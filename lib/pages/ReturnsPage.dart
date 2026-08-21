import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import '../utils/image_compressor.dart';

/// ====================================================================
/// صفحة المرتجعات
/// تعرض كل القطع التي تم بيعها خلال آخر 3 أيام، وتسمح باسترجاع أي قطعة
/// عن طريق قراءة شريحة (EPC) جديدة وتصوير صورة جديدة لها، مع حذف سجل
/// البيع القديم بعد إعادة تسجيل القطعة في المخزون.
/// ====================================================================
class ReturnsPage extends StatefulWidget {
  const ReturnsPage({super.key});

  @override
  State<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _recentSales = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadRecentSales();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadRecentSales() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final sales = await FS.getRecentSales(days: 3);
      if (!mounted) return;
      setState(() {
        _recentSales = sales;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _showAppMessage(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Text(msg),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onTapReturn(Map<String, dynamic> sale) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ReturnConfirmDialog(t: _t),
    );
    if (confirmed != true || !mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ReturnEntryPage(sale: sale)),
    );

    if (result == true) {
      _showAppMessage(
        _t('تم استرجاع القطعة بنجاح', 'Item returned successfully'),
        success: true,
      );
      _loadRecentSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_t('المرتجعات', 'Returns')),
          backgroundColor: const Color(0xFFD4AF37),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: _t('تحديث', 'Refresh'),
              onPressed: _loading ? null : _loadRecentSales,
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            '${_t('حدث خطأ أثناء جلب البيانات', 'Failed to load data')}\n$_error',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_recentSales.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            _t(
              'لا توجد عمليات بيع خلال آخر 3 أيام',
              'No items were sold in the last 3 days',
            ),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecentSales,
      child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _recentSales.length,
        itemBuilder: (context, i) => _buildSaleCard(_recentSales[i]),
      ),
    );
  }

  Widget _buildSaleCard(Map<String, dynamic> sale) {
    final payload = Map<String, dynamic>.from(sale['payload'] ?? {});
    final category = (sale['category'] ?? '').toString();
    final epcHex = (sale['epcHex'] ?? '').toString();
    final payment = Map<String, dynamic>.from(sale['payment'] ?? {});
    final soldAt = sale['soldAt'];
    final soldAtStr = (soldAt is Timestamp) ? _formatDate(soldAt.toDate()) : '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_categoryIcon(category), color: const Color(0xFFD4AF37)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _categoryLabel(category),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(soldAtStr, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _t('الشريحة القديمة: $epcHex', 'Old tag: $epcHex'),
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ..._buildPayloadDetails(category, payload),
            if (payment.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                _t('سعر البيع: ${payment['total'] ?? 0}', 'Sale total: ${payment['total'] ?? 0}'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (payment['soldBy'] != null)
                Text(_t('البائع: ${payment['soldBy']}', 'Sold by: ${payment['soldBy']}')),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _onTapReturn(sale),
                icon: const Icon(Icons.assignment_return),
                label: Text(_t('استرجاع', 'Return')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPayloadDetails(String category, Map<String, dynamic> payload) {
    switch (category) {
      case 'gold':
      case 'scrap':
        return [
          Text(_t('العيار: ${payload['carat'] ?? '-'}', 'Carat: ${payload['carat'] ?? '-'}')),
          if (payload['kind'] != null)
            Text(_t('النوع: ${payload['kind']}', 'Kind: ${payload['kind']}')),
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام', 'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'gem':
        return [
          Text(_t('نوع الحجر: ${payload['type'] ?? '-'}', 'Type: ${payload['type'] ?? '-'}')),
          Text(_t('التكلفة: ${payload['cost'] ?? '-'}', 'Cost: ${payload['cost'] ?? '-'}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'bullion':
        return [
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام', 'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      default:
        return payload.entries.map((e) => Text('${e.key}: ${e.value}')).toList();
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'gold':
        return Icons.workspace_premium;
      case 'gem':
        return Icons.diamond;
      case 'scrap':
        return Icons.recycling;
      case 'bullion':
        return Icons.workspace_premium;
      default:
        return Icons.inventory_2;
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'gold':
        return _t('ذهب', 'Gold');
      case 'gem':
        return _t('أحجار كريمة', 'Gemstones');
      case 'scrap':
        return _t('كسر', 'Scrap');
      case 'bullion':
        return _t('سبائك', 'Bullion');
      default:
        return category;
    }
  }

  String _formatDate(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} $hh:$mm';
  }
}

/// ====================================================================
/// نافذة تأكيد الاسترجاع: زرار التأكيد لا يُفعَّل إلا بعد 5 ثوانٍ
/// ====================================================================
class _ReturnConfirmDialog extends StatefulWidget {
  final String Function(String ar, String en) t;
  const _ReturnConfirmDialog({required this.t});

  @override
  State<_ReturnConfirmDialog> createState() => _ReturnConfirmDialogState();
}

class _ReturnConfirmDialogState extends State<_ReturnConfirmDialog> {
  static const int _waitSeconds = 5;
  int _secondsLeft = _waitSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final ready = _secondsLeft <= 0;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text(t('تأكيد الاسترجاع', 'Confirm Return')),
          ],
        ),
        content: Text(
          t(
            'هل أنت متأكد من استرجاع هذه القطعة؟ سيتم حذف سجل البيع وإعادة تسجيل القطعة في المخزون برقم شريحة وصورة جديدين.',
            'Are you sure you want to return this item? The sale record will be deleted and the item re-registered in inventory with a new tag and image.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('إلغاء', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: ready ? () => Navigator.pop(context, true) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.redAccent.withOpacity(0.4),
            ),
            child: Text(
              ready
                  ? t('تأكيد الاسترجاع', 'Confirm Return')
                  : t('تأكيد الاسترجاع ($_secondsLeft)', 'Confirm Return ($_secondsLeft)'),
            ),
          ),
        ],
      ),
    );
  }
}

/// ====================================================================
/// صفحة إعادة الإدخال (مثل صفحة الإدخال الأصلية): تعرض بيانات القطعة
/// القديمة، وتطلب قراءة شريحة جديدة وتصوير صورة جديدة، ثم تحفظ القطعة
/// كعنصر جديد في المخزون وتحذف سجل البيع القديم.
/// ====================================================================
class ReturnEntryPage extends StatefulWidget {
  final Map<String, dynamic> sale;
  const ReturnEntryPage({super.key, required this.sale});

  @override
  State<ReturnEntryPage> createState() => _ReturnEntryPageState();
}

class _ReturnEntryPageState extends State<ReturnEntryPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  String newEpcHex = '';
  bool isReading = false;
  StreamSubscription<String>? _tagSubscription;

  File? selectedImage;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    SeuicUhfService.open();
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;
      //if (tag.length < 24) return; // ليست شريحة EPC صحيحة

      final exists = await FS.checkItemExists(tag.toUpperCase());
      if (!mounted) return;
      if (exists) {
        _showAppMessage(
          _t('⚠️ هذه الشريحة مسجلة من قبل', '⚠️ This tag is already registered'),
        );
        return;
      }
      setState(() {
        newEpcHex = tag.toUpperCase();
        isReading = false;
      });
    });
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    super.dispose();
  }

  void _showAppMessage(String text, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Text(text),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _readChip() async {
    setState(() => isReading = true);
    try {
      final result = await SeuicUhfService.inventoryOnce();
      if (result == null || result.isEmpty) {
        setState(() => isReading = false);
        _showAppMessage(_t(
          'لم يتم العثور على شريحة - جرب فتح تطبيق UHF',
          'No chip found - try opening the UHF app',
        ));
        return;
      }

      final exists = await FS.checkItemExists(result.toUpperCase());
      if (exists) {
        setState(() => isReading = false);
        _showAppMessage(
          _t('⚠️ هذه الشريحة مسجلة من قبل', '⚠️ This tag is already registered'),
        );
        return;
      }

      setState(() {
        newEpcHex = result.toUpperCase();
        isReading = false;
      });
    } catch (e) {
      setState(() => isReading = false);
      _showAppMessage('${_t('خطأ في قراءة الشريحة', 'Chip read error')}: $e');
    }
  }

  void _clearEpc() => setState(() => newEpcHex = '');

  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      setState(() => selectedImage = File(xFile.path));
    }
  }

  Future<void> _save() async {
    if (newEpcHex.isEmpty) {
      _showAppMessage(_t('من فضلك اقرأ شريحة جديدة أولاً', 'Please read a new tag first'));
      return;
    }
    if (selectedImage == null) {
      _showAppMessage(
        _t('من فضلك صوّر صورة جديدة للقطعة', 'Please take a new photo of the item'),
      );
      return;
    }

    setState(() => busy = true);
    try {
      final sale = widget.sale;
      final category = (sale['category'] ?? '').toString();
      final payload = Map<String, dynamic>.from(sale['payload'] ?? {});
      final saleId = sale['id']?.toString();

      // 1) إعادة تسجيل القطعة في المخزون برقم الشريحة الجديد وبيانات الإدخال الأصلية
      await FS.saveItem(
        epcHex: newEpcHex,
        category: category,
        date: DateTime.now(),
        payload: payload,
        fromOpeningBalance: false,
      );

      // 2) رفع الصورة الجديدة وربطها بالشريحة الجديدة
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final compressed = await compressImage(selectedImage!);
      if (compressed != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('users')
            .child(uid)
            .child(newEpcHex)
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          cacheControl: 'public,max-age=300',
        );
        await storageRef.putFile(compressed, metadata);
        final url = await storageRef.getDownloadURL();

        await FS.uploadImage(newEpcHex, {
          'images': FieldValue.arrayUnion([url]),
        });
      }

      // 3) حذف بيانات الشريحة القديمة من سجل المبيعات
      if (saleId != null) {
        await FS.deleteSale(saleId);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _showAppMessage('${_t('فشل الاسترجاع', 'Return failed')}: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  /*void _showManualEpcDialog() {
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
  void AddEpcManualy(String Epc){
    SeuicUhfService.addEpcManualy(Epc);
  }*/

  @override
  Widget build(BuildContext context) {
    final payload = Map<String, dynamic>.from(widget.sale['payload'] ?? {});
    final category = (widget.sale['category'] ?? '').toString();
    final oldEpc = (widget.sale['epcHex'] ?? '').toString();

    return Directionality(
      textDirection: _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_t('استرجاع قطعة', 'Return Item')),
          backgroundColor: const Color(0xFFD4AF37),
          centerTitle: true,
        ),
        /*floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFD4AF37),
          onPressed: _showManualEpcDialog,
          child: const Icon(Icons.add),
        ),*/
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== بيانات القطعة الأصلية (بيانات الإدخال) =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD4AF37).withOpacity(0.12),
                      const Color(0xFFB8860B).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('بيانات القطعة المسترجعة', 'Returned Item Data'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _t('الشريحة القديمة: $oldEpc', 'Old tag: $oldEpc'),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    ..._payloadDetails(category, payload),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ===== قراءة شريحة جديدة =====
              Text(
                _t('قراءة شريحة جديدة', 'Read New Tag'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (newEpcHex.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      _t('لم يتم قراءة شريحة بعد', 'No tag has been read yet'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFD4AF37)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('EPC: $newEpcHex', style: const TextStyle(fontFamily: 'monospace')),
                      ),
                      IconButton(icon: const Icon(Icons.clear), onPressed: _clearEpc),
                    ],
                  ),
                ),
              const SizedBox(height: 28),

              // ===== رفع صورة جديدة =====
              Text(
                _t('صورة جديدة للقطعة', 'New Item Image'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
                label: Text(
                  _t('تصوير القطعة', 'Take Photo'),
                  style: const TextStyle(color: Color(0xFFD4AF37)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD4AF37)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              if (selectedImage != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (busy || newEpcHex.isEmpty || selectedImage == null) ? null : _save,
                  icon: busy
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                      : const Icon(Icons.save),
                  label: Text(busy ? _t('جاري الحفظ...', 'Saving...') : _t('حفظ', 'Save')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _payloadDetails(String category, Map<String, dynamic> payload) {
    switch (category) {
      case 'gold':
      case 'scrap':
        return [
          Text(_t('العيار: ${payload['carat'] ?? '-'}', 'Carat: ${payload['carat'] ?? '-'}')),
          if (payload['kind'] != null)
            Text(_t('النوع: ${payload['kind']}', 'Kind: ${payload['kind']}')),
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام', 'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'gem':
        return [
          Text(_t('نوع الحجر: ${payload['type'] ?? '-'}', 'Type: ${payload['type'] ?? '-'}')),
          Text(_t('التكلفة: ${payload['cost'] ?? '-'}', 'Cost: ${payload['cost'] ?? '-'}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'bullion':
        return [
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام', 'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}', 'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      default:
        return payload.entries.map((e) => Text('${e.key}: ${e.value}')).toList();
    }
  }
}