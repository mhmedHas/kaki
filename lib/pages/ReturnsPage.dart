// import 'dart:async';
// import 'dart:io';
// import 'dart:ui' as ui;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../services/firestore_service.dart';
// import '../services/seuic_uhf_service.dart';
// import '../utils/image_compressor.dart';

// /// ====================================================================
// /// صفحة المرتجعات
// /// تعرض كل القطع التي تم بيعها خلال آخر 3 أيام، وتسمح باسترجاع أي قطعة
// /// عن طريق قراءة شريحة (EPC) جديدة وتصوير صورة جديدة لها، مع حذف سجل
// /// البيع القديم بعد إعادة تسجيل القطعة في المخزون.
// /// ====================================================================
// class ReturnsPage extends StatefulWidget {
//   const ReturnsPage({super.key});

//   @override
//   State<ReturnsPage> createState() => _ReturnsPageState();
// }

// class _ReturnsPageState extends State<ReturnsPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   bool _loading = true;
//   String? _error;
//   List<Map<String, dynamic>> _recentSales = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _loadRecentSales();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!mounted) return;
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadRecentSales() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final sales = await FS.getRecentSales(days: 3);
//       if (!mounted) return;
//       setState(() {
//         _recentSales = sales;
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   void _showAppMessage(String msg, {bool success = false}) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(msg),
//         ),
//         backgroundColor: success ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<void> _onTapReturn(Map<String, dynamic> sale) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => _ReturnConfirmDialog(t: _t),
//     );
//     if (confirmed != true || !mounted) return;

//     final result = await Navigator.push<bool>(
//       context,
//       MaterialPageRoute(builder: (_) => ReturnEntryPage(sale: sale)),
//     );

//     if (result == true) {
//       _showAppMessage(
//         _t('تم استرجاع القطعة بنجاح', 'Item returned successfully'),
//         success: true,
//       );
//       _loadRecentSales();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection:
//           _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(_t('المرتجعات', 'Returns')),
//           backgroundColor: const Color(0xFFD4AF37),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               tooltip: _t('تحديث', 'Refresh'),
//               onPressed: _loading ? null : _loadRecentSales,
//             ),
//           ],
//         ),
//         body: _buildBody(),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_loading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text(
//             '${_t('حدث خطأ أثناء جلب البيانات', 'Failed to load data')}\n$_error',
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }
//     if (_recentSales.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text(
//             _t(
//               'لا توجد عمليات بيع خلال آخر 3 أيام',
//               'No items were sold in the last 3 days',
//             ),
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _loadRecentSales,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(14),
//         itemCount: _recentSales.length,
//         itemBuilder: (context, i) => _buildSaleCard(_recentSales[i]),
//       ),
//     );
//   }

//   Widget _buildSaleCard(Map<String, dynamic> sale) {
//     final payload = Map<String, dynamic>.from(sale['payload'] ?? {});
//     final category = (sale['category'] ?? '').toString();
//     final epcHex = (sale['epcHex'] ?? '').toString();
//     final payment = Map<String, dynamic>.from(sale['payment'] ?? {});
//     final soldAt = sale['soldAt'];
//     final soldAtStr =
//         (soldAt is Timestamp) ? _formatDate(soldAt.toDate()) : '-';

//     return Card(
//       margin: const EdgeInsets.only(bottom: 14),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(_categoryIcon(category), color: const Color(0xFFD4AF37)),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     _categoryLabel(category),
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//                 Text(soldAtStr,
//                     style: const TextStyle(color: Colors.grey, fontSize: 12)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(
//               _t('الشريحة القديمة: $epcHex', 'Old tag: $epcHex'),
//               style: const TextStyle(fontSize: 13, color: Colors.grey),
//             ),
//             const SizedBox(height: 10),
//             ..._buildPayloadDetails(category, payload),
//             if (payment.isNotEmpty) ...[
//               const Divider(height: 20),
//               Text(
//                 _t('سعر البيع: ${payment['total'] ?? 0}',
//                     'Sale total: ${payment['total'] ?? 0}'),
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//               if (payment['soldBy'] != null)
//                 Text(_t('البائع: ${payment['soldBy']}',
//                     'Sold by: ${payment['soldBy']}')),
//             ],
//             const SizedBox(height: 14),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _onTapReturn(sale),
//                 icon: const Icon(Icons.assignment_return),
//                 label: Text(_t('استرجاع', 'Return')),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildPayloadDetails(
//       String category, Map<String, dynamic> payload) {
//     switch (category) {
//       case 'gold':
//       case 'scrap':
//         return [
//           Text(_t('العيار: ${payload['carat'] ?? '-'}',
//               'Carat: ${payload['carat'] ?? '-'}')),
//           if (payload['kind'] != null)
//             Text(_t('النوع: ${payload['kind']}', 'Kind: ${payload['kind']}')),
//           Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
//               'Weight: ${payload['weight'] ?? '-'} g')),
//           if (payload['wage'] != null)
//             Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       case 'gem':
//         return [
//           Text(_t('نوع الحجر: ${payload['type'] ?? '-'}',
//               'Type: ${payload['type'] ?? '-'}')),
//           Text(_t('التكلفة: ${payload['cost'] ?? '-'}',
//               'Cost: ${payload['cost'] ?? '-'}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       case 'bullion':
//         return [
//           Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
//               'Weight: ${payload['weight'] ?? '-'} g')),
//           if (payload['wage'] != null)
//             Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       default:
//         return payload.entries
//             .map((e) => Text('${e.key}: ${e.value}'))
//             .toList();
//     }
//   }

//   IconData _categoryIcon(String category) {
//     switch (category) {
//       case 'gold':
//         return Icons.workspace_premium;
//       case 'gem':
//         return Icons.diamond;
//       case 'scrap':
//         return Icons.recycling;
//       case 'bullion':
//         return Icons.workspace_premium;
//       default:
//         return Icons.inventory_2;
//     }
//   }

//   String _categoryLabel(String category) {
//     switch (category) {
//       case 'gold':
//         return _t('ذهب', 'Gold');
//       case 'gem':
//         return _t('أحجار كريمة', 'Gemstones');
//       case 'scrap':
//         return _t('كسر', 'Scrap');
//       case 'bullion':
//         return _t('سبائك', 'Bullion');
//       default:
//         return category;
//     }
//   }

//   String _formatDate(DateTime d) {
//     final hh = d.hour.toString().padLeft(2, '0');
//     final mm = d.minute.toString().padLeft(2, '0');
//     return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} $hh:$mm';
//   }
// }

// /// ====================================================================
// /// نافذة تأكيد الاسترجاع: زرار التأكيد لا يُفعَّل إلا بعد 5 ثوانٍ
// /// ====================================================================
// class _ReturnConfirmDialog extends StatefulWidget {
//   final String Function(String ar, String en) t;
//   const _ReturnConfirmDialog({required this.t});

//   @override
//   State<_ReturnConfirmDialog> createState() => _ReturnConfirmDialogState();
// }

// class _ReturnConfirmDialogState extends State<_ReturnConfirmDialog> {
//   static const int _waitSeconds = 5;
//   int _secondsLeft = _waitSeconds;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) return;
//       if (_secondsLeft <= 1) {
//         timer.cancel();
//         setState(() => _secondsLeft = 0);
//       } else {
//         setState(() => _secondsLeft -= 1);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = widget.t;
//     final ready = _secondsLeft <= 0;

//     return Directionality(
//       textDirection: ui.TextDirection.rtl,
//       child: AlertDialog(
//         title: Row(
//           children: [
//             const Icon(Icons.warning_amber_rounded, color: Colors.orange),
//             const SizedBox(width: 8),
//             Text(t('تأكيد الاسترجاع', 'Confirm Return')),
//           ],
//         ),
//         content: Text(
//           t(
//             'هل أنت متأكد من استرجاع هذه القطعة؟ سيتم حذف سجل البيع وإعادة تسجيل القطعة في المخزون برقم شريحة وصورة جديدين.',
//             'Are you sure you want to return this item? The sale record will be deleted and the item re-registered in inventory with a new tag and image.',
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(t('إلغاء', 'Cancel')),
//           ),
//           ElevatedButton(
//             onPressed: ready ? () => Navigator.pop(context, true) : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: Colors.redAccent.withOpacity(0.4),
//             ),
//             child: Text(
//               ready
//                   ? t('تأكيد الاسترجاع', 'Confirm Return')
//                   : t('تأكيد الاسترجاع ($_secondsLeft)',
//                       'Confirm Return ($_secondsLeft)'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// ====================================================================
// /// صفحة إعادة الإدخال (مثل صفحة الإدخال الأصلية): تعرض بيانات القطعة
// /// القديمة، وتطلب قراءة شريحة جديدة وتصوير صورة جديدة، ثم تحفظ القطعة
// /// كعنصر جديد في المخزون وتحذف سجل البيع القديم.
// /// ====================================================================
// class ReturnEntryPage extends StatefulWidget {
//   final Map<String, dynamic> sale;
//   const ReturnEntryPage({super.key, required this.sale});

//   @override
//   State<ReturnEntryPage> createState() => _ReturnEntryPageState();
// }

// class _ReturnEntryPageState extends State<ReturnEntryPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   String newEpcHex = '';
//   bool isReading = false;
//   StreamSubscription<String>? _tagSubscription;

//   File? selectedImage;
//   bool busy = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();

//     SeuicUhfService.open();
//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
//       if (!mounted) return;
//       //if (tag.length < 24) return; // ليست شريحة EPC صحيحة

//       final exists = await FS.checkItemExists(tag.toUpperCase());
//       if (!mounted) return;
//       if (exists) {
//         _showAppMessage(
//           _t('⚠️ هذه الشريحة مسجلة من قبل',
//               '⚠️ This tag is already registered'),
//         );
//         return;
//       }
//       setState(() {
//         newEpcHex = tag.toUpperCase();
//         isReading = false;
//       });
//     });
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!mounted) return;
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     super.dispose();
//   }

//   void _showAppMessage(String text, {bool success = false}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(text),
//         ),
//         backgroundColor: success ? Colors.green : Colors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<void> _readChip() async {
//     setState(() => isReading = true);
//     try {
//       final result = await SeuicUhfService.inventoryOnce();
//       if (result == null || result.isEmpty) {
//         setState(() => isReading = false);
//         _showAppMessage(_t(
//           'لم يتم العثور على شريحة - جرب فتح تطبيق UHF',
//           'No chip found - try opening the UHF app',
//         ));
//         return;
//       }

//       final exists = await FS.checkItemExists(result.toUpperCase());
//       if (exists) {
//         setState(() => isReading = false);
//         _showAppMessage(
//           _t('⚠️ هذه الشريحة مسجلة من قبل',
//               '⚠️ This tag is already registered'),
//         );
//         return;
//       }

//       setState(() {
//         newEpcHex = result.toUpperCase();
//         isReading = false;
//       });
//     } catch (e) {
//       setState(() => isReading = false);
//       _showAppMessage('${_t('خطأ في قراءة الشريحة', 'Chip read error')}: $e');
//     }
//   }

//   void _clearEpc() => setState(() => newEpcHex = '');

//   Future<void> _pickImage() async {
//     FocusScope.of(context).unfocus();
//     final picker = ImagePicker();
//     final xFile = await picker.pickImage(source: ImageSource.camera);
//     if (xFile != null) {
//       setState(() => selectedImage = File(xFile.path));
//     }
//   }

//   Future<void> _save() async {
//     if (newEpcHex.isEmpty) {
//       _showAppMessage(
//           _t('من فضلك اقرأ شريحة جديدة أولاً', 'Please read a new tag first'));
//       return;
//     }
//     if (selectedImage == null) {
//       _showAppMessage(
//         _t('من فضلك صوّر صورة جديدة للقطعة',
//             'Please take a new photo of the item'),
//       );
//       return;
//     }

//     setState(() => busy = true);
//     try {
//       final sale = widget.sale;
//       final category = (sale['category'] ?? '').toString();
//       final payload = Map<String, dynamic>.from(sale['payload'] ?? {});
//       final saleId = sale['id']?.toString();

//       // 1) إعادة تسجيل القطعة في المخزون برقم الشريحة الجديد وبيانات الإدخال الأصلية
//       await FS.saveItem(
//         epcHex: newEpcHex,
//         category: category,
//         date: DateTime.now(),
//         payload: payload,
//         fromOpeningBalance: false,
//       );

//       // 2) رفع الصورة الجديدة وربطها بالشريحة الجديدة
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       final compressed = await compressImage(selectedImage!);
//       if (compressed != null) {
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('images')
//             .child('users')
//             .child(uid)
//             .child(newEpcHex)
//             .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//         final metadata = SettableMetadata(
//           contentType: 'image/jpeg',
//           cacheControl: 'public,max-age=300',
//         );
//         await storageRef.putFile(compressed, metadata);
//         final url = await storageRef.getDownloadURL();

//         await FS.uploadImage(newEpcHex, {
//           'images': FieldValue.arrayUnion([url]),
//         });
//       }

//       // 3) حذف بيانات الشريحة القديمة من سجل المبيعات
//       if (saleId != null) {
//         await FS.deleteSale(saleId);
//       }

//       if (!mounted) return;
//       Navigator.pop(context, true);
//     } catch (e) {
//       _showAppMessage('${_t('فشل الاسترجاع', 'Return failed')}: $e');
//     } finally {
//       if (mounted) setState(() => busy = false);
//     }
//   }

//   /*void _showManualEpcDialog() {
//     final controller = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(_t("إضافة شريحة يدويًا", "Add Tag Manually")),
//         content: TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             labelText: _t("رقم الشريحة (EPC)", "Tag EPC"),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text(_t("إلغاء", "Cancel")),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               AddEpcManualy(controller.text);
//             },
//             child: Text(_t("إضافة", "Add")),
//           ),
//         ],
//       ),
//     );
//   }
//   void AddEpcManualy(String Epc){
//     SeuicUhfService.addEpcManualy(Epc);
//   }*/

//   @override
//   Widget build(BuildContext context) {
//     final payload = Map<String, dynamic>.from(widget.sale['payload'] ?? {});
//     final category = (widget.sale['category'] ?? '').toString();
//     final oldEpc = (widget.sale['epcHex'] ?? '').toString();

//     return Directionality(
//       textDirection:
//           _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(_t('استرجاع قطعة', 'Return Item')),
//           backgroundColor: const Color(0xFFD4AF37),
//           centerTitle: true,
//         ),
//         /*floatingActionButton: FloatingActionButton(
//           backgroundColor: const Color(0xFFD4AF37),
//           onPressed: _showManualEpcDialog,
//           child: const Icon(Icons.add),
//         ),*/
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ===== بيانات القطعة الأصلية (بيانات الإدخال) =====
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFFD4AF37).withOpacity(0.12),
//                       const Color(0xFFB8860B).withOpacity(0.05),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _t('بيانات القطعة المسترجعة', 'Returned Item Data'),
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _t('الشريحة القديمة: $oldEpc', 'Old tag: $oldEpc'),
//                       style: const TextStyle(color: Colors.grey, fontSize: 13),
//                     ),
//                     const SizedBox(height: 8),
//                     ..._payloadDetails(category, payload),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 28),

//               // ===== قراءة شريحة جديدة =====
//               Text(
//                 _t('قراءة شريحة جديدة', 'Read New Tag'),
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 12),
//               if (newEpcHex.isEmpty)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Center(
//                     child: Text(
//                       _t('لم يتم قراءة شريحة بعد', 'No tag has been read yet'),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 )
//               else
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xFFD4AF37)),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.check_circle, color: Colors.green),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text('EPC: $newEpcHex',
//                             style: const TextStyle(fontFamily: 'monospace')),
//                       ),
//                       IconButton(
//                           icon: const Icon(Icons.clear), onPressed: _clearEpc),
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 28),

//               // ===== رفع صورة جديدة =====
//               Text(
//                 _t('صورة جديدة للقطعة', 'New Item Image'),
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.camera_alt, color: Color(0xFFD4AF37)),
//                 label: Text(
//                   _t('تصوير القطعة', 'Take Photo'),
//                   style: const TextStyle(color: Color(0xFFD4AF37)),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: Color(0xFFD4AF37)),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               if (selectedImage != null) ...[
//                 const SizedBox(height: 12),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     selectedImage!,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//               const SizedBox(height: 36),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed:
//                       (busy || newEpcHex.isEmpty || selectedImage == null)
//                           ? null
//                           : _save,
//                   icon: busy
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2.5, color: Colors.white),
//                         )
//                       : const Icon(Icons.save),
//                   label: Text(busy
//                       ? _t('جاري الحفظ...', 'Saving...')
//                       : _t('حفظ', 'Save')),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD4AF37),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     textStyle: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _payloadDetails(String category, Map<String, dynamic> payload) {
//     switch (category) {
//       case 'gold':
//       case 'scrap':
//         return [
//           Text(_t('العيار: ${payload['carat'] ?? '-'}',
//               'Carat: ${payload['carat'] ?? '-'}')),
//           if (payload['kind'] != null)
//             Text(_t('النوع: ${payload['kind']}', 'Kind: ${payload['kind']}')),
//           Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
//               'Weight: ${payload['weight'] ?? '-'} g')),
//           if (payload['wage'] != null)
//             Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       case 'gem':
//         return [
//           Text(_t('نوع الحجر: ${payload['type'] ?? '-'}',
//               'Type: ${payload['type'] ?? '-'}')),
//           Text(_t('التكلفة: ${payload['cost'] ?? '-'}',
//               'Cost: ${payload['cost'] ?? '-'}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       case 'bullion':
//         return [
//           Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
//               'Weight: ${payload['weight'] ?? '-'} g')),
//           if (payload['wage'] != null)
//             Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
//           Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
//               'Code: ${payload['qrCode'] ?? '-'}')),
//         ];
//       default:
//         return payload.entries
//             .map((e) => Text('${e.key}: ${e.value}'))
//             .toList();
//     }
//   }
// }
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import '../services/new_printer_api.dart';
import '../services/new_printer_status.dart';
import '../utils/image_compressor.dart';
import 'label_layout_model.dart'; // تأكد من المسار الصحيح

// ====================================================================
// صفحة المرتجعات (قائمة المبيعات الأخيرة)
// ====================================================================
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
      textDirection:
          _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
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
    final soldAtStr =
        (soldAt is Timestamp) ? _formatDate(soldAt.toDate()) : '-';

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
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(soldAtStr,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                _t('سعر البيع: ${payment['total'] ?? 0}',
                    'Sale total: ${payment['total'] ?? 0}'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (payment['soldBy'] != null)
                Text(_t('البائع: ${payment['soldBy']}',
                    'Sold by: ${payment['soldBy']}')),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPayloadDetails(
      String category, Map<String, dynamic> payload) {
    switch (category) {
      case 'gold':
      case 'scrap':
        return [
          Text(_t('العيار: ${payload['carat'] ?? '-'}',
              'Carat: ${payload['carat'] ?? '-'}')),
          if (payload['kind'] != null)
            Text(_t('النوع: ${payload['kind']}', 'Kind: ${payload['kind']}')),
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
              'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
              'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'gem':
        return [
          Text(_t('نوع الحجر: ${payload['type'] ?? '-'}',
              'Type: ${payload['type'] ?? '-'}')),
          Text(_t('التكلفة: ${payload['cost'] ?? '-'}',
              'Cost: ${payload['cost'] ?? '-'}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
              'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      case 'bullion':
        return [
          Text(_t('الوزن: ${payload['weight'] ?? '-'} جرام',
              'Weight: ${payload['weight'] ?? '-'} g')),
          if (payload['wage'] != null)
            Text(_t('الأجر: ${payload['wage']}', 'Wage: ${payload['wage']}')),
          Text(_t('الكود: ${payload['qrCode'] ?? '-'}',
              'Code: ${payload['qrCode'] ?? '-'}')),
        ];
      default:
        return payload.entries
            .map((e) => Text('${e.key}: ${e.value}'))
            .toList();
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

// ====================================================================
// نافذة تأكيد الاسترجاع (بعد 5 ثوانٍ)
// ====================================================================
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
                  : t('تأكيد الاسترجاع ($_secondsLeft)',
                      'Confirm Return ($_secondsLeft)'),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// صفحة إدخال بيانات الاسترجاع (مطابقة لصفحة تفاصيل القطعة في بقايا الأطقم)
// ====================================================================
class ReturnEntryPage extends StatefulWidget {
  final Map<String, dynamic> sale;
  const ReturnEntryPage({super.key, required this.sale});

  @override
  State<ReturnEntryPage> createState() => _ReturnEntryPageState();
}

class _ReturnEntryPageState extends State<ReturnEntryPage> {
  // ===== اللغة =====
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // ===== بيانات القطعة القديمة (من البيع) =====
  late Map<String, dynamic> _oldPayload;
  late String _oldCategory;
  late String _oldEpc;
  late String _oldKind;

  // ===== بيانات الإدخال الجديدة =====
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _qrController = TextEditingController();
  bool _useScanner = false;

  // ===== الصورة =====
  File? _selectedImage;
  bool _pinImage = false;

  // ===== الشريحة الجديدة =====
  String _newEpcHex = '';
  bool _isReadFromChip = false;
  bool _isReading = false;
  bool _showManualEpcField = false;
  final TextEditingController _manualEpcController = TextEditingController();
  final FocusNode _manualEpcFocus = FocusNode();

  // ===== حالة الطباعة =====
  bool _isPrinting = false;
  bool _isPrinterConnected = false;
  String _connectedPrinterName = "غير متصلة";
  String? _connectedPrinterMac;
  String? _errorMessage;
  String? _successMessage;
  String? _progressMessage;
  StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

  // ===== الماسح =====
  bool _isPrimaryScanner = false;
  StreamSubscription<String>? _tagSubscription;

  // ===== ملف الطباعة =====
  LabelProfile? _activeProfile;

  // ===== حالة الحفظ =====
  bool _isSaving = false;

  // ===== مفاتيح النماذج =====
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ==================================================================
  // دورة الحياة
  // ==================================================================
  @override
  void initState() {
    super.initState();

    // استخراج البيانات القديمة
    _oldPayload = Map<String, dynamic>.from(widget.sale['payload'] ?? {});
    _oldCategory = (widget.sale['category'] ?? '').toString();
    _oldEpc = (widget.sale['epcHex'] ?? '').toString();
    _oldKind = _oldPayload['kind']?.toString() ?? 'قطعة';

    // تعيين الوزن القديم في حقل الوزن (للقراءة فقط)
    final oldWeight = (_oldPayload['weight'] as num?)?.toDouble() ?? 0.0;
    _weightController.text = oldWeight.toStringAsFixed(2);

    // توليد QR عشوائي
    _qrController.text = const Uuid().v4().substring(0, 7);

    // تحميل الإعدادات
    _loadLanguage();
    _loadScannerMode();
    _loadActiveProfile();
    _listenToPrinterStatus();
    _listenToTagStream();

    // فتح UHF
    SeuicUhfService.open();
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    _printerStatusSubscription?.cancel();
    _manualEpcController.dispose();
    _manualEpcFocus.dispose();
    _weightController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  // ==================================================================
  // تحميل الإعدادات
  // ==================================================================
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadActiveProfile() async {
    final profile = await LabelProfileStorage.loadActive('gold');
    if (mounted) setState(() => _activeProfile = profile);
  }

  Future<void> _loadScannerMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('scannerMode');
    setState(() {
      _isPrimaryScanner = mode == 'primary';
    });
  }

  // ==================================================================
  // اتصال الطابعة
  // ==================================================================
  void _listenToPrinterStatus() {
    _printerStatusSubscription =
        NewPrinterStatusListener.getStream().listen((status) {
      setState(() {
        _errorMessage = null;
        _successMessage = null;
        _progressMessage = null;

        switch (status.status) {
          case 'connected':
            final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
            _isPrinterConnected = true;
            _connectedPrinterName = match?.group(1) ?? "طابعة LPAPI";
            _connectedPrinterMac = match?.group(1);
            _successMessage = "متصل بـ $_connectedPrinterName";
            break;

          case 'disconnected':
            _isPrinterConnected = false;
            _connectedPrinterName = "غير متصلة";
            _connectedPrinterMac = null;
            _errorMessage = "تم قطع الاتصال بالطابعة";
            break;

          case 'connecting':
          case 'auto_connecting':
            _progressMessage = status.message;
            break;

          case 'printing':
          case 'progress':
            _progressMessage = status.message;
            _isPrinting = true;
            break;

          case 'success':
            _successMessage = status.message;
            _isPrinting = false;
            break;

          case 'error':
            _errorMessage = status.message;
            _isPrinting = false;
            if (status.message.contains("قطع الاتصال") ||
                status.message.contains("غير متصلة")) {
              _isPrinterConnected = false;
              _connectedPrinterName = "غير متصلة";
              _connectedPrinterMac = null;
            }
            break;

          case 'initialized':
            _successMessage = status.message;
            break;
        }
      });
    });
  }

  Future<void> _selectAndConnectPrinter() async {
    _clearMessages();
    try {
      final printers = await NewPrinterAPI.getBluetoothPrinters();
      if (printers.isEmpty) {
        setState(() {
          _errorMessage = "لا توجد طابعات LPAPI في النطاق";
        });
        return;
      }

      final selectedMac = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("اختر طابعة LPAPI"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: printers.length,
              itemBuilder: (context, i) {
                final name = printers[i]["name"] ?? "طابعة LPAPI";
                final addr = printers[i]["address"] ?? "";
                final isCurrent = addr == _connectedPrinterMac;
                return ListTile(
                  leading: Icon(
                    Icons.print,
                    color: isCurrent ? Colors.green : const Color(0xFFD4AF37),
                  ),
                  title: Text(name,
                      style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text(addr),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(ctx, addr),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("إلغاء")),
          ],
        ),
      );

      if (selectedMac != null) {
        final selectedDevice = printers.firstWhere(
          (printer) => printer["address"] == selectedMac,
          orElse: () => {"name": "طابعة LPAPI", "address": selectedMac},
        );
        setState(() {
          _progressMessage = "جاري الاتصال...";
          _connectedPrinterMac = selectedMac;
          _connectedPrinterName = selectedDevice["name"] ?? selectedMac;
        });

        final success = await NewPrinterAPI.connectBluetooth(selectedMac);
        if (success) {
          setState(() {
            _isPrinterConnected = true;
            _successMessage = null;
            _progressMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = "فشل الاتصال، تأكد من تشغيل الطابعة";
            _progressMessage = null;
            _isPrinterConnected = false;
            _connectedPrinterName = "غير متصلة";
            _connectedPrinterMac = null;
          });
        }
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    }
  }

  Future<void> _disconnectPrinter() async {
    await NewPrinterAPI.disconnect();
  }

  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _progressMessage = null;
    });
  }

  // ==================================================================
  // قراءة الشريحة (بنسخ كامل من RemainingKitsPage)
  // ==================================================================
  void _listenToTagStream() {
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;

      if (tag.length >= 24) {
        final exists = await FS.checkItemExists(tag.toUpperCase());
        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_t('⚠️ هذه الشريحة مسجلة من قبل',
                  '⚠️ This tag is already registered')),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          _newEpcHex = tag.toUpperCase();
          _isReadFromChip = true;
          _isReading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.nfc, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_t('تم قراءة الشريحة:', 'Tag read:')} ${tag.substring(0, tag.length > 20 ? 20 : tag.length)}...',
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFD4AF37),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        if (!_isPrimaryScanner) {
          setState(() {
            _manualEpcController.text = tag;
            _showManualEpcField = true;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              FocusScope.of(context).requestFocus(_manualEpcFocus);
            }
          });
        }
      }
    });
  }

  void _clearEpc() {
    setState(() {
      _newEpcHex = '';
      _isReadFromChip = false;
      _showManualEpcField = false;
      _manualEpcController.clear();
    });
  }

  void addEpcManualy(String epc) {
    SeuicUhfService.addEpcManualy(epc);
    setState(() {
      _newEpcHex = epc.toUpperCase();
      _isReadFromChip = true;
      _showManualEpcField = false;
      _manualEpcController.clear();
    });
    _manualEpcFocus.unfocus();
    FocusScope.of(context).unfocus();
  }

  // ==================================================================
  // QR
  // ==================================================================
  void _toggleQRMode() {
    setState(() {
      _useScanner = !_useScanner;
      if (!_useScanner) {
        _qrController.text = const Uuid().v4().substring(0, 7);
      } else {
        _qrController.clear();
      }
    });
  }

  // ==================================================================
  // الصورة
  // ==================================================================
  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      setState(() {
        _selectedImage = File(xFile.path);
      });
    }
  }

  Future<void> _uploadImage(String epcHex) async {
    if (_selectedImage == null) return;
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final compressed = await compressImage(_selectedImage!);
      if (compressed == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ فشل ضغط الصورة')),
        );
        return;
      }
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(epcHex)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=300',
      );
      await storageRef.putFile(compressed, metadata);
      final url = await storageRef.getDownloadURL();
      await FS.uploadImage(epcHex, {
        'images': FieldValue.arrayUnion([url]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم رفع الصورة بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ فشل رفع الصورة: $e')),
      );
    }
  }

  // ==================================================================
  // الطباعة
  // ==================================================================
  Future<void> _printConvertedItemLabel({
    required String name,
    required String weight,
    required String qrCode,
  }) async {
    if (!_isPrinterConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ الطابعة غير متصلة، يرجى الاتصال أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isPrinting = true);

    try {
      if (_activeProfile != null) {
        await LabelLayoutStorage.save(_activeProfile!.layout);
      }

      final layout = await LabelLayoutStorage.load('gold');
      final prefs = await SharedPreferences.getInstance();
      final String? logoBase64 = prefs.getString('custom_logo_base64');

      final success = await NewPrinterAPI.printGoldLabel(
        weight: weight.trim().isEmpty ? null : weight.trim(),
        carat: null,
        size: null,
        showQr: "true",
        qrCode: qrCode.trim(),
        customLogoBase64: logoBase64,
        labelLayout: layout.toJson(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ تمت طباعة ليبل القطعة بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Print error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل الطباعة: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> _showProfilePicker(String labelType) async {
    final profiles = await LabelProfileStorage.loadAll(labelType);
    if (!mounted) return;
    if (profiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'لا يوجد ملفات محفوظة — اذهب لمحرر التخطيط وأضف ملفاً أولاً'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.style_outlined, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    const Text(
                      'اختر إعدادات الطباعة',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: profiles.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16),
                  itemBuilder: (_, i) {
                    final p = profiles[i];
                    final isActive = _activeProfile?.id == p.id;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isActive
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFFD4AF37).withOpacity(0.12),
                        child: Icon(
                          Icons.description_outlined,
                          color:
                              isActive ? Colors.white : const Color(0xFFD4AF37),
                        ),
                      ),
                      title: Text(
                        p.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isActive ? const Color(0xFFD4AF37) : null,
                        ),
                      ),
                      subtitle: Text(
                        '${p.layout.stickerW.toStringAsFixed(0)}×'
                        '${p.layout.stickerH.toStringAsFixed(0)} مم  •  '
                        'كثافة ${p.layout.density}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: isActive
                          ? const Icon(Icons.check_circle,
                              color: Color(0xFFD4AF37))
                          : null,
                      onTap: () {
                        setState(() => _activeProfile = p);
                        LabelProfileStorage.saveActive('gold', p.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ تم تفعيل "${p.name}"'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================================
  // حفظ الاسترجاع
  // ==================================================================
  Future<void> _saveReturn() async {
    // التحقق من صحة النموذج
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // التأكد من وجود QR
    final qrCode = _qrController.text.trim();
    if (qrCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ يرجى إدخال كود QR'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // التأكد من وجود شريحة جديدة
    if (_newEpcHex.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ يرجى قراءة أو إدخال رقم الشريحة الجديدة'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // التأكد من وجود صورة جديدة
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ يرجى تصوير صورة جديدة للقطعة'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final saleId = widget.sale['id']?.toString();
      if (saleId == null) throw Exception('معرف البيع غير موجود');

      // 1. إعادة تسجيل القطعة في المخزون بالبيانات الجديدة (نفس البيانات القديمة مع QR و EPC جديدين)
      final newPayload = Map<String, dynamic>.from(_oldPayload);
      newPayload['qrCode'] = qrCode; // تحديث QR
      // يمكن إضافة notes لتوضيح أنها مرتجعة
      newPayload['notes'] = 'مرتجعة من البيع (الشريحة القديمة: $_oldEpc)';

      await FS.saveItem(
        epcHex: _newEpcHex,
        category: _oldCategory,
        date: DateTime.now(),
        payload: newPayload,
        fromOpeningBalance: false,
      );

      // 2. رفع الصورة الجديدة
      await _uploadImage(_newEpcHex);

      // 3. حذف سجل البيع القديم
      await FS.deleteSale(saleId);

      if (!mounted) return;

      // 4. إغلاق الصفحة بنجاح
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل الاسترجاع: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ==================================================================
  // بناء الواجهة
  // ==================================================================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // استخراج البيانات القديمة لعرضها
    final oldWeight = (_oldPayload['weight'] as num?)?.toDouble() ?? 0.0;
    final oldCarat = _oldPayload['carat']?.toString() ?? '-';
    final oldKind = _oldPayload['kind']?.toString() ?? 'قطعة';
    final oldWage = _oldPayload['wage']?.toString() ?? '-';
    final oldQr = _oldPayload['qrCode']?.toString() ?? '-';

    return Directionality(
      textDirection:
          _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _t('استرجاع قطعة', 'Return Item'),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFD4AF37),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          ),
          actions: [
            // زر الاتصال بالطابعة (مثل بقايا الأطقم)
            IconButton(
              icon: Icon(
                _isPrinterConnected ? Icons.print : Icons.print_disabled,
                color: Colors.white,
              ),
              onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
              tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================================================
                    // 1. بطاقة بيانات القطعة القديمة (للقراءة فقط)
                    // =========================================================
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
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFD4AF37).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.history,
                                  color: Color(0xFFD4AF37),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _t('بيانات القطعة المسترجعة',
                                    'Returned Item Data'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFD4AF37)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // الشريحة القديمة
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.nfc,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _t('الشريحة القديمة: $_oldEpc',
                                      'Old tag: $_oldEpc'),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // تفاصيل الوزن والعيار والنوع والأجر والكود
                          _buildOldItemDetail(_t('العيار', 'Carat'), oldCarat),
                          if (oldKind.isNotEmpty)
                            _buildOldItemDetail(_t('النوع', 'Kind'), oldKind),
                          _buildOldItemDetail(_t('الوزن', 'Weight'),
                              '$oldWeight ${_t('جم', 'g')}'),
                          if (oldWage != '-')
                            _buildOldItemDetail(_t('الأجر', 'Wage'), oldWage),
                          _buildOldItemDetail(_t('الكود', 'Code'), oldQr),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // =========================================================
                    // 2. حقل الوزن (للقراءة فقط - الوزن القديم)
                    // =========================================================
                    Text(
                      _t('وزن القطعة (جم)', 'Part Weight (g)'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _weightController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.scale, color: Color(0xFFD4AF37)),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        suffixText: _t('جم', 'g'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // =========================================================
                    // 3. QR كود جديد
                    // =========================================================
                    Text(
                      _t('الكود الجديد', 'New QR Code'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _qrController,
                      readOnly: true,
                      focusNode: FocusNode(canRequestFocus: false),
                      decoration: InputDecoration(
                        labelText: _useScanner
                            ? _t("QR من الماسح", "QR from Scanner")
                            : _t("QR عشوائي", "Random QR"),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _useScanner ? Icons.qr_code_scanner : Icons.shuffle,
                          ),
                          tooltip: _useScanner
                              ? _t("استخدام QR عشوائي", "Use Random QR")
                              : _t("استخدام الماسح", "Use Scanner"),
                          onPressed: _toggleQRMode,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _t('يرجى إدخال الكود', 'Please enter code');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // =========================================================
                    // 4. زر تصوير الصورة
                    // =========================================================
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt),
                        label: Text(_t('تصوير صورة جديدة', 'Take New Photo')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _pinImage = !_pinImage;
                            });
                          },
                          icon: Icon(
                            _pinImage
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            color: _pinImage ? Colors.orange : null,
                          ),
                          label: Text(
                            _pinImage
                                ? _t("إلغاء تثبيت الصورة", "Unpin Image")
                                : _t("تثبيت الصورة", "Pin Image"),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _pinImage ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // =========================================================
                    // 5. أزرار الطباعة واختيار الملف الشخصي
                    // =========================================================
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: (_isPrinting || _isSaving)
                                ? null
                                : () async {
                                    // طباعة ليبل الذهب باستخدام البيانات الجديدة
                                    await _printConvertedItemLabel(
                                      name: _oldKind,
                                      weight: _weightController.text,
                                      qrCode: _qrController.text.trim(),
                                    );
                                    // بعد الطباعة، إذا لم يكن الماسح الأساسي، نظهر حقل الإدخال اليدوي
                                    if (!_isPrimaryScanner) {
                                      setState(() {
                                        _showManualEpcField = true;
                                        _manualEpcController.clear();
                                      });
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        if (mounted) {
                                          FocusScope.of(context)
                                              .requestFocus(_manualEpcFocus);
                                        }
                                      });
                                    }
                                  },
                            icon: _isPrinting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.print),
                            label: Text(
                              _isPrinting
                                  ? _t('جاري الطباعة...', 'Printing...')
                                  : _t('طباعة ليبل الذهب', 'Print Gold Label'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPrinterConnected
                                  ? const Color(0xFFD4AF37)
                                  : Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              side: const BorderSide(color: Color(0xFFD4AF37)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => _showProfilePicker('gold'),
                            child: const Icon(
                              Icons.settings,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // =========================================================
                    // 6. قراءة الشريحة الجديدة (بآلية بقايا الأطقم)
                    // =========================================================
                    Text(
                      _t('قراءة شريحة جديدة', 'Read New Tag'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 6),

                    // عرض الشريحة المقروءة
                    if (_newEpcHex.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _isReadFromChip
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isReadFromChip
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
                              size: 16,
                              color:
                                  _isReadFromChip ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'EPC: $_newEpcHex',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: _isReadFromChip
                                      ? Colors.green.shade700
                                      : Colors.grey,
                                  fontWeight: _isReadFromChip
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (_isReadFromChip) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _t('مقروء', 'Read'),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: _clearEpc,
                                tooltip: _t('مسح', 'Clear'),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // حقل الإدخال اليدوي (عند عدم وجود قارئ أساسي)
                    if (!_isPrimaryScanner && _showManualEpcField) ...[
                      TextField(
                        controller: _manualEpcController,
                        focusNode: _manualEpcFocus,
                        textCapitalization: TextCapitalization.characters,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'أدخل رقم الشريحة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: Icon(Icons.nfc),
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            addEpcManualy(value.trim());
                          } else {
                            setState(() {
                              _showManualEpcField = false;
                              _manualEpcController.clear();
                            });
                            _manualEpcFocus.unfocus();
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    // =========================================================
                    // 7. زر الحفظ (استرجاع)
                    // =========================================================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            (_isSaving || _isPrinting) ? null : _saveReturn,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(
                          _isSaving
                              ? _t('جاري الاسترجاع...', 'Returning...')
                              : _t('استرجاع القطعة', 'Return Item'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================================
  // مساعدات العرض
  // ==================================================================
  Widget _buildOldItemDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
