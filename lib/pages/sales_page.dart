// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';
// import '../services/seuic_uhf_service.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'sales_history_page.dart';

// class SalesPage extends StatefulWidget {
//   const SalesPage({super.key});

//   @override
//   State<SalesPage> createState() => _SalesPageState();
// }

// class _SalesPageState extends State<SalesPage> {
//   StreamSubscription<String>? _tagSubscription;
//   List<String> epcs = [];
//   Map<String, dynamic> itemsData = {};
//   bool isReading = false;
//   bool busy = false;
//   String? msg;

//   // 🔹 أسماء المستخدمين
//   List<String> userNames = [];
//   String? selectedUser;

//   // 🔹 متغيرات الدفع
//   Map<String, String?> paymentTypes = {};
//   Map<String, TextEditingController> cashControllers = {};
//   Map<String, TextEditingController> visaControllers = {};
//   Map<String, double> totals = {};

//   // وضع البيع: 'كامل' او 'جزئي' لكل epc
//   Map<String, String> saleMode = {};

//   double totalCash = 0;
//   double totalVisa = 0;
//   double grandTotal = 0;

//   // Global (batch) payment controllers for multiple-item sales
//   TextEditingController globalCashController = TextEditingController();
//   TextEditingController globalVisaController = TextEditingController();
//   String? globalPaymentType;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   int _readerPower = 26; // القيمة الحالية
//   int _tempPower = 26;  // قيمة السلايدر المؤقتة

//   @override
//   void initState() {
//     super.initState();

//     //SeuicUhfService.sendBoolean(false);
//     _loadLanguage();
//     //_setPagePower();
//     //_initUhfAndSetPower();
//     //_loadSavedReaderPower();
//     _loadUserNames();

//     _tagSubscription = SeuicUhfService.tagStream.listen((tag)async {
//       final epc = tag;

//       final result = await FS.epcandcode(epc);

//       if (!epcs.contains(epc) && !epcs.contains(result?['epcHex'] )&& !epcs.contains(result?['qrCode'] )) {
//         setState(() {

//           epcs.add(epc);
//           paymentTypes[epc] = null;
//           cashControllers[epc] = TextEditingController();
//           visaControllers[epc] = TextEditingController();
//           totals[epc] = 0;
//           saleMode[epc] = 'كامل';
//         });
//         _loadItemData(epc);
//       }
//       //_addEpc(tag);

//     });
//     SeuicUhfService.open();
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
//   Future<void> _loadSavedReaderPower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');

//     if (powerJson != null) {
//       final Map<String, dynamic> pagePowers =
//       Map<String, dynamic>.from(json.decode(powerJson));

//       final savedPower = pagePowers['sales'];
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
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 16),

//                   Text(
//                     '${_tempPower} dBm',
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
//                               pagePowers = Map<String, int>.from(json.decode(powerJson));
//                             }

//                             pagePowers['sales'] = _readerPower;
//                             await prefs.setString('pagePowers', json.encode(pagePowers));

//                             Navigator.pop(context);

//                             /*_showMsg(
//                               _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'),
//                               true,
//                             );*/
//                             showAppMessage(context, _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'));
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
//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadUserNames() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userNames = prefs.getStringList('userNames') ?? [];
//       if (userNames.isNotEmpty) selectedUser = userNames.first;
//     });
//   }
//   /*Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['sales'] ?? 26; // استبدل 'sales' حسب الصفحة
//       await SeuicUhfService.setPower(pagePower);
//       print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//     }
//   }*/
//   Future<void> _initUhfAndSetPower() async {
//     try {
//       // أولاً: افتح الـ UHF وانتظر
//       final opened = await SeuicUhfService.open();
//       if (!opened) {
//         print('⚠️ فشل في فتح UHF، محاولة مرة ثانية...');
//         await Future.delayed(const Duration(seconds: 1));  // تأخير صغير
//         await SeuicUhfService.open();  // retry
//       }

//       // ثانيًا: حمّل وضبط القوة (بعد الفتح)
//       await _setPagePower();
//     } catch (e) {
//       print('❌ خطأ في تهيئة UHF: $e');
//     }
//   }

//   Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['sales'] ?? 26;

//       // استدعي setPower وشيك النتيجة
//       final success = await SeuicUhfService.setPower(pagePower);
//       if (success) {
//         print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//       } else {
//         print('⚠️ فشل في ضبط القوة، محاولة عبر fallback...');
//         // لو عايز، أضف fallback هنا في Flutter، لكن أفضل في Android
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     for (final c in cashControllers.values) {
//       c.dispose();
//     }
//     for (final c in visaControllers.values) {
//       c.dispose();
//     }
//     globalCashController.dispose();
//     globalVisaController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadItemData(String epc) async {
//     try {
//       final data = await FS.findItemByEpc(epc);
//       setState(() {
//         itemsData[epc] = data;
//         // لو العنصر طقم وخانة saleMode مش معمولة مسبقًا
//         if (data != null) {
//           final payload = data['payload'] ?? {};
//           final kind = (payload['kind'] ?? '').toString();
//           if (kind.contains('طقم') || kind.contains('طقم'.trim())) {
//             saleMode[epc] = saleMode[epc] ?? 'كامل';
//           } else {
//             saleMode[epc] = 'كامل';
//           }
//         }
//       });
//     } catch (e) {
//       setState(() {
//         itemsData[epc] = {"error": e.toString()};
//       });
//     }
//   }

//   void _calculateTotal(String epc) {
//     double cash = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//     double visa = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;
//     setState(() {
//       totals[epc] = cash + visa;
//       totalCash = cashControllers.values.fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values.fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });
//   }

//   Future<void> _sell() async {
//     if (epcs.isEmpty) {
//       setState(() => msg = _t("من فضلك اقرأ شريحة واحدة على الأقل", "Please read at least one chip"));
//       return;
//     }

//     if (selectedUser == null || selectedUser!.isEmpty) {
//       setState(() => msg = _t("يرجى اضافة اسم المستخدم من الاعدادات وحفظ الاعدادات حتى تتمكن من البيع", "Please add a username from settings and save settings before proceeding"));
//       return;
//     }

//     // ✅ الخطوة 1: تحقق من جميع البيانات أولاً قبل البدء بالبيع
//     for (final epc in List<String>.from(epcs)) {
//       /*// 🔹 تحقق أولاً إن الشريحة موجودة في قاعدة البيانات
//       final exists = await FS.findItemByEpc(epc);
//       if (exists == null || exists == false) {
//         setState(() {
//           msg = _t(
//               "⚠ الشريحة $epc غير موجودة في قاعدة البيانات، تم تجاهلها.",
//               "⚠ The tag $epc was not found in the database and has been ignored."
//           );
//           epcs.remove(epc);
//           paymentTypes.remove(epc);
//           cashControllers.remove(epc);
//           visaControllers.remove(epc);
//           totals.remove(epc);
//           saleMode.remove(epc);
//           itemsData.remove(epc);
//         });
//         continue; // ✅ تخطى هذه الشريحة ولا توقف العملية
//       }*/

//       // 🔹 تحقق من اختيار طريقة الدفع
//       if (paymentTypes[epc] == null) {
//         setState(() {
//           msg = _t(
//               "⚠ اختر طريقة الدفع للشريحة $epc أولاً",
//               "⚠ Please select the payment method for tag $epc first"
//           );
//         });
//         return; // ❌ توقف العملية بالكامل
//       }
//       final paymentType = paymentTypes[epc];
//       final cashVal = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//       final visaVal = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;

//       if (paymentType == "cash" && cashVal <= 0) {
//         setState(() {
//           msg = _t(
//               "⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//               "⚠ Enter the correct cash amount for tag $epc."
//           );

//         });
//         return;
//       }

//       if (paymentType == "visa" && visaVal <= 0) {
//         setState(() {
//           msg = _t(
//               "⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//               "⚠ Enter the correct card amount for tag $epc."
//           );
//         });
//         return;
//       }

//       if (paymentType == "multi") {
//         if (cashVal <= 0) {
//           setState(() {
//             msg = _t(
//                 "⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct cash amount for tag $epc."
//             );
//           });
//           return;
//         }

//         if (visaVal <= 0) {
//           setState(() {
//             msg = _t(
//                 "⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct card amount for tag $epc."
//             );
//           });
//           return;
//         }

//       }

//       // 🔹 تحقق من البيع الجزئي إن وجد
//       if (saleMode[epc] == 'جزئي') {
//         final item = itemsData[epc];
//         if (item == null) {
//           setState(() {
//             msg = _t(
//                 "خطأ: بيانات الشريحة $epc غير متاحة.",
//                 "Error: Data for tag $epc is not available."
//             );
//           });
//           return; // ❌ توقف العملية بالكامل
//         }

//         final partialResult = item['_pendingPartial'];
//         if (partialResult == null) {
//           setState(() {
//             msg = _t(
//                 "⚠ من فضلك اضغط 'فتح البيع الجزئي' وأدخل التفاصيل قبل تسجيل البيع.",
//                 "⚠ Please press 'Open Partial Sale' and enter the details before recording the sale."
//             );
//           });
//           return; // ❌ توقف العملية بالكامل
//         }

//         final weightSold = (partialResult['weightSold'] ?? 0).toDouble();
//         if (weightSold <= 0) {
//           setState(() {
//             msg = _t(
//                 "⚠ أدخل وزن صحيح في البيع الجزئي للشريحة $epc.",
//                 "⚠ Enter a valid weight in the partial sale for tag $epc."
//             );

//           });
//           return; // ❌ توقف العملية بالكامل
//         }
//       }
//     }

//     // ✅ لو وصلنا هنا فكل البيانات سليمة نبدأ البيع فعليًا
//     setState(() {
//       busy = true;
//       msg = null;
//     });

//     final saleGroupId = DateTime.now().millisecondsSinceEpoch.toString();
//     final hasSetItem = epcs.any((epc) {
//       final item = itemsData[epc];
//       final payload = item != null ? Map<String, dynamic>.from(item['payload'] ?? {}) : {};
//       return (payload['kind'] ?? '').toString().contains('طقم');
//     });
//     if (hasSetItem) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             _t(
//               'تنبيه: يوجد طقم في البيع، تأكد من اختيار حالة البيع جزئي أو كامل لكل قطعة قبل التأكيد.',
//               'Note: a set item is included in the sale. Make sure to choose partial or full sale for each item before confirming.',
//             ),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }

//     try {
//       for (final epc in List<String>.from(epcs)) {
//         final paymentData = {
//           "type": paymentTypes[epc],
//           "cash": double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0,
//           "visa": double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0,
//           "total": totals[epc] ?? 0,
//           "soldBy": selectedUser,
//         };

//         if (saleMode[epc] == 'جزئي') {
//           final item = itemsData[epc];
//           final partialResult = item['_pendingPartial'];

//           final soldCompsRaw = partialResult['soldComponents'];
//           final soldComps = soldCompsRaw is List
//               ? soldCompsRaw.map((e) => e.toString()).toList()
//               : <String>[];

//           await FS.sellItem(
//             epc,
//             saleGroupId: saleGroupId,
//             partialSale: true,
//             soldComponents: soldComps,
//             weightSold: (partialResult['weightSold'] ?? 0).toDouble(),
//             wageSold: (partialResult['wageSold'] ?? 0).toDouble(),
//             paymentData: paymentData,
//           );

//           // حذف بيانات الجزئي بعد البيع
//           setState(() {
//             itemsData[epc].remove('_pendingPartial');
//           });

//           await _loadItemData(epc);

//           final updated = itemsData[epc];
//           final updatedPayload = updated != null ? (updated['payload'] ?? {}) : {};
//           final updatedWeight = (updatedPayload['weight'] ?? 0).toString();
//           final hasComponents = (updatedPayload['setComponents'] ?? []).isNotEmpty;
//           final weightZero = double.tryParse(updatedWeight.toString()) == 0;

//           if (!hasComponents || weightZero) {
//             setState(() {
//               epcs.remove(epc);
//               itemsData.remove(epc);
//               paymentTypes.remove(epc);
//               cashControllers.remove(epc);
//               visaControllers.remove(epc);
//               totals.remove(epc);
//               saleMode.remove(epc);
//             });
//           }
//         } else {
//           // 🔹 حذف الصور فقط في حالة البيع الكامل
//           await _deleteItemImages(epc);
//           // البيع الكامل
//           await FS.sellItem(epc, saleGroupId: saleGroupId, paymentData: paymentData);
//           setState(() {
//             epcs.remove(epc);
//             itemsData.remove(epc);
//             paymentTypes.remove(epc);
//             cashControllers.remove(epc);
//             visaControllers.remove(epc);
//             totals.remove(epc);
//             saleMode.remove(epc);
//           });
//         }
//       }

//       setState(() {
//         msg = _t(
//             "✅ تم تنفيذ جميع عمليات البيع بنجاح بواسطة $selectedUser.",
//             "✅ All sales were successfully completed by $selectedUser."
//         );

//         // 🔹 حساب الإجماليات النهائية فقط للعرض المؤقت
//         totalCash = cashControllers.values.fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         totalVisa = visaControllers.values.fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         grandTotal = totalCash + totalVisa;
//       });

// // 🔹 انتظر لحظة قصيرة قبل التهيئة (علشان تظهر رسالة النجاح)
//       await Future.delayed(const Duration(seconds: 1));

// // ✅ إعادة ضبط كل القيم إلى حالتها الأساسية
//       setState(() {
//         epcs.clear();
//         itemsData.clear();
//         paymentTypes.clear();
//         for (final c in cashControllers.values) {
//           c.dispose();
//         }
//         for (final c in visaControllers.values) {
//           c.dispose();
//         }
//         cashControllers.clear();
//         visaControllers.clear();
//         totals.clear();
//         saleMode.clear();
//         totalCash = 0;
//         totalVisa = 0;
//         grandTotal = 0;
//       });

//     } catch (e) {
//       setState(() => msg = _t(
//           "فشل تسجيل البيع: $e",
//           "Failed to record sale: $e"
//       ));

//     } finally {
//       if (!mounted) return;
//       setState(() => busy = false);
//     }
//   }
//   /*Future<void> _deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       // المسار الكامل للفولدر الخاص بالشريحة
//       final folderRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epc.toUpperCase());

//       // جلب قائمة كل الملفات داخل الفولدر
//       final ListResult result = await folderRef.listAll();

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $epc (الفولدر فاضي)');
//         // نحذف الحقل من Firestore برضو عشان النظافة
//         //await _clearImagesFieldFromFirestore(epc);
//         return;
//       }

//       print('🗑️ بدء حذف ${result.items.length} صورة للشريحة $epc');

//       // حذف كل صورة
//       for (Reference ref in result.items) {
//         try {
//           await ref.delete();
//           print('✅ تم حذف: ${ref.name}');
//         } catch (e) {
//           print('❌ فشل حذف ملف: ${ref.name} | $e');
//         }
//       }

//       // بعد الحذف، نحذف حقل images من Firestore
//       //await _clearImagesFieldFromFirestore(epc);

//       print('✅ تم حذف الفولدر بأكمله وحقل الصور من Firestore لـ $epc');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//       // ما نوقفش عملية البيع بسبب الصور
//     }
//   }*/
//   Future<void> _deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       // الفولدر الأصلي
//       final sourceFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epc.toUpperCase());

//       // فولدر المبيعات
//       final salesFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child('sales')
//           .child(epc.toUpperCase());

//       final ListResult result = await sourceFolder.listAll();

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $epc');
//         return;
//       }

//       print('📦 نسخ ${result.items.length} صورة إلى مجلد المبيعات');

//       for (Reference sourceRef in result.items) {
//         try {
//           // تحميل الصورة
//           final Uint8List? bytes = await sourceRef.getData();

//           if (bytes == null) {
//             print('❌ لم يتم تحميل ${sourceRef.name}');
//             continue;
//           }

//           // إنشاء الملف الجديد بنفس الاسم
//           final destRef = salesFolder.child(sourceRef.name);

//           // نسخ الصورة
//           await destRef.putData(bytes);

//           print('✅ تم نسخ ${sourceRef.name}');

//           // حذف الأصل بعد نجاح النسخ
//           await sourceRef.delete();

//           print('🗑️ تم حذف ${sourceRef.name}');
//         } catch (e) {
//           print('❌ خطأ مع ${sourceRef.name}: $e');
//         }
//       }

//       print('✅ انتهت عملية النسخ والحذف');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//     }
//   }

//   // يوزع المبلغ الكلي على جميع القطع حسب (الوزن * العيار) أو بالتساوي كبديل
//   void _applyGlobalDistribution() {
//     if (epcs.isEmpty) return;
//     if (globalPaymentType == null) {
//       showAppMessage(context, _t('اختر طريقة دفع مجمّعة', 'Please select batch payment type'));
//       return;
//     }

//     final totalCashGlobal = double.tryParse(globalCashController.text) ?? 0;
//     final totalVisaGlobal = double.tryParse(globalVisaController.text) ?? 0;

//     if (totalCashGlobal <= 0 && totalVisaGlobal <= 0) {
//       showAppMessage(context, _t('أدخل مبلغ كاش أو شبكة صحيح', 'Enter a valid cash or card total'));
//       return;
//     }

//     final Map<String, double> factors = {};
//     double sumFactors = 0;

//     for (final epc in epcs) {
//       final payload = itemsData[epc]?['payload'] ?? {};

//       double weight = 0;
//       if (saleMode[epc] == 'جزئي' && itemsData[epc]?['_pendingPartial'] != null) {
//         weight = double.tryParse(itemsData[epc]!['_pendingPartial']['weightSold']?.toString() ?? '0') ?? 0;
//       } else {
//         weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//       }

//       double carat = double.tryParse((payload['carat'] ?? 0).toString()) ?? 0;
//       double factor = weight * (carat > 0 ? carat : 1);
//       if (factor <= 0) factor = 1;
//       factors[epc] = factor;
//       sumFactors += factor;
//     }

//     if (sumFactors <= 0) sumFactors = epcs.length.toDouble();

//     for (final epc in epcs) {
//       final factor = factors[epc] ?? 1;
//       final cashShare = totalCashGlobal * factor / sumFactors;
//       final visaShare = totalVisaGlobal * factor / sumFactors;

//       setState(() {
//         paymentTypes[epc] = globalPaymentType;
//         cashControllers[epc]?.text = cashShare.toStringAsFixed(2);
//         visaControllers[epc]?.text = visaShare.toStringAsFixed(2);
//         _calculateTotal(epc);
//       });
//     }

//     setState(() {
//       totalCash = cashControllers.values.fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values.fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });

//     showAppMessage(context, _t('تم تطبيق الدفع المجمّع على كل القطع', 'Batch payment applied to all items'));
//   }

//   // دالة مساعدة لحذف حقل images من Firestore فقط
//   /*Future<void> _clearImagesFieldFromFirestore(String epc) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('items')
//           .doc(epc)
//           .update({
//         'images': FieldValue.delete(),
//       });
//     } catch (e) {
//       print('⚠️ فشل حذف حقل images من Firestore لـ $epc: $e');
//     }
//   }*/

//   // Dialog لبيع جزئي: اختيار مكونات + ادخال weight و wage
//   // يعيد Map مع المفاتيح: soldComponents(List<String>), weightSold(double), wageSold(double) أو null لو ألغي
//   Future<Map<String, dynamic>?> _openPartialSaleDialog(String epc, Map<String, dynamic> itemData) async {
//     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
//     final List<dynamic> setComponentsDynamic = payload['setComponents'] ?? [];
//     final List<String> components = setComponentsDynamic.map((c) => c.toString()).toList();
//     double computedWage = 0;

//     // حالة اختيار المكونات
//     final Map<String, bool> selected = {for (var c in components) c: false};
//     final weightController = TextEditingController();
//     final wageController = TextEditingController();

//     return showDialog<Map<String, dynamic>>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         return StatefulBuilder(builder: (context, setStateDialog) {
//           return AlertDialog(
//             title: Text(_t("تفاصيل البيع الجزئي", "Partial Sale Details")),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (components.isEmpty)
//                     Text(_t("لا توجد مكونات في الطقم لعمل بيع جزئي.", "No components in the set for partial sale."))
//                   else
//                     Column(
//                       children: [
//                          Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _t("اختر المكونات التي سيتم بيعها:", "Select components to sell:"),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),

//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 150,
//                           width: double.maxFinite,
//                           child: ListView.builder(
//                             itemCount: components.length,
//                             itemBuilder: (_, i) {
//                               final comp = components[i];
//                               return CheckboxListTile(
//                                 value: selected[comp],
//                                 title: Text(comp),
//                                 onChanged: (v) => setStateDialog(() => selected[comp] = v ?? false),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: weightController,
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                           "الوزن المباع (جرام) - متاح: ${payload['weight'] ?? 'غير معروف'}",
//                           "Sold weight (g) - available: ${payload['weight'] ?? 'unknown'}"
//                       ),
//                     ),
//                     onChanged: (value) {
//                       final weightSold = double.tryParse(value) ?? 0;
//                       final totalWeight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//                       final totalWage = double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;

//                       if (weightSold > 0 && totalWeight > 0) {
//                         computedWage = totalWage * (weightSold / totalWeight);
//                         wageController.text = computedWage.toStringAsFixed(2);
//                       } else {
//                         wageController.text = "0";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: wageController,
//                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                         "الأجر المباع (قابل للتعديل) - متاح: ${payload['wage'] ?? '0'}",
//                         "Sold wage (editable) - available: ${payload['wage'] ?? '0'}",
//                       ),
//                     ),
//                   ),

//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   weightController.dispose();
//                   wageController.dispose();
//                   Navigator.of(ctx).pop(null);
//                 },
//                 child: Text(_t("إلغاء", "Cancel")),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   FocusScope.of(ctx).unfocus(); // أولاً نلغي التركيز

//                   await Future.delayed(const Duration(milliseconds: 100)); // ننتظر لحظة صغيرة

//                   final soldComps = selected.entries.where((e) => e.value).map((e) => e.key).toList();
//                   /*if (soldComps.isEmpty) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("اختر مكون/مكونات للبيع الجزئي", "Select item(s) for partial sale"))));
//                     return;
//                   }*/

//                   final weightSold = double.tryParse(weightController.text) ?? 0;
//                   final wageSold = double.tryParse(wageController.text) ?? 0;
//                   final availableWeight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//                   final availableWage = double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;

//                   if (weightSold <= 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("ادخل وزن صالح أكبر من صفر", "Enter a valid weight greater than zero"))));
//                     return;
//                   }
//                   if (weightSold > availableWeight) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("الوزن المباع أكبر من الوزن المتاح", "Sold weight exceeds available weight"))));
//                     return;
//                   }
//                   if (wageSold < 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("الأجر غير صحيح", "Invalid wage"))));
//                     return;
//                   }
//                   if (wageSold > availableWage) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("الأجر المباع أكبر من الأجر المتاح", "Sold wage exceeds available wage"))));
//                     return;
//                   }

//                   final result = {
//                     'soldComponents': soldComps,
//                     'weightSold': weightSold,
//                     'wageSold': wageSold,
//                   };

//                   // ✅ الحل القوي هنا
//                   if (ctx.mounted) {
//                     Navigator.of(ctx).pop(result);
//                   }
//                 },
//                 child:  Text(_t("تأكيد البيع الجزئي", "Confirm partial sale")),

//               ),

//             ],
//           );
//         });
//       },
//     );
//   }
//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.9),
//       builder: (_) => GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(10),
//           child: InteractiveViewer(
//             minScale: 0.8,
//             maxScale: 4,
//             child: Image.network(imageUrl, fit: BoxFit.contain),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItemCard(String epc, Map<String, dynamic>? itemData) {
//     if (itemData == null) return const SizedBox();
//     final payload = itemData['payload'] ?? {};
//     final epcHex = itemData['epcHex'].toString();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//       Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ================== البيانات ==================
//         Expanded(
//           flex: 2,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const Icon(Icons.qr_code, color: Colors.blue),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _t("المقروء: $epc", "Read: $epc"),
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               // ===== تفاصيل حسب النوع =====
//               if (itemData['category'] == 'gold') ...[
//                 Row(children: [
//                   const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37)),
//                   const SizedBox(width: 8),
//                   Text(_t("التصنيف: ذهب", "Category: Gold")),
//                 ]),
//                 Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}", "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                 Text(_t("النوع: ${payload['kind'] ?? 'غير محدد'}", "kind: ${payload['kind'] ?? 'Unknown'}")),
//                 Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام", "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                 if (payload['wage'] != null)
//                   Text(_t("الأجر: ${payload['wage']}", "Wage: ${payload['wage']}")),
//                 Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}", "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//               ],

//               if (itemData['category'] == 'gem') ...[
//                 Row(children: [
//                   const Icon(Icons.diamond, color: Colors.purple),
//                   const SizedBox(width: 8),
//                   Text(_t("التصنيف: أحجار كريمة", "Category: Gemstones")),
//                 ]),
//                 Text(_t("نوع الحجر: ${payload['type'] ?? 'غير محدد'}", "Type: ${payload['type'] ?? 'Unknown'}")),
//                 Text(_t("التكلفة: ${payload['cost'] ?? 'غير محدد'}", "Cost: ${payload['cost'] ?? 'Unknown'}")),
//                 Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}", "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//               ],

//               if (itemData['category'] == 'scrap') ...[
//                 Row(children: [
//                   const Icon(Icons.recycling, color: Colors.green),
//                   const SizedBox(width: 8),
//                   Text(_t("التصنيف: كسر", "Category: Scrap")),
//                 ]),
//                 Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}", "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                 Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام", "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                 if (payload['wage'] != null)
//                   Text(_t("الأجر: ${payload['wage']}", "Wage: ${payload['wage']}")),
//                 Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}", "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//               ],

//               if (itemData['category'] == 'bullion') ...[
//                 Row(children: [
//                   const Icon(Icons.workspace_premium, color: Color(0xFFD4AF37)),
//                   const SizedBox(width: 8),
//                   Text(_t("التصنيف: سبائك", "Category: Bullion")),
//                 ]),
//                 Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام", "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                 if (payload['wage'] != null)
//                   Text(_t("الأجر: ${payload['wage']}", "Wage: ${payload['wage']}")),
//                 Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}", "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//               ],
//             ],
//           ),
//         ),

//         const SizedBox(width: 12),

//         // ================== الصور ==================
//         Expanded(
//           flex: 1,
//           child: SizedBox(
//             height: 140,
//             child: FutureBuilder<List<String>>(
//               future: () async {
//                 final uid = FirebaseAuth.instance.currentUser!.uid;
//                 final storageRef = FirebaseStorage.instance
//                     .ref()
//                     .child('images')
//                     .child('users')
//                     .child(uid)
//                     .child(epcHex);

//                 final result = await storageRef.listAll();
//                 return Future.wait(result.items.map((e) => e.getDownloadURL()));
//               }(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator(strokeWidth: 2));
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Center(
//                     child: Text(
//                       _t('لا يوجد صور', 'No Images'),
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (_, i) => Padding(
//                     padding: const EdgeInsets.all(4),
//                     child: GestureDetector(
//                       onTap: () => _showFullImage(context, snapshot.data![i]),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           snapshot.data![i],
//                           width: 100,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),

//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     ),

//     // 🔹 تفاصيل العنصر (نفس الكود القديم)
//         if (payload['qrCode'] != null)
//           Center(
//             child: (payload['showQr'] == true)
//                 ? QrImageView(
//               data: payload['qrCode'],
//               version: QrVersions.auto,
//               size: 100.0,
//               backgroundColor: Colors.white,
//             )
//                 : BarcodeWidget(
//               barcode: Barcode.code128(),
//               data: payload['qrCode'],
//               width: 100,
//               height: 40,
//             ),
//           ),
//         const SizedBox(height: 16),

//         // لو العنصر طقم نظهر اختيار وضع البيع
//         if ((payload['kind'] ?? '').toString().contains('طقم')) ...[
//           Row(
//             children: [
//                Text(_t("نوع البيع:", "Sale type:"), style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: saleMode[epc] ?? 'كامل',
//                 items:  [
//                   DropdownMenuItem(value: 'كامل', child: Text(_t('بيع كامل', 'Full sale'))),
//                   DropdownMenuItem(value: 'جزئي', child: Text(_t('بيع جزئي', 'Partial sale'))),
//                 ],
//                 onChanged: (v) => setState(() => saleMode[epc] = v ?? 'كامل'),
//               ),
//               const SizedBox(width: 10),
//               if (saleMode[epc] == 'جزئي')
//                 ElevatedButton(
//                   onPressed: () async {
//                     // افتح دياج للجزئي فوراً (بدون انتظار زرار مركزي)
//                     final partialResult = await _openPartialSaleDialog(epc, itemData);
//                     if (partialResult != null) {
//                       // حفظ مؤقت لpartialData لنبعثها لاحقًا أثناء عملية _sell
//                       // هنا نخزنها داخل itemsData كي يتم استرجاعها قبل نداء FS.sellItem في _sell
//                       setState(() {
//                         itemsData[epc] = {
//                           ...itemData,
//                           '_pendingPartial': partialResult, // علامة احتياطية
//                         };
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             _t(
//                                 'تم تحضير بيانات البيع الجزئي. اضغط "تسجيل عملية البيع" لإتمام العملية.',
//                                 'Partial sale data prepared. Press "Register Sale" to complete the process.'
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: Text(_t('فتح البيع الجزئي', 'Open partial sale')),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//         ],

//         Text(_t("اختر طريقة الدفع:", "Choose payment method:"), style: const TextStyle(fontWeight: FontWeight.bold)),
//         DropdownButton<String>(
//           value: paymentTypes[epc],
//           hint: Text(_t("اختر نوع الدفع", "Select payment type")),
//           items:  [
//             DropdownMenuItem(value: "cash", child: Text(_t("كاش", "Cash"))),
//             DropdownMenuItem(value: "visa", child: Text(_t("شبكة", "Card"))),
//             DropdownMenuItem(value: "multi", child: Text(_t("متعدد", "Multiple"))),
//     ],
//           onChanged: (val) => setState(() => paymentTypes[epc] = val),
//         ),
//         if (paymentTypes[epc] == "cash" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: cashControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration:  InputDecoration(labelText: _t("مبلغ الكاش", "Cash amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] == "visa" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: visaControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(labelText: _t("مبلغ الشبكة", "Card amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: Text(
//               _t("الإجمالي", "Total") + ": ${totals[epc] ?? 0}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         if (totals[epc] != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               _t("سعر القطعة:", "Piece price:") + " ${totals[epc] ?? 0}",
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
//             ),
//           ),
//         const Divider(),
//       ],
//     );
//   }
//   void _addEpc(String epc) async{
//     //epc = epc.trim().toUpperCase();

//     if (epc.isEmpty) return;
//     final result = await FS.epcandcode(epc);
//     print(epcs);

//     if (epcs.contains(epc) && epcs.contains(epc.trim().toUpperCase()) && epcs.contains(result?['epcHex'] ) && epcs.contains(result?['qrCode'] )) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_t("تمت اضافة الشريحة من قبل", "Tag already added"))),
//       );
//       return;
//     }

//     setState(() {
//       epcs.add(epc);
//       paymentTypes[epc] = null;
//       cashControllers[epc] = TextEditingController();
//       visaControllers[epc] = TextEditingController();
//       totals[epc] = 0;
//       saleMode[epc] = 'كامل';
//     });

//     _loadItemData(epc);
//   }
//   void _showManualEpcDialog() {
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
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _t("صفحة البيع", "Sales Page")
//         ),
//         backgroundColor: const Color(0xFFD4AF37),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.history),
//             tooltip: _t("سجل البيع", "Sales History"),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const SalesHistoryPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//         /*actions: [
//           IconButton(
//             icon: const Icon(Icons.tune),
//             tooltip: _t('قوة القارئ', 'Reader Power'),
//             onPressed: _showPowerSheet,
//           ),
//         ],*/
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFD4AF37),
//         onPressed: _showManualEpcDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // 🔹 اختيار المستخدم
//             if (userNames.isNotEmpty) ...[
//               Text(
//                 _t("اختر اسم المستخدم:", "Select User:"),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),

//               DropdownButton<String>(
//                 value: selectedUser,
//                 isExpanded: true,
//                 hint: Text(_t("اختر المستخدم", "Select User")),
//                 items: userNames.map((name) {
//                   return DropdownMenuItem(value: name, child: Text(name));
//                 }).toList(),
//                 onChanged: (val) => setState(() => selectedUser = val),
//               ),
//               const Divider(),
//             ],

//             for (final epc in epcs) _buildItemCard(epc, itemsData[epc]),

//             // --- دفع مجمّع عند وجود أكثر من قطعة ---
//             if (epcs.length > 1) ...[
//               const SizedBox(height: 12),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   _t('الدفع المجمّع (تطبيق مرة واحدة على كل القطع)', 'Batch payment (apply once for all items)'),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButton<String>(
//                 value: globalPaymentType,
//                 hint: Text(_t('اختر نوع الدفع المجمّع', 'Select batch payment type')),
//                 items: [
//                   DropdownMenuItem(value: 'cash', child: Text(_t('كاش', 'Cash'))),
//                   DropdownMenuItem(value: 'visa', child: Text(_t('شبكة', 'Card'))),
//                   DropdownMenuItem(value: 'multi', child: Text(_t('متعدد', 'Multiple'))),
//                 ],
//                 onChanged: (v) => setState(() => globalPaymentType = v),
//               ),
//               if (globalPaymentType == 'cash' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalCashController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(labelText: _t('مجموع الكاش للقطع كلها', 'Total cash for all items')),
//                 ),
//               if (globalPaymentType == 'visa' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalVisaController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(labelText: _t('مجموع الشبكة للقطع كلها', 'Total card for all items')),
//                 ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _applyGlobalDistribution,
//                       child: Text(_t('تطبيق على الكل', 'Apply to all')),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             if (epcs.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       Text(_t("الكاش", "Cash"), style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalCash", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(_t("الشبكة", "Visa"), style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalVisa", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),

//                   Column(
//                     children: [
//                       Text(_t("الإجمالي", "Total"), style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$grandTotal", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             ElevatedButton.icon(
//               onPressed: busy ? null : _sell,
//               icon: const Icon(Icons.sell, color: Colors.white),
//               label: Text(_t("تسجيل عملية البيع", "Register Sale")),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             if (msg != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 msg!,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: msg!.contains(_t("نجاح", "Success")) ? Colors.green : Colors.red,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';
// import '../services/seuic_uhf_service.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'sales_history_page.dart';
// import 'RemainingKitsPage.dart'; // ✅ استيراد صفحة بقايا الأطقم

// class SalesPage extends StatefulWidget {
//   const SalesPage({super.key});

//   @override
//   State<SalesPage> createState() => _SalesPageState();
// }

// class _SalesPageState extends State<SalesPage> {
//   StreamSubscription<String>? _tagSubscription;
//   List<String> epcs = [];
//   Map<String, dynamic> itemsData = {};
//   bool isReading = false;
//   bool busy = false;
//   String? msg;

//   // 🔹 أسماء المستخدمين
//   List<String> userNames = [];
//   String? selectedUser;

//   // 🔹 متغيرات الدفع
//   Map<String, String?> paymentTypes = {};
//   Map<String, TextEditingController> cashControllers = {};
//   Map<String, TextEditingController> visaControllers = {};
//   Map<String, double> totals = {};

//   // وضع البيع: 'كامل' او 'جزئي' لكل epc
//   Map<String, String> saleMode = {};

//   double totalCash = 0;
//   double totalVisa = 0;
//   double grandTotal = 0;

//   // Global (batch) payment controllers for multiple-item sales
//   TextEditingController globalCashController = TextEditingController();
//   TextEditingController globalVisaController = TextEditingController();
//   String? globalPaymentType;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   int _readerPower = 26; // القيمة الحالية
//   int _tempPower = 26; // قيمة السلايدر المؤقتة

//   @override
//   void initState() {
//     super.initState();

//     //SeuicUhfService.sendBoolean(false);
//     _loadLanguage();
//     //_setPagePower();
//     //_initUhfAndSetPower();
//     //_loadSavedReaderPower();
//     _loadUserNames();

//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
//       final epc = tag;

//       final result = await FS.epcandcode(epc);

//       if (!epcs.contains(epc) &&
//           !epcs.contains(result?['epcHex']) &&
//           !epcs.contains(result?['qrCode'])) {
//         setState(() {
//           epcs.add(epc);
//           paymentTypes[epc] = null;
//           cashControllers[epc] = TextEditingController();
//           visaControllers[epc] = TextEditingController();
//           totals[epc] = 0;
//           saleMode[epc] = 'كامل';
//         });
//         _loadItemData(epc);
//       }
//       //_addEpc(tag);
//     });
//     SeuicUhfService.open();
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

//   Future<void> _loadSavedReaderPower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');

//     if (powerJson != null) {
//       final Map<String, dynamic> pagePowers =
//           Map<String, dynamic>.from(json.decode(powerJson));

//       final savedPower = pagePowers['sales'];
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

//                             pagePowers['sales'] = _readerPower;
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

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadUserNames() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userNames = prefs.getStringList('userNames') ?? [];
//       if (userNames.isNotEmpty) selectedUser = userNames.first;
//     });
//   }

//   /*Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['sales'] ?? 26; // استبدل 'sales' حسب الصفحة
//       await SeuicUhfService.setPower(pagePower);
//       print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//     }
//   }*/
//   Future<void> _initUhfAndSetPower() async {
//     try {
//       // أولاً: افتح الـ UHF وانتظر
//       final opened = await SeuicUhfService.open();
//       if (!opened) {
//         print('⚠️ فشل في فتح UHF، محاولة مرة ثانية...');
//         await Future.delayed(const Duration(seconds: 1)); // تأخير صغير
//         await SeuicUhfService.open(); // retry
//       }

//       // ثانيًا: حمّل وضبط القوة (بعد الفتح)
//       await _setPagePower();
//     } catch (e) {
//       print('❌ خطأ في تهيئة UHF: $e');
//     }
//   }

//   Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['sales'] ?? 26;

//       // استدعي setPower وشيك النتيجة
//       final success = await SeuicUhfService.setPower(pagePower);
//       if (success) {
//         print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//       } else {
//         print('⚠️ فشل في ضبط القوة، محاولة عبر fallback...');
//         // لو عايز، أضف fallback هنا في Flutter، لكن أفضل في Android
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     for (final c in cashControllers.values) {
//       c.dispose();
//     }
//     for (final c in visaControllers.values) {
//       c.dispose();
//     }
//     globalCashController.dispose();
//     globalVisaController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadItemData(String epc) async {
//     try {
//       final data = await FS.findItemByEpc(epc);
//       setState(() {
//         itemsData[epc] = data;
//         // لو العنصر طقم وخانة saleMode مش معمولة مسبقًا
//         if (data != null) {
//           final payload = data['payload'] ?? {};
//           final kind = (payload['kind'] ?? '').toString();
//           if (kind.contains('طقم') || kind.contains('طقم'.trim())) {
//             saleMode[epc] = saleMode[epc] ?? 'كامل';
//           } else {
//             saleMode[epc] = 'كامل';
//           }
//         }
//       });
//     } catch (e) {
//       setState(() {
//         itemsData[epc] = {"error": e.toString()};
//       });
//     }
//   }

//   void _calculateTotal(String epc) {
//     double cash = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//     double visa = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;
//     setState(() {
//       totals[epc] = cash + visa;
//       totalCash = cashControllers.values
//           .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values
//           .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });
//   }

//   Future<void> _sell() async {
//     if (epcs.isEmpty) {
//       setState(() => msg = _t("من فضلك اقرأ شريحة واحدة على الأقل",
//           "Please read at least one chip"));
//       return;
//     }

//     if (selectedUser == null || selectedUser!.isEmpty) {
//       setState(() => msg = _t(
//           "يرجى اضافة اسم المستخدم من الاعدادات وحفظ الاعدادات حتى تتمكن من البيع",
//           "Please add a username from settings and save settings before proceeding"));
//       return;
//     }

//     // ✅ الخطوة 1: تحقق من جميع البيانات أولاً قبل البدء بالبيع
//     for (final epc in List<String>.from(epcs)) {
//       /*// 🔹 تحقق أولاً إن الشريحة موجودة في قاعدة البيانات
//       final exists = await FS.findItemByEpc(epc);
//       if (exists == null || exists == false) {
//         setState(() {
//           msg = _t(
//               "⚠ الشريحة $epc غير موجودة في قاعدة البيانات، تم تجاهلها.",
//               "⚠ The tag $epc was not found in the database and has been ignored."
//           );
//           epcs.remove(epc);
//           paymentTypes.remove(epc);
//           cashControllers.remove(epc);
//           visaControllers.remove(epc);
//           totals.remove(epc);
//           saleMode.remove(epc);
//           itemsData.remove(epc);
//         });
//         continue; // ✅ تخطى هذه الشريحة ولا توقف العملية
//       }*/

//       // 🔹 تحقق من اختيار طريقة الدفع
//       if (paymentTypes[epc] == null) {
//         setState(() {
//           msg = _t("⚠ اختر طريقة الدفع للشريحة $epc أولاً",
//               "⚠ Please select the payment method for tag $epc first");
//         });
//         return; // ❌ توقف العملية بالكامل
//       }
//       final paymentType = paymentTypes[epc];
//       final cashVal = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//       final visaVal = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;

//       if (paymentType == "cash" && cashVal <= 0) {
//         setState(() {
//           msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//               "⚠ Enter the correct cash amount for tag $epc.");
//         });
//         return;
//       }

//       if (paymentType == "visa" && visaVal <= 0) {
//         setState(() {
//           msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//               "⚠ Enter the correct card amount for tag $epc.");
//         });
//         return;
//       }

//       if (paymentType == "multi") {
//         if (cashVal <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct cash amount for tag $epc.");
//           });
//           return;
//         }

//         if (visaVal <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct card amount for tag $epc.");
//           });
//           return;
//         }
//       }

//       // 🔹 تحقق من البيع الجزئي إن وجد
//       if (saleMode[epc] == 'جزئي') {
//         final item = itemsData[epc];
//         if (item == null) {
//           setState(() {
//             msg = _t("خطأ: بيانات الشريحة $epc غير متاحة.",
//                 "Error: Data for tag $epc is not available.");
//           });
//           return; // ❌ توقف العملية بالكامل
//         }

//         final partialResult = item['_pendingPartial'];
//         if (partialResult == null) {
//           setState(() {
//             msg = _t(
//                 "⚠ من فضلك اضغط 'فتح البيع الجزئي' وأدخل التفاصيل قبل تسجيل البيع.",
//                 "⚠ Please press 'Open Partial Sale' and enter the details before recording the sale.");
//           });
//           return; // ❌ توقف العملية بالكامل
//         }

//         final weightSold = (partialResult['weightSold'] ?? 0).toDouble();
//         if (weightSold <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل وزن صحيح في البيع الجزئي للشريحة $epc.",
//                 "⚠ Enter a valid weight in the partial sale for tag $epc.");
//           });
//           return; // ❌ توقف العملية بالكامل
//         }
//       }
//     }

//     // ✅ لو وصلنا هنا فكل البيانات سليمة نبدأ البيع فعليًا
//     setState(() {
//       busy = true;
//       msg = null;
//     });

//     final saleGroupId = DateTime.now().millisecondsSinceEpoch.toString();
//     final hasSetItem = epcs.any((epc) {
//       final item = itemsData[epc];
//       final payload =
//           item != null ? Map<String, dynamic>.from(item['payload'] ?? {}) : {};
//       return (payload['kind'] ?? '').toString().contains('طقم');
//     });
//     if (hasSetItem) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             _t(
//               'تنبيه: يوجد طقم في البيع، تأكد من اختيار حالة البيع جزئي أو كامل لكل قطعة قبل التأكيد.',
//               'Note: a set item is included in the sale. Make sure to choose partial or full sale for each item before confirming.',
//             ),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }

//     try {
//       for (final epc in List<String>.from(epcs)) {
//         final paymentData = {
//           "type": paymentTypes[epc],
//           "cash": double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0,
//           "visa": double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0,
//           "total": totals[epc] ?? 0,
//           "soldBy": selectedUser,
//         };

//         if (saleMode[epc] == 'جزئي') {
//           final item = itemsData[epc];
//           final partialResult = item['_pendingPartial'];

//           final soldCompsRaw = partialResult['soldComponents'];
//           final soldComps = soldCompsRaw is List
//               ? soldCompsRaw.map((e) => e.toString()).toList()
//               : <String>[];

//           await FS.sellItem(
//             epc,
//             saleGroupId: saleGroupId,
//             partialSale: true,
//             soldComponents: soldComps,
//             weightSold: (partialResult['weightSold'] ?? 0).toDouble(),
//             wageSold: (partialResult['wageSold'] ?? 0).toDouble(),
//             paymentData: paymentData,
//           );

//           // حذف بيانات الجزئي بعد البيع
//           setState(() {
//             itemsData[epc].remove('_pendingPartial');
//           });

//           await _loadItemData(epc);

//           final updated = itemsData[epc];
//           final updatedPayload =
//               updated != null ? (updated['payload'] ?? {}) : {};
//           final updatedWeight = (updatedPayload['weight'] ?? 0).toString();
//           final hasComponents =
//               (updatedPayload['setComponents'] ?? []).isNotEmpty;
//           final weightZero = double.tryParse(updatedWeight.toString()) == 0;

//           if (!hasComponents || weightZero) {
//             setState(() {
//               epcs.remove(epc);
//               itemsData.remove(epc);
//               paymentTypes.remove(epc);
//               cashControllers.remove(epc);
//               visaControllers.remove(epc);
//               totals.remove(epc);
//               saleMode.remove(epc);
//             });
//           }
//         } else {
//           // 🔹 حذف الصور فقط في حالة البيع الكامل
//           await _deleteItemImages(epc);
//           // البيع الكامل
//           await FS.sellItem(epc,
//               saleGroupId: saleGroupId, paymentData: paymentData);
//           setState(() {
//             epcs.remove(epc);
//             itemsData.remove(epc);
//             paymentTypes.remove(epc);
//             cashControllers.remove(epc);
//             visaControllers.remove(epc);
//             totals.remove(epc);
//             saleMode.remove(epc);
//           });
//         }
//       }

//       setState(() {
//         msg = _t("✅ تم تنفيذ جميع عمليات البيع بنجاح بواسطة $selectedUser.",
//             "✅ All sales were successfully completed by $selectedUser.");

//         // 🔹 حساب الإجماليات النهائية فقط للعرض المؤقت
//         totalCash = cashControllers.values
//             .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         totalVisa = visaControllers.values
//             .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         grandTotal = totalCash + totalVisa;
//       });

// // 🔹 انتظر لحظة قصيرة قبل التهيئة (علشان تظهر رسالة النجاح)
//       await Future.delayed(const Duration(seconds: 1));

// // ✅ إعادة ضبط كل القيم إلى حالتها الأساسية
//       setState(() {
//         epcs.clear();
//         itemsData.clear();
//         paymentTypes.clear();
//         for (final c in cashControllers.values) {
//           c.dispose();
//         }
//         for (final c in visaControllers.values) {
//           c.dispose();
//         }
//         cashControllers.clear();
//         visaControllers.clear();
//         totals.clear();
//         saleMode.clear();
//         totalCash = 0;
//         totalVisa = 0;
//         grandTotal = 0;
//       });
//     } catch (e) {
//       setState(
//           () => msg = _t("فشل تسجيل البيع: $e", "Failed to record sale: $e"));
//     } finally {
//       if (!mounted) return;
//       setState(() => busy = false);
//     }
//   }

//   /*Future<void> _deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       // المسار الكامل للفولدر الخاص بالشريحة
//       final folderRef = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epc.toUpperCase());

//       // جلب قائمة كل الملفات داخل الفولدر
//       final ListResult result = await folderRef.listAll();

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $epc (الفولدر فاضي)');
//         // نحذف الحقل من Firestore برضو عشان النظافة
//         //await _clearImagesFieldFromFirestore(epc);
//         return;
//       }

//       print('🗑️ بدء حذف ${result.items.length} صورة للشريحة $epc');

//       // حذف كل صورة
//       for (Reference ref in result.items) {
//         try {
//           await ref.delete();
//           print('✅ تم حذف: ${ref.name}');
//         } catch (e) {
//           print('❌ فشل حذف ملف: ${ref.name} | $e');
//         }
//       }

//       // بعد الحذف، نحذف حقل images من Firestore
//       //await _clearImagesFieldFromFirestore(epc);

//       print('✅ تم حذف الفولدر بأكمله وحقل الصور من Firestore لـ $epc');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//       // ما نوقفش عملية البيع بسبب الصور
//     }
//   }*/
//   Future<void> _deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       // الفولدر الأصلي
//       final sourceFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epc.toUpperCase());

//       // فولدر المبيعات
//       final salesFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child('sales')
//           .child(epc.toUpperCase());

//       final ListResult result = await sourceFolder.listAll();

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $epc');
//         return;
//       }

//       print('📦 نسخ ${result.items.length} صورة إلى مجلد المبيعات');

//       for (Reference sourceRef in result.items) {
//         try {
//           // تحميل الصورة
//           final Uint8List? bytes = await sourceRef.getData();

//           if (bytes == null) {
//             print('❌ لم يتم تحميل ${sourceRef.name}');
//             continue;
//           }

//           // إنشاء الملف الجديد بنفس الاسم
//           final destRef = salesFolder.child(sourceRef.name);

//           // نسخ الصورة
//           await destRef.putData(bytes);

//           print('✅ تم نسخ ${sourceRef.name}');

//           // حذف الأصل بعد نجاح النسخ
//           await sourceRef.delete();

//           print('🗑️ تم حذف ${sourceRef.name}');
//         } catch (e) {
//           print('❌ خطأ مع ${sourceRef.name}: $e');
//         }
//       }

//       print('✅ انتهت عملية النسخ والحذف');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//     }
//   }

//   // يوزع المبلغ الكلي على جميع القطع حسب (الوزن * العيار) أو بالتساوي كبديل
//   void _applyGlobalDistribution() {
//     if (epcs.isEmpty) return;
//     if (globalPaymentType == null) {
//       showAppMessage(context,
//           _t('اختر طريقة دفع مجمّعة', 'Please select batch payment type'));
//       return;
//     }

//     final totalCashGlobal = double.tryParse(globalCashController.text) ?? 0;
//     final totalVisaGlobal = double.tryParse(globalVisaController.text) ?? 0;

//     if (totalCashGlobal <= 0 && totalVisaGlobal <= 0) {
//       showAppMessage(context,
//           _t('أدخل مبلغ كاش أو شبكة صحيح', 'Enter a valid cash or card total'));
//       return;
//     }

//     final Map<String, double> factors = {};
//     double sumFactors = 0;

//     for (final epc in epcs) {
//       final payload = itemsData[epc]?['payload'] ?? {};

//       double weight = 0;
//       if (saleMode[epc] == 'جزئي' &&
//           itemsData[epc]?['_pendingPartial'] != null) {
//         weight = double.tryParse(
//                 itemsData[epc]!['_pendingPartial']['weightSold']?.toString() ??
//                     '0') ??
//             0;
//       } else {
//         weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//       }

//       double carat = double.tryParse((payload['carat'] ?? 0).toString()) ?? 0;
//       double factor = weight * (carat > 0 ? carat : 1);
//       if (factor <= 0) factor = 1;
//       factors[epc] = factor;
//       sumFactors += factor;
//     }

//     if (sumFactors <= 0) sumFactors = epcs.length.toDouble();

//     for (final epc in epcs) {
//       final factor = factors[epc] ?? 1;
//       final cashShare = totalCashGlobal * factor / sumFactors;
//       final visaShare = totalVisaGlobal * factor / sumFactors;

//       setState(() {
//         paymentTypes[epc] = globalPaymentType;
//         cashControllers[epc]?.text = cashShare.toStringAsFixed(2);
//         visaControllers[epc]?.text = visaShare.toStringAsFixed(2);
//         _calculateTotal(epc);
//       });
//     }

//     setState(() {
//       totalCash = cashControllers.values
//           .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values
//           .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });

//     showAppMessage(
//         context,
//         _t('تم تطبيق الدفع المجمّع على كل القطع',
//             'Batch payment applied to all items'));
//   }

//   // دالة مساعدة لحذف حقل images من Firestore فقط
//   /*Future<void> _clearImagesFieldFromFirestore(String epc) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('items')
//           .doc(epc)
//           .update({
//         'images': FieldValue.delete(),
//       });
//     } catch (e) {
//       print('⚠️ فشل حذف حقل images من Firestore لـ $epc: $e');
//     }
//   }*/

//   // Dialog لبيع جزئي: اختيار مكونات + ادخال weight و wage
//   // يعيد Map مع المفاتيح: soldComponents(List<String>), weightSold(double), wageSold(double) أو null لو ألغي
//   Future<Map<String, dynamic>?> _openPartialSaleDialog(
//       String epc, Map<String, dynamic> itemData) async {
//     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
//     final List<dynamic> setComponentsDynamic = payload['setComponents'] ?? [];
//     final List<String> components =
//         setComponentsDynamic.map((c) => c.toString()).toList();
//     double computedWage = 0;

//     // حالة اختيار المكونات
//     final Map<String, bool> selected = {for (var c in components) c: false};
//     final weightController = TextEditingController();
//     final wageController = TextEditingController();

//     return showDialog<Map<String, dynamic>>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         return StatefulBuilder(builder: (context, setStateDialog) {
//           return AlertDialog(
//             title: Text(_t("تفاصيل البيع الجزئي", "Partial Sale Details")),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (components.isEmpty)
//                     Text(_t("لا توجد مكونات في الطقم لعمل بيع جزئي.",
//                         "No components in the set for partial sale."))
//                   else
//                     Column(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _t("اختر المكونات التي سيتم بيعها:",
//                                 "Select components to sell:"),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 150,
//                           width: double.maxFinite,
//                           child: ListView.builder(
//                             itemCount: components.length,
//                             itemBuilder: (_, i) {
//                               final comp = components[i];
//                               return CheckboxListTile(
//                                 value: selected[comp],
//                                 title: Text(comp),
//                                 onChanged: (v) => setStateDialog(
//                                     () => selected[comp] = v ?? false),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: weightController,
//                     keyboardType:
//                         TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                           "الوزن المباع (جرام) - متاح: ${payload['weight'] ?? 'غير معروف'}",
//                           "Sold weight (g) - available: ${payload['weight'] ?? 'unknown'}"),
//                     ),
//                     onChanged: (value) {
//                       final weightSold = double.tryParse(value) ?? 0;
//                       final totalWeight = double.tryParse(
//                               (payload['weight'] ?? 0).toString()) ??
//                           0;
//                       final totalWage =
//                           double.tryParse((payload['wage'] ?? 0).toString()) ??
//                               0;

//                       if (weightSold > 0 && totalWeight > 0) {
//                         computedWage = totalWage * (weightSold / totalWeight);
//                         wageController.text = computedWage.toStringAsFixed(2);
//                       } else {
//                         wageController.text = "0";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: wageController,
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                         "الأجر المباع (قابل للتعديل) - متاح: ${payload['wage'] ?? '0'}",
//                         "Sold wage (editable) - available: ${payload['wage'] ?? '0'}",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   weightController.dispose();
//                   wageController.dispose();
//                   Navigator.of(ctx).pop(null);
//                 },
//                 child: Text(_t("إلغاء", "Cancel")),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   FocusScope.of(ctx).unfocus(); // أولاً نلغي التركيز

//                   await Future.delayed(
//                       const Duration(milliseconds: 100)); // ننتظر لحظة صغيرة

//                   final soldComps = selected.entries
//                       .where((e) => e.value)
//                       .map((e) => e.key)
//                       .toList();
//                   /*if (soldComps.isEmpty) {
//                     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(content: Text(_t("اختر مكون/مكونات للبيع الجزئي", "Select item(s) for partial sale"))));
//                     return;
//                   }*/

//                   final weightSold =
//                       double.tryParse(weightController.text) ?? 0;
//                   final wageSold = double.tryParse(wageController.text) ?? 0;
//                   final availableWeight =
//                       double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//                   final availableWage =
//                       double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;

//                   if (weightSold <= 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("ادخل وزن صالح أكبر من صفر",
//                             "Enter a valid weight greater than zero"))));
//                     return;
//                   }
//                   if (weightSold > availableWeight) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الوزن المباع أكبر من الوزن المتاح",
//                             "Sold weight exceeds available weight"))));
//                     return;
//                   }
//                   if (wageSold < 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الأجر غير صحيح", "Invalid wage"))));
//                     return;
//                   }
//                   if (wageSold > availableWage) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الأجر المباع أكبر من الأجر المتاح",
//                             "Sold wage exceeds available wage"))));
//                     return;
//                   }

//                   final result = {
//                     'soldComponents': soldComps,
//                     'weightSold': weightSold,
//                     'wageSold': wageSold,
//                   };

//                   // ✅ الحل القوي هنا
//                   if (ctx.mounted) {
//                     Navigator.of(ctx).pop(result);
//                   }
//                 },
//                 child: Text(_t("تأكيد البيع الجزئي", "Confirm partial sale")),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.9),
//       builder: (_) => GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(10),
//           child: InteractiveViewer(
//             minScale: 0.8,
//             maxScale: 4,
//             child: Image.network(imageUrl, fit: BoxFit.contain),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItemCard(String epc, Map<String, dynamic>? itemData) {
//     if (itemData == null) return const SizedBox();
//     final payload = itemData['payload'] ?? {};
//     final epcHex = itemData['epcHex'].toString();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ================== البيانات ==================
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.qr_code, color: Colors.blue),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _t("المقروء: $epc", "Read: $epc"),
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   // ===== تفاصيل حسب النوع =====
//                   if (itemData['category'] == 'gold') ...[
//                     Row(children: [
//                       const Icon(Icons.workspace_premium,
//                           color: Color(0xFFD4AF37)),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: ذهب", "Category: Gold")),
//                     ]),
//                     Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
//                         "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                     Text(_t("النوع: ${payload['kind'] ?? 'غير محدد'}",
//                         "kind: ${payload['kind'] ?? 'Unknown'}")),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],

//                   if (itemData['category'] == 'gem') ...[
//                     Row(children: [
//                       const Icon(Icons.diamond, color: Colors.purple),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: أحجار كريمة", "Category: Gemstones")),
//                     ]),
//                     Text(_t("نوع الحجر: ${payload['type'] ?? 'غير محدد'}",
//                         "Type: ${payload['type'] ?? 'Unknown'}")),
//                     Text(_t("التكلفة: ${payload['cost'] ?? 'غير محدد'}",
//                         "Cost: ${payload['cost'] ?? 'Unknown'}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],

//                   if (itemData['category'] == 'scrap') ...[
//                     Row(children: [
//                       const Icon(Icons.recycling, color: Colors.green),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: كسر", "Category: Scrap")),
//                     ]),
//                     Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
//                         "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],

//                   if (itemData['category'] == 'bullion') ...[
//                     Row(children: [
//                       const Icon(Icons.workspace_premium,
//                           color: Color(0xFFD4AF37)),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: سبائك", "Category: Bullion")),
//                     ]),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],
//                 ],
//               ),
//             ),

//             const SizedBox(width: 12),

//             // ================== الصور ==================
//             Expanded(
//               flex: 1,
//               child: SizedBox(
//                 height: 140,
//                 child: FutureBuilder<List<String>>(
//                   future: () async {
//                     final uid = FirebaseAuth.instance.currentUser!.uid;
//                     final storageRef = FirebaseStorage.instance
//                         .ref()
//                         .child('images')
//                         .child('users')
//                         .child(uid)
//                         .child(epcHex);

//                     final result = await storageRef.listAll();
//                     return Future.wait(
//                         result.items.map((e) => e.getDownloadURL()));
//                   }(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2));
//                     }

//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text(
//                           _t('لا يوجد صور', 'No Images'),
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       );
//                     }

//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (_, i) => Padding(
//                         padding: const EdgeInsets.all(4),
//                         child: GestureDetector(
//                           onTap: () =>
//                               _showFullImage(context, snapshot.data![i]),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               snapshot.data![i],
//                               width: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),

//         // 🔹 تفاصيل العنصر (نفس الكود القديم)
//         if (payload['qrCode'] != null)
//           Center(
//             child: (payload['showQr'] == true)
//                 ? QrImageView(
//                     data: payload['qrCode'],
//                     version: QrVersions.auto,
//                     size: 100.0,
//                     backgroundColor: Colors.white,
//                   )
//                 : BarcodeWidget(
//                     barcode: Barcode.code128(),
//                     data: payload['qrCode'],
//                     width: 100,
//                     height: 40,
//                   ),
//           ),
//         const SizedBox(height: 16),

//         // لو العنصر طقم نظهر اختيار وضع البيع
//         if ((payload['kind'] ?? '').toString().contains('طقم')) ...[
//           Row(
//             children: [
//               Text(_t("نوع البيع:", "Sale type:"),
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: saleMode[epc] ?? 'كامل',
//                 items: [
//                   DropdownMenuItem(
//                       value: 'كامل', child: Text(_t('بيع كامل', 'Full sale'))),
//                   DropdownMenuItem(
//                       value: 'جزئي',
//                       child: Text(_t('بيع جزئي', 'Partial sale'))),
//                 ],
//                 onChanged: (v) => setState(() => saleMode[epc] = v ?? 'كامل'),
//               ),
//               const SizedBox(width: 10),
//               if (saleMode[epc] == 'جزئي')
//                 ElevatedButton(
//                   onPressed: () async {
//                     // افتح دياج للجزئي فوراً (بدون انتظار زرار مركزي)
//                     final partialResult =
//                         await _openPartialSaleDialog(epc, itemData);
//                     if (partialResult != null) {
//                       // حفظ مؤقت لpartialData لنبعثها لاحقًا أثناء عملية _sell
//                       // هنا نخزنها داخل itemsData كي يتم استرجاعها قبل نداء FS.sellItem في _sell
//                       setState(() {
//                         itemsData[epc] = {
//                           ...itemData,
//                           '_pendingPartial': partialResult, // علامة احتياطية
//                         };
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             _t('تم تحضير بيانات البيع الجزئي. اضغط "تسجيل عملية البيع" لإتمام العملية.',
//                                 'Partial sale data prepared. Press "Register Sale" to complete the process.'),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: Text(_t('فتح البيع الجزئي', 'Open partial sale')),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//         ],

//         Text(_t("اختر طريقة الدفع:", "Choose payment method:"),
//             style: const TextStyle(fontWeight: FontWeight.bold)),
//         DropdownButton<String>(
//           value: paymentTypes[epc],
//           hint: Text(_t("اختر نوع الدفع", "Select payment type")),
//           items: [
//             DropdownMenuItem(value: "cash", child: Text(_t("كاش", "Cash"))),
//             DropdownMenuItem(value: "visa", child: Text(_t("شبكة", "Card"))),
//             DropdownMenuItem(
//                 value: "multi", child: Text(_t("متعدد", "Multiple"))),
//           ],
//           onChanged: (val) => setState(() => paymentTypes[epc] = val),
//         ),
//         if (paymentTypes[epc] == "cash" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: cashControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration:
//                 InputDecoration(labelText: _t("مبلغ الكاش", "Cash amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] == "visa" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: visaControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration:
//                 InputDecoration(labelText: _t("مبلغ الشبكة", "Card amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: Text(
//               _t("الإجمالي", "Total") + ": ${totals[epc] ?? 0}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         if (totals[epc] != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               _t("سعر القطعة:", "Piece price:") + " ${totals[epc] ?? 0}",
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87),
//             ),
//           ),
//         const Divider(),
//       ],
//     );
//   }

//   void _addEpc(String epc) async {
//     //epc = epc.trim().toUpperCase();

//     if (epc.isEmpty) return;
//     final result = await FS.epcandcode(epc);
//     print(epcs);

//     if (epcs.contains(epc) &&
//         epcs.contains(epc.trim().toUpperCase()) &&
//         epcs.contains(result?['epcHex']) &&
//         epcs.contains(result?['qrCode'])) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(_t("تمت اضافة الشريحة من قبل", "Tag already added"))),
//       );
//       return;
//     }

//     setState(() {
//       epcs.add(epc);
//       paymentTypes[epc] = null;
//       cashControllers[epc] = TextEditingController();
//       visaControllers[epc] = TextEditingController();
//       totals[epc] = 0;
//       saleMode[epc] = 'كامل';
//     });

//     _loadItemData(epc);
//   }

//   void _showManualEpcDialog() {
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

//   void AddEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("صفحة البيع", "Sales Page")),
//         backgroundColor: const Color(0xFFD4AF37),
//         centerTitle: true,
//         actions: [
//           // ✅ زر سجل البيع
//           IconButton(
//             icon: const Icon(Icons.history),
//             tooltip: _t("سجل البيع", "Sales History"),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const SalesHistoryPage(),
//                 ),
//               );
//             },
//           ),
//           // ✅ زر بقايا الأطقم (الجديد)
//           IconButton(
//             icon: const Icon(Icons.inventory_2_outlined),
//             tooltip: _t("بقايا الأطقم", "Set Remainders"),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const RemainingKitsPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//         /*actions: [
//           IconButton(
//             icon: const Icon(Icons.tune),
//             tooltip: _t('قوة القارئ', 'Reader Power'),
//             onPressed: _showPowerSheet,
//           ),
//         ],*/
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFD4AF37),
//         onPressed: _showManualEpcDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // 🔹 اختيار المستخدم
//             if (userNames.isNotEmpty) ...[
//               Text(
//                 _t("اختر اسم المستخدم:", "Select User:"),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               DropdownButton<String>(
//                 value: selectedUser,
//                 isExpanded: true,
//                 hint: Text(_t("اختر المستخدم", "Select User")),
//                 items: userNames.map((name) {
//                   return DropdownMenuItem(value: name, child: Text(name));
//                 }).toList(),
//                 onChanged: (val) => setState(() => selectedUser = val),
//               ),
//               const Divider(),
//             ],

//             for (final epc in epcs) _buildItemCard(epc, itemsData[epc]),

//             // --- دفع مجمّع عند وجود أكثر من قطعة ---
//             if (epcs.length > 1) ...[
//               const SizedBox(height: 12),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   _t('الدفع المجمّع (تطبيق مرة واحدة على كل القطع)',
//                       'Batch payment (apply once for all items)'),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButton<String>(
//                 value: globalPaymentType,
//                 hint: Text(
//                     _t('اختر نوع الدفع المجمّع', 'Select batch payment type')),
//                 items: [
//                   DropdownMenuItem(
//                       value: 'cash', child: Text(_t('كاش', 'Cash'))),
//                   DropdownMenuItem(
//                       value: 'visa', child: Text(_t('شبكة', 'Card'))),
//                   DropdownMenuItem(
//                       value: 'multi', child: Text(_t('متعدد', 'Multiple'))),
//                 ],
//                 onChanged: (v) => setState(() => globalPaymentType = v),
//               ),
//               if (globalPaymentType == 'cash' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalCashController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(
//                       labelText: _t('مجموع الكاش للقطع كلها',
//                           'Total cash for all items')),
//                 ),
//               if (globalPaymentType == 'visa' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalVisaController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(
//                       labelText: _t('مجموع الشبكة للقطع كلها',
//                           'Total card for all items')),
//                 ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _applyGlobalDistribution,
//                       child: Text(_t('تطبيق على الكل', 'Apply to all')),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             if (epcs.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       Text(_t("الكاش", "Cash"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalCash", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(_t("الشبكة", "Visa"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalVisa", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(_t("الإجمالي", "Total"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$grandTotal", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             ElevatedButton.icon(
//               onPressed: busy ? null : _sell,
//               icon: const Icon(Icons.sell, color: Colors.white),
//               label: Text(_t("تسجيل عملية البيع", "Register Sale")),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             if (msg != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 msg!,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: msg!.contains(_t("نجاح", "Success"))
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// // }
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';
// import '../services/seuic_uhf_service.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';
// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ui' as ui;
// import 'dart:typed_data';
// import 'sales_history_page.dart';
// import 'RemainingKitsPage.dart'; // ✅ استيراد صفحة بقايا الأطقم

// class SalesPage extends StatefulWidget {
//   const SalesPage({super.key});

//   @override
//   State<SalesPage> createState() => _SalesPageState();
// }

// class _SalesPageState extends State<SalesPage> {
//   StreamSubscription<String>? _tagSubscription;
//   List<String> epcs = [];
//   Map<String, dynamic> itemsData = {};
//   bool isReading = false;
//   bool busy = false;
//   String? msg;

//   // 🔹 أسماء المستخدمين
//   List<String> userNames = [];
//   String? selectedUser;

//   // 🔹 متغيرات الدفع
//   Map<String, String?> paymentTypes = {};
//   Map<String, TextEditingController> cashControllers = {};
//   Map<String, TextEditingController> visaControllers = {};
//   Map<String, double> totals = {};

//   // وضع البيع: 'كامل' او 'جزئي' لكل epc
//   Map<String, String> saleMode = {};

//   double totalCash = 0;
//   double totalVisa = 0;
//   double grandTotal = 0;

//   // Global (batch) payment controllers for multiple-item sales
//   TextEditingController globalCashController = TextEditingController();
//   TextEditingController globalVisaController = TextEditingController();
//   String? globalPaymentType;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   int _readerPower = 26; // القيمة الحالية
//   int _tempPower = 26; // قيمة السلايدر المؤقتة

//   // ✅ متغير للتحكم في ظهور زر بقايا الأطقم
//   bool _hasRemainingKits = false;

//   @override
//   void initState() {
//     super.initState();

//     _loadLanguage();
//     _loadUserNames();
//     _checkRemainingKits(); // ✅ التحقق من وجود بقايا أطقم

//     _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
//       final epc = tag;

//       final result = await FS.epcandcode(epc);

//       if (!epcs.contains(epc) &&
//           !epcs.contains(result?['epcHex']) &&
//           !epcs.contains(result?['qrCode'])) {
//         setState(() {
//           epcs.add(epc);
//           paymentTypes[epc] = null;
//           cashControllers[epc] = TextEditingController();
//           visaControllers[epc] = TextEditingController();
//           totals[epc] = 0;
//           saleMode[epc] = 'كامل';
//         });
//         _loadItemData(epc);
//       }
//     });
//     SeuicUhfService.open();
//   }

//   // ✅ دالة للتحقق من وجود بقايا أطقم
//   Future<void> _checkRemainingKits() async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) return;

//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('setRemainders')
//           .limit(1)
//           .get();

//       setState(() {
//         _hasRemainingKits = snapshot.docs.isNotEmpty;
//       });
//     } catch (e) {
//       print('❌ خطأ في التحقق من بقايا الأطقم: $e');
//       setState(() {
//         _hasRemainingKits = false;
//       });
//     }
//   }

//   // ✅ دالة لتحديث حالة بقايا الأطقم بعد العودة من الصفحة
//   Future<void> _refreshRemainingKitsStatus() async {
//     await _checkRemainingKits();
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

//   Future<void> _loadSavedReaderPower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');

//     if (powerJson != null) {
//       final Map<String, dynamic> pagePowers =
//           Map<String, dynamic>.from(json.decode(powerJson));

//       final savedPower = pagePowers['sales'];
//       if (savedPower != null) {
//         setState(() {
//           _readerPower = savedPower;
//           _tempPower = savedPower;
//         });

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

//                             await SeuicUhfService.setPower(_readerPower);

//                             final prefs = await SharedPreferences.getInstance();
//                             final powerJson = prefs.getString('pagePowers');
//                             Map<String, int> pagePowers = {};

//                             if (powerJson != null) {
//                               pagePowers =
//                                   Map<String, int>.from(json.decode(powerJson));
//                             }

//                             pagePowers['sales'] = _readerPower;
//                             await prefs.setString(
//                                 'pagePowers', json.encode(pagePowers));

//                             Navigator.pop(context);

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

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadUserNames() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userNames = prefs.getStringList('userNames') ?? [];
//       if (userNames.isNotEmpty) selectedUser = userNames.first;
//     });
//   }

//   Future<void> _initUhfAndSetPower() async {
//     try {
//       final opened = await SeuicUhfService.open();
//       if (!opened) {
//         print('⚠️ فشل في فتح UHF، محاولة مرة ثانية...');
//         await Future.delayed(const Duration(seconds: 1));
//         await SeuicUhfService.open();
//       }
//       await _setPagePower();
//     } catch (e) {
//       print('❌ خطأ في تهيئة UHF: $e');
//     }
//   }

//   Future<void> _setPagePower() async {
//     final prefs = await SharedPreferences.getInstance();
//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       final pagePowers = Map<String, int>.from(decoded);
//       final pagePower = pagePowers['sales'] ?? 26;

//       final success = await SeuicUhfService.setPower(pagePower);
//       if (success) {
//         print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
//       } else {
//         print('⚠️ فشل في ضبط القوة');
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _tagSubscription?.cancel();
//     for (final c in cashControllers.values) {
//       c.dispose();
//     }
//     for (final c in visaControllers.values) {
//       c.dispose();
//     }
//     globalCashController.dispose();
//     globalVisaController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadItemData(String epc) async {
//     try {
//       final data = await FS.findItemByEpc(epc);
//       setState(() {
//         itemsData[epc] = data;
//         if (data != null) {
//           final payload = data['payload'] ?? {};
//           final kind = (payload['kind'] ?? '').toString();
//           if (kind.contains('طقم') || kind.contains('طقم'.trim())) {
//             saleMode[epc] = saleMode[epc] ?? 'كامل';
//           } else {
//             saleMode[epc] = 'كامل';
//           }
//         }
//       });
//     } catch (e) {
//       setState(() {
//         itemsData[epc] = {"error": e.toString()};
//       });
//     }
//   }

//   void _calculateTotal(String epc) {
//     double cash = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//     double visa = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;
//     setState(() {
//       totals[epc] = cash + visa;
//       totalCash = cashControllers.values
//           .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values
//           .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });
//   }

//   Future<void> _sell() async {
//     if (epcs.isEmpty) {
//       setState(() => msg = _t("من فضلك اقرأ شريحة واحدة على الأقل",
//           "Please read at least one chip"));
//       return;
//     }

//     if (selectedUser == null || selectedUser!.isEmpty) {
//       setState(() => msg = _t(
//           "يرجى اضافة اسم المستخدم من الاعدادات وحفظ الاعدادات حتى تتمكن من البيع",
//           "Please add a username from settings and save settings before proceeding"));
//       return;
//     }

//     for (final epc in List<String>.from(epcs)) {
//       if (paymentTypes[epc] == null) {
//         setState(() {
//           msg = _t("⚠ اختر طريقة الدفع للشريحة $epc أولاً",
//               "⚠ Please select the payment method for tag $epc first");
//         });
//         return;
//       }
//       final paymentType = paymentTypes[epc];
//       final cashVal = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
//       final visaVal = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;

//       if (paymentType == "cash" && cashVal <= 0) {
//         setState(() {
//           msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//               "⚠ Enter the correct cash amount for tag $epc.");
//         });
//         return;
//       }

//       if (paymentType == "visa" && visaVal <= 0) {
//         setState(() {
//           msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//               "⚠ Enter the correct card amount for tag $epc.");
//         });
//         return;
//       }

//       if (paymentType == "multi") {
//         if (cashVal <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل مبلغ الكاش الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct cash amount for tag $epc.");
//           });
//           return;
//         }

//         if (visaVal <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل مبلغ الشبكة الصحيح للشريحة $epc.",
//                 "⚠ Enter the correct card amount for tag $epc.");
//           });
//           return;
//         }
//       }

//       if (saleMode[epc] == 'جزئي') {
//         final item = itemsData[epc];
//         if (item == null) {
//           setState(() {
//             msg = _t("خطأ: بيانات الشريحة $epc غير متاحة.",
//                 "Error: Data for tag $epc is not available.");
//           });
//           return;
//         }

//         final partialResult = item['_pendingPartial'];
//         if (partialResult == null) {
//           setState(() {
//             msg = _t(
//                 "⚠ من فضلك اضغط 'فتح البيع الجزئي' وأدخل التفاصيل قبل تسجيل البيع.",
//                 "⚠ Please press 'Open Partial Sale' and enter the details before recording the sale.");
//           });
//           return;
//         }

//         final weightSold = (partialResult['weightSold'] ?? 0).toDouble();
//         if (weightSold <= 0) {
//           setState(() {
//             msg = _t("⚠ أدخل وزن صحيح في البيع الجزئي للشريحة $epc.",
//                 "⚠ Enter a valid weight in the partial sale for tag $epc.");
//           });
//           return;
//         }
//       }
//     }

//     setState(() {
//       busy = true;
//       msg = null;
//     });

//     final saleGroupId = DateTime.now().millisecondsSinceEpoch.toString();
//     final hasSetItem = epcs.any((epc) {
//       final item = itemsData[epc];
//       final payload =
//           item != null ? Map<String, dynamic>.from(item['payload'] ?? {}) : {};
//       return (payload['kind'] ?? '').toString().contains('طقم');
//     });
//     if (hasSetItem) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             _t(
//               'تنبيه: يوجد طقم في البيع، تأكد من اختيار حالة البيع جزئي أو كامل لكل قطعة قبل التأكيد.',
//               'Note: a set item is included in the sale. Make sure to choose partial or full sale for each item before confirming.',
//             ),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }

//     try {
//       for (final epc in List<String>.from(epcs)) {
//         final paymentData = {
//           "type": paymentTypes[epc],
//           "cash": double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0,
//           "visa": double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0,
//           "total": totals[epc] ?? 0,
//           "soldBy": selectedUser,
//         };

//         if (saleMode[epc] == 'جزئي') {
//           final item = itemsData[epc];
//           final partialResult = item['_pendingPartial'];

//           final soldCompsRaw = partialResult['soldComponents'];
//           final soldComps = soldCompsRaw is List
//               ? soldCompsRaw.map((e) => e.toString()).toList()
//               : <String>[];

//           await FS.sellItem(
//             epc,
//             saleGroupId: saleGroupId,
//             partialSale: true,
//             soldComponents: soldComps,
//             weightSold: (partialResult['weightSold'] ?? 0).toDouble(),
//             wageSold: (partialResult['wageSold'] ?? 0).toDouble(),
//             paymentData: paymentData,
//           );

//           setState(() {
//             itemsData[epc].remove('_pendingPartial');
//           });

//           await _loadItemData(epc);

//           final updated = itemsData[epc];
//           final updatedPayload =
//               updated != null ? (updated['payload'] ?? {}) : {};
//           final updatedWeight = (updatedPayload['weight'] ?? 0).toString();
//           final hasComponents =
//               (updatedPayload['setComponents'] ?? []).isNotEmpty;
//           final weightZero = double.tryParse(updatedWeight.toString()) == 0;

//           if (!hasComponents || weightZero) {
//             setState(() {
//               epcs.remove(epc);
//               itemsData.remove(epc);
//               paymentTypes.remove(epc);
//               cashControllers.remove(epc);
//               visaControllers.remove(epc);
//               totals.remove(epc);
//               saleMode.remove(epc);
//             });
//           }
//         } else {
//           await _deleteItemImages(epc);
//           await FS.sellItem(epc,
//               saleGroupId: saleGroupId, paymentData: paymentData);
//           setState(() {
//             epcs.remove(epc);
//             itemsData.remove(epc);
//             paymentTypes.remove(epc);
//             cashControllers.remove(epc);
//             visaControllers.remove(epc);
//             totals.remove(epc);
//             saleMode.remove(epc);
//           });
//         }
//       }

//       setState(() {
//         msg = _t("✅ تم تنفيذ جميع عمليات البيع بنجاح بواسطة $selectedUser.",
//             "✅ All sales were successfully completed by $selectedUser.");

//         totalCash = cashControllers.values
//             .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         totalVisa = visaControllers.values
//             .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
//         grandTotal = totalCash + totalVisa;
//       });

//       await Future.delayed(const Duration(seconds: 1));

//       setState(() {
//         epcs.clear();
//         itemsData.clear();
//         paymentTypes.clear();
//         for (final c in cashControllers.values) {
//           c.dispose();
//         }
//         for (final c in visaControllers.values) {
//           c.dispose();
//         }
//         cashControllers.clear();
//         visaControllers.clear();
//         totals.clear();
//         saleMode.clear();
//         totalCash = 0;
//         totalVisa = 0;
//         grandTotal = 0;
//       });

//       // ✅ تحديث حالة بقايا الأطقم بعد البيع
//       await _checkRemainingKits();
//     } catch (e) {
//       setState(
//           () => msg = _t("فشل تسجيل البيع: $e", "Failed to record sale: $e"));
//     } finally {
//       if (!mounted) return;
//       setState(() => busy = false);
//     }
//   }

//   Future<void> _deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;

//       final sourceFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(epc.toUpperCase());

//       final salesFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child('sales')
//           .child(epc.toUpperCase());

//       final ListResult result = await sourceFolder.listAll();

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $epc');
//         return;
//       }

//       print('📦 نسخ ${result.items.length} صورة إلى مجلد المبيعات');

//       for (Reference sourceRef in result.items) {
//         try {
//           final Uint8List? bytes = await sourceRef.getData();

//           if (bytes == null) {
//             print('❌ لم يتم تحميل ${sourceRef.name}');
//             continue;
//           }

//           final destRef = salesFolder.child(sourceRef.name);
//           await destRef.putData(bytes);
//           print('✅ تم نسخ ${sourceRef.name}');
//           await sourceRef.delete();
//           print('🗑️ تم حذف ${sourceRef.name}');
//         } catch (e) {
//           print('❌ خطأ مع ${sourceRef.name}: $e');
//         }
//       }

//       print('✅ انتهت عملية النسخ والحذف');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//     }
//   }

//   void _applyGlobalDistribution() {
//     if (epcs.isEmpty) return;
//     if (globalPaymentType == null) {
//       showAppMessage(context,
//           _t('اختر طريقة دفع مجمّعة', 'Please select batch payment type'));
//       return;
//     }

//     final totalCashGlobal = double.tryParse(globalCashController.text) ?? 0;
//     final totalVisaGlobal = double.tryParse(globalVisaController.text) ?? 0;

//     if (totalCashGlobal <= 0 && totalVisaGlobal <= 0) {
//       showAppMessage(context,
//           _t('أدخل مبلغ كاش أو شبكة صحيح', 'Enter a valid cash or card total'));
//       return;
//     }

//     final Map<String, double> factors = {};
//     double sumFactors = 0;

//     for (final epc in epcs) {
//       final payload = itemsData[epc]?['payload'] ?? {};

//       double weight = 0;
//       if (saleMode[epc] == 'جزئي' &&
//           itemsData[epc]?['_pendingPartial'] != null) {
//         weight = double.tryParse(
//                 itemsData[epc]!['_pendingPartial']['weightSold']?.toString() ??
//                     '0') ??
//             0;
//       } else {
//         weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//       }

//       double carat = double.tryParse((payload['carat'] ?? 0).toString()) ?? 0;
//       double factor = weight * (carat > 0 ? carat : 1);
//       if (factor <= 0) factor = 1;
//       factors[epc] = factor;
//       sumFactors += factor;
//     }

//     if (sumFactors <= 0) sumFactors = epcs.length.toDouble();

//     for (final epc in epcs) {
//       final factor = factors[epc] ?? 1;
//       final cashShare = totalCashGlobal * factor / sumFactors;
//       final visaShare = totalVisaGlobal * factor / sumFactors;

//       setState(() {
//         paymentTypes[epc] = globalPaymentType;
//         cashControllers[epc]?.text = cashShare.toStringAsFixed(2);
//         visaControllers[epc]?.text = visaShare.toStringAsFixed(2);
//         _calculateTotal(epc);
//       });
//     }

//     setState(() {
//       totalCash = cashControllers.values
//           .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       totalVisa = visaControllers.values
//           .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
//       grandTotal = totalCash + totalVisa;
//     });

//     showAppMessage(
//         context,
//         _t('تم تطبيق الدفع المجمّع على كل القطع',
//             'Batch payment applied to all items'));
//   }

//   Future<Map<String, dynamic>?> _openPartialSaleDialog(
//       String epc, Map<String, dynamic> itemData) async {
//     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
//     final List<dynamic> setComponentsDynamic = payload['setComponents'] ?? [];
//     final List<String> components =
//         setComponentsDynamic.map((c) => c.toString()).toList();
//     double computedWage = 0;

//     final Map<String, bool> selected = {for (var c in components) c: false};
//     final weightController = TextEditingController();
//     final wageController = TextEditingController();

//     return showDialog<Map<String, dynamic>>(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) {
//         return StatefulBuilder(builder: (context, setStateDialog) {
//           return AlertDialog(
//             title: Text(_t("تفاصيل البيع الجزئي", "Partial Sale Details")),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (components.isEmpty)
//                     Text(_t("لا توجد مكونات في الطقم لعمل بيع جزئي.",
//                         "No components in the set for partial sale."))
//                   else
//                     Column(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             _t("اختر المكونات التي سيتم بيعها:",
//                                 "Select components to sell:"),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         SizedBox(
//                           height: 150,
//                           width: double.maxFinite,
//                           child: ListView.builder(
//                             itemCount: components.length,
//                             itemBuilder: (_, i) {
//                               final comp = components[i];
//                               return CheckboxListTile(
//                                 value: selected[comp],
//                                 title: Text(comp),
//                                 onChanged: (v) => setStateDialog(
//                                     () => selected[comp] = v ?? false),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: weightController,
//                     keyboardType:
//                         TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                           "الوزن المباع (جرام) - متاح: ${payload['weight'] ?? 'غير معروف'}",
//                           "Sold weight (g) - available: ${payload['weight'] ?? 'unknown'}"),
//                     ),
//                     onChanged: (value) {
//                       final weightSold = double.tryParse(value) ?? 0;
//                       final totalWeight = double.tryParse(
//                               (payload['weight'] ?? 0).toString()) ??
//                           0;
//                       final totalWage =
//                           double.tryParse((payload['wage'] ?? 0).toString()) ??
//                               0;

//                       if (weightSold > 0 && totalWeight > 0) {
//                         computedWage = totalWage * (weightSold / totalWeight);
//                         wageController.text = computedWage.toStringAsFixed(2);
//                       } else {
//                         wageController.text = "0";
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: wageController,
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     decoration: InputDecoration(
//                       labelText: _t(
//                         "الأجر المباع (قابل للتعديل) - متاح: ${payload['wage'] ?? '0'}",
//                         "Sold wage (editable) - available: ${payload['wage'] ?? '0'}",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   weightController.dispose();
//                   wageController.dispose();
//                   Navigator.of(ctx).pop(null);
//                 },
//                 child: Text(_t("إلغاء", "Cancel")),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   FocusScope.of(ctx).unfocus();
//                   await Future.delayed(const Duration(milliseconds: 100));

//                   final soldComps = selected.entries
//                       .where((e) => e.value)
//                       .map((e) => e.key)
//                       .toList();

//                   final weightSold =
//                       double.tryParse(weightController.text) ?? 0;
//                   final wageSold = double.tryParse(wageController.text) ?? 0;
//                   final availableWeight =
//                       double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
//                   final availableWage =
//                       double.tryParse((payload['wage'] ?? 0).toString()) ?? 0;

//                   if (weightSold <= 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("ادخل وزن صالح أكبر من صفر",
//                             "Enter a valid weight greater than zero"))));
//                     return;
//                   }
//                   if (weightSold > availableWeight) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الوزن المباع أكبر من الوزن المتاح",
//                             "Sold weight exceeds available weight"))));
//                     return;
//                   }
//                   if (wageSold < 0) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الأجر غير صحيح", "Invalid wage"))));
//                     return;
//                   }
//                   if (wageSold > availableWage) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
//                         content: Text(_t("الأجر المباع أكبر من الأجر المتاح",
//                             "Sold wage exceeds available wage"))));
//                     return;
//                   }

//                   final result = {
//                     'soldComponents': soldComps,
//                     'weightSold': weightSold,
//                     'wageSold': wageSold,
//                   };

//                   if (ctx.mounted) {
//                     Navigator.of(ctx).pop(result);
//                   }
//                 },
//                 child: Text(_t("تأكيد البيع الجزئي", "Confirm partial sale")),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   void _showFullImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.9),
//       builder: (_) => GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.all(10),
//           child: InteractiveViewer(
//             minScale: 0.8,
//             maxScale: 4,
//             child: Image.network(imageUrl, fit: BoxFit.contain),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItemCard(String epc, Map<String, dynamic>? itemData) {
//     if (itemData == null) return const SizedBox();
//     final payload = itemData['payload'] ?? {};
//     final epcHex = itemData['epcHex'].toString();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(Icons.qr_code, color: Colors.blue),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _t("المقروء: $epc", "Read: $epc"),
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   if (itemData['category'] == 'gold') ...[
//                     Row(children: [
//                       const Icon(Icons.workspace_premium,
//                           color: Color(0xFFD4AF37)),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: ذهب", "Category: Gold")),
//                     ]),
//                     Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
//                         "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                     Text(_t("النوع: ${payload['kind'] ?? 'غير محدد'}",
//                         "kind: ${payload['kind'] ?? 'Unknown'}")),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],
//                   if (itemData['category'] == 'gem') ...[
//                     Row(children: [
//                       const Icon(Icons.diamond, color: Colors.purple),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: أحجار كريمة", "Category: Gemstones")),
//                     ]),
//                     Text(_t("نوع الحجر: ${payload['type'] ?? 'غير محدد'}",
//                         "Type: ${payload['type'] ?? 'Unknown'}")),
//                     Text(_t("التكلفة: ${payload['cost'] ?? 'غير محدد'}",
//                         "Cost: ${payload['cost'] ?? 'Unknown'}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],
//                   if (itemData['category'] == 'scrap') ...[
//                     Row(children: [
//                       const Icon(Icons.recycling, color: Colors.green),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: كسر", "Category: Scrap")),
//                     ]),
//                     Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
//                         "Carat: ${payload['carat'] ?? 'Unknown'}")),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],
//                   if (itemData['category'] == 'bullion') ...[
//                     Row(children: [
//                       const Icon(Icons.workspace_premium,
//                           color: Color(0xFFD4AF37)),
//                       const SizedBox(width: 8),
//                       Text(_t("التصنيف: سبائك", "Category: Bullion")),
//                     ]),
//                     Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
//                         "Weight: ${payload['weight'] ?? 'Unknown'} g")),
//                     if (payload['wage'] != null)
//                       Text(_t("الأجر: ${payload['wage']}",
//                           "Wage: ${payload['wage']}")),
//                     Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
//                         "Code: ${payload['qrCode'] ?? 'Unknown'}")),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 1,
//               child: SizedBox(
//                 height: 140,
//                 child: FutureBuilder<List<String>>(
//                   future: () async {
//                     final uid = FirebaseAuth.instance.currentUser!.uid;
//                     final storageRef = FirebaseStorage.instance
//                         .ref()
//                         .child('images')
//                         .child('users')
//                         .child(uid)
//                         .child(epcHex);

//                     final result = await storageRef.listAll();
//                     return Future.wait(
//                         result.items.map((e) => e.getDownloadURL()));
//                   }(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2));
//                     }

//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(
//                         child: Text(
//                           _t('لا يوجد صور', 'No Images'),
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       );
//                     }

//                     return ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (_, i) => Padding(
//                         padding: const EdgeInsets.all(4),
//                         child: GestureDetector(
//                           onTap: () =>
//                               _showFullImage(context, snapshot.data![i]),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               snapshot.data![i],
//                               width: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//         if (payload['qrCode'] != null)
//           Center(
//             child: (payload['showQr'] == true)
//                 ? QrImageView(
//                     data: payload['qrCode'],
//                     version: QrVersions.auto,
//                     size: 100.0,
//                     backgroundColor: Colors.white,
//                   )
//                 : BarcodeWidget(
//                     barcode: Barcode.code128(),
//                     data: payload['qrCode'],
//                     width: 100,
//                     height: 40,
//                   ),
//           ),
//         const SizedBox(height: 16),
//         if ((payload['kind'] ?? '').toString().contains('طقم')) ...[
//           Row(
//             children: [
//               Text(_t("نوع البيع:", "Sale type:"),
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(width: 10),
//               DropdownButton<String>(
//                 value: saleMode[epc] ?? 'كامل',
//                 items: [
//                   DropdownMenuItem(
//                       value: 'كامل', child: Text(_t('بيع كامل', 'Full sale'))),
//                   DropdownMenuItem(
//                       value: 'جزئي',
//                       child: Text(_t('بيع جزئي', 'Partial sale'))),
//                 ],
//                 onChanged: (v) => setState(() => saleMode[epc] = v ?? 'كامل'),
//               ),
//               const SizedBox(width: 10),
//               if (saleMode[epc] == 'جزئي')
//                 ElevatedButton(
//                   onPressed: () async {
//                     final partialResult =
//                         await _openPartialSaleDialog(epc, itemData);
//                     if (partialResult != null) {
//                       setState(() {
//                         itemsData[epc] = {
//                           ...itemData,
//                           '_pendingPartial': partialResult,
//                         };
//                       });
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             _t('تم تحضير بيانات البيع الجزئي. اضغط "تسجيل عملية البيع" لإتمام العملية.',
//                                 'Partial sale data prepared. Press "Register Sale" to complete the process.'),
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                   child: Text(_t('فتح البيع الجزئي', 'Open partial sale')),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//         ],
//         Text(_t("اختر طريقة الدفع:", "Choose payment method:"),
//             style: const TextStyle(fontWeight: FontWeight.bold)),
//         DropdownButton<String>(
//           value: paymentTypes[epc],
//           hint: Text(_t("اختر نوع الدفع", "Select payment type")),
//           items: [
//             DropdownMenuItem(value: "cash", child: Text(_t("كاش", "Cash"))),
//             DropdownMenuItem(value: "visa", child: Text(_t("شبكة", "Card"))),
//             DropdownMenuItem(
//                 value: "multi", child: Text(_t("متعدد", "Multiple"))),
//           ],
//           onChanged: (val) => setState(() => paymentTypes[epc] = val),
//         ),
//         if (paymentTypes[epc] == "cash" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: cashControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration:
//                 InputDecoration(labelText: _t("مبلغ الكاش", "Cash amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] == "visa" || paymentTypes[epc] == "multi")
//           TextField(
//             controller: visaControllers[epc],
//             keyboardType: TextInputType.number,
//             decoration:
//                 InputDecoration(labelText: _t("مبلغ الشبكة", "Card amount")),
//             onChanged: (_) => _calculateTotal(epc),
//           ),
//         if (paymentTypes[epc] != null)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: Text(
//               _t("الإجمالي", "Total") + ": ${totals[epc] ?? 0}",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//         if (totals[epc] != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Text(
//               _t("سعر القطعة:", "Piece price:") + " ${totals[epc] ?? 0}",
//               style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87),
//             ),
//           ),
//         const Divider(),
//       ],
//     );
//   }

//   void _addEpc(String epc) async {
//     if (epc.isEmpty) return;
//     final result = await FS.epcandcode(epc);
//     print(epcs);

//     if (epcs.contains(epc) &&
//         epcs.contains(epc.trim().toUpperCase()) &&
//         epcs.contains(result?['epcHex']) &&
//         epcs.contains(result?['qrCode'])) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(_t("تمت اضافة الشريحة من قبل", "Tag already added"))),
//       );
//       return;
//     }

//     setState(() {
//       epcs.add(epc);
//       paymentTypes[epc] = null;
//       cashControllers[epc] = TextEditingController();
//       visaControllers[epc] = TextEditingController();
//       totals[epc] = 0;
//       saleMode[epc] = 'كامل';
//     });

//     _loadItemData(epc);
//   }

//   void _showManualEpcDialog() {
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

//   void AddEpcManualy(String Epc) {
//     SeuicUhfService.addEpcManualy(Epc);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("صفحة البيع", "Sales Page")),
//         backgroundColor: const Color(0xFFD4AF37),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.history),
//             tooltip: _t("سجل البيع", "Sales History"),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => const SalesHistoryPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFD4AF37),
//         onPressed: _showManualEpcDialog,
//         child: const Icon(Icons.add),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             if (userNames.isNotEmpty) ...[
//               Text(
//                 _t("اختر اسم المستخدم:", "Select User:"),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               DropdownButton<String>(
//                 value: selectedUser,
//                 isExpanded: true,
//                 hint: Text(_t("اختر المستخدم", "Select User")),
//                 items: userNames.map((name) {
//                   return DropdownMenuItem(value: name, child: Text(name));
//                 }).toList(),
//                 onChanged: (val) => setState(() => selectedUser = val),
//               ),
//               const Divider(),
//             ],

//             for (final epc in epcs) _buildItemCard(epc, itemsData[epc]),

//             if (epcs.length > 1) ...[
//               const SizedBox(height: 12),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   _t('الدفع المجمّع (تطبيق مرة واحدة على كل القطع)',
//                       'Batch payment (apply once for all items)'),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               DropdownButton<String>(
//                 value: globalPaymentType,
//                 hint: Text(
//                     _t('اختر نوع الدفع المجمّع', 'Select batch payment type')),
//                 items: [
//                   DropdownMenuItem(
//                       value: 'cash', child: Text(_t('كاش', 'Cash'))),
//                   DropdownMenuItem(
//                       value: 'visa', child: Text(_t('شبكة', 'Card'))),
//                   DropdownMenuItem(
//                       value: 'multi', child: Text(_t('متعدد', 'Multiple'))),
//                 ],
//                 onChanged: (v) => setState(() => globalPaymentType = v),
//               ),
//               if (globalPaymentType == 'cash' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalCashController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(
//                       labelText: _t('مجموع الكاش للقطع كلها',
//                           'Total cash for all items')),
//                 ),
//               if (globalPaymentType == 'visa' || globalPaymentType == 'multi')
//                 TextField(
//                   controller: globalVisaController,
//                   keyboardType: TextInputType.numberWithOptions(decimal: true),
//                   decoration: InputDecoration(
//                       labelText: _t('مجموع الشبكة للقطع كلها',
//                           'Total card for all items')),
//                 ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _applyGlobalDistribution,
//                       child: Text(_t('تطبيق على الكل', 'Apply to all')),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             if (epcs.isNotEmpty) ...[
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       Text(_t("الكاش", "Cash"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalCash", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(_t("الشبكة", "Visa"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$totalVisa", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Text(_t("الإجمالي", "Total"),
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       Text("$grandTotal", style: const TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ],
//               ),
//               const Divider(),
//             ],

//             // ✅ زر تسجيل عملية البيع
//             ElevatedButton.icon(
//               onPressed: busy ? null : _sell,
//               icon: const Icon(Icons.sell, color: Colors.white),
//               label: Text(_t("تسجيل عملية البيع", "Register Sale")),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),

//             // ✅ زر بقايا الأطقم (يظهر فقط لو فيه بقايا أطقم)
//             if (_hasRemainingKits) ...[
//               const SizedBox(height: 12),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () async {
//                     // ✅ نفتح الصفحة ونستنى النتيجة
//                     final result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const RemainingKitsPage(),
//                       ),
//                     );
//                     // ✅ بعد الرجوع من الصفحة، نحدث الحالة
//                     await _checkRemainingKits();
//                   },
//                   icon: const Icon(Icons.inventory_2_outlined,
//                       color: Colors.white),
//                   label: Text(
//                     _t("بقايا الأطقم", "Set Remainders"),
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD4AF37),
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                 ),
//               ),
//             ],

//             if (msg != null) ...[
//               const SizedBox(height: 20),
//               Text(
//                 msg!,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: msg!.contains(_t("نجاح", "Success"))
//                       ? Colors.green
//                       : Colors.red,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'sales_history_page.dart';

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

  // وضع البيع: 'كامل' او 'جزئي' لكل epc
  Map<String, String> saleMode = {};

  double totalCash = 0;
  double totalVisa = 0;
  double grandTotal = 0;

  // Global (batch) payment controllers for multiple-item sales
  TextEditingController globalCashController = TextEditingController();
  TextEditingController globalVisaController = TextEditingController();
  String? globalPaymentType;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  int _readerPower = 26; // القيمة الحالية
  int _tempPower = 26; // قيمة السلايدر المؤقتة

  @override
  void initState() {
    super.initState();

    _loadLanguage();
    _loadUserNames();

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
          saleMode[epc] = 'كامل';
        });
        _loadItemData(epc);
      }
    });
    SeuicUhfService.open();
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

  Future<void> _initUhfAndSetPower() async {
    try {
      final opened = await SeuicUhfService.open();
      if (!opened) {
        print('⚠️ فشل في فتح UHF، محاولة مرة ثانية...');
        await Future.delayed(const Duration(seconds: 1));
        await SeuicUhfService.open();
      }
      await _setPagePower();
    } catch (e) {
      print('❌ خطأ في تهيئة UHF: $e');
    }
  }

  Future<void> _setPagePower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');
    if (powerJson != null) {
      final decoded = json.decode(powerJson);
      final pagePowers = Map<String, int>.from(decoded);
      final pagePower = pagePowers['sales'] ?? 26;

      final success = await SeuicUhfService.setPower(pagePower);
      if (success) {
        print('✅ قوة القارئ تم ضبطها على: $pagePower dBm');
      } else {
        print('⚠️ فشل في ضبط القوة');
      }
    }
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

  Future<void> _loadItemData(String epc) async {
    try {
      final data = await FS.findItemByEpc(epc);
      setState(() {
        itemsData[epc] = data;
        if (data != null) {
          final payload = data['payload'] ?? {};
          final kind = (payload['kind'] ?? '').toString();
          if (kind.contains('طقم') || kind.contains('طقم'.trim())) {
            saleMode[epc] = saleMode[epc] ?? 'كامل';
          } else {
            saleMode[epc] = 'كامل';
          }
        }
      });
    } catch (e) {
      setState(() {
        itemsData[epc] = {"error": e.toString()};
      });
    }
  }

  void _calculateTotal(String epc) {
    double cash = double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0;
    double visa = double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0;
    setState(() {
      totals[epc] = cash + visa;
      totalCash = cashControllers.values
          .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
      totalVisa = visaControllers.values
          .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
      grandTotal = totalCash + totalVisa;
    });
  }

  Future<void> _sell() async {
    if (epcs.isEmpty) {
      setState(() => msg = _t("من فضلك اقرأ شريحة واحدة على الأقل",
          "Please read at least one chip"));
      return;
    }

    if (selectedUser == null || selectedUser!.isEmpty) {
      setState(() => msg = _t(
          "يرجى اضافة اسم المستخدم من الاعدادات وحفظ الاعدادات حتى تتمكن من البيع",
          "Please add a username from settings and save settings before proceeding"));
      return;
    }

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
          content: Text(
            _t(
              'تنبيه: يوجد طقم في البيع، تأكد من اختيار حالة البيع جزئي أو كامل لكل قطعة قبل التأكيد.',
              'Note: a set item is included in the sale. Make sure to choose partial or full sale for each item before confirming.',
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    try {
      for (final epc in List<String>.from(epcs)) {
        final paymentData = {
          "type": paymentTypes[epc],
          "cash": double.tryParse(cashControllers[epc]?.text ?? "0") ?? 0,
          "visa": double.tryParse(visaControllers[epc]?.text ?? "0") ?? 0,
          "total": totals[epc] ?? 0,
          "soldBy": selectedUser,
        };

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

          await _loadItemData(epc);

          final updated = itemsData[epc];
          final updatedPayload =
              updated != null ? (updated['payload'] ?? {}) : {};
          final updatedWeight = (updatedPayload['weight'] ?? 0).toString();
          final hasComponents =
              (updatedPayload['setComponents'] ?? []).isNotEmpty;
          final weightZero = double.tryParse(updatedWeight.toString()) == 0;

          if (!hasComponents || weightZero) {
            setState(() {
              epcs.remove(epc);
              itemsData.remove(epc);
              paymentTypes.remove(epc);
              cashControllers.remove(epc);
              visaControllers.remove(epc);
              totals.remove(epc);
              saleMode.remove(epc);
            });
          }
        } else {
          await _deleteItemImages(epc);
          await FS.sellItem(epc,
              saleGroupId: saleGroupId, paymentData: paymentData);
          setState(() {
            epcs.remove(epc);
            itemsData.remove(epc);
            paymentTypes.remove(epc);
            cashControllers.remove(epc);
            visaControllers.remove(epc);
            totals.remove(epc);
            saleMode.remove(epc);
          });
        }
      }

      setState(() {
        msg = _t("✅ تم تنفيذ جميع عمليات البيع بنجاح بواسطة $selectedUser.",
            "✅ All sales were successfully completed by $selectedUser.");

        totalCash = cashControllers.values
            .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
        totalVisa = visaControllers.values
            .fold(0, (sum, c) => sum + (double.tryParse(c.text) ?? 0));
        grandTotal = totalCash + totalVisa;
      });

      await Future.delayed(const Duration(seconds: 1));

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
        saleMode.clear();
        totalCash = 0;
        totalVisa = 0;
        grandTotal = 0;
      });
    } catch (e) {
      setState(
          () => msg = _t("فشل تسجيل البيع: $e", "Failed to record sale: $e"));
    } finally {
      if (!mounted) return;
      setState(() => busy = false);
    }
  }

  Future<void> _deleteItemImages(String epc) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final sourceFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(epc.toUpperCase());

      final salesFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child('sales')
          .child(epc.toUpperCase());

      final ListResult result = await sourceFolder.listAll();

      if (result.items.isEmpty) {
        print('ℹ️ لا توجد صور للشريحة $epc');
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
          print('✅ تم نسخ ${sourceRef.name}');
          await sourceRef.delete();
          print('🗑️ تم حذف ${sourceRef.name}');
        } catch (e) {
          print('❌ خطأ مع ${sourceRef.name}: $e');
        }
      }

      print('✅ انتهت عملية النسخ والحذف');
    } catch (e) {
      print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
    }
  }

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
      final payload = itemsData[epc]?['payload'] ?? {};

      double weight = 0;
      if (saleMode[epc] == 'جزئي' &&
          itemsData[epc]?['_pendingPartial'] != null) {
        weight = double.tryParse(
                itemsData[epc]!['_pendingPartial']['weightSold']?.toString() ??
                    '0') ??
            0;
      } else {
        weight = double.tryParse((payload['weight'] ?? 0).toString()) ?? 0;
      }

      double carat = double.tryParse((payload['carat'] ?? 0).toString()) ?? 0;
      double factor = weight * (carat > 0 ? carat : 1);
      if (factor <= 0) factor = 1;
      factors[epc] = factor;
      sumFactors += factor;
    }

    if (sumFactors <= 0) sumFactors = epcs.length.toDouble();

    for (final epc in epcs) {
      final factor = factors[epc] ?? 1;
      final cashShare = totalCashGlobal * factor / sumFactors;
      final visaShare = totalVisaGlobal * factor / sumFactors;

      setState(() {
        paymentTypes[epc] = globalPaymentType;
        cashControllers[epc]?.text = cashShare.toStringAsFixed(2);
        visaControllers[epc]?.text = visaShare.toStringAsFixed(2);
        _calculateTotal(epc);
      });
    }

    setState(() {
      totalCash = cashControllers.values
          .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
      totalVisa = visaControllers.values
          .fold(0, (s, c) => s + (double.tryParse(c.text) ?? 0));
      grandTotal = totalCash + totalVisa;
    });

    showAppMessage(
        context,
        _t('تم تطبيق الدفع المجمّع على كل القطع',
            'Batch payment applied to all items'));
  }

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
                        TextInputType.numberWithOptions(decimal: true),
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

                  if (ctx.mounted) {
                    Navigator.of(ctx).pop(result);
                  }
                },
                child: Text(_t("تأكيد البيع الجزئي", "Confirm partial sale")),
              ),
            ],
          );
        });
      },
    );
  }

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

  Widget _buildItemCard(String epc, Map<String, dynamic>? itemData) {
    if (itemData == null) return const SizedBox();
    final payload = itemData['payload'] ?? {};
    final epcHex = itemData['epcHex'].toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      const Icon(Icons.qr_code, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _t("المقروء: $epc", "Read: $epc"),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (itemData['category'] == 'gold') ...[
                    Row(children: [
                      const Icon(Icons.workspace_premium,
                          color: Color(0xFFD4AF37)),
                      const SizedBox(width: 8),
                      Text(_t("التصنيف: ذهب", "Category: Gold")),
                    ]),
                    Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
                        "Carat: ${payload['carat'] ?? 'Unknown'}")),
                    Text(_t("النوع: ${payload['kind'] ?? 'غير محدد'}",
                        "kind: ${payload['kind'] ?? 'Unknown'}")),
                    Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
                        "Weight: ${payload['weight'] ?? 'Unknown'} g")),
                    if (payload['wage'] != null)
                      Text(_t("الأجر: ${payload['wage']}",
                          "Wage: ${payload['wage']}")),
                    Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
                        "Code: ${payload['qrCode'] ?? 'Unknown'}")),
                  ],
                  if (itemData['category'] == 'gem') ...[
                    Row(children: [
                      const Icon(Icons.diamond, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(_t("التصنيف: أحجار كريمة", "Category: Gemstones")),
                    ]),
                    Text(_t("نوع الحجر: ${payload['type'] ?? 'غير محدد'}",
                        "Type: ${payload['type'] ?? 'Unknown'}")),
                    Text(_t("التكلفة: ${payload['cost'] ?? 'غير محدد'}",
                        "Cost: ${payload['cost'] ?? 'Unknown'}")),
                    Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
                        "Code: ${payload['qrCode'] ?? 'Unknown'}")),
                  ],
                  if (itemData['category'] == 'scrap') ...[
                    Row(children: [
                      const Icon(Icons.recycling, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(_t("التصنيف: كسر", "Category: Scrap")),
                    ]),
                    Text(_t("العيار: ${payload['carat'] ?? 'غير محدد'}",
                        "Carat: ${payload['carat'] ?? 'Unknown'}")),
                    Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
                        "Weight: ${payload['weight'] ?? 'Unknown'} g")),
                    if (payload['wage'] != null)
                      Text(_t("الأجر: ${payload['wage']}",
                          "Wage: ${payload['wage']}")),
                    Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
                        "Code: ${payload['qrCode'] ?? 'Unknown'}")),
                  ],
                  if (itemData['category'] == 'bullion') ...[
                    Row(children: [
                      const Icon(Icons.workspace_premium,
                          color: Color(0xFFD4AF37)),
                      const SizedBox(width: 8),
                      Text(_t("التصنيف: سبائك", "Category: Bullion")),
                    ]),
                    Text(_t("الوزن: ${payload['weight'] ?? 'غير محدد'} جرام",
                        "Weight: ${payload['weight'] ?? 'Unknown'} g")),
                    if (payload['wage'] != null)
                      Text(_t("الأجر: ${payload['wage']}",
                          "Wage: ${payload['wage']}")),
                    Text(_t("الكود: ${payload['qrCode'] ?? 'غير محدد'}",
                        "Code: ${payload['qrCode'] ?? 'Unknown'}")),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 140,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          _t('لا يوجد صور', 'No Images'),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: () =>
                              _showFullImage(context, snapshot.data![i]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              snapshot.data![i],
                              width: 100,
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
        if (payload['qrCode'] != null)
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
        const SizedBox(height: 16),
        if ((payload['kind'] ?? '').toString().contains('طقم')) ...[
          Row(
            children: [
              Text(_t("نوع البيع:", "Sale type:"),
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: saleMode[epc] ?? 'كامل',
                items: [
                  DropdownMenuItem(
                      value: 'كامل', child: Text(_t('بيع كامل', 'Full sale'))),
                  DropdownMenuItem(
                      value: 'جزئي',
                      child: Text(_t('بيع جزئي', 'Partial sale'))),
                ],
                onChanged: (v) => setState(() => saleMode[epc] = v ?? 'كامل'),
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
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _t('تم تحضير بيانات البيع الجزئي. اضغط "تسجيل عملية البيع" لإتمام العملية.',
                                'Partial sale data prepared. Press "Register Sale" to complete the process.'),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(_t('فتح البيع الجزئي', 'Open partial sale')),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Text(_t("اختر طريقة الدفع:", "Choose payment method:"),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: paymentTypes[epc],
          hint: Text(_t("اختر نوع الدفع", "Select payment type")),
          items: [
            DropdownMenuItem(value: "cash", child: Text(_t("كاش", "Cash"))),
            DropdownMenuItem(value: "visa", child: Text(_t("شبكة", "Card"))),
            DropdownMenuItem(
                value: "multi", child: Text(_t("متعدد", "Multiple"))),
          ],
          onChanged: (val) => setState(() => paymentTypes[epc] = val),
        ),
        if (paymentTypes[epc] == "cash" || paymentTypes[epc] == "multi")
          TextField(
            controller: cashControllers[epc],
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: _t("مبلغ الكاش", "Cash amount")),
            onChanged: (_) => _calculateTotal(epc),
          ),
        if (paymentTypes[epc] == "visa" || paymentTypes[epc] == "multi")
          TextField(
            controller: visaControllers[epc],
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(labelText: _t("مبلغ الشبكة", "Card amount")),
            onChanged: (_) => _calculateTotal(epc),
          ),
        if (paymentTypes[epc] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "${_t("الإجمالي", "Total")}: ${totals[epc] ?? 0}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        if (totals[epc] != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "${_t("سعر القطعة:", "Piece price:")} ${totals[epc] ?? 0}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ),
        const Divider(),
      ],
    );
  }

  void _addEpc(String epc) async {
    if (epc.isEmpty) return;
    final result = await FS.epcandcode(epc);
    print(epcs);

    if (epcs.contains(epc) &&
        epcs.contains(epc.trim().toUpperCase()) &&
        epcs.contains(result?['epcHex']) &&
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("صفحة البيع", "Sales Page")),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: _t("سجل البيع", "Sales History"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SalesHistoryPage(),
                ),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (userNames.isNotEmpty) ...[
              Text(
                _t("اختر اسم المستخدم:", "Select User:"),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: selectedUser,
                isExpanded: true,
                hint: Text(_t("اختر المستخدم", "Select User")),
                items: userNames.map((name) {
                  return DropdownMenuItem(value: name, child: Text(name));
                }).toList(),
                onChanged: (val) => setState(() => selectedUser = val),
              ),
              const Divider(),
            ],

            for (final epc in epcs) _buildItemCard(epc, itemsData[epc]),

            if (epcs.length > 1) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _t('الدفع المجمّع (تطبيق مرة واحدة على كل القطع)',
                      'Batch payment (apply once for all items)'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: globalPaymentType,
                hint: Text(
                    _t('اختر نوع الدفع المجمّع', 'Select batch payment type')),
                items: [
                  DropdownMenuItem(
                      value: 'cash', child: Text(_t('كاش', 'Cash'))),
                  DropdownMenuItem(
                      value: 'visa', child: Text(_t('شبكة', 'Card'))),
                  DropdownMenuItem(
                      value: 'multi', child: Text(_t('متعدد', 'Multiple'))),
                ],
                onChanged: (v) => setState(() => globalPaymentType = v),
              ),
              if (globalPaymentType == 'cash' || globalPaymentType == 'multi')
                TextField(
                  controller: globalCashController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: _t('مجموع الكاش للقطع كلها',
                          'Total cash for all items')),
                ),
              if (globalPaymentType == 'visa' || globalPaymentType == 'multi')
                TextField(
                  controller: globalVisaController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: _t('مجموع الشبكة للقطع كلها',
                          'Total card for all items')),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyGlobalDistribution,
                      child: Text(_t('تطبيق على الكل', 'Apply to all')),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],

            if (epcs.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(_t("الكاش", "Cash"),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("$totalCash", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_t("الشبكة", "Visa"),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("$totalVisa", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_t("الإجمالي", "Total"),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("$grandTotal", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const Divider(),
            ],

            // ✅ زر تسجيل عملية البيع
            ElevatedButton.icon(
              onPressed: busy ? null : _sell,
              icon: const Icon(Icons.sell, color: Colors.white),
              label: Text(_t("تسجيل عملية البيع", "Register Sale")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            if (msg != null) ...[
              const SizedBox(height: 20),
              Text(
                msg!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: msg!.contains(_t("نجاح", "Success"))
                      ? Colors.green
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
