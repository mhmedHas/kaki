// // import 'package:flutter/material.dart';
// // import '../services/firestore_service.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:dio/dio.dart';
// // //import 'package:gal/gal.dart';
// // import 'dart:typed_data';
// // //import 'package:permission_handler/permission_handler.dart';

// // class GeneralBalancePage extends StatefulWidget {
// //   const GeneralBalancePage({super.key});

// //   @override
// //   State<GeneralBalancePage> createState() => _GeneralBalancePageState();
// // }

// // class _GeneralBalancePageState extends State<GeneralBalancePage> {
// //   bool loading = true;

// //   double totalWeight = 0;
// //   Map<int, double> caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};

// //   int stonesCount = 0;
// //   int BullionCount = 0;
// //   double stonesCost = 0;
// //   double BullionWeight = 0;

// //   double scrapWeight = 0;
// //   double supply = 0;
// //   double import = 0;
// //   double supplycash = 0;
// //   double importcash = 0;
// //   double supplyvisa = 0;
// //   double importvisa = 0;
// //   double balancesWeight = 0;
// //   int balancesCount = 0;

// //   double total = 0.0;
// //   double cashtotal = 0.0;
// //   double visatotal = 0.0;
// //   int lostItemsCount = 0;

// //   int missing_18 = 0;
// //   int missing_21 = 0;
// //   int missing_22 = 0;
// //   int missing_Gem = 0;
// //   int missing_Bullion = 0;
// //   List<String> missingEpcs = [];
// //   bool isLoadingImages = false;
// //   List<String> allMissingImageUrls = [];
// //   Map<String, int> deptCount = {};

// //   double missingwage_18 = 0,
// //       missing_wage21 = 0,
// //       missing_wage22 = 0,
// //       missing_wagebullion = 0,
// //       missing_costgem = 0;
// //   double missingweight_18 = 0,
// //       missing_weight21 = 0,
// //       missing_weight22 = 0,
// //       missing_weightbullion = 0;

// //   // Deleted items tracking
// //   int deletedGoldCount = 0;
// //   int deletedGemCount = 0;
// //   int deletedBullionCount = 0;
// //   double deletedGoldWeight = 0;
// //   double deletedGoldWage = 0;
// //   double deletedGemCost = 0;
// //   double deletedBullionWeight = 0;
// //   double deletedBullionWage = 0;
// //   List<Map<String, dynamic>> deletedItems = [];
// //   bool showLostDetails = false;
// //   bool showSuppliers = false;
// //   double expenses_Month = 0;

// //   List<Map<String, dynamic>> suppliers = [];
// //   List<Map<String, dynamic>> AllMissingTags = [];

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
// //   Map<String, List<Map<String, dynamic>>> lostItemsByCategory = {
// //     'gold': [],
// //     'gem': [],
// //     'bullion': [],
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //     _loadData();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _lang = prefs.getString('languageCode') ?? 'ar';
// //   }
// //   /*Future<Map<int, double>> fetchGoldPrices() async {
// //     final res = await http.get(
// //       Uri.parse(
// //         'https://goldprices-usqjvutvvq-uc.a.run.app',
// //       ),
// //     );

// //     print('STATUS: ${res.statusCode}');
// //     print('BODY: ${res.body}');

// //     if (res.statusCode != 200) {
// //       return {18: 0, 21: 0, 22: 0, 24: 0};
// //     }

// //     final data = jsonDecode(res.body);

// //     return {
// //       18: (data['g18'] as num).toDouble(),
// //       21: (data['g21'] as num).toDouble(),
// //       22: (data['g22'] as num).toDouble(),
// //       24: (data['g24'] as num).toDouble(),
// //     };
// //   }*/

// //   // 🔵 نفس دالة _loadData بتاعتك بدون أي تعديل
// //   Future<void> _loadData() async {
// //     double sum = 0.0;
// //     double cash = 0.0;
// //     double visa = 0.0;
// //     balancesWeight = 0;
// //     balancesCount = 0;
// //     List<Map<String, dynamic>> all = [];

// //     final itemsSnap = await FS.itemsCol().get();
// //     final balancesSnap = await FS.balancesCol().get();
// //     balancesCount = balancesSnap.docs.length;
// //     Map<String, int> tempCounts = {};
// //     final allInventoryDocs = [...itemsSnap.docs, ...balancesSnap.docs];

// //     for (var doc in allInventoryDocs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final payload = Map<String, dynamic>.from(data['payload'] ?? {});
// //       final isBalance = doc.reference.parent.id == 'balances';
// //       final weight = (payload['weight'] ?? 0).toDouble();
// //       if (isBalance) balancesWeight += weight;

// //       final carat = int.tryParse(payload['carat']?.toString() ?? '');
// //       final kind = payload['kind']?.toString();
// //       final type = payload['type']?.toString();
// //       if (data['category'] == "bullion") {
// //         tempCounts['سبائك'] = (tempCounts['سبائك'] ?? 0) + 1;
// //       }

// //       if (kind != null) {
// //         tempCounts[kind] = (tempCounts[kind] ?? 0) + 1;
// //       }

// //       if (type != null) {
// //         tempCounts[type] = (tempCounts[type] ?? 0) + 1;
// //       }

// //       if (caratWeight.containsKey(carat)) {
// //         caratWeight[carat!] = caratWeight[carat]! + weight;
// //         totalWeight += weight;
// //       }

// //       if (data['category'] == 'gem') {
// //         stonesCount += 1;
// //         stonesCost += (payload['cost'] ?? 0).toDouble();
// //       }
// //       if (data['category'] == 'bullion') {
// //         BullionCount += 1;
// //         BullionWeight += (payload['weight'] ?? 0).toDouble();
// //       }
// //     }

// //     // 🟢 بيع القطع
// //     final salesSnap = await FS.salesCol().get();
// //     for (var d in salesSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final wage = (data['payment']?['total'] ?? 0).toDouble();
// //       final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
// //       final date = (data['createdAt'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("بيع قطعة", "Piece Sale"),
// //         "value": wage,
// //         "date": date,
// //         "data": data,
// //       });
// //       sum += wage;
// //       cash += totalcash;
// //       visa += totalvisa;
// //     }

// //     // 🟢 بيع كسر
// //     final scrapSnap =
// //         await FS.scrapCol().where("type", isEqualTo: "sale").get();
// //     for (var d in scrapSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final wage = (data['total'] ?? 0).toDouble();
// //       final totalcash = (data['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['network'] ?? 0).toDouble();
// //       final date = (data['date'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("بيع كسر", "Scrap Sale"),
// //         "value": wage,
// //         "date": date,
// //         "data": data,
// //       });
// //       sum += wage;
// //       cash += totalcash;
// //       visa += totalvisa;
// //       scrapWeight -= (data['weight'] ?? 0).toDouble();
// //     }

// //     // 🔴 شراء كسر
// //     final scrapBuySnap =
// //         await FS.scrapCol().where("type", isEqualTo: "add").get();
// //     for (var d in scrapBuySnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final wage = (data['total'] ?? 0).toDouble();
// //       final totalcash = (data['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['network'] ?? 0).toDouble();
// //       final date = (data['date'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("شراء كسر", "Scrap Purchase"),
// //         "value": -wage,
// //         "date": date,
// //         "data": data,
// //       });
// //       sum -= wage;
// //       cash -= totalcash;
// //       visa -= totalvisa;
// //       scrapWeight += (data['weight'] ?? 0).toDouble();
// //     }

// //     // 🔴 سندات الصرف
// //     final vouchersSnap =
// //         await FS.vouchersCol().where("type", isEqualTo: "payment").get();
// //     for (var d in vouchersSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final wage = (data['total'] ?? 0).toDouble();
// //       final totalcash = (data['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['network'] ?? 0).toDouble();
// //       final date = (data['date'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("سند صرف", "Payment Voucher"),
// //         "value": -wage,
// //         "date": date,
// //         "data": data,
// //       });
// //       sum -= wage;
// //       cash -= totalcash;
// //       visa -= totalvisa;
// //     }

// //     // 🔴 المصروفات
// //     final now = DateTime.now();
// //     final currentMonth = now.month;
// //     final currentYear = now.year;
// //     final expSnap = await FS.expensesCol().get();
// //     for (var d in expSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
// //       final date = (data['date'] as Timestamp?)?.toDate();

// //       final displayType = _t('مصروف', 'Expense');
// //       all.add({
// //         "type": displayType,
// //         "value": -amount,
// //         "date": date,
// //         "data": data,
// //       });
// //       // ✅ حساب مصروفات الشهر الحالي فقط
// //       if (date != null &&
// //           date.month == currentMonth &&
// //           date.year == currentYear) {
// //         expenses_Month += amount;
// //       }
// //       sum -= amount;
// //       cash -= amount;
// //     }

// //     // 🔵 توريد للإدارة
// //     final depositSnap = await FS.depositsCol().get();
// //     for (var d in depositSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final totalcash = (data['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['visa'] ?? 0).toDouble();
// //       final totalValue = totalcash + totalvisa;
// //       final date = (data['date'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("توريد للإدارة", "Deposit to Admin"),
// //         "value": -totalValue,
// //         "date": date,
// //         "data": data,
// //       });
// //       if (date != null &&
// //           date.month == currentMonth &&
// //           date.year == currentYear) {
// //         supply += totalValue;
// //         supplycash += totalcash;
// //         supplyvisa += totalvisa;
// //       }
// //       sum -= totalValue;
// //       cash -= totalcash;
// //       visa -= totalvisa;
// //     }
// //     // 🔵 استيراد من الإدارة
// //     final ImportSnap = await FS.ImportedCol().get();
// //     for (var d in ImportSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final totalcash = (data['cash'] ?? 0).toDouble();
// //       final totalvisa = (data['visa'] ?? 0).toDouble();
// //       final totalValue = totalcash + totalvisa;
// //       final date = (data['date'] as Timestamp?)?.toDate();
// //       all.add({
// //         "type": _t("استيراد من الإدارة", "Import from Admin"),
// //         "value": totalValue,
// //         "date": date,
// //         "data": data,
// //       });
// //       if (date != null &&
// //           date.month == currentMonth &&
// //           date.year == currentYear) {
// //         import += totalValue;
// //         importcash += totalcash;
// //         importvisa += totalvisa;
// //       }
// //       sum += totalValue;
// //       cash += totalcash;
// //       visa += totalvisa;
// //     }

// //     int missingCount = 0;
// //     int missing18 = 0;
// //     int missing21 = 0;
// //     int missing22 = 0;
// //     int missingGem = 0;
// //     int missingBullion = 0;

// //     double missingwage18 = 0,
// //         missingwage21 = 0,
// //         missingwage22 = 0,
// //         missingwagebullion = 0,
// //         missingcostgem = 0;
// //     double missingweight18 = 0,
// //         missingweight21 = 0,
// //         missingweight22 = 0,
// //         missingweightbullion = 0;

// //     // 🟡 inventories = المخزون الحالي (اللي مقروء فعليًا)
// //     final inventoriesSnap = await FS.invCol().get();

// //     // 🟡 IDs الموجودة في المخزون
// //     final invIds = inventoriesSnap.docs.map((d) {
// //       final data = d.data() as Map<String, dynamic>;
// //       return data['epcHex'] ?? data['id'];
// //     }).toSet();
// //     List<Map<String, dynamic>> AllTags = [];

// //     for (var doc in allInventoryDocs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final id = data['epcHex'] ?? data['id'];

// //       if (!invIds.contains(id)) {
// //         // Check if item has been missing for 1+ month
// //         final payload = Map<String, dynamic>.from(data['payload'] ?? {});
// //         final entryDateStr = payload['entryDate']?.toString();
// //         bool isMissingForMonth = false;

// //         if (entryDateStr != null && entryDateStr.isNotEmpty) {
// //           try {
// //             final entryDate = DateTime.parse(entryDateStr);
// //             final now = DateTime.now();
// //             final difference = now.difference(entryDate);
// //             isMissingForMonth = difference.inDays >= 30; // 1+ month
// //           } catch (e) {
// //             // If date parsing fails, include as missing (fallback behavior)
// //             isMissingForMonth = true;
// //           }
// //         } else {
// //           // If no entry date, include as missing (fallback behavior)
// //           isMissingForMonth = true;
// //         }

// //         if (isMissingForMonth && id != null) {
// //           missingEpcs.add(id.toString());
// //           AllTags.add(data);
// //         }

// //         final category = data['category'] ?? 'gold';
// //         final weight = (payload['weight'] ?? 0).toDouble();
// //         final cost = (payload['cost'] ?? 0).toDouble();
// //         final wage = (payload['wage'] ?? 0).toDouble();

// //         if (category == 'gold') {
// //           if (payload['carat'] == '18') {
// //             missing18++;
// //             missingwage18 += wage;
// //             missingweight18 += weight;
// //           } else if (payload['carat'] == '21') {
// //             missing21++;
// //             missingwage21 += wage;
// //             missingweight21 += weight;
// //           } else if (payload['carat'] == '22') {
// //             missing22++;
// //             missingwage22 += wage;
// //             missingweight22 += weight;
// //           }
// //         } else if (category == 'bullion') {
// //           missingBullion++;
// //           missingwagebullion += wage;
// //           missingweightbullion += weight;
// //         } else if (category == 'gem') {
// //           missingGem++;
// //           missingcostgem += cost;
// //         }

// //         missingCount++;
// //       }
// //     }

// //     all.sort((a, b) =>
// //         (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

// //     setState(() {
// //       total = sum;
// //       cashtotal = cash;
// //       visatotal = visa;
// //       //transactions = all;
// //       lostItemsCount = missingCount;
// //       loading = false;
// //       missing_18 = missing18;
// //       missing_21 = missing21;
// //       missing_22 = missing22;
// //       missing_Bullion = missingBullion;
// //       missing_Gem = missingGem;
// //       missingwage_18 = missingwage18;
// //       missing_wage21 = missingwage21;
// //       missing_wage22 = missingwage22;
// //       missing_wagebullion = missingwagebullion;
// //       missing_costgem = missingcostgem;
// //       missingweight_18 = missingweight18;
// //       missing_weight21 = missingweight21;
// //       missing_weight22 = missingweight22;
// //       missing_weightbullion = missingweightbullion;
// //       deptCount = tempCounts;
// //       AllMissingTags = AllTags;

// //       // Set deleted items data
// //       deletedGoldCount = 0;
// //       deletedGemCount = 0;
// //       deletedBullionCount = 0;
// //       deletedGoldWeight = 0;
// //       deletedGoldWage = 0;
// //       deletedGemCost = 0;
// //       deletedBullionWeight = 0;
// //       deletedBullionWage = 0;
// //       deletedItems = [];
// //     });
// //   }

// //   Map<String, List<Map<String, dynamic>>> missingByDepartment = {};
// //   void _calculateMissingItems() {
// //     missingByDepartment.clear();

// //     //if (selectedDepartments.isEmpty) return;

// //     //final selectedSet = selectedDepartments.toSet();
// //     //final scannedEpcs = itemsData.keys.toSet();

// //     for (var item in AllMissingTags) {
// //       final epc = item['epcHex']?.toString().toUpperCase();
// //       if (epc == null) continue;

// //       final payload = item['payload'] as Map<String, dynamic>?;
// //       if (payload == null) continue;

// //       final kind = payload['kind']?.toString();
// //       final type = payload['type']?.toString();
// //       final category = item['category']?.toString().toLowerCase();

// //       String? department;

// //       // تحديد القسم
// //       if (category == 'bullion') {
// //         department = 'سبائك';
// //       } else if (kind != null) {
// //         department = kind;
// //       } else if (type != null) {
// //         department = type;
// //       }

// //       if (department == null) continue;

// //       // لو مش متجرد يبقى مفقود
// //       //if (!scannedEpcs.contains(epc)) {

// //       missingByDepartment.putIfAbsent(department, () => []);
// //       missingByDepartment[department]!.add(item);
// //       //}
// //     }

// //     setState(() {});
// //   }

// //   void _showMissingDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         return Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: Dialog(
// //             child: SizedBox(
// //               height: 600,
// //               child: ListView(
// //                 padding: const EdgeInsets.all(16),
// //                 children: missingByDepartment.entries.map((entry) {
// //                   final department = entry.key;
// //                   final items = entry.value;

// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         "$department (${items.length})",
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.red,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       ...items.map((item) {
// //                         final payload =
// //                             item['payload'] as Map<String, dynamic>? ?? {};

// //                         return Card(
// //                           child: ListTile(
// //                             subtitle: Text(
// //                               [
// //                                 if (item['epcHex'] != null &&
// //                                     item['epcHex'].toString().isNotEmpty)
// //                                   "رقم الشريحة: ${item['epcHex']}",
// //                                 if (payload['carat'] != null &&
// //                                     payload['carat'].toString().isNotEmpty)
// //                                   "العيار: ${payload['carat']}",
// //                                 if (payload['size'] != null &&
// //                                     payload['size'].toString().isNotEmpty)
// //                                   "المقاس: ${payload['size']}",
// //                                 if (payload['weight'] != null)
// //                                   "الوزن: ${payload['weight']}",
// //                                 if (payload['wage'] != null)
// //                                   "الاجر: ${payload['wage']}",
// //                                 if (payload['notes'] != null)
// //                                   "الملاحظات: ${payload['notes']}",
// //                                 if (item['createdAt'] != null)
// //                                   "تاريخ الادخال: ${_formatDate(item['createdAt'])}",
// //                                 if (payload['qrCode'] != null &&
// //                                     payload['qrCode'].toString().isNotEmpty)
// //                                   "الكود: ${payload['qrCode']}",
// //                               ].join("\n"),
// //                             ),

// //                             /// 👇 زرار عرض الصور
// //                             trailing: item['epcHex'] != null
// //                                 ? IconButton(
// //                                     icon: const Icon(Icons.image,
// //                                         color: Colors.blue),
// //                                     onPressed: () async {
// //                                       final epcHex = item['epcHex'];
// //                                       final uid = FirebaseAuth
// //                                           .instance.currentUser!.uid;

// //                                       final storageRef = FirebaseStorage
// //                                           .instance
// //                                           .ref()
// //                                           .child('images')
// //                                           .child('users')
// //                                           .child(uid)
// //                                           .child(epcHex);

// //                                       try {
// //                                         final result =
// //                                             await storageRef.listAll();

// //                                         if (result.items.isEmpty) {
// //                                           ScaffoldMessenger.of(context)
// //                                               .showSnackBar(
// //                                             const SnackBar(
// //                                                 content:
// //                                                     Text("لا يوجد صور محفوظة")),
// //                                           );
// //                                           return;
// //                                         }

// //                                         final urls = await Future.wait(
// //                                           result.items.map(
// //                                               (ref) => ref.getDownloadURL()),
// //                                         );

// //                                         showDialog(
// //                                           context: context,
// //                                           builder: (_) => Dialog(
// //                                             //insetPadding: EdgeInsets.zero,
// //                                             child: Container(
// //                                               padding: const EdgeInsets.all(8),
// //                                               width: double.maxFinite,
// //                                               child: Column(
// //                                                 mainAxisSize: MainAxisSize.min,
// //                                                 children: [
// //                                                   const Text(
// //                                                     "صور الشريحة",
// //                                                     style: TextStyle(
// //                                                       fontWeight:
// //                                                           FontWeight.bold,
// //                                                       fontSize: 16,
// //                                                     ),
// //                                                   ),
// //                                                   const SizedBox(height: 8),
// //                                                   SizedBox(
// //                                                     height: 400,
// //                                                     child: ListView.builder(
// //                                                       //scrollDirection: Axis.horizontal,
// //                                                       itemCount: urls.length,
// //                                                       itemBuilder: (_, i) =>
// //                                                           Padding(
// //                                                         padding:
// //                                                             const EdgeInsets
// //                                                                 .all(4),
// //                                                         child: GestureDetector(
// //                                                           onTap: () {
// //                                                             showDialog(
// //                                                               context: context,
// //                                                               builder: (_) =>
// //                                                                   Scaffold(
// //                                                                 backgroundColor:
// //                                                                     Colors
// //                                                                         .black,
// //                                                                 body: Stack(
// //                                                                   children: [
// //                                                                     Center(
// //                                                                       child:
// //                                                                           InteractiveViewer(
// //                                                                         minScale:
// //                                                                             0.5,
// //                                                                         maxScale:
// //                                                                             5.0,
// //                                                                         child: Image
// //                                                                             .network(
// //                                                                           urls[
// //                                                                               i],
// //                                                                           fit: BoxFit
// //                                                                               .contain,
// //                                                                         ),
// //                                                                       ),
// //                                                                     ),
// //                                                                     Positioned(
// //                                                                       top: 40,
// //                                                                       right: 20,
// //                                                                       child:
// //                                                                           IconButton(
// //                                                                         icon:
// //                                                                             const Icon(
// //                                                                           Icons
// //                                                                               .close,
// //                                                                           color:
// //                                                                               Colors.white,
// //                                                                           size:
// //                                                                               30,
// //                                                                         ),
// //                                                                         onPressed:
// //                                                                             () =>
// //                                                                                 Navigator.pop(context),
// //                                                                       ),
// //                                                                     ),
// //                                                                   ],
// //                                                                 ),
// //                                                               ),
// //                                                             );
// //                                                           },
// //                                                           child: Image.network(
// //                                                             urls[i],
// //                                                             width: 200,
// //                                                             fit: BoxFit.cover,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                   TextButton(
// //                                                     onPressed: () =>
// //                                                         Navigator.pop(context),
// //                                                     child: const Text("إغلاق"),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         );
// //                                       } catch (e) {
// //                                         ScaffoldMessenger.of(context)
// //                                             .showSnackBar(
// //                                           const SnackBar(
// //                                               content: Text("فشل تحميل الصور")),
// //                                         );
// //                                       }
// //                                     },
// //                                   )
// //                                 : null,
// //                           ),
// //                         );
// //                       }),
// //                       const SizedBox(height: 16),
// //                     ],
// //                   );
// //                 }).toList(),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   String _formatDate(dynamic timestamp) {
// //     if (timestamp == null) return "";

// //     final date = timestamp.toDate(); // تحويل من Timestamp لـ DateTime

// //     return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
// //         "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
// //   }

// //   void _showNoMissingDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         return AlertDialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: const [
// //               Icon(
// //                 Icons.verified,
// //                 color: Colors.green,
// //                 size: 60,
// //               ),
// //               SizedBox(height: 12),
// //               Text(
// //                 "لا يوجد عناصر مفقودة",
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 6),
// //               Text(
// //                 "تم جرد جميع العناصر بنجاح",
// //                 textAlign: TextAlign.center,
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text("حسناً"),
// //             )
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // ================= UI COMPONENTS =================

// //   Widget statCard({
// //     required String title,
// //     required String value,
// //     required IconData icon,
// //     Color? color,
// //     Color? bg,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: bg ?? Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.05),
// //             blurRadius: 8,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Icon(icon, color: color, size: 25),
// //           const SizedBox(height: 6),
// //           Text(title, style: const TextStyle(fontSize: 14)),
// //           const SizedBox(height: 6),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget sectionCard(String title, Widget child) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(18),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(.05),
// //             blurRadius: 8,
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(title,
// //               style:
// //                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// //           const SizedBox(height: 12),
// //           child,
// //         ],
// //       ),
// //     );
// //   }

// //   Widget rowItem(String title, String value, {Color? color}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(title),
// //           Text(
// //             value,
// //             style: TextStyle(fontWeight: FontWeight.bold, color: color),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   double _percent(double value) {
// //     if (totalWeight == 0) return 0;
// //     return (value / totalWeight) * 100;
// //   }

// //   // ================= BUILD =================

// //   @override
// //   Widget build(BuildContext context) {
// //     if (loading) {
// //       return const Scaffold(
// //         body: Center(child: CircularProgressIndicator()),
// //       );
// //     }

// //     return Scaffold(
// //       backgroundColor: const Color(0xffF5F7FA),
// //       appBar: AppBar(
// //         title: Text("تقرير الرصيد العام"),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: ListView(
// //         padding: const EdgeInsets.all(16),
// //         children: [
// //           /// 🔹 TOP CARDS
// //           GridView.count(
// //             crossAxisCount: 2,
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             crossAxisSpacing: 12,
// //             mainAxisSpacing: 12,
// //             childAspectRatio: 1.4,
// //             children: [
// //               statCard(
// //                 title: 'اجمالي وزن العيارات',
// //                 value: '${totalWeight.toStringAsFixed(2)} جرام',
// //                 icon: Icons.balance,
// //                 color: Colors.blue,
// //               ),
// //               statCard(
// //                 title: 'اجمالي الصندوق',
// //                 value: '${total.toStringAsFixed(0)} ريال',
// //                 icon: Icons.attach_money,
// //                 color: Colors.blue,
// //               ),
// //               statCard(
// //                 title: 'رصيد الكاش',
// //                 value: '${cashtotal.toStringAsFixed(0)} ريال',
// //                 icon: Icons.attach_money,
// //                 color: Colors.green,
// //               ),
// //               statCard(
// //                 title: 'رصيد الشبكة',
// //                 value: '${visatotal.toStringAsFixed(0)} ريال',
// //                 icon: Icons.track_changes,
// //                 color: Colors.green,
// //               ),
// //             ],
// //           ),

// //           const SizedBox(height: 16),

// //           /// 🔹 DISTRIBUTION
// //           sectionCard(
// //             'توزيع الأوزان حسب العيار',
// //             Column(
// //               children: [
// //                 _caratRow(
// //                   'عيار 18',
// //                   caratWeight[18]!,
// //                   Colors.orange,
// //                 ),
// //                 _caratRow(
// //                   'عيار 21',
// //                   caratWeight[21]!,
// //                   Colors.green,
// //                 ),
// //                 _caratRow(
// //                   'عيار 22',
// //                   caratWeight[22]!,
// //                   Colors.red,
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 16),
// //           if (deptCount.isNotEmpty) const SizedBox(height: 25),
// //           Padding(
// //             padding: const EdgeInsets.only(),
// //             child: Text(
// //               _t("عدد الاقسام المسجلة", "Number of dept existed"),
// //               style: const TextStyle(
// //                 color: Colors.black,
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 12),
// //             child: Wrap(
// //               spacing: 10,
// //               runSpacing: 10,
// //               children: deptCount.entries.map((entry) {
// //                 return Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFD4AF37).withOpacity(0.15),
// //                     borderRadius: BorderRadius.circular(20),
// //                     border: Border.all(color: const Color(0xFFD4AF37)),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       const Icon(Icons.category,
// //                           size: 18, color: Color(0xFFD4AF37)),
// //                       const SizedBox(width: 6),
// //                       Text(
// //                         "${entry.key} : ${entry.value}",
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.black87,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           Directionality(
// //             textDirection: TextDirection.rtl,
// //             child: sectionCard(
// //               'نظرة سريعة',
// //               Column(
// //                 children: [
// //                   rowItem(
// //                       'رصيد الكسر', '${scrapWeight.toStringAsFixed(2)} جرام'),
// //                   rowItem('عدد الاحجار', '${stonesCount.toStringAsFixed(2)} ',
// //                       color: Colors.purple),
// //                   rowItem('عدد السبائك', '${BullionCount.toStringAsFixed(2)} ',
// //                       color: Color(0xFFD4AF37)),
// //                   rowItem(
// //                       'وزن السبائك', '${BullionWeight.toStringAsFixed(2)} جرام',
// //                       color: Color(0xFFD4AF37)),
// //                   rowItem('توريدات للادراة هذا الشهر',
// //                       ' كاش : ${supplycash.toStringAsFixed(0)} شبكة : ${supplyvisa.toStringAsFixed(0)}',
// //                       color: Colors.red),
// //                   rowItem('استيرادات الادراة هذا الشهر',
// //                       ' كاش : ${importcash.toStringAsFixed(0)} شبكة : ${importvisa.toStringAsFixed(0)}',
// //                       color: Colors.red),
// //                   rowItem('المصروفات هذا الشهر ',
// //                       '${expenses_Month.toStringAsFixed(0)} ريال',
// //                       color: Colors.green),
// //                   rowItem('رصيد بيع جزئي متبقي',
// //                       '${balancesWeight.toStringAsFixed(2)} جرام',
// //                       color: Colors.orange),
// //                   rowItem('عدد أرصدة البيع الجزئي', '$balancesCount',
// //                       color: Colors.orange),
// //                   rowItem('عدد الذهب المحذوف', '$deletedGoldCount',
// //                       color: Colors.red),
// //                   rowItem('وزن الذهب المحذوف',
// //                       '${deletedGoldWeight.toStringAsFixed(2)} جرام',
// //                       color: Colors.red),
// //                   rowItem('عدد الأحجار المحذوفة', '$deletedGemCount',
// //                       color: Colors.purple),
// //                   rowItem('تكلفة الأحجار المحذوفة',
// //                       '${deletedGemCost.toStringAsFixed(0)} ريال',
// //                       color: Colors.purple),
// //                   rowItem('عدد السبائك المحذوفة', '$deletedBullionCount',
// //                       color: Colors.orange),
// //                   rowItem('وزن السبائك المحذوفة',
// //                       '${deletedBullionWeight.toStringAsFixed(2)} جرام',
// //                       color: Colors.orange),
// //                   const Divider(),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           //const SizedBox(height: 16),

// //           ElevatedButton.icon(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red,
// //               minimumSize: const Size.fromHeight(45),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             icon: const Icon(Icons.warning, color: Colors.white),
// //             label: const Text(
// //               "عرض المفقود",
// //               style: TextStyle(color: Colors.white),
// //             ),
// //             onPressed: () {
// //               _calculateMissingItems();

// //               if (missingByDepartment.isEmpty) {
// //                 _showNoMissingDialog();
// //               } else {
// //                 _showMissingDialog();
// //               }
// //             },
// //           ),

// //           /*Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: sectionCard(
// //             'المفقود',
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [

// //                 /// ===== Header (دايمًا ظاهر) =====
// //                 InkWell(
// //                   onTap: () {
// //                     setState(() {
// //                       showLostDetails = !showLostDetails;
// //                     });
// //                   },
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         'إجمالي الشرائح المفقودة: $lostItemsCount',
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                           color: Colors.red,
// //                         ),
// //                       ),
// //                       Icon(
// //                         showLostDetails
// //                             ? Icons.keyboard_arrow_up
// //                             : Icons.keyboard_arrow_down,
// //                         size: 28,
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 /// ===== التفاصيل =====
// //                 AnimatedCrossFade(
// //                   firstChild: const SizedBox.shrink(),
// //                   secondChild: _lostDetails(),
// //                   crossFadeState: showLostDetails
// //                       ? CrossFadeState.showSecond
// //                       : CrossFadeState.showFirst,
// //                   duration: const Duration(milliseconds: 250),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),*/
// //           const SizedBox(height: 16),
// //           Directionality(
// //             textDirection: TextDirection.rtl,
// //             child: sectionCard(
// //               'الموردين',
// //               StreamBuilder<List<Map<String, dynamic>>>(
// //                 stream: FS.suppliersStream(),
// //                 builder: (context, snap) {
// //                   if (!snap.hasData) {
// //                     return const Padding(
// //                       padding: EdgeInsets.all(12),
// //                       child: Center(child: CircularProgressIndicator()),
// //                     );
// //                   }

// //                   final suppliers = snap.data!;

// //                   if (suppliers.isEmpty) {
// //                     return const Padding(
// //                       padding: EdgeInsets.all(12),
// //                       child: Text(
// //                         'لا يوجد موردين حالياً',
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //                     );
// //                   }

// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       /// ===== Header =====
// //                       InkWell(
// //                         onTap: () {
// //                           setState(() {
// //                             showSuppliers = !showSuppliers;
// //                           });
// //                         },
// //                         child: Row(
// //                           children: [
// //                             Expanded(
// //                               child: Text(
// //                                 'عدد الموردين: ${suppliers.length}',
// //                                 textAlign: TextAlign.right,
// //                                 style: const TextStyle(
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Icon(
// //                               showSuppliers
// //                                   ? Icons.keyboard_arrow_up
// //                                   : Icons.keyboard_arrow_down,
// //                               size: 28,
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       /// ===== List =====
// //                       AnimatedCrossFade(
// //                         firstChild: const SizedBox.shrink(),
// //                         secondChild: ListView.builder(
// //                           shrinkWrap: true,
// //                           physics: const NeverScrollableScrollPhysics(),
// //                           padding: const EdgeInsets.only(top: 12),
// //                           itemCount: suppliers.length,
// //                           itemBuilder: (_, i) {
// //                             final s = suppliers[i];
// //                             return _supplierCard(s); // نفس الكارت اللي عندك
// //                           },
// //                         ),
// //                         crossFadeState: showSuppliers
// //                             ? CrossFadeState.showSecond
// //                             : CrossFadeState.showFirst,
// //                         duration: const Duration(milliseconds: 250),
// //                       ),
// //                     ],
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),

// //           const SizedBox(height: 16),

// //           /*FutureBuilder<Map<int, double>>(
// //             future: fetchGoldPrices(),
// //             builder: (context, snapshot) {
// //               if (!snapshot.hasData) {
// //                 return const Center(child: CircularProgressIndicator());
// //               }

// //               final prices = snapshot.data!;
// //               return Directionality(
// //                 textDirection: TextDirection.rtl,
// //                 child: sectionCard(
// //                   'أسعار الذهب اليوم',
// //                   Column(
// //                     children: [
// //                       _priceRow('عيار 18', prices[18]!),
// //                       _priceRow('عيار 21', prices[21]!),
// //                       _priceRow('عيار 22', prices[22]!),
// //                       _priceRow('عيار 24', prices[24]!),
// //                     ],
// //                   ),
// //                 ),
// //               );

// //               /*return sectionCard(
// //                 'أسعار الذهب اليوم',
// //                 Column(
// //                   children: [
// //                     _priceRow('عيار 18', prices[18]!),
// //                     _priceRow('عيار 21', prices[21]!),
// //                     _priceRow('عيار 22', prices[22]!),
// //                     _priceRow('عيار 24', prices[24]!),
// //                   ],
// //                 ),
// //               );*/
// //             },
// //           ),*/
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _supplierCard(Map<String, dynamic> s) {
// //     return Card(
// //       elevation: 4,
// //       margin: const EdgeInsets.symmetric(vertical: 8),
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(16),
// //       ),
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: Colors.blue.shade100,
// //           child: const Icon(Icons.person, color: Colors.blue),
// //         ),
// //         title: Text(
// //           s["name"],
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         subtitle: FutureBuilder<Map<String, dynamic>>(
// //           future: _supplierSummary(s["id"]),
// //           builder: (context, snap) {
// //             if (!snap.hasData) {
// //               return const Text("جاري حساب الرصيد...");
// //             }

// //             final data = snap.data!;
// //             final bool cleared = data["cleared"];
// //             final double w = data["weight"];
// //             final double g = data["wage"];

// //             Color color;
// //             String status;

// //             if (cleared) {
// //               color = Colors.green;
// //               status = "تمت تصفية الحساب";
// //             } else if (w > 0) {
// //               color = Colors.red;
// //               status = "للمورد";
// //             } else {
// //               color = Colors.green.shade700;
// //               status = "على المورد";
// //             }

// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text("📞 ${s["phone"] ?? '-'}"),
// //                 const SizedBox(height: 4),

// //                 /// ===== Status Badge =====
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: color.withOpacity(.1),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Text(
// //                     status,
// //                     style: TextStyle(
// //                       color: color,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ),

// //                 if (!cleared) ...[
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     "وزن: ${w.abs().toStringAsFixed(2)} جم • أجر: ${g.abs().toStringAsFixed(2)}",
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: Colors.grey.shade700,
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             );
// //           },
// //         ),
// //         onTap: () async {
// //           final vouchers = await FS.getVouchersForSupplier(s["id"]);

// //           // 🧮 حساب إجمالي الوزن والأجر لكل عيار
// //           final Map<String, double> totalPaymentWeight = {
// //             "18": 0,
// //             "21": 0,
// //             "22": 0
// //           };
// //           final Map<String, double> totalReceiptWeight = {
// //             "18": 0,
// //             "21": 0,
// //             "22": 0
// //           };
// //           final Map<String, double> totalPaymentWage = {
// //             "18": 0,
// //             "21": 0,
// //             "22": 0
// //           };
// //           final Map<String, double> totalReceiptWage = {
// //             "18": 0,
// //             "21": 0,
// //             "22": 0
// //           };

// //           for (var v in vouchers) {
// //             final carat = (v["carat"] ?? "").toString();
// //             final weight =
// //                 double.tryParse(v["weight"]?.toString() ?? "0") ?? 0.0;
// //             final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0.0;

// //             if (["18", "21", "22"].contains(carat)) {
// //               if (v["type"] == "payment") {
// //                 totalPaymentWeight[carat] =
// //                     (totalPaymentWeight[carat] ?? 0) + weight;
// //                 totalPaymentWage[carat] = (totalPaymentWage[carat] ?? 0) + wage;
// //               } else if (v["type"] == "receipt") {
// //                 totalReceiptWeight[carat] =
// //                     (totalReceiptWeight[carat] ?? 0) + weight;
// //                 totalReceiptWage[carat] = (totalReceiptWage[carat] ?? 0) + wage;
// //               }
// //             }
// //           }

// //           // 🧾 حساب الصافي لكل عيار
// //           final Map<String, double> balanceWeight = {};
// //           final Map<String, double> balanceWage = {};

// //           for (var c in ["18", "21", "22"]) {
// //             balanceWeight[c] = totalReceiptWeight[c]! - totalPaymentWeight[c]!;
// //             balanceWage[c] = totalReceiptWage[c]! - totalPaymentWage[c]!;
// //           }

// //           // 💰 إجمالي عام
// //           final totalBalanceWeight =
// //               balanceWeight.values.fold(0.0, (a, b) => a + b);
// //           final totalBalanceWage =
// //               balanceWage.values.fold(0.0, (a, b) => a + b);

// //           final allCleared =
// //               balanceWeight.values.every((v) => v.abs() < 0.0001) &&
// //                   balanceWage.values.every((v) => v.abs() < 0.0001);

// //           showDialog(
// //             context: context,
// //             builder: (_) => AlertDialog(
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(20)),
// //               title: Center(
// //                 child: Text(
// //                   _t("رصيد المورد", "Supplier Balance"),
// //                   style: const TextStyle(
// //                       fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //               ),
// //               content: SizedBox(
// //                 width: double.maxFinite,
// //                 height: MediaQuery.of(context).size.height * 0.85,
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     children: [
// //                       // 🔹 الحالة العامة
// //                       Card(
// //                         elevation: 2,
// //                         color: allCleared
// //                             ? Colors.green.shade50
// //                             : totalBalanceWeight > 0
// //                                 ? Colors.amber.shade50
// //                                 : Colors.red.shade50,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(16)),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(14),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Icon(
// //                                 allCleared
// //                                     ? Icons.check_circle
// //                                     : (totalBalanceWeight > 0
// //                                         ? Icons.account_balance_wallet
// //                                         : Icons.warning_amber_rounded),
// //                                 color: allCleared
// //                                     ? Colors.green
// //                                     : (totalBalanceWeight > 0
// //                                         ? Colors.red
// //                                         : Colors.green),
// //                                 size: 20,
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 child: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.center,
// //                                   children: [
// //                                     if (allCleared)
// //                                       Text(
// //                                         _t("تمت تصفية الحساب بالكامل ",
// //                                             "Account fully settled "),
// //                                         textAlign: TextAlign.center,
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 17,
// //                                           color: Colors.green,
// //                                         ),
// //                                       )
// //                                     else ...[
// //                                       Text(
// //                                         totalBalanceWeight > 0
// //                                             ? _t("للمورد", "Supplier balance")
// //                                             : _t("على المورد", "Supplier owes"),
// //                                         textAlign: TextAlign.center,
// //                                         style: TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 17,
// //                                           color: totalBalanceWeight > 0
// //                                               ? Colors.red.shade800
// //                                               : Colors.green.shade800,
// //                                         ),
// //                                       ),
// //                                       const SizedBox(height: 4),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.center,
// //                                         children: [
// //                                           const SizedBox(width: 4),
// //                                           Text(
// //                                             "${_t("الوزن", "Weight")}: ${totalBalanceWeight.abs().toStringAsFixed(2)} جم",
// //                                             style: const TextStyle(
// //                                                 fontSize: 12,
// //                                                 fontWeight: FontWeight.w500),
// //                                           ),
// //                                           const SizedBox(width: 12),
// //                                           const SizedBox(width: 4),
// //                                           Text(
// //                                             "${_t("الأجر", "Wage")}: ${totalBalanceWage.abs().toStringAsFixed(2)}",
// //                                             style: const TextStyle(
// //                                                 fontSize: 12,
// //                                                 fontWeight: FontWeight.w500),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ],
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),

// //                       const SizedBox(height: 10),

// //                       // 🔸 تفاصيل كل عيار
// //                       if (!allCleared)
// //                         Card(
// //                           elevation: 1,
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16)),
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(12),
// //                             child: Column(
// //                               children: [
// //                                 Text(
// //                                   _t("تفاصيل حسب العيار", "Details by Carat"),
// //                                   style: const TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 15),
// //                                 ),
// //                                 const SizedBox(height: 8),
// //                                 GridView.count(
// //                                   physics: const NeverScrollableScrollPhysics(),
// //                                   shrinkWrap: true,
// //                                   crossAxisCount: 2,
// //                                   mainAxisSpacing: 6,
// //                                   crossAxisSpacing: 6,
// //                                   childAspectRatio: 1.1,
// //                                   children: ["18", "21", "22"].map((c) {
// //                                     final bw = balanceWeight[c]!;
// //                                     final wg = balanceWage[c]!;

// //                                     final bool cleared =
// //                                         bw.abs() < 0.0001 && wg.abs() < 0.0001;

// //                                     return Container(
// //                                       decoration: BoxDecoration(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                         color: cleared
// //                                             ? Colors.grey.shade100
// //                                             : bw > 0
// //                                                 ? Colors.red.shade50
// //                                                 : bw < 0
// //                                                     ? Colors.green.shade50
// //                                                     : Colors.amber.shade50,
// //                                         border: Border.all(
// //                                           color: cleared
// //                                               ? Colors.grey.shade300
// //                                               : bw > 0
// //                                                   ? Colors.red.shade300
// //                                                   : Colors.green.shade300,
// //                                         ),
// //                                       ),
// //                                       child: Padding(
// //                                         padding: const EdgeInsets.all(8),
// //                                         child: Column(
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.center,
// //                                           children: [
// //                                             Text("عيار $c",
// //                                                 style: const TextStyle(
// //                                                     fontWeight:
// //                                                         FontWeight.bold)),
// //                                             const SizedBox(height: 4),
// //                                             Text(
// //                                               "${_t("وزن", "weight")}: ${bw.toStringAsFixed(2)}",
// //                                               style: TextStyle(
// //                                                   color: bw == 0
// //                                                       ? Colors.grey
// //                                                       : bw > 0
// //                                                           ? Colors.red.shade800
// //                                                           : Colors
// //                                                               .green.shade800,
// //                                                   fontSize: 13),
// //                                             ),
// //                                             Text(
// //                                               "${_t("أجر", "Wage")}: ${wg.toStringAsFixed(2)}",
// //                                               style:
// //                                                   const TextStyle(fontSize: 12),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),

// //                       const SizedBox(height: 16),
// //                       const Divider(thickness: 1),
// //                       const SizedBox(height: 6),
// //                       Text(
// //                         _t("قائمة السندات", "Vouchers List"),
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.bold, fontSize: 15),
// //                       ),
// //                       const SizedBox(height: 8),

// //                       // 🔹 قائمة السندات الأصلية
// //                       ...vouchers.map((v) {
// //                         final isReceipt = v["type"] == "receipt";

// //                         return Card(
// //                           elevation: 2,
// //                           margin: const EdgeInsets.symmetric(vertical: 6),
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(12)),
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(10),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     CircleAvatar(
// //                                       backgroundColor: isReceipt
// //                                           ? Colors.red.shade100
// //                                           : Colors.green.shade100,
// //                                       child: Icon(
// //                                         isReceipt
// //                                             ? Icons.download_done
// //                                             : Icons.upload,
// //                                         color: isReceipt
// //                                             ? Colors.red
// //                                             : Colors.green,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(width: 12),
// //                                     Text(
// //                                       isReceipt
// //                                           ? _t("سند قبض", "Receipt Voucher")
// //                                           : _t("سند صرف", "Payment Voucher"),
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 15),
// //                                     ),
// //                                     const Spacer(),
// //                                     if (v["date"] != null)
// //                                       Text(
// //                                         " ${(v["date"] as Timestamp).toDate().toString().split(' ')[0]}",
// //                                         style: TextStyle(
// //                                             color: Colors.grey.shade600,
// //                                             fontSize: 12),
// //                                       ),
// //                                   ],
// //                                 ),
// //                                 const Divider(height: 16),
// //                                 Text(
// //                                     "${_t("المندوب", "Delegate")}: ${v["delegate"] ?? "-"}"),
// //                                 Text(
// //                                     "${_t("العيار", "Carat")}: ${v["carat"] ?? "-"}"),
// //                                 Text(
// //                                     "${_t("الوزن", "Weight")}: ${v["weight"] ?? 0} g"),
// //                                 Text(
// //                                     "${_t("الأجر", "Wage")}: ${v["wage"] ?? 0}"),
// //                                 if (!isReceipt) ...[
// //                                   if (v["paymentMethod"] != null)
// //                                     Text(
// //                                         "${_t("طريقة الدفع", "Payment Method")}: ${v["paymentMethod"]}"),
// //                                   if (v["cash"] != null)
// //                                     Text("${_t("كاش", "Cash")}: ${v["cash"]}"),
// //                                   if (v["network"] != null)
// //                                     Text(
// //                                         "${_t("شبكة", "Network")}: ${v["network"]}"),
// //                                 ],
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
// //     final vouchers = await FS.getVouchersForSupplier(supplierId);

// //     double payW = 0, recW = 0;
// //     double payG = 0, recG = 0;

// //     for (var v in vouchers) {
// //       final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

// //       if (v["type"] == "payment") {
// //         payW += weight;
// //         payG += wage;
// //       } else if (v["type"] == "receipt") {
// //         recW += weight;
// //         recG += wage;
// //       }
// //     }

// //     final balanceWeight = recW - payW;
// //     final balanceWage = recG - payG;

// //     final cleared = balanceWeight.abs() < 0.0001 && balanceWage.abs() < 0.0001;

// //     return {
// //       "cleared": cleared,
// //       "weight": balanceWeight,
// //       "wage": balanceWage,
// //     };
// //   }

// //   /*Widget _suppliersList() {
// //     return ListView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       padding: const EdgeInsets.only(top: 12),
// //       itemCount: suppliers.length,
// //       itemBuilder: (_, i) {
// //         final s = suppliers[i];

// //         return Card(
// //           elevation: 4,
// //           margin: const EdgeInsets.symmetric(vertical: 8),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: ListTile(
// //             leading: CircleAvatar(
// //               backgroundColor: Colors.blue.shade100,
// //               child: const Icon(Icons.person, color: Colors.blue),
// //             ),
// //             title: Text(
// //               s["name"],
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //             ),
// //             subtitle: Padding(
// //               padding: const EdgeInsets.only(top: 6),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text("👤 ${_t("مندوبيـن", "Delegates")}: ${s["delegates"].join(", ")}"),
// //                   const SizedBox(height: 4),
// //                   Text("📞 ${_t("جوال", "Phone")}: ${s["phone"]}"),
// //                 ],
// //               ),
// //             ),

// //             /// نفس PopupMenu + onTap بتاعك
// //             /*trailing: PopupMenuButton<String>(
// //               icon: const Icon(Icons.more_vert),
// //               onSelected: (value) async {
// //                 if (value == 'edit') {
// //                   _showEditSupplierDialog(context, s);
// //                 } else if (value == 'delete') {
// //                   final confirm = await showDialog(
// //                     context: context,
// //                     builder: (_) => AlertDialog(
// //                       title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
// //                       content: Text(_t("هل تريد حذف المورد ${s["name"]}؟",
// //                           "Are you sure you want to delete ${s["name"]}?")),
// //                       actions: [
// //                         TextButton(
// //                           onPressed: () => Navigator.pop(context, false),
// //                           child: Text(_t("إلغاء", "Cancel")),
// //                         ),
// //                         TextButton(
// //                           onPressed: () => Navigator.pop(context, true),
// //                           child: Text(_t("حذف", "Delete"),
// //                               style: const TextStyle(color: Colors.red)),
// //                         ),
// //                       ],
// //                     ),
// //                   );

// //                   if (confirm == true) {
// //                     await FS.deleteSupplier(s["id"]);
// //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //                       content: Text(_t(
// //                           "تم حذف المورد ${s["name"]} بنجاح ✅",
// //                           "Supplier ${s["name"]} deleted successfully ✅")),
// //                       backgroundColor: Colors.redAccent,
// //                     ));
// //                   }
// //                 }
// //               },
// //               itemBuilder: (context) => [
// //                 PopupMenuItem(
// //                   value: 'edit',
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.edit, color: Colors.orange),
// //                       const SizedBox(width: 8),
// //                       Text(_t('تعديل', 'Edit')),
// //                     ],
// //                   ),
// //                 ),
// //                 PopupMenuItem(
// //                   value: 'delete',
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.delete, color: Colors.red),
// //                       const SizedBox(width: 8),
// //                       Text(_t('حذف', 'Delete')),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),*/

// //           ),
// //         );
// //       },
// //     );
// //   }*/

// //   Widget _lostDetails() {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 12),

// //         /// الذهب
// //         _summaryCard(
// //           title: 'ذهب',
// //           children: [
// //             _summaryRow('عيار 18',
// //                 count: missing_18,
// //                 weight: missingweight_18,
// //                 wage: missingwage_18),
// //             _summaryRow('عيار 21',
// //                 count: missing_21,
// //                 weight: missing_weight21,
// //                 wage: missing_wage21),
// //             _summaryRow('عيار 22',
// //                 count: missing_22,
// //                 weight: missing_weight22,
// //                 wage: missing_wage22),
// //           ],
// //         ),

// //         const SizedBox(height: 8),

// //         _summaryCard(
// //           title: 'سبائك',
// //           children: [
// //             _summaryRow(
// //               'سبائك',
// //               count: missing_Bullion,
// //               weight: missing_weightbullion,
// //               cost: missing_wagebullion,
// //             ),
// //           ],
// //         ),

// //         const SizedBox(height: 8),

// //         _summaryCard(
// //           title: 'أحجار',
// //           children: [
// //             _summaryRow(
// //               'أحجار',
// //               count: missing_Gem,
// //               cost: missing_costgem,
// //             ),
// //           ],
// //         ),

// //         const SizedBox(height: 20),

// //         /// 🔵 زرار عرض كل الصور
// //         ElevatedButton(
// //           onPressed: isLoadingImages ? null : _loadAllMissingImages,
// //           child: isLoadingImages
// //               ? const SizedBox(
// //                   height: 20,
// //                   width: 20,
// //                   child: CircularProgressIndicator(
// //                     strokeWidth: 2,
// //                     color: Colors.white,
// //                   ),
// //                 )
// //               : const Text("عرض كل صور العناصر المفقودة"),
// //         ),
// //       ],
// //     );
// //   }

// //   Future<void> _loadAllMissingImages() async {
// //     if (missingEpcs.isEmpty) return;

// //     setState(() => isLoadingImages = true);

// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     try {
// //       final futures = missingEpcs.map((epc) async {
// //         final storageRef = FirebaseStorage.instance
// //             .ref()
// //             .child('images')
// //             .child('users')
// //             .child(uid)
// //             .child(epc);

// //         final result = await storageRef.listAll();

// //         return Future.wait(
// //           result.items.map((ref) => ref.getDownloadURL()),
// //         );
// //       });

// //       final results = await Future.wait(futures);

// //       allMissingImageUrls = results.expand((element) => element).toList();

// //       setState(() => isLoadingImages = false);

// //       if (allMissingImageUrls.isNotEmpty) {
// //         _openImageViewer();
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("لا توجد صور محفوظة")),
// //         );
// //       }
// //     } catch (e) {
// //       setState(() => isLoadingImages = false);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("فشل تحميل الصور")),
// //       );
// //     }
// //   }

// //   void _openImageViewer() {
// //     showDialog(
// //       context: context,
// //       builder: (_) {
// //         PageController controller = PageController();

// //         return Dialog(
// //           insetPadding: EdgeInsets.zero,
// //           child: Stack(
// //             children: [
// //               /// الصور
// //               PageView.builder(
// //                 controller: controller,
// //                 itemCount: allMissingImageUrls.length,
// //                 itemBuilder: (_, index) {
// //                   return InteractiveViewer(
// //                     child: Image.network(
// //                       allMissingImageUrls[index],
// //                       fit: BoxFit.contain,
// //                     ),
// //                   );
// //                 },
// //               ),

// //               /// زرار إغلاق
// //               Positioned(
// //                 top: 20,
// //                 right: 20,
// //                 child: IconButton(
// //                   icon: const Icon(Icons.close, color: Colors.red, size: 30),
// //                   onPressed: () => Navigator.pop(context),
// //                 ),
// //               ),

// //               /// زر تنزيل
// //               /*Positioned(
// //                 bottom: 20,
// //                 right: 20,
// //                 child: FloatingActionButton(
// //                   onPressed: () {
// //                     _downloadImage(
// //                         allMissingImageUrls[controller.page?.round() ?? 0]);
// //                   },
// //                   child: const Icon(Icons.download),
// //                 ),
// //               ),*/
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //   /*Future<void> _downloadImage(String url) async {
// //     try {
// //       final response = await Dio().get(
// //         url,
// //         options: Options(responseType: ResponseType.bytes),
// //       );

// //       await Gal.putImageBytes(
// //         response.data,
// //         name: "lost_${DateTime.now().millisecondsSinceEpoch}",
// //       );

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("تم تنزيل الصورة بنجاح")),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("فشل تنزيل الصورة")),
// //       );
// //     }
// //   }*/

// //   Widget _summaryCard({
// //     required String title,
// //     required List<Widget> children,
// //   }) {
// //     return Card(
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               title,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 16,
// //               ),
// //             ),
// //             const Divider(),
// //             ...children,
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _summaryRow(
// //     String label, {
// //     int? count,
// //     double? weight,
// //     double? wage,
// //     double? cost,
// //   }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 6),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: const TextStyle(fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 4),
// //           if (count != null) Text('عدد الشرائح: $count'),
// //           if (weight != null) Text('الوزن: ${weight.toStringAsFixed(2)} جرام'),
// //           if (wage != null) Text('الأجر: ${wage.toStringAsFixed(2)} ريال'),
// //           if (cost != null) Text('التكلفة: ${cost.toStringAsFixed(2)} ريال'),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _caratRow(String title, double weight, Color color) {
// //     final percent = _percent(weight);

// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// //               Text(
// //                 '${weight.toStringAsFixed(2)}   •  ${percent.toStringAsFixed(1)}%',
// //                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 6),
// //           LinearProgressIndicator(
// //             value: percent / 100,
// //             backgroundColor: color.withOpacity(.15),
// //             valueColor: AlwaysStoppedAnimation(color),
// //             minHeight: 8,
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // /*Widget _priceRow(String title, double price) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(fontSize: 14),
// //           ),
// //           Text(
// //             '${price.toStringAsFixed(2)} ريال',
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFFD4AF37),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }*/
// // }
// import 'dart:async';

// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class GeneralBalancePage extends StatefulWidget {
//   const GeneralBalancePage({super.key});

//   @override
//   State<GeneralBalancePage> createState() => _GeneralBalancePageState();
// }

// class _GeneralBalancePageState extends State<GeneralBalancePage> {
//   bool loading = true;

//   double totalWeight = 0;
//   Map<int, double> caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};

//   int stonesCount = 0;
//   int BullionCount = 0;
//   double stonesCost = 0;
//   double BullionWeight = 0;

//   double scrapWeight = 0;
//   double supply = 0;
//   double import = 0;
//   double supplycash = 0;
//   double importcash = 0;
//   double supplyvisa = 0;
//   double importvisa = 0;
//   double balancesWeight = 0;
//   int balancesCount = 0;

//   double total = 0.0;
//   double cashtotal = 0.0;
//   double visatotal = 0.0;
//   int lostItemsCount = 0;

//   int missing_18 = 0;
//   int missing_21 = 0;
//   int missing_22 = 0;
//   int missing_Gem = 0;
//   int missing_Bullion = 0;
//   List<String> missingEpcs = [];
//   bool isLoadingImages = false;
//   List<String> allMissingImageUrls = [];
//   Map<String, int> deptCount = {};

//   double missingwage_18 = 0,
//       missing_wage21 = 0,
//       missing_wage22 = 0,
//       missing_wagebullion = 0,
//       missing_costgem = 0;
//   double missingweight_18 = 0,
//       missing_weight21 = 0,
//       missing_weight22 = 0,
//       missing_weightbullion = 0;

//   // ✅ الجرامات المعلقة من بقايا الأطقم
//   double _remainingKitsWeight = 0.0;

//   // Deleted items tracking
//   int deletedGoldCount = 0;
//   int deletedGemCount = 0;
//   int deletedBullionCount = 0;
//   double deletedGoldWeight = 0;
//   double deletedGoldWage = 0;
//   double deletedGemCost = 0;
//   double deletedBullionWeight = 0;
//   double deletedBullionWage = 0;
//   List<Map<String, dynamic>> deletedItems = [];
//   bool showLostDetails = false;
//   bool showSuppliers = false;
//   double expenses_Month = 0;

//   List<Map<String, dynamic>> suppliers = [];
//   List<Map<String, dynamic>> AllMissingTags = [];

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   Map<String, List<Map<String, dynamic>>> lostItemsByCategory = {
//     'gold': [],
//     'gem': [],
//     'bullion': [],
//   };

//   // ✅ Stream Subscription
//   StreamSubscription? _kitsSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _loadData();
//     _listenToKitsChanges();
//   }

//   @override
//   void dispose() {
//     _kitsSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     _lang = prefs.getString('languageCode') ?? 'ar';
//   }

//   // ✅ الاستماع للتحديثات في بقايا الأطقم
//   void _listenToKitsChanges() {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     _kitsSubscription = FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('setRemainders')
//         .snapshots()
//         .listen((snapshot) {
//       double totalRemaining = 0.0;

//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final payload = data['payload'] as Map<String, dynamic>? ?? {};

//         final originalWeight =
//             (payload['originalWeight'] as num?)?.toDouble() ??
//                 (payload['weight'] as num?)?.toDouble() ??
//                 0;
//         final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//         final remainingWeight = originalWeight - soldWeight;

//         // ✅ فقط الوزن الموجب
//         if (remainingWeight > 0) {
//           totalRemaining += remainingWeight;
//         }
//       }

//       if (mounted) {
//         setState(() {
//           _remainingKitsWeight = totalRemaining;
//         });
//       }
//     });
//   }

//   // ✅ دالة لحساب الجرامات المعلقة (تستخدم في التحميل الأول)
//   Future<double> _calculateRemainingKitsWeight() async {
//     double totalRemaining = 0.0;

//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         final kitsSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .collection('setRemainders')
//             .get();

//         for (var doc in kitsSnapshot.docs) {
//           final data = doc.data();
//           final payload = data['payload'] as Map<String, dynamic>? ?? {};

//           final originalWeight =
//               (payload['originalWeight'] as num?)?.toDouble() ??
//                   (payload['weight'] as num?)?.toDouble() ??
//                   0;
//           final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//           final remainingWeight = originalWeight - soldWeight;

//           if (remainingWeight > 0) {
//             totalRemaining += remainingWeight;
//           }
//         }
//       }
//     } catch (e) {
//       print('Error loading remaining kits: $e');
//     }

//     return totalRemaining;
//   }

//   Future<void> _loadData() async {
//     // =====================================================
//     // ✅ إعادة تعيين كل المتغيرات قبل الجمع (مهم جداً)
//     // =====================================================
//     totalWeight = 0;
//     caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};
//     stonesCount = 0;
//     BullionCount = 0;
//     stonesCost = 0;
//     BullionWeight = 0;
//     scrapWeight = 0;
//     balancesWeight = 0;
//     balancesCount = 0;
//     deptCount = {};
//     missingEpcs.clear();
//     AllMissingTags.clear();

//     double sum = 0.0;
//     double cash = 0.0;
//     double visa = 0.0;
//     List<Map<String, dynamic>> all = [];

//     final itemsSnap = await FS.itemsCol().get();
//     final balancesSnap = await FS.balancesCol().get();
//     balancesCount = balancesSnap.docs.length;
//     Map<String, int> tempCounts = {};
//     final allInventoryDocs = [...itemsSnap.docs, ...balancesSnap.docs];

//     for (var doc in allInventoryDocs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//       final isBalance = doc.reference.parent.id == 'balances';
//       final weight = (payload['weight'] ?? 0).toDouble();
//       if (isBalance) balancesWeight += weight;

//       final carat = int.tryParse(payload['carat']?.toString() ?? '');
//       final kind = payload['kind']?.toString();
//       final type = payload['type']?.toString();
//       if (data['category'] == "bullion") {
//         tempCounts['سبائك'] = (tempCounts['سبائك'] ?? 0) + 1;
//       }

//       if (kind != null) {
//         tempCounts[kind] = (tempCounts[kind] ?? 0) + 1;
//       }

//       if (type != null) {
//         tempCounts[type] = (tempCounts[type] ?? 0) + 1;
//       }

//       if (caratWeight.containsKey(carat)) {
//         caratWeight[carat!] = caratWeight[carat]! + weight;
//         totalWeight += weight;
//       }

//       if (data['category'] == 'gem') {
//         stonesCount += 1;
//         stonesCost += (payload['cost'] ?? 0).toDouble();
//       }
//       if (data['category'] == 'bullion') {
//         BullionCount += 1;
//         BullionWeight += (payload['weight'] ?? 0).toDouble();
//       }
//     }

//     // 🟢 بيع القطع
//     final salesSnap = await FS.salesCol().get();
//     for (var d in salesSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final wage = (data['payment']?['total'] ?? 0).toDouble();
//       final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
//       final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
//       final date = (data['createdAt'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("بيع قطعة", "Piece Sale"),
//         "value": wage,
//         "date": date,
//         "data": data,
//       });
//       sum += wage;
//       cash += totalcash;
//       visa += totalvisa;
//     }

//     // 🟢 بيع كسر
//     final scrapSnap =
//         await FS.scrapCol().where("type", isEqualTo: "sale").get();
//     for (var d in scrapSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final wage = (data['total'] ?? 0).toDouble();
//       final totalcash = (data['cash'] ?? 0).toDouble();
//       final totalvisa = (data['network'] ?? 0).toDouble();
//       final date = (data['date'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("بيع كسر", "Scrap Sale"),
//         "value": wage,
//         "date": date,
//         "data": data,
//       });
//       sum += wage;
//       cash += totalcash;
//       visa += totalvisa;
//       scrapWeight -= (data['weight'] ?? 0).toDouble();
//     }

//     // 🔴 شراء كسر
//     final scrapBuySnap =
//         await FS.scrapCol().where("type", isEqualTo: "add").get();
//     for (var d in scrapBuySnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final wage = (data['total'] ?? 0).toDouble();
//       final totalcash = (data['cash'] ?? 0).toDouble();
//       final totalvisa = (data['network'] ?? 0).toDouble();
//       final date = (data['date'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("شراء كسر", "Scrap Purchase"),
//         "value": -wage,
//         "date": date,
//         "data": data,
//       });
//       sum -= wage;
//       cash -= totalcash;
//       visa -= totalvisa;
//       scrapWeight += (data['weight'] ?? 0).toDouble();
//     }

//     // 🔴 سندات الصرف
//     final vouchersSnap =
//         await FS.vouchersCol().where("type", isEqualTo: "payment").get();
//     for (var d in vouchersSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final wage = (data['total'] ?? 0).toDouble();
//       final totalcash = (data['cash'] ?? 0).toDouble();
//       final totalvisa = (data['network'] ?? 0).toDouble();
//       final date = (data['date'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("سند صرف", "Payment Voucher"),
//         "value": -wage,
//         "date": date,
//         "data": data,
//       });
//       sum -= wage;
//       cash -= totalcash;
//       visa -= totalvisa;
//     }

//     // 🔴 المصروفات
//     final now = DateTime.now();
//     final currentMonth = now.month;
//     final currentYear = now.year;
//     final expSnap = await FS.expensesCol().get();
//     for (var d in expSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
//       final date = (data['date'] as Timestamp?)?.toDate();

//       final displayType = _t('مصروف', 'Expense');
//       all.add({
//         "type": displayType,
//         "value": -amount,
//         "date": date,
//         "data": data,
//       });
//       if (date != null &&
//           date.month == currentMonth &&
//           date.year == currentYear) {
//         expenses_Month += amount;
//       }
//       sum -= amount;
//       cash -= amount;
//     }

//     // 🔵 توريد للإدارة
//     final depositSnap = await FS.depositsCol().get();
//     for (var d in depositSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final totalcash = (data['cash'] ?? 0).toDouble();
//       final totalvisa = (data['visa'] ?? 0).toDouble();
//       final totalValue = totalcash + totalvisa;
//       final date = (data['date'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("توريد للإدارة", "Deposit to Admin"),
//         "value": -totalValue,
//         "date": date,
//         "data": data,
//       });
//       if (date != null &&
//           date.month == currentMonth &&
//           date.year == currentYear) {
//         supply += totalValue;
//         supplycash += totalcash;
//         supplyvisa += totalvisa;
//       }
//       sum -= totalValue;
//       cash -= totalcash;
//       visa -= totalvisa;
//     }
//     // 🔵 استيراد من الإدارة
//     final ImportSnap = await FS.ImportedCol().get();
//     for (var d in ImportSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final totalcash = (data['cash'] ?? 0).toDouble();
//       final totalvisa = (data['visa'] ?? 0).toDouble();
//       final totalValue = totalcash + totalvisa;
//       final date = (data['date'] as Timestamp?)?.toDate();
//       all.add({
//         "type": _t("استيراد من الإدارة", "Import from Admin"),
//         "value": totalValue,
//         "date": date,
//         "data": data,
//       });
//       if (date != null &&
//           date.month == currentMonth &&
//           date.year == currentYear) {
//         import += totalValue;
//         importcash += totalcash;
//         importvisa += totalvisa;
//       }
//       sum += totalValue;
//       cash += totalcash;
//       visa += totalvisa;
//     }

//     int missingCount = 0;
//     int missing18 = 0;
//     int missing21 = 0;
//     int missing22 = 0;
//     int missingGem = 0;
//     int missingBullion = 0;

//     double missingwage18 = 0,
//         missingwage21 = 0,
//         missingwage22 = 0,
//         missingwagebullion = 0,
//         missingcostgem = 0;
//     double missingweight18 = 0,
//         missingweight21 = 0,
//         missingweight22 = 0,
//         missingweightbullion = 0;

//     // 🟡 inventories = المخزون الحالي (اللي مقروء فعليًا)
//     final inventoriesSnap = await FS.invCol().get();

//     // 🟡 IDs الموجودة في المخزون
//     final invIds = inventoriesSnap.docs.map((d) {
//       final data = d.data() as Map<String, dynamic>;
//       return data['epcHex'] ?? data['id'];
//     }).toSet();
//     List<Map<String, dynamic>> AllTags = [];

//     for (var doc in allInventoryDocs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final id = data['epcHex'] ?? data['id'];

//       if (!invIds.contains(id)) {
//         final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//         final entryDateStr = payload['entryDate']?.toString();
//         bool isMissingForMonth = false;

//         if (entryDateStr != null && entryDateStr.isNotEmpty) {
//           try {
//             final entryDate = DateTime.parse(entryDateStr);
//             final now = DateTime.now();
//             final difference = now.difference(entryDate);
//             isMissingForMonth = difference.inDays >= 30;
//           } catch (e) {
//             isMissingForMonth = true;
//           }
//         } else {
//           isMissingForMonth = true;
//         }

//         if (isMissingForMonth && id != null) {
//           missingEpcs.add(id.toString());
//           AllTags.add(data);
//         }

//         final category = data['category'] ?? 'gold';
//         final weight = (payload['weight'] ?? 0).toDouble();
//         final cost = (payload['cost'] ?? 0).toDouble();
//         final wage = (payload['wage'] ?? 0).toDouble();

//         if (category == 'gold') {
//           if (payload['carat'] == '18') {
//             missing18++;
//             missingwage18 += wage;
//             missingweight18 += weight;
//           } else if (payload['carat'] == '21') {
//             missing21++;
//             missingwage21 += wage;
//             missingweight21 += weight;
//           } else if (payload['carat'] == '22') {
//             missing22++;
//             missingwage22 += wage;
//             missingweight22 += weight;
//           }
//         } else if (category == 'bullion') {
//           missingBullion++;
//           missingwagebullion += wage;
//           missingweightbullion += weight;
//         } else if (category == 'gem') {
//           missingGem++;
//           missingcostgem += cost;
//         }

//         missingCount++;
//       }
//     }

//     // ✅ حساب الجرامات المعلقة من بقايا الأطقم (مرة واحدة عند التحميل)
//     double remainingKitsWeight = await _calculateRemainingKitsWeight();

//     all.sort((a, b) =>
//         (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

//     setState(() {
//       total = sum;
//       cashtotal = cash;
//       visatotal = visa;
//       lostItemsCount = missingCount;
//       loading = false;
//       missing_18 = missing18;
//       missing_21 = missing21;
//       missing_22 = missing22;
//       missing_Bullion = missingBullion;
//       missing_Gem = missingGem;
//       missingwage_18 = missingwage18;
//       missing_wage21 = missingwage21;
//       missing_wage22 = missingwage22;
//       missing_wagebullion = missingwagebullion;
//       missing_costgem = missingcostgem;
//       missingweight_18 = missingweight18;
//       missing_weight21 = missingweight21;
//       missing_weight22 = missingweight22;
//       missing_weightbullion = missingweightbullion;
//       deptCount = tempCounts;
//       AllMissingTags = AllTags;

//       // ✅ تحديث الجرامات المعلقة
//       _remainingKitsWeight = remainingKitsWeight;

//       // Set deleted items data
//       deletedGoldCount = 0;
//       deletedGemCount = 0;
//       deletedBullionCount = 0;
//       deletedGoldWeight = 0;
//       deletedGoldWage = 0;
//       deletedGemCost = 0;
//       deletedBullionWeight = 0;
//       deletedBullionWage = 0;
//       deletedItems = [];
//     });
//   }

//   Map<String, List<Map<String, dynamic>>> missingByDepartment = {};
//   void _calculateMissingItems() {
//     missingByDepartment.clear();

//     for (var item in AllMissingTags) {
//       final epc = item['epcHex']?.toString().toUpperCase();
//       if (epc == null) continue;

//       final payload = item['payload'] as Map<String, dynamic>?;
//       if (payload == null) continue;

//       final kind = payload['kind']?.toString();
//       final type = payload['type']?.toString();
//       final category = item['category']?.toString().toLowerCase();

//       String? department;

//       if (category == 'bullion') {
//         department = 'سبائك';
//       } else if (kind != null) {
//         department = kind;
//       } else if (type != null) {
//         department = type;
//       }

//       if (department == null) continue;

//       missingByDepartment.putIfAbsent(department, () => []);
//       missingByDepartment[department]!.add(item);
//     }

//     setState(() {});
//   }

//   void _showMissingDialog() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Dialog(
//             child: SizedBox(
//               height: 600,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: missingByDepartment.entries.map((entry) {
//                   final department = entry.key;
//                   final items = entry.value;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "$department (${items.length})",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ...items.map((item) {
//                         final payload =
//                             item['payload'] as Map<String, dynamic>? ?? {};

//                         return Card(
//                           child: ListTile(
//                             subtitle: Text(
//                               [
//                                 if (item['epcHex'] != null &&
//                                     item['epcHex'].toString().isNotEmpty)
//                                   "رقم الشريحة: ${item['epcHex']}",
//                                 if (payload['carat'] != null &&
//                                     payload['carat'].toString().isNotEmpty)
//                                   "العيار: ${payload['carat']}",
//                                 if (payload['size'] != null &&
//                                     payload['size'].toString().isNotEmpty)
//                                   "المقاس: ${payload['size']}",
//                                 if (payload['weight'] != null)
//                                   "الوزن: ${payload['weight']}",
//                                 if (payload['wage'] != null)
//                                   "الاجر: ${payload['wage']}",
//                                 if (payload['notes'] != null)
//                                   "الملاحظات: ${payload['notes']}",
//                                 if (item['createdAt'] != null)
//                                   "تاريخ الادخال: ${_formatDate(item['createdAt'])}",
//                                 if (payload['qrCode'] != null &&
//                                     payload['qrCode'].toString().isNotEmpty)
//                                   "الكود: ${payload['qrCode']}",
//                               ].join("\n"),
//                             ),
//                             trailing: item['epcHex'] != null
//                                 ? IconButton(
//                                     icon: const Icon(Icons.image,
//                                         color: Colors.blue),
//                                     onPressed: () async {
//                                       final epcHex = item['epcHex'];
//                                       final uid = FirebaseAuth
//                                           .instance.currentUser!.uid;

//                                       final storageRef = FirebaseStorage
//                                           .instance
//                                           .ref()
//                                           .child('images')
//                                           .child('users')
//                                           .child(uid)
//                                           .child(epcHex);

//                                       try {
//                                         final result =
//                                             await storageRef.listAll();

//                                         if (result.items.isEmpty) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                                 content:
//                                                     Text("لا يوجد صور محفوظة")),
//                                           );
//                                           return;
//                                         }

//                                         final urls = await Future.wait(
//                                           result.items.map(
//                                               (ref) => ref.getDownloadURL()),
//                                         );

//                                         showDialog(
//                                           context: context,
//                                           builder: (_) => Dialog(
//                                             child: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               width: double.maxFinite,
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   const Text(
//                                                     "صور الشريحة",
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 8),
//                                                   SizedBox(
//                                                     height: 400,
//                                                     child: ListView.builder(
//                                                       itemCount: urls.length,
//                                                       itemBuilder: (_, i) =>
//                                                           Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(4),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             showDialog(
//                                                               context: context,
//                                                               builder: (_) =>
//                                                                   Scaffold(
//                                                                 backgroundColor:
//                                                                     Colors
//                                                                         .black,
//                                                                 body: Stack(
//                                                                   children: [
//                                                                     Center(
//                                                                       child:
//                                                                           InteractiveViewer(
//                                                                         minScale:
//                                                                             0.5,
//                                                                         maxScale:
//                                                                             5.0,
//                                                                         child: Image
//                                                                             .network(
//                                                                           urls[
//                                                                               i],
//                                                                           fit: BoxFit
//                                                                               .contain,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Positioned(
//                                                                       top: 40,
//                                                                       right: 20,
//                                                                       child:
//                                                                           IconButton(
//                                                                         icon:
//                                                                             const Icon(
//                                                                           Icons
//                                                                               .close,
//                                                                           color:
//                                                                               Colors.white,
//                                                                           size:
//                                                                               30,
//                                                                         ),
//                                                                         onPressed:
//                                                                             () =>
//                                                                                 Navigator.pop(context),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           },
//                                                           child: Image.network(
//                                                             urls[i],
//                                                             width: 200,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   TextButton(
//                                                     onPressed: () =>
//                                                         Navigator.pop(context),
//                                                     child: const Text("إغلاق"),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       } catch (e) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                               content: Text("فشل تحميل الصور")),
//                                         );
//                                       }
//                                     },
//                                   )
//                                 : null,
//                           ),
//                         );
//                       }),
//                       const SizedBox(height: 16),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDate(dynamic timestamp) {
//     if (timestamp == null) return "";

//     final date = timestamp.toDate();

//     return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
//         "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
//   }

//   void _showNoMissingDialog() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Icon(
//                 Icons.verified,
//                 color: Colors.green,
//                 size: 60,
//               ),
//               SizedBox(height: 12),
//               Text(
//                 "لا يوجد عناصر مفقودة",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 6),
//               Text(
//                 "تم جرد جميع العناصر بنجاح",
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("حسناً"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   // ================= UI COMPONENTS =================

//   Widget statCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     Color? color,
//     Color? bg,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: bg ?? Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 25),
//           const SizedBox(height: 6),
//           Text(title, style: const TextStyle(fontSize: 14)),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget sectionCard(String title, Widget child) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget rowItem(String title, String value, {Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title),
//           Text(
//             value,
//             style: TextStyle(fontWeight: FontWeight.bold, color: color),
//           ),
//         ],
//       ),
//     );
//   }

//   double _percent(double value) {
//     if (totalWeight == 0) return 0;
//     return (value / totalWeight) * 100;
//   }

//   // ================= BUILD =================

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       appBar: AppBar(
//         title: Text("تقرير الرصيد العام"),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               setState(() {
//                 loading = true;
//               });
//               _loadData();
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             /// 🔹 TOP CARDS
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.4,
//               children: [
//                 statCard(
//                   title: 'اجمالي وزن العيارات',
//                   value: '${totalWeight.toStringAsFixed(2)} جرام',
//                   icon: Icons.balance,
//                   color: Colors.blue,
//                 ),
//                 statCard(
//                   title: 'اجمالي الصندوق',
//                   value: '${total.toStringAsFixed(0)} ريال',
//                   icon: Icons.attach_money,
//                   color: Colors.blue,
//                 ),
//                 statCard(
//                   title: 'رصيد الكاش',
//                   value: '${cashtotal.toStringAsFixed(0)} ريال',
//                   icon: Icons.attach_money,
//                   color: Colors.green,
//                 ),
//                 statCard(
//                   title: 'رصيد الشبكة',
//                   value: '${visatotal.toStringAsFixed(0)} ريال',
//                   icon: Icons.track_changes,
//                   color: Colors.green,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// 🔹 REMAINING KITS CARD
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.inventory_2_outlined,
//                       color: Color(0xFFD4AF37),
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _t('إجمالي الجرامات المعلقة',
//                               'Total Remaining Grams'),
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${_remainingKitsWeight.toStringAsFixed(2)} جم',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// 🔹 DISTRIBUTION
//             sectionCard(
//               'توزيع الأوزان حسب العيار',
//               Column(
//                 children: [
//                   _caratRow(
//                     'عيار 18',
//                     caratWeight[18]!,
//                     Colors.orange,
//                   ),
//                   _caratRow(
//                     'عيار 21',
//                     caratWeight[21]!,
//                     Colors.green,
//                   ),
//                   _caratRow(
//                     'عيار 22',
//                     caratWeight[22]!,
//                     Colors.red,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),
//             if (deptCount.isNotEmpty) const SizedBox(height: 25),
//             Padding(
//               padding: const EdgeInsets.only(),
//               child: Text(
//                 _t("عدد الاقسام المسجلة", "Number of dept existed"),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: deptCount.entries.map((entry) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: const Color(0xFFD4AF37)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.category,
//                             size: 18, color: Color(0xFFD4AF37)),
//                         const SizedBox(width: 6),
//                         Text(
//                           "${entry.key} : ${entry.value}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: sectionCard(
//                 'نظرة سريعة',
//                 Column(
//                   children: [
//                     rowItem(
//                         'رصيد الكسر', '${scrapWeight.toStringAsFixed(2)} جرام'),
//                     rowItem('عدد الاحجار', '${stonesCount.toStringAsFixed(2)} ',
//                         color: Colors.purple),
//                     rowItem(
//                         'عدد السبائك', '${BullionCount.toStringAsFixed(2)} ',
//                         color: Color(0xFFD4AF37)),
//                     rowItem('وزن السبائك',
//                         '${BullionWeight.toStringAsFixed(2)} جرام',
//                         color: Color(0xFFD4AF37)),
//                     rowItem('توريدات للادراة هذا الشهر',
//                         ' كاش : ${supplycash.toStringAsFixed(0)} شبكة : ${supplyvisa.toStringAsFixed(0)}',
//                         color: Colors.red),
//                     rowItem('استيرادات الادراة هذا الشهر',
//                         ' كاش : ${importcash.toStringAsFixed(0)} شبكة : ${importvisa.toStringAsFixed(0)}',
//                         color: Colors.red),
//                     rowItem('المصروفات هذا الشهر ',
//                         '${expenses_Month.toStringAsFixed(0)} ريال',
//                         color: Colors.green),
//                     rowItem('رصيد بيع جزئي متبقي',
//                         '${balancesWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.orange),
//                     rowItem('عدد أرصدة البيع الجزئي', '$balancesCount',
//                         color: Colors.orange),
//                     rowItem('عدد الذهب المحذوف', '$deletedGoldCount',
//                         color: Colors.red),
//                     rowItem('وزن الذهب المحذوف',
//                         '${deletedGoldWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.red),
//                     rowItem('عدد الأحجار المحذوفة', '$deletedGemCount',
//                         color: Colors.purple),
//                     rowItem('تكلفة الأحجار المحذوفة',
//                         '${deletedGemCost.toStringAsFixed(0)} ريال',
//                         color: Colors.purple),
//                     rowItem('عدد السبائك المحذوفة', '$deletedBullionCount',
//                         color: Colors.orange),
//                     rowItem('وزن السبائك المحذوفة',
//                         '${deletedBullionWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.orange),
//                     const Divider(),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size.fromHeight(45),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.warning, color: Colors.white),
//               label: const Text(
//                 "عرض المفقود",
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 _calculateMissingItems();

//                 if (missingByDepartment.isEmpty) {
//                   _showNoMissingDialog();
//                 } else {
//                   _showMissingDialog();
//                 }
//               },
//             ),

//             const SizedBox(height: 16),
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: sectionCard(
//                 'الموردين',
//                 StreamBuilder<List<Map<String, dynamic>>>(
//                   stream: FS.suppliersStream(),
//                   builder: (context, snap) {
//                     if (!snap.hasData) {
//                       return const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }

//                     final suppliers = snap.data!;

//                     if (suppliers.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Text(
//                           'لا يوجد موردين حالياً',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       );
//                     }

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               showSuppliers = !showSuppliers;
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'عدد الموردين: ${suppliers.length}',
//                                   textAlign: TextAlign.right,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Icon(
//                                 showSuppliers
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 size: 28,
//                               ),
//                             ],
//                           ),
//                         ),
//                         AnimatedCrossFade(
//                           firstChild: const SizedBox.shrink(),
//                           secondChild: ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             padding: const EdgeInsets.only(top: 12),
//                             itemCount: suppliers.length,
//                             itemBuilder: (_, i) {
//                               final s = suppliers[i];
//                               return _supplierCard(s);
//                             },
//                           ),
//                           crossFadeState: showSuppliers
//                               ? CrossFadeState.showSecond
//                               : CrossFadeState.showFirst,
//                           duration: const Duration(milliseconds: 250),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _supplierCard(Map<String, dynamic> s) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.blue.shade100,
//           child: const Icon(Icons.person, color: Colors.blue),
//         ),
//         title: Text(
//           s["name"],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: FutureBuilder<Map<String, dynamic>>(
//           future: _supplierSummary(s["id"]),
//           builder: (context, snap) {
//             if (!snap.hasData) {
//               return const Text("جاري حساب الرصيد...");
//             }

//             final data = snap.data!;
//             final bool cleared = data["cleared"];
//             final double w = data["weight"];
//             final double g = data["wage"];

//             Color color;
//             String status;

//             if (cleared) {
//               color = Colors.green;
//               status = "تمت تصفية الحساب";
//             } else if (w > 0) {
//               color = Colors.red;
//               status = "للمورد";
//             } else {
//               color = Colors.green.shade700;
//               status = "على المورد";
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("📞 ${s["phone"] ?? '-'}"),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 if (!cleared) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     "وزن: ${w.abs().toStringAsFixed(2)} جم • أجر: ${g.abs().toStringAsFixed(2)}",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         ),
//         onTap: () async {
//           final vouchers = await FS.getVouchersForSupplier(s["id"]);

//           final Map<String, double> totalPaymentWeight = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalReceiptWeight = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalPaymentWage = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalReceiptWage = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };

//           for (var v in vouchers) {
//             final carat = (v["carat"] ?? "").toString();
//             final weight =
//                 double.tryParse(v["weight"]?.toString() ?? "0") ?? 0.0;
//             final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0.0;

//             if (["18", "21", "22"].contains(carat)) {
//               if (v["type"] == "payment") {
//                 totalPaymentWeight[carat] =
//                     (totalPaymentWeight[carat] ?? 0) + weight;
//                 totalPaymentWage[carat] = (totalPaymentWage[carat] ?? 0) + wage;
//               } else if (v["type"] == "receipt") {
//                 totalReceiptWeight[carat] =
//                     (totalReceiptWeight[carat] ?? 0) + weight;
//                 totalReceiptWage[carat] = (totalReceiptWage[carat] ?? 0) + wage;
//               }
//             }
//           }

//           final Map<String, double> balanceWeight = {};
//           final Map<String, double> balanceWage = {};

//           for (var c in ["18", "21", "22"]) {
//             balanceWeight[c] = totalReceiptWeight[c]! - totalPaymentWeight[c]!;
//             balanceWage[c] = totalReceiptWage[c]! - totalPaymentWage[c]!;
//           }

//           final totalBalanceWeight =
//               balanceWeight.values.fold(0.0, (a, b) => a + b);
//           final totalBalanceWage =
//               balanceWage.values.fold(0.0, (a, b) => a + b);

//           final allCleared =
//               balanceWeight.values.every((v) => v.abs() < 0.0001) &&
//                   balanceWage.values.every((v) => v.abs() < 0.0001);

//           showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               title: Center(
//                 child: Text(
//                   _t("رصيد المورد", "Supplier Balance"),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 height: MediaQuery.of(context).size.height * 0.85,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Card(
//                         elevation: 2,
//                         color: allCleared
//                             ? Colors.green.shade50
//                             : totalBalanceWeight > 0
//                                 ? Colors.amber.shade50
//                                 : Colors.red.shade50,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(14),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 allCleared
//                                     ? Icons.check_circle
//                                     : (totalBalanceWeight > 0
//                                         ? Icons.account_balance_wallet
//                                         : Icons.warning_amber_rounded),
//                                 color: allCleared
//                                     ? Colors.green
//                                     : (totalBalanceWeight > 0
//                                         ? Colors.red
//                                         : Colors.green),
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     if (allCleared)
//                                       Text(
//                                         _t("تمت تصفية الحساب بالكامل ",
//                                             "Account fully settled "),
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 17,
//                                           color: Colors.green,
//                                         ),
//                                       )
//                                     else ...[
//                                       Text(
//                                         totalBalanceWeight > 0
//                                             ? _t("للمورد", "Supplier balance")
//                                             : _t("على المورد", "Supplier owes"),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 17,
//                                           color: totalBalanceWeight > 0
//                                               ? Colors.red.shade800
//                                               : Colors.green.shade800,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             "${_t("الوزن", "Weight")}: ${totalBalanceWeight.abs().toStringAsFixed(2)} جم",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           const SizedBox(width: 12),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             "${_t("الأجر", "Wage")}: ${totalBalanceWage.abs().toStringAsFixed(2)}",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       if (!allCleared)
//                         Card(
//                           elevation: 1,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   _t("تفاصيل حسب العيار", "Details by Carat"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 GridView.count(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   crossAxisCount: 2,
//                                   mainAxisSpacing: 6,
//                                   crossAxisSpacing: 6,
//                                   childAspectRatio: 1.1,
//                                   children: ["18", "21", "22"].map((c) {
//                                     final bw = balanceWeight[c]!;
//                                     final wg = balanceWage[c]!;

//                                     final bool cleared =
//                                         bw.abs() < 0.0001 && wg.abs() < 0.0001;

//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: cleared
//                                             ? Colors.grey.shade100
//                                             : bw > 0
//                                                 ? Colors.red.shade50
//                                                 : bw < 0
//                                                     ? Colors.green.shade50
//                                                     : Colors.amber.shade50,
//                                         border: Border.all(
//                                           color: cleared
//                                               ? Colors.grey.shade300
//                                               : bw > 0
//                                                   ? Colors.red.shade300
//                                                   : Colors.green.shade300,
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text("عيار $c",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               "${_t("وزن", "weight")}: ${bw.toStringAsFixed(2)}",
//                                               style: TextStyle(
//                                                   color: bw == 0
//                                                       ? Colors.grey
//                                                       : bw > 0
//                                                           ? Colors.red.shade800
//                                                           : Colors
//                                                               .green.shade800,
//                                                   fontSize: 13),
//                                             ),
//                                             Text(
//                                               "${_t("أجر", "Wage")}: ${wg.toStringAsFixed(2)}",
//                                               style:
//                                                   const TextStyle(fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 16),
//                       const Divider(thickness: 1),
//                       const SizedBox(height: 6),
//                       Text(
//                         _t("قائمة السندات", "Vouchers List"),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 15),
//                       ),
//                       const SizedBox(height: 8),
//                       ...vouchers.map((v) {
//                         final isReceipt = v["type"] == "receipt";

//                         return Card(
//                           elevation: 2,
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: isReceipt
//                                           ? Colors.red.shade100
//                                           : Colors.green.shade100,
//                                       child: Icon(
//                                         isReceipt
//                                             ? Icons.download_done
//                                             : Icons.upload,
//                                         color: isReceipt
//                                             ? Colors.red
//                                             : Colors.green,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       isReceipt
//                                           ? _t("سند قبض", "Receipt Voucher")
//                                           : _t("سند صرف", "Payment Voucher"),
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15),
//                                     ),
//                                     const Spacer(),
//                                     if (v["date"] != null)
//                                       Text(
//                                         " ${(v["date"] as Timestamp).toDate().toString().split(' ')[0]}",
//                                         style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 12),
//                                       ),
//                                   ],
//                                 ),
//                                 const Divider(height: 16),
//                                 Text(
//                                     "${_t("المندوب", "Delegate")}: ${v["delegate"] ?? "-"}"),
//                                 Text(
//                                     "${_t("العيار", "Carat")}: ${v["carat"] ?? "-"}"),
//                                 Text(
//                                     "${_t("الوزن", "Weight")}: ${v["weight"] ?? 0} g"),
//                                 Text(
//                                     "${_t("الأجر", "Wage")}: ${v["wage"] ?? 0}"),
//                                 if (!isReceipt) ...[
//                                   if (v["paymentMethod"] != null)
//                                     Text(
//                                         "${_t("طريقة الدفع", "Payment Method")}: ${v["paymentMethod"]}"),
//                                   if (v["cash"] != null)
//                                     Text("${_t("كاش", "Cash")}: ${v["cash"]}"),
//                                   if (v["network"] != null)
//                                     Text(
//                                         "${_t("شبكة", "Network")}: ${v["network"]}"),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
//     final vouchers = await FS.getVouchersForSupplier(supplierId);

//     double payW = 0, recW = 0;
//     double payG = 0, recG = 0;

//     for (var v in vouchers) {
//       final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

//       if (v["type"] == "payment") {
//         payW += weight;
//         payG += wage;
//       } else if (v["type"] == "receipt") {
//         recW += weight;
//         recG += wage;
//       }
//     }

//     final balanceWeight = recW - payW;
//     final balanceWage = recG - payG;

//     final cleared = balanceWeight.abs() < 0.0001 && balanceWage.abs() < 0.0001;

//     return {
//       "cleared": cleared,
//       "weight": balanceWeight,
//       "wage": balanceWage,
//     };
//   }

//   Widget _lostDetails() {
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         _summaryCard(
//           title: 'ذهب',
//           children: [
//             _summaryRow('عيار 18',
//                 count: missing_18,
//                 weight: missingweight_18,
//                 wage: missingwage_18),
//             _summaryRow('عيار 21',
//                 count: missing_21,
//                 weight: missing_weight21,
//                 wage: missing_wage21),
//             _summaryRow('عيار 22',
//                 count: missing_22,
//                 weight: missing_weight22,
//                 wage: missing_wage22),
//           ],
//         ),
//         const SizedBox(height: 8),
//         _summaryCard(
//           title: 'سبائك',
//           children: [
//             _summaryRow(
//               'سبائك',
//               count: missing_Bullion,
//               weight: missing_weightbullion,
//               cost: missing_wagebullion,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         _summaryCard(
//           title: 'أحجار',
//           children: [
//             _summaryRow(
//               'أحجار',
//               count: missing_Gem,
//               cost: missing_costgem,
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isLoadingImages ? null : _loadAllMissingImages,
//           child: isLoadingImages
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text("عرض كل صور العناصر المفقودة"),
//         ),
//       ],
//     );
//   }

//   Future<void> _loadAllMissingImages() async {
//     if (missingEpcs.isEmpty) return;

//     setState(() => isLoadingImages = true);

//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     try {
//       final futures = missingEpcs.map((epc) async {
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('images')
//             .child('users')
//             .child(uid)
//             .child(epc);

//         final result = await storageRef.listAll();

//         return Future.wait(
//           result.items.map((ref) => ref.getDownloadURL()),
//         );
//       });

//       final results = await Future.wait(futures);

//       allMissingImageUrls = results.expand((element) => element).toList();

//       setState(() => isLoadingImages = false);

//       if (allMissingImageUrls.isNotEmpty) {
//         _openImageViewer();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("لا توجد صور محفوظة")),
//         );
//       }
//     } catch (e) {
//       setState(() => isLoadingImages = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("فشل تحميل الصور")),
//       );
//     }
//   }

//   void _openImageViewer() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         PageController controller = PageController();

//         return Dialog(
//           insetPadding: EdgeInsets.zero,
//           child: Stack(
//             children: [
//               PageView.builder(
//                 controller: controller,
//                 itemCount: allMissingImageUrls.length,
//                 itemBuilder: (_, index) {
//                   return InteractiveViewer(
//                     child: Image.network(
//                       allMissingImageUrls[index],
//                       fit: BoxFit.contain,
//                     ),
//                   );
//                 },
//               ),
//               Positioned(
//                 top: 20,
//                 right: 20,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.red, size: 30),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _summaryCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const Divider(),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow(
//     String label, {
//     int? count,
//     double? weight,
//     double? wage,
//     double? cost,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           if (count != null) Text('عدد الشرائح: $count'),
//           if (weight != null) Text('الوزن: ${weight.toStringAsFixed(2)} جرام'),
//           if (wage != null) Text('الأجر: ${wage.toStringAsFixed(2)} ريال'),
//           if (cost != null) Text('التكلفة: ${cost.toStringAsFixed(2)} ريال'),
//         ],
//       ),
//     );
//   }

//   Widget _caratRow(String title, double weight, Color color) {
//     final percent = _percent(weight);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(
//                 '${weight.toStringAsFixed(2)}   •  ${percent.toStringAsFixed(1)}%',
//                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           LinearProgressIndicator(
//             value: percent / 100,
//             backgroundColor: color.withOpacity(.15),
//             valueColor: AlwaysStoppedAnimation(color),
//             minHeight: 8,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ],
//       ),
//     );
//   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class GeneralBalancePage extends StatefulWidget {
//   const GeneralBalancePage({super.key});

//   @override
//   State<GeneralBalancePage> createState() => _GeneralBalancePageState();
// }

// class _GeneralBalancePageState extends State<GeneralBalancePage> {
//   bool loading = true;

//   double totalWeight = 0;
//   Map<int, double> caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};

//   int stonesCount = 0;
//   int BullionCount = 0;
//   double stonesCost = 0;
//   double BullionWeight = 0;

//   double scrapWeight = 0;
//   double supply = 0;
//   double import = 0;
//   double supplycash = 0;
//   double importcash = 0;
//   double supplyvisa = 0;
//   double importvisa = 0;
//   double balancesWeight = 0;
//   int balancesCount = 0;

//   double total = 0.0;
//   double cashtotal = 0.0;
//   double visatotal = 0.0;
//   int lostItemsCount = 0;

//   int missing_18 = 0;
//   int missing_21 = 0;
//   int missing_22 = 0;
//   int missing_Gem = 0;
//   int missing_Bullion = 0;
//   List<String> missingEpcs = [];
//   bool isLoadingImages = false;
//   List<String> allMissingImageUrls = [];
//   Map<String, int> deptCount = {};

//   double missingwage_18 = 0,
//       missing_wage21 = 0,
//       missing_wage22 = 0,
//       missing_wagebullion = 0,
//       missing_costgem = 0;
//   double missingweight_18 = 0,
//       missing_weight21 = 0,
//       missing_weight22 = 0,
//       missing_weightbullion = 0;

//   // ✅ الجرامات المعلقة من بقايا الأطقم
//   double _remainingKitsWeight = 0.0;

//   // Deleted items tracking
//   int deletedGoldCount = 0;
//   int deletedGemCount = 0;
//   int deletedBullionCount = 0;
//   double deletedGoldWeight = 0;
//   double deletedGoldWage = 0;
//   double deletedGemCost = 0;
//   double deletedBullionWeight = 0;
//   double deletedBullionWage = 0;
//   List<Map<String, dynamic>> deletedItems = [];
//   bool showLostDetails = false;
//   bool showSuppliers = false;
//   double expenses_Month = 0;

//   List<Map<String, dynamic>> suppliers = [];
//   List<Map<String, dynamic>> AllMissingTags = [];

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   Map<String, List<Map<String, dynamic>>> lostItemsByCategory = {
//     'gold': [],
//     'gem': [],
//     'bullion': [],
//   };

//   // ✅ Stream Subscription
//   StreamSubscription? _kitsSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();

//     // ✅ تحميل البيانات بعد رسم الواجهة مباشرة (لعدم تجميد التطبيق)
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadData();
//       _listenToKitsChanges();
//     });
//   }

//   @override
//   void dispose() {
//     _kitsSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     _lang = prefs.getString('languageCode') ?? 'ar';
//   }

//   // ✅ الاستماع للتحديثات في بقايا الأطقم
//   void _listenToKitsChanges() {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     _kitsSubscription = FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('setRemainders')
//         .snapshots()
//         .listen((snapshot) {
//       double totalRemaining = 0.0;

//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final payload = data['payload'] as Map<String, dynamic>? ?? {};

//         final originalWeight =
//             (payload['originalWeight'] as num?)?.toDouble() ??
//                 (payload['weight'] as num?)?.toDouble() ??
//                 0;
//         final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//         final remainingWeight = originalWeight - soldWeight;

//         // ✅ فقط الوزن الموجب
//         if (remainingWeight > 0) {
//           totalRemaining += remainingWeight;
//         }
//       }

//       if (mounted) {
//         setState(() {
//           _remainingKitsWeight = totalRemaining;
//         });
//       }
//     });
//   }

//   // ✅ دالة لحساب الجرامات المعلقة (تستخدم في التحميل الأول)
//   Future<double> _calculateRemainingKitsWeight() async {
//     double totalRemaining = 0.0;

//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         final kitsSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .doc(uid)
//             .collection('setRemainders')
//             .get();

//         for (var doc in kitsSnapshot.docs) {
//           final data = doc.data();
//           final payload = data['payload'] as Map<String, dynamic>? ?? {};

//           final originalWeight =
//               (payload['originalWeight'] as num?)?.toDouble() ??
//                   (payload['weight'] as num?)?.toDouble() ??
//                   0;
//           final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
//           final remainingWeight = originalWeight - soldWeight;

//           if (remainingWeight > 0) {
//             totalRemaining += remainingWeight;
//           }
//         }
//       }
//     } catch (e) {
//       print('Error loading remaining kits: $e');
//     }

//     return totalRemaining;
//   }

//   // ✅ شاشة التحميل المحسنة
//   Widget _buildLoadingScreen() {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
//               strokeWidth: 4,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               _t('جاري تحميل البيانات...', 'Loading data...'),
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFFD4AF37),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _t('يرجى الانتظار', 'Please wait'),
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _loadData() async {
//     // ✅ إظهار شاشة التحميل
//     if (mounted) setState(() => loading = true);

//     try {
//       // =====================================================
//       // ✅ إعادة تعيين كل المتغيرات قبل الجمع (مهم جداً)
//       // =====================================================
//       totalWeight = 0;
//       caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};
//       stonesCount = 0;
//       BullionCount = 0;
//       stonesCost = 0;
//       BullionWeight = 0;
//       scrapWeight = 0;
//       balancesWeight = 0;
//       balancesCount = 0;
//       deptCount = {};
//       missingEpcs.clear();
//       AllMissingTags.clear();

//       double sum = 0.0;
//       double cash = 0.0;
//       double visa = 0.0;
//       List<Map<String, dynamic>> all = [];

//       // ✅ استخدام Future.wait لجلب البيانات بالتوازي (أسرع بكثير)
//       final results = await Future.wait([
//         FS.itemsCol().get(),
//         FS.balancesCol().get(),
//         FS.salesCol().get(),
//         FS.scrapCol().where("type", isEqualTo: "sale").get(),
//         FS.scrapCol().where("type", isEqualTo: "add").get(),
//         FS.vouchersCol().where("type", isEqualTo: "payment").get(),
//         FS.expensesCol().get(),
//         FS.depositsCol().get(),
//         FS.ImportedCol().get(),
//         FS.invCol().get(),
//       ]);

//       final itemsSnap = results[0];
//       final balancesSnap = results[1];
//       final salesSnap = results[2];
//       final scrapSnap = results[3];
//       final scrapBuySnap = results[4];
//       final vouchersSnap = results[5];
//       final expSnap = results[6];
//       final depositSnap = results[7];
//       final ImportSnap = results[8];
//       final inventoriesSnap = results[9];

//       balancesCount = balancesSnap.docs.length;
//       Map<String, int> tempCounts = {};
//       final allInventoryDocs = [...itemsSnap.docs, ...balancesSnap.docs];

//       for (var doc in allInventoryDocs) {
//         final data = doc.data() as Map<String, dynamic>;
//         final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//         final isBalance = doc.reference.parent.id == 'balances';
//         final weight = (payload['weight'] ?? 0).toDouble();
//         if (isBalance) balancesWeight += weight;

//         final carat = int.tryParse(payload['carat']?.toString() ?? '');
//         final kind = payload['kind']?.toString();
//         final type = payload['type']?.toString();
//         if (data['category'] == "bullion") {
//           tempCounts['سبائك'] = (tempCounts['سبائك'] ?? 0) + 1;
//         }

//         if (kind != null) {
//           tempCounts[kind] = (tempCounts[kind] ?? 0) + 1;
//         }

//         if (type != null) {
//           tempCounts[type] = (tempCounts[type] ?? 0) + 1;
//         }

//         if (caratWeight.containsKey(carat)) {
//           caratWeight[carat!] = caratWeight[carat]! + weight;
//           totalWeight += weight;
//         }

//         if (data['category'] == 'gem') {
//           stonesCount += 1;
//           stonesCost += (payload['cost'] ?? 0).toDouble();
//         }
//         if (data['category'] == 'bullion') {
//           BullionCount += 1;
//           BullionWeight += (payload['weight'] ?? 0).toDouble();
//         }
//       }

//       // 🟢 بيع القطع
//       for (var d in salesSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final wage = (data['payment']?['total'] ?? 0).toDouble();
//         final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
//         final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
//         final date = (data['createdAt'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("بيع قطعة", "Piece Sale"),
//           "value": wage,
//           "date": date,
//           "data": data,
//         });
//         sum += wage;
//         cash += totalcash;
//         visa += totalvisa;
//       }

//       // 🟢 بيع كسر
//       for (var d in scrapSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final wage = (data['total'] ?? 0).toDouble();
//         final totalcash = (data['cash'] ?? 0).toDouble();
//         final totalvisa = (data['network'] ?? 0).toDouble();
//         final date = (data['date'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("بيع كسر", "Scrap Sale"),
//           "value": wage,
//           "date": date,
//           "data": data,
//         });
//         sum += wage;
//         cash += totalcash;
//         visa += totalvisa;
//         scrapWeight -= (data['weight'] ?? 0).toDouble();
//       }

//       // 🔴 شراء كسر
//       for (var d in scrapBuySnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final wage = (data['total'] ?? 0).toDouble();
//         final totalcash = (data['cash'] ?? 0).toDouble();
//         final totalvisa = (data['network'] ?? 0).toDouble();
//         final date = (data['date'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("شراء كسر", "Scrap Purchase"),
//           "value": -wage,
//           "date": date,
//           "data": data,
//         });
//         sum -= wage;
//         cash -= totalcash;
//         visa -= totalvisa;
//         scrapWeight += (data['weight'] ?? 0).toDouble();
//       }

//       // 🔴 سندات الصرف
//       for (var d in vouchersSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final wage = (data['total'] ?? 0).toDouble();
//         final totalcash = (data['cash'] ?? 0).toDouble();
//         final totalvisa = (data['network'] ?? 0).toDouble();
//         final date = (data['date'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("سند صرف", "Payment Voucher"),
//           "value": -wage,
//           "date": date,
//           "data": data,
//         });
//         sum -= wage;
//         cash -= totalcash;
//         visa -= totalvisa;
//       }

//       // 🔴 المصروفات
//       final now = DateTime.now();
//       final currentMonth = now.month;
//       final currentYear = now.year;
//       for (var d in expSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
//         final date = (data['date'] as Timestamp?)?.toDate();

//         final displayType = _t('مصروف', 'Expense');
//         all.add({
//           "type": displayType,
//           "value": -amount,
//           "date": date,
//           "data": data,
//         });
//         if (date != null &&
//             date.month == currentMonth &&
//             date.year == currentYear) {
//           expenses_Month += amount;
//         }
//         sum -= amount;
//         cash -= amount;
//       }

//       // 🔵 توريد للإدارة
//       for (var d in depositSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final totalcash = (data['cash'] ?? 0).toDouble();
//         final totalvisa = (data['visa'] ?? 0).toDouble();
//         final totalValue = totalcash + totalvisa;
//         final date = (data['date'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("توريد للإدارة", "Deposit to Admin"),
//           "value": -totalValue,
//           "date": date,
//           "data": data,
//         });
//         if (date != null &&
//             date.month == currentMonth &&
//             date.year == currentYear) {
//           supply += totalValue;
//           supplycash += totalcash;
//           supplyvisa += totalvisa;
//         }
//         sum -= totalValue;
//         cash -= totalcash;
//         visa -= totalvisa;
//       }

//       // 🔵 استيراد من الإدارة
//       for (var d in ImportSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         final totalcash = (data['cash'] ?? 0).toDouble();
//         final totalvisa = (data['visa'] ?? 0).toDouble();
//         final totalValue = totalcash + totalvisa;
//         final date = (data['date'] as Timestamp?)?.toDate();
//         all.add({
//           "type": _t("استيراد من الإدارة", "Import from Admin"),
//           "value": totalValue,
//           "date": date,
//           "data": data,
//         });
//         if (date != null &&
//             date.month == currentMonth &&
//             date.year == currentYear) {
//           import += totalValue;
//           importcash += totalcash;
//           importvisa += totalvisa;
//         }
//         sum += totalValue;
//         cash += totalcash;
//         visa += totalvisa;
//       }

//       int missingCount = 0;
//       int missing18 = 0;
//       int missing21 = 0;
//       int missing22 = 0;
//       int missingGem = 0;
//       int missingBullion = 0;

//       double missingwage18 = 0,
//           missingwage21 = 0,
//           missingwage22 = 0,
//           missingwagebullion = 0,
//           missingcostgem = 0;
//       double missingweight18 = 0,
//           missingweight21 = 0,
//           missingweight22 = 0,
//           missingweightbullion = 0;

//       // 🟡 IDs الموجودة في المخزون
//       final invIds = inventoriesSnap.docs.map((d) {
//         final data = d.data() as Map<String, dynamic>;
//         return data['epcHex'] ?? data['id'];
//       }).toSet();
//       List<Map<String, dynamic>> AllTags = [];

//       for (var doc in allInventoryDocs) {
//         final data = doc.data() as Map<String, dynamic>;
//         final id = data['epcHex'] ?? data['id'];

//         if (!invIds.contains(id)) {
//           final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//           final entryDateStr = payload['entryDate']?.toString();
//           bool isMissingForMonth = false;

//           if (entryDateStr != null && entryDateStr.isNotEmpty) {
//             try {
//               final entryDate = DateTime.parse(entryDateStr);
//               final now = DateTime.now();
//               final difference = now.difference(entryDate);
//               isMissingForMonth = difference.inDays >= 30;
//             } catch (e) {
//               isMissingForMonth = true;
//             }
//           } else {
//             isMissingForMonth = true;
//           }

//           if (isMissingForMonth && id != null) {
//             missingEpcs.add(id.toString());
//             AllTags.add(data);
//           }

//           final category = data['category'] ?? 'gold';
//           final weight = (payload['weight'] ?? 0).toDouble();
//           final cost = (payload['cost'] ?? 0).toDouble();
//           final wage = (payload['wage'] ?? 0).toDouble();

//           if (category == 'gold') {
//             if (payload['carat'] == '18') {
//               missing18++;
//               missingwage18 += wage;
//               missingweight18 += weight;
//             } else if (payload['carat'] == '21') {
//               missing21++;
//               missingwage21 += wage;
//               missingweight21 += weight;
//             } else if (payload['carat'] == '22') {
//               missing22++;
//               missingwage22 += wage;
//               missingweight22 += weight;
//             }
//           } else if (category == 'bullion') {
//             missingBullion++;
//             missingwagebullion += wage;
//             missingweightbullion += weight;
//           } else if (category == 'gem') {
//             missingGem++;
//             missingcostgem += cost;
//           }

//           missingCount++;
//         }
//       }

//       // ✅ حساب الجرامات المعلقة من بقايا الأطقم (مرة واحدة عند التحميل)
//       double remainingKitsWeight = await _calculateRemainingKitsWeight();

//       all.sort((a, b) =>
//           (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

//       if (mounted) {
//         setState(() {
//           total = sum;
//           cashtotal = cash;
//           visatotal = visa;
//           lostItemsCount = missingCount;
//           loading = false;
//           missing_18 = missing18;
//           missing_21 = missing21;
//           missing_22 = missing22;
//           missing_Bullion = missingBullion;
//           missing_Gem = missingGem;
//           missingwage_18 = missingwage18;
//           missing_wage21 = missingwage21;
//           missing_wage22 = missingwage22;
//           missing_wagebullion = missingwagebullion;
//           missing_costgem = missingcostgem;
//           missingweight_18 = missingweight18;
//           missing_weight21 = missingweight21;
//           missing_weight22 = missingweight22;
//           missing_weightbullion = missingweightbullion;
//           deptCount = tempCounts;
//           AllMissingTags = AllTags;

//           // ✅ تحديث الجرامات المعلقة
//           _remainingKitsWeight = remainingKitsWeight;

//           // Set deleted items data
//           deletedGoldCount = 0;
//           deletedGemCount = 0;
//           deletedBullionCount = 0;
//           deletedGoldWeight = 0;
//           deletedGoldWage = 0;
//           deletedGemCost = 0;
//           deletedBullionWeight = 0;
//           deletedBullionWage = 0;
//           deletedItems = [];
//         });
//       }
//     } catch (e) {
//       print('Error loading data: $e');
//       if (mounted) {
//         setState(() => loading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${_t('حدث خطأ', 'Error')}: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Map<String, List<Map<String, dynamic>>> missingByDepartment = {};
//   void _calculateMissingItems() {
//     missingByDepartment.clear();

//     for (var item in AllMissingTags) {
//       final epc = item['epcHex']?.toString().toUpperCase();
//       if (epc == null) continue;

//       final payload = item['payload'] as Map<String, dynamic>?;
//       if (payload == null) continue;

//       final kind = payload['kind']?.toString();
//       final type = payload['type']?.toString();
//       final category = item['category']?.toString().toLowerCase();

//       String? department;

//       if (category == 'bullion') {
//         department = 'سبائك';
//       } else if (kind != null) {
//         department = kind;
//       } else if (type != null) {
//         department = type;
//       }

//       if (department == null) continue;

//       missingByDepartment.putIfAbsent(department, () => []);
//       missingByDepartment[department]!.add(item);
//     }

//     setState(() {});
//   }

//   void _showMissingDialog() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Dialog(
//             child: SizedBox(
//               height: 600,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: missingByDepartment.entries.map((entry) {
//                   final department = entry.key;
//                   final items = entry.value;

//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "$department (${items.length})",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       ...items.map((item) {
//                         final payload =
//                             item['payload'] as Map<String, dynamic>? ?? {};

//                         return Card(
//                           child: ListTile(
//                             subtitle: Text(
//                               [
//                                 if (item['epcHex'] != null &&
//                                     item['epcHex'].toString().isNotEmpty)
//                                   "رقم الشريحة: ${item['epcHex']}",
//                                 if (payload['carat'] != null &&
//                                     payload['carat'].toString().isNotEmpty)
//                                   "العيار: ${payload['carat']}",
//                                 if (payload['size'] != null &&
//                                     payload['size'].toString().isNotEmpty)
//                                   "المقاس: ${payload['size']}",
//                                 if (payload['weight'] != null)
//                                   "الوزن: ${payload['weight']}",
//                                 if (payload['wage'] != null)
//                                   "الاجر: ${payload['wage']}",
//                                 if (payload['notes'] != null)
//                                   "الملاحظات: ${payload['notes']}",
//                                 if (item['createdAt'] != null)
//                                   "تاريخ الادخال: ${_formatDate(item['createdAt'])}",
//                                 if (payload['qrCode'] != null &&
//                                     payload['qrCode'].toString().isNotEmpty)
//                                   "الكود: ${payload['qrCode']}",
//                               ].join("\n"),
//                             ),
//                             trailing: item['epcHex'] != null
//                                 ? IconButton(
//                                     icon: const Icon(Icons.image,
//                                         color: Colors.blue),
//                                     onPressed: () async {
//                                       final epcHex = item['epcHex'];
//                                       final uid = FirebaseAuth
//                                           .instance.currentUser!.uid;

//                                       final storageRef = FirebaseStorage
//                                           .instance
//                                           .ref()
//                                           .child('images')
//                                           .child('users')
//                                           .child(uid)
//                                           .child(epcHex);

//                                       try {
//                                         final result =
//                                             await storageRef.listAll();

//                                         if (result.items.isEmpty) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                                 content:
//                                                     Text("لا يوجد صور محفوظة")),
//                                           );
//                                           return;
//                                         }

//                                         final urls = await Future.wait(
//                                           result.items.map(
//                                               (ref) => ref.getDownloadURL()),
//                                         );

//                                         showDialog(
//                                           context: context,
//                                           builder: (_) => Dialog(
//                                             child: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               width: double.maxFinite,
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   const Text(
//                                                     "صور الشريحة",
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 8),
//                                                   SizedBox(
//                                                     height: 400,
//                                                     child: ListView.builder(
//                                                       itemCount: urls.length,
//                                                       itemBuilder: (_, i) =>
//                                                           Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(4),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             showDialog(
//                                                               context: context,
//                                                               builder: (_) =>
//                                                                   Scaffold(
//                                                                 backgroundColor:
//                                                                     Colors
//                                                                         .black,
//                                                                 body: Stack(
//                                                                   children: [
//                                                                     Center(
//                                                                       child:
//                                                                           InteractiveViewer(
//                                                                         minScale:
//                                                                             0.5,
//                                                                         maxScale:
//                                                                             5.0,
//                                                                         child: Image
//                                                                             .network(
//                                                                           urls[
//                                                                               i],
//                                                                           fit: BoxFit
//                                                                               .contain,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Positioned(
//                                                                       top: 40,
//                                                                       right: 20,
//                                                                       child:
//                                                                           IconButton(
//                                                                         icon:
//                                                                             const Icon(
//                                                                           Icons
//                                                                               .close,
//                                                                           color:
//                                                                               Colors.white,
//                                                                           size:
//                                                                               30,
//                                                                         ),
//                                                                         onPressed:
//                                                                             () =>
//                                                                                 Navigator.pop(context),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           },
//                                                           child: Image.network(
//                                                             urls[i],
//                                                             width: 200,
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   TextButton(
//                                                     onPressed: () =>
//                                                         Navigator.pop(context),
//                                                     child: const Text("إغلاق"),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       } catch (e) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                               content: Text("فشل تحميل الصور")),
//                                         );
//                                       }
//                                     },
//                                   )
//                                 : null,
//                           ),
//                         );
//                       }),
//                       const SizedBox(height: 16),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatDate(dynamic timestamp) {
//     if (timestamp == null) return "";

//     final date = timestamp.toDate();

//     return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
//         "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
//   }

//   void _showNoMissingDialog() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               Icon(
//                 Icons.verified,
//                 color: Colors.green,
//                 size: 60,
//               ),
//               SizedBox(height: 12),
//               Text(
//                 "لا يوجد عناصر مفقودة",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 6),
//               Text(
//                 "تم جرد جميع العناصر بنجاح",
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("حسناً"),
//             )
//           ],
//         );
//       },
//     );
//   }

//   // ================= UI COMPONENTS =================

//   Widget statCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     Color? color,
//     Color? bg,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: bg ?? Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 25),
//           const SizedBox(height: 6),
//           Text(title, style: const TextStyle(fontSize: 14)),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget sectionCard(String title, Widget child) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 12),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget rowItem(String title, String value, {Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title),
//           Text(
//             value,
//             style: TextStyle(fontWeight: FontWeight.bold, color: color),
//           ),
//         ],
//       ),
//     );
//   }

//   double _percent(double value) {
//     if (totalWeight == 0) return 0;
//     return (value / totalWeight) * 100;
//   }

//   // ================= BUILD =================

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return _buildLoadingScreen();
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       appBar: AppBar(
//         title: Text("تقرير الرصيد العام"),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () {
//               setState(() {
//                 loading = true;
//               });
//               _loadData();
//             },
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             /// 🔹 TOP CARDS
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 1.4,
//               children: [
//                 statCard(
//                   title: 'اجمالي الوزن العام',
//                   value: '${totalWeight.toStringAsFixed(2)} جرام',
//                   icon: Icons.balance,
//                   color: Colors.blue,
//                 ),
//                 statCard(
//                   title: 'اجمالي الصندوق',
//                   value: '${total.toStringAsFixed(0)} ريال',
//                   icon: Icons.attach_money,
//                   color: Colors.blue,
//                 ),
//                 statCard(
//                   title: 'رصيد الكاش',
//                   value: '${cashtotal.toStringAsFixed(0)} ريال',
//                   icon: Icons.attach_money,
//                   color: Colors.green,
//                 ),
//                 statCard(
//                   title: 'رصيد الشبكة',
//                   value: '${visatotal.toStringAsFixed(0)} ريال',
//                   icon: Icons.track_changes,
//                   color: Colors.green,
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             /// 🔹 REMAINING KITS CARD
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.inventory_2_outlined,
//                       color: Color(0xFFD4AF37),
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _t('إجمالي الوزن المعلق', 'Total Remaining Grams'),
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${_remainingKitsWeight.toStringAsFixed(2)} جم',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                             color: Color(0xFFD4AF37),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             /// 🔹 DISTRIBUTION
//             sectionCard(
//               'توزيع الأوزان حسب العيار',
//               Column(
//                 children: [
//                   _caratRow(
//                     'عيار 18',
//                     caratWeight[18]!,
//                     Colors.orange,
//                   ),
//                   _caratRow(
//                     'عيار 21',
//                     caratWeight[21]!,
//                     Colors.green,
//                   ),
//                   _caratRow(
//                     'عيار 22',
//                     caratWeight[22]!,
//                     Colors.red,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),
//             if (deptCount.isNotEmpty) const SizedBox(height: 25),
//             Padding(
//               padding: const EdgeInsets.only(),
//               child: Text(
//                 _t("عدد الاقسام المسجلة", "Number of dept existed"),
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Wrap(
//                 spacing: 10,
//                 runSpacing: 10,
//                 children: deptCount.entries.map((entry) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: const Color(0xFFD4AF37)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.category,
//                             size: 18, color: Color(0xFFD4AF37)),
//                         const SizedBox(width: 6),
//                         Text(
//                           "${entry.key} : ${entry.value}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: sectionCard(
//                 'نظرة سريعة',
//                 Column(
//                   children: [
//                     rowItem(
//                         'رصيد الكسر', '${scrapWeight.toStringAsFixed(2)} جرام'),
//                     rowItem('عدد الاحجار', '${stonesCount.toStringAsFixed(2)} ',
//                         color: Colors.purple),
//                     rowItem(
//                         'عدد السبائك', '${BullionCount.toStringAsFixed(2)} ',
//                         color: Color(0xFFD4AF37)),
//                     rowItem('وزن السبائك',
//                         '${BullionWeight.toStringAsFixed(2)} جرام',
//                         color: Color(0xFFD4AF37)),
//                     rowItem('توريدات للادراة هذا الشهر',
//                         ' كاش : ${supplycash.toStringAsFixed(0)} شبكة : ${supplyvisa.toStringAsFixed(0)}',
//                         color: Colors.red),
//                     rowItem('استيرادات الادراة هذا الشهر',
//                         ' كاش : ${importcash.toStringAsFixed(0)} شبكة : ${importvisa.toStringAsFixed(0)}',
//                         color: Colors.red),
//                     rowItem('المصروفات هذا الشهر ',
//                         '${expenses_Month.toStringAsFixed(0)} ريال',
//                         color: Colors.green),
//                     rowItem('رصيد بيع جزئي متبقي',
//                         '${balancesWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.orange),
//                     rowItem('عدد أرصدة البيع الجزئي', '$balancesCount',
//                         color: Colors.orange),
//                     rowItem('عدد الذهب المحذوف', '$deletedGoldCount',
//                         color: Colors.red),
//                     rowItem('وزن الذهب المحذوف',
//                         '${deletedGoldWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.red),
//                     rowItem('عدد الأحجار المحذوفة', '$deletedGemCount',
//                         color: Colors.purple),
//                     rowItem('تكلفة الأحجار المحذوفة',
//                         '${deletedGemCost.toStringAsFixed(0)} ريال',
//                         color: Colors.purple),
//                     rowItem('عدد السبائك المحذوفة', '$deletedBullionCount',
//                         color: Colors.orange),
//                     rowItem('وزن السبائك المحذوفة',
//                         '${deletedBullionWeight.toStringAsFixed(2)} جرام',
//                         color: Colors.orange),
//                     const Divider(),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 minimumSize: const Size.fromHeight(45),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.warning, color: Colors.white),
//               label: const Text(
//                 "عرض المفقود",
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 _calculateMissingItems();

//                 if (missingByDepartment.isEmpty) {
//                   _showNoMissingDialog();
//                 } else {
//                   _showMissingDialog();
//                 }
//               },
//             ),

//             const SizedBox(height: 16),
//             Directionality(
//               textDirection: TextDirection.rtl,
//               child: sectionCard(
//                 'الموردين',
//                 StreamBuilder<List<Map<String, dynamic>>>(
//                   stream: FS.suppliersStream(),
//                   builder: (context, snap) {
//                     if (!snap.hasData) {
//                       return const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }

//                     final suppliers = snap.data!;

//                     if (suppliers.isEmpty) {
//                       return const Padding(
//                         padding: EdgeInsets.all(12),
//                         child: Text(
//                           'لا يوجد موردين حالياً',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       );
//                     }

//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               showSuppliers = !showSuppliers;
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'عدد الموردين: ${suppliers.length}',
//                                   textAlign: TextAlign.right,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Icon(
//                                 showSuppliers
//                                     ? Icons.keyboard_arrow_up
//                                     : Icons.keyboard_arrow_down,
//                                 size: 28,
//                               ),
//                             ],
//                           ),
//                         ),
//                         AnimatedCrossFade(
//                           firstChild: const SizedBox.shrink(),
//                           secondChild: ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             padding: const EdgeInsets.only(top: 12),
//                             itemCount: suppliers.length,
//                             itemBuilder: (_, i) {
//                               final s = suppliers[i];
//                               return _supplierCard(s);
//                             },
//                           ),
//                           crossFadeState: showSuppliers
//                               ? CrossFadeState.showSecond
//                               : CrossFadeState.showFirst,
//                           duration: const Duration(milliseconds: 250),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _supplierCard(Map<String, dynamic> s) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.blue.shade100,
//           child: const Icon(Icons.person, color: Colors.blue),
//         ),
//         title: Text(
//           s["name"],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: FutureBuilder<Map<String, dynamic>>(
//           future: _supplierSummary(s["id"]),
//           builder: (context, snap) {
//             if (!snap.hasData) {
//               return const Text("جاري حساب الرصيد...");
//             }

//             final data = snap.data!;
//             final bool cleared = data["cleared"];
//             final double w = data["weight"];
//             final double g = data["wage"];

//             Color color;
//             String status;

//             if (cleared) {
//               color = Colors.green;
//               status = "تمت تصفية الحساب";
//             } else if (w > 0) {
//               color = Colors.red;
//               status = "للمورد";
//             } else {
//               color = Colors.green.shade700;
//               status = "على المورد";
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("📞 ${s["phone"] ?? '-'}"),
//                 const SizedBox(height: 4),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 if (!cleared) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     "وزن: ${w.abs().toStringAsFixed(2)} جم • أجر: ${g.abs().toStringAsFixed(2)}",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         ),
//         onTap: () async {
//           final vouchers = await FS.getVouchersForSupplier(s["id"]);

//           final Map<String, double> totalPaymentWeight = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalReceiptWeight = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalPaymentWage = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };
//           final Map<String, double> totalReceiptWage = {
//             "18": 0,
//             "21": 0,
//             "22": 0
//           };

//           for (var v in vouchers) {
//             final carat = (v["carat"] ?? "").toString();
//             final weight =
//                 double.tryParse(v["weight"]?.toString() ?? "0") ?? 0.0;
//             final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0.0;

//             if (["18", "21", "22"].contains(carat)) {
//               if (v["type"] == "payment") {
//                 totalPaymentWeight[carat] =
//                     (totalPaymentWeight[carat] ?? 0) + weight;
//                 totalPaymentWage[carat] = (totalPaymentWage[carat] ?? 0) + wage;
//               } else if (v["type"] == "receipt") {
//                 totalReceiptWeight[carat] =
//                     (totalReceiptWeight[carat] ?? 0) + weight;
//                 totalReceiptWage[carat] = (totalReceiptWage[carat] ?? 0) + wage;
//               }
//             }
//           }

//           final Map<String, double> balanceWeight = {};
//           final Map<String, double> balanceWage = {};

//           for (var c in ["18", "21", "22"]) {
//             balanceWeight[c] = totalReceiptWeight[c]! - totalPaymentWeight[c]!;
//             balanceWage[c] = totalReceiptWage[c]! - totalPaymentWage[c]!;
//           }

//           final totalBalanceWeight =
//               balanceWeight.values.fold(0.0, (a, b) => a + b);
//           final totalBalanceWage =
//               balanceWage.values.fold(0.0, (a, b) => a + b);

//           final allCleared =
//               balanceWeight.values.every((v) => v.abs() < 0.0001) &&
//                   balanceWage.values.every((v) => v.abs() < 0.0001);

//           showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               title: Center(
//                 child: Text(
//                   _t("رصيد المورد", "Supplier Balance"),
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//               content: SizedBox(
//                 width: double.maxFinite,
//                 height: MediaQuery.of(context).size.height * 0.85,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Card(
//                         elevation: 2,
//                         color: allCleared
//                             ? Colors.green.shade50
//                             : totalBalanceWeight > 0
//                                 ? Colors.amber.shade50
//                                 : Colors.red.shade50,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         child: Padding(
//                           padding: const EdgeInsets.all(14),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 allCleared
//                                     ? Icons.check_circle
//                                     : (totalBalanceWeight > 0
//                                         ? Icons.account_balance_wallet
//                                         : Icons.warning_amber_rounded),
//                                 color: allCleared
//                                     ? Colors.green
//                                     : (totalBalanceWeight > 0
//                                         ? Colors.red
//                                         : Colors.green),
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     if (allCleared)
//                                       Text(
//                                         _t("تمت تصفية الحساب بالكامل ",
//                                             "Account fully settled "),
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 17,
//                                           color: Colors.green,
//                                         ),
//                                       )
//                                     else ...[
//                                       Text(
//                                         totalBalanceWeight > 0
//                                             ? _t("للمورد", "Supplier balance")
//                                             : _t("على المورد", "Supplier owes"),
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 17,
//                                           color: totalBalanceWeight > 0
//                                               ? Colors.red.shade800
//                                               : Colors.green.shade800,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             "${_t("الوزن", "Weight")}: ${totalBalanceWeight.abs().toStringAsFixed(2)} جم",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                           const SizedBox(width: 12),
//                                           const SizedBox(width: 4),
//                                           Text(
//                                             "${_t("الأجر", "Wage")}: ${totalBalanceWage.abs().toStringAsFixed(2)}",
//                                             style: const TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       if (!allCleared)
//                         Card(
//                           elevation: 1,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   _t("تفاصيل حسب العيار", "Details by Carat"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 GridView.count(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   crossAxisCount: 2,
//                                   mainAxisSpacing: 6,
//                                   crossAxisSpacing: 6,
//                                   childAspectRatio: 1.1,
//                                   children: ["18", "21", "22"].map((c) {
//                                     final bw = balanceWeight[c]!;
//                                     final wg = balanceWage[c]!;

//                                     final bool cleared =
//                                         bw.abs() < 0.0001 && wg.abs() < 0.0001;

//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: cleared
//                                             ? Colors.grey.shade100
//                                             : bw > 0
//                                                 ? Colors.red.shade50
//                                                 : bw < 0
//                                                     ? Colors.green.shade50
//                                                     : Colors.amber.shade50,
//                                         border: Border.all(
//                                           color: cleared
//                                               ? Colors.grey.shade300
//                                               : bw > 0
//                                                   ? Colors.red.shade300
//                                                   : Colors.green.shade300,
//                                         ),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text("عيار $c",
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             const SizedBox(height: 4),
//                                             Text(
//                                               "${_t("وزن", "weight")}: ${bw.toStringAsFixed(2)}",
//                                               style: TextStyle(
//                                                   color: bw == 0
//                                                       ? Colors.grey
//                                                       : bw > 0
//                                                           ? Colors.red.shade800
//                                                           : Colors
//                                                               .green.shade800,
//                                                   fontSize: 13),
//                                             ),
//                                             Text(
//                                               "${_t("أجر", "Wage")}: ${wg.toStringAsFixed(2)}",
//                                               style:
//                                                   const TextStyle(fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 16),
//                       const Divider(thickness: 1),
//                       const SizedBox(height: 6),
//                       Text(
//                         _t("قائمة السندات", "Vouchers List"),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 15),
//                       ),
//                       const SizedBox(height: 8),
//                       ...vouchers.map((v) {
//                         final isReceipt = v["type"] == "receipt";

//                         return Card(
//                           elevation: 2,
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Padding(
//                             padding: const EdgeInsets.all(10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundColor: isReceipt
//                                           ? Colors.red.shade100
//                                           : Colors.green.shade100,
//                                       child: Icon(
//                                         isReceipt
//                                             ? Icons.download_done
//                                             : Icons.upload,
//                                         color: isReceipt
//                                             ? Colors.red
//                                             : Colors.green,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       isReceipt
//                                           ? _t("سند قبض", "Receipt Voucher")
//                                           : _t("سند صرف", "Payment Voucher"),
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15),
//                                     ),
//                                     const Spacer(),
//                                     if (v["date"] != null)
//                                       Text(
//                                         " ${(v["date"] as Timestamp).toDate().toString().split(' ')[0]}",
//                                         style: TextStyle(
//                                             color: Colors.grey.shade600,
//                                             fontSize: 12),
//                                       ),
//                                   ],
//                                 ),
//                                 const Divider(height: 16),
//                                 Text(
//                                     "${_t("المندوب", "Delegate")}: ${v["delegate"] ?? "-"}"),
//                                 Text(
//                                     "${_t("العيار", "Carat")}: ${v["carat"] ?? "-"}"),
//                                 Text(
//                                     "${_t("الوزن", "Weight")}: ${v["weight"] ?? 0} g"),
//                                 Text(
//                                     "${_t("الأجر", "Wage")}: ${v["wage"] ?? 0}"),
//                                 if (!isReceipt) ...[
//                                   if (v["paymentMethod"] != null)
//                                     Text(
//                                         "${_t("طريقة الدفع", "Payment Method")}: ${v["paymentMethod"]}"),
//                                   if (v["cash"] != null)
//                                     Text("${_t("كاش", "Cash")}: ${v["cash"]}"),
//                                   if (v["network"] != null)
//                                     Text(
//                                         "${_t("شبكة", "Network")}: ${v["network"]}"),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
//     final vouchers = await FS.getVouchersForSupplier(supplierId);

//     double payW = 0, recW = 0;
//     double payG = 0, recG = 0;

//     for (var v in vouchers) {
//       final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

//       if (v["type"] == "payment") {
//         payW += weight;
//         payG += wage;
//       } else if (v["type"] == "receipt") {
//         recW += weight;
//         recG += wage;
//       }
//     }

//     final balanceWeight = recW - payW;
//     final balanceWage = recG - payG;

//     final cleared = balanceWeight.abs() < 0.0001 && balanceWage.abs() < 0.0001;

//     return {
//       "cleared": cleared,
//       "weight": balanceWeight,
//       "wage": balanceWage,
//     };
//   }

//   Widget _lostDetails() {
//     return Column(
//       children: [
//         const SizedBox(height: 12),
//         _summaryCard(
//           title: 'ذهب',
//           children: [
//             _summaryRow('عيار 18',
//                 count: missing_18,
//                 weight: missingweight_18,
//                 wage: missingwage_18),
//             _summaryRow('عيار 21',
//                 count: missing_21,
//                 weight: missing_weight21,
//                 wage: missing_wage21),
//             _summaryRow('عيار 22',
//                 count: missing_22,
//                 weight: missing_weight22,
//                 wage: missing_wage22),
//           ],
//         ),
//         const SizedBox(height: 8),
//         _summaryCard(
//           title: 'سبائك',
//           children: [
//             _summaryRow(
//               'سبائك',
//               count: missing_Bullion,
//               weight: missing_weightbullion,
//               cost: missing_wagebullion,
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         _summaryCard(
//           title: 'أحجار',
//           children: [
//             _summaryRow(
//               'أحجار',
//               count: missing_Gem,
//               cost: missing_costgem,
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isLoadingImages ? null : _loadAllMissingImages,
//           child: isLoadingImages
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text("عرض كل صور العناصر المفقودة"),
//         ),
//       ],
//     );
//   }

//   Future<void> _loadAllMissingImages() async {
//     if (missingEpcs.isEmpty) return;

//     setState(() => isLoadingImages = true);

//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     try {
//       final futures = missingEpcs.map((epc) async {
//         final storageRef = FirebaseStorage.instance
//             .ref()
//             .child('images')
//             .child('users')
//             .child(uid)
//             .child(epc);

//         final result = await storageRef.listAll();

//         return Future.wait(
//           result.items.map((ref) => ref.getDownloadURL()),
//         );
//       });

//       final results = await Future.wait(futures);

//       allMissingImageUrls = results.expand((element) => element).toList();

//       setState(() => isLoadingImages = false);

//       if (allMissingImageUrls.isNotEmpty) {
//         _openImageViewer();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("لا توجد صور محفوظة")),
//         );
//       }
//     } catch (e) {
//       setState(() => isLoadingImages = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("فشل تحميل الصور")),
//       );
//     }
//   }

//   void _openImageViewer() {
//     showDialog(
//       context: context,
//       builder: (_) {
//         PageController controller = PageController();

//         return Dialog(
//           insetPadding: EdgeInsets.zero,
//           child: Stack(
//             children: [
//               PageView.builder(
//                 controller: controller,
//                 itemCount: allMissingImageUrls.length,
//                 itemBuilder: (_, index) {
//                   return InteractiveViewer(
//                     child: Image.network(
//                       allMissingImageUrls[index],
//                       fit: BoxFit.contain,
//                     ),
//                   );
//                 },
//               ),
//               Positioned(
//                 top: 20,
//                 right: 20,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.red, size: 30),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _summaryCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const Divider(),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _summaryRow(
//     String label, {
//     int? count,
//     double? weight,
//     double? wage,
//     double? cost,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           if (count != null) Text('عدد الشرائح: $count'),
//           if (weight != null) Text('الوزن: ${weight.toStringAsFixed(2)} جرام'),
//           if (wage != null) Text('الأجر: ${wage.toStringAsFixed(2)} ريال'),
//           if (cost != null) Text('التكلفة: ${cost.toStringAsFixed(2)} ريال'),
//         ],
//       ),
//     );
//   }

//   Widget _caratRow(String title, double weight, Color color) {
//     final percent = _percent(weight);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(
//                 '${weight.toStringAsFixed(2)}   •  ${percent.toStringAsFixed(1)}%',
//                 style: TextStyle(color: color, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           LinearProgressIndicator(
//             value: percent / 100,
//             backgroundColor: color.withOpacity(.15),
//             valueColor: AlwaysStoppedAnimation(color),
//             minHeight: 8,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GeneralBalancePage extends StatefulWidget {
  const GeneralBalancePage({super.key});

  @override
  State<GeneralBalancePage> createState() => _GeneralBalancePageState();
}

class _GeneralBalancePageState extends State<GeneralBalancePage> {
  bool loading = true;

  double totalWeight = 0;
  Map<int, double> caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};

  int stonesCount = 0;
  int BullionCount = 0;
  double stonesCost = 0;
  double BullionWeight = 0;

  double scrapWeight = 0; // وزن الكسر الخام (بدون تحويل)
  double scrapWeight24K = 0; // 🔥 وزن الكسر المحول لعيار 24
  double supply = 0;
  double import = 0;
  double supplycash = 0;
  double importcash = 0;
  double supplyvisa = 0;
  double importvisa = 0;
  double balancesWeight = 0;
  int balancesCount = 0;

  double total = 0.0;
  double cashtotal = 0.0;
  double visatotal = 0.0;
  int lostItemsCount = 0;

  int missing_18 = 0;
  int missing_21 = 0;
  int missing_22 = 0;
  int missing_Gem = 0;
  int missing_Bullion = 0;
  List<String> missingEpcs = [];
  bool isLoadingImages = false;
  List<String> allMissingImageUrls = [];
  Map<String, int> deptCount = {};

  double missingwage_18 = 0,
      missing_wage21 = 0,
      missing_wage22 = 0,
      missing_wagebullion = 0,
      missing_costgem = 0;
  double missingweight_18 = 0,
      missing_weight21 = 0,
      missing_weight22 = 0,
      missing_weightbullion = 0;

  // ✅ الجرامات المعلقة من بقايا الأطقم
  double _remainingKitsWeight = 0.0;

  // Deleted items tracking
  int deletedGoldCount = 0;
  int deletedGemCount = 0;
  int deletedBullionCount = 0;
  double deletedGoldWeight = 0;
  double deletedGoldWage = 0;
  double deletedGemCost = 0;
  double deletedBullionWeight = 0;
  double deletedBullionWage = 0;
  List<Map<String, dynamic>> deletedItems = [];
  bool showLostDetails = false;
  bool showSuppliers = false;
  double expenses_Month = 0;

  List<Map<String, dynamic>> suppliers = [];
  List<Map<String, dynamic>> AllMissingTags = [];

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  Map<String, List<Map<String, dynamic>>> lostItemsByCategory = {
    'gold': [],
    'gem': [],
    'bullion': [],
  };

  // ✅ Stream Subscription
  StreamSubscription? _kitsSubscription;

  @override
  void initState() {
    super.initState();
    _loadLanguage();

    // ✅ تحميل البيانات بعد رسم الواجهة مباشرة (لعدم تجميد التطبيق)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _listenToKitsChanges();
    });
  }

  @override
  void dispose() {
    _kitsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('languageCode') ?? 'ar';
  }

  // ✅ الاستماع للتحديثات في بقايا الأطقم
  void _listenToKitsChanges() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _kitsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('setRemainders')
        .snapshots()
        .listen((snapshot) {
      double totalRemaining = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final payload = data['payload'] as Map<String, dynamic>? ?? {};

        final originalWeight =
            (payload['originalWeight'] as num?)?.toDouble() ??
                (payload['weight'] as num?)?.toDouble() ??
                0;
        final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
        final remainingWeight = originalWeight - soldWeight;

        // ✅ فقط الوزن الموجب
        if (remainingWeight > 0) {
          totalRemaining += remainingWeight;
        }
      }

      if (mounted) {
        setState(() {
          _remainingKitsWeight = totalRemaining;
        });
      }
    });
  }

  // ✅ دالة لحساب الجرامات المعلقة (تستخدم في التحميل الأول)
  Future<double> _calculateRemainingKitsWeight() async {
    double totalRemaining = 0.0;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final kitsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('setRemainders')
            .get();

        for (var doc in kitsSnapshot.docs) {
          final data = doc.data();
          final payload = data['payload'] as Map<String, dynamic>? ?? {};

          final originalWeight =
              (payload['originalWeight'] as num?)?.toDouble() ??
                  (payload['weight'] as num?)?.toDouble() ??
                  0;
          final soldWeight = (payload['soldWeight'] as num?)?.toDouble() ?? 0;
          final remainingWeight = originalWeight - soldWeight;

          if (remainingWeight > 0) {
            totalRemaining += remainingWeight;
          }
        }
      }
    } catch (e) {
      print('Error loading remaining kits: $e');
    }

    return totalRemaining;
  }

  /// 🔥 دالة تحويل العيار إلى 24
  double _convertTo24Karat(double weight, String carat) {
    if (carat == "24") return weight;
    if (carat == "22") return weight * 22 / 24;
    if (carat == "21") return weight * 21 / 24;
    if (carat == "18") return weight * 18 / 24;
    if (carat == "14") return weight * 14 / 24;
    return weight;
  }

  /// 🔥 دالة لحساب وزن الكسر بعيار 24
  Future<double> _calculateScrapWeight24K() async {
    double totalScrap24K = 0.0;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return 0;

      // جلب كل معاملات الكسر
      final scrapSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('scrapTransactions')
          .get();

      for (var doc in scrapSnapshot.docs) {
        final data = doc.data();
        final type = data['type'] ?? '';
        final carat = (data['carat'] ?? '18').toString();
        final weight = (data['weight'] ?? 0).toDouble();

        // تحويل الوزن إلى عيار 24
        double convertedWeight = _convertTo24Karat(weight, carat);

        if (type == 'add' || type == 'transform') {
          totalScrap24K += convertedWeight;
        } else if (type == 'sale' || type == 'payment') {
          totalScrap24K -= convertedWeight.abs();
        }
      }
    } catch (e) {
      print('Error calculating scrap weight: $e');
    }

    return totalScrap24K;
  }

  // ✅ شاشة التحميل المحسنة
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
              strokeWidth: 4,
            ),
            const SizedBox(height: 24),
            Text(
              _t('جاري تحميل البيانات...', 'Loading data...'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _t('يرجى الانتظار', 'Please wait'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    // ✅ إظهار شاشة التحميل
    if (mounted) setState(() => loading = true);

    try {
      // =====================================================
      // ✅ إعادة تعيين كل المتغيرات قبل الجمع (مهم جداً)
      // =====================================================
      totalWeight = 0;
      caratWeight = {18: 0, 21: 0, 22: 0, 24: 0};
      stonesCount = 0;
      BullionCount = 0;
      stonesCost = 0;
      BullionWeight = 0;
      scrapWeight = 0;
      scrapWeight24K = 0;
      balancesWeight = 0;
      balancesCount = 0;
      deptCount = {};
      missingEpcs.clear();
      AllMissingTags.clear();

      double sum = 0.0;
      double cash = 0.0;
      double visa = 0.0;
      List<Map<String, dynamic>> all = [];

      // ✅ استخدام Future.wait لجلب البيانات بالتوازي (أسرع بكثير)
      final results = await Future.wait([
        FS.itemsCol().get(),
        FS.balancesCol().get(),
        FS.salesCol().get(),
        FS.scrapCol().where("type", isEqualTo: "sale").get(),
        FS.scrapCol().where("type", isEqualTo: "add").get(),
        FS.vouchersCol().where("type", isEqualTo: "payment").get(),
        FS.expensesCol().get(),
        FS.depositsCol().get(),
        FS.ImportedCol().get(),
        FS.invCol().get(),
      ]);

      final itemsSnap = results[0];
      final balancesSnap = results[1];
      final salesSnap = results[2];
      final scrapSnap = results[3];
      final scrapBuySnap = results[4];
      final vouchersSnap = results[5];
      final expSnap = results[6];
      final depositSnap = results[7];
      final ImportSnap = results[8];
      final inventoriesSnap = results[9];

      balancesCount = balancesSnap.docs.length;
      Map<String, int> tempCounts = {};
      final allInventoryDocs = [...itemsSnap.docs, ...balancesSnap.docs];

      for (var doc in allInventoryDocs) {
        final data = doc.data() as Map<String, dynamic>;
        final payload = Map<String, dynamic>.from(data['payload'] ?? {});
        final isBalance = doc.reference.parent.id == 'balances';
        final weight = (payload['weight'] ?? 0).toDouble();
        if (isBalance) balancesWeight += weight;

        final carat = int.tryParse(payload['carat']?.toString() ?? '');
        final kind = payload['kind']?.toString();
        final type = payload['type']?.toString();
        if (data['category'] == "bullion") {
          tempCounts['سبائك'] = (tempCounts['سبائك'] ?? 0) + 1;
        }

        if (kind != null) {
          tempCounts[kind] = (tempCounts[kind] ?? 0) + 1;
        }

        if (type != null) {
          tempCounts[type] = (tempCounts[type] ?? 0) + 1;
        }

        if (caratWeight.containsKey(carat)) {
          caratWeight[carat!] = caratWeight[carat]! + weight;
          totalWeight += weight;
        }

        if (data['category'] == 'gem') {
          stonesCount += 1;
          stonesCost += (payload['cost'] ?? 0).toDouble();
        }
        if (data['category'] == 'bullion') {
          BullionCount += 1;
          BullionWeight += (payload['weight'] ?? 0).toDouble();
        }
      }

      // 🔥 حساب وزن الكسر بعيار 24
      scrapWeight24K = await _calculateScrapWeight24K();

      // 🟢 بيع القطع
      for (var d in salesSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['payment']?['total'] ?? 0).toDouble();
        final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
        final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
        final date = (data['createdAt'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("بيع قطعة", "Piece Sale"),
          "value": wage,
          "date": date,
          "data": data,
        });
        sum += wage;
        cash += totalcash;
        visa += totalvisa;
      }

      // 🟢 بيع كسر
      for (var d in scrapSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("بيع كسر", "Scrap Sale"),
          "value": wage,
          "date": date,
          "data": data,
        });
        sum += wage;
        cash += totalcash;
        visa += totalvisa;
        scrapWeight -= (data['weight'] ?? 0).toDouble();
      }

      // 🔴 شراء كسر
      for (var d in scrapBuySnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("شراء كسر", "Scrap Purchase"),
          "value": -wage,
          "date": date,
          "data": data,
        });
        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
        scrapWeight += (data['weight'] ?? 0).toDouble();
      }

      // 🔴 سندات الصرف
      for (var d in vouchersSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("سند صرف", "Payment Voucher"),
          "value": -wage,
          "date": date,
          "data": data,
        });
        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔴 المصروفات
      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;
      for (var d in expSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
        final date = (data['date'] as Timestamp?)?.toDate();

        final displayType = _t('مصروف', 'Expense');
        all.add({
          "type": displayType,
          "value": -amount,
          "date": date,
          "data": data,
        });
        if (date != null &&
            date.month == currentMonth &&
            date.year == currentYear) {
          expenses_Month += amount;
        }
        sum -= amount;
        cash -= amount;
      }

      // 🔵 توريد للإدارة
      for (var d in depositSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("توريد للإدارة", "Deposit to Admin"),
          "value": -totalValue,
          "date": date,
          "data": data,
        });
        if (date != null &&
            date.month == currentMonth &&
            date.year == currentYear) {
          supply += totalValue;
          supplycash += totalcash;
          supplyvisa += totalvisa;
        }
        sum -= totalValue;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔵 استيراد من الإدارة
      for (var d in ImportSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();
        all.add({
          "type": _t("استيراد من الإدارة", "Import from Admin"),
          "value": totalValue,
          "date": date,
          "data": data,
        });
        if (date != null &&
            date.month == currentMonth &&
            date.year == currentYear) {
          import += totalValue;
          importcash += totalcash;
          importvisa += totalvisa;
        }
        sum += totalValue;
        cash += totalcash;
        visa += totalvisa;
      }

      int missingCount = 0;
      int missing18 = 0;
      int missing21 = 0;
      int missing22 = 0;
      int missingGem = 0;
      int missingBullion = 0;

      double missingwage18 = 0,
          missingwage21 = 0,
          missingwage22 = 0,
          missingwagebullion = 0,
          missingcostgem = 0;
      double missingweight18 = 0,
          missingweight21 = 0,
          missingweight22 = 0,
          missingweightbullion = 0;

      // 🟡 IDs الموجودة في المخزون
      final invIds = inventoriesSnap.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        return data['epcHex'] ?? data['id'];
      }).toSet();
      List<Map<String, dynamic>> AllTags = [];

      for (var doc in allInventoryDocs) {
        final data = doc.data() as Map<String, dynamic>;
        final id = data['epcHex'] ?? data['id'];

        if (!invIds.contains(id)) {
          final payload = Map<String, dynamic>.from(data['payload'] ?? {});
          final entryDateStr = payload['entryDate']?.toString();
          bool isMissingForMonth = false;

          if (entryDateStr != null && entryDateStr.isNotEmpty) {
            try {
              final entryDate = DateTime.parse(entryDateStr);
              final now = DateTime.now();
              final difference = now.difference(entryDate);
              isMissingForMonth = difference.inDays >= 30;
            } catch (e) {
              isMissingForMonth = true;
            }
          } else {
            isMissingForMonth = true;
          }

          if (isMissingForMonth && id != null) {
            missingEpcs.add(id.toString());
            AllTags.add(data);
          }

          final category = data['category'] ?? 'gold';
          final weight = (payload['weight'] ?? 0).toDouble();
          final cost = (payload['cost'] ?? 0).toDouble();
          final wage = (payload['wage'] ?? 0).toDouble();

          if (category == 'gold') {
            if (payload['carat'] == '18') {
              missing18++;
              missingwage18 += wage;
              missingweight18 += weight;
            } else if (payload['carat'] == '21') {
              missing21++;
              missingwage21 += wage;
              missingweight21 += weight;
            } else if (payload['carat'] == '22') {
              missing22++;
              missingwage22 += wage;
              missingweight22 += weight;
            }
          } else if (category == 'bullion') {
            missingBullion++;
            missingwagebullion += wage;
            missingweightbullion += weight;
          } else if (category == 'gem') {
            missingGem++;
            missingcostgem += cost;
          }

          missingCount++;
        }
      }

      // ✅ حساب الجرامات المعلقة من بقايا الأطقم (مرة واحدة عند التحميل)
      double remainingKitsWeight = await _calculateRemainingKitsWeight();

      all.sort((a, b) =>
          (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

      if (mounted) {
        setState(() {
          total = sum;
          cashtotal = cash;
          visatotal = visa;
          lostItemsCount = missingCount;
          loading = false;
          missing_18 = missing18;
          missing_21 = missing21;
          missing_22 = missing22;
          missing_Bullion = missingBullion;
          missing_Gem = missingGem;
          missingwage_18 = missingwage18;
          missing_wage21 = missingwage21;
          missing_wage22 = missingwage22;
          missing_wagebullion = missingwagebullion;
          missing_costgem = missingcostgem;
          missingweight_18 = missingweight18;
          missing_weight21 = missingweight21;
          missing_weight22 = missingweight22;
          missing_weightbullion = missingweightbullion;
          deptCount = tempCounts;
          AllMissingTags = AllTags;

          // ✅ تحديث الجرامات المعلقة
          _remainingKitsWeight = remainingKitsWeight;

          // Set deleted items data
          deletedGoldCount = 0;
          deletedGemCount = 0;
          deletedBullionCount = 0;
          deletedGoldWeight = 0;
          deletedGoldWage = 0;
          deletedGemCost = 0;
          deletedBullionWeight = 0;
          deletedBullionWage = 0;
          deletedItems = [];
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_t('حدث خطأ', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Map<String, List<Map<String, dynamic>>> missingByDepartment = {};
  void _calculateMissingItems() {
    missingByDepartment.clear();

    for (var item in AllMissingTags) {
      final epc = item['epcHex']?.toString().toUpperCase();
      if (epc == null) continue;

      final payload = item['payload'] as Map<String, dynamic>?;
      if (payload == null) continue;

      final kind = payload['kind']?.toString();
      final type = payload['type']?.toString();
      final category = item['category']?.toString().toLowerCase();

      String? department;

      if (category == 'bullion') {
        department = 'سبائك';
      } else if (kind != null) {
        department = kind;
      } else if (type != null) {
        department = type;
      }

      if (department == null) continue;

      missingByDepartment.putIfAbsent(department, () => []);
      missingByDepartment[department]!.add(item);
    }

    setState(() {});
  }

  void _showMissingDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: SizedBox(
              height: 600,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: missingByDepartment.entries.map((entry) {
                  final department = entry.key;
                  final items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$department (${items.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...items.map((item) {
                        final payload =
                            item['payload'] as Map<String, dynamic>? ?? {};

                        return Card(
                          child: ListTile(
                            subtitle: Text(
                              [
                                if (item['epcHex'] != null &&
                                    item['epcHex'].toString().isNotEmpty)
                                  "رقم الشريحة: ${item['epcHex']}",
                                if (payload['carat'] != null &&
                                    payload['carat'].toString().isNotEmpty)
                                  "العيار: ${payload['carat']}",
                                if (payload['size'] != null &&
                                    payload['size'].toString().isNotEmpty)
                                  "المقاس: ${payload['size']}",
                                if (payload['weight'] != null)
                                  "الوزن: ${payload['weight']}",
                                if (payload['wage'] != null)
                                  "الاجر: ${payload['wage']}",
                                if (payload['notes'] != null)
                                  "الملاحظات: ${payload['notes']}",
                                if (item['createdAt'] != null)
                                  "تاريخ الادخال: ${_formatDate(item['createdAt'])}",
                                if (payload['qrCode'] != null &&
                                    payload['qrCode'].toString().isNotEmpty)
                                  "الكود: ${payload['qrCode']}",
                              ].join("\n"),
                            ),
                            trailing: item['epcHex'] != null
                                ? IconButton(
                                    icon: const Icon(Icons.image,
                                        color: Colors.blue),
                                    onPressed: () async {
                                      final epcHex = item['epcHex'];
                                      final uid = FirebaseAuth
                                          .instance.currentUser!.uid;

                                      final storageRef = FirebaseStorage
                                          .instance
                                          .ref()
                                          .child('images')
                                          .child('users')
                                          .child(uid)
                                          .child(epcHex);

                                      try {
                                        final result =
                                            await storageRef.listAll();

                                        if (result.items.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("لا يوجد صور محفوظة")),
                                          );
                                          return;
                                        }

                                        final urls = await Future.wait(
                                          result.items.map(
                                              (ref) => ref.getDownloadURL()),
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              width: double.maxFinite,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    "صور الشريحة",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    height: 400,
                                                    child: ListView.builder(
                                                      itemCount: urls.length,
                                                      itemBuilder: (_, i) =>
                                                          Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  Scaffold(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                body: Stack(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          InteractiveViewer(
                                                                        minScale:
                                                                            0.5,
                                                                        maxScale:
                                                                            5.0,
                                                                        child: Image
                                                                            .network(
                                                                          urls[
                                                                              i],
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 40,
                                                                      right: 20,
                                                                      child:
                                                                          IconButton(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Image.network(
                                                            urls[i],
                                                            width: 200,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("إغلاق"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text("فشل تحميل الصور")),
                                        );
                                      }
                                    },
                                  )
                                : null,
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "";

    final date = timestamp.toDate();

    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _showNoMissingDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.verified,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 12),
              Text(
                "لا يوجد عناصر مفقودة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "تم جرد جميع العناصر بنجاح",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            )
          ],
        );
      },
    );
  }

  // ================= UI COMPONENTS =================

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    Color? bg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget rowItem(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  double _percent(double value) {
    if (totalWeight == 0) return 0;
    return (value / totalWeight) * 100;
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _buildLoadingScreen();
    }

    // 🔥 حساب الوزن العام بعيار 24
    // وزن العيارات بعد التحويل لعيار 24
    double caratWeight24K = 0;
    caratWeight.forEach((carat, weight) {
      if (carat != 24) {
        // العيارات 18، 21، 22 تتحول لـ 24
        caratWeight24K += _convertTo24Karat(weight, carat.toString());
      } else {
        caratWeight24K += weight;
      }
    });

    // 🔥 إجمالي الوزن العام = وزن العيارات (محول لـ24) + وزن الكسر (محول لـ24)
    double totalWeight24K = caratWeight24K + scrapWeight24K;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: Text("تقرير الرصيد العام"),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                loading = true;
              });
              _loadData();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 🔹 TOP CARDS
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                statCard(
                  title: 'اجمالي الوزن العام',
                  value: '${totalWeight24K.toStringAsFixed(3)} جرام',
                  icon: Icons.balance,
                  color: Colors.blue,
                ),
                statCard(
                  title: 'اجمالي الصندوق',
                  value: '${total.toStringAsFixed(0)} ريال',
                  icon: Icons.attach_money,
                  color: Colors.blue,
                ),
                statCard(
                  title: 'رصيد الكاش',
                  value: '${cashtotal.toStringAsFixed(0)} ريال',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
                statCard(
                  title: 'رصيد الشبكة',
                  value: '${visatotal.toStringAsFixed(0)} ريال',
                  icon: Icons.track_changes,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 REMAINING KITS CARD (الوزن المعلق)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFFD4AF37),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t('الوزن المعلق (عيار 24)',
                              'Remaining Weight (24K)'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_remainingKitsWeight.toStringAsFixed(3)} جم',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔥 NEW: SCRAP WEIGHT CARD (وزن الكسر عيار 24)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.recycling_rounded,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t('وزن الكسر (عيار 24)', 'Scrap Weight (24K)'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${scrapWeight24K.toStringAsFixed(3)} جم',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 DISTRIBUTION
            sectionCard(
              'توزيع الأوزان حسب العيار',
              Column(
                children: [
                  _caratRow(
                    'عيار 18',
                    caratWeight[18]!,
                    Colors.orange,
                  ),
                  _caratRow(
                    'عيار 21',
                    caratWeight[21]!,
                    Colors.green,
                  ),
                  _caratRow(
                    'عيار 22',
                    caratWeight[22]!,
                    Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            if (deptCount.isNotEmpty) const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(),
              child: Text(
                _t("عدد الاقسام المسجلة", "Number of dept existed"),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: deptCount.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFD4AF37)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.category,
                            size: 18, color: Color(0xFFD4AF37)),
                        const SizedBox(width: 6),
                        Text(
                          "${entry.key} : ${entry.value}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.rtl,
              child: sectionCard(
                'نظرة سريعة',
                Column(
                  children: [
                    rowItem('رصيد الكسر (خام)',
                        '${scrapWeight.toStringAsFixed(2)} جرام'),
                    rowItem('عدد الاحجار', '${stonesCount.toStringAsFixed(2)} ',
                        color: Colors.purple),
                    rowItem(
                        'عدد السبائك', '${BullionCount.toStringAsFixed(2)} ',
                        color: Color(0xFFD4AF37)),
                    rowItem('وزن السبائك',
                        '${BullionWeight.toStringAsFixed(2)} جرام',
                        color: Color(0xFFD4AF37)),
                    rowItem('توريدات للادراة هذا الشهر',
                        ' كاش : ${supplycash.toStringAsFixed(0)} شبكة : ${supplyvisa.toStringAsFixed(0)}',
                        color: Colors.red),
                    rowItem('استيرادات الادراة هذا الشهر',
                        ' كاش : ${importcash.toStringAsFixed(0)} شبكة : ${importvisa.toStringAsFixed(0)}',
                        color: Colors.red),
                    rowItem('المصروفات هذا الشهر ',
                        '${expenses_Month.toStringAsFixed(0)} ريال',
                        color: Colors.green),
                    rowItem('رصيد بيع جزئي متبقي',
                        '${balancesWeight.toStringAsFixed(2)} جرام',
                        color: Colors.orange),
                    rowItem('عدد أرصدة البيع الجزئي', '$balancesCount',
                        color: Colors.orange),
                    rowItem('عدد الذهب المحذوف', '$deletedGoldCount',
                        color: Colors.red),
                    rowItem('وزن الذهب المحذوف',
                        '${deletedGoldWeight.toStringAsFixed(2)} جرام',
                        color: Colors.red),
                    rowItem('عدد الأحجار المحذوفة', '$deletedGemCount',
                        color: Colors.purple),
                    rowItem('تكلفة الأحجار المحذوفة',
                        '${deletedGemCost.toStringAsFixed(0)} ريال',
                        color: Colors.purple),
                    rowItem('عدد السبائك المحذوفة', '$deletedBullionCount',
                        color: Colors.orange),
                    rowItem('وزن السبائك المحذوفة',
                        '${deletedBullionWeight.toStringAsFixed(2)} جرام',
                        color: Colors.orange),
                    const Divider(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text(
                "عرض المفقود",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _calculateMissingItems();

                if (missingByDepartment.isEmpty) {
                  _showNoMissingDialog();
                } else {
                  _showMissingDialog();
                }
              },
            ),

            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.rtl,
              child: sectionCard(
                'الموردين',
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FS.suppliersStream(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final suppliers = snap.data!;

                    if (suppliers.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'لا يوجد موردين حالياً',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showSuppliers = !showSuppliers;
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'عدد الموردين: ${suppliers.length}',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                showSuppliers
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: suppliers.length,
                            itemBuilder: (_, i) {
                              final s = suppliers[i];
                              return _supplierCard(s);
                            },
                          ),
                          crossFadeState: showSuppliers
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 250),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _supplierCard(Map<String, dynamic> s) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          s["name"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: FutureBuilder<Map<String, dynamic>>(
          future: _supplierSummary(s["id"]),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Text("جاري حساب الرصيد...");
            }

            final data = snap.data!;
            final bool cleared = data["cleared"];
            final double w = data["weight"];
            final double g = data["wage"];

            Color color;
            String status;

            if (cleared) {
              color = Colors.green;
              status = "تمت تصفية الحساب";
            } else if (w > 0) {
              color = Colors.red;
              status = "للمورد";
            } else {
              color = Colors.green.shade700;
              status = "على المورد";
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📞 ${s["phone"] ?? '-'}"),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (!cleared) ...[
                  const SizedBox(height: 4),
                  Text(
                    "وزن: ${w.abs().toStringAsFixed(2)} جم • أجر: ${g.abs().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        onTap: () async {
          final vouchers = await FS.getVouchersForSupplier(s["id"]);

          final Map<String, double> totalPaymentWeight = {
            "18": 0,
            "21": 0,
            "22": 0
          };
          final Map<String, double> totalReceiptWeight = {
            "18": 0,
            "21": 0,
            "22": 0
          };
          final Map<String, double> totalPaymentWage = {
            "18": 0,
            "21": 0,
            "22": 0
          };
          final Map<String, double> totalReceiptWage = {
            "18": 0,
            "21": 0,
            "22": 0
          };

          for (var v in vouchers) {
            final carat = (v["carat"] ?? "").toString();
            final weight =
                double.tryParse(v["weight"]?.toString() ?? "0") ?? 0.0;
            final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0.0;

            if (["18", "21", "22"].contains(carat)) {
              if (v["type"] == "payment") {
                totalPaymentWeight[carat] =
                    (totalPaymentWeight[carat] ?? 0) + weight;
                totalPaymentWage[carat] = (totalPaymentWage[carat] ?? 0) + wage;
              } else if (v["type"] == "receipt") {
                totalReceiptWeight[carat] =
                    (totalReceiptWeight[carat] ?? 0) + weight;
                totalReceiptWage[carat] = (totalReceiptWage[carat] ?? 0) + wage;
              }
            }
          }

          final Map<String, double> balanceWeight = {};
          final Map<String, double> balanceWage = {};

          for (var c in ["18", "21", "22"]) {
            balanceWeight[c] = totalReceiptWeight[c]! - totalPaymentWeight[c]!;
            balanceWage[c] = totalReceiptWage[c]! - totalPaymentWage[c]!;
          }

          final totalBalanceWeight =
              balanceWeight.values.fold(0.0, (a, b) => a + b);
          final totalBalanceWage =
              balanceWage.values.fold(0.0, (a, b) => a + b);

          final allCleared =
              balanceWeight.values.every((v) => v.abs() < 0.0001) &&
                  balanceWage.values.every((v) => v.abs() < 0.0001);

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Center(
                child: Text(
                  _t("رصيد المورد", "Supplier Balance"),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.85,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        color: allCleared
                            ? Colors.green.shade50
                            : totalBalanceWeight > 0
                                ? Colors.amber.shade50
                                : Colors.red.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                allCleared
                                    ? Icons.check_circle
                                    : (totalBalanceWeight > 0
                                        ? Icons.account_balance_wallet
                                        : Icons.warning_amber_rounded),
                                color: allCleared
                                    ? Colors.green
                                    : (totalBalanceWeight > 0
                                        ? Colors.red
                                        : Colors.green),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (allCleared)
                                      Text(
                                        _t("تمت تصفية الحساب بالكامل ",
                                            "Account fully settled "),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.green,
                                        ),
                                      )
                                    else ...[
                                      Text(
                                        totalBalanceWeight > 0
                                            ? _t("للمورد", "Supplier balance")
                                            : _t("على المورد", "Supplier owes"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: totalBalanceWeight > 0
                                              ? Colors.red.shade800
                                              : Colors.green.shade800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 4),
                                          Text(
                                            "${_t("الوزن", "Weight")}: ${totalBalanceWeight.abs().toStringAsFixed(2)} جم",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${_t("الأجر", "Wage")}: ${totalBalanceWage.abs().toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!allCleared)
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  _t("تفاصيل حسب العيار", "Details by Carat"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 6,
                                  crossAxisSpacing: 6,
                                  childAspectRatio: 1.1,
                                  children: ["18", "21", "22"].map((c) {
                                    final bw = balanceWeight[c]!;
                                    final wg = balanceWage[c]!;

                                    final bool cleared =
                                        bw.abs() < 0.0001 && wg.abs() < 0.0001;

                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: cleared
                                            ? Colors.grey.shade100
                                            : bw > 0
                                                ? Colors.red.shade50
                                                : bw < 0
                                                    ? Colors.green.shade50
                                                    : Colors.amber.shade50,
                                        border: Border.all(
                                          color: cleared
                                              ? Colors.grey.shade300
                                              : bw > 0
                                                  ? Colors.red.shade300
                                                  : Colors.green.shade300,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("عيار $c",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${_t("وزن", "weight")}: ${bw.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: bw == 0
                                                      ? Colors.grey
                                                      : bw > 0
                                                          ? Colors.red.shade800
                                                          : Colors
                                                              .green.shade800,
                                                  fontSize: 13),
                                            ),
                                            Text(
                                              "${_t("أجر", "Wage")}: ${wg.toStringAsFixed(2)}",
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Divider(thickness: 1),
                      const SizedBox(height: 6),
                      Text(
                        _t("قائمة السندات", "Vouchers List"),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      ...vouchers.map((v) {
                        final isReceipt = v["type"] == "receipt";

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isReceipt
                                          ? Colors.red.shade100
                                          : Colors.green.shade100,
                                      child: Icon(
                                        isReceipt
                                            ? Icons.download_done
                                            : Icons.upload,
                                        color: isReceipt
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isReceipt
                                          ? _t("سند قبض", "Receipt Voucher")
                                          : _t("سند صرف", "Payment Voucher"),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const Spacer(),
                                    if (v["date"] != null)
                                      Text(
                                        " ${(v["date"] as Timestamp).toDate().toString().split(' ')[0]}",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12),
                                      ),
                                  ],
                                ),
                                const Divider(height: 16),
                                Text(
                                    "${_t("المندوب", "Delegate")}: ${v["delegate"] ?? "-"}"),
                                Text(
                                    "${_t("العيار", "Carat")}: ${v["carat"] ?? "-"}"),
                                Text(
                                    "${_t("الوزن", "Weight")}: ${v["weight"] ?? 0} g"),
                                Text(
                                    "${_t("الأجر", "Wage")}: ${v["wage"] ?? 0}"),
                                if (!isReceipt) ...[
                                  if (v["paymentMethod"] != null)
                                    Text(
                                        "${_t("طريقة الدفع", "Payment Method")}: ${v["paymentMethod"]}"),
                                  if (v["cash"] != null)
                                    Text("${_t("كاش", "Cash")}: ${v["cash"]}"),
                                  if (v["network"] != null)
                                    Text(
                                        "${_t("شبكة", "Network")}: ${v["network"]}"),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
    final vouchers = await FS.getVouchersForSupplier(supplierId);

    double payW = 0, recW = 0;
    double payG = 0, recG = 0;

    for (var v in vouchers) {
      final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

      if (v["type"] == "payment") {
        payW += weight;
        payG += wage;
      } else if (v["type"] == "receipt") {
        recW += weight;
        recG += wage;
      }
    }

    final balanceWeight = recW - payW;
    final balanceWage = recG - payG;

    final cleared = balanceWeight.abs() < 0.0001 && balanceWage.abs() < 0.0001;

    return {
      "cleared": cleared,
      "weight": balanceWeight,
      "wage": balanceWage,
    };
  }

  Widget _lostDetails() {
    return Column(
      children: [
        const SizedBox(height: 12),
        _summaryCard(
          title: 'ذهب',
          children: [
            _summaryRow('عيار 18',
                count: missing_18,
                weight: missingweight_18,
                wage: missingwage_18),
            _summaryRow('عيار 21',
                count: missing_21,
                weight: missing_weight21,
                wage: missing_wage21),
            _summaryRow('عيار 22',
                count: missing_22,
                weight: missing_weight22,
                wage: missing_wage22),
          ],
        ),
        const SizedBox(height: 8),
        _summaryCard(
          title: 'سبائك',
          children: [
            _summaryRow(
              'سبائك',
              count: missing_Bullion,
              weight: missing_weightbullion,
              cost: missing_wagebullion,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _summaryCard(
          title: 'أحجار',
          children: [
            _summaryRow(
              'أحجار',
              count: missing_Gem,
              cost: missing_costgem,
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoadingImages ? null : _loadAllMissingImages,
          child: isLoadingImages
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("عرض كل صور العناصر المفقودة"),
        ),
      ],
    );
  }

  Future<void> _loadAllMissingImages() async {
    if (missingEpcs.isEmpty) return;

    setState(() => isLoadingImages = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      final futures = missingEpcs.map((epc) async {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('users')
            .child(uid)
            .child(epc);

        final result = await storageRef.listAll();

        return Future.wait(
          result.items.map((ref) => ref.getDownloadURL()),
        );
      });

      final results = await Future.wait(futures);

      allMissingImageUrls = results.expand((element) => element).toList();

      setState(() => isLoadingImages = false);

      if (allMissingImageUrls.isNotEmpty) {
        _openImageViewer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("لا توجد صور محفوظة")),
        );
      }
    } catch (e) {
      setState(() => isLoadingImages = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل تحميل الصور")),
      );
    }
  }

  void _openImageViewer() {
    showDialog(
      context: context,
      builder: (_) {
        PageController controller = PageController();

        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: allMissingImageUrls.length,
                itemBuilder: (_, index) {
                  return InteractiveViewer(
                    child: Image.network(
                      allMissingImageUrls[index],
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label, {
    int? count,
    double? weight,
    double? wage,
    double? cost,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (count != null) Text('عدد الشرائح: $count'),
          if (weight != null) Text('الوزن: ${weight.toStringAsFixed(2)} جرام'),
          if (wage != null) Text('الأجر: ${wage.toStringAsFixed(2)} ريال'),
          if (cost != null) Text('التكلفة: ${cost.toStringAsFixed(2)} ريال'),
        ],
      ),
    );
  }

  Widget _caratRow(String title, double weight, Color color) {
    final percent = _percent(weight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${weight.toStringAsFixed(2)}   •  ${percent.toStringAsFixed(1)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: color.withOpacity(.15),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
}
