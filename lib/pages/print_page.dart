// // import 'dart:typed_data';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:intl/intl.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// // import 'dart:io';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:flutter/services.dart' show rootBundle;
// // import '../services/firestore_service.dart';

// // class PdfReport {
// //   /// ✅ تجيب عناصر من Firestore (items)
// //   static Future<List<Map<String, dynamic>>> getItemsByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('items')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   static Future<List<Map<String, dynamic>>> getupdatesByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('items')
// //         .where('updatedAt', isGreaterThanOrEqualTo: start)
// //         .where('updatedAt', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (inventories)
// //   static Future<List<Map<String, dynamic>>> getInventoriesByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('inventories')
// //         .where('lastSeenAt', isGreaterThanOrEqualTo: start)
// //         .where('lastSeenAt', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (sales)
// //   static Future<List<Map<String, dynamic>>> getSalesByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('sales')
// //         .where('soldAt', isGreaterThanOrEqualTo: start)
// //         .where('soldAt', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (branchTransfers)
// //   static Future<List<Map<String, dynamic>>> getBranchTransfersByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('branchTransfers')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (scrapTransactions)
// //   static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('scrapTransactions')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (vouchers)
// //   static Future<List<Map<String, dynamic>>> getvouchersByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('vouchers')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (expenses)
// //   static Future<List<Map<String, dynamic>>> getexpensesByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('expenses')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (managementDeposits)
// //   static Future<List<Map<String, dynamic>>> getmanagementDepositsByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('managementDeposits')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ تجيب عناصر من Firestore (managementImported)
// //   static Future<List<Map<String, dynamic>>> getmanagementImportedByDateRange(
// //       DateTime start, DateTime end) async {
// //     final user = FirebaseAuth.instance.currentUser;
// //     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(user.uid)
// //         .collection('managementImported')
// //         .where('date', isGreaterThanOrEqualTo: start)
// //         .where('date', isLessThanOrEqualTo: end)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = d.data();
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ توليد ملف PDF
// //   static Future<Uint8List> generatePdfReport(
// //       List<Map<String, dynamic>> items,
// //       List<Map<String, dynamic>> inventories,
// //       List<Map<String, dynamic>> sales,
// //       List<Map<String, dynamic>> branchTransfers,
// //       List<Map<String, dynamic>> updates,
// //       List<Map<String, dynamic>> scrapTransactions,
// //       List<Map<String, dynamic>> vouchers,
// //       List<Map<String, dynamic>> expenses,
// //       List<Map<String, dynamic>> managementDeposits,
// //       List<Map<String, dynamic>> managementImported,
// //       DateTime start,
// //       DateTime end) async {
// //     final pdf = pw.Document();

// //     final arabicFont = await PdfGoogleFonts.cairoRegular();
// //     final arabicFontBold = await PdfGoogleFonts.cairoBold();

// //     // ---------------- إجماليات items ----------------
// //     int totalCount = 0;
// //     double totalWeight = 0;
// //     double totalWage = 0;
// //     double totalCost = 0;

// // // ---------------- إجماليات opening balance ----------------
// //     int openingCount = 0;
// //     double openingWeight = 0;
// //     double openingWage = 0;
// //     double openingCost = 0;

// // // ---------------- إجماليات التعديلات ----------------
// //     int updatedCount = 0;
// //     double updatedWeight = 0;
// //     double updatedWage = 0;
// //     double updatedCost = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للعادية)
// //     int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
// //     double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للـ Opening)
// //     int opening18 = 0,
// //         opening21 = 0,
// //         opening22 = 0,
// //         openingBullion = 0,
// //         openingGem = 0;
// //     double openingWeight18 = 0,
// //         openingWeight21 = 0,
// //         openingWeight22 = 0,
// //         openingWeightBullion = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للتعديلات)
// //     int updated18 = 0,
// //         updated21 = 0,
// //         updated22 = 0,
// //         updatedBullion = 0,
// //         updatedGem = 0;
// //     double updatedWeight18 = 0,
// //         updatedWeight21 = 0,
// //         updatedWeight22 = 0,
// //         updatedWeightBullion = 0;

// //     for (var item in items) {
// //       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       final carat = payload['carat']?.toString();
// //       final category = item['category']?.toString();
// //       final fromOpening = item['fromOpeningBalance'] == true;

// //       // ---------------- العادية أو الافتتاحية ----------------
// //       if (fromOpening) {
// //         // 🔹 إجماليات الافتتاحية
// //         openingCount++;
// //         openingWeight += weight;
// //         openingWage += wage;
// //         openingCost += cost;

// //         if (carat == "18") {
// //           opening18++;
// //           openingWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           opening21++;
// //           openingWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           opening22++;
// //           openingWeight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           openingBullion++;
// //           openingWeightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           openingGem++;
// //         }
// //       } else {
// //         // 🔹 إجماليات العادية
// //         totalCount++;
// //         totalWeight += weight;
// //         totalWage += wage;
// //         totalCost += cost;

// //         if (carat == "18") {
// //           count18++;
// //           weight18 += weight;
// //         }
// //         if (carat == "21") {
// //           count21++;
// //           weight21 += weight;
// //         }
// //         if (carat == "22") {
// //           count22++;
// //           weight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           countBullion++;
// //           weightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           countGem++;
// //         }
// //       }
// //     }
// //     // ---------------- التعديلات (مستقلة) ----------------
// //     for (var update in updates) {
// //       final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       final carat = payload['carat']?.toString();
// //       final category = update['category']?.toString();
// //       final updatedAt = update['updatedAt'];

// //       if (updatedAt != null) {
// //         updatedCount++;
// //         updatedWeight += weight;
// //         updatedWage += wage;
// //         updatedCost += cost;

// //         if (carat == "18") {
// //           updated18++;
// //           updatedWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           updated21++;
// //           updatedWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           updated22++;
// //           updatedWeight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           updatedBullion++;
// //           updatedWeightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           updatedGem++;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات inventories ----------------
// //     int invTotalCount = inventories.length;
// //     double invTotalWeight = 0;
// //     double invTotalWage = 0;
// //     double invTotalCost = 0;

// //     int invCount18 = 0,
// //         invCount21 = 0,
// //         invCount22 = 0,
// //         invCountBullion = 0,
// //         invCountGem = 0;

// // // ✅ أوزان كل نوع
// //     double invWeight18 = 0,
// //         invWeight21 = 0,
// //         invWeight22 = 0,
// //         invWeightBullion = 0;

// //     for (var inv in inventories) {
// //       final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       invTotalWeight += weight;
// //       invTotalWage += wage;
// //       invTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = inv['category']?.toString();

// //       if (carat == "18") {
// //         invCount18++;
// //         invWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         invCount21++;
// //         invWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         invCount22++;
// //         invWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         invCountBullion++;
// //         invWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         invCountGem++;
// //       }
// //     }

// //     // 🟡 استخراج الـ itemId من المخزون (inventories)
// //     // 🟡 استخراج الـ EPCs أو IDs من المخزون الحالي
// //     final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();

// // // 🟡 تحديد العناصر المفقودة (اللي مش موجودة في المخزون)
// //     final missingItems = items.where((item) {
// //       final id = item['epcHex'] ?? item['id'];
// //       return !invIds.contains(id);
// //     }).toList();

// //     // ---------------- إجماليات المفقود ----------------
// //     // ---------------- إجماليات المفقود ----------------
// //     int missingCount = 0;
// //     double missingWeight = 0;
// //     double missingWage = 0;
// //     double missingCost = 0;

// //     int missing18 = 0,
// //         missing21 = 0,
// //         missing22 = 0,
// //         missingBullion = 0,
// //         missingGem = 0;
// //     double missingWeight18 = 0,
// //         missingWeight21 = 0,
// //         missingWeight22 = 0,
// //         missingWeightBullion = 0;

// //     for (var item in missingItems) {
// //       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
// //       final carat = payload['carat']?.toString();
// //       final category = item['category']?.toString();

// //       missingCount++;
// //       missingWeight += weight;
// //       missingWage += wage;
// //       missingCost += cost;

// //       if (carat == "18") {
// //         missing18++;
// //         missingWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         missing21++;
// //         missingWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         missing22++;
// //         missingWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         missingBullion++;
// //         missingWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         missingGem++;
// //       }
// //     }

// //     // ---------------- إجماليات المبيعات ----------------
// //     int salesTotalCount = sales.length;
// //     double salesTotalWeight = 0;
// //     double salesTotalWage = 0;
// //     double salesTotalCost = 0;

// //     int salesCount18 = 0,
// //         salesCount21 = 0,
// //         salesCount22 = 0,
// //         salesCountBullion = 0,
// //         salesCountGem = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double salesWeight18 = 0,
// //         salesWeight21 = 0,
// //         salesWeight22 = 0,
// //         salesWeightBullion = 0;

// //     for (var sale in sales) {
// //       final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       // جمع الإجماليات
// //       salesTotalWeight += weight;
// //       salesTotalWage += wage;
// //       salesTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = sale['category']?.toString();

// //       if (carat == "18") {
// //         salesCount18++;
// //         salesWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         salesCount21++;
// //         salesWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         salesCount22++;
// //         salesWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         salesCountBullion++;
// //         salesWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         salesCountGem++;
// //       }
// //     }

// //     // ---------------- إجماليات الفروع ----------------
// //     int branchTransfersTotalCount = branchTransfers.length;
// //     double branchTransfersTotalWeight = 0;
// //     double branchTransfersTotalWage = 0;
// //     double branchTransfersTotalCost = 0;

// //     int branchTransfersCount18 = 0,
// //         branchTransfersCount21 = 0,
// //         branchTransfersCount22 = 0,
// //         branchTransfersCountBullion = 0,
// //         branchTransfersCountGem = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double branchTransfersWeight18 = 0,
// //         branchTransfersWeight21 = 0,
// //         branchTransfersWeight22 = 0,
// //         branchTransfersWeightBullion = 0;

// //     for (var branchTransfer in branchTransfers) {
// //       final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       // جمع الإجماليات
// //       branchTransfersTotalWeight += weight;
// //       branchTransfersTotalWage += wage;
// //       branchTransfersTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = branchTransfer['category']?.toString();

// //       if (carat == "18") {
// //         branchTransfersCount18++;
// //         branchTransfersWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         branchTransfersCount21++;
// //         branchTransfersWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         branchTransfersCount22++;
// //         branchTransfersWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         branchTransfersCountBullion++;
// //         branchTransfersWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         branchTransfersCountGem++;
// //       }
// //     }

// //     // ---------------- إجماليات الكسر ----------------
// //     int scrapTransactionsTotalCount = 0;
// //     double scrapTransactionsTotalWeight = 0;
// //     double scrapTransactionsTotalcash = 0;
// //     double scrapTransactionsTotalnetwork = 0;
// //     double scrapTransactionsTotaltotal = 0;

// //     int scrapTransactionsCount18 = 0,
// //         scrapTransactionsCount14 = 0,
// //         scrapTransactionsCount24 = 0,
// //         scrapTransactionsCount21 = 0,
// //         scrapTransactionsCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double scrapTransactionsWeight18 = 0,
// //         scrapTransactionsWeight14 = 0,
// //         scrapTransactionsWeight24 = 0,
// //         scrapTransactionsWeight21 = 0,
// //         scrapTransactionsWeight22 = 0;

// //     for (var scrapTransaction in scrapTransactions) {
// //       final weight =
// //           double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
// //       final cash =
// //           double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;

// //       final carat = scrapTransaction['carat']?.toString();
// //       final type =
// //           scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';

// //       if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
// //         scrapTransactionsTotalCount += 1;
// //         scrapTransactionsTotalWeight += weight;
// //         scrapTransactionsTotalcash += cash;
// //         scrapTransactionsTotalnetwork += network;
// //         scrapTransactionsTotaltotal += total;

// //         if (carat == "14") {
// //           scrapTransactionsCount14++;
// //           scrapTransactionsWeight14 += weight;
// //         }
// //         if (carat == "18") {
// //           scrapTransactionsCount18++;
// //           scrapTransactionsWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           scrapTransactionsCount21++;
// //           scrapTransactionsWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           scrapTransactionsCount22++;
// //           scrapTransactionsWeight22 += weight;
// //         }
// //         if (carat == "24") {
// //           scrapTransactionsCount24++;
// //           scrapTransactionsWeight24 += weight;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات السندات ----------------
// //     int vouchersTotalCount = 0;
// //     int voucherspaymentCount = 0;
// //     int vouchersreceiptCount = 0;
// //     double vouchersTotalWeight = 0;
// //     double vouchersTotalcash = 0;
// //     double vouchersTotalnetwork = 0;
// //     double vouchersTotaltotal = 0;

// //     int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;

// //     for (var voucher in vouchers) {
// //       final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
// //       final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
// //       final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;

// //       final carat = voucher['carat']?.toString();
// //       final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
// //       vouchersTotalCount += 1;

// //       if (type.isNotEmpty && type == 'payment') {
// //         voucherspaymentCount += 1;
// //         vouchersTotalWeight += weight;
// //         vouchersTotalcash += cash;
// //         vouchersTotalnetwork += network;
// //         vouchersTotaltotal += total;

// //         if (carat == "18") {
// //           vouchersCount18++;
// //           vouchersWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           vouchersCount21++;
// //           vouchersWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           vouchersCount22++;
// //           vouchersWeight22 += weight;
// //         }
// //       } else if (type.isNotEmpty && type == 'receipt') {
// //         vouchersreceiptCount += 1;
// //         vouchersTotalWeight -= weight;
// //         vouchersTotalcash -= cash;
// //         vouchersTotalnetwork -= network;
// //         vouchersTotaltotal -= total;

// //         if (carat == "18") {
// //           vouchersCount18++;
// //           vouchersWeight18 -= weight;
// //         }
// //         if (carat == "21") {
// //           vouchersCount21++;
// //           vouchersWeight21 -= weight;
// //         }
// //         if (carat == "22") {
// //           vouchersCount22++;
// //           vouchersWeight22 -= weight;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات المصروفات ----------------
// //     int expensesTotalCount = 0;
// //     double expensesTotal = 0;

// //     //int scrapTransactionsCount18 = 0, scrapTransactionsCount21 = 0, scrapTransactionsCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     //double scrapTransactionsWeight18 = 0, scrapTransactionsWeight21 = 0, scrapTransactionsWeight22 = 0;

// //     for (var expense in expenses) {
// //       final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
// //       expensesTotal += amount;
// //       expensesTotalCount += 1;
// //     }

// //     // ---------------- إجماليات توريدات الادارة  ----------------
// //     int managementDepositsTotalCount = 0;
// //     double managementDepositsTotalcash = 0;
// //     double managementDepositsTotalnetwork = 0;
// //     double managementDepositsTotaltotal = 0;

// //     for (var managementDeposit in managementDeposits) {
// //       final cash =
// //           double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
// //       managementDepositsTotalCount += 1;
// //       managementDepositsTotalcash += cash;
// //       managementDepositsTotalnetwork += network;
// //       managementDepositsTotaltotal += total;
// //     }
// //     // ---------------- إجماليات الاستيرادات من الادارة  ----------------
// //     int managementImportedTotalCount = 0;
// //     double managementImportedTotalcash = 0;
// //     double managementImportedTotalnetwork = 0;
// //     double managementImportedTotaltotal = 0;

// //     for (var managementImport in managementImported) {
// //       final cash =
// //           double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
// //       managementImportedTotalCount += 1;
// //       managementImportedTotalcash += cash;
// //       managementImportedTotalnetwork += network;
// //       managementImportedTotaltotal += total;
// //     }

// //     // ---------------- إجماليات البائعين ----------------
// //     final Map<String, Map<String, double>> sellersTotals = {};

// //     for (var sale in sales) {
// //       final payment = sale['payment'] as Map<String, dynamic>? ?? {};

// //       final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';

// //       final total = (payment['total'] ?? 0).toDouble();
// //       final cash = (payment['cash'] ?? 0).toDouble();
// //       final visa = (payment['visa'] ?? 0).toDouble();

// //       sellersTotals.putIfAbsent(
// //           soldBy,
// //           () => {
// //                 'total': 0,
// //                 'cash': 0,
// //                 'visa': 0,
// //               });

// //       sellersTotals[soldBy]!['total'] =
// //           sellersTotals[soldBy]!['total']! + total;
// //       sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
// //       sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
// //     }

// //     // ---------------- PDF ----------------
// //     // صفحة العنوان والفترة
// //     final image = pw.MemoryImage(
// //       (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
// //     );

// //     pdf.addPage(
// //       pw.Page(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) {
// //           final pageWidth = PdfPageFormat.a4.width;
// //           final pageHeight = PdfPageFormat.a4.height;

// //           return pw.Stack(
// //             children: [
// //               // برواز ذهبي
// //               pw.Container(
// //                 width: pageWidth,
// //                 height: pageHeight,
// //                 decoration: pw.BoxDecoration(
// //                   color: PdfColors.white,
// //                   border: pw.Border.all(color: PdfColors.amber600, width: 3),
// //                 ),
// //               ),

// //               // المحتوى
// //               pw.Padding(
// //                 padding: const pw.EdgeInsets.all(40),
// //                 child: pw.Column(
// //                   mainAxisAlignment: pw.MainAxisAlignment.start,
// //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
// //                   children: [
// //                     // ✅ أيقونة ذهبية من صورة
// //                     pw.Image(image, width: 60, height: 60),

// //                     pw.SizedBox(height: 10),

// //                     // العنوان في النص
// //                     pw.Text(
// //                       "تقارير المخزون",
// //                       style: pw.TextStyle(
// //                         fontSize: 26,
// //                         fontWeight: pw.FontWeight.bold,
// //                         color: PdfColors.black,
// //                       ),
// //                       textAlign: pw.TextAlign.center,
// //                     ),

// //                     pw.SizedBox(height: 6),

// //                     // خط ذهبي تحت العنوان
// //                     pw.Container(
// //                       height: 2,
// //                       width: pageWidth * 0.4,
// //                       color: PdfColors.amber600,
// //                     ),

// //                     pw.SizedBox(height: 20),

// //                     // الفترة
// //                     pw.Text(
// //                       "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
// //                       "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
// //                       style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
// //                       textAlign: pw.TextAlign.center,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول الرصيد الافتتاحي",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(e,
// //                               style: pw.TextStyle(
// //                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                               textAlign: pw.TextAlign.center),
// //                         ))
// //                     .toList(),
// //               ),
// //               // Data rows (الافتتاحية فقط)
// //               ...items
// //                   .where((e) => e['fromOpeningBalance'] == true)
// //                   .map((item) {
// //                 final date = item['date'] is Timestamp
// //                     ? (item['date'] as Timestamp).toDate()
// //                     : item['date'];
// //                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.qrCode(),
// //                             data: payload['qrCode'],
// //                             width: 20,
// //                             height: 20),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.code128(),
// //                             data: payload['qrCode'],
// //                             width: 40,
// //                             height: 15,
// //                             drawText: false),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(item['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         payload['type']?.toString().isNotEmpty == true
// //                             ? payload['type'].toString()
// //                             : (payload['kind']?.toString().isNotEmpty == true
// //                                 ? payload['kind'].toString()
// //                                 : "—"),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات الرصيد الافتتاحي",
// //               style:
// //                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
// //           _buildTotals(
// //             openingCount,
// //             opening18,
// //             opening21,
// //             opening22,
// //             openingBullion,
// //             openingGem,
// //             openingWeight,
// //             openingWage,
// //             openingCost,
// //             openingWeight18,
// //             openingWeight21,
// //             openingWeight22,
// //             openingWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول الإدخال",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(e,
// //                               style: pw.TextStyle(
// //                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                               textAlign: pw.TextAlign.center),
// //                         ))
// //                     .toList(),
// //               ),
// //               // Data rows (العادي فقط)
// //               ...items
// //                   .where((e) => e['fromOpeningBalance'] != true)
// //                   .map((item) {
// //                 final date = item['date'] is Timestamp
// //                     ? (item['date'] as Timestamp).toDate()
// //                     : item['date'];
// //                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.qrCode(),
// //                             data: payload['qrCode'],
// //                             width: 20,
// //                             height: 20),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.code128(),
// //                             data: payload['qrCode'],
// //                             width: 40,
// //                             height: 15,
// //                             drawText: false),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(item['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         payload['type']?.toString().isNotEmpty == true
// //                             ? payload['type'].toString()
// //                             : (payload['kind']?.toString().isNotEmpty == true
// //                                 ? payload['kind'].toString()
// //                                 : "—"),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات الإدخال",
// //               style:
// //                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
// //           _buildTotals(
// //             totalCount,
// //             count18,
// //             count21,
// //             count22,
// //             countBullion,
// //             countGem,
// //             totalWeight,
// //             totalWage,
// //             totalCost,
// //             weight18,
// //             weight21,
// //             weight22,
// //             weightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // ✅ صفحة المفقودين
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول المفقود",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),
// //               // Data rows (المفقودين)
// //               ...missingItems.map((item) {
// //                 final date = item['date'] is Timestamp
// //                     ? (item['date'] as Timestamp).toDate()
// //                     : item['date'];
// //                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.qrCode(),
// //                           data: payload['qrCode'],
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.code128(),
// //                           data: payload['qrCode'],
// //                           width: 40,
// //                           height: 15,
// //                           drawText: false,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(item['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         payload['type']?.toString().isNotEmpty == true
// //                             ? payload['type'].toString()
// //                             : (payload['kind']?.toString().isNotEmpty == true
// //                                 ? payload['kind'].toString()
// //                                 : "—"),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات المفقود",
// //               style:
// //                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
// //           _buildTotals(
// //             missingCount,
// //             missing18,
// //             missing21,
// //             missing22,
// //             missingBullion,
// //             missingGem,
// //             missingWeight,
// //             missingWage,
// //             missingCost,
// //             missingWeight18,
// //             missingWeight21,
// //             missingWeight22,
// //             missingWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // صفحة جدول الجرد
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول الجرد",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "آخر ظهور",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...inventories.map((inv) {
// //                 final date = inv['lastSeenAt'] is Timestamp
// //                     ? (inv['lastSeenAt'] as Timestamp).toDate()
// //                     : inv['lastSeenAt'];
// //                 final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.qrCode(),
// //                           data: payload['qrCode'],
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.code128(),
// //                           data: payload['qrCode'],
// //                           width: 40,
// //                           height: 15,
// //                           drawText: false,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(inv['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                       payload['type']?.toString().isNotEmpty == true
// //                           ? payload['type'].toString()
// //                           : (payload['kind']?.toString().isNotEmpty == true
// //                               ? payload['kind'].toString()
// //                               : "—"),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الجرد",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildTotals(
// //             invTotalCount,
// //             invCount18,
// //             invCount21,
// //             invCount22,
// //             invCountBullion,
// //             invCountGem,
// //             invTotalWeight,
// //             invTotalWage,
// //             invTotalCost,
// //             invWeight18,
// //             invWeight21,
// //             invWeight22,
// //             invWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // ✅ صفحة جدول التعديلات
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول التعديلات",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(e,
// //                               style: pw.TextStyle(
// //                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                               textAlign: pw.TextAlign.center),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows (التعديلات فقط)
// //               ...updates.where((e) => e['updatedAt'] != null).map((update) {
// //                 final date = update['updatedAt'] is Timestamp
// //                     ? (update['updatedAt'] as Timestamp).toDate()
// //                     : update['updatedAt'];
// //                 final payload =
// //                     (update['payload'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.qrCode(),
// //                             data: payload['qrCode'],
// //                             width: 20,
// //                             height: 20),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                             barcode: pw.Barcode.code128(),
// //                             data: payload['qrCode'],
// //                             width: 40,
// //                             height: 15,
// //                             drawText: false),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(update['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                       payload['type']?.toString().isNotEmpty == true
// //                           ? payload['type'].toString()
// //                           : (payload['kind']?.toString().isNotEmpty == true
// //                               ? payload['kind'].toString()
// //                               : "—"),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات التعديلات",
// //               style:
// //                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
// //           _buildTotals(
// //             updatedCount,
// //             updated18,
// //             updated21,
// //             updated22,
// //             updatedBullion,
// //             updatedGem,
// //             updatedWeight,
// //             updatedWage,
// //             updatedCost,
// //             updatedWeight18,
// //             updatedWeight21,
// //             updatedWeight22,
// //             updatedWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// // // صفحة جدول المبيعات
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول المبيعات",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1.9),
// //               2: pw.FlexColumnWidth(1),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(1),
// //               6: pw.FlexColumnWidth(1.5),
// //               7: pw.FlexColumnWidth(1.7),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //               10: pw.FlexColumnWidth(1.5),
// //               11: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "مستخدم",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "عيار",
// //                   "قطعة",
// //                   "مكونات",
// //                   "كاش",
// //                   "شبكة",
// //                   "اجمالي",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...sales.map((sale) {
// //                 final date = sale['soldAt'] is Timestamp
// //                     ? (sale['soldAt'] as Timestamp).toDate()
// //                     : sale['soldAt'];
// //                 final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
// //                 final payment = (sale['payment'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.qrCode(),
// //                           data: payload['qrCode'],
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.code128(),
// //                           data: payload['qrCode'],
// //                           width: 40,
// //                           height: 15,
// //                           drawText: false,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(payment['soldBy']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(translateCategory(sale['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                       payload['type']?.toString().isNotEmpty == true
// //                           ? payload['type'].toString()
// //                           : (payload['kind']?.toString().isNotEmpty == true
// //                               ? payload['kind'].toString()
// //                               : "—"),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payment['cash']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payment['visa']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payment['total']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات المبيعات",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildTotals(
// //             salesTotalCount,
// //             salesCount18,
// //             salesCount21,
// //             salesCount22,
// //             salesCountBullion,
// //             salesCountGem,
// //             salesTotalWeight,
// //             salesTotalWage,
// //             salesTotalCost,
// //             salesWeight18,
// //             salesWeight21,
// //             salesWeight22,
// //             salesWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(
// //           base: arabicFont,
// //           bold: arabicFontBold,
// //         ),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات البائعين",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(3),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(2),
// //               3: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // 🔹 الهيدر
// //               pw.TableRow(
// //                 decoration: const pw.BoxDecoration(color: PdfColors.grey200),
// //                 children: [
// //                   _cell("البائع", bold: true),
// //                   _cell("الإجمالي", bold: true),
// //                   _cell("كاش", bold: true),
// //                   _cell("شبكة", bold: true),
// //                 ],
// //               ),

// //               // 🔹 البيانات
// //               ...sellersTotals.entries.map((e) {
// //                 return pw.TableRow(
// //                   children: [
// //                     _cell(e.key),
// //                     _cell(e.value['total']!.toStringAsFixed(2)),
// //                     _cell(e.value['cash']!.toStringAsFixed(2)),
// //                     _cell(e.value['visa']!.toStringAsFixed(2)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول التحويلات",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(1),
// //               2: pw.FlexColumnWidth(1.5),
// //               3: pw.FlexColumnWidth(1.5),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(0.8),
// //               6: pw.FlexColumnWidth(1.2),
// //               7: pw.FlexColumnWidth(1.2),
// //               8: pw.FlexColumnWidth(1.5),
// //               9: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "كود",
// //                   "نوع",
// //                   "تاريخ",
// //                   "وزن",
// //                   "أجر",
// //                   "عيار",
// //                   "قطعة",
// //                   "تكلفة",
// //                   "مكونات",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...branchTransfers.map((branchTransfer) {
// //                 final date = branchTransfer['date'] is Timestamp
// //                     ? (branchTransfer['date'] as Timestamp).toDate()
// //                     : branchTransfer['date'];
// //                 final payload =
// //                     (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;

// //                 pw.Widget codeWidget;
// //                 if (payload['qrCode'] != null) {
// //                   if (payload['showQr'] == true) {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.qrCode(),
// //                           data: payload['qrCode'],
// //                           width: 20,
// //                           height: 20,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   } else {
// //                     codeWidget = pw.Column(
// //                       mainAxisSize: pw.MainAxisSize.min,
// //                       children: [
// //                         pw.BarcodeWidget(
// //                           barcode: pw.Barcode.code128(),
// //                           data: payload['qrCode'],
// //                           width: 40,
// //                           height: 15,
// //                           drawText: false,
// //                         ),
// //                         pw.SizedBox(height: 1),
// //                         pw.Text(payload['qrCode']?.toString() ?? "—",
// //                             style: pw.TextStyle(fontSize: 6)),
// //                       ],
// //                     );
// //                   }
// //                 } else {
// //                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
// //                 }

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                         padding: const pw.EdgeInsets.all(2), child: codeWidget),
// //                     pw.Text(translateCategory(branchTransfer['category']),
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['wage']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                       payload['type']?.toString().isNotEmpty == true
// //                           ? payload['type'].toString()
// //                           : (payload['kind']?.toString().isNotEmpty == true
// //                               ? payload['kind'].toString()
// //                               : "—"),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(payload['cost']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['setComponents']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(payload['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات التحويلات",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildTotals(
// //             branchTransfersTotalCount,
// //             branchTransfersCount18,
// //             branchTransfersCount21,
// //             branchTransfersCount22,
// //             branchTransfersCountBullion,
// //             branchTransfersCountGem,
// //             branchTransfersTotalWeight,
// //             branchTransfersTotalWage,
// //             branchTransfersTotalCost,
// //             branchTransfersWeight18,
// //             branchTransfersWeight21,
// //             branchTransfersWeight22,
// //             branchTransfersWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول الكسر",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(1),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(1),
// //               3: pw.FlexColumnWidth(2),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(1.5),
// //               6: pw.FlexColumnWidth(1.5),
// //               7: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "نوع",
// //                   "تاريخ",
// //                   "عيار",
// //                   "وزن",
// //                   "كاش",
// //                   "شبكة",
// //                   "اجمالي",
// //                   "ملاحظات"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...scrapTransactions.where((scrapTransaction) {
// //                 final type =
// //                     scrapTransaction['type']?.toString().trim().toLowerCase() ??
// //                         '';
// //                 return type == 'sale' || type == 'add';
// //               }).map((scrapTransaction) {
// //                 final date = scrapTransaction['date'] is Timestamp
// //                     ? (scrapTransaction['date'] as Timestamp).toDate()
// //                     : scrapTransaction['date'];

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Text(
// //                       (() {
// //                         final type = scrapTransaction['type']
// //                             ?.toString()
// //                             .trim()
// //                             .toLowerCase();
// //                         if (type == 'add') return 'شراء';
// //                         if (type == 'sale') return 'بيع';
// //                         return '—';
// //                       })(),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['cash']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['network']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['total']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(scrapTransaction['notes']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الكسر",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 14 : $scrapTransactionsCount14             ( وزن:   ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 18 : $scrapTransactionsCount18             ( وزن:   ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 21 : $scrapTransactionsCount21              ( وزن:  ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 22 : $scrapTransactionsCount22              ( وزن:  ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 24 : $scrapTransactionsCount24             ( وزن:   ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول السندات",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(1),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(1),
// //               3: pw.FlexColumnWidth(2),
// //               4: pw.FlexColumnWidth(1.5),
// //               5: pw.FlexColumnWidth(1.5),
// //               6: pw.FlexColumnWidth(1.5),
// //               7: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: [
// //                   "سند",
// //                   "تاريخ",
// //                   "عيار",
// //                   "وزن",
// //                   "كاش",
// //                   "شبكة",
// //                   "اجمالي",
// //                   "مندوب",
// //                   "مورد"
// //                 ]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...vouchers.where((voucher) {
// //                 final type =
// //                     voucher['type']?.toString().trim().toLowerCase() ?? '';
// //                 return type == 'receipt' || type == 'payment';
// //               }).map((voucher) {
// //                 final date = voucher['date'] is Timestamp
// //                     ? (voucher['date'] as Timestamp).toDate()
// //                     : voucher['date'];

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Text(
// //                       (() {
// //                         final type =
// //                             voucher['type']?.toString().trim().toLowerCase();
// //                         if (type == 'payment') return 'صرف';
// //                         if (type == 'receipt') return 'قبض';
// //                         return '—';
// //                       })(),
// //                       textAlign: pw.TextAlign.center,
// //                       style: pw.TextStyle(fontSize: 8),
// //                     ),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['carat']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['weight']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['cash']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['network']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['total']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['delegate']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(voucher['supplierName']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات السندات",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد السندات: $vouchersTotalCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 18 : $vouchersCount18             ( وزن:   ${vouchersWeight18.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 21 : $vouchersCount21              ( وزن:  ${vouchersWeight21.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 22 : $vouchersCount22              ( وزن:  ${vouchersWeight22.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول المصروفات",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(2),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(2),
// //               3: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: ["نوع", "تاريخ", "مصروف", "سبب الصرف"]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...expenses.map((expense) {
// //                 final date = expense['date'] is Timestamp
// //                     ? (expense['date'] as Timestamp).toDate()
// //                     : expense['date'];

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Text(expense['type']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(expense['amount']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(expense['note']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجمالي المصروفات",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد المصروفات: $expensesTotalCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي قيمة المصروفات: $expensesTotal",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول توريد للادارة",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(1),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(1),
// //               3: pw.FlexColumnWidth(2),
// //               4: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...managementDeposits.map((managementDeposit) {
// //                 final date = managementDeposit['date'] is Timestamp
// //                     ? (managementDeposit['date'] as Timestamp).toDate()
// //                     : managementDeposit['date'];

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Text(managementDeposit['type']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementDeposit['cash']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementDeposit['visa']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementDeposit['total']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات التوريد للادارة ",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.Text("جدول استيرادات من الادارة",
// //               style:
// //                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(1),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(1),
// //               3: pw.FlexColumnWidth(2),
// //               4: pw.FlexColumnWidth(1.5),
// //             },
// //             children: [
// //               // Header
// //               pw.TableRow(
// //                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
// //                 children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
// //                     .map((e) => pw.Padding(
// //                           padding: const pw.EdgeInsets.all(4),
// //                           child: pw.Text(
// //                             e,
// //                             style: pw.TextStyle(
// //                                 fontSize: 10, fontWeight: pw.FontWeight.bold),
// //                             textAlign: pw.TextAlign.center,
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //               // Data rows
// //               ...managementImported.map((managementImport) {
// //                 final date = managementImport['date'] is Timestamp
// //                     ? (managementImport['date'] as Timestamp).toDate()
// //                     : managementImport['date'];

// //                 return pw.TableRow(
// //                   children: [
// //                     pw.Text(managementImport['type']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(
// //                         date != null
// //                             ? DateFormat('yyyy/MM/dd').format(date)
// //                             : "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementImport['cash']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementImport['visa']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                     pw.Text(managementImport['total']?.toString() ?? "—",
// //                         textAlign: pw.TextAlign.center,
// //                         style: pw.TextStyle(fontSize: 8)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الاستيرادات من لادارة ",
// //             style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد التوريدات: $managementImportedTotalCount",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 8),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     // 🧾 صفحة عمليات الصندوق
// //     try {
// //       double sum = 0.0;
// //       double cash = 0.0;
// //       double visa = 0.0;
// //       //List<Map<String, dynamic>> all = [];

// //       // 🟢 بيع القطع
// //       final salesSnap = await FS.salesCol().get();
// //       for (var d in salesSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['payment']?['total'] ?? 0).toDouble();
// //         final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
// //         final date = (data['createdAt'] as Timestamp?)?.toDate();

// //         sum += wage;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       // 🟢 بيع كسر
// //       final scrapSnap =
// //           await FS.scrapCol().where("type", isEqualTo: "sale").get();
// //       for (var d in scrapSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum += wage;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       // 🔴 شراء كسر
// //       final scrapBuySnap =
// //           await FS.scrapCol().where("type", isEqualTo: "add").get();
// //       for (var d in scrapBuySnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= wage;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }

// //       // 🔴 سندات الصرف
// //       final vouchersSnap =
// //           await FS.vouchersCol().where("type", isEqualTo: "payment").get();
// //       for (var d in vouchersSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= wage;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }

// //       // 🔴 المصروفات
// //       final expSnap = await FS.expensesCol().get();
// //       for (var d in expSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         //final displayType = _t('مصروف', 'Expense');

// //         sum -= amount;
// //         cash -= amount;
// //       }

// //       // 🔵 توريد للإدارة
// //       final depositSnap = await FS.depositsCol().get();
// //       for (var d in depositSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['visa'] ?? 0).toDouble();
// //         final totalValue = totalcash + totalvisa;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= totalValue;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }
// //       // 🔵 استيراد من الإدارة
// //       final ImportSnap = await FS.ImportedCol().get();
// //       for (var d in ImportSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['visa'] ?? 0).toDouble();
// //         final totalValue = totalcash + totalvisa;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum += totalValue;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       //print("✅ تم حساب البيانات بنجاح. عدد الصفوف: ${cashBoxRows.length}");
// //       print("الإجمالي الكاش: $cash - الشبكة: $visa - الكلي: $sum");

// //       // صفحة الـ PDF
// //       // 🧾 صفحة عمليات الصندوق
// //       pdf.addPage(
// //         pw.MultiPage(
// //           pageFormat: PdfPageFormat.a4,
// //           textDirection: pw.TextDirection.rtl,
// //           theme: pw.ThemeData.withFont(
// //             base: arabicFont,
// //             bold: arabicFontBold,
// //           ),
// //           build: (context) => [
// //             pw.SizedBox(height: 15),

// //             // 🧮 إجماليات الصندوق
// //             pw.Text(
// //               "إجماليات الصندوق",
// //               style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //             ),
// //             pw.SizedBox(height: 8),

// //             pw.Table(
// //               border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //               columnWidths: const {
// //                 0: pw.FlexColumnWidth(3),
// //                 1: pw.FlexColumnWidth(2),
// //               },
// //               children: [
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("إجمالي الكاش",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         cash.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("إجمالي الشبكة",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         visa.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("الإجمالي الكلي",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         sum.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       );
// //     } catch (e, st) {
// //       print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
// //       print(st);
// //     }

// //     return pdf.save();
// //   }

// //   /// ✅ دالة تعرض نافذة الطباعة مباشرة
// //   static Future<void> printReport(DateTime start, DateTime end) async {
// //     final items = await getItemsByDateRange(start, end);
// //     final updates = await getupdatesByDateRange(start, end);
// //     final inventories = await getInventoriesByDateRange(start, end);
// //     final sales = await getSalesByDateRange(start, end);
// //     final branchTransfers = await getBranchTransfersByDateRange(start, end);
// //     final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
// //     final vouchers = await getvouchersByDateRange(start, end);
// //     final expenses = await getexpensesByDateRange(start, end);
// //     final managementDeposits =
// //         await getmanagementDepositsByDateRange(start, end);
// //     final managementImported =
// //         await getmanagementImportedByDateRange(start, end);
// //     final pdfData = await generatePdfReport(
// //         items,
// //         inventories,
// //         sales,
// //         branchTransfers,
// //         updates,
// //         scrapTransactions,
// //         vouchers,
// //         expenses,
// //         managementDeposits,
// //         managementImported,
// //         start,
// //         end);

// //     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
// //   }

// //   /// ✅ نسخة تستخدم للـ Workmanager

// //   static Future<bool> runScheduledReport(DateTime start, DateTime end) async {
// //     try {
// //       // ✅ هات البيانات للفترة المطلوبة
// //       final items = await getItemsByDateRange(start, end);
// //       final updates = await getupdatesByDateRange(start, end);
// //       final inventories = await getInventoriesByDateRange(start, end);
// //       final sales = await getSalesByDateRange(start, end);
// //       final branchTransfers = await getBranchTransfersByDateRange(start, end);
// //       final scrapTransactions =
// //           await getScrapTransactionsByDateRange(start, end);
// //       final vouchers = await getvouchersByDateRange(start, end);
// //       final expenses = await getexpensesByDateRange(start, end);
// //       final managementDeposits =
// //           await getmanagementDepositsByDateRange(start, end);
// //       final managementImported =
// //           await getmanagementImportedByDateRange(start, end);

// //       // ✅ ولّد PDF من نفس الدالة بتاعتك
// //       final pdfData = await generatePdfReport(
// //           items,
// //           inventories,
// //           sales,
// //           branchTransfers,
// //           updates,
// //           scrapTransactions,
// //           vouchers,
// //           expenses,
// //           managementDeposits,
// //           managementImported,
// //           start,
// //           end);

// //       // ✅ حدد المسار
// //       Directory? downloadsDir;
// //       if (Platform.isAndroid) {
// //         downloadsDir = Directory("/storage/emulated/0/Download");
// //       } else {
// //         downloadsDir = await getApplicationDocumentsDirectory();
// //       }

// //       final filePath =
// //           "${downloadsDir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf";
// //       final file = File(filePath);

// //       // ✅ هنا بقى نكتب الداتا اللي انت مولدها
// //       await file.writeAsBytes(pdfData);

// //       print("🚀 التقرير اتحفظ هنا: $filePath");

// //       return true; // ✅ النجاح
// //     } catch (e) {
// //       print("❌ خطأ في إنشاء التقرير: $e");
// //       return false; // ❌ فشل
// //     }
// //   }

// //   /// ✅ دالة تعرض نافذة الطباعة مباشرة
// //   static Future<void> printReportTotal(DateTime start, DateTime end) async {
// //     final items = await getItemsByDateRange(start, end);
// //     final updates = await getupdatesByDateRange(start, end);
// //     final inventories = await getInventoriesByDateRange(start, end);
// //     final sales = await getSalesByDateRange(start, end);
// //     final branchTransfers = await getBranchTransfersByDateRange(start, end);
// //     final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
// //     final vouchers = await getvouchersByDateRange(start, end);
// //     final expenses = await getexpensesByDateRange(start, end);
// //     final managementDeposits =
// //         await getmanagementDepositsByDateRange(start, end);
// //     final managementImported =
// //         await getmanagementImportedByDateRange(start, end);

// //     // ✅ ولّد PDF من نفس الدالة بتاعتك
// //     final pdfData = await generatePdfTotal(
// //         items,
// //         inventories,
// //         sales,
// //         branchTransfers,
// //         updates,
// //         scrapTransactions,
// //         vouchers,
// //         expenses,
// //         managementDeposits,
// //         managementImported,
// //         start,
// //         end);

// //     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
// //   }

// //   static Future<Uint8List> generatePdfTotal(
// //       List<Map<String, dynamic>> items,
// //       List<Map<String, dynamic>> inventories,
// //       List<Map<String, dynamic>> sales,
// //       List<Map<String, dynamic>> branchTransfers,
// //       List<Map<String, dynamic>> updates,
// //       List<Map<String, dynamic>> scrapTransactions,
// //       List<Map<String, dynamic>> vouchers,
// //       List<Map<String, dynamic>> expenses,
// //       List<Map<String, dynamic>> managementDeposits,
// //       List<Map<String, dynamic>> managementImported,
// //       DateTime start,
// //       DateTime end) async {
// //     final pdf = pw.Document();

// //     final arabicFont = await PdfGoogleFonts.cairoRegular();
// //     final arabicFontBold = await PdfGoogleFonts.cairoBold();

// //     // ---------------- إجماليات items ----------------
// //     int totalCount = 0;
// //     double totalWeight = 0;
// //     double totalWage = 0;
// //     double totalCost = 0;

// // // ---------------- إجماليات opening balance ----------------
// //     int openingCount = 0;
// //     double openingWeight = 0;
// //     double openingWage = 0;
// //     double openingCost = 0;

// // // ---------------- إجماليات التعديلات ----------------
// //     int updatedCount = 0;
// //     double updatedWeight = 0;
// //     double updatedWage = 0;
// //     double updatedCost = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للعادية)
// //     int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
// //     double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للـ Opening)
// //     int opening18 = 0,
// //         opening21 = 0,
// //         opening22 = 0,
// //         openingBullion = 0,
// //         openingGem = 0;
// //     double openingWeight18 = 0,
// //         openingWeight21 = 0,
// //         openingWeight22 = 0,
// //         openingWeightBullion = 0;

// // // ✅ تفاصيل الكارات لكل نوع (للتعديلات)
// //     int updated18 = 0,
// //         updated21 = 0,
// //         updated22 = 0,
// //         updatedBullion = 0,
// //         updatedGem = 0;
// //     double updatedWeight18 = 0,
// //         updatedWeight21 = 0,
// //         updatedWeight22 = 0,
// //         updatedWeightBullion = 0;

// //     for (var item in items) {
// //       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       final carat = payload['carat']?.toString();
// //       final category = item['category']?.toString();
// //       final fromOpening = item['fromOpeningBalance'] == true;

// //       // ---------------- العادية أو الافتتاحية ----------------
// //       if (fromOpening) {
// //         // 🔹 إجماليات الافتتاحية
// //         openingCount++;
// //         openingWeight += weight;
// //         openingWage += wage;
// //         openingCost += cost;

// //         if (carat == "18") {
// //           opening18++;
// //           openingWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           opening21++;
// //           openingWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           opening22++;
// //           openingWeight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           openingBullion++;
// //           openingWeightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           openingGem++;
// //         }
// //       } else {
// //         // 🔹 إجماليات العادية
// //         totalCount++;
// //         totalWeight += weight;
// //         totalWage += wage;
// //         totalCost += cost;

// //         if (carat == "18") {
// //           count18++;
// //           weight18 += weight;
// //         }
// //         if (carat == "21") {
// //           count21++;
// //           weight21 += weight;
// //         }
// //         if (carat == "22") {
// //           count22++;
// //           weight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           countBullion++;
// //           weightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           countGem++;
// //         }
// //       }
// //     }
// //     // ---------------- التعديلات (مستقلة) ----------------
// //     for (var update in updates) {
// //       final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       final carat = payload['carat']?.toString();
// //       final category = update['category']?.toString();
// //       final updatedAt = update['updatedAt'];

// //       if (updatedAt != null) {
// //         updatedCount++;
// //         updatedWeight += weight;
// //         updatedWage += wage;
// //         updatedCost += cost;

// //         if (carat == "18") {
// //           updated18++;
// //           updatedWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           updated21++;
// //           updatedWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           updated22++;
// //           updatedWeight22 += weight;
// //         }
// //         if (category == "bullion") {
// //           updatedBullion++;
// //           updatedWeightBullion += weight;
// //         }
// //         if (category == "gem") {
// //           updatedGem++;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات inventories ----------------
// //     int invTotalCount = inventories.length;
// //     double invTotalWeight = 0;
// //     double invTotalWage = 0;
// //     double invTotalCost = 0;

// //     int invCount18 = 0,
// //         invCount21 = 0,
// //         invCount22 = 0,
// //         invCountBullion = 0,
// //         invCountGem = 0;

// // // ✅ أوزان كل نوع
// //     double invWeight18 = 0,
// //         invWeight21 = 0,
// //         invWeight22 = 0,
// //         invWeightBullion = 0;

// //     for (var inv in inventories) {
// //       final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       invTotalWeight += weight;
// //       invTotalWage += wage;
// //       invTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = inv['category']?.toString();

// //       if (carat == "18") {
// //         invCount18++;
// //         invWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         invCount21++;
// //         invWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         invCount22++;
// //         invWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         invCountBullion++;
// //         invWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         invCountGem++;
// //       }
// //     }

// //     // 🟡 استخراج الـ itemId من المخزون (inventories)
// //     // 🟡 استخراج الـ EPCs أو IDs من المخزون الحالي
// //     final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();

// // // 🟡 تحديد العناصر المفقودة (اللي مش موجودة في المخزون)
// //     final missingItems = items.where((item) {
// //       final id = item['epcHex'] ?? item['id'];
// //       return !invIds.contains(id);
// //     }).toList();

// //     // ---------------- إجماليات المفقود ----------------
// //     // ---------------- إجماليات المفقود ----------------
// //     int missingCount = 0;
// //     double missingWeight = 0;
// //     double missingWage = 0;
// //     double missingCost = 0;

// //     int missing18 = 0,
// //         missing21 = 0,
// //         missing22 = 0,
// //         missingBullion = 0,
// //         missingGem = 0;
// //     double missingWeight18 = 0,
// //         missingWeight21 = 0,
// //         missingWeight22 = 0,
// //         missingWeightBullion = 0;

// //     for (var item in missingItems) {
// //       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
// //       final carat = payload['carat']?.toString();
// //       final category = item['category']?.toString();

// //       missingCount++;
// //       missingWeight += weight;
// //       missingWage += wage;
// //       missingCost += cost;

// //       if (carat == "18") {
// //         missing18++;
// //         missingWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         missing21++;
// //         missingWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         missing22++;
// //         missingWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         missingBullion++;
// //         missingWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         missingGem++;
// //       }
// //     }

// //     // ---------------- إجماليات المبيعات ----------------
// //     int salesTotalCount = sales.length;
// //     double salesTotalWeight = 0;
// //     double salesTotalWage = 0;
// //     double salesTotalCost = 0;

// //     int salesCount18 = 0,
// //         salesCount21 = 0,
// //         salesCount22 = 0,
// //         salesCountBullion = 0,
// //         salesCountGem = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double salesWeight18 = 0,
// //         salesWeight21 = 0,
// //         salesWeight22 = 0,
// //         salesWeightBullion = 0;

// //     for (var sale in sales) {
// //       final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       // جمع الإجماليات
// //       salesTotalWeight += weight;
// //       salesTotalWage += wage;
// //       salesTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = sale['category']?.toString();

// //       if (carat == "18") {
// //         salesCount18++;
// //         salesWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         salesCount21++;
// //         salesWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         salesCount22++;
// //         salesWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         salesCountBullion++;
// //         salesWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         salesCountGem++;
// //       }
// //     }

// //     // ---------------- إجماليات الفروع ----------------
// //     int branchTransfersTotalCount = branchTransfers.length;
// //     double branchTransfersTotalWeight = 0;
// //     double branchTransfersTotalWage = 0;
// //     double branchTransfersTotalCost = 0;

// //     int branchTransfersCount18 = 0,
// //         branchTransfersCount21 = 0,
// //         branchTransfersCount22 = 0,
// //         branchTransfersCountBullion = 0,
// //         branchTransfersCountGem = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double branchTransfersWeight18 = 0,
// //         branchTransfersWeight21 = 0,
// //         branchTransfersWeight22 = 0,
// //         branchTransfersWeightBullion = 0;

// //     for (var branchTransfer in branchTransfers) {
// //       final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
// //       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
// //       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
// //       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

// //       // جمع الإجماليات
// //       branchTransfersTotalWeight += weight;
// //       branchTransfersTotalWage += wage;
// //       branchTransfersTotalCost += cost;

// //       final carat = payload['carat']?.toString();
// //       final category = branchTransfer['category']?.toString();

// //       if (carat == "18") {
// //         branchTransfersCount18++;
// //         branchTransfersWeight18 += weight;
// //       }
// //       if (carat == "21") {
// //         branchTransfersCount21++;
// //         branchTransfersWeight21 += weight;
// //       }
// //       if (carat == "22") {
// //         branchTransfersCount22++;
// //         branchTransfersWeight22 += weight;
// //       }
// //       if (category == "bullion") {
// //         branchTransfersCountBullion++;
// //         branchTransfersWeightBullion += weight;
// //       }
// //       if (category == "gem") {
// //         branchTransfersCountGem++;
// //       }
// //     }

// //     // ---------------- إجماليات الكسر ----------------
// //     int scrapTransactionsTotalCount = 0;
// //     double scrapTransactionsTotalWeight = 0;
// //     double scrapTransactionsTotalcash = 0;
// //     double scrapTransactionsTotalnetwork = 0;
// //     double scrapTransactionsTotaltotal = 0;

// //     int scrapTransactionsCount18 = 0,
// //         scrapTransactionsCount14 = 0,
// //         scrapTransactionsCount24 = 0,
// //         scrapTransactionsCount21 = 0,
// //         scrapTransactionsCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double scrapTransactionsWeight18 = 0,
// //         scrapTransactionsWeight14 = 0,
// //         scrapTransactionsWeight24 = 0,
// //         scrapTransactionsWeight21 = 0,
// //         scrapTransactionsWeight22 = 0;

// //     for (var scrapTransaction in scrapTransactions) {
// //       final weight =
// //           double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
// //       final cash =
// //           double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;

// //       final carat = scrapTransaction['carat']?.toString();
// //       final type =
// //           scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';

// //       if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
// //         scrapTransactionsTotalCount += 1;
// //         scrapTransactionsTotalWeight += weight;
// //         scrapTransactionsTotalcash += cash;
// //         scrapTransactionsTotalnetwork += network;
// //         scrapTransactionsTotaltotal += total;

// //         if (carat == "14") {
// //           scrapTransactionsCount14++;
// //           scrapTransactionsWeight14 += weight;
// //         }
// //         if (carat == "18") {
// //           scrapTransactionsCount18++;
// //           scrapTransactionsWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           scrapTransactionsCount21++;
// //           scrapTransactionsWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           scrapTransactionsCount22++;
// //           scrapTransactionsWeight22 += weight;
// //         }
// //         if (carat == "24") {
// //           scrapTransactionsCount24++;
// //           scrapTransactionsWeight24 += weight;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات السندات ----------------
// //     int vouchersTotalCount = 0;
// //     int voucherspaymentCount = 0;
// //     int vouchersreceiptCount = 0;
// //     double vouchersTotalWeight = 0;
// //     double vouchersTotalcash = 0;
// //     double vouchersTotalnetwork = 0;
// //     double vouchersTotaltotal = 0;

// //     int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;

// //     for (var voucher in vouchers) {
// //       final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
// //       final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
// //       final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;

// //       final carat = voucher['carat']?.toString();
// //       final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
// //       vouchersTotalCount += 1;

// //       if (type.isNotEmpty && type == 'payment') {
// //         voucherspaymentCount += 1;
// //         vouchersTotalWeight += weight;
// //         vouchersTotalcash += cash;
// //         vouchersTotalnetwork += network;
// //         vouchersTotaltotal += total;

// //         if (carat == "18") {
// //           vouchersCount18++;
// //           vouchersWeight18 += weight;
// //         }
// //         if (carat == "21") {
// //           vouchersCount21++;
// //           vouchersWeight21 += weight;
// //         }
// //         if (carat == "22") {
// //           vouchersCount22++;
// //           vouchersWeight22 += weight;
// //         }
// //       } else if (type.isNotEmpty && type == 'receipt') {
// //         vouchersreceiptCount += 1;
// //         vouchersTotalWeight -= weight;
// //         vouchersTotalcash -= cash;
// //         vouchersTotalnetwork -= network;
// //         vouchersTotaltotal -= total;

// //         if (carat == "18") {
// //           vouchersCount18++;
// //           vouchersWeight18 -= weight;
// //         }
// //         if (carat == "21") {
// //           vouchersCount21++;
// //           vouchersWeight21 -= weight;
// //         }
// //         if (carat == "22") {
// //           vouchersCount22++;
// //           vouchersWeight22 -= weight;
// //         }
// //       }
// //     }

// //     // ---------------- إجماليات المصروفات ----------------
// //     int expensesTotalCount = 0;
// //     double expensesTotal = 0;

// //     //int scrapTransactionsCount18 = 0, scrapTransactionsCount21 = 0, scrapTransactionsCount22 = 0;

// // // ✅ أوزان كل نوع في المبيعات
// //     //double scrapTransactionsWeight18 = 0, scrapTransactionsWeight21 = 0, scrapTransactionsWeight22 = 0;

// //     for (var expense in expenses) {
// //       final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
// //       expensesTotal += amount;
// //       expensesTotalCount += 1;
// //     }

// //     // ---------------- إجماليات توريدات الادارة  ----------------
// //     int managementDepositsTotalCount = 0;
// //     double managementDepositsTotalcash = 0;
// //     double managementDepositsTotalnetwork = 0;
// //     double managementDepositsTotaltotal = 0;

// //     for (var managementDeposit in managementDeposits) {
// //       final cash =
// //           double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
// //       managementDepositsTotalCount += 1;
// //       managementDepositsTotalcash += cash;
// //       managementDepositsTotalnetwork += network;
// //       managementDepositsTotaltotal += total;
// //     }

// //     // ---------------- إجماليات الاستيرادات من الادارة  ----------------
// //     int managementImportedTotalCount = 0;
// //     double managementImportedTotalcash = 0;
// //     double managementImportedTotalnetwork = 0;
// //     double managementImportedTotaltotal = 0;

// //     for (var managementImport in managementImported) {
// //       final cash =
// //           double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
// //       final network =
// //           double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
// //       final total =
// //           double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
// //       managementImportedTotalCount += 1;
// //       managementImportedTotalcash += cash;
// //       managementImportedTotalnetwork += network;
// //       managementImportedTotaltotal += total;
// //     }

// //     // ---------------- إجماليات البائعين ----------------
// //     final Map<String, Map<String, double>> sellersTotals = {};

// //     for (var sale in sales) {
// //       final payment = sale['payment'] as Map<String, dynamic>? ?? {};

// //       final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';

// //       final total = (payment['total'] ?? 0).toDouble();
// //       final cash = (payment['cash'] ?? 0).toDouble();
// //       final visa = (payment['visa'] ?? 0).toDouble();

// //       sellersTotals.putIfAbsent(
// //           soldBy,
// //           () => {
// //                 'total': 0,
// //                 'cash': 0,
// //                 'visa': 0,
// //               });

// //       sellersTotals[soldBy]!['total'] =
// //           sellersTotals[soldBy]!['total']! + total;
// //       sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
// //       sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
// //     }

// //     // ---------------- PDF ----------------
// //     // صفحة العنوان والفترة
// //     final image = pw.MemoryImage(
// //       (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
// //     );

// //     pdf.addPage(
// //       pw.Page(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) {
// //           final pageWidth = PdfPageFormat.a4.width;
// //           final pageHeight = PdfPageFormat.a4.height;

// //           return pw.Stack(
// //             children: [
// //               // برواز ذهبي
// //               pw.Container(
// //                 width: pageWidth,
// //                 height: pageHeight,
// //                 decoration: pw.BoxDecoration(
// //                   color: PdfColors.white,
// //                   border: pw.Border.all(color: PdfColors.amber600, width: 3),
// //                 ),
// //               ),

// //               // المحتوى
// //               pw.Padding(
// //                 padding: const pw.EdgeInsets.all(40),
// //                 child: pw.Column(
// //                   mainAxisAlignment: pw.MainAxisAlignment.start,
// //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
// //                   children: [
// //                     // ✅ أيقونة ذهبية من صورة
// //                     pw.Image(image, width: 60, height: 60),

// //                     pw.SizedBox(height: 10),

// //                     // العنوان في النص
// //                     pw.Text(
// //                       "تقارير الاجماليات",
// //                       style: pw.TextStyle(
// //                         fontSize: 26,
// //                         fontWeight: pw.FontWeight.bold,
// //                         color: PdfColors.black,
// //                       ),
// //                       textAlign: pw.TextAlign.center,
// //                     ),

// //                     pw.SizedBox(height: 6),

// //                     // خط ذهبي تحت العنوان
// //                     pw.Container(
// //                       height: 2,
// //                       width: pageWidth * 0.4,
// //                       color: PdfColors.amber600,
// //                     ),

// //                     pw.SizedBox(height: 20),

// //                     // الفترة
// //                     pw.Text(
// //                       "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
// //                       "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
// //                       style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
// //                       textAlign: pw.TextAlign.center,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات الرصيد الافتتاحي",
// //               style:
// //                   pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
// //           _buildtotals(
// //             openingCount,
// //             opening18,
// //             opening21,
// //             opening22,
// //             openingBullion,
// //             openingGem,
// //             openingWeight,
// //             openingWage,
// //             openingCost,
// //             openingWeight18,
// //             openingWeight21,
// //             openingWeight22,
// //             openingWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات الإدخال",
// //               style:
// //                   pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
// //           _buildtotals(
// //             totalCount,
// //             count18,
// //             count21,
// //             count22,
// //             countBullion,
// //             countGem,
// //             totalWeight,
// //             totalWage,
// //             totalCost,
// //             weight18,
// //             weight21,
// //             weight22,
// //             weightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // ✅ صفحة المفقودين
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات المفقود",
// //               style:
// //                   pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
// //           _buildtotals(
// //             missingCount,
// //             missing18,
// //             missing21,
// //             missing22,
// //             missingBullion,
// //             missingGem,
// //             missingWeight,
// //             missingWage,
// //             missingCost,
// //             missingWeight18,
// //             missingWeight21,
// //             missingWeight22,
// //             missingWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // صفحة جدول الجرد
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الجرد",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildtotals(
// //             invTotalCount,
// //             invCount18,
// //             invCount21,
// //             invCount22,
// //             invCountBullion,
// //             invCountGem,
// //             invTotalWeight,
// //             invTotalWage,
// //             invTotalCost,
// //             invWeight18,
// //             invWeight21,
// //             invWeight22,
// //             invWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     // ✅ صفحة جدول التعديلات
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text("إجماليات التعديلات",
// //               style:
// //                   pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
// //           _buildtotals(
// //             updatedCount,
// //             updated18,
// //             updated21,
// //             updated22,
// //             updatedBullion,
// //             updatedGem,
// //             updatedWeight,
// //             updatedWage,
// //             updatedCost,
// //             updatedWeight18,
// //             updatedWeight21,
// //             updatedWeight22,
// //             updatedWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// // // صفحة جدول المبيعات
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات المبيعات",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildtotals(
// //             salesTotalCount,
// //             salesCount18,
// //             salesCount21,
// //             salesCount22,
// //             salesCountBullion,
// //             salesCountGem,
// //             salesTotalWeight,
// //             salesTotalWage,
// //             salesTotalCost,
// //             salesWeight18,
// //             salesWeight21,
// //             salesWeight22,
// //             salesWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(
// //           base: arabicFont,
// //           bold: arabicFontBold,
// //         ),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات البائعين",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.SizedBox(height: 10),
// //           pw.Table(
// //             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //             columnWidths: const {
// //               0: pw.FlexColumnWidth(3),
// //               1: pw.FlexColumnWidth(2),
// //               2: pw.FlexColumnWidth(2),
// //               3: pw.FlexColumnWidth(2),
// //             },
// //             children: [
// //               // 🔹 الهيدر
// //               pw.TableRow(
// //                 decoration: const pw.BoxDecoration(color: PdfColors.grey200),
// //                 children: [
// //                   _cell("البائع", bold: true),
// //                   _cell("الإجمالي", bold: true),
// //                   _cell("كاش", bold: true),
// //                   _cell("شبكة", bold: true),
// //                 ],
// //               ),

// //               // 🔹 البيانات
// //               ...sellersTotals.entries.map((e) {
// //                 return pw.TableRow(
// //                   children: [
// //                     _cell(e.key),
// //                     _cell(e.value['total']!.toStringAsFixed(2)),
// //                     _cell(e.value['cash']!.toStringAsFixed(2)),
// //                     _cell(e.value['visa']!.toStringAsFixed(2)),
// //                   ],
// //                 );
// //               }),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات التحويلات",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           _buildtotals(
// //             branchTransfersTotalCount,
// //             branchTransfersCount18,
// //             branchTransfersCount21,
// //             branchTransfersCount22,
// //             branchTransfersCountBullion,
// //             branchTransfersCountGem,
// //             branchTransfersTotalWeight,
// //             branchTransfersTotalWage,
// //             branchTransfersTotalCost,
// //             branchTransfersWeight18,
// //             branchTransfersWeight21,
// //             branchTransfersWeight22,
// //             branchTransfersWeightBullion,
// //           ),
// //         ],
// //       ),
// //     );

// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الكسر",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 14 : $scrapTransactionsCount14             ( وزن:   ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 18 : $scrapTransactionsCount18             ( وزن:   ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 21 : $scrapTransactionsCount21              ( وزن:  ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 22 : $scrapTransactionsCount22              ( وزن:  ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد شرائح عيار 24 : $scrapTransactionsCount24             ( وزن: ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات السندات",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد السندات: $vouchersTotalCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 18 : $vouchersCount18             ( وزن:   ${vouchersWeight18.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 21 : $vouchersCount21              ( وزن:  ${vouchersWeight21.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "عدد سندات عيار 22 : $vouchersCount22              ( وزن:  ${vouchersWeight22.toStringAsFixed(2)} )",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجمالي المصروفات",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد المصروفات: $expensesTotalCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text: "إجمالي قيمة المصروفات: $expensesTotal",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات التوريد للادارة ",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //     pdf.addPage(
// //       pw.MultiPage(
// //         pageFormat: PdfPageFormat.a4,
// //         textDirection: pw.TextDirection.rtl,
// //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
// //         build: (context) => [
// //           pw.SizedBox(height: 10),
// //           pw.Text(
// //             "إجماليات الاستيرادات من الادارة ",
// //             style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //           ),
// //           pw.Align(
// //             alignment: pw.Alignment.centerRight,
// //             child: pw.Column(
// //               crossAxisAlignment: pw.CrossAxisAlignment.end,
// //               children: [
// //                 pw.Bullet(
// //                   text: "إجمالي عدد الاستيردات: $managementImportedTotalCount",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //                 pw.Bullet(
// //                   text:
// //                       "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
// //                   style: pw.TextStyle(fontSize: 20),
// //                   textAlign: pw.TextAlign.right,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );

// //     // 🧾 صفحة عمليات الصندوق
// //     try {
// //       double sum = 0.0;
// //       double cash = 0.0;
// //       double visa = 0.0;
// //       //List<Map<String, dynamic>> all = [];

// //       // 🟢 بيع القطع
// //       final salesSnap = await FS.salesCol().get();
// //       for (var d in salesSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['payment']?['total'] ?? 0).toDouble();
// //         final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
// //         final date = (data['createdAt'] as Timestamp?)?.toDate();

// //         sum += wage;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       // 🟢 بيع كسر
// //       final scrapSnap =
// //           await FS.scrapCol().where("type", isEqualTo: "sale").get();
// //       for (var d in scrapSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum += wage;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       // 🔴 شراء كسر
// //       final scrapBuySnap =
// //           await FS.scrapCol().where("type", isEqualTo: "add").get();
// //       for (var d in scrapBuySnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= wage;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }

// //       // 🔴 سندات الصرف
// //       final vouchersSnap =
// //           await FS.vouchersCol().where("type", isEqualTo: "payment").get();
// //       for (var d in vouchersSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final wage = (data['total'] ?? 0).toDouble();
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['network'] ?? 0).toDouble();
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= wage;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }

// //       // 🔴 المصروفات
// //       final expSnap = await FS.expensesCol().get();
// //       for (var d in expSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         //final displayType = _t('مصروف', 'Expense');

// //         sum -= amount;
// //         cash -= amount;
// //       }

// //       // 🔵 توريد للإدارة
// //       final depositSnap = await FS.depositsCol().get();
// //       for (var d in depositSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['visa'] ?? 0).toDouble();
// //         final totalValue = totalcash + totalvisa;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum -= totalValue;
// //         cash -= totalcash;
// //         visa -= totalvisa;
// //       }
// //       // 🔵 استيراد من الإدارة
// //       final ImportSnap = await FS.ImportedCol().get();
// //       for (var d in ImportSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final totalcash = (data['cash'] ?? 0).toDouble();
// //         final totalvisa = (data['visa'] ?? 0).toDouble();
// //         final totalValue = totalcash + totalvisa;
// //         final date = (data['date'] as Timestamp?)?.toDate();

// //         sum += totalValue;
// //         cash += totalcash;
// //         visa += totalvisa;
// //       }

// //       //print("✅ تم حساب البيانات بنجاح. عدد الصفوف: ${cashBoxRows.length}");
// //       print("الإجمالي الكاش: $cash - الشبكة: $visa - الكلي: $sum");

// //       // صفحة الـ PDF
// //       // 🧾 صفحة عمليات الصندوق
// //       pdf.addPage(
// //         pw.MultiPage(
// //           pageFormat: PdfPageFormat.a4,
// //           textDirection: pw.TextDirection.rtl,
// //           theme: pw.ThemeData.withFont(
// //             base: arabicFont,
// //             bold: arabicFontBold,
// //           ),
// //           build: (context) => [
// //             pw.SizedBox(height: 15),

// //             // 🧮 إجماليات الصندوق
// //             pw.Text(
// //               "إجماليات الصندوق",
// //               style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
// //             ),
// //             pw.SizedBox(height: 8),

// //             pw.Table(
// //               border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
// //               columnWidths: const {
// //                 0: pw.FlexColumnWidth(3),
// //                 1: pw.FlexColumnWidth(2),
// //               },
// //               children: [
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("إجمالي الكاش",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         cash.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("إجمالي الشبكة",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         visa.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 pw.TableRow(
// //                   children: [
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text("الإجمالي الكلي",
// //                           style: pw.TextStyle(
// //                               fontSize: 20, fontWeight: pw.FontWeight.bold)),
// //                     ),
// //                     pw.Padding(
// //                       padding: const pw.EdgeInsets.all(4),
// //                       child: pw.Text(
// //                         sum.toStringAsFixed(2),
// //                         style: pw.TextStyle(fontSize: 20),
// //                         textAlign: pw.TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       );
// //     } catch (e, st) {
// //       print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
// //       print(st);
// //     }

// //     return pdf.save();
// //   }

// //   /// ✅ ترجمة الفئات
// //   static String translateCategory(String? category) {
// //     switch (category) {
// //       case 'bullion':
// //         return "سبائك";
// //       case 'gem':
// //         return "أحجار كريمة";
// //       case 'gold':
// //         return "ذهب";
// //       default:
// //         return "غير محدد";
// //     }
// //   }

// //   /// ✅ بناء جزء الإجماليات
// //   static pw.Widget _buildTotals(
// //     int totalCount,
// //     int count18,
// //     int count21,
// //     int count22,
// //     int countBullion,
// //     int countGem,
// //     double totalWeight,
// //     double totalWage,
// //     double totalCost,
// //     double weight18,
// //     double weight21,
// //     double weight22,
// //     double weightBullion,
// //   ) {
// //     return pw.Align(
// //       alignment: pw.Alignment.centerRight,
// //       child: pw.Column(
// //         crossAxisAlignment: pw.CrossAxisAlignment.end,
// //         children: [
// //           pw.Bullet(
// //             text: "إجمالي عدد الشرائح: $totalCount",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "عدد الأحجار الكريمة : $countGem",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 8),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   /// ✅ بناء جزء الإجماليات
// //   static pw.Widget _buildtotals(
// //     int totalCount,
// //     int count18,
// //     int count21,
// //     int count22,
// //     int countBullion,
// //     int countGem,
// //     double totalWeight,
// //     double totalWage,
// //     double totalCost,
// //     double weight18,
// //     double weight21,
// //     double weight22,
// //     double weightBullion,
// //   ) {
// //     return pw.Align(
// //       alignment: pw.Alignment.centerRight,
// //       child: pw.Column(
// //         crossAxisAlignment: pw.CrossAxisAlignment.end,
// //         children: [
// //           pw.Bullet(
// //             text: "إجمالي عدد الشرائح: $totalCount",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text:
// //                 "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "عدد الأحجار الكريمة : $countGem",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //           pw.Bullet(
// //             text: "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
// //             style: pw.TextStyle(fontSize: 20),
// //             textAlign: pw.TextAlign.right,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // pw.Widget _cell(String text, {bool bold = false}) {
// //   return pw.Padding(
// //     padding: const pw.EdgeInsets.all(6),
// //     child: pw.Text(
// //       text,
// //       style: pw.TextStyle(
// //         fontSize: 18,
// //         fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
// //       ),
// //       textAlign: pw.TextAlign.center,
// //     ),
// //   );
// // }
// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import '../services/firestore_service.dart';

// // ============================================================
// // ReportSection enum + label
// // ============================================================
// enum ReportSection {
//   openingBalance,
//   entry,
//   missing,
//   inventory,
//   updates,
//   sales,
//   sellersTotals,
//   transfers,
//   scrap,
//   vouchers,
//   expenses,
//   deposits,
//   imports,
//   safeTotals,  generalBalance,   // ⬅️ ضيف

// }

// extension ReportSectionLabel on ReportSection {
//   String getLabel(String lang) {
//     const ar = {
//       ReportSection.openingBalance: 'الرصيد الافتتاحي',
//       ReportSection.entry: 'الإدخال',
//       ReportSection.missing: 'المفقود',
//       ReportSection.inventory: 'الجرد',
//       ReportSection.updates: 'التعديلات',
//       ReportSection.sales: 'المبيعات',
//       ReportSection.sellersTotals: 'إجماليات البائعين',
//       ReportSection.transfers: 'التحويلات',
//       ReportSection.scrap: 'الكسر',
//       ReportSection.vouchers: 'السندات',
//       ReportSection.expenses: 'المصروفات',
//       ReportSection.deposits: 'توريد للإدارة',
//       ReportSection.imports: 'استيراد من الإدارة',
//       ReportSection.safeTotals: 'إجماليات الصندوق',
//     };
//     const en = {
//       ReportSection.openingBalance: 'Opening Balance',
//       ReportSection.entry: 'Entry',
//       ReportSection.missing: 'Missing',
//       ReportSection.inventory: 'Inventory',
//       ReportSection.updates: 'Updates',
//       ReportSection.sales: 'Sales',
//       ReportSection.sellersTotals: 'Sellers Totals',
//       ReportSection.transfers: 'Transfers',
//       ReportSection.scrap: 'Scrap',
//       ReportSection.vouchers: 'Vouchers',
//       ReportSection.expenses: 'Expenses',
//       ReportSection.deposits: 'Deposits to Admin',
//       ReportSection.imports: 'Imports from Admin',
//       ReportSection.safeTotals: 'Safe Totals',
//     };
//     return lang == 'ar' ? ar[this]! : en[this]!;
//   }
// }

// class PdfReport {
//   // ============================================================
//   // Helpers
//   // ============================================================
//   static String translateCategory(String? category) {
//     switch (category) {
//       case 'bullion':
//         return "سبائك";
//       case 'gem':
//         return "أحجار";
//       case 'gold':
//         return "ذهب";
//       default:
//         return "غير محدد";
//     }
//   }

//   static pw.Widget _cell(String text, {bool bold = false}) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.all(4),
//       child: pw.Text(
//         text,
//         textAlign: pw.TextAlign.center,
//         style: pw.TextStyle(
//           fontSize: 10,
//           fontWeight: bold ? pw.FontWeight.bold : null,
//         ),
//       ),
//     );
//   }

//   static pw.Widget _buildTotals(
//     int count,
//     int count18,
//     int count21,
//     int count22,
//     int countBullion,
//     int countGem,
//     double weight,
//     double wage,
//     double cost,
//     double weight18,
//     double weight21,
//     double weight22,
//     double weightBullion,
//   ) {
//     return pw.Align(
//       alignment: pw.Alignment.centerRight,
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.end,
//         children: [
//           pw.Bullet(
//             text: "إجمالي عدد الشرائح: $count",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text:
//                 "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text:
//                 "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text:
//                 "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text:
//                 "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text: "عدد الأحجار الكريمة : $countGem",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text: "إجمالي الوزن الكلي : ${weight.toStringAsFixed(2)}",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text: "إجمالي الأجر الكلي : ${wage.toStringAsFixed(2)}",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//           pw.Bullet(
//             text: "إجمالي التكلفة الكلية : ${cost.toStringAsFixed(2)}",
//             style: pw.TextStyle(fontSize: 8),
//             textAlign: pw.TextAlign.right,
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // Firestore getters
//   // ============================================================
//   static Future<List<Map<String, dynamic>>> getItemsByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('items')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getupdatesByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('items')
//         .where('updatedAt', isGreaterThanOrEqualTo: start)
//         .where('updatedAt', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getInventoriesByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('inventories')
//         .where('lastSeenAt', isGreaterThanOrEqualTo: start)
//         .where('lastSeenAt', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getSalesByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('sales')
//         .where('soldAt', isGreaterThanOrEqualTo: start)
//         .where('soldAt', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getBranchTransfersByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('branchTransfers')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('scrapTransactions')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getvouchersByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('vouchers')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getexpensesByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('expenses')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getmanagementDepositsByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('managementDeposits')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   static Future<List<Map<String, dynamic>>> getmanagementImportedByDateRange(
//       DateTime start, DateTime end) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('managementImported')
//         .where('date', isGreaterThanOrEqualTo: start)
//         .where('date', isLessThanOrEqualTo: end)
//         .get();
//     return q.docs.map((d) {
//       final data = d.data();
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   // ============================================================
//   // generatePdfReport — كامل مع filters
//   // ============================================================
//   static Future<Uint8List> generatePdfReport(
//       List<Map<String, dynamic>> items,
//       List<Map<String, dynamic>> inventories,
//       List<Map<String, dynamic>> sales,
//       List<Map<String, dynamic>> branchTransfers,
//       List<Map<String, dynamic>> updates,
//       List<Map<String, dynamic>> scrapTransactions,
//       List<Map<String, dynamic>> vouchers,
//       List<Map<String, dynamic>> expenses,
//       List<Map<String, dynamic>> managementDeposits,
//       List<Map<String, dynamic>> managementImported,
//       DateTime start,
//       DateTime end,
//       {Set<ReportSection>? sections}) async {
//     final allowed = sections ?? ReportSection.values.toSet();
//     final pdf = pw.Document();
//     final arabicFont = await PdfGoogleFonts.cairoRegular();
//     final arabicFontBold = await PdfGoogleFonts.cairoBold();

//     // ============ إجماليات ============
//     int totalCount = 0;
//     double totalWeight = 0;
//     double totalWage = 0;
//     double totalCost = 0;
//     int openingCount = 0;
//     double openingWeight = 0;
//     double openingWage = 0;
//     double openingCost = 0;
//     int updatedCount = 0;
//     double updatedWeight = 0;
//     double updatedWage = 0;
//     double updatedCost = 0;
//     int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
//     double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;
//     int opening18 = 0,
//         opening21 = 0,
//         opening22 = 0,
//         openingBullion = 0,
//         openingGem = 0;
//     double openingWeight18 = 0,
//         openingWeight21 = 0,
//         openingWeight22 = 0,
//         openingWeightBullion = 0;
//     int updated18 = 0,
//         updated21 = 0,
//         updated22 = 0,
//         updatedBullion = 0,
//         updatedGem = 0;
//     double updatedWeight18 = 0,
//         updatedWeight21 = 0,
//         updatedWeight22 = 0,
//         updatedWeightBullion = 0;

//     for (var item in items) {
//       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = item['category']?.toString();
//       final fromOpening = item['fromOpeningBalance'] == true;
//       if (fromOpening) {
//         openingCount++;
//         openingWeight += weight;
//         openingWage += wage;
//         openingCost += cost;
//         if (carat == "18") {
//           opening18++;
//           openingWeight18 += weight;
//         }
//         if (carat == "21") {
//           opening21++;
//           openingWeight21 += weight;
//         }
//         if (carat == "22") {
//           opening22++;
//           openingWeight22 += weight;
//         }
//         if (category == "bullion") {
//           openingBullion++;
//           openingWeightBullion += weight;
//         }
//         if (category == "gem") {
//           openingGem++;
//         }
//       } else {
//         totalCount++;
//         totalWeight += weight;
//         totalWage += wage;
//         totalCost += cost;
//         if (carat == "18") {
//           count18++;
//           weight18 += weight;
//         }
//         if (carat == "21") {
//           count21++;
//           weight21 += weight;
//         }
//         if (carat == "22") {
//           count22++;
//           weight22 += weight;
//         }
//         if (category == "bullion") {
//           countBullion++;
//           weightBullion += weight;
//         }
//         if (category == "gem") {
//           countGem++;
//         }
//       }
//     }

//     for (var update in updates) {
//       final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = update['category']?.toString();
//       final updatedAt = update['updatedAt'];
//       if (updatedAt != null) {
//         updatedCount++;
//         updatedWeight += weight;
//         updatedWage += wage;
//         updatedCost += cost;
//         if (carat == "18") {
//           updated18++;
//           updatedWeight18 += weight;
//         }
//         if (carat == "21") {
//           updated21++;
//           updatedWeight21 += weight;
//         }
//         if (carat == "22") {
//           updated22++;
//           updatedWeight22 += weight;
//         }
//         if (category == "bullion") {
//           updatedBullion++;
//           updatedWeightBullion += weight;
//         }
//         if (category == "gem") {
//           updatedGem++;
//         }
//       }
//     }

//     int invTotalCount = inventories.length;
//     double invTotalWeight = 0, invTotalWage = 0, invTotalCost = 0;
//     int invCount18 = 0,
//         invCount21 = 0,
//         invCount22 = 0,
//         invCountBullion = 0,
//         invCountGem = 0;
//     double invWeight18 = 0,
//         invWeight21 = 0,
//         invWeight22 = 0,
//         invWeightBullion = 0;
//     for (var inv in inventories) {
//       final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       invTotalWeight += weight;
//       invTotalWage += wage;
//       invTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = inv['category']?.toString();
//       if (carat == "18") {
//         invCount18++;
//         invWeight18 += weight;
//       }
//       if (carat == "21") {
//         invCount21++;
//         invWeight21 += weight;
//       }
//       if (carat == "22") {
//         invCount22++;
//         invWeight22 += weight;
//       }
//       if (category == "bullion") {
//         invCountBullion++;
//         invWeightBullion += weight;
//       }
//       if (category == "gem") {
//         invCountGem++;
//       }
//     }

//     final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();
//     final missingItems = items.where((item) {
//       final id = item['epcHex'] ?? item['id'];
//       return !invIds.contains(id);
//     }).toList();

//     int missingCount = 0;
//     double missingWeight = 0, missingWage = 0, missingCost = 0;
//     int missing18 = 0,
//         missing21 = 0,
//         missing22 = 0,
//         missingBullion = 0,
//         missingGem = 0;
//     double missingWeight18 = 0,
//         missingWeight21 = 0,
//         missingWeight22 = 0,
//         missingWeightBullion = 0;
//     for (var item in missingItems) {
//       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = item['category']?.toString();
//       missingCount++;
//       missingWeight += weight;
//       missingWage += wage;
//       missingCost += cost;
//       if (carat == "18") {
//         missing18++;
//         missingWeight18 += weight;
//       }
//       if (carat == "21") {
//         missing21++;
//         missingWeight21 += weight;
//       }
//       if (carat == "22") {
//         missing22++;
//         missingWeight22 += weight;
//       }
//       if (category == "bullion") {
//         missingBullion++;
//         missingWeightBullion += weight;
//       }
//       if (category == "gem") {
//         missingGem++;
//       }
//     }

//     int salesTotalCount = sales.length;
//     double salesTotalWeight = 0, salesTotalWage = 0, salesTotalCost = 0;
//     int salesCount18 = 0,
//         salesCount21 = 0,
//         salesCount22 = 0,
//         salesCountBullion = 0,
//         salesCountGem = 0;
//     double salesWeight18 = 0,
//         salesWeight21 = 0,
//         salesWeight22 = 0,
//         salesWeightBullion = 0;
//     for (var sale in sales) {
//       final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       salesTotalWeight += weight;
//       salesTotalWage += wage;
//       salesTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = sale['category']?.toString();
//       if (carat == "18") {
//         salesCount18++;
//         salesWeight18 += weight;
//       }
//       if (carat == "21") {
//         salesCount21++;
//         salesWeight21 += weight;
//       }
//       if (carat == "22") {
//         salesCount22++;
//         salesWeight22 += weight;
//       }
//       if (category == "bullion") {
//         salesCountBullion++;
//         salesWeightBullion += weight;
//       }
//       if (category == "gem") {
//         salesCountGem++;
//       }
//     }

//     int branchTransfersTotalCount = branchTransfers.length;
//     double branchTransfersTotalWeight = 0,
//         branchTransfersTotalWage = 0,
//         branchTransfersTotalCost = 0;
//     int branchTransfersCount18 = 0,
//         branchTransfersCount21 = 0,
//         branchTransfersCount22 = 0,
//         branchTransfersCountBullion = 0,
//         branchTransfersCountGem = 0;
//     double branchTransfersWeight18 = 0,
//         branchTransfersWeight21 = 0,
//         branchTransfersWeight22 = 0,
//         branchTransfersWeightBullion = 0;
//     for (var branchTransfer in branchTransfers) {
//       final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       branchTransfersTotalWeight += weight;
//       branchTransfersTotalWage += wage;
//       branchTransfersTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = branchTransfer['category']?.toString();
//       if (carat == "18") {
//         branchTransfersCount18++;
//         branchTransfersWeight18 += weight;
//       }
//       if (carat == "21") {
//         branchTransfersCount21++;
//         branchTransfersWeight21 += weight;
//       }
//       if (carat == "22") {
//         branchTransfersCount22++;
//         branchTransfersWeight22 += weight;
//       }
//       if (category == "bullion") {
//         branchTransfersCountBullion++;
//         branchTransfersWeightBullion += weight;
//       }
//       if (category == "gem") {
//         branchTransfersCountGem++;
//       }
//     }

//     int scrapTransactionsTotalCount = 0;
//     double scrapTransactionsTotalWeight = 0,
//         scrapTransactionsTotalcash = 0,
//         scrapTransactionsTotalnetwork = 0,
//         scrapTransactionsTotaltotal = 0;
//     int scrapTransactionsCount18 = 0,
//         scrapTransactionsCount14 = 0,
//         scrapTransactionsCount24 = 0,
//         scrapTransactionsCount21 = 0,
//         scrapTransactionsCount22 = 0;
//     double scrapTransactionsWeight18 = 0,
//         scrapTransactionsWeight14 = 0,
//         scrapTransactionsWeight24 = 0,
//         scrapTransactionsWeight21 = 0,
//         scrapTransactionsWeight22 = 0;
//     for (var scrapTransaction in scrapTransactions) {
//       final weight =
//           double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
//       final cash =
//           double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
//       final network =
//           double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
//       final total =
//           double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;
//       final carat = scrapTransaction['carat']?.toString();
//       final type =
//           scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';
//       if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
//         scrapTransactionsTotalCount += 1;
//         scrapTransactionsTotalWeight += weight;
//         scrapTransactionsTotalcash += cash;
//         scrapTransactionsTotalnetwork += network;
//         scrapTransactionsTotaltotal += total;
//         if (carat == "14") {
//           scrapTransactionsCount14++;
//           scrapTransactionsWeight14 += weight;
//         }
//         if (carat == "18") {
//           scrapTransactionsCount18++;
//           scrapTransactionsWeight18 += weight;
//         }
//         if (carat == "21") {
//           scrapTransactionsCount21++;
//           scrapTransactionsWeight21 += weight;
//         }
//         if (carat == "22") {
//           scrapTransactionsCount22++;
//           scrapTransactionsWeight22 += weight;
//         }
//         if (carat == "24") {
//           scrapTransactionsCount24++;
//           scrapTransactionsWeight24 += weight;
//         }
//       }
//     }

//     int vouchersTotalCount = 0,
//         voucherspaymentCount = 0,
//         vouchersreceiptCount = 0;
//     double vouchersTotalWeight = 0,
//         vouchersTotalcash = 0,
//         vouchersTotalnetwork = 0,
//         vouchersTotaltotal = 0;
//     int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;
//     double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;
//     for (var voucher in vouchers) {
//       final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
//       final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
//       final network =
//           double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
//       final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;
//       final carat = voucher['carat']?.toString();
//       final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
//       vouchersTotalCount += 1;
//       if (type.isNotEmpty && type == 'payment') {
//         voucherspaymentCount += 1;
//         vouchersTotalWeight += weight;
//         vouchersTotalcash += cash;
//         vouchersTotalnetwork += network;
//         vouchersTotaltotal += total;
//         if (carat == "18") {
//           vouchersCount18++;
//           vouchersWeight18 += weight;
//         }
//         if (carat == "21") {
//           vouchersCount21++;
//           vouchersWeight21 += weight;
//         }
//         if (carat == "22") {
//           vouchersCount22++;
//           vouchersWeight22 += weight;
//         }
//       } else if (type.isNotEmpty && type == 'receipt') {
//         vouchersreceiptCount += 1;
//         vouchersTotalWeight -= weight;
//         vouchersTotalcash -= cash;
//         vouchersTotalnetwork -= network;
//         vouchersTotaltotal -= total;
//         if (carat == "18") {
//           vouchersCount18++;
//           vouchersWeight18 -= weight;
//         }
//         if (carat == "21") {
//           vouchersCount21++;
//           vouchersWeight21 -= weight;
//         }
//         if (carat == "22") {
//           vouchersCount22++;
//           vouchersWeight22 -= weight;
//         }
//       }
//     }

//     int expensesTotalCount = 0;
//     double expensesTotal = 0;
//     for (var expense in expenses) {
//       final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
//       expensesTotal += amount;
//       expensesTotalCount += 1;
//     }

//     int managementDepositsTotalCount = 0;
//     double managementDepositsTotalcash = 0,
//         managementDepositsTotalnetwork = 0,
//         managementDepositsTotaltotal = 0;
//     for (var managementDeposit in managementDeposits) {
//       managementDepositsTotalCount += 1;
//       managementDepositsTotalcash +=
//           double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
//       managementDepositsTotalnetwork +=
//           double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
//       managementDepositsTotaltotal +=
//           double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
//     }

//     int managementImportedTotalCount = 0;
//     double managementImportedTotalcash = 0,
//         managementImportedTotalnetwork = 0,
//         managementImportedTotaltotal = 0;
//     for (var managementImport in managementImported) {
//       managementImportedTotalCount += 1;
//       managementImportedTotalcash +=
//           double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
//       managementImportedTotalnetwork +=
//           double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
//       managementImportedTotaltotal +=
//           double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
//     }

//     final Map<String, Map<String, double>> sellersTotals = {};
//     for (var sale in sales) {
//       final payment = sale['payment'] as Map<String, dynamic>? ?? {};
//       final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';
//       final total = (payment['total'] ?? 0).toDouble();
//       final cash = (payment['cash'] ?? 0).toDouble();
//       final visa = (payment['visa'] ?? 0).toDouble();
//       sellersTotals.putIfAbsent(
//           soldBy, () => {'total': 0, 'cash': 0, 'visa': 0});
//       sellersTotals[soldBy]!['total'] =
//           sellersTotals[soldBy]!['total']! + total;
//       sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
//       sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
//     }

//     // ============================================================
//     // PDF PAGES
//     // ============================================================
//     final image = pw.MemoryImage(
//       (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
//     );

//     // ---------- Cover (always) ----------
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) {
//           final pageWidth = PdfPageFormat.a4.width;
//           final pageHeight = PdfPageFormat.a4.height;
//           return pw.Stack(
//             children: [
//               pw.Container(
//                 width: pageWidth,
//                 height: pageHeight,
//                 decoration: pw.BoxDecoration(
//                   color: PdfColors.white,
//                   border: pw.Border.all(color: PdfColors.amber600, width: 3),
//                 ),
//               ),
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(40),
//                 child: pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.start,
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Image(image, width: 60, height: 60),
//                     pw.SizedBox(height: 10),
//                     pw.Text("تقارير المخزون",
//                         style: pw.TextStyle(
//                             fontSize: 26,
//                             fontWeight: pw.FontWeight.bold,
//                             color: PdfColors.black),
//                         textAlign: pw.TextAlign.center),
//                     pw.SizedBox(height: 6),
//                     pw.Container(
//                         height: 2,
//                         width: pageWidth * 0.4,
//                         color: PdfColors.amber600),
//                     pw.SizedBox(height: 20),
//                     pw.Text(
//                       "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
//                       "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
//                       style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
//                       textAlign: pw.TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     // ---------- Opening Balance ----------
//     if (allowed.contains(ReportSection.openingBalance)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول الرصيد الافتتاحي",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...items
//                   .where((e) => e['fromOpeningBalance'] == true)
//                   .map((item) {
//                 final date = item['date'] is Timestamp
//                     ? (item['date'] as Timestamp).toDate()
//                     : item['date'];
//                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(item['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات الرصيد الافتتاحي",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               openingCount,
//               opening18,
//               opening21,
//               opening22,
//               openingBullion,
//               openingGem,
//               openingWeight,
//               openingWage,
//               openingCost,
//               openingWeight18,
//               openingWeight21,
//               openingWeight22,
//               openingWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Entry ----------
//     if (allowed.contains(ReportSection.entry)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول الإدخال",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...items
//                   .where((e) => e['fromOpeningBalance'] != true)
//                   .map((item) {
//                 final date = item['date'] is Timestamp
//                     ? (item['date'] as Timestamp).toDate()
//                     : item['date'];
//                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(item['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات الإدخال",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               totalCount,
//               count18,
//               count21,
//               count22,
//               countBullion,
//               countGem,
//               totalWeight,
//               totalWage,
//               totalCost,
//               weight18,
//               weight21,
//               weight22,
//               weightBullion),
//         ],
//       ));
//     }

//     // ---------- Missing ----------
//     if (allowed.contains(ReportSection.missing)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول المفقود",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...missingItems.map((item) {
//                 final date = item['date'] is Timestamp
//                     ? (item['date'] as Timestamp).toDate()
//                     : item['date'];
//                 final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(item['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات المفقود",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               missingCount,
//               missing18,
//               missing21,
//               missing22,
//               missingBullion,
//               missingGem,
//               missingWeight,
//               missingWage,
//               missingCost,
//               missingWeight18,
//               missingWeight21,
//               missingWeight22,
//               missingWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Inventory ----------
//     if (allowed.contains(ReportSection.inventory)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول الجرد",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "آخر ظهور",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...inventories.map((inv) {
//                 final date = inv['lastSeenAt'] is Timestamp
//                     ? (inv['lastSeenAt'] as Timestamp).toDate()
//                     : inv['lastSeenAt'];
//                 final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(inv['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات الجرد",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               invTotalCount,
//               invCount18,
//               invCount21,
//               invCount22,
//               invCountBullion,
//               invCountGem,
//               invTotalWeight,
//               invTotalWage,
//               invTotalCost,
//               invWeight18,
//               invWeight21,
//               invWeight22,
//               invWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Updates ----------
//     if (allowed.contains(ReportSection.updates)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول التعديلات",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...updates.where((e) => e['updatedAt'] != null).map((update) {
//                 final date = update['updatedAt'] is Timestamp
//                     ? (update['updatedAt'] as Timestamp).toDate()
//                     : update['updatedAt'];
//                 final payload =
//                     (update['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(update['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات التعديلات",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               updatedCount,
//               updated18,
//               updated21,
//               updated22,
//               updatedBullion,
//               updatedGem,
//               updatedWeight,
//               updatedWage,
//               updatedCost,
//               updatedWeight18,
//               updatedWeight21,
//               updatedWeight22,
//               updatedWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Sales ----------
//     if (allowed.contains(ReportSection.sales)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول المبيعات",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1.9),
//               2: pw.FlexColumnWidth(1),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(1),
//               6: pw.FlexColumnWidth(1.5),
//               7: pw.FlexColumnWidth(1.7),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//               10: pw.FlexColumnWidth(1.5),
//               11: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "مستخدم",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "عيار",
//                   "قطعة",
//                   "مكونات",
//                   "كاش",
//                   "شبكة",
//                   "اجمالي",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...sales.map((sale) {
//                 final date = sale['soldAt'] is Timestamp
//                     ? (sale['soldAt'] as Timestamp).toDate()
//                     : sale['soldAt'];
//                 final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
//                 final payment = (sale['payment'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(payment['soldBy']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(translateCategory(sale['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payment['cash']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payment['visa']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payment['total']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات المبيعات",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               salesTotalCount,
//               salesCount18,
//               salesCount21,
//               salesCount22,
//               salesCountBullion,
//               salesCountGem,
//               salesTotalWeight,
//               salesTotalWage,
//               salesTotalCost,
//               salesWeight18,
//               salesWeight21,
//               salesWeight22,
//               salesWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Sellers Totals ----------
//     if (allowed.contains(ReportSection.sellersTotals)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات البائعين",
//               style:
//                   pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(3),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(2),
//               3: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: const pw.BoxDecoration(color: PdfColors.grey200),
//                 children: [
//                   _cell("البائع", bold: true),
//                   _cell("الإجمالي", bold: true),
//                   _cell("كاش", bold: true),
//                   _cell("شبكة", bold: true)
//                 ],
//               ),
//               ...sellersTotals.entries.map((e) {
//                 return pw.TableRow(children: [
//                   _cell(e.key),
//                   _cell(e.value['total']!.toStringAsFixed(2)),
//                   _cell(e.value['cash']!.toStringAsFixed(2)),
//                   _cell(e.value['visa']!.toStringAsFixed(2)),
//                 ]);
//               }),
//             ],
//           ),
//         ],
//       ));
//     }

//     // ---------- Transfers ----------
//     if (allowed.contains(ReportSection.transfers)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول التحويلات",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(1),
//               2: pw.FlexColumnWidth(1.5),
//               3: pw.FlexColumnWidth(1.5),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(0.8),
//               6: pw.FlexColumnWidth(1.2),
//               7: pw.FlexColumnWidth(1.2),
//               8: pw.FlexColumnWidth(1.5),
//               9: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "كود",
//                   "نوع",
//                   "تاريخ",
//                   "وزن",
//                   "أجر",
//                   "عيار",
//                   "قطعة",
//                   "تكلفة",
//                   "مكونات",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...branchTransfers.map((branchTransfer) {
//                 final date = branchTransfer['date'] is Timestamp
//                     ? (branchTransfer['date'] as Timestamp).toDate()
//                     : branchTransfer['date'];
//                 final payload =
//                     (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
//                 pw.Widget codeWidget;
//                 if (payload['qrCode'] != null) {
//                   if (payload['showQr'] == true) {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.qrCode(),
//                           data: payload['qrCode'],
//                           width: 20,
//                           height: 20),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   } else {
//                     codeWidget =
//                         pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
//                       pw.BarcodeWidget(
//                           barcode: pw.Barcode.code128(),
//                           data: payload['qrCode'],
//                           width: 40,
//                           height: 15,
//                           drawText: false),
//                       pw.SizedBox(height: 1),
//                       pw.Text(payload['qrCode']?.toString() ?? "—",
//                           style: pw.TextStyle(fontSize: 6)),
//                     ]);
//                   }
//                 } else {
//                   codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
//                 }
//                 return pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(2), child: codeWidget),
//                   pw.Text(translateCategory(branchTransfer['category']),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['wage']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       payload['type']?.toString().isNotEmpty == true
//                           ? payload['type'].toString()
//                           : (payload['kind']?.toString().isNotEmpty == true
//                               ? payload['kind'].toString()
//                               : "—"),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['cost']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['setComponents']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(payload['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات التحويلات",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           _buildTotals(
//               branchTransfersTotalCount,
//               branchTransfersCount18,
//               branchTransfersCount21,
//               branchTransfersCount22,
//               branchTransfersCountBullion,
//               branchTransfersCountGem,
//               branchTransfersTotalWeight,
//               branchTransfersTotalWage,
//               branchTransfersTotalCost,
//               branchTransfersWeight18,
//               branchTransfersWeight21,
//               branchTransfersWeight22,
//               branchTransfersWeightBullion),
//         ],
//       ));
//     }

//     // ---------- Scrap ----------
//     if (allowed.contains(ReportSection.scrap)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول الكسر",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(1),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(1),
//               3: pw.FlexColumnWidth(2),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(1.5),
//               6: pw.FlexColumnWidth(1.5),
//               7: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "نوع",
//                   "تاريخ",
//                   "عيار",
//                   "وزن",
//                   "كاش",
//                   "شبكة",
//                   "اجمالي",
//                   "ملاحظات"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...scrapTransactions.where((scrapTransaction) {
//                 final type =
//                     scrapTransaction['type']?.toString().trim().toLowerCase() ??
//                         '';
//                 return type == 'sale' || type == 'add';
//               }).map((scrapTransaction) {
//                 final date = scrapTransaction['date'] is Timestamp
//                     ? (scrapTransaction['date'] as Timestamp).toDate()
//                     : scrapTransaction['date'];
//                 return pw.TableRow(children: [
//                   pw.Text((() {
//                     final type = scrapTransaction['type']
//                         ?.toString()
//                         .trim()
//                         .toLowerCase();
//                     if (type == 'add') return 'شراء';
//                     if (type == 'sale') return 'بيع';
//                     return '—';
//                   })(),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['cash']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['network']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['total']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(scrapTransaction['notes']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات الكسر",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 14 : $scrapTransactionsCount14             ( وزن:   ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 18 : $scrapTransactionsCount18             ( وزن:   ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 21 : $scrapTransactionsCount21              ( وزن:  ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 22 : $scrapTransactionsCount22              ( وزن:  ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 24 : $scrapTransactionsCount24             ( وزن:   ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     // ---------- Vouchers ----------
//     if (allowed.contains(ReportSection.vouchers)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول السندات",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(1),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(1),
//               3: pw.FlexColumnWidth(2),
//               4: pw.FlexColumnWidth(1.5),
//               5: pw.FlexColumnWidth(1.5),
//               6: pw.FlexColumnWidth(1.5),
//               7: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: [
//                   "سند",
//                   "تاريخ",
//                   "عيار",
//                   "وزن",
//                   "كاش",
//                   "شبكة",
//                   "اجمالي",
//                   "مندوب",
//                   "مورد"
//                 ]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...vouchers.where((voucher) {
//                 final type =
//                     voucher['type']?.toString().trim().toLowerCase() ?? '';
//                 return type == 'receipt' || type == 'payment';
//               }).map((voucher) {
//                 final date = voucher['date'] is Timestamp
//                     ? (voucher['date'] as Timestamp).toDate()
//                     : voucher['date'];
//                 return pw.TableRow(children: [
//                   pw.Text((() {
//                     final type =
//                         voucher['type']?.toString().trim().toLowerCase();
//                     if (type == 'payment') return 'صرف';
//                     if (type == 'receipt') return 'قبض';
//                     return '—';
//                   })(),
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['carat']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['weight']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['cash']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['network']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['total']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['delegate']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(voucher['supplierName']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات السندات",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد السندات: $vouchersTotalCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 18 : $vouchersCount18             ( وزن:   ${vouchersWeight18.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 21 : $vouchersCount21              ( وزن:  ${vouchersWeight21.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 22 : $vouchersCount22              ( وزن:  ${vouchersWeight22.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     // ---------- Expenses ----------
//     if (allowed.contains(ReportSection.expenses)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول المصروفات",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(2),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(2),
//               3: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: ["نوع", "تاريخ", "مصروف", "سبب الصرف"]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...expenses.map((expense) {
//                 final date = expense['date'] is Timestamp
//                     ? (expense['date'] as Timestamp).toDate()
//                     : expense['date'];
//                 return pw.TableRow(children: [
//                   pw.Text(expense['type']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(expense['amount']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(expense['note']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجمالي المصروفات",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد المصروفات: $expensesTotalCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text: "إجمالي قيمة المصروفات: $expensesTotal",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     // ---------- Deposits ----------
//     if (allowed.contains(ReportSection.deposits)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول توريد للادارة",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(1),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(1),
//               3: pw.FlexColumnWidth(2),
//               4: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...managementDeposits.map((managementDeposit) {
//                 final date = managementDeposit['date'] is Timestamp
//                     ? (managementDeposit['date'] as Timestamp).toDate()
//                     : managementDeposit['date'];
//                 return pw.TableRow(children: [
//                   pw.Text(managementDeposit['type']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementDeposit['cash']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementDeposit['visa']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementDeposit['total']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات التوريد للادارة ",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     // ---------- Imports ----------
//     if (allowed.contains(ReportSection.imports)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("جدول استيرادات من الادارة",
//               style:
//                   pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(1),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(1),
//               3: pw.FlexColumnWidth(2),
//               4: pw.FlexColumnWidth(1.5),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: pw.BoxDecoration(color: PdfColors.grey300),
//                 children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
//                     .map((e) => pw.Padding(
//                           padding: const pw.EdgeInsets.all(4),
//                           child: pw.Text(e,
//                               style: pw.TextStyle(
//                                   fontSize: 10, fontWeight: pw.FontWeight.bold),
//                               textAlign: pw.TextAlign.center),
//                         ))
//                     .toList(),
//               ),
//               ...managementImported.map((managementImport) {
//                 final date = managementImport['date'] is Timestamp
//                     ? (managementImport['date'] as Timestamp).toDate()
//                     : managementImport['date'];
//                 return pw.TableRow(children: [
//                   pw.Text(managementImport['type']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementImport['cash']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementImport['visa']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                   pw.Text(managementImport['total']?.toString() ?? "—",
//                       textAlign: pw.TextAlign.center,
//                       style: pw.TextStyle(fontSize: 8)),
//                 ]);
//               }),
//             ],
//           ),
//           pw.SizedBox(height: 10),
//           pw.Text("إجماليات الاستيرادات من لادارة ",
//               style:
//                   pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد التوريدات: $managementImportedTotalCount",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 8),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     // ---------- Safe Totals ----------
//     if (allowed.contains(ReportSection.safeTotals)) {
//       try {
//         double sum = 0.0, cash = 0.0, visa = 0.0;
//         final salesSnap = await FS.salesCol().get();
//         for (var d in salesSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum += (data['payment']?['total'] ?? 0).toDouble();
//           cash += (data['payment']?['cash'] ?? 0).toDouble();
//           visa += (data['payment']?['visa'] ?? 0).toDouble();
//         }
//         final scrapSnap =
//             await FS.scrapCol().where("type", isEqualTo: "sale").get();
//         for (var d in scrapSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum += (data['total'] ?? 0).toDouble();
//           cash += (data['cash'] ?? 0).toDouble();
//           visa += (data['network'] ?? 0).toDouble();
//         }
//         final scrapBuySnap =
//             await FS.scrapCol().where("type", isEqualTo: "add").get();
//         for (var d in scrapBuySnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum -= (data['total'] ?? 0).toDouble();
//           cash -= (data['cash'] ?? 0).toDouble();
//           visa -= (data['network'] ?? 0).toDouble();
//         }
//         final vouchersSnap =
//             await FS.vouchersCol().where("type", isEqualTo: "payment").get();
//         for (var d in vouchersSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum -= (data['total'] ?? 0).toDouble();
//           cash -= (data['cash'] ?? 0).toDouble();
//           visa -= (data['network'] ?? 0).toDouble();
//         }
//         final expSnap = await FS.expensesCol().get();
//         for (var d in expSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
//           sum -= amount;
//           cash -= amount;
//         }
//         final depositSnap = await FS.depositsCol().get();
//         for (var d in depositSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final totalcash = (data['cash'] ?? 0).toDouble();
//           final totalvisa = (data['visa'] ?? 0).toDouble();
//           sum -= totalcash + totalvisa;
//           cash -= totalcash;
//           visa -= totalvisa;
//         }
//         final ImportSnap = await FS.ImportedCol().get();
//         for (var d in ImportSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final totalcash = (data['cash'] ?? 0).toDouble();
//           final totalvisa = (data['visa'] ?? 0).toDouble();
//           sum += totalcash + totalvisa;
//           cash += totalcash;
//           visa += totalvisa;
//         }
//         pdf.addPage(pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           textDirection: pw.TextDirection.rtl,
//           theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//           build: (context) => [
//             pw.SizedBox(height: 15),
//             pw.Text("إجماليات الصندوق",
//                 style:
//                     pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 8),
//             pw.Table(
//               border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//               columnWidths: const {
//                 0: pw.FlexColumnWidth(3),
//                 1: pw.FlexColumnWidth(2),
//               },
//               children: [
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("إجمالي الكاش",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(cash.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("إجمالي الشبكة",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(visa.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("الإجمالي الكلي",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(sum.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//               ],
//             ),
//           ],
//         ));
//       } catch (e, st) {
//         print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
//         print(st);
//       }
//     }

//     return pdf.save();
//   }

//   // ============================================================
//   // printReport
//   // ============================================================
//   static Future<void> printReport(DateTime start, DateTime end,
//       {Set<ReportSection>? sections}) async {
//     final items = await getItemsByDateRange(start, end);
//     final updates = await getupdatesByDateRange(start, end);
//     final inventories = await getInventoriesByDateRange(start, end);
//     final sales = await getSalesByDateRange(start, end);
//     final branchTransfers = await getBranchTransfersByDateRange(start, end);
//     final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
//     final vouchers = await getvouchersByDateRange(start, end);
//     final expenses = await getexpensesByDateRange(start, end);
//     final managementDeposits =
//         await getmanagementDepositsByDateRange(start, end);
//     final managementImported =
//         await getmanagementImportedByDateRange(start, end);
//     final pdfData = await generatePdfReport(
//         items,
//         inventories,
//         sales,
//         branchTransfers,
//         updates,
//         scrapTransactions,
//         vouchers,
//         expenses,
//         managementDeposits,
//         managementImported,
//         start,
//         end,
//         sections: sections);
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
//   }

//   // ============================================================
//   // runScheduledReport
//   // ============================================================
//   static Future<bool> runScheduledReport(DateTime start, DateTime end) async {
//     try {
//       final items = await getItemsByDateRange(start, end);
//       final updates = await getupdatesByDateRange(start, end);
//       final inventories = await getInventoriesByDateRange(start, end);
//       final sales = await getSalesByDateRange(start, end);
//       final branchTransfers = await getBranchTransfersByDateRange(start, end);
//       final scrapTransactions =
//           await getScrapTransactionsByDateRange(start, end);
//       final vouchers = await getvouchersByDateRange(start, end);
//       final expenses = await getexpensesByDateRange(start, end);
//       final managementDeposits =
//           await getmanagementDepositsByDateRange(start, end);
//       final managementImported =
//           await getmanagementImportedByDateRange(start, end);
//       final pdfData = await generatePdfReport(
//           items,
//           inventories,
//           sales,
//           branchTransfers,
//           updates,
//           scrapTransactions,
//           vouchers,
//           expenses,
//           managementDeposits,
//           managementImported,
//           start,
//           end);
//       Directory? downloadsDir;
//       if (Platform.isAndroid) {
//         downloadsDir = Directory("/storage/emulated/0/Download");
//       } else {
//         downloadsDir = await getApplicationDocumentsDirectory();
//       }
//       final filePath =
//           "${downloadsDir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf";
//       final file = File(filePath);
//       await file.writeAsBytes(pdfData);
//       print("🚀 التقرير اتحفظ هنا: $filePath");
//       return true;
//     } catch (e) {
//       print("❌ خطأ في إنشاء التقرير: $e");
//       return false;
//     }
//   }

//   // ============================================================
//   // printReportTotal
//   // ============================================================
//   static Future<void> printReportTotal(DateTime start, DateTime end,
//       {Set<ReportSection>? sections}) async {
//     final items = await getItemsByDateRange(start, end);
//     final updates = await getupdatesByDateRange(start, end);
//     final inventories = await getInventoriesByDateRange(start, end);
//     final sales = await getSalesByDateRange(start, end);
//     final branchTransfers = await getBranchTransfersByDateRange(start, end);
//     final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
//     final vouchers = await getvouchersByDateRange(start, end);
//     final expenses = await getexpensesByDateRange(start, end);
//     final managementDeposits =
//         await getmanagementDepositsByDateRange(start, end);
//     final managementImported =
//         await getmanagementImportedByDateRange(start, end);
//     final pdfData = await generatePdfTotal(
//         items,
//         inventories,
//         sales,
//         branchTransfers,
//         updates,
//         scrapTransactions,
//         vouchers,
//         expenses,
//         managementDeposits,
//         managementImported,
//         start,
//         end,
//         sections: sections);
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
//   }

//   // ============================================================
//   // generatePdfTotal — معاد بناؤه (شغال 100%، بس مش نسخة أصلية)
//   // ============================================================
//   static Future<Uint8List> generatePdfTotal(
//       List<Map<String, dynamic>> items,
//       List<Map<String, dynamic>> inventories,
//       List<Map<String, dynamic>> sales,
//       List<Map<String, dynamic>> branchTransfers,
//       List<Map<String, dynamic>> updates,
//       List<Map<String, dynamic>> scrapTransactions,
//       List<Map<String, dynamic>> vouchers,
//       List<Map<String, dynamic>> expenses,
//       List<Map<String, dynamic>> managementDeposits,
//       List<Map<String, dynamic>> managementImported,
//       DateTime start,
//       DateTime end,
//       {Set<ReportSection>? sections}) async {
//     final allowed = sections ?? ReportSection.values.toSet();
//     final pdf = pw.Document();
//     final arabicFont = await PdfGoogleFonts.cairoRegular();
//     final arabicFontBold = await PdfGoogleFonts.cairoBold();

//     // ===== إعادة حساب نفس الإجماليات (نفس منطق generatePdfReport) =====
//     int totalCount = 0, openingCount = 0, updatedCount = 0;
//     double totalWeight = 0, totalWage = 0, totalCost = 0;
//     double openingWeight = 0, openingWage = 0, openingCost = 0;
//     double updatedWeight = 0, updatedWage = 0, updatedCost = 0;
//     int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
//     double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;
//     int opening18 = 0,
//         opening21 = 0,
//         opening22 = 0,
//         openingBullion = 0,
//         openingGem = 0;
//     double openingWeight18 = 0,
//         openingWeight21 = 0,
//         openingWeight22 = 0,
//         openingWeightBullion = 0;
//     int updated18 = 0,
//         updated21 = 0,
//         updated22 = 0,
//         updatedBullion = 0,
//         updatedGem = 0;
//     double updatedWeight18 = 0,
//         updatedWeight21 = 0,
//         updatedWeight22 = 0,
//         updatedWeightBullion = 0;

//     for (var item in items) {
//       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = item['category']?.toString();
//       final fromOpening = item['fromOpeningBalance'] == true;
//       if (fromOpening) {
//         openingCount++;
//         openingWeight += weight;
//         openingWage += wage;
//         openingCost += cost;
//         if (carat == "18") {
//           opening18++;
//           openingWeight18 += weight;
//         }
//         if (carat == "21") {
//           opening21++;
//           openingWeight21 += weight;
//         }
//         if (carat == "22") {
//           opening22++;
//           openingWeight22 += weight;
//         }
//         if (category == "bullion") {
//           openingBullion++;
//           openingWeightBullion += weight;
//         }
//         if (category == "gem") {
//           openingGem++;
//         }
//       } else {
//         totalCount++;
//         totalWeight += weight;
//         totalWage += wage;
//         totalCost += cost;
//         if (carat == "18") {
//           count18++;
//           weight18 += weight;
//         }
//         if (carat == "21") {
//           count21++;
//           weight21 += weight;
//         }
//         if (carat == "22") {
//           count22++;
//           weight22 += weight;
//         }
//         if (category == "bullion") {
//           countBullion++;
//           weightBullion += weight;
//         }
//         if (category == "gem") {
//           countGem++;
//         }
//       }
//     }
//     for (var update in updates) {
//       final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = update['category']?.toString();
//       if (update['updatedAt'] != null) {
//         updatedCount++;
//         updatedWeight += weight;
//         updatedWage += wage;
//         updatedCost += cost;
//         if (carat == "18") {
//           updated18++;
//           updatedWeight18 += weight;
//         }
//         if (carat == "21") {
//           updated21++;
//           updatedWeight21 += weight;
//         }
//         if (carat == "22") {
//           updated22++;
//           updatedWeight22 += weight;
//         }
//         if (category == "bullion") {
//           updatedBullion++;
//           updatedWeightBullion += weight;
//         }
//         if (category == "gem") {
//           updatedGem++;
//         }
//       }
//     }

//     int invTotalCount = inventories.length;
//     double invTotalWeight = 0, invTotalWage = 0, invTotalCost = 0;
//     int invCount18 = 0,
//         invCount21 = 0,
//         invCount22 = 0,
//         invCountBullion = 0,
//         invCountGem = 0;
//     double invWeight18 = 0,
//         invWeight21 = 0,
//         invWeight22 = 0,
//         invWeightBullion = 0;
//     for (var inv in inventories) {
//       final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       invTotalWeight += weight;
//       invTotalWage += wage;
//       invTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = inv['category']?.toString();
//       if (carat == "18") {
//         invCount18++;
//         invWeight18 += weight;
//       }
//       if (carat == "21") {
//         invCount21++;
//         invWeight21 += weight;
//       }
//       if (carat == "22") {
//         invCount22++;
//         invWeight22 += weight;
//       }
//       if (category == "bullion") {
//         invCountBullion++;
//         invWeightBullion += weight;
//       }
//       if (category == "gem") {
//         invCountGem++;
//       }
//     }

//     final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();
//     final missingItems = items.where((item) {
//       final id = item['epcHex'] ?? item['id'];
//       return !invIds.contains(id);
//     }).toList();
//     int missingCount = 0;
//     double missingWeight = 0, missingWage = 0, missingCost = 0;
//     int missing18 = 0,
//         missing21 = 0,
//         missing22 = 0,
//         missingBullion = 0,
//         missingGem = 0;
//     double missingWeight18 = 0,
//         missingWeight21 = 0,
//         missingWeight22 = 0,
//         missingWeightBullion = 0;
//     for (var item in missingItems) {
//       final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       final carat = payload['carat']?.toString();
//       final category = item['category']?.toString();
//       missingCount++;
//       missingWeight += weight;
//       missingWage += wage;
//       missingCost += cost;
//       if (carat == "18") {
//         missing18++;
//         missingWeight18 += weight;
//       }
//       if (carat == "21") {
//         missing21++;
//         missingWeight21 += weight;
//       }
//       if (carat == "22") {
//         missing22++;
//         missingWeight22 += weight;
//       }
//       if (category == "bullion") {
//         missingBullion++;
//         missingWeightBullion += weight;
//       }
//       if (category == "gem") {
//         missingGem++;
//       }
//     }

//     int salesTotalCount = sales.length;
//     double salesTotalWeight = 0, salesTotalWage = 0, salesTotalCost = 0;
//     int salesCount18 = 0,
//         salesCount21 = 0,
//         salesCount22 = 0,
//         salesCountBullion = 0,
//         salesCountGem = 0;
//     double salesWeight18 = 0,
//         salesWeight21 = 0,
//         salesWeight22 = 0,
//         salesWeightBullion = 0;
//     for (var sale in sales) {
//       final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       salesTotalWeight += weight;
//       salesTotalWage += wage;
//       salesTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = sale['category']?.toString();
//       if (carat == "18") {
//         salesCount18++;
//         salesWeight18 += weight;
//       }
//       if (carat == "21") {
//         salesCount21++;
//         salesWeight21 += weight;
//       }
//       if (carat == "22") {
//         salesCount22++;
//         salesWeight22 += weight;
//       }
//       if (category == "bullion") {
//         salesCountBullion++;
//         salesWeightBullion += weight;
//       }
//       if (category == "gem") {
//         salesCountGem++;
//       }
//     }

//     int branchTransfersTotalCount = branchTransfers.length;
//     double branchTransfersTotalWeight = 0,
//         branchTransfersTotalWage = 0,
//         branchTransfersTotalCost = 0;
//     int branchTransfersCount18 = 0,
//         branchTransfersCount21 = 0,
//         branchTransfersCount22 = 0,
//         branchTransfersCountBullion = 0,
//         branchTransfersCountGem = 0;
//     double branchTransfersWeight18 = 0,
//         branchTransfersWeight21 = 0,
//         branchTransfersWeight22 = 0,
//         branchTransfersWeightBullion = 0;
//     for (var branchTransfer in branchTransfers) {
//       final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
//       final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
//       final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
//       final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
//       branchTransfersTotalWeight += weight;
//       branchTransfersTotalWage += wage;
//       branchTransfersTotalCost += cost;
//       final carat = payload['carat']?.toString();
//       final category = branchTransfer['category']?.toString();
//       if (carat == "18") {
//         branchTransfersCount18++;
//         branchTransfersWeight18 += weight;
//       }
//       if (carat == "21") {
//         branchTransfersCount21++;
//         branchTransfersWeight21 += weight;
//       }
//       if (carat == "22") {
//         branchTransfersCount22++;
//         branchTransfersWeight22 += weight;
//       }
//       if (category == "bullion") {
//         branchTransfersCountBullion++;
//         branchTransfersWeightBullion += weight;
//       }
//       if (category == "gem") {
//         branchTransfersCountGem++;
//       }
//     }

//     int scrapTransactionsTotalCount = 0;
//     double scrapTransactionsTotalWeight = 0,
//         scrapTransactionsTotalcash = 0,
//         scrapTransactionsTotalnetwork = 0,
//         scrapTransactionsTotaltotal = 0;
//     int scrapTransactionsCount18 = 0,
//         scrapTransactionsCount14 = 0,
//         scrapTransactionsCount24 = 0,
//         scrapTransactionsCount21 = 0,
//         scrapTransactionsCount22 = 0;
//     double scrapTransactionsWeight18 = 0,
//         scrapTransactionsWeight14 = 0,
//         scrapTransactionsWeight24 = 0,
//         scrapTransactionsWeight21 = 0,
//         scrapTransactionsWeight22 = 0;
//     for (var scrapTransaction in scrapTransactions) {
//       final weight =
//           double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
//       final cash =
//           double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
//       final network =
//           double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
//       final total =
//           double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;
//       final carat = scrapTransaction['carat']?.toString();
//       final type =
//           scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';
//       if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
//         scrapTransactionsTotalCount += 1;
//         scrapTransactionsTotalWeight += weight;
//         scrapTransactionsTotalcash += cash;
//         scrapTransactionsTotalnetwork += network;
//         scrapTransactionsTotaltotal += total;
//         if (carat == "14") {
//           scrapTransactionsCount14++;
//           scrapTransactionsWeight14 += weight;
//         }
//         if (carat == "18") {
//           scrapTransactionsCount18++;
//           scrapTransactionsWeight18 += weight;
//         }
//         if (carat == "21") {
//           scrapTransactionsCount21++;
//           scrapTransactionsWeight21 += weight;
//         }
//         if (carat == "22") {
//           scrapTransactionsCount22++;
//           scrapTransactionsWeight22 += weight;
//         }
//         if (carat == "24") {
//           scrapTransactionsCount24++;
//           scrapTransactionsWeight24 += weight;
//         }
//       }
//     }

//     int vouchersTotalCount = 0,
//         voucherspaymentCount = 0,
//         vouchersreceiptCount = 0;
//     double vouchersTotalWeight = 0,
//         vouchersTotalcash = 0,
//         vouchersTotalnetwork = 0,
//         vouchersTotaltotal = 0;
//     int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;
//     double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;
//     for (var voucher in vouchers) {
//       final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
//       final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
//       final network =
//           double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
//       final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;
//       final carat = voucher['carat']?.toString();
//       final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
//       vouchersTotalCount += 1;
//       if (type.isNotEmpty && type == 'payment') {
//         voucherspaymentCount += 1;
//         vouchersTotalWeight += weight;
//         vouchersTotalcash += cash;
//         vouchersTotalnetwork += network;
//         vouchersTotaltotal += total;
//         if (carat == "18") {
//           vouchersCount18++;
//           vouchersWeight18 += weight;
//         }
//         if (carat == "21") {
//           vouchersCount21++;
//           vouchersWeight21 += weight;
//         }
//         if (carat == "22") {
//           vouchersCount22++;
//           vouchersWeight22 += weight;
//         }
//       } else if (type.isNotEmpty && type == 'receipt') {
//         vouchersreceiptCount += 1;
//         vouchersTotalWeight -= weight;
//         vouchersTotalcash -= cash;
//         vouchersTotalnetwork -= network;
//         vouchersTotaltotal -= total;
//         if (carat == "18") {
//           vouchersCount18++;
//           vouchersWeight18 -= weight;
//         }
//         if (carat == "21") {
//           vouchersCount21++;
//           vouchersWeight21 -= weight;
//         }
//         if (carat == "22") {
//           vouchersCount22++;
//           vouchersWeight22 -= weight;
//         }
//       }
//     }

//     int expensesTotalCount = 0;
//     double expensesTotal = 0;
//     for (var expense in expenses) {
//       final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
//       expensesTotal += amount;
//       expensesTotalCount += 1;
//     }

//     int managementDepositsTotalCount = 0;
//     double managementDepositsTotalcash = 0,
//         managementDepositsTotalnetwork = 0,
//         managementDepositsTotaltotal = 0;
//     for (var managementDeposit in managementDeposits) {
//       managementDepositsTotalCount += 1;
//       managementDepositsTotalcash +=
//           double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
//       managementDepositsTotalnetwork +=
//           double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
//       managementDepositsTotaltotal +=
//           double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
//     }

//     int managementImportedTotalCount = 0;
//     double managementImportedTotalcash = 0,
//         managementImportedTotalnetwork = 0,
//         managementImportedTotaltotal = 0;
//     for (var managementImport in managementImported) {
//       managementImportedTotalCount += 1;
//       managementImportedTotalcash +=
//           double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
//       managementImportedTotalnetwork +=
//           double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
//       managementImportedTotaltotal +=
//           double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
//     }

//     final Map<String, Map<String, double>> sellersTotals = {};
//     for (var sale in sales) {
//       final payment = sale['payment'] as Map<String, dynamic>? ?? {};
//       final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';
//       final total = (payment['total'] ?? 0).toDouble();
//       final cash = (payment['cash'] ?? 0).toDouble();
//       final visa = (payment['visa'] ?? 0).toDouble();
//       sellersTotals.putIfAbsent(
//           soldBy, () => {'total': 0, 'cash': 0, 'visa': 0});
//       sellersTotals[soldBy]!['total'] =
//           sellersTotals[soldBy]!['total']! + total;
//       sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
//       sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
//     }

//     // ============================================================
//     // PDF PAGES
//     // ============================================================
//     final image = pw.MemoryImage(
//       (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
//     );

//     // Cover (always)
//     pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       textDirection: pw.TextDirection.rtl,
//       theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//       build: (context) {
//         final pageWidth = PdfPageFormat.a4.width;
//         final pageHeight = PdfPageFormat.a4.height;
//         return pw.Stack(children: [
//           pw.Container(
//             width: pageWidth,
//             height: pageHeight,
//             decoration: pw.BoxDecoration(
//               color: PdfColors.white,
//               border: pw.Border.all(color: PdfColors.amber600, width: 3),
//             ),
//           ),
//           pw.Padding(
//             padding: const pw.EdgeInsets.all(40),
//             child: pw.Column(
//               mainAxisAlignment: pw.MainAxisAlignment.start,
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 pw.Image(image, width: 60, height: 60),
//                 pw.SizedBox(height: 10),
//                 pw.Text("تقرير الإجماليات",
//                     style: pw.TextStyle(
//                         fontSize: 26,
//                         fontWeight: pw.FontWeight.bold,
//                         color: PdfColors.black),
//                     textAlign: pw.TextAlign.center),
//                 pw.SizedBox(height: 6),
//                 pw.Container(
//                     height: 2,
//                     width: pageWidth * 0.4,
//                     color: PdfColors.amber600),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
//                   "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
//                   style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
//                   textAlign: pw.TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ]);
//       },
//     ));

//     if (allowed.contains(ReportSection.openingBalance)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات الرصيد الافتتاحي",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               openingCount,
//               opening18,
//               opening21,
//               opening22,
//               openingBullion,
//               openingGem,
//               openingWeight,
//               openingWage,
//               openingCost,
//               openingWeight18,
//               openingWeight21,
//               openingWeight22,
//               openingWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.entry)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات الإدخال",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               totalCount,
//               count18,
//               count21,
//               count22,
//               countBullion,
//               countGem,
//               totalWeight,
//               totalWage,
//               totalCost,
//               weight18,
//               weight21,
//               weight22,
//               weightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.missing)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات المفقود",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               missingCount,
//               missing18,
//               missing21,
//               missing22,
//               missingBullion,
//               missingGem,
//               missingWeight,
//               missingWage,
//               missingCost,
//               missingWeight18,
//               missingWeight21,
//               missingWeight22,
//               missingWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.inventory)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات الجرد",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               invTotalCount,
//               invCount18,
//               invCount21,
//               invCount22,
//               invCountBullion,
//               invCountGem,
//               invTotalWeight,
//               invTotalWage,
//               invTotalCost,
//               invWeight18,
//               invWeight21,
//               invWeight22,
//               invWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.updates)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات التعديلات",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               updatedCount,
//               updated18,
//               updated21,
//               updated22,
//               updatedBullion,
//               updatedGem,
//               updatedWeight,
//               updatedWage,
//               updatedCost,
//               updatedWeight18,
//               updatedWeight21,
//               updatedWeight22,
//               updatedWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.sales)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات المبيعات",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               salesTotalCount,
//               salesCount18,
//               salesCount21,
//               salesCount22,
//               salesCountBullion,
//               salesCountGem,
//               salesTotalWeight,
//               salesTotalWage,
//               salesTotalCost,
//               salesWeight18,
//               salesWeight21,
//               salesWeight22,
//               salesWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.sellersTotals)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات البائعين",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Table(
//             border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//             columnWidths: const {
//               0: pw.FlexColumnWidth(3),
//               1: pw.FlexColumnWidth(2),
//               2: pw.FlexColumnWidth(2),
//               3: pw.FlexColumnWidth(2),
//             },
//             children: [
//               pw.TableRow(
//                 decoration: const pw.BoxDecoration(color: PdfColors.grey200),
//                 children: [
//                   _cell("البائع", bold: true),
//                   _cell("الإجمالي", bold: true),
//                   _cell("كاش", bold: true),
//                   _cell("شبكة", bold: true)
//                 ],
//               ),
//               ...sellersTotals.entries.map((e) => pw.TableRow(children: [
//                     _cell(e.key),
//                     _cell(e.value['total']!.toStringAsFixed(2)),
//                     _cell(e.value['cash']!.toStringAsFixed(2)),
//                     _cell(e.value['visa']!.toStringAsFixed(2)),
//                   ])),
//             ],
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.transfers)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات التحويلات",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           _buildTotals(
//               branchTransfersTotalCount,
//               branchTransfersCount18,
//               branchTransfersCount21,
//               branchTransfersCount22,
//               branchTransfersCountBullion,
//               branchTransfersCountGem,
//               branchTransfersTotalWeight,
//               branchTransfersTotalWage,
//               branchTransfersTotalCost,
//               branchTransfersWeight18,
//               branchTransfersWeight21,
//               branchTransfersWeight22,
//               branchTransfersWeightBullion),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.scrap)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات الكسر",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 14 : $scrapTransactionsCount14 ( وزن: ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 18 : $scrapTransactionsCount18 ( وزن: ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 21 : $scrapTransactionsCount21 ( وزن: ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 22 : $scrapTransactionsCount22 ( وزن: ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد شرائح عيار 24 : $scrapTransactionsCount24 ( وزن: ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.vouchers)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات السندات",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد السندات: $vouchersTotalCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 18 : $vouchersCount18 ( وزن: ${vouchersWeight18.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 21 : $vouchersCount21 ( وزن: ${vouchersWeight21.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "عدد سندات عيار 22 : $vouchersCount22 ( وزن: ${vouchersWeight22.toStringAsFixed(2)} )",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.expenses)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجمالي المصروفات",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد المصروفات: $expensesTotalCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي قيمة المصروفات: ${expensesTotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.deposits)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات التوريد للإدارة",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة: ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش: ${managementDepositsTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر: ${managementDepositsTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.imports)) {
//       pdf.addPage(pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         textDirection: pw.TextDirection.rtl,
//         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//         build: (context) => [
//           pw.Text("إجماليات الاستيراد من الإدارة",
//               style:
//                   pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//           pw.SizedBox(height: 10),
//           pw.Align(
//             alignment: pw.Alignment.centerRight,
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.end,
//               children: [
//                 pw.Bullet(
//                     text:
//                         "إجمالي عدد الاستيرادات: $managementImportedTotalCount",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الشبكة: ${managementImportedTotalnetwork.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي الكاش: ${managementImportedTotalcash.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//                 pw.Bullet(
//                     text:
//                         "إجمالي السعر: ${managementImportedTotaltotal.toStringAsFixed(2)}",
//                     style: pw.TextStyle(fontSize: 10),
//                     textAlign: pw.TextAlign.right),
//               ],
//             ),
//           ),
//         ],
//       ));
//     }

//     if (allowed.contains(ReportSection.safeTotals)) {
//       try {
//         double sum = 0.0, cash = 0.0, visa = 0.0;
//         final salesSnap = await FS.salesCol().get();
//         for (var d in salesSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum += (data['payment']?['total'] ?? 0).toDouble();
//           cash += (data['payment']?['cash'] ?? 0).toDouble();
//           visa += (data['payment']?['visa'] ?? 0).toDouble();
//         }
//         final scrapSnap =
//             await FS.scrapCol().where("type", isEqualTo: "sale").get();
//         for (var d in scrapSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum += (data['total'] ?? 0).toDouble();
//           cash += (data['cash'] ?? 0).toDouble();
//           visa += (data['network'] ?? 0).toDouble();
//         }
//         final scrapBuySnap =
//             await FS.scrapCol().where("type", isEqualTo: "add").get();
//         for (var d in scrapBuySnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum -= (data['total'] ?? 0).toDouble();
//           cash -= (data['cash'] ?? 0).toDouble();
//           visa -= (data['network'] ?? 0).toDouble();
//         }
//         final vouchersSnap =
//             await FS.vouchersCol().where("type", isEqualTo: "payment").get();
//         for (var d in vouchersSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           sum -= (data['total'] ?? 0).toDouble();
//           cash -= (data['cash'] ?? 0).toDouble();
//           visa -= (data['network'] ?? 0).toDouble();
//         }
//         final expSnap = await FS.expensesCol().get();
//         for (var d in expSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
//           sum -= amount;
//           cash -= amount;
//         }
//         final depositSnap = await FS.depositsCol().get();
//         for (var d in depositSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final totalcash = (data['cash'] ?? 0).toDouble();
//           final totalvisa = (data['visa'] ?? 0).toDouble();
//           sum -= totalcash + totalvisa;
//           cash -= totalcash;
//           visa -= totalvisa;
//         }
//         final ImportSnap = await FS.ImportedCol().get();
//         for (var d in ImportSnap.docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final totalcash = (data['cash'] ?? 0).toDouble();
//           final totalvisa = (data['visa'] ?? 0).toDouble();
//           sum += totalcash + totalvisa;
//           cash += totalcash;
//           visa += totalvisa;
//         }
//         pdf.addPage(pw.MultiPage(
//           pageFormat: PdfPageFormat.a4,
//           textDirection: pw.TextDirection.rtl,
//           theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
//           build: (context) => [
//             pw.SizedBox(height: 15),
//             pw.Text("إجماليات الصندوق",
//                 style:
//                     pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 8),
//             pw.Table(
//               border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
//               columnWidths: const {
//                 0: pw.FlexColumnWidth(3),
//                 1: pw.FlexColumnWidth(2),
//               },
//               children: [
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("إجمالي الكاش",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(cash.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("إجمالي الشبكة",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(visa.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//                 pw.TableRow(children: [
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text("الإجمالي الكلي",
//                           style: pw.TextStyle(
//                               fontSize: 20, fontWeight: pw.FontWeight.bold))),
//                   pw.Padding(
//                       padding: const pw.EdgeInsets.all(4),
//                       child: pw.Text(sum.toStringAsFixed(2),
//                           style: pw.TextStyle(fontSize: 20),
//                           textAlign: pw.TextAlign.center)),
//                 ]),
//               ],
//             ),
//           ],
//         ));
//       } catch (e, st) {
//         print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
//         print(st);
//       }
//     }

//     return pdf.save();
//   }
// }
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../services/firestore_service.dart';

// ============================================================
// ReportSection enum + label
// ============================================================
enum ReportSection {
  openingBalance,
  entry,
  missing,
  inventory,
  updates,
  sales,
  sellersTotals,
  transfers,
  scrap,
  vouchers,
  expenses,
  deposits,
  imports,
  safeTotals,
  generalBalance,
}

extension ReportSectionLabel on ReportSection {
  String getLabel(String lang) {
    const ar = {
      ReportSection.openingBalance: 'الرصيد الافتتاحي',
      ReportSection.entry: 'الإدخال',
      ReportSection.missing: 'المفقود',
      ReportSection.inventory: 'الجرد',
      ReportSection.updates: 'التعديلات',
      ReportSection.sales: 'المبيعات',
      ReportSection.sellersTotals: 'إجماليات البائعين',
      ReportSection.transfers: 'التحويلات',
      ReportSection.scrap: 'الكسر',
      ReportSection.vouchers: 'السندات',
      ReportSection.expenses: 'المصروفات',
      ReportSection.deposits: 'توريد للإدارة',
      ReportSection.imports: 'استيراد من الإدارة',
      ReportSection.safeTotals: 'إجماليات الصندوق',
      ReportSection.generalBalance: 'الرصيد العام',
    };
    const en = {
      ReportSection.openingBalance: 'Opening Balance',
      ReportSection.entry: 'Entry',
      ReportSection.missing: 'Missing',
      ReportSection.inventory: 'Inventory',
      ReportSection.updates: 'Updates',
      ReportSection.sales: 'Sales',
      ReportSection.sellersTotals: 'Sellers Totals',
      ReportSection.transfers: 'Transfers',
      ReportSection.scrap: 'Scrap',
      ReportSection.vouchers: 'Vouchers',
      ReportSection.expenses: 'Expenses',
      ReportSection.deposits: 'Deposits to Admin',
      ReportSection.imports: 'Imports from Admin',
      ReportSection.safeTotals: 'Safe Totals',
      ReportSection.generalBalance: 'General Balance',
    };
    return lang == 'ar' ? ar[this]! : en[this]!;
  }
}

class PdfReport {
  // ============================================================
  // Helpers
  // ============================================================
  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
              fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : null)),
    );
  }

  static pw.Widget _buildTotals(
    int count,
    int count18,
    int count21,
    int count22,
    int countBullion,
    int countGem,
    double weight,
    double wage,
    double cost,
    double weight18,
    double weight21,
    double weight22,
    double weightBullion,
  ) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Bullet(
              text: "إجمالي عدد الشرائح: $count",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text:
                  "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text:
                  "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text:
                  "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text:
                  "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text: "عدد الأحجار الكريمة : $countGem",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text: "إجمالي الوزن الكلي : ${weight.toStringAsFixed(2)}",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text: "إجمالي الأجر الكلي : ${wage.toStringAsFixed(2)}",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
          pw.Bullet(
              text: "إجمالي التكلفة الكلية : ${cost.toStringAsFixed(2)}",
              style: pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right),
        ],
      ),
    );
  }

  // ============================================================
  // General Balance PDF helpers
  // ============================================================
  static pw.Widget _gbSection(String title, List<pw.Widget> rows) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(title,
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start, children: rows),
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget _gbRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
          pw.Text(value,
              style:
                  pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static String _missingLine(dynamic m) {
    return "عدد ${m['c']} - وزن ${(m['w'] as double).toStringAsFixed(2)} جم - أجر ${(m['g'] as double).toStringAsFixed(2)}";
  }

  // ============================================================
  // Firestore getters
  // ============================================================
  static Future<List<Map<String, dynamic>>> getItemsByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getupdatesByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('items')
        .where('updatedAt', isGreaterThanOrEqualTo: start)
        .where('updatedAt', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getInventoriesByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('inventories')
        .where('lastSeenAt', isGreaterThanOrEqualTo: start)
        .where('lastSeenAt', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getSalesByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('sales')
        .where('soldAt', isGreaterThanOrEqualTo: start)
        .where('soldAt', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getBranchTransfersByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('branchTransfers')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('scrapTransactions')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getvouchersByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('vouchers')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getexpensesByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('expenses')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getmanagementDepositsByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('managementDeposits')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getmanagementImportedByDateRange(
      DateTime start, DateTime end) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('managementImported')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();
    return q.docs.map((d) {
      final data = d.data();
      data['id'] = d.id;
      return data;
    }).toList();
  }

  // ============================================================
  // General Balance snapshot (unfiltered)
  // ============================================================
  static Future<Map<String, dynamic>> _getGeneralBalanceSnapshot() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("⚠️ لم يتم تسجيل الدخول");

    final results = await Future.wait([
      FS.itemsCol().get(),
      FS.balancesCol().get(),
      FS.salesCol().get(),
      FS.scrapCol().get(),
      FS.vouchersCol().get(),
      FS.expensesCol().get(),
      FS.depositsCol().get(),
      FS.ImportedCol().get(),
      FS.invCol().get(),
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('setRemainders')
          .get(),
    ]);

    final itemsSnap = results[0];
    final balancesSnap = results[1];
    final salesSnap = results[2];
    final scrapAllSnap = results[3];
    final vouchersAllSnap = results[4];
    final expSnap = results[5];
    final depositSnap = results[6];
    final importSnap = results[7];
    final invSnap = results[8];
    final kitsSnap = results[9];

    double carat18 = 0, carat21 = 0, carat22 = 0, carat24 = 0;
    double bullionWeight = 0, bullionNotCounted = 0;
    int bullionCount = 0, stonesCount = 0;
    double stonesCost = 0, balancesWeight = 0;
    final balancesCount = balancesSnap.docs.length;
    final Map<String, int> deptCount = {};

    final allInventoryDocs = [...itemsSnap.docs, ...balancesSnap.docs];
    for (var doc in allInventoryDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>? ?? {};
      final isBalance = doc.reference.parent.id == 'balances';
      final weight = (payload['weight'] as num?)?.toDouble() ?? 0;
      if (isBalance) balancesWeight += weight;

      final caratInt = int.tryParse(payload['carat']?.toString() ?? '');
      final kind = payload['kind']?.toString();
      final type = payload['type']?.toString();
      final category = data['category']?.toString();

      if (category == 'bullion') {
        deptCount['سبائك'] = (deptCount['سبائك'] ?? 0) + 1;
        bullionCount++;
        bullionWeight += weight;
        if (caratInt == null || ![18, 21, 22, 24].contains(caratInt)) {
          bullionNotCounted += weight;
        }
      }
      if (kind != null) deptCount[kind] = (deptCount[kind] ?? 0) + 1;
      if (type != null) deptCount[type] = (deptCount[type] ?? 0) + 1;

      if (caratInt == 18)
        carat18 += weight;
      else if (caratInt == 21)
        carat21 += weight;
      else if (caratInt == 22)
        carat22 += weight;
      else if (caratInt == 24) carat24 += weight;

      if (category == 'gem') {
        stonesCount++;
        stonesCost += (payload['cost'] as num?)?.toDouble() ?? 0;
      }
    }
    // ✅ الحساب الصح (مطابق لـ _calculateScrapWeight24K في GeneralBalancePage)
    double scrap24K = 0;
    double scrapRaw = 0;

    const knownScrapTypes = ['add', 'sale', 'payment', 'transform'];
    const knownScrapCarats = ['14', '18', '21', '22', '24'];

    for (var d in scrapAllSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final type = (data['type'] as String?)?.trim().toLowerCase() ?? '';
      final weight = (data['weight'] as num?)?.toDouble() ?? 0;

      // --- 1) الوزن الخام (scrapRaw): add - sale فقط (زي Flutter بالظبط) ---
      if (type == 'add') {
        scrapRaw += weight;
      } else if (type == 'sale') {
        scrapRaw -= weight;
      }

      // --- 2) الوزن 24K (scrap24K): نفس منطق _calculateScrapWeight24K ---
      if (!knownScrapTypes.contains(type)) continue;

      // 🟢 معالجة خاصة لسندات الصرف اللي فيها carats array
      if (type == 'payment' &&
          data['carats'] != null &&
          (data['carats'] as List).isNotEmpty) {
        final carats = data['carats'] as List;
        for (var c in carats) {
          final carat = (c['carat'] ?? '18').toString();
          final w = (c['weight'] as num?)?.toDouble() ?? 0;
          final caratNum = double.tryParse(carat) ?? 18;
          scrap24K -= (w * caratNum / 24).abs();
        }
      } else {
        final carat = (data['carat'] ?? '18').toString();
        if (!knownScrapCarats.contains(carat)) continue;
        final caratNum = double.tryParse(carat) ?? 18;
        final w24 = weight * caratNum / 24;
        if (type == 'add' || type == 'transform') {
          scrap24K += w24;
        } else if (type == 'sale' || type == 'payment') {
          scrap24K -= w24.abs();
        }
      }
    }

    // double scrap24K = 0, scrapRaw = 0;
    // for (var d in scrapAllSnap.docs) {
    //   final data = d.data() as Map<String, dynamic>;
    //   final type = (data['type'] as String?)?.trim().toLowerCase() ?? '';
    //   final caratStr = data['carat']?.toString() ?? '18';
    //   final weight = (data['weight'] as num?)?.toDouble() ?? 0;
    //   final caratNum = double.tryParse(caratStr) ?? 18;
    //   final weight24 = weight * caratNum / 24;
    //   if (type == 'add' || type == 'transform') {
    //     scrap24K += weight24;
    //     scrapRaw += weight;
    //   } else if (type == 'sale' || type == 'payment') {
    //     scrap24K -= weight24;
    //     scrapRaw -= weight;
    //   }
    // }

    double sum = 0, cash = 0, visa = 0;
    for (var d in salesSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final p = data['payment'] as Map<String, dynamic>? ?? {};
      sum += (p['total'] as num?)?.toDouble() ?? 0;
      cash += (p['cash'] as num?)?.toDouble() ?? 0;
      visa += (p['visa'] as num?)?.toDouble() ?? 0;
    }
    for (var d in scrapAllSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final t = data['type'];
      final total = (data['total'] as num?)?.toDouble() ?? 0;
      final c = (data['cash'] as num?)?.toDouble() ?? 0;
      final v = (data['network'] as num?)?.toDouble() ?? 0;
      if (t == 'sale') {
        sum += total;
        cash += c;
        visa += v;
      } else if (t == 'add') {
        sum -= total;
        cash -= c;
        visa -= v;
      }
    }
    for (var d in vouchersAllSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      if (data['type'] == 'payment') {
        sum -= (data['total'] as num?)?.toDouble() ?? 0;
        cash -= (data['cash'] as num?)?.toDouble() ?? 0;
        visa -= (data['network'] as num?)?.toDouble() ?? 0;
      }
    }
    for (var d in expSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final amount = double.tryParse(data['amount']?.toString() ?? '0') ?? 0;
      sum -= amount;
      cash -= amount;
    }
    for (var d in depositSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final c = (data['cash'] as num?)?.toDouble() ?? 0;
      final v = (data['visa'] as num?)?.toDouble() ?? 0;
      sum -= (c + v);
      cash -= c;
      visa -= v;
    }
    for (var d in importSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final c = (data['cash'] as num?)?.toDouble() ?? 0;
      final v = (data['visa'] as num?)?.toDouble() ?? 0;
      sum += (c + v);
      cash += c;
      visa += v;
    }

    double safeCash = 0, safeNetwork = 0, safeGold24K = 0;
    try {
      final s = await FS.getCashBoxBalance();
      safeCash = (s['cash'] as num?)?.toDouble() ?? 0;
      safeNetwork = (s['network'] as num?)?.toDouble() ?? 0;
    } catch (_) {}
    try {
      final g = await FS.getSafeGoldSummary();
      safeGold24K = (g['total24K'] as num?)?.toDouble() ?? 0;
    } catch (_) {}

    double remainingKits = 0;
    for (var d in kitsSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final p = data['payload'] as Map<String, dynamic>? ?? {};
      final orig = (p['originalWeight'] as num?)?.toDouble() ??
          (p['weight'] as num?)?.toDouble() ??
          0;
      final sold = (p['soldWeight'] as num?)?.toDouble() ?? 0;
      if (orig - sold > 0) remainingKits += orig - sold;
    }

    final invIds = invSnap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      return data['epcHex'] ?? data['id'];
    }).toSet();

    int m18 = 0, m21 = 0, m22 = 0, mGem = 0, mBull = 0;
    double mW18 = 0, mW21 = 0, mW22 = 0, mWBull = 0;
    double mG18 = 0, mG21 = 0, mG22 = 0, mGBull = 0, mCGem = 0;

    for (var doc in allInventoryDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final id = data['epcHex'] ?? data['id'];
      if (invIds.contains(id)) continue;
      final p = data['payload'] as Map<String, dynamic>? ?? {};
      final cat = data['category']?.toString() ?? 'gold';
      final w = (p['weight'] as num?)?.toDouble() ?? 0;
      final g = (p['wage'] as num?)?.toDouble() ?? 0;
      final c = (p['cost'] as num?)?.toDouble() ?? 0;
      final cr = p['carat']?.toString();
      if (cat == 'gold') {
        if (cr == '18') {
          m18++;
          mW18 += w;
          mG18 += g;
        } else if (cr == '21') {
          m21++;
          mW21 += w;
          mG21 += g;
        } else if (cr == '22') {
          m22++;
          mW22 += w;
          mG22 += g;
        }
      } else if (cat == 'bullion') {
        mBull++;
        mWBull += w;
        mGBull += g;
      } else if (cat == 'gem') {
        mGem++;
        mCGem += c;
      }
    }

    final now = DateTime.now();
    double mSupply = 0, mImport = 0, mExpenses = 0;
    for (var d in depositSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final dt = (data['date'] as Timestamp?)?.toDate();
      if (dt != null && dt.month == now.month && dt.year == now.year) {
        mSupply += ((data['cash'] as num?)?.toDouble() ?? 0) +
            ((data['visa'] as num?)?.toDouble() ?? 0);
      }
    }
    for (var d in importSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final dt = (data['date'] as Timestamp?)?.toDate();
      if (dt != null && dt.month == now.month && dt.year == now.year) {
        mImport += ((data['cash'] as num?)?.toDouble() ?? 0) +
            ((data['visa'] as num?)?.toDouble() ?? 0);
      }
    }
    for (var d in expSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final dt = (data['date'] as Timestamp?)?.toDate();
      if (dt != null && dt.month == now.month && dt.year == now.year) {
        mExpenses += double.tryParse(data['amount']?.toString() ?? '0') ?? 0;
      }
    }

    final carat24K =
        carat18 * 18 / 24 + carat21 * 21 / 24 + carat22 * 22 / 24 + carat24;
    final total24K = carat24K + scrap24K + bullionNotCounted - safeGold24K;
    final total21K = total24K * 24 / 21;

    final Map<String, Map<String, double>> sellers = {};
    for (var d in salesSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final p = data['payment'] as Map<String, dynamic>? ?? {};
      final soldBy = p['soldBy']?.toString() ?? 'غير معروف';
      sellers.putIfAbsent(soldBy, () => {'total': 0, 'cash': 0, 'visa': 0});
      sellers[soldBy]!['total'] =
          sellers[soldBy]!['total']! + ((p['total'] as num?)?.toDouble() ?? 0);
      sellers[soldBy]!['cash'] =
          sellers[soldBy]!['cash']! + ((p['cash'] as num?)?.toDouble() ?? 0);
      sellers[soldBy]!['visa'] =
          sellers[soldBy]!['visa']! + ((p['visa'] as num?)?.toDouble() ?? 0);
    }

    return {
      'totalWeight21K': total21K,
      'totalWeight24K': total24K,
      'gold24K': carat24K,
      'scrap24K': scrap24K,
      'bullion24K': bullionNotCounted,
      'carat18': carat18,
      'carat21': carat21,
      'carat22': carat22,
      'carat24': carat24,
      'total': sum - (safeCash + safeNetwork),
      'cash': cash - safeCash,
      'visa': visa - safeNetwork,
      'safeCash': safeCash,
      'safeNetwork': safeNetwork,
      'safeGold24K': safeGold24K,
      'remainingKits': remainingKits,
      'scrapRaw': scrapRaw,
      'bullionWeight': bullionWeight,
      'bullionCount': bullionCount,
      'stonesCount': stonesCount,
      'stonesCost': stonesCost,
      'balancesWeight': balancesWeight,
      'balancesCount': balancesCount,
      'deptCount': deptCount,
      'missing': {
        '18': {'c': m18, 'w': mW18, 'g': mG18},
        '21': {'c': m21, 'w': mW21, 'g': mG21},
        '22': {'c': m22, 'w': mW22, 'g': mG22},
        'bull': {'c': mBull, 'w': mWBull, 'g': mGBull},
        'gem': {'c': mGem, 'cost': mCGem},
      },
      'monthlySupply': mSupply,
      'monthlyImport': mImport,
      'monthlyExpenses': mExpenses,
      'sellers': sellers,
    };
  }

  // ============================================================
  // General Balance page builder → returns pw.MultiPage (NOT pw.Widget)
  // ============================================================
  // static pw.MultiPage _buildGeneralBalancePage(Map<String, dynamic> gb) {
  //   return pw.MultiPage(
  //     pageFormat: PdfPageFormat.a4,
  //     textDirection: pw.TextDirection.rtl,
  //         theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold), // ✅ السطر الناقص

  //     build: (context) => [
  //       pw.Text("تقرير الرصيد العام",
  //           style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
  //       pw.SizedBox(height: 6),
  //       pw.Text("حالة حالية (غير مفلترة بالتاريخ)",
  //           style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
  //       pw.SizedBox(height: 12),
  //       _gbSection("إجمالي الوزن العام", [
  //         _gbRow("بالعيار 21",
  //             "${(gb['totalWeight21K'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("بالعيار 24",
  //             "${(gb['totalWeight24K'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("  • ذهب (24K)",
  //             "${(gb['gold24K'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("  • كسر (24K)",
  //             "${(gb['scrap24K'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("  • سبائك (24K)",
  //             "${(gb['bullion24K'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("  • خزنة (مخصوم)",
  //             "${(gb['safeGold24K'] as double).toStringAsFixed(3)} جم"),
  //       ]),
  //       _gbSection("الصندوق", [
  //         _gbRow(
  //             "الإجمالي", "${(gb['total'] as double).toStringAsFixed(2)} ريال"),
  //         _gbRow("كاش", "${(gb['cash'] as double).toStringAsFixed(2)} ريال"),
  //         _gbRow("شبكة", "${(gb['visa'] as double).toStringAsFixed(2)} ريال"),
  //         _gbRow("  • خزنة كاش (مخصوم)",
  //             "${(gb['safeCash'] as double).toStringAsFixed(2)}"),
  //         _gbRow("  • خزنة شبكة (مخصوم)",
  //             "${(gb['safeNetwork'] as double).toStringAsFixed(2)}"),
  //       ]),
  //       _gbSection("أوزان معلقة وكسر", [
  //         _gbRow("الوزن المعلق (بقايا أطقم)",
  //             "${(gb['remainingKits'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow("وزن الكسر الخام",
  //             "${(gb['scrapRaw'] as double).toStringAsFixed(2)} جم"),
  //         _gbRow("وزن الكسر (24K)",
  //             "${(gb['scrap24K'] as double).toStringAsFixed(3)} جم"),
  //       ]),
  //       _gbSection("توزيع العيارات (وزن خام)", [
  //         _gbRow(
  //             "عيار 18", "${(gb['carat18'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow(
  //             "عيار 21", "${(gb['carat21'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow(
  //             "عيار 22", "${(gb['carat22'] as double).toStringAsFixed(3)} جم"),
  //         _gbRow(
  //             "عيار 24", "${(gb['carat24'] as double).toStringAsFixed(3)} جم"),
  //       ]),
  //       _gbSection("السبائك / الأحجار / الأرصدة", [
  //         _gbRow("السبائك",
  //             "${(gb['bullionWeight'] as double).toStringAsFixed(2)} جم (عدد ${gb['bullionCount']})"),
  //         _gbRow("الأحجار",
  //             "عدد ${gb['stonesCount']} - تكلفة ${(gb['stonesCost'] as double).toStringAsFixed(2)}"),
  //         _gbRow("الأرصدة الجزئية",
  //             "${(gb['balancesWeight'] as double).toStringAsFixed(2)} جم (عدد ${gb['balancesCount']})"),
  //       ]),
  //       _gbSection(
  //           "أقسام المخزون",
  //           (gb['deptCount'] as Map<String, int>)
  //               .entries
  //               .map((e) => _gbRow(e.key, "${e.value}"))
  //               .toList()),
  //       _gbSection("المفقود (غير موجود في الجرد)", [
  //         _gbRow("عيار 18", _missingLine(gb['missing']['18'])),
  //         _gbRow("عيار 21", _missingLine(gb['missing']['21'])),
  //         _gbRow("عيار 22", _missingLine(gb['missing']['22'])),
  //         _gbRow("سبائك", _missingLine(gb['missing']['bull'])),
  //         _gbRow("أحجار",
  //             "عدد ${gb['missing']['gem']['c']} - تكلفة ${(gb['missing']['gem']['cost'] as double).toStringAsFixed(2)}"),
  //       ]),
  //       _gbSection("حركة الشهر الحالي", [
  //         _gbRow("توريدات للإدارة",
  //             "${(gb['monthlySupply'] as double).toStringAsFixed(2)} ريال"),
  //         _gbRow("استيرادات من الإدارة",
  //             "${(gb['monthlyImport'] as double).toStringAsFixed(2)} ريال"),
  //         _gbRow("المصروفات",
  //             "${(gb['monthlyExpenses'] as double).toStringAsFixed(2)} ريال"),
  //       ]),
  //       if ((gb['sellers'] as Map).isNotEmpty) ...[
  //         pw.SizedBox(height: 12),
  //         pw.Text("إجماليات البائعين (تراكمي)",
  //             style:
  //                 pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
  //         pw.SizedBox(height: 6),
  //         pw.Table(
  //           border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
  //           columnWidths: const {
  //             0: pw.FlexColumnWidth(3),
  //             1: pw.FlexColumnWidth(2),
  //             2: pw.FlexColumnWidth(2),
  //             3: pw.FlexColumnWidth(2),
  //           },
  //           children: [
  //             pw.TableRow(
  //               decoration: const pw.BoxDecoration(color: PdfColors.grey200),
  //               children: [
  //                 _cell("البائع", bold: true),
  //                 _cell("الإجمالي", bold: true),
  //                 _cell("كاش", bold: true),
  //                 _cell("شبكة", bold: true),
  //               ],
  //             ),
  //             ...(gb['sellers'] as Map<String, Map<String, double>>)
  //                 .entries
  //                 .map(
  //                   (e) => pw.TableRow(children: [
  //                     _cell(e.key),
  //                     _cell(e.value['total']!.toStringAsFixed(2)),
  //                     _cell(e.value['cash']!.toStringAsFixed(2)),
  //                     _cell(e.value['visa']!.toStringAsFixed(2)),
  //                   ]),
  //                 ),
  //           ],
  //         ),
  //       ],
  //     ],
  //   );
  // }

  // ============================================================
// General Balance page builder
// ============================================================
  static pw.MultiPage _buildGeneralBalancePage(
    Map<String, dynamic> gb,
    pw.Font arabicFont,
    pw.Font arabicFontBold,
  ) {
    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(
          base: arabicFont, bold: arabicFontBold), // ✅ السطر الناقص
      build: (context) => [
        pw.Text("تقرير الرصيد العام",
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        pw.Text("حالة حالية (غير مفلترة بالتاريخ)",
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 12),
        _gbSection("إجمالي الوزن العام", [
          _gbRow("بالعيار 21",
              "${(gb['totalWeight21K'] as double).toStringAsFixed(3)} جم"),
          _gbRow("بالعيار 24",
              "${(gb['totalWeight24K'] as double).toStringAsFixed(3)} جم"),
          _gbRow("  • ذهب (24K)",
              "${(gb['gold24K'] as double).toStringAsFixed(3)} جم"),
          _gbRow("  • كسر (24K)",
              "${(gb['scrap24K'] as double).toStringAsFixed(3)} جم"),
          _gbRow("  • سبائك (24K)",
              "${(gb['bullion24K'] as double).toStringAsFixed(3)} جم"),
          _gbRow("  • خزنة (مخصوم)",
              "${(gb['safeGold24K'] as double).toStringAsFixed(3)} جم"),
        ]),
        _gbSection("الصندوق", [
          _gbRow(
              "الإجمالي", "${(gb['total'] as double).toStringAsFixed(2)} ريال"),
          _gbRow("كاش", "${(gb['cash'] as double).toStringAsFixed(2)} ريال"),
          _gbRow("شبكة", "${(gb['visa'] as double).toStringAsFixed(2)} ريال"),
          _gbRow("  • خزنة كاش (مخصوم)",
              "${(gb['safeCash'] as double).toStringAsFixed(2)}"),
          _gbRow("  • خزنة شبكة (مخصوم)",
              "${(gb['safeNetwork'] as double).toStringAsFixed(2)}"),
        ]),
        _gbSection("أوزان معلقة وكسر", [
          _gbRow("الوزن المعلق (بقايا أطقم)",
              "${(gb['remainingKits'] as double).toStringAsFixed(3)} جم"),
          _gbRow("وزن الكسر الخام",
              "${(gb['scrapRaw'] as double).toStringAsFixed(2)} جم"),
          _gbRow("وزن الكسر (24K)",
              "${(gb['scrap24K'] as double).toStringAsFixed(3)} جم"),
        ]),
        _gbSection("توزيع العيارات (وزن خام)", [
          _gbRow(
              "عيار 18", "${(gb['carat18'] as double).toStringAsFixed(3)} جم"),
          _gbRow(
              "عيار 21", "${(gb['carat21'] as double).toStringAsFixed(3)} جم"),
          _gbRow(
              "عيار 22", "${(gb['carat22'] as double).toStringAsFixed(3)} جم"),
          _gbRow(
              "عيار 24", "${(gb['carat24'] as double).toStringAsFixed(3)} جم"),
        ]),
        _gbSection("السبائك / الأحجار / الأرصدة", [
          _gbRow("السبائك",
              "${(gb['bullionWeight'] as double).toStringAsFixed(2)} جم (عدد ${gb['bullionCount']})"),
          _gbRow("الأحجار",
              "عدد ${gb['stonesCount']} - تكلفة ${(gb['stonesCost'] as double).toStringAsFixed(2)}"),
          _gbRow("الأرصدة الجزئية",
              "${(gb['balancesWeight'] as double).toStringAsFixed(2)} جم (عدد ${gb['balancesCount']})"),
        ]),
        _gbSection(
            "أقسام المخزون",
            (gb['deptCount'] as Map<String, int>)
                .entries
                .map((e) => _gbRow(e.key, "${e.value}"))
                .toList()),
      ],
    );
  }

  // ============================================================
  // Reusable table helpers
  // ============================================================
  static pw.Widget _buildCodeWidget(Map<String, dynamic> payload) {
    if (payload['qrCode'] != null) {
      if (payload['showQr'] == true) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
            pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: payload['qrCode'],
                width: 20,
                height: 20),
            pw.SizedBox(height: 1),
            pw.Text(payload['qrCode']?.toString() ?? "—",
                style: const pw.TextStyle(fontSize: 6)),
          ]),
        );
      } else {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
            pw.BarcodeWidget(
                barcode: pw.Barcode.code128(),
                data: payload['qrCode'],
                width: 40,
                height: 15,
                drawText: false),
            pw.SizedBox(height: 1),
            pw.Text(payload['qrCode']?.toString() ?? "—",
                style: const pw.TextStyle(fontSize: 6)),
          ]),
        );
      }
    }
    return pw.Text("—", textAlign: pw.TextAlign.center);
  }

  static pw.Widget _buildItemTable({
    required List<Map<String, dynamic>> items,
    required String dateField,
    required String headerLast,
    String dateHeader = "تاريخ",
    required pw.Widget totalsWidget,
  }) {
    return pw.Column(children: [
      pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        columnWidths: const {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(1),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(1.5),
          4: pw.FlexColumnWidth(1.5),
          5: pw.FlexColumnWidth(0.8),
          6: pw.FlexColumnWidth(1.2),
          7: pw.FlexColumnWidth(1.2),
          8: pw.FlexColumnWidth(1.5),
          9: pw.FlexColumnWidth(1.5),
        },
        children: [
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfColors.grey300),
            children: [
              "كود",
              "نوع",
              dateHeader,
              "وزن",
              "أجر",
              "عيار",
              "قطعة",
              "تكلفة",
              "مكونات",
              "ملاحظات"
            ]
                .map((e) => pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(e,
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center)))
                .toList(),
          ),
          ...items.map((item) {
            final date = item[dateField] is Timestamp
                ? (item[dateField] as Timestamp).toDate()
                : item[dateField];
            final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
            return pw.TableRow(children: [
              _buildCodeWidget(payload),
              pw.Text(translateCategory(item['category']),
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(
                  date != null ? DateFormat('yyyy/MM/dd').format(date) : "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['weight']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['wage']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['carat']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(
                  payload['type']?.toString().isNotEmpty == true
                      ? payload['type'].toString()
                      : (payload['kind']?.toString().isNotEmpty == true
                          ? payload['kind'].toString()
                          : "—"),
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['cost']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['setComponents']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
              pw.Text(payload['notes']?.toString() ?? "—",
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
            ]);
          }),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Text(headerLast,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      totalsWidget,
    ]);
  }

  static pw.Widget _buildSimpleMoneyTable(List<Map<String, dynamic>> items) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(1.5),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
              .map((e) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text(e,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center)))
              .toList(),
        ),
        ...items.map((item) {
          final date = item['date'] is Timestamp
              ? (item['date'] as Timestamp).toDate()
              : item['date'];
          return pw.TableRow(children: [
            pw.Text(item['type']?.toString() ?? "—",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8)),
            pw.Text(date != null ? DateFormat('yyyy/MM/dd').format(date) : "—",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8)),
            pw.Text(item['cash']?.toString() ?? "—",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8)),
            pw.Text(item['visa']?.toString() ?? "—",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8)),
            pw.Text(item['total']?.toString() ?? "—",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8)),
          ]);
        }),
      ],
    );
  }

  // ============================================================
  // generatePdfReport
  // ============================================================
  static Future<Uint8List> generatePdfReport(
      List<Map<String, dynamic>> items,
      List<Map<String, dynamic>> inventories,
      List<Map<String, dynamic>> sales,
      List<Map<String, dynamic>> branchTransfers,
      List<Map<String, dynamic>> updates,
      List<Map<String, dynamic>> scrapTransactions,
      List<Map<String, dynamic>> vouchers,
      List<Map<String, dynamic>> expenses,
      List<Map<String, dynamic>> managementDeposits,
      List<Map<String, dynamic>> managementImported,
      DateTime start,
      DateTime end,
      {Set<ReportSection>? sections}) async {
    final allowed = sections ?? ReportSection.values.toSet();
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    int totalCount = 0;
    double totalWeight = 0, totalWage = 0, totalCost = 0;
    int openingCount = 0;
    double openingWeight = 0, openingWage = 0, openingCost = 0;
    int updatedCount = 0;
    double updatedWeight = 0, updatedWage = 0, updatedCost = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;
    int opening18 = 0,
        opening21 = 0,
        opening22 = 0,
        openingBullion = 0,
        openingGem = 0;
    double openingWeight18 = 0,
        openingWeight21 = 0,
        openingWeight22 = 0,
        openingWeightBullion = 0;
    int updated18 = 0,
        updated21 = 0,
        updated22 = 0,
        updatedBullion = 0,
        updatedGem = 0;
    double updatedWeight18 = 0,
        updatedWeight21 = 0,
        updatedWeight22 = 0,
        updatedWeightBullion = 0;

    for (var item in items) {
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      final fromOpening = item['fromOpeningBalance'] == true;
      if (fromOpening) {
        openingCount++;
        openingWeight += weight;
        openingWage += wage;
        openingCost += cost;
        if (carat == "18") {
          opening18++;
          openingWeight18 += weight;
        }
        if (carat == "21") {
          opening21++;
          openingWeight21 += weight;
        }
        if (carat == "22") {
          opening22++;
          openingWeight22 += weight;
        }
        if (category == "bullion") {
          openingBullion++;
          openingWeightBullion += weight;
        }
        if (category == "gem") {
          openingGem++;
        }
      } else {
        totalCount++;
        totalWeight += weight;
        totalWage += wage;
        totalCost += cost;
        if (carat == "18") {
          count18++;
          weight18 += weight;
        }
        if (carat == "21") {
          count21++;
          weight21 += weight;
        }
        if (carat == "22") {
          count22++;
          weight22 += weight;
        }
        if (category == "bullion") {
          countBullion++;
          weightBullion += weight;
        }
        if (category == "gem") {
          countGem++;
        }
      }
    }
    for (var update in updates) {
      final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = update['category']?.toString();
      if (update['updatedAt'] != null) {
        updatedCount++;
        updatedWeight += weight;
        updatedWage += wage;
        updatedCost += cost;
        if (carat == "18") {
          updated18++;
          updatedWeight18 += weight;
        }
        if (carat == "21") {
          updated21++;
          updatedWeight21 += weight;
        }
        if (carat == "22") {
          updated22++;
          updatedWeight22 += weight;
        }
        if (category == "bullion") {
          updatedBullion++;
          updatedWeightBullion += weight;
        }
        if (category == "gem") {
          updatedGem++;
        }
      }
    }

    int invTotalCount = inventories.length;
    double invTotalWeight = 0, invTotalWage = 0, invTotalCost = 0;
    int invCount18 = 0,
        invCount21 = 0,
        invCount22 = 0,
        invCountBullion = 0,
        invCountGem = 0;
    double invWeight18 = 0,
        invWeight21 = 0,
        invWeight22 = 0,
        invWeightBullion = 0;
    for (var inv in inventories) {
      final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      invTotalWeight += weight;
      invTotalWage += wage;
      invTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = inv['category']?.toString();
      if (carat == "18") {
        invCount18++;
        invWeight18 += weight;
      }
      if (carat == "21") {
        invCount21++;
        invWeight21 += weight;
      }
      if (carat == "22") {
        invCount22++;
        invWeight22 += weight;
      }
      if (category == "bullion") {
        invCountBullion++;
        invWeightBullion += weight;
      }
      if (category == "gem") {
        invCountGem++;
      }
    }

    final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();
    final missingItems = items.where((item) {
      final id = item['epcHex'] ?? item['id'];
      return !invIds.contains(id);
    }).toList();

    int missingCount = 0;
    double missingWeight = 0, missingWage = 0, missingCost = 0;
    int missing18 = 0,
        missing21 = 0,
        missing22 = 0,
        missingBullion = 0,
        missingGem = 0;
    double missingWeight18 = 0,
        missingWeight21 = 0,
        missingWeight22 = 0,
        missingWeightBullion = 0;
    for (var item in missingItems) {
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      missingCount++;
      missingWeight += weight;
      missingWage += wage;
      missingCost += cost;
      if (carat == "18") {
        missing18++;
        missingWeight18 += weight;
      }
      if (carat == "21") {
        missing21++;
        missingWeight21 += weight;
      }
      if (carat == "22") {
        missing22++;
        missingWeight22 += weight;
      }
      if (category == "bullion") {
        missingBullion++;
        missingWeightBullion += weight;
      }
      if (category == "gem") {
        missingGem++;
      }
    }

    int salesTotalCount = sales.length;
    double salesTotalWeight = 0, salesTotalWage = 0, salesTotalCost = 0;
    int salesCount18 = 0,
        salesCount21 = 0,
        salesCount22 = 0,
        salesCountBullion = 0,
        salesCountGem = 0;
    double salesWeight18 = 0,
        salesWeight21 = 0,
        salesWeight22 = 0,
        salesWeightBullion = 0;
    for (var sale in sales) {
      final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      salesTotalWeight += weight;
      salesTotalWage += wage;
      salesTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = sale['category']?.toString();
      if (carat == "18") {
        salesCount18++;
        salesWeight18 += weight;
      }
      if (carat == "21") {
        salesCount21++;
        salesWeight21 += weight;
      }
      if (carat == "22") {
        salesCount22++;
        salesWeight22 += weight;
      }
      if (category == "bullion") {
        salesCountBullion++;
        salesWeightBullion += weight;
      }
      if (category == "gem") {
        salesCountGem++;
      }
    }

    int branchTransfersTotalCount = branchTransfers.length;
    double branchTransfersTotalWeight = 0,
        branchTransfersTotalWage = 0,
        branchTransfersTotalCost = 0;
    int branchTransfersCount18 = 0,
        branchTransfersCount21 = 0,
        branchTransfersCount22 = 0,
        branchTransfersCountBullion = 0,
        branchTransfersCountGem = 0;
    double branchTransfersWeight18 = 0,
        branchTransfersWeight21 = 0,
        branchTransfersWeight22 = 0,
        branchTransfersWeightBullion = 0;
    for (var branchTransfer in branchTransfers) {
      final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      branchTransfersTotalWeight += weight;
      branchTransfersTotalWage += wage;
      branchTransfersTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = branchTransfer['category']?.toString();
      if (carat == "18") {
        branchTransfersCount18++;
        branchTransfersWeight18 += weight;
      }
      if (carat == "21") {
        branchTransfersCount21++;
        branchTransfersWeight21 += weight;
      }
      if (carat == "22") {
        branchTransfersCount22++;
        branchTransfersWeight22 += weight;
      }
      if (category == "bullion") {
        branchTransfersCountBullion++;
        branchTransfersWeightBullion += weight;
      }
      if (category == "gem") {
        branchTransfersCountGem++;
      }
    }

    int scrapTransactionsTotalCount = 0;
    double scrapTransactionsTotalWeight = 0,
        scrapTransactionsTotalcash = 0,
        scrapTransactionsTotalnetwork = 0,
        scrapTransactionsTotaltotal = 0;
    int scrapTransactionsCount18 = 0,
        scrapTransactionsCount14 = 0,
        scrapTransactionsCount24 = 0,
        scrapTransactionsCount21 = 0,
        scrapTransactionsCount22 = 0;
    double scrapTransactionsWeight18 = 0,
        scrapTransactionsWeight14 = 0,
        scrapTransactionsWeight24 = 0,
        scrapTransactionsWeight21 = 0,
        scrapTransactionsWeight22 = 0;
    for (var scrapTransaction in scrapTransactions) {
      final weight =
          double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
      final cash =
          double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;
      final carat = scrapTransaction['carat']?.toString();
      final type =
          scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';
      if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
        scrapTransactionsTotalCount += 1;
        scrapTransactionsTotalWeight += weight;
        scrapTransactionsTotalcash += cash;
        scrapTransactionsTotalnetwork += network;
        scrapTransactionsTotaltotal += total;
        if (carat == "14") {
          scrapTransactionsCount14++;
          scrapTransactionsWeight14 += weight;
        }
        if (carat == "18") {
          scrapTransactionsCount18++;
          scrapTransactionsWeight18 += weight;
        }
        if (carat == "21") {
          scrapTransactionsCount21++;
          scrapTransactionsWeight21 += weight;
        }
        if (carat == "22") {
          scrapTransactionsCount22++;
          scrapTransactionsWeight22 += weight;
        }
        if (carat == "24") {
          scrapTransactionsCount24++;
          scrapTransactionsWeight24 += weight;
        }
      }
    }

    int vouchersTotalCount = 0,
        voucherspaymentCount = 0,
        vouchersreceiptCount = 0;
    double vouchersTotalWeight = 0,
        vouchersTotalcash = 0,
        vouchersTotalnetwork = 0,
        vouchersTotaltotal = 0;
    int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;
    double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;
    for (var voucher in vouchers) {
      final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
      final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
      final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;
      final carat = voucher['carat']?.toString();
      final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
      vouchersTotalCount += 1;
      if (type == 'payment') {
        voucherspaymentCount += 1;
        vouchersTotalWeight += weight;
        vouchersTotalcash += cash;
        vouchersTotalnetwork += network;
        vouchersTotaltotal += total;
        if (carat == "18") {
          vouchersCount18++;
          vouchersWeight18 += weight;
        }
        if (carat == "21") {
          vouchersCount21++;
          vouchersWeight21 += weight;
        }
        if (carat == "22") {
          vouchersCount22++;
          vouchersWeight22 += weight;
        }
      } else if (type == 'receipt') {
        vouchersreceiptCount += 1;
        vouchersTotalWeight -= weight;
        vouchersTotalcash -= cash;
        vouchersTotalnetwork -= network;
        vouchersTotaltotal -= total;
        if (carat == "18") {
          vouchersCount18++;
          vouchersWeight18 -= weight;
        }
        if (carat == "21") {
          vouchersCount21++;
          vouchersWeight21 -= weight;
        }
        if (carat == "22") {
          vouchersCount22++;
          vouchersWeight22 -= weight;
        }
      }
    }

    int expensesTotalCount = 0;
    double expensesTotal = 0;
    for (var expense in expenses) {
      final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
      expensesTotal += amount;
      expensesTotalCount += 1;
    }

    int managementDepositsTotalCount = 0;
    double managementDepositsTotalcash = 0,
        managementDepositsTotalnetwork = 0,
        managementDepositsTotaltotal = 0;
    for (var managementDeposit in managementDeposits) {
      managementDepositsTotalCount += 1;
      managementDepositsTotalcash +=
          double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
      managementDepositsTotalnetwork +=
          double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
      managementDepositsTotaltotal +=
          double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
    }

    int managementImportedTotalCount = 0;
    double managementImportedTotalcash = 0,
        managementImportedTotalnetwork = 0,
        managementImportedTotaltotal = 0;
    for (var managementImport in managementImported) {
      managementImportedTotalCount += 1;
      managementImportedTotalcash +=
          double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
      managementImportedTotalnetwork +=
          double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
      managementImportedTotaltotal +=
          double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
    }

    final Map<String, Map<String, double>> sellersTotals = {};
    for (var sale in sales) {
      final payment = sale['payment'] as Map<String, dynamic>? ?? {};
      final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';
      final total = (payment['total'] ?? 0).toDouble();
      final cash = (payment['cash'] ?? 0).toDouble();
      final visa = (payment['visa'] ?? 0).toDouble();
      sellersTotals.putIfAbsent(
          soldBy, () => {'total': 0, 'cash': 0, 'visa': 0});
      sellersTotals[soldBy]!['total'] =
          sellersTotals[soldBy]!['total']! + total;
      sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
      sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
    }

    final image = pw.MemoryImage(
      (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
    );

    // Cover (always)
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
      build: (context) {
        final pageWidth = PdfPageFormat.a4.width;
        final pageHeight = PdfPageFormat.a4.height;
        return pw.Stack(children: [
          pw.Container(
            width: pageWidth,
            height: pageHeight,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.amber600, width: 3),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(image, width: 60, height: 60),
                pw.SizedBox(height: 10),
                pw.Text("تقارير المخزون",
                    style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black),
                    textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 6),
                pw.Container(
                    height: 2,
                    width: pageWidth * 0.4,
                    color: PdfColors.amber600),
                pw.SizedBox(height: 20),
                pw.Text(
                  "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
                  "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ]);
      },
    ));

    if (allowed.contains(ReportSection.openingBalance)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الرصيد الافتتاحي",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: items.where((e) => e['fromOpeningBalance'] == true).toList(),
            dateField: 'date',
            headerLast: "إجماليات الرصيد الافتتاحي",
            totalsWidget: _buildTotals(
                openingCount,
                opening18,
                opening21,
                opening22,
                openingBullion,
                openingGem,
                openingWeight,
                openingWage,
                openingCost,
                openingWeight18,
                openingWeight21,
                openingWeight22,
                openingWeightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.entry)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الإدخال",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: items.where((e) => e['fromOpeningBalance'] != true).toList(),
            dateField: 'date',
            headerLast: "إجماليات الإدخال",
            totalsWidget: _buildTotals(
                totalCount,
                count18,
                count21,
                count22,
                countBullion,
                countGem,
                totalWeight,
                totalWage,
                totalCost,
                weight18,
                weight21,
                weight22,
                weightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.missing)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول المفقود",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: missingItems,
            dateField: 'date',
            headerLast: "إجماليات المفقود",
            totalsWidget: _buildTotals(
                missingCount,
                missing18,
                missing21,
                missing22,
                missingBullion,
                missingGem,
                missingWeight,
                missingWage,
                missingCost,
                missingWeight18,
                missingWeight21,
                missingWeight22,
                missingWeightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.inventory)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الجرد",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: inventories,
            dateField: 'lastSeenAt',
            headerLast: "إجماليات الجرد",
            dateHeader: "آخر ظهور",
            totalsWidget: _buildTotals(
                invTotalCount,
                invCount18,
                invCount21,
                invCount22,
                invCountBullion,
                invCountGem,
                invTotalWeight,
                invTotalWage,
                invTotalCost,
                invWeight18,
                invWeight21,
                invWeight22,
                invWeightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.updates)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول التعديلات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: updates.where((e) => e['updatedAt'] != null).toList(),
            dateField: 'updatedAt',
            headerLast: "إجماليات التعديلات",
            totalsWidget: _buildTotals(
                updatedCount,
                updated18,
                updated21,
                updated22,
                updatedBullion,
                updatedGem,
                updatedWeight,
                updatedWage,
                updatedCost,
                updatedWeight18,
                updatedWeight21,
                updatedWeight22,
                updatedWeightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.sales)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول المبيعات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(1.9),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1.5),
              4: pw.FlexColumnWidth(1.5),
              5: pw.FlexColumnWidth(1),
              6: pw.FlexColumnWidth(1.5),
              7: pw.FlexColumnWidth(1.7),
              8: pw.FlexColumnWidth(1.5),
              9: pw.FlexColumnWidth(1.5),
              10: pw.FlexColumnWidth(1.5),
              11: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "مستخدم",
                  "نوع",
                  "تاريخ",
                  "وزن",
                  "عيار",
                  "قطعة",
                  "مكونات",
                  "كاش",
                  "شبكة",
                  "اجمالي",
                  "ملاحظات"
                ]
                    .map((e) => pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center)))
                    .toList(),
              ),
              ...sales.map((sale) {
                final date = sale['soldAt'] is Timestamp
                    ? (sale['soldAt'] as Timestamp).toDate()
                    : sale['soldAt'];
                final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
                final payment = (sale['payment'] ?? {}) as Map<String, dynamic>;
                return pw.TableRow(children: [
                  _buildCodeWidget(payload),
                  pw.Text(payment['soldBy']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(translateCategory(sale['category']),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payload['weight']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payload['carat']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                      payload['type']?.toString().isNotEmpty == true
                          ? payload['type'].toString()
                          : (payload['kind']?.toString().isNotEmpty == true
                              ? payload['kind'].toString()
                              : "—"),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payload['setComponents']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payment['cash']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payment['visa']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payment['total']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(payload['notes']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                ]);
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات المبيعات",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          _buildTotals(
              salesTotalCount,
              salesCount18,
              salesCount21,
              salesCount22,
              salesCountBullion,
              salesCountGem,
              salesTotalWeight,
              salesTotalWage,
              salesTotalCost,
              salesWeight18,
              salesWeight21,
              salesWeight22,
              salesWeightBullion),
        ],
      ));
    }

    if (allowed.contains(ReportSection.sellersTotals)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text("إجماليات البائعين",
              style:
                  pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cell("البائع", bold: true),
                    _cell("الإجمالي", bold: true),
                    _cell("كاش", bold: true),
                    _cell("شبكة", bold: true)
                  ]),
              ...sellersTotals.entries.map((e) => pw.TableRow(children: [
                    _cell(e.key),
                    _cell(e.value['total']!.toStringAsFixed(2)),
                    _cell(e.value['cash']!.toStringAsFixed(2)),
                    _cell(e.value['visa']!.toStringAsFixed(2)),
                  ])),
            ],
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.transfers)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول التحويلات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildItemTable(
            items: branchTransfers,
            dateField: 'date',
            headerLast: "إجماليات التحويلات",
            totalsWidget: _buildTotals(
                branchTransfersTotalCount,
                branchTransfersCount18,
                branchTransfersCount21,
                branchTransfersCount22,
                branchTransfersCountBullion,
                branchTransfersCountGem,
                branchTransfersTotalWeight,
                branchTransfersTotalWage,
                branchTransfersTotalCost,
                branchTransfersWeight18,
                branchTransfersWeight21,
                branchTransfersWeight22,
                branchTransfersWeightBullion),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.scrap)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الكسر",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(1.5),
              5: pw.FlexColumnWidth(1.5),
              6: pw.FlexColumnWidth(1.5),
              7: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    "نوع",
                    "تاريخ",
                    "عيار",
                    "وزن",
                    "كاش",
                    "شبكة",
                    "اجمالي",
                    "ملاحظات"
                  ]
                      .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(e,
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center)))
                      .toList()),
              ...scrapTransactions.where((s) {
                final t = s['type']?.toString().trim().toLowerCase() ?? '';
                return t == 'sale' || t == 'add';
              }).map((s) {
                final date = s['date'] is Timestamp
                    ? (s['date'] as Timestamp).toDate()
                    : s['date'];
                final type = s['type']?.toString().trim().toLowerCase();
                return pw.TableRow(children: [
                  pw.Text(
                      type == 'add' ? 'شراء' : (type == 'sale' ? 'بيع' : '—'),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['carat']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['weight']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['cash']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['network']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['total']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(s['notes']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                ]);
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الكسر",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد شرائح عيار 14 : $scrapTransactionsCount14 ( وزن: ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد شرائح عيار 18 : $scrapTransactionsCount18 ( وزن: ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد شرائح عيار 21 : $scrapTransactionsCount21 ( وزن: ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد شرائح عيار 22 : $scrapTransactionsCount22 ( وزن: ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد شرائح عيار 24 : $scrapTransactionsCount24 ( وزن: ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.vouchers)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول السندات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(1.5),
              5: pw.FlexColumnWidth(1.5),
              6: pw.FlexColumnWidth(1.5),
              7: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    "سند",
                    "تاريخ",
                    "عيار",
                    "وزن",
                    "كاش",
                    "شبكة",
                    "اجمالي",
                    "مندوب",
                    "مورد"
                  ]
                      .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(e,
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center)))
                      .toList()),
              ...vouchers.where((v) {
                final t = v['type']?.toString().trim().toLowerCase() ?? '';
                return t == 'receipt' || t == 'payment';
              }).map((v) {
                final date = v['date'] is Timestamp
                    ? (v['date'] as Timestamp).toDate()
                    : v['date'];
                final type = v['type']?.toString().trim().toLowerCase();
                return pw.TableRow(children: [
                  pw.Text(
                      type == 'payment'
                          ? 'صرف'
                          : (type == 'receipt' ? 'قبض' : '—'),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['carat']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['weight']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['cash']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['network']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['total']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['delegate']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(v['supplierName']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                ]);
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات السندات",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "إجمالي عدد السندات: $vouchersTotalCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد سندات عيار 18 : $vouchersCount18 ( وزن: ${vouchersWeight18.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد سندات عيار 21 : $vouchersCount21 ( وزن: ${vouchersWeight21.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عدد سندات عيار 22 : $vouchersCount22 ( وزن: ${vouchersWeight22.toStringAsFixed(2)} )",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.expenses)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول المصروفات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: ["نوع", "تاريخ", "مصروف", "سبب الصرف"]
                      .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(e,
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                              textAlign: pw.TextAlign.center)))
                      .toList()),
              ...expenses.map((e) {
                final date = e['date'] is Timestamp
                    ? (e['date'] as Timestamp).toDate()
                    : e['date'];
                return pw.TableRow(children: [
                  pw.Text(e['type']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(e['amount']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                  pw.Text(e['note']?.toString() ?? "—",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 8)),
                ]);
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجمالي المصروفات",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "إجمالي عدد المصروفات: $expensesTotalCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text: "إجمالي قيمة المصروفات: $expensesTotal",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.deposits)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول توريد للادارة",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildSimpleMoneyTable(managementDeposits),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات التوريد للادارة",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text:
                          "إجمالي عدد التوريدات: $managementDepositsTotalCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.imports)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول استيرادات من الادارة",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildSimpleMoneyTable(managementImported),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الاستيرادات من الادارة",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text:
                          "إجمالي عدد التوريدات: $managementImportedTotalCount",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }

    if (allowed.contains(ReportSection.safeTotals)) {
      try {
        final safeResults = await Future.wait<QuerySnapshot>([
          FS.salesCol().get(),
          FS.scrapCol().where("type", isEqualTo: "sale").get(),
          FS.scrapCol().where("type", isEqualTo: "add").get(),
          FS.vouchersCol().where("type", isEqualTo: "payment").get(),
          FS.expensesCol().get(),
          FS.depositsCol().get(),
          FS.ImportedCol().get(),
        ]);
        double sum = 0.0, cash = 0.0, visa = 0.0;
        for (var d in safeResults[0].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum += (data['payment']?['total'] ?? 0).toDouble();
          cash += (data['payment']?['cash'] ?? 0).toDouble();
          visa += (data['payment']?['visa'] ?? 0).toDouble();
        }
        for (var d in safeResults[1].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum += (data['total'] ?? 0).toDouble();
          cash += (data['cash'] ?? 0).toDouble();
          visa += (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[2].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum -= (data['total'] ?? 0).toDouble();
          cash -= (data['cash'] ?? 0).toDouble();
          visa -= (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[3].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum -= (data['total'] ?? 0).toDouble();
          cash -= (data['cash'] ?? 0).toDouble();
          visa -= (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[4].docs) {
          final data = d.data() as Map<String, dynamic>;
          final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
          sum -= amount;
          cash -= amount;
        }
        for (var d in safeResults[5].docs) {
          final data = d.data() as Map<String, dynamic>;
          final c = (data['cash'] ?? 0).toDouble();
          final v = (data['visa'] ?? 0).toDouble();
          sum -= c + v;
          cash -= c;
          visa -= v;
        }
        for (var d in safeResults[6].docs) {
          final data = d.data() as Map<String, dynamic>;
          final c = (data['cash'] ?? 0).toDouble();
          final v = (data['visa'] ?? 0).toDouble();
          sum += c + v;
          cash += c;
          visa += v;
        }
        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
          build: (context) => [
            pw.SizedBox(height: 15),
            pw.Text("إجماليات الصندوق",
                style:
                    pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2)
              },
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الكاش",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(cash.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الشبكة",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(visa.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("الإجمالي الكلي",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(sum.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
              ],
            ),
          ],
        ));
      } catch (e, st) {
        print("❌ خطأ في صفحة الصندوق: $e");
        print(st);
      }
    }

    // General Balance
    if (allowed.contains(ReportSection.generalBalance)) {
      try {
        final gb = await _getGeneralBalanceSnapshot();
        pdf.addPage(_buildGeneralBalancePage(gb, arabicFont, arabicFontBold));
      } catch (e, st) {
        print("❌ خطأ في صفحة الرصيد العام: $e");
        print(st);
      }
    }

    return pdf.save();
  }

  // ============================================================
  // printReport
  // ============================================================
  static Future<void> printReport(DateTime start, DateTime end,
      {Set<ReportSection>? sections}) async {
    final results = await Future.wait<List<Map<String, dynamic>>>([
      getItemsByDateRange(start, end),
      getupdatesByDateRange(start, end),
      getInventoriesByDateRange(start, end),
      getSalesByDateRange(start, end),
      getBranchTransfersByDateRange(start, end),
      getScrapTransactionsByDateRange(start, end),
      getvouchersByDateRange(start, end),
      getexpensesByDateRange(start, end),
      getmanagementDepositsByDateRange(start, end),
      getmanagementImportedByDateRange(start, end),
    ]);
    final pdfData = await generatePdfReport(
      results[0],
      results[2],
      results[3],
      results[4],
      results[1],
      results[5],
      results[6],
      results[7],
      results[8],
      results[9],
      start,
      end,
      sections: sections,
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  // ============================================================
  // runScheduledReport
  // ============================================================
  static Future<bool> runScheduledReport(DateTime start, DateTime end) async {
    try {
      final results = await Future.wait<List<Map<String, dynamic>>>([
        getItemsByDateRange(start, end),
        getupdatesByDateRange(start, end),
        getInventoriesByDateRange(start, end),
        getSalesByDateRange(start, end),
        getBranchTransfersByDateRange(start, end),
        getScrapTransactionsByDateRange(start, end),
        getvouchersByDateRange(start, end),
        getexpensesByDateRange(start, end),
        getmanagementDepositsByDateRange(start, end),
        getmanagementImportedByDateRange(start, end),
      ]);
      final pdfData = await generatePdfReport(
        results[0],
        results[2],
        results[3],
        results[4],
        results[1],
        results[5],
        results[6],
        results[7],
        results[8],
        results[9],
        start,
        end,
      );
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }
      final filePath =
          "${downloadsDir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf";
      await File(filePath).writeAsBytes(pdfData);
      print("🚀 التقرير اتحفظ هنا: $filePath");
      return true;
    } catch (e) {
      print("❌ خطأ في إنشاء التقرير: $e");
      return false;
    }
  }

  // ============================================================
  // printReportTotal
  // ============================================================
  static Future<void> printReportTotal(DateTime start, DateTime end,
      {Set<ReportSection>? sections}) async {
    final results = await Future.wait<List<Map<String, dynamic>>>([
      getItemsByDateRange(start, end),
      getupdatesByDateRange(start, end),
      getInventoriesByDateRange(start, end),
      getSalesByDateRange(start, end),
      getBranchTransfersByDateRange(start, end),
      getScrapTransactionsByDateRange(start, end),
      getvouchersByDateRange(start, end),
      getexpensesByDateRange(start, end),
      getmanagementDepositsByDateRange(start, end),
      getmanagementImportedByDateRange(start, end),
    ]);
    final pdfData = await generatePdfTotal(
      results[0],
      results[2],
      results[3],
      results[4],
      results[1],
      results[5],
      results[6],
      results[7],
      results[8],
      results[9],
      start,
      end,
      sections: sections,
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  // ============================================================
  // generatePdfTotal — totals only + General Balance
  // ============================================================
  static Future<Uint8List> generatePdfTotal(
      List<Map<String, dynamic>> items,
      List<Map<String, dynamic>> inventories,
      List<Map<String, dynamic>> sales,
      List<Map<String, dynamic>> branchTransfers,
      List<Map<String, dynamic>> updates,
      List<Map<String, dynamic>> scrapTransactions,
      List<Map<String, dynamic>> vouchers,
      List<Map<String, dynamic>> expenses,
      List<Map<String, dynamic>> managementDeposits,
      List<Map<String, dynamic>> managementImported,
      DateTime start,
      DateTime end,
      {Set<ReportSection>? sections}) async {
    final allowed = sections ?? ReportSection.values.toSet();
    final pdf = pw.Document();
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    int totalCount = 0, openingCount = 0, updatedCount = 0;
    double totalWeight = 0, totalWage = 0, totalCost = 0;
    double openingWeight = 0, openingWage = 0, openingCost = 0;
    double updatedWeight = 0, updatedWage = 0, updatedCost = 0;
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;
    int opening18 = 0,
        opening21 = 0,
        opening22 = 0,
        openingBullion = 0,
        openingGem = 0;
    double openingWeight18 = 0,
        openingWeight21 = 0,
        openingWeight22 = 0,
        openingWeightBullion = 0;
    int updated18 = 0,
        updated21 = 0,
        updated22 = 0,
        updatedBullion = 0,
        updatedGem = 0;
    double updatedWeight18 = 0,
        updatedWeight21 = 0,
        updatedWeight22 = 0,
        updatedWeightBullion = 0;

    for (var item in items) {
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      final fromOpening = item['fromOpeningBalance'] == true;
      if (fromOpening) {
        openingCount++;
        openingWeight += weight;
        openingWage += wage;
        openingCost += cost;
        if (carat == "18") {
          opening18++;
          openingWeight18 += weight;
        }
        if (carat == "21") {
          opening21++;
          openingWeight21 += weight;
        }
        if (carat == "22") {
          opening22++;
          openingWeight22 += weight;
        }
        if (category == "bullion") {
          openingBullion++;
          openingWeightBullion += weight;
        }
        if (category == "gem") {
          openingGem++;
        }
      } else {
        totalCount++;
        totalWeight += weight;
        totalWage += wage;
        totalCost += cost;
        if (carat == "18") {
          count18++;
          weight18 += weight;
        }
        if (carat == "21") {
          count21++;
          weight21 += weight;
        }
        if (carat == "22") {
          count22++;
          weight22 += weight;
        }
        if (category == "bullion") {
          countBullion++;
          weightBullion += weight;
        }
        if (category == "gem") {
          countGem++;
        }
      }
    }
    for (var update in updates) {
      final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = update['category']?.toString();
      if (update['updatedAt'] != null) {
        updatedCount++;
        updatedWeight += weight;
        updatedWage += wage;
        updatedCost += cost;
        if (carat == "18") {
          updated18++;
          updatedWeight18 += weight;
        }
        if (carat == "21") {
          updated21++;
          updatedWeight21 += weight;
        }
        if (carat == "22") {
          updated22++;
          updatedWeight22 += weight;
        }
        if (category == "bullion") {
          updatedBullion++;
          updatedWeightBullion += weight;
        }
        if (category == "gem") {
          updatedGem++;
        }
      }
    }

    int invTotalCount = inventories.length;
    double invTotalWeight = 0, invTotalWage = 0, invTotalCost = 0;
    int invCount18 = 0,
        invCount21 = 0,
        invCount22 = 0,
        invCountBullion = 0,
        invCountGem = 0;
    double invWeight18 = 0,
        invWeight21 = 0,
        invWeight22 = 0,
        invWeightBullion = 0;
    for (var inv in inventories) {
      final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      invTotalWeight += weight;
      invTotalWage += wage;
      invTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = inv['category']?.toString();
      if (carat == "18") {
        invCount18++;
        invWeight18 += weight;
      }
      if (carat == "21") {
        invCount21++;
        invWeight21 += weight;
      }
      if (carat == "22") {
        invCount22++;
        invWeight22 += weight;
      }
      if (category == "bullion") {
        invCountBullion++;
        invWeightBullion += weight;
      }
      if (category == "gem") {
        invCountGem++;
      }
    }

    final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();
    final missingItems = items.where((item) {
      final id = item['epcHex'] ?? item['id'];
      return !invIds.contains(id);
    }).toList();
    int missingCount = 0;
    double missingWeight = 0, missingWage = 0, missingCost = 0;
    int missing18 = 0,
        missing21 = 0,
        missing22 = 0,
        missingBullion = 0,
        missingGem = 0;
    double missingWeight18 = 0,
        missingWeight21 = 0,
        missingWeight22 = 0,
        missingWeightBullion = 0;
    for (var item in missingItems) {
      final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      final carat = payload['carat']?.toString();
      final category = item['category']?.toString();
      missingCount++;
      missingWeight += weight;
      missingWage += wage;
      missingCost += cost;
      if (carat == "18") {
        missing18++;
        missingWeight18 += weight;
      }
      if (carat == "21") {
        missing21++;
        missingWeight21 += weight;
      }
      if (carat == "22") {
        missing22++;
        missingWeight22 += weight;
      }
      if (category == "bullion") {
        missingBullion++;
        missingWeightBullion += weight;
      }
      if (category == "gem") {
        missingGem++;
      }
    }

    int salesTotalCount = sales.length;
    double salesTotalWeight = 0, salesTotalWage = 0, salesTotalCost = 0;
    int salesCount18 = 0,
        salesCount21 = 0,
        salesCount22 = 0,
        salesCountBullion = 0,
        salesCountGem = 0;
    double salesWeight18 = 0,
        salesWeight21 = 0,
        salesWeight22 = 0,
        salesWeightBullion = 0;
    for (var sale in sales) {
      final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      salesTotalWeight += weight;
      salesTotalWage += wage;
      salesTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = sale['category']?.toString();
      if (carat == "18") {
        salesCount18++;
        salesWeight18 += weight;
      }
      if (carat == "21") {
        salesCount21++;
        salesWeight21 += weight;
      }
      if (carat == "22") {
        salesCount22++;
        salesWeight22 += weight;
      }
      if (category == "bullion") {
        salesCountBullion++;
        salesWeightBullion += weight;
      }
      if (category == "gem") {
        salesCountGem++;
      }
    }

    int branchTransfersTotalCount = branchTransfers.length;
    double branchTransfersTotalWeight = 0,
        branchTransfersTotalWage = 0,
        branchTransfersTotalCost = 0;
    int branchTransfersCount18 = 0,
        branchTransfersCount21 = 0,
        branchTransfersCount22 = 0,
        branchTransfersCountBullion = 0,
        branchTransfersCountGem = 0;
    double branchTransfersWeight18 = 0,
        branchTransfersWeight21 = 0,
        branchTransfersWeight22 = 0,
        branchTransfersWeightBullion = 0;
    for (var branchTransfer in branchTransfers) {
      final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;
      branchTransfersTotalWeight += weight;
      branchTransfersTotalWage += wage;
      branchTransfersTotalCost += cost;
      final carat = payload['carat']?.toString();
      final category = branchTransfer['category']?.toString();
      if (carat == "18") {
        branchTransfersCount18++;
        branchTransfersWeight18 += weight;
      }
      if (carat == "21") {
        branchTransfersCount21++;
        branchTransfersWeight21 += weight;
      }
      if (carat == "22") {
        branchTransfersCount22++;
        branchTransfersWeight22 += weight;
      }
      if (category == "bullion") {
        branchTransfersCountBullion++;
        branchTransfersWeightBullion += weight;
      }
      if (category == "gem") {
        branchTransfersCountGem++;
      }
    }

    int scrapTransactionsTotalCount = 0;
    double scrapTransactionsTotalWeight = 0,
        scrapTransactionsTotalcash = 0,
        scrapTransactionsTotalnetwork = 0,
        scrapTransactionsTotaltotal = 0;
    int scrapTransactionsCount18 = 0,
        scrapTransactionsCount14 = 0,
        scrapTransactionsCount24 = 0,
        scrapTransactionsCount21 = 0,
        scrapTransactionsCount22 = 0;
    double scrapTransactionsWeight18 = 0,
        scrapTransactionsWeight14 = 0,
        scrapTransactionsWeight24 = 0,
        scrapTransactionsWeight21 = 0,
        scrapTransactionsWeight22 = 0;
    for (var scrapTransaction in scrapTransactions) {
      final weight =
          double.tryParse(scrapTransaction['weight']?.toString() ?? "0") ?? 0;
      final cash =
          double.tryParse(scrapTransaction['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(scrapTransaction['network']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(scrapTransaction['total']?.toString() ?? "0") ?? 0;
      final carat = scrapTransaction['carat']?.toString();
      final type =
          scrapTransaction['type']?.toString().trim().toLowerCase() ?? '';
      if (type.isNotEmpty && (type == 'sale' || type == 'add')) {
        scrapTransactionsTotalCount += 1;
        scrapTransactionsTotalWeight += weight;
        scrapTransactionsTotalcash += cash;
        scrapTransactionsTotalnetwork += network;
        scrapTransactionsTotaltotal += total;
        if (carat == "14") {
          scrapTransactionsCount14++;
          scrapTransactionsWeight14 += weight;
        }
        if (carat == "18") {
          scrapTransactionsCount18++;
          scrapTransactionsWeight18 += weight;
        }
        if (carat == "21") {
          scrapTransactionsCount21++;
          scrapTransactionsWeight21 += weight;
        }
        if (carat == "22") {
          scrapTransactionsCount22++;
          scrapTransactionsWeight22 += weight;
        }
        if (carat == "24") {
          scrapTransactionsCount24++;
          scrapTransactionsWeight24 += weight;
        }
      }
    }

    int vouchersTotalCount = 0,
        voucherspaymentCount = 0,
        vouchersreceiptCount = 0;
    double vouchersTotalWeight = 0,
        vouchersTotalcash = 0,
        vouchersTotalnetwork = 0,
        vouchersTotaltotal = 0;
    int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;
    double vouchersWeight18 = 0, vouchersWeight21 = 0, vouchersWeight22 = 0;
    for (var voucher in vouchers) {
      final weight = double.tryParse(voucher['weight']?.toString() ?? "0") ?? 0;
      final cash = double.tryParse(voucher['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(voucher['network']?.toString() ?? "0") ?? 0;
      final total = double.tryParse(voucher['total']?.toString() ?? "0") ?? 0;
      final carat = voucher['carat']?.toString();
      final type = voucher['type']?.toString().trim().toLowerCase() ?? '';
      vouchersTotalCount += 1;
      if (type == 'payment') {
        voucherspaymentCount += 1;
        vouchersTotalWeight += weight;
        vouchersTotalcash += cash;
        vouchersTotalnetwork += network;
        vouchersTotaltotal += total;
        if (carat == "18") {
          vouchersCount18++;
          vouchersWeight18 += weight;
        }
        if (carat == "21") {
          vouchersCount21++;
          vouchersWeight21 += weight;
        }
        if (carat == "22") {
          vouchersCount22++;
          vouchersWeight22 += weight;
        }
      } else if (type == 'receipt') {
        vouchersreceiptCount += 1;
        vouchersTotalWeight -= weight;
        vouchersTotalcash -= cash;
        vouchersTotalnetwork -= network;
        vouchersTotaltotal -= total;
        if (carat == "18") {
          vouchersCount18++;
          vouchersWeight18 -= weight;
        }
        if (carat == "21") {
          vouchersCount21++;
          vouchersWeight21 -= weight;
        }
        if (carat == "22") {
          vouchersCount22++;
          vouchersWeight22 -= weight;
        }
      }
    }

    int expensesTotalCount = 0;
    double expensesTotal = 0;
    for (var expense in expenses) {
      final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
      expensesTotal += amount;
      expensesTotalCount += 1;
    }

    int managementDepositsTotalCount = 0;
    double managementDepositsTotalcash = 0,
        managementDepositsTotalnetwork = 0,
        managementDepositsTotaltotal = 0;
    for (var managementDeposit in managementDeposits) {
      managementDepositsTotalCount += 1;
      managementDepositsTotalcash +=
          double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
      managementDepositsTotalnetwork +=
          double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
      managementDepositsTotaltotal +=
          double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
    }

    int managementImportedTotalCount = 0;
    double managementImportedTotalcash = 0,
        managementImportedTotalnetwork = 0,
        managementImportedTotaltotal = 0;
    for (var managementImport in managementImported) {
      managementImportedTotalCount += 1;
      managementImportedTotalcash +=
          double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
      managementImportedTotalnetwork +=
          double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
      managementImportedTotaltotal +=
          double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
    }

    final Map<String, Map<String, double>> sellersTotals = {};
    for (var sale in sales) {
      final payment = sale['payment'] as Map<String, dynamic>? ?? {};
      final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';
      final total = (payment['total'] ?? 0).toDouble();
      final cash = (payment['cash'] ?? 0).toDouble();
      final visa = (payment['visa'] ?? 0).toDouble();
      sellersTotals.putIfAbsent(
          soldBy, () => {'total': 0, 'cash': 0, 'visa': 0});
      sellersTotals[soldBy]!['total'] =
          sellersTotals[soldBy]!['total']! + total;
      sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
      sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
    }

    final image = pw.MemoryImage(
        (await rootBundle.load('assets/gold.png')).buffer.asUint8List());

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
      build: (context) {
        final pageWidth = PdfPageFormat.a4.width;
        final pageHeight = PdfPageFormat.a4.height;
        return pw.Stack(children: [
          pw.Container(
            width: pageWidth,
            height: pageHeight,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.amber600, width: 3),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(image, width: 60, height: 60),
                pw.SizedBox(height: 10),
                pw.Text("تقرير الإجماليات",
                    style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black),
                    textAlign: pw.TextAlign.center),
                pw.SizedBox(height: 6),
                pw.Container(
                    height: 2,
                    width: pageWidth * 0.4,
                    color: PdfColors.amber600),
                pw.SizedBox(height: 20),
                pw.Text(
                  "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
                  "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          ),
        ]);
      },
    ));

    if (allowed.contains(ReportSection.openingBalance)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات الرصيد الافتتاحي",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              openingCount,
              opening18,
              opening21,
              opening22,
              openingBullion,
              openingGem,
              openingWeight,
              openingWage,
              openingCost,
              openingWeight18,
              openingWeight21,
              openingWeight22,
              openingWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.entry)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات الإدخال",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              totalCount,
              count18,
              count21,
              count22,
              countBullion,
              countGem,
              totalWeight,
              totalWage,
              totalCost,
              weight18,
              weight21,
              weight22,
              weightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.missing)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات المفقود",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              missingCount,
              missing18,
              missing21,
              missing22,
              missingBullion,
              missingGem,
              missingWeight,
              missingWage,
              missingCost,
              missingWeight18,
              missingWeight21,
              missingWeight22,
              missingWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.inventory)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات الجرد",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              invTotalCount,
              invCount18,
              invCount21,
              invCount22,
              invCountBullion,
              invCountGem,
              invTotalWeight,
              invTotalWage,
              invTotalCost,
              invWeight18,
              invWeight21,
              invWeight22,
              invWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.updates)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات التعديلات",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              updatedCount,
              updated18,
              updated21,
              updated22,
              updatedBullion,
              updatedGem,
              updatedWeight,
              updatedWage,
              updatedCost,
              updatedWeight18,
              updatedWeight21,
              updatedWeight22,
              updatedWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.sales)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات المبيعات",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              salesTotalCount,
              salesCount18,
              salesCount21,
              salesCount22,
              salesCountBullion,
              salesCountGem,
              salesTotalWeight,
              salesTotalWage,
              salesTotalCost,
              salesWeight18,
              salesWeight21,
              salesWeight22,
              salesWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.sellersTotals)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات البائعين",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cell("البائع", bold: true),
                    _cell("الإجمالي", bold: true),
                    _cell("كاش", bold: true),
                    _cell("شبكة", bold: true)
                  ]),
              ...sellersTotals.entries.map((e) => pw.TableRow(children: [
                    _cell(e.key),
                    _cell(e.value['total']!.toStringAsFixed(2)),
                    _cell(e.value['cash']!.toStringAsFixed(2)),
                    _cell(e.value['visa']!.toStringAsFixed(2)),
                  ])),
            ],
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.transfers)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات التحويلات",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          _buildTotals(
              branchTransfersTotalCount,
              branchTransfersCount18,
              branchTransfersCount21,
              branchTransfersCount22,
              branchTransfersCountBullion,
              branchTransfersCountGem,
              branchTransfersTotalWeight,
              branchTransfersTotalWage,
              branchTransfersTotalCost,
              branchTransfersWeight18,
              branchTransfersWeight21,
              branchTransfersWeight22,
              branchTransfersWeightBullion),
        ],
      ));
    }
    if (allowed.contains(ReportSection.scrap)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات الكسر",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عيار 14: $scrapTransactionsCount14 ( ${scrapTransactionsWeight14.toStringAsFixed(2)} جم )",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عيار 18: $scrapTransactionsCount18 ( ${scrapTransactionsWeight18.toStringAsFixed(2)} جم )",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عيار 21: $scrapTransactionsCount21 ( ${scrapTransactionsWeight21.toStringAsFixed(2)} جم )",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عيار 22: $scrapTransactionsCount22 ( ${scrapTransactionsWeight22.toStringAsFixed(2)} جم )",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "عيار 24: $scrapTransactionsCount24 ( ${scrapTransactionsWeight24.toStringAsFixed(2)} جم )",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الوزن: ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة: ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش: ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر: ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.vouchers)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات السندات",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "إجمالي عدد السندات: $vouchersTotalCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text: "صرف: $voucherspaymentCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text: "قبض: $vouchersreceiptCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الوزن: ${vouchersTotalWeight.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الشبكة: ${vouchersTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي الكاش: ${vouchersTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "إجمالي السعر: ${vouchersTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.expenses)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجمالي المصروفات",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "عدد المصروفات: $expensesTotalCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "قيمة المصروفات: ${expensesTotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.deposits)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات التوريد للإدارة",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "العدد: $managementDepositsTotalCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الشبكة: ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الكاش: ${managementDepositsTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الإجمالي: ${managementDepositsTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.imports)) {
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("إجماليات الاستيراد من الإدارة",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Bullet(
                      text: "العدد: $managementImportedTotalCount",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الشبكة: ${managementImportedTotalnetwork.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الكاش: ${managementImportedTotalcash.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                  pw.Bullet(
                      text:
                          "الإجمالي: ${managementImportedTotaltotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.right),
                ]),
          ),
        ],
      ));
    }
    if (allowed.contains(ReportSection.safeTotals)) {
      try {
        final safeResults = await Future.wait<QuerySnapshot>([
          FS.salesCol().get(),
          FS.scrapCol().where("type", isEqualTo: "sale").get(),
          FS.scrapCol().where("type", isEqualTo: "add").get(),
          FS.vouchersCol().where("type", isEqualTo: "payment").get(),
          FS.expensesCol().get(),
          FS.depositsCol().get(),
          FS.ImportedCol().get(),
        ]);
        double sum = 0.0, cash = 0.0, visa = 0.0;
        for (var d in safeResults[0].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum += (data['payment']?['total'] ?? 0).toDouble();
          cash += (data['payment']?['cash'] ?? 0).toDouble();
          visa += (data['payment']?['visa'] ?? 0).toDouble();
        }
        for (var d in safeResults[1].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum += (data['total'] ?? 0).toDouble();
          cash += (data['cash'] ?? 0).toDouble();
          visa += (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[2].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum -= (data['total'] ?? 0).toDouble();
          cash -= (data['cash'] ?? 0).toDouble();
          visa -= (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[3].docs) {
          final data = d.data() as Map<String, dynamic>;
          sum -= (data['total'] ?? 0).toDouble();
          cash -= (data['cash'] ?? 0).toDouble();
          visa -= (data['network'] ?? 0).toDouble();
        }
        for (var d in safeResults[4].docs) {
          final data = d.data() as Map<String, dynamic>;
          final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
          sum -= amount;
          cash -= amount;
        }
        for (var d in safeResults[5].docs) {
          final data = d.data() as Map<String, dynamic>;
          final c = (data['cash'] ?? 0).toDouble();
          final v = (data['visa'] ?? 0).toDouble();
          sum -= c + v;
          cash -= c;
          visa -= v;
        }
        for (var d in safeResults[6].docs) {
          final data = d.data() as Map<String, dynamic>;
          final c = (data['cash'] ?? 0).toDouble();
          final v = (data['visa'] ?? 0).toDouble();
          sum += c + v;
          cash += c;
          visa += v;
        }
        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
          build: (context) => [
            pw.SizedBox(height: 15),
            pw.Text("إجماليات الصندوق",
                style:
                    pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2)
              },
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الكاش",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(cash.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الشبكة",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(visa.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("الإجمالي الكلي",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold))),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(sum.toStringAsFixed(2),
                          style: const pw.TextStyle(fontSize: 20),
                          textAlign: pw.TextAlign.center)),
                ]),
              ],
            ),
          ],
        ));
      } catch (e, st) {
        print("❌ خطأ في صفحة الصندوق: $e");
        print(st);
      }
    }

    // General Balance
    if (allowed.contains(ReportSection.generalBalance)) {
      try {
        final gb = await _getGeneralBalanceSnapshot();
        pdf.addPage(_buildGeneralBalancePage(gb, arabicFont, arabicFontBold));
      } catch (e, st) {
        print("❌ خطأ في صفحة الرصيد العام: $e");
        print(st);
      }
    }

    return pdf.save();
  }
}
