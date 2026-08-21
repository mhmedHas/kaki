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

class PdfReport {
  /// ✅ تجيب عناصر من Firestore (items)
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

  /// ✅ تجيب عناصر من Firestore (inventories)
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

  /// ✅ تجيب عناصر من Firestore (sales)
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

  /// ✅ تجيب عناصر من Firestore (branchTransfers)
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

  /// ✅ تجيب عناصر من Firestore (scrapTransactions)
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

  /// ✅ تجيب عناصر من Firestore (vouchers)
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

  /// ✅ تجيب عناصر من Firestore (expenses)
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

  /// ✅ تجيب عناصر من Firestore (managementDeposits)
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

  /// ✅ تجيب عناصر من Firestore (managementImported)
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

  /// ✅ توليد ملف PDF
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
      DateTime end) async {
    final pdf = pw.Document();

    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // ---------------- إجماليات items ----------------
    int totalCount = 0;
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

// ---------------- إجماليات opening balance ----------------
    int openingCount = 0;
    double openingWeight = 0;
    double openingWage = 0;
    double openingCost = 0;

// ---------------- إجماليات التعديلات ----------------
    int updatedCount = 0;
    double updatedWeight = 0;
    double updatedWage = 0;
    double updatedCost = 0;

// ✅ تفاصيل الكارات لكل نوع (للعادية)
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

// ✅ تفاصيل الكارات لكل نوع (للـ Opening)
    int opening18 = 0,
        opening21 = 0,
        opening22 = 0,
        openingBullion = 0,
        openingGem = 0;
    double openingWeight18 = 0,
        openingWeight21 = 0,
        openingWeight22 = 0,
        openingWeightBullion = 0;

// ✅ تفاصيل الكارات لكل نوع (للتعديلات)
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

      // ---------------- العادية أو الافتتاحية ----------------
      if (fromOpening) {
        // 🔹 إجماليات الافتتاحية
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
        // 🔹 إجماليات العادية
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
    // ---------------- التعديلات (مستقلة) ----------------
    for (var update in updates) {
      final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = update['category']?.toString();
      final updatedAt = update['updatedAt'];

      if (updatedAt != null) {
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

    // ---------------- إجماليات inventories ----------------
    int invTotalCount = inventories.length;
    double invTotalWeight = 0;
    double invTotalWage = 0;
    double invTotalCost = 0;

    int invCount18 = 0,
        invCount21 = 0,
        invCount22 = 0,
        invCountBullion = 0,
        invCountGem = 0;

// ✅ أوزان كل نوع
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

    // 🟡 استخراج الـ itemId من المخزون (inventories)
    // 🟡 استخراج الـ EPCs أو IDs من المخزون الحالي
    final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();

// 🟡 تحديد العناصر المفقودة (اللي مش موجودة في المخزون)
    final missingItems = items.where((item) {
      final id = item['epcHex'] ?? item['id'];
      return !invIds.contains(id);
    }).toList();

    // ---------------- إجماليات المفقود ----------------
    // ---------------- إجماليات المفقود ----------------
    int missingCount = 0;
    double missingWeight = 0;
    double missingWage = 0;
    double missingCost = 0;

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

    // ---------------- إجماليات المبيعات ----------------
    int salesTotalCount = sales.length;
    double salesTotalWeight = 0;
    double salesTotalWage = 0;
    double salesTotalCost = 0;

    int salesCount18 = 0,
        salesCount21 = 0,
        salesCount22 = 0,
        salesCountBullion = 0,
        salesCountGem = 0;

// ✅ أوزان كل نوع في المبيعات
    double salesWeight18 = 0,
        salesWeight21 = 0,
        salesWeight22 = 0,
        salesWeightBullion = 0;

    for (var sale in sales) {
      final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      // جمع الإجماليات
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

    // ---------------- إجماليات الفروع ----------------
    int branchTransfersTotalCount = branchTransfers.length;
    double branchTransfersTotalWeight = 0;
    double branchTransfersTotalWage = 0;
    double branchTransfersTotalCost = 0;

    int branchTransfersCount18 = 0,
        branchTransfersCount21 = 0,
        branchTransfersCount22 = 0,
        branchTransfersCountBullion = 0,
        branchTransfersCountGem = 0;

// ✅ أوزان كل نوع في المبيعات
    double branchTransfersWeight18 = 0,
        branchTransfersWeight21 = 0,
        branchTransfersWeight22 = 0,
        branchTransfersWeightBullion = 0;

    for (var branchTransfer in branchTransfers) {
      final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      // جمع الإجماليات
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

    // ---------------- إجماليات الكسر ----------------
    int scrapTransactionsTotalCount = 0;
    double scrapTransactionsTotalWeight = 0;
    double scrapTransactionsTotalcash = 0;
    double scrapTransactionsTotalnetwork = 0;
    double scrapTransactionsTotaltotal = 0;

    int scrapTransactionsCount18 = 0,
        scrapTransactionsCount14 = 0,
        scrapTransactionsCount24 = 0,
        scrapTransactionsCount21 = 0,
        scrapTransactionsCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
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

    // ---------------- إجماليات السندات ----------------
    int vouchersTotalCount = 0;
    int voucherspaymentCount = 0;
    int vouchersreceiptCount = 0;
    double vouchersTotalWeight = 0;
    double vouchersTotalcash = 0;
    double vouchersTotalnetwork = 0;
    double vouchersTotaltotal = 0;

    int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
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

      if (type.isNotEmpty && type == 'payment') {
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
      } else if (type.isNotEmpty && type == 'receipt') {
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

    // ---------------- إجماليات المصروفات ----------------
    int expensesTotalCount = 0;
    double expensesTotal = 0;

    //int scrapTransactionsCount18 = 0, scrapTransactionsCount21 = 0, scrapTransactionsCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
    //double scrapTransactionsWeight18 = 0, scrapTransactionsWeight21 = 0, scrapTransactionsWeight22 = 0;

    for (var expense in expenses) {
      final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
      expensesTotal += amount;
      expensesTotalCount += 1;
    }

    // ---------------- إجماليات توريدات الادارة  ----------------
    int managementDepositsTotalCount = 0;
    double managementDepositsTotalcash = 0;
    double managementDepositsTotalnetwork = 0;
    double managementDepositsTotaltotal = 0;

    for (var managementDeposit in managementDeposits) {
      final cash =
          double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
      managementDepositsTotalCount += 1;
      managementDepositsTotalcash += cash;
      managementDepositsTotalnetwork += network;
      managementDepositsTotaltotal += total;
    }
    // ---------------- إجماليات الاستيرادات من الادارة  ----------------
    int managementImportedTotalCount = 0;
    double managementImportedTotalcash = 0;
    double managementImportedTotalnetwork = 0;
    double managementImportedTotaltotal = 0;

    for (var managementImport in managementImported) {
      final cash =
          double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
      managementImportedTotalCount += 1;
      managementImportedTotalcash += cash;
      managementImportedTotalnetwork += network;
      managementImportedTotaltotal += total;
    }

    // ---------------- إجماليات البائعين ----------------
    final Map<String, Map<String, double>> sellersTotals = {};

    for (var sale in sales) {
      final payment = sale['payment'] as Map<String, dynamic>? ?? {};

      final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';

      final total = (payment['total'] ?? 0).toDouble();
      final cash = (payment['cash'] ?? 0).toDouble();
      final visa = (payment['visa'] ?? 0).toDouble();

      sellersTotals.putIfAbsent(
          soldBy,
          () => {
                'total': 0,
                'cash': 0,
                'visa': 0,
              });

      sellersTotals[soldBy]!['total'] =
          sellersTotals[soldBy]!['total']! + total;
      sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
      sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
    }

    // ---------------- PDF ----------------
    // صفحة العنوان والفترة
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          final pageWidth = PdfPageFormat.a4.width;
          final pageHeight = PdfPageFormat.a4.height;

          return pw.Stack(
            children: [
              // برواز ذهبي
              pw.Container(
                width: pageWidth,
                height: pageHeight,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.amber600, width: 3),
                ),
              ),

              // المحتوى
              pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // ✅ أيقونة ذهبية من صورة
                    pw.Image(image, width: 60, height: 60),

                    pw.SizedBox(height: 10),

                    // العنوان في النص
                    pw.Text(
                      "تقارير المخزون",
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),

                    pw.SizedBox(height: 6),

                    // خط ذهبي تحت العنوان
                    pw.Container(
                      height: 2,
                      width: pageWidth * 0.4,
                      color: PdfColors.amber600,
                    ),

                    pw.SizedBox(height: 20),

                    // الفترة
                    pw.Text(
                      "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
                      "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الرصيد الافتتاحي",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "تاريخ",
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
                              textAlign: pw.TextAlign.center),
                        ))
                    .toList(),
              ),
              // Data rows (الافتتاحية فقط)
              ...items
                  .where((e) => e['fromOpeningBalance'] == true)
                  .map((item) {
                final date = item['date'] is Timestamp
                    ? (item['date'] as Timestamp).toDate()
                    : item['date'];
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;
                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString().isNotEmpty == true
                                ? payload['kind'].toString()
                                : "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الرصيد الافتتاحي",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
            openingWeightBullion,
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الإدخال",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "تاريخ",
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
                              textAlign: pw.TextAlign.center),
                        ))
                    .toList(),
              ),
              // Data rows (العادي فقط)
              ...items
                  .where((e) => e['fromOpeningBalance'] != true)
                  .map((item) {
                final date = item['date'] is Timestamp
                    ? (item['date'] as Timestamp).toDate()
                    : item['date'];
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString().isNotEmpty == true
                                ? payload['kind'].toString()
                                : "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الإدخال",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
            weightBullion,
          ),
        ],
      ),
    );

    // ✅ صفحة المفقودين
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول المفقود",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "تاريخ",
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),
              // Data rows (المفقودين)
              ...missingItems.map((item) {
                final date = item['date'] is Timestamp
                    ? (item['date'] as Timestamp).toDate()
                    : item['date'];
                final payload = (item['payload'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: payload['qrCode'],
                          width: 20,
                          height: 20,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: payload['qrCode'],
                          width: 40,
                          height: 15,
                          drawText: false,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(item['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        payload['type']?.toString().isNotEmpty == true
                            ? payload['type'].toString()
                            : (payload['kind']?.toString().isNotEmpty == true
                                ? payload['kind'].toString()
                                : "—"),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات المفقود",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
            missingWeightBullion,
          ),
        ],
      ),
    );

    // صفحة جدول الجرد
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول الجرد",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "آخر ظهور",
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...inventories.map((inv) {
                final date = inv['lastSeenAt'] is Timestamp
                    ? (inv['lastSeenAt'] as Timestamp).toDate()
                    : inv['lastSeenAt'];
                final payload = (inv['payload'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: payload['qrCode'],
                          width: 20,
                          height: 20,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: payload['qrCode'],
                          width: 40,
                          height: 15,
                          drawText: false,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(inv['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      payload['type']?.toString().isNotEmpty == true
                          ? payload['type'].toString()
                          : (payload['kind']?.toString().isNotEmpty == true
                              ? payload['kind'].toString()
                              : "—"),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الجرد",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
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
            invWeightBullion,
          ),
        ],
      ),
    );

    // ✅ صفحة جدول التعديلات
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول التعديلات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "تاريخ",
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
                              textAlign: pw.TextAlign.center),
                        ))
                    .toList(),
              ),

              // Data rows (التعديلات فقط)
              ...updates.where((e) => e['updatedAt'] != null).map((update) {
                final date = update['updatedAt'] is Timestamp
                    ? (update['updatedAt'] as Timestamp).toDate()
                    : update['updatedAt'];
                final payload =
                    (update['payload'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: payload['qrCode'],
                            width: 20,
                            height: 20),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: payload['qrCode'],
                            width: 40,
                            height: 15,
                            drawText: false),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(update['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      payload['type']?.toString().isNotEmpty == true
                          ? payload['type'].toString()
                          : (payload['kind']?.toString().isNotEmpty == true
                              ? payload['kind'].toString()
                              : "—"),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text("إجماليات التعديلات",
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
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
            updatedWeightBullion,
          ),
        ],
      ),
    );

// صفحة جدول المبيعات
    pdf.addPage(
      pw.MultiPage(
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
              // Header
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...sales.map((sale) {
                final date = sale['soldAt'] is Timestamp
                    ? (sale['soldAt'] as Timestamp).toDate()
                    : sale['soldAt'];
                final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
                final payment = (sale['payment'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: payload['qrCode'],
                          width: 20,
                          height: 20,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: payload['qrCode'],
                          width: 40,
                          height: 15,
                          drawText: false,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(payment['soldBy']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(translateCategory(sale['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      payload['type']?.toString().isNotEmpty == true
                          ? payload['type'].toString()
                          : (payload['kind']?.toString().isNotEmpty == true
                              ? payload['kind'].toString()
                              : "—"),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payment['cash']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payment['visa']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payment['total']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات المبيعات",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
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
            salesWeightBullion,
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات البائعين",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
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
              // 🔹 الهيدر
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _cell("البائع", bold: true),
                  _cell("الإجمالي", bold: true),
                  _cell("كاش", bold: true),
                  _cell("شبكة", bold: true),
                ],
              ),

              // 🔹 البيانات
              ...sellersTotals.entries.map((e) {
                return pw.TableRow(
                  children: [
                    _cell(e.key),
                    _cell(e.value['total']!.toStringAsFixed(2)),
                    _cell(e.value['cash']!.toStringAsFixed(2)),
                    _cell(e.value['visa']!.toStringAsFixed(2)),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول التحويلات",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  "كود",
                  "نوع",
                  "تاريخ",
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...branchTransfers.map((branchTransfer) {
                final date = branchTransfer['date'] is Timestamp
                    ? (branchTransfer['date'] as Timestamp).toDate()
                    : branchTransfer['date'];
                final payload =
                    (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;

                pw.Widget codeWidget;
                if (payload['qrCode'] != null) {
                  if (payload['showQr'] == true) {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: payload['qrCode'],
                          width: 20,
                          height: 20,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  } else {
                    codeWidget = pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: payload['qrCode'],
                          width: 40,
                          height: 15,
                          drawText: false,
                        ),
                        pw.SizedBox(height: 1),
                        pw.Text(payload['qrCode']?.toString() ?? "—",
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    );
                  }
                } else {
                  codeWidget = pw.Text("—", textAlign: pw.TextAlign.center);
                }

                return pw.TableRow(
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(2), child: codeWidget),
                    pw.Text(translateCategory(branchTransfer['category']),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['wage']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                      payload['type']?.toString().isNotEmpty == true
                          ? payload['type'].toString()
                          : (payload['kind']?.toString().isNotEmpty == true
                              ? payload['kind'].toString()
                              : "—"),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(payload['cost']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['setComponents']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(payload['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات التحويلات",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
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
            branchTransfersWeightBullion,
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
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
              // Header
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...scrapTransactions.where((scrapTransaction) {
                final type =
                    scrapTransaction['type']?.toString().trim().toLowerCase() ??
                        '';
                return type == 'sale' || type == 'add';
              }).map((scrapTransaction) {
                final date = scrapTransaction['date'] is Timestamp
                    ? (scrapTransaction['date'] as Timestamp).toDate()
                    : scrapTransaction['date'];

                return pw.TableRow(
                  children: [
                    pw.Text(
                      (() {
                        final type = scrapTransaction['type']
                            ?.toString()
                            .trim()
                            .toLowerCase();
                        if (type == 'add') return 'شراء';
                        if (type == 'sale') return 'بيع';
                        return '—';
                      })(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['cash']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['network']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['total']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(scrapTransaction['notes']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الكسر",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 14 : $scrapTransactionsCount14             ( وزن:   ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $scrapTransactionsCount18             ( وزن:   ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $scrapTransactionsCount21              ( وزن:  ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $scrapTransactionsCount22              ( وزن:  ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 24 : $scrapTransactionsCount24             ( وزن:   ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
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
              // Header
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
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...vouchers.where((voucher) {
                final type =
                    voucher['type']?.toString().trim().toLowerCase() ?? '';
                return type == 'receipt' || type == 'payment';
              }).map((voucher) {
                final date = voucher['date'] is Timestamp
                    ? (voucher['date'] as Timestamp).toDate()
                    : voucher['date'];

                return pw.TableRow(
                  children: [
                    pw.Text(
                      (() {
                        final type =
                            voucher['type']?.toString().trim().toLowerCase();
                        if (type == 'payment') return 'صرف';
                        if (type == 'receipt') return 'قبض';
                        return '—';
                      })(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['carat']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['weight']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['cash']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['network']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['total']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['delegate']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(voucher['supplierName']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات السندات",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد السندات: $vouchersTotalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 18 : $vouchersCount18             ( وزن:   ${vouchersWeight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 21 : $vouchersCount21              ( وزن:  ${vouchersWeight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 22 : $vouchersCount22              ( وزن:  ${vouchersWeight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
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
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: ["نوع", "تاريخ", "مصروف", "سبب الصرف"]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...expenses.map((expense) {
                final date = expense['date'] is Timestamp
                    ? (expense['date'] as Timestamp).toDate()
                    : expense['date'];

                return pw.TableRow(
                  children: [
                    pw.Text(expense['type']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(expense['amount']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(expense['note']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجمالي المصروفات",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد المصروفات: $expensesTotalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي قيمة المصروفات: $expensesTotal",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول توريد للادارة",
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
            },
            children: [
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...managementDeposits.map((managementDeposit) {
                final date = managementDeposit['date'] is Timestamp
                    ? (managementDeposit['date'] as Timestamp).toDate()
                    : managementDeposit['date'];

                return pw.TableRow(
                  children: [
                    pw.Text(managementDeposit['type']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementDeposit['cash']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementDeposit['visa']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementDeposit['total']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات التوريد للادارة ",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.Text("جدول استيرادات من الادارة",
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
            },
            children: [
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: ["نوع", "تاريخ", "كاش", "شبكة", "اجمالي"]
                    .map((e) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(
                            e,
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center,
                          ),
                        ))
                    .toList(),
              ),

              // Data rows
              ...managementImported.map((managementImport) {
                final date = managementImport['date'] is Timestamp
                    ? (managementImport['date'] as Timestamp).toDate()
                    : managementImport['date'];

                return pw.TableRow(
                  children: [
                    pw.Text(managementImport['type']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        date != null
                            ? DateFormat('yyyy/MM/dd').format(date)
                            : "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementImport['cash']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementImport['visa']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                    pw.Text(managementImport['total']?.toString() ?? "—",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الاستيرادات من لادارة ",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد التوريدات: $managementImportedTotalCount",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // 🧾 صفحة عمليات الصندوق
    try {
      double sum = 0.0;
      double cash = 0.0;
      double visa = 0.0;
      //List<Map<String, dynamic>> all = [];

      // 🟢 بيع القطع
      final salesSnap = await FS.salesCol().get();
      for (var d in salesSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['payment']?['total'] ?? 0).toDouble();
        final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
        final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
        final date = (data['createdAt'] as Timestamp?)?.toDate();

        sum += wage;
        cash += totalcash;
        visa += totalvisa;
      }

      // 🟢 بيع كسر
      final scrapSnap =
          await FS.scrapCol().where("type", isEqualTo: "sale").get();
      for (var d in scrapSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum += wage;
        cash += totalcash;
        visa += totalvisa;
      }

      // 🔴 شراء كسر
      final scrapBuySnap =
          await FS.scrapCol().where("type", isEqualTo: "add").get();
      for (var d in scrapBuySnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔴 سندات الصرف
      final vouchersSnap =
          await FS.vouchersCol().where("type", isEqualTo: "payment").get();
      for (var d in vouchersSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔴 المصروفات
      final expSnap = await FS.expensesCol().get();
      for (var d in expSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
        final date = (data['date'] as Timestamp?)?.toDate();

        //final displayType = _t('مصروف', 'Expense');

        sum -= amount;
        cash -= amount;
      }

      // 🔵 توريد للإدارة
      final depositSnap = await FS.depositsCol().get();
      for (var d in depositSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= totalValue;
        cash -= totalcash;
        visa -= totalvisa;
      }
      // 🔵 استيراد من الإدارة
      final ImportSnap = await FS.ImportedCol().get();
      for (var d in ImportSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();

        sum += totalValue;
        cash += totalcash;
        visa += totalvisa;
      }

      //print("✅ تم حساب البيانات بنجاح. عدد الصفوف: ${cashBoxRows.length}");
      print("الإجمالي الكاش: $cash - الشبكة: $visa - الكلي: $sum");

      // صفحة الـ PDF
      // 🧾 صفحة عمليات الصندوق
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFontBold,
          ),
          build: (context) => [
            pw.SizedBox(height: 15),

            // 🧮 إجماليات الصندوق
            pw.Text(
              "إجماليات الصندوق",
              style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الكاش",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        cash.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الشبكة",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        visa.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("الإجمالي الكلي",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        sum.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e, st) {
      print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
      print(st);
    }

    return pdf.save();
  }

  /// ✅ دالة تعرض نافذة الطباعة مباشرة
  static Future<void> printReport(DateTime start, DateTime end) async {
    final items = await getItemsByDateRange(start, end);
    final updates = await getupdatesByDateRange(start, end);
    final inventories = await getInventoriesByDateRange(start, end);
    final sales = await getSalesByDateRange(start, end);
    final branchTransfers = await getBranchTransfersByDateRange(start, end);
    final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
    final vouchers = await getvouchersByDateRange(start, end);
    final expenses = await getexpensesByDateRange(start, end);
    final managementDeposits =
        await getmanagementDepositsByDateRange(start, end);
    final managementImported =
        await getmanagementImportedByDateRange(start, end);
    final pdfData = await generatePdfReport(
        items,
        inventories,
        sales,
        branchTransfers,
        updates,
        scrapTransactions,
        vouchers,
        expenses,
        managementDeposits,
        managementImported,
        start,
        end);

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  /// ✅ نسخة تستخدم للـ Workmanager

  static Future<bool> runScheduledReport(DateTime start, DateTime end) async {
    try {
      // ✅ هات البيانات للفترة المطلوبة
      final items = await getItemsByDateRange(start, end);
      final updates = await getupdatesByDateRange(start, end);
      final inventories = await getInventoriesByDateRange(start, end);
      final sales = await getSalesByDateRange(start, end);
      final branchTransfers = await getBranchTransfersByDateRange(start, end);
      final scrapTransactions =
          await getScrapTransactionsByDateRange(start, end);
      final vouchers = await getvouchersByDateRange(start, end);
      final expenses = await getexpensesByDateRange(start, end);
      final managementDeposits =
          await getmanagementDepositsByDateRange(start, end);
      final managementImported =
          await getmanagementImportedByDateRange(start, end);

      // ✅ ولّد PDF من نفس الدالة بتاعتك
      final pdfData = await generatePdfReport(
          items,
          inventories,
          sales,
          branchTransfers,
          updates,
          scrapTransactions,
          vouchers,
          expenses,
          managementDeposits,
          managementImported,
          start,
          end);

      // ✅ حدد المسار
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final filePath =
          "${downloadsDir.path}/report_${DateTime.now().millisecondsSinceEpoch}.pdf";
      final file = File(filePath);

      // ✅ هنا بقى نكتب الداتا اللي انت مولدها
      await file.writeAsBytes(pdfData);

      print("🚀 التقرير اتحفظ هنا: $filePath");

      return true; // ✅ النجاح
    } catch (e) {
      print("❌ خطأ في إنشاء التقرير: $e");
      return false; // ❌ فشل
    }
  }

  /// ✅ دالة تعرض نافذة الطباعة مباشرة
  static Future<void> printReportTotal(DateTime start, DateTime end) async {
    final items = await getItemsByDateRange(start, end);
    final updates = await getupdatesByDateRange(start, end);
    final inventories = await getInventoriesByDateRange(start, end);
    final sales = await getSalesByDateRange(start, end);
    final branchTransfers = await getBranchTransfersByDateRange(start, end);
    final scrapTransactions = await getScrapTransactionsByDateRange(start, end);
    final vouchers = await getvouchersByDateRange(start, end);
    final expenses = await getexpensesByDateRange(start, end);
    final managementDeposits =
        await getmanagementDepositsByDateRange(start, end);
    final managementImported =
        await getmanagementImportedByDateRange(start, end);

    // ✅ ولّد PDF من نفس الدالة بتاعتك
    final pdfData = await generatePdfTotal(
        items,
        inventories,
        sales,
        branchTransfers,
        updates,
        scrapTransactions,
        vouchers,
        expenses,
        managementDeposits,
        managementImported,
        start,
        end);

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

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
      DateTime end) async {
    final pdf = pw.Document();

    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    // ---------------- إجماليات items ----------------
    int totalCount = 0;
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

// ---------------- إجماليات opening balance ----------------
    int openingCount = 0;
    double openingWeight = 0;
    double openingWage = 0;
    double openingCost = 0;

// ---------------- إجماليات التعديلات ----------------
    int updatedCount = 0;
    double updatedWeight = 0;
    double updatedWage = 0;
    double updatedCost = 0;

// ✅ تفاصيل الكارات لكل نوع (للعادية)
    int count18 = 0, count21 = 0, count22 = 0, countBullion = 0, countGem = 0;
    double weight18 = 0, weight21 = 0, weight22 = 0, weightBullion = 0;

// ✅ تفاصيل الكارات لكل نوع (للـ Opening)
    int opening18 = 0,
        opening21 = 0,
        opening22 = 0,
        openingBullion = 0,
        openingGem = 0;
    double openingWeight18 = 0,
        openingWeight21 = 0,
        openingWeight22 = 0,
        openingWeightBullion = 0;

// ✅ تفاصيل الكارات لكل نوع (للتعديلات)
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

      // ---------------- العادية أو الافتتاحية ----------------
      if (fromOpening) {
        // 🔹 إجماليات الافتتاحية
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
        // 🔹 إجماليات العادية
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
    // ---------------- التعديلات (مستقلة) ----------------
    for (var update in updates) {
      final payload = (update['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      final carat = payload['carat']?.toString();
      final category = update['category']?.toString();
      final updatedAt = update['updatedAt'];

      if (updatedAt != null) {
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

    // ---------------- إجماليات inventories ----------------
    int invTotalCount = inventories.length;
    double invTotalWeight = 0;
    double invTotalWage = 0;
    double invTotalCost = 0;

    int invCount18 = 0,
        invCount21 = 0,
        invCount22 = 0,
        invCountBullion = 0,
        invCountGem = 0;

// ✅ أوزان كل نوع
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

    // 🟡 استخراج الـ itemId من المخزون (inventories)
    // 🟡 استخراج الـ EPCs أو IDs من المخزون الحالي
    final invIds = inventories.map((inv) => inv['epcHex'] ?? inv['id']).toSet();

// 🟡 تحديد العناصر المفقودة (اللي مش موجودة في المخزون)
    final missingItems = items.where((item) {
      final id = item['epcHex'] ?? item['id'];
      return !invIds.contains(id);
    }).toList();

    // ---------------- إجماليات المفقود ----------------
    // ---------------- إجماليات المفقود ----------------
    int missingCount = 0;
    double missingWeight = 0;
    double missingWage = 0;
    double missingCost = 0;

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

    // ---------------- إجماليات المبيعات ----------------
    int salesTotalCount = sales.length;
    double salesTotalWeight = 0;
    double salesTotalWage = 0;
    double salesTotalCost = 0;

    int salesCount18 = 0,
        salesCount21 = 0,
        salesCount22 = 0,
        salesCountBullion = 0,
        salesCountGem = 0;

// ✅ أوزان كل نوع في المبيعات
    double salesWeight18 = 0,
        salesWeight21 = 0,
        salesWeight22 = 0,
        salesWeightBullion = 0;

    for (var sale in sales) {
      final payload = (sale['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      // جمع الإجماليات
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

    // ---------------- إجماليات الفروع ----------------
    int branchTransfersTotalCount = branchTransfers.length;
    double branchTransfersTotalWeight = 0;
    double branchTransfersTotalWage = 0;
    double branchTransfersTotalCost = 0;

    int branchTransfersCount18 = 0,
        branchTransfersCount21 = 0,
        branchTransfersCount22 = 0,
        branchTransfersCountBullion = 0,
        branchTransfersCountGem = 0;

// ✅ أوزان كل نوع في المبيعات
    double branchTransfersWeight18 = 0,
        branchTransfersWeight21 = 0,
        branchTransfersWeight22 = 0,
        branchTransfersWeightBullion = 0;

    for (var branchTransfer in branchTransfers) {
      final payload = (branchTransfer['payload'] ?? {}) as Map<String, dynamic>;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      final wage = double.tryParse(payload['wage']?.toString() ?? "0") ?? 0;
      final cost = double.tryParse(payload['cost']?.toString() ?? "0") ?? 0;

      // جمع الإجماليات
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

    // ---------------- إجماليات الكسر ----------------
    int scrapTransactionsTotalCount = 0;
    double scrapTransactionsTotalWeight = 0;
    double scrapTransactionsTotalcash = 0;
    double scrapTransactionsTotalnetwork = 0;
    double scrapTransactionsTotaltotal = 0;

    int scrapTransactionsCount18 = 0,
        scrapTransactionsCount14 = 0,
        scrapTransactionsCount24 = 0,
        scrapTransactionsCount21 = 0,
        scrapTransactionsCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
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

    // ---------------- إجماليات السندات ----------------
    int vouchersTotalCount = 0;
    int voucherspaymentCount = 0;
    int vouchersreceiptCount = 0;
    double vouchersTotalWeight = 0;
    double vouchersTotalcash = 0;
    double vouchersTotalnetwork = 0;
    double vouchersTotaltotal = 0;

    int vouchersCount18 = 0, vouchersCount21 = 0, vouchersCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
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

      if (type.isNotEmpty && type == 'payment') {
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
      } else if (type.isNotEmpty && type == 'receipt') {
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

    // ---------------- إجماليات المصروفات ----------------
    int expensesTotalCount = 0;
    double expensesTotal = 0;

    //int scrapTransactionsCount18 = 0, scrapTransactionsCount21 = 0, scrapTransactionsCount22 = 0;

// ✅ أوزان كل نوع في المبيعات
    //double scrapTransactionsWeight18 = 0, scrapTransactionsWeight21 = 0, scrapTransactionsWeight22 = 0;

    for (var expense in expenses) {
      final amount = double.tryParse(expense['amount']?.toString() ?? "0") ?? 0;
      expensesTotal += amount;
      expensesTotalCount += 1;
    }

    // ---------------- إجماليات توريدات الادارة  ----------------
    int managementDepositsTotalCount = 0;
    double managementDepositsTotalcash = 0;
    double managementDepositsTotalnetwork = 0;
    double managementDepositsTotaltotal = 0;

    for (var managementDeposit in managementDeposits) {
      final cash =
          double.tryParse(managementDeposit['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(managementDeposit['visa']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(managementDeposit['total']?.toString() ?? "0") ?? 0;
      managementDepositsTotalCount += 1;
      managementDepositsTotalcash += cash;
      managementDepositsTotalnetwork += network;
      managementDepositsTotaltotal += total;
    }

    // ---------------- إجماليات الاستيرادات من الادارة  ----------------
    int managementImportedTotalCount = 0;
    double managementImportedTotalcash = 0;
    double managementImportedTotalnetwork = 0;
    double managementImportedTotaltotal = 0;

    for (var managementImport in managementImported) {
      final cash =
          double.tryParse(managementImport['cash']?.toString() ?? "0") ?? 0;
      final network =
          double.tryParse(managementImport['visa']?.toString() ?? "0") ?? 0;
      final total =
          double.tryParse(managementImport['total']?.toString() ?? "0") ?? 0;
      managementImportedTotalCount += 1;
      managementImportedTotalcash += cash;
      managementImportedTotalnetwork += network;
      managementImportedTotaltotal += total;
    }

    // ---------------- إجماليات البائعين ----------------
    final Map<String, Map<String, double>> sellersTotals = {};

    for (var sale in sales) {
      final payment = sale['payment'] as Map<String, dynamic>? ?? {};

      final soldBy = payment['soldBy']?.toString() ?? 'غير معروف';

      final total = (payment['total'] ?? 0).toDouble();
      final cash = (payment['cash'] ?? 0).toDouble();
      final visa = (payment['visa'] ?? 0).toDouble();

      sellersTotals.putIfAbsent(
          soldBy,
          () => {
                'total': 0,
                'cash': 0,
                'visa': 0,
              });

      sellersTotals[soldBy]!['total'] =
          sellersTotals[soldBy]!['total']! + total;
      sellersTotals[soldBy]!['cash'] = sellersTotals[soldBy]!['cash']! + cash;
      sellersTotals[soldBy]!['visa'] = sellersTotals[soldBy]!['visa']! + visa;
    }

    // ---------------- PDF ----------------
    // صفحة العنوان والفترة
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/gold.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          final pageWidth = PdfPageFormat.a4.width;
          final pageHeight = PdfPageFormat.a4.height;

          return pw.Stack(
            children: [
              // برواز ذهبي
              pw.Container(
                width: pageWidth,
                height: pageHeight,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border.all(color: PdfColors.amber600, width: 3),
                ),
              ),

              // المحتوى
              pw.Padding(
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // ✅ أيقونة ذهبية من صورة
                    pw.Image(image, width: 60, height: 60),

                    pw.SizedBox(height: 10),

                    // العنوان في النص
                    pw.Text(
                      "تقارير الاجماليات",
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),

                    pw.SizedBox(height: 6),

                    // خط ذهبي تحت العنوان
                    pw.Container(
                      height: 2,
                      width: pageWidth * 0.4,
                      color: PdfColors.amber600,
                    ),

                    pw.SizedBox(height: 20),

                    // الفترة
                    pw.Text(
                      "الفترة من ${DateFormat('yyyy/MM/dd').format(start)} "
                      "إلى ${DateFormat('yyyy/MM/dd').format(end)}",
                      style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الرصيد الافتتاحي",
              style:
                  pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
          _buildtotals(
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
            openingWeightBullion,
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text("إجماليات الإدخال",
              style:
                  pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
          _buildtotals(
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
            weightBullion,
          ),
        ],
      ),
    );

    // ✅ صفحة المفقودين
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text("إجماليات المفقود",
              style:
                  pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
          _buildtotals(
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
            missingWeightBullion,
          ),
        ],
      ),
    );

    // صفحة جدول الجرد
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الجرد",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          _buildtotals(
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
            invWeightBullion,
          ),
        ],
      ),
    );

    // ✅ صفحة جدول التعديلات
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text("إجماليات التعديلات",
              style:
                  pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold)),
          _buildtotals(
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
            updatedWeightBullion,
          ),
        ],
      ),
    );

// صفحة جدول المبيعات
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات المبيعات",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          _buildtotals(
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
            salesWeightBullion,
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات البائعين",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
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
              // 🔹 الهيدر
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _cell("البائع", bold: true),
                  _cell("الإجمالي", bold: true),
                  _cell("كاش", bold: true),
                  _cell("شبكة", bold: true),
                ],
              ),

              // 🔹 البيانات
              ...sellersTotals.entries.map((e) {
                return pw.TableRow(
                  children: [
                    _cell(e.key),
                    _cell(e.value['total']!.toStringAsFixed(2)),
                    _cell(e.value['cash']!.toStringAsFixed(2)),
                    _cell(e.value['visa']!.toStringAsFixed(2)),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات التحويلات",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          _buildtotals(
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
            branchTransfersWeightBullion,
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الكسر",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد الشرائح: $scrapTransactionsTotalCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 14 : $scrapTransactionsCount14             ( وزن:   ${scrapTransactionsWeight14.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 18 : $scrapTransactionsCount18             ( وزن:   ${scrapTransactionsWeight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 21 : $scrapTransactionsCount21              ( وزن:  ${scrapTransactionsWeight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 22 : $scrapTransactionsCount22              ( وزن:  ${scrapTransactionsWeight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد شرائح عيار 24 : $scrapTransactionsCount24             ( وزن: ${scrapTransactionsWeight24.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${scrapTransactionsTotalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${scrapTransactionsTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${scrapTransactionsTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${scrapTransactionsTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات السندات",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد السندات: $vouchersTotalCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي عدد سندات الصرف: $voucherspaymentCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي عدد سندات القبض: $vouchersreceiptCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 18 : $vouchersCount18             ( وزن:   ${vouchersWeight18.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 21 : $vouchersCount21              ( وزن:  ${vouchersWeight21.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "عدد سندات عيار 22 : $vouchersCount22              ( وزن:  ${vouchersWeight22.toStringAsFixed(2)} )",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الوزن الكلي : ${vouchersTotalWeight.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${vouchersTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${vouchersTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${vouchersTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجمالي المصروفات",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد المصروفات: $expensesTotalCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text: "إجمالي قيمة المصروفات: $expensesTotal",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات التوريد للادارة ",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد التوريدات: $managementDepositsTotalCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${managementDepositsTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${managementDepositsTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${managementDepositsTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) => [
          pw.SizedBox(height: 10),
          pw.Text(
            "إجماليات الاستيرادات من الادارة ",
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          ),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Bullet(
                  text: "إجمالي عدد الاستيردات: $managementImportedTotalCount",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الشبكة الكلي : ${managementImportedTotalnetwork.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي الكاش الكلي : ${managementImportedTotalcash.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Bullet(
                  text:
                      "إجمالي السعر الكلي : ${managementImportedTotaltotal.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontSize: 20),
                  textAlign: pw.TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // 🧾 صفحة عمليات الصندوق
    try {
      double sum = 0.0;
      double cash = 0.0;
      double visa = 0.0;
      //List<Map<String, dynamic>> all = [];

      // 🟢 بيع القطع
      final salesSnap = await FS.salesCol().get();
      for (var d in salesSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['payment']?['total'] ?? 0).toDouble();
        final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
        final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
        final date = (data['createdAt'] as Timestamp?)?.toDate();

        sum += wage;
        cash += totalcash;
        visa += totalvisa;
      }

      // 🟢 بيع كسر
      final scrapSnap =
          await FS.scrapCol().where("type", isEqualTo: "sale").get();
      for (var d in scrapSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum += wage;
        cash += totalcash;
        visa += totalvisa;
      }

      // 🔴 شراء كسر
      final scrapBuySnap =
          await FS.scrapCol().where("type", isEqualTo: "add").get();
      for (var d in scrapBuySnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔴 سندات الصرف
      final vouchersSnap =
          await FS.vouchersCol().where("type", isEqualTo: "payment").get();
      for (var d in vouchersSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final wage = (data['total'] ?? 0).toDouble();
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['network'] ?? 0).toDouble();
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= wage;
        cash -= totalcash;
        visa -= totalvisa;
      }

      // 🔴 المصروفات
      final expSnap = await FS.expensesCol().get();
      for (var d in expSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
        final date = (data['date'] as Timestamp?)?.toDate();

        //final displayType = _t('مصروف', 'Expense');

        sum -= amount;
        cash -= amount;
      }

      // 🔵 توريد للإدارة
      final depositSnap = await FS.depositsCol().get();
      for (var d in depositSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();

        sum -= totalValue;
        cash -= totalcash;
        visa -= totalvisa;
      }
      // 🔵 استيراد من الإدارة
      final ImportSnap = await FS.ImportedCol().get();
      for (var d in ImportSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        final totalcash = (data['cash'] ?? 0).toDouble();
        final totalvisa = (data['visa'] ?? 0).toDouble();
        final totalValue = totalcash + totalvisa;
        final date = (data['date'] as Timestamp?)?.toDate();

        sum += totalValue;
        cash += totalcash;
        visa += totalvisa;
      }

      //print("✅ تم حساب البيانات بنجاح. عدد الصفوف: ${cashBoxRows.length}");
      print("الإجمالي الكاش: $cash - الشبكة: $visa - الكلي: $sum");

      // صفحة الـ PDF
      // 🧾 صفحة عمليات الصندوق
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicFontBold,
          ),
          build: (context) => [
            pw.SizedBox(height: 15),

            // 🧮 إجماليات الصندوق
            pw.Text(
              "إجماليات الصندوق",
              style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الكاش",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        cash.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("إجمالي الشبكة",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        visa.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text("الإجمالي الكلي",
                          style: pw.TextStyle(
                              fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        sum.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 20),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e, st) {
      print("❌ خطأ أثناء إنشاء صفحة الصندوق: $e");
      print(st);
    }

    return pdf.save();
  }

  /// ✅ ترجمة الفئات
  static String translateCategory(String? category) {
    switch (category) {
      case 'bullion':
        return "سبائك";
      case 'gem':
        return "أحجار كريمة";
      case 'gold':
        return "ذهب";
      default:
        return "غير محدد";
    }
  }

  /// ✅ بناء جزء الإجماليات
  static pw.Widget _buildTotals(
    int totalCount,
    int count18,
    int count21,
    int count22,
    int countBullion,
    int countGem,
    double totalWeight,
    double totalWage,
    double totalCost,
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
            text: "إجمالي عدد الشرائح: $totalCount",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "عدد الأحجار الكريمة : $countGem",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.right,
          ),
        ],
      ),
    );
  }

  /// ✅ بناء جزء الإجماليات
  static pw.Widget _buildtotals(
    int totalCount,
    int count18,
    int count21,
    int count22,
    int countBullion,
    int countGem,
    double totalWeight,
    double totalWage,
    double totalCost,
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
            text: "إجمالي عدد الشرائح: $totalCount",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 18 : $count18             ( وزن:   ${weight18.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 21 : $count21              ( وزن:  ${weight21.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد شرائح عيار 22 : $count22             ( وزن:   ${weight22.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text:
                "عدد السبائك : $countBullion             ( وزن:    ${weightBullion.toStringAsFixed(2)} )",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "عدد الأحجار الكريمة : $countGem",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي الوزن الكلي : ${totalWeight.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي الأجر الكلي : ${totalWage.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
          pw.Bullet(
            text: "إجمالي التكلفة الكلية : ${totalCost.toStringAsFixed(2)}",
            style: pw.TextStyle(fontSize: 20),
            textAlign: pw.TextAlign.right,
          ),
        ],
      ),
    );
  }
}

pw.Widget _cell(String text, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
      textAlign: pw.TextAlign.center,
    ),
  );
}
