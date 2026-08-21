import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:convert';

class TransformPage extends StatefulWidget {
  const TransformPage({super.key});

  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  StreamSubscription<String>? _tagSubscription;
  String epcHex = '';
  bool isReading = false;
  bool busy = false;
  String? msg;

  Map<String, dynamic>? itemData;
  String? selectedBranch;
  String? selectedRep;

  List<Map<String, dynamic>> branches = [];
  List<String> reps = [];

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  int _readerPower = 26; // القيمة الحالية
  int _tempPower = 26; // قيمة السلايدر المؤقتة

  @override
  void initState() {
    super.initState();

    //SeuicUhfService.sendBoolean(false);
    _loadLanguage();
    //_loadSavedReaderPower();
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (mounted) {
        setState(() {
          epcHex = tag;
          isReading = false;
        });
        _loadItemData();
      }
    });
    SeuicUhfService.open();
  }

  Future<void> _loadSavedReaderPower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');

    if (powerJson != null) {
      final Map<String, dynamic> pagePowers =
          Map<String, dynamic>.from(json.decode(powerJson));

      final savedPower = pagePowers['transform'];
      if (savedPower != null) {
        setState(() {
          _readerPower = savedPower;
          _tempPower = savedPower;
        });

        // تطبيق القوة فعليًا على القارئ
        await SeuicUhfService.setPower(savedPower);
      }
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
                      setModalState(() {
                        _tempPower = v.round();
                      });
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
                            setState(() {
                              _readerPower = _tempPower;
                            });

                            // تطبيق القوة فورًا
                            await SeuicUhfService.setPower(_readerPower);

                            // حفظها للصفحة
                            final prefs = await SharedPreferences.getInstance();
                            final powerJson = prefs.getString('pagePowers');
                            Map<String, int> pagePowers = {};

                            if (powerJson != null) {
                              pagePowers =
                                  Map<String, int>.from(json.decode(powerJson));
                            }

                            pagePowers['transform'] = _readerPower;
                            await prefs.setString(
                                'pagePowers', json.encode(pagePowers));

                            Navigator.pop(context);

                            /*_showMsg(
                              _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'),
                              true,
                            );*/
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    super.dispose();
  }

  Future<void> _readChip() async {
    setState(() {
      isReading = true;
      msg = null;
    });
    try {
      final result = await SeuicUhfService.inventoryOnce();
      if (result == null || result.isEmpty) {
        setState(() => isReading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t("لم يتم العثور على شريحة", "No tag found")),
          ),
        );
      } else {
        setState(() {
          epcHex = result.toUpperCase();
          isReading = false;
        });
        _loadItemData();
      }
    } catch (e) {
      setState(() => isReading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t("خطأ في قراءة الشريحة: $e", "Tag read error: $e")),
        ),
      );
    }
  }

  Future<void> _loadItemData() async {
    if (epcHex.isEmpty) return;
    try {
      final data = await FS.findItemByEpc(epcHex);
      setState(() {
        itemData = data;
        msg = null;
      });
    } catch (e) {
      setState(() {
        itemData = null;
        msg = _t("فشل تحميل بيانات الشريحة: $e", "Failed to load tag data: $e");
      });
    }
  }

  Future<void> _loadBranches() async {
    final list = await FS.getBranches();
    setState(() => branches = list);
  }

  Future<void> _loadRepsForBranch(String branchId) async {
    final list = await FS.getRepsForBranch(branchId);
    setState(() => reps = list);
  }

  Future<void> _convertToScrap() async {
    if (itemData == null) return;

    setState(() => busy = true);
    try {
      await FS.transferToScrap(itemData!, epcHex);
      setState(() {
        itemData = null; // 🔹 يمسح البيانات من الواجهة
        msg = _t("✅ تم تحويل العنصر إلى كسر بنجاح",
            "✅ Item successfully converted to scrap");
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => msg = null);
      });
    } catch (e) {
      setState(() => msg =
          _t("فشل التحويل إلى كسر: $e", "Failed to convert to scrap: $e"));
    } finally {
      setState(() => busy = false);
    }
  }

  Future<void> _convertToBranch() async {
    if (itemData == null || selectedBranch == null || selectedRep == null) {
      setState(() => msg = _t("يرجى اختيار الفرع والمندوب أولاً",
          "Please select branch and delegate first"));
      return;
    }

    setState(() => busy = true);
    try {
      final branch = branches.firstWhere(
        (b) => b['id'] == selectedBranch,
        orElse: () => {
          'name': _t('غير معروف', 'Unknown'),
          'uid': null,
        },
      );

      final branchName = branch['name'];
      final branchUid = branch['uid'];
      await FS.transferToBranch(itemData!, epcHex, selectedBranch!, branchName,
          selectedRep!, branchUid);
      setState(() {
        itemData = null; // 🔹 يحدث الصفحة فورًا
        msg = _t("✅ تم تحويل العنصر إلى الفرع بنجاح",
            "✅ Item transferred to branch successfully");
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => msg = null);
      });
    } catch (e) {
      setState(() => msg =
          _t("فشل التحويل إلى الفرع: $e", "Failed to transfer to branch: $e"));
    } finally {
      setState(() => busy = false);
    }
  }

  // ---------- المساعدة لبناء قائمة ويدجتس للعرض ----------
  List<Widget> _buildDetails() {
    if (itemData == null) return [];

    final payload = itemData!['payload'] ?? {};
    final category = itemData!['category'] ?? '';

    final List<Widget> details = [];

    details.add(
      Text(
        _t("الفئة: ${_getCategoryName(category)}",
            "Category: ${_getCategoryName(category)}"),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
    details.add(const SizedBox(height: 10));

    switch (category) {
      case "gold":
        details.addAll([
          _buildInfoRow(_t("العيار", "Carat"), payload['carat']),
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الأجر", "Wage"), payload['wage']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "scrap":
        details.addAll([
          _buildInfoRow(_t("العيار", "Carat"), payload['carat']),
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "bullion":
        details.addAll([
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الأجر", "Wage"), payload['wage']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "gem":
        details.addAll([
          _buildInfoRow(_t("نوع الحجر", "Gem Type"), payload['type']),
          _buildInfoRow(_t("التكلفة", "Cost"), payload['cost']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      default:
        details.add(
          Text(
            _t("❌ نوع غير معروف", "❌ Unknown Type"),
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
    // ✅ إضافة الباركود أو QR في النهاية
    if (payload['qrCode'] != null && payload['qrCode'].toString().isNotEmpty) {
      details.add(const SizedBox(height: 16));
      details.add(
        Center(
          child: (payload['showQr'] == true)
              ? QrImageView(
                  data: payload['qrCode'],
                  version: QrVersions.auto,
                  size: 100.0,
                  backgroundColor: Colors.white,
                )
              : BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: payload['qrCode'],
                  width: 100,
                  height: 40,
                ),
        ),
      );
      details.add(const SizedBox(height: 16));
    }

    return details;
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value?.toString() ?? '-',
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String cat) {
    switch (cat) {
      case 'gold':
        return _t("ذهب", "Gold");
      case 'scrap':
        return _t("كسر", "Scrap");
      case 'bullion':
        return _t("سبائك", "Bullion");
      case 'gem':
        return _t("أحجار كريمة", "Gemstone");
      default:
        return cat;
    }
  }

  void _showManualEpcDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t("إدخال الشريحة يدويًا", "Enter Tag Manually")),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
            ),
            onPressed: () {
              final epc = controller.text.trim();
              Navigator.pop(ctx);

              if (epc.isEmpty) {
                _showMsg(_t("أدخل رقم الشريحة", "Enter tag EPC"), false);
                return;
              }

              setState(() {
                epcHex = epc;
                isReading = false;
              });

              _loadItemData();
            },
            child: Text(_t("تحميل", "Load")),
          ),
        ],
      ),
    );
  }

  void _showMsg(String text, bool success) {
    setState(() {
      msg = success ? '✅ $text' : '❌ $text';
    });
    // اختفاء الرسالة بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => msg = null);
    });
  }

  // ---------- الواجهة ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("صفحة التحويل", "Transfer Page")),
        backgroundColor: const Color(0xFFD4AF37),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: _t('قوة القارئ', 'Reader Power'),
            onPressed: _showPowerSheet,
          ),
        ],*/
        centerTitle: true,
        elevation: 3,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        tooltip: _t("إدخال شريحة يدوي", "Manual Tag"),
        onPressed: _showManualEpcDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر قراءة الشريحة
              ElevatedButton.icon(
                onPressed: isReading ? null : _readChip,
                icon: const Icon(Icons.nfc, size: 22),
                label: Text(_t("قراءة الشريحة", "Read Tag"),
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              // عرض بيانات الشريحة بعد القراءة
              if (itemData != null) ...[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t("بيانات الشريحة", "Tag Data"),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        ..._buildDetails(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                Text(_t("اختر نوع التحويل", "Select Transfer Type"),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // زر التحويل إلى كسر
                ElevatedButton.icon(
                  onPressed: busy
                      ? null
                      : () async {
                          final confirm = await _showConfirmDialog(
                            context,
                            title: _t("تحويل إلى كسر", "Convert to Scrap"),
                            message: _t(
                                "هل أنت متأكد أنك تريد تحويل هذه الشريحة إلى كسر؟",
                                "Are you sure you want to convert this tag to scrap?"),
                            color: Colors.redAccent,
                          );
                          if (confirm == true) await _convertToScrap();
                        },
                  icon: const Icon(Icons.recycling),
                  label: Text(
                    _t("تحويل إلى كسر", "Convert to Scrap"),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),

                // زر التحويل إلى فرع
                ElevatedButton.icon(
                  onPressed: () async {
                    await _loadBranches();
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return StatefulBuilder(
                          builder: (ctx, setDialogState) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text(
                                  _t("تحويل إلى فرع", "Transfer to Branch")),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField<String>(
                                    initialValue: selectedBranch,
                                    items: branches.map((b) {
                                      return DropdownMenuItem<String>(
                                        value: b['id'],
                                        child: Text(b['name']),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      labelText:
                                          _t("اختر الفرع", "Select Branch"),
                                      border: const OutlineInputBorder(),
                                    ),
                                    onChanged: (v) async {
                                      if (v == null) return;
                                      setDialogState(() {
                                        selectedBranch = v;
                                        reps = [];
                                        selectedRep = null;
                                      });
                                      final list = await FS.getRepsForBranch(v);
                                      setDialogState(() => reps = list);
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  if (reps.isNotEmpty)
                                    DropdownButtonFormField<String>(
                                      initialValue: selectedRep,
                                      items: reps.map((r) {
                                        return DropdownMenuItem<String>(
                                          value: r,
                                          child: Text(r),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelText: _t(
                                            "اختر المندوب", "Select Delegate"),
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (v) =>
                                          setDialogState(() => selectedRep = v),
                                    )
                                  else if (selectedBranch != null)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: CircularProgressIndicator(),
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text(_t("إلغاء", "Cancel")),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (selectedBranch == null ||
                                        selectedRep == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "$_t('يرجى اختيار الفرع والمندوب أولاً', 'Please select branch and delegate first')")),
                                      );
                                      return;
                                    }
                                    final confirm = await _showConfirmDialog(
                                      context,
                                      title: _t("تحويل إلى فرع",
                                          "Transfer to Branch"),
                                      message: _t(
                                          "هل أنت متأكد أنك تريد تحويل هذه الشريحة إلى الفرع المحدد؟",
                                          "Are you sure you want to transfer this item to the selected branch?"),
                                      color: Colors.blueAccent,
                                    );
                                    if (confirm == true) {
                                      Navigator.pop(ctx);
                                      await _convertToBranch();
                                    }
                                  },
                                  child: Text(_t("تحويل", "Transfer")),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.sync_alt),
                  label: Text(
                    _t("تحويل إلى فرع", "Transfer to Branch"),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],

              if (msg != null) ...[
                const SizedBox(height: 25),
                Text(
                  msg!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: msg!.contains("✅") ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // نافذة تأكيد التحويل
  Future<bool?> _showConfirmDialog(BuildContext context,
      {required String title, required String message, required Color color}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: color),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_t("تأكيد", "Confirm")),
          ),
        ],
      ),
    );
  }
}
