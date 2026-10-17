import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'sales_history_page.dart';

/// ✅ [تعديل #2] يسمح بأرقام + نقطة عشرية واحدة فقط
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return newValue;
    }
    return oldValue;
  }
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  StreamSubscription<String>? _tagSubscription;
  List<String> epcs = [];
  Map<String, dynamic> itemsData = {};
  bool isReading = false;
  bool busy = false;
  String? msg;

  // 🔹 أسماء المستخدمين
  List<String> userNames = [];
  String? selectedUser;

  // 🔹 متغيرات الدفع
  Map<String, String?> paymentTypes = {};
  Map<String, TextEditingController> cashControllers = {};
  Map<String, TextEditingController> visaControllers = {};
  Map<String, double> totals = {};

  // 🔹 أسعار الذهب اللحظية
  Map<int, double> _goldPrices = {18: 0, 21: 0, 22: 0, 24: 0};
  bool _loadingPrices = false;

  // 🔹 سعر كل قطعة (محسوب)
  Map<String, double> piecePrices = {};

  // وضع البيع: 'كامل' او 'جزئي' لكل epc
  Map<String, String> saleMode = {};

  double totalCash = 0;
  double totalVisa = 0;
  double grandTotal = 0;

  // 🔹 إجمالي الوزن لكل القطع
  double totalWeight = 0;

  // Global (batch) payment controllers
  TextEditingController globalCashController = TextEditingController();
  TextEditingController globalVisaController = TextEditingController();
  String? globalPaymentType;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  int _readerPower = 26;
  int _tempPower = 26;

  // ═══════════════════════════════════════════════════════════
  // ✅ [إصلاح #3] هل أسعار الذهب محمّلة؟
  // ═══════════════════════════════════════════════════════════
  bool get _pricesReady => _goldPrices.values.any((p) => p > 0);

  // ═══════════════════════════════════════════════════════════
  // 🔵 دورة حياة الصفحة
  // ═══════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _loadLanguage();
    _loadUserNames();
    _fetchGoldPrices();

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      final epc = tag;
      final result = await FS.epcandcode(epc);

      if (!epcs.contains(epc) &&
          !epcs.contains(result?['epcHex']) &&
          !epcs.contains(result?['qrCode'])) {
        setState(() {
          epcs.add(epc);
          paymentTypes[epc] = null;
          cashControllers[epc] = TextEditingController();
          visaControllers[epc] = TextEditingController();
          totals[epc] = 0;
          piecePrices[epc] = 0;
          saleMode[epc] = 'كامل';
        });
        _loadItemData(epc);
      }
    });
    SeuicUhfService.open();
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    for (final c in cashControllers.values) {
      c.dispose();
    }
    for (final c in visaControllers.values) {
      c.dispose();
    }
    globalCashController.dispose();
    globalVisaController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 جلب أسعار الذهب من API
  // ═══════════════════════════════════════════════════════════

  Future<void> _fetchGoldPrices() async {
    setState(() => _loadingPrices = true);
    try {
      final res = await http.get(
        Uri.parse('https://goldprices-usqjvutvvq-uc.a.run.app'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _goldPrices = {
            18: (data['g18'] as num).toDouble(),
            21: (data['g21'] as num).toDouble(),
            22: (data['g22'] as num).toDouble(),
            24: (data['g24'] as num).toDouble(),
          };
          _recalculateAll();
        });
      } else {
        print('⚠️ فشل جلب الأسعار - كود: ${res.statusCode}');
      }
    } catch (e) {
      print('❌ خطأ في جلب أسعار الذهب: $e');
    } finally {
      if (mounted) setState(() => _loadingPrices = false);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ✅ [إصلاح #4] parseCarat ترجع null لو العيار غير مدعوم
  // ═══════════════════════════════════════════════════════════

  int? _parseCarat(dynamic carat) {
    if (carat == null) return null;
    final s = carat.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (s.isEmpty) return null;
    final v = int.tryParse(s);
    if (v == null) return null;
    return (v == 18 || v == 21 || v == 22 || v == 24) ? v : null;
  }

  double _getGoldPriceForCarat(int? carat) {
    if (carat == null) return 0;
    return _goldPrices[carat] ?? 0;
  }

  /// سعر القطعة = (الوزن × سعر الجرام) + المصنعية
  double _calculatePiecePrice(String epc) {
    final item = itemsData[epc];
    if (item == null || item is! Map || item['error'] != null) return 0;

    final payload = item['payload'] ?? {};
    final category = (item['category'] ?? '').toString();

    double weight = 0;
    double wage = 0;

    if (saleMode[epc] == 'جزئي' && item['_pendingPartial'] != null) {
      weight = double.tryParse(
              item['_pendingPartial']['weightSold']?.toString() ?? '0') ??
          0;
      wage = double.tryParse(
              item['_pendingPartial']['wageSold']?.toString() ?? '0') ??
          0;
    } else {
      weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
      wage = double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;
    }

    if (category == 'gold' || category == 'scrap' || category == 'bullion') {
      final carat = _parseCarat(payload['carat']);
      if (carat == null) return 0;
      final goldPricePerGram = _getGoldPriceForCarat(carat);
      final goldValue = weight * goldPricePerGram;
      return goldValue + wage;
    }

    if (category == 'gem') {
      return double.tryParse((payload['cost'] ?? 0).toString()) ?? 0;
    }

    return 0;
  }

  /// تفاصيل الحساب (للعرض فقط)
  Map<String, dynamic> _piecePriceBreakdown(String epc) {
    final item = itemsData[epc];
    if (item == null || item is! Map || item['error'] != null) {
      return {
        'gold': 0.0,
        'wage': 0.0,
        'total': 0.0,
        'goldPricePerGram': 0.0,
        'caratError': false,
      };
    }
    final payload = item['payload'] ?? {};
    final category = (item['category'] ?? '').toString();

    double weight = 0;
    double wage = 0;

    if (saleMode[epc] == 'جزئي' && item['_pendingPartial'] != null) {
      weight = double.tryParse(
              item['_pendingPartial']['weightSold']?.toString() ?? '0') ??
          0;
      wage = double.tryParse(
              item['_pendingPartial']['wageSold']?.toString() ?? '0') ??
          0;
    } else {
      weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
      wage = double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;
    }

    if (category == 'gold' || category == 'scrap' || category == 'bullion') {
      final carat = _parseCarat(payload['carat']);
      if (carat == null) {
        return {
          'gold': 0.0,
          'wage': wage,
          'total': wage,
          'goldPricePerGram': 0.0,
          'caratError': true,
        };
      }
      final goldPricePerGram = _getGoldPriceForCarat(carat);
      final goldValue = weight * goldPricePerGram;
      return {
        'gold': goldValue,
        'wage': wage,
        'total': goldValue + wage,
        'goldPricePerGram': goldPricePerGram,
        'caratError': false,
      };
    }

    if (category == 'gem') {
      final c = double.tryParse((payload['cost'] ?? 0).toString()) ?? 0;
      return {
        'gold': 0.0,
        'wage': 0.0,
        'total': c,
        'goldPricePerGram': 0.0,
        'caratError': false,
      };
    }

    return {
      'gold': 0.0,
      'wage': 0.0,
      'total': 0.0,
      'goldPricePerGram': 0.0,
      'caratError': false,
    };
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 إعادة الحساب الكلي
  // ═══════════════════════════════════════════════════════════

  void _recalculateAll() {
    double sum = 0;
    double priceSum = 0;

    for (final epc in epcs) {
      final item = itemsData[epc];
      if (item == null || item is! Map || item['error'] != null) continue;

      final payload = item['payload'] ?? {};
      double w = 0;

      if (saleMode[epc] == 'جزئي' && item['_pendingPartial'] != null) {
        w = double.tryParse(
                item['_pendingPartial']['weightSold']?.toString() ?? '0') ??
            0;
      } else {
        w = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
      }

      sum += w;

      final price = _calculatePiecePrice(epc);
      piecePrices[epc] = price;
      priceSum += price;
    }

    totalWeight = sum;
    grandTotal = priceSum;
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 تحميل البيانات والإعدادات
  // ═══════════════════════════════════════════════════════════

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadUserNames() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userNames = prefs.getStringList('userNames') ?? [];
      if (userNames.isNotEmpty) selectedUser = userNames.first;
    });
  }

  Future<void> _loadSavedReaderPower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');

    if (powerJson != null) {
      final Map<String, dynamic> pagePowers =
          Map<String, dynamic>.from(json.decode(powerJson));

      final savedPower = pagePowers['sales'];
      if (savedPower != null) {
        setState(() {
          _readerPower = savedPower;
          _tempPower = savedPower;
        });
        await SeuicUhfService.setPower(savedPower);
      }
    }
  }

  Future<void> _setPagePower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');
    if (powerJson != null) {
      final decoded = json.decode(powerJson);
      final pagePowers = Map<String, int>.from(decoded);
      final pagePower = pagePowers['sales'] ?? 26;
      await SeuicUhfService.setPower(pagePower);
    }
  }

  void _showPowerSheet() {
    _tempPower = _readerPower;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _t('قوة قارئ RFID', 'RFID Reader Power'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_tempPower dBm',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    min: 1,
                    max: 33,
                    divisions: 25,
                    value: _tempPower.toDouble(),
                    label: _tempPower.toString(),
                    onChanged: (v) {
                      setModalState(() => _tempPower = v.round());
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(_t('إلغاء', 'Cancel')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                          ),
                          onPressed: () async {
                            setState(() => _readerPower = _tempPower);
                            await SeuicUhfService.setPower(_readerPower);

                            final prefs = await SharedPreferences.getInstance();
                            final powerJson = prefs.getString('pagePowers');
                            Map<String, int> pagePowers = {};

                            if (powerJson != null) {
                              pagePowers =
                                  Map<String, int>.from(json.decode(powerJson));
                            }

                            pagePowers['sales'] = _readerPower;
                            await prefs.setString(
                                'pagePowers', json.encode(pagePowers));

                            Navigator.pop(context);
                            showAppMessage(
                                context,
                                _t('تم ضبط قوة القارئ بنجاح',
                                    'Reader power updated'));
                          },
                          child: Text(_t('حفظ', 'Save')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showAppMessage(BuildContext context, String msg) {
    final isSuccess = msg.contains('تمت') ||
        msg.contains('تم') ||
        msg.contains('written') ||
        msg.contains('Saved');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Text(msg),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ✅ [إصلاح #9] تحميل بيانات القطعة - حذف لو مش موجودة
  // ═══════════════════════════════════════════════════════════

  Future<void> _loadItemData(String epc) async {
    try {
      final data = await FS.findItemByEpc(epc);

      if (!mounted) return;

      if (data == null) {
        _removeEpc(epc);
        showAppMessage(
          context,
          _t('الشريحة $epc غير موجودة في المخزن',
              'Tag $epc not found in inventory'),
        );
        return;
      }

      setState(() {
        itemsData[epc] = data;
        final payload = data['payload'] ?? {};
        final kind = (payload['kind'] ?? '').toString();
        if (kind.contains('طقم')) {
          saleMode[epc] = saleMode[epc] ?? 'كامل';
        } else {
          saleMode[epc] = 'كامل';
        }
        _recalculateAll();
      });
    } catch (e) {
      if (!mounted) return;
      _removeEpc(epc);
      showAppMessage(context, _t('خطأ في تحميل $epc', 'Error loading $epc'));
    }
  }

  /// ✅ [إصلاح #9] helper لحذف EPC + كل بياناته من الـ UI
  void _removeEpc(String epc) {
    if (!mounted) return;
    setState(() {
      epcs.remove(epc);
      itemsData.remove(epc);
      paymentTypes.remove(epc);
      cashControllers.remove(epc)?.dispose();
      visaControllers.remove(epc)?.dispose();
      totals.remove(epc);
      piecePrices.remove(epc);
      saleMode.remove(epc);
      _recalculateAll();
    });
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 حساب الإجماليات (كاش / شبكة / إجمالي)
  // ═══════════════════════════════════════════════════════════

  void _calculateTotal(String epc) {
    double cash = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
    double visa = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;
    setState(() {
      totals[epc] = cash + visa;
      totalCash = cashControllers.values
          .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
      totalVisa = visaControllers.values
          .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
      _recalculateAll();
    });
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 توزيع الدفع المجمّع (بناءً على سعر القطعة المحسوب)
  // ═══════════════════════════════════════════════════════════

  void _applyGlobalDistribution() {
    if (epcs.isEmpty) return;
    if (globalPaymentType == null) {
      showAppMessage(context,
          _t('اختر طريقة دفع مجمّعة', 'Please select batch payment type'));
      return;
    }

    final totalCashGlobal = double.tryParse(globalCashController.text) ?? 0;
    final totalVisaGlobal = double.tryParse(globalVisaController.text) ?? 0;

    if (totalCashGlobal <= 0 && totalVisaGlobal <= 0) {
      showAppMessage(context,
          _t('أدخل مبلغ كاش أو شبكة صحيح', 'Enter a valid cash or card total'));
      return;
    }

    final Map<String, double> factors = {};
    double sumFactors = 0;

    for (final epc in epcs) {
      final double price = piecePrices[epc] ?? 0.0;
      final double factor = price > 0 ? price : 1.0;
      factors[epc] = factor;
      sumFactors += factor;
    }

    if (sumFactors <= 0) sumFactors = epcs.length.toDouble();

    for (final epc in epcs) {
      final double factor = factors[epc] ?? 1.0;
      final double cashShare = totalCashGlobal * factor / sumFactors;
      final double visaShare = totalVisaGlobal * factor / sumFactors;

      setState(() {
        paymentTypes[epc] = globalPaymentType;
        cashControllers[epc]?.text = cashShare.toStringAsFixed(2);
        visaControllers[epc]?.text = visaShare.toStringAsFixed(2);
        _calculateTotal(epc);
      });
    }

    showAppMessage(
        context,
        _t('تم تطبيق الدفع المجمّع على كل القطع',
            'Batch payment applied to all items'));
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 حوار البيع الجزئي
  // ═══════════════════════════════════════════════════════════

  Future<Map<String, dynamic>?> _openPartialSaleDialog(
      String epc, Map<String, dynamic> itemData) async {
    final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
    final List<dynamic> setComponentsDynamic = payload['setComponents'] ?? [];
    final List<String> components =
        setComponentsDynamic.map((c) => c.toString()).toList();
    double computedWage = 0;

    final Map<String, bool> selected = {for (var c in components) c: false};
    final weightController = TextEditingController();
    final wageController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(_t("تفاصيل البيع الجزئي", "Partial Sale Details")),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (components.isEmpty)
                    Text(_t("لا توجد مكونات في الطقم لعمل بيع جزئي.",
                        "No components in the set for partial sale."))
                  else
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _t("اختر المكونات التي سيتم بيعها:",
                                "Select components to sell:"),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: components.length,
                            itemBuilder: (_, i) {
                              final comp = components[i];
                              return CheckboxListTile(
                                value: selected[comp],
                                title: Text(comp),
                                onChanged: (v) => setStateDialog(
                                    () => selected[comp] = v ?? false),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: weightController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [DecimalTextInputFormatter()],
                    decoration: InputDecoration(
                      labelText: _t(
                          "الوزن المباع (جرام) - متاح: ${payload['weight'] ?? 'غير معروف'}",
                          "Sold weight (g) - available: ${payload['weight'] ?? 'unknown'}"),
                    ),
                    onChanged: (value) {
                      final weightSold = double.tryParse(value) ?? 0;
                      final totalWeight = double.tryParse(
                              (payload['weight'] ?? 0).toString()) ??
                          0;
                      final totalWage =
                          double.tryParse((payload['wage'] ?? 0).toString()) ??
                              0;

                      if (weightSold > 0 && totalWeight > 0) {
                        computedWage = totalWage * (weightSold / totalWeight);
                        wageController.text = computedWage.toStringAsFixed(2);
                      } else {
                        wageController.text = "0";
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: wageController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [DecimalTextInputFormatter()],
                    decoration: InputDecoration(
                      labelText: _t(
                        "الأجر المباع (قابل للتعديل) - متاح: ${payload['wage'] ?? '0'}",
                        "Sold wage (editable) - available: ${payload['wage'] ?? '0'}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  weightController.dispose();
                  wageController.dispose();
                  Navigator.of(ctx).pop(null);
                },
                child: Text(_t("إلغاء", "Cancel")),
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(ctx).unfocus();
                  await Future.delayed(const Duration(milliseconds: 100));

                  final soldComps = selected.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .toList();

                  final weightSold =
                      double.tryParse(weightController.text) ?? 0;
                  final wageSold = double.tryParse(wageController.text) ?? 0;
                  final availableWeight =
                      double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
                  final availableWage =
                      double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;

                  if (weightSold <= 0) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text(_t("ادخل وزن صالح أكبر من صفر",
                            "Enter a valid weight greater than zero"))));
                    return;
                  }
                  if (weightSold > availableWeight) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text(_t("الوزن المباع أكبر من الوزن المتاح",
                            "Sold weight exceeds available weight"))));
                    return;
                  }
                  if (wageSold < 0) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text(_t("الأجر غير صحيح", "Invalid wage"))));
                    return;
                  }
                  if (wageSold > availableWage) {
                    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                        content: Text(_t("الأجر المباع أكبر من الأجر المتاح",
                            "Sold wage exceeds available wage"))));
                    return;
                  }

                  final result = {
                    'soldComponents': soldComps,
                    'weightSold': weightSold,
                    'wageSold': wageSold,
                  };

                  if (ctx.mounted) Navigator.of(ctx).pop(result);
                },
                child: Text(_t("تأكيد البيع الجزئي", "Confirm partial sale")),
              ),
            ],
          );
        });
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ✅ [إصلاح #2, #3, #6, #7] تنفيذ البيع
  // ═══════════════════════════════════════════════════════════

  Future<void> _sell() async {
    if (epcs.isEmpty) {
      setState(() => msg = _t("من فضلك اقرأ شريحة واحدة على الأقل",
          "Please read at least one chip"));
      return;
    }

    if (!_pricesReady) {
      setState(() => msg = _t(
          "⚠ أسعار الذهب غير محمّلة، اضغط زر التحديث في الأعلى ثم حاول مرة أخرى",
          "⚠ Gold prices not loaded, tap refresh at the top then try again"));
      showAppMessage(context, msg!);
      return;
    }

    if (selectedUser == null || selectedUser!.isEmpty) {
      setState(() => msg = _t(
          "يرجى اضافة اسم المستخدم من الاعدادات وحفظ الاعدادات حتى تتمكن من البيع",
          "Please add a username from settings and save settings before proceeding"));
      return;
    }

    // ═══ التحقق من كل قطعة ═══
    for (final epc in List<String>.from(epcs)) {
      if (paymentTypes[epc] == null) {
        setState(() {
          msg = _t("⚠ اختر طريقة الدفع للشريحة $epc أولاً",
              "⚠ Please select the payment method for tag $epc first");
        });
        return;
      }
      final paymentType = paymentTypes[epc];
      final cashVal = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
      final visaVal = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;

      if (paymentType == "cash" && cashVal <= 0) {
        setState(() {
          msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
              "⚠ Enter the correct cash amount for tag $epc.");
        });
        return;
      }

      if (paymentType == "visa" && visaVal <= 0) {
        setState(() {
          msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
              "⚠ Enter the correct card amount for tag $epc.");
        });
        return;
      }

      if (paymentType == "multi") {
        if (cashVal <= 0) {
          setState(() {
            msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
                "⚠ Enter the correct cash amount for tag $epc.");
          });
          return;
        }
        if (visaVal <= 0) {
          setState(() {
            msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
                "⚠ Enter the correct card amount for tag $epc.");
          });
          return;
        }
      }

      if (saleMode[epc] == 'جزئي') {
        final item = itemsData[epc];
        if (item == null) {
          setState(() {
            msg = _t("خطأ: بيانات الشريحة $epc غير متاحة.",
                "Error: Data for tag $epc is not available.");
          });
          return;
        }

        final partialResult = item['_pendingPartial'];
        if (partialResult == null) {
          setState(() {
            msg = _t(
                "⚠ من فضلك اضغط 'فتح البيع الجزئي' وأدخل التفاصيل قبل تسجيل البيع.",
                "⚠ Please press 'Open Partial Sale' and enter the details before recording the sale.");
          });
          return;
        }

        final weightSold = (partialResult['weightSold'] ?? 0).toDouble();
        if (weightSold <= 0) {
          setState(() {
            msg = _t("⚠ أدخل وزن صحيح في البيع الجزئي للشريحة $epc.",
                "⚠ Enter a valid weight in the partial sale for tag $epc.");
          });
          return;
        }
      }
    }

    // ═══ ✅ [إصلاح #2] مقارنة المدفوع بالمطلوب ═══
    final double expected =
        epcs.fold<double>(0, (sum, e) => sum + (piecePrices[e] ?? 0));
    final double paid = totalCash + totalVisa;

    if ((paid - expected).abs() > 0.5) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(_t('المدفوع لا يساوي المطلوب',
              'Paid amount does not match expected')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_t('المطلوب: ${expected.toStringAsFixed(2)} ريال',
                  'Expected: ${expected.toStringAsFixed(2)} SAR')),
              const SizedBox(height: 6),
              Text(_t('المدفوع: ${paid.toStringAsFixed(2)} ريال',
                  'Paid: ${paid.toStringAsFixed(2)} SAR')),
              const SizedBox(height: 6),
              Text(
                _t(
                  'الفرق: ${(paid - expected).toStringAsFixed(2)} ريال',
                  'Difference: ${(paid - expected).toStringAsFixed(2)} SAR',
                ),
                style: TextStyle(
                  color: (paid - expected) < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(_t('رجوع', 'Back')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
              ),
              child: Text(_t('كمّل البيع', 'Continue')),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    setState(() {
      busy = true;
      msg = null;
    });

    final saleGroupId = DateTime.now().millisecondsSinceEpoch.toString();
    final hasSetItem = epcs.any((epc) {
      final item = itemsData[epc];
      final payload =
          item != null ? Map<String, dynamic>.from(item['payload'] ?? {}) : {};
      return (payload['kind'] ?? '').toString().contains('طقم');
    });
    if (hasSetItem) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t(
            'تنبيه: يوجد طقم في البيع، تأكد من اختيار حالة البيع جزئي أو كامل لكل قطعة قبل التأكيد.',
            'Note: a set item is included in the sale. Make sure to choose partial or full sale for each item before confirming.',
          )),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // ✅ [إصلاح #7] تتبع القطع المبيعة بنجاح
    final List<String> processed = [];
    String? failedEpc;
    Object? failure;

    try {
      for (final epc in List<String>.from(epcs)) {
        try {
          final paymentData = {
            "type": paymentTypes[epc],
            "cash": double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0,
            "visa": double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0,
            "total": totals[epc] ?? 0,
            "piecePrice": piecePrices[epc] ?? 0,
            "soldBy": selectedUser,
          };

          final String epcHex = (itemsData[epc]?['epcHex'] ?? epc).toString();

          if (saleMode[epc] == 'جزئي') {
            final item = itemsData[epc];
            final partialResult = item['_pendingPartial'];

            final soldCompsRaw = partialResult['soldComponents'];
            final soldComps = soldCompsRaw is List
                ? soldCompsRaw.map((e) => e.toString()).toList()
                : <String>[];

            await FS.sellItem(
              epc,
              saleGroupId: saleGroupId,
              partialSale: true,
              soldComponents: soldComps,
              weightSold: (partialResult['weightSold'] ?? 0).toDouble(),
              wageSold: (partialResult['wageSold'] ?? 0).toDouble(),
              paymentData: paymentData,
            );

            setState(() {
              itemsData[epc].remove('_pendingPartial');
            });

            await _deleteItemImages(epcHex);

            await _loadItemData(epc);

            final updated = itemsData[epc];
            final updatedPayload =
                updated != null ? (updated['payload'] ?? {}) : {};
            final updatedWeight = (updatedPayload['weight'] ?? 0).toString();
            final hasComponents =
                (updatedPayload['setComponents'] ?? []).isNotEmpty;
            final weightZero = double.tryParse(updatedWeight.toString()) == 0;

            if (!hasComponents || weightZero) {
              if (mounted) {
                setState(() {
                  epcs.remove(epc);
                  itemsData.remove(epc);
                  paymentTypes.remove(epc);
                  cashControllers.remove(epc)?.dispose();
                  visaControllers.remove(epc)?.dispose();
                  totals.remove(epc);
                  piecePrices.remove(epc);
                  saleMode.remove(epc);
                  _recalculateAll();
                });
              }
            }
          } else {
            await FS.sellItem(epc,
                saleGroupId: saleGroupId, paymentData: paymentData);

            await _deleteItemImages(epcHex);

            if (mounted) {
              setState(() {
                epcs.remove(epc);
                itemsData.remove(epc);
                paymentTypes.remove(epc);
                cashControllers.remove(epc)?.dispose();
                visaControllers.remove(epc)?.dispose();
                totals.remove(epc);
                piecePrices.remove(epc);
                saleMode.remove(epc);
                _recalculateAll();
              });
            }
          }

          processed.add(epc);
        } catch (e) {
          failedEpc = epc;
          failure = e;
          break;
        }
      }

      if (failure == null) {
        setState(() {
          msg = _t("✅ تم تنفيذ جميع عمليات البيع بنجاح بواسطة $selectedUser.",
              "✅ All sales were successfully completed by $selectedUser.");
          _recalculateAll();
        });

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            epcs.clear();
            itemsData.clear();
            paymentTypes.clear();
            for (final c in cashControllers.values) {
              c.dispose();
            }
            for (final c in visaControllers.values) {
              c.dispose();
            }
            cashControllers.clear();
            visaControllers.clear();
            totals.clear();
            piecePrices.clear();
            saleMode.clear();
            totalCash = 0;
            totalVisa = 0;
            grandTotal = 0;
            totalWeight = 0;
          });
        }
      } else {
        final String soldList = processed.isEmpty ? '—' : processed.join(', ');
        final String remainList = epcs
            .where((e) => !processed.contains(e))
            .map((e) => e.length > 12 ? '${e.substring(0, 12)}…' : e)
            .join(', ');

        setState(() {
          msg = _t(
            '⚠ فشل جزئي:\n'
                'تم بيع (${processed.length}): $soldList\n'
                'فشل عند: ${failedEpc ?? "؟"}\n'
                'القطع المتبقية: $remainList\n'
                'الخطأ: $failure\n'
                'راجع سجل البيع.',
            '⚠ Partial failure:\n'
                'Sold (${processed.length}): $soldList\n'
                'Failed at: ${failedEpc ?? "?"}\n'
                'Remaining: $remainList\n'
                'Error: $failure\n'
                'Check sales history.',
          );
        });

        showAppMessage(
          context,
          _t('فشل جزئي: تم بيع ${processed.length} قطعة فقط',
              'Partial failure: ${processed.length} item(s) sold'),
        );
      }
    } catch (e) {
      setState(() {
        msg = _t(
          'فشل تسجيل البيع: $e\nتم بيع: ${processed.length} قطعة.',
          'Failed to record sale: $e\nSold: ${processed.length} item(s).',
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => busy = false);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ✅ [إصلاح #6] حذف الصور - ياخد epcHex مباشرة
  // ═══════════════════════════════════════════════════════════

  Future<void> _deleteItemImages(String epcHex) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final folderName = epcHex.toUpperCase();

      final sourceFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(folderName);

      final salesFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child('sales')
          .child(folderName);

      final ListResult result = await sourceFolder.listAll();

      if (result.items.isEmpty) {
        print('ℹ️ لا توجد صور للشريحة $folderName');
        return;
      }

      print('📦 نسخ ${result.items.length} صورة إلى مجلد المبيعات');

      for (Reference sourceRef in result.items) {
        try {
          final Uint8List? bytes = await sourceRef.getData();
          if (bytes == null) {
            print('❌ لم يتم تحميل ${sourceRef.name}');
            continue;
          }

          final destRef = salesFolder.child(sourceRef.name);
          await destRef.putData(bytes);
          await sourceRef.delete();
        } catch (e) {
          print('❌ خطأ مع ${sourceRef.name}: $e');
        }
      }
    } catch (e) {
      print('🔥 خطأ أثناء حذف صور الشريحة $epcHex: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 عرض الصورة كاملة
  // ═══════════════════════════════════════════════════════════

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 إضافة EPC يدوياً
  // ═══════════════════════════════════════════════════════════

  void _addEpc(String epc) async {
    if (epc.isEmpty) return;
    final result = await FS.epcandcode(epc);

    if (epcs.contains(epc) ||
        epcs.contains(epc.trim().toUpperCase()) ||
        epcs.contains(result?['epcHex']) ||
        epcs.contains(result?['qrCode'])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_t("تمت اضافة الشريحة من قبل", "Tag already added"))),
      );
      return;
    }

    setState(() {
      epcs.add(epc);
      paymentTypes[epc] = null;
      cashControllers[epc] = TextEditingController();
      visaControllers[epc] = TextEditingController();
      totals[epc] = 0;
      piecePrices[epc] = 0;
      saleMode[epc] = 'كامل';
    });

    _loadItemData(epc);
  }

  void _showManualEpcDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t("إضافة شريحة يدويًا", "Add Tag Manually")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _t("رقم الشريحة (EPC)", "Tag EPC"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AddEpcManualy(controller.text);
            },
            child: Text(_t("إضافة", "Add")),
          ),
        ],
      ),
    );
  }

  void AddEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 كارت القطعة
  // ═══════════════════════════════════════════════════════════

  Widget _buildItemCard(String epc, Map<String, dynamic>? itemData) {
    if (itemData == null) return const SizedBox();
    final payload = itemData['payload'] ?? {};
    final epcHex = itemData['epcHex'].toString();
    final breakdown = _piecePriceBreakdown(epc);
    final piecePrice = piecePrices[epc] ?? 0;
    final bool caratError = breakdown['caratError'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: caratError
              ? Colors.red.withOpacity(0.6)
              : const Color(0xFFD4AF37).withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══ بيانات القطعة + الصور ═══
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.qr_code,
                              color: Colors.blue, size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _t("المقروء: $epc", "Read: $epc"),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (itemData['category'] == 'gold') ...[
                        _dataRow(Icons.workspace_premium, _t("ذهب", "Gold"),
                            const Color(0xFFD4AF37)),
                        _dataRow(
                            Icons.grade,
                            _t("عيار: ${payload['carat'] ?? '-'}",
                                "Carat: ${payload['carat'] ?? '-'}"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.category,
                            _t("نوع: ${payload['kind'] ?? '-'}",
                                "Kind: ${payload['kind'] ?? '-'}"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.scale,
                            _t("وزن: ${payload['weight'] ?? '-'} جم",
                                "Weight: ${payload['weight'] ?? '-'} g"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.attach_money,
                            _t("مصنعية: ${payload['wage'] ?? '0'}",
                                "Wage: ${payload['wage'] ?? '0'}"),
                            Colors.grey[700]!),
                      ],
                      if (itemData['category'] == 'gem') ...[
                        _dataRow(Icons.diamond, _t("أحجار كريمة", "Gemstones"),
                            Colors.purple),
                        _dataRow(
                            Icons.category,
                            _t("نوع: ${payload['type'] ?? '-'}",
                                "Type: ${payload['type'] ?? '-'}"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.attach_money,
                            _t("تكلفة: ${payload['cost'] ?? '-'}",
                                "Cost: ${payload['cost'] ?? '-'}"),
                            Colors.grey[700]!),
                      ],
                      if (itemData['category'] == 'scrap') ...[
                        _dataRow(
                            Icons.recycling, _t("كسر", "Scrap"), Colors.green),
                        _dataRow(
                            Icons.grade,
                            _t("عيار: ${payload['carat'] ?? '-'}",
                                "Carat: ${payload['carat'] ?? '-'}"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.scale,
                            _t("وزن: ${payload['weight'] ?? '-'} جم",
                                "Weight: ${payload['weight'] ?? '-'} g"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.attach_money,
                            _t("مصنعية: ${payload['wage'] ?? '0'}",
                                "Wage: ${payload['wage'] ?? '0'}"),
                            Colors.grey[700]!),
                      ],
                      if (itemData['category'] == 'bullion') ...[
                        _dataRow(Icons.workspace_premium,
                            _t("سبائك", "Bullion"), const Color(0xFFD4AF37)),
                        _dataRow(
                            Icons.scale,
                            _t("وزن: ${payload['weight'] ?? '-'} جم",
                                "Weight: ${payload['weight'] ?? '-'} g"),
                            Colors.grey[700]!),
                        _dataRow(
                            Icons.attach_money,
                            _t("مصنعية: ${payload['wage'] ?? '0'}",
                                "Wage: ${payload['wage'] ?? '0'}"),
                            Colors.grey[700]!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 130,
                    child: FutureBuilder<List<String>>(
                      future: () async {
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        final storageRef = FirebaseStorage.instance
                            .ref()
                            .child('images')
                            .child('users')
                            .child(uid)
                            .child(epcHex);

                        final result = await storageRef.listAll();
                        return Future.wait(
                            result.items.map((e) => e.getDownloadURL()));
                      }(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              _t('لا يوجد صور', 'No Images'),
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.all(3),
                            child: GestureDetector(
                              onTap: () =>
                                  _showFullImage(context, snapshot.data![i]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  snapshot.data![i],
                                  width: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // ═══ QR / Barcode ═══
            if (payload['qrCode'] != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: (payload['showQr'] == true)
                      ? QrImageView(
                          data: payload['qrCode'],
                          version: QrVersions.auto,
                          size: 90.0,
                          backgroundColor: Colors.white,
                        )
                      : BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: payload['qrCode'],
                          width: 100,
                          height: 40,
                        ),
                ),
              ),

            // ═══ نوع البيع (للأطقم) ═══
            if ((payload['kind'] ?? '').toString().contains('طقم')) ...[
              const Divider(),
              Row(
                children: [
                  Text(_t("نوع البيع:", "Sale type:"),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: saleMode[epc] ?? 'كامل',
                    items: [
                      DropdownMenuItem(
                          value: 'كامل',
                          child: Text(_t('بيع كامل', 'Full sale'))),
                      DropdownMenuItem(
                          value: 'جزئي',
                          child: Text(_t('بيع جزئي', 'Partial sale'))),
                    ],
                    onChanged: (v) {
                      setState(() {
                        saleMode[epc] = v ?? 'كامل';
                        _recalculateAll();
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  if (saleMode[epc] == 'جزئي')
                    ElevatedButton(
                      onPressed: () async {
                        final partialResult =
                            await _openPartialSaleDialog(epc, itemData);
                        if (partialResult != null) {
                          setState(() {
                            itemsData[epc] = {
                              ...itemData,
                              '_pendingPartial': partialResult,
                            };
                            _recalculateAll();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_t('تم تحضير بيانات البيع الجزئي.',
                                  'Partial sale data prepared.')),
                            ),
                          );
                        }
                      },
                      child: Text(_t('فتح البيع الجزئي', 'Open partial sale')),
                    ),
                ],
              ),
            ],

            const Divider(height: 20),

            // ═══ 💰 سعر القطعة ═══
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: caratError
                      ? [Colors.red.shade50, Colors.white]
                      : [
                          const Color(0xFFD4AF37).withOpacity(0.12),
                          const Color(0xFFFFF4D6).withOpacity(0.6),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: caratError
                      ? Colors.red.withOpacity(0.6)
                      : const Color(0xFFD4AF37).withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        caratError ? Icons.warning_amber : Icons.calculate,
                        color:
                            caratError ? Colors.red : const Color(0xFFD4AF37),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          caratError
                              ? _t(
                                  "⚠ العيار غير مدعوم - لا يمكن حساب قيمة الذهب",
                                  "⚠ Unsupported carat - cannot compute gold value")
                              : _t("تفاصيل الحساب", "Price breakdown"),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: caratError
                                ? Colors.red
                                : const Color(0xFFB8860B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if ((breakdown['goldPricePerGram'] as double) > 0) ...[
                    _calcRow(
                      _t("سعر الجرام", "Price per gram"),
                      "${(breakdown['goldPricePerGram'] as double).toStringAsFixed(2)} ريال",
                    ),
                  ],
                  _calcRow(
                    _t("قيمة الذهب", "Gold value"),
                    "${(breakdown['gold'] as double).toStringAsFixed(2)} ريال",
                  ),
                  _calcRow(
                    _t("المصنعية", "Wage"),
                    "${(breakdown['wage'] as double).toStringAsFixed(2)} ريال",
                  ),
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _t("سعر القطعة", "Piece price"),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color:
                              caratError ? Colors.red : const Color(0xFFB8860B),
                        ),
                      ),
                      Text(
                        "${piecePrice.toStringAsFixed(2)} ريال",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:
                              caratError ? Colors.red : const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ═══ طريقة الدفع ═══
            Text(_t("اختر طريقة الدفع:", "Choose payment method:"),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: paymentTypes[epc],
              hint: Text(_t("اختر نوع الدفع", "Select payment type")),
              isExpanded: true,
              items: [
                DropdownMenuItem(value: "cash", child: Text(_t("كاش", "Cash"))),
                DropdownMenuItem(
                    value: "visa", child: Text(_t("شبكة", "Card"))),
                DropdownMenuItem(
                    value: "multi", child: Text(_t("متعدد", "Multiple"))),
              ],
              // ✅ [إصلاح #5] امسح الخانة التانية عند تغيير الطريقة
              onChanged: (val) {
                setState(() {
                  paymentTypes[epc] = val;
                  if (val == 'cash') {
                    visaControllers[epc]?.clear();
                  }
                  if (val == 'visa') {
                    cashControllers[epc]?.clear();
                  }
                });
                _calculateTotal(epc);
              },
            ),
            if (paymentTypes[epc] == "cash" || paymentTypes[epc] == "multi")
              TextField(
                controller: cashControllers[epc],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter()],
                decoration:
                    InputDecoration(labelText: _t("مبلغ الكاش", "Cash amount")),
                onChanged: (_) => _calculateTotal(epc),
              ),
            if (paymentTypes[epc] == "visa" || paymentTypes[epc] == "multi")
              TextField(
                controller: visaControllers[epc],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [DecimalTextInputFormatter()],
                decoration: InputDecoration(
                    labelText: _t("مبلغ الشبكة", "Card amount")),
                onChanged: (_) => _calculateTotal(epc),
              ),

            // ═══ إجمالي المدفوع للقطعة ═══
            if (paymentTypes[epc] != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _t("المدفوع لهذه القطعة", "Paid for this item"),
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      "${(totals[epc] ?? 0).toStringAsFixed(2)} ريال",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _calcRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value,
              style: const TextStyle(fontSize: 11, color: Colors.black87)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 🔵 البناء الرئيسي
  // ═══════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("صفحة البيع", "Sales Page")),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: _t("تحديث الأسعار", "Refresh prices"),
            onPressed: _loadingPrices ? null : _fetchGoldPrices,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: _t("سجل البيع", "Sales History"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesHistoryPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        onPressed: _showManualEpcDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // ═══════════════════════════════════════════
            // 🏆 الشريط العلوي: الوزن + القطع + الإجمالي
            // ═══════════════════════════════════════════
            if (epcs.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _topInfo(
                            Icons.scale,
                            _t("إجمالي الوزن", "Total Weight"),
                            "${totalWeight.toStringAsFixed(2)} ${_t("جم", "g")}",
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        Expanded(
                          child: _topInfo(
                            Icons.inventory_2,
                            _t("عدد القطع", "Items"),
                            "${epcs.length}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 6),
                        Text(
                          _t("الإجمالي:", "Total:"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "${grandTotal.toStringAsFixed(2)} ريال",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB8860B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_loadingPrices)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "🔄 جاري تحديث أسعار الذهب...",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ),
                    if (!_pricesReady && !_loadingPrices)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "⚠ أسعار الذهب غير محمّلة - اضغط تحديث",
                          style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),

            // ═══════════════════════════════════════════
            // 👤 اختيار المستخدم
            // ═══════════════════════════════════════════
            if (userNames.isNotEmpty) ...[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFFD4AF37)),
                      const SizedBox(width: 10),
                      Text(
                        _t("المستخدم:", "User:"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedUser,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: Text(_t("اختر المستخدم", "Select User")),
                          items: userNames.map((name) {
                            return DropdownMenuItem(
                                value: name, child: Text(name));
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => selectedUser = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ═══════════════════════════════════════════
            // 📦 كروت القطع
            // ═══════════════════════════════════════════
            for (final epc in epcs) _buildItemCard(epc, itemsData[epc]),

            // ═══════════════════════════════════════════
            // 💳 الدفع المجمّع
            // ═══════════════════════════════════════════
            if (epcs.length > 1) ...[
              const SizedBox(height: 8),
              Card(
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.merge_type, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _t('الدفع المجمّع (توزيع تلقائي)',
                                  'Batch payment (auto distribute)'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: globalPaymentType,
                        isExpanded: true,
                        hint: Text(_t('اختر نوع الدفع المجمّع',
                            'Select batch payment type')),
                        items: [
                          DropdownMenuItem(
                              value: 'cash', child: Text(_t('كاش', 'Cash'))),
                          DropdownMenuItem(
                              value: 'visa', child: Text(_t('شبكة', 'Card'))),
                          DropdownMenuItem(
                              value: 'multi',
                              child: Text(_t('متعدد', 'Multiple'))),
                        ],
                        // ✅ [إصلاح الدفع المجمّع] امسح الاتنين عند أي تبديل
                        onChanged: (v) {
                          setState(() {
                            globalPaymentType = v;
                            globalCashController.clear();
                            globalVisaController.clear();
                          });
                        },
                      ),
                      if (globalPaymentType == 'cash' ||
                          globalPaymentType == 'multi')
                        TextField(
                          controller: globalCashController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [DecimalTextInputFormatter()],
                          decoration: InputDecoration(
                              labelText: _t('مجموع الكاش للقطع كلها',
                                  'Total cash for all items')),
                        ),
                      if (globalPaymentType == 'visa' ||
                          globalPaymentType == 'multi')
                        TextField(
                          controller: globalVisaController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [DecimalTextInputFormatter()],
                          decoration: InputDecoration(
                              labelText: _t('مجموع الشبكة للقطع كلها',
                                  'Total card for all items')),
                        ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _applyGlobalDistribution,
                          icon: const Icon(Icons.done_all),
                          label: Text(_t('تطبيق على الكل', 'Apply to all')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // ═══════════════════════════════════════════
            // 💵 ملخص الدفع
            // ═══════════════════════════════════════════
            if (epcs.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryCol(
                      _t("الكاش", "Cash"),
                      totalCash.toStringAsFixed(2),
                      Colors.green,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    _summaryCol(
                      _t("الشبكة", "Visa"),
                      totalVisa.toStringAsFixed(2),
                      Colors.blue,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    _summaryCol(
                      _t("الإجمالي المدفوع", "Total Paid"),
                      (totalCash + totalVisa).toStringAsFixed(2),
                      const Color(0xFFB8860B),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ═══════════════════════════════════════════
            // ✅ زر تسجيل البيع
            // ═══════════════════════════════════════════
            ElevatedButton.icon(
              onPressed: busy ? null : _sell,
              icon: busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : const Icon(Icons.sell, color: Colors.white),
              label: Text(
                busy
                    ? _t("جاري التسجيل...", "Recording...")
                    : _t("تسجيل عملية البيع", "Register Sale"),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            if (msg != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: msg!.contains('✅') || msg!.contains('تم تنفيذ')
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: msg!.contains('✅') || msg!.contains('تم تنفيذ')
                        ? Colors.green.shade300
                        : Colors.red.shade300,
                  ),
                ),
                child: Text(
                  msg!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: msg!.contains('✅') || msg!.contains('تم تنفيذ')
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _topInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _summaryCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "$value ريال",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
