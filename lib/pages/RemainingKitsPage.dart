// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../services/firestore_service.dart';
// import '../services/seuic_uhf_service.dart';
// import '../services/new_printer_api.dart';
// import '../services/new_printer_status.dart';
// import 'dart:async';
// import 'label_layout_model.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import '../utils/image_compressor.dart';

// class RemainingKitsPage extends StatefulWidget {
//   const RemainingKitsPage({super.key});

//   @override
//   State<RemainingKitsPage> createState() => _RemainingKitsPageState();
// }

// class _RemainingKitsPageState extends State<RemainingKitsPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   Map<String, dynamic>? _openKitData;
//   String? _openKitDocId;
//   bool _showKitItems = false;

//   Map<String, dynamic>? _selectedItem;
//   int? _selectedIndex;
//   bool _showItemDetails = false;

//   bool _isPrinting = false;
//   bool _isPrinterConnected = false;
//   String _connectedPrinterName = "غير متصلة";
//   String? _connectedPrinterMac;
//   String? _errorMessage;
//   String? _successMessage;
//   String? _progressMessage;
//   StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

//   bool _isPrimaryScanner = false;
//   StreamSubscription<String>? _tagSubscription;

//   final TextEditingController qrController = TextEditingController();
//   bool useScanner = false;

//   final TextEditingController weightController = TextEditingController();

//   final FocusNode _weightFocusNode = FocusNode();

//   String _epcHex = '';
//   bool _isReadFromChip = false;
//   bool _isReading = false;

//   bool _showManualEpcField = false;
//   final TextEditingController _manualEpcController = TextEditingController();
//   final FocusNode _manualEpcFocus = FocusNode();

//   bool _isConverting = false;
//   LabelProfile? _activeProfile;

//   final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

//   File? _selectedImage;
//   bool _pinImage = false;

//   // ✅ فقط إجمالي الجرامات
//   double _totalRemainingWeight = 0.0;
//   bool _isLoadingTotal = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _loadScannerMode();
//     _listenToPrinterStatus();
//     _listenToTagStream();
//     _loadActiveProfile();
//     _calculateTotalRemainingWeight();

//     final randomQr = const Uuid().v4().substring(0, 7);
//     qrController.text = randomQr;
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     _printerStatusSubscription?.cancel();
//     _manualEpcController.dispose();
//     _manualEpcFocus.dispose();
//     qrController.dispose();
//     weightController.dispose();
//     _weightFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadActiveProfile() async {
//     final profile = await LabelProfileStorage.loadActive('gold');
//     if (mounted) setState(() => _activeProfile = profile);
//   }

//   Future<void> _loadScannerMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final mode = prefs.getString('scannerMode');
//     setState(() {
//       _isPrimaryScanner = mode == 'primary';
//     });
//   }

//   void _listenToPrinterStatus() {
//     _printerStatusSubscription =
//         NewPrinterStatusListener.getStream().listen((status) {
//       setState(() {
//         _errorMessage = null;
//         _successMessage = null;
//         _progressMessage = null;

//         switch (status.status) {
//           case 'connected':
//             final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
//             _isPrinterConnected = true;
//             _connectedPrinterName = match?.group(1) ?? "طابعة LPAPI";
//             _connectedPrinterMac = match?.group(1);
//             _successMessage = "متصل بـ $_connectedPrinterName";
//             break;

//           case 'disconnected':
//             _isPrinterConnected = false;
//             _connectedPrinterName = "غير متصلة";
//             _connectedPrinterMac = null;
//             _errorMessage = "تم قطع الاتصال بالطابعة";
//             break;

//           case 'connecting':
//           case 'auto_connecting':
//             _progressMessage = status.message;
//             break;

//           case 'printing':
//           case 'progress':
//             _progressMessage = status.message;
//             _isPrinting = true;
//             break;

//           case 'success':
//             _successMessage = status.message;
//             _isPrinting = false;
//             break;

//           case 'error':
//             _errorMessage = status.message;
//             _isPrinting = false;
//             if (status.message.contains("قطع الاتصال") ||
//                 status.message.contains("غير متصلة")) {
//               _isPrinterConnected = false;
//               _connectedPrinterName = "غير متصلة";
//               _connectedPrinterMac = null;
//             }
//             break;

//           case 'initialized':
//             _successMessage = status.message;
//             break;
//         }
//       });
//     });
//   }

//   void _listenToTagStream() {
//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
//       if (!mounted) return;

//       if (tag.length >= 24) {
//         final exists = await FS.checkItemExists(tag.toUpperCase());
//         if (exists) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(_t('⚠️ هذه الشريحة مسجلة من قبل',
//                   '⚠️ This tag is already registered')),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }

//         setState(() {
//           _epcHex = tag.toUpperCase();
//           _isReadFromChip = true;
//           _isReading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.nfc, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     '${_t('تم قراءة الشريحة:', 'Tag read:')} ${tag.substring(0, tag.length > 20 ? 20 : tag.length)}...',
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: const Color(0xFFD4AF37),
//             behavior: SnackBarBehavior.floating,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       } else {
//         if (!_isPrimaryScanner) {
//           setState(() {
//             _manualEpcController.text = tag;
//             _showManualEpcField = true;
//           });

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (mounted) {
//               FocusScope.of(context).requestFocus(_manualEpcFocus);
//             }
//           });
//         }
//       }
//     });
//   }

//   void _clearEpc() {
//     setState(() {
//       _epcHex = '';
//       _isReadFromChip = false;
//       _showManualEpcField = false;
//       _manualEpcController.clear();
//     });
//   }

//   void addEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//     setState(() {
//       _epcHex = Epc.toUpperCase();
//       _isReadFromChip = true;
//       _showManualEpcField = false;
//       _manualEpcController.clear();
//     });
//     _manualEpcFocus.unfocus();
//     FocusScope.of(context).unfocus();
//   }

//   void _toggleQRMode() {
//     setState(() {
//       useScanner = !useScanner;
//       if (!useScanner) {
//         qrController.text = const Uuid().v4().substring(0, 7);
//       } else {
//         qrController.clear();
//       }
//     });
//   }

//   Future<void> _selectAndConnectPrinter() async {
//     _clearMessages();
//     try {
//       final printers = await NewPrinterAPI.getBluetoothPrinters();
//       if (printers.isEmpty) {
//         setState(() {
//           _errorMessage = "لا توجد طابعات LPAPI في النطاق";
//         });
//         return;
//       }

//       final selectedMac = await showDialog<String>(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Text("اختر طابعة LPAPI"),
//           content: SizedBox(
//             width: double.maxFinite,
//             height: 300,
//             child: ListView.builder(
//               itemCount: printers.length,
//               itemBuilder: (context, i) {
//                 final name = printers[i]["name"] ?? "طابعة LPAPI";
//                 final addr = printers[i]["address"] ?? "";
//                 final isCurrent = addr == _connectedPrinterMac;
//                 return ListTile(
//                   leading: Icon(
//                     Icons.print,
//                     color: isCurrent ? Colors.green : const Color(0xFFD4AF37),
//                   ),
//                   title: Text(name,
//                       style: TextStyle(
//                           fontWeight:
//                               isCurrent ? FontWeight.bold : FontWeight.normal)),
//                   subtitle: Text(addr),
//                   trailing: isCurrent
//                       ? const Icon(Icons.check_circle, color: Colors.green)
//                       : null,
//                   onTap: () => Navigator.pop(ctx, addr),
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () => Navigator.pop(ctx),
//                 child: const Text("إلغاء")),
//           ],
//         ),
//       );

//       if (selectedMac != null) {
//         final selectedDevice = printers.firstWhere(
//           (printer) => printer["address"] == selectedMac,
//           orElse: () => {"name": "طابعة LPAPI", "address": selectedMac},
//         );
//         setState(() {
//           _progressMessage = "جاري الاتصال...";
//           _connectedPrinterMac = selectedMac;
//           _connectedPrinterName = selectedDevice["name"] ?? selectedMac;
//         });

//         final success = await NewPrinterAPI.connectBluetooth(selectedMac);
//         if (success) {
//           setState(() {
//             _isPrinterConnected = true;
//             _successMessage = null;
//             _progressMessage = null;
//           });
//         } else {
//           setState(() {
//             _errorMessage = "فشل الاتصال، تأكد من تشغيل الطابعة";
//             _progressMessage = null;
//             _isPrinterConnected = false;
//             _connectedPrinterName = "غير متصلة";
//             _connectedPrinterMac = null;
//           });
//         }
//       }
//     } catch (e) {
//       setState(() =>
//           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
//     }
//   }

//   Future<void> _disconnectPrinter() async {
//     await NewPrinterAPI.disconnect();
//   }

//   void _clearMessages() {
//     setState(() {
//       _errorMessage = null;
//       _successMessage = null;
//       _progressMessage = null;
//     });
//   }

//   Future<String?> _getKitImageUrl(String epcHex) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('items')
//           .doc(epcHex)
//           .get();

//       if (docSnapshot.exists) {
//         final data = docSnapshot.data();
//         final images = data?['images'] as List<dynamic>?;
//         if (images != null && images.isNotEmpty) {
//           return images.first.toString();
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error getting kit image: $e');
//       return null;
//     }
//   }

//   Future<void> _printConvertedItemLabel({
//     required String name,
//     required String weight,
//     required String qrCode,
//   }) async {
//     if (!_isPrinterConnected) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('⚠️ الطابعة غير متصلة، يرجى الاتصال أولاً'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     setState(() => _isPrinting = true);

//     try {
//       if (_activeProfile != null) {
//         await LabelLayoutStorage.save(_activeProfile!.layout);
//       }

//       final layout = await LabelLayoutStorage.load('gold');
//       final prefs = await SharedPreferences.getInstance();
//       final String? logoBase64 = prefs.getString('custom_logo_base64');

//       final success = await NewPrinterAPI.printGoldLabel(
//         weight: weight.trim().isEmpty ? null : weight.trim(),
//         carat: null,
//         size: null,
//         showQr: "true",
//         qrCode: qrCode.trim(),
//         customLogoBase64: logoBase64,
//         labelLayout: layout.toJson(),
//       );

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("✅ تمت طباعة ليبل القطعة بنجاح"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       print('Print error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ فشل الطباعة: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => _isPrinting = false);
//     }
//   }

//   Future<void> _uploadImage(String epcHex) async {
//     if (_selectedImage == null) return;

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       final compressed = await compressImage(_selectedImage!);
//       if (compressed == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('❌ فشل ضغط الصورة')),
//         );
//         return;
//       }

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epcHex)
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         cacheControl: 'public,max-age=300',
//       );

//       await storageRef.putFile(compressed, metadata);
//       final url = await storageRef.getDownloadURL();

//       await FS.uploadImage(epcHex, {
//         'images': FieldValue.arrayUnion([url]),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ تم رفع الصورة بنجاح')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ فشل رفع الصورة: $e')),
//       );
//     }
//   }

//   Future<void> _showProfilePicker(String labelType) async {
//     final profiles = await LabelProfileStorage.loadAll(labelType);

//     if (!mounted) return;

//     if (profiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//               'لا يوجد ملفات محفوظة — اذهب لمحرر التخطيط وأضف ملفاً أولاً'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => Directionality(
//         textDirection: ui.TextDirection.rtl,
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.6,
//           ),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.style_outlined, color: Color(0xFFD4AF37)),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'اختر إعدادات الطباعة',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               Flexible(
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   itemCount: profiles.length,
//                   separatorBuilder: (_, __) =>
//                       const Divider(height: 1, indent: 16),
//                   itemBuilder: (_, i) {
//                     final p = profiles[i];
//                     final isActive = _activeProfile?.id == p.id;
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: isActive
//                             ? const Color(0xFFD4AF37)
//                             : const Color(0xFFD4AF37).withOpacity(0.12),
//                         child: Icon(
//                           Icons.description_outlined,
//                           color:
//                               isActive ? Colors.white : const Color(0xFFD4AF37),
//                         ),
//                       ),
//                       title: Text(
//                         p.name,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: isActive ? const Color(0xFFD4AF37) : null,
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${p.layout.stickerW.toStringAsFixed(0)}×'
//                         '${p.layout.stickerH.toStringAsFixed(0)} مم  •  '
//                         'كثافة ${p.layout.density}',
//                         style: const TextStyle(fontSize: 11),
//                       ),
//                       trailing: isActive
//                           ? const Icon(Icons.check_circle,
//                               color: Color(0xFFD4AF37))
//                           : null,
//                       onTap: () {
//                         setState(() => _activeProfile = p);
//                         LabelProfileStorage.saveActive('gold', p.id);
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('✅ تم تفعيل "${p.name}"'),
//                             backgroundColor: Colors.green,
//                             duration: const Duration(seconds: 2),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   double _getRemainingWeight(Map<String, dynamic> kitData) {
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
//         (payload['weight'] as num?)?.toDouble() ??
//         0;
//     final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//     return originalWeight - soldWeight;
//   }

//   double _getRemainingItemsWeight(Map<String, dynamic> kitData) {
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final items = payload['remainingItems'] as List<dynamic>? ?? [];
//     double total = 0;
//     for (var item in items) {
//       total += (item['weight'] as num?)?.toDouble() ?? 0;
//     }
//     return total;
//   }

//   bool _isWeightFullyDistributed(Map<String, dynamic> kitData) {
//     final remainingWeight = _getRemainingWeight(kitData);
//     final itemsWeight = _getRemainingItemsWeight(kitData);
//     return (remainingWeight - itemsWeight).abs() < 0.001;
//   }

//   double _getOriginalWeight(Map<String, dynamic> kitData) {
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     return (payload['originalWeight'] as num?)?.toDouble() ??
//         (payload['weight'] as num?)?.toDouble() ??
//         0;
//   }

//   double _getSoldWeight(Map<String, dynamic> kitData) {
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     return (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//   }

//   List<String> _getSetComponents(Map<String, dynamic> kitData) {
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final components = payload['setComponents'] as List<dynamic>? ?? [];
//     return components.map((e) => e.toString()).toList();
//   }

//   List<Map<String, dynamic>> _getRemainingItems(Map<String, dynamic> kitData) {
//     if (kitData['payload'] == null) return [];

//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final items = payload['remainingItems'] as List<dynamic>? ?? [];

//     return items.map((e) => Map<String, dynamic>.from(e)).toList();
//   }

//   // ✅ دالة حساب إجمالي الجرامات المتبقية فقط
//   Future<void> _calculateTotalRemainingWeight() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     setState(() => _isLoadingTotal = true);

//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('setRemainders')
//           .get();

//       double totalWeight = 0.0;

//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final payload = data['payload'] as Map<String, dynamic>? ?? {};
//         final originalWeight =
//             (payload['originalWeight'] as num?)?.toDouble() ??
//                 (payload['weight'] as num?)?.toDouble() ??
//                 0;
//         final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//         final remainingWeight = originalWeight - soldWeight;
//         totalWeight += remainingWeight;
//       }

//       setState(() {
//         _totalRemainingWeight = totalWeight;
//         _isLoadingTotal = false;
//       });
//     } catch (e) {
//       print('Error calculating total: $e');
//       setState(() => _isLoadingTotal = false);
//     }
//   }

//   void _openKit(Map<String, dynamic> kitData, String docId) {
//     setState(() {
//       _openKitData = kitData;
//       _openKitDocId = docId;
//       _showKitItems = true;
//       _selectedItem = null;
//       _selectedIndex = null;
//       _showItemDetails = false;
//       _clearEpc();
//       _showManualEpcField = false;
//       _manualEpcController.clear();
//       _selectedImage = null;
//       _pinImage = false;
//     });
//   }

//   void _backToKits() {
//     setState(() {
//       _openKitData = null;
//       _openKitDocId = null;
//       _showKitItems = false;
//       _selectedItem = null;
//       _selectedIndex = null;
//       _showItemDetails = false;
//       _clearEpc();
//       _selectedImage = null;
//       _pinImage = false;
//     });
//     _calculateTotalRemainingWeight();
//   }

//   void _resetFormState() {
//     weightController.clear();
//     qrController.text = const Uuid().v4().substring(0, 7);
//     _clearEpc();
//     _showManualEpcField = false;
//     _manualEpcController.clear();
//     if (!_pinImage) {
//       _selectedImage = null;
//     }
//     _itemFormKey.currentState?.reset();
//   }

//   void _openItemDetails(Map<String, dynamic> item, int index) {
//     weightController.text =
//         (item['weight'] as num?)?.toStringAsFixed(2) ?? '0.00';

//     setState(() {
//       _selectedItem = item;
//       _selectedIndex = index;
//       _showItemDetails = true;
//       _showManualEpcField = false;
//       _manualEpcController.clear();
//       _clearEpc();
//       _selectedImage = null;
//       _pinImage = false;
//     });

//     _itemFormKey.currentState?.reset();
//   }

//   void _backToItemsList() {
//     setState(() {
//       _selectedItem = null;
//       _selectedIndex = null;
//       _showItemDetails = false;
//       _showManualEpcField = false;
//       _manualEpcController.clear();
//       _clearEpc();
//       if (!_pinImage) {
//         _selectedImage = null;
//       }
//     });
//     _resetFormState();
//   }

//   Future<void> _pickImage() async {
//     FocusScope.of(context).unfocus();

//     final picker = ImagePicker();
//     final xFile = await picker.pickImage(source: ImageSource.camera);

//     if (xFile != null) {
//       setState(() {
//         _selectedImage = File(xFile.path);
//       });
//     }
//   }

//   Future<void> _convertSinglePartToItem({
//     required int index,
//     required Map<String, dynamic> item,
//     required String category,
//     required Map<String, dynamic> kitData,
//     required String kitDocId,
//     required String uid,
//   }) async {
//     try {
//       setState(() => _isConverting = true);

//       final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});
//       final items = List<dynamic>.from(payload['remainingItems'] ?? []);

//       if (index >= items.length) {
//         throw Exception('القطعة غير موجودة في الطقم');
//       }

//       final removedItem = items.removeAt(index);

//       final weight = (item['weight'] as num?)?.toDouble() ??
//           (removedItem['weight'] as num?)?.toDouble() ??
//           0;

//       final qrCode = item['qrCode']?.toString() ??
//           removedItem['qrCode']?.toString() ??
//           const Uuid().v4().substring(0, 7);

//       final epcHex = _epcHex.isNotEmpty
//           ? _epcHex
//           : (kitData['epcHex']?.toString() ??
//               payload['epcHex']?.toString() ??
//               qrCode);

//       final componentName =
//           item['name']?.toString() ?? removedItem['name']?.toString() ?? 'قطعة';

//       final kitImageUrl = await _getKitImageUrl(epcHex);

//       final newPayload = {
//         'weight': weight,
//         'qrCode': qrCode,
//         'kind': componentName,
//         'isFromKit': true,
//         'kitDocId': kitDocId,
//         'originalKitWeight': payload['originalWeight'] ?? payload['weight'],
//         'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
//         'notes': 'تم التحويل من طقم ${payload['kind'] ?? ''}',
//         'carat': payload['carat'] ?? '21',
//         'size': payload['size'] ?? '0',
//         'wage': payload['wage'] ?? 0,
//         'showQr': true,
//         'images': kitImageUrl != null ? [kitImageUrl] : [],
//       };

//       await FS.saveItem(
//         epcHex: epcHex,
//         category: category,
//         date: DateTime.now(),
//         payload: newPayload,
//         fromOpeningBalance: false,
//       );

//       if (_selectedImage != null) {
//         await _uploadImage(epcHex);
//       }

//       if (kitImageUrl != null) {
//         await FS.uploadImage(epcHex, {
//           'images': FieldValue.arrayUnion([kitImageUrl]),
//         });
//       }

//       final currentSoldWeight =
//           (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//       final newSoldWeight = currentSoldWeight + weight;
//       final currentComponents =
//           List<String>.from(payload['setComponents'] ?? []);

//       final updateData = {
//         'payload.remainingItems': items,
//         'payload.soldWeight': newSoldWeight,
//         'updatedAt': FieldValue.serverTimestamp(),
//       };

//       if (index < currentComponents.length) {
//         currentComponents.removeAt(index);
//         updateData['payload.setComponents'] = currentComponents;
//       }

//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('setRemainders')
//           .doc(kitDocId)
//           .update(updateData);

//       setState(() {
//         _openKitData!['payload']['remainingItems'] = items;
//         _openKitData!['payload']['soldWeight'] = newSoldWeight;
//         if (index < currentComponents.length) {
//           _openKitData!['payload']['setComponents'] = currentComponents;
//         }
//       });

//       if (items.isEmpty) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .collection('setRemainders')
//             .doc(kitDocId)
//             .delete();

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('✅ تم تحويل جميع القطع وحذف الطقم'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           await _calculateTotalRemainingWeight();
//           _backToKits();
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   '✅ تم تحويل القطعة "$componentName" بنجاح (متبقي ${items.length} قطع)'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           await _calculateTotalRemainingWeight();
//           _backToItemsList();
//           setState(() {});
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 '${_t('فشل التحويل', 'Failed to convert')}: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       setState(() => _isConverting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     if (uid == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text(_t("بقايا الاطقم", "Remaining Kits")),
//           backgroundColor: const Color(0xFFD4AF37),
//         ),
//         body: Center(
//           child: Text(
//             _t('يرجى تسجيل الدخول أولاً', 'Please login first'),
//             style: const TextStyle(fontSize: 18),
//           ),
//         ),
//       );
//     }

//     if (_showKitItems && _openKitData != null) {
//       if (_showItemDetails && _selectedItem != null) {
//         return _buildItemDetailsView(uid);
//       }
//       return _buildKitItemsView(uid);
//     }

//     Query q = FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('setRemainders')
//         .orderBy('createdAt', descending: true);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("بقايا الاطقم", "Remaining Kits")),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               _calculateTotalRemainingWeight();
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             // ✅ عرض إجمالي الجرامات فقط
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color(0xFFD4AF37),
//                     Color(0xFFB8860B),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: _isLoadingTotal
//                   ? const Center(
//                       child: SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       ),
//                     )
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.scale,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Directionality(
//                           textDirection: ui.TextDirection.rtl,
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 _t('إجمالي الجرامات المعلقه',
//                                     'Total Remaining Weight'),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 15,
//                                 ),
//                               ),
//                               Container(
//                                 margin:
//                                     const EdgeInsets.symmetric(horizontal: 8),
//                                 width: 2,
//                                 height: 25,
//                                 color: const ui.Color.fromARGB(255, 28, 27, 27),
//                               ),
//                               Text(
//                                 '${_totalRemainingWeight.toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 _t('جم', 'g'),
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: q.snapshots(),
//                 builder: (ctx, snap) {
//                   if (!snap.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final docs = snap.data!.docs;
//                   if (docs.isEmpty) {
//                     return _buildEmptyState(
//                       icon: Icons.inventory_2_outlined,
//                       title: _t('لا يوجد بقايا أطقم', 'No Set Remainders'),
//                       subtitle: _t('لم يتم تسجيل أي بيع جزئي للأطقم',
//                           'No partial set sales recorded'),
//                     );
//                   }

//                   return ListView(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//                     children: [
//                       ...docs.map((doc) {
//                         final data = doc.data() as Map<String, dynamic>;
//                         return _buildKitCard(
//                           data: data,
//                           docId: doc.id,
//                           onOpen: () => _openKit(data, doc.id),
//                         );
//                       }),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildItemDetailsView(String uid) {
//     final kitData = _openKitData!;
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final category = kitData['category'] as String? ?? 'gold';
//     final item = _selectedItem!;
//     final index = _selectedIndex!;
//     final components = _getSetComponents(kitData);
//     final componentName = item['name'] ??
//         (index < components.length ? components[index] : 'قطعة ${index + 1}');

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _t('تفاصيل القطعة', 'Item Details'),
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFFD4AF37),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: _backToItemsList,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isPrinterConnected ? Icons.print : Icons.print_disabled,
//               color: Colors.white,
//             ),
//             onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
//             tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
//           ),
//         ],
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _itemFormKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 36,
//                           height: 36,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFD4AF37),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Center(
//                             child: Text(
//                               '${index + 1}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             componentName,
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFD4AF37),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   if (_epcHex.isNotEmpty) ...[
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: _isReadFromChip
//                             ? Colors.green.withOpacity(0.1)
//                             : Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: _isReadFromChip
//                               ? Colors.green
//                               : Colors.grey.shade300,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
//                             size: 16,
//                             color: _isReadFromChip ? Colors.green : Colors.grey,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               'EPC: $_epcHex',
//                               style: TextStyle(
//                                 fontFamily: 'monospace',
//                                 fontSize: 12,
//                                 color: _isReadFromChip
//                                     ? Colors.green.shade700
//                                     : Colors.grey,
//                                 fontWeight: _isReadFromChip
//                                     ? FontWeight.bold
//                                     : FontWeight.normal,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           if (_isReadFromChip) ...[
//                             const SizedBox(width: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 _t('مقروء', 'Read'),
//                                 style: const TextStyle(
//                                   color: Colors.green,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.clear, size: 16),
//                               onPressed: _clearEpc,
//                               tooltip: _t('مسح', 'Clear'),
//                               padding: EdgeInsets.zero,
//                               constraints: const BoxConstraints(),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                   TextFormField(
//                     controller: weightController,
//                     focusNode: _weightFocusNode,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
//                       prefixIcon:
//                           const Icon(Icons.scale, color: Color(0xFFD4AF37)),
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide(
//                           color: Colors.grey.shade300,
//                         ),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                         borderSide: BorderSide(
//                           color: Color(0xFFD4AF37),
//                           width: 2,
//                         ),
//                       ),
//                       suffixText: 'جم',
//                       hintText: _t('أدخل وزن القطعة', 'Enter part weight'),
//                     ),
//                     onTap: () {
//                       _weightFocusNode.requestFocus();
//                       if (weightController.text == '0.00' ||
//                           weightController.text == '0') {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           weightController.clear();
//                         });
//                       } else {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           weightController.selection = TextSelection(
//                             baseOffset: 0,
//                             extentOffset: weightController.text.length,
//                           );
//                         });
//                       }
//                     },
//                     onEditingComplete: () {
//                       _weightFocusNode.unfocus();
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return _t('يرجى إدخال الوزن', 'Please enter weight');
//                       }
//                       final weight = double.tryParse(value);
//                       if (weight == null || weight <= 0) {
//                         return _t('وزن غير صحيح', 'Invalid weight');
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: qrController,
//                     readOnly: true,
//                     focusNode: FocusNode(canRequestFocus: false),
//                     decoration: InputDecoration(
//                       labelText: useScanner
//                           ? _t("QR من الماسح", "QR from Scanner")
//                           : _t("QR عشوائي", "Random QR"),
//                       border: const OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           useScanner ? Icons.qr_code_scanner : Icons.shuffle,
//                         ),
//                         tooltip: useScanner
//                             ? _t("استخدام QR عشوائي", "Use Random QR")
//                             : _t("استخدام الماسح", "Use Scanner"),
//                         onPressed: _toggleQRMode,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return _t('يرجى إدخال الكود', 'Please enter code');
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: _pickImage,
//                       icon: const Icon(Icons.camera_alt),
//                       label: const Text('تصوير صورة'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFD4AF37),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (_selectedImage != null) ...[
//                     const SizedBox(height: 16),
//                     Center(
//                       child: SizedBox(
//                         height: 200,
//                         child: Image.file(
//                           _selectedImage!,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Center(
//                       child: OutlinedButton.icon(
//                         onPressed: () {
//                           setState(() {
//                             _pinImage = !_pinImage;
//                           });
//                         },
//                         icon: Icon(
//                           _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
//                           color: _pinImage ? Colors.orange : null,
//                         ),
//                         label: Text(
//                           _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(
//                             color: _pinImage ? Colors.orange : Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: (_isConverting || _isPrinting)
//                               ? null
//                               : () async {
//                                   if (_itemFormKey.currentState?.validate() ??
//                                       false) {
//                                     final weight = weightController.text;
//                                     final qrCode = qrController.text.trim();

//                                     await _printConvertedItemLabel(
//                                       name: componentName,
//                                       weight: weight,
//                                       qrCode: qrCode,
//                                     );

//                                     if (!_isPrimaryScanner) {
//                                       setState(() {
//                                         _showManualEpcField = true;
//                                         _manualEpcController.clear();
//                                       });
//                                       WidgetsBinding.instance
//                                           .addPostFrameCallback((_) {
//                                         if (mounted) {
//                                           FocusScope.of(context)
//                                               .requestFocus(_manualEpcFocus);
//                                         }
//                                       });
//                                     }
//                                   }
//                                 },
//                           icon: _isPrinting
//                               ? const SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : const Icon(Icons.print),
//                           label: Text(
//                             _isPrinting
//                                 ? _t('جاري الطباعة...', 'Printing...')
//                                 : _t('طباعة ليبل الذهب', 'Print Gold Label'),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _isPrinterConnected
//                                 ? const Color(0xFFD4AF37)
//                                 : Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             side: const BorderSide(color: Color(0xFFD4AF37)),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           onPressed: () => _showProfilePicker('gold'),
//                           child: const Icon(
//                             Icons.settings,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   if (!_isPrimaryScanner && _showManualEpcField) ...[
//                     TextField(
//                       controller: _manualEpcController,
//                       focusNode: _manualEpcFocus,
//                       textCapitalization: TextCapitalization.characters,
//                       textInputAction: TextInputAction.done,
//                       decoration: const InputDecoration(
//                         labelText: 'أدخل رقم الشريحة',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                         ),
//                         prefixIcon: Icon(Icons.nfc),
//                       ),
//                       onSubmitted: (value) {
//                         if (value.trim().isNotEmpty) {
//                           addEpcManualy(value.trim());
//                         } else {
//                           setState(() {
//                             _showManualEpcField = false;
//                             _manualEpcController.clear();
//                           });
//                           _manualEpcFocus.unfocus();
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _isConverting
//                           ? null
//                           : () async {
//                               if (_itemFormKey.currentState?.validate() ??
//                                   false) {
//                                 final weight =
//                                     double.parse(weightController.text);
//                                 final qrCode = qrController.text.trim();

//                                 if (_epcHex.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
//                                       backgroundColor: Colors.orange,
//                                     ),
//                                   );
//                                   return;
//                                 }

//                                 final itemData = {
//                                   'name': componentName,
//                                   'weight': weight,
//                                   'qrCode': qrCode,
//                                 };

//                                 await _convertSinglePartToItem(
//                                   index: index,
//                                   item: itemData,
//                                   category: category,
//                                   kitData: kitData,
//                                   kitDocId: _openKitDocId!,
//                                   uid: uid,
//                                 );
//                               }
//                             },
//                       icon: _isConverting
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(Icons.save),
//                       label: Text(
//                         _isConverting
//                             ? _t('جاري التحويل...', 'Converting...')
//                             : _t('تحويل القطعة', 'Convert Part'),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFD4AF37),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildKitItemsView(String uid) {
//     final kitData = _openKitData!;
//     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
//     final kind = payload['kind'] ?? 'طقم';
//     final category = kitData['category'] as String? ?? 'gold';

//     final originalWeight = _getOriginalWeight(kitData);
//     final soldWeight = _getSoldWeight(kitData);
//     final remainingWeight = originalWeight - soldWeight;

//     final components = _getSetComponents(kitData);
//     final items = _getRemainingItems(kitData);
//     final itemsWeight = _getRemainingItemsWeight(kitData);
//     final isFullyDistributed = _isWeightFullyDistributed(kitData);

//     if (items.isEmpty && components.isNotEmpty) {
//       final newItems = components.map((name) {
//         return {
//           'name': name,
//           'weight': 0.0,
//           'qrCode': '',
//           'createdAt': DateTime.now().toIso8601String(),
//         };
//       }).toList();

//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('setRemainders')
//           .doc(_openKitDocId)
//           .update({
//         'payload.remainingItems': newItems,
//       }).then((_) {
//         setState(() {
//           _openKitData!['payload']['remainingItems'] = newItems;
//         });
//       });

//       _openKitData!['payload']['remainingItems'] = newItems;
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("قطع $kind المتبقية", "Remaining $kind Parts")),
//         backgroundColor: const Color(0xFFD4AF37),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: _backToKits,
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '${remainingWeight.toStringAsFixed(2)} جم',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFD4AF37),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD4AF37).withOpacity(0.1),
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           '${_t('الطقم', 'Set')}: $kind',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color:
//                               isFullyDistributed ? Colors.green : Colors.orange,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           isFullyDistributed
//                               ? _t('مكتمل ✅', 'Complete ✅')
//                               : '${(remainingWeight - itemsWeight).toStringAsFixed(2)} جم متبقي',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   if (components.isNotEmpty) ...[
//                     Text(
//                       _t('مكونات الطقم:', 'Set Components:'),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Wrap(
//                       spacing: 6,
//                       runSpacing: 4,
//                       children: components.map((comp) {
//                         return Chip(
//                           label: Text(comp),
//                           backgroundColor:
//                               const Color(0xFFD4AF37).withOpacity(0.2),
//                           labelStyle: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                           ),
//                           avatar: const Icon(
//                             Icons.check_circle,
//                             size: 16,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 8),
//                   ],
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${_t('الوزن الأصلي', 'Original Weight')}: ${originalWeight.toStringAsFixed(2)} جم',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             Text(
//                               '${_t('الوزن المحول', 'Converted Weight')}: ${soldWeight.toStringAsFixed(2)} جم',
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                             Text(
//                               '${_t('الوزن المتبقي', 'Remaining Weight')}: ${remainingWeight.toStringAsFixed(2)} جم',
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (!isFullyDistributed)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               _t('تم تحويل', 'Converted'),
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             Text(
//                               '${itemsWeight.toStringAsFixed(2)} جم',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFD4AF37),
//                               ),
//                             ),
//                             Text(
//                               '${(remainingWeight - itemsWeight).toStringAsFixed(2)} جم ${_t('متبقي', 'left')}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.orange[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: items.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.inbox_outlined,
//                             size: 64,
//                             color: Colors.grey[400],
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             _t('لا توجد قطع متبقية', 'No remaining parts'),
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           if (remainingWeight > 0 && !isFullyDistributed)
//                             Text(
//                               '${_t('الوزن المتبقي', 'Remaining weight')}: ${remainingWeight.toStringAsFixed(2)} جم',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.orange[700],
//                               ),
//                             ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(8),
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         final item = items[index];
//                         final componentName = item['name'] ??
//                             (index < components.length
//                                 ? components[index]
//                                 : 'قطعة ${index + 1}');
//                         final weight =
//                             (item['weight'] as num?)?.toDouble() ?? 0;
//                         final qrCode = item['qrCode']?.toString() ?? '';

//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 8),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             side: BorderSide(
//                               color: const Color(0xFFD4AF37).withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: InkWell(
//                             onTap: () => _openItemDetails(item, index),
//                             borderRadius: BorderRadius.circular(12),
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 32,
//                                     height: 32,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFD4AF37),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         '${index + 1}',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           componentName,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         if (qrCode.isNotEmpty)
//                                           Text(
//                                             'QR: $qrCode',
//                                             style: TextStyle(
//                                               fontSize: 11,
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         '${weight.toStringAsFixed(2)} جم',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xFFD4AF37),
//                                         ),
//                                       ),
//                                       Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 14,
//                                         color: Colors.grey[400],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildKitCard({
//     required Map<String, dynamic> data,
//     required String docId,
//     required VoidCallback onOpen,
//   }) {
//     final payload = data['payload'] as Map<String, dynamic>? ?? {};
//     final category = data['category'] as String? ?? '';
//     final kind = payload['kind'] ?? 'طقم';
//     final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

//     final originalWeight = _getOriginalWeight(data);
//     final soldWeight = _getSoldWeight(data);
//     final remainingWeight = originalWeight - soldWeight;
//     final items = _getRemainingItems(data);
//     final itemsCount = items.length;
//     final isFullyDistributed = _isWeightFullyDistributed(data);
//     final components = _getSetComponents(data);

//     Color categoryColor;
//     IconData categoryIcon;
//     switch (category) {
//       case 'gold':
//         categoryColor = const Color(0xFFD4AF37);
//         categoryIcon = Icons.workspace_premium_rounded;
//         break;
//       case 'gem':
//         categoryColor = Colors.purple;
//         categoryIcon = Icons.diamond_rounded;
//         break;
//       case 'bullion':
//         categoryColor = Colors.blue;
//         categoryIcon = Icons.account_balance;
//         break;
//       default:
//         categoryColor = Colors.grey;
//         categoryIcon = Icons.help_outline_rounded;
//     }

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: categoryColor.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: InkWell(
//         onTap: onOpen,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: categoryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       categoryIcon,
//                       color: categoryColor,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           kind,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           category,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isFullyDistributed ? Colors.green : Colors.orange,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       isFullyDistributed
//                           ? _t('مكتمل', 'Complete')
//                           : '${remainingWeight.toStringAsFixed(2)} جم',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               if (components.isNotEmpty) ...[
//                 Wrap(
//                   spacing: 4,
//                   runSpacing: 4,
//                   children: components.map((comp) {
//                     return Chip(
//                       label: Text(
//                         comp,
//                         style: const TextStyle(fontSize: 11),
//                       ),
//                       backgroundColor: categoryColor.withOpacity(0.15),
//                       padding: const EdgeInsets.symmetric(horizontal: 2),
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 8),
//               ],
//               Row(
//                 children: [
//                   Icon(Icons.scale, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${originalWeight.toStringAsFixed(2)} جم',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   const SizedBox(width: 16),
//                   Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${soldWeight.toStringAsFixed(2)} جم',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   const Spacer(),
//                   Icon(Icons.grid_view, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 4),
//                   Text(
//                     '$itemsCount ${_t('قطعة', 'Parts')}',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               if (createdAt != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Icon(
//               icon,
//               size: 48,
//               color: Colors.grey.shade400,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // // import 'dart:ui' as ui;
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:uuid/uuid.dart';
// // // import 'package:qr_flutter/qr_flutter.dart';
// // // import '../services/firestore_service.dart';
// // // import '../services/seuic_uhf_service.dart';
// // // import '../services/new_printer_api.dart';
// // // import '../services/new_printer_status.dart';
// // // import 'dart:async';
// // // import 'label_layout_model.dart';
// // // import 'dart:io';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import '../utils/image_compressor.dart';

// // // class RemainingKitsPage extends StatefulWidget {
// // //   const RemainingKitsPage({super.key});

// // //   @override
// // //   State<RemainingKitsPage> createState() => _RemainingKitsPageState();
// // // }

// // // class _RemainingKitsPageState extends State<RemainingKitsPage> {
// // //   String _lang = 'ar';
// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // //   Map<String, dynamic>? _openKitData;
// // //   String? _openKitDocId;
// // //   bool _showKitItems = false;

// // //   Map<String, dynamic>? _selectedItem;
// // //   int? _selectedIndex;
// // //   bool _showItemDetails = false;

// // //   bool _isPrinting = false;
// // //   bool _isPrinterConnected = false;
// // //   String _connectedPrinterName = "غير متصلة";
// // //   String? _connectedPrinterMac;
// // //   String? _errorMessage;
// // //   String? _successMessage;
// // //   String? _progressMessage;
// // //   StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

// // //   bool _isPrimaryScanner = false;
// // //   StreamSubscription<String>? _tagSubscription;

// // //   final TextEditingController qrController = TextEditingController();
// // //   bool useScanner = false;

// // //   final TextEditingController weightController = TextEditingController();

// // //   final FocusNode _weightFocusNode = FocusNode();

// // //   String _epcHex = '';
// // //   bool _isReadFromChip = false;
// // //   bool _isReading = false;

// // //   bool _showManualEpcField = false;
// // //   final TextEditingController _manualEpcController = TextEditingController();
// // //   final FocusNode _manualEpcFocus = FocusNode();

// // //   bool _isConverting = false;
// // //   LabelProfile? _activeProfile;

// // //   final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

// // //   File? _selectedImage;
// // //   bool _pinImage = false;

// // //   // ✅ فقط إجمالي الجرامات
// // //   double _totalRemainingWeight = 0.0;
// // //   bool _isLoadingTotal = false;

// // //   // ✅ إضافة قطعة من الرصيد المعلق
// // //   bool _isAddingFromBalance = false;
// // //   final TextEditingController _newPartNameController = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //     _loadScannerMode();
// // //     _listenToPrinterStatus();
// // //     _listenToTagStream();
// // //     _loadActiveProfile();
// // //     _calculateTotalRemainingWeight();

// // //     final randomQr = const Uuid().v4().substring(0, 7);
// // //     qrController.text = randomQr;
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _tagSubscription?.cancel();
// // //     _printerStatusSubscription?.cancel();
// // //     _manualEpcController.dispose();
// // //     _manualEpcFocus.dispose();
// // //     qrController.dispose();
// // //     weightController.dispose();
// // //     _weightFocusNode.dispose();
// // //     _newPartNameController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   Future<void> _loadActiveProfile() async {
// // //     final profile = await LabelProfileStorage.loadActive('gold');
// // //     if (mounted) setState(() => _activeProfile = profile);
// // //   }

// // //   Future<void> _loadScannerMode() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final mode = prefs.getString('scannerMode');
// // //     setState(() {
// // //       _isPrimaryScanner = mode == 'primary';
// // //     });
// // //   }

// // //   void _listenToPrinterStatus() {
// // //     _printerStatusSubscription =
// // //         NewPrinterStatusListener.getStream().listen((status) {
// // //       setState(() {
// // //         _errorMessage = null;
// // //         _successMessage = null;
// // //         _progressMessage = null;

// // //         switch (status.status) {
// // //           case 'connected':
// // //             final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
// // //             _isPrinterConnected = true;
// // //             _connectedPrinterName = match?.group(1) ?? "طابعة LPAPI";
// // //             _connectedPrinterMac = match?.group(1);
// // //             _successMessage = "متصل بـ $_connectedPrinterName";
// // //             break;

// // //           case 'disconnected':
// // //             _isPrinterConnected = false;
// // //             _connectedPrinterName = "غير متصلة";
// // //             _connectedPrinterMac = null;
// // //             _errorMessage = "تم قطع الاتصال بالطابعة";
// // //             break;

// // //           case 'connecting':
// // //           case 'auto_connecting':
// // //             _progressMessage = status.message;
// // //             break;

// // //           case 'printing':
// // //           case 'progress':
// // //             _progressMessage = status.message;
// // //             _isPrinting = true;
// // //             break;

// // //           case 'success':
// // //             _successMessage = status.message;
// // //             _isPrinting = false;
// // //             break;

// // //           case 'error':
// // //             _errorMessage = status.message;
// // //             _isPrinting = false;
// // //             if (status.message.contains("قطع الاتصال") ||
// // //                 status.message.contains("غير متصلة")) {
// // //               _isPrinterConnected = false;
// // //               _connectedPrinterName = "غير متصلة";
// // //               _connectedPrinterMac = null;
// // //             }
// // //             break;

// // //           case 'initialized':
// // //             _successMessage = status.message;
// // //             break;
// // //         }
// // //       });
// // //     });
// // //   }

// // //   void _listenToTagStream() {
// // //     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
// // //       if (!mounted) return;

// // //       if (tag.length >= 24) {
// // //         final exists = await FS.checkItemExists(tag.toUpperCase());
// // //         if (exists) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text(_t('⚠️ هذه الشريحة مسجلة من قبل',
// // //                   '⚠️ This tag is already registered')),
// // //               backgroundColor: Colors.red,
// // //             ),
// // //           );
// // //           return;
// // //         }

// // //         setState(() {
// // //           _epcHex = tag.toUpperCase();
// // //           _isReadFromChip = true;
// // //           _isReading = false;
// // //         });

// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Row(
// // //               children: [
// // //                 const Icon(Icons.nfc, color: Colors.white),
// // //                 const SizedBox(width: 12),
// // //                 Expanded(
// // //                   child: Text(
// // //                     '${_t('تم قراءة الشريحة:', 'Tag read:')} ${tag.substring(0, tag.length > 20 ? 20 : tag.length)}...',
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             backgroundColor: const Color(0xFFD4AF37),
// // //             behavior: SnackBarBehavior.floating,
// // //             shape:
// // //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //             duration: const Duration(seconds: 2),
// // //           ),
// // //         );
// // //       } else {
// // //         if (!_isPrimaryScanner) {
// // //           setState(() {
// // //             _manualEpcController.text = tag;
// // //             _showManualEpcField = true;
// // //           });

// // //           WidgetsBinding.instance.addPostFrameCallback((_) {
// // //             if (mounted) {
// // //               FocusScope.of(context).requestFocus(_manualEpcFocus);
// // //             }
// // //           });
// // //         }
// // //       }
// // //     });
// // //   }

// // //   void _clearEpc() {
// // //     setState(() {
// // //       _epcHex = '';
// // //       _isReadFromChip = false;
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //     });
// // //   }

// // //   void addEpcManualy(String Epc) {
// // //     SeuicUhfService.addEpcManualy(Epc);
// // //     setState(() {
// // //       _epcHex = Epc.toUpperCase();
// // //       _isReadFromChip = true;
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //     });
// // //     _manualEpcFocus.unfocus();
// // //     FocusScope.of(context).unfocus();
// // //   }

// // //   void _toggleQRMode() {
// // //     setState(() {
// // //       useScanner = !useScanner;
// // //       if (!useScanner) {
// // //         qrController.text = const Uuid().v4().substring(0, 7);
// // //       } else {
// // //         qrController.clear();
// // //       }
// // //     });
// // //   }

// // //   Future<void> _selectAndConnectPrinter() async {
// // //     _clearMessages();
// // //     try {
// // //       final printers = await NewPrinterAPI.getBluetoothPrinters();
// // //       if (printers.isEmpty) {
// // //         setState(() {
// // //           _errorMessage = "لا توجد طابعات LPAPI في النطاق";
// // //         });
// // //         return;
// // //       }

// // //       final selectedMac = await showDialog<String>(
// // //         context: context,
// // //         builder: (ctx) => AlertDialog(
// // //           title: const Text("اختر طابعة LPAPI"),
// // //           content: SizedBox(
// // //             width: double.maxFinite,
// // //             height: 300,
// // //             child: ListView.builder(
// // //               itemCount: printers.length,
// // //               itemBuilder: (context, i) {
// // //                 final name = printers[i]["name"] ?? "طابعة LPAPI";
// // //                 final addr = printers[i]["address"] ?? "";
// // //                 final isCurrent = addr == _connectedPrinterMac;
// // //                 return ListTile(
// // //                   leading: Icon(
// // //                     Icons.print,
// // //                     color: isCurrent ? Colors.green : const Color(0xFFD4AF37),
// // //                   ),
// // //                   title: Text(name,
// // //                       style: TextStyle(
// // //                           fontWeight:
// // //                               isCurrent ? FontWeight.bold : FontWeight.normal)),
// // //                   subtitle: Text(addr),
// // //                   trailing: isCurrent
// // //                       ? const Icon(Icons.check_circle, color: Colors.green)
// // //                       : null,
// // //                   onTap: () => Navigator.pop(ctx, addr),
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //                 onPressed: () => Navigator.pop(ctx),
// // //                 child: const Text("إلغاء")),
// // //           ],
// // //         ),
// // //       );

// // //       if (selectedMac != null) {
// // //         final selectedDevice = printers.firstWhere(
// // //           (printer) => printer["address"] == selectedMac,
// // //           orElse: () => {"name": "طابعة LPAPI", "address": selectedMac},
// // //         );
// // //         setState(() {
// // //           _progressMessage = "جاري الاتصال...";
// // //           _connectedPrinterMac = selectedMac;
// // //           _connectedPrinterName = selectedDevice["name"] ?? selectedMac;
// // //         });

// // //         final success = await NewPrinterAPI.connectBluetooth(selectedMac);
// // //         if (success) {
// // //           setState(() {
// // //             _isPrinterConnected = true;
// // //             _successMessage = null;
// // //             _progressMessage = null;
// // //           });
// // //         } else {
// // //           setState(() {
// // //             _errorMessage = "فشل الاتصال، تأكد من تشغيل الطابعة";
// // //             _progressMessage = null;
// // //             _isPrinterConnected = false;
// // //             _connectedPrinterName = "غير متصلة";
// // //             _connectedPrinterMac = null;
// // //           });
// // //         }
// // //       }
// // //     } catch (e) {
// // //       setState(() =>
// // //           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
// // //     }
// // //   }

// // //   Future<void> _disconnectPrinter() async {
// // //     await NewPrinterAPI.disconnect();
// // //   }

// // //   void _clearMessages() {
// // //     setState(() {
// // //       _errorMessage = null;
// // //       _successMessage = null;
// // //       _progressMessage = null;
// // //     });
// // //   }

// // //   Future<String?> _getKitImageUrl(String epcHex) async {
// // //     try {
// // //       final uid = FirebaseAuth.instance.currentUser!.uid;
// // //       final docSnapshot = await FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(uid)
// // //           .collection('items')
// // //           .doc(epcHex)
// // //           .get();

// // //       if (docSnapshot.exists) {
// // //         final data = docSnapshot.data();
// // //         final images = data?['images'] as List<dynamic>?;
// // //         if (images != null && images.isNotEmpty) {
// // //           return images.first.toString();
// // //         }
// // //       }
// // //       return null;
// // //     } catch (e) {
// // //       print('Error getting kit image: $e');
// // //       return null;
// // //     }
// // //   }

// // //   Future<void> _printConvertedItemLabel({
// // //     required String name,
// // //     required String weight,
// // //     required String qrCode,
// // //   }) async {
// // //     if (!_isPrinterConnected) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text('⚠️ الطابعة غير متصلة، يرجى الاتصال أولاً'),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     setState(() => _isPrinting = true);

// // //     try {
// // //       if (_activeProfile != null) {
// // //         await LabelLayoutStorage.save(_activeProfile!.layout);
// // //       }

// // //       final layout = await LabelLayoutStorage.load('gold');
// // //       final prefs = await SharedPreferences.getInstance();
// // //       final String? logoBase64 = prefs.getString('custom_logo_base64');

// // //       final success = await NewPrinterAPI.printGoldLabel(
// // //         weight: weight.trim().isEmpty ? null : weight.trim(),
// // //         carat: null,
// // //         size: null,
// // //         showQr: "true",
// // //         qrCode: qrCode.trim(),
// // //         customLogoBase64: logoBase64,
// // //         labelLayout: layout.toJson(),
// // //       );

// // //       if (success) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text("✅ تمت طباعة ليبل القطعة بنجاح"),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       print('Print error: $e');
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('❌ فشل الطباعة: ${e.toString()}'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     } finally {
// // //       setState(() => _isPrinting = false);
// // //     }
// // //   }

// // //   Future<void> _uploadImage(String epcHex) async {
// // //     if (_selectedImage == null) return;

// // //     try {
// // //       final uid = FirebaseAuth.instance.currentUser!.uid;

// // //       final compressed = await compressImage(_selectedImage!);
// // //       if (compressed == null) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text('❌ فشل ضغط الصورة')),
// // //         );
// // //         return;
// // //       }

// // //       final storageRef = FirebaseStorage.instance
// // //           .ref()
// // //           .child('images')
// // //           .child('users')
// // //           .child(uid)
// // //           .child(epcHex)
// // //           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

// // //       final metadata = SettableMetadata(
// // //         contentType: 'image/jpeg',
// // //         cacheControl: 'public,max-age=300',
// // //       );

// // //       await storageRef.putFile(compressed, metadata);
// // //       final url = await storageRef.getDownloadURL();

// // //       await FS.uploadImage(epcHex, {
// // //         'images': FieldValue.arrayUnion([url]),
// // //       });

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text('✅ تم رفع الصورة بنجاح')),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('❌ فشل رفع الصورة: $e')),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _showProfilePicker(String labelType) async {
// // //     final profiles = await LabelProfileStorage.loadAll(labelType);

// // //     if (!mounted) return;

// // //     if (profiles.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //           content: Text(
// // //               'لا يوجد ملفات محفوظة — اذهب لمحرر التخطيط وأضف ملفاً أولاً'),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     await showModalBottomSheet(
// // //       context: context,
// // //       isScrollControlled: true,
// // //       backgroundColor: Colors.transparent,
// // //       builder: (_) => Directionality(
// // //         textDirection: ui.TextDirection.rtl,
// // //         child: Container(
// // //           constraints: BoxConstraints(
// // //             maxHeight: MediaQuery.of(context).size.height * 0.6,
// // //           ),
// // //           decoration: const BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// // //           ),
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               Container(
// // //                 margin: const EdgeInsets.symmetric(vertical: 10),
// // //                 width: 40,
// // //                 height: 4,
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.grey.shade300,
// // //                   borderRadius: BorderRadius.circular(2),
// // //                 ),
// // //               ),
// // //               Padding(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // //                 child: Row(
// // //                   children: [
// // //                     const Icon(Icons.style_outlined, color: Color(0xFFD4AF37)),
// // //                     const SizedBox(width: 8),
// // //                     const Text(
// // //                       'اختر إعدادات الطباعة',
// // //                       style:
// // //                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const Divider(height: 1),
// // //               Flexible(
// // //                 child: ListView.separated(
// // //                   shrinkWrap: true,
// // //                   padding: const EdgeInsets.symmetric(vertical: 8),
// // //                   itemCount: profiles.length,
// // //                   separatorBuilder: (_, __) =>
// // //                       const Divider(height: 1, indent: 16),
// // //                   itemBuilder: (_, i) {
// // //                     final p = profiles[i];
// // //                     final isActive = _activeProfile?.id == p.id;
// // //                     return ListTile(
// // //                       leading: CircleAvatar(
// // //                         backgroundColor: isActive
// // //                             ? const Color(0xFFD4AF37)
// // //                             : const Color(0xFFD4AF37).withOpacity(0.12),
// // //                         child: Icon(
// // //                           Icons.description_outlined,
// // //                           color:
// // //                               isActive ? Colors.white : const Color(0xFFD4AF37),
// // //                         ),
// // //                       ),
// // //                       title: Text(
// // //                         p.name,
// // //                         style: TextStyle(
// // //                           fontWeight: FontWeight.bold,
// // //                           color: isActive ? const Color(0xFFD4AF37) : null,
// // //                         ),
// // //                       ),
// // //                       subtitle: Text(
// // //                         '${p.layout.stickerW.toStringAsFixed(0)}×'
// // //                         '${p.layout.stickerH.toStringAsFixed(0)} مم  •  '
// // //                         'كثافة ${p.layout.density}',
// // //                         style: const TextStyle(fontSize: 11),
// // //                       ),
// // //                       trailing: isActive
// // //                           ? const Icon(Icons.check_circle,
// // //                               color: Color(0xFFD4AF37))
// // //                           : null,
// // //                       onTap: () {
// // //                         setState(() => _activeProfile = p);
// // //                         LabelProfileStorage.saveActive('gold', p.id);
// // //                         Navigator.pop(context);
// // //                         ScaffoldMessenger.of(context).showSnackBar(
// // //                           SnackBar(
// // //                             content: Text('✅ تم تفعيل "${p.name}"'),
// // //                             backgroundColor: Colors.green,
// // //                             duration: const Duration(seconds: 2),
// // //                           ),
// // //                         );
// // //                       },
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   double _getRemainingWeight(Map<String, dynamic> kitData) {
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// // //         (payload['weight'] as num?)?.toDouble() ??
// // //         0;
// // //     final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// // //     return originalWeight - soldWeight;
// // //   }

// // //   double _getRemainingItemsWeight(Map<String, dynamic> kitData) {
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final items = payload['remainingItems'] as List<dynamic>? ?? [];
// // //     double total = 0;
// // //     for (var item in items) {
// // //       total += (item['weight'] as num?)?.toDouble() ?? 0;
// // //     }
// // //     return total;
// // //   }

// // //   bool _isWeightFullyDistributed(Map<String, dynamic> kitData) {
// // //     final remainingWeight = _getRemainingWeight(kitData);
// // //     final itemsWeight = _getRemainingItemsWeight(kitData);
// // //     return (remainingWeight - itemsWeight).abs() < 0.001;
// // //   }

// // //   double _getOriginalWeight(Map<String, dynamic> kitData) {
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     return (payload['originalWeight'] as num?)?.toDouble() ??
// // //         (payload['weight'] as num?)?.toDouble() ??
// // //         0;
// // //   }

// // //   double _getSoldWeight(Map<String, dynamic> kitData) {
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     return (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// // //   }

// // //   List<String> _getSetComponents(Map<String, dynamic> kitData) {
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final components = payload['setComponents'] as List<dynamic>? ?? [];
// // //     return components.map((e) => e.toString()).toList();
// // //   }

// // //   List<Map<String, dynamic>> _getRemainingItems(Map<String, dynamic> kitData) {
// // //     if (kitData['payload'] == null) return [];

// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final items = payload['remainingItems'] as List<dynamic>? ?? [];

// // //     return items.map((e) => Map<String, dynamic>.from(e)).toList();
// // //   }

// // //   // ✅ دالة حساب إجمالي الجرامات المتبقية فقط
// // //   Future<void> _calculateTotalRemainingWeight() async {
// // //     final uid = FirebaseAuth.instance.currentUser?.uid;
// // //     if (uid == null) return;

// // //     setState(() => _isLoadingTotal = true);

// // //     try {
// // //       final snapshot = await FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(uid)
// // //           .collection('setRemainders')
// // //           .get();

// // //       double totalWeight = 0.0;

// // //       for (var doc in snapshot.docs) {
// // //         final data = doc.data();
// // //         final payload = data['payload'] as Map<String, dynamic>? ?? {};
// // //         final originalWeight =
// // //             (payload['originalWeight'] as num?)?.toDouble() ??
// // //                 (payload['weight'] as num?)?.toDouble() ??
// // //                 0;
// // //         final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// // //         final remainingWeight = originalWeight - soldWeight;
// // //         totalWeight += remainingWeight;
// // //       }

// // //       setState(() {
// // //         _totalRemainingWeight = totalWeight;
// // //         _isLoadingTotal = false;
// // //       });
// // //     } catch (e) {
// // //       print('Error calculating total: $e');
// // //       setState(() => _isLoadingTotal = false);
// // //     }
// // //   }

// // //   void _openKit(Map<String, dynamic> kitData, String docId) {
// // //     setState(() {
// // //       _openKitData = kitData;
// // //       _openKitDocId = docId;
// // //       _showKitItems = true;
// // //       _selectedItem = null;
// // //       _selectedIndex = null;
// // //       _showItemDetails = false;
// // //       _isAddingFromBalance = false;
// // //       _newPartNameController.clear();
// // //       _clearEpc();
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //       _selectedImage = null;
// // //       _pinImage = false;
// // //     });
// // //   }

// // //   void _backToKits() {
// // //     setState(() {
// // //       _openKitData = null;
// // //       _openKitDocId = null;
// // //       _showKitItems = false;
// // //       _selectedItem = null;
// // //       _selectedIndex = null;
// // //       _showItemDetails = false;
// // //       _isAddingFromBalance = false;
// // //       _newPartNameController.clear();
// // //       _clearEpc();
// // //       _selectedImage = null;
// // //       _pinImage = false;
// // //     });
// // //     _calculateTotalRemainingWeight();
// // //   }

// // //   void _resetFormState() {
// // //     weightController.clear();
// // //     qrController.text = const Uuid().v4().substring(0, 7);
// // //     _clearEpc();
// // //     _showManualEpcField = false;
// // //     _manualEpcController.clear();
// // //     if (!_pinImage) {
// // //       _selectedImage = null;
// // //     }
// // //     _itemFormKey.currentState?.reset();
// // //   }

// // //   void _openItemDetails(Map<String, dynamic> item, int index) {
// // //     weightController.text =
// // //         (item['weight'] as num?)?.toStringAsFixed(2) ?? '0.00';

// // //     setState(() {
// // //       _selectedItem = item;
// // //       _selectedIndex = index;
// // //       _showItemDetails = true;
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //       _clearEpc();
// // //       _selectedImage = null;
// // //       _pinImage = false;
// // //     });

// // //     _itemFormKey.currentState?.reset();
// // //   }

// // //   void _backToItemsList() {
// // //     setState(() {
// // //       _selectedItem = null;
// // //       _selectedIndex = null;
// // //       _showItemDetails = false;
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //       _clearEpc();
// // //       if (!_pinImage) {
// // //         _selectedImage = null;
// // //       }
// // //     });
// // //     _resetFormState();
// // //   }

// // //   Future<void> _pickImage() async {
// // //     FocusScope.of(context).unfocus();

// // //     final picker = ImagePicker();
// // //     final xFile = await picker.pickImage(source: ImageSource.camera);

// // //     if (xFile != null) {
// // //       setState(() {
// // //         _selectedImage = File(xFile.path);
// // //       });
// // //     }
// // //   }

// // //   // ✅ ميثود مساعدة لفتح فورم الإضافة من الرصيد
// // //   void _openAddFromBalanceForm() {
// // //     setState(() {
// // //       _isAddingFromBalance = true;
// // //       _newPartNameController.clear();
// // //       weightController.clear();
// // //       qrController.text = const Uuid().v4().substring(0, 7);
// // //       _clearEpc();
// // //       _selectedImage = null;
// // //       _pinImage = false;
// // //       _showManualEpcField = false;
// // //       _manualEpcController.clear();
// // //     });
// // //     _itemFormKey.currentState?.reset();
// // //   }

// // //   Future<void> _convertSinglePartToItem({
// // //     required int index,
// // //     required Map<String, dynamic> item,
// // //     required String category,
// // //     required Map<String, dynamic> kitData,
// // //     required String kitDocId,
// // //     required String uid,
// // //   }) async {
// // //     try {
// // //       setState(() => _isConverting = true);

// // //       final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});
// // //       final items = List<dynamic>.from(payload['remainingItems'] ?? []);

// // //       if (index >= items.length) {
// // //         throw Exception('القطعة غير موجودة في الطقم');
// // //       }

// // //       final removedItem = items.removeAt(index);

// // //       final weight = (item['weight'] as num?)?.toDouble() ??
// // //           (removedItem['weight'] as num?)?.toDouble() ??
// // //           0;

// // //       final qrCode = item['qrCode']?.toString() ??
// // //           removedItem['qrCode']?.toString() ??
// // //           const Uuid().v4().substring(0, 7);

// // //       final epcHex = _epcHex.isNotEmpty
// // //           ? _epcHex
// // //           : (kitData['epcHex']?.toString() ??
// // //               payload['epcHex']?.toString() ??
// // //               qrCode);

// // //       final componentName =
// // //           item['name']?.toString() ?? removedItem['name']?.toString() ?? 'قطعة';

// // //       final kitImageUrl = await _getKitImageUrl(epcHex);

// // //       final newPayload = {
// // //         'weight': weight,
// // //         'qrCode': qrCode,
// // //         'kind': componentName,
// // //         'isFromKit': true,
// // //         'kitDocId': kitDocId,
// // //         'originalKitWeight': payload['originalWeight'] ?? payload['weight'],
// // //         'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
// // //         'notes': 'تم التحويل من طقم ${payload['kind'] ?? ''}',
// // //         'carat': payload['carat'] ?? '21',
// // //         'size': payload['size'] ?? '0',
// // //         'wage': payload['wage'] ?? 0,
// // //         'showQr': true,
// // //         'images': kitImageUrl != null ? [kitImageUrl] : [],
// // //       };

// // //       await FS.saveItem(
// // //         epcHex: epcHex,
// // //         category: category,
// // //         date: DateTime.now(),
// // //         payload: newPayload,
// // //         fromOpeningBalance: false,
// // //       );

// // //       if (_selectedImage != null) {
// // //         await _uploadImage(epcHex);
// // //       }

// // //       if (kitImageUrl != null) {
// // //         await FS.uploadImage(epcHex, {
// // //           'images': FieldValue.arrayUnion([kitImageUrl]),
// // //         });
// // //       }

// // //       final currentSoldWeight =
// // //           (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// // //       final newSoldWeight = currentSoldWeight + weight;
// // //       final currentComponents =
// // //           List<String>.from(payload['setComponents'] ?? []);

// // //       // ✅ الحل: احفظ الشرط قبل الحذف
// // //       final bool componentExists = index < currentComponents.length;

// // //       final updateData = {
// // //         'payload.remainingItems': items,
// // //         'payload.soldWeight': newSoldWeight,
// // //         'updatedAt': FieldValue.serverTimestamp(),
// // //       };

// // //       if (componentExists) {
// // //         currentComponents.removeAt(index);
// // //         updateData['payload.setComponents'] = currentComponents;
// // //       }

// // //       await FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(uid)
// // //           .collection('setRemainders')
// // //           .doc(kitDocId)
// // //           .update(updateData);

// // //       setState(() {
// // //         _openKitData!['payload']['remainingItems'] = items;
// // //         _openKitData!['payload']['soldWeight'] = newSoldWeight;
// // //         // ✅ استخدم نفس المتغير عشان مايتغيرش بعد الحذف
// // //         if (componentExists) {
// // //           _openKitData!['payload']['setComponents'] = currentComponents;
// // //         }
// // //       });

// // //       // ============================================================
// // //       // ✅ حساب الرصيد المعلق المتبقي
// // //       // ============================================================
// // //       final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// // //           (payload['weight'] as num?)?.toDouble() ??
// // //           0;

// // //       double remainingItemsWeight = 0;
// // //       for (var it in items) {
// // //         remainingItemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
// // //       }

// // //       final pendingBalance =
// // //           originalWeight - newSoldWeight - remainingItemsWeight;

// // //       // ============================================================
// // //       // ✅ القرار: نحذف الطقم ولا لأ؟
// // //       // ============================================================

// // //       // الحالة 1: مفيش قطع + مفيش رصيد معلق → احذف الطقم
// // //       if (items.isEmpty && pendingBalance <= 0.001) {
// // //         await FirebaseFirestore.instance
// // //             .collection('users')
// // //             .doc(uid)
// // //             .collection('setRemainders')
// // //             .doc(kitDocId)
// // //             .delete();

// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content:
// // //                   Text('✅ تم تحويل جميع القطع واكتمل الرصيد — تم حذف الطقم'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //           await _calculateTotalRemainingWeight();
// // //           _backToKits();
// // //         }
// // //       }
// // //       // الحالة 2: مفيش قطع بس لسه فيه رصيد معلق → متحذفش الطقم
// // //       else if (items.isEmpty && pendingBalance > 0.001) {
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text(
// // //                   '✅ تم تحويل "$componentName" — الرصيد المعلق: ${pendingBalance.toStringAsFixed(2)} جم. استخدم زر "إضافة قطعة من الرصيد" لتوزيعه.'),
// // //               backgroundColor: Colors.green,
// // //               duration: const Duration(seconds: 4),
// // //             ),
// // //           );
// // //           await _calculateTotalRemainingWeight();
// // //           _backToItemsList();
// // //           setState(() {});
// // //         }
// // //       }
// // //       // الحالة 3: لسه فيه قطع متبقية
// // //       else {
// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text(
// // //                   '✅ تم تحويل القطعة "$componentName" بنجاح (متبقي ${items.length} قطع)'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //           await _calculateTotalRemainingWeight();
// // //           _backToItemsList();
// // //           setState(() {});
// // //         }
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(
// // //                 '${_t('فشل التحويل', 'Failed to convert')}: ${e.toString()}'),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       setState(() => _isConverting = false);
// // //     }
// // //   }

// // //   // ============================================================
// // //   // ✅ إضافة قطعة جديدة من الرصيد المعلق
// // //   // ============================================================
// // //   Future<void> _addPartFromBalance({
// // //     required String name,
// // //     required double weight,
// // //     required String qrCode,
// // //     required String category,
// // //     required String uid,
// // //   }) async {
// // //     try {
// // //       setState(() => _isConverting = true);

// // //       final kitData = _openKitData!;
// // //       final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});

// // //       final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// // //           (payload['weight'] as num?)?.toDouble() ??
// // //           0;
// // //       final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// // //       final items = List<dynamic>.from(payload['remainingItems'] ?? []);
// // //       double itemsWeight = 0;
// // //       for (var it in items) {
// // //         itemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
// // //       }
// // //       final pending = originalWeight - soldWeight - itemsWeight;

// // //       if (weight > pending + 0.001) {
// // //         throw Exception('الوزن أكبر من الرصيد المتاح');
// // //       }

// // //       final epcHex = _epcHex.isNotEmpty ? _epcHex : qrCode;

// // //       // 1) حفظ القطعة كـ item مستقل
// // //       final newPayload = {
// // //         'weight': weight,
// // //         'qrCode': qrCode,
// // //         'kind': name,
// // //         'isFromKit': true,
// // //         'kitDocId': _openKitDocId,
// // //         'originalKitWeight': originalWeight,
// // //         'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
// // //         'notes': 'أُضيفت من الرصيد المعلق للطقم ${payload['kind'] ?? ''}',
// // //         'carat': payload['carat'] ?? '21',
// // //         'size': payload['size'] ?? '0',
// // //         'wage': payload['wage'] ?? 0,
// // //         'showQr': true,
// // //         'images': [],
// // //       };

// // //       await FS.saveItem(
// // //         epcHex: epcHex,
// // //         category: category,
// // //         date: DateTime.now(),
// // //         payload: newPayload,
// // //         fromOpeningBalance: false,
// // //       );

// // //       if (_selectedImage != null) {
// // //         await _uploadImage(epcHex);
// // //       }

// // //       // 2) تحديث الرصيد — نزيد soldWeight (يقلل pending)
// // //       final newSoldWeight = soldWeight + weight;
// // //       final newPending = originalWeight - newSoldWeight - itemsWeight;

// // //       if (newPending <= 0.001) {
// // //         // ✅ الرصيد خلص → امسح الطقم بالكامل
// // //         await FirebaseFirestore.instance
// // //             .collection('users')
// // //             .doc(uid)
// // //             .collection('setRemainders')
// // //             .doc(_openKitDocId)
// // //             .delete();

// // //         if (mounted) {
// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             const SnackBar(
// // //               content:
// // //                   Text('✅ تم حفظ القطعة واكتمل توزيع الرصيد — تم حذف الطقم'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //           await _calculateTotalRemainingWeight();
// // //           _backToKits();
// // //         }
// // //       } else {
// // //         // لسه فيه رصيد → حدّث الطقم وارجع لصفحة الطقم
// // //         await FirebaseFirestore.instance
// // //             .collection('users')
// // //             .doc(uid)
// // //             .collection('setRemainders')
// // //             .doc(_openKitDocId)
// // //             .update({
// // //           'payload.soldWeight': newSoldWeight,
// // //           'updatedAt': FieldValue.serverTimestamp(),
// // //         });

// // //         if (mounted) {
// // //           setState(() {
// // //             _openKitData!['payload']['soldWeight'] = newSoldWeight;
// // //             _isAddingFromBalance = false;
// // //             _newPartNameController.clear();
// // //             weightController.clear();
// // //             qrController.text = const Uuid().v4().substring(0, 7);
// // //             _clearEpc();
// // //             _selectedImage = null;
// // //             _pinImage = false;
// // //           });

// // //           ScaffoldMessenger.of(context).showSnackBar(
// // //             SnackBar(
// // //               content: Text(
// // //                   '✅ تم حفظ "$name" — الرصيد المتبقي: ${newPending.toStringAsFixed(2)} جم'),
// // //               backgroundColor: Colors.green,
// // //             ),
// // //           );
// // //           await _calculateTotalRemainingWeight();
// // //         }
// // //       }
// // //     } catch (e) {
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text('${_t('فشل الحفظ', 'Failed')}: $e'),
// // //             backgroundColor: Colors.red,
// // //           ),
// // //         );
// // //       }
// // //     } finally {
// // //       if (mounted) setState(() => _isConverting = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final theme = Theme.of(context);
// // //     final uid = FirebaseAuth.instance.currentUser?.uid;

// // //     if (uid == null) {
// // //       return Scaffold(
// // //         appBar: AppBar(
// // //           title: Text(_t("بقايا الاطقم", "Remaining Kits")),
// // //           backgroundColor: const Color(0xFFD4AF37),
// // //         ),
// // //         body: Center(
// // //           child: Text(
// // //             _t('يرجى تسجيل الدخول أولاً', 'Please login first'),
// // //             style: const TextStyle(fontSize: 18),
// // //           ),
// // //         ),
// // //       );
// // //     }

// // //     if (_showKitItems && _openKitData != null) {
// // //       if (_isAddingFromBalance) {
// // //         return _buildAddFromBalanceView(uid);
// // //       }
// // //       if (_showItemDetails && _selectedItem != null) {
// // //         return _buildItemDetailsView(uid);
// // //       }
// // //       return _buildKitItemsView(uid);
// // //     }

// // //     Query q = FirebaseFirestore.instance
// // //         .collection('users')
// // //         .doc(uid)
// // //         .collection('setRemainders')
// // //         .orderBy('createdAt', descending: true);

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(_t("بقايا الاطقم", "Remaining Kits")),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.refresh),
// // //             onPressed: () {
// // //               _calculateTotalRemainingWeight();
// // //               setState(() {});
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //       body: Container(
// // //         margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// // //         decoration: BoxDecoration(
// // //           color: theme.colorScheme.surface,
// // //           borderRadius: BorderRadius.circular(20),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.05),
// // //               blurRadius: 10,
// // //               offset: const Offset(0, 2),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             // ✅ عرض إجمالي الجرامات فقط
// // //             Container(
// // //               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [
// // //                     Color(0xFFD4AF37),
// // //                     Color(0xFFB8860B),
// // //                   ],
// // //                   begin: Alignment.centerLeft,
// // //                   end: Alignment.centerRight,
// // //                 ),
// // //                 borderRadius: const BorderRadius.vertical(
// // //                   top: Radius.circular(20),
// // //                 ),
// // //               ),
// // //               child: _isLoadingTotal
// // //                   ? const Center(
// // //                       child: SizedBox(
// // //                         height: 20,
// // //                         width: 20,
// // //                         child: CircularProgressIndicator(
// // //                           strokeWidth: 2,
// // //                           valueColor:
// // //                               AlwaysStoppedAnimation<Color>(Colors.white),
// // //                         ),
// // //                       ),
// // //                     )
// // //                   : Row(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Container(
// // //                           padding: const EdgeInsets.all(10),
// // //                           decoration: BoxDecoration(
// // //                             color: Colors.white.withOpacity(0.2),
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           child: const Icon(
// // //                             Icons.scale,
// // //                             color: Colors.white,
// // //                             size: 24,
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 16),
// // //                         Directionality(
// // //                           textDirection: ui.TextDirection.rtl,
// // //                           child: Row(
// // //                             crossAxisAlignment: CrossAxisAlignment.center,
// // //                             children: [
// // //                               Text(
// // //                                 _t('إجمالي الجرامات المعلقه',
// // //                                     'Total Remaining Weight'),
// // //                                 style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontSize: 15,
// // //                                 ),
// // //                               ),
// // //                               Container(
// // //                                 margin:
// // //                                     const EdgeInsets.symmetric(horizontal: 8),
// // //                                 width: 2,
// // //                                 height: 25,
// // //                                 color: const ui.Color.fromARGB(255, 28, 27, 27),
// // //                               ),
// // //                               Text(
// // //                                 '${_totalRemainingWeight.toStringAsFixed(2)}',
// // //                                 style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   fontSize: 20,
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(width: 4),
// // //                               Text(
// // //                                 _t('جم', 'g'),
// // //                                 style: const TextStyle(
// // //                                   color: Colors.white70,
// // //                                   fontSize: 14,
// // //                                   fontWeight: FontWeight.w500,
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //             ),
// // //             Expanded(
// // //               child: StreamBuilder<QuerySnapshot>(
// // //                 stream: q.snapshots(),
// // //                 builder: (ctx, snap) {
// // //                   if (!snap.hasData) {
// // //                     return const Center(child: CircularProgressIndicator());
// // //                   }

// // //                   final docs = snap.data!.docs;
// // //                   if (docs.isEmpty) {
// // //                     return _buildEmptyState(
// // //                       icon: Icons.inventory_2_outlined,
// // //                       title: _t('لا يوجد بقايا أطقم', 'No Set Remainders'),
// // //                       subtitle: _t('لم يتم تسجيل أي بيع جزئي للأطقم',
// // //                           'No partial set sales recorded'),
// // //                     );
// // //                   }

// // //                   return ListView(
// // //                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
// // //                     children: [
// // //                       ...docs.map((doc) {
// // //                         final data = doc.data() as Map<String, dynamic>;
// // //                         return _buildKitCard(
// // //                           data: data,
// // //                           docId: doc.id,
// // //                           onOpen: () => _openKit(data, doc.id),
// // //                         );
// // //                       }),
// // //                     ],
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildItemDetailsView(String uid) {
// // //     final kitData = _openKitData!;
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final category = kitData['category'] as String? ?? 'gold';
// // //     final item = _selectedItem!;
// // //     final index = _selectedIndex!;
// // //     final components = _getSetComponents(kitData);
// // //     final componentName = item['name'] ??
// // //         (index < components.length ? components[index] : 'قطعة ${index + 1}');

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           _t('تفاصيل القطعة', 'Item Details'),
// // //           style: const TextStyle(color: Colors.white),
// // //         ),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// // //           onPressed: _backToItemsList,
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(
// // //               _isPrinterConnected ? Icons.print : Icons.print_disabled,
// // //               color: Colors.white,
// // //             ),
// // //             onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
// // //             tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
// // //           ),
// // //         ],
// // //       ),
// // //       body: Container(
// // //         margin: const EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Theme.of(context).colorScheme.surface,
// // //           borderRadius: BorderRadius.circular(20),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.05),
// // //               blurRadius: 10,
// // //               offset: const Offset(0, 2),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Form(
// // //             key: _itemFormKey,
// // //             child: SingleChildScrollView(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Container(
// // //                     padding: const EdgeInsets.all(12),
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFFD4AF37).withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Row(
// // //                       children: [
// // //                         Container(
// // //                           width: 36,
// // //                           height: 36,
// // //                           decoration: const BoxDecoration(
// // //                             color: Color(0xFFD4AF37),
// // //                             shape: BoxShape.circle,
// // //                           ),
// // //                           child: Center(
// // //                             child: Text(
// // //                               '${index + 1}',
// // //                               style: const TextStyle(
// // //                                 color: Colors.white,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 fontSize: 16,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 12),
// // //                         Expanded(
// // //                           child: Text(
// // //                             componentName,
// // //                             style: const TextStyle(
// // //                               fontSize: 20,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Color(0xFFD4AF37),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   if (_epcHex.isNotEmpty) ...[
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 12, vertical: 8),
// // //                       decoration: BoxDecoration(
// // //                         color: _isReadFromChip
// // //                             ? Colors.green.withOpacity(0.1)
// // //                             : Colors.grey.shade100,
// // //                         borderRadius: BorderRadius.circular(8),
// // //                         border: Border.all(
// // //                           color: _isReadFromChip
// // //                               ? Colors.green
// // //                               : Colors.grey.shade300,
// // //                         ),
// // //                       ),
// // //                       child: Row(
// // //                         children: [
// // //                           Icon(
// // //                             _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
// // //                             size: 16,
// // //                             color: _isReadFromChip ? Colors.green : Colors.grey,
// // //                           ),
// // //                           const SizedBox(width: 8),
// // //                           Expanded(
// // //                             child: Text(
// // //                               'EPC: $_epcHex',
// // //                               style: TextStyle(
// // //                                 fontFamily: 'monospace',
// // //                                 fontSize: 12,
// // //                                 color: _isReadFromChip
// // //                                     ? Colors.green.shade700
// // //                                     : Colors.grey,
// // //                                 fontWeight: _isReadFromChip
// // //                                     ? FontWeight.bold
// // //                                     : FontWeight.normal,
// // //                               ),
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                           ),
// // //                           if (_isReadFromChip) ...[
// // //                             const SizedBox(width: 4),
// // //                             Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                   horizontal: 8, vertical: 2),
// // //                               decoration: BoxDecoration(
// // //                                 color: Colors.green.withOpacity(0.2),
// // //                                 borderRadius: BorderRadius.circular(12),
// // //                               ),
// // //                               child: Text(
// // //                                 _t('مقروء', 'Read'),
// // //                                 style: const TextStyle(
// // //                                   color: Colors.green,
// // //                                   fontSize: 10,
// // //                                   fontWeight: FontWeight.bold,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             IconButton(
// // //                               icon: const Icon(Icons.clear, size: 16),
// // //                               onPressed: _clearEpc,
// // //                               tooltip: _t('مسح', 'Clear'),
// // //                               padding: EdgeInsets.zero,
// // //                               constraints: const BoxConstraints(),
// // //                             ),
// // //                           ],
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 12),
// // //                   ],
// // //                   TextFormField(
// // //                     controller: weightController,
// // //                     focusNode: _weightFocusNode,
// // //                     keyboardType: TextInputType.number,
// // //                     decoration: InputDecoration(
// // //                       labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
// // //                       prefixIcon:
// // //                           const Icon(Icons.scale, color: Color(0xFFD4AF37)),
// // //                       border: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                       ),
// // //                       enabledBorder: OutlineInputBorder(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         borderSide: BorderSide(
// // //                           color: Colors.grey.shade300,
// // //                         ),
// // //                       ),
// // //                       focusedBorder: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                         borderSide: BorderSide(
// // //                           color: Color(0xFFD4AF37),
// // //                           width: 2,
// // //                         ),
// // //                       ),
// // //                       suffixText: 'جم',
// // //                       hintText: _t('أدخل وزن القطعة', 'Enter part weight'),
// // //                     ),
// // //                     onTap: () {
// // //                       _weightFocusNode.requestFocus();
// // //                       if (weightController.text == '0.00' ||
// // //                           weightController.text == '0') {
// // //                         WidgetsBinding.instance.addPostFrameCallback((_) {
// // //                           weightController.clear();
// // //                         });
// // //                       } else {
// // //                         WidgetsBinding.instance.addPostFrameCallback((_) {
// // //                           weightController.selection = TextSelection(
// // //                             baseOffset: 0,
// // //                             extentOffset: weightController.text.length,
// // //                           );
// // //                         });
// // //                       }
// // //                     },
// // //                     onEditingComplete: () {
// // //                       _weightFocusNode.unfocus();
// // //                     },
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return _t('يرجى إدخال الوزن', 'Please enter weight');
// // //                       }
// // //                       final weight = double.tryParse(value);
// // //                       if (weight == null || weight <= 0) {
// // //                         return _t('وزن غير صحيح', 'Invalid weight');
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   TextFormField(
// // //                     controller: qrController,
// // //                     readOnly: true,
// // //                     focusNode: FocusNode(canRequestFocus: false),
// // //                     decoration: InputDecoration(
// // //                       labelText: useScanner
// // //                           ? _t("QR من الماسح", "QR from Scanner")
// // //                           : _t("QR عشوائي", "Random QR"),
// // //                       border: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                       ),
// // //                       suffixIcon: IconButton(
// // //                         icon: Icon(
// // //                           useScanner ? Icons.qr_code_scanner : Icons.shuffle,
// // //                         ),
// // //                         tooltip: useScanner
// // //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// // //                             : _t("استخدام الماسح", "Use Scanner"),
// // //                         onPressed: _toggleQRMode,
// // //                       ),
// // //                     ),
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return _t('يرجى إدخال الكود', 'Please enter code');
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),
// // //                   Center(
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: _pickImage,
// // //                       icon: const Icon(Icons.camera_alt),
// // //                       label: const Text('تصوير صورة'),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: const Color(0xFFD4AF37),
// // //                         foregroundColor: Colors.white,
// // //                         shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   if (_selectedImage != null) ...[
// // //                     const SizedBox(height: 16),
// // //                     Center(
// // //                       child: SizedBox(
// // //                         height: 200,
// // //                         child: Image.file(
// // //                           _selectedImage!,
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     Center(
// // //                       child: OutlinedButton.icon(
// // //                         onPressed: () {
// // //                           setState(() {
// // //                             _pinImage = !_pinImage;
// // //                           });
// // //                         },
// // //                         icon: Icon(
// // //                           _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// // //                           color: _pinImage ? Colors.orange : null,
// // //                         ),
// // //                         label: Text(
// // //                           _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// // //                         ),
// // //                         style: OutlinedButton.styleFrom(
// // //                           side: BorderSide(
// // //                             color: _pinImage ? Colors.orange : Colors.grey,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                   ],
// // //                   const SizedBox(height: 20),
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: ElevatedButton.icon(
// // //                           onPressed: (_isConverting || _isPrinting)
// // //                               ? null
// // //                               : () async {
// // //                                   if (_itemFormKey.currentState?.validate() ??
// // //                                       false) {
// // //                                     final weight = weightController.text;
// // //                                     final qrCode = qrController.text.trim();

// // //                                     await _printConvertedItemLabel(
// // //                                       name: componentName,
// // //                                       weight: weight,
// // //                                       qrCode: qrCode,
// // //                                     );

// // //                                     if (!_isPrimaryScanner) {
// // //                                       setState(() {
// // //                                         _showManualEpcField = true;
// // //                                         _manualEpcController.clear();
// // //                                       });
// // //                                       WidgetsBinding.instance
// // //                                           .addPostFrameCallback((_) {
// // //                                         if (mounted) {
// // //                                           FocusScope.of(context)
// // //                                               .requestFocus(_manualEpcFocus);
// // //                                         }
// // //                                       });
// // //                                     }
// // //                                   }
// // //                                 },
// // //                           icon: _isPrinting
// // //                               ? const SizedBox(
// // //                                   width: 20,
// // //                                   height: 20,
// // //                                   child: CircularProgressIndicator(
// // //                                     strokeWidth: 2,
// // //                                     color: Colors.white,
// // //                                   ),
// // //                                 )
// // //                               : const Icon(Icons.print),
// // //                           label: Text(
// // //                             _isPrinting
// // //                                 ? _t('جاري الطباعة...', 'Printing...')
// // //                                 : _t('طباعة ليبل الذهب', 'Print Gold Label'),
// // //                           ),
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: _isPrinterConnected
// // //                                 ? const Color(0xFFD4AF37)
// // //                                 : Colors.green,
// // //                             foregroundColor: Colors.white,
// // //                             padding: const EdgeInsets.symmetric(vertical: 14),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 8),
// // //                       SizedBox(
// // //                         width: 50,
// // //                         height: 50,
// // //                         child: OutlinedButton(
// // //                           style: OutlinedButton.styleFrom(
// // //                             padding: EdgeInsets.zero,
// // //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                           onPressed: () => _showProfilePicker('gold'),
// // //                           child: const Icon(
// // //                             Icons.settings,
// // //                             color: Color(0xFFD4AF37),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 12),
// // //                   if (!_isPrimaryScanner && _showManualEpcField) ...[
// // //                     TextField(
// // //                       controller: _manualEpcController,
// // //                       focusNode: _manualEpcFocus,
// // //                       textCapitalization: TextCapitalization.characters,
// // //                       textInputAction: TextInputAction.done,
// // //                       decoration: const InputDecoration(
// // //                         labelText: 'أدخل رقم الشريحة',
// // //                         border: OutlineInputBorder(
// // //                           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                         ),
// // //                         prefixIcon: Icon(Icons.nfc),
// // //                       ),
// // //                       onSubmitted: (value) {
// // //                         if (value.trim().isNotEmpty) {
// // //                           addEpcManualy(value.trim());
// // //                         } else {
// // //                           setState(() {
// // //                             _showManualEpcField = false;
// // //                             _manualEpcController.clear();
// // //                           });
// // //                           _manualEpcFocus.unfocus();
// // //                         }
// // //                       },
// // //                     ),
// // //                     const SizedBox(height: 12),
// // //                   ],
// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: _isConverting
// // //                           ? null
// // //                           : () async {
// // //                               if (_itemFormKey.currentState?.validate() ??
// // //                                   false) {
// // //                                 final weight =
// // //                                     double.parse(weightController.text);
// // //                                 final qrCode = qrController.text.trim();

// // //                                 if (_epcHex.isEmpty) {
// // //                                   ScaffoldMessenger.of(context).showSnackBar(
// // //                                     const SnackBar(
// // //                                       content: Text(
// // //                                           '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
// // //                                       backgroundColor: Colors.orange,
// // //                                     ),
// // //                                   );
// // //                                   return;
// // //                                 }

// // //                                 final itemData = {
// // //                                   'name': componentName,
// // //                                   'weight': weight,
// // //                                   'qrCode': qrCode,
// // //                                 };

// // //                                 await _convertSinglePartToItem(
// // //                                   index: index,
// // //                                   item: itemData,
// // //                                   category: category,
// // //                                   kitData: kitData,
// // //                                   kitDocId: _openKitDocId!,
// // //                                   uid: uid,
// // //                                 );
// // //                               }
// // //                             },
// // //                       icon: _isConverting
// // //                           ? const SizedBox(
// // //                               width: 20,
// // //                               height: 20,
// // //                               child: CircularProgressIndicator(
// // //                                 strokeWidth: 2,
// // //                                 color: Colors.white,
// // //                               ),
// // //                             )
// // //                           : const Icon(Icons.save),
// // //                       label: Text(
// // //                         _isConverting
// // //                             ? _t('جاري التحويل...', 'Converting...')
// // //                             : _t('تحويل القطعة', 'Convert Part'),
// // //                       ),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: const Color(0xFFD4AF37),
// // //                         foregroundColor: Colors.white,
// // //                         padding: const EdgeInsets.symmetric(vertical: 14),
// // //                         shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ============================================================
// // //   // ✅ فورم إضافة قطعة جديدة من الرصيد المعلق
// // //   // ============================================================
// // //   Widget _buildAddFromBalanceView(String uid) {
// // //     final kitData = _openKitData!;
// // //     final category = kitData['category'] as String? ?? 'gold';

// // //     final originalWeight = _getOriginalWeight(kitData);
// // //     final soldWeight = _getSoldWeight(kitData);
// // //     final itemsWeight = _getRemainingItemsWeight(kitData);
// // //     final pending = originalWeight - soldWeight - itemsWeight;

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           _t('إضافة قطعة من الرصيد', 'Add Part from Balance'),
// // //           style: const TextStyle(color: Colors.white),
// // //         ),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// // //           onPressed: () {
// // //             setState(() {
// // //               _isAddingFromBalance = false;
// // //               _newPartNameController.clear();
// // //               weightController.clear();
// // //               qrController.text = const Uuid().v4().substring(0, 7);
// // //               _clearEpc();
// // //               _selectedImage = null;
// // //               _pinImage = false;
// // //             });
// // //           },
// // //         ),
// // //         actions: [
// // //           IconButton(
// // //             icon: Icon(
// // //               _isPrinterConnected ? Icons.print : Icons.print_disabled,
// // //               color: Colors.white,
// // //             ),
// // //             onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
// // //             tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
// // //           ),
// // //         ],
// // //       ),
// // //       body: Container(
// // //         margin: const EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Theme.of(context).colorScheme.surface,
// // //           borderRadius: BorderRadius.circular(20),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.05),
// // //               blurRadius: 10,
// // //               offset: const Offset(0, 2),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Form(
// // //             key: _itemFormKey,
// // //             child: SingleChildScrollView(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   // بادج الرصيد المعلق المتاح
// // //                   Container(
// // //                     width: double.infinity,
// // //                     padding: const EdgeInsets.all(12),
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFFD4AF37).withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Row(
// // //                       children: [
// // //                         const Icon(Icons.account_balance_wallet,
// // //                             color: Color(0xFFD4AF37)),
// // //                         const SizedBox(width: 12),
// // //                         Expanded(
// // //                           child: Text(
// // //                             '${_t('الرصيد المعلق المتاح', 'Available pending balance')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // //                             style: const TextStyle(
// // //                               fontSize: 16,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Color(0xFFD4AF37),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 16),

// // //                   // اسم القطعة
// // //                   TextFormField(
// // //                     controller: _newPartNameController,
// // //                     decoration: InputDecoration(
// // //                       labelText: _t('اسم القطعة', 'Part name'),
// // //                       prefixIcon: const Icon(Icons.label_outline,
// // //                           color: Color(0xFFD4AF37)),
// // //                       border: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                       ),
// // //                       enabledBorder: OutlineInputBorder(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         borderSide: BorderSide(color: Colors.grey.shade300),
// // //                       ),
// // //                       focusedBorder: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                         borderSide: BorderSide(
// // //                           color: Color(0xFFD4AF37),
// // //                           width: 2,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     validator: (v) => (v == null || v.trim().isEmpty)
// // //                         ? _t('يرجى إدخال اسم القطعة', 'Enter part name')
// // //                         : null,
// // //                   ),
// // //                   const SizedBox(height: 16),

// // //                   // EPC
// // //                   if (_epcHex.isNotEmpty) ...[
// // //                     Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 12, vertical: 8),
// // //                       decoration: BoxDecoration(
// // //                         color: _isReadFromChip
// // //                             ? Colors.green.withOpacity(0.1)
// // //                             : Colors.grey.shade100,
// // //                         borderRadius: BorderRadius.circular(8),
// // //                         border: Border.all(
// // //                           color: _isReadFromChip
// // //                               ? Colors.green
// // //                               : Colors.grey.shade300,
// // //                         ),
// // //                       ),
// // //                       child: Row(
// // //                         children: [
// // //                           Icon(
// // //                             _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
// // //                             size: 16,
// // //                             color: _isReadFromChip ? Colors.green : Colors.grey,
// // //                           ),
// // //                           const SizedBox(width: 8),
// // //                           Expanded(
// // //                             child: Text(
// // //                               'EPC: $_epcHex',
// // //                               style: TextStyle(
// // //                                 fontFamily: 'monospace',
// // //                                 fontSize: 12,
// // //                                 color: _isReadFromChip
// // //                                     ? Colors.green.shade700
// // //                                     : Colors.grey,
// // //                                 fontWeight: _isReadFromChip
// // //                                     ? FontWeight.bold
// // //                                     : FontWeight.normal,
// // //                               ),
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                           ),
// // //                           if (_isReadFromChip) ...[
// // //                             const SizedBox(width: 4),
// // //                             Container(
// // //                               padding: const EdgeInsets.symmetric(
// // //                                   horizontal: 8, vertical: 2),
// // //                               decoration: BoxDecoration(
// // //                                 color: Colors.green.withOpacity(0.2),
// // //                                 borderRadius: BorderRadius.circular(12),
// // //                               ),
// // //                               child: Text(
// // //                                 _t('مقروء', 'Read'),
// // //                                 style: const TextStyle(
// // //                                   color: Colors.green,
// // //                                   fontSize: 10,
// // //                                   fontWeight: FontWeight.bold,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                           IconButton(
// // //                             icon: const Icon(Icons.clear, size: 16),
// // //                             onPressed: _clearEpc,
// // //                             padding: EdgeInsets.zero,
// // //                             constraints: const BoxConstraints(),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 12),
// // //                   ],

// // //                   // الوزن
// // //                   TextFormField(
// // //                     controller: weightController,
// // //                     focusNode: _weightFocusNode,
// // //                     keyboardType: TextInputType.number,
// // //                     decoration: InputDecoration(
// // //                       labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
// // //                       prefixIcon:
// // //                           const Icon(Icons.scale, color: Color(0xFFD4AF37)),
// // //                       helperText:
// // //                           '${_t('الحد الأقصى', 'Max')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // //                       border: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                       ),
// // //                       enabledBorder: OutlineInputBorder(
// // //                         borderRadius: BorderRadius.circular(10),
// // //                         borderSide: BorderSide(color: Colors.grey.shade300),
// // //                       ),
// // //                       focusedBorder: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                         borderSide: BorderSide(
// // //                           color: Color(0xFFD4AF37),
// // //                           width: 2,
// // //                         ),
// // //                       ),
// // //                       suffixText: 'جم',
// // //                     ),
// // //                     onTap: () {
// // //                       _weightFocusNode.requestFocus();
// // //                     },
// // //                     onEditingComplete: () {
// // //                       _weightFocusNode.unfocus();
// // //                     },
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return _t('يرجى إدخال الوزن', 'Please enter weight');
// // //                       }
// // //                       final w = double.tryParse(value);
// // //                       if (w == null || w <= 0) {
// // //                         return _t('وزن غير صحيح', 'Invalid weight');
// // //                       }
// // //                       if (w > pending + 0.001) {
// // //                         return _t(
// // //                           'الوزن أكبر من الرصيد المتاح (${pending.toStringAsFixed(2)} جم)',
// // //                           'Weight exceeds available balance',
// // //                         );
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),

// // //                   // QR
// // //                   TextFormField(
// // //                     controller: qrController,
// // //                     readOnly: true,
// // //                     focusNode: FocusNode(canRequestFocus: false),
// // //                     decoration: InputDecoration(
// // //                       labelText: useScanner
// // //                           ? _t("QR من الماسح", "QR from Scanner")
// // //                           : _t("QR عشوائي", "Random QR"),
// // //                       border: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                       ),
// // //                       suffixIcon: IconButton(
// // //                         icon: Icon(
// // //                           useScanner ? Icons.qr_code_scanner : Icons.shuffle,
// // //                         ),
// // //                         tooltip: useScanner
// // //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// // //                             : _t("استخدام الماسح", "Use Scanner"),
// // //                         onPressed: _toggleQRMode,
// // //                       ),
// // //                     ),
// // //                     validator: (value) {
// // //                       if (value == null || value.isEmpty) {
// // //                         return _t('يرجى إدخال الكود', 'Please enter code');
// // //                       }
// // //                       return null;
// // //                     },
// // //                   ),
// // //                   const SizedBox(height: 16),

// // //                   // صورة
// // //                   Center(
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: _pickImage,
// // //                       icon: const Icon(Icons.camera_alt),
// // //                       label: const Text('تصوير صورة'),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: const Color(0xFFD4AF37),
// // //                         foregroundColor: Colors.white,
// // //                         shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   if (_selectedImage != null) ...[
// // //                     const SizedBox(height: 16),
// // //                     Center(
// // //                       child: SizedBox(
// // //                         height: 200,
// // //                         child: Image.file(
// // //                           _selectedImage!,
// // //                           fit: BoxFit.cover,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 10),
// // //                     Center(
// // //                       child: OutlinedButton.icon(
// // //                         onPressed: () {
// // //                           setState(() {
// // //                             _pinImage = !_pinImage;
// // //                           });
// // //                         },
// // //                         icon: Icon(
// // //                           _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// // //                           color: _pinImage ? Colors.orange : null,
// // //                         ),
// // //                         label: Text(
// // //                           _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// // //                         ),
// // //                         style: OutlinedButton.styleFrom(
// // //                           side: BorderSide(
// // //                             color: _pinImage ? Colors.orange : Colors.grey,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                   ],
// // //                   const SizedBox(height: 20),

// // //                   // طباعة
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: ElevatedButton.icon(
// // //                           onPressed: (_isConverting || _isPrinting)
// // //                               ? null
// // //                               : () async {
// // //                                   if (_itemFormKey.currentState?.validate() ??
// // //                                       false) {
// // //                                     await _printConvertedItemLabel(
// // //                                       name: _newPartNameController.text.trim(),
// // //                                       weight: weightController.text,
// // //                                       qrCode: qrController.text.trim(),
// // //                                     );

// // //                                     if (!_isPrimaryScanner) {
// // //                                       setState(() {
// // //                                         _showManualEpcField = true;
// // //                                         _manualEpcController.clear();
// // //                                       });
// // //                                       WidgetsBinding.instance
// // //                                           .addPostFrameCallback((_) {
// // //                                         if (mounted) {
// // //                                           FocusScope.of(context)
// // //                                               .requestFocus(_manualEpcFocus);
// // //                                         }
// // //                                       });
// // //                                     }
// // //                                   }
// // //                                 },
// // //                           icon: _isPrinting
// // //                               ? const SizedBox(
// // //                                   width: 20,
// // //                                   height: 20,
// // //                                   child: CircularProgressIndicator(
// // //                                     strokeWidth: 2,
// // //                                     color: Colors.white,
// // //                                   ),
// // //                                 )
// // //                               : const Icon(Icons.print),
// // //                           label: Text(
// // //                             _isPrinting
// // //                                 ? _t('جاري الطباعة...', 'Printing...')
// // //                                 : _t('طباعة ليبل الذهب', 'Print Gold Label'),
// // //                           ),
// // //                           style: ElevatedButton.styleFrom(
// // //                             backgroundColor: _isPrinterConnected
// // //                                 ? const Color(0xFFD4AF37)
// // //                                 : Colors.green,
// // //                             foregroundColor: Colors.white,
// // //                             padding: const EdgeInsets.symmetric(vertical: 14),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 8),
// // //                       SizedBox(
// // //                         width: 50,
// // //                         height: 50,
// // //                         child: OutlinedButton(
// // //                           style: OutlinedButton.styleFrom(
// // //                             padding: EdgeInsets.zero,
// // //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// // //                             shape: RoundedRectangleBorder(
// // //                               borderRadius: BorderRadius.circular(10),
// // //                             ),
// // //                           ),
// // //                           onPressed: () => _showProfilePicker('gold'),
// // //                           child: const Icon(
// // //                             Icons.settings,
// // //                             color: Color(0xFFD4AF37),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 12),

// // //                   // حقل EPC اليدوي
// // //                   if (!_isPrimaryScanner && _showManualEpcField) ...[
// // //                     TextField(
// // //                       controller: _manualEpcController,
// // //                       focusNode: _manualEpcFocus,
// // //                       textCapitalization: TextCapitalization.characters,
// // //                       textInputAction: TextInputAction.done,
// // //                       decoration: const InputDecoration(
// // //                         labelText: 'أدخل رقم الشريحة',
// // //                         border: OutlineInputBorder(
// // //                           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //                         ),
// // //                         prefixIcon: Icon(Icons.nfc),
// // //                       ),
// // //                       onSubmitted: (value) {
// // //                         if (value.trim().isNotEmpty) {
// // //                           addEpcManualy(value.trim());
// // //                         } else {
// // //                           setState(() {
// // //                             _showManualEpcField = false;
// // //                             _manualEpcController.clear();
// // //                           });
// // //                           _manualEpcFocus.unfocus();
// // //                         }
// // //                       },
// // //                     ),
// // //                     const SizedBox(height: 12),
// // //                   ],

// // //                   // حفظ
// // //                   SizedBox(
// // //                     width: double.infinity,
// // //                     child: ElevatedButton.icon(
// // //                       onPressed: _isConverting
// // //                           ? null
// // //                           : () async {
// // //                               if (!(_itemFormKey.currentState?.validate() ??
// // //                                   false)) {
// // //                                 return;
// // //                               }
// // //                               if (_epcHex.isEmpty) {
// // //                                 ScaffoldMessenger.of(context).showSnackBar(
// // //                                   const SnackBar(
// // //                                     content: Text(
// // //                                         '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
// // //                                     backgroundColor: Colors.orange,
// // //                                   ),
// // //                                 );
// // //                                 return;
// // //                               }

// // //                               final name = _newPartNameController.text.trim();
// // //                               final weight =
// // //                                   double.parse(weightController.text);
// // //                               final qrCode = qrController.text.trim();

// // //                               await _addPartFromBalance(
// // //                                 name: name,
// // //                                 weight: weight,
// // //                                 qrCode: qrCode,
// // //                                 category: category,
// // //                                 uid: uid,
// // //                               );
// // //                             },
// // //                       icon: _isConverting
// // //                           ? const SizedBox(
// // //                               width: 20,
// // //                               height: 20,
// // //                               child: CircularProgressIndicator(
// // //                                 strokeWidth: 2,
// // //                                 color: Colors.white,
// // //                               ),
// // //                             )
// // //                           : const Icon(Icons.save),
// // //                       label: Text(
// // //                         _isConverting
// // //                             ? _t('جاري الحفظ...', 'Saving...')
// // //                             : _t('حفظ القطعة', 'Save Part'),
// // //                       ),
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: const Color(0xFFD4AF37),
// // //                         foregroundColor: Colors.white,
// // //                         padding: const EdgeInsets.symmetric(vertical: 14),
// // //                         shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildKitItemsView(String uid) {
// // //     final kitData = _openKitData!;
// // //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// // //     final kind = payload['kind'] ?? 'طقم';
// // //     final category = kitData['category'] as String? ?? 'gold';

// // //     final originalWeight = _getOriginalWeight(kitData);
// // //     final soldWeight = _getSoldWeight(kitData);
// // //     final remainingWeight = originalWeight - soldWeight;

// // //     final components = _getSetComponents(kitData);
// // //     final items = _getRemainingItems(kitData);
// // //     final itemsWeight = _getRemainingItemsWeight(kitData);
// // //     final isFullyDistributed = _isWeightFullyDistributed(kitData);
// // //     final pendingBalance = remainingWeight - itemsWeight;

// // //     if (items.isEmpty && components.isNotEmpty) {
// // //       final newItems = components.map((name) {
// // //         return {
// // //           'name': name,
// // //           'weight': 0.0,
// // //           'qrCode': '',
// // //           'createdAt': DateTime.now().toIso8601String(),
// // //         };
// // //       }).toList();

// // //       FirebaseFirestore.instance
// // //           .collection('users')
// // //           .doc(uid)
// // //           .collection('setRemainders')
// // //           .doc(_openKitDocId)
// // //           .update({
// // //         'payload.remainingItems': newItems,
// // //       }).then((_) {
// // //         setState(() {
// // //           _openKitData!['payload']['remainingItems'] = newItems;
// // //         });
// // //       });

// // //       _openKitData!['payload']['remainingItems'] = newItems;
// // //     }

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(_t("قطع $kind المتبقية", "Remaining $kind Parts")),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back),
// // //           onPressed: _backToKits,
// // //         ),
// // //         actions: [
// // //           Container(
// // //             margin: const EdgeInsets.symmetric(horizontal: 16),
// // //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //             decoration: BoxDecoration(
// // //               color: Colors.white,
// // //               borderRadius: BorderRadius.circular(20),
// // //             ),
// // //             child: Text(
// // //               '${remainingWeight.toStringAsFixed(2)} جم',
// // //               style: const TextStyle(
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Color(0xFFD4AF37),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       // ✅ FAB إضافي لإضافة قطعة من الرصيد

// // //       body: Container(
// // //         margin: const EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Theme.of(context).colorScheme.surface,
// // //           borderRadius: BorderRadius.circular(20),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.05),
// // //               blurRadius: 10,
// // //               offset: const Offset(0, 2),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(16),
// // //               decoration: BoxDecoration(
// // //                 color: const Color(0xFFD4AF37).withOpacity(0.1),
// // //                 borderRadius: const BorderRadius.vertical(
// // //                   top: Radius.circular(20),
// // //                 ),
// // //               ),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: Text(
// // //                           '${_t('الطقم', 'Set')}: $kind',
// // //                           style: const TextStyle(
// // //                             fontSize: 18,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Container(
// // //                         padding: const EdgeInsets.symmetric(
// // //                           horizontal: 12,
// // //                           vertical: 6,
// // //                         ),
// // //                         decoration: BoxDecoration(
// // //                           color:
// // //                               isFullyDistributed ? Colors.green : Colors.orange,
// // //                           borderRadius: BorderRadius.circular(20),
// // //                         ),
// // //                         child: Text(
// // //                           isFullyDistributed
// // //                               ? _t('مكتمل ✅', 'Complete ✅')
// // //                               : '${pendingBalance.toStringAsFixed(2)} جم متبقي',
// // //                           style: const TextStyle(
// // //                             color: Colors.white,
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 12,
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   if (components.isNotEmpty) ...[
// // //                     Text(
// // //                       _t('مكونات الطقم:', 'Set Components:'),
// // //                       style: const TextStyle(
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 14,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 4),
// // //                     Wrap(
// // //                       spacing: 6,
// // //                       runSpacing: 4,
// // //                       children: components.map((comp) {
// // //                         return Chip(
// // //                           label: Text(comp),
// // //                           backgroundColor:
// // //                               const Color(0xFFD4AF37).withOpacity(0.2),
// // //                           labelStyle: const TextStyle(
// // //                             fontWeight: FontWeight.w500,
// // //                           ),
// // //                           avatar: const Icon(
// // //                             Icons.check_circle,
// // //                             size: 16,
// // //                             color: Color(0xFFD4AF37),
// // //                           ),
// // //                         );
// // //                       }).toList(),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                   ],
// // //                   Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Text(
// // //                               '${_t('الوزن الأصلي', 'Original Weight')}: ${originalWeight.toStringAsFixed(2)} جم',
// // //                               style: const TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: Colors.black87,
// // //                               ),
// // //                             ),
// // //                             Text(
// // //                               '${_t('الوزن المحول', 'Converted Weight')}: ${soldWeight.toStringAsFixed(2)} جم',
// // //                               style: TextStyle(
// // //                                 color: Colors.grey[700],
// // //                               ),
// // //                             ),
// // //                             Text(
// // //                               '${_t('الوزن المتبقي', 'Remaining Weight')}: ${remainingWeight.toStringAsFixed(2)} جم',
// // //                               style: TextStyle(
// // //                                 color: Colors.grey[700],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       if (!isFullyDistributed)
// // //                         Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.end,
// // //                           children: [
// // //                             Text(
// // //                               _t('تم تحويل', 'Converted'),
// // //                               style: TextStyle(
// // //                                 fontSize: 11,
// // //                                 color: Colors.grey[600],
// // //                               ),
// // //                             ),
// // //                             Text(
// // //                               '${itemsWeight.toStringAsFixed(2)} جم',
// // //                               style: const TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: Color(0xFFD4AF37),
// // //                               ),
// // //                             ),
// // //                             Text(
// // //                               '${pendingBalance.toStringAsFixed(2)} جم ${_t('متبقي', 'left')}',
// // //                               style: TextStyle(
// // //                                 fontSize: 11,
// // //                                 color: Colors.orange[700],
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //             Expanded(
// // //               child: items.isEmpty
// // //                   ? Center(
// // //                       child: SingleChildScrollView(
// // //                         padding: const EdgeInsets.all(20),
// // //                         child: Column(
// // //                           mainAxisAlignment: MainAxisAlignment.center,
// // //                           children: [
// // //                             Icon(
// // //                               Icons.inbox_outlined,
// // //                               size: 64,
// // //                               color: Colors.grey[400],
// // //                             ),
// // //                             const SizedBox(height: 16),
// // //                             Text(
// // //                               _t('لا توجد قطع متبقية', 'No remaining parts'),
// // //                               style: TextStyle(
// // //                                 fontSize: 16,
// // //                                 color: Colors.grey[600],
// // //                               ),
// // //                             ),
// // //                             if (pendingBalance > 0.001) ...[
// // //                               const SizedBox(height: 12),
// // //                               Text(
// // //                                 '${_t('الرصيد المعلق', 'Pending balance')}: ${pendingBalance.toStringAsFixed(2)} جم',
// // //                                 style: TextStyle(
// // //                                   fontSize: 16,
// // //                                   fontWeight: FontWeight.bold,
// // //                                   color: Colors.orange[700],
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(height: 24),
// // //                               // ✅ زرار كبير واضح جوه الصفحة
// // //                               SizedBox(
// // //                                 width: double.infinity,
// // //                                 child: ElevatedButton.icon(
// // //                                   onPressed: _openAddFromBalanceForm,
// // //                                   icon: const Icon(Icons.add_circle_outline,
// // //                                       color: Colors.white, size: 24),
// // //                                   label: Text(
// // //                                     _t('إضافة قطعة من الرصيد',
// // //                                         'Add Part from Balance'),
// // //                                     style: const TextStyle(
// // //                                       fontSize: 16,
// // //                                       fontWeight: FontWeight.bold,
// // //                                       color: Colors.white,
// // //                                     ),
// // //                                   ),
// // //                                   style: ElevatedButton.styleFrom(
// // //                                     backgroundColor: const Color(0xFFD4AF37),
// // //                                     foregroundColor: Colors.white,
// // //                                     padding: const EdgeInsets.symmetric(
// // //                                         vertical: 16, horizontal: 20),
// // //                                     shape: RoundedRectangleBorder(
// // //                                       borderRadius: BorderRadius.circular(12),
// // //                                     ),
// // //                                     elevation: 4,
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(height: 12),
// // //                               Padding(
// // //                                 padding:
// // //                                     const EdgeInsets.symmetric(horizontal: 16),
// // //                                 child: Text(
// // //                                   _t(
// // //                                     'هيفتحلك فورم تدخل فيه اسم القطعة ووزنها، وكل ما تحفظ قطعة الرصيد هيقل لحد ما يخلص.',
// // //                                     'A form will open to enter the part name and weight. Each time you save a part, the balance decreases until it reaches zero.',
// // //                                   ),
// // //                                   textAlign: TextAlign.center,
// // //                                   style: TextStyle(
// // //                                     fontSize: 12,
// // //                                     color: Colors.grey[500],
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ],
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     )
// // //                   : ListView.builder(
// // //                       padding: const EdgeInsets.all(8),
// // //                       itemCount: items.length,
// // //                       itemBuilder: (context, index) {
// // //                         final item = items[index];
// // //                         final componentName = item['name'] ??
// // //                             (index < components.length
// // //                                 ? components[index]
// // //                                 : 'قطعة ${index + 1}');
// // //                         final weight =
// // //                             (item['weight'] as num?)?.toDouble() ?? 0;
// // //                         final qrCode = item['qrCode']?.toString() ?? '';

// // //                         return Card(
// // //                           margin: const EdgeInsets.only(bottom: 8),
// // //                           shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                             side: BorderSide(
// // //                               color: const Color(0xFFD4AF37).withOpacity(0.3),
// // //                               width: 1,
// // //                             ),
// // //                           ),
// // //                           child: InkWell(
// // //                             onTap: () => _openItemDetails(item, index),
// // //                             borderRadius: BorderRadius.circular(12),
// // //                             child: Padding(
// // //                               padding: const EdgeInsets.all(12),
// // //                               child: Row(
// // //                                 children: [
// // //                                   Container(
// // //                                     width: 32,
// // //                                     height: 32,
// // //                                     decoration: const BoxDecoration(
// // //                                       color: Color(0xFFD4AF37),
// // //                                       shape: BoxShape.circle,
// // //                                     ),
// // //                                     child: Center(
// // //                                       child: Text(
// // //                                         '${index + 1}',
// // //                                         style: const TextStyle(
// // //                                           color: Colors.white,
// // //                                           fontWeight: FontWeight.bold,
// // //                                         ),
// // //                                       ),
// // //                                     ),
// // //                                   ),
// // //                                   const SizedBox(width: 12),
// // //                                   Expanded(
// // //                                     child: Column(
// // //                                       crossAxisAlignment:
// // //                                           CrossAxisAlignment.start,
// // //                                       children: [
// // //                                         Text(
// // //                                           componentName,
// // //                                           style: const TextStyle(
// // //                                             fontSize: 16,
// // //                                             fontWeight: FontWeight.bold,
// // //                                           ),
// // //                                         ),
// // //                                         if (qrCode.isNotEmpty)
// // //                                           Text(
// // //                                             'QR: $qrCode',
// // //                                             style: TextStyle(
// // //                                               fontSize: 11,
// // //                                               color: Colors.grey[600],
// // //                                             ),
// // //                                           ),
// // //                                       ],
// // //                                     ),
// // //                                   ),
// // //                                   Column(
// // //                                     crossAxisAlignment: CrossAxisAlignment.end,
// // //                                     children: [
// // //                                       Text(
// // //                                         '${weight.toStringAsFixed(2)} جم',
// // //                                         style: const TextStyle(
// // //                                           fontWeight: FontWeight.bold,
// // //                                           color: Color(0xFFD4AF37),
// // //                                         ),
// // //                                       ),
// // //                                       Icon(
// // //                                         Icons.arrow_forward_ios,
// // //                                         size: 14,
// // //                                         color: Colors.grey[400],
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //             ),
// // //             // ✅ زرار سفلي دائمًا ظاهر لما فيه رصيد معلق + فيه قطع
// // //             if (pendingBalance > 0.001 && items.isNotEmpty)
// // //               Container(
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: const Color(0xFFD4AF37).withOpacity(0.08),
// // //                   borderRadius: const BorderRadius.vertical(
// // //                     bottom: Radius.circular(20),
// // //                   ),
// // //                 ),
// // //                 child: SizedBox(
// // //                   width: double.infinity,
// // //                   child: ElevatedButton.icon(
// // //                     onPressed: _openAddFromBalanceForm,
// // //                     icon: const Icon(Icons.add_circle_outline,
// // //                         color: Colors.white, size: 22),
// // //                     label: Text(
// // //                       '${_t('إضافة قطعة من الرصيد', 'Add Part from Balance')} (${pendingBalance.toStringAsFixed(2)} جم)',
// // //                       style: const TextStyle(
// // //                         fontSize: 14,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.white,
// // //                       ),
// // //                     ),
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: const Color(0xFFD4AF37),
// // //                       foregroundColor: Colors.white,
// // //                       padding: const EdgeInsets.symmetric(vertical: 14),
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildKitCard({
// // //     required Map<String, dynamic> data,
// // //     required String docId,
// // //     required VoidCallback onOpen,
// // //   }) {
// // //     final payload = data['payload'] as Map<String, dynamic>? ?? {};
// // //     final category = data['category'] as String? ?? '';
// // //     final kind = payload['kind'] ?? 'طقم';
// // //     final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

// // //     final originalWeight = _getOriginalWeight(data);
// // //     final soldWeight = _getSoldWeight(data);
// // //     final remainingWeight = originalWeight - soldWeight;
// // //     final items = _getRemainingItems(data);
// // //     final itemsCount = items.length;
// // //     final isFullyDistributed = _isWeightFullyDistributed(data);
// // //     final components = _getSetComponents(data);

// // //     Color categoryColor;
// // //     IconData categoryIcon;
// // //     switch (category) {
// // //       case 'gold':
// // //         categoryColor = const Color(0xFFD4AF37);
// // //         categoryIcon = Icons.workspace_premium_rounded;
// // //         break;
// // //       case 'gem':
// // //         categoryColor = Colors.purple;
// // //         categoryIcon = Icons.diamond_rounded;
// // //         break;
// // //       case 'bullion':
// // //         categoryColor = Colors.blue;
// // //         categoryIcon = Icons.account_balance;
// // //         break;
// // //       default:
// // //         categoryColor = Colors.grey;
// // //         categoryIcon = Icons.help_outline_rounded;
// // //     }

// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(12),
// // //         side: BorderSide(
// // //           color: categoryColor.withOpacity(0.3),
// // //           width: 1,
// // //         ),
// // //       ),
// // //       child: InkWell(
// // //         onTap: onOpen,
// // //         borderRadius: BorderRadius.circular(12),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Row(
// // //                 children: [
// // //                   Container(
// // //                     padding: const EdgeInsets.all(8),
// // //                     decoration: BoxDecoration(
// // //                       color: categoryColor.withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(8),
// // //                     ),
// // //                     child: Icon(
// // //                       categoryIcon,
// // //                       color: categoryColor,
// // //                       size: 24,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 12),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         Text(
// // //                           kind,
// // //                           style: const TextStyle(
// // //                             fontSize: 16,
// // //                             fontWeight: FontWeight.bold,
// // //                           ),
// // //                         ),
// // //                         Text(
// // //                           category,
// // //                           style: TextStyle(
// // //                             fontSize: 12,
// // //                             color: Colors.grey[600],
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   Container(
// // //                     padding: const EdgeInsets.symmetric(
// // //                       horizontal: 10,
// // //                       vertical: 4,
// // //                     ),
// // //                     decoration: BoxDecoration(
// // //                       color: isFullyDistributed ? Colors.green : Colors.orange,
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Text(
// // //                       isFullyDistributed
// // //                           ? _t('مكتمل', 'Complete')
// // //                           : '${remainingWeight.toStringAsFixed(2)} جم',
// // //                       style: const TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 12,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 8),
// // //               if (components.isNotEmpty) ...[
// // //                 Wrap(
// // //                   spacing: 4,
// // //                   runSpacing: 4,
// // //                   children: components.map((comp) {
// // //                     return Chip(
// // //                       label: Text(
// // //                         comp,
// // //                         style: const TextStyle(fontSize: 11),
// // //                       ),
// // //                       backgroundColor: categoryColor.withOpacity(0.15),
// // //                       padding: const EdgeInsets.symmetric(horizontal: 2),
// // //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// // //                     );
// // //                   }).toList(),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //               ],
// // //               Row(
// // //                 children: [
// // //                   Icon(Icons.scale, size: 16, color: Colors.grey[600]),
// // //                   const SizedBox(width: 4),
// // //                   Text(
// // //                     '${originalWeight.toStringAsFixed(2)} جم',
// // //                     style: TextStyle(color: Colors.grey[600]),
// // //                   ),
// // //                   const SizedBox(width: 16),
// // //                   Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600]),
// // //                   const SizedBox(width: 4),
// // //                   Text(
// // //                     '${soldWeight.toStringAsFixed(2)} جم',
// // //                     style: TextStyle(color: Colors.grey[600]),
// // //                   ),
// // //                   const Spacer(),
// // //                   Icon(Icons.grid_view, size: 16, color: Colors.grey[600]),
// // //                   const SizedBox(width: 4),
// // //                   Text(
// // //                     '$itemsCount ${_t('قطعة', 'Parts')}',
// // //                     style: TextStyle(color: Colors.grey[600]),
// // //                   ),
// // //                 ],
// // //               ),
// // //               if (createdAt != null) ...[
// // //                 const SizedBox(height: 8),
// // //                 Text(
// // //                   DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
// // //                   style: TextStyle(
// // //                     fontSize: 11,
// // //                     color: Colors.grey[500],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmptyState({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //   }) {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.all(24),
// // //             decoration: BoxDecoration(
// // //               color: Colors.grey.shade100,
// // //               borderRadius: BorderRadius.circular(20),
// // //             ),
// // //             child: Icon(
// // //               icon,
// // //               size: 48,
// // //               color: Colors.grey.shade400,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           Text(
// // //             title,
// // //             style: TextStyle(
// // //               fontSize: 16,
// // //               fontWeight: FontWeight.w600,
// // //               color: Colors.grey.shade600,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Text(
// // //             subtitle,
// // //             style: TextStyle(
// // //               fontSize: 14,
// // //               color: Colors.grey.shade500,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:ui' as ui;
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:uuid/uuid.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// // import '../services/firestore_service.dart';
// // import '../services/seuic_uhf_service.dart';
// // import '../services/new_printer_api.dart';
// // import '../services/new_printer_status.dart';
// // import 'dart:async';
// // import 'label_layout_model.dart';
// // import 'dart:io';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:image_picker/image_picker.dart';
// // import '../utils/image_compressor.dart';

// // class RemainingKitsPage extends StatefulWidget {
// //   const RemainingKitsPage({super.key});

// //   @override
// //   State<RemainingKitsPage> createState() => _RemainingKitsPageState();
// // }

// // class _RemainingKitsPageState extends State<RemainingKitsPage> {
// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   Map<String, dynamic>? _openKitData;
// //   String? _openKitDocId;
// //   bool _showKitItems = false;

// //   Map<String, dynamic>? _selectedItem;
// //   int? _selectedIndex;
// //   bool _showItemDetails = false;

// //   bool _isPrinting = false;
// //   bool _isPrinterConnected = false;
// //   String _connectedPrinterName = "غير متصلة";
// //   String? _connectedPrinterMac;
// //   String? _errorMessage;
// //   String? _successMessage;
// //   String? _progressMessage;
// //   StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

// //   bool _isPrimaryScanner = false;
// //   StreamSubscription<String>? _tagSubscription;

// //   final TextEditingController qrController = TextEditingController();
// //   bool useScanner = false;

// //   final TextEditingController weightController = TextEditingController();

// //   final FocusNode _weightFocusNode = FocusNode();

// //   String _epcHex = '';
// //   bool _isReadFromChip = false;
// //   bool _isReading = false;

// //   bool _showManualEpcField = false;
// //   final TextEditingController _manualEpcController = TextEditingController();
// //   final FocusNode _manualEpcFocus = FocusNode();

// //   bool _isConverting = false;
// //   LabelProfile? _activeProfile;

// //   final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

// //   File? _selectedImage;
// //   bool _pinImage = false;

// //   // ✅ فقط إجمالي الجرامات
// //   double _totalRemainingWeight = 0.0;
// //   bool _isLoadingTotal = false;

// //   // ✅ إضافة قطعة من الرصيد المعلق
// //   bool _isAddingFromBalance = false;
// //   String _selectedPartName = 'خاتم';

// //   // ✅ قائمة أسماء القطع (نفس قائمة "النوع" بدون أطقم)
// //   final List<String> partNameOptions = [
// //     'خاتم',
// //     'اسورة',
// //     'خاتم و اسورة',
// //     'بنجرة',
// //     'حلق',
// //     'خلخال',
// //     'تعليقة',
// //     'حزام',
// //     'تاج',
// //     'كف',
// //     'عقد',
// //     'انسيال',
// //     'سلسال',
// //     'شوكر',
// //     'طوق',
// //     'مخنق',
// //     'سبحة',
// //     'غير ذلك',
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //     _loadScannerMode();
// //     _listenToPrinterStatus();
// //     _listenToTagStream();
// //     _loadActiveProfile();
// //     _calculateTotalRemainingWeight();

// //     final randomQr = const Uuid().v4().substring(0, 7);
// //     qrController.text = randomQr;
// //   }

// //   @override
// //   void dispose() {
// //     _tagSubscription?.cancel();
// //     _printerStatusSubscription?.cancel();
// //     _manualEpcController.dispose();
// //     _manualEpcFocus.dispose();
// //     qrController.dispose();
// //     weightController.dispose();
// //     _weightFocusNode.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   Future<void> _loadActiveProfile() async {
// //     final profile = await LabelProfileStorage.loadActive('gold');
// //     if (mounted) setState(() => _activeProfile = profile);
// //   }

// //   Future<void> _loadScannerMode() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final mode = prefs.getString('scannerMode');
// //     setState(() {
// //       _isPrimaryScanner = mode == 'primary';
// //     });
// //   }

// //   void _listenToPrinterStatus() {
// //     _printerStatusSubscription =
// //         NewPrinterStatusListener.getStream().listen((status) {
// //       setState(() {
// //         _errorMessage = null;
// //         _successMessage = null;
// //         _progressMessage = null;

// //         switch (status.status) {
// //           case 'connected':
// //             final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
// //             _isPrinterConnected = true;
// //             _connectedPrinterName = match?.group(1) ?? "طابعة LPAPI";
// //             _connectedPrinterMac = match?.group(1);
// //             _successMessage = "متصل بـ $_connectedPrinterName";
// //             break;

// //           case 'disconnected':
// //             _isPrinterConnected = false;
// //             _connectedPrinterName = "غير متصلة";
// //             _connectedPrinterMac = null;
// //             _errorMessage = "تم قطع الاتصال بالطابعة";
// //             break;

// //           case 'connecting':
// //           case 'auto_connecting':
// //             _progressMessage = status.message;
// //             break;

// //           case 'printing':
// //           case 'progress':
// //             _progressMessage = status.message;
// //             _isPrinting = true;
// //             break;

// //           case 'success':
// //             _successMessage = status.message;
// //             _isPrinting = false;
// //             break;

// //           case 'error':
// //             _errorMessage = status.message;
// //             _isPrinting = false;
// //             if (status.message.contains("قطع الاتصال") ||
// //                 status.message.contains("غير متصلة")) {
// //               _isPrinterConnected = false;
// //               _connectedPrinterName = "غير متصلة";
// //               _connectedPrinterMac = null;
// //             }
// //             break;

// //           case 'initialized':
// //             _successMessage = status.message;
// //             break;
// //         }
// //       });
// //     });
// //   }

// //   void _listenToTagStream() {
// //     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
// //       if (!mounted) return;

// //       if (tag.length >= 24) {
// //         final exists = await FS.checkItemExists(tag.toUpperCase());
// //         if (exists) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(_t('⚠️ هذه الشريحة مسجلة من قبل',
// //                   '⚠️ This tag is already registered')),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //           return;
// //         }

// //         setState(() {
// //           _epcHex = tag.toUpperCase();
// //           _isReadFromChip = true;
// //           _isReading = false;
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Row(
// //               children: [
// //                 const Icon(Icons.nfc, color: Colors.white),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Text(
// //                     '${_t('تم قراءة الشريحة:', 'Tag read:')} ${tag.substring(0, tag.length > 20 ? 20 : tag.length)}...',
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             backgroundColor: const Color(0xFFD4AF37),
// //             behavior: SnackBarBehavior.floating,
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //             duration: const Duration(seconds: 2),
// //           ),
// //         );
// //       } else {
// //         if (!_isPrimaryScanner) {
// //           setState(() {
// //             _manualEpcController.text = tag;
// //             _showManualEpcField = true;
// //           });

// //           WidgetsBinding.instance.addPostFrameCallback((_) {
// //             if (mounted) {
// //               FocusScope.of(context).requestFocus(_manualEpcFocus);
// //             }
// //           });
// //         }
// //       }
// //     });
// //   }

// //   void _clearEpc() {
// //     setState(() {
// //       _epcHex = '';
// //       _isReadFromChip = false;
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //     });
// //   }

// //   void addEpcManualy(String Epc) {
// //     SeuicUhfService.addEpcManualy(Epc);
// //     setState(() {
// //       _epcHex = Epc.toUpperCase();
// //       _isReadFromChip = true;
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //     });
// //     _manualEpcFocus.unfocus();
// //     FocusScope.of(context).unfocus();
// //   }

// //   void _toggleQRMode() {
// //     setState(() {
// //       useScanner = !useScanner;
// //       if (!useScanner) {
// //         qrController.text = const Uuid().v4().substring(0, 7);
// //       } else {
// //         qrController.clear();
// //       }
// //     });
// //   }

// //   Future<void> _selectAndConnectPrinter() async {
// //     _clearMessages();
// //     try {
// //       final printers = await NewPrinterAPI.getBluetoothPrinters();
// //       if (printers.isEmpty) {
// //         setState(() {
// //           _errorMessage = "لا توجد طابعات LPAPI في النطاق";
// //         });
// //         return;
// //       }

// //       final selectedMac = await showDialog<String>(
// //         context: context,
// //         builder: (ctx) => AlertDialog(
// //           title: const Text("اختر طابعة LPAPI"),
// //           content: SizedBox(
// //             width: double.maxFinite,
// //             height: 300,
// //             child: ListView.builder(
// //               itemCount: printers.length,
// //               itemBuilder: (context, i) {
// //                 final name = printers[i]["name"] ?? "طابعة LPAPI";
// //                 final addr = printers[i]["address"] ?? "";
// //                 final isCurrent = addr == _connectedPrinterMac;
// //                 return ListTile(
// //                   leading: Icon(
// //                     Icons.print,
// //                     color: isCurrent ? Colors.green : const Color(0xFFD4AF37),
// //                   ),
// //                   title: Text(name,
// //                       style: TextStyle(
// //                           fontWeight:
// //                               isCurrent ? FontWeight.bold : FontWeight.normal)),
// //                   subtitle: Text(addr),
// //                   trailing: isCurrent
// //                       ? const Icon(Icons.check_circle, color: Colors.green)
// //                       : null,
// //                   onTap: () => Navigator.pop(ctx, addr),
// //                 );
// //               },
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //                 onPressed: () => Navigator.pop(ctx),
// //                 child: const Text("إلغاء")),
// //           ],
// //         ),
// //       );

// //       if (selectedMac != null) {
// //         final selectedDevice = printers.firstWhere(
// //           (printer) => printer["address"] == selectedMac,
// //           orElse: () => {"name": "طابعة LPAPI", "address": selectedMac},
// //         );
// //         setState(() {
// //           _progressMessage = "جاري الاتصال...";
// //           _connectedPrinterMac = selectedMac;
// //           _connectedPrinterName = selectedDevice["name"] ?? selectedMac;
// //         });

// //         final success = await NewPrinterAPI.connectBluetooth(selectedMac);
// //         if (success) {
// //           setState(() {
// //             _isPrinterConnected = true;
// //             _successMessage = null;
// //             _progressMessage = null;
// //           });
// //         } else {
// //           setState(() {
// //             _errorMessage = "فشل الاتصال، تأكد من تشغيل الطابعة";
// //             _progressMessage = null;
// //             _isPrinterConnected = false;
// //             _connectedPrinterName = "غير متصلة";
// //             _connectedPrinterMac = null;
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       setState(() =>
// //           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
// //     }
// //   }

// //   Future<void> _disconnectPrinter() async {
// //     await NewPrinterAPI.disconnect();
// //   }

// //   void _clearMessages() {
// //     setState(() {
// //       _errorMessage = null;
// //       _successMessage = null;
// //       _progressMessage = null;
// //     });
// //   }

// //   Future<String?> _getKitImageUrl(String epcHex) async {
// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;
// //       final docSnapshot = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(uid)
// //           .collection('items')
// //           .doc(epcHex)
// //           .get();

// //       if (docSnapshot.exists) {
// //         final data = docSnapshot.data();
// //         final images = data?['images'] as List<dynamic>?;
// //         if (images != null && images.isNotEmpty) {
// //           return images.first.toString();
// //         }
// //       }
// //       return null;
// //     } catch (e) {
// //       print('Error getting kit image: $e');
// //       return null;
// //     }
// //   }

// //   Future<void> _printConvertedItemLabel({
// //     required String name,
// //     required String weight,
// //     required String qrCode,
// //   }) async {
// //     if (!_isPrinterConnected) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('⚠️ الطابعة غير متصلة، يرجى الاتصال أولاً'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     setState(() => _isPrinting = true);

// //     try {
// //       if (_activeProfile != null) {
// //         await LabelLayoutStorage.save(_activeProfile!.layout);
// //       }

// //       final layout = await LabelLayoutStorage.load('gold');
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? logoBase64 = prefs.getString('custom_logo_base64');

// //       final success = await NewPrinterAPI.printGoldLabel(
// //         weight: weight.trim().isEmpty ? null : weight.trim(),
// //         carat: null,
// //         size: null,
// //         showQr: "true",
// //         qrCode: qrCode.trim(),
// //         customLogoBase64: logoBase64,
// //         labelLayout: layout.toJson(),
// //       );

// //       if (success) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("✅ تمت طباعة ليبل القطعة بنجاح"),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       }
// //     } catch (e) {
// //       print('Print error: $e');
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('❌ فشل الطباعة: ${e.toString()}'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     } finally {
// //       setState(() => _isPrinting = false);
// //     }
// //   }

// //   Future<void> _uploadImage(String epcHex) async {
// //     if (_selectedImage == null) return;

// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;

// //       final compressed = await compressImage(_selectedImage!);
// //       if (compressed == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text('❌ فشل ضغط الصورة')),
// //         );
// //         return;
// //       }

// //       final storageRef = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(epcHex)
// //           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

// //       final metadata = SettableMetadata(
// //         contentType: 'image/jpeg',
// //         cacheControl: 'public,max-age=300',
// //       );

// //       await storageRef.putFile(compressed, metadata);
// //       final url = await storageRef.getDownloadURL();

// //       await FS.uploadImage(epcHex, {
// //         'images': FieldValue.arrayUnion([url]),
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('✅ تم رفع الصورة بنجاح')),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('❌ فشل رفع الصورة: $e')),
// //       );
// //     }
// //   }

// //   Future<void> _showProfilePicker(String labelType) async {
// //     final profiles = await LabelProfileStorage.loadAll(labelType);

// //     if (!mounted) return;

// //     if (profiles.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text(
// //               'لا يوجد ملفات محفوظة — اذهب لمحرر التخطيط وأضف ملفاً أولاً'),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     await showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (_) => Directionality(
// //         textDirection: ui.TextDirection.rtl,
// //         child: Container(
// //           constraints: BoxConstraints(
// //             maxHeight: MediaQuery.of(context).size.height * 0.6,
// //           ),
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 margin: const EdgeInsets.symmetric(vertical: 10),
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               Padding(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.style_outlined, color: Color(0xFFD4AF37)),
// //                     const SizedBox(width: 8),
// //                     const Text(
// //                       'اختر إعدادات الطباعة',
// //                       style:
// //                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const Divider(height: 1),
// //               Flexible(
// //                 child: ListView.separated(
// //                   shrinkWrap: true,
// //                   padding: const EdgeInsets.symmetric(vertical: 8),
// //                   itemCount: profiles.length,
// //                   separatorBuilder: (_, __) =>
// //                       const Divider(height: 1, indent: 16),
// //                   itemBuilder: (_, i) {
// //                     final p = profiles[i];
// //                     final isActive = _activeProfile?.id == p.id;
// //                     return ListTile(
// //                       leading: CircleAvatar(
// //                         backgroundColor: isActive
// //                             ? const Color(0xFFD4AF37)
// //                             : const Color(0xFFD4AF37).withOpacity(0.12),
// //                         child: Icon(
// //                           Icons.description_outlined,
// //                           color:
// //                               isActive ? Colors.white : const Color(0xFFD4AF37),
// //                         ),
// //                       ),
// //                       title: Text(
// //                         p.name,
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           color: isActive ? const Color(0xFFD4AF37) : null,
// //                         ),
// //                       ),
// //                       subtitle: Text(
// //                         '${p.layout.stickerW.toStringAsFixed(0)}×'
// //                         '${p.layout.stickerH.toStringAsFixed(0)} مم  •  '
// //                         'كثافة ${p.layout.density}',
// //                         style: const TextStyle(fontSize: 11),
// //                       ),
// //                       trailing: isActive
// //                           ? const Icon(Icons.check_circle,
// //                               color: Color(0xFFD4AF37))
// //                           : null,
// //                       onTap: () {
// //                         setState(() => _activeProfile = p);
// //                         LabelProfileStorage.saveActive('gold', p.id);
// //                         Navigator.pop(context);
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text('✅ تم تفعيل "${p.name}"'),
// //                             backgroundColor: Colors.green,
// //                             duration: const Duration(seconds: 2),
// //                           ),
// //                         );
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   double _getRemainingWeight(Map<String, dynamic> kitData) {
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// //         (payload['weight'] as num?)?.toDouble() ??
// //         0;
// //     final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// //     return originalWeight - soldWeight;
// //   }

// //   double _getRemainingItemsWeight(Map<String, dynamic> kitData) {
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final items = payload['remainingItems'] as List<dynamic>? ?? [];
// //     double total = 0;
// //     for (var item in items) {
// //       total += (item['weight'] as num?)?.toDouble() ?? 0;
// //     }
// //     return total;
// //   }

// //   bool _isWeightFullyDistributed(Map<String, dynamic> kitData) {
// //     final remainingWeight = _getRemainingWeight(kitData);
// //     final itemsWeight = _getRemainingItemsWeight(kitData);
// //     return (remainingWeight - itemsWeight).abs() < 0.001;
// //   }

// //   double _getOriginalWeight(Map<String, dynamic> kitData) {
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     return (payload['originalWeight'] as num?)?.toDouble() ??
// //         (payload['weight'] as num?)?.toDouble() ??
// //         0;
// //   }

// //   double _getSoldWeight(Map<String, dynamic> kitData) {
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     return (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// //   }

// //   List<String> _getSetComponents(Map<String, dynamic> kitData) {
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final components = payload['setComponents'] as List<dynamic>? ?? [];
// //     return components.map((e) => e.toString()).toList();
// //   }

// //   List<Map<String, dynamic>> _getRemainingItems(Map<String, dynamic> kitData) {
// //     if (kitData['payload'] == null) return [];

// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final items = payload['remainingItems'] as List<dynamic>? ?? [];

// //     return items.map((e) => Map<String, dynamic>.from(e)).toList();
// //   }

// //   // ✅ دالة حساب إجمالي الجرامات المتبقية فقط
// //   Future<void> _calculateTotalRemainingWeight() async {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;
// //     if (uid == null) return;

// //     setState(() => _isLoadingTotal = true);

// //     try {
// //       final snapshot = await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(uid)
// //           .collection('setRemainders')
// //           .get();

// //       double totalWeight = 0.0;

// //       for (var doc in snapshot.docs) {
// //         final data = doc.data();
// //         final payload = data['payload'] as Map<String, dynamic>? ?? {};
// //         final originalWeight =
// //             (payload['originalWeight'] as num?)?.toDouble() ??
// //                 (payload['weight'] as num?)?.toDouble() ??
// //                 0;
// //         final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// //         final remainingWeight = originalWeight - soldWeight;
// //         totalWeight += remainingWeight;
// //       }

// //       setState(() {
// //         _totalRemainingWeight = totalWeight;
// //         _isLoadingTotal = false;
// //       });
// //     } catch (e) {
// //       print('Error calculating total: $e');
// //       setState(() => _isLoadingTotal = false);
// //     }
// //   }

// //   void _openKit(Map<String, dynamic> kitData, String docId) {
// //     setState(() {
// //       _openKitData = kitData;
// //       _openKitDocId = docId;
// //       _showKitItems = true;
// //       _selectedItem = null;
// //       _selectedIndex = null;
// //       _showItemDetails = false;
// //       _isAddingFromBalance = false;
// //       _selectedPartName = 'خاتم';
// //       _clearEpc();
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //       _selectedImage = null;
// //       _pinImage = false;
// //     });
// //   }

// //   void _backToKits() {
// //     setState(() {
// //       _openKitData = null;
// //       _openKitDocId = null;
// //       _showKitItems = false;
// //       _selectedItem = null;
// //       _selectedIndex = null;
// //       _showItemDetails = false;
// //       _isAddingFromBalance = false;
// //       _selectedPartName = 'خاتم';
// //       _clearEpc();
// //       _selectedImage = null;
// //       _pinImage = false;
// //     });
// //     _calculateTotalRemainingWeight();
// //   }

// //   void _resetFormState() {
// //     weightController.clear();
// //     qrController.text = const Uuid().v4().substring(0, 7);
// //     _clearEpc();
// //     _showManualEpcField = false;
// //     _manualEpcController.clear();
// //     if (!_pinImage) {
// //       _selectedImage = null;
// //     }
// //     _itemFormKey.currentState?.reset();
// //   }

// //   void _openItemDetails(Map<String, dynamic> item, int index) {
// //     weightController.text =
// //         (item['weight'] as num?)?.toStringAsFixed(2) ?? '0.00';

// //     setState(() {
// //       _selectedItem = item;
// //       _selectedIndex = index;
// //       _showItemDetails = true;
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //       _clearEpc();
// //       _selectedImage = null;
// //       _pinImage = false;
// //     });

// //     _itemFormKey.currentState?.reset();
// //   }

// //   void _backToItemsList() {
// //     setState(() {
// //       _selectedItem = null;
// //       _selectedIndex = null;
// //       _showItemDetails = false;
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //       _clearEpc();
// //       if (!_pinImage) {
// //         _selectedImage = null;
// //       }
// //     });
// //     _resetFormState();
// //   }

// //   Future<void> _pickImage() async {
// //     FocusScope.of(context).unfocus();

// //     final picker = ImagePicker();
// //     final xFile = await picker.pickImage(source: ImageSource.camera);

// //     if (xFile != null) {
// //       setState(() {
// //         _selectedImage = File(xFile.path);
// //       });
// //     }
// //   }

// //   // ✅ ميثود مساعدة لفتح فورم الإضافة من الرصيد
// //   void _openAddFromBalanceForm() {
// //     setState(() {
// //       _isAddingFromBalance = true;
// //       _selectedPartName = 'خاتم';
// //       weightController.clear();
// //       qrController.text = const Uuid().v4().substring(0, 7);
// //       _clearEpc();
// //       _selectedImage = null;
// //       _pinImage = false;
// //       _showManualEpcField = false;
// //       _manualEpcController.clear();
// //     });
// //     _itemFormKey.currentState?.reset();
// //   }

// //   Future<void> _convertSinglePartToItem({
// //     required int index,
// //     required Map<String, dynamic> item,
// //     required String category,
// //     required Map<String, dynamic> kitData,
// //     required String kitDocId,
// //     required String uid,
// //   }) async {
// //     try {
// //       setState(() => _isConverting = true);

// //       final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});
// //       final items = List<dynamic>.from(payload['remainingItems'] ?? []);

// //       if (index >= items.length) {
// //         throw Exception('القطعة غير موجودة في الطقم');
// //       }

// //       final removedItem = items.removeAt(index);

// //       final weight = (item['weight'] as num?)?.toDouble() ??
// //           (removedItem['weight'] as num?)?.toDouble() ??
// //           0;

// //       final qrCode = item['qrCode']?.toString() ??
// //           removedItem['qrCode']?.toString() ??
// //           const Uuid().v4().substring(0, 7);

// //       final epcHex = _epcHex.isNotEmpty
// //           ? _epcHex
// //           : (kitData['epcHex']?.toString() ??
// //               payload['epcHex']?.toString() ??
// //               qrCode);

// //       final componentName =
// //           item['name']?.toString() ?? removedItem['name']?.toString() ?? 'قطعة';

// //       final kitImageUrl = await _getKitImageUrl(epcHex);

// //       final newPayload = {
// //         'weight': weight,
// //         'qrCode': qrCode,
// //         'kind': componentName,
// //         'isFromKit': true,
// //         'kitDocId': kitDocId,
// //         'originalKitWeight': payload['originalWeight'] ?? payload['weight'],
// //         'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
// //         'notes': 'تم التحويل من طقم ${payload['kind'] ?? ''}',
// //         'carat': payload['carat'] ?? '21',
// //         'size': payload['size'] ?? '0',
// //         'wage': payload['wage'] ?? 0,
// //         'showQr': true,
// //         'images': kitImageUrl != null ? [kitImageUrl] : [],
// //       };

// //       await FS.saveItem(
// //         epcHex: epcHex,
// //         category: category,
// //         date: DateTime.now(),
// //         payload: newPayload,
// //         fromOpeningBalance: false,
// //       );

// //       if (_selectedImage != null) {
// //         await _uploadImage(epcHex);
// //       }

// //       if (kitImageUrl != null) {
// //         await FS.uploadImage(epcHex, {
// //           'images': FieldValue.arrayUnion([kitImageUrl]),
// //         });
// //       }

// //       final currentSoldWeight =
// //           (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// //       final newSoldWeight = currentSoldWeight + weight;
// //       final currentComponents =
// //           List<String>.from(payload['setComponents'] ?? []);

// //       // ✅ الحل: احفظ الشرط قبل الحذف
// //       final bool componentExists = index < currentComponents.length;

// //       final updateData = {
// //         'payload.remainingItems': items,
// //         'payload.soldWeight': newSoldWeight,
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       };

// //       if (componentExists) {
// //         currentComponents.removeAt(index);
// //         updateData['payload.setComponents'] = currentComponents;
// //       }

// //       await FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(uid)
// //           .collection('setRemainders')
// //           .doc(kitDocId)
// //           .update(updateData);

// //       setState(() {
// //         _openKitData!['payload']['remainingItems'] = items;
// //         _openKitData!['payload']['soldWeight'] = newSoldWeight;
// //         // ✅ استخدم نفس المتغير عشان مايتغيرش بعد الحذف
// //         if (componentExists) {
// //           _openKitData!['payload']['setComponents'] = currentComponents;
// //         }
// //       });

// //       // ============================================================
// //       // ✅ حساب الرصيد المعلق المتبقي
// //       // ============================================================
// //       final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// //           (payload['weight'] as num?)?.toDouble() ??
// //           0;

// //       double remainingItemsWeight = 0;
// //       for (var it in items) {
// //         remainingItemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
// //       }

// //       final pendingBalance =
// //           originalWeight - newSoldWeight - remainingItemsWeight;

// //       // ============================================================
// //       // ✅ القرار: نحذف الطقم ولا لأ؟
// //       // ============================================================

// //       // الحالة 1: مفيش قطع + مفيش رصيد معلق → احذف الطقم
// //       if (items.isEmpty && pendingBalance <= 0.001) {
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(uid)
// //             .collection('setRemainders')
// //             .doc(kitDocId)
// //             .delete();

// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content:
// //                   Text('✅ تم تحويل جميع القطع واكتمل الرصيد — تم حذف الطقم'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //           await _calculateTotalRemainingWeight();
// //           _backToKits();
// //         }
// //       }
// //       // الحالة 2: مفيش قطع بس لسه فيه رصيد معلق → متحذفش الطقم
// //       else if (items.isEmpty && pendingBalance > 0.001) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                   '✅ تم تحويل "$componentName" — الرصيد المعلق: ${pendingBalance.toStringAsFixed(2)} جم. استخدم زر "إضافة قطعة من الرصيد" لتوزيعه.'),
// //               backgroundColor: Colors.green,
// //               duration: const Duration(seconds: 4),
// //             ),
// //           );
// //           await _calculateTotalRemainingWeight();
// //           _backToItemsList();
// //           setState(() {});
// //         }
// //       }
// //       // الحالة 3: لسه فيه قطع متبقية
// //       else {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                   '✅ تم تحويل القطعة "$componentName" بنجاح (متبقي ${items.length} قطع)'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //           await _calculateTotalRemainingWeight();
// //           _backToItemsList();
// //           setState(() {});
// //         }
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(
// //                 '${_t('فشل التحويل', 'Failed to convert')}: ${e.toString()}'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       setState(() => _isConverting = false);
// //     }
// //   }

// //   // ============================================================
// //   // ✅ إضافة قطعة جديدة من الرصيد المعلق
// //   // ============================================================
// //   Future<void> _addPartFromBalance({
// //     required String name,
// //     required double weight,
// //     required String qrCode,
// //     required String category,
// //     required String uid,
// //   }) async {
// //     try {
// //       setState(() => _isConverting = true);

// //       final kitData = _openKitData!;
// //       final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});

// //       final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
// //           (payload['weight'] as num?)?.toDouble() ??
// //           0;
// //       final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
// //       final items = List<dynamic>.from(payload['remainingItems'] ?? []);
// //       double itemsWeight = 0;
// //       for (var it in items) {
// //         itemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
// //       }
// //       final pending = originalWeight - soldWeight - itemsWeight;

// //       if (weight > pending + 0.001) {
// //         throw Exception('الوزن أكبر من الرصيد المتاح');
// //       }

// //       final epcHex = _epcHex.isNotEmpty ? _epcHex : qrCode;

// //       // 1) حفظ القطعة كـ item مستقل
// //       final newPayload = {
// //         'weight': weight,
// //         'qrCode': qrCode,
// //         'kind': name,
// //         'isFromKit': true,
// //         'kitDocId': _openKitDocId,
// //         'originalKitWeight': originalWeight,
// //         'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
// //         'notes': 'أُضيفت من الرصيد المعلق للطقم ${payload['kind'] ?? ''}',
// //         'carat': payload['carat'] ?? '21',
// //         'size': payload['size'] ?? '0',
// //         'wage': payload['wage'] ?? 0,
// //         'showQr': true,
// //         'images': [],
// //       };

// //       await FS.saveItem(
// //         epcHex: epcHex,
// //         category: category,
// //         date: DateTime.now(),
// //         payload: newPayload,
// //         fromOpeningBalance: false,
// //       );

// //       if (_selectedImage != null) {
// //         await _uploadImage(epcHex);
// //       }

// //       // 2) تحديث الرصيد — نزيد soldWeight (يقلل pending)
// //       final newSoldWeight = soldWeight + weight;
// //       final newPending = originalWeight - newSoldWeight - itemsWeight;

// //       if (newPending <= 0.001) {
// //         // ✅ الرصيد خلص → امسح الطقم بالكامل
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(uid)
// //             .collection('setRemainders')
// //             .doc(_openKitDocId)
// //             .delete();

// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content:
// //                   Text('✅ تم حفظ القطعة واكتمل توزيع الرصيد — تم حذف الطقم'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //           await _calculateTotalRemainingWeight();
// //           _backToKits();
// //         }
// //       } else {
// //         // لسه فيه رصيد → حدّث الطقم وارجع لصفحة الطقم
// //         await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(uid)
// //             .collection('setRemainders')
// //             .doc(_openKitDocId)
// //             .update({
// //           'payload.soldWeight': newSoldWeight,
// //           'updatedAt': FieldValue.serverTimestamp(),
// //         });

// //         if (mounted) {
// //           setState(() {
// //             _openKitData!['payload']['soldWeight'] = newSoldWeight;
// //             _isAddingFromBalance = false;
// //             _selectedPartName = 'خاتم';
// //             weightController.clear();
// //             qrController.text = const Uuid().v4().substring(0, 7);
// //             _clearEpc();
// //             _selectedImage = null;
// //             _pinImage = false;
// //           });

// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(
// //                   '✅ تم حفظ "$name" — الرصيد المتبقي: ${newPending.toStringAsFixed(2)} جم'),
// //               backgroundColor: Colors.green,
// //             ),
// //           );
// //           await _calculateTotalRemainingWeight();
// //         }
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('${_t('فشل الحفظ', 'Failed')}: $e'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) setState(() => _isConverting = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     final uid = FirebaseAuth.instance.currentUser?.uid;

// //     if (uid == null) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: Text(_t("بقايا الاطقم", "Remaining Kits")),
// //           backgroundColor: const Color(0xFFD4AF37),
// //         ),
// //         body: Center(
// //           child: Text(
// //             _t('يرجى تسجيل الدخول أولاً', 'Please login first'),
// //             style: const TextStyle(fontSize: 18),
// //           ),
// //         ),
// //       );
// //     }

// //     if (_showKitItems && _openKitData != null) {
// //       if (_isAddingFromBalance) {
// //         return _buildAddFromBalanceView(uid);
// //       }
// //       if (_showItemDetails && _selectedItem != null) {
// //         return _buildItemDetailsView(uid);
// //       }
// //       return _buildKitItemsView(uid);
// //     }

// //     Query q = FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(uid)
// //         .collection('setRemainders')
// //         .orderBy('createdAt', descending: true);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("بقايا الاطقم", "Remaining Kits")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: () {
// //               _calculateTotalRemainingWeight();
// //               setState(() {});
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //         decoration: BoxDecoration(
// //           color: theme.colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             // ✅ عرض إجمالي الجرامات فقط
// //             Container(
// //               padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [
// //                     Color(0xFFD4AF37),
// //                     Color(0xFFB8860B),
// //                   ],
// //                   begin: Alignment.centerLeft,
// //                   end: Alignment.centerRight,
// //                 ),
// //                 borderRadius: const BorderRadius.vertical(
// //                   top: Radius.circular(20),
// //                 ),
// //               ),
// //               child: _isLoadingTotal
// //                   ? const Center(
// //                       child: SizedBox(
// //                         height: 20,
// //                         width: 20,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           valueColor:
// //                               AlwaysStoppedAnimation<Color>(Colors.white),
// //                         ),
// //                       ),
// //                     )
// //                   : Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Container(
// //                           padding: const EdgeInsets.all(10),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.2),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: const Icon(
// //                             Icons.scale,
// //                             color: Colors.white,
// //                             size: 24,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Directionality(
// //                           textDirection: ui.TextDirection.rtl,
// //                           child: Row(
// //                             crossAxisAlignment: CrossAxisAlignment.center,
// //                             children: [
// //                               Text(
// //                                 _t('إجمالي الجرامات المعلقه',
// //                                     'Total Remaining Weight'),
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontSize: 15,
// //                                 ),
// //                               ),
// //                               Container(
// //                                 margin:
// //                                     const EdgeInsets.symmetric(horizontal: 8),
// //                                 width: 2,
// //                                 height: 25,
// //                                 color: const ui.Color.fromARGB(255, 28, 27, 27),
// //                               ),
// //                               Text(
// //                                 '${_totalRemainingWeight.toStringAsFixed(2)}',
// //                                 style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 20,
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 _t('جم', 'g'),
// //                                 style: const TextStyle(
// //                                   color: Colors.white70,
// //                                   fontSize: 14,
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //             ),
// //             Expanded(
// //               child: StreamBuilder<QuerySnapshot>(
// //                 stream: q.snapshots(),
// //                 builder: (ctx, snap) {
// //                   if (!snap.hasData) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   }

// //                   final docs = snap.data!.docs;
// //                   if (docs.isEmpty) {
// //                     return _buildEmptyState(
// //                       icon: Icons.inventory_2_outlined,
// //                       title: _t('لا يوجد بقايا أطقم', 'No Set Remainders'),
// //                       subtitle: _t('لم يتم تسجيل أي بيع جزئي للأطقم',
// //                           'No partial set sales recorded'),
// //                     );
// //                   }

// //                   return ListView(
// //                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
// //                     children: [
// //                       ...docs.map((doc) {
// //                         final data = doc.data() as Map<String, dynamic>;
// //                         return _buildKitCard(
// //                           data: data,
// //                           docId: doc.id,
// //                           onOpen: () => _openKit(data, doc.id),
// //                         );
// //                       }),
// //                     ],
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildItemDetailsView(String uid) {
// //     final kitData = _openKitData!;
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final category = kitData['category'] as String? ?? 'gold';
// //     final item = _selectedItem!;
// //     final index = _selectedIndex!;
// //     final components = _getSetComponents(kitData);
// //     final componentName = item['name'] ??
// //         (index < components.length ? components[index] : 'قطعة ${index + 1}');

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           _t('تفاصيل القطعة', 'Item Details'),
// //           style: const TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// //           onPressed: _backToItemsList,
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               _isPrinterConnected ? Icons.print : Icons.print_disabled,
// //               color: Colors.white,
// //             ),
// //             onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
// //             tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Form(
// //             key: _itemFormKey,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFD4AF37).withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Container(
// //                           width: 36,
// //                           height: 36,
// //                           decoration: const BoxDecoration(
// //                             color: Color(0xFFD4AF37),
// //                             shape: BoxShape.circle,
// //                           ),
// //                           child: Center(
// //                             child: Text(
// //                               '${index + 1}',
// //                               style: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 16,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Text(
// //                             componentName,
// //                             style: const TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                               color: Color(0xFFD4AF37),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   if (_epcHex.isNotEmpty) ...[
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 8),
// //                       decoration: BoxDecoration(
// //                         color: _isReadFromChip
// //                             ? Colors.green.withOpacity(0.1)
// //                             : Colors.grey.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                           color: _isReadFromChip
// //                               ? Colors.green
// //                               : Colors.grey.shade300,
// //                         ),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(
// //                             _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
// //                             size: 16,
// //                             color: _isReadFromChip ? Colors.green : Colors.grey,
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               'EPC: $_epcHex',
// //                               style: TextStyle(
// //                                 fontFamily: 'monospace',
// //                                 fontSize: 12,
// //                                 color: _isReadFromChip
// //                                     ? Colors.green.shade700
// //                                     : Colors.grey,
// //                                 fontWeight: _isReadFromChip
// //                                     ? FontWeight.bold
// //                                     : FontWeight.normal,
// //                               ),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                           if (_isReadFromChip) ...[
// //                             const SizedBox(width: 4),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 2),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.green.withOpacity(0.2),
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                               child: Text(
// //                                 _t('مقروء', 'Read'),
// //                                 style: const TextStyle(
// //                                   color: Colors.green,
// //                                   fontSize: 10,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                             IconButton(
// //                               icon: const Icon(Icons.clear, size: 16),
// //                               onPressed: _clearEpc,
// //                               tooltip: _t('مسح', 'Clear'),
// //                               padding: EdgeInsets.zero,
// //                               constraints: const BoxConstraints(),
// //                             ),
// //                           ],
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                   ],
// //                   TextFormField(
// //                     controller: weightController,
// //                     focusNode: _weightFocusNode,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
// //                       prefixIcon:
// //                           const Icon(Icons.scale, color: Color(0xFFD4AF37)),
// //                       border: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide(
// //                           color: Colors.grey.shade300,
// //                         ),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                         borderSide: BorderSide(
// //                           color: Color(0xFFD4AF37),
// //                           width: 2,
// //                         ),
// //                       ),
// //                       suffixText: 'جم',
// //                       hintText: _t('أدخل وزن القطعة', 'Enter part weight'),
// //                     ),
// //                     onTap: () {
// //                       _weightFocusNode.requestFocus();
// //                       if (weightController.text == '0.00' ||
// //                           weightController.text == '0') {
// //                         WidgetsBinding.instance.addPostFrameCallback((_) {
// //                           weightController.clear();
// //                         });
// //                       } else {
// //                         WidgetsBinding.instance.addPostFrameCallback((_) {
// //                           weightController.selection = TextSelection(
// //                             baseOffset: 0,
// //                             extentOffset: weightController.text.length,
// //                           );
// //                         });
// //                       }
// //                     },
// //                     onEditingComplete: () {
// //                       _weightFocusNode.unfocus();
// //                     },
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return _t('يرجى إدخال الوزن', 'Please enter weight');
// //                       }
// //                       final weight = double.tryParse(value);
// //                       if (weight == null || weight <= 0) {
// //                         return _t('وزن غير صحيح', 'Invalid weight');
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextFormField(
// //                     controller: qrController,
// //                     readOnly: true,
// //                     focusNode: FocusNode(canRequestFocus: false),
// //                     decoration: InputDecoration(
// //                       labelText: useScanner
// //                           ? _t("QR من الماسح", "QR from Scanner")
// //                           : _t("QR عشوائي", "Random QR"),
// //                       border: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                       ),
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           useScanner ? Icons.qr_code_scanner : Icons.shuffle,
// //                         ),
// //                         tooltip: useScanner
// //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// //                             : _t("استخدام الماسح", "Use Scanner"),
// //                         onPressed: _toggleQRMode,
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return _t('يرجى إدخال الكود', 'Please enter code');
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),
// //                   Center(
// //                     child: ElevatedButton.icon(
// //                       onPressed: _pickImage,
// //                       icon: const Icon(Icons.camera_alt),
// //                       label: const Text('تصوير صورة'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   if (_selectedImage != null) ...[
// //                     const SizedBox(height: 16),
// //                     Center(
// //                       child: SizedBox(
// //                         height: 200,
// //                         child: Image.file(
// //                           _selectedImage!,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Center(
// //                       child: OutlinedButton.icon(
// //                         onPressed: () {
// //                           setState(() {
// //                             _pinImage = !_pinImage;
// //                           });
// //                         },
// //                         icon: Icon(
// //                           _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// //                           color: _pinImage ? Colors.orange : null,
// //                         ),
// //                         label: Text(
// //                           _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// //                         ),
// //                         style: OutlinedButton.styleFrom(
// //                           side: BorderSide(
// //                             color: _pinImage ? Colors.orange : Colors.grey,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   const SizedBox(height: 20),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: ElevatedButton.icon(
// //                           onPressed: (_isConverting || _isPrinting)
// //                               ? null
// //                               : () async {
// //                                   if (_itemFormKey.currentState?.validate() ??
// //                                       false) {
// //                                     final weight = weightController.text;
// //                                     final qrCode = qrController.text.trim();

// //                                     await _printConvertedItemLabel(
// //                                       name: componentName,
// //                                       weight: weight,
// //                                       qrCode: qrCode,
// //                                     );

// //                                     if (!_isPrimaryScanner) {
// //                                       setState(() {
// //                                         _showManualEpcField = true;
// //                                         _manualEpcController.clear();
// //                                       });
// //                                       WidgetsBinding.instance
// //                                           .addPostFrameCallback((_) {
// //                                         if (mounted) {
// //                                           FocusScope.of(context)
// //                                               .requestFocus(_manualEpcFocus);
// //                                         }
// //                                       });
// //                                     }
// //                                   }
// //                                 },
// //                           icon: _isPrinting
// //                               ? const SizedBox(
// //                                   width: 20,
// //                                   height: 20,
// //                                   child: CircularProgressIndicator(
// //                                     strokeWidth: 2,
// //                                     color: Colors.white,
// //                                   ),
// //                                 )
// //                               : const Icon(Icons.print),
// //                           label: Text(
// //                             _isPrinting
// //                                 ? _t('جاري الطباعة...', 'Printing...')
// //                                 : _t('طباعة ليبل الذهب', 'Print Gold Label'),
// //                           ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: _isPrinterConnected
// //                                 ? const Color(0xFFD4AF37)
// //                                 : Colors.green,
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 14),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       SizedBox(
// //                         width: 50,
// //                         height: 50,
// //                         child: OutlinedButton(
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.zero,
// //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           onPressed: () => _showProfilePicker('gold'),
// //                           child: const Icon(
// //                             Icons.settings,
// //                             color: Color(0xFFD4AF37),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   if (!_isPrimaryScanner && _showManualEpcField) ...[
// //                     TextField(
// //                       controller: _manualEpcController,
// //                       focusNode: _manualEpcFocus,
// //                       textCapitalization: TextCapitalization.characters,
// //                       textInputAction: TextInputAction.done,
// //                       decoration: const InputDecoration(
// //                         labelText: 'أدخل رقم الشريحة',
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(10)),
// //                         ),
// //                         prefixIcon: Icon(Icons.nfc),
// //                       ),
// //                       onSubmitted: (value) {
// //                         if (value.trim().isNotEmpty) {
// //                           addEpcManualy(value.trim());
// //                         } else {
// //                           setState(() {
// //                             _showManualEpcField = false;
// //                             _manualEpcController.clear();
// //                           });
// //                           _manualEpcFocus.unfocus();
// //                         }
// //                       },
// //                     ),
// //                     const SizedBox(height: 12),
// //                   ],
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: _isConverting
// //                           ? null
// //                           : () async {
// //                               if (_itemFormKey.currentState?.validate() ??
// //                                   false) {
// //                                 final weight =
// //                                     double.parse(weightController.text);
// //                                 final qrCode = qrController.text.trim();

// //                                 if (_epcHex.isEmpty) {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     const SnackBar(
// //                                       content: Text(
// //                                           '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
// //                                       backgroundColor: Colors.orange,
// //                                     ),
// //                                   );
// //                                   return;
// //                                 }

// //                                 final itemData = {
// //                                   'name': componentName,
// //                                   'weight': weight,
// //                                   'qrCode': qrCode,
// //                                 };

// //                                 await _convertSinglePartToItem(
// //                                   index: index,
// //                                   item: itemData,
// //                                   category: category,
// //                                   kitData: kitData,
// //                                   kitDocId: _openKitDocId!,
// //                                   uid: uid,
// //                                 );
// //                               }
// //                             },
// //                       icon: _isConverting
// //                           ? const SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Icon(Icons.save),
// //                       label: Text(
// //                         _isConverting
// //                             ? _t('جاري التحويل...', 'Converting...')
// //                             : _t('تحويل القطعة', 'Convert Part'),
// //                       ),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // ✅ فورم إضافة قطعة جديدة من الرصيد المعلق
// //   // ============================================================
// //   Widget _buildAddFromBalanceView(String uid) {
// //     final kitData = _openKitData!;
// //     final category = kitData['category'] as String? ?? 'gold';

// //     final originalWeight = _getOriginalWeight(kitData);
// //     final soldWeight = _getSoldWeight(kitData);
// //     final itemsWeight = _getRemainingItemsWeight(kitData);
// //     final pending = originalWeight - soldWeight - itemsWeight;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           _t('إضافة قطعة من الرصيد', 'Add Part from Balance'),
// //           style: const TextStyle(color: Colors.white),
// //         ),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// //           onPressed: () {
// //             setState(() {
// //               _isAddingFromBalance = false;
// //               _selectedPartName = 'خاتم';
// //               weightController.clear();
// //               qrController.text = const Uuid().v4().substring(0, 7);
// //               _clearEpc();
// //               _selectedImage = null;
// //               _pinImage = false;
// //             });
// //           },
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               _isPrinterConnected ? Icons.print : Icons.print_disabled,
// //               color: Colors.white,
// //             ),
// //             onPressed: _isPrinterConnected ? null : _selectAndConnectPrinter,
// //             tooltip: _isPrinterConnected ? "طابعة متصلة" : "اتصال بالطابعة",
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Form(
// //             key: _itemFormKey,
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // بادج الرصيد المعلق المتاح
// //                   Container(
// //                     width: double.infinity,
// //                     padding: const EdgeInsets.all(12),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFD4AF37).withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         const Icon(Icons.account_balance_wallet,
// //                             color: Color(0xFFD4AF37)),
// //                         const SizedBox(width: 12),
// //                         Expanded(
// //                           child: Text(
// //                             '${_t('الرصيد المعلق المتاح', 'Available pending balance')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: Color(0xFFD4AF37),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // ✅ اسم القطعة (قائمة منسدلة)
// //                   DropdownButtonFormField<String>(
// //                     initialValue: _selectedPartName,
// //                     decoration: InputDecoration(
// //                       labelText: _t('اسم القطعة', 'Part name'),
// //                       prefixIcon:
// //                           const Icon(Icons.category, color: Color(0xFFD4AF37)),
// //                       border: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide(color: Colors.grey.shade300),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                         borderSide: BorderSide(
// //                           color: Color(0xFFD4AF37),
// //                           width: 2,
// //                         ),
// //                       ),
// //                     ),
// //                     items: partNameOptions.map((String type) {
// //                       return DropdownMenuItem<String>(
// //                         value: type,
// //                         child: Text(type),
// //                       );
// //                     }).toList(),
// //                     onChanged: (String? v) {
// //                       if (v != null) {
// //                         setState(() => _selectedPartName = v);
// //                       }
// //                     },
// //                     validator: (v) => (v == null || v.trim().isEmpty)
// //                         ? _t(
// //                             'يرجى اختيار اسم القطعة', 'Please select part name')
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // EPC
// //                   if (_epcHex.isNotEmpty) ...[
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 8),
// //                       decoration: BoxDecoration(
// //                         color: _isReadFromChip
// //                             ? Colors.green.withOpacity(0.1)
// //                             : Colors.grey.shade100,
// //                         borderRadius: BorderRadius.circular(8),
// //                         border: Border.all(
// //                           color: _isReadFromChip
// //                               ? Colors.green
// //                               : Colors.grey.shade300,
// //                         ),
// //                       ),
// //                       child: Row(
// //                         children: [
// //                           Icon(
// //                             _isReadFromChip ? Icons.nfc : Icons.nfc_outlined,
// //                             size: 16,
// //                             color: _isReadFromChip ? Colors.green : Colors.grey,
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               'EPC: $_epcHex',
// //                               style: TextStyle(
// //                                 fontFamily: 'monospace',
// //                                 fontSize: 12,
// //                                 color: _isReadFromChip
// //                                     ? Colors.green.shade700
// //                                     : Colors.grey,
// //                                 fontWeight: _isReadFromChip
// //                                     ? FontWeight.bold
// //                                     : FontWeight.normal,
// //                               ),
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ),
// //                           if (_isReadFromChip) ...[
// //                             const SizedBox(width: 4),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 8, vertical: 2),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.green.withOpacity(0.2),
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                               child: Text(
// //                                 _t('مقروء', 'Read'),
// //                                 style: const TextStyle(
// //                                   color: Colors.green,
// //                                   fontSize: 10,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                           IconButton(
// //                             icon: const Icon(Icons.clear, size: 16),
// //                             onPressed: _clearEpc,
// //                             padding: EdgeInsets.zero,
// //                             constraints: const BoxConstraints(),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 12),
// //                   ],

// //                   // الوزن
// //                   TextFormField(
// //                     controller: weightController,
// //                     focusNode: _weightFocusNode,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
// //                       prefixIcon:
// //                           const Icon(Icons.scale, color: Color(0xFFD4AF37)),
// //                       helperText:
// //                           '${_t('الحد الأقصى', 'Max')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
// //                       border: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(10),
// //                         borderSide: BorderSide(color: Colors.grey.shade300),
// //                       ),
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                         borderSide: BorderSide(
// //                           color: Color(0xFFD4AF37),
// //                           width: 2,
// //                         ),
// //                       ),
// //                       suffixText: 'جم',
// //                     ),
// //                     onTap: () {
// //                       _weightFocusNode.requestFocus();
// //                     },
// //                     onEditingComplete: () {
// //                       _weightFocusNode.unfocus();
// //                     },
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return _t('يرجى إدخال الوزن', 'Please enter weight');
// //                       }
// //                       final w = double.tryParse(value);
// //                       if (w == null || w <= 0) {
// //                         return _t('وزن غير صحيح', 'Invalid weight');
// //                       }
// //                       if (w > pending + 0.001) {
// //                         return _t(
// //                           'الوزن أكبر من الرصيد المتاح (${pending.toStringAsFixed(2)} جم)',
// //                           'Weight exceeds available balance',
// //                         );
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // QR
// //                   TextFormField(
// //                     controller: qrController,
// //                     readOnly: true,
// //                     focusNode: FocusNode(canRequestFocus: false),
// //                     decoration: InputDecoration(
// //                       labelText: useScanner
// //                           ? _t("QR من الماسح", "QR from Scanner")
// //                           : _t("QR عشوائي", "Random QR"),
// //                       border: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10)),
// //                       ),
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           useScanner ? Icons.qr_code_scanner : Icons.shuffle,
// //                         ),
// //                         tooltip: useScanner
// //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// //                             : _t("استخدام الماسح", "Use Scanner"),
// //                         onPressed: _toggleQRMode,
// //                       ),
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return _t('يرجى إدخال الكود', 'Please enter code');
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // صورة
// //                   Center(
// //                     child: ElevatedButton.icon(
// //                       onPressed: _pickImage,
// //                       icon: const Icon(Icons.camera_alt),
// //                       label: const Text('تصوير صورة'),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   if (_selectedImage != null) ...[
// //                     const SizedBox(height: 16),
// //                     Center(
// //                       child: SizedBox(
// //                         height: 200,
// //                         child: Image.file(
// //                           _selectedImage!,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     Center(
// //                       child: OutlinedButton.icon(
// //                         onPressed: () {
// //                           setState(() {
// //                             _pinImage = !_pinImage;
// //                           });
// //                         },
// //                         icon: Icon(
// //                           _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// //                           color: _pinImage ? Colors.orange : null,
// //                         ),
// //                         label: Text(
// //                           _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// //                         ),
// //                         style: OutlinedButton.styleFrom(
// //                           side: BorderSide(
// //                             color: _pinImage ? Colors.orange : Colors.grey,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   const SizedBox(height: 20),

// //                   // طباعة
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: ElevatedButton.icon(
// //                           onPressed: (_isConverting || _isPrinting)
// //                               ? null
// //                               : () async {
// //                                   if (_itemFormKey.currentState?.validate() ??
// //                                       false) {
// //                                     await _printConvertedItemLabel(
// //                                       name: _selectedPartName,
// //                                       weight: weightController.text,
// //                                       qrCode: qrController.text.trim(),
// //                                     );

// //                                     if (!_isPrimaryScanner) {
// //                                       setState(() {
// //                                         _showManualEpcField = true;
// //                                         _manualEpcController.clear();
// //                                       });
// //                                       WidgetsBinding.instance
// //                                           .addPostFrameCallback((_) {
// //                                         if (mounted) {
// //                                           FocusScope.of(context)
// //                                               .requestFocus(_manualEpcFocus);
// //                                         }
// //                                       });
// //                                     }
// //                                   }
// //                                 },
// //                           icon: _isPrinting
// //                               ? const SizedBox(
// //                                   width: 20,
// //                                   height: 20,
// //                                   child: CircularProgressIndicator(
// //                                     strokeWidth: 2,
// //                                     color: Colors.white,
// //                                   ),
// //                                 )
// //                               : const Icon(Icons.print),
// //                           label: Text(
// //                             _isPrinting
// //                                 ? _t('جاري الطباعة...', 'Printing...')
// //                                 : _t('طباعة ليبل الذهب', 'Print Gold Label'),
// //                           ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: _isPrinterConnected
// //                                 ? const Color(0xFFD4AF37)
// //                                 : Colors.green,
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 14),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       SizedBox(
// //                         width: 50,
// //                         height: 50,
// //                         child: OutlinedButton(
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.zero,
// //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(10),
// //                             ),
// //                           ),
// //                           onPressed: () => _showProfilePicker('gold'),
// //                           child: const Icon(
// //                             Icons.settings,
// //                             color: Color(0xFFD4AF37),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),

// //                   // حقل EPC اليدوي
// //                   if (!_isPrimaryScanner && _showManualEpcField) ...[
// //                     TextField(
// //                       controller: _manualEpcController,
// //                       focusNode: _manualEpcFocus,
// //                       textCapitalization: TextCapitalization.characters,
// //                       textInputAction: TextInputAction.done,
// //                       decoration: const InputDecoration(
// //                         labelText: 'أدخل رقم الشريحة',
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(10)),
// //                         ),
// //                         prefixIcon: Icon(Icons.nfc),
// //                       ),
// //                       onSubmitted: (value) {
// //                         if (value.trim().isNotEmpty) {
// //                           addEpcManualy(value.trim());
// //                         } else {
// //                           setState(() {
// //                             _showManualEpcField = false;
// //                             _manualEpcController.clear();
// //                           });
// //                           _manualEpcFocus.unfocus();
// //                         }
// //                       },
// //                     ),
// //                     const SizedBox(height: 12),
// //                   ],

// //                   // حفظ
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: _isConverting
// //                           ? null
// //                           : () async {
// //                               if (!(_itemFormKey.currentState?.validate() ??
// //                                   false)) {
// //                                 return;
// //                               }
// //                               if (_epcHex.isEmpty) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   const SnackBar(
// //                                     content: Text(
// //                                         '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
// //                                     backgroundColor: Colors.orange,
// //                                   ),
// //                                 );
// //                                 return;
// //                               }

// //                               final name = _selectedPartName;
// //                               final weight =
// //                                   double.parse(weightController.text);
// //                               final qrCode = qrController.text.trim();

// //                               await _addPartFromBalance(
// //                                 name: name,
// //                                 weight: weight,
// //                                 qrCode: qrCode,
// //                                 category: category,
// //                                 uid: uid,
// //                               );
// //                             },
// //                       icon: _isConverting
// //                           ? const SizedBox(
// //                               width: 20,
// //                               height: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Icon(Icons.save),
// //                       label: Text(
// //                         _isConverting
// //                             ? _t('جاري الحفظ...', 'Saving...')
// //                             : _t('حفظ القطعة', 'Save Part'),
// //                       ),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildKitItemsView(String uid) {
// //     final kitData = _openKitData!;
// //     final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
// //     final kind = payload['kind'] ?? 'طقم';
// //     final category = kitData['category'] as String? ?? 'gold';

// //     final originalWeight = _getOriginalWeight(kitData);
// //     final soldWeight = _getSoldWeight(kitData);
// //     final remainingWeight = originalWeight - soldWeight;

// //     final components = _getSetComponents(kitData);
// //     final items = _getRemainingItems(kitData);
// //     final itemsWeight = _getRemainingItemsWeight(kitData);
// //     final isFullyDistributed = _isWeightFullyDistributed(kitData);
// //     final pendingBalance = remainingWeight - itemsWeight;

// //     if (items.isEmpty && components.isNotEmpty) {
// //       final newItems = components.map((name) {
// //         return {
// //           'name': name,
// //           'weight': 0.0,
// //           'qrCode': '',
// //           'createdAt': DateTime.now().toIso8601String(),
// //         };
// //       }).toList();

// //       FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(uid)
// //           .collection('setRemainders')
// //           .doc(_openKitDocId)
// //           .update({
// //         'payload.remainingItems': newItems,
// //       }).then((_) {
// //         setState(() {
// //           _openKitData!['payload']['remainingItems'] = newItems;
// //         });
// //       });

// //       _openKitData!['payload']['remainingItems'] = newItems;
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("قطع $kind المتبقية", "Remaining $kind Parts")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: _backToKits,
// //         ),
// //         actions: [
// //           Container(
// //             margin: const EdgeInsets.symmetric(horizontal: 16),
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Text(
// //               '${remainingWeight.toStringAsFixed(2)} جم',
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFFD4AF37),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       // ✅ FAB إضافي لإضافة قطعة من الرصيد

// //       body: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFD4AF37).withOpacity(0.1),
// //                 borderRadius: const BorderRadius.vertical(
// //                   top: Radius.circular(20),
// //                 ),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(
// //                           '${_t('الطقم', 'Set')}: $kind',
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 12,
// //                           vertical: 6,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color:
// //                               isFullyDistributed ? Colors.green : Colors.orange,
// //                           borderRadius: BorderRadius.circular(20),
// //                         ),
// //                         child: Text(
// //                           isFullyDistributed
// //                               ? _t('مكتمل ✅', 'Complete ✅')
// //                               : '${pendingBalance.toStringAsFixed(2)} جم متبقي',
// //                           style: const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 12,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 8),
// //                   if (components.isNotEmpty) ...[
// //                     Text(
// //                       _t('مكونات الطقم:', 'Set Components:'),
// //                       style: const TextStyle(
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Wrap(
// //                       spacing: 6,
// //                       runSpacing: 4,
// //                       children: components.map((comp) {
// //                         return Chip(
// //                           label: Text(comp),
// //                           backgroundColor:
// //                               const Color(0xFFD4AF37).withOpacity(0.2),
// //                           labelStyle: const TextStyle(
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                           avatar: const Icon(
// //                             Icons.check_circle,
// //                             size: 16,
// //                             color: Color(0xFFD4AF37),
// //                           ),
// //                         );
// //                       }).toList(),
// //                     ),
// //                     const SizedBox(height: 8),
// //                   ],
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               '${_t('الوزن الأصلي', 'Original Weight')}: ${originalWeight.toStringAsFixed(2)} جم',
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Colors.black87,
// //                               ),
// //                             ),
// //                             Text(
// //                               '${_t('الوزن المحول', 'Converted Weight')}: ${soldWeight.toStringAsFixed(2)} جم',
// //                               style: TextStyle(
// //                                 color: Colors.grey[700],
// //                               ),
// //                             ),
// //                             Text(
// //                               '${_t('الوزن المتبقي', 'Remaining Weight')}: ${remainingWeight.toStringAsFixed(2)} جم',
// //                               style: TextStyle(
// //                                 color: Colors.grey[700],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       if (!isFullyDistributed)
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.end,
// //                           children: [
// //                             Text(
// //                               _t('تم تحويل', 'Converted'),
// //                               style: TextStyle(
// //                                 fontSize: 11,
// //                                 color: Colors.grey[600],
// //                               ),
// //                             ),
// //                             Text(
// //                               '${itemsWeight.toStringAsFixed(2)} جم',
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Color(0xFFD4AF37),
// //                               ),
// //                             ),
// //                             Text(
// //                               '${pendingBalance.toStringAsFixed(2)} جم ${_t('متبقي', 'left')}',
// //                               style: TextStyle(
// //                                 fontSize: 11,
// //                                 color: Colors.orange[700],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               child: items.isEmpty
// //                   ? Center(
// //                       child: SingleChildScrollView(
// //                         padding: const EdgeInsets.all(20),
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Icon(
// //                               Icons.inbox_outlined,
// //                               size: 64,
// //                               color: Colors.grey[400],
// //                             ),
// //                             const SizedBox(height: 16),
// //                             Text(
// //                               _t('لا توجد قطع متبقية', 'No remaining parts'),
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 color: Colors.grey[600],
// //                               ),
// //                             ),
// //                             if (pendingBalance > 0.001) ...[
// //                               const SizedBox(height: 12),
// //                               Text(
// //                                 '${_t('الرصيد المعلق', 'Pending balance')}: ${pendingBalance.toStringAsFixed(2)} جم',
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.orange[700],
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 24),
// //                               // ✅ زرار كبير واضح جوه الصفحة
// //                               SizedBox(
// //                                 width: double.infinity,
// //                                 child: ElevatedButton.icon(
// //                                   onPressed: _openAddFromBalanceForm,
// //                                   icon: const Icon(Icons.add_circle_outline,
// //                                       color: Colors.white, size: 24),
// //                                   label: Text(
// //                                     _t('إضافة قطعة من الرصيد',
// //                                         'Add Part from Balance'),
// //                                     style: const TextStyle(
// //                                       fontSize: 16,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                   style: ElevatedButton.styleFrom(
// //                                     backgroundColor: const Color(0xFFD4AF37),
// //                                     foregroundColor: Colors.white,
// //                                     padding: const EdgeInsets.symmetric(
// //                                         vertical: 16, horizontal: 20),
// //                                     shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(12),
// //                                     ),
// //                                     elevation: 4,
// //                                   ),
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 12),
// //                               Padding(
// //                                 padding:
// //                                     const EdgeInsets.symmetric(horizontal: 16),
// //                                 child: Text(
// //                                   _t(
// //                                     'هيفتحلك فورم تدخل فيه اسم القطعة ووزنها، وكل ما تحفظ قطعة الرصيد هيقل لحد ما يخلص.',
// //                                     'A form will open to enter the part name and weight. Each time you save a part, the balance decreases until it reaches zero.',
// //                                   ),
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(
// //                                     fontSize: 12,
// //                                     color: Colors.grey[500],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ),
// //                     )
// //                   : ListView.builder(
// //                       padding: const EdgeInsets.all(8),
// //                       itemCount: items.length,
// //                       itemBuilder: (context, index) {
// //                         final item = items[index];
// //                         final componentName = item['name'] ??
// //                             (index < components.length
// //                                 ? components[index]
// //                                 : 'قطعة ${index + 1}');
// //                         final weight =
// //                             (item['weight'] as num?)?.toDouble() ?? 0;
// //                         final qrCode = item['qrCode']?.toString() ?? '';

// //                         return Card(
// //                           margin: const EdgeInsets.only(bottom: 8),
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                             side: BorderSide(
// //                               color: const Color(0xFFD4AF37).withOpacity(0.3),
// //                               width: 1,
// //                             ),
// //                           ),
// //                           child: InkWell(
// //                             onTap: () => _openItemDetails(item, index),
// //                             borderRadius: BorderRadius.circular(12),
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(12),
// //                               child: Row(
// //                                 children: [
// //                                   Container(
// //                                     width: 32,
// //                                     height: 32,
// //                                     decoration: const BoxDecoration(
// //                                       color: Color(0xFFD4AF37),
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                     child: Center(
// //                                       child: Text(
// //                                         '${index + 1}',
// //                                         style: const TextStyle(
// //                                           color: Colors.white,
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(width: 12),
// //                                   Expanded(
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text(
// //                                           componentName,
// //                                           style: const TextStyle(
// //                                             fontSize: 16,
// //                                             fontWeight: FontWeight.bold,
// //                                           ),
// //                                         ),
// //                                         if (qrCode.isNotEmpty)
// //                                           Text(
// //                                             'QR: $qrCode',
// //                                             style: TextStyle(
// //                                               fontSize: 11,
// //                                               color: Colors.grey[600],
// //                                             ),
// //                                           ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   Column(
// //                                     crossAxisAlignment: CrossAxisAlignment.end,
// //                                     children: [
// //                                       Text(
// //                                         '${weight.toStringAsFixed(2)} جم',
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           color: Color(0xFFD4AF37),
// //                                         ),
// //                                       ),
// //                                       Icon(
// //                                         Icons.arrow_forward_ios,
// //                                         size: 14,
// //                                         color: Colors.grey[400],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //             ),
// //             // ✅ زرار سفلي دائمًا ظاهر لما فيه رصيد معلق + فيه قطع
// //             if (pendingBalance > 0.001 && items.isNotEmpty)
// //               Container(
// //                 padding: const EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFFD4AF37).withOpacity(0.08),
// //                   borderRadius: const BorderRadius.vertical(
// //                     bottom: Radius.circular(20),
// //                   ),
// //                 ),
// //                 child: SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     onPressed: _openAddFromBalanceForm,
// //                     icon: const Icon(Icons.add_circle_outline,
// //                         color: Colors.white, size: 22),
// //                     label: Text(
// //                       '${_t('إضافة قطعة من الرصيد', 'Add Part from Balance')} (${pendingBalance.toStringAsFixed(2)} جم)',
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFFD4AF37),
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildKitCard({
// //     required Map<String, dynamic> data,
// //     required String docId,
// //     required VoidCallback onOpen,
// //   }) {
// //     final payload = data['payload'] as Map<String, dynamic>? ?? {};
// //     final category = data['category'] as String? ?? '';
// //     final kind = payload['kind'] ?? 'طقم';
// //     final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

// //     final originalWeight = _getOriginalWeight(data);
// //     final soldWeight = _getSoldWeight(data);
// //     final remainingWeight = originalWeight - soldWeight;
// //     final items = _getRemainingItems(data);
// //     final itemsCount = items.length;
// //     final isFullyDistributed = _isWeightFullyDistributed(data);
// //     final components = _getSetComponents(data);

// //     Color categoryColor;
// //     IconData categoryIcon;
// //     switch (category) {
// //       case 'gold':
// //         categoryColor = const Color(0xFFD4AF37);
// //         categoryIcon = Icons.workspace_premium_rounded;
// //         break;
// //       case 'gem':
// //         categoryColor = Colors.purple;
// //         categoryIcon = Icons.diamond_rounded;
// //         break;
// //       case 'bullion':
// //         categoryColor = Colors.blue;
// //         categoryIcon = Icons.account_balance;
// //         break;
// //       default:
// //         categoryColor = Colors.grey;
// //         categoryIcon = Icons.help_outline_rounded;
// //     }

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(12),
// //         side: BorderSide(
// //           color: categoryColor.withOpacity(0.3),
// //           width: 1,
// //         ),
// //       ),
// //       child: InkWell(
// //         onTap: onOpen,
// //         borderRadius: BorderRadius.circular(12),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   Container(
// //                     padding: const EdgeInsets.all(8),
// //                     decoration: BoxDecoration(
// //                       color: categoryColor.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(8),
// //                     ),
// //                     child: Icon(
// //                       categoryIcon,
// //                       color: categoryColor,
// //                       size: 24,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           kind,
// //                           style: const TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         Text(
// //                           category,
// //                           style: TextStyle(
// //                             fontSize: 12,
// //                             color: Colors.grey[600],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 10,
// //                       vertical: 4,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: isFullyDistributed ? Colors.green : Colors.orange,
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Text(
// //                       isFullyDistributed
// //                           ? _t('مكتمل', 'Complete')
// //                           : '${remainingWeight.toStringAsFixed(2)} جم',
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 12,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 8),
// //               if (components.isNotEmpty) ...[
// //                 Wrap(
// //                   spacing: 4,
// //                   runSpacing: 4,
// //                   children: components.map((comp) {
// //                     return Chip(
// //                       label: Text(
// //                         comp,
// //                         style: const TextStyle(fontSize: 11),
// //                       ),
// //                       backgroundColor: categoryColor.withOpacity(0.15),
// //                       padding: const EdgeInsets.symmetric(horizontal: 2),
// //                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 8),
// //               ],
// //               Row(
// //                 children: [
// //                   Icon(Icons.scale, size: 16, color: Colors.grey[600]),
// //                   const SizedBox(width: 4),
// //                   Text(
// //                     '${originalWeight.toStringAsFixed(2)} جم',
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600]),
// //                   const SizedBox(width: 4),
// //                   Text(
// //                     '${soldWeight.toStringAsFixed(2)} جم',
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                   const Spacer(),
// //                   Icon(Icons.grid_view, size: 16, color: Colors.grey[600]),
// //                   const SizedBox(width: 4),
// //                   Text(
// //                     '$itemsCount ${_t('قطعة', 'Parts')}',
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                 ],
// //               ),
// //               if (createdAt != null) ...[
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
// //                   style: TextStyle(
// //                     fontSize: 11,
// //                     color: Colors.grey[500],
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //   }) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(24),
// //             decoration: BoxDecoration(
// //               color: Colors.grey.shade100,
// //               borderRadius: BorderRadius.circular(20),
// //             ),
// //             child: Icon(
// //               icon,
// //               size: 48,
// //               color: Colors.grey.shade400,
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.grey.shade600,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             subtitle,
// //             style: TextStyle(
// //               fontSize: 14,
// //               color: Colors.grey.shade500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import '../services/new_printer_api.dart';
import '../services/new_printer_status.dart';
import 'dart:async';
import 'label_layout_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_compressor.dart';

class RemainingKitsPage extends StatefulWidget {
  const RemainingKitsPage({super.key});

  @override
  State<RemainingKitsPage> createState() => _RemainingKitsPageState();
}

class _RemainingKitsPageState extends State<RemainingKitsPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  Map<String, dynamic>? _openKitData;
  String? _openKitDocId;
  bool _showKitItems = false;

  Map<String, dynamic>? _selectedItem;
  int? _selectedIndex;
  bool _showItemDetails = false;

  bool _isPrinting = false;
  bool _isPrinterConnected = false;
  String _connectedPrinterName = "غير متصلة";
  String? _connectedPrinterMac;
  String? _errorMessage;
  String? _successMessage;
  String? _progressMessage;
  StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

  bool _isPrimaryScanner = false;
  StreamSubscription<String>? _tagSubscription;

  final TextEditingController qrController = TextEditingController();
  bool useScanner = false;

  final TextEditingController weightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();

  String _epcHex = '';
  bool _isReadFromChip = false;
  bool _isReading = false;

  bool _showManualEpcField = false;
  final TextEditingController _manualEpcController = TextEditingController();
  final FocusNode _manualEpcFocus = FocusNode();

  bool _isConverting = false;
  LabelProfile? _activeProfile;

  final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool _pinImage = false;

  // ✅ فقط إجمالي الجرامات
  double _totalRemainingWeight = 0.0;
  bool _isLoadingTotal = false;

  // ✅ إضافة قطعة من الرصيد المعلق
  bool _isAddingFromBalance = false;
  String _selectedPartName = 'خاتم';

  // ✅ قائمة أسماء القطع (بدون أطقم)
  final List<String> partNameOptions = [
    'خاتم',
    'اسورة',
    'خاتم و اسورة',
    'بنجرة',
    'حلق',
    'خلخال',
    'تعليقة',
    'حزام',
    'تاج',
    'كف',
    'عقد',
    'انسيال',
    'سلسال',
    'شوكر',
    'طوق',
    'مخنق',
    'سبحة',
    'غير ذلك',
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadScannerMode();
    _listenToPrinterStatus();
    _listenToTagStream();
    _loadActiveProfile();
    _calculateTotalRemainingWeight();

    final randomQr = const Uuid().v4().substring(0, 7);
    qrController.text = randomQr;
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    _printerStatusSubscription?.cancel();
    _manualEpcController.dispose();
    _manualEpcFocus.dispose();
    qrController.dispose();
    weightController.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

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
    if (!mounted) return;
    setState(() {
      _isPrimaryScanner = mode == 'primary';
    });
  }

  // ============================================================
  // ✅ [FIX] دالة مساعدة لمسح قيم الـ EPC بدون setState
  //         عشان نتجنب setState جوه setState
  // ============================================================
  void _clearEpcValues() {
    _epcHex = '';
    _isReadFromChip = false;
    _showManualEpcField = false;
    _manualEpcController.clear();
  }

  void _clearEpc() {
    setState(() {
      _clearEpcValues();
    });
  }

  void _listenToPrinterStatus() {
    _printerStatusSubscription =
        NewPrinterStatusListener.getStream().listen((status) {
      if (!mounted) return;
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

  void _listenToTagStream() {
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;

      if (tag.length >= 24) {
        final exists = await FS.checkItemExists(tag.toUpperCase());
        if (!mounted) return;

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
          _epcHex = tag.toUpperCase();
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

  void addEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
    setState(() {
      _epcHex = Epc.toUpperCase();
      _isReadFromChip = true;
      _showManualEpcField = false;
      _manualEpcController.clear();
    });
    _manualEpcFocus.unfocus();
    FocusScope.of(context).unfocus();
  }

  void _toggleQRMode() {
    setState(() {
      useScanner = !useScanner;
      if (!useScanner) {
        qrController.text = const Uuid().v4().substring(0, 7);
      } else {
        qrController.clear();
      }
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
        if (!mounted) return;
        setState(() {
          _progressMessage = "جاري الاتصال...";
          _connectedPrinterMac = selectedMac;
          _connectedPrinterName = selectedDevice["name"] ?? selectedMac;
        });

        final success = await NewPrinterAPI.connectBluetooth(selectedMac);
        if (!mounted) return;
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
      if (!mounted) return;
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    }
  }

  Future<void> _disconnectPrinter() async {
    await NewPrinterAPI.disconnect();
  }

  void _clearMessages() {
    if (!mounted) return;
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _progressMessage = null;
    });
  }

  Future<String?> _getKitImageUrl(String epcHex) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(epcHex)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final images = data?['images'] as List<dynamic>?;
        if (images != null && images.isNotEmpty) {
          return images.first.toString();
        }
      }
      return null;
    } catch (e) {
      print('Error getting kit image: $e');
      return null;
    }
  }

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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ تمت طباعة ليبل القطعة بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Print error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ فشل الطباعة: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  Future<void> _uploadImage(String epcHex) async {
    if (_selectedImage == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compressed = await compressImage(_selectedImage!);
      if (compressed == null) {
        if (!mounted) return;
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم رفع الصورة بنجاح')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ فشل رفع الصورة: $e')),
      );
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

  double _getRemainingWeight(Map<String, dynamic> kitData) {
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
        (payload['weight'] as num?)?.toDouble() ??
        0;
    final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
    return originalWeight - soldWeight;
  }

  double _getRemainingItemsWeight(Map<String, dynamic> kitData) {
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    final items = payload['remainingItems'] as List<dynamic>? ?? [];
    double total = 0;
    for (var item in items) {
      total += (item['weight'] as num?)?.toDouble() ?? 0;
    }
    return total;
  }

  bool _isWeightFullyDistributed(Map<String, dynamic> kitData) {
    final remainingWeight = _getRemainingWeight(kitData);
    final itemsWeight = _getRemainingItemsWeight(kitData);
    return (remainingWeight - itemsWeight).abs() < 0.001;
  }

  double _getOriginalWeight(Map<String, dynamic> kitData) {
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    return (payload['originalWeight'] as num?)?.toDouble() ??
        (payload['weight'] as num?)?.toDouble() ??
        0;
  }

  double _getSoldWeight(Map<String, dynamic> kitData) {
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    return (payload['soldWeight'] as num?)?.toDouble() ?? 0;
  }

  List<String> _getSetComponents(Map<String, dynamic> kitData) {
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    final components = payload['setComponents'] as List<dynamic>? ?? [];
    return components.map((e) => e.toString()).toList();
  }

  List<Map<String, dynamic>> _getRemainingItems(Map<String, dynamic> kitData) {
    if (kitData['payload'] == null) return [];

    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    final items = payload['remainingItems'] as List<dynamic>? ?? [];

    return items.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _calculateTotalRemainingWeight() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (mounted) setState(() => _isLoadingTotal = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('setRemainders')
          .get();

      double totalWeight = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final payload = data['payload'] as Map<String, dynamic>? ?? {};
        final originalWeight =
            (payload['originalWeight'] as num?)?.toDouble() ??
                (payload['weight'] as num?)?.toDouble() ??
                0;
        final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
        final remainingWeight = originalWeight - soldWeight;
        totalWeight += remainingWeight;
      }

      if (!mounted) return;
      setState(() {
        _totalRemainingWeight = totalWeight;
        _isLoadingTotal = false;
      });
    } catch (e) {
      print('Error calculating total: $e');
      if (mounted) setState(() => _isLoadingTotal = false);
    }
  }

  // ============================================================
  // ✅ [FIX] إزالة setState المتداخل
  // ============================================================
  void _openKit(Map<String, dynamic> kitData, String docId) {
    setState(() {
      _openKitData = kitData;
      _openKitDocId = docId;
      _showKitItems = true;
      _selectedItem = null;
      _selectedIndex = null;
      _showItemDetails = false;
      _isAddingFromBalance = false;
      _selectedPartName = 'خاتم';
      _clearEpcValues();
      _selectedImage = null;
      _pinImage = false;
    });
  }

  void _backToKits() {
    setState(() {
      _openKitData = null;
      _openKitDocId = null;
      _showKitItems = false;
      _selectedItem = null;
      _selectedIndex = null;
      _showItemDetails = false;
      _isAddingFromBalance = false;
      _selectedPartName = 'خاتم';
      _clearEpcValues();
      _selectedImage = null;
      _pinImage = false;
    });
    _calculateTotalRemainingWeight();
  }

  void _resetFormState() {
    weightController.clear();
    qrController.text = const Uuid().v4().substring(0, 7);
    _clearEpcValues();
    if (!_pinImage) {
      _selectedImage = null;
    }
    _itemFormKey.currentState?.reset();
  }

  void _openItemDetails(Map<String, dynamic> item, int index) {
    weightController.text =
        (item['weight'] as num?)?.toStringAsFixed(2) ?? '0.00';

    setState(() {
      _selectedItem = item;
      _selectedIndex = index;
      _showItemDetails = true;
      _clearEpcValues();
      _selectedImage = null;
      _pinImage = false;
    });

    _itemFormKey.currentState?.reset();
  }

  void _backToItemsList() {
    setState(() {
      _selectedItem = null;
      _selectedIndex = null;
      _showItemDetails = false;
      _clearEpcValues();
      if (!_pinImage) {
        _selectedImage = null;
      }
    });
    _resetFormState();
  }

  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);

    if (xFile != null) {
      if (!mounted) return;
      setState(() {
        _selectedImage = File(xFile.path);
      });
    }
  }

  // ============================================================
  // ✅ [FIX] إزالة setState المتداخل
  // ============================================================
  void _openAddFromBalanceForm() {
    setState(() {
      _isAddingFromBalance = true;
      _selectedPartName = 'خاتم';
      weightController.clear();
      qrController.text = const Uuid().v4().substring(0, 7);
      _clearEpcValues();
      _selectedImage = null;
      _pinImage = false;
    });
    _itemFormKey.currentState?.reset();
  }

  Future<void> _convertSinglePartToItem({
    required int index,
    required Map<String, dynamic> item,
    required String category,
    required Map<String, dynamic> kitData,
    required String kitDocId,
    required String uid,
  }) async {
    try {
      setState(() => _isConverting = true);

      final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});
      final items = List<dynamic>.from(payload['remainingItems'] ?? []);

      if (index >= items.length) {
        throw Exception('القطعة غير موجودة في الطقم');
      }

      final removedItem = items.removeAt(index);

      final weight = (item['weight'] as num?)?.toDouble() ??
          (removedItem['weight'] as num?)?.toDouble() ??
          0;

      final qrCode = item['qrCode']?.toString() ??
          removedItem['qrCode']?.toString() ??
          const Uuid().v4().substring(0, 7);

      final epcHex = _epcHex.isNotEmpty
          ? _epcHex
          : (kitData['epcHex']?.toString() ??
              payload['epcHex']?.toString() ??
              qrCode);

      final componentName =
          item['name']?.toString() ?? removedItem['name']?.toString() ?? 'قطعة';

      final kitImageUrl = await _getKitImageUrl(epcHex);

      final newPayload = {
        'weight': weight,
        'qrCode': qrCode,
        'kind': componentName,
        'isFromKit': true,
        'kitDocId': kitDocId,
        'originalKitWeight': payload['originalWeight'] ?? payload['weight'],
        'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
        'notes': 'تم التحويل من طقم ${payload['kind'] ?? ''}',
        'carat': payload['carat'] ?? '21',
        'size': payload['size'] ?? '0',
        'wage': payload['wage'] ?? 0,
        'showQr': true,
        'images': kitImageUrl != null ? [kitImageUrl] : [],
      };

      await FS.saveItem(
        epcHex: epcHex,
        category: category,
        date: DateTime.now(),
        payload: newPayload,
        fromOpeningBalance: false,
      );

      if (_selectedImage != null) {
        await _uploadImage(epcHex);
      }

      if (kitImageUrl != null) {
        await FS.uploadImage(epcHex, {
          'images': FieldValue.arrayUnion([kitImageUrl]),
        });
      }

      final currentSoldWeight =
          (payload['soldWeight'] as num?)?.toDouble() ?? 0;
      final newSoldWeight = currentSoldWeight + weight;
      final currentComponents =
          List<String>.from(payload['setComponents'] ?? []);

      final bool componentExists = index < currentComponents.length;

      final updateData = {
        'payload.remainingItems': items,
        'payload.soldWeight': newSoldWeight,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (componentExists) {
        currentComponents.removeAt(index);
        updateData['payload.setComponents'] = currentComponents;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('setRemainders')
          .doc(kitDocId)
          .update(updateData);

      if (mounted) {
        setState(() {
          _openKitData!['payload']['remainingItems'] = items;
          _openKitData!['payload']['soldWeight'] = newSoldWeight;
          if (componentExists) {
            _openKitData!['payload']['setComponents'] = currentComponents;
          }
        });
      }

      final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
          (payload['weight'] as num?)?.toDouble() ??
          0;

      double remainingItemsWeight = 0;
      for (var it in items) {
        remainingItemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
      }

      final pendingBalance =
          originalWeight - newSoldWeight - remainingItemsWeight;

      if (items.isEmpty && pendingBalance <= 0.001) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('setRemainders')
            .doc(kitDocId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('✅ تم تحويل جميع القطع واكتمل الرصيد — تم حذف الطقم'),
              backgroundColor: Colors.green,
            ),
          );
          await _calculateTotalRemainingWeight();
          _backToKits();
        }
      } else if (items.isEmpty && pendingBalance > 0.001) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '✅ تم تحويل "$componentName" — الرصيد المعلق: ${pendingBalance.toStringAsFixed(2)} جم. استخدم زر "إضافة قطعة من الرصيد" لتوزيعه.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          await _calculateTotalRemainingWeight();
          _backToItemsList();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '✅ تم تحويل القطعة "$componentName" بنجاح (متبقي ${items.length} قطع)'),
              backgroundColor: Colors.green,
            ),
          );
          await _calculateTotalRemainingWeight();
          _backToItemsList();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${_t('فشل التحويل', 'Failed to convert')}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  Future<void> _addPartFromBalance({
    required String name,
    required double weight,
    required String qrCode,
    required String category,
    required String uid,
  }) async {
    try {
      setState(() => _isConverting = true);

      final kitData = _openKitData!;
      final payload = Map<String, dynamic>.from(kitData['payload'] ?? {});

      final originalWeight = (payload['originalWeight'] as num?)?.toDouble() ??
          (payload['weight'] as num?)?.toDouble() ??
          0;
      final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
      final items = List<dynamic>.from(payload['remainingItems'] ?? []);
      double itemsWeight = 0;
      for (var it in items) {
        itemsWeight += (it['weight'] as num?)?.toDouble() ?? 0;
      }
      final pending = originalWeight - soldWeight - itemsWeight;

      if (weight > pending + 0.001) {
        throw Exception('الوزن أكبر من الرصيد المتاح');
      }

      final epcHex = _epcHex.isNotEmpty ? _epcHex : qrCode;

      final newPayload = {
        'weight': weight,
        'qrCode': qrCode,
        'kind': name,
        'isFromKit': true,
        'kitDocId': _openKitDocId,
        'originalKitWeight': originalWeight,
        'originalEpc': kitData['epcHex'] ?? payload['epcHex'] ?? '',
        'notes': 'أُضيفت من الرصيد المعلق للطقم ${payload['kind'] ?? ''}',
        'carat': payload['carat'] ?? '21',
        'size': payload['size'] ?? '0',
        'wage': payload['wage'] ?? 0,
        'showQr': true,
        'images': [],
      };

      await FS.saveItem(
        epcHex: epcHex,
        category: category,
        date: DateTime.now(),
        payload: newPayload,
        fromOpeningBalance: false,
      );

      if (_selectedImage != null) {
        await _uploadImage(epcHex);
      }

      final newSoldWeight = soldWeight + weight;
      final newPending = originalWeight - newSoldWeight - itemsWeight;

      if (newPending <= 0.001) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('setRemainders')
            .doc(_openKitDocId)
            .delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('✅ تم حفظ القطعة واكتمل توزيع الرصيد — تم حذف الطقم'),
              backgroundColor: Colors.green,
            ),
          );
          await _calculateTotalRemainingWeight();
          _backToKits();
        }
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('setRemainders')
            .doc(_openKitDocId)
            .update({
          'payload.soldWeight': newSoldWeight,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          setState(() {
            _openKitData!['payload']['soldWeight'] = newSoldWeight;
            _isAddingFromBalance = false;
            _selectedPartName = 'خاتم';
            weightController.clear();
            qrController.text = const Uuid().v4().substring(0, 7);
            _clearEpcValues();
            _selectedImage = null;
            _pinImage = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '✅ تم حفظ "$name" — الرصيد المتبقي: ${newPending.toStringAsFixed(2)} جم'),
              backgroundColor: Colors.green,
            ),
          );
          await _calculateTotalRemainingWeight();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_t('فشل الحفظ', 'Failed')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isConverting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_t("بقايا الاطقم", "Remaining Kits")),
          backgroundColor: const Color(0xFFD4AF37),
        ),
        body: Center(
          child: Text(
            _t('يرجى تسجيل الدخول أولاً', 'Please login first'),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    if (_showKitItems && _openKitData != null) {
      if (_isAddingFromBalance) {
        return _buildAddFromBalanceView(uid);
      }
      if (_showItemDetails && _selectedItem != null) {
        return _buildItemDetailsView(uid);
      }
      return _buildKitItemsView(uid);
    }

    Query q = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('setRemainders')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("بقايا الاطقم", "Remaining Kits")),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _calculateTotalRemainingWeight();
              setState(() {});
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD4AF37),
                    Color(0xFFB8860B),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: _isLoadingTotal
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.scale,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _t('إجمالي الجرامات المعلقه',
                                    'Total Remaining Weight'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 2,
                                height: 25,
                                color: const ui.Color.fromARGB(255, 28, 27, 27),
                              ),
                              Text(
                                '${_totalRemainingWeight.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _t('جم', 'g'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: q.snapshots(),
                builder: (ctx, snap) {
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: _t('لا يوجد بقايا أطقم', 'No Set Remainders'),
                      subtitle: _t('لم يتم تسجيل أي بيع جزئي للأطقم',
                          'No partial set sales recorded'),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      ...docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return _buildKitCard(
                          data: data,
                          docId: doc.id,
                          onOpen: () => _openKit(data, doc.id),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetailsView(String uid) {
    final kitData = _openKitData!;
    final category = kitData['category'] as String? ?? 'gold';
    final item = _selectedItem!;
    final index = _selectedIndex!;
    final components = _getSetComponents(kitData);
    final componentName = item['name'] ??
        (index < components.length ? components[index] : 'قطعة ${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('تفاصيل القطعة', 'Item Details'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD4AF37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _backToItemsList,
        ),
        actions: [
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
          color: Theme.of(context).colorScheme.surface,
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
            key: _itemFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD4AF37),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            componentName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_epcHex.isNotEmpty) ...[
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
                            color: _isReadFromChip ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'EPC: $_epcHex',
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
                  TextFormField(
                    controller: weightController,
                    focusNode: _weightFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
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
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      suffixText: 'جم',
                      hintText: _t('أدخل وزن القطعة', 'Enter part weight'),
                    ),
                    onTap: () {
                      _weightFocusNode.requestFocus();
                      if (weightController.text == '0.00' ||
                          weightController.text == '0') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          weightController.clear();
                        });
                      } else {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          weightController.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: weightController.text.length,
                          );
                        });
                      }
                    },
                    onEditingComplete: () {
                      _weightFocusNode.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _t('يرجى إدخال الوزن', 'Please enter weight');
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return _t('وزن غير صحيح', 'Invalid weight');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: qrController,
                    readOnly: true,
                    focusNode: FocusNode(canRequestFocus: false),
                    decoration: InputDecoration(
                      labelText: useScanner
                          ? _t("QR من الماسح", "QR from Scanner")
                          : _t("QR عشوائي", "Random QR"),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          useScanner ? Icons.qr_code_scanner : Icons.shuffle,
                        ),
                        tooltip: useScanner
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
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('تصوير صورة'),
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
                    const SizedBox(height: 16),
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
                          _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
                          color: _pinImage ? Colors.orange : null,
                        ),
                        label: Text(
                          _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _pinImage ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_isConverting || _isPrinting)
                              ? null
                              : () async {
                                  if (_itemFormKey.currentState?.validate() ??
                                      false) {
                                    final weight = weightController.text;
                                    final qrCode = qrController.text.trim();

                                    await _printConvertedItemLabel(
                                      name: componentName,
                                      weight: weight,
                                      qrCode: qrCode,
                                    );

                                    if (!_isPrimaryScanner && mounted) {
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
                  const SizedBox(height: 12),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isConverting
                          ? null
                          : () async {
                              if (_itemFormKey.currentState?.validate() ??
                                  false) {
                                final weight =
                                    double.parse(weightController.text);
                                final qrCode = qrController.text.trim();

                                if (_epcHex.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                  return;
                                }

                                final itemData = {
                                  'name': componentName,
                                  'weight': weight,
                                  'qrCode': qrCode,
                                };

                                await _convertSinglePartToItem(
                                  index: index,
                                  item: itemData,
                                  category: category,
                                  kitData: kitData,
                                  kitDocId: _openKitDocId!,
                                  uid: uid,
                                );
                              }
                            },
                      icon: _isConverting
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
                        _isConverting
                            ? _t('جاري التحويل...', 'Converting...')
                            : _t('تحويل القطعة', 'Convert Part'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddFromBalanceView(String uid) {
    final kitData = _openKitData!;
    final category = kitData['category'] as String? ?? 'gold';

    final originalWeight = _getOriginalWeight(kitData);
    final soldWeight = _getSoldWeight(kitData);
    final itemsWeight = _getRemainingItemsWeight(kitData);
    final pending = originalWeight - soldWeight - itemsWeight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('إضافة قطعة من الرصيد', 'Add Part from Balance'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFD4AF37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _isAddingFromBalance = false;
              _selectedPartName = 'خاتم';
              weightController.clear();
              qrController.text = const Uuid().v4().substring(0, 7);
              _clearEpcValues();
              _selectedImage = null;
              _pinImage = false;
            });
          },
        ),
        actions: [
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
          color: Theme.of(context).colorScheme.surface,
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
            key: _itemFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            color: Color(0xFFD4AF37)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${_t('الرصيد المعلق المتاح', 'Available pending balance')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ✅ [FIX] value بدل initialValue
                  DropdownButtonFormField<String>(
                    value: _selectedPartName,
                    decoration: InputDecoration(
                      labelText: _t('اسم القطعة', 'Part name'),
                      prefixIcon:
                          const Icon(Icons.category, color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                    ),
                    items: partNameOptions.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? v) {
                      if (v != null) {
                        setState(() => _selectedPartName = v);
                      }
                    },
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? _t(
                            'يرجى اختيار اسم القطعة', 'Please select part name')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // EPC
                  if (_epcHex.isNotEmpty) ...[
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
                            color: _isReadFromChip ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'EPC: $_epcHex',
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
                          ],
                          IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: _clearEpc,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // الوزن
                  TextFormField(
                    controller: weightController,
                    focusNode: _weightFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('وزن القطعة (جم)', 'Part Weight (g)'),
                      prefixIcon:
                          const Icon(Icons.scale, color: Color(0xFFD4AF37)),
                      helperText:
                          '${_t('الحد الأقصى', 'Max')}: ${pending.toStringAsFixed(2)} ${_t('جم', 'g')}',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0xFFD4AF37),
                          width: 2,
                        ),
                      ),
                      suffixText: 'جم',
                    ),
                    onTap: () {
                      _weightFocusNode.requestFocus();
                    },
                    onEditingComplete: () {
                      _weightFocusNode.unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return _t('يرجى إدخال الوزن', 'Please enter weight');
                      }
                      final w = double.tryParse(value);
                      if (w == null || w <= 0) {
                        return _t('وزن غير صحيح', 'Invalid weight');
                      }
                      if (w > pending + 0.001) {
                        return _t(
                          'الوزن أكبر من الرصيد المتاح (${pending.toStringAsFixed(2)} جم)',
                          'Weight exceeds available balance',
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // QR
                  TextFormField(
                    controller: qrController,
                    readOnly: true,
                    focusNode: FocusNode(canRequestFocus: false),
                    decoration: InputDecoration(
                      labelText: useScanner
                          ? _t("QR من الماسح", "QR from Scanner")
                          : _t("QR عشوائي", "Random QR"),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          useScanner ? Icons.qr_code_scanner : Icons.shuffle,
                        ),
                        tooltip: useScanner
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

                  // صورة
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('تصوير صورة'),
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
                    const SizedBox(height: 16),
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
                          _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
                          color: _pinImage ? Colors.orange : null,
                        ),
                        label: Text(
                          _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _pinImage ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 20),

                  // طباعة
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_isConverting || _isPrinting)
                              ? null
                              : () async {
                                  if (_itemFormKey.currentState?.validate() ??
                                      false) {
                                    await _printConvertedItemLabel(
                                      name: _selectedPartName,
                                      weight: weightController.text,
                                      qrCode: qrController.text.trim(),
                                    );

                                    if (!_isPrimaryScanner && mounted) {
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
                  const SizedBox(height: 12),

                  // حقل EPC اليدوي
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

                  // حفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isConverting
                          ? null
                          : () async {
                              if (!(_itemFormKey.currentState?.validate() ??
                                  false)) {
                                return;
                              }
                              if (_epcHex.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        '⚠️ يرجى قراءة أو إدخال رقم الشريحة أولاً'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              final name = _selectedPartName;
                              final weight =
                                  double.parse(weightController.text);
                              final qrCode = qrController.text.trim();

                              await _addPartFromBalance(
                                name: name,
                                weight: weight,
                                qrCode: qrCode,
                                category: category,
                                uid: uid,
                              );
                            },
                      icon: _isConverting
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
                        _isConverting
                            ? _t('جاري الحفظ...', 'Saving...')
                            : _t('حفظ القطعة', 'Save Part'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKitItemsView(String uid) {
    final kitData = _openKitData!;
    final payload = kitData['payload'] as Map<String, dynamic>? ?? {};
    final kind = payload['kind'] ?? 'طقم';

    final originalWeight = _getOriginalWeight(kitData);
    final soldWeight = _getSoldWeight(kitData);
    final remainingWeight = originalWeight - soldWeight;

    final components = _getSetComponents(kitData);
    final items = _getRemainingItems(kitData);
    final itemsWeight = _getRemainingItemsWeight(kitData);
    final isFullyDistributed = _isWeightFullyDistributed(kitData);
    final pendingBalance = remainingWeight - itemsWeight;

    if (items.isEmpty && components.isNotEmpty) {
      final newItems = components.map((name) {
        return {
          'name': name,
          'weight': 0.0,
          'qrCode': '',
          'createdAt': DateTime.now().toIso8601String(),
        };
      }).toList();

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('setRemainders')
          .doc(_openKitDocId)
          .update({
        'payload.remainingItems': newItems,
      }).then((_) {
        if (mounted) {
          setState(() {
            _openKitData!['payload']['remainingItems'] = newItems;
          });
        }
      });

      _openKitData!['payload']['remainingItems'] = newItems;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("قطع $kind المتبقية", "Remaining $kind Parts")),
        backgroundColor: const Color(0xFFD4AF37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToKits,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${remainingWeight.toStringAsFixed(2)} جم',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_t('الطقم', 'Set')}: $kind',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isFullyDistributed ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isFullyDistributed
                              ? _t('مكتمل ✅', 'Complete ✅')
                              : '${pendingBalance.toStringAsFixed(2)} جم متبقي',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (components.isNotEmpty) ...[
                    Text(
                      _t('مكونات الطقم:', 'Set Components:'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: components.map((comp) {
                        return Chip(
                          label: Text(comp),
                          backgroundColor:
                              const Color(0xFFD4AF37).withOpacity(0.2),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          avatar: const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Color(0xFFD4AF37),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_t('الوزن الأصلي', 'Original Weight')}: ${originalWeight.toStringAsFixed(2)} جم',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${_t('الوزن المحول', 'Converted Weight')}: ${soldWeight.toStringAsFixed(2)} جم',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              '${_t('الوزن المتبقي', 'Remaining Weight')}: ${remainingWeight.toStringAsFixed(2)} جم',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isFullyDistributed)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _t('تم تحويل', 'Converted'),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${itemsWeight.toStringAsFixed(2)} جم',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                            Text(
                              '${pendingBalance.toStringAsFixed(2)} جم ${_t('متبقي', 'left')}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _t('لا توجد قطع متبقية', 'No remaining parts'),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (pendingBalance > 0.001) ...[
                              const SizedBox(height: 12),
                              Text(
                                '${_t('الرصيد المعلق', 'Pending balance')}: ${pendingBalance.toStringAsFixed(2)} جم',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _openAddFromBalanceForm,
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.white, size: 24),
                                  label: Text(
                                    _t('إضافة قطعة من الرصيد',
                                        'Add Part from Balance'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4AF37),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  _t(
                                    'هيفتحلك فورم تدخل فيه اسم القطعة ووزنها، وكل ما تحفظ قطعة الرصيد هيقل لحد ما يخلص.',
                                    'A form will open to enter the part name and weight. Each time you save a part, the balance decreases until it reaches zero.',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final componentName = item['name'] ??
                            (index < components.length
                                ? components[index]
                                : 'قطعة ${index + 1}');
                        final weight =
                            (item['weight'] as num?)?.toDouble() ?? 0;
                        final qrCode = item['qrCode']?.toString() ?? '';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => _openItemDetails(item, index),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD4AF37),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          componentName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (qrCode.isNotEmpty)
                                          Text(
                                            'QR: $qrCode',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${weight.toStringAsFixed(2)} جم',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD4AF37),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (pendingBalance > 0.001 && items.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _openAddFromBalanceForm,
                    icon: const Icon(Icons.add_circle_outline,
                        color: Colors.white, size: 22),
                    label: Text(
                      '${_t('إضافة قطعة من الرصيد', 'Add Part from Balance')} (${pendingBalance.toStringAsFixed(2)} جم)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKitCard({
    required Map<String, dynamic> data,
    required String docId,
    required VoidCallback onOpen,
  }) {
    final payload = data['payload'] as Map<String, dynamic>? ?? {};
    final category = data['category'] as String? ?? '';
    final kind = payload['kind'] ?? 'طقم';
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();

    final originalWeight = _getOriginalWeight(data);
    final soldWeight = _getSoldWeight(data);
    final remainingWeight = originalWeight - soldWeight;
    final items = _getRemainingItems(data);
    final itemsCount = items.length;
    final isFullyDistributed = _isWeightFullyDistributed(data);
    final components = _getSetComponents(data);

    Color categoryColor;
    IconData categoryIcon;
    switch (category) {
      case 'gold':
        categoryColor = const Color(0xFFD4AF37);
        categoryIcon = Icons.workspace_premium_rounded;
        break;
      case 'gem':
        categoryColor = Colors.purple;
        categoryIcon = Icons.diamond_rounded;
        break;
      case 'bullion':
        categoryColor = Colors.blue;
        categoryIcon = Icons.account_balance;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.help_outline_rounded;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: categoryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kind,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isFullyDistributed ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isFullyDistributed
                          ? _t('مكتمل', 'Complete')
                          : '${remainingWeight.toStringAsFixed(2)} جم',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (components.isNotEmpty) ...[
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: components.map((comp) {
                    return Chip(
                      label: Text(
                        comp,
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: categoryColor.withOpacity(0.15),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${originalWeight.toStringAsFixed(2)} جم',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${soldWeight.toStringAsFixed(2)} جم',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.grid_view, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '$itemsCount ${_t('قطعة', 'Parts')}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              if (createdAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
