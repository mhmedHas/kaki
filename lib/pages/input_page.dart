// // import 'dart:async';
// // //import 'package:barcode/barcode.dart';
// // import 'package:flutter/material.dart';
// // //import 'package:intl/intl.dart';
// // import '../services/new_printer_api.dart';
// // import '../services/new_printer_status.dart';
// // import '../services/seuic_uhf_service.dart';
// // import '../services/firestore_service.dart';
// // import 'package:uuid/uuid.dart';
// // //import 'package:qr_flutter/qr_flutter.dart';
// // import '../services/seuic_scanner_service.dart';
// // //import 'package:barcode_widget/barcode_widget.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:uhf_gold_shop/pages/settings_page.dart';
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../utils/image_compressor.dart';
// // import 'dart:ui' as ui;
// // import 'package:bluetooth_classic/bluetooth_classic.dart';
// // import 'package:bluetooth_classic/models/device.dart';
// // import 'dart:typed_data';
// // import 'label_layout_model.dart';

// // class InputPage extends StatefulWidget {
// //   final bool fromOpeningBalance;
// //   const InputPage({super.key, required this.fromOpeningBalance});
// //   @override
// //   State<InputPage> createState() => _InputPageState();
// // }

// // class _InputPageState extends State<InputPage> with TickerProviderStateMixin {
// //   late TabController _tabController;
// //   String epcHex = '';
// //   bool isFromScanner = false;
// //   StreamSubscription<String>? _uhfSubscription;
// //   String _lang = 'ar'; // 🟢 اللغة الحالية

// //   final TextEditingController qrController = TextEditingController();
// //   bool useScanner = false;

// //   final List<String> typeOptions = [
// //     'خاتم',
// //     'اسورة',
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
// //     'طقم',
// //     'طقم هافست',
// //     'غير ذلك'
// //   ];

// //   final List<String> setComponentOptions = [
// //     'خاتم',
// //     'اسورة',
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
// //     'غير ذلك'
// //   ];

// //   String? selectedGoldType;
// //   String? selectedScrapType;
// //   List<String> selectedSetComponents = [];
// //   bool showSetComponents = false;
// //   bool showScrapSetComponents = false;

// //   late final TabController _tab = TabController(length: 3, vsync: this);
// //   bool isReadFromChip = false;
// //   bool isReading = false;
// //   StreamSubscription<String>? _tagSubscription;

// //   // 🟢 تحميل اللغة من SharedPreferences
// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   // 🟢 دالة الترجمة المحلية
// //   String _t(String key, String lang) {
// //     final map = {
// //       'ar': {
// //         'gold': 'ذهب',
// //         'stones': 'أحجار',
// //         'ingots': 'سبائك',
// //         'chipAlreadyExists': '⚠️ هذه الشريحة مسجلة من قبل',
// //         'noChipFound': 'لم يتم العثور على شريحة - جرب فتح تطبيق UHF',
// //         'openUHF': 'فتح UHF',
// //         'chipReadError': 'خطأ في قراءة الشريحة:',
// //         'chipReadSuccess': 'تم قراءة الشريحة:',
// //       },
// //       'en': {
// //         'gold': 'Gold',
// //         'stones': 'Stones',
// //         'ingots': 'Ingots',
// //         'chipAlreadyExists': '⚠️ This tag is already registered',
// //         'noChipFound': 'No chip found - try opening the UHF app',
// //         'openUHF': 'Open UHF',
// //         'chipReadError': 'Error reading chip:',
// //         'chipReadSuccess': 'Tag read:',
// //       },
// //     };
// //     return map[lang]?[key] ?? key;
// //   }

// //   // نقل حالة الطابعة من printer_page
// //   bool _isPrinting = false;
// //   String? _errorMessage;
// //   String? _successMessage;
// //   String? _progressMessage;

// //   // حالة الطابعة
// //   bool _isPrinterConnected = false;
// //   String _connectedPrinterName = "غير متصلة";
// //   String? _connectedPrinterMac;

// //   StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

// //   @override
// //   void initState() {
// //     super.initState();
// //     //SeuicUhfService.sendBoolean(false);
// //     _loadLanguage(); // 🟢 تحميل اللغة أول ما الصفحة تفتح
// //     //_setPagePower();
// //     //_loadSavedReaderPower();
// //     final randomQr = const Uuid().v4().substring(0, 7);
// //     setState(() {
// //       qrController.text = randomQr;
// //     });
// //     _loadDecimalPlaces();

// //     SeuicScannerService.scanStream.listen((event) {
// //       if (useScanner) {
// //         setState(() {
// //           qrController.text = event['barcode'] ?? '';
// //         });
// //       }
// //     });

// //     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
// //       if (!mounted) return;

// //       if (tag.length >= 24) {
// //         final exists = await FS.checkItemExists(tag.toUpperCase());
// //         if (exists) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(_t('chipAlreadyExists', _lang)),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //           return;
// //         }

// //         setState(() {
// //           epcHex = tag.toUpperCase();
// //           isReadFromChip = true;
// //           isReading = false;
// //         });
// //       } else {
// //         setState(() {
// //           qrController.text = tag;
// //         });
// //       }
// //     });

// //     SeuicUhfService.open();
// //     // نقل الاستماع لحالة الطابعة من printer_page
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
// //             _connectedPrinterMac = match?.group(1); // في الغالب هو الـ MAC
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

// //   Future<void> _setPagePower() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final powerJson = prefs.getString('pagePowers');
// //     if (powerJson != null) {
// //       final decoded = json.decode(powerJson);
// //       final pagePowers = Map<String, int>.from(decoded);
// //       final pagePower = pagePowers['Input'] ?? 26;
// //       await SeuicUhfService.setPower(pagePower);
// //       print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
// //     }
// //   }

// //   @override
// //   Future<void> dispose() async {
// //     _tagSubscription?.cancel();
// //     _printerStatusSubscription?.cancel(); // إلغاء الاستماع لحالة الطابعة
// //     _weightDataSubscription?.cancel(); // ✅ إلغاء subscription الوزن
// //     _weightStreamController.close();
// //     await _bluetoothClassicPlugin.disconnect();
// //     super.dispose();
// //     qrController.dispose();
// //   }

// //   String _generateRandomQR() {
// //     return const Uuid().v4().substring(0, 7);
// //   }

// //   void _toggleQRMode() {
// //     setState(() {
// //       useScanner = !useScanner;
// //       if (!useScanner) {
// //         qrController.text = _generateRandomQR();
// //       } else {
// //         qrController.clear();
// //       }
// //     });
// //   }

// //   Future<void> _readChip() async {
// //     setState(() {
// //       isReading = true;
// //     });
// //     try {
// //       final result = await SeuicUhfService.inventoryOnce();
// //       if (result == null || result.isEmpty) {
// //         setState(() {
// //           isReading = false;
// //         });
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(_t('noChipFound', _lang)),
// //             backgroundColor: Colors.orange,
// //             action: SnackBarAction(
// //               label: _t('openUHF', _lang),
// //               textColor: Colors.white,
// //               onPressed: SeuicUhfService.openUhfApp,
// //             ),
// //           ),
// //         );
// //       } else {
// //         final exists = await FS.checkItemExists(result.toUpperCase());
// //         if (exists) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(
// //               content: Text(_t('chipAlreadyExists', _lang)),
// //               backgroundColor: Colors.red,
// //             ),
// //           );
// //           return;
// //         }

// //         setState(() {
// //           epcHex = result.toUpperCase();
// //           isReadFromChip = true;
// //         });

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Row(
// //               children: [
// //                 const Icon(Icons.nfc, color: Colors.white),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Text(
// //                       '${_t('chipReadSuccess', _lang)} ${result.substring(0, result.length > 20 ? 20 : result.length)}...'),
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
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isReading = false;
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('${_t('chipReadError', _lang)} $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }

// //   void _clearEpc() {
// //     setState(() {
// //       epcHex = '';
// //       isReadFromChip = false;
// //     });
// //   }

// //   void _clearMessages() {
// //     setState(() {
// //       _errorMessage = null;
// //       _successMessage = null;
// //       _progressMessage = null;
// //     });
// //   }

// //   // نقل دالة اختيار والاتصال بالطابعة
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

// //   // نقل دالة بناء الرسائل
// //   Widget _buildMessage(String msg, Color color, [bool loading = false]) {
// //     final isError = color == Colors.red;
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.1),
// //         border: Border.all(color: color.withOpacity(0.6)),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           loading
// //               ? const SizedBox(
// //                   width: 24,
// //                   height: 24,
// //                   child: CircularProgressIndicator(strokeWidth: 2))
// //               : Icon(
// //                   loading
// //                       ? Icons.print
// //                       : (color == Colors.green
// //                           ? Icons.check_circle
// //                           : Icons.error),
// //                   color: color),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(msg.split('. ')[0],
// //                     style:
// //                         TextStyle(color: color, fontWeight: FontWeight.w600)),
// //                 if (isError && msg.contains('. '))
// //                   Text(msg.split('. ').skip(1).join('. '),
// //                       style: TextStyle(color: Colors.red[700], fontSize: 12)),
// //               ],
// //             ),
// //           ),
// //           IconButton(icon: const Icon(Icons.close), onPressed: _clearMessages),
// //         ],
// //       ),
// //     );
// //   }

// //   int _readerPower = 26; // القيمة الحالية
// //   int _tempPower = 26; // قيمة السلايدر المؤقتة
// //   Future<void> _loadSavedReaderPower() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final powerJson = prefs.getString('pagePowers');

// //     if (powerJson != null) {
// //       final Map<String, dynamic> pagePowers =
// //           Map<String, dynamic>.from(json.decode(powerJson));

// //       final savedPower = pagePowers['Input'];
// //       if (savedPower != null) {
// //         setState(() {
// //           _readerPower = savedPower;
// //           _tempPower = savedPower;
// //         });

// //         // تطبيق القوة فعليًا على القارئ
// //         await SeuicUhfService.setPower(savedPower);
// //       }
// //     }
// //   }

// //   void _showPowerSheet() {
// //     _tempPower = _readerPower;
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setModalState) {
// //             return Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Text(
// //                     _t('قوة قارئ RFID', 'RFID Reader Power'),
// //                     style: const TextStyle(
// //                         fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   Text(
// //                     '${_tempPower} dBm',
// //                     style: const TextStyle(
// //                         fontSize: 22, fontWeight: FontWeight.bold),
// //                   ),
// //                   Slider(
// //                     min: 1,
// //                     max: 33,
// //                     divisions: 25,
// //                     value: _tempPower.toDouble(),
// //                     label: _tempPower.toString(),
// //                     onChanged: (v) {
// //                       setModalState(() {
// //                         _tempPower = v.round();
// //                       });
// //                     },
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: OutlinedButton(
// //                           onPressed: () => Navigator.pop(context),
// //                           child: Text(_t('إلغاء', 'Cancel')),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: ElevatedButton(
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: const Color(0xFFD4AF37),
// //                           ),
// //                           onPressed: () async {
// //                             setState(() {
// //                               _readerPower = _tempPower;
// //                             });

// //                             // تطبيق القوة فورًا
// //                             await SeuicUhfService.setPower(_readerPower);

// //                             // حفظها للصفحة
// //                             final prefs = await SharedPreferences.getInstance();
// //                             final powerJson = prefs.getString('pagePowers');
// //                             Map<String, int> pagePowers = {};

// //                             if (powerJson != null) {
// //                               pagePowers =
// //                                   Map<String, int>.from(json.decode(powerJson));
// //                             }

// //                             pagePowers['Input'] = _readerPower;
// //                             await prefs.setString(
// //                                 'pagePowers', json.encode(pagePowers));

// //                             Navigator.pop(context);

// //                             /*_showMsg(
// //                               _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'),
// //                               true,
// //                             );*/
// //                             showAppMessage(
// //                                 context,
// //                                 _t('تم ضبط قوة القارئ بنجاح',
// //                                     'Reader power updated'));
// //                           },
// //                           child: Text(_t('حفظ', 'Save')),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }

// //   void showAppMessage(BuildContext context, String msg) {
// //     final isSuccess = msg.contains('تمت') ||
// //         msg.contains('تم') ||
// //         msg.contains('written') ||
// //         msg.contains('Saved');

// //     ScaffoldMessenger.of(context).clearSnackBars();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Directionality(
// //           textDirection: ui.TextDirection.rtl,
// //           child: Text(msg),
// //         ),
// //         backgroundColor: isSuccess ? Colors.green : Colors.red,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         margin: const EdgeInsets.all(16),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //       ),
// //     );
// //   }

// //   final _bluetoothClassicPlugin = BluetoothClassic();
// //   String buffer = "";
// //   final _weightStreamController = StreamController<String>.broadcast();
// //   bool isConnected = false;
// //   StreamSubscription<Uint8List>?
// //       _weightDataSubscription; // ✅ حفظ subscription الوزن
// //   int _decimalPlaces = 2; // ✅ الافتراضي 0.00

// // // ✅ تحميل الإعداد المحفوظ
// //   Future<void> _loadDecimalPlaces() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _decimalPlaces = prefs.getInt('weightDecimalPlaces') ?? 2;
// //     });
// //   }

// //   Future<void> connectToScale() async {
// //     // ✅ لو كان في اتصال قديم، قطعه الأول
// //     if (isConnected) {
// //       await _weightDataSubscription?.cancel();
// //       await _bluetoothClassicPlugin.disconnect();
// //       setState(() {
// //         isConnected = false;
// //       });
// //     }

// //     await _bluetoothClassicPlugin.initPermissions();
// //     final devices = await _bluetoothClassicPlugin.getPairedDevices();

// //     final selected = await showDialog<Device>(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text("اختر الميزان"),
// //         content: SizedBox(
// //           height: 370,
// //           width: double.maxFinite,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // ✅ اختيار عدد الأرقام العشرية
// //               StatefulBuilder(
// //                 builder: (ctx, setLocalState) => Padding(
// //                   padding: const EdgeInsets.only(bottom: 12),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       const Text("دقة الوزن: "),
// //                       ChoiceChip(
// //                         label: const Text("0.00"),
// //                         selected: _decimalPlaces == 2,
// //                         onSelected: (_) async {
// //                           final prefs = await SharedPreferences.getInstance();
// //                           await prefs.setInt('weightDecimalPlaces', 2);
// //                           setLocalState(() {});
// //                           setState(() => _decimalPlaces = 2);
// //                         },
// //                       ),
// //                       const SizedBox(width: 8),
// //                       ChoiceChip(
// //                         label: const Text("0.000"),
// //                         selected: _decimalPlaces == 3,
// //                         onSelected: (_) async {
// //                           final prefs = await SharedPreferences.getInstance();
// //                           await prefs.setInt('weightDecimalPlaces', 3);
// //                           setLocalState(() {});
// //                           setState(() => _decimalPlaces = 3);
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               // ✅ قائمة الأجهزة
// //               Expanded(
// //                 child: ListView(
// //                   shrinkWrap: true,
// //                   children: devices.map((d) {
// //                     return ListTile(
// //                       title: Text(d.name ?? "HC-06"),
// //                       subtitle: Text(d.address),
// //                       onTap: () => Navigator.pop(ctx, d),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );

// //     if (selected == null) return;

// //     await _bluetoothClassicPlugin.connect(
// //       selected.address,
// //       "00001101-0000-1000-8000-00805f9b34fb",
// //     );

// //     setState(() {
// //       isConnected = true;
// //     });

// //     listenToWeight();
// //   }

// //   void listenToWeight() {
// //     // ✅ إلغاء الـ subscription القديمة قبل ما نعمل جديدة
// //     _weightDataSubscription?.cancel();
// //     buffer = ""; // ✅ مسح الـ buffer القديم

// //     _weightDataSubscription =
// //         _bluetoothClassicPlugin.onDeviceDataReceived().listen((Uint8List data) {
// //       final raw = String.fromCharCodes(data);
// //       print("RAW DATA: $raw"); // ← أضيفي السطر ده
// //       buffer += String.fromCharCodes(data);

// //       if (buffer.contains("\n")) {
// //         String full = buffer.trim();
// //         buffer = "";

// //         final match = RegExp(r'\d+\.?\d*').firstMatch(full);
// //         final rawWeight = match != null ? match.group(0)! : '';

// //         if (rawWeight.isNotEmpty) {
// //           // ✅ تطبيق عدد الأرقام العشرية المحدد
// //           final parsed = double.tryParse(rawWeight);
// //           final formatted = parsed != null
// //               ? parsed.toStringAsFixed(_decimalPlaces)
// //               : rawWeight;

// //           print("Weight: $formatted");
// //           if (!_weightStreamController.isClosed) {
// //             _weightStreamController.add(formatted);
// //           }
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 3,
// //       child: Scaffold(
// //         backgroundColor: Colors.transparent,
// //         /*floatingActionButton: FloatingActionButton(
// //           backgroundColor: const Color(0xFFD4AF37),
// //           tooltip: _t('قوة القارئ', 'Reader Power'),
// //           onPressed: _showPowerSheet,
// //           child: const Icon(Icons.tune),
// //         ),*/
// //         body: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: [
// //                 Theme.of(context).colorScheme.surface,
// //                 Theme.of(context).colorScheme.surface.withOpacity(0.8),
// //               ],
// //             ),
// //           ),
// //           child: Column(
// //             children: [
// //               // إضافة شريط حالة الطابعة في الأعلى (نقل من printer_page)
// //               Card(
// //                 color: _isPrinterConnected
// //                     ? Colors.green.shade50
// //                     : Colors.red.shade50,
// //                 elevation: 4,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(16)),
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                   child: Row(
// //                     children: [
// //                       Icon(
// //                         _isPrinterConnected
// //                             ? Icons.print
// //                             : Icons.print_disabled,
// //                         color: _isPrinterConnected ? Colors.green : Colors.red,
// //                         size: 32,
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               "حالة الطابعة",
// //                               style: TextStyle(
// //                                   fontSize: 14, color: Colors.grey[700]),
// //                             ),
// //                             Text(
// //                               _isPrinterConnected
// //                                   ? _connectedPrinterName
// //                                   : "غير متصلة",
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: _isPrinterConnected
// //                                     ? Colors.green.shade700
// //                                     : Colors.red.shade700,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       ElevatedButton.icon(
// //                         onPressed: _selectAndConnectPrinter,
// //                         icon: const Icon(Icons.bluetooth_searching, size: 18),
// //                         label: Text(_isPrinterConnected ? "متصلة" : "اتصال"),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: _isPrinterConnected
// //                               ? Colors.red
// //                               : const Color(0xFFD4AF37),
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 12, vertical: 10),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       ElevatedButton.icon(
// //                         onPressed: () async {
// //                           await NewPrinterAPI.disconnect();
// //                         },
// //                         icon: const Icon(Icons.bluetooth_disabled, size: 18),
// //                         label: const Text("فصل"),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.red,
// //                           foregroundColor: Colors.white,
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 12, vertical: 10),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               // رسائل الحالة للطابعة
// //               if (_errorMessage != null)
// //                 _buildMessage(_errorMessage!, Colors.red),
// //               if (_successMessage != null)
// //                 _buildMessage(_successMessage!, Colors.green),
// //               if (_progressMessage != null)
// //                 _buildMessage(_progressMessage!, Colors.blue, true),
// //               Container(
// //                 margin: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: Theme.of(context).colorScheme.surface,
// //                   borderRadius: BorderRadius.circular(16),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 10,
// //                       offset: const Offset(0, 2),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Material(
// //                   color: Colors.transparent,
// //                   child: TabBar(
// //                     controller: _tab,
// //                     indicator: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(12),
// //                       gradient: const LinearGradient(
// //                         colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
// //                       ),
// //                     ),
// //                     indicatorSize: TabBarIndicatorSize.tab,
// //                     dividerColor: Colors.transparent,
// //                     labelColor: Colors.white,
// //                     unselectedLabelColor: Theme.of(context)
// //                         .colorScheme
// //                         .onSurface
// //                         .withOpacity(0.6),
// //                     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
// //                     tabs: [
// //                       Tab(child: Text(_t('gold', _lang))),
// //                       Tab(child: Text(_t('stones', _lang))),
// //                       Tab(child: Text(_t('ingots', _lang))),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Expanded(
// //                 child: TabBarView(
// //                   controller: _tab,
// //                   children: [
// //                     GoldForm(
// //                       epcHex: epcHex,
// //                       onReadChip: _readChip,
// //                       onClearEpc: _clearEpc,
// //                       isReadFromChip: isReadFromChip,
// //                       isReading: isReading,
// //                       qrController: qrController,
// //                       useScanner: useScanner,
// //                       toggleQRMode: _toggleQRMode,
// //                       fromOpeningBalance: widget.fromOpeningBalance,
// //                       onPrint: _printGoldLabel, // نقل دالة الطباعة
// //                       isPrinterConnected: _isPrinterConnected,
// //                       isPrinting: _isPrinting,
// //                       weightStream: _weightStreamController.stream,
// //                       isConnected: isConnected,
// //                       connectToScale: connectToScale,
// //                     ),
// //                     GemForm(
// //                       epcHex: epcHex,
// //                       onReadChip: _readChip,
// //                       onClearEpc: _clearEpc,
// //                       isReadFromChip: isReadFromChip,
// //                       isReading: isReading,
// //                       qrController: qrController,
// //                       useScanner: useScanner,
// //                       toggleQRMode: _toggleQRMode,
// //                       fromOpeningBalance: widget.fromOpeningBalance,
// //                       onPrint:
// //                           _printGemLabel, // دالة طباعة مخصصة للأحجار (يمكن تخصيصها)
// //                       isPrinterConnected: _isPrinterConnected,
// //                       isPrinting: _isPrinting,
// //                     ),
// //                     BullionForm(
// //                       epcHex: epcHex,
// //                       onReadChip: _readChip,
// //                       onClearEpc: _clearEpc,
// //                       isReadFromChip: isReadFromChip,
// //                       isReading: isReading,
// //                       qrController: qrController,
// //                       useScanner: useScanner,
// //                       toggleQRMode: _toggleQRMode,
// //                       fromOpeningBalance: widget.fromOpeningBalance,
// //                       onPrint:
// //                           _printBullionLabel, // دالة طباعة مخصصة للسبائك (يمكن تخصيصها)
// //                       isPrinterConnected: _isPrinterConnected,
// //                       isPrinting: _isPrinting,
// //                       weightStream: _weightStreamController.stream,
// //                       isConnected: isConnected,
// //                       connectToScale: connectToScale,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // نقل دالة الطباعة للذهب (يمكن تخصيص للأخرى)
// //   Future<void> _printGoldLabel({
// //     String? weight,
// //     String? carat,
// //     String? size,
// //     required String showQr,
// //     required String qrCode,
// //   }) async {
// //     _clearMessages();

// //     setState(() => _isPrinting = true);

// //     try {
// //       final layout = await LabelLayoutStorage.load('gold');
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? logoBase64 = prefs.getString('custom_logo_base64');

// //       final success = await NewPrinterAPI.printGoldLabel(
// //         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
// //         weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
// //         carat: carat?.trim().isEmpty ?? true ? null : carat?.trim(),
// //         size: size?.trim().isEmpty ?? true ? null : size?.trim(),
// //         showQr: showQr.trim(),
// //         qrCode: qrCode.trim(),
// //         customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
// //         labelLayout: layout.toJson(),
// //       );

// //       if (!success) {
// //         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
// //         );
// //       }
// //     } catch (e) {
// //       setState(() =>
// //           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
// //     } finally {
// //       setState(() => _isPrinting = false);
// //     }
// //   }

// //   Future<void> _printBullionLabel({
// //     String? weight,
// //     String? note1,
// //     String? note2,
// //     required String showQr,
// //     required String qrCode,
// //   }) async {
// //     _clearMessages();

// //     setState(() => _isPrinting = true);

// //     try {
// //       // ← أهم سطر في حياتك دلوقتي
// //       final layout = await LabelLayoutStorage.load('bullion');
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? logoBase64 = prefs.getString('custom_logo_base64');

// //       final success = await NewPrinterAPI.printBullionLabel(
// //         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
// //         weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
// //         note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
// //         note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
// //         showQr: showQr.trim(),
// //         qrCode: qrCode.trim(),
// //         customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
// //         labelLayout: layout.toJson(),
// //       );

// //       if (!success) {
// //         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
// //         );
// //       }
// //     } catch (e) {
// //       setState(() =>
// //           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
// //     } finally {
// //       setState(() => _isPrinting = false);
// //     }
// //   }

// //   Future<void> _printGemLabel({
// //     String? gemType,
// //     String? note1,
// //     String? note2,
// //     required String showQr,
// //     required String qrCode,
// //   }) async {
// //     _clearMessages();

// //     setState(() => _isPrinting = true);

// //     try {
// //       // ← أهم سطر في حياتك دلوقتي
// //       final layout = await LabelLayoutStorage.load('gem');
// //       final prefs = await SharedPreferences.getInstance();
// //       final String? logoBase64 = prefs.getString('custom_logo_base64');

// //       final success = await NewPrinterAPI.printGemLabel(
// //         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
// //         gemType: gemType?.trim().isEmpty ?? true ? null : gemType?.trim(),
// //         note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
// //         note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
// //         showQr: showQr.trim(),
// //         qrCode: qrCode.trim(),
// //         customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
// //         labelLayout: layout.toJson(),
// //       );

// //       if (!success) {
// //         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
// //         );
// //       }
// //     } catch (e) {
// //       setState(() =>
// //           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
// //     } finally {
// //       setState(() => _isPrinting = false);
// //     }
// //   }
// // }

// // class GoldForm extends StatefulWidget {
// //   final String epcHex;
// //   final VoidCallback onReadChip;
// //   final VoidCallback onClearEpc;
// //   final bool isReadFromChip;
// //   final bool isReading;
// //   final TextEditingController qrController;
// //   final bool useScanner;
// //   final VoidCallback toggleQRMode;
// //   final bool fromOpeningBalance;
// //   final bool isPrinterConnected; //الطابعة
// //   final bool isPrinting;
// //   final Stream<String> weightStream;
// //   final bool isConnected;
// //   final VoidCallback connectToScale;
// //   final Future<void> Function({
// //     String? weight,
// //     String? carat,
// //     String? size,
// //     required String showQr,
// //     required String qrCode,
// //   }) onPrint;
// //   const GoldForm({
// //     super.key,
// //     required this.epcHex,
// //     required this.onReadChip,
// //     required this.onClearEpc,
// //     this.isReadFromChip = false,
// //     this.isReading = false,
// //     required this.qrController,
// //     required this.useScanner,
// //     required this.toggleQRMode,
// //     required this.fromOpeningBalance,
// //     required this.isPrinterConnected,
// //     required this.isPrinting,
// //     required this.weightStream,
// //     required this.isConnected,
// //     required this.connectToScale,
// //     required this.onPrint,
// //   });

// //   @override
// //   State<GoldForm> createState() => _GoldFormState();
// // }

// // class _GoldFormState extends State<GoldForm> {
// //   DateTime date = DateTime.now();
// //   String carat = '21';
// //   final weight = TextEditingController();
// //   final wage = TextEditingController();
// //   //final kind = TextEditingController();
// //   final notes = TextEditingController();
// //   bool busy = false;
// //   String? msg;

// //   String? selectedGoldType = 'خاتم';
// //   bool showSetComponents = false;
// //   List<String> selectedSetComponents = [];
// //   File? selectedImage;
// //   bool _pinImage = false; // تثبيت الصورة
// //   bool _autoWeightMode = false; // false = يدوي، true = من الميزان
// //   StreamSubscription<String>? _weightSub;
// //   LabelProfile? _activeProfile; // البروفايل المختار حالياً

// //   final List<String> typeOptions = [
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
// //     'طقم',
// //     'طقم هافست',
// //     'غير ذلك'
// //   ];

// //   List<String> get setComponentOptions => typeOptions
// //       .where(
// //         (type) => type != 'طقم' && type != 'طقم هافست',
// //       )
// //       .toList();
// //   // ✅ متغيرات QR
// //   bool showQr = true; // true = QR, false = Barcode
// //   CodeDisplayMode _displayMode = CodeDisplayMode.qr;
// //   String _lang = 'ar';
// //   final TextEditingController _sizeController = TextEditingController();

// //   void _subscribeToWeight() {
// //     _weightSub?.cancel();
// //     _weightSub = widget.weightStream.listen((value) {
// //       if (_autoWeightMode) {
// //         final match = RegExp(r'\d+\.?\d*').firstMatch(value);
// //         final cleaned = match != null ? match.group(0)! : '';
// //         if (cleaned.isNotEmpty) {
// //           setState(() => weight.text = cleaned);
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();

// //     _loadLanguage();
// //     _loadActiveProfile();
// //     weight.addListener(_onFormChanged);
// //     wage.addListener(_onFormChanged);
// //     widget.qrController.addListener(_onFormChanged);
// //     _sizeController.text = "0";
// //     _loadSettings();
// //     /*widget.weightStream.listen((value) {
// //       if (_autoWeightMode) { // ✅ يأخذ من الميزان بس لو الوضع التلقائي
// //         // استخراج أرقام عشرية فقط
// //         final match = RegExp(r'\d+\.?\d*').firstMatch(value);
// //         final cleaned = match != null ? match.group(0)! : '';
// //         if (cleaned.isNotEmpty) {
// //           setState(() {
// //             weight.text = cleaned;
// //           });
// //         }
// //       }
// //     });*/
// //     _subscribeToWeight();
// //   }

// //   @override
// //   void didUpdateWidget(GoldForm oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (oldWidget.weightStream != widget.weightStream) {
// //       _subscribeToWeight();
// //     }
// //   }

// //   Future<void> _loadActiveProfile() async {
// //     final profile = await LabelProfileStorage.loadActive('gold');
// //     if (mounted) setState(() => _activeProfile = profile);
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
// //               // Handle
// //               Container(
// //                 margin: const EdgeInsets.symmetric(vertical: 10),
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               // Header
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
// //               // القائمة
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
// //                         LabelProfileStorage.saveActive(
// //                             'gold', p.id); // ← السطر الجديد
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

// //   void _onFormChanged() {
// //     setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
// //   }

// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final saved = prefs.getString('displayMode');
// //     if (saved != null) {
// //       setState(() {
// //         _displayMode = CodeDisplayMode.values.firstWhere(
// //           (e) => e.name == saved,
// //           orElse: () => CodeDisplayMode.qr,
// //         );
// //         if (_displayMode == CodeDisplayMode.qr) {
// //           showQr = true;
// //         } else if (_displayMode == CodeDisplayMode.barcode) {
// //           showQr = false;
// //         }
// //       });
// //     }
// //   }

// //   // 🟢 تحميل اللغة من SharedPreferences
// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void dispose() {
// //     _weightSub?.cancel();
// //     weight.removeListener(_onFormChanged);
// //     wage.removeListener(_onFormChanged);
// //     widget.qrController.removeListener(_onFormChanged);
// //     super.dispose();
// //   }

// //   bool useScanner = false;
// //   void showAppMessage(BuildContext context, String msg) {
// //     final isSuccess = msg.contains('تمت') ||
// //         msg.contains('تم') ||
// //         msg.contains('written') ||
// //         msg.contains('Saved');

// //     ScaffoldMessenger.of(context).clearSnackBars();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Directionality(
// //           textDirection: ui.TextDirection.rtl,
// //           child: Text(msg),
// //         ),
// //         backgroundColor: isSuccess ? Colors.green : Colors.red,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         margin: const EdgeInsets.all(16),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _saveGold() async {
// //     setState(() {
// //       busy = true;
// //       msg = null;
// //     });
// //     try {
// //       final w = double.tryParse(weight.text) ?? 0;
// //       final wg = double.tryParse(wage.text) ?? 0;
// //       await FS.saveItem(
// //         epcHex: widget.epcHex,
// //         category: 'gold',
// //         date: date,
// //         payload: {
// //           'carat': carat,
// //           'size': _sizeController.text,
// //           'weight': w,
// //           'wage': w * wg,
// //           'kind': selectedGoldType, // ✅ احفظ من الدروب داون
// //           if (selectedGoldType == 'طقم' || selectedGoldType == 'طقم هافست')
// //             'setComponents': selectedSetComponents,
// //           'notes': notes.text.trim(),
// //           'qrCode': widget.qrController.text,
// //           'showQr': showQr,
// //         },
// //         fromOpeningBalance: widget.fromOpeningBalance,
// //       );
// //       // بعد await FS.saveItem(...)
// //       if (selectedImage != null) {
// //         await _uploadImage();
// //       }
// //       setState(() {
// //         msg = _t('تم الحفظ بنجاح', 'Saved successfully');

// //         // Reset form fields
// //         weight.clear();
// //         wage.clear();
// //         //selectedGoldType = 'خاتم';
// //         selectedSetComponents.clear();
// //         showSetComponents = false;
// //         notes.clear();
// //         //carat = '21';
// //         date = DateTime.now();
// //         // امسح الشريحة بعد الحفظ
// //         widget.onClearEpc?.call();
// //         widget.qrController.text = const Uuid().v4().substring(0, 7);

// //         if (!_pinImage) {
// //           selectedImage = null;
// //         }
// //       });
// //       showAppMessage(context, msg!);
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _scrollController.animateTo(
// //           0,
// //           duration: const Duration(milliseconds: 500),
// //           curve: Curves.easeOut,
// //         );
// //       });
// //     } catch (e) {
// //       setState(() {
// //         msg = '${_t('فشل الحفظ', 'Failed to save')}: $e';
// //       });
// //       showAppMessage(context, msg!);
// //     } finally {
// //       setState(() {
// //         busy = false;
// //       });
// //     }
// //   }

// //   final ScrollController _scrollController = ScrollController();

// //   // دالة اختيار الصورة
// //   Future<void> _pickImage() async {
// //     FocusScope.of(context).unfocus();

// //     final picker = ImagePicker();
// //     final xFile = await picker.pickImage(source: ImageSource.camera);

// //     if (xFile != null) {
// //       setState(() {
// //         selectedImage = File(xFile.path);
// //       });
// //     }
// //   }

// //   // دالة رفع الصورة
// //   Future<void> _uploadImage() async {
// //     if (selectedImage == null) return;

// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;

// //       final compressed = await compressImage(selectedImage!);
// //       if (compressed == null) {
// //         setState(() => msg = '❌ فشل ضغط الصورة');
// //         return;
// //       }

// //       final storageRef = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(widget.epcHex)
// //           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

// //       final metadata = SettableMetadata(
// //         contentType: 'image/jpeg',
// //         cacheControl: 'public,max-age=300',
// //       );

// //       await storageRef.putFile(compressed, metadata);
// //       final url = await storageRef.getDownloadURL();

// //       await FS.uploadImage(widget.epcHex, {
// //         'images': FieldValue.arrayUnion([url]),
// //       });

// //       setState(() => msg = '✅ تم رفع الصورة بنجاح');
// //     } catch (e) {
// //       setState(() => msg = '❌ فشل رفع الصورة: $e');
// //     }
// //   }

// //   bool _showNotes = false;
// //   final TextEditingController manualEpcController = TextEditingController();
// //   final FocusNode manualEpcFocus = FocusNode();

// //   bool showManualEpcField = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       controller: _scrollController,
// //       child: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 15,
// //               offset: const Offset(0, 5),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const SizedBox(height: 16),
// //                   DropdownButtonFormField<String>(
// //                     value: carat,
// //                     items: const ['18', '21', '22']
// //                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => carat = v ?? '21'),
// //                     decoration: InputDecoration(
// //                       labelText: _t('العيار', 'Carat'),
// //                       prefixIcon: Icon(Icons.grade, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   /*TextField(
// //                     controller: weight,
// //                     keyboardType: TextInputType.number,
// //                     decoration:  InputDecoration(
// //                       labelText: _t('الوزن (جم)', 'Weight (g)'),

// //                       prefixIcon: Icon(Icons.scale, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),*/
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       TextField(
// //                         controller: weight,
// //                         keyboardType: TextInputType.number,
// //                         readOnly: _autoWeightMode,
// //                         decoration: InputDecoration(
// //                           labelText: _t('الوزن (جم)', 'Weight (g)'),
// //                           border: const OutlineInputBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(12)),
// //                           ),
// //                           // ✅ زرار الاتصال بالميزان على اليسار
// //                           prefixIcon: IconButton(
// //                             tooltip: _t('اتصال بالميزان', 'Connect Scale'),
// //                             icon: Icon(
// //                               widget.isConnected
// //                                   ? Icons.bluetooth_connected
// //                                   : Icons.bluetooth,
// //                               color: widget.isConnected
// //                                   ? Colors.green
// //                                   : Colors.grey,
// //                             ),
// //                             onPressed: widget.connectToScale,
// //                           ),
// //                           // ✅ زرار التحويل يدوي/تلقائي على اليمين
// //                           suffixIcon: IconButton(
// //                             tooltip: _autoWeightMode
// //                                 ? _t('تحويل ليدوي', 'Switch to Manual')
// //                                 : _t('تحويل لتلقائي', 'Switch to Scale'),
// //                             icon: Icon(
// //                               _autoWeightMode ? Icons.edit : Icons.scale,
// //                               color:
// //                                   _autoWeightMode ? Colors.green : Colors.grey,
// //                             ),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _autoWeightMode = !_autoWeightMode;
// //                                 if (_autoWeightMode) weight.clear();
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       if (_autoWeightMode)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 4, right: 4),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 widget.isConnected
// //                                     ? Icons.bluetooth_connected
// //                                     : Icons.bluetooth_disabled,
// //                                 size: 14,
// //                                 color: widget.isConnected
// //                                     ? Colors.green
// //                                     : Colors.red,
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 widget.isConnected
// //                                     ? _t('في انتظار الميزان...',
// //                                         'Waiting for scale...')
// //                                     : _t('الميزان غير متصل',
// //                                         'Scale not connected'),
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   color: widget.isConnected
// //                                       ? Colors.green
// //                                       : Colors.red,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: wage,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('الأجر', 'Wage'),
// //                       prefixIcon:
// //                           Icon(Icons.attach_money, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   DropdownButtonFormField<String>(
// //                     value: selectedGoldType,
// //                     decoration: InputDecoration(
// //                       labelText: _t('النوع', 'Type'),
// //                       prefixIcon:
// //                           Icon(Icons.category, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                     items: typeOptions.map((String type) {
// //                       return DropdownMenuItem<String>(
// //                         value: type,
// //                         child: Text(type),
// //                       );
// //                     }).toList(),
// //                     onChanged: (String? newValue) {
// //                       setState(() {
// //                         selectedGoldType = newValue;
// //                         showSetComponents =
// //                             newValue == 'طقم' || newValue == 'طقم هافست';

// //                         if (!showSetComponents) {
// //                           selectedSetComponents.clear();
// //                         }
// //                       });
// //                     },
// //                   ),
// //                   if (showSetComponents) ...[
// //                     const SizedBox(height: 16),
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         border: Border.all(color: Colors.grey),
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       padding: const EdgeInsets.all(12),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             _t('مكونات الطقم', 'Set Components'),
// //                             style: const TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: Color(0xFFD4AF37),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Wrap(
// //                             spacing: 8,
// //                             runSpacing: 8,
// //                             children: setComponentOptions.map((component) {
// //                               final isSelected =
// //                                   selectedSetComponents.contains(component);
// //                               return FilterChip(
// //                                 label: Text(component),
// //                                 selected: isSelected,
// //                                 onSelected: (selected) {
// //                                   setState(() {
// //                                     if (selected) {
// //                                       selectedSetComponents.add(component);
// //                                     } else {
// //                                       selectedSetComponents.remove(component);
// //                                     }
// //                                   });
// //                                 },
// //                                 selectedColor:
// //                                     const Color(0xFFD4AF37).withOpacity(0.3),
// //                                 checkmarkColor: const Color(0xFFD4AF37),
// //                               );
// //                             }).toList(),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: _sizeController,
// //                     decoration: InputDecoration(
// //                       labelText: "المقاس",
// //                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ElevatedButton.icon(
// //                     onPressed: _pickImage,
// //                     icon: const Icon(Icons.camera_alt),
// //                     label: const Text('تصوير صورة'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFFD4AF37),
// //                       foregroundColor: Colors.white,
// //                     ),
// //                   ),
// //                   if (selectedImage != null) ...[
// //                     const SizedBox(height: 16),
// //                     SizedBox(
// //                       height: 200,
// //                       child: Image.file(
// //                         selectedImage!,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     OutlinedButton.icon(
// //                       onPressed: () {
// //                         setState(() {
// //                           _pinImage = !_pinImage;
// //                         });
// //                       },
// //                       icon: Icon(
// //                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// //                         color: _pinImage ? Colors.orange : null,
// //                       ),
// //                       label: Text(
// //                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   const SizedBox(height: 10),
// //                   // استبدل الـ TextField بالكود ده
// //                   Column(
// //                     children: [
// //                       InkWell(
// //                         onTap: () => setState(() => _showNotes = !_showNotes),
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 12, vertical: 2),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                               const SizedBox(width: 12),
// //                               Expanded(
// //                                 child: Text(
// //                                   notes.text.isEmpty
// //                                       ? _t('ملاحظات', 'Notes')
// //                                       : notes.text,
// //                                   style: TextStyle(
// //                                     color:
// //                                         notes.text.isEmpty ? Colors.grey : null,
// //                                   ),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                               Icon(
// //                                 _showNotes
// //                                     ? Icons.keyboard_arrow_up
// //                                     : Icons.keyboard_arrow_down,
// //                                 color: Colors.grey,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       if (_showNotes) ...[
// //                         const SizedBox(height: 8),
// //                         TextField(
// //                           controller: notes,
// //                           maxLines: 3,
// //                           autofocus: true,
// //                           decoration: InputDecoration(
// //                             labelText: _t('ملاحظات', 'Notes'),
// //                             prefixIcon: const Icon(Icons.note,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: const OutlineInputBorder(
// //                               borderRadius:
// //                                   BorderRadius.all(Radius.circular(12)),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: widget.qrController,
// //                     readOnly: true,
// //                     decoration: InputDecoration(
// //                       labelText: widget.useScanner
// //                           ? _t("QR من الماسح", "QR from Scanner")
// //                           : _t("QR عشوائي", "Random QR"),
// //                       border: const OutlineInputBorder(),

// //                       // الزرار الصغير جنب الحقل
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           widget.useScanner
// //                               ? Icons.qr_code_scanner
// //                               : Icons.shuffle,
// //                         ),
// //                         tooltip: widget.useScanner
// //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// //                             : _t("استخدام الماسح", "Use Scanner"),
// //                         onPressed: widget.toggleQRMode,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   Row(
// //                     children: [
// //                       // زر الطباعة (ياخد باقي المساحة)
// //                       Expanded(
// //                         child: ElevatedButton.icon(
// //                           onPressed: (busy || widget.isPrinting)
// //                               ? null
// //                               : () async {
// //                                   if (_activeProfile != null) {
// //                                     // احفظه مؤقتاً كـ active layout
// //                                     await LabelLayoutStorage.save(
// //                                         _activeProfile!.layout);
// //                                   }
// //                                   await widget.onPrint(
// //                                     weight: weight.text,
// //                                     carat: carat,
// //                                     size: _sizeController.text,
// //                                     showQr: "$showQr",
// //                                     qrCode: widget.qrController.text,
// //                                   );
// //                                   setState(() {
// //                                     showManualEpcField = true;
// //                                     manualEpcController.clear();
// //                                   });
// //                                   WidgetsBinding.instance
// //                                       .addPostFrameCallback((_) {
// //                                     FocusScope.of(context)
// //                                         .requestFocus(manualEpcFocus);
// //                                   });
// //                                 },
// //                           icon: widget.isPrinting
// //                               ? const SizedBox(
// //                                   width: 24,
// //                                   height: 24,
// //                                   child: CircularProgressIndicator(
// //                                     color: Colors.white,
// //                                     strokeWidth: 3,
// //                                   ),
// //                                 )
// //                               : const Icon(Icons.print),
// //                           label: Text(
// //                             widget.isPrinting
// //                                 ? "جاري الطباعة..."
// //                                 : "طباعة ليبل الذهب",
// //                           ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: widget.isPrinterConnected
// //                                 ? const Color(0xFFD4AF37)
// //                                 : Colors.green,
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 16),
// //                             textStyle: const TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.bold),
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                           ),
// //                         ),
// //                       ),

// //                       const SizedBox(width: 8),

// //                       // زرار الإعدادات (مربع صغير)
// //                       SizedBox(
// //                         width: 50,
// //                         height: 50,
// //                         child: OutlinedButton(
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.zero,
// //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
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
// //                   if (showManualEpcField) ...[
// //                     const SizedBox(height: 16),
// //                     TextField(
// //                       controller: manualEpcController,
// //                       focusNode: manualEpcFocus,
// //                       textCapitalization: TextCapitalization.characters,
// //                       decoration: const InputDecoration(
// //                         labelText: 'أدخل رقم الشريحة',
// //                         border: OutlineInputBorder(),
// //                         prefixIcon: Icon(Icons.nfc),
// //                       ),
// //                       onSubmitted: (value) {
// //                         setState(() {
// //                           AddEpcManualy(value);
// //                           showManualEpcField = false;
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                   Container(
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors: [
// //                           const Color(0xFFD4AF37).withOpacity(0.1),
// //                           const Color(0xFFB8860B).withOpacity(0.05),
// //                         ],
// //                       ),
// //                       borderRadius:
// //                           const BorderRadius.vertical(top: Radius.circular(20)),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         if (widget.epcHex.isNotEmpty) ...[
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Text(
// //                                   'EPC (hex): ${widget.epcHex}',
// //                                   style:
// //                                       const TextStyle(fontFamily: 'monospace'),
// //                                 ),
// //                               ),
// //                               if (widget.isReadFromChip)
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                       horizontal: 8, vertical: 4),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.green.withOpacity(0.2),
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     border: Border.all(color: Colors.green),
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     children: [
// //                                       Icon(Icons.nfc,
// //                                           size: 16, color: Colors.green),
// //                                       SizedBox(width: 4),
// //                                       Text(_t('مقروء', 'Read'),
// //                                           style: TextStyle(
// //                                               color: Colors.green,
// //                                               fontSize: 12)),
// //                                     ],
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                         ],
// //                         Row(
// //                           children: [
// //                             if (widget.epcHex.isNotEmpty) ...[
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: OutlinedButton.icon(
// //                                   onPressed: busy ? null : widget.onClearEpc,
// //                                   icon: const Icon(Icons.clear),
// //                                   label: Text(_t('مسح', 'Clear')),
// //                                   style: OutlinedButton.styleFrom(
// //                                     shape: RoundedRectangleBorder(
// //                                         borderRadius:
// //                                             BorderRadius.circular(12)),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   ElevatedButton(
// //                     onPressed: (busy ||
// //                             widget.epcHex.isEmpty ||
// //                             weight.text.isEmpty ||
// //                             _sizeController.text.isEmpty ||
// //                             wage.text.isEmpty ||
// //                             widget.qrController.text.isEmpty ||
// //                             selectedImage == null)
// //                         ? null
// //                         : _saveGold,
// //                     style: ElevatedButton.styleFrom(
// //                       padding: const EdgeInsets.symmetric(vertical: 16),
// //                       backgroundColor: const Color(0xFFD4AF37),
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 2,
// //                     ),
// //                     child: SizedBox(
// //                       height: 24, // نفس ارتفاع المحتوى
// //                       child: Center(
// //                         child: AnimatedSwitcher(
// //                           duration: const Duration(milliseconds: 250),
// //                           child: busy
// //                               ? const SizedBox(
// //                                   key: ValueKey('loading'),
// //                                   height: 22,
// //                                   width: 22,
// //                                   child: CircularProgressIndicator(
// //                                     strokeWidth: 2.5,
// //                                     color: Colors.white,
// //                                   ),
// //                                 )
// //                               : Row(
// //                                   key: const ValueKey('normal'),
// //                                   mainAxisSize: MainAxisSize.min,
// //                                   children: [
// //                                     const Icon(Icons.save),
// //                                     const SizedBox(width: 8),
// //                                     Text(_t(
// //                                         'حفظ إلى التقارير', 'Save to Reports')),
// //                                   ],
// //                                 ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void AddEpcManualy(String Epc) {
// //     SeuicUhfService.addEpcManualy(Epc);
// //   }
// // }

// // class GemForm extends StatefulWidget {
// //   final String epcHex;
// //   final VoidCallback onReadChip;
// //   final VoidCallback onClearEpc;
// //   final bool isReadFromChip;
// //   final bool isReading;
// //   final TextEditingController qrController;
// //   final bool useScanner;
// //   final VoidCallback toggleQRMode;
// //   final bool fromOpeningBalance;
// //   final bool isPrinterConnected; //الطابعة
// //   final bool isPrinting;
// //   final Future<void> Function({
// //     String? gemType,
// //     String? note1,
// //     String? note2,
// //     required String showQr,
// //     required String qrCode,
// //   }) onPrint;
// //   const GemForm({
// //     super.key,
// //     required this.epcHex,
// //     required this.onReadChip,
// //     required this.onClearEpc,
// //     this.isReadFromChip = false,
// //     this.isReading = false,
// //     required this.qrController,
// //     required this.useScanner,
// //     required this.toggleQRMode,
// //     required this.fromOpeningBalance,
// //     required this.isPrinterConnected,
// //     required this.isPrinting,
// //     required this.onPrint,
// //   });
// //   @override
// //   State<GemForm> createState() => _GemFormState();
// // }

// // class _GemFormState extends State<GemForm> {
// //   DateTime date = DateTime.now();
// //   String gemType = 'ماس';
// //   final cost = TextEditingController();
// //   final notes = TextEditingController();
// //   bool busy = false;
// //   String? msg;

// //   // ✅ متغيرات QR
// //   bool showQr = true; // true = QR, false = Barcode
// //   CodeDisplayMode _displayMode = CodeDisplayMode.qr;
// //   File? selectedImage;
// //   bool _pinImage = false; // تثبيت الصورة
// //   LabelProfile? _activeProfile; // البروفايل المختار حالياً

// //   String _lang = 'ar';
// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
// //   final TextEditingController _note1Controller = TextEditingController();
// //   final TextEditingController _note2Controller = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadActiveProfile();
// //     cost.addListener(_onFormChanged);
// //     widget.qrController.addListener(_onFormChanged);
// //     _loadSettings();
// //     _loadLanguage();
// //   }

// //   void _onFormChanged() {
// //     setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
// //   }

// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final saved = prefs.getString('displayMode');
// //     if (saved != null) {
// //       setState(() {
// //         _displayMode = CodeDisplayMode.values.firstWhere(
// //           (e) => e.name == saved,
// //           orElse: () => CodeDisplayMode.qr,
// //         );
// //         if (_displayMode == CodeDisplayMode.qr) {
// //           showQr = true;
// //         } else if (_displayMode == CodeDisplayMode.barcode) {
// //           showQr = false;
// //         }
// //       });
// //     }
// //   }

// //   Future<void> _loadActiveProfile() async {
// //     final profile = await LabelProfileStorage.loadActive('gem');
// //     if (mounted) setState(() => _activeProfile = profile);
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
// //               // Handle
// //               Container(
// //                 margin: const EdgeInsets.symmetric(vertical: 10),
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               // Header
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
// //               // القائمة
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
// //                         LabelProfileStorage.saveActive(
// //                             'gem', p.id); // ← السطر الجديد
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

// //   @override
// //   void dispose() {
// //     cost.removeListener(_onFormChanged);
// //     widget.qrController.removeListener(_onFormChanged);
// //     super.dispose();
// //   }

// //   bool useScanner = false;

// //   Future<void> _saveGem() async {
// //     setState(() {
// //       busy = true;
// //       msg = null;
// //     });
// //     try {
// //       await FS.saveItem(
// //         epcHex: widget.epcHex,
// //         category: 'gem',
// //         date: date,
// //         payload: {
// //           'type': gemType,
// //           'cost': double.tryParse(cost.text) ?? 0,
// //           'notes': notes.text.trim(),
// //           'qrCode': widget.qrController.text,
// //           'showQr': showQr,
// //         },
// //         fromOpeningBalance: widget.fromOpeningBalance,
// //       );
// //       // بعد await FS.saveItem(...)
// //       if (selectedImage != null) {
// //         await _uploadImage();
// //       }
// //       setState(() {
// //         msg = _t('تم الحفظ بنجاح', 'Saved successfully');
// //         // Reset form
// //         cost.clear();
// //         notes.clear();
// //         //gemType = 'ماس';
// //         date = DateTime.now();
// //         widget.onClearEpc?.call();
// //         widget.qrController.text = const Uuid().v4().substring(0, 7);

// //         if (!_pinImage) {
// //           selectedImage = null;
// //         }
// //       });
// //       showAppMessage(context, msg!);
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _scrollController.animateTo(
// //           0,
// //           duration: const Duration(milliseconds: 500),
// //           curve: Curves.easeOut,
// //         );
// //       });
// //     } catch (e) {
// //       setState(() {
// //         msg = _t('فشل الحفظ', 'Failed to save') + ': $e';
// //       });
// //       showAppMessage(context, msg!);
// //     } finally {
// //       setState(() {
// //         busy = false;
// //       });
// //     }
// //   }

// //   void showAppMessage(BuildContext context, String msg) {
// //     final isSuccess = msg.contains('تمت') ||
// //         msg.contains('تم') ||
// //         msg.contains('written') ||
// //         msg.contains('Saved');

// //     ScaffoldMessenger.of(context).clearSnackBars();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Directionality(
// //           textDirection: ui.TextDirection.rtl,
// //           child: Text(msg),
// //         ),
// //         backgroundColor: isSuccess ? Colors.green : Colors.red,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         margin: const EdgeInsets.all(16),
// //       ),
// //     );
// //   }

// //   final ScrollController _scrollController = ScrollController();
// //   // دالة اختيار الصورة
// //   Future<void> _pickImage() async {
// //     FocusScope.of(context).unfocus();

// //     final picker = ImagePicker();
// //     final xFile = await picker.pickImage(source: ImageSource.camera);

// //     if (xFile != null) {
// //       setState(() {
// //         selectedImage = File(xFile.path);
// //       });
// //     }
// //   }

// //   // دالة رفع الصورة
// //   Future<void> _uploadImage() async {
// //     if (selectedImage == null) return;

// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;

// //       final compressed = await compressImage(selectedImage!);
// //       if (compressed == null) {
// //         setState(() => msg = '❌ فشل ضغط الصورة');
// //         return;
// //       }

// //       final storageRef = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(widget.epcHex)
// //           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

// //       final metadata = SettableMetadata(
// //         contentType: 'image/jpeg',
// //         cacheControl: 'public,max-age=300',
// //       );

// //       await storageRef.putFile(compressed, metadata);
// //       final url = await storageRef.getDownloadURL();

// //       await FS.uploadImage(widget.epcHex, {
// //         'images': FieldValue.arrayUnion([url]),
// //       });

// //       setState(() => msg = '✅ تم رفع الصورة بنجاح');
// //     } catch (e) {
// //       setState(() => msg = '❌ فشل رفع الصورة: $e');
// //     }
// //   }

// //   bool _showNotes = false;
// //   final TextEditingController manualEpcController = TextEditingController();
// //   final FocusNode manualEpcFocus = FocusNode();

// //   bool showManualEpcField = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     final gemTypes = [
// //       'ماس',
// //       'زمرد',
// //       'ياقوت',
// //       'فيروز',
// //       'عقيق',
// //       'توباز',
// //       'لؤلؤ',
// //       'أوبال',
// //       'عين النمر',
// //       'غير ذلك'
// //     ];
// //     return SingleChildScrollView(
// //       controller: _scrollController,
// //       child: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 15,
// //               offset: const Offset(0, 5),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const SizedBox(height: 16),
// //                   DropdownButtonFormField<String>(
// //                     value: gemType,
// //                     items: gemTypes
// //                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => gemType = v ?? 'ماس'),
// //                     decoration: InputDecoration(
// //                       labelText: _t('النوع', 'Type'),
// //                       prefixIcon:
// //                           const Icon(Icons.auto_awesome, color: Colors.purple),
// //                       border: const OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: cost,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('التكلفة', 'Cost'),
// //                       prefixIcon:
// //                           const Icon(Icons.attach_money, color: Colors.purple),
// //                       border: const OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),

// //                   ElevatedButton.icon(
// //                     onPressed: _pickImage,
// //                     icon: const Icon(Icons.camera_alt),
// //                     label: const Text('تصوير صورة'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFFD4AF37),
// //                       foregroundColor: Colors.white,
// //                     ),
// //                   ),

// //                   if (selectedImage != null) ...[
// //                     const SizedBox(height: 16),
// //                     SizedBox(
// //                       height: 200,
// //                       child: Image.file(
// //                         selectedImage!,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     OutlinedButton.icon(
// //                       onPressed: () {
// //                         setState(() {
// //                           _pinImage = !_pinImage;
// //                         });
// //                       },
// //                       icon: Icon(
// //                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// //                         color: _pinImage ? Colors.orange : null,
// //                       ),
// //                       label: Text(
// //                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   const SizedBox(height: 10),
// //                   // استبدل الـ TextField بالكود ده
// //                   Column(
// //                     children: [
// //                       InkWell(
// //                         onTap: () => setState(() => _showNotes = !_showNotes),
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 12, vertical: 2),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                               const SizedBox(width: 12),
// //                               Expanded(
// //                                 child: Text(
// //                                   notes.text.isEmpty
// //                                       ? _t('ملاحظات', 'Notes')
// //                                       : notes.text,
// //                                   style: TextStyle(
// //                                     color:
// //                                         notes.text.isEmpty ? Colors.grey : null,
// //                                   ),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                               Icon(
// //                                 _showNotes
// //                                     ? Icons.keyboard_arrow_up
// //                                     : Icons.keyboard_arrow_down,
// //                                 color: Colors.grey,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       if (_showNotes) ...[
// //                         const SizedBox(height: 8),
// //                         TextField(
// //                           controller: notes,
// //                           maxLines: 3,
// //                           autofocus: true,
// //                           decoration: InputDecoration(
// //                             labelText: _t('ملاحظات', 'Notes'),
// //                             prefixIcon: const Icon(Icons.note,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: const OutlineInputBorder(
// //                               borderRadius:
// //                                   BorderRadius.all(Radius.circular(12)),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextFormField(
// //                     controller: widget.qrController,
// //                     readOnly: true,
// //                     decoration: InputDecoration(
// //                       labelText: widget.useScanner
// //                           ? _t("QR من الماسح", "QR from Scanner")
// //                           : _t("QR عشوائي", "Random QR"),
// //                       border: const OutlineInputBorder(),

// //                       // الزرار الصغير جنب الحقل
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           widget.useScanner
// //                               ? Icons.qr_code_scanner
// //                               : Icons.shuffle,
// //                         ),
// //                         tooltip: widget.useScanner
// //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// //                             : _t("استخدام الماسح", "Use Scanner"),
// //                         onPressed: widget.toggleQRMode,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   TextField(
// //                     controller: _note1Controller,
// //                     decoration: InputDecoration(
// //                       labelText: "اكتب للطباعة 1",
// //                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                     ),
// //                     //keyboardType: TextInputType.number,
// //                   ),
// //                   const SizedBox(height: 24),
// //                   TextField(
// //                     controller: _note2Controller,
// //                     decoration: InputDecoration(
// //                       labelText: "اكتب للطباعة 2",
// //                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                     ),
// //                     //keyboardType: TextInputType.number,
// //                   ),

// //                   const SizedBox(height: 24),
// //                   // زر الطباعة قبل زر الحفظ
// //                   /*SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: (busy || widget.isPrinting ) ? null : () async {
// //                         await widget.onPrint(
// //                           gemType: gemType,
// //                           note1: _note1Controller.text,
// //                           note2: _note2Controller.text,
// //                           showQr: "$showQr",
// //                           qrCode: widget.qrController.text,
// //                         );
// //                       },
// //                       icon: widget.isPrinting
// //                           ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
// //                           : const Icon(Icons.print),
// //                       label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل الاحجار"),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 16),
// //                         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                       ),
// //                     ),
// //                   ),*/
// //                   Row(
// //                     children: [
// //                       // زر الطباعة (ياخد باقي المساحة)
// //                       Expanded(
// //                         child: ElevatedButton.icon(
// //                           onPressed: (busy || widget.isPrinting)
// //                               ? null
// //                               : () async {
// //                                   if (_activeProfile != null) {
// //                                     // احفظه مؤقتاً كـ active layout
// //                                     await LabelLayoutStorage.save(
// //                                         _activeProfile!.layout);
// //                                   }
// //                                   await widget.onPrint(
// //                                     gemType: gemType,
// //                                     note1: _note1Controller.text,
// //                                     note2: _note2Controller.text,
// //                                     showQr: "$showQr",
// //                                     qrCode: widget.qrController.text,
// //                                   );
// //                                   setState(() {
// //                                     showManualEpcField = true;
// //                                     manualEpcController.clear();
// //                                   });
// //                                   WidgetsBinding.instance
// //                                       .addPostFrameCallback((_) {
// //                                     FocusScope.of(context)
// //                                         .requestFocus(manualEpcFocus);
// //                                   });
// //                                 },
// //                           icon: widget.isPrinting
// //                               ? const SizedBox(
// //                                   width: 24,
// //                                   height: 24,
// //                                   child: CircularProgressIndicator(
// //                                     color: Colors.white,
// //                                     strokeWidth: 3,
// //                                   ),
// //                                 )
// //                               : const Icon(Icons.print),
// //                           label: Text(widget.isPrinting
// //                               ? "جاري الطباعة..."
// //                               : "طباعة ليبل الاحجار"),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: widget.isPrinterConnected
// //                                 ? const Color(0xFFD4AF37)
// //                                 : Colors.green,
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 16),
// //                             textStyle: const TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.bold),
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                           ),
// //                         ),
// //                       ),

// //                       const SizedBox(width: 8),

// //                       // زرار الإعدادات (مربع صغير)
// //                       SizedBox(
// //                         width: 50,
// //                         height: 50,
// //                         child: OutlinedButton(
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.zero,
// //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                           ),
// //                           onPressed: () => _showProfilePicker('gem'),
// //                           child: const Icon(
// //                             Icons.settings,
// //                             color: Color(0xFFD4AF37),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   if (showManualEpcField) ...[
// //                     const SizedBox(height: 16),
// //                     TextField(
// //                       controller: manualEpcController,
// //                       focusNode: manualEpcFocus,
// //                       textCapitalization: TextCapitalization.characters,
// //                       decoration: const InputDecoration(
// //                         labelText: 'أدخل رقم الشريحة',
// //                         border: OutlineInputBorder(),
// //                         prefixIcon: Icon(Icons.nfc),
// //                       ),
// //                       onSubmitted: (value) {
// //                         setState(() {
// //                           AddEpcManualy(value);
// //                           showManualEpcField = false;
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                   const SizedBox(height: 24),
// //                   Container(
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors: [
// //                           Colors.purple.withOpacity(0.1),
// //                           Colors.deepPurple.withOpacity(0.05),
// //                         ],
// //                       ),
// //                       borderRadius:
// //                           const BorderRadius.vertical(top: Radius.circular(20)),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         if (widget.epcHex.isNotEmpty) ...[
// //                           Row(
// //                             children: [
// //                               Expanded(
// //                                 child: Text(
// //                                   'EPC (hex): ${widget.epcHex}',
// //                                   style:
// //                                       const TextStyle(fontFamily: 'monospace'),
// //                                 ),
// //                               ),
// //                               if (widget.isReadFromChip)
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                       horizontal: 8, vertical: 4),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.green.withOpacity(0.2),
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     border: Border.all(color: Colors.green),
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     children: [
// //                                       const Icon(Icons.nfc,
// //                                           size: 16, color: Colors.green),
// //                                       const SizedBox(width: 4),
// //                                       Text(_t('مقروء', 'Read'),
// //                                           style: const TextStyle(
// //                                               color: Colors.green,
// //                                               fontSize: 12)),
// //                                     ],
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                           const SizedBox(height: 8),
// //                         ],
// //                         Row(
// //                           children: [
// //                             if (widget.epcHex.isNotEmpty) ...[
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: OutlinedButton.icon(
// //                                   onPressed: busy ? null : widget.onClearEpc,
// //                                   icon: const Icon(Icons.clear),
// //                                   label: Text(_t('مسح', 'Clear')),
// //                                   style: OutlinedButton.styleFrom(
// //                                     shape: RoundedRectangleBorder(
// //                                         borderRadius:
// //                                             BorderRadius.circular(12)),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: (busy ||
// //                               widget.epcHex.isEmpty ||
// //                               selectedImage == null ||
// //                               cost.text.isEmpty ||
// //                               widget.qrController.text.isEmpty)
// //                           ? null
// //                           : _saveGem,
// //                       icon: busy
// //                           ? const SizedBox(
// //                               height: 22,
// //                               width: 22,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2.5,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Icon(Icons.save),
// //                       label: busy
// //                           ? Text(_t('جاري الحفظ...', 'Saving...'))
// //                           : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
// //                       style: ElevatedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 16),
// //                         backgroundColor: Colors.purple,
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         elevation: 2,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void AddEpcManualy(String Epc) {
// //     SeuicUhfService.addEpcManualy(Epc);
// //   }
// // }

// // class BullionForm extends StatefulWidget {
// //   final String epcHex;
// //   final VoidCallback onReadChip;
// //   final VoidCallback onClearEpc;
// //   final bool isReadFromChip;
// //   final bool isReading;
// //   final TextEditingController qrController;
// //   final bool useScanner;
// //   final VoidCallback toggleQRMode;
// //   final bool fromOpeningBalance;
// //   final bool isPrinterConnected; //الطابعة
// //   final bool isPrinting;
// //   final Stream<String> weightStream;
// //   final bool isConnected;
// //   final VoidCallback connectToScale;
// //   final Future<void> Function({
// //     String? weight,
// //     String? note1,
// //     String? note2,
// //     required String showQr,
// //     required String qrCode,
// //   }) onPrint;
// //   const BullionForm({
// //     super.key,
// //     required this.epcHex,
// //     required this.onReadChip,
// //     required this.onClearEpc,
// //     this.isReadFromChip = false,
// //     this.isReading = false,
// //     required this.qrController,
// //     required this.useScanner,
// //     required this.toggleQRMode,
// //     required this.fromOpeningBalance,
// //     required this.isPrinterConnected,
// //     required this.isPrinting,
// //     required this.onPrint,
// //     required this.weightStream,
// //     required this.isConnected,
// //     required this.connectToScale,
// //   });

// //   @override
// //   State<BullionForm> createState() => _BullionFormState();
// // }

// // class _BullionFormState extends State<BullionForm> {
// //   DateTime date = DateTime.now();
// //   final weight = TextEditingController();
// //   final wage = TextEditingController();
// //   final notes = TextEditingController();
// //   bool busy = false;
// //   String? msg;
// //   File? selectedImage;
// //   bool _pinImage = false; // تثبيت الصورة
// //   LabelProfile? _activeProfile; // البروفايل المختار حالياً

// //   // ✅ متغيرات QR
// //   bool showQr = true; // true = QR, false = Barcode
// //   CodeDisplayMode _displayMode = CodeDisplayMode.qr;

// //   String _lang = 'ar';
// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
// //   final TextEditingController _note1Controller = TextEditingController();
// //   final TextEditingController _note2Controller = TextEditingController();
// //   bool _autoWeightMode = false;

// //   StreamSubscription<String>? _weightSub;
// //   void _subscribeToWeight() {
// //     _weightSub?.cancel();
// //     _weightSub = widget.weightStream.listen((value) {
// //       if (_autoWeightMode) {
// //         final match = RegExp(r'\d+\.?\d*').firstMatch(value);
// //         final cleaned = match != null ? match.group(0)! : '';
// //         if (cleaned.isNotEmpty) {
// //           setState(() => weight.text = cleaned);
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadActiveProfile();
// //     weight.addListener(_onFormChanged);
// //     wage.addListener(_onFormChanged);
// //     widget.qrController.addListener(_onFormChanged);
// //     _loadSettings();
// //     _loadLanguage();
// //     _subscribeToWeight();
// //   }

// //   @override
// //   void didUpdateWidget(BullionForm oldWidget) {
// //     super.didUpdateWidget(oldWidget);
// //     if (oldWidget.weightStream != widget.weightStream) {
// //       _subscribeToWeight();
// //     }
// //   }

// //   void _onFormChanged() {
// //     setState(() {});
// //   }

// //   Future<void> _loadActiveProfile() async {
// //     final profile = await LabelProfileStorage.loadActive('bullion');
// //     if (mounted) setState(() => _activeProfile = profile);
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
// //               // Handle
// //               Container(
// //                 margin: const EdgeInsets.symmetric(vertical: 10),
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(2),
// //                 ),
// //               ),
// //               // Header
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
// //               // القائمة
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
// //                         LabelProfileStorage.saveActive(
// //                             'bullion', p.id); // ← السطر الجديد
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

// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final saved = prefs.getString('displayMode');
// //     if (saved != null) {
// //       setState(() {
// //         _displayMode = CodeDisplayMode.values.firstWhere(
// //           (e) => e.name == saved,
// //           orElse: () => CodeDisplayMode.qr,
// //         );
// //         if (_displayMode == CodeDisplayMode.qr) {
// //           showQr = true;
// //         } else if (_displayMode == CodeDisplayMode.barcode) {
// //           showQr = false;
// //         }
// //       });
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _weightSub?.cancel();
// //     weight.removeListener(_onFormChanged);
// //     wage.removeListener(_onFormChanged);
// //     widget.qrController.removeListener(_onFormChanged);
// //     super.dispose();
// //   }

// //   bool useScanner = false;

// //   Future<void> _saveBullion() async {
// //     setState(() {
// //       busy = true;
// //       msg = null;
// //     });
// //     try {
// //       final w = double.tryParse(weight.text) ?? 0;
// //       final wg = double.tryParse(wage.text) ?? 0;
// //       await FS.saveItem(
// //         epcHex: widget.epcHex,
// //         category: 'bullion',
// //         date: date,
// //         payload: {
// //           'weight': w,
// //           'wage': w * wg,
// //           'notes': notes.text.trim(),
// //           'qrCode': widget.qrController.text,
// //           'showQr': showQr,
// //         },
// //         fromOpeningBalance: widget.fromOpeningBalance,
// //       );
// //       // بعد await FS.saveItem(...)
// //       if (selectedImage != null) {
// //         await _uploadImage();
// //       }
// //       setState(() {
// //         msg = _t('تم الحفظ بنجاح', 'Saved successfully');
// //         weight.clear();
// //         wage.clear();
// //         notes.clear();
// //         date = DateTime.now();
// //         widget.qrController.text = const Uuid().v4().substring(0, 7);

// //         if (!_pinImage) {
// //           selectedImage = null;
// //         }
// //       });
// //       widget.onClearEpc();
// //       showAppMessage(context, msg!);
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _scrollController.animateTo(
// //           0,
// //           duration: const Duration(milliseconds: 500),
// //           curve: Curves.easeOut,
// //         );
// //       });
// //     } catch (e) {
// //       setState(() {
// //         msg = _t('فشل الحفظ', 'Failed to save') + ': $e';
// //       });
// //       showAppMessage(context, msg!);
// //     } finally {
// //       setState(() {
// //         busy = false;
// //       });
// //     }
// //   }

// //   void showAppMessage(BuildContext context, String msg) {
// //     final isSuccess = msg.contains('تمت') ||
// //         msg.contains('تم') ||
// //         msg.contains('written') ||
// //         msg.contains('Saved');

// //     ScaffoldMessenger.of(context).clearSnackBars();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Directionality(
// //           textDirection: ui.TextDirection.rtl,
// //           child: Text(msg),
// //         ),
// //         backgroundColor: isSuccess ? Colors.green : Colors.red,
// //         duration: const Duration(seconds: 2),
// //         behavior: SnackBarBehavior.floating,
// //         margin: const EdgeInsets.all(16),
// //       ),
// //     );
// //   }

// //   final ScrollController _scrollController = ScrollController();
// //   // دالة اختيار الصورة
// //   Future<void> _pickImage() async {
// //     FocusScope.of(context).unfocus(); // ⭐ حل المشكلة

// //     final picker = ImagePicker();
// //     final xFile = await picker.pickImage(source: ImageSource.camera);

// //     if (xFile != null) {
// //       setState(() {
// //         selectedImage = File(xFile.path);
// //       });
// //     }
// //   }

// //   // دالة رفع الصورة
// //   Future<void> _uploadImage() async {
// //     if (selectedImage == null) return;

// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;

// //       final compressed = await compressImage(selectedImage!);
// //       if (compressed == null) {
// //         setState(() => msg = '❌ فشل ضغط الصورة');
// //         return;
// //       }

// //       final storageRef = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(widget.epcHex)
// //           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

// //       final metadata = SettableMetadata(
// //         contentType: 'image/jpeg',
// //         cacheControl: 'public,max-age=300',
// //       );

// //       await storageRef.putFile(compressed, metadata);
// //       final url = await storageRef.getDownloadURL();

// //       await FS.uploadImage(widget.epcHex, {
// //         'images': FieldValue.arrayUnion([url]),
// //       });

// //       setState(() => msg = '✅ تم رفع الصورة بنجاح');
// //     } catch (e) {
// //       setState(() => msg = '❌ فشل رفع الصورة: $e');
// //     }
// //   }

// //   bool _showNotes = false;
// //   final TextEditingController manualEpcController = TextEditingController();
// //   final FocusNode manualEpcFocus = FocusNode();

// //   bool showManualEpcField = false;

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       controller: _scrollController,
// //       child: Container(
// //         margin: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Theme.of(context).colorScheme.surface,
// //           borderRadius: BorderRadius.circular(20),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.1),
// //               blurRadius: 15,
// //               offset: const Offset(0, 5),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 16),
// //                   /*TextField(
// //                     controller: weight,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('الوزن (جم)', 'Weight (g)'),
// //                       prefixIcon: const Icon(Icons.scale, color: Color(0xFFD4AF37)),
// //                       border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),*/
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       TextField(
// //                         controller: weight,
// //                         keyboardType: TextInputType.number,
// //                         readOnly: _autoWeightMode,
// //                         decoration: InputDecoration(
// //                           labelText: _t('الوزن (جم)', 'Weight (g)'),
// //                           border: const OutlineInputBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(12)),
// //                           ),
// //                           // ✅ زرار الاتصال بالميزان على اليسار
// //                           prefixIcon: IconButton(
// //                             tooltip: _t('اتصال بالميزان', 'Connect Scale'),
// //                             icon: Icon(
// //                               widget.isConnected
// //                                   ? Icons.bluetooth_connected
// //                                   : Icons.bluetooth,
// //                               color: widget.isConnected
// //                                   ? Colors.green
// //                                   : Colors.grey,
// //                             ),
// //                             onPressed: widget.connectToScale,
// //                           ),
// //                           // ✅ زرار التحويل يدوي/تلقائي على اليمين
// //                           suffixIcon: IconButton(
// //                             tooltip: _autoWeightMode
// //                                 ? _t('تحويل ليدوي', 'Switch to Manual')
// //                                 : _t('تحويل لتلقائي', 'Switch to Scale'),
// //                             icon: Icon(
// //                               _autoWeightMode ? Icons.edit : Icons.scale,
// //                               color:
// //                                   _autoWeightMode ? Colors.green : Colors.grey,
// //                             ),
// //                             onPressed: () {
// //                               setState(() {
// //                                 _autoWeightMode = !_autoWeightMode;
// //                                 if (_autoWeightMode) weight.clear();
// //                               });
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       if (_autoWeightMode)
// //                         Padding(
// //                           padding: const EdgeInsets.only(top: 4, right: 4),
// //                           child: Row(
// //                             children: [
// //                               Icon(
// //                                 widget.isConnected
// //                                     ? Icons.bluetooth_connected
// //                                     : Icons.bluetooth_disabled,
// //                                 size: 14,
// //                                 color: widget.isConnected
// //                                     ? Colors.green
// //                                     : Colors.red,
// //                               ),
// //                               const SizedBox(width: 4),
// //                               Text(
// //                                 widget.isConnected
// //                                     ? _t('في انتظار الميزان...',
// //                                         'Waiting for scale...')
// //                                     : _t('الميزان غير متصل',
// //                                         'Scale not connected'),
// //                                 style: TextStyle(
// //                                   fontSize: 12,
// //                                   color: widget.isConnected
// //                                       ? Colors.green
// //                                       : Colors.red,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: wage,
// //                     keyboardType: TextInputType.number,
// //                     decoration: InputDecoration(
// //                       labelText: _t('الأجر', 'Wage'),
// //                       prefixIcon: const Icon(Icons.attach_money,
// //                           color: Color(0xFFD4AF37)),
// //                       border: const OutlineInputBorder(
// //                           borderRadius: BorderRadius.all(Radius.circular(12))),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ElevatedButton.icon(
// //                     onPressed: _pickImage,
// //                     icon: const Icon(Icons.camera_alt),
// //                     label: const Text('تصوير صورة'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFFD4AF37),
// //                       foregroundColor: Colors.white,
// //                     ),
// //                   ),
// //                   if (selectedImage != null) ...[
// //                     const SizedBox(height: 16),
// //                     SizedBox(
// //                       height: 200,
// //                       child: Image.file(
// //                         selectedImage!,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 10),
// //                     OutlinedButton.icon(
// //                       onPressed: () {
// //                         setState(() {
// //                           _pinImage = !_pinImage;
// //                         });
// //                       },
// //                       icon: Icon(
// //                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
// //                         color: _pinImage ? Colors.orange : null,
// //                       ),
// //                       label: Text(
// //                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
// //                       ),
// //                     ),
// //                     const SizedBox(height: 16),
// //                   ],
// //                   const SizedBox(height: 10),
// //                   // استبدل الـ TextField بالكود ده
// //                   Column(
// //                     children: [
// //                       InkWell(
// //                         onTap: () => setState(() => _showNotes = !_showNotes),
// //                         borderRadius: BorderRadius.circular(12),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 12, vertical: 2),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: Row(
// //                             children: [
// //                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                               const SizedBox(width: 12),
// //                               Expanded(
// //                                 child: Text(
// //                                   notes.text.isEmpty
// //                                       ? _t('ملاحظات', 'Notes')
// //                                       : notes.text,
// //                                   style: TextStyle(
// //                                     color:
// //                                         notes.text.isEmpty ? Colors.grey : null,
// //                                   ),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                               Icon(
// //                                 _showNotes
// //                                     ? Icons.keyboard_arrow_up
// //                                     : Icons.keyboard_arrow_down,
// //                                 color: Colors.grey,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       if (_showNotes) ...[
// //                         const SizedBox(height: 8),
// //                         TextField(
// //                           controller: notes,
// //                           maxLines: 3,
// //                           autofocus: true,
// //                           decoration: InputDecoration(
// //                             labelText: _t('ملاحظات', 'Notes'),
// //                             prefixIcon: const Icon(Icons.note,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: const OutlineInputBorder(
// //                               borderRadius:
// //                                   BorderRadius.all(Radius.circular(12)),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ],
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: widget.qrController,
// //                     readOnly: true,
// //                     decoration: InputDecoration(
// //                       labelText: widget.useScanner
// //                           ? _t("QR من الماسح", "QR from Scanner")
// //                           : _t("QR عشوائي", "Random QR"),
// //                       border: const OutlineInputBorder(),

// //                       // الزرار الصغير جنب الحقل
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           widget.useScanner
// //                               ? Icons.qr_code_scanner
// //                               : Icons.shuffle,
// //                         ),
// //                         tooltip: widget.useScanner
// //                             ? _t("استخدام QR عشوائي", "Use Random QR")
// //                             : _t("استخدام الماسح", "Use Scanner"),
// //                         onPressed: widget.toggleQRMode,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),
// //                   TextField(
// //                     controller: _note1Controller,
// //                     decoration: InputDecoration(
// //                       labelText: "اكتب للطباعة 1",
// //                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                     ),
// //                     //keyboardType: TextInputType.number,
// //                   ),
// //                   const SizedBox(height: 24),
// //                   TextField(
// //                     controller: _note2Controller,
// //                     decoration: InputDecoration(
// //                       labelText: "اكتب للطباعة 2",
// //                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                     ),
// //                     //keyboardType: TextInputType.number,
// //                   ),
// //                   const SizedBox(height: 24),
// //                   // زر الطباعة قبل زر الحفظ
// //                   /*SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: (busy || widget.isPrinting ) ? null : () async {
// //                         await widget.onPrint(
// //                           weight: weight.text,
// //                           note1: _note1Controller.text,
// //                           note2: _note2Controller.text,
// //                           showQr: "$showQr",
// //                           qrCode: widget.qrController.text,
// //                         );
// //                       },
// //                       icon: widget.isPrinting
// //                           ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
// //                           : const Icon(Icons.print),
// //                       label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل السبائك"),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
// //                         foregroundColor: Colors.white,
// //                         padding: const EdgeInsets.symmetric(vertical: 16),
// //                         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                       ),
// //                     ),
// //                   ),*/
// //                   Row(
// //                     children: [
// //                       // زر الطباعة (ياخد باقي المساحة)
// //                       Expanded(
// //                         child: ElevatedButton.icon(
// //                           onPressed: (busy || widget.isPrinting)
// //                               ? null
// //                               : () async {
// //                                   if (_activeProfile != null) {
// //                                     // احفظه مؤقتاً كـ active layout
// //                                     await LabelLayoutStorage.save(
// //                                         _activeProfile!.layout);
// //                                   }
// //                                   await widget.onPrint(
// //                                     weight: weight.text,
// //                                     note1: _note1Controller.text,
// //                                     note2: _note2Controller.text,
// //                                     showQr: "$showQr",
// //                                     qrCode: widget.qrController.text,
// //                                   );
// //                                   setState(() {
// //                                     showManualEpcField = true;
// //                                     manualEpcController.clear();
// //                                   });
// //                                   WidgetsBinding.instance
// //                                       .addPostFrameCallback((_) {
// //                                     FocusScope.of(context)
// //                                         .requestFocus(manualEpcFocus);
// //                                   });
// //                                 },
// //                           icon: widget.isPrinting
// //                               ? const SizedBox(
// //                                   width: 24,
// //                                   height: 24,
// //                                   child: CircularProgressIndicator(
// //                                     color: Colors.white,
// //                                     strokeWidth: 3,
// //                                   ),
// //                                 )
// //                               : const Icon(Icons.print),
// //                           label: Text(
// //                             widget.isPrinting
// //                                 ? "جاري الطباعة..."
// //                                 : "طباعة ليبل الذهب",
// //                           ),
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: widget.isPrinterConnected
// //                                 ? const Color(0xFFD4AF37)
// //                                 : Colors.green,
// //                             foregroundColor: Colors.white,
// //                             padding: const EdgeInsets.symmetric(vertical: 16),
// //                             textStyle: const TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.bold),
// //                             shape: RoundedRectangleBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                           ),
// //                         ),
// //                       ),

// //                       const SizedBox(width: 8),

// //                       // زرار الإعدادات (مربع صغير)
// //                       SizedBox(
// //                         width: 50,
// //                         height: 50,
// //                         child: OutlinedButton(
// //                           style: OutlinedButton.styleFrom(
// //                             padding: EdgeInsets.zero,
// //                             side: const BorderSide(color: Color(0xFFD4AF37)),
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                           ),
// //                           onPressed: () => _showProfilePicker('bullion'),
// //                           child: const Icon(
// //                             Icons.settings,
// //                             color: Color(0xFFD4AF37),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   if (showManualEpcField) ...[
// //                     const SizedBox(height: 16),
// //                     TextField(
// //                       controller: manualEpcController,
// //                       focusNode: manualEpcFocus,
// //                       textCapitalization: TextCapitalization.characters,
// //                       decoration: const InputDecoration(
// //                         labelText: 'أدخل رقم الشريحة',
// //                         border: OutlineInputBorder(),
// //                         prefixIcon: Icon(Icons.nfc),
// //                       ),
// //                       onSubmitted: (value) {
// //                         setState(() {
// //                           AddEpcManualy(value);
// //                           showManualEpcField = false;
// //                         });
// //                       },
// //                     ),
// //                   ],
// //                   const SizedBox(height: 24),
// //                   Container(
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         colors: [
// //                           const Color(0xFFD4AF37).withOpacity(0.1),
// //                           const Color(0xFFB8860B).withOpacity(0.05),
// //                         ],
// //                       ),
// //                       borderRadius:
// //                           const BorderRadius.vertical(top: Radius.circular(20)),
// //                     ),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         if (widget.epcHex.isNotEmpty) ...[
// //                           Text('EPC (hex): ${widget.epcHex}',
// //                               style: const TextStyle(fontFamily: 'monospace')),
// //                           const SizedBox(height: 8),
// //                         ],
// //                         Row(
// //                           children: [
// //                             if (widget.epcHex.isNotEmpty) ...[
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: OutlinedButton.icon(
// //                                   onPressed: busy ? null : widget.onClearEpc,
// //                                   icon: const Icon(Icons.clear),
// //                                   label: Text(_t('مسح', 'Clear')),
// //                                 ),
// //                               ),
// //                             ],
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     width: double.infinity,
// //                     child: ElevatedButton.icon(
// //                       onPressed: (busy ||
// //                               widget.epcHex.isEmpty ||
// //                               selectedImage == null ||
// //                               weight.text.isEmpty ||
// //                               wage.text.isEmpty ||
// //                               widget.qrController.text.isEmpty)
// //                           ? null
// //                           : _saveBullion,
// //                       icon: busy
// //                           ? const SizedBox(
// //                               height: 22,
// //                               width: 22,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2.5,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : const Icon(Icons.save),
// //                       label: busy
// //                           ? Text(_t('جاري الحفظ...', 'Saving...'))
// //                           : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void AddEpcManualy(String Epc) {
// //     SeuicUhfService.addEpcManualy(Epc);
// //   }
// // }
// import 'dart:async';
// //import 'package:barcode/barcode.dart';
// import 'package:flutter/material.dart';
// //import 'package:intl/intl.dart';
// import '../services/new_printer_api.dart';
// import '../services/new_printer_status.dart';
// import '../services/seuic_uhf_service.dart';
// import '../services/firestore_service.dart';
// import 'package:uuid/uuid.dart';
// //import 'package:qr_flutter/qr_flutter.dart';
// import '../services/seuic_scanner_service.dart';
// //import 'package:barcode_widget/barcode_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uhf_gold_shop/pages/settings_page.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../utils/image_compressor.dart';
// import 'dart:ui' as ui;
// import 'package:bluetooth_classic/bluetooth_classic.dart';
// import 'package:bluetooth_classic/models/device.dart';
// import 'dart:typed_data';
// import 'label_layout_model.dart';

// class InputPage extends StatefulWidget {
//   final bool fromOpeningBalance;
//   const InputPage({super.key, required this.fromOpeningBalance});
//   @override
//   State<InputPage> createState() => _InputPageState();
// }

// class _InputPageState extends State<InputPage> with TickerProviderStateMixin {
//   late TabController _tabController;
//   String epcHex = '';
//   bool isFromScanner = false;
//   StreamSubscription<String>? _uhfSubscription;
//   String _lang = 'ar'; // 🟢 اللغة الحالية

//   final TextEditingController qrController = TextEditingController();
//   bool useScanner = false;

//   final List<String> typeOptions = [
//     'خاتم',
//     'اسورة',
//     'بنجرة',
//     'حلق',
//     'خلخال',
//     'تعليقة',
//     'حزام',
//     'تاج',
//     'كف',
//     'عقد',
//     'انسيال',
//     'سلسال',
//     'طقم',
//     'طقم هافست',
//     'غير ذلك'
//   ];

//   final List<String> setComponentOptions = [
//     'خاتم',
//     'اسورة',
//     'بنجرة',
//     'حلق',
//     'خلخال',
//     'تعليقة',
//     'حزام',
//     'تاج',
//     'كف',
//     'عقد',
//     'انسيال',
//     'سلسال',
//     'غير ذلك'
//   ];

//   String? selectedGoldType;
//   String? selectedScrapType;
//   List<String> selectedSetComponents = [];
//   bool showSetComponents = false;
//   bool showScrapSetComponents = false;

//   late final TabController _tab = TabController(length: 3, vsync: this);
//   bool isReadFromChip = false;
//   bool isReading = false;
//   StreamSubscription<String>? _tagSubscription;

//   // 🟢 تحميل اللغة من SharedPreferences
//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   // 🟢 دالة الترجمة المحلية
//   String _t(String key, String lang) {
//     final map = {
//       'ar': {
//         'gold': 'ذهب',
//         'stones': 'أحجار',
//         'ingots': 'سبائك',
//         'chipAlreadyExists': '⚠️ هذه الشريحة مسجلة من قبل',
//         'noChipFound': 'لم يتم العثور على شريحة - جرب فتح تطبيق UHF',
//         'openUHF': 'فتح UHF',
//         'chipReadError': 'خطأ في قراءة الشريحة:',
//         'chipReadSuccess': 'تم قراءة الشريحة:',
//       },
//       'en': {
//         'gold': 'Gold',
//         'stones': 'Stones',
//         'ingots': 'Ingots',
//         'chipAlreadyExists': '⚠️ This tag is already registered',
//         'noChipFound': 'No chip found - try opening the UHF app',
//         'openUHF': 'Open UHF',
//         'chipReadError': 'Error reading chip:',
//         'chipReadSuccess': 'Tag read:',
//       },
//     };
//     return map[lang]?[key] ?? key;
//   }

//   // نقل حالة الطابعة من printer_page
//   bool _isPrinting = false;
//   String? _errorMessage;
//   String? _successMessage;
//   String? _progressMessage;

//   // حالة الطابعة
//   bool _isPrinterConnected = false;
//   String _connectedPrinterName = "غير متصلة";
//   String? _connectedPrinterMac;

//   StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

//   @override
//   void initState() {
//     super.initState();
//     //SeuicUhfService.sendBoolean(false);
//     _loadLanguage(); // 🟢 تحميل اللغة أول ما الصفحة تفتح
//     //_setPagePower();
//     //_loadSavedReaderPower();
//     final randomQr = const Uuid().v4().substring(0, 7);
//     setState(() {
//       qrController.text = randomQr;
//     });
//     _loadDecimalPlaces();

//     SeuicScannerService.scanStream.listen((event) {
//       if (useScanner) {
//         setState(() {
//           qrController.text = event['barcode'] ?? '';
//         });
//       }
//     });

//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
//       if (!mounted) return;

//       if (tag.length >= 24) {
//         final exists = await FS.checkItemExists(tag.toUpperCase());
//         if (exists) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(_t('chipAlreadyExists', _lang)),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }

//         setState(() {
//           epcHex = tag.toUpperCase();
//           isReadFromChip = true;
//           isReading = false;
//         });
//       } else {
//         // ✅ تم إزالة السطر الذي كان يضع الرقم في qrController
//         // ✅ سيتم التعامل مع الرقم داخل كل Form على حدة
//         // setState(() {
//         //   qrController.text = tag; // ❌ تم إزالة هذا السطر
//         // });
//       }
//     });

//     SeuicUhfService.open();
//     // نقل الاستماع لحالة الطابعة من printer_page
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
//             _connectedPrinterMac = match?.group(1); // في الغالب هو الـ MAC
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

//   Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['Input'] ?? 26;
//       await SeuicUhfService.setPower(pagePower);
//       print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//     }
//   }

//   @override
//   Future<void> dispose() async {
//     _tagSubscription?.cancel();
//     _printerStatusSubscription?.cancel(); // إلغاء الاستماع لحالة الطابعة
//     _weightDataSubscription?.cancel(); // ✅ إلغاء subscription الوزن
//     _weightStreamController.close();
//     await _bluetoothClassicPlugin.disconnect();
//     super.dispose();
//     qrController.dispose();
//   }

//   String _generateRandomQR() {
//     return const Uuid().v4().substring(0, 7);
//   }

//   void _toggleQRMode() {
//     setState(() {
//       useScanner = !useScanner;
//       if (!useScanner) {
//         qrController.text = _generateRandomQR();
//       } else {
//         qrController.clear();
//       }
//     });
//   }

//   Future<void> _readChip() async {
//     setState(() {
//       isReading = true;
//     });
//     try {
//       final result = await SeuicUhfService.inventoryOnce();
//       if (result == null || result.isEmpty) {
//         setState(() {
//           isReading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_t('noChipFound', _lang)),
//             backgroundColor: Colors.orange,
//             action: SnackBarAction(
//               label: _t('openUHF', _lang),
//               textColor: Colors.white,
//               onPressed: SeuicUhfService.openUhfApp,
//             ),
//           ),
//         );
//       } else {
//         final exists = await FS.checkItemExists(result.toUpperCase());
//         if (exists) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(_t('chipAlreadyExists', _lang)),
//               backgroundColor: Colors.red,
//             ),
//           );
//           return;
//         }

//         setState(() {
//           epcHex = result.toUpperCase();
//           isReadFromChip = true;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.nfc, color: Colors.white),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                       '${_t('chipReadSuccess', _lang)} ${result.substring(0, result.length > 20 ? 20 : result.length)}...'),
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
//       }
//     } catch (e) {
//       setState(() {
//         isReading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('${_t('chipReadError', _lang)} $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _clearEpc() {
//     setState(() {
//       epcHex = '';
//       isReadFromChip = false;
//     });
//   }

//   void _clearMessages() {
//     setState(() {
//       _errorMessage = null;
//       _successMessage = null;
//       _progressMessage = null;
//     });
//   }

//   // نقل دالة اختيار والاتصال بالطابعة
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

//   // نقل دالة بناء الرسائل
//   Widget _buildMessage(String msg, Color color, [bool loading = false]) {
//     final isError = color == Colors.red;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         border: Border.all(color: color.withOpacity(0.6)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           loading
//               ? const SizedBox(
//                   width: 24,
//                   height: 24,
//                   child: CircularProgressIndicator(strokeWidth: 2))
//               : Icon(
//                   loading
//                       ? Icons.print
//                       : (color == Colors.green
//                           ? Icons.check_circle
//                           : Icons.error),
//                   color: color),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(msg.split('. ')[0],
//                     style:
//                         TextStyle(color: color, fontWeight: FontWeight.w600)),
//                 if (isError && msg.contains('. '))
//                   Text(msg.split('. ').skip(1).join('. '),
//                       style: TextStyle(color: Colors.red[700], fontSize: 12)),
//               ],
//             ),
//           ),
//           IconButton(icon: const Icon(Icons.close), onPressed: _clearMessages),
//         ],
//       ),
//     );
//   }

//   int _readerPower = 26; // القيمة الحالية
//   int _tempPower = 26; // قيمة السلايدر المؤقتة
//   Future<void> _loadSavedReaderPower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');

//     if (powerJson != null) {
//       final Map<String, dynamic> pagePowers =
//           Map<String, dynamic>.from(json.decode(powerJson));

//       final savedPower = pagePowers['Input'];
//       if (savedPower != null) {
//         setState(() {
//           _readerPower = savedPower;
//           _tempPower = savedPower;
//         });

//         // تطبيق القوة فعليًا على القارئ
//         await SeuicUhfService.setPower(savedPower);
//       }
//     }
//   }

//   void _showPowerSheet() {
//     _tempPower = _readerPower;
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     _t('قوة قارئ RFID', 'RFID Reader Power'),
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     '${_tempPower} dBm',
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Slider(
//                     min: 1,
//                     max: 33,
//                     divisions: 25,
//                     value: _tempPower.toDouble(),
//                     label: _tempPower.toString(),
//                     onChanged: (v) {
//                       setModalState(() {
//                         _tempPower = v.round();
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text(_t('إلغاء', 'Cancel')),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFD4AF37),
//                           ),
//                           onPressed: () async {
//                             setState(() {
//                               _readerPower = _tempPower;
//                             });

//                             // تطبيق القوة فورًا
//                             await SeuicUhfService.setPower(_readerPower);

//                             // حفظها للصفحة
//                             final prefs = await SharedPreferences.getInstance();
//                             final powerJson = prefs.getString('pagePowers');
//                             Map<String, int> pagePowers = {};

//                             if (powerJson != null) {
//                               pagePowers =
//                                   Map<String, int>.from(json.decode(powerJson));
//                             }

//                             pagePowers['Input'] = _readerPower;
//                             await prefs.setString(
//                                 'pagePowers', json.encode(pagePowers));

//                             Navigator.pop(context);

//                             /*_showMsg(
//                               _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'),
//                               true,
//                             );*/
//                             showAppMessage(
//                                 context,
//                                 _t('تم ضبط قوة القارئ بنجاح',
//                                     'Reader power updated'));
//                           },
//                           child: Text(_t('حفظ', 'Save')),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void showAppMessage(BuildContext context, String msg) {
//     final isSuccess = msg.contains('تمت') ||
//         msg.contains('تم') ||
//         msg.contains('written') ||
//         msg.contains('Saved');

//     ScaffoldMessenger.of(context).clearSnackBars();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(msg),
//         ),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }

//   final _bluetoothClassicPlugin = BluetoothClassic();
//   String buffer = "";
//   final _weightStreamController = StreamController<String>.broadcast();
//   bool isConnected = false;
//   StreamSubscription<Uint8List>?
//       _weightDataSubscription; // ✅ حفظ subscription الوزن
//   int _decimalPlaces = 2; // ✅ الافتراضي 0.00

// // ✅ تحميل الإعداد المحفوظ
//   Future<void> _loadDecimalPlaces() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _decimalPlaces = prefs.getInt('weightDecimalPlaces') ?? 2;
//     });
//   }

//   Future<void> connectToScale() async {
//     // ✅ لو كان في اتصال قديم، قطعه الأول
//     if (isConnected) {
//       await _weightDataSubscription?.cancel();
//       await _bluetoothClassicPlugin.disconnect();
//       setState(() {
//         isConnected = false;
//       });
//     }

//     await _bluetoothClassicPlugin.initPermissions();
//     final devices = await _bluetoothClassicPlugin.getPairedDevices();

//     final selected = await showDialog<Device>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("اختر الميزان"),
//         content: SizedBox(
//           height: 370,
//           width: double.maxFinite,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ✅ اختيار عدد الأرقام العشرية
//               StatefulBuilder(
//                 builder: (ctx, setLocalState) => Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("دقة الوزن: "),
//                       ChoiceChip(
//                         label: const Text("0.00"),
//                         selected: _decimalPlaces == 2,
//                         onSelected: (_) async {
//                           final prefs = await SharedPreferences.getInstance();
//                           await prefs.setInt('weightDecimalPlaces', 2);
//                           setLocalState(() {});
//                           setState(() => _decimalPlaces = 2);
//                         },
//                       ),
//                       const SizedBox(width: 8),
//                       ChoiceChip(
//                         label: const Text("0.000"),
//                         selected: _decimalPlaces == 3,
//                         onSelected: (_) async {
//                           final prefs = await SharedPreferences.getInstance();
//                           await prefs.setInt('weightDecimalPlaces', 3);
//                           setLocalState(() {});
//                           setState(() => _decimalPlaces = 3);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // ✅ قائمة الأجهزة
//               Expanded(
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: devices.map((d) {
//                     return ListTile(
//                       title: Text(d.name ?? "HC-06"),
//                       subtitle: Text(d.address),
//                       onTap: () => Navigator.pop(ctx, d),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );

//     if (selected == null) return;

//     await _bluetoothClassicPlugin.connect(
//       selected.address,
//       "00001101-0000-1000-8000-00805f9b34fb",
//     );

//     setState(() {
//       isConnected = true;
//     });

//     listenToWeight();
//   }

//   void listenToWeight() {
//     // ✅ إلغاء الـ subscription القديمة قبل ما نعمل جديدة
//     _weightDataSubscription?.cancel();
//     buffer = ""; // ✅ مسح الـ buffer القديم

//     _weightDataSubscription =
//         _bluetoothClassicPlugin.onDeviceDataReceived().listen((Uint8List data) {
//       final raw = String.fromCharCodes(data);
//       print("RAW DATA: $raw"); // ← أضيفي السطر ده
//       buffer += String.fromCharCodes(data);

//       if (buffer.contains("\n")) {
//         String full = buffer.trim();
//         buffer = "";

//         final match = RegExp(r'\d+\.?\d*').firstMatch(full);
//         final rawWeight = match != null ? match.group(0)! : '';

//         if (rawWeight.isNotEmpty) {
//           // ✅ تطبيق عدد الأرقام العشرية المحدد
//           final parsed = double.tryParse(rawWeight);
//           final formatted = parsed != null
//               ? parsed.toStringAsFixed(_decimalPlaces)
//               : rawWeight;

//           print("Weight: $formatted");
//           if (!_weightStreamController.isClosed) {
//             _weightStreamController.add(formatted);
//           }
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         /*floatingActionButton: FloatingActionButton(
//           backgroundColor: const Color(0xFFD4AF37),
//           tooltip: _t('قوة القارئ', 'Reader Power'),
//           onPressed: _showPowerSheet,
//           child: const Icon(Icons.tune),
//         ),*/
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Theme.of(context).colorScheme.surface,
//                 Theme.of(context).colorScheme.surface.withOpacity(0.8),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               // إضافة شريط حالة الطابعة في الأعلى (نقل من printer_page)
//               Card(
//                 color: _isPrinterConnected
//                     ? Colors.green.shade50
//                     : Colors.red.shade50,
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _isPrinterConnected
//                             ? Icons.print
//                             : Icons.print_disabled,
//                         color: _isPrinterConnected ? Colors.green : Colors.red,
//                         size: 32,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "حالة الطابعة",
//                               style: TextStyle(
//                                   fontSize: 14, color: Colors.grey[700]),
//                             ),
//                             Text(
//                               _isPrinterConnected
//                                   ? _connectedPrinterName
//                                   : "غير متصلة",
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: _isPrinterConnected
//                                     ? Colors.green.shade700
//                                     : Colors.red.shade700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         onPressed: _selectAndConnectPrinter,
//                         icon: const Icon(Icons.bluetooth_searching, size: 18),
//                         label: Text(_isPrinterConnected ? "متصلة" : "اتصال"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _isPrinterConnected
//                               ? Colors.red
//                               : const Color(0xFFD4AF37),
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 10),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           await NewPrinterAPI.disconnect();
//                         },
//                         icon: const Icon(Icons.bluetooth_disabled, size: 18),
//                         label: const Text("فصل"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // رسائل الحالة للطابعة
//               if (_errorMessage != null)
//                 _buildMessage(_errorMessage!, Colors.red),
//               if (_successMessage != null)
//                 _buildMessage(_successMessage!, Colors.green),
//               if (_progressMessage != null)
//                 _buildMessage(_progressMessage!, Colors.blue, true),
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.surface,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: TabBar(
//                     controller: _tab,
//                     indicator: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
//                       ),
//                     ),
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     dividerColor: Colors.transparent,
//                     labelColor: Colors.white,
//                     unselectedLabelColor: Theme.of(context)
//                         .colorScheme
//                         .onSurface
//                         .withOpacity(0.6),
//                     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                     tabs: [
//                       Tab(child: Text(_t('gold', _lang))),
//                       Tab(child: Text(_t('stones', _lang))),
//                       Tab(child: Text(_t('ingots', _lang))),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tab,
//                   children: [
//                     GoldForm(
//                       epcHex: epcHex,
//                       onReadChip: _readChip,
//                       onClearEpc: _clearEpc,
//                       isReadFromChip: isReadFromChip,
//                       isReading: isReading,
//                       qrController: qrController,
//                       useScanner: useScanner,
//                       toggleQRMode: _toggleQRMode,
//                       fromOpeningBalance: widget.fromOpeningBalance,
//                       onPrint: _printGoldLabel, // نقل دالة الطباعة
//                       isPrinterConnected: _isPrinterConnected,
//                       isPrinting: _isPrinting,
//                       weightStream: _weightStreamController.stream,
//                       isConnected: isConnected,
//                       connectToScale: connectToScale,
//                     ),
//                     GemForm(
//                       epcHex: epcHex,
//                       onReadChip: _readChip,
//                       onClearEpc: _clearEpc,
//                       isReadFromChip: isReadFromChip,
//                       isReading: isReading,
//                       qrController: qrController,
//                       useScanner: useScanner,
//                       toggleQRMode: _toggleQRMode,
//                       fromOpeningBalance: widget.fromOpeningBalance,
//                       onPrint:
//                           _printGemLabel, // دالة طباعة مخصصة للأحجار (يمكن تخصيصها)
//                       isPrinterConnected: _isPrinterConnected,
//                       isPrinting: _isPrinting,
//                     ),
//                     BullionForm(
//                       epcHex: epcHex,
//                       onReadChip: _readChip,
//                       onClearEpc: _clearEpc,
//                       isReadFromChip: isReadFromChip,
//                       isReading: isReading,
//                       qrController: qrController,
//                       useScanner: useScanner,
//                       toggleQRMode: _toggleQRMode,
//                       fromOpeningBalance: widget.fromOpeningBalance,
//                       onPrint:
//                           _printBullionLabel, // دالة طباعة مخصصة للسبائك (يمكن تخصيصها)
//                       isPrinterConnected: _isPrinterConnected,
//                       isPrinting: _isPrinting,
//                       weightStream: _weightStreamController.stream,
//                       isConnected: isConnected,
//                       connectToScale: connectToScale,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // نقل دالة الطباعة للذهب (يمكن تخصيص للأخرى)
//   Future<void> _printGoldLabel({
//     String? weight,
//     String? carat,
//     String? size,
//     required String showQr,
//     required String qrCode,
//   }) async {
//     _clearMessages();

//     setState(() => _isPrinting = true);

//     try {
//       final layout = await LabelLayoutStorage.load('gold');
//       final prefs = await SharedPreferences.getInstance();
//       final String? logoBase64 = prefs.getString('custom_logo_base64');

//       final success = await NewPrinterAPI.printGoldLabel(
//         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
//         weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
//         carat: carat?.trim().isEmpty ?? true ? null : carat?.trim(),
//         size: size?.trim().isEmpty ?? true ? null : size?.trim(),
//         showQr: showQr.trim(),
//         qrCode: qrCode.trim(),
//         customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
//         labelLayout: layout.toJson(),
//       );

//       if (!success) {
//         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
//         );
//       }
//     } catch (e) {
//       setState(() =>
//           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
//     } finally {
//       setState(() => _isPrinting = false);
//     }
//   }

//   Future<void> _printBullionLabel({
//     String? weight,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//   }) async {
//     _clearMessages();

//     setState(() => _isPrinting = true);

//     try {
//       // ← أهم سطر في حياتك دلوقتي
//       final layout = await LabelLayoutStorage.load('bullion');
//       final prefs = await SharedPreferences.getInstance();
//       final String? logoBase64 = prefs.getString('custom_logo_base64');

//       final success = await NewPrinterAPI.printBullionLabel(
//         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
//         weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
//         note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
//         note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
//         showQr: showQr.trim(),
//         qrCode: qrCode.trim(),
//         customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
//         labelLayout: layout.toJson(),
//       );

//       if (!success) {
//         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
//         );
//       }
//     } catch (e) {
//       setState(() =>
//           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
//     } finally {
//       setState(() => _isPrinting = false);
//     }
//   }

//   Future<void> _printGemLabel({
//     String? gemType,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//   }) async {
//     _clearMessages();

//     setState(() => _isPrinting = true);

//     try {
//       // ← أهم سطر في حياتك دلوقتي
//       final layout = await LabelLayoutStorage.load('gem');
//       final prefs = await SharedPreferences.getInstance();
//       final String? logoBase64 = prefs.getString('custom_logo_base64');

//       final success = await NewPrinterAPI.printGemLabel(
//         //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
//         gemType: gemType?.trim().isEmpty ?? true ? null : gemType?.trim(),
//         note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
//         note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
//         showQr: showQr.trim(),
//         qrCode: qrCode.trim(),
//         customLogoBase64:
//             logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin        labelLayout: layout.toJson(),
//       );

//       if (!success) {
//         //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
//         );
//       }
//     } catch (e) {
//       setState(() =>
//           _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
//     } finally {
//       setState(() => _isPrinting = false);
//     }
//   }
// }

// class GoldForm extends StatefulWidget {
//   final String epcHex;
//   final VoidCallback onReadChip;
//   final VoidCallback onClearEpc;
//   final bool isReadFromChip;
//   final bool isReading;
//   final TextEditingController qrController;
//   final bool useScanner;
//   final VoidCallback toggleQRMode;
//   final bool fromOpeningBalance;
//   final bool isPrinterConnected; //الطابعة
//   final bool isPrinting;
//   final Stream<String> weightStream;
//   final bool isConnected;
//   final VoidCallback connectToScale;
//   final Future<void> Function({
//     String? weight,
//     String? carat,
//     String? size,
//     required String showQr,
//     required String qrCode,
//   }) onPrint;
//   const GoldForm({
//     super.key,
//     required this.epcHex,
//     required this.onReadChip,
//     required this.onClearEpc,
//     this.isReadFromChip = false,
//     this.isReading = false,
//     required this.qrController,
//     required this.useScanner,
//     required this.toggleQRMode,
//     required this.fromOpeningBalance,
//     required this.isPrinterConnected,
//     required this.isPrinting,
//     required this.weightStream,
//     required this.isConnected,
//     required this.connectToScale,
//     required this.onPrint,
//   });

//   @override
//   State<GoldForm> createState() => _GoldFormState();
// }

// class _GoldFormState extends State<GoldForm> {
//   DateTime date = DateTime.now();
//   String carat = '21';
//   final weight = TextEditingController();
//   final wage = TextEditingController();
//   //final kind = TextEditingController();
//   final notes = TextEditingController();
//   bool busy = false;
//   String? msg;

//   String? selectedGoldType = 'خاتم';
//   bool showSetComponents = false;
//   List<String> selectedSetComponents = [];
//   File? selectedImage;
//   bool _pinImage = false; // تثبيت الصورة
//   bool _autoWeightMode = false; // false = يدوي، true = من الميزان
//   StreamSubscription<String>? _weightSub;
//   LabelProfile? _activeProfile; // البروفايل المختار حالياً

//   final List<String> typeOptions = [
//     'خاتم',
//     'اسورة',
//     'خاتم و اسورة',
//     'بنجرة',
//     'حلق',
//     'خلخال',
//     'تعليقة',
//     'حزام',
//     'تاج',
//     'كف',
//     'عقد',
//     'انسيال',
//     'سلسال',
//     'شوكر',
//     'طوق',
//     'مخنق',
//     'سبحة',
//     'طقم',
//     'طقم هافست',
//     'غير ذلك'
//   ];

//   List<String> get setComponentOptions => typeOptions
//       .where(
//         (type) => type != 'طقم' && type != 'طقم هافست',
//       )
//       .toList();
//   // ✅ متغيرات QR
//   bool showQr = true; // true = QR, false = Barcode
//   CodeDisplayMode _displayMode = CodeDisplayMode.qr;
//   String _lang = 'ar';
//   final TextEditingController _sizeController = TextEditingController();

//   // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
//   final TextEditingController manualEpcController = TextEditingController();
//   final FocusNode manualEpcFocus = FocusNode();
//   bool showManualEpcField = false;
//   StreamSubscription<String>? _tagSubscription;

//   void _subscribeToWeight() {
//     _weightSub?.cancel();
//     _weightSub = widget.weightStream.listen((value) {
//       if (_autoWeightMode) {
//         final match = RegExp(r'\d+\.?\d*').firstMatch(value);
//         final cleaned = match != null ? match.group(0)! : '';
//         if (cleaned.isNotEmpty) {
//           setState(() => weight.text = cleaned);
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     _loadLanguage();
//     _loadActiveProfile();
//     weight.addListener(_onFormChanged);
//     wage.addListener(_onFormChanged);
//     widget.qrController.addListener(_onFormChanged);
//     _sizeController.text = "0";
//     _loadSettings();

//     // ✅ استماع للقارئ داخل GoldForm
//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
//       if (!mounted) return;

//       // ✅ نتعامل مع الأرقام القصيرة (QR) فقط، والأرقام الطويلة (EPC) تتعامل معها الصفحة الأم
//       if (tag.length < 24) {
//         setState(() {
//           manualEpcController.text = tag;
//           showManualEpcField = true;
//         });

//         // ✅ نطلب التركيز يفضل في حقل الشريحة
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             FocusScope.of(context).requestFocus(manualEpcFocus);
//           }
//         });
//       }
//     });

//     _subscribeToWeight();
//   }

//   @override
//   void didUpdateWidget(GoldForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.weightStream != widget.weightStream) {
//       _subscribeToWeight();
//     }
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     _weightSub?.cancel();
//     weight.removeListener(_onFormChanged);
//     wage.removeListener(_onFormChanged);
//     widget.qrController.removeListener(_onFormChanged);
//     manualEpcController.dispose();
//     manualEpcFocus.dispose();
//     super.dispose();
//   }

//   Future<void> _loadActiveProfile() async {
//     final profile = await LabelProfileStorage.loadActive('gold');
//     if (mounted) setState(() => _activeProfile = profile);
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
//               // Handle
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               // Header
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
//               // القائمة
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
//                         LabelProfileStorage.saveActive(
//                             'gold', p.id); // ← السطر الجديد
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

//   void _onFormChanged() {
//     setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
//   }

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('displayMode');
//     if (saved != null) {
//       setState(() {
//         _displayMode = CodeDisplayMode.values.firstWhere(
//           (e) => e.name == saved,
//           orElse: () => CodeDisplayMode.qr,
//         );
//         if (_displayMode == CodeDisplayMode.qr) {
//           showQr = true;
//         } else if (_displayMode == CodeDisplayMode.barcode) {
//           showQr = false;
//         }
//       });
//     }
//   }

//   // 🟢 تحميل اللغة من SharedPreferences
//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   bool useScanner = false;
//   void showAppMessage(BuildContext context, String msg) {
//     final isSuccess = msg.contains('تمت') ||
//         msg.contains('تم') ||
//         msg.contains('written') ||
//         msg.contains('Saved');

//     ScaffoldMessenger.of(context).clearSnackBars();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(msg),
//         ),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }

//   void AddEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//   }

//   Future<void> _saveGold() async {
//     setState(() {
//       busy = true;
//       msg = null;
//     });
//     try {
//       final w = double.tryParse(weight.text) ?? 0;
//       final wg = double.tryParse(wage.text) ?? 0;
//       await FS.saveItem(
//         epcHex: widget.epcHex,
//         category: 'gold',
//         date: date,
//         payload: {
//           'carat': carat,
//           'size': _sizeController.text,
//           'weight': w,
//           'wage': w * wg,
//           'kind': selectedGoldType, // ✅ احفظ من الدروب داون
//           if (selectedGoldType == 'طقم' || selectedGoldType == 'طقم هافست')
//             'setComponents': selectedSetComponents,
//           'notes': notes.text.trim(),
//           'qrCode': widget.qrController.text,
//           'showQr': showQr,
//         },
//         fromOpeningBalance: widget.fromOpeningBalance,
//       );
//       // بعد await FS.saveItem(...)
//       if (selectedImage != null) {
//         await _uploadImage();
//       }
//       setState(() {
//         msg = _t('تم الحفظ بنجاح', 'Saved successfully');

//         // Reset form fields
//         weight.clear();
//         wage.clear();
//         //selectedGoldType = 'خاتم';
//         selectedSetComponents.clear();
//         showSetComponents = false;
//         notes.clear();
//         //carat = '21';
//         date = DateTime.now();
//         // امسح الشريحة بعد الحفظ
//         widget.onClearEpc?.call();
//         widget.qrController.text = const Uuid().v4().substring(0, 7);
//         // ✅ مسح حقل الشريحة وإخفائه
//         manualEpcController.clear();
//         showManualEpcField = false;

//         if (!_pinImage) {
//           selectedImage = null;
//         }
//       });
//       showAppMessage(context, msg!);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeOut,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         msg = '${_t('فشل الحفظ', 'Failed to save')}: $e';
//       });
//       showAppMessage(context, msg!);
//     } finally {
//       setState(() {
//         busy = false;
//       });
//     }
//   }

//   final ScrollController _scrollController = ScrollController();

//   // دالة اختيار الصورة
//   Future<void> _pickImage() async {
//     FocusScope.of(context).unfocus();

//     final picker = ImagePicker();
//     final xFile = await picker.pickImage(source: ImageSource.camera);

//     if (xFile != null) {
//       setState(() {
//         selectedImage = File(xFile.path);
//       });
//     }
//   }

//   // دالة رفع الصورة
//   Future<void> _uploadImage() async {
//     if (selectedImage == null) return;

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       final compressed = await compressImage(selectedImage!);
//       if (compressed == null) {
//         setState(() => msg = '❌ فشل ضغط الصورة');
//         return;
//       }

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(widget.epcHex)
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         cacheControl: 'public,max-age=300',
//       );

//       await storageRef.putFile(compressed, metadata);
//       final url = await storageRef.getDownloadURL();

//       await FS.uploadImage(widget.epcHex, {
//         'images': FieldValue.arrayUnion([url]),
//       });

//       setState(() => msg = '✅ تم رفع الصورة بنجاح');
//     } catch (e) {
//       setState(() => msg = '❌ فشل رفع الصورة: $e');
//     }
//   }

//   bool _showNotes = false;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: carat,
//                     items: const ['18', '21', '22']
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (v) => setState(() => carat = v ?? '21'),
//                     decoration: InputDecoration(
//                       labelText: _t('العيار', 'Carat'),
//                       prefixIcon: Icon(Icons.grade, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   /*TextField(
//                     controller: weight,
//                     keyboardType: TextInputType.number,
//                     decoration:  InputDecoration(
//                       labelText: _t('الوزن (جم)', 'Weight (g)'),

//                       prefixIcon: Icon(Icons.scale, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),*/
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: weight,
//                         keyboardType: TextInputType.number,
//                         readOnly: _autoWeightMode,
//                         decoration: InputDecoration(
//                           labelText: _t('الوزن (جم)', 'Weight (g)'),
//                           border: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(12)),
//                           ),
//                           // ✅ زرار الاتصال بالميزان على اليسار
//                           prefixIcon: IconButton(
//                             tooltip: _t('اتصال بالميزان', 'Connect Scale'),
//                             icon: Icon(
//                               widget.isConnected
//                                   ? Icons.bluetooth_connected
//                                   : Icons.bluetooth,
//                               color: widget.isConnected
//                                   ? Colors.green
//                                   : Colors.grey,
//                             ),
//                             onPressed: widget.connectToScale,
//                           ),
//                           // ✅ زرار التحويل يدوي/تلقائي على اليمين
//                           suffixIcon: IconButton(
//                             tooltip: _autoWeightMode
//                                 ? _t('تحويل ليدوي', 'Switch to Manual')
//                                 : _t('تحويل لتلقائي', 'Switch to Scale'),
//                             icon: Icon(
//                               _autoWeightMode ? Icons.edit : Icons.scale,
//                               color:
//                                   _autoWeightMode ? Colors.green : Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _autoWeightMode = !_autoWeightMode;
//                                 if (_autoWeightMode) weight.clear();
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       if (_autoWeightMode)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4, right: 4),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 widget.isConnected
//                                     ? Icons.bluetooth_connected
//                                     : Icons.bluetooth_disabled,
//                                 size: 14,
//                                 color: widget.isConnected
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 widget.isConnected
//                                     ? _t('في انتظار الميزان...',
//                                         'Waiting for scale...')
//                                     : _t('الميزان غير متصل',
//                                         'Scale not connected'),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: widget.isConnected
//                                       ? Colors.green
//                                       : Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: wage,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: _t('الأجر', 'Wage'),
//                       prefixIcon:
//                           Icon(Icons.attach_money, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: selectedGoldType,
//                     decoration: InputDecoration(
//                       labelText: _t('النوع', 'Type'),
//                       prefixIcon:
//                           Icon(Icons.category, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                     items: typeOptions.map((String type) {
//                       return DropdownMenuItem<String>(
//                         value: type,
//                         child: Text(type),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedGoldType = newValue;
//                         showSetComponents =
//                             newValue == 'طقم' || newValue == 'طقم هافست';

//                         if (!showSetComponents) {
//                           selectedSetComponents.clear();
//                         }
//                       });
//                     },
//                   ),
//                   if (showSetComponents) ...[
//                     const SizedBox(height: 16),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _t('مكونات الطقم', 'Set Components'),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFD4AF37),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 8,
//                             children: setComponentOptions.map((component) {
//                               final isSelected =
//                                   selectedSetComponents.contains(component);
//                               return FilterChip(
//                                 label: Text(component),
//                                 selected: isSelected,
//                                 onSelected: (selected) {
//                                   setState(() {
//                                     if (selected) {
//                                       selectedSetComponents.add(component);
//                                     } else {
//                                       selectedSetComponents.remove(component);
//                                     }
//                                   });
//                                 },
//                                 selectedColor:
//                                     const Color(0xFFD4AF37).withOpacity(0.3),
//                                 checkmarkColor: const Color(0xFFD4AF37),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: _sizeController,
//                     decoration: InputDecoration(
//                       labelText: "المقاس",
//                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('تصوير صورة'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                   if (selectedImage != null) ...[
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       height: 200,
//                       child: Image.file(
//                         selectedImage!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _pinImage = !_pinImage;
//                         });
//                       },
//                       icon: Icon(
//                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
//                         color: _pinImage ? Colors.orange : null,
//                       ),
//                       label: Text(
//                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   const SizedBox(height: 10),
//                   // استبدل الـ TextField بالكود ده
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: () => setState(() => _showNotes = !_showNotes),
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 2),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   notes.text.isEmpty
//                                       ? _t('ملاحظات', 'Notes')
//                                       : notes.text,
//                                   style: TextStyle(
//                                     color:
//                                         notes.text.isEmpty ? Colors.grey : null,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Icon(
//                                 _showNotes
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 color: Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (_showNotes) ...[
//                         const SizedBox(height: 8),
//                         TextField(
//                           controller: notes,
//                           maxLines: 3,
//                           autofocus: true,
//                           decoration: InputDecoration(
//                             labelText: _t('ملاحظات', 'Notes'),
//                             prefixIcon: const Icon(Icons.note,
//                                 color: Color(0xFFD4AF37)),
//                             border: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: widget.qrController,
//                     readOnly: true,
//                     focusNode: FocusNode(
//                         canRequestFocus: false), // ✅ منع التركيز على حقل QR
//                     decoration: InputDecoration(
//                       labelText: widget.useScanner
//                           ? _t("QR من الماسح", "QR from Scanner")
//                           : _t("QR عشوائي", "Random QR"),
//                       border: const OutlineInputBorder(),

//                       // الزرار الصغير جنب الحقل
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           widget.useScanner
//                               ? Icons.qr_code_scanner
//                               : Icons.shuffle,
//                         ),
//                         tooltip: widget.useScanner
//                             ? _t("استخدام QR عشوائي", "Use Random QR")
//                             : _t("استخدام الماسح", "Use Scanner"),
//                         onPressed: widget.toggleQRMode,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     children: [
//                       // زر الطباعة (ياخد باقي المساحة)
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: (busy || widget.isPrinting)
//                               ? null
//                               : () async {
//                                   if (_activeProfile != null) {
//                                     // احفظه مؤقتاً كـ active layout
//                                     await LabelLayoutStorage.save(
//                                         _activeProfile!.layout);
//                                   }
//                                   await widget.onPrint(
//                                     weight: weight.text,
//                                     carat: carat,
//                                     size: _sizeController.text,
//                                     showQr: "$showQr",
//                                     qrCode: widget.qrController.text,
//                                   );
//                                   setState(() {
//                                     showManualEpcField = true;
//                                     manualEpcController.clear();
//                                   });
//                                   WidgetsBinding.instance
//                                       .addPostFrameCallback((_) {
//                                     if (mounted) {
//                                       FocusScope.of(context)
//                                           .requestFocus(manualEpcFocus);
//                                     }
//                                   });
//                                 },
//                           icon: widget.isPrinting
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Icon(Icons.print),
//                           label: Text(
//                             widget.isPrinting
//                                 ? "جاري الطباعة..."
//                                 : "طباعة ليبل الذهب",
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: widget.isPrinterConnected
//                                 ? const Color(0xFFD4AF37)
//                                 : Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             textStyle: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 8),

//                       // زرار الإعدادات (مربع صغير)
//                       SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             side: const BorderSide(color: Color(0xFFD4AF37)),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
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
//                   if (showManualEpcField) ...[
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: manualEpcController,
//                       focusNode: manualEpcFocus,
//                       textCapitalization: TextCapitalization.characters,
//                       decoration: const InputDecoration(
//                         labelText: 'أدخل رقم الشريحة',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.nfc),
//                       ),
//                       onSubmitted: (value) {
//                         setState(() {
//                           AddEpcManualy(value);
//                           showManualEpcField = false;
//                         });
//                       },
//                     ),
//                   ],
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFFD4AF37).withOpacity(0.1),
//                           const Color(0xFFB8860B).withOpacity(0.05),
//                         ],
//                       ),
//                       borderRadius:
//                           const BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.epcHex.isNotEmpty) ...[
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'EPC (hex): ${widget.epcHex}',
//                                   style:
//                                       const TextStyle(fontFamily: 'monospace'),
//                                 ),
//                               ),
//                               if (widget.isReadFromChip)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(color: Colors.green),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(Icons.nfc,
//                                           size: 16, color: Colors.green),
//                                       SizedBox(width: 4),
//                                       Text(_t('مقروء', 'Read'),
//                                           style: TextStyle(
//                                               color: Colors.green,
//                                               fontSize: 12)),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                         ],
//                         Row(
//                           children: [
//                             if (widget.epcHex.isNotEmpty) ...[
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: OutlinedButton.icon(
//                                   onPressed: busy ? null : widget.onClearEpc,
//                                   icon: const Icon(Icons.clear),
//                                   label: Text(_t('مسح', 'Clear')),
//                                   style: OutlinedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: (busy ||
//                             widget.epcHex.isEmpty ||
//                             weight.text.isEmpty ||
//                             _sizeController.text.isEmpty ||
//                             wage.text.isEmpty ||
//                             widget.qrController.text.isEmpty ||
//                             selectedImage == null)
//                         ? null
//                         : _saveGold,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: SizedBox(
//                       height: 24, // نفس ارتفاع المحتوى
//                       child: Center(
//                         child: AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 250),
//                           child: busy
//                               ? const SizedBox(
//                                   key: ValueKey('loading'),
//                                   height: 22,
//                                   width: 22,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.5,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : Row(
//                                   key: const ValueKey('normal'),
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Icon(Icons.save),
//                                     const SizedBox(width: 8),
//                                     Text(_t(
//                                         'حفظ إلى التقارير', 'Save to Reports')),
//                                   ],
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GemForm extends StatefulWidget {
//   final String epcHex;
//   final VoidCallback onReadChip;
//   final VoidCallback onClearEpc;
//   final bool isReadFromChip;
//   final bool isReading;
//   final TextEditingController qrController;
//   final bool useScanner;
//   final VoidCallback toggleQRMode;
//   final bool fromOpeningBalance;
//   final bool isPrinterConnected; //الطابعة
//   final bool isPrinting;
//   final Future<void> Function({
//     String? gemType,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//   }) onPrint;
//   const GemForm({
//     super.key,
//     required this.epcHex,
//     required this.onReadChip,
//     required this.onClearEpc,
//     this.isReadFromChip = false,
//     this.isReading = false,
//     required this.qrController,
//     required this.useScanner,
//     required this.toggleQRMode,
//     required this.fromOpeningBalance,
//     required this.isPrinterConnected,
//     required this.isPrinting,
//     required this.onPrint,
//   });
//   @override
//   State<GemForm> createState() => _GemFormState();
// }

// class _GemFormState extends State<GemForm> {
//   DateTime date = DateTime.now();
//   String gemType = 'ماس';
//   final cost = TextEditingController();
//   final notes = TextEditingController();
//   bool busy = false;
//   String? msg;

//   // ✅ متغيرات QR
//   bool showQr = true; // true = QR, false = Barcode
//   CodeDisplayMode _displayMode = CodeDisplayMode.qr;
//   File? selectedImage;
//   bool _pinImage = false; // تثبيت الصورة
//   LabelProfile? _activeProfile; // البروفايل المختار حالياً

//   // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
//   final TextEditingController manualEpcController = TextEditingController();
//   final FocusNode manualEpcFocus = FocusNode();
//   bool showManualEpcField = false;
//   StreamSubscription<String>? _tagSubscription;

//   String _lang = 'ar';
//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   final TextEditingController _note1Controller = TextEditingController();
//   final TextEditingController _note2Controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadActiveProfile();
//     cost.addListener(_onFormChanged);
//     widget.qrController.addListener(_onFormChanged);
//     _loadSettings();
//     _loadLanguage();

//     // ✅ استماع للقارئ داخل GemForm
//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
//       if (!mounted) return;

//       if (tag.length < 24) {
//         setState(() {
//           manualEpcController.text = tag;
//           showManualEpcField = true;
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             FocusScope.of(context).requestFocus(manualEpcFocus);
//           }
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     cost.removeListener(_onFormChanged);
//     widget.qrController.removeListener(_onFormChanged);
//     manualEpcController.dispose();
//     manualEpcFocus.dispose();
//     super.dispose();
//   }

//   void _onFormChanged() {
//     setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
//   }

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('displayMode');
//     if (saved != null) {
//       setState(() {
//         _displayMode = CodeDisplayMode.values.firstWhere(
//           (e) => e.name == saved,
//           orElse: () => CodeDisplayMode.qr,
//         );
//         if (_displayMode == CodeDisplayMode.qr) {
//           showQr = true;
//         } else if (_displayMode == CodeDisplayMode.barcode) {
//           showQr = false;
//         }
//       });
//     }
//   }

//   Future<void> _loadActiveProfile() async {
//     final profile = await LabelProfileStorage.loadActive('gem');
//     if (mounted) setState(() => _activeProfile = profile);
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
//               // Handle
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               // Header
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
//               // القائمة
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
//                         LabelProfileStorage.saveActive(
//                             'gem', p.id); // ← السطر الجديد
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

//   bool useScanner = false;

//   void AddEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//   }

//   Future<void> _saveGem() async {
//     setState(() {
//       busy = true;
//       msg = null;
//     });
//     try {
//       await FS.saveItem(
//         epcHex: widget.epcHex,
//         category: 'gem',
//         date: date,
//         payload: {
//           'type': gemType,
//           'cost': double.tryParse(cost.text) ?? 0,
//           'notes': notes.text.trim(),
//           'qrCode': widget.qrController.text,
//           'showQr': showQr,
//         },
//         fromOpeningBalance: widget.fromOpeningBalance,
//       );
//       // بعد await FS.saveItem(...)
//       if (selectedImage != null) {
//         await _uploadImage();
//       }
//       setState(() {
//         msg = _t('تم الحفظ بنجاح', 'Saved successfully');
//         // Reset form
//         cost.clear();
//         notes.clear();
//         //gemType = 'ماس';
//         date = DateTime.now();
//         widget.onClearEpc?.call();
//         widget.qrController.text = const Uuid().v4().substring(0, 7);
//         // ✅ مسح حقل الشريحة وإخفائه
//         manualEpcController.clear();
//         showManualEpcField = false;

//         if (!_pinImage) {
//           selectedImage = null;
//         }
//       });
//       showAppMessage(context, msg!);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeOut,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         msg = _t('فشل الحفظ', 'Failed to save') + ': $e';
//       });
//       showAppMessage(context, msg!);
//     } finally {
//       setState(() {
//         busy = false;
//       });
//     }
//   }

//   void showAppMessage(BuildContext context, String msg) {
//     final isSuccess = msg.contains('تمت') ||
//         msg.contains('تم') ||
//         msg.contains('written') ||
//         msg.contains('Saved');

//     ScaffoldMessenger.of(context).clearSnackBars();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(msg),
//         ),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   final ScrollController _scrollController = ScrollController();
//   // دالة اختيار الصورة
//   Future<void> _pickImage() async {
//     FocusScope.of(context).unfocus();

//     final picker = ImagePicker();
//     final xFile = await picker.pickImage(source: ImageSource.camera);

//     if (xFile != null) {
//       setState(() {
//         selectedImage = File(xFile.path);
//       });
//     }
//   }

//   // دالة رفع الصورة
//   Future<void> _uploadImage() async {
//     if (selectedImage == null) return;

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       final compressed = await compressImage(selectedImage!);
//       if (compressed == null) {
//         setState(() => msg = '❌ فشل ضغط الصورة');
//         return;
//       }

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(widget.epcHex)
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         cacheControl: 'public,max-age=300',
//       );

//       await storageRef.putFile(compressed, metadata);
//       final url = await storageRef.getDownloadURL();

//       await FS.uploadImage(widget.epcHex, {
//         'images': FieldValue.arrayUnion([url]),
//       });

//       setState(() => msg = '✅ تم رفع الصورة بنجاح');
//     } catch (e) {
//       setState(() => msg = '❌ فشل رفع الصورة: $e');
//     }
//   }

//   bool _showNotes = false;

//   @override
//   Widget build(BuildContext context) {
//     final gemTypes = [
//       'ماس',
//       'زمرد',
//       'ياقوت',
//       'فيروز',
//       'عقيق',
//       'توباز',
//       'لؤلؤ',
//       'أوبال',
//       'عين النمر',
//       'غير ذلك'
//     ];
//     return SingleChildScrollView(
//       controller: _scrollController,
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: gemType,
//                     items: gemTypes
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (v) => setState(() => gemType = v ?? 'ماس'),
//                     decoration: InputDecoration(
//                       labelText: _t('النوع', 'Type'),
//                       prefixIcon:
//                           const Icon(Icons.auto_awesome, color: Colors.purple),
//                       border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: cost,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: _t('التكلفة', 'Cost'),
//                       prefixIcon:
//                           const Icon(Icons.attach_money, color: Colors.purple),
//                       border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('تصوير صورة'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.white,
//                     ),
//                   ),

//                   if (selectedImage != null) ...[
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       height: 200,
//                       child: Image.file(
//                         selectedImage!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _pinImage = !_pinImage;
//                         });
//                       },
//                       icon: Icon(
//                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
//                         color: _pinImage ? Colors.orange : null,
//                       ),
//                       label: Text(
//                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   const SizedBox(height: 10),
//                   // استبدل الـ TextField بالكود ده
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: () => setState(() => _showNotes = !_showNotes),
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 2),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   notes.text.isEmpty
//                                       ? _t('ملاحظات', 'Notes')
//                                       : notes.text,
//                                   style: TextStyle(
//                                     color:
//                                         notes.text.isEmpty ? Colors.grey : null,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Icon(
//                                 _showNotes
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 color: Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (_showNotes) ...[
//                         const SizedBox(height: 8),
//                         TextField(
//                           controller: notes,
//                           maxLines: 3,
//                           autofocus: true,
//                           decoration: InputDecoration(
//                             labelText: _t('ملاحظات', 'Notes'),
//                             prefixIcon: const Icon(Icons.note,
//                                 color: Color(0xFFD4AF37)),
//                             border: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: widget.qrController,
//                     readOnly: true,
//                     focusNode: FocusNode(
//                         canRequestFocus: false), // ✅ منع التركيز على حقل QR
//                     decoration: InputDecoration(
//                       labelText: widget.useScanner
//                           ? _t("QR من الماسح", "QR from Scanner")
//                           : _t("QR عشوائي", "Random QR"),
//                       border: const OutlineInputBorder(),

//                       // الزرار الصغير جنب الحقل
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           widget.useScanner
//                               ? Icons.qr_code_scanner
//                               : Icons.shuffle,
//                         ),
//                         tooltip: widget.useScanner
//                             ? _t("استخدام QR عشوائي", "Use Random QR")
//                             : _t("استخدام الماسح", "Use Scanner"),
//                         onPressed: widget.toggleQRMode,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   TextField(
//                     controller: _note1Controller,
//                     decoration: InputDecoration(
//                       labelText: "اكتب للطباعة 1",
//                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     //keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 24),
//                   TextField(
//                     controller: _note2Controller,
//                     decoration: InputDecoration(
//                       labelText: "اكتب للطباعة 2",
//                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     //keyboardType: TextInputType.number,
//                   ),

//                   const SizedBox(height: 24),
//                   // زر الطباعة قبل زر الحفظ
//                   /*SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: (busy || widget.isPrinting ) ? null : () async {
//                         await widget.onPrint(
//                           gemType: gemType,
//                           note1: _note1Controller.text,
//                           note2: _note2Controller.text,
//                           showQr: "$showQr",
//                           qrCode: widget.qrController.text,
//                         );
//                       },
//                       icon: widget.isPrinting
//                           ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
//                           : const Icon(Icons.print),
//                       label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل الاحجار"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     ),
//                   ),*/
//                   Row(
//                     children: [
//                       // زر الطباعة (ياخد باقي المساحة)
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: (busy || widget.isPrinting)
//                               ? null
//                               : () async {
//                                   if (_activeProfile != null) {
//                                     // احفظه مؤقتاً كـ active layout
//                                     await LabelLayoutStorage.save(
//                                         _activeProfile!.layout);
//                                   }
//                                   await widget.onPrint(
//                                     gemType: gemType,
//                                     note1: _note1Controller.text,
//                                     note2: _note2Controller.text,
//                                     showQr: "$showQr",
//                                     qrCode: widget.qrController.text,
//                                   );
//                                   setState(() {
//                                     showManualEpcField = true;
//                                     manualEpcController.clear();
//                                   });
//                                   WidgetsBinding.instance
//                                       .addPostFrameCallback((_) {
//                                     if (mounted) {
//                                       FocusScope.of(context)
//                                           .requestFocus(manualEpcFocus);
//                                     }
//                                   });
//                                 },
//                           icon: widget.isPrinting
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Icon(Icons.print),
//                           label: Text(widget.isPrinting
//                               ? "جاري الطباعة..."
//                               : "طباعة ليبل الاحجار"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: widget.isPrinterConnected
//                                 ? const Color(0xFFD4AF37)
//                                 : Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             textStyle: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 8),

//                       // زرار الإعدادات (مربع صغير)
//                       SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             side: const BorderSide(color: Color(0xFFD4AF37)),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () => _showProfilePicker('gem'),
//                           child: const Icon(
//                             Icons.settings,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (showManualEpcField) ...[
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: manualEpcController,
//                       focusNode: manualEpcFocus,
//                       textCapitalization: TextCapitalization.characters,
//                       decoration: const InputDecoration(
//                         labelText: 'أدخل رقم الشريحة',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.nfc),
//                       ),
//                       onSubmitted: (value) {
//                         setState(() {
//                           AddEpcManualy(value);
//                           showManualEpcField = false;
//                         });
//                       },
//                     ),
//                   ],
//                   const SizedBox(height: 24),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.purple.withOpacity(0.1),
//                           Colors.deepPurple.withOpacity(0.05),
//                         ],
//                       ),
//                       borderRadius:
//                           const BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.epcHex.isNotEmpty) ...[
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'EPC (hex): ${widget.epcHex}',
//                                   style:
//                                       const TextStyle(fontFamily: 'monospace'),
//                                 ),
//                               ),
//                               if (widget.isReadFromChip)
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: Colors.green.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(color: Colors.green),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Icon(Icons.nfc,
//                                           size: 16, color: Colors.green),
//                                       const SizedBox(width: 4),
//                                       Text(_t('مقروء', 'Read'),
//                                           style: const TextStyle(
//                                               color: Colors.green,
//                                               fontSize: 12)),
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                         ],
//                         Row(
//                           children: [
//                             if (widget.epcHex.isNotEmpty) ...[
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: OutlinedButton.icon(
//                                   onPressed: busy ? null : widget.onClearEpc,
//                                   icon: const Icon(Icons.clear),
//                                   label: Text(_t('مسح', 'Clear')),
//                                   style: OutlinedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: (busy ||
//                               widget.epcHex.isEmpty ||
//                               selectedImage == null ||
//                               cost.text.isEmpty ||
//                               widget.qrController.text.isEmpty)
//                           ? null
//                           : _saveGem,
//                       icon: busy
//                           ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.5,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(Icons.save),
//                       label: busy
//                           ? Text(_t('جاري الحفظ...', 'Saving...'))
//                           : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.purple,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BullionForm extends StatefulWidget {
//   final String epcHex;
//   final VoidCallback onReadChip;
//   final VoidCallback onClearEpc;
//   final bool isReadFromChip;
//   final bool isReading;
//   final TextEditingController qrController;
//   final bool useScanner;
//   final VoidCallback toggleQRMode;
//   final bool fromOpeningBalance;
//   final bool isPrinterConnected; //الطابعة
//   final bool isPrinting;
//   final Stream<String> weightStream;
//   final bool isConnected;
//   final VoidCallback connectToScale;
//   final Future<void> Function({
//     String? weight,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//   }) onPrint;
//   const BullionForm({
//     super.key,
//     required this.epcHex,
//     required this.onReadChip,
//     required this.onClearEpc,
//     this.isReadFromChip = false,
//     this.isReading = false,
//     required this.qrController,
//     required this.useScanner,
//     required this.toggleQRMode,
//     required this.fromOpeningBalance,
//     required this.isPrinterConnected,
//     required this.isPrinting,
//     required this.onPrint,
//     required this.weightStream,
//     required this.isConnected,
//     required this.connectToScale,
//   });

//   @override
//   State<BullionForm> createState() => _BullionFormState();
// }

// class _BullionFormState extends State<BullionForm> {
//   DateTime date = DateTime.now();
//   final weight = TextEditingController();
//   final wage = TextEditingController();
//   final notes = TextEditingController();
//   bool busy = false;
//   String? msg;
//   File? selectedImage;
//   bool _pinImage = false; // تثبيت الصورة
//   LabelProfile? _activeProfile; // البروفايل المختار حالياً

//   // ✅ متغيرات QR
//   bool showQr = true; // true = QR, false = Barcode
//   CodeDisplayMode _displayMode = CodeDisplayMode.qr;

//   // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
//   final TextEditingController manualEpcController = TextEditingController();
//   final FocusNode manualEpcFocus = FocusNode();
//   bool showManualEpcField = false;
//   StreamSubscription<String>? _tagSubscription;

//   String _lang = 'ar';
//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   final TextEditingController _note1Controller = TextEditingController();
//   final TextEditingController _note2Controller = TextEditingController();
//   bool _autoWeightMode = false;

//   StreamSubscription<String>? _weightSub;
//   void _subscribeToWeight() {
//     _weightSub?.cancel();
//     _weightSub = widget.weightStream.listen((value) {
//       if (_autoWeightMode) {
//         final match = RegExp(r'\d+\.?\d*').firstMatch(value);
//         final cleaned = match != null ? match.group(0)! : '';
//         if (cleaned.isNotEmpty) {
//           setState(() => weight.text = cleaned);
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadActiveProfile();
//     weight.addListener(_onFormChanged);
//     wage.addListener(_onFormChanged);
//     widget.qrController.addListener(_onFormChanged);
//     _loadSettings();
//     _loadLanguage();

//     // ✅ استماع للقارئ داخل BullionForm
//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
//       if (!mounted) return;

//       if (tag.length < 24) {
//         setState(() {
//           manualEpcController.text = tag;
//           showManualEpcField = true;
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             FocusScope.of(context).requestFocus(manualEpcFocus);
//           }
//         });
//       }
//     });

//     _subscribeToWeight();
//   }

//   @override
//   void didUpdateWidget(BullionForm oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.weightStream != widget.weightStream) {
//       _subscribeToWeight();
//     }
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     _weightSub?.cancel();
//     weight.removeListener(_onFormChanged);
//     wage.removeListener(_onFormChanged);
//     widget.qrController.removeListener(_onFormChanged);
//     manualEpcController.dispose();
//     manualEpcFocus.dispose();
//     super.dispose();
//   }

//   void _onFormChanged() {
//     setState(() {});
//   }

//   Future<void> _loadActiveProfile() async {
//     final profile = await LabelProfileStorage.loadActive('bullion');
//     if (mounted) setState(() => _activeProfile = profile);
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
//               // Handle
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               // Header
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
//               // القائمة
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
//                         LabelProfileStorage.saveActive(
//                             'bullion', p.id); // ← السطر الجديد
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

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final saved = prefs.getString('displayMode');
//     if (saved != null) {
//       setState(() {
//         _displayMode = CodeDisplayMode.values.firstWhere(
//           (e) => e.name == saved,
//           orElse: () => CodeDisplayMode.qr,
//         );
//         if (_displayMode == CodeDisplayMode.qr) {
//           showQr = true;
//         } else if (_displayMode == CodeDisplayMode.barcode) {
//           showQr = false;
//         }
//       });
//     }
//   }

//   bool useScanner = false;

//   void AddEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//   }

//   Future<void> _saveBullion() async {
//     setState(() {
//       busy = true;
//       msg = null;
//     });
//     try {
//       final w = double.tryParse(weight.text) ?? 0;
//       final wg = double.tryParse(wage.text) ?? 0;
//       await FS.saveItem(
//         epcHex: widget.epcHex,
//         category: 'bullion',
//         date: date,
//         payload: {
//           'weight': w,
//           'wage': w * wg,
//           'notes': notes.text.trim(),
//           'qrCode': widget.qrController.text,
//           'showQr': showQr,
//         },
//         fromOpeningBalance: widget.fromOpeningBalance,
//       );
//       // بعد await FS.saveItem(...)
//       if (selectedImage != null) {
//         await _uploadImage();
//       }
//       setState(() {
//         msg = _t('تم الحفظ بنجاح', 'Saved successfully');
//         weight.clear();
//         wage.clear();
//         notes.clear();
//         date = DateTime.now();
//         widget.qrController.text = const Uuid().v4().substring(0, 7);
//         // ✅ مسح حقل الشريحة وإخفائه
//         manualEpcController.clear();
//         showManualEpcField = false;

//         if (!_pinImage) {
//           selectedImage = null;
//         }
//       });
//       widget.onClearEpc();
//       showAppMessage(context, msg!);
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           0,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeOut,
//         );
//       });
//     } catch (e) {
//       setState(() {
//         msg = _t('فشل الحفظ', 'Failed to save') + ': $e';
//       });
//       showAppMessage(context, msg!);
//     } finally {
//       setState(() {
//         busy = false;
//       });
//     }
//   }

//   void showAppMessage(BuildContext context, String msg) {
//     final isSuccess = msg.contains('تمت') ||
//         msg.contains('تم') ||
//         msg.contains('written') ||
//         msg.contains('Saved');

//     ScaffoldMessenger.of(context).clearSnackBars();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Directionality(
//           textDirection: ui.TextDirection.rtl,
//           child: Text(msg),
//         ),
//         backgroundColor: isSuccess ? Colors.green : Colors.red,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   final ScrollController _scrollController = ScrollController();
//   // دالة اختيار الصورة
//   Future<void> _pickImage() async {
//     FocusScope.of(context).unfocus(); // ⭐ حل المشكلة

//     final picker = ImagePicker();
//     final xFile = await picker.pickImage(source: ImageSource.camera);

//     if (xFile != null) {
//       setState(() {
//         selectedImage = File(xFile.path);
//       });
//     }
//   }

//   // دالة رفع الصورة
//   Future<void> _uploadImage() async {
//     if (selectedImage == null) return;

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       final compressed = await compressImage(selectedImage!);
//       if (compressed == null) {
//         setState(() => msg = '❌ فشل ضغط الصورة');
//         return;
//       }

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(widget.epcHex)
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

//       final metadata = SettableMetadata(
//         contentType: 'image/jpeg',
//         cacheControl: 'public,max-age=300',
//       );

//       await storageRef.putFile(compressed, metadata);
//       final url = await storageRef.getDownloadURL();

//       await FS.uploadImage(widget.epcHex, {
//         'images': FieldValue.arrayUnion([url]),
//       });

//       setState(() => msg = '✅ تم رفع الصورة بنجاح');
//     } catch (e) {
//       setState(() => msg = '❌ فشل رفع الصورة: $e');
//     }
//   }

//   bool _showNotes = false;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.surface,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 16),
//                   /*TextField(
//                     controller: weight,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: _t('الوزن (جم)', 'Weight (g)'),
//                       prefixIcon: const Icon(Icons.scale, color: Color(0xFFD4AF37)),
//                       border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),*/
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextField(
//                         controller: weight,
//                         keyboardType: TextInputType.number,
//                         readOnly: _autoWeightMode,
//                         decoration: InputDecoration(
//                           labelText: _t('الوزن (جم)', 'Weight (g)'),
//                           border: const OutlineInputBorder(
//                             borderRadius: BorderRadius.all(Radius.circular(12)),
//                           ),
//                           // ✅ زرار الاتصال بالميزان على اليسار
//                           prefixIcon: IconButton(
//                             tooltip: _t('اتصال بالميزان', 'Connect Scale'),
//                             icon: Icon(
//                               widget.isConnected
//                                   ? Icons.bluetooth_connected
//                                   : Icons.bluetooth,
//                               color: widget.isConnected
//                                   ? Colors.green
//                                   : Colors.grey,
//                             ),
//                             onPressed: widget.connectToScale,
//                           ),
//                           // ✅ زرار التحويل يدوي/تلقائي على اليمين
//                           suffixIcon: IconButton(
//                             tooltip: _autoWeightMode
//                                 ? _t('تحويل ليدوي', 'Switch to Manual')
//                                 : _t('تحويل لتلقائي', 'Switch to Scale'),
//                             icon: Icon(
//                               _autoWeightMode ? Icons.edit : Icons.scale,
//                               color:
//                                   _autoWeightMode ? Colors.green : Colors.grey,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _autoWeightMode = !_autoWeightMode;
//                                 if (_autoWeightMode) weight.clear();
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       if (_autoWeightMode)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4, right: 4),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 widget.isConnected
//                                     ? Icons.bluetooth_connected
//                                     : Icons.bluetooth_disabled,
//                                 size: 14,
//                                 color: widget.isConnected
//                                     ? Colors.green
//                                     : Colors.red,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 widget.isConnected
//                                     ? _t('في انتظار الميزان...',
//                                         'Waiting for scale...')
//                                     : _t('الميزان غير متصل',
//                                         'Scale not connected'),
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: widget.isConnected
//                                       ? Colors.green
//                                       : Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: wage,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: _t('الأجر', 'Wage'),
//                       prefixIcon: const Icon(Icons.attach_money,
//                           color: Color(0xFFD4AF37)),
//                       border: const OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(12))),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton.icon(
//                     onPressed: _pickImage,
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text('تصوير صورة'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                   if (selectedImage != null) ...[
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       height: 200,
//                       child: Image.file(
//                         selectedImage!,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     OutlinedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _pinImage = !_pinImage;
//                         });
//                       },
//                       icon: Icon(
//                         _pinImage ? Icons.push_pin : Icons.push_pin_outlined,
//                         color: _pinImage ? Colors.orange : null,
//                       ),
//                       label: Text(
//                         _pinImage ? "إلغاء تثبيت الصورة" : "تثبيت الصورة",
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],
//                   const SizedBox(height: 10),
//                   // استبدل الـ TextField بالكود ده
//                   Column(
//                     children: [
//                       InkWell(
//                         onTap: () => setState(() => _showNotes = !_showNotes),
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 2),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   notes.text.isEmpty
//                                       ? _t('ملاحظات', 'Notes')
//                                       : notes.text,
//                                   style: TextStyle(
//                                     color:
//                                         notes.text.isEmpty ? Colors.grey : null,
//                                   ),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Icon(
//                                 _showNotes
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 color: Colors.grey,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (_showNotes) ...[
//                         const SizedBox(height: 8),
//                         TextField(
//                           controller: notes,
//                           maxLines: 3,
//                           autofocus: true,
//                           decoration: InputDecoration(
//                             labelText: _t('ملاحظات', 'Notes'),
//                             prefixIcon: const Icon(Icons.note,
//                                 color: Color(0xFFD4AF37)),
//                             border: const OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: widget.qrController,
//                     readOnly: true,
//                     focusNode: FocusNode(
//                         canRequestFocus: false), // ✅ منع التركيز على حقل QR
//                     decoration: InputDecoration(
//                       labelText: widget.useScanner
//                           ? _t("QR من الماسح", "QR from Scanner")
//                           : _t("QR عشوائي", "Random QR"),
//                       border: const OutlineInputBorder(),

//                       // الزرار الصغير جنب الحقل
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           widget.useScanner
//                               ? Icons.qr_code_scanner
//                               : Icons.shuffle,
//                         ),
//                         tooltip: widget.useScanner
//                             ? _t("استخدام QR عشوائي", "Use Random QR")
//                             : _t("استخدام الماسح", "Use Scanner"),
//                         onPressed: widget.toggleQRMode,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   TextField(
//                     controller: _note1Controller,
//                     decoration: InputDecoration(
//                       labelText: "اكتب للطباعة 1",
//                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     //keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 24),
//                   TextField(
//                     controller: _note2Controller,
//                     decoration: InputDecoration(
//                       labelText: "اكتب للطباعة 2",
//                       prefixIcon: Icon(Icons.photo_size_select_small_sharp,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     //keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 24),
//                   // زر الطباعة قبل زر الحفظ
//                   /*SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: (busy || widget.isPrinting ) ? null : () async {
//                         await widget.onPrint(
//                           weight: weight.text,
//                           note1: _note1Controller.text,
//                           note2: _note2Controller.text,
//                           showQr: "$showQr",
//                           qrCode: widget.qrController.text,
//                         );
//                       },
//                       icon: widget.isPrinting
//                           ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
//                           : const Icon(Icons.print),
//                       label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل السبائك"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     ),
//                   ),*/
//                   Row(
//                     children: [
//                       // زر الطباعة (ياخد باقي المساحة)
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: (busy || widget.isPrinting)
//                               ? null
//                               : () async {
//                                   if (_activeProfile != null) {
//                                     // احفظه مؤقتاً كـ active layout
//                                     await LabelLayoutStorage.save(
//                                         _activeProfile!.layout);
//                                   }
//                                   await widget.onPrint(
//                                     weight: weight.text,
//                                     note1: _note1Controller.text,
//                                     note2: _note2Controller.text,
//                                     showQr: "$showQr",
//                                     qrCode: widget.qrController.text,
//                                   );
//                                   setState(() {
//                                     showManualEpcField = true;
//                                     manualEpcController.clear();
//                                   });
//                                   WidgetsBinding.instance
//                                       .addPostFrameCallback((_) {
//                                     if (mounted) {
//                                       FocusScope.of(context)
//                                           .requestFocus(manualEpcFocus);
//                                     }
//                                   });
//                                 },
//                           icon: widget.isPrinting
//                               ? const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   ),
//                                 )
//                               : const Icon(Icons.print),
//                           label: Text(
//                             widget.isPrinting
//                                 ? "جاري الطباعة..."
//                                 : "طباعة ليبل الذهب",
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: widget.isPrinterConnected
//                                 ? const Color(0xFFD4AF37)
//                                 : Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             textStyle: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(width: 8),

//                       // زرار الإعدادات (مربع صغير)
//                       SizedBox(
//                         width: 50,
//                         height: 50,
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             side: const BorderSide(color: Color(0xFFD4AF37)),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () => _showProfilePicker('bullion'),
//                           child: const Icon(
//                             Icons.settings,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (showManualEpcField) ...[
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: manualEpcController,
//                       focusNode: manualEpcFocus,
//                       textCapitalization: TextCapitalization.characters,
//                       decoration: const InputDecoration(
//                         labelText: 'أدخل رقم الشريحة',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.nfc),
//                       ),
//                       onSubmitted: (value) {
//                         setState(() {
//                           AddEpcManualy(value);
//                           showManualEpcField = false;
//                         });
//                       },
//                     ),
//                   ],
//                   const SizedBox(height: 24),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           const Color(0xFFD4AF37).withOpacity(0.1),
//                           const Color(0xFFB8860B).withOpacity(0.05),
//                         ],
//                       ),
//                       borderRadius:
//                           const BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.epcHex.isNotEmpty) ...[
//                           Text('EPC (hex): ${widget.epcHex}',
//                               style: const TextStyle(fontFamily: 'monospace')),
//                           const SizedBox(height: 8),
//                         ],
//                         Row(
//                           children: [
//                             if (widget.epcHex.isNotEmpty) ...[
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: OutlinedButton.icon(
//                                   onPressed: busy ? null : widget.onClearEpc,
//                                   icon: const Icon(Icons.clear),
//                                   label: Text(_t('مسح', 'Clear')),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: (busy ||
//                               widget.epcHex.isEmpty ||
//                               selectedImage == null ||
//                               weight.text.isEmpty ||
//                               wage.text.isEmpty ||
//                               widget.qrController.text.isEmpty)
//                           ? null
//                           : _saveBullion,
//                       icon: busy
//                           ? const SizedBox(
//                               height: 22,
//                               width: 22,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2.5,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Icon(Icons.save),
//                       label: busy
//                           ? Text(_t('جاري الحفظ...', 'Saving...'))
//                           : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
//import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../services/new_printer_api.dart';
import '../services/new_printer_status.dart';
import '../services/seuic_uhf_service.dart';
import '../services/firestore_service.dart';
import 'package:uuid/uuid.dart';
//import 'package:qr_flutter/qr_flutter.dart';
import '../services/seuic_scanner_service.dart';
//import 'package:barcode_widget/barcode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uhf_gold_shop/pages/settings_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/image_compressor.dart';
import 'dart:ui' as ui;
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'dart:typed_data';
import 'label_layout_model.dart';

class InputPage extends StatefulWidget {
  final bool fromOpeningBalance;
  const InputPage({super.key, required this.fromOpeningBalance});
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String epcHex = '';
  bool isFromScanner = false;
  StreamSubscription<String>? _uhfSubscription;
  String _lang = 'ar'; // 🟢 اللغة الحالية

  final TextEditingController qrController = TextEditingController();
  bool useScanner = false;

  final List<String> typeOptions = [
    'خاتم',
    'اسورة',
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
    'طقم',
    'طقم هافست',
    'غير ذلك'
  ];

  final List<String> setComponentOptions = [
    'خاتم',
    'اسورة',
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
    'غير ذلك'
  ];

  String? selectedGoldType;
  String? selectedScrapType;
  List<String> selectedSetComponents = [];
  bool showSetComponents = false;
  bool showScrapSetComponents = false;

  late final TabController _tab = TabController(length: 3, vsync: this);
  bool isReadFromChip = false;
  bool isReading = false;
  StreamSubscription<String>? _tagSubscription;

  // 🟢 تحميل اللغة من SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  // 🟢 دالة الترجمة المحلية
  String _t(String key, String lang) {
    final map = {
      'ar': {
        'gold': 'ذهب',
        'stones': 'أحجار',
        'ingots': 'سبائك',
        'chipAlreadyExists': '⚠️ هذه الشريحة مسجلة من قبل',
        'noChipFound': 'لم يتم العثور على شريحة - جرب فتح تطبيق UHF',
        'openUHF': 'فتح UHF',
        'chipReadError': 'خطأ في قراءة الشريحة:',
        'chipReadSuccess': 'تم قراءة الشريحة:',
      },
      'en': {
        'gold': 'Gold',
        'stones': 'Stones',
        'ingots': 'Ingots',
        'chipAlreadyExists': '⚠️ This tag is already registered',
        'noChipFound': 'No chip found - try opening the UHF app',
        'openUHF': 'Open UHF',
        'chipReadError': 'Error reading chip:',
        'chipReadSuccess': 'Tag read:',
      },
    };
    return map[lang]?[key] ?? key;
  }

  // نقل حالة الطابعة من printer_page
  bool _isPrinting = false;
  String? _errorMessage;
  String? _successMessage;
  String? _progressMessage;

  // حالة الطابعة
  bool _isPrinterConnected = false;
  String _connectedPrinterName = "غير متصلة";
  String? _connectedPrinterMac;

  StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

  @override
  void initState() {
    super.initState();
    //SeuicUhfService.sendBoolean(false);
    _loadLanguage(); // 🟢 تحميل اللغة أول ما الصفحة تفتح
    //_setPagePower();
    //_loadSavedReaderPower();
    final randomQr = const Uuid().v4().substring(0, 7);
    setState(() {
      qrController.text = randomQr;
    });
    _loadDecimalPlaces();

    SeuicScannerService.scanStream.listen((event) {
      if (useScanner) {
        setState(() {
          qrController.text = event['barcode'] ?? '';
        });
      }
    });

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;

      if (tag.length >= 24) {
        final exists = await FS.checkItemExists(tag.toUpperCase());
        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_t('chipAlreadyExists', _lang)),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          epcHex = tag.toUpperCase();
          isReadFromChip = true;
          isReading = false;
        });
      } else {
        // ✅ سيتم التعامل مع الرقم داخل كل Form على حدة
      }
    });

    SeuicUhfService.open();
    // نقل الاستماع لحالة الطابعة من printer_page
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
            _connectedPrinterMac = match?.group(1); // في الغالب هو الـ MAC
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

  Future<void> _setPagePower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');
    if (powerJson != null) {
      final decoded = json.decode(powerJson);
      final pagePowers = Map<String, int>.from(decoded);
      final pagePower = pagePowers['Input'] ?? 26;
      await SeuicUhfService.setPower(pagePower);
      print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
    }
  }

  @override
  Future<void> dispose() async {
    _tagSubscription?.cancel();
    _printerStatusSubscription?.cancel(); // إلغاء الاستماع لحالة الطابعة
    _weightDataSubscription?.cancel(); // ✅ إلغاء subscription الوزن
    _weightStreamController.close();
    await _bluetoothClassicPlugin.disconnect();
    super.dispose();
    qrController.dispose();
  }

  String _generateRandomQR() {
    return const Uuid().v4().substring(0, 7);
  }

  void _toggleQRMode() {
    setState(() {
      useScanner = !useScanner;
      if (!useScanner) {
        qrController.text = _generateRandomQR();
      } else {
        qrController.clear();
      }
    });
  }

  Future<void> _readChip() async {
    setState(() {
      isReading = true;
    });
    try {
      final result = await SeuicUhfService.inventoryOnce();
      if (result == null || result.isEmpty) {
        setState(() {
          isReading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('noChipFound', _lang)),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: _t('openUHF', _lang),
              textColor: Colors.white,
              onPressed: SeuicUhfService.openUhfApp,
            ),
          ),
        );
      } else {
        final exists = await FS.checkItemExists(result.toUpperCase());
        if (exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_t('chipAlreadyExists', _lang)),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        setState(() {
          epcHex = result.toUpperCase();
          isReadFromChip = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.nfc, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      '${_t('chipReadSuccess', _lang)} ${result.substring(0, result.length > 20 ? 20 : result.length)}...'),
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
      }
    } catch (e) {
      setState(() {
        isReading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_t('chipReadError', _lang)} $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearEpc() {
    setState(() {
      epcHex = '';
      isReadFromChip = false;
    });
  }

  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _progressMessage = null;
    });
  }

  // نقل دالة اختيار والاتصال بالطابعة
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

  // نقل دالة بناء الرسائل
  Widget _buildMessage(String msg, Color color, [bool loading = false]) {
    final isError = color == Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
                  loading
                      ? Icons.print
                      : (color == Colors.green
                          ? Icons.check_circle
                          : Icons.error),
                  color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg.split('. ')[0],
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w600)),
                if (isError && msg.contains('. '))
                  Text(msg.split('. ').skip(1).join('. '),
                      style: TextStyle(color: Colors.red[700], fontSize: 12)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: _clearMessages),
        ],
      ),
    );
  }

  int _readerPower = 26; // القيمة الحالية
  int _tempPower = 26; // قيمة السلايدر المؤقتة
  Future<void> _loadSavedReaderPower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');

    if (powerJson != null) {
      final Map<String, dynamic> pagePowers =
          Map<String, dynamic>.from(json.decode(powerJson));

      final savedPower = pagePowers['Input'];
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

                            pagePowers['Input'] = _readerPower;
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

  final _bluetoothClassicPlugin = BluetoothClassic();
  String buffer = "";
  final _weightStreamController = StreamController<String>.broadcast();
  bool isConnected = false;
  StreamSubscription<Uint8List>?
      _weightDataSubscription; // ✅ حفظ subscription الوزن
  int _decimalPlaces = 2; // ✅ الافتراضي 0.00

// ✅ تحميل الإعداد المحفوظ
  Future<void> _loadDecimalPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _decimalPlaces = prefs.getInt('weightDecimalPlaces') ?? 2;
    });
  }

  Future<void> connectToScale() async {
    // ✅ لو كان في اتصال قديم، قطعه الأول
    if (isConnected) {
      await _weightDataSubscription?.cancel();
      await _bluetoothClassicPlugin.disconnect();
      setState(() {
        isConnected = false;
      });
    }

    await _bluetoothClassicPlugin.initPermissions();
    final devices = await _bluetoothClassicPlugin.getPairedDevices();

    final selected = await showDialog<Device>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("اختر الميزان"),
        content: SizedBox(
          height: 370,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ✅ اختيار عدد الأرقام العشرية
              StatefulBuilder(
                builder: (ctx, setLocalState) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("دقة الوزن: "),
                      ChoiceChip(
                        label: const Text("0.00"),
                        selected: _decimalPlaces == 2,
                        onSelected: (_) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('weightDecimalPlaces', 2);
                          setLocalState(() {});
                          setState(() => _decimalPlaces = 2);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text("0.000"),
                        selected: _decimalPlaces == 3,
                        onSelected: (_) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('weightDecimalPlaces', 3);
                          setLocalState(() {});
                          setState(() => _decimalPlaces = 3);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // ✅ قائمة الأجهزة
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: devices.map((d) {
                    return ListTile(
                      title: Text(d.name ?? "HC-06"),
                      subtitle: Text(d.address),
                      onTap: () => Navigator.pop(ctx, d),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected == null) return;

    await _bluetoothClassicPlugin.connect(
      selected.address,
      "00001101-0000-1000-8000-00805f9b34fb",
    );

    setState(() {
      isConnected = true;
    });

    listenToWeight();
  }

  void listenToWeight() {
    // ✅ إلغاء الـ subscription القديمة قبل ما نعمل جديدة
    _weightDataSubscription?.cancel();
    buffer = ""; // ✅ مسح الـ buffer القديم

    _weightDataSubscription =
        _bluetoothClassicPlugin.onDeviceDataReceived().listen((Uint8List data) {
      final raw = String.fromCharCodes(data);
      print("RAW DATA: $raw"); // ← أضيفي السطر ده
      buffer += String.fromCharCodes(data);

      if (buffer.contains("\n")) {
        String full = buffer.trim();
        buffer = "";

        final match = RegExp(r'\d+\.?\d*').firstMatch(full);
        final rawWeight = match != null ? match.group(0)! : '';

        if (rawWeight.isNotEmpty) {
          // ✅ تطبيق عدد الأرقام العشرية المحدد
          final parsed = double.tryParse(rawWeight);
          final formatted = parsed != null
              ? parsed.toStringAsFixed(_decimalPlaces)
              : rawWeight;

          print("Weight: $formatted");
          if (!_weightStreamController.isClosed) {
            _weightStreamController.add(formatted);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        /*floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFD4AF37),
          tooltip: _t('قوة القارئ', 'Reader Power'),
          onPressed: _showPowerSheet,
          child: const Icon(Icons.tune),
        ),*/
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              // إضافة شريط حالة الطابعة في الأعلى (نقل من printer_page)
              Card(
                color: _isPrinterConnected
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        _isPrinterConnected
                            ? Icons.print
                            : Icons.print_disabled,
                        color: _isPrinterConnected ? Colors.green : Colors.red,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "حالة الطابعة",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            Text(
                              _isPrinterConnected
                                  ? _connectedPrinterName
                                  : "غير متصلة",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isPrinterConnected
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _selectAndConnectPrinter,
                        icon: const Icon(Icons.bluetooth_searching, size: 18),
                        label: Text(_isPrinterConnected ? "متصلة" : "اتصال"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPrinterConnected
                              ? Colors.red
                              : const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await NewPrinterAPI.disconnect();
                        },
                        icon: const Icon(Icons.bluetooth_disabled, size: 18),
                        label: const Text("فصل"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // رسائل الحالة للطابعة
              if (_errorMessage != null)
                _buildMessage(_errorMessage!, Colors.red),
              if (_successMessage != null)
                _buildMessage(_successMessage!, Colors.green),
              if (_progressMessage != null)
                _buildMessage(_progressMessage!, Colors.blue, true),
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(child: Text(_t('gold', _lang))),
                      Tab(child: Text(_t('stones', _lang))),
                      Tab(child: Text(_t('ingots', _lang))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    GoldForm(
                      epcHex: epcHex,
                      onReadChip: _readChip,
                      onClearEpc: _clearEpc,
                      isReadFromChip: isReadFromChip,
                      isReading: isReading,
                      qrController: qrController,
                      useScanner: useScanner,
                      toggleQRMode: _toggleQRMode,
                      fromOpeningBalance: widget.fromOpeningBalance,
                      onPrint: _printGoldLabel, // نقل دالة الطباعة
                      isPrinterConnected: _isPrinterConnected,
                      isPrinting: _isPrinting,
                      weightStream: _weightStreamController.stream,
                      isConnected: isConnected,
                      connectToScale: connectToScale,
                    ),
                    GemForm(
                      epcHex: epcHex,
                      onReadChip: _readChip,
                      onClearEpc: _clearEpc,
                      isReadFromChip: isReadFromChip,
                      isReading: isReading,
                      qrController: qrController,
                      useScanner: useScanner,
                      toggleQRMode: _toggleQRMode,
                      fromOpeningBalance: widget.fromOpeningBalance,
                      onPrint:
                          _printGemLabel, // دالة طباعة مخصصة للأحجار (يمكن تخصيصها)
                      isPrinterConnected: _isPrinterConnected,
                      isPrinting: _isPrinting,
                    ),
                    BullionForm(
                      epcHex: epcHex,
                      onReadChip: _readChip,
                      onClearEpc: _clearEpc,
                      isReadFromChip: isReadFromChip,
                      isReading: isReading,
                      qrController: qrController,
                      useScanner: useScanner,
                      toggleQRMode: _toggleQRMode,
                      fromOpeningBalance: widget.fromOpeningBalance,
                      onPrint:
                          _printBullionLabel, // دالة طباعة مخصصة للسبائك (يمكن تخصيصها)
                      isPrinterConnected: _isPrinterConnected,
                      isPrinting: _isPrinting,
                      weightStream: _weightStreamController.stream,
                      isConnected: isConnected,
                      connectToScale: connectToScale,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // نقل دالة الطباعة للذهب (يمكن تخصيص للأخرى)
  Future<void> _printGoldLabel({
    String? weight,
    String? carat,
    String? size,
    required String showQr,
    required String qrCode,
  }) async {
    _clearMessages();

    setState(() => _isPrinting = true);

    try {
      final layout = await LabelLayoutStorage.load('gold');
      final prefs = await SharedPreferences.getInstance();
      final String? logoBase64 = prefs.getString('custom_logo_base64');

      final success = await NewPrinterAPI.printGoldLabel(
        //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
        weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
        carat: carat?.trim().isEmpty ?? true ? null : carat?.trim(),
        size: size?.trim().isEmpty ?? true ? null : size?.trim(),
        showQr: showQr.trim(),
        qrCode: qrCode.trim(),
        customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
        labelLayout: layout.toJson(),
      );

      if (!success) {
        //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
        );
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> _printBullionLabel({
    String? weight,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
  }) async {
    _clearMessages();

    setState(() => _isPrinting = true);

    try {
      // ← أهم سطر في حياتك دلوقتي
      final layout = await LabelLayoutStorage.load('bullion');
      final prefs = await SharedPreferences.getInstance();
      final String? logoBase64 = prefs.getString('custom_logo_base64');

      final success = await NewPrinterAPI.printBullionLabel(
        //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
        weight: weight?.trim().isEmpty ?? true ? null : weight?.trim(),
        note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
        note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
        showQr: showQr.trim(),
        qrCode: qrCode.trim(),
        customLogoBase64: logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin
        labelLayout: layout.toJson(),
      );

      if (!success) {
        //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
        );
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> _printGemLabel({
    String? gemType,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
  }) async {
    _clearMessages();

    setState(() => _isPrinting = true);

    try {
      // ← أهم سطر في حياتك دلوقتي
      final layout = await LabelLayoutStorage.load('gem');
      final prefs = await SharedPreferences.getInstance();
      final String? logoBase64 = prefs.getString('custom_logo_base64');

      final success = await NewPrinterAPI.printGemLabel(
        //qrCode: qrCode?.trim().isEmpty ?? true ? null : qrCode?.trim(),
        gemType: gemType?.trim().isEmpty ?? true ? null : gemType?.trim(),
        note1: note1?.trim().isEmpty ?? true ? null : note1?.trim(),
        note2: note2?.trim().isEmpty ?? true ? null : note2?.trim(),
        showQr: showQr.trim(),
        qrCode: qrCode.trim(),
        customLogoBase64:
            logoBase64, // ← هنا بتبعت اللوجو لـ Kotlin        labelLayout: layout.toJson(),
      );

      if (!success) {
        //setState(() => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تمت الطباعة بنجاح مع اللوجو!")),
        );
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      setState(() => _isPrinting = false);
    }
  }
}

class GoldForm extends StatefulWidget {
  final String epcHex;
  final VoidCallback onReadChip;
  final VoidCallback onClearEpc;
  final bool isReadFromChip;
  final bool isReading;
  final TextEditingController qrController;
  final bool useScanner;
  final VoidCallback toggleQRMode;
  final bool fromOpeningBalance;
  final bool isPrinterConnected; //الطابعة
  final bool isPrinting;
  final Stream<String> weightStream;
  final bool isConnected;
  final VoidCallback connectToScale;
  final Future<void> Function({
    String? weight,
    String? carat,
    String? size,
    required String showQr,
    required String qrCode,
  }) onPrint;
  const GoldForm({
    super.key,
    required this.epcHex,
    required this.onReadChip,
    required this.onClearEpc,
    this.isReadFromChip = false,
    this.isReading = false,
    required this.qrController,
    required this.useScanner,
    required this.toggleQRMode,
    required this.fromOpeningBalance,
    required this.isPrinterConnected,
    required this.isPrinting,
    required this.weightStream,
    required this.isConnected,
    required this.connectToScale,
    required this.onPrint,
  });

  @override
  State<GoldForm> createState() => _GoldFormState();
}

class _GoldFormState extends State<GoldForm> {
  DateTime date = DateTime.now();
  String carat = '21';
  final weight = TextEditingController();
  final wage = TextEditingController();
  //final kind = TextEditingController();
  final notes = TextEditingController();
  bool busy = false;
  String? msg;

  String? selectedGoldType = 'خاتم';
  bool showSetComponents = false;
  List<String> selectedSetComponents = [];
  File? selectedImage;
  bool _pinImage = false; // تثبيت الصورة
  bool _autoWeightMode = false; // false = يدوي، true = من الميزان
  StreamSubscription<String>? _weightSub;
  LabelProfile? _activeProfile; // البروفايل المختار حالياً

  final List<String> typeOptions = [
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
    'طقم',
    'طقم هافست',
    'غير ذلك'
  ];

  List<String> get setComponentOptions => typeOptions
      .where(
        (type) => type != 'طقم' && type != 'طقم هافست',
      )
      .toList();
  // ✅ متغيرات QR
  bool showQr = true; // true = QR, false = Barcode
  CodeDisplayMode _displayMode = CodeDisplayMode.qr;
  String _lang = 'ar';
  final TextEditingController _sizeController = TextEditingController();

  // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
  final TextEditingController manualEpcController = TextEditingController();
  final FocusNode manualEpcFocus = FocusNode();
  bool showManualEpcField = false;
  StreamSubscription<String>? _tagSubscription;

  // ✅ متغير لتحديد وضع الماسح
  bool _isPrimaryScanner =
      false; // false = مساعد (يظهر الحقل)، true = أساسي (يخفي الحقل)

  void _subscribeToWeight() {
    _weightSub?.cancel();
    _weightSub = widget.weightStream.listen((value) {
      if (_autoWeightMode) {
        final match = RegExp(r'\d+\.?\d*').firstMatch(value);
        final cleaned = match != null ? match.group(0)! : '';
        if (cleaned.isNotEmpty) {
          setState(() => weight.text = cleaned);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _loadLanguage();
    _loadActiveProfile();
    _loadScannerMode(); // ✅ تحميل وضع الماسح
    weight.addListener(_onFormChanged);
    wage.addListener(_onFormChanged);
    widget.qrController.addListener(_onFormChanged);
    _sizeController.text = "0";
    _loadSettings();

    // ✅ استماع للقارئ داخل GoldForm
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (!mounted) return;

      // ✅ نتعامل مع الأرقام القصيرة (QR) فقط، والأرقام الطويلة (EPC) تتعامل معها الصفحة الأم
      if (tag.length < 24) {
        setState(() {
          manualEpcController.text = tag;
          showManualEpcField = true;
        });

        // ✅ نطلب التركيز يفضل في حقل الشريحة
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(manualEpcFocus);
          }
        });
      }
    });

    _subscribeToWeight();
  }

  // ✅ تحميل وضع الماسح من الإعدادات
  Future<void> _loadScannerMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('scannerMode');
    // القيمة الافتراضية هي false (مساعد) إذا لم يتم العثور على إعداد
    setState(() {
      _isPrimaryScanner = mode == 'primary';
    });
  }

  @override
  void didUpdateWidget(GoldForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightStream != widget.weightStream) {
      _subscribeToWeight();
    }
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    _weightSub?.cancel();
    weight.removeListener(_onFormChanged);
    wage.removeListener(_onFormChanged);
    widget.qrController.removeListener(_onFormChanged);
    manualEpcController.dispose();
    manualEpcFocus.dispose();
    super.dispose();
  }

  Future<void> _loadActiveProfile() async {
    final profile = await LabelProfileStorage.loadActive('gold');
    if (mounted) setState(() => _activeProfile = profile);
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
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
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
              // القائمة
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
                        LabelProfileStorage.saveActive(
                            'gold', p.id); // ← السطر الجديد
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

  void _onFormChanged() {
    setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('displayMode');
    if (saved != null) {
      setState(() {
        _displayMode = CodeDisplayMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => CodeDisplayMode.qr,
        );
        if (_displayMode == CodeDisplayMode.qr) {
          showQr = true;
        } else if (_displayMode == CodeDisplayMode.barcode) {
          showQr = false;
        }
      });
    }
  }

  // 🟢 تحميل اللغة من SharedPreferences
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  bool useScanner = false;
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

  void AddEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
  }

  Future<void> _saveGold() async {
    setState(() {
      busy = true;
      msg = null;
    });
    try {
      final w = double.tryParse(weight.text) ?? 0;
      final wg = double.tryParse(wage.text) ?? 0;
      await FS.saveItem(
        epcHex: widget.epcHex,
        category: 'gold',
        date: date,
        payload: {
          'carat': carat,
          'size': _sizeController.text,
          'weight': w,
          'wage': w * wg,
          'kind': selectedGoldType, // ✅ احفظ من الدروب داون
          if (selectedGoldType == 'طقم' || selectedGoldType == 'طقم هافست')
            'setComponents': selectedSetComponents,
          'notes': notes.text.trim(),
          'qrCode': widget.qrController.text,
          'showQr': showQr,
        },
        fromOpeningBalance: widget.fromOpeningBalance,
      );
      // بعد await FS.saveItem(...)
      if (selectedImage != null) {
        await _uploadImage();
      }
      setState(() {
        msg = _t('تم الحفظ بنجاح', 'Saved successfully');

        // Reset form fields
        weight.clear();
        wage.clear();
        //selectedGoldType = 'خاتم';
        selectedSetComponents.clear();
        showSetComponents = false;
        notes.clear();
        //carat = '21';
        date = DateTime.now();
        // امسح الشريحة بعد الحفظ
        widget.onClearEpc.call();
        widget.qrController.text = const Uuid().v4().substring(0, 7);
        // ✅ مسح حقل الشريحة وإخفائه
        manualEpcController.clear();
        showManualEpcField = false;

        if (!_pinImage) {
          selectedImage = null;
        }
      });
      showAppMessage(context, msg!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        msg = '${_t('فشل الحفظ', 'Failed to save')}: $e';
      });
      showAppMessage(context, msg!);
    } finally {
      setState(() {
        busy = false;
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  // دالة اختيار الصورة
  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);

    if (xFile != null) {
      setState(() {
        selectedImage = File(xFile.path);
      });
    }
  }

  // دالة رفع الصورة
  Future<void> _uploadImage() async {
    if (selectedImage == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compressed = await compressImage(selectedImage!);
      if (compressed == null) {
        setState(() => msg = '❌ فشل ضغط الصورة');
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(widget.epcHex)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=300',
      );

      await storageRef.putFile(compressed, metadata);
      final url = await storageRef.getDownloadURL();

      await FS.uploadImage(widget.epcHex, {
        'images': FieldValue.arrayUnion([url]),
      });

      setState(() => msg = '✅ تم رفع الصورة بنجاح');
    } catch (e) {
      setState(() => msg = '❌ فشل رفع الصورة: $e');
    }
  }

  bool _showNotes = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: carat,
                    items: const ['18', '21', '22']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => carat = v ?? '21'),
                    decoration: InputDecoration(
                      labelText: _t('العيار', 'Carat'),
                      prefixIcon: Icon(Icons.grade, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  /*TextField(
                    controller: weight,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                      labelText: _t('الوزن (جم)', 'Weight (g)'),

                      prefixIcon: Icon(Icons.scale, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: weight,
                        keyboardType: TextInputType.number,
                        readOnly: _autoWeightMode,
                        decoration: InputDecoration(
                          labelText: _t('الوزن (جم)', 'Weight (g)'),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          // ✅ زرار الاتصال بالميزان على اليسار
                          prefixIcon: IconButton(
                            tooltip: _t('اتصال بالميزان', 'Connect Scale'),
                            icon: Icon(
                              widget.isConnected
                                  ? Icons.bluetooth_connected
                                  : Icons.bluetooth,
                              color: widget.isConnected
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: widget.connectToScale,
                          ),
                          // ✅ زرار التحويل يدوي/تلقائي على اليمين
                          suffixIcon: IconButton(
                            tooltip: _autoWeightMode
                                ? _t('تحويل ليدوي', 'Switch to Manual')
                                : _t('تحويل لتلقائي', 'Switch to Scale'),
                            icon: Icon(
                              _autoWeightMode ? Icons.edit : Icons.scale,
                              color:
                                  _autoWeightMode ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _autoWeightMode = !_autoWeightMode;
                                if (_autoWeightMode) weight.clear();
                              });
                            },
                          ),
                        ),
                      ),
                      if (_autoWeightMode)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: Row(
                            children: [
                              Icon(
                                widget.isConnected
                                    ? Icons.bluetooth_connected
                                    : Icons.bluetooth_disabled,
                                size: 14,
                                color: widget.isConnected
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.isConnected
                                    ? _t('في انتظار الميزان...',
                                        'Waiting for scale...')
                                    : _t('الميزان غير متصل',
                                        'Scale not connected'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.isConnected
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: wage,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('الأجر', 'Wage'),
                      prefixIcon:
                          Icon(Icons.attach_money, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedGoldType,
                    decoration: InputDecoration(
                      labelText: _t('النوع', 'Type'),
                      prefixIcon:
                          Icon(Icons.category, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    items: typeOptions.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGoldType = newValue;
                        showSetComponents =
                            newValue == 'طقم' || newValue == 'طقم هافست';

                        if (!showSetComponents) {
                          selectedSetComponents.clear();
                        }
                      });
                    },
                  ),
                  if (showSetComponents) ...[
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _t('مكونات الطقم', 'Set Components'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: setComponentOptions.map((component) {
                              final isSelected =
                                  selectedSetComponents.contains(component);
                              return FilterChip(
                                label: Text(component),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSetComponents.add(component);
                                    } else {
                                      selectedSetComponents.remove(component);
                                    }
                                  });
                                },
                                selectedColor:
                                    const Color(0xFFD4AF37).withOpacity(0.3),
                                checkmarkColor: const Color(0xFFD4AF37),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: _sizeController,
                    decoration: InputDecoration(
                      labelText: "المقاس",
                      prefixIcon: Icon(Icons.photo_size_select_small_sharp,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('تصوير صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (selectedImage != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
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
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 10),
                  // استبدل الـ TextField بالكود ده
                  Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _showNotes = !_showNotes),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.note, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  notes.text.isEmpty
                                      ? _t('ملاحظات', 'Notes')
                                      : notes.text,
                                  style: TextStyle(
                                    color:
                                        notes.text.isEmpty ? Colors.grey : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _showNotes
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showNotes) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: notes,
                          maxLines: 3,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: _t('ملاحظات', 'Notes'),
                            prefixIcon: const Icon(Icons.note,
                                color: Color(0xFFD4AF37)),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: widget.qrController,
                    readOnly: true,
                    focusNode: FocusNode(
                        canRequestFocus: false), // ✅ منع التركيز على حقل QR
                    decoration: InputDecoration(
                      labelText: widget.useScanner
                          ? _t("QR من الماسح", "QR from Scanner")
                          : _t("QR عشوائي", "Random QR"),
                      border: const OutlineInputBorder(),

                      // الزرار الصغير جنب الحقل
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget.useScanner
                              ? Icons.qr_code_scanner
                              : Icons.shuffle,
                        ),
                        tooltip: widget.useScanner
                            ? _t("استخدام QR عشوائي", "Use Random QR")
                            : _t("استخدام الماسح", "Use Scanner"),
                        onPressed: widget.toggleQRMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      // زر الطباعة (ياخد باقي المساحة)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (busy || widget.isPrinting)
                              ? null
                              : () async {
                                  if (_activeProfile != null) {
                                    // احفظه مؤقتاً كـ active layout
                                    await LabelLayoutStorage.save(
                                        _activeProfile!.layout);
                                  }
                                  await widget.onPrint(
                                    weight: weight.text,
                                    carat: carat,
                                    size: _sizeController.text,
                                    showQr: "$showQr",
                                    qrCode: widget.qrController.text,
                                  );
                                  setState(() {
                                    showManualEpcField = true;
                                    manualEpcController.clear();
                                  });
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      FocusScope.of(context)
                                          .requestFocus(manualEpcFocus);
                                    }
                                  });
                                },
                          icon: widget.isPrinting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.print),
                          label: Text(
                            widget.isPrinting
                                ? "جاري الطباعة..."
                                : "طباعة ليبل الذهب",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isPrinterConnected
                                ? const Color(0xFFD4AF37)
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // زرار الإعدادات (مربع صغير)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                  // ✅ إظهار حقل إدخال الشريحة فقط إذا كان الماسح مساعداً
                  if (!_isPrimaryScanner && showManualEpcField) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: manualEpcController,
                      focusNode: manualEpcFocus,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'أدخل رقم الشريحة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.nfc),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          AddEpcManualy(value);
                          showManualEpcField = false;
                        });
                      },
                    ),
                  ],
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD4AF37).withOpacity(0.1),
                          const Color(0xFFB8860B).withOpacity(0.05),
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.epcHex.isNotEmpty) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'EPC (hex): ${widget.epcHex}',
                                  style:
                                      const TextStyle(fontFamily: 'monospace'),
                                ),
                              ),
                              if (widget.isReadFromChip)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.nfc,
                                          size: 16, color: Colors.green),
                                      SizedBox(width: 4),
                                      Text(_t('مقروء', 'Read'),
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            if (widget.epcHex.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: busy ? null : widget.onClearEpc,
                                  icon: const Icon(Icons.clear),
                                  label: Text(_t('مسح', 'Clear')),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (busy ||
                            widget.epcHex.isEmpty ||
                            weight.text.isEmpty ||
                            _sizeController.text.isEmpty ||
                            wage.text.isEmpty ||
                            widget.qrController.text.isEmpty ||
                            selectedImage == null)
                        ? null
                        : _saveGold,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: SizedBox(
                      height: 24, // نفس ارتفاع المحتوى
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: busy
                              ? const SizedBox(
                                  key: ValueKey('loading'),
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  key: const ValueKey('normal'),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.save),
                                    const SizedBox(width: 8),
                                    Text(_t(
                                        'حفظ إلى التقارير', 'Save to Reports')),
                                  ],
                                ),
                        ),
                      ),
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
}

class GemForm extends StatefulWidget {
  final String epcHex;
  final VoidCallback onReadChip;
  final VoidCallback onClearEpc;
  final bool isReadFromChip;
  final bool isReading;
  final TextEditingController qrController;
  final bool useScanner;
  final VoidCallback toggleQRMode;
  final bool fromOpeningBalance;
  final bool isPrinterConnected; //الطابعة
  final bool isPrinting;
  final Future<void> Function({
    String? gemType,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
  }) onPrint;
  const GemForm({
    super.key,
    required this.epcHex,
    required this.onReadChip,
    required this.onClearEpc,
    this.isReadFromChip = false,
    this.isReading = false,
    required this.qrController,
    required this.useScanner,
    required this.toggleQRMode,
    required this.fromOpeningBalance,
    required this.isPrinterConnected,
    required this.isPrinting,
    required this.onPrint,
  });
  @override
  State<GemForm> createState() => _GemFormState();
}

class _GemFormState extends State<GemForm> {
  DateTime date = DateTime.now();
  String gemType = 'ماس';
  final cost = TextEditingController();
  final notes = TextEditingController();
  bool busy = false;
  String? msg;

  // ✅ متغيرات QR
  bool showQr = true; // true = QR, false = Barcode
  CodeDisplayMode _displayMode = CodeDisplayMode.qr;
  File? selectedImage;
  bool _pinImage = false; // تثبيت الصورة
  LabelProfile? _activeProfile; // البروفايل المختار حالياً

  // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
  final TextEditingController manualEpcController = TextEditingController();
  final FocusNode manualEpcFocus = FocusNode();
  bool showManualEpcField = false;
  StreamSubscription<String>? _tagSubscription;

  // ✅ متغير لتحديد وضع الماسح
  bool _isPrimaryScanner =
      false; // false = مساعد (يظهر الحقل)، true = أساسي (يخفي الحقل)

  String _lang = 'ar';
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  final TextEditingController _note1Controller = TextEditingController();
  final TextEditingController _note2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadActiveProfile();
    _loadScannerMode(); // ✅ تحميل وضع الماسح
    cost.addListener(_onFormChanged);
    widget.qrController.addListener(_onFormChanged);
    _loadSettings();
    _loadLanguage();

    // ✅ استماع للقارئ داخل GemForm
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (!mounted) return;

      if (tag.length < 24) {
        setState(() {
          manualEpcController.text = tag;
          showManualEpcField = true;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(manualEpcFocus);
          }
        });
      }
    });
  }

  // ✅ تحميل وضع الماسح من الإعدادات
  Future<void> _loadScannerMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('scannerMode');
    // القيمة الافتراضية هي false (مساعد) إذا لم يتم العثور على إعداد
    setState(() {
      _isPrimaryScanner = mode == 'primary';
    });
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    cost.removeListener(_onFormChanged);
    widget.qrController.removeListener(_onFormChanged);
    manualEpcController.dispose();
    manualEpcFocus.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {}); // أي تغيير يخلي الزرار يتبني من جديد
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('displayMode');
    if (saved != null) {
      setState(() {
        _displayMode = CodeDisplayMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => CodeDisplayMode.qr,
        );
        if (_displayMode == CodeDisplayMode.qr) {
          showQr = true;
        } else if (_displayMode == CodeDisplayMode.barcode) {
          showQr = false;
        }
      });
    }
  }

  Future<void> _loadActiveProfile() async {
    final profile = await LabelProfileStorage.loadActive('gem');
    if (mounted) setState(() => _activeProfile = profile);
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
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
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
              // القائمة
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
                        LabelProfileStorage.saveActive(
                            'gem', p.id); // ← السطر الجديد
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

  bool useScanner = false;

  void AddEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
  }

  Future<void> _saveGem() async {
    setState(() {
      busy = true;
      msg = null;
    });
    try {
      await FS.saveItem(
        epcHex: widget.epcHex,
        category: 'gem',
        date: date,
        payload: {
          'type': gemType,
          'cost': double.tryParse(cost.text) ?? 0,
          'notes': notes.text.trim(),
          'qrCode': widget.qrController.text,
          'showQr': showQr,
        },
        fromOpeningBalance: widget.fromOpeningBalance,
      );
      // بعد await FS.saveItem(...)
      if (selectedImage != null) {
        await _uploadImage();
      }
      setState(() {
        msg = _t('تم الحفظ بنجاح', 'Saved successfully');
        // Reset form
        cost.clear();
        notes.clear();
        //gemType = 'ماس';
        date = DateTime.now();
        widget.onClearEpc.call();
        widget.qrController.text = const Uuid().v4().substring(0, 7);
        // ✅ مسح حقل الشريحة وإخفائه
        manualEpcController.clear();
        showManualEpcField = false;

        if (!_pinImage) {
          selectedImage = null;
        }
      });
      showAppMessage(context, msg!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        msg = '${_t('فشل الحفظ', 'Failed to save')}: $e';
      });
      showAppMessage(context, msg!);
    } finally {
      setState(() {
        busy = false;
      });
    }
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
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  // دالة اختيار الصورة
  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);

    if (xFile != null) {
      setState(() {
        selectedImage = File(xFile.path);
      });
    }
  }

  // دالة رفع الصورة
  Future<void> _uploadImage() async {
    if (selectedImage == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compressed = await compressImage(selectedImage!);
      if (compressed == null) {
        setState(() => msg = '❌ فشل ضغط الصورة');
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(widget.epcHex)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=300',
      );

      await storageRef.putFile(compressed, metadata);
      final url = await storageRef.getDownloadURL();

      await FS.uploadImage(widget.epcHex, {
        'images': FieldValue.arrayUnion([url]),
      });

      setState(() => msg = '✅ تم رفع الصورة بنجاح');
    } catch (e) {
      setState(() => msg = '❌ فشل رفع الصورة: $e');
    }
  }

  bool _showNotes = false;

  @override
  Widget build(BuildContext context) {
    final gemTypes = [
      'ماس',
      'زمرد',
      'ياقوت',
      'فيروز',
      'عقيق',
      'توباز',
      'لؤلؤ',
      'أوبال',
      'عين النمر',
      'غير ذلك'
    ];
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: gemType,
                    items: gemTypes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => gemType = v ?? 'ماس'),
                    decoration: InputDecoration(
                      labelText: _t('النوع', 'Type'),
                      prefixIcon:
                          const Icon(Icons.auto_awesome, color: Colors.purple),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cost,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('التكلفة', 'Cost'),
                      prefixIcon:
                          const Icon(Icons.attach_money, color: Colors.purple),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('تصوير صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                    ),
                  ),

                  if (selectedImage != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
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
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 10),
                  // استبدل الـ TextField بالكود ده
                  Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _showNotes = !_showNotes),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.note, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  notes.text.isEmpty
                                      ? _t('ملاحظات', 'Notes')
                                      : notes.text,
                                  style: TextStyle(
                                    color:
                                        notes.text.isEmpty ? Colors.grey : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _showNotes
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showNotes) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: notes,
                          maxLines: 3,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: _t('ملاحظات', 'Notes'),
                            prefixIcon: const Icon(Icons.note,
                                color: Color(0xFFD4AF37)),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: widget.qrController,
                    readOnly: true,
                    focusNode: FocusNode(
                        canRequestFocus: false), // ✅ منع التركيز على حقل QR
                    decoration: InputDecoration(
                      labelText: widget.useScanner
                          ? _t("QR من الماسح", "QR from Scanner")
                          : _t("QR عشوائي", "Random QR"),
                      border: const OutlineInputBorder(),

                      // الزرار الصغير جنب الحقل
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget.useScanner
                              ? Icons.qr_code_scanner
                              : Icons.shuffle,
                        ),
                        tooltip: widget.useScanner
                            ? _t("استخدام QR عشوائي", "Use Random QR")
                            : _t("استخدام الماسح", "Use Scanner"),
                        onPressed: widget.toggleQRMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _note1Controller,
                    decoration: InputDecoration(
                      labelText: "اكتب للطباعة 1",
                      prefixIcon: Icon(Icons.photo_size_select_small_sharp,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    //keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _note2Controller,
                    decoration: InputDecoration(
                      labelText: "اكتب للطباعة 2",
                      prefixIcon: Icon(Icons.photo_size_select_small_sharp,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    //keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 24),
                  // زر الطباعة قبل زر الحفظ
                  /*SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (busy || widget.isPrinting ) ? null : () async {
                        await widget.onPrint(
                          gemType: gemType,
                          note1: _note1Controller.text,
                          note2: _note2Controller.text,
                          showQr: "$showQr",
                          qrCode: widget.qrController.text,
                        );
                      },
                      icon: widget.isPrinting
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Icon(Icons.print),
                      label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل الاحجار"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),*/
                  Row(
                    children: [
                      // زر الطباعة (ياخد باقي المساحة)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (busy || widget.isPrinting)
                              ? null
                              : () async {
                                  if (_activeProfile != null) {
                                    // احفظه مؤقتاً كـ active layout
                                    await LabelLayoutStorage.save(
                                        _activeProfile!.layout);
                                  }
                                  await widget.onPrint(
                                    gemType: gemType,
                                    note1: _note1Controller.text,
                                    note2: _note2Controller.text,
                                    showQr: "$showQr",
                                    qrCode: widget.qrController.text,
                                  );
                                  setState(() {
                                    showManualEpcField = true;
                                    manualEpcController.clear();
                                  });
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      FocusScope.of(context)
                                          .requestFocus(manualEpcFocus);
                                    }
                                  });
                                },
                          icon: widget.isPrinting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.print),
                          label: Text(widget.isPrinting
                              ? "جاري الطباعة..."
                              : "طباعة ليبل الاحجار"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isPrinterConnected
                                ? const Color(0xFFD4AF37)
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // زرار الإعدادات (مربع صغير)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showProfilePicker('gem'),
                          child: const Icon(
                            Icons.settings,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ✅ إظهار حقل إدخال الشريحة فقط إذا كان الماسح مساعداً
                  if (!_isPrimaryScanner && showManualEpcField) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: manualEpcController,
                      focusNode: manualEpcFocus,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'أدخل رقم الشريحة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.nfc),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          AddEpcManualy(value);
                          showManualEpcField = false;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.1),
                          Colors.deepPurple.withOpacity(0.05),
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.epcHex.isNotEmpty) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'EPC (hex): ${widget.epcHex}',
                                  style:
                                      const TextStyle(fontFamily: 'monospace'),
                                ),
                              ),
                              if (widget.isReadFromChip)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.nfc,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(_t('مقروء', 'Read'),
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            if (widget.epcHex.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: busy ? null : widget.onClearEpc,
                                  icon: const Icon(Icons.clear),
                                  label: Text(_t('مسح', 'Clear')),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (busy ||
                              widget.epcHex.isEmpty ||
                              selectedImage == null ||
                              cost.text.isEmpty ||
                              widget.qrController.text.isEmpty)
                          ? null
                          : _saveGem,
                      icon: busy
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: busy
                          ? Text(_t('جاري الحفظ...', 'Saving...'))
                          : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
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
}

class BullionForm extends StatefulWidget {
  final String epcHex;
  final VoidCallback onReadChip;
  final VoidCallback onClearEpc;
  final bool isReadFromChip;
  final bool isReading;
  final TextEditingController qrController;
  final bool useScanner;
  final VoidCallback toggleQRMode;
  final bool fromOpeningBalance;
  final bool isPrinterConnected; //الطابعة
  final bool isPrinting;
  final Stream<String> weightStream;
  final bool isConnected;
  final VoidCallback connectToScale;
  final Future<void> Function({
    String? weight,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
  }) onPrint;
  const BullionForm({
    super.key,
    required this.epcHex,
    required this.onReadChip,
    required this.onClearEpc,
    this.isReadFromChip = false,
    this.isReading = false,
    required this.qrController,
    required this.useScanner,
    required this.toggleQRMode,
    required this.fromOpeningBalance,
    required this.isPrinterConnected,
    required this.isPrinting,
    required this.onPrint,
    required this.weightStream,
    required this.isConnected,
    required this.connectToScale,
  });

  @override
  State<BullionForm> createState() => _BullionFormState();
}

class _BullionFormState extends State<BullionForm> {
  DateTime date = DateTime.now();
  final weight = TextEditingController();
  final wage = TextEditingController();
  final notes = TextEditingController();
  bool busy = false;
  String? msg;
  File? selectedImage;
  bool _pinImage = false; // تثبيت الصورة
  LabelProfile? _activeProfile; // البروفايل المختار حالياً

  // ✅ متغيرات QR
  bool showQr = true; // true = QR, false = Barcode
  CodeDisplayMode _displayMode = CodeDisplayMode.qr;

  // ✅ متغيرات حقل الشريحة اليدوي والاستماع للقارئ
  final TextEditingController manualEpcController = TextEditingController();
  final FocusNode manualEpcFocus = FocusNode();
  bool showManualEpcField = false;
  StreamSubscription<String>? _tagSubscription;

  // ✅ متغير لتحديد وضع الماسح
  bool _isPrimaryScanner =
      false; // false = مساعد (يظهر الحقل)، true = أساسي (يخفي الحقل)

  String _lang = 'ar';
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  final TextEditingController _note1Controller = TextEditingController();
  final TextEditingController _note2Controller = TextEditingController();
  bool _autoWeightMode = false;

  StreamSubscription<String>? _weightSub;
  void _subscribeToWeight() {
    _weightSub?.cancel();
    _weightSub = widget.weightStream.listen((value) {
      if (_autoWeightMode) {
        final match = RegExp(r'\d+\.?\d*').firstMatch(value);
        final cleaned = match != null ? match.group(0)! : '';
        if (cleaned.isNotEmpty) {
          setState(() => weight.text = cleaned);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadActiveProfile();
    _loadScannerMode(); // ✅ تحميل وضع الماسح
    weight.addListener(_onFormChanged);
    wage.addListener(_onFormChanged);
    widget.qrController.addListener(_onFormChanged);
    _loadSettings();
    _loadLanguage();

    // ✅ استماع للقارئ داخل BullionForm
    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (!mounted) return;

      if (tag.length < 24) {
        setState(() {
          manualEpcController.text = tag;
          showManualEpcField = true;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(manualEpcFocus);
          }
        });
      }
    });

    _subscribeToWeight();
  }

  // ✅ تحميل وضع الماسح من الإعدادات
  Future<void> _loadScannerMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('scannerMode');
    // القيمة الافتراضية هي false (مساعد) إذا لم يتم العثور على إعداد
    setState(() {
      _isPrimaryScanner = mode == 'primary';
    });
  }

  @override
  void didUpdateWidget(BullionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weightStream != widget.weightStream) {
      _subscribeToWeight();
    }
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    _weightSub?.cancel();
    weight.removeListener(_onFormChanged);
    wage.removeListener(_onFormChanged);
    widget.qrController.removeListener(_onFormChanged);
    manualEpcController.dispose();
    manualEpcFocus.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  Future<void> _loadActiveProfile() async {
    final profile = await LabelProfileStorage.loadActive('bullion');
    if (mounted) setState(() => _activeProfile = profile);
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
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
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
              // القائمة
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
                        LabelProfileStorage.saveActive(
                            'bullion', p.id); // ← السطر الجديد
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

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('displayMode');
    if (saved != null) {
      setState(() {
        _displayMode = CodeDisplayMode.values.firstWhere(
          (e) => e.name == saved,
          orElse: () => CodeDisplayMode.qr,
        );
        if (_displayMode == CodeDisplayMode.qr) {
          showQr = true;
        } else if (_displayMode == CodeDisplayMode.barcode) {
          showQr = false;
        }
      });
    }
  }

  bool useScanner = false;

  void AddEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
  }

  Future<void> _saveBullion() async {
    setState(() {
      busy = true;
      msg = null;
    });
    try {
      final w = double.tryParse(weight.text) ?? 0;
      final wg = double.tryParse(wage.text) ?? 0;
      await FS.saveItem(
        epcHex: widget.epcHex,
        category: 'bullion',
        date: date,
        payload: {
          'weight': w,
          'wage': w * wg,
          'notes': notes.text.trim(),
          'qrCode': widget.qrController.text,
          'showQr': showQr,
        },
        fromOpeningBalance: widget.fromOpeningBalance,
      );
      // بعد await FS.saveItem(...)
      if (selectedImage != null) {
        await _uploadImage();
      }
      setState(() {
        msg = _t('تم الحفظ بنجاح', 'Saved successfully');
        weight.clear();
        wage.clear();
        notes.clear();
        date = DateTime.now();
        widget.qrController.text = const Uuid().v4().substring(0, 7);
        // ✅ مسح حقل الشريحة وإخفائه
        manualEpcController.clear();
        showManualEpcField = false;

        if (!_pinImage) {
          selectedImage = null;
        }
      });
      widget.onClearEpc();
      showAppMessage(context, msg!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        msg = '${_t('فشل الحفظ', 'Failed to save')}: $e';
      });
      showAppMessage(context, msg!);
    } finally {
      setState(() {
        busy = false;
      });
    }
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
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  // دالة اختيار الصورة
  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus(); // ⭐ حل المشكلة

    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.camera);

    if (xFile != null) {
      setState(() {
        selectedImage = File(xFile.path);
      });
    }
  }

  // دالة رفع الصورة
  Future<void> _uploadImage() async {
    if (selectedImage == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compressed = await compressImage(selectedImage!);
      if (compressed == null) {
        setState(() => msg = '❌ فشل ضغط الصورة');
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(widget.epcHex)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=300',
      );

      await storageRef.putFile(compressed, metadata);
      final url = await storageRef.getDownloadURL();

      await FS.uploadImage(widget.epcHex, {
        'images': FieldValue.arrayUnion([url]),
      });

      setState(() => msg = '✅ تم رفع الصورة بنجاح');
    } catch (e) {
      setState(() => msg = '❌ فشل رفع الصورة: $e');
    }
  }

  bool _showNotes = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  /*TextField(
                    controller: weight,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('الوزن (جم)', 'Weight (g)'),
                      prefixIcon: const Icon(Icons.scale, color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: weight,
                        keyboardType: TextInputType.number,
                        readOnly: _autoWeightMode,
                        decoration: InputDecoration(
                          labelText: _t('الوزن (جم)', 'Weight (g)'),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          // ✅ زرار الاتصال بالميزان على اليسار
                          prefixIcon: IconButton(
                            tooltip: _t('اتصال بالميزان', 'Connect Scale'),
                            icon: Icon(
                              widget.isConnected
                                  ? Icons.bluetooth_connected
                                  : Icons.bluetooth,
                              color: widget.isConnected
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: widget.connectToScale,
                          ),
                          // ✅ زرار التحويل يدوي/تلقائي على اليمين
                          suffixIcon: IconButton(
                            tooltip: _autoWeightMode
                                ? _t('تحويل ليدوي', 'Switch to Manual')
                                : _t('تحويل لتلقائي', 'Switch to Scale'),
                            icon: Icon(
                              _autoWeightMode ? Icons.edit : Icons.scale,
                              color:
                                  _autoWeightMode ? Colors.green : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _autoWeightMode = !_autoWeightMode;
                                if (_autoWeightMode) weight.clear();
                              });
                            },
                          ),
                        ),
                      ),
                      if (_autoWeightMode)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 4),
                          child: Row(
                            children: [
                              Icon(
                                widget.isConnected
                                    ? Icons.bluetooth_connected
                                    : Icons.bluetooth_disabled,
                                size: 14,
                                color: widget.isConnected
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.isConnected
                                    ? _t('في انتظار الميزان...',
                                        'Waiting for scale...')
                                    : _t('الميزان غير متصل',
                                        'Scale not connected'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: widget.isConnected
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: wage,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: _t('الأجر', 'Wage'),
                      prefixIcon: const Icon(Icons.attach_money,
                          color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('تصوير صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (selectedImage != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
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
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 10),
                  // استبدل الـ TextField بالكود ده
                  Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _showNotes = !_showNotes),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.note, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  notes.text.isEmpty
                                      ? _t('ملاحظات', 'Notes')
                                      : notes.text,
                                  style: TextStyle(
                                    color:
                                        notes.text.isEmpty ? Colors.grey : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _showNotes
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showNotes) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: notes,
                          maxLines: 3,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: _t('ملاحظات', 'Notes'),
                            prefixIcon: const Icon(Icons.note,
                                color: Color(0xFFD4AF37)),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: widget.qrController,
                    readOnly: true,
                    focusNode: FocusNode(
                        canRequestFocus: false), // ✅ منع التركيز على حقل QR
                    decoration: InputDecoration(
                      labelText: widget.useScanner
                          ? _t("QR من الماسح", "QR from Scanner")
                          : _t("QR عشوائي", "Random QR"),
                      border: const OutlineInputBorder(),

                      // الزرار الصغير جنب الحقل
                      suffixIcon: IconButton(
                        icon: Icon(
                          widget.useScanner
                              ? Icons.qr_code_scanner
                              : Icons.shuffle,
                        ),
                        tooltip: widget.useScanner
                            ? _t("استخدام QR عشوائي", "Use Random QR")
                            : _t("استخدام الماسح", "Use Scanner"),
                        onPressed: widget.toggleQRMode,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _note1Controller,
                    decoration: InputDecoration(
                      labelText: "اكتب للطباعة 1",
                      prefixIcon: Icon(Icons.photo_size_select_small_sharp,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    //keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _note2Controller,
                    decoration: InputDecoration(
                      labelText: "اكتب للطباعة 2",
                      prefixIcon: Icon(Icons.photo_size_select_small_sharp,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    //keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  // زر الطباعة قبل زر الحفظ
                  /*SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (busy || widget.isPrinting ) ? null : () async {
                        await widget.onPrint(
                          weight: weight.text,
                          note1: _note1Controller.text,
                          note2: _note2Controller.text,
                          showQr: "$showQr",
                          qrCode: widget.qrController.text,
                        );
                      },
                      icon: widget.isPrinting
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Icon(Icons.print),
                      label: Text(widget.isPrinting ? "جاري الطباعة..." : "طباعة ليبل السبائك"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isPrinterConnected ? const Color(0xFFD4AF37) : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),*/
                  Row(
                    children: [
                      // زر الطباعة (ياخد باقي المساحة)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (busy || widget.isPrinting)
                              ? null
                              : () async {
                                  if (_activeProfile != null) {
                                    // احفظه مؤقتاً كـ active layout
                                    await LabelLayoutStorage.save(
                                        _activeProfile!.layout);
                                  }
                                  await widget.onPrint(
                                    weight: weight.text,
                                    note1: _note1Controller.text,
                                    note2: _note2Controller.text,
                                    showQr: "$showQr",
                                    qrCode: widget.qrController.text,
                                  );
                                  setState(() {
                                    showManualEpcField = true;
                                    manualEpcController.clear();
                                  });
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      FocusScope.of(context)
                                          .requestFocus(manualEpcFocus);
                                    }
                                  });
                                },
                          icon: widget.isPrinting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.print),
                          label: Text(
                            widget.isPrinting
                                ? "جاري الطباعة..."
                                : "طباعة ليبل الذهب",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.isPrinterConnected
                                ? const Color(0xFFD4AF37)
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // زرار الإعدادات (مربع صغير)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: const BorderSide(color: Color(0xFFD4AF37)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showProfilePicker('bullion'),
                          child: const Icon(
                            Icons.settings,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ✅ إظهار حقل إدخال الشريحة فقط إذا كان الماسح مساعداً
                  if (!_isPrimaryScanner && showManualEpcField) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: manualEpcController,
                      focusNode: manualEpcFocus,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'أدخل رقم الشريحة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.nfc),
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          AddEpcManualy(value);
                          showManualEpcField = false;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFD4AF37).withOpacity(0.1),
                          const Color(0xFFB8860B).withOpacity(0.05),
                        ],
                      ),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.epcHex.isNotEmpty) ...[
                          Text('EPC (hex): ${widget.epcHex}',
                              style: const TextStyle(fontFamily: 'monospace')),
                          const SizedBox(height: 8),
                        ],
                        Row(
                          children: [
                            if (widget.epcHex.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: busy ? null : widget.onClearEpc,
                                  icon: const Icon(Icons.clear),
                                  label: Text(_t('مسح', 'Clear')),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (busy ||
                              widget.epcHex.isEmpty ||
                              selectedImage == null ||
                              weight.text.isEmpty ||
                              wage.text.isEmpty ||
                              widget.qrController.text.isEmpty)
                          ? null
                          : _saveBullion,
                      icon: busy
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: busy
                          ? Text(_t('جاري الحفظ...', 'Saving...'))
                          : Text(_t('حفظ إلى التقارير', 'Save to Reports')),
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
}
