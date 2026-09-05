// // // // import 'package:flutter/material.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../services/firestore_service.dart';

// // // // class CashBoxPage extends StatefulWidget {
// // // //   const CashBoxPage({super.key});

// // // //   @override
// // // //   State<CashBoxPage> createState() => _CashBoxPageState();
// // // // }

// // // // class _CashBoxPageState extends State<CashBoxPage> {
// // // //   double total = 0.0;
// // // //   double cashtotal = 0.0;
// // // //   double visatotal = 0.0;
// // // //   List<Map<String, dynamic>> transactions = [];
// // // //   bool loading = true;
// // // //   String _lang = 'ar';

// // // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadLanguage();
// // // //     _loadData();
// // // //   }

// // // //   Future<void> _loadLanguage() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     setState(() {
// // // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // // //     });
// // // //   }

// // // //   Future<void> _loadData() async {
// // // //     double sum = 0.0;
// // // //     double cash = 0.0;
// // // //     double visa = 0.0;
// // // //     List<Map<String, dynamic>> all = [];

// // // //     // 🟢 بيع القطع
// // // //     final salesSnap = await FS.salesCol().get();
// // // //     for (var d in salesSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final wage = (data['payment']?['total'] ?? 0).toDouble();
// // // //       final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
// // // //       final date = (data['createdAt'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("بيع قطعة", "Piece Sale"),
// // // //         "value": wage,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum += wage;
// // // //       cash += totalcash;
// // // //       visa += totalvisa;
// // // //     }

// // // //     // 🟢 بيع كسر
// // // //     final scrapSnap = await FS.scrapCol().where("type", isEqualTo: "sale").get();
// // // //     for (var d in scrapSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final wage = (data['total'] ?? 0).toDouble();
// // // //       final totalcash = (data['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['network'] ?? 0).toDouble();
// // // //       final date = (data['date'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("بيع كسر", "Scrap Sale"),
// // // //         "value": wage,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum += wage;
// // // //       cash += totalcash;
// // // //       visa += totalvisa;
// // // //     }

// // // //     // 🔴 شراء كسر
// // // //     final scrapBuySnap = await FS.scrapCol().where("type", isEqualTo: "add").get();
// // // //     for (var d in scrapBuySnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final wage = (data['total'] ?? 0).toDouble();
// // // //       final totalcash = (data['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['network'] ?? 0).toDouble();
// // // //       final date = (data['date'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("شراء كسر", "Scrap Purchase"),
// // // //         "value": -wage,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum -= wage;
// // // //       cash -= totalcash;
// // // //       visa -= totalvisa;
// // // //     }

// // // //     // 🔴 سندات الصرف
// // // //     final vouchersSnap = await FS.vouchersCol().where("type", isEqualTo: "payment").get();
// // // //     for (var d in vouchersSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final wage = (data['total'] ?? 0).toDouble();
// // // //       final totalcash = (data['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['network'] ?? 0).toDouble();
// // // //       final date = (data['date'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("سند صرف", "Payment Voucher"),
// // // //         "value": -wage,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum -= wage;
// // // //       cash -= totalcash;
// // // //       visa -= totalvisa;
// // // //     }

// // // //     // 🔴 المصروفات
// // // //     final expSnap = await FS.expensesCol().get();
// // // //     for (var d in expSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
// // // //       final date = (data['date'] as Timestamp?)?.toDate();

// // // //       final displayType = _t('مصروف', 'Expense');
// // // //       all.add({
// // // //         "type": displayType,
// // // //         "value": -amount,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum -= amount;
// // // //       cash -= amount;
// // // //     }

// // // //     // 🔵 توريد للإدارة
// // // //     final depositSnap = await FS.depositsCol().get();
// // // //     for (var d in depositSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final totalcash = (data['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['visa'] ?? 0).toDouble();
// // // //       final totalValue = totalcash + totalvisa;
// // // //       final date = (data['date'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("توريد للإدارة", "Deposit to Admin"),
// // // //         "value": -totalValue,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum -= totalValue;
// // // //       cash -= totalcash;
// // // //       visa -= totalvisa;
// // // //     }
// // // //     // 🔵 استيراد من الإدارة
// // // //     final ImportSnap = await FS.ImportedCol().get();
// // // //     for (var d in ImportSnap.docs) {
// // // //       final data = d.data() as Map<String, dynamic>;
// // // //       final totalcash = (data['cash'] ?? 0).toDouble();
// // // //       final totalvisa = (data['visa'] ?? 0).toDouble();
// // // //       final totalValue = totalcash + totalvisa;
// // // //       final date = (data['date'] as Timestamp?)?.toDate();
// // // //       all.add({
// // // //         "type": _t("استيراد من الادارة", "Deposit to Admin"),
// // // //         "value": totalValue,
// // // //         "date": date,
// // // //         "data": data,
// // // //       });
// // // //       sum += totalValue;
// // // //       cash += totalcash;
// // // //       visa += totalvisa;
// // // //     }

// // // //     all.sort((a, b) => (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

// // // //     setState(() {
// // // //       total = sum;
// // // //       cashtotal = cash;
// // // //       visatotal = visa;
// // // //       transactions = all;
// // // //       loading = false;
// // // //     });
// // // //   }

// // // //   void _addDepositDialog() {
// // // //     String type = "كاش";
// // // //     final cashCtrl = TextEditingController();
// // // //     final visaCtrl = TextEditingController();

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => StatefulBuilder(
// // // //         builder: (context, setDialogState) => AlertDialog(
// // // //           title: Text(_t("توريد للإدارة", "Deposit to Admin")),
// // // //           content: Column(
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             children: [
// // // //               DropdownButton<String>(
// // // //                 value: type,
// // // //                 isExpanded: true,
// // // //                 items: [
// // // //                   DropdownMenuItem(value: "كاش", child: Text(_t("كاش", "Cash"))),
// // // //                   DropdownMenuItem(value: "شبكة", child: Text(_t("شبكة", "Network"))),
// // // //                   DropdownMenuItem(value: "متعدد", child: Text(_t("متعدد", "Mixed"))),
// // // //                 ],
// // // //                 onChanged: (val) => setDialogState(() => type = val!),
// // // //               ),
// // // //               if (type == "كاش" || type == "متعدد")
// // // //                 TextField(
// // // //                   controller: cashCtrl,
// // // //                   keyboardType: TextInputType.number,
// // // //                   decoration: InputDecoration(labelText: _t("مبلغ الكاش", "Cash Amount")),
// // // //                 ),
// // // //               const SizedBox(height: 15),
// // // //               if (type == "شبكة" || type == "متعدد")
// // // //                 TextField(
// // // //                   controller: visaCtrl,
// // // //                   keyboardType: TextInputType.number,
// // // //                   decoration: InputDecoration(labelText: _t("مبلغ الشبكة", "Network Amount")),
// // // //                 ),
// // // //             ],
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context),
// // // //               child: Text(_t("إلغاء", "Cancel")),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () async {
// // // //                 final cash = double.tryParse(cashCtrl.text) ?? 0.0;
// // // //                 final visa = double.tryParse(visaCtrl.text) ?? 0.0;
// // // //                 await FS.depositsCol().add({
// // // //                   "type": type,
// // // //                   "cash": cash,
// // // //                   "total": cash + visa,
// // // //                   "visa": visa,
// // // //                   "date": DateTime.now(),
// // // //                 });
// // // //                 Navigator.pop(context);
// // // //                 _loadData();
// // // //               },
// // // //               child: Text(_t("حفظ", "Save")),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //   void _addImportedDialog() {
// // // //     String type = "كاش";
// // // //     final cashCtrl = TextEditingController();
// // // //     final visaCtrl = TextEditingController();

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => StatefulBuilder(
// // // //         builder: (context, setDialogState) => AlertDialog(
// // // //           title: Text(_t("استيراد من الادارة", "Import from Admin")),
// // // //           content: Column(
// // // //             mainAxisSize: MainAxisSize.min,
// // // //             children: [
// // // //               DropdownButton<String>(
// // // //                 value: type,
// // // //                 isExpanded: true,
// // // //                 items: [
// // // //                   DropdownMenuItem(value: "كاش", child: Text(_t("كاش", "Cash"))),
// // // //                   DropdownMenuItem(value: "شبكة", child: Text(_t("شبكة", "Network"))),
// // // //                   DropdownMenuItem(value: "متعدد", child: Text(_t("متعدد", "Mixed"))),
// // // //                 ],
// // // //                 onChanged: (val) => setDialogState(() => type = val!),
// // // //               ),
// // // //               if (type == "كاش" || type == "متعدد")
// // // //                 TextField(
// // // //                   controller: cashCtrl,
// // // //                   keyboardType: TextInputType.number,
// // // //                   decoration: InputDecoration(labelText: _t("مبلغ الكاش", "Cash Amount")),
// // // //                 ),
// // // //               const SizedBox(height: 15),
// // // //               if (type == "شبكة" || type == "متعدد")
// // // //                 TextField(
// // // //                   controller: visaCtrl,
// // // //                   keyboardType: TextInputType.number,
// // // //                   decoration: InputDecoration(labelText: _t("مبلغ الشبكة", "Network Amount")),
// // // //                 ),
// // // //             ],
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context),
// // // //               child: Text(_t("إلغاء", "Cancel")),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () async {
// // // //                 final cash = double.tryParse(cashCtrl.text) ?? 0.0;
// // // //                 final visa = double.tryParse(visaCtrl.text) ?? 0.0;
// // // //                 await FS.ImportedCol().add({
// // // //                   "type": type,
// // // //                   "cash": cash,
// // // //                   "total": cash + visa,
// // // //                   "visa": visa,
// // // //                   "date": DateTime.now(),
// // // //                 });
// // // //                 Navigator.pop(context);
// // // //                 _loadData();
// // // //               },
// // // //               child: Text(_t("حفظ", "Save")),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // //   final Map<String, Map<String, String>> fieldNames = {
// // // //     "person": {"ar": "المعاملة", "en": "Transaction"},
// // // //     "wage": {"ar": "الأجر", "en": "Wage"},
// // // //     "weight": {"ar": "الوزن", "en": "Weight"},
// // // //     "carat": {"ar": "العيار", "en": "Carat"},
// // // //     "notes": {"ar": "ملاحظات", "en": "Notes"},
// // // //     "note": {"ar": "ملاحظات", "en": "Note"},
// // // //     "type": {"ar": "النوع", "en": "Type"},
// // // //     "amount": {"ar": "المبلغ", "en": "Amount"},
// // // //     "createdAt": {"ar": "تاريخ الإنشاء", "en": "Created At"},
// // // //     "date": {"ar": "التاريخ", "en": "Date"},
// // // //     "delegate": {"ar": "المندوب", "en": "Delegate"},
// // // //     "supplier": {"ar": "المورد", "en": "Supplier"},
// // // //     "category": {"ar": "الفئة", "en": "Category"},
// // // //     "price": {"ar": "السعر", "en": "Price"},
// // // //     "total": {"ar": "الإجمالي", "en": "Total"},
// // // //     "itemId": {"ar": "رقم القطعة", "en": "Item ID"},
// // // //     "epcHex": {"ar": "Rfid", "en": "Rfid"},
// // // //     "qrCode": {"ar": "الكود", "en": "QR Code"},
// // // //     "showQr": {"ar": "عرض QR", "en": "Show QR"},
// // // //     "kind": {"ar": "النوع", "en": "Kind"},
// // // //     "visa": {"ar": "شبكة", "en": "Network"},
// // // //     "cash": {"ar": "كاش", "en": "Cash"},
// // // //     "payload": {"ar": "تفاصيل الشريحة", "en": "Payload Details"},
// // // //     "payment": {"ar": "تفاصيل الدفع", "en": "Payment Details"},
// // // //     "soldAt": {"ar": "تاريخ البيع", "en": "Sold At"},
// // // //     "supplierName": {"ar": "اسم المورد", "en": "Supplier Name"},
// // // //     "supplierId": {"ar": "الرقم التسلسلي", "en": "Supplier ID"},
// // // //     "network": {"ar": "شبكة", "en": "Network"},
// // // //     "paymentMethod": {"ar": "طريقة الدفع", "en": "Payment Method"},
// // // //     "cost": {"ar": "التكلفة", "en": "Cost"},
// // // //     "updatedAt": {"ar": "تاريخ التحديث", "en": "Updated At"},
// // // //     "soldBy": {"ar": "بيع بواسطة", "en": "soldBy"},
// // // //     "partialSale": {"ar": "بيع جزئي", "en": "partialSale"},
// // // //   };

// // // //   void _showDetails(Map<String, dynamic> data, String type) {
// // // //     List<Widget> buildFields(dynamic value, {String? key, int indent = 0}) {
// // // //       List<Widget> widgets = [];

// // // //       if (value is Map<String, dynamic>) {
// // // //         value.forEach((k, v) {
// // // //           widgets.addAll(buildFields(v, key: k, indent: indent + 1));
// // // //         });
// // // //       } else if (value is List) {
// // // //         for (int i = 0; i < value.length; i++) {
// // // //           widgets.addAll(buildFields(value[i], key: "${key ?? 'Item'} ${i+1}", indent: indent + 1));
// // // //         }
// // // //       } else {
// // // //         String label = key != null ? (fieldNames[key]?[_lang] ?? key) : '';
// // // //         if (value is Timestamp) value = value.toDate().toString().split(' ').first;
// // // //         widgets.add(
// // // //           Padding(
// // // //             padding: EdgeInsets.only(left: indent * 12.0, top: 4),
// // // //             child: Row(
// // // //               children: [
// // // //                 Expanded(child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
// // // //                 Expanded(child: Text(value.toString(), textAlign: TextAlign.right)),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         );
// // // //       }

// // // //       return widgets;
// // // //     }

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => AlertDialog(
// // // //         title: Text(_lang == 'ar' ? "تفاصيل $type" : "$type Details"),
// // // //         content: SingleChildScrollView(
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: buildFields(data),
// // // //           ),
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: Text(_lang == 'ar' ? "إغلاق" : "Close"),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text(_t("الصندوق", "Cash Box")),
// // // //         backgroundColor: const Color(0xFFD4AF37),
// // // //         centerTitle: true,
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: const Icon(Icons.upload),
// // // //             tooltip: _t("توريد للإدارة", "Deposit to Admin"),
// // // //             onPressed: _addDepositDialog,
// // // //           ),
// // // //           IconButton(
// // // //             icon: const Icon(Icons.download),
// // // //             tooltip: _t("استيراد من الادارة", "Import from Admin"),
// // // //             onPressed: _addImportedDialog,
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: loading
// // // //           ? const Center(child: CircularProgressIndicator())
// // // //           : Padding(
// // // //         padding: const EdgeInsets.all(12),
// // // //         child: Column(
// // // //           children: [
// // // //             Card(
// // // //               color: Colors.green[50],
// // // //               elevation: 3,
// // // //               child: Padding(
// // // //                 padding: const EdgeInsets.all(16),
// // // //                 child: Column(
// // // //                   children: [
// // // //                     Text(
// // // //                       _t("إجمالي الصندوق", "Total Balance"),
// // // //                       style: const TextStyle(fontWeight: FontWeight.bold),
// // // //                     ),
// // // //                     Text(
// // // //                       "${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
// // // //                       style: TextStyle(
// // // //                         fontSize: 22,
// // // //                         color: total >= 0 ? Colors.green : Colors.red,
// // // //                       ),
// // // //                     ),
// // // //                     Row(
// // // //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //                       children: [
// // // //                         Column(children: [
// // // //                           Text(_t("كاش", "Cash"),
// // // //                               style: const TextStyle(fontWeight: FontWeight.bold)),
// // // //                           Text(cashtotal.toStringAsFixed(2)),
// // // //                         ]),
// // // //                         Column(children: [
// // // //                           Text(_t("شبكة", "Network"),
// // // //                               style: const TextStyle(fontWeight: FontWeight.bold)),
// // // //                           Text(visatotal.toStringAsFixed(2)),
// // // //                         ]),
// // // //                       ],
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             Expanded(
// // // //               child: Card(
// // // //                 elevation: 3,
// // // //                 child: ListView.separated(
// // // //                   itemCount: transactions.length,
// // // //                   separatorBuilder: (_, __) => const Divider(height: 0),
// // // //                   itemBuilder: (context, index) {
// // // //                     final t = transactions[index];
// // // //                     final date = t['date'] != null
// // // //                         ? "${t['date'].day}/${t['date'].month}/${t['date'].year}"
// // // //                         : '';
// // // //                     return ListTile(
// // // //                       onTap: () => _showDetails(t['data'], t['type']),
// // // //                       leading: Icon(
// // // //                         t['value'] >= 0
// // // //                             ? Icons.add_circle
// // // //                             : Icons.remove_circle,
// // // //                         color:
// // // //                         t['value'] >= 0 ? Colors.green : Colors.red,
// // // //                       ),
// // // //                       title: Text(t['type']),
// // // //                       subtitle: Text(date),
// // // //                       trailing: Text(
// // // //                         "${t['value'] >= 0 ? '+' : ''}${t['value'].toStringAsFixed(2)}",
// // // //                         style: TextStyle(
// // // //                           color: t['value'] >= 0
// // // //                               ? Colors.green
// // // //                               : Colors.red,
// // // //                           fontWeight: FontWeight.bold,
// // // //                         ),
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // // }
// // // // import 'package:flutter/material.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../services/firestore_service.dart';

// // // // class CashBoxPage extends StatefulWidget {
// // // //   const CashBoxPage({super.key});

// // // //   @override
// // // //   State<CashBoxPage> createState() => _CashBoxPageState();
// // // // }

// // // // class _CashBoxPageState extends State<CashBoxPage>
// // // //     with SingleTickerProviderStateMixin {
// // // //   // ===== ألوان التصميم (Dark theme متوافق مع لون البرنامج الذهبي) =====
// // // //   static const Color kGold = Color(0xFFD4AF37);
// // // //   static const Color kBackground = Color(0xFF121212);
// // // //   static const Color kCard = Color(0xFF1C1C1C);
// // // //   static const Color kCardBorder = Color(0xFF2A2A2A);
// // // //   static const Color kFieldFill = Color(0xFF161616);
// // // //   static const Color kGreen = Color(0xFF4CAF50);
// // // //   static const Color kRed = Color(0xFFE05353);
// // // //   static const Color kTextSecondary = Color(0xFF9E9E9E);

// // // //   // ===== متغيرات الأقسام =====
// // // //   double totalBalance = 0.0; // إجمالي الصندوق (جميع الأقسام)
// // // //   double cashTotal = 0.0; // إجمالي النقدي
// // // //   double networkTotal = 0.0; // إجمالي الشبكة

// // // //   // ===== الخزنة (نقدي) =====
// // // //   double safeCash = 0.0;
// // // //   double safeNetwork = 0.0;

// // // //   // ===== الخزنة (ذهب) =====
// // // //   double goldTotal24K = 0.0;
// // // //   double goldTotalActual = 0.0;
// // // //   double goldScrapWeight = 0.0;
// // // //   double goldWorkedWeight = 0.0;
// // // //   List<Map<String, dynamic>> goldTransactions = [];

// // // //   // ===== صندوق اليومي (مثال) =====
// // // //   double dailyCash = 0.0;
// // // //   double dailyNetwork = 0.0;
// // // //   List<Map<String, dynamic>> dailyTransactions = [];

// // // //   // ===== صندوق الكسر (مثال) =====
// // // //   double scrapCash = 0.0;
// // // //   double scrapNetwork = 0.0;
// // // //   List<Map<String, dynamic>> scrapTransactions = [];

// // // //   bool loading = true;
// // // //   String _lang = 'ar';
// // // //   late TabController _tabController;

// // // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _tabController = TabController(length: 3, vsync: this);
// // // //     _loadLanguage();
// // // //     _loadAllData();
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     _tabController.dispose();
// // // //     super.dispose();
// // // //   }

// // // //   Future<void> _loadLanguage() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     setState(() {
// // // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // // //     });
// // // //   }

// // // //   // ===== تحميل جميع البيانات =====
// // // //   Future<void> _loadAllData() async {
// // // //     setState(() => loading = true);
// // // //     try {
// // // //       // 1. جلب رصيد الخزنة النقدي
// // // //       final cashBalance = await FS.getCashBoxBalance();
// // // //       safeCash = cashBalance['cash']!;
// // // //       safeNetwork = cashBalance['network']!;

// // // //       // 2. جلب ملخص الذهب في الخزنة
// // // //       final goldSummary = await FS.getSafeGoldSummary();
// // // //       goldTotal24K = goldSummary['total24K'] ?? 0.0;
// // // //       goldTotalActual = goldSummary['totalActual'] ?? 0.0;
// // // //       goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
// // // //       goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
// // // //       goldTransactions =
// // // //           List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

// // // //       // 3. جلب بيانات صندوق اليومي (مؤقت)
// // // //       final dailyData = await _getDailyBoxData();
// // // //       dailyCash = dailyData['cash'];
// // // //       dailyNetwork = dailyData['network'];
// // // //       dailyTransactions = dailyData['transactions'];

// // // //       // 4. جلب بيانات صندوق الكسر (مؤقت)
// // // //       final scrapData = await _getScrapBoxData();
// // // //       scrapCash = scrapData['cash'];
// // // //       scrapNetwork = scrapData['network'];
// // // //       scrapTransactions = scrapData['transactions'];

// // // //       // 5. حساب الإجمالي العام
// // // //       totalBalance = (safeCash + safeNetwork) +
// // // //           (dailyCash + dailyNetwork) +
// // // //           (scrapCash + scrapNetwork);
// // // //       cashTotal = safeCash + dailyCash + scrapCash;
// // // //       networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

// // // //       setState(() => loading = false);
// // // //     } catch (e) {
// // // //       setState(() => loading = false);
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
// // // //       );
// // // //     }
// // // //   }

// // // //   // ===== دوال جلب البيانات المؤقتة (يمكنك تعديلها حسب هيكل قاعدة البيانات) =====
// // // //   Future<Map<String, dynamic>> _getDailyBoxData() async {
// // // //     // مثال: نجلب من sales
// // // //     double cash = 0.0, network = 0.0;
// // // //     List<Map<String, dynamic>> transactions = [];

// // // //     final salesSnap = await FS.salesCol().get();
// // // //     for (var doc in salesSnap.docs) {
// // // //       final data = doc.data() as Map<String, dynamic>;
// // // //       final payment = data['payment'] ?? {};
// // // //       cash += (payment['cash'] ?? 0.0).toDouble();
// // // //       network += (payment['network'] ?? 0.0).toDouble();
// // // //       transactions.add({
// // // //         'type': 'بيع',
// // // //         'cash': payment['cash'] ?? 0.0,
// // // //         'network': payment['network'] ?? 0.0,
// // // //         'date': data['soldAt'] ?? data['createdAt'],
// // // //         'data': data,
// // // //       });
// // // //     }
// // // //     return {'cash': cash, 'network': network, 'transactions': transactions};
// // // //   }

// // // //   Future<Map<String, dynamic>> _getScrapBoxData() async {
// // // //     double cash = 0.0, network = 0.0;
// // // //     List<Map<String, dynamic>> transactions = [];

// // // //     final scrapSnap = await FS.scrapCol().get();
// // // //     for (var doc in scrapSnap.docs) {
// // // //       final data = doc.data() as Map<String, dynamic>;
// // // //       final type = data['type'] ?? '';
// // // //       final c = (data['cash'] ?? 0.0).toDouble();
// // // //       final n = (data['network'] ?? 0.0).toDouble();

// // // //       if (type == 'add') {
// // // //         cash -= c;
// // // //         network -= n;
// // // //         transactions.add({
// // // //           'type': 'شراء كسر',
// // // //           'cash': -c,
// // // //           'network': -n,
// // // //           'date': data['date'],
// // // //           'data': data
// // // //         });
// // // //       } else if (type == 'sale') {
// // // //         cash += c;
// // // //         network += n;
// // // //         transactions.add({
// // // //           'type': 'بيع كسر',
// // // //           'cash': c,
// // // //           'network': n,
// // // //           'date': data['date'],
// // // //           'data': data
// // // //         });
// // // //       } else if (type == 'payment') {
// // // //         cash -= c;
// // // //         network -= n;
// // // //         transactions.add({
// // // //           'type': 'سند صرف',
// // // //           'cash': -c,
// // // //           'network': -n,
// // // //           'date': data['date'],
// // // //           'data': data
// // // //         });
// // // //       }
// // // //     }
// // // //     return {'cash': cash, 'network': network, 'transactions': transactions};
// // // //   }

// // // //   // =========================================================================
// // // //   // عناصر تصميم مشتركة (Segmented toggle / حقول نصية داكنة / أزرار كبسولية)
// // // //   // =========================================================================

// // // //   Widget _segmentedToggle({
// // // //     required List<MapEntry<String, String>> options, // value -> label
// // // //     required String value,
// // // //     required ValueChanged<String> onChanged,
// // // //   }) {
// // // //     return Row(
// // // //       children: options.map((opt) {
// // // //         final selected = opt.key == value;
// // // //         return Expanded(
// // // //           child: GestureDetector(
// // // //             onTap: () => onChanged(opt.key),
// // // //             child: Container(
// // // //               margin: const EdgeInsets.symmetric(horizontal: 4),
// // // //               padding: const EdgeInsets.symmetric(vertical: 12),
// // // //               decoration: BoxDecoration(
// // // //                 color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
// // // //                 borderRadius: BorderRadius.circular(30),
// // // //                 border: Border.all(
// // // //                     color: selected ? kGold : kCardBorder, width: 1.2),
// // // //               ),
// // // //               child: Text(
// // // //                 opt.value,
// // // //                 textAlign: TextAlign.center,
// // // //                 style: TextStyle(
// // // //                   color: selected ? kGold : Colors.white70,
// // // //                   fontWeight: selected ? FontWeight.bold : FontWeight.normal,
// // // //                   fontSize: 13,
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         );
// // // //       }).toList(),
// // // //     );
// // // //   }

// // // //   Widget _darkField({
// // // //     required TextEditingController controller,
// // // //     required String label,
// // // //     TextInputType? keyboardType,
// // // //     String? prefixText,
// // // //   }) {
// // // //     return TextField(
// // // //       controller: controller,
// // // //       keyboardType: keyboardType,
// // // //       style: const TextStyle(color: Colors.white),
// // // //       decoration: InputDecoration(
// // // //         labelText: label,
// // // //         labelStyle: const TextStyle(color: kTextSecondary),
// // // //         prefixText: prefixText,
// // // //         prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
// // // //         filled: true,
// // // //         fillColor: kFieldFill,
// // // //         border: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: const BorderSide(color: kCardBorder),
// // // //         ),
// // // //         enabledBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: const BorderSide(color: kCardBorder),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: const BorderSide(color: kGold, width: 1.4),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _pillButton({
// // // //     required String label,
// // // //     required VoidCallback onPressed,
// // // //     required Color color,
// // // //     bool filled = true,
// // // //     IconData? icon,
// // // //   }) {
// // // //     return Expanded(
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.symmetric(horizontal: 4),
// // // //         child: filled
// // // //             ? ElevatedButton.icon(
// // // //                 onPressed: onPressed,
// // // //                 icon: icon != null
// // // //                     ? Icon(icon, size: 18, color: Colors.black)
// // // //                     : const SizedBox.shrink(),
// // // //                 label: Text(label,
// // // //                     style: const TextStyle(
// // // //                         fontWeight: FontWeight.bold, color: Colors.black)),
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: color,
// // // //                   minimumSize: const Size(0, 46),
// // // //                   shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(30)),
// // // //                   elevation: 0,
// // // //                 ),
// // // //               )
// // // //             : OutlinedButton.icon(
// // // //                 onPressed: onPressed,
// // // //                 icon: icon != null
// // // //                     ? Icon(icon, size: 18, color: color)
// // // //                     : const SizedBox.shrink(),
// // // //                 label: Text(label,
// // // //                     style:
// // // //                         TextStyle(fontWeight: FontWeight.bold, color: color)),
// // // //                 style: OutlinedButton.styleFrom(
// // // //                   side: BorderSide(color: color.withOpacity(0.6)),
// // // //                   backgroundColor: color.withOpacity(0.08),
// // // //                   minimumSize: const Size(0, 46),
// // // //                   shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(30)),
// // // //                 ),
// // // //               ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _darkCard({required Widget child}) {
// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: const EdgeInsets.all(18),
// // // //       decoration: BoxDecoration(
// // // //         color: kCard,
// // // //         borderRadius: BorderRadius.circular(18),
// // // //         border: Border.all(color: kCardBorder),
// // // //       ),
// // // //       child: child,
// // // //     );
// // // //   }

// // // //   Widget _darkDialogShell({
// // // //     required String title,
// // // //     required Widget content,
// // // //     required List<Widget> actions,
// // // //   }) {
// // // //     return AlertDialog(
// // // //       backgroundColor: kCard,
// // // //       shape: RoundedRectangleBorder(
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         side: const BorderSide(color: kCardBorder),
// // // //       ),
// // // //       title: Text(title,
// // // //           style: const TextStyle(
// // // //               color: Colors.white, fontWeight: FontWeight.bold)),
// // // //       content: content,
// // // //       actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // // //       actions: actions,
// // // //     );
// // // //   }

// // // //   // ===== دوال الخزنة (نقدي) =====
// // // //   void _showDepositCashDialog() {
// // // //     String method = 'cash';
// // // //     final amountController = TextEditingController();
// // // //     final noteController = TextEditingController();

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => StatefulBuilder(
// // // //         builder: (context, setDialogState) => _darkDialogShell(
// // // //           title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
// // // //           content: SingleChildScrollView(
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 _segmentedToggle(
// // // //                   options: [
// // // //                     const MapEntry('cash', 'نقدي'),
// // // //                     const MapEntry('network', 'شبكة'),
// // // //                   ],
// // // //                   value: method,
// // // //                   onChanged: (val) => setDialogState(() => method = val),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 _darkField(
// // // //                   controller: amountController,
// // // //                   keyboardType: TextInputType.number,
// // // //                   label: _t('المبلغ', 'Amount'),
// // // //                   prefixText: 'ر.س ',
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 _darkField(
// // // //                   controller: noteController,
// // // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context),
// // // //               child: Text(_t('إلغاء', 'Cancel'),
// // // //                   style: const TextStyle(color: kTextSecondary)),
// // // //             ),
// // // //             ElevatedButton(
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: kGreen,
// // // //                 shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(24)),
// // // //               ),
// // // //               onPressed: () async {
// // // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // // //                 if (amount <= 0) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     const SnackBar(
// // // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // // //                   );
// // // //                   return;
// // // //                 }
// // // //                 try {
// // // //                   await FS.addToCashBox(
// // // //                     amount: amount,
// // // //                     method: method,
// // // //                     note: noteController.text.isNotEmpty
// // // //                         ? noteController.text
// // // //                         : null,
// // // //                   );
// // // //                   Navigator.pop(context);
// // // //                   _loadAllData();
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                         content:
// // // //                             Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
// // // //                   );
// // // //                 } catch (e) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(content: Text('خطأ: $e')),
// // // //                   );
// // // //                 }
// // // //               },
// // // //               child: Text(_t('إيداع', 'Deposit'),
// // // //                   style: const TextStyle(
// // // //                       color: Colors.black, fontWeight: FontWeight.bold)),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _showWithdrawCashDialog() {
// // // //     String method = 'cash';
// // // //     final amountController = TextEditingController();
// // // //     final noteController = TextEditingController();

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => StatefulBuilder(
// // // //         builder: (context, setDialogState) => _darkDialogShell(
// // // //           title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
// // // //           content: SingleChildScrollView(
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 _segmentedToggle(
// // // //                   options: [
// // // //                     const MapEntry('cash', 'نقدي'),
// // // //                     const MapEntry('network', 'شبكة'),
// // // //                   ],
// // // //                   value: method,
// // // //                   onChanged: (val) => setDialogState(() => method = val),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 _darkField(
// // // //                   controller: amountController,
// // // //                   keyboardType: TextInputType.number,
// // // //                   label: _t('المبلغ', 'Amount'),
// // // //                   prefixText: 'ر.س ',
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 _darkField(
// // // //                   controller: noteController,
// // // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context),
// // // //               child: Text(_t('إلغاء', 'Cancel'),
// // // //                   style: const TextStyle(color: kTextSecondary)),
// // // //             ),
// // // //             ElevatedButton(
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: kRed,
// // // //                 shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(24)),
// // // //               ),
// // // //               onPressed: () async {
// // // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // // //                 if (amount <= 0) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     const SnackBar(
// // // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // // //                   );
// // // //                   return;
// // // //                 }
// // // //                 final balance = await FS.getCashBoxBalance();
// // // //                 double available =
// // // //                     method == 'cash' ? balance['cash']! : balance['network']!;
// // // //                 if (amount > available) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                         content: Text(
// // // //                             _t('الرصيد غير كافٍ', 'Insufficient balance'))),
// // // //                   );
// // // //                   return;
// // // //                 }
// // // //                 try {
// // // //                   await FS.deductFromCashBox(
// // // //                     amount: amount,
// // // //                     method: method,
// // // //                     note: noteController.text.isNotEmpty
// // // //                         ? noteController.text
// // // //                         : null,
// // // //                   );
// // // //                   Navigator.pop(context);
// // // //                   _loadAllData();
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                         content: Text(
// // // //                             _t('تم السحب بنجاح', 'Withdrawal successful'))),
// // // //                   );
// // // //                 } catch (e) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(content: Text('خطأ: $e')),
// // // //                   );
// // // //                 }
// // // //               },
// // // //               child: Text(_t('سحب', 'Withdraw'),
// // // //                   style: const TextStyle(
// // // //                       color: Colors.white, fontWeight: FontWeight.bold)),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== دوال الخزنة (ذهب) =====
// // // //   void _showGoldDepositDialog() {
// // // //     _showGoldDialog(mode: 'deposit');
// // // //   }

// // // //   void _showGoldWithdrawDialog() {
// // // //     _showGoldDialog(mode: 'withdraw');
// // // //   }

// // // //   void _showGoldDialog({required String mode}) {
// // // //     String goldType = 'raw';
// // // //     String carat = '21';
// // // //     final weightController = TextEditingController();
// // // //     final noteController = TextEditingController();

// // // //     final caratList = ['14', '18', '21', '22', '24'];
// // // //     final actionColor = mode == 'deposit' ? kGreen : kRed;

// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => StatefulBuilder(
// // // //         builder: (context, setDialogState) => _darkDialogShell(
// // // //           title: mode == 'deposit'
// // // //               ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
// // // //               : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
// // // //           content: SingleChildScrollView(
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 _segmentedToggle(
// // // //                   options: [
// // // //                     MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
// // // //                     MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
// // // //                   ],
// // // //                   value: goldType,
// // // //                   onChanged: (val) => setDialogState(() => goldType = val),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 Container(
// // // //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// // // //                   decoration: BoxDecoration(
// // // //                     color: kFieldFill,
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                     border: Border.all(color: kCardBorder),
// // // //                   ),
// // // //                   child: DropdownButtonHideUnderline(
// // // //                     child: DropdownButton<String>(
// // // //                       value: carat,
// // // //                       isExpanded: true,
// // // //                       dropdownColor: kCard,
// // // //                       iconEnabledColor: kGold,
// // // //                       style: const TextStyle(color: Colors.white),
// // // //                       items: caratList.map((c) {
// // // //                         return DropdownMenuItem(
// // // //                             value: c, child: Text('$c ${_t('عيار', 'K')}'));
// // // //                       }).toList(),
// // // //                       onChanged: (val) => setDialogState(() => carat = val!),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 _darkField(
// // // //                   controller: weightController,
// // // //                   keyboardType: TextInputType.number,
// // // //                   label: _t('الوزن (جرام)', 'Weight (g)'),
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 _darkField(
// // // //                   controller: noteController,
// // // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(context),
// // // //               child: Text(_t('إلغاء', 'Cancel'),
// // // //                   style: const TextStyle(color: kTextSecondary)),
// // // //             ),
// // // //             ElevatedButton(
// // // //               style: ElevatedButton.styleFrom(
// // // //                 backgroundColor: actionColor,
// // // //                 shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(24)),
// // // //               ),
// // // //               onPressed: () async {
// // // //                 final weight = double.tryParse(weightController.text) ?? 0.0;
// // // //                 if (weight <= 0) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     const SnackBar(
// // // //                         content: Text('الوزن يجب أن يكون أكبر من صفر')),
// // // //                   );
// // // //                   return;
// // // //                 }
// // // //                 final caratDouble = double.tryParse(carat) ?? 21.0;

// // // //                 try {
// // // //                   if (mode == 'deposit') {
// // // //                     await FS.depositSafeGold(
// // // //                       goldType: goldType,
// // // //                       carat: caratDouble,
// // // //                       weight: weight,
// // // //                       note: noteController.text.isNotEmpty
// // // //                           ? noteController.text
// // // //                           : null,
// // // //                     );
// // // //                   } else {
// // // //                     // التحقق من الرصيد المتاح
// // // //                     final summary = await FS.getSafeGoldSummary();
// // // //                     final transactions =
// // // //                         summary['transactions'] as List<Map<String, dynamic>>;
// // // //                     double available = 0.0;
// // // //                     for (var t in transactions) {
// // // //                       if (t['goldType'] == goldType &&
// // // //                           (t['carat'] ?? 24).toDouble() == caratDouble) {
// // // //                         if (t['type'] == 'deposit') {
// // // //                           available += (t['weight'] ?? 0.0).toDouble();
// // // //                         } else if (t['type'] == 'withdraw') {
// // // //                           available -= (t['weight'] ?? 0.0).toDouble();
// // // //                         }
// // // //                       }
// // // //                     }
// // // //                     if (weight > available) {
// // // //                       ScaffoldMessenger.of(context).showSnackBar(
// // // //                         SnackBar(
// // // //                             content: Text(_t(
// // // //                                 'الرصيد غير كافٍ لهذا العيار والنوع',
// // // //                                 'Insufficient balance for this carat and type'))),
// // // //                       );
// // // //                       return;
// // // //                     }
// // // //                     await FS.withdrawSafeGold(
// // // //                       goldType: goldType,
// // // //                       carat: caratDouble,
// // // //                       weight: weight,
// // // //                       note: noteController.text.isNotEmpty
// // // //                           ? noteController.text
// // // //                           : null,
// // // //                     );
// // // //                   }
// // // //                   Navigator.pop(context);
// // // //                   _loadAllData();
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                       content: Text(
// // // //                         mode == 'deposit'
// // // //                             ? _t('تم إيداع الذهب بنجاح',
// // // //                                 'Gold deposited successfully')
// // // //                             : _t('تم سحب الذهب بنجاح',
// // // //                                 'Gold withdrawn successfully'),
// // // //                       ),
// // // //                     ),
// // // //                   );
// // // //                 } catch (e) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(content: Text('خطأ: $e')),
// // // //                   );
// // // //                 }
// // // //               },
// // // //               child: Text(
// // // //                 mode == 'deposit'
// // // //                     ? _t('إيداع', 'Deposit')
// // // //                     : _t('سحب', 'Withdraw'),
// // // //                 style: TextStyle(
// // // //                     color: mode == 'deposit' ? Colors.black : Colors.white,
// // // //                     fontWeight: FontWeight.bold),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== بناء واجهة الخزنة (المطابقة للصور) =====
// // // //   Widget _buildSafeBoxTab() {
// // // //     return SingleChildScrollView(
// // // //       padding: const EdgeInsets.all(14),
// // // //       child: Column(
// // // //         children: [
// // // //           // ----- رصيد الخزنة النقدي -----
// // // //           _darkCard(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(
// // // //                   _t('رصيد الخزنة', 'Safe Balance'),
// // // //                   style: const TextStyle(
// // // //                       fontSize: 16,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.white),
// // // //                 ),
// // // //                 const SizedBox(height: 18),
// // // //                 Center(
// // // //                   child: RichText(
// // // //                     text: TextSpan(
// // // //                       children: [
// // // //                         TextSpan(
// // // //                           text: 'ر.س',
// // // //                           style: TextStyle(
// // // //                               fontSize: 16,
// // // //                               color: kTextSecondary,
// // // //                               fontWeight: FontWeight.w500),
// // // //                         ),
// // // //                         const TextSpan(text: '  '),
// // // //                         TextSpan(
// // // //                           text: (safeCash + safeNetwork).toStringAsFixed(0),
// // // //                           style: const TextStyle(
// // // //                               fontSize: 32,
// // // //                               fontWeight: FontWeight.bold,
// // // //                               color: Colors.white),
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 18),
// // // //                 Row(
// // // //                   children: [
// // // //                     Expanded(
// // // //                         child: _buildBalanceItem(
// // // //                             label: _t('شبكة', 'Network'), amount: safeNetwork)),
// // // //                     const SizedBox(width: 10),
// // // //                     Expanded(
// // // //                         child: _buildBalanceItem(
// // // //                             label: _t('نقدي', 'Cash'), amount: safeCash)),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 Row(
// // // //                   children: [
// // // //                     _pillButton(
// // // //                       label: _t('سحب', 'Withdraw'),
// // // //                       icon: Icons.arrow_upward,
// // // //                       color: kRed,
// // // //                       filled: false,
// // // //                       onPressed: _showWithdrawCashDialog,
// // // //                     ),
// // // //                     _pillButton(
// // // //                       label: _t('إيداع ', 'Manual Deposit'),
// // // //                       icon: Icons.arrow_downward,
// // // //                       color: kGreen,
// // // //                       filled: true,
// // // //                       onPressed: _showDepositCashDialog,
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),

// // // //           const SizedBox(height: 16),

// // // //           // ----- الذهب المحفوظ بالخزنة -----
// // // //           _darkCard(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(
// // // //                   _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
// // // //                   style: const TextStyle(
// // // //                       fontSize: 16,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.white),
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 Container(
// // // //                   width: double.infinity,
// // // //                   padding: const EdgeInsets.all(14),
// // // //                   decoration: BoxDecoration(
// // // //                     color: kFieldFill,
// // // //                     borderRadius: BorderRadius.circular(14),
// // // //                     border: Border.all(color: kCardBorder),
// // // //                   ),
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(
// // // //                         _t('الإجمالي محوّلًا لعيار 24',
// // // //                             'Total converted to 24K'),
// // // //                         style: const TextStyle(
// // // //                             color: kTextSecondary, fontSize: 12.5),
// // // //                       ),
// // // //                       const SizedBox(height: 6),
// // // //                       Text(
// // // //                         '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // // //                         style: const TextStyle(
// // // //                             fontSize: 22,
// // // //                             fontWeight: FontWeight.bold,
// // // //                             color: kGold),
// // // //                       ),
// // // //                       const SizedBox(height: 6),
// // // //                       Text(
// // // //                         '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
// // // //                         '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
// // // //                         '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
// // // //                         style: const TextStyle(
// // // //                             color: kTextSecondary, fontSize: 12),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 14),
// // // //                 if (goldTransactions.isNotEmpty)
// // // //                   Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(
// // // //                         _t('آخر العمليات', 'Recent Transactions'),
// // // //                         style: const TextStyle(
// // // //                             fontWeight: FontWeight.bold, color: Colors.white),
// // // //                       ),
// // // //                       const SizedBox(height: 6),
// // // //                       ...goldTransactions.take(5).map((t) {
// // // //                         final isDeposit = t['type'] == 'deposit';
// // // //                         final weight = (t['weight'] ?? 0.0).toDouble();
// // // //                         final carat = (t['carat'] ?? 24).toDouble();
// // // //                         final type = t['goldType'] == 'raw'
// // // //                             ? _t('خام', 'Raw')
// // // //                             : _t('مشغول', 'Worked');
// // // //                         final date = (t['date'] as Timestamp?)?.toDate();
// // // //                         final dateStr = date != null
// // // //                             ? '${date.day}/${date.month}/${date.year}'
// // // //                             : '';
// // // //                         return ListTile(
// // // //                           contentPadding: EdgeInsets.zero,
// // // //                           dense: true,
// // // //                           leading: Icon(
// // // //                             isDeposit ? Icons.add_circle : Icons.remove_circle,
// // // //                             color: isDeposit ? kGreen : kRed,
// // // //                           ),
// // // //                           title: Text(
// // // //                             '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
// // // //                             style: const TextStyle(
// // // //                                 fontSize: 13.5, color: Colors.white),
// // // //                           ),
// // // //                           subtitle: Text(dateStr,
// // // //                               style: const TextStyle(
// // // //                                   color: kTextSecondary, fontSize: 11.5)),
// // // //                           trailing: Text(
// // // //                             '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
// // // //                             style: TextStyle(
// // // //                               color: isDeposit ? kGreen : kRed,
// // // //                               fontWeight: FontWeight.bold,
// // // //                             ),
// // // //                           ),
// // // //                         );
// // // //                       }),
// // // //                     ],
// // // //                   )
// // // //                 else
// // // //                   Center(
// // // //                     child: Padding(
// // // //                       padding: const EdgeInsets.symmetric(vertical: 8),
// // // //                       child: Text(
// // // //                         _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
// // // //                         style: const TextStyle(color: kTextSecondary),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 const SizedBox(height: 14),
// // // //                 Row(
// // // //                   children: [
// // // //                     _pillButton(
// // // //                       label: _t('سحب', 'Withdraw'),
// // // //                       icon: Icons.arrow_downward,
// // // //                       color: kRed,
// // // //                       filled: false,
// // // //                       onPressed: _showGoldWithdrawDialog,
// // // //                     ),
// // // //                     _pillButton(
// // // //                       label: _t('إيداع', 'Deposit'),
// // // //                       icon: Icons.arrow_upward,
// // // //                       color: kGreen,
// // // //                       filled: true,
// // // //                       onPressed: _showGoldDepositDialog,
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== بناء واجهة صندوق اليومي =====
// // // //   Widget _buildDailyBoxTab() {
// // // //     return SingleChildScrollView(
// // // //       padding: const EdgeInsets.all(14),
// // // //       child: _darkCard(
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               _t('صندوق اليومي', 'Daily Box'),
// // // //               style: const TextStyle(
// // // //                   fontSize: 16,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: Colors.white),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Center(
// // // //               child: RichText(
// // // //                 text: TextSpan(
// // // //                   children: [
// // // //                     TextSpan(
// // // //                         text: 'ر.س  ',
// // // //                         style: TextStyle(fontSize: 16, color: kTextSecondary)),
// // // //                     TextSpan(
// // // //                       text: (dailyCash + dailyNetwork).toStringAsFixed(0),
// // // //                       style: const TextStyle(
// // // //                           fontSize: 30,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.white),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                     child: _buildBalanceItem(
// // // //                         label: _t('شبكة', 'Network'), amount: dailyNetwork)),
// // // //                 const SizedBox(width: 10),
// // // //                 Expanded(
// // // //                     child: _buildBalanceItem(
// // // //                         label: _t('نقدي', 'Cash'), amount: dailyCash)),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Center(
// // // //               child: Text(
// // // //                 _t('(قيد التطوير)', '(Under development)'),
// // // //                 style: const TextStyle(color: kTextSecondary),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== بناء واجهة صندوق الكسر =====
// // // //   Widget _buildScrapBoxTab() {
// // // //     return SingleChildScrollView(
// // // //       padding: const EdgeInsets.all(14),
// // // //       child: _darkCard(
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(
// // // //               _t('صندوق الكسر', 'Scrap Box'),
// // // //               style: const TextStyle(
// // // //                   fontSize: 16,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: Colors.white),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Center(
// // // //               child: RichText(
// // // //                 text: TextSpan(
// // // //                   children: [
// // // //                     TextSpan(
// // // //                         text: 'ر.س  ',
// // // //                         style: TextStyle(fontSize: 16, color: kTextSecondary)),
// // // //                     TextSpan(
// // // //                       text: (scrapCash + scrapNetwork).toStringAsFixed(0),
// // // //                       style: const TextStyle(
// // // //                           fontSize: 30,
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.white),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                     child: _buildBalanceItem(
// // // //                         label: _t('شبكة', 'Network'), amount: scrapNetwork)),
// // // //                 const SizedBox(width: 10),
// // // //                 Expanded(
// // // //                     child: _buildBalanceItem(
// // // //                         label: _t('نقدي', 'Cash'), amount: scrapCash)),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 18),
// // // //             Center(
// // // //               child: Text(
// // // //                 _t('(قيد التطوير)', '(Under development)'),
// // // //                 style: const TextStyle(color: kTextSecondary),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== عنصر مساعد لعرض الرصيد (مطابق لصناديق شبكة/نقدي بالصورة) =====
// // // //   Widget _buildBalanceItem({
// // // //     required String label,
// // // //     required double amount,
// // // //   }) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(vertical: 14),
// // // //       decoration: BoxDecoration(
// // // //         color: kFieldFill,
// // // //         borderRadius: BorderRadius.circular(14),
// // // //         border: Border.all(color: kCardBorder),
// // // //       ),
// // // //       child: Column(
// // // //         children: [
// // // //           Text(label,
// // // //               style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
// // // //           const SizedBox(height: 6),
// // // //           Text(
// // // //             'ر.س${amount.toStringAsFixed(0)}',
// // // //             style: const TextStyle(
// // // //                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ===== الواجهة الرئيسية =====
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: kBackground,
// // // //       appBar: AppBar(
// // // //         title: Text(_t('الصندوق', 'Cash Box')),
// // // //         backgroundColor:
// // // //             const Color(0xFFD4AF37), // اللون الذهبي المطلوب (بدون تغيير)
// // // //         centerTitle: true,
// // // //         elevation: 0,
// // // //         bottom: PreferredSize(
// // // //           preferredSize: const Size.fromHeight(48),
// // // //           child: Padding(
// // // //             padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
// // // //             child: Container(
// // // //               decoration: BoxDecoration(
// // // //                 color: Colors.black.withOpacity(0.15),
// // // //                 borderRadius: BorderRadius.circular(30),
// // // //               ),
// // // //               child: TabBar(
// // // //                 controller: _tabController,
// // // //                 indicator: BoxDecoration(
// // // //                   color: Colors.black.withOpacity(0.28),
// // // //                   borderRadius: BorderRadius.circular(30),
// // // //                 ),
// // // //                 indicatorSize: TabBarIndicatorSize.tab,
// // // //                 labelColor: Colors.white,
// // // //                 unselectedLabelColor: Colors.black54,
// // // //                 labelStyle:
// // // //                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
// // // //                 dividerColor: Colors.transparent,
// // // //                 tabs: [
// // // //                   Tab(text: _t('صندوق الكسر', 'Scrap Box')),
// // // //                   Tab(text: _t('صندوق اليومي', 'Daily Box')),
// // // //                   Tab(text: _t('الخزنة', 'Safe Box')),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       body: loading
// // // //           ? Center(child: CircularProgressIndicator(color: kGold))
// // // //           : Column(
// // // //               children: [
// // // //                 // بطاقة الإجمالي العام أعلى الصفحة
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
// // // //                   child: Container(
// // // //                     padding: const EdgeInsets.symmetric(vertical: 14),
// // // //                     decoration: BoxDecoration(
// // // //                       color: kCard,
// // // //                       borderRadius: BorderRadius.circular(18),
// // // //                       border: Border.all(color: kCardBorder),
// // // //                     ),
// // // //                     child: Row(
// // // //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // // //                       children: [
// // // //                         Column(
// // // //                           children: [
// // // //                             Text(_t('الإجمالي', 'Total'),
// // // //                                 style: const TextStyle(
// // // //                                     fontWeight: FontWeight.bold,
// // // //                                     color: kTextSecondary,
// // // //                                     fontSize: 12.5)),
// // // //                             const SizedBox(height: 4),
// // // //                             Text(
// // // //                               '${totalBalance.toStringAsFixed(2)} ر.س',
// // // //                               style: TextStyle(
// // // //                                 fontSize: 18,
// // // //                                 fontWeight: FontWeight.bold,
// // // //                                 color: totalBalance >= 0 ? kGreen : kRed,
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                         Container(width: 1, height: 30, color: kCardBorder),
// // // //                         Column(
// // // //                           children: [
// // // //                             Text(_t('نقدي', 'Cash'),
// // // //                                 style: const TextStyle(
// // // //                                     fontWeight: FontWeight.bold,
// // // //                                     color: kTextSecondary,
// // // //                                     fontSize: 12.5)),
// // // //                             const SizedBox(height: 4),
// // // //                             Text('${cashTotal.toStringAsFixed(2)}',
// // // //                                 style: const TextStyle(
// // // //                                     color: Colors.white,
// // // //                                     fontWeight: FontWeight.bold)),
// // // //                           ],
// // // //                         ),
// // // //                         Container(width: 1, height: 30, color: kCardBorder),
// // // //                         Column(
// // // //                           children: [
// // // //                             Text(_t('شبكة', 'Network'),
// // // //                                 style: const TextStyle(
// // // //                                     fontWeight: FontWeight.bold,
// // // //                                     color: kTextSecondary,
// // // //                                     fontSize: 12.5)),
// // // //                             const SizedBox(height: 4),
// // // //                             Text('${networkTotal.toStringAsFixed(2)}',
// // // //                                 style: const TextStyle(
// // // //                                     color: Colors.white,
// // // //                                     fontWeight: FontWeight.bold)),
// // // //                           ],
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 // محتوى التاب
// // // //                 Expanded(
// // // //                   child: TabBarView(
// // // //                     controller: _tabController,
// // // //                     children: [
// // // //                       _buildScrapBoxTab(),
// // // //                       _buildDailyBoxTab(),
// // // //                       _buildSafeBoxTab(),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //     );
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../services/firestore_service.dart';

// // // class CashBoxPage extends StatefulWidget {
// // //   const CashBoxPage({super.key});

// // //   @override
// // //   State<CashBoxPage> createState() => _CashBoxPageState();
// // // }

// // // class _CashBoxPageState extends State<CashBoxPage>
// // //     with SingleTickerProviderStateMixin {
// // //   // ===== ألوان التصميم =====
// // //   static const Color kGold = Color(0xFFD4AF37);
// // //   static const Color kBackground = Color(0xFF121212);
// // //   static const Color kCard = Color(0xFF1C1C1C);
// // //   static const Color kCardBorder = Color(0xFF2A2A2A);
// // //   static const Color kFieldFill = Color(0xFF161616);
// // //   static const Color kGreen = Color(0xFF4CAF50);
// // //   static const Color kRed = Color(0xFFE05353);
// // //   static const Color kTextSecondary = Color(0xFF9E9E9E);

// // //   // ===== متغيرات الأقسام =====
// // //   double totalBalance = 0.0;
// // //   double cashTotal = 0.0;
// // //   double networkTotal = 0.0;

// // //   // ===== الخزنة (نقدي) =====
// // //   double safeCash = 0.0;
// // //   double safeNetwork = 0.0;

// // //   // ===== الخزنة (ذهب) =====
// // //   double goldTotal24K = 0.0;
// // //   double goldTotalActual = 0.0;
// // //   double goldScrapWeight = 0.0;
// // //   double goldWorkedWeight = 0.0;
// // //   List<Map<String, dynamic>> goldTransactions = [];

// // //   // ===== صندوق اليومي =====
// // //   double dailyCash = 0.0;
// // //   double dailyNetwork = 0.0;
// // //   List<Map<String, dynamic>> dailyTransactions = [];
// // //   double dailyFloatCash = 0.0;
// // //   double dailyFloatNetwork = 0.0;

// // //   // ===== صندوق الكسر =====
// // //   double scrapCash = 0.0;
// // //   double scrapNetwork = 0.0;
// // //   List<Map<String, dynamic>> scrapTransactions = [];

// // //   bool loading = true;
// // //   String _lang = 'ar';
// // //   late TabController _tabController;

// // //   // قوائم التصنيفات
// // //   final List<String> expenseCategories = [
// // //     'سحب شخصي / سحب شريك',
// // //     'أخرى',
// // //   ];
// // //   final List<String> depositCategories = [
// // //     'إيرادات أخرى',
// // //     'رأس مال / مساهمة شريك',
// // //   ];

// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 3, vsync: this);
// // //     _loadLanguage();
// // //     _loadAllData();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     super.dispose();
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   // ===== تحميل جميع البيانات =====
// // //   Future<void> _loadAllData() async {
// // //     setState(() => loading = true);
// // //     try {
// // //       final cashBalance = await FS.getCashBoxBalance();
// // //       safeCash = cashBalance['cash']!;
// // //       safeNetwork = cashBalance['network']!;

// // //       final goldSummary = await FS.getSafeGoldSummary();
// // //       goldTotal24K = goldSummary['total24K'] ?? 0.0;
// // //       goldTotalActual = goldSummary['totalActual'] ?? 0.0;
// // //       goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
// // //       goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
// // //       goldTransactions =
// // //           List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

// // //       await _loadDailyBoxData();

// // //       final scrapData = await _getScrapBoxData();
// // //       scrapCash = scrapData['cash'];
// // //       scrapNetwork = scrapData['network'];
// // //       scrapTransactions = scrapData['transactions'];

// // //       totalBalance = (safeCash + safeNetwork) +
// // //           (dailyCash + dailyNetwork) +
// // //           (scrapCash + scrapNetwork);
// // //       cashTotal = safeCash + dailyCash + scrapCash;
// // //       networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

// // //       setState(() => loading = false);
// // //     } catch (e) {
// // //       setState(() => loading = false);
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _loadDailyBoxData() async {
// // //     try {
// // //       final balance = await FS.getDailyBoxBalance();
// // //       dailyCash = balance['cash']!;
// // //       dailyNetwork = balance['network']!;

// // //       final history = await FS.getDailyBoxHistory();
// // //       dailyTransactions = history;

// // //       double floatCash = 0.0;
// // //       double floatNetwork = 0.0;
// // //       for (var t in history) {
// // //         if (t['type'] == 'float_open') {
// // //           if (t['method'] == 'cash')
// // //             floatCash += (t['amount'] ?? 0).toDouble();
// // //           else if (t['method'] == 'network')
// // //             floatNetwork += (t['amount'] ?? 0).toDouble();
// // //         }
// // //       }
// // //       dailyFloatCash = floatCash;
// // //       dailyFloatNetwork = floatNetwork;
// // //     } catch (e) {
// // //       print('⚠️ خطأ في تحميل الصندوق اليومي: $e');
// // //     }
// // //   }

// // //   Future<Map<String, dynamic>> _getScrapBoxData() async {
// // //     double cash = 0.0, network = 0.0;
// // //     List<Map<String, dynamic>> transactions = [];

// // //     final scrapSnap = await FS.scrapCol().get();
// // //     for (var doc in scrapSnap.docs) {
// // //       final data = doc.data() as Map<String, dynamic>;
// // //       final type = data['type'] ?? '';
// // //       final c = (data['cash'] ?? 0.0).toDouble();
// // //       final n = (data['network'] ?? 0.0).toDouble();

// // //       if (type == 'add') {
// // //         cash -= c;
// // //         network -= n;
// // //         transactions.add({
// // //           'type': 'شراء كسر',
// // //           'cash': -c,
// // //           'network': -n,
// // //           'date': data['date'],
// // //           'data': data
// // //         });
// // //       } else if (type == 'sale') {
// // //         cash += c;
// // //         network += n;
// // //         transactions.add({
// // //           'type': 'بيع كسر',
// // //           'cash': c,
// // //           'network': n,
// // //           'date': data['date'],
// // //           'data': data
// // //         });
// // //       } else if (type == 'payment') {
// // //         cash -= c;
// // //         network -= n;
// // //         transactions.add({
// // //           'type': 'سند صرف',
// // //           'cash': -c,
// // //           'network': -n,
// // //           'date': data['date'],
// // //           'data': data
// // //         });
// // //       }
// // //     }
// // //     return {'cash': cash, 'network': network, 'transactions': transactions};
// // //   }

// // //   // =========================================================================
// // //   // عناصر تصميم مشتركة
// // //   // =========================================================================

// // //   Widget _segmentedToggle({
// // //     required List<MapEntry<String, String>> options,
// // //     required String value,
// // //     required ValueChanged<String> onChanged,
// // //   }) {
// // //     return Row(
// // //       children: options.map((opt) {
// // //         final selected = opt.key == value;
// // //         return Expanded(
// // //           child: GestureDetector(
// // //             onTap: () => onChanged(opt.key),
// // //             child: Container(
// // //               margin: const EdgeInsets.symmetric(horizontal: 4),
// // //               padding: const EdgeInsets.symmetric(vertical: 12),
// // //               decoration: BoxDecoration(
// // //                 color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
// // //                 borderRadius: BorderRadius.circular(30),
// // //                 border: Border.all(
// // //                     color: selected ? kGold : kCardBorder, width: 1.2),
// // //               ),
// // //               child: Text(
// // //                 opt.value,
// // //                 textAlign: TextAlign.center,
// // //                 style: TextStyle(
// // //                   color: selected ? kGold : Colors.white70,
// // //                   fontWeight: selected ? FontWeight.bold : FontWeight.normal,
// // //                   fontSize: 13,
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   Widget _darkField({
// // //     required TextEditingController controller,
// // //     required String label,
// // //     TextInputType? keyboardType,
// // //     String? prefixText,
// // //     bool enabled = true,
// // //   }) {
// // //     return TextField(
// // //       controller: controller,
// // //       keyboardType: keyboardType,
// // //       enabled: enabled,
// // //       style: const TextStyle(color: Colors.white),
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         labelStyle: const TextStyle(color: kTextSecondary),
// // //         prefixText: prefixText,
// // //         prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
// // //         filled: true,
// // //         fillColor: kFieldFill,
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: const BorderSide(color: kCardBorder),
// // //         ),
// // //         enabledBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: const BorderSide(color: kCardBorder),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: const BorderSide(color: kGold, width: 1.4),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _pillButton({
// // //     required String label,
// // //     required VoidCallback onPressed,
// // //     required Color color,
// // //     bool filled = true,
// // //     IconData? icon,
// // //     bool expanded = true,
// // //   }) {
// // //     Widget btn = filled
// // //         ? ElevatedButton.icon(
// // //             onPressed: onPressed,
// // //             icon: icon != null
// // //                 ? Icon(icon, size: 18, color: Colors.black)
// // //                 : const SizedBox.shrink(),
// // //             label: Text(label,
// // //                 style: const TextStyle(
// // //                     fontWeight: FontWeight.bold, color: Colors.black)),
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: color,
// // //               minimumSize: const Size(0, 46),
// // //               shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(30)),
// // //               elevation: 0,
// // //             ),
// // //           )
// // //         : OutlinedButton.icon(
// // //             onPressed: onPressed,
// // //             icon: icon != null
// // //                 ? Icon(icon, size: 18, color: color)
// // //                 : const SizedBox.shrink(),
// // //             label: Text(label,
// // //                 style: TextStyle(fontWeight: FontWeight.bold, color: color)),
// // //             style: OutlinedButton.styleFrom(
// // //               side: BorderSide(color: color.withOpacity(0.6)),
// // //               backgroundColor: color.withOpacity(0.08),
// // //               minimumSize: const Size(0, 46),
// // //               shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(30)),
// // //             ),
// // //           );

// // //     return expanded
// // //         ? Expanded(
// // //             child: Padding(
// // //               padding: const EdgeInsets.symmetric(horizontal: 4),
// // //               child: btn,
// // //             ),
// // //           )
// // //         : btn;
// // //   }

// // //   Widget _darkCard({required Widget child}) {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.all(18),
// // //       decoration: BoxDecoration(
// // //         color: kCard,
// // //         borderRadius: BorderRadius.circular(18),
// // //         border: Border.all(color: kCardBorder),
// // //       ),
// // //       child: child,
// // //     );
// // //   }

// // //   Widget _darkDialogShell({
// // //     required String title,
// // //     required Widget content,
// // //     required List<Widget> actions,
// // //   }) {
// // //     return AlertDialog(
// // //       backgroundColor: kCard,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(20),
// // //         side: const BorderSide(color: kCardBorder),
// // //       ),
// // //       title: Text(title,
// // //           style: const TextStyle(
// // //               color: Colors.white, fontWeight: FontWeight.bold)),
// // //       content: content,
// // //       actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// // //       actions: actions,
// // //     );
// // //   }

// // //   Widget _buildBalanceItem({
// // //     required String label,
// // //     required double amount,
// // //   }) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(vertical: 14),
// // //       decoration: BoxDecoration(
// // //         color: kFieldFill,
// // //         borderRadius: BorderRadius.circular(14),
// // //         border: Border.all(color: kCardBorder),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Text(label,
// // //               style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
// // //           const SizedBox(height: 6),
// // //           Text(
// // //             'ر.س${amount.toStringAsFixed(0)}',
// // //             style: const TextStyle(
// // //                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // دوال الخزنة النقدية
// // //   // =========================================================================
// // //   void _showDepositCashDialog() {
// // //     String method = 'cash';
// // //     final amountController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     const MapEntry('cash', 'نقدي'),
// // //                     const MapEntry('network', 'شبكة'),
// // //                   ],
// // //                   value: method,
// // //                   onChanged: (val) => setDialogState(() => method = val),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 _darkField(
// // //                   controller: amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('المبلغ', 'Amount'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kGreen,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // //                 if (amount <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 try {
// // //                   await FS.addToCashBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     note: noteController.text.isNotEmpty
// // //                         ? noteController.text
// // //                         : null,
// // //                   );
// // //                   Navigator.pop(context);
// // //                   _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content:
// // //                             Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('إيداع', 'Deposit'),
// // //                   style: const TextStyle(
// // //                       color: Colors.black, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showWithdrawCashDialog() {
// // //     String method = 'cash';
// // //     final amountController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     const MapEntry('cash', 'نقدي'),
// // //                     const MapEntry('network', 'شبكة'),
// // //                   ],
// // //                   value: method,
// // //                   onChanged: (val) => setDialogState(() => method = val),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 _darkField(
// // //                   controller: amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('المبلغ', 'Amount'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kRed,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // //                 if (amount <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 final balance = await FS.getCashBoxBalance();
// // //                 double available =
// // //                     method == 'cash' ? balance['cash']! : balance['network']!;
// // //                 if (amount > available) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content: Text(
// // //                             _t('الرصيد غير كافٍ', 'Insufficient balance'))),
// // //                   );
// // //                   return;
// // //                 }
// // //                 try {
// // //                   await FS.deductFromCashBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     note: noteController.text.isNotEmpty
// // //                         ? noteController.text
// // //                         : null,
// // //                   );
// // //                   Navigator.pop(context);
// // //                   _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content: Text(
// // //                             _t('تم السحب بنجاح', 'Withdrawal successful'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('سحب', 'Withdraw'),
// // //                   style: const TextStyle(
// // //                       color: Colors.white, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // دوال الخزنة (ذهب)
// // //   // =========================================================================
// // //   void _showGoldDepositDialog() {
// // //     _showGoldDialog(mode: 'deposit');
// // //   }

// // //   void _showGoldWithdrawDialog() {
// // //     _showGoldDialog(mode: 'withdraw');
// // //   }

// // //   void _showGoldDialog({required String mode}) {
// // //     String goldType = 'raw';
// // //     String carat = '21';
// // //     final weightController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     final caratList = ['14', '18', '21', '22', '24'];
// // //     final actionColor = mode == 'deposit' ? kGreen : kRed;

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: mode == 'deposit'
// // //               ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
// // //               : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
// // //                     MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
// // //                   ],
// // //                   value: goldType,
// // //                   onChanged: (val) => setDialogState(() => goldType = val),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// // //                   decoration: BoxDecoration(
// // //                     color: kFieldFill,
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     border: Border.all(color: kCardBorder),
// // //                   ),
// // //                   child: DropdownButtonHideUnderline(
// // //                     child: DropdownButton<String>(
// // //                       value: carat,
// // //                       isExpanded: true,
// // //                       dropdownColor: kCard,
// // //                       iconEnabledColor: kGold,
// // //                       style: const TextStyle(color: Colors.white),
// // //                       items: caratList.map((c) {
// // //                         return DropdownMenuItem(
// // //                             value: c, child: Text('$c ${_t('عيار', 'K')}'));
// // //                       }).toList(),
// // //                       onChanged: (val) => setDialogState(() => carat = val!),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 _darkField(
// // //                   controller: weightController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('الوزن (جرام)', 'Weight (g)'),
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: actionColor,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final weight = double.tryParse(weightController.text) ?? 0.0;
// // //                 if (weight <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('الوزن يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 final caratDouble = double.tryParse(carat) ?? 21.0;

// // //                 try {
// // //                   if (mode == 'deposit') {
// // //                     await FS.depositSafeGold(
// // //                       goldType: goldType,
// // //                       carat: caratDouble,
// // //                       weight: weight,
// // //                       note: noteController.text.isNotEmpty
// // //                           ? noteController.text
// // //                           : null,
// // //                     );
// // //                   } else {
// // //                     final summary = await FS.getSafeGoldSummary();
// // //                     final transactions =
// // //                         summary['transactions'] as List<Map<String, dynamic>>;
// // //                     double available = 0.0;
// // //                     for (var t in transactions) {
// // //                       if (t['goldType'] == goldType &&
// // //                           (t['carat'] ?? 24).toDouble() == caratDouble) {
// // //                         if (t['type'] == 'deposit') {
// // //                           available += (t['weight'] ?? 0.0).toDouble();
// // //                         } else if (t['type'] == 'withdraw') {
// // //                           available -= (t['weight'] ?? 0.0).toDouble();
// // //                         }
// // //                       }
// // //                     }
// // //                     if (weight > available) {
// // //                       ScaffoldMessenger.of(context).showSnackBar(
// // //                         SnackBar(
// // //                             content: Text(_t(
// // //                                 'الرصيد غير كافٍ لهذا العيار والنوع',
// // //                                 'Insufficient balance for this carat and type'))),
// // //                       );
// // //                       return;
// // //                     }
// // //                     await FS.withdrawSafeGold(
// // //                       goldType: goldType,
// // //                       carat: caratDouble,
// // //                       weight: weight,
// // //                       note: noteController.text.isNotEmpty
// // //                           ? noteController.text
// // //                           : null,
// // //                     );
// // //                   }
// // //                   Navigator.pop(context);
// // //                   _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                       content: Text(
// // //                         mode == 'deposit'
// // //                             ? _t('تم إيداع الذهب بنجاح',
// // //                                 'Gold deposited successfully')
// // //                             : _t('تم سحب الذهب بنجاح',
// // //                                 'Gold withdrawn successfully'),
// // //                       ),
// // //                     ),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(
// // //                 mode == 'deposit'
// // //                     ? _t('إيداع', 'Deposit')
// // //                     : _t('سحب', 'Withdraw'),
// // //                 style: TextStyle(
// // //                     color: mode == 'deposit' ? Colors.black : Colors.white,
// // //                     fontWeight: FontWeight.bold),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // دوال صندوق اليومي
// // //   // =========================================================================

// // //   void _showOpenFloatDialog() {
// // //     final cashController = TextEditingController();
// // //     final networkController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('فتح عهدة جديدة', 'Open New Float'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Text(
// // //                   _t('تخصص العهدة من الخزنة وتضاف لصندوق اليومي.',
// // //                       'Float is taken from safe and added to daily box.'),
// // //                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 _darkField(
// // //                   controller: cashController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('نقدي (ر.س)', 'Cash (SAR)'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: networkController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('شبكة (ر.س)', 'Network (SAR)'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     Text(_t('إجمالي العهدة', 'Total Float'),
// // //                         style: const TextStyle(color: Colors.white70)),
// // //                     ValueListenableBuilder(
// // //                       valueListenable: cashController,
// // //                       builder: (_, __, ___) {
// // //                         final cash = double.tryParse(cashController.text) ?? 0;
// // //                         final network =
// // //                             double.tryParse(networkController.text) ?? 0;
// // //                         return Text(
// // //                           'ر.س ${(cash + network).toStringAsFixed(2)}',
// // //                           style: const TextStyle(
// // //                               fontSize: 18,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: kGold),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kGold,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final cash = double.tryParse(cashController.text) ?? 0.0;
// // //                 final network = double.tryParse(networkController.text) ?? 0.0;
// // //                 if (cash <= 0 && network <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('يجب إدخال مبلغ في أحد الحقلين')),
// // //                   );
// // //                   return;
// // //                 }

// // //                 try {
// // //                   final safeBal = await FS.getCashBoxBalance();
// // //                   if (cash > safeBal['cash']!) {
// // //                     throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
// // //                   }
// // //                   if (network > safeBal['network']!) {
// // //                     throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
// // //                   }

// // //                   if (cash > 0) {
// // //                     await FS.deductFromCashBox(
// // //                       amount: cash,
// // //                       method: 'cash',
// // //                       note: 'فتح عهدة صندوق يومي',
// // //                     );
// // //                   }
// // //                   if (network > 0) {
// // //                     await FS.deductFromCashBox(
// // //                       amount: network,
// // //                       method: 'network',
// // //                       note: 'فتح عهدة صندوق يومي',
// // //                     );
// // //                   }

// // //                   if (cash > 0) {
// // //                     await FS.addToDailyBox(
// // //                       amount: cash,
// // //                       method: 'cash',
// // //                       note: noteController.text.isNotEmpty
// // //                           ? noteController.text
// // //                           : 'فتح عهدة',
// // //                       type: 'float_open',
// // //                     );
// // //                   }
// // //                   if (network > 0) {
// // //                     await FS.addToDailyBox(
// // //                       amount: network,
// // //                       method: 'network',
// // //                       note: noteController.text.isNotEmpty
// // //                           ? noteController.text
// // //                           : 'فتح عهدة',
// // //                       type: 'float_open',
// // //                     );
// // //                   }

// // //                   Navigator.pop(context);
// // //                   await _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content: Text(_t('تم فتح العهدة بنجاح',
// // //                             'Float opened successfully'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('فتح العهدة', 'Open Float'),
// // //                   style: const TextStyle(
// // //                       color: Colors.black, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showExpenseDialog() {
// // //     String method = 'cash';
// // //     String selectedCategory = expenseCategories.first;
// // //     final amountController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('تسجيل مصروف', 'Record Expense'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// // //                   decoration: BoxDecoration(
// // //                     color: kFieldFill,
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     border: Border.all(color: kCardBorder),
// // //                   ),
// // //                   child: DropdownButtonHideUnderline(
// // //                     child: DropdownButton<String>(
// // //                       value: selectedCategory,
// // //                       isExpanded: true,
// // //                       dropdownColor: kCard,
// // //                       iconEnabledColor: kGold,
// // //                       style: const TextStyle(color: Colors.white),
// // //                       items: expenseCategories.map((cat) {
// // //                         return DropdownMenuItem(value: cat, child: Text(cat));
// // //                       }).toList(),
// // //                       onChanged: (val) =>
// // //                           setDialogState(() => selectedCategory = val!),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     const MapEntry('cash', 'نقدي'),
// // //                     const MapEntry('network', 'شبكة'),
// // //                   ],
// // //                   value: method,
// // //                   onChanged: (val) => setDialogState(() => method = val),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('المبلغ', 'Amount'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kRed,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // //                 if (amount <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 try {
// // //                   await FS.deductFromDailyBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     category: selectedCategory,
// // //                     note: noteController.text.isNotEmpty
// // //                         ? noteController.text
// // //                         : null,
// // //                     type: 'expense',
// // //                   );
// // //                   Navigator.pop(context);
// // //                   await _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content:
// // //                             Text(_t('تم تسجيل المصروف', 'Expense recorded'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('حفظ', 'Save'),
// // //                   style: const TextStyle(
// // //                       color: Colors.white, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showDepositDialog() {
// // //     String method = 'cash';
// // //     String selectedCategory = depositCategories.first;
// // //     final amountController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('تسجيل إيداع', 'Record Deposit'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// // //                   decoration: BoxDecoration(
// // //                     color: kFieldFill,
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     border: Border.all(color: kCardBorder),
// // //                   ),
// // //                   child: DropdownButtonHideUnderline(
// // //                     child: DropdownButton<String>(
// // //                       value: selectedCategory,
// // //                       isExpanded: true,
// // //                       dropdownColor: kCard,
// // //                       iconEnabledColor: kGold,
// // //                       style: const TextStyle(color: Colors.white),
// // //                       items: depositCategories.map((cat) {
// // //                         return DropdownMenuItem(value: cat, child: Text(cat));
// // //                       }).toList(),
// // //                       onChanged: (val) =>
// // //                           setDialogState(() => selectedCategory = val!),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     const MapEntry('cash', 'نقدي'),
// // //                     const MapEntry('network', 'شبكة'),
// // //                   ],
// // //                   value: method,
// // //                   onChanged: (val) => setDialogState(() => method = val),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('المبلغ', 'Amount'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kGreen,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // //                 if (amount <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 try {
// // //                   await FS.addToDailyBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     category: selectedCategory,
// // //                     note: noteController.text.isNotEmpty
// // //                         ? noteController.text
// // //                         : null,
// // //                     type: 'deposit',
// // //                   );
// // //                   Navigator.pop(context);
// // //                   await _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content:
// // //                             Text(_t('تم تسجيل الإيداع', 'Deposit recorded'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('حفظ', 'Save'),
// // //                   style: const TextStyle(
// // //                       color: Colors.black, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showPartialTransferToSafeDialog() {
// // //     String method = 'cash';
// // //     final amountController = TextEditingController();
// // //     final noteController = TextEditingController();

// // //     showDialog(
// // //       context: context,
// // //       builder: (_) => StatefulBuilder(
// // //         builder: (context, setDialogState) => _darkDialogShell(
// // //           title: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer to Safe'),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 _segmentedToggle(
// // //                   options: [
// // //                     const MapEntry('cash', 'نقدي'),
// // //                     const MapEntry('network', 'شبكة'),
// // //                   ],
// // //                   value: method,
// // //                   onChanged: (val) => setDialogState(() => method = val),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: amountController,
// // //                   keyboardType: TextInputType.number,
// // //                   label: _t('المبلغ', 'Amount'),
// // //                   prefixText: 'ر.س ',
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 _darkField(
// // //                   controller: noteController,
// // //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(context),
// // //               child: Text(_t('إلغاء', 'Cancel'),
// // //                   style: const TextStyle(color: kTextSecondary)),
// // //             ),
// // //             ElevatedButton(
// // //               style: ElevatedButton.styleFrom(
// // //                 backgroundColor: kGold,
// // //                 shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(24)),
// // //               ),
// // //               onPressed: () async {
// // //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// // //                 if (amount <= 0) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     const SnackBar(
// // //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// // //                   );
// // //                   return;
// // //                 }
// // //                 try {
// // //                   await FS.deductFromDailyBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     note: noteController.text.isNotEmpty
// // //                         ? noteController.text
// // //                         : 'تحويل للخزنة',
// // //                     type: 'transfer_to_safe',
// // //                   );
// // //                   await FS.addToCashBox(
// // //                     amount: amount,
// // //                     method: method,
// // //                     note: 'تحويل من الصندوق اليومي',
// // //                   );
// // //                   Navigator.pop(context);
// // //                   await _loadAllData();
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content: Text(_t('تم التحويل', 'Transfer completed'))),
// // //                   );
// // //                 } catch (e) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(content: Text('خطأ: $e')),
// // //                   );
// // //                 }
// // //               },
// // //               child: Text(_t('تحويل', 'Transfer'),
// // //                   style: const TextStyle(
// // //                       color: Colors.black, fontWeight: FontWeight.bold)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _showEndOfDayTransfer() async {
// // //     final confirm = await showDialog<bool>(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         backgroundColor: kCard,
// // //         shape: RoundedRectangleBorder(
// // //           borderRadius: BorderRadius.circular(20),
// // //           side: const BorderSide(color: kCardBorder),
// // //         ),
// // //         title: Text(_t('توريد نهاية اليوم', 'End-of-Day Transfer'),
// // //             style: const TextStyle(color: Colors.white)),
// // //         content: Text(
// // //           _t('سيتم تحويل كامل رصيد الصندوق اليومي إلى الخزنة وإعادة تعيينه.',
// // //               'All daily box balance will be transferred to safe and reset.'),
// // //           style: const TextStyle(color: Colors.white70),
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: Text(_t('إلغاء', 'Cancel'),
// // //                 style: const TextStyle(color: kTextSecondary)),
// // //           ),
// // //           ElevatedButton(
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: kRed,
// // //               shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(24)),
// // //             ),
// // //             onPressed: () => Navigator.pop(context, true),
// // //             child: Text(_t('تأكيد', 'Confirm'),
// // //                 style: const TextStyle(
// // //                     color: Colors.white, fontWeight: FontWeight.bold)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //     if (confirm != true) return;

// // //     try {
// // //       final balance = await FS.getDailyBoxBalance();
// // //       double cash = balance['cash']!;
// // //       double network = balance['network']!;

// // //       if (cash > 0) {
// // //         await FS.addToCashBox(
// // //           amount: cash,
// // //           method: 'cash',
// // //           note: 'توريد نهاية اليوم (نقدي)',
// // //         );
// // //       }
// // //       if (network > 0) {
// // //         await FS.addToCashBox(
// // //           amount: network,
// // //           method: 'network',
// // //           note: 'توريد نهاية اليوم (شبكة)',
// // //         );
// // //       }

// // //       if (cash > 0) {
// // //         await FS.deductFromDailyBox(
// // //           amount: cash,
// // //           method: 'cash',
// // //           note: 'توريد نهاية اليوم',
// // //           type: 'end_of_day_transfer',
// // //         );
// // //       }
// // //       if (network > 0) {
// // //         await FS.deductFromDailyBox(
// // //           amount: network,
// // //           method: 'network',
// // //           note: 'توريد نهاية اليوم',
// // //           type: 'end_of_day_transfer',
// // //         );
// // //       }

// // //       await FS.resetDailyBox();

// // //       await _loadAllData();
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //             content: Text(_t('تم توريد نهاية اليوم بنجاح',
// // //                 'End-of-day transfer completed'))),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('خطأ: $e')),
// // //       );
// // //     }
// // //   }

// // //   // =========================================================================
// // //   // بناء واجهة صندوق اليومي (مطابقة للصورة)
// // //   // =========================================================================
// // //   Widget _buildDailyBoxTab() {
// // //     return SingleChildScrollView(
// // //       padding: const EdgeInsets.all(14),
// // //       child: Column(
// // //         children: [
// // //           // بطاقة الرصيد
// // //           _darkCard(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   _t('رصيد صندوق اليومي', 'Daily Box Balance'),
// // //                   style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white),
// // //                 ),
// // //                 const SizedBox(height: 18),
// // //                 Center(
// // //                   child: RichText(
// // //                     text: TextSpan(
// // //                       children: [
// // //                         TextSpan(
// // //                           text: 'ر.س',
// // //                           style: TextStyle(
// // //                               fontSize: 16,
// // //                               color: kTextSecondary,
// // //                               fontWeight: FontWeight.w500),
// // //                         ),
// // //                         const TextSpan(text: '  '),
// // //                         TextSpan(
// // //                           text: (dailyCash + dailyNetwork).toStringAsFixed(0),
// // //                           style: const TextStyle(
// // //                               fontSize: 32,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.white),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 18),
// // //                 Row(
// // //                   children: [
// // //                     Expanded(
// // //                         child: _buildBalanceItem(
// // //                             label: _t('شبكة', 'Network'),
// // //                             amount: dailyNetwork)),
// // //                     const SizedBox(width: 10),
// // //                     Expanded(
// // //                         child: _buildBalanceItem(
// // //                             label: _t('نقدي', 'Cash'), amount: dailyCash)),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 // صف أزرار مصروف وإيداع
// // //                 Row(
// // //                   children: [
// // //                     _pillButton(
// // //                       label: _t('مصروف', 'Expense'),
// // //                       icon: Icons.remove_circle,
// // //                       color: kRed,
// // //                       filled: true,
// // //                       expanded: true,
// // //                       onPressed: _showExpenseDialog,
// // //                     ),
// // //                     _pillButton(
// // //                       label: _t('إيداع', 'Deposit'),
// // //                       icon: Icons.add_circle,
// // //                       color: kGreen,
// // //                       filled: true,
// // //                       expanded: true,
// // //                       onPressed: _showDepositDialog,
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 // زر توريد نهاية اليوم (كامل العرض)
// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   child: _pillButton(
// // //                     label: _t('توريد نهاية اليوم للخزنة (كامل الرصيد)',
// // //                         'End-of-Day Transfer to Safe (Full Balance)'),
// // //                     icon: Icons.payments,
// // //                     color: kGold,
// // //                     filled: true,
// // //                     expanded: false,
// // //                     onPressed: _showEndOfDayTransfer,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           // قسم العهدة
// // //           _darkCard(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   _t('عهدة الصندوق اليومي', 'Daily Box Float'),
// // //                   style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white),
// // //                 ),
// // //                 const SizedBox(height: 8),
// // //                 Text(
// // //                   _t(
// // //                     'سلم عهدة ابتدائية من الخزنة لمن يقف على الصندوق. وعند نهاية الوردية اجرد الدرج فعلياً وسجل الفرق.',
// // //                     'An initial float is given from the safe to the cashier. At the end of shift, count the actual drawer and record the difference.',
// // //                   ),
// // //                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 // عرض العهدة الحالية (قيم نقدي وشبكة)
// // //                 Container(
// // //                   padding: const EdgeInsets.all(12),
// // //                   decoration: BoxDecoration(
// // //                     color: kFieldFill,
// // //                     borderRadius: BorderRadius.circular(12),
// // //                     border: Border.all(color: kCardBorder),
// // //                   ),
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                     children: [
// // //                       Column(
// // //                         children: [
// // //                           Text(_t('نقدي', 'Cash'),
// // //                               style: const TextStyle(
// // //                                   color: kTextSecondary, fontSize: 12)),
// // //                           Text('ر.س ${dailyFloatCash.toStringAsFixed(0)}',
// // //                               style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontWeight: FontWeight.bold)),
// // //                         ],
// // //                       ),
// // //                       Container(width: 1, height: 30, color: kCardBorder),
// // //                       Column(
// // //                         children: [
// // //                           Text(_t('شبكة', 'Network'),
// // //                               style: const TextStyle(
// // //                                   color: kTextSecondary, fontSize: 12)),
// // //                           Text('ر.س ${dailyFloatNetwork.toStringAsFixed(0)}',
// // //                               style: const TextStyle(
// // //                                   color: Colors.white,
// // //                                   fontWeight: FontWeight.bold)),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 // زرين فتح عهدة جديدة وتحويل جزئي
// // //                 Row(
// // //                   children: [
// // //                     _pillButton(
// // //                       label: _t('فتح عهدة جديدة', 'Open New Float'),
// // //                       icon: Icons.add,
// // //                       color: kGold,
// // //                       filled: true,
// // //                       expanded: true,
// // //                       onPressed: _showOpenFloatDialog,
// // //                     ),
// // //                     _pillButton(
// // //                       label: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer'),
// // //                       icon: Icons.swap_horiz,
// // //                       color: kGold,
// // //                       filled: false,
// // //                       expanded: true,
// // //                       onPressed: _showPartialTransferToSafeDialog,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           // قائمة الحركات (اختياري، يمكن إضافتها أسفل كل شيء)
// // //           if (dailyTransactions.isNotEmpty) ...[
// // //             const SizedBox(height: 16),
// // //             _darkCard(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Text(
// // //                     _t('آخر الحركات', 'Recent Transactions'),
// // //                     style: const TextStyle(
// // //                         fontWeight: FontWeight.bold, color: Colors.white),
// // //                   ),
// // //                   const SizedBox(height: 6),
// // //                   ...dailyTransactions.take(10).map((t) {
// // //                     final type = t['type'] ?? '';
// // //                     final method = t['method'] ?? '';
// // //                     final amount = (t['amount'] ?? 0).toDouble();
// // //                     final category = t['category'] ?? '';
// // //                     final note = t['note'] ?? '';
// // //                     final isAdd = (type == 'float_open' || type == 'deposit');
// // //                     final color = isAdd ? kGreen : kRed;
// // //                     final icon = isAdd ? Icons.add_circle : Icons.remove_circle;
// // //                     final typeLabel = {
// // //                           'float_open': _t('فتح عهدة', 'Open Float'),
// // //                           'deposit': _t('إيداع', 'Deposit'),
// // //                           'expense': _t('مصروف', 'Expense'),
// // //                           'transfer_to_safe':
// // //                               _t('تحويل للخزنة', 'Transfer to Safe'),
// // //                           'end_of_day_transfer':
// // //                               _t('توريد نهاية اليوم', 'End of Day'),
// // //                         }[type] ??
// // //                         type;

// // //                     return ListTile(
// // //                       contentPadding: EdgeInsets.zero,
// // //                       dense: true,
// // //                       leading: Icon(icon, color: color),
// // //                       title: Text(
// // //                         '$typeLabel - ${method == 'cash' ? 'نقدي' : 'شبكة'}',
// // //                         style: const TextStyle(
// // //                             fontSize: 13.5, color: Colors.white),
// // //                       ),
// // //                       subtitle: Text(
// // //                         category.isNotEmpty ? '$category | $note' : note,
// // //                         maxLines: 1,
// // //                         overflow: TextOverflow.ellipsis,
// // //                         style: const TextStyle(
// // //                             color: kTextSecondary, fontSize: 11.5),
// // //                       ),
// // //                       trailing: Text(
// // //                         '${isAdd ? '+' : '-'}ر.س ${amount.toStringAsFixed(0)}',
// // //                         style: TextStyle(
// // //                           color: color,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     );
// // //                   }),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // بناء واجهة الخزنة
// // //   // =========================================================================
// // //   Widget _buildSafeBoxTab() {
// // //     return SingleChildScrollView(
// // //       padding: const EdgeInsets.all(14),
// // //       child: Column(
// // //         children: [
// // //           _darkCard(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   _t('رصيد الخزنة', 'Safe Balance'),
// // //                   style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white),
// // //                 ),
// // //                 const SizedBox(height: 18),
// // //                 Center(
// // //                   child: RichText(
// // //                     text: TextSpan(
// // //                       children: [
// // //                         TextSpan(
// // //                           text: 'ر.س',
// // //                           style: TextStyle(
// // //                               fontSize: 16,
// // //                               color: kTextSecondary,
// // //                               fontWeight: FontWeight.w500),
// // //                         ),
// // //                         const TextSpan(text: '  '),
// // //                         TextSpan(
// // //                           text: (safeCash + safeNetwork).toStringAsFixed(0),
// // //                           style: const TextStyle(
// // //                               fontSize: 32,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.white),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 18),
// // //                 Row(
// // //                   children: [
// // //                     Expanded(
// // //                         child: _buildBalanceItem(
// // //                             label: _t('شبكة', 'Network'), amount: safeNetwork)),
// // //                     const SizedBox(width: 10),
// // //                     Expanded(
// // //                         child: _buildBalanceItem(
// // //                             label: _t('نقدي', 'Cash'), amount: safeCash)),
// // //                   ],
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 Row(
// // //                   children: [
// // //                     _pillButton(
// // //                       label: _t('سحب', 'Withdraw'),
// // //                       icon: Icons.arrow_upward,
// // //                       color: kRed,
// // //                       filled: false,
// // //                       onPressed: _showWithdrawCashDialog,
// // //                     ),
// // //                     _pillButton(
// // //                       label: _t('إيداع ', 'Manual Deposit'),
// // //                       icon: Icons.arrow_downward,
// // //                       color: kGreen,
// // //                       filled: true,
// // //                       onPressed: _showDepositCashDialog,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           _darkCard(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
// // //                   style: const TextStyle(
// // //                       fontSize: 16,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.white),
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 Container(
// // //                   width: double.infinity,
// // //                   padding: const EdgeInsets.all(14),
// // //                   decoration: BoxDecoration(
// // //                     color: kFieldFill,
// // //                     borderRadius: BorderRadius.circular(14),
// // //                     border: Border.all(color: kCardBorder),
// // //                   ),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         _t('الإجمالي محوّلًا لعيار 24',
// // //                             'Total converted to 24K'),
// // //                         style: const TextStyle(
// // //                             color: kTextSecondary, fontSize: 12.5),
// // //                       ),
// // //                       const SizedBox(height: 6),
// // //                       Text(
// // //                         '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // //                         style: const TextStyle(
// // //                             fontSize: 22,
// // //                             fontWeight: FontWeight.bold,
// // //                             color: kGold),
// // //                       ),
// // //                       const SizedBox(height: 6),
// // //                       Text(
// // //                         '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
// // //                         '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
// // //                         '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
// // //                         style: const TextStyle(
// // //                             color: kTextSecondary, fontSize: 12),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 14),
// // //                 if (goldTransactions.isNotEmpty)
// // //                   Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         _t('آخر العمليات', 'Recent Transactions'),
// // //                         style: const TextStyle(
// // //                             fontWeight: FontWeight.bold, color: Colors.white),
// // //                       ),
// // //                       const SizedBox(height: 6),
// // //                       ...goldTransactions.take(5).map((t) {
// // //                         final isDeposit = t['type'] == 'deposit';
// // //                         final weight = (t['weight'] ?? 0.0).toDouble();
// // //                         final carat = (t['carat'] ?? 24).toDouble();
// // //                         final type = t['goldType'] == 'raw'
// // //                             ? _t('خام', 'Raw')
// // //                             : _t('مشغول', 'Worked');
// // //                         final date = (t['date'] as Timestamp?)?.toDate();
// // //                         final dateStr = date != null
// // //                             ? '${date.day}/${date.month}/${date.year}'
// // //                             : '';
// // //                         return ListTile(
// // //                           contentPadding: EdgeInsets.zero,
// // //                           dense: true,
// // //                           leading: Icon(
// // //                             isDeposit ? Icons.add_circle : Icons.remove_circle,
// // //                             color: isDeposit ? kGreen : kRed,
// // //                           ),
// // //                           title: Text(
// // //                             '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
// // //                             style: const TextStyle(
// // //                                 fontSize: 13.5, color: Colors.white),
// // //                           ),
// // //                           subtitle: Text(dateStr,
// // //                               style: const TextStyle(
// // //                                   color: kTextSecondary, fontSize: 11.5)),
// // //                           trailing: Text(
// // //                             '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
// // //                             style: TextStyle(
// // //                               color: isDeposit ? kGreen : kRed,
// // //                               fontWeight: FontWeight.bold,
// // //                             ),
// // //                           ),
// // //                         );
// // //                       }),
// // //                     ],
// // //                   )
// // //                 else
// // //                   Center(
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.symmetric(vertical: 8),
// // //                       child: Text(
// // //                         _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
// // //                         style: const TextStyle(color: kTextSecondary),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 const SizedBox(height: 14),
// // //                 Row(
// // //                   children: [
// // //                     _pillButton(
// // //                       label: _t('سحب', 'Withdraw'),
// // //                       icon: Icons.arrow_downward,
// // //                       color: kRed,
// // //                       filled: false,
// // //                       onPressed: _showGoldWithdrawDialog,
// // //                     ),
// // //                     _pillButton(
// // //                       label: _t('إيداع', 'Deposit'),
// // //                       icon: Icons.arrow_upward,
// // //                       color: kGreen,
// // //                       filled: true,
// // //                       onPressed: _showGoldDepositDialog,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // بناء واجهة صندوق الكسر (كما هي)
// // //   // =========================================================================
// // //   Widget _buildScrapBoxTab() {
// // //     return SingleChildScrollView(
// // //       padding: const EdgeInsets.all(14),
// // //       child: _darkCard(
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               _t('صندوق الكسر', 'Scrap Box'),
// // //               style: const TextStyle(
// // //                   fontSize: 16,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.white),
// // //             ),
// // //             const SizedBox(height: 18),
// // //             Center(
// // //               child: RichText(
// // //                 text: TextSpan(
// // //                   children: [
// // //                     TextSpan(
// // //                         text: 'ر.س  ',
// // //                         style: TextStyle(fontSize: 16, color: kTextSecondary)),
// // //                     TextSpan(
// // //                       text: (scrapCash + scrapNetwork).toStringAsFixed(0),
// // //                       style: const TextStyle(
// // //                           fontSize: 30,
// // //                           fontWeight: FontWeight.bold,
// // //                           color: Colors.white),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 18),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                     child: _buildBalanceItem(
// // //                         label: _t('شبكة', 'Network'), amount: scrapNetwork)),
// // //                 const SizedBox(width: 10),
// // //                 Expanded(
// // //                     child: _buildBalanceItem(
// // //                         label: _t('نقدي', 'Cash'), amount: scrapCash)),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 18),
// // //             Center(
// // //               child: Text(
// // //                 _t('(قيد التطوير)', '(Under development)'),
// // //                 style: const TextStyle(color: kTextSecondary),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // =========================================================================
// // //   // الواجهة الرئيسية
// // //   // =========================================================================
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: kBackground,
// // //       appBar: AppBar(
// // //         title: Text(_t('الصندوق', 'Cash Box')),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         centerTitle: true,
// // //         elevation: 0,
// // //         bottom: PreferredSize(
// // //           preferredSize: const Size.fromHeight(48),
// // //           child: Padding(
// // //             padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
// // //             child: Container(
// // //               decoration: BoxDecoration(
// // //                 color: Colors.black.withOpacity(0.15),
// // //                 borderRadius: BorderRadius.circular(30),
// // //               ),
// // //               child: TabBar(
// // //                 controller: _tabController,
// // //                 indicator: BoxDecoration(
// // //                   color: Colors.black.withOpacity(0.28),
// // //                   borderRadius: BorderRadius.circular(30),
// // //                 ),
// // //                 indicatorSize: TabBarIndicatorSize.tab,
// // //                 labelColor: Colors.white,
// // //                 unselectedLabelColor: Colors.black54,
// // //                 labelStyle:
// // //                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
// // //                 dividerColor: Colors.transparent,
// // //                 tabs: [
// // //                   Tab(text: _t('صندوق الكسر', 'Scrap Box')),
// // //                   Tab(text: _t('صندوق اليومي', 'Daily Box')),
// // //                   Tab(text: _t('الخزنة', 'Safe Box')),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //       body: loading
// // //           ? Center(child: CircularProgressIndicator(color: kGold))
// // //           : Column(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
// // //                   child: Container(
// // //                     padding: const EdgeInsets.symmetric(vertical: 14),
// // //                     decoration: BoxDecoration(
// // //                       color: kCard,
// // //                       borderRadius: BorderRadius.circular(18),
// // //                       border: Border.all(color: kCardBorder),
// // //                     ),
// // //                     child: Row(
// // //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                       children: [
// // //                         Column(
// // //                           children: [
// // //                             Text(_t('الإجمالي', 'Total'),
// // //                                 style: const TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: kTextSecondary,
// // //                                     fontSize: 12.5)),
// // //                             const SizedBox(height: 4),
// // //                             Text(
// // //                               '${totalBalance.toStringAsFixed(2)} ر.س',
// // //                               style: TextStyle(
// // //                                 fontSize: 18,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 color: totalBalance >= 0 ? kGreen : kRed,
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                         Container(width: 1, height: 30, color: kCardBorder),
// // //                         Column(
// // //                           children: [
// // //                             Text(_t('نقدي', 'Cash'),
// // //                                 style: const TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: kTextSecondary,
// // //                                     fontSize: 12.5)),
// // //                             const SizedBox(height: 4),
// // //                             Text('${cashTotal.toStringAsFixed(2)}',
// // //                                 style: const TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontWeight: FontWeight.bold)),
// // //                           ],
// // //                         ),
// // //                         Container(width: 1, height: 30, color: kCardBorder),
// // //                         Column(
// // //                           children: [
// // //                             Text(_t('شبكة', 'Network'),
// // //                                 style: const TextStyle(
// // //                                     fontWeight: FontWeight.bold,
// // //                                     color: kTextSecondary,
// // //                                     fontSize: 12.5)),
// // //                             const SizedBox(height: 4),
// // //                             Text('${networkTotal.toStringAsFixed(2)}',
// // //                                 style: const TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontWeight: FontWeight.bold)),
// // //                           ],
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 Expanded(
// // //                   child: TabBarView(
// // //                     controller: _tabController,
// // //                     children: [
// // //                       _buildScrapBoxTab(),
// // //                       _buildDailyBoxTab(),
// // //                       _buildSafeBoxTab(),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/firestore_service.dart';

// // class CashBoxPage extends StatefulWidget {
// //   const CashBoxPage({super.key});

// //   @override
// //   State<CashBoxPage> createState() => _CashBoxPageState();
// // }

// // class _CashBoxPageState extends State<CashBoxPage>
// //     with SingleTickerProviderStateMixin {
// //   // ===== ألوان التصميم =====
// //   static const Color kGold = Color(0xFFD4AF37);
// //   static const Color kBackground = Color(0xFF121212);
// //   static const Color kCard = Color(0xFF1C1C1C);
// //   static const Color kCardBorder = Color(0xFF2A2A2A);
// //   static const Color kFieldFill = Color(0xFF161616);
// //   static const Color kGreen = Color(0xFF4CAF50);
// //   static const Color kRed = Color(0xFFE05353);
// //   static const Color kTextSecondary = Color(0xFF9E9E9E);

// //   // ===== متغيرات الأقسام =====
// //   double totalBalance = 0.0;
// //   double cashTotal = 0.0;
// //   double networkTotal = 0.0;

// //   // ===== الخزنة (نقدي) =====
// //   double safeCash = 0.0;
// //   double safeNetwork = 0.0;

// //   // ===== الخزنة (ذهب) =====
// //   double goldTotal24K = 0.0;
// //   double goldTotalActual = 0.0;
// //   double goldScrapWeight = 0.0;
// //   double goldWorkedWeight = 0.0;
// //   List<Map<String, dynamic>> goldTransactions = [];

// //   // ===== صندوق اليومي =====
// //   double dailyCash = 0.0;
// //   double dailyNetwork = 0.0;
// //   List<Map<String, dynamic>> dailyTransactions = [];
// //   double dailyFloatCash = 0.0;
// //   double dailyFloatNetwork = 0.0;

// //   // ===== صندوق الكسر =====
// //   double scrapCash = 0.0;
// //   double scrapNetwork = 0.0;
// //   List<Map<String, dynamic>> scrapTransactions = [];

// //   bool loading = true;
// //   String _lang = 'ar';
// //   late TabController _tabController;

// //   // قوائم التصنيفات
// //   final List<String> expenseCategories = [
// //     'سحب شخصي / سحب شريك',
// //     'أخرى',
// //   ];
// //   final List<String> depositCategories = [
// //     'إيرادات أخرى',
// //     'رأس مال / مساهمة شريك',
// //   ];

// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this);
// //     _loadLanguage();
// //     _loadAllData();
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   // ===== تحميل جميع البيانات =====
// //   Future<void> _loadAllData() async {
// //     setState(() => loading = true);
// //     try {
// //       final cashBalance = await FS.getCashBoxBalance();
// //       safeCash = cashBalance['cash']!;
// //       safeNetwork = cashBalance['network']!;

// //       final goldSummary = await FS.getSafeGoldSummary();
// //       goldTotal24K = goldSummary['total24K'] ?? 0.0;
// //       goldTotalActual = goldSummary['totalActual'] ?? 0.0;
// //       goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
// //       goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
// //       goldTransactions =
// //           List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

// //       await _loadDailyBoxData();

// //       final scrapData = await _getScrapBoxData();
// //       scrapCash = scrapData['cash'];
// //       scrapNetwork = scrapData['network'];
// //       scrapTransactions = scrapData['transactions'];

// //       totalBalance = (safeCash + safeNetwork) +
// //           (dailyCash + dailyNetwork) +
// //           (scrapCash + scrapNetwork);
// //       cashTotal = safeCash + dailyCash + scrapCash;
// //       networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

// //       setState(() => loading = false);
// //     } catch (e) {
// //       setState(() => loading = false);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
// //       );
// //     }
// //   }

// //   Future<void> _loadDailyBoxData() async {
// //     try {
// //       final balance = await FS.getDailyBoxBalance();
// //       dailyCash = balance['cash']!;
// //       dailyNetwork = balance['network']!;

// //       final history = await FS.getDailyBoxHistory();
// //       dailyTransactions = history;

// //       double floatCash = 0.0;
// //       double floatNetwork = 0.0;
// //       for (var t in history) {
// //         if (t['type'] == 'float_open') {
// //           if (t['method'] == 'cash')
// //             floatCash += (t['amount'] ?? 0).toDouble();
// //           else if (t['method'] == 'network')
// //             floatNetwork += (t['amount'] ?? 0).toDouble();
// //         }
// //       }
// //       dailyFloatCash = floatCash;
// //       dailyFloatNetwork = floatNetwork;
// //     } catch (e) {
// //       print('⚠️ خطأ في تحميل الصندوق اليومي: $e');
// //     }
// //   }

// //   Future<Map<String, dynamic>> _getScrapBoxData() async {
// //     double cash = 0.0, network = 0.0;
// //     List<Map<String, dynamic>> transactions = [];

// //     final scrapSnap = await FS.scrapCol().get();
// //     for (var doc in scrapSnap.docs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final type = data['type'] ?? '';
// //       final c = (data['cash'] ?? 0.0).toDouble();
// //       final n = (data['network'] ?? 0.0).toDouble();

// //       if (type == 'add') {
// //         cash -= c;
// //         network -= n;
// //         transactions.add({
// //           'type': 'شراء كسر',
// //           'cash': -c,
// //           'network': -n,
// //           'date': data['date'],
// //           'data': data
// //         });
// //       } else if (type == 'sale') {
// //         cash += c;
// //         network += n;
// //         transactions.add({
// //           'type': 'بيع كسر',
// //           'cash': c,
// //           'network': n,
// //           'date': data['date'],
// //           'data': data
// //         });
// //       } else if (type == 'payment') {
// //         cash -= c;
// //         network -= n;
// //         transactions.add({
// //           'type': 'سند صرف',
// //           'cash': -c,
// //           'network': -n,
// //           'date': data['date'],
// //           'data': data
// //         });
// //       }
// //     }
// //     return {'cash': cash, 'network': network, 'transactions': transactions};
// //   }

// //   // =========================================================================
// //   // عناصر تصميم مشتركة
// //   // =========================================================================

// //   Widget _segmentedToggle({
// //     required List<MapEntry<String, String>> options,
// //     required String value,
// //     required ValueChanged<String> onChanged,
// //   }) {
// //     return Row(
// //       children: options.map((opt) {
// //         final selected = opt.key == value;
// //         return Expanded(
// //           child: GestureDetector(
// //             onTap: () => onChanged(opt.key),
// //             child: Container(
// //               margin: const EdgeInsets.symmetric(horizontal: 4),
// //               padding: const EdgeInsets.symmetric(vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
// //                 borderRadius: BorderRadius.circular(30),
// //                 border: Border.all(
// //                     color: selected ? kGold : kCardBorder, width: 1.2),
// //               ),
// //               child: Text(
// //                 opt.value,
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   color: selected ? kGold : Colors.white70,
// //                   fontWeight: selected ? FontWeight.bold : FontWeight.normal,
// //                   fontSize: 13,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       }).toList(),
// //     );
// //   }

// //   Widget _darkField({
// //     required TextEditingController controller,
// //     required String label,
// //     TextInputType? keyboardType,
// //     String? prefixText,
// //     bool enabled = true,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: keyboardType,
// //       enabled: enabled,
// //       style: const TextStyle(color: Colors.white),
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: const TextStyle(color: kTextSecondary),
// //         prefixText: prefixText,
// //         prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
// //         filled: true,
// //         fillColor: kFieldFill,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: kCardBorder),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: kCardBorder),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: const BorderSide(color: kGold, width: 1.4),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _pillButton({
// //     required String label,
// //     required VoidCallback onPressed,
// //     required Color color,
// //     bool filled = true,
// //     IconData? icon,
// //     bool expanded = true,
// //   }) {
// //     Widget btn = filled
// //         ? ElevatedButton.icon(
// //             onPressed: onPressed,
// //             icon: icon != null
// //                 ? Icon(icon, size: 18, color: Colors.black)
// //                 : const SizedBox.shrink(),
// //             label: Text(label,
// //                 style: const TextStyle(
// //                     fontWeight: FontWeight.bold, color: Colors.black)),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: color,
// //               minimumSize: const Size(0, 46),
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(30)),
// //               elevation: 0,
// //             ),
// //           )
// //         : OutlinedButton.icon(
// //             onPressed: onPressed,
// //             icon: icon != null
// //                 ? Icon(icon, size: 18, color: color)
// //                 : const SizedBox.shrink(),
// //             label: Text(label,
// //                 style: TextStyle(fontWeight: FontWeight.bold, color: color)),
// //             style: OutlinedButton.styleFrom(
// //               side: BorderSide(color: color.withOpacity(0.6)),
// //               backgroundColor: color.withOpacity(0.08),
// //               minimumSize: const Size(0, 46),
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(30)),
// //             ),
// //           );

// //     return expanded
// //         ? Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 4),
// //               child: btn,
// //             ),
// //           )
// //         : btn;
// //   }

// //   Widget _darkCard({required Widget child}) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(18),
// //       decoration: BoxDecoration(
// //         color: kCard,
// //         borderRadius: BorderRadius.circular(18),
// //         border: Border.all(color: kCardBorder),
// //       ),
// //       child: child,
// //     );
// //   }

// //   Widget _darkDialogShell({
// //     required String title,
// //     required Widget content,
// //     required List<Widget> actions,
// //   }) {
// //     return AlertDialog(
// //       backgroundColor: kCard,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(20),
// //         side: const BorderSide(color: kCardBorder),
// //       ),
// //       title: Text(title,
// //           style: const TextStyle(
// //               color: Colors.white, fontWeight: FontWeight.bold)),
// //       content: content,
// //       actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //       actions: actions,
// //     );
// //   }

// //   Widget _buildBalanceItem({
// //     required String label,
// //     required double amount,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 14),
// //       decoration: BoxDecoration(
// //         color: kFieldFill,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: kCardBorder),
// //       ),
// //       child: Column(
// //         children: [
// //           Text(label,
// //               style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
// //           const SizedBox(height: 6),
// //           Text(
// //             'ر.س${amount.toStringAsFixed(0)}',
// //             style: const TextStyle(
// //                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // دوال الخزنة النقدية
// //   // =========================================================================
// //   void _showDepositCashDialog() {
// //     String method = 'cash';
// //     final amountController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _segmentedToggle(
// //                   options: [
// //                     const MapEntry('cash', 'نقدي'),
// //                     const MapEntry('network', 'شبكة'),
// //                   ],
// //                   value: method,
// //                   onChanged: (val) => setDialogState(() => method = val),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 _darkField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('المبلغ', 'Amount'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 14),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kGreen,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// //                 if (amount <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 try {
// //                   await FS.addToCashBox(
// //                     amount: amount,
// //                     method: method,
// //                     note: noteController.text.isNotEmpty
// //                         ? noteController.text
// //                         : null,
// //                   );
// //                   Navigator.pop(context);
// //                   _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content:
// //                             Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('إيداع', 'Deposit'),
// //                   style: const TextStyle(
// //                       color: Colors.black, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showWithdrawCashDialog() {
// //     String method = 'cash';
// //     final amountController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _segmentedToggle(
// //                   options: [
// //                     const MapEntry('cash', 'نقدي'),
// //                     const MapEntry('network', 'شبكة'),
// //                   ],
// //                   value: method,
// //                   onChanged: (val) => setDialogState(() => method = val),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 _darkField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('المبلغ', 'Amount'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 14),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kRed,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// //                 if (amount <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 final balance = await FS.getCashBoxBalance();
// //                 double available =
// //                     method == 'cash' ? balance['cash']! : balance['network']!;
// //                 if (amount > available) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content: Text(
// //                             _t('الرصيد غير كافٍ', 'Insufficient balance'))),
// //                   );
// //                   return;
// //                 }
// //                 try {
// //                   await FS.deductFromCashBox(
// //                     amount: amount,
// //                     method: method,
// //                     note: noteController.text.isNotEmpty
// //                         ? noteController.text
// //                         : null,
// //                   );
// //                   Navigator.pop(context);
// //                   _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content: Text(
// //                             _t('تم السحب بنجاح', 'Withdrawal successful'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('سحب', 'Withdraw'),
// //                   style: const TextStyle(
// //                       color: Colors.white, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // دوال الخزنة (ذهب)
// //   // =========================================================================
// //   void _showGoldDepositDialog() {
// //     _showGoldDialog(mode: 'deposit');
// //   }

// //   void _showGoldWithdrawDialog() {
// //     _showGoldDialog(mode: 'withdraw');
// //   }

// //   void _showGoldDialog({required String mode}) {
// //     String goldType = 'raw';
// //     String carat = '21';
// //     final weightController = TextEditingController();
// //     final noteController = TextEditingController();

// //     final caratList = ['14', '18', '21', '22', '24'];
// //     final actionColor = mode == 'deposit' ? kGreen : kRed;

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: mode == 'deposit'
// //               ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
// //               : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _segmentedToggle(
// //                   options: [
// //                     MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
// //                     MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
// //                   ],
// //                   value: goldType,
// //                   onChanged: (val) => setDialogState(() => goldType = val),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// //                   decoration: BoxDecoration(
// //                     color: kFieldFill,
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(color: kCardBorder),
// //                   ),
// //                   child: DropdownButtonHideUnderline(
// //                     child: DropdownButton<String>(
// //                       value: carat,
// //                       isExpanded: true,
// //                       dropdownColor: kCard,
// //                       iconEnabledColor: kGold,
// //                       style: const TextStyle(color: Colors.white),
// //                       items: caratList.map((c) {
// //                         return DropdownMenuItem(
// //                             value: c, child: Text('$c ${_t('عيار', 'K')}'));
// //                       }).toList(),
// //                       onChanged: (val) => setDialogState(() => carat = val!),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 14),
// //                 _darkField(
// //                   controller: weightController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('الوزن (جرام)', 'Weight (g)'),
// //                 ),
// //                 const SizedBox(height: 14),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: actionColor,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final weight = double.tryParse(weightController.text) ?? 0.0;
// //                 if (weight <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('الوزن يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 final caratDouble = double.tryParse(carat) ?? 21.0;

// //                 try {
// //                   if (mode == 'deposit') {
// //                     await FS.depositSafeGold(
// //                       goldType: goldType,
// //                       carat: caratDouble,
// //                       weight: weight,
// //                       note: noteController.text.isNotEmpty
// //                           ? noteController.text
// //                           : null,
// //                     );
// //                   } else {
// //                     final summary = await FS.getSafeGoldSummary();
// //                     final transactions =
// //                         summary['transactions'] as List<Map<String, dynamic>>;
// //                     double available = 0.0;
// //                     for (var t in transactions) {
// //                       if (t['goldType'] == goldType &&
// //                           (t['carat'] ?? 24).toDouble() == caratDouble) {
// //                         if (t['type'] == 'deposit') {
// //                           available += (t['weight'] ?? 0.0).toDouble();
// //                         } else if (t['type'] == 'withdraw') {
// //                           available -= (t['weight'] ?? 0.0).toDouble();
// //                         }
// //                       }
// //                     }
// //                     if (weight > available) {
// //                       ScaffoldMessenger.of(context).showSnackBar(
// //                         SnackBar(
// //                             content: Text(_t(
// //                                 'الرصيد غير كافٍ لهذا العيار والنوع',
// //                                 'Insufficient balance for this carat and type'))),
// //                       );
// //                       return;
// //                     }
// //                     await FS.withdrawSafeGold(
// //                       goldType: goldType,
// //                       carat: caratDouble,
// //                       weight: weight,
// //                       note: noteController.text.isNotEmpty
// //                           ? noteController.text
// //                           : null,
// //                     );
// //                   }
// //                   Navigator.pop(context);
// //                   _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text(
// //                         mode == 'deposit'
// //                             ? _t('تم إيداع الذهب بنجاح',
// //                                 'Gold deposited successfully')
// //                             : _t('تم سحب الذهب بنجاح',
// //                                 'Gold withdrawn successfully'),
// //                       ),
// //                     ),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(
// //                 mode == 'deposit'
// //                     ? _t('إيداع', 'Deposit')
// //                     : _t('سحب', 'Withdraw'),
// //                 style: TextStyle(
// //                     color: mode == 'deposit' ? Colors.black : Colors.white,
// //                     fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // دوال صندوق اليومي
// //   // =========================================================================

// //   void _showOpenFloatDialog() {
// //     final cashController = TextEditingController();
// //     final networkController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('فتح عهدة جديدة', 'Open New Float'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   _t('تخصص العهدة من الخزنة وتضاف لصندوق اليومي.',
// //                       'Float is taken from safe and added to daily box.'),
// //                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 _darkField(
// //                   controller: cashController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('نقدي (ر.س)', 'Cash (SAR)'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: networkController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('شبكة (ر.س)', 'Network (SAR)'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(_t('إجمالي العهدة', 'Total Float'),
// //                         style: const TextStyle(color: Colors.white70)),
// //                     ValueListenableBuilder(
// //                       valueListenable: cashController,
// //                       builder: (_, __, ___) {
// //                         final cash = double.tryParse(cashController.text) ?? 0;
// //                         final network =
// //                             double.tryParse(networkController.text) ?? 0;
// //                         return Text(
// //                           'ر.س ${(cash + network).toStringAsFixed(2)}',
// //                           style: const TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                               color: kGold),
// //                         );
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kGold,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final cash = double.tryParse(cashController.text) ?? 0.0;
// //                 final network = double.tryParse(networkController.text) ?? 0.0;
// //                 if (cash <= 0 && network <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('يجب إدخال مبلغ في أحد الحقلين')),
// //                   );
// //                   return;
// //                 }

// //                 try {
// //                   final safeBal = await FS.getCashBoxBalance();
// //                   if (cash > safeBal['cash']!) {
// //                     throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
// //                   }
// //                   if (network > safeBal['network']!) {
// //                     throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
// //                   }

// //                   if (cash > 0) {
// //                     await FS.deductFromCashBox(
// //                       amount: cash,
// //                       method: 'cash',
// //                       note: 'فتح عهدة صندوق يومي',
// //                     );
// //                   }
// //                   if (network > 0) {
// //                     await FS.deductFromCashBox(
// //                       amount: network,
// //                       method: 'network',
// //                       note: 'فتح عهدة صندوق يومي',
// //                     );
// //                   }

// //                   if (cash > 0) {
// //                     await FS.addToDailyBox(
// //                       amount: cash,
// //                       method: 'cash',
// //                       note: noteController.text.isNotEmpty
// //                           ? noteController.text
// //                           : 'فتح عهدة',
// //                       type: 'float_open',
// //                     );
// //                   }
// //                   if (network > 0) {
// //                     await FS.addToDailyBox(
// //                       amount: network,
// //                       method: 'network',
// //                       note: noteController.text.isNotEmpty
// //                           ? noteController.text
// //                           : 'فتح عهدة',
// //                       type: 'float_open',
// //                     );
// //                   }

// //                   Navigator.pop(context);
// //                   await _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content: Text(_t('تم فتح العهدة بنجاح',
// //                             'Float opened successfully'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('فتح العهدة', 'Open Float'),
// //                   style: const TextStyle(
// //                       color: Colors.black, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showExpenseDialog() {
// //     String method = 'cash';
// //     String selectedCategory = expenseCategories.first;
// //     final amountController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('تسجيل مصروف', 'Record Expense'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// //                   decoration: BoxDecoration(
// //                     color: kFieldFill,
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(color: kCardBorder),
// //                   ),
// //                   child: DropdownButtonHideUnderline(
// //                     child: DropdownButton<String>(
// //                       value: selectedCategory,
// //                       isExpanded: true,
// //                       dropdownColor: kCard,
// //                       iconEnabledColor: kGold,
// //                       style: const TextStyle(color: Colors.white),
// //                       items: expenseCategories.map((cat) {
// //                         return DropdownMenuItem(value: cat, child: Text(cat));
// //                       }).toList(),
// //                       onChanged: (val) =>
// //                           setDialogState(() => selectedCategory = val!),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _segmentedToggle(
// //                   options: [
// //                     const MapEntry('cash', 'نقدي'),
// //                     const MapEntry('network', 'شبكة'),
// //                   ],
// //                   value: method,
// //                   onChanged: (val) => setDialogState(() => method = val),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('المبلغ', 'Amount'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kRed,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// //                 if (amount <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 try {
// //                   await FS.deductFromDailyBox(
// //                     amount: amount,
// //                     method: method,
// //                     category: selectedCategory,
// //                     note: noteController.text.isNotEmpty
// //                         ? noteController.text
// //                         : null,
// //                     type: 'expense',
// //                   );
// //                   Navigator.pop(context);
// //                   await _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content:
// //                             Text(_t('تم تسجيل المصروف', 'Expense recorded'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('حفظ', 'Save'),
// //                   style: const TextStyle(
// //                       color: Colors.white, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showDepositDialog() {
// //     String method = 'cash';
// //     String selectedCategory = depositCategories.first;
// //     final amountController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('تسجيل إيداع', 'Record Deposit'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 14),
// //                   decoration: BoxDecoration(
// //                     color: kFieldFill,
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(color: kCardBorder),
// //                   ),
// //                   child: DropdownButtonHideUnderline(
// //                     child: DropdownButton<String>(
// //                       value: selectedCategory,
// //                       isExpanded: true,
// //                       dropdownColor: kCard,
// //                       iconEnabledColor: kGold,
// //                       style: const TextStyle(color: Colors.white),
// //                       items: depositCategories.map((cat) {
// //                         return DropdownMenuItem(value: cat, child: Text(cat));
// //                       }).toList(),
// //                       onChanged: (val) =>
// //                           setDialogState(() => selectedCategory = val!),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _segmentedToggle(
// //                   options: [
// //                     const MapEntry('cash', 'نقدي'),
// //                     const MapEntry('network', 'شبكة'),
// //                   ],
// //                   value: method,
// //                   onChanged: (val) => setDialogState(() => method = val),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('المبلغ', 'Amount'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kGreen,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// //                 if (amount <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 try {
// //                   await FS.addToDailyBox(
// //                     amount: amount,
// //                     method: method,
// //                     category: selectedCategory,
// //                     note: noteController.text.isNotEmpty
// //                         ? noteController.text
// //                         : null,
// //                     type: 'deposit',
// //                   );
// //                   Navigator.pop(context);
// //                   await _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content:
// //                             Text(_t('تم تسجيل الإيداع', 'Deposit recorded'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('حفظ', 'Save'),
// //                   style: const TextStyle(
// //                       color: Colors.black, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showPartialTransferToSafeDialog() {
// //     String method = 'cash';
// //     final amountController = TextEditingController();
// //     final noteController = TextEditingController();

// //     showDialog(
// //       context: context,
// //       builder: (_) => StatefulBuilder(
// //         builder: (context, setDialogState) => _darkDialogShell(
// //           title: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer to Safe'),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _segmentedToggle(
// //                   options: [
// //                     const MapEntry('cash', 'نقدي'),
// //                     const MapEntry('network', 'شبكة'),
// //                   ],
// //                   value: method,
// //                   onChanged: (val) => setDialogState(() => method = val),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: amountController,
// //                   keyboardType: TextInputType.number,
// //                   label: _t('المبلغ', 'Amount'),
// //                   prefixText: 'ر.س ',
// //                 ),
// //                 const SizedBox(height: 12),
// //                 _darkField(
// //                   controller: noteController,
// //                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text(_t('إلغاء', 'Cancel'),
// //                   style: const TextStyle(color: kTextSecondary)),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: kGold,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(24)),
// //               ),
// //               onPressed: () async {
// //                 final amount = double.tryParse(amountController.text) ?? 0.0;
// //                 if (amount <= 0) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     const SnackBar(
// //                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
// //                   );
// //                   return;
// //                 }
// //                 try {
// //                   await FS.deductFromDailyBox(
// //                     amount: amount,
// //                     method: method,
// //                     note: noteController.text.isNotEmpty
// //                         ? noteController.text
// //                         : 'تحويل للخزنة',
// //                     type: 'transfer_to_safe',
// //                   );
// //                   await FS.addToCashBox(
// //                     amount: amount,
// //                     method: method,
// //                     note: 'تحويل من الصندوق اليومي',
// //                   );
// //                   Navigator.pop(context);
// //                   await _loadAllData();
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content: Text(_t('تم التحويل', 'Transfer completed'))),
// //                   );
// //                 } catch (e) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(content: Text('خطأ: $e')),
// //                   );
// //                 }
// //               },
// //               child: Text(_t('تحويل', 'Transfer'),
// //                   style: const TextStyle(
// //                       color: Colors.black, fontWeight: FontWeight.bold)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showEndOfDayTransfer() async {
// //     final confirm = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: kCard,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //           side: const BorderSide(color: kCardBorder),
// //         ),
// //         title: Text(_t('توريد نهاية اليوم', 'End-of-Day Transfer'),
// //             style: const TextStyle(color: Colors.white)),
// //         content: Text(
// //           _t('سيتم تحويل كامل رصيد الصندوق اليومي إلى الخزنة وإعادة تعيينه.',
// //               'All daily box balance will be transferred to safe and reset.'),
// //           style: const TextStyle(color: Colors.white70),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             child: Text(_t('إلغاء', 'Cancel'),
// //                 style: const TextStyle(color: kTextSecondary)),
// //           ),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: kRed,
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(24)),
// //             ),
// //             onPressed: () => Navigator.pop(context, true),
// //             child: Text(_t('تأكيد', 'Confirm'),
// //                 style: const TextStyle(
// //                     color: Colors.white, fontWeight: FontWeight.bold)),
// //           ),
// //         ],
// //       ),
// //     );
// //     if (confirm != true) return;

// //     try {
// //       final balance = await FS.getDailyBoxBalance();
// //       double cash = balance['cash']!;
// //       double network = balance['network']!;

// //       if (cash > 0) {
// //         await FS.addToCashBox(
// //           amount: cash,
// //           method: 'cash',
// //           note: 'توريد نهاية اليوم (نقدي)',
// //         );
// //       }
// //       if (network > 0) {
// //         await FS.addToCashBox(
// //           amount: network,
// //           method: 'network',
// //           note: 'توريد نهاية اليوم (شبكة)',
// //         );
// //       }

// //       if (cash > 0) {
// //         await FS.deductFromDailyBox(
// //           amount: cash,
// //           method: 'cash',
// //           note: 'توريد نهاية اليوم',
// //           type: 'end_of_day_transfer',
// //         );
// //       }
// //       if (network > 0) {
// //         await FS.deductFromDailyBox(
// //           amount: network,
// //           method: 'network',
// //           note: 'توريد نهاية اليوم',
// //           type: 'end_of_day_transfer',
// //         );
// //       }

// //       await FS.resetDailyBox();

// //       await _loadAllData();
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //             content: Text(_t('تم توريد نهاية اليوم بنجاح',
// //                 'End-of-day transfer completed'))),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('خطأ: $e')),
// //       );
// //     }
// //   }

// //   // =========================================================================
// //   // بناء واجهة صندوق اليومي (مطابقة للصورة)
// //   // =========================================================================
// //   Widget _buildDailyBoxTab() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(14),
// //       child: Column(
// //         children: [
// //           // بطاقة الرصيد
// //           _darkCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   _t('رصيد صندوق اليومي', 'Daily Box Balance'),
// //                   style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white),
// //                 ),
// //                 const SizedBox(height: 18),
// //                 Center(
// //                   child: RichText(
// //                     text: TextSpan(
// //                       children: [
// //                         TextSpan(
// //                           text: 'ر.س',
// //                           style: TextStyle(
// //                               fontSize: 16,
// //                               color: kTextSecondary,
// //                               fontWeight: FontWeight.w500),
// //                         ),
// //                         const TextSpan(text: '  '),
// //                         TextSpan(
// //                           text: (dailyCash + dailyNetwork).toStringAsFixed(0),
// //                           style: const TextStyle(
// //                               fontSize: 32,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 18),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                         child: _buildBalanceItem(
// //                             label: _t('شبكة', 'Network'),
// //                             amount: dailyNetwork)),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                         child: _buildBalanceItem(
// //                             label: _t('نقدي', 'Cash'), amount: dailyCash)),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 // صف أزرار مصروف وإيداع
// //                 Row(
// //                   children: [
// //                     _pillButton(
// //                       label: _t('مصروف', 'Expense'),
// //                       icon: Icons.remove_circle,
// //                       color: kRed,
// //                       filled: true,
// //                       expanded: true,
// //                       onPressed: _showExpenseDialog,
// //                     ),
// //                     _pillButton(
// //                       label: _t('إيداع', 'Deposit'),
// //                       icon: Icons.add_circle,
// //                       color: kGreen,
// //                       filled: true,
// //                       expanded: true,
// //                       onPressed: _showDepositDialog,
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 10),
// //                 // زر توريد نهاية اليوم (كامل العرض)
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: _pillButton(
// //                     label: _t('توريد نهاية اليوم للخزنة (كامل الرصيد)',
// //                         'End-of-Day Transfer to Safe (Full Balance)'),
// //                     icon: Icons.payments,
// //                     color: kGold,
// //                     filled: true,
// //                     expanded: false,
// //                     onPressed: _showEndOfDayTransfer,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           // قسم العهدة
// //           _darkCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   _t('عهدة الصندوق اليومي', 'Daily Box Float'),
// //                   style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   _t(
// //                     'سلم عهدة ابتدائية من الخزنة لمن يقف على الصندوق. وعند نهاية الوردية اجرد الدرج فعلياً وسجل الفرق.',
// //                     'An initial float is given from the safe to the cashier. At the end of shift, count the actual drawer and record the difference.',
// //                   ),
// //                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 // عرض العهدة الحالية (قيم نقدي وشبكة)
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: kFieldFill,
// //                     borderRadius: BorderRadius.circular(12),
// //                     border: Border.all(color: kCardBorder),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                     children: [
// //                       Column(
// //                         children: [
// //                           Text(_t('نقدي', 'Cash'),
// //                               style: const TextStyle(
// //                                   color: kTextSecondary, fontSize: 12)),
// //                           Text('ر.س ${dailyFloatCash.toStringAsFixed(0)}',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold)),
// //                         ],
// //                       ),
// //                       Container(width: 1, height: 30, color: kCardBorder),
// //                       Column(
// //                         children: [
// //                           Text(_t('شبكة', 'Network'),
// //                               style: const TextStyle(
// //                                   color: kTextSecondary, fontSize: 12)),
// //                           Text('ر.س ${dailyFloatNetwork.toStringAsFixed(0)}',
// //                               style: const TextStyle(
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.bold)),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 // زرين فتح عهدة جديدة وتحويل جزئي
// //                 Row(
// //                   children: [
// //                     _pillButton(
// //                       label: _t('فتح عهدة جديدة', 'Open New Float'),
// //                       icon: Icons.add,
// //                       color: kGold,
// //                       filled: true,
// //                       expanded: true,
// //                       onPressed: _showOpenFloatDialog,
// //                     ),
// //                     _pillButton(
// //                       label: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer'),
// //                       icon: Icons.swap_horiz,
// //                       color: kGold,
// //                       filled: false,
// //                       expanded: true,
// //                       onPressed: _showPartialTransferToSafeDialog,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           // قائمة الحركات (اختياري، يمكن إضافتها أسفل كل شيء)
// //           if (dailyTransactions.isNotEmpty) ...[
// //             const SizedBox(height: 16),
// //             _darkCard(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     _t('آخر الحركات', 'Recent Transactions'),
// //                     style: const TextStyle(
// //                         fontWeight: FontWeight.bold, color: Colors.white),
// //                   ),
// //                   const SizedBox(height: 6),
// //                   ...dailyTransactions.take(10).map((t) {
// //                     final type = t['type'] ?? '';
// //                     final method = t['method'] ?? '';
// //                     final amount = (t['amount'] ?? 0).toDouble();
// //                     final category = t['category'] ?? '';
// //                     final note = t['note'] ?? '';
// //                     final isAdd = (type == 'float_open' || type == 'deposit');
// //                     final color = isAdd ? kGreen : kRed;
// //                     final icon = isAdd ? Icons.add_circle : Icons.remove_circle;
// //                     final typeLabel = {
// //                           'float_open': _t('فتح عهدة', 'Open Float'),
// //                           'deposit': _t('إيداع', 'Deposit'),
// //                           'expense': _t('مصروف', 'Expense'),
// //                           'transfer_to_safe':
// //                               _t('تحويل للخزنة', 'Transfer to Safe'),
// //                           'end_of_day_transfer':
// //                               _t('توريد نهاية اليوم', 'End of Day'),
// //                         }[type] ??
// //                         type;

// //                     return ListTile(
// //                       contentPadding: EdgeInsets.zero,
// //                       dense: true,
// //                       leading: Icon(icon, color: color),
// //                       title: Text(
// //                         '$typeLabel - ${method == 'cash' ? 'نقدي' : 'شبكة'}',
// //                         style: const TextStyle(
// //                             fontSize: 13.5, color: Colors.white),
// //                       ),
// //                       subtitle: Text(
// //                         category.isNotEmpty ? '$category | $note' : note,
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                         style: const TextStyle(
// //                             color: kTextSecondary, fontSize: 11.5),
// //                       ),
// //                       trailing: Text(
// //                         '${isAdd ? '+' : '-'}ر.س ${amount.toStringAsFixed(0)}',
// //                         style: TextStyle(
// //                           color: color,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     );
// //                   }),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // بناء واجهة الخزنة (تم تعديلها لعرض الإجمالي الكلي)
// //   // =========================================================================
// //   Widget _buildSafeBoxTab() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(14),
// //       child: Column(
// //         children: [
// //           // البطاقة الأولى: تعرض الإجمالي الكلي (بدلاً من رصيد الخزنة)
// //           _darkCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   _t('الإجمالي', 'Total'),
// //                   style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white),
// //                 ),
// //                 const SizedBox(height: 18),
// //                 Center(
// //                   child: RichText(
// //                     text: TextSpan(
// //                       children: [
// //                         TextSpan(
// //                           text: 'ر.س',
// //                           style: TextStyle(
// //                               fontSize: 16,
// //                               color: kTextSecondary,
// //                               fontWeight: FontWeight.w500),
// //                         ),
// //                         const TextSpan(text: '  '),
// //                         TextSpan(
// //                           text: totalBalance.toStringAsFixed(0),
// //                           style: const TextStyle(
// //                               fontSize: 32,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 18),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                         child: _buildBalanceItem(
// //                             label: _t('نقدي', 'Cash'), amount: cashTotal)),
// //                     const SizedBox(width: 10),
// //                     Expanded(
// //                         child: _buildBalanceItem(
// //                             label: _t('شبكة', 'Network'),
// //                             amount: networkTotal)),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: [
// //                     _pillButton(
// //                       label: _t('سحب', 'Withdraw'),
// //                       icon: Icons.arrow_upward,
// //                       color: kRed,
// //                       filled: false,
// //                       onPressed: _showWithdrawCashDialog,
// //                     ),
// //                     _pillButton(
// //                       label: _t('إيداع ', 'Manual Deposit'),
// //                       icon: Icons.arrow_downward,
// //                       color: kGreen,
// //                       filled: true,
// //                       onPressed: _showDepositCashDialog,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 16),
// //           // البطاقة الثانية: الذهب المحفوظ بالخزنة (كما هي)
// //           _darkCard(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
// //                   style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white),
// //                 ),
// //                 const SizedBox(height: 14),
// //                 Container(
// //                   width: double.infinity,
// //                   padding: const EdgeInsets.all(14),
// //                   decoration: BoxDecoration(
// //                     color: kFieldFill,
// //                     borderRadius: BorderRadius.circular(14),
// //                     border: Border.all(color: kCardBorder),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         _t('الإجمالي محوّلًا لعيار 24',
// //                             'Total converted to 24K'),
// //                         style: const TextStyle(
// //                             color: kTextSecondary, fontSize: 12.5),
// //                       ),
// //                       const SizedBox(height: 6),
// //                       Text(
// //                         '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
// //                         style: const TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                             color: kGold),
// //                       ),
// //                       const SizedBox(height: 6),
// //                       Text(
// //                         '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
// //                         '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
// //                         '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
// //                         style: const TextStyle(
// //                             color: kTextSecondary, fontSize: 12),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 14),
// //                 if (goldTransactions.isNotEmpty)
// //                   Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         _t('آخر العمليات', 'Recent Transactions'),
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.bold, color: Colors.white),
// //                       ),
// //                       const SizedBox(height: 6),
// //                       ...goldTransactions.take(5).map((t) {
// //                         final isDeposit = t['type'] == 'deposit';
// //                         final weight = (t['weight'] ?? 0.0).toDouble();
// //                         final carat = (t['carat'] ?? 24).toDouble();
// //                         final type = t['goldType'] == 'raw'
// //                             ? _t('خام', 'Raw')
// //                             : _t('مشغول', 'Worked');
// //                         final date = (t['date'] as Timestamp?)?.toDate();
// //                         final dateStr = date != null
// //                             ? '${date.day}/${date.month}/${date.year}'
// //                             : '';
// //                         return ListTile(
// //                           contentPadding: EdgeInsets.zero,
// //                           dense: true,
// //                           leading: Icon(
// //                             isDeposit ? Icons.add_circle : Icons.remove_circle,
// //                             color: isDeposit ? kGreen : kRed,
// //                           ),
// //                           title: Text(
// //                             '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
// //                             style: const TextStyle(
// //                                 fontSize: 13.5, color: Colors.white),
// //                           ),
// //                           subtitle: Text(dateStr,
// //                               style: const TextStyle(
// //                                   color: kTextSecondary, fontSize: 11.5)),
// //                           trailing: Text(
// //                             '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
// //                             style: TextStyle(
// //                               color: isDeposit ? kGreen : kRed,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         );
// //                       }),
// //                     ],
// //                   )
// //                 else
// //                   Center(
// //                     child: Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 8),
// //                       child: Text(
// //                         _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
// //                         style: const TextStyle(color: kTextSecondary),
// //                       ),
// //                     ),
// //                   ),
// //                 const SizedBox(height: 14),
// //                 Row(
// //                   children: [
// //                     _pillButton(
// //                       label: _t('سحب', 'Withdraw'),
// //                       icon: Icons.arrow_downward,
// //                       color: kRed,
// //                       filled: false,
// //                       onPressed: _showGoldWithdrawDialog,
// //                     ),
// //                     _pillButton(
// //                       label: _t('إيداع', 'Deposit'),
// //                       icon: Icons.arrow_upward,
// //                       color: kGreen,
// //                       filled: true,
// //                       onPressed: _showGoldDepositDialog,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // بناء واجهة صندوق الكسر (كما هي)
// //   // =========================================================================
// //   Widget _buildScrapBoxTab() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(14),
// //       child: _darkCard(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               _t('صندوق الكسر', 'Scrap Box'),
// //               style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white),
// //             ),
// //             const SizedBox(height: 18),
// //             Center(
// //               child: RichText(
// //                 text: TextSpan(
// //                   children: [
// //                     TextSpan(
// //                         text: 'ر.س  ',
// //                         style: TextStyle(fontSize: 16, color: kTextSecondary)),
// //                     TextSpan(
// //                       text: (scrapCash + scrapNetwork).toStringAsFixed(0),
// //                       style: const TextStyle(
// //                           fontSize: 30,
// //                           fontWeight: FontWeight.bold,
// //                           color: Colors.white),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 18),
// //             Row(
// //               children: [
// //                 Expanded(
// //                     child: _buildBalanceItem(
// //                         label: _t('شبكة', 'Network'), amount: scrapNetwork)),
// //                 const SizedBox(width: 10),
// //                 Expanded(
// //                     child: _buildBalanceItem(
// //                         label: _t('نقدي', 'Cash'), amount: scrapCash)),
// //               ],
// //             ),
// //             const SizedBox(height: 18),
// //             Center(
// //               child: Text(
// //                 _t('(قيد التطوير)', '(Under development)'),
// //                 style: const TextStyle(color: kTextSecondary),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // =========================================================================
// //   // الواجهة الرئيسية (تم إزالة البطاقة العلوية)
// //   // =========================================================================
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: kBackground,
// //       appBar: AppBar(
// //         title: Text(_t('الصندوق', 'Cash Box')),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         centerTitle: true,
// //         elevation: 0,
// //         bottom: PreferredSize(
// //           preferredSize: const Size.fromHeight(48),
// //           child: Padding(
// //             padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.black.withOpacity(0.15),
// //                 borderRadius: BorderRadius.circular(30),
// //               ),
// //               child: TabBar(
// //                 controller: _tabController,
// //                 indicator: BoxDecoration(
// //                   color: Colors.black.withOpacity(0.28),
// //                   borderRadius: BorderRadius.circular(30),
// //                 ),
// //                 indicatorSize: TabBarIndicatorSize.tab,
// //                 labelColor: Colors.white,
// //                 unselectedLabelColor: Colors.black54,
// //                 labelStyle:
// //                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
// //                 dividerColor: Colors.transparent,
// //                 tabs: [
// //                   Tab(text: _t('صندوق الكسر', 'Scrap Box')),
// //                   Tab(text: _t('صندوق اليومي', 'Daily Box')),
// //                   Tab(text: _t('الخزنة', 'Safe Box')),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: loading
// //           ? Center(child: CircularProgressIndicator(color: kGold))
// //           : TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 _buildScrapBoxTab(),
// //                 _buildDailyBoxTab(),
// //                 _buildSafeBoxTab(),
// //               ],
// //             ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';

// class CashBoxPage extends StatefulWidget {
//   const CashBoxPage({super.key});

//   @override
//   State<CashBoxPage> createState() => _CashBoxPageState();
// }

// class _CashBoxPageState extends State<CashBoxPage>
//     with SingleTickerProviderStateMixin {
//   // ===== ألوان التصميم =====
//   static const Color kGold = Color(0xFFD4AF37);
//   static const Color kBackground = Color(0xFF121212);
//   static const Color kCard = Color(0xFF1C1C1C);
//   static const Color kCardBorder = Color(0xFF2A2A2A);
//   static const Color kFieldFill = Color(0xFF161616);
//   static const Color kGreen = Color(0xFF4CAF50);
//   static const Color kRed = Color(0xFFE05353);
//   static const Color kTextSecondary = Color(0xFF9E9E9E);

//   // ===== متغيرات الأقسام =====
//   double totalBalance = 0.0;
//   double cashTotal = 0.0;
//   double networkTotal = 0.0;

//   // ===== الخزنة (نقدي) =====
//   double safeCash = 0.0;
//   double safeNetwork = 0.0;

//   // ===== الخزنة (ذهب) =====
//   double goldTotal24K = 0.0;
//   double goldTotalActual = 0.0;
//   double goldScrapWeight = 0.0;
//   double goldWorkedWeight = 0.0;
//   List<Map<String, dynamic>> goldTransactions = [];

//   // ===== صندوق اليومي =====
//   double dailyCash = 0.0;
//   double dailyNetwork = 0.0;
//   List<Map<String, dynamic>> dailyTransactions = [];
//   double dailyFloatCash = 0.0;
//   double dailyFloatNetwork = 0.0;

//   // ===== صندوق الكسر =====
//   double scrapCash = 0.0;
//   double scrapNetwork = 0.0;
//   List<Map<String, dynamic>> scrapTransactions = [];

//   bool loading = true;
//   String _lang = 'ar';
//   late TabController _tabController;

//   // قوائم التصنيفات
//   final List<String> expenseCategories = [
//     'سحب شخصي / سحب شريك',
//     'أخرى',
//   ];
//   final List<String> depositCategories = [
//     'إيرادات أخرى',
//     'رأس مال / مساهمة شريك',
//   ];

//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadLanguage();
//     _loadAllData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   // ===== تحميل جميع البيانات =====
//   Future<void> _loadAllData() async {
//     setState(() => loading = true);
//     try {
//       final cashBalance = await FS.getCashBoxBalance();
//       safeCash = cashBalance['cash']!;
//       safeNetwork = cashBalance['network']!;

//       final goldSummary = await FS.getSafeGoldSummary();
//       goldTotal24K = goldSummary['total24K'] ?? 0.0;
//       goldTotalActual = goldSummary['totalActual'] ?? 0.0;
//       goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
//       goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
//       goldTransactions =
//           List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

//       await _loadDailyBoxData();

//       final scrapData = await _getScrapBoxData();
//       scrapCash = scrapData['cash'];
//       scrapNetwork = scrapData['network'];
//       scrapTransactions = scrapData['transactions'];

//       totalBalance = (safeCash + safeNetwork) +
//           (dailyCash + dailyNetwork) +
//           (scrapCash + scrapNetwork);
//       cashTotal = safeCash + dailyCash + scrapCash;
//       networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

//       setState(() => loading = false);
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
//       );
//     }
//   }

//   Future<void> _loadDailyBoxData() async {
//     try {
//       final balance = await FS.getDailyBoxBalance();
//       dailyCash = balance['cash']!;
//       dailyNetwork = balance['network']!;

//       final history = await FS.getDailyBoxHistory();
//       dailyTransactions = history;

//       double floatCash = 0.0;
//       double floatNetwork = 0.0;
//       for (var t in history) {
//         if (t['type'] == 'float_open') {
//           if (t['method'] == 'cash')
//             floatCash += (t['amount'] ?? 0).toDouble();
//           else if (t['method'] == 'network')
//             floatNetwork += (t['amount'] ?? 0).toDouble();
//         }
//       }
//       dailyFloatCash = floatCash;
//       dailyFloatNetwork = floatNetwork;
//     } catch (e) {
//       print('⚠️ خطأ في تحميل الصندوق اليومي: $e');
//     }
//   }

//   Future<Map<String, dynamic>> _getScrapBoxData() async {
//     double cash = 0.0, network = 0.0;
//     List<Map<String, dynamic>> transactions = [];

//     final scrapSnap = await FS.scrapCol().get();
//     for (var doc in scrapSnap.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final type = data['type'] ?? '';
//       final c = (data['cash'] ?? 0.0).toDouble();
//       final n = (data['network'] ?? 0.0).toDouble();

//       if (type == 'add') {
//         cash -= c;
//         network -= n;
//         transactions.add({
//           'type': 'شراء كسر',
//           'cash': -c,
//           'network': -n,
//           'date': data['date'],
//           'data': data
//         });
//       } else if (type == 'sale') {
//         cash += c;
//         network += n;
//         transactions.add({
//           'type': 'بيع كسر',
//           'cash': c,
//           'network': n,
//           'date': data['date'],
//           'data': data
//         });
//       } else if (type == 'payment') {
//         cash -= c;
//         network -= n;
//         transactions.add({
//           'type': 'سند صرف',
//           'cash': -c,
//           'network': -n,
//           'date': data['date'],
//           'data': data
//         });
//       }
//     }
//     return {'cash': cash, 'network': network, 'transactions': transactions};
//   }

//   // =========================================================================
//   // عناصر تصميم مشتركة
//   // =========================================================================

//   Widget _segmentedToggle({
//     required List<MapEntry<String, String>> options,
//     required String value,
//     required ValueChanged<String> onChanged,
//   }) {
//     return Row(
//       children: options.map((opt) {
//         final selected = opt.key == value;
//         return Expanded(
//           child: GestureDetector(
//             onTap: () => onChanged(opt.key),
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(
//                     color: selected ? kGold : kCardBorder, width: 1.2),
//               ),
//               child: Text(
//                 opt.value,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: selected ? kGold : Colors.white70,
//                   fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _darkField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? prefixText,
//     bool enabled = true,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       enabled: enabled,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: kTextSecondary),
//         prefixText: prefixText,
//         prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
//         filled: true,
//         fillColor: kFieldFill,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kCardBorder),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kCardBorder),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kGold, width: 1.4),
//         ),
//       ),
//     );
//   }

//   Widget _pillButton({
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//     bool filled = true,
//     IconData? icon,
//     bool expanded = true,
//   }) {
//     Widget btn = filled
//         ? ElevatedButton.icon(
//             onPressed: onPressed,
//             icon: icon != null
//                 ? Icon(icon, size: 18, color: Colors.black)
//                 : const SizedBox.shrink(),
//             label: Text(label,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.black)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: color,
//               minimumSize: const Size(0, 46),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//               elevation: 0,
//             ),
//           )
//         : OutlinedButton.icon(
//             onPressed: onPressed,
//             icon: icon != null
//                 ? Icon(icon, size: 18, color: color)
//                 : const SizedBox.shrink(),
//             label: Text(label,
//                 style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: color.withOpacity(0.6)),
//               backgroundColor: color.withOpacity(0.08),
//               minimumSize: const Size(0, 46),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//             ),
//           );

//     return expanded
//         ? Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: btn,
//             ),
//           )
//         : btn;
//   }

//   Widget _darkCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: kCard,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: kCardBorder),
//       ),
//       child: child,
//     );
//   }

//   Widget _darkDialogShell({
//     required String title,
//     required Widget content,
//     required List<Widget> actions,
//   }) {
//     return AlertDialog(
//       backgroundColor: kCard,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: const BorderSide(color: kCardBorder),
//       ),
//       title: Text(title,
//           style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold)),
//       content: content,
//       actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       actions: actions,
//     );
//   }

//   Widget _buildBalanceItem({
//     required String label,
//     required double amount,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: kFieldFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: kCardBorder),
//       ),
//       child: Column(
//         children: [
//           Text(label,
//               style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
//           const SizedBox(height: 6),
//           Text(
//             'ر.س${amount.toStringAsFixed(0)}',
//             style: const TextStyle(
//                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال الخزنة النقدية
//   // =========================================================================
//   void _showDepositCashDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.addToCashBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                   );
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('إيداع', 'Deposit'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showWithdrawCashDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kRed,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 final balance = await FS.getCashBoxBalance();
//                 double available =
//                     method == 'cash' ? balance['cash']! : balance['network']!;
//                 if (amount > available) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             _t('الرصيد غير كافٍ', 'Insufficient balance'))),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromCashBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                   );
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             _t('تم السحب بنجاح', 'Withdrawal successful'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('سحب', 'Withdraw'),
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال الخزنة (ذهب)
//   // =========================================================================
//   void _showGoldDepositDialog() {
//     _showGoldDialog(mode: 'deposit');
//   }

//   void _showGoldWithdrawDialog() {
//     _showGoldDialog(mode: 'withdraw');
//   }

//   void _showGoldDialog({required String mode}) {
//     String goldType = 'raw';
//     String carat = '21';
//     final weightController = TextEditingController();
//     final noteController = TextEditingController();

//     final caratList = ['14', '18', '21', '22', '24'];
//     final actionColor = mode == 'deposit' ? kGreen : kRed;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: mode == 'deposit'
//               ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
//               : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
//                     MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
//                   ],
//                   value: goldType,
//                   onChanged: (val) => setDialogState(() => goldType = val),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: carat,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: caratList.map((c) {
//                         return DropdownMenuItem(
//                             value: c, child: Text('$c ${_t('عيار', 'K')}'));
//                       }).toList(),
//                       onChanged: (val) => setDialogState(() => carat = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: weightController,
//                   keyboardType: TextInputType.number,
//                   label: _t('الوزن (جرام)', 'Weight (g)'),
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: actionColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final weight = double.tryParse(weightController.text) ?? 0.0;
//                 if (weight <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('الوزن يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 final caratDouble = double.tryParse(carat) ?? 21.0;

//                 try {
//                   if (mode == 'deposit') {
//                     await FS.depositSafeGold(
//                       goldType: goldType,
//                       carat: caratDouble,
//                       weight: weight,
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : null,
//                     );
//                   } else {
//                     final summary = await FS.getSafeGoldSummary();
//                     final transactions =
//                         summary['transactions'] as List<Map<String, dynamic>>;
//                     double available = 0.0;
//                     for (var t in transactions) {
//                       if (t['goldType'] == goldType &&
//                           (t['carat'] ?? 24).toDouble() == caratDouble) {
//                         if (t['type'] == 'deposit') {
//                           available += (t['weight'] ?? 0.0).toDouble();
//                         } else if (t['type'] == 'withdraw') {
//                           available -= (t['weight'] ?? 0.0).toDouble();
//                         }
//                       }
//                     }
//                     if (weight > available) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(_t(
//                                 'الرصيد غير كافٍ لهذا العيار والنوع',
//                                 'Insufficient balance for this carat and type'))),
//                       );
//                       return;
//                     }
//                     await FS.withdrawSafeGold(
//                       goldType: goldType,
//                       carat: caratDouble,
//                       weight: weight,
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : null,
//                     );
//                   }
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         mode == 'deposit'
//                             ? _t('تم إيداع الذهب بنجاح',
//                                 'Gold deposited successfully')
//                             : _t('تم سحب الذهب بنجاح',
//                                 'Gold withdrawn successfully'),
//                       ),
//                     ),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(
//                 mode == 'deposit'
//                     ? _t('إيداع', 'Deposit')
//                     : _t('سحب', 'Withdraw'),
//                 style: TextStyle(
//                     color: mode == 'deposit' ? Colors.black : Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال صندوق اليومي
//   // =========================================================================

//   void _showOpenFloatDialog() {
//     final cashController = TextEditingController();
//     final networkController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('فتح عهدة جديدة', 'Open New Float'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _t('تخصص العهدة من الخزنة وتضاف لصندوق اليومي.',
//                       'Float is taken from safe and added to daily box.'),
//                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: cashController,
//                   keyboardType: TextInputType.number,
//                   label: _t('نقدي (ر.س)', 'Cash (SAR)'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: networkController,
//                   keyboardType: TextInputType.number,
//                   label: _t('شبكة (ر.س)', 'Network (SAR)'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(_t('إجمالي العهدة', 'Total Float'),
//                         style: const TextStyle(color: Colors.white70)),
//                     ValueListenableBuilder(
//                       valueListenable: cashController,
//                       builder: (_, __, ___) {
//                         final cash = double.tryParse(cashController.text) ?? 0;
//                         final network =
//                             double.tryParse(networkController.text) ?? 0;
//                         return Text(
//                           'ر.س ${(cash + network).toStringAsFixed(2)}',
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: kGold),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGold,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final cash = double.tryParse(cashController.text) ?? 0.0;
//                 final network = double.tryParse(networkController.text) ?? 0.0;
//                 if (cash <= 0 && network <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('يجب إدخال مبلغ في أحد الحقلين')),
//                   );
//                   return;
//                 }

//                 try {
//                   final safeBal = await FS.getCashBoxBalance();
//                   if (cash > safeBal['cash']!) {
//                     throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
//                   }
//                   if (network > safeBal['network']!) {
//                     throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
//                   }

//                   if (cash > 0) {
//                     await FS.deductFromCashBox(
//                       amount: cash,
//                       method: 'cash',
//                       note: 'فتح عهدة صندوق يومي',
//                     );
//                   }
//                   if (network > 0) {
//                     await FS.deductFromCashBox(
//                       amount: network,
//                       method: 'network',
//                       note: 'فتح عهدة صندوق يومي',
//                     );
//                   }

//                   if (cash > 0) {
//                     await FS.addToDailyBox(
//                       amount: cash,
//                       method: 'cash',
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : 'فتح عهدة',
//                       type: 'float_open',
//                     );
//                   }
//                   if (network > 0) {
//                     await FS.addToDailyBox(
//                       amount: network,
//                       method: 'network',
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : 'فتح عهدة',
//                       type: 'float_open',
//                     );
//                   }

//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(_t('تم فتح العهدة بنجاح',
//                             'Float opened successfully'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('فتح العهدة', 'Open Float'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showExpenseDialog() {
//     String method = 'cash';
//     String selectedCategory = expenseCategories.first;
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تسجيل مصروف', 'Record Expense'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCategory,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: expenseCategories.map((cat) {
//                         return DropdownMenuItem(value: cat, child: Text(cat));
//                       }).toList(),
//                       onChanged: (val) =>
//                           setDialogState(() => selectedCategory = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kRed,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromDailyBox(
//                     amount: amount,
//                     method: method,
//                     category: selectedCategory,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                     type: 'expense',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم تسجيل المصروف', 'Expense recorded'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('حفظ', 'Save'),
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDepositDialog() {
//     String method = 'cash';
//     String selectedCategory = depositCategories.first;
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تسجيل إيداع', 'Record Deposit'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCategory,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: depositCategories.map((cat) {
//                         return DropdownMenuItem(value: cat, child: Text(cat));
//                       }).toList(),
//                       onChanged: (val) =>
//                           setDialogState(() => selectedCategory = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.addToDailyBox(
//                     amount: amount,
//                     method: method,
//                     category: selectedCategory,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                     type: 'deposit',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم تسجيل الإيداع', 'Deposit recorded'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('حفظ', 'Save'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPartialTransferToSafeDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer to Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGold,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromDailyBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : 'تحويل للخزنة',
//                     type: 'transfer_to_safe',
//                   );
//                   await FS.addToCashBox(
//                     amount: amount,
//                     method: method,
//                     note: 'تحويل من الصندوق اليومي',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(_t('تم التحويل', 'Transfer completed'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('تحويل', 'Transfer'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEndOfDayTransfer() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: const BorderSide(color: kCardBorder),
//         ),
//         title: Text(_t('توريد نهاية اليوم', 'End-of-Day Transfer'),
//             style: const TextStyle(color: Colors.white)),
//         content: Text(
//           _t('سيتم تحويل كامل رصيد الصندوق اليومي إلى الخزنة وإعادة تعيينه.',
//               'All daily box balance will be transferred to safe and reset.'),
//           style: const TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(_t('إلغاء', 'Cancel'),
//                 style: const TextStyle(color: kTextSecondary)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kRed,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24)),
//             ),
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(_t('تأكيد', 'Confirm'),
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//     if (confirm != true) return;

//     try {
//       final balance = await FS.getDailyBoxBalance();
//       double cash = balance['cash']!;
//       double network = balance['network']!;

//       if (cash > 0) {
//         await FS.addToCashBox(
//           amount: cash,
//           method: 'cash',
//           note: 'توريد نهاية اليوم (نقدي)',
//         );
//       }
//       if (network > 0) {
//         await FS.addToCashBox(
//           amount: network,
//           method: 'network',
//           note: 'توريد نهاية اليوم (شبكة)',
//         );
//       }

//       if (cash > 0) {
//         await FS.deductFromDailyBox(
//           amount: cash,
//           method: 'cash',
//           note: 'توريد نهاية اليوم',
//           type: 'end_of_day_transfer',
//         );
//       }
//       if (network > 0) {
//         await FS.deductFromDailyBox(
//           amount: network,
//           method: 'network',
//           note: 'توريد نهاية اليوم',
//           type: 'end_of_day_transfer',
//         );
//       }

//       await FS.resetDailyBox();

//       await _loadAllData();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(_t('تم توريد نهاية اليوم بنجاح',
//                 'End-of-day transfer completed'))),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ: $e')),
//       );
//     }
//   }

//   // =========================================================================
//   // بناء واجهة صندوق اليومي
//   // =========================================================================
//   Widget _buildDailyBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('رصيد صندوق اليومي', 'Daily Box Balance'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 18),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'ر.س',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           text: (dailyCash + dailyNetwork).toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('شبكة', 'Network'),
//                             amount: dailyNetwork)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('نقدي', 'Cash'), amount: dailyCash)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('مصروف', 'Expense'),
//                       icon: Icons.remove_circle,
//                       color: kRed,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showExpenseDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع', 'Deposit'),
//                       icon: Icons.add_circle,
//                       color: kGreen,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showDepositDialog,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   child: _pillButton(
//                     label: _t('توريد نهاية اليوم للخزنة (كامل الرصيد)',
//                         'End-of-Day Transfer to Safe (Full Balance)'),
//                     icon: Icons.payments,
//                     color: kGold,
//                     filled: true,
//                     expanded: false,
//                     onPressed: _showEndOfDayTransfer,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('عهدة الصندوق اليومي', 'Daily Box Float'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _t(
//                     'سلم عهدة ابتدائية من الخزنة لمن يقف على الصندوق. وعند نهاية الوردية اجرد الدرج فعلياً وسجل الفرق.',
//                     'An initial float is given from the safe to the cashier. At the end of shift, count the actual drawer and record the difference.',
//                   ),
//                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Column(
//                         children: [
//                           Text(_t('نقدي', 'Cash'),
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 12)),
//                           Text('ر.س ${dailyFloatCash.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       Container(width: 1, height: 30, color: kCardBorder),
//                       Column(
//                         children: [
//                           Text(_t('شبكة', 'Network'),
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 12)),
//                           Text('ر.س ${dailyFloatNetwork.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('فتح عهدة جديدة', 'Open New Float'),
//                       icon: Icons.add,
//                       color: kGold,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showOpenFloatDialog,
//                     ),
//                     _pillButton(
//                       label: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer'),
//                       icon: Icons.swap_horiz,
//                       color: kGold,
//                       filled: false,
//                       expanded: true,
//                       onPressed: _showPartialTransferToSafeDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (dailyTransactions.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             _darkCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _t('آخر الحركات', 'Recent Transactions'),
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 6),
//                   ...dailyTransactions.take(10).map((t) {
//                     final type = t['type'] ?? '';
//                     final method = t['method'] ?? '';
//                     final amount = (t['amount'] ?? 0).toDouble();
//                     final category = t['category'] ?? '';
//                     final note = t['note'] ?? '';
//                     final isAdd = (type == 'float_open' || type == 'deposit');
//                     final color = isAdd ? kGreen : kRed;
//                     final icon = isAdd ? Icons.add_circle : Icons.remove_circle;
//                     final typeLabel = {
//                           'float_open': _t('فتح عهدة', 'Open Float'),
//                           'deposit': _t('إيداع', 'Deposit'),
//                           'expense': _t('مصروف', 'Expense'),
//                           'transfer_to_safe':
//                               _t('تحويل للخزنة', 'Transfer to Safe'),
//                           'end_of_day_transfer':
//                               _t('توريد نهاية اليوم', 'End of Day'),
//                         }[type] ??
//                         type;

//                     return ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       dense: true,
//                       leading: Icon(icon, color: color),
//                       title: Text(
//                         '$typeLabel - ${method == 'cash' ? 'نقدي' : 'شبكة'}',
//                         style: const TextStyle(
//                             fontSize: 13.5, color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         category.isNotEmpty ? '$category | $note' : note,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 11.5),
//                       ),
//                       trailing: Text(
//                         '${isAdd ? '+' : '-'}ر.س ${amount.toStringAsFixed(0)}',
//                         style: TextStyle(
//                           color: color,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // بناء واجهة الخزنة (تعرض رصيد الخزنة فقط)
//   // =========================================================================
//   Widget _buildSafeBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           // البطاقة الأولى: تعرض إجمالي رصيد الخزنة (نقدي + شبكة)
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('الإجمالي', 'Total'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 18),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'ر.س',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           // نعرض رصيد الخزنة وليس المجموع الكلي
//                           text: (safeCash + safeNetwork).toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('نقدي', 'Cash'), amount: safeCash)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('شبكة', 'Network'), amount: safeNetwork)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('سحب', 'Withdraw'),
//                       icon: Icons.arrow_upward,
//                       color: kRed,
//                       filled: false,
//                       onPressed: _showWithdrawCashDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع ', 'Manual Deposit'),
//                       icon: Icons.arrow_downward,
//                       color: kGreen,
//                       filled: true,
//                       onPressed: _showDepositCashDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // البطاقة الثانية: الذهب المحفوظ بالخزنة
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 14),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _t('الإجمالي محوّلًا لعيار 24',
//                             'Total converted to 24K'),
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 12.5),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
//                         style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: kGold),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
//                         '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
//                         '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 if (goldTransactions.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _t('آخر العمليات', 'Recent Transactions'),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       const SizedBox(height: 6),
//                       ...goldTransactions.take(5).map((t) {
//                         final isDeposit = t['type'] == 'deposit';
//                         final weight = (t['weight'] ?? 0.0).toDouble();
//                         final carat = (t['carat'] ?? 24).toDouble();
//                         final type = t['goldType'] == 'raw'
//                             ? _t('خام', 'Raw')
//                             : _t('مشغول', 'Worked');
//                         final date = (t['date'] as Timestamp?)?.toDate();
//                         final dateStr = date != null
//                             ? '${date.day}/${date.month}/${date.year}'
//                             : '';
//                         return ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           dense: true,
//                           leading: Icon(
//                             isDeposit ? Icons.add_circle : Icons.remove_circle,
//                             color: isDeposit ? kGreen : kRed,
//                           ),
//                           title: Text(
//                             '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
//                             style: const TextStyle(
//                                 fontSize: 13.5, color: Colors.white),
//                           ),
//                           subtitle: Text(dateStr,
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 11.5)),
//                           trailing: Text(
//                             '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
//                             style: TextStyle(
//                               color: isDeposit ? kGreen : kRed,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   )
//                 else
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
//                         style: const TextStyle(color: kTextSecondary),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('سحب', 'Withdraw'),
//                       icon: Icons.arrow_downward,
//                       color: kRed,
//                       filled: false,
//                       onPressed: _showGoldWithdrawDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع', 'Deposit'),
//                       icon: Icons.arrow_upward,
//                       color: kGreen,
//                       filled: true,
//                       onPressed: _showGoldDepositDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // بناء واجهة صندوق الكسر
//   // =========================================================================
//   Widget _buildScrapBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: _darkCard(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _t('صندوق الكسر', 'Scrap Box'),
//               style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white),
//             ),
//             const SizedBox(height: 18),
//             Center(
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                         text: 'ر.س  ',
//                         style: TextStyle(fontSize: 16, color: kTextSecondary)),
//                     TextSpan(
//                       text: (scrapCash + scrapNetwork).toStringAsFixed(0),
//                       style: const TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 18),
//             Row(
//               children: [
//                 Expanded(
//                     child: _buildBalanceItem(
//                         label: _t('شبكة', 'Network'), amount: scrapNetwork)),
//                 const SizedBox(width: 10),
//                 Expanded(
//                     child: _buildBalanceItem(
//                         label: _t('نقدي', 'Cash'), amount: scrapCash)),
//               ],
//             ),
//             const SizedBox(height: 18),
//             Center(
//               child: Text(
//                 _t('(قيد التطوير)', '(Under development)'),
//                 style: const TextStyle(color: kTextSecondary),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================================
//   // الواجهة الرئيسية (بدون البطاقة العلوية)
//   // =========================================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         title: Text(_t('الصندوق', 'Cash Box')),
//         backgroundColor: const Color(0xFFD4AF37),
//         centerTitle: true,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 indicator: BoxDecoration(
//                   color: Colors.black.withOpacity(0.28),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.black54,
//                 labelStyle:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//                 dividerColor: Colors.transparent,
//                 tabs: [
//                   Tab(text: _t('صندوق الكسر', 'Scrap Box')),
//                   Tab(text: _t('صندوق اليومي', 'Daily Box')),
//                   Tab(text: _t('الخزنة', 'Safe Box')),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator(color: kGold))
//           : TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildScrapBoxTab(),
//                 _buildDailyBoxTab(),
//                 _buildSafeBoxTab(),
//               ],
//             ),
//     );
//   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';

// class CashBoxPage extends StatefulWidget {
//   const CashBoxPage({super.key});

//   @override
//   State<CashBoxPage> createState() => _CashBoxPageState();
// }

// class _CashBoxPageState extends State<CashBoxPage>
//     with SingleTickerProviderStateMixin {
//   // ===== ألوان التصميم =====
//   static const Color kGold = Color(0xFFD4AF37);
//   static const Color kBackground = Color(0xFF121212);
//   static const Color kCard = Color(0xFF1C1C1C);
//   static const Color kCardBorder = Color(0xFF2A2A2A);
//   static const Color kFieldFill = Color(0xFF161616);
//   static const Color kGreen = Color(0xFF4CAF50);
//   static const Color kRed = Color(0xFFE05353);
//   static const Color kTextSecondary = Color(0xFF9E9E9E);

//   // ===== متغيرات الأقسام =====
//   double totalBalance = 0.0;
//   double cashTotal = 0.0;
//   double networkTotal = 0.0;

//   // ===== الخزنة (نقدي) =====
//   double safeCash = 0.0;
//   double safeNetwork = 0.0;

//   // ===== الخزنة (ذهب) =====
//   double goldTotal24K = 0.0;
//   double goldTotalActual = 0.0;
//   double goldScrapWeight = 0.0;
//   double goldWorkedWeight = 0.0;
//   List<Map<String, dynamic>> goldTransactions = [];

//   // ===== صندوق اليومي =====
//   double dailyCash = 0.0;
//   double dailyNetwork = 0.0;
//   List<Map<String, dynamic>> dailyTransactions = [];
//   double dailyFloatCash = 0.0;
//   double dailyFloatNetwork = 0.0;

//   // ===== صندوق الكسر (ليوم واحد فقط) =====
//   double scrapCash = 0.0;
//   double scrapNetwork = 0.0;
//   List<Map<String, dynamic>> scrapTransactions = [];
//   double scrapGold24K = 0.0; // الوزن الإجمالي لعيار 24 لليوم

//   bool loading = true;
//   String _lang = 'ar';
//   late TabController _tabController;

//   // قوائم التصنيفات
//   final List<String> expenseCategories = [
//     'سحب شخصي / سحب شريك',
//     'أخرى',
//   ];
//   final List<String> depositCategories = [
//     'إيرادات أخرى',
//     'رأس مال / مساهمة شريك',
//   ];

//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadLanguage();
//     _loadAllData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   // ===== تحميل جميع البيانات =====
//   Future<void> _loadAllData() async {
//     setState(() => loading = true);
//     try {
//       final cashBalance = await FS.getCashBoxBalance();
//       safeCash = cashBalance['cash']!;
//       safeNetwork = cashBalance['network']!;

//       final goldSummary = await FS.getSafeGoldSummary();
//       goldTotal24K = goldSummary['total24K'] ?? 0.0;
//       goldTotalActual = goldSummary['totalActual'] ?? 0.0;
//       goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
//       goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
//       goldTransactions =
//           List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

//       await _loadDailyBoxData();

//       // تحميل بيانات صندوق الكسر لليوم الحالي فقط
//       final scrapData = await _getScrapBoxDataToday();
//       scrapCash = scrapData['cash'];
//       scrapNetwork = scrapData['network'];
//       scrapTransactions = scrapData['transactions'];
//       scrapGold24K = scrapData['gold24K'] ?? 0.0;

//       // المجاميع الكلية (للاستخدام في تبويب الخزنة) - تبقى كما هي (كل الصناديق)
//       totalBalance = (safeCash + safeNetwork) +
//           (dailyCash + dailyNetwork) +
//           (scrapCash + scrapNetwork);
//       cashTotal = safeCash + dailyCash + scrapCash;
//       networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

//       setState(() => loading = false);
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
//       );
//     }
//   }

//   Future<void> _loadDailyBoxData() async {
//     try {
//       final balance = await FS.getDailyBoxBalance();
//       dailyCash = balance['cash']!;
//       dailyNetwork = balance['network']!;

//       final history = await FS.getDailyBoxHistory();
//       dailyTransactions = history;

//       double floatCash = 0.0;
//       double floatNetwork = 0.0;
//       for (var t in history) {
//         if (t['type'] == 'float_open') {
//           if (t['method'] == 'cash')
//             floatCash += (t['amount'] ?? 0).toDouble();
//           else if (t['method'] == 'network')
//             floatNetwork += (t['amount'] ?? 0).toDouble();
//         }
//       }
//       dailyFloatCash = floatCash;
//       dailyFloatNetwork = floatNetwork;
//     } catch (e) {
//       print('⚠️ خطأ في تحميل الصندوق اليومي: $e');
//     }
//   }

//   // جلب معاملات صندوق الكسر لليوم الحالي فقط
//   Future<Map<String, dynamic>> _getScrapBoxDataToday() async {
//     double cash = 0.0, network = 0.0;
//     List<Map<String, dynamic>> transactions = [];
//     double gold24K = 0.0;

//     // الحصول على بداية ونهاية اليوم الحالي
//     final now = DateTime.now();
//     final startOfDay = DateTime(now.year, now.month, now.day);
//     final endOfDay = startOfDay.add(const Duration(days: 1));

//     // جلب جميع وثائق الكسر ثم تصفية حسب التاريخ
//     final scrapSnap = await FS.scrapCol().get();
//     for (var doc in scrapSnap.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final dateField = data['date'];
//       DateTime? docDate;
//       if (dateField is Timestamp) {
//         docDate = dateField.toDate();
//       } else if (dateField is DateTime) {
//         docDate = dateField;
//       } else {
//         continue; // تخطي إذا لم يكن التاريخ صحيحاً
//       }
//       // تصفية لليوم الحالي فقط
//       if (docDate.isBefore(startOfDay) || docDate.isAfter(endOfDay)) continue;

//       final type = data['type'] ?? '';
//       final c = (data['cash'] ?? 0.0).toDouble();
//       final n = (data['network'] ?? 0.0).toDouble();

//       // حساب الرصيد النقدي والشبكة حسب النوع
//       if (type == 'add') {
//         cash -= c;
//         network -= n;
//         transactions.add({
//           'type': 'شراء كسر',
//           'cash': -c,
//           'network': -n,
//           'date': data['date'],
//           'data': data
//         });
//         // وزن لعيار 24 (شراء يزيد المخزون)
//         final carat =
//             double.tryParse(data['carat']?.toString() ?? '18') ?? 18.0;
//         final weight = (data['weight'] ?? 0.0).toDouble();
//         gold24K += weight * (carat / 24);
//       } else if (type == 'sale') {
//         cash += c;
//         network += n;
//         transactions.add({
//           'type': 'بيع كسر',
//           'cash': c,
//           'network': n,
//           'date': data['date'],
//           'data': data
//         });
//         final carat =
//             double.tryParse(data['carat']?.toString() ?? '18') ?? 18.0;
//         final weight = (data['weight'] ?? 0.0).toDouble();
//         gold24K -= weight * (carat / 24);
//       } else if (type == 'payment') {
//         cash -= c;
//         network -= n;
//         transactions.add({
//           'type': 'سند صرف',
//           'cash': -c,
//           'network': -n,
//           'date': data['date'],
//           'data': data
//         });
//         // سند الصرف قد يكون متعدد العيارات
//         final carats = data['carats'] as List?;
//         if (carats != null && carats.isNotEmpty) {
//           for (var item in carats) {
//             final carat =
//                 double.tryParse(item['carat']?.toString() ?? '18') ?? 18.0;
//             final weight = (item['weight'] ?? 0.0).toDouble();
//             gold24K -= weight * (carat / 24);
//           }
//         } else {
//           final carat =
//               double.tryParse(data['carat']?.toString() ?? '18') ?? 18.0;
//           final weight = (data['weight'] ?? 0.0).toDouble();
//           gold24K -= weight * (carat / 24);
//         }
//       } else if (type == 'fund') {
//         // تمويل العهدة (إضافة)
//         cash += c;
//         network += n;
//         transactions.add({
//           'type': 'تمويل',
//           'cash': c,
//           'network': n,
//           'date': data['date'],
//           'data': data
//         });
//       } else if (type == 'close') {
//         // إقفال العهدة (خصم)
//         cash -= c;
//         network -= n;
//         transactions.add({
//           'type': 'إقفال',
//           'cash': -c,
//           'network': -n,
//           'date': data['date'],
//           'data': data
//         });
//       }
//     }
//     return {
//       'cash': cash,
//       'network': network,
//       'transactions': transactions,
//       'gold24K': gold24K
//     };
//   }

//   // =========================================================================
//   // عناصر تصميم مشتركة
//   // =========================================================================

//   Widget _segmentedToggle({
//     required List<MapEntry<String, String>> options,
//     required String value,
//     required ValueChanged<String> onChanged,
//   }) {
//     return Row(
//       children: options.map((opt) {
//         final selected = opt.key == value;
//         return Expanded(
//           child: GestureDetector(
//             onTap: () => onChanged(opt.key),
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(30),
//                 border: Border.all(
//                     color: selected ? kGold : kCardBorder, width: 1.2),
//               ),
//               child: Text(
//                 opt.value,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: selected ? kGold : Colors.white70,
//                   fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _darkField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     String? prefixText,
//     bool enabled = true,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       enabled: enabled,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: kTextSecondary),
//         prefixText: prefixText,
//         prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
//         filled: true,
//         fillColor: kFieldFill,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kCardBorder),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kCardBorder),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kGold, width: 1.4),
//         ),
//       ),
//     );
//   }

//   Widget _pillButton({
//     required String label,
//     required VoidCallback onPressed,
//     required Color color,
//     bool filled = true,
//     IconData? icon,
//     bool expanded = true,
//   }) {
//     Widget btn = filled
//         ? ElevatedButton.icon(
//             onPressed: onPressed,
//             icon: icon != null
//                 ? Icon(icon, size: 18, color: Colors.black)
//                 : const SizedBox.shrink(),
//             label: Text(label,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.black)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: color,
//               minimumSize: const Size(0, 46),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//               elevation: 0,
//             ),
//           )
//         : OutlinedButton.icon(
//             onPressed: onPressed,
//             icon: icon != null
//                 ? Icon(icon, size: 18, color: color)
//                 : const SizedBox.shrink(),
//             label: Text(label,
//                 style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: color.withOpacity(0.6)),
//               backgroundColor: color.withOpacity(0.08),
//               minimumSize: const Size(0, 46),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//             ),
//           );

//     return expanded
//         ? Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: btn,
//             ),
//           )
//         : btn;
//   }

//   Widget _darkCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: kCard,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: kCardBorder),
//       ),
//       child: child,
//     );
//   }

//   Widget _darkDialogShell({
//     required String title,
//     required Widget content,
//     required List<Widget> actions,
//   }) {
//     return AlertDialog(
//       backgroundColor: kCard,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: const BorderSide(color: kCardBorder),
//       ),
//       title: Text(title,
//           style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold)),
//       content: content,
//       actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       actions: actions,
//     );
//   }

//   Widget _buildBalanceItem({
//     required String label,
//     required double amount,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: kFieldFill,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: kCardBorder),
//       ),
//       child: Column(
//         children: [
//           Text(label,
//               style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
//           const SizedBox(height: 6),
//           Text(
//             'ر.س${amount.toStringAsFixed(0)}',
//             style: const TextStyle(
//                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال الخزنة النقدية (بدون تغيير)
//   // =========================================================================
//   void _showDepositCashDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.addToCashBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                   );
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('إيداع', 'Deposit'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showWithdrawCashDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kRed,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 final balance = await FS.getCashBoxBalance();
//                 double available =
//                     method == 'cash' ? balance['cash']! : balance['network']!;
//                 if (amount > available) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             _t('الرصيد غير كافٍ', 'Insufficient balance'))),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromCashBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                   );
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             _t('تم السحب بنجاح', 'Withdrawal successful'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('سحب', 'Withdraw'),
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال الخزنة (ذهب) - بدون تغيير
//   // =========================================================================
//   void _showGoldDepositDialog() {
//     _showGoldDialog(mode: 'deposit');
//   }

//   void _showGoldWithdrawDialog() {
//     _showGoldDialog(mode: 'withdraw');
//   }

//   void _showGoldDialog({required String mode}) {
//     String goldType = 'raw';
//     String carat = '21';
//     final weightController = TextEditingController();
//     final noteController = TextEditingController();

//     final caratList = ['14', '18', '21', '22', '24'];
//     final actionColor = mode == 'deposit' ? kGreen : kRed;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: mode == 'deposit'
//               ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
//               : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
//                     MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
//                   ],
//                   value: goldType,
//                   onChanged: (val) => setDialogState(() => goldType = val),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: carat,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: caratList.map((c) {
//                         return DropdownMenuItem(
//                             value: c, child: Text('$c ${_t('عيار', 'K')}'));
//                       }).toList(),
//                       onChanged: (val) => setDialogState(() => carat = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: weightController,
//                   keyboardType: TextInputType.number,
//                   label: _t('الوزن (جرام)', 'Weight (g)'),
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: actionColor,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final weight = double.tryParse(weightController.text) ?? 0.0;
//                 if (weight <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('الوزن يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 final caratDouble = double.tryParse(carat) ?? 21.0;

//                 try {
//                   if (mode == 'deposit') {
//                     await FS.depositSafeGold(
//                       goldType: goldType,
//                       carat: caratDouble,
//                       weight: weight,
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : null,
//                     );
//                   } else {
//                     final summary = await FS.getSafeGoldSummary();
//                     final transactions =
//                         summary['transactions'] as List<Map<String, dynamic>>;
//                     double available = 0.0;
//                     for (var t in transactions) {
//                       if (t['goldType'] == goldType &&
//                           (t['carat'] ?? 24).toDouble() == caratDouble) {
//                         if (t['type'] == 'deposit') {
//                           available += (t['weight'] ?? 0.0).toDouble();
//                         } else if (t['type'] == 'withdraw') {
//                           available -= (t['weight'] ?? 0.0).toDouble();
//                         }
//                       }
//                     }
//                     if (weight > available) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(_t(
//                                 'الرصيد غير كافٍ لهذا العيار والنوع',
//                                 'Insufficient balance for this carat and type'))),
//                       );
//                       return;
//                     }
//                     await FS.withdrawSafeGold(
//                       goldType: goldType,
//                       carat: caratDouble,
//                       weight: weight,
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : null,
//                     );
//                   }
//                   Navigator.pop(context);
//                   _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         mode == 'deposit'
//                             ? _t('تم إيداع الذهب بنجاح',
//                                 'Gold deposited successfully')
//                             : _t('تم سحب الذهب بنجاح',
//                                 'Gold withdrawn successfully'),
//                       ),
//                     ),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(
//                 mode == 'deposit'
//                     ? _t('إيداع', 'Deposit')
//                     : _t('سحب', 'Withdraw'),
//                 style: TextStyle(
//                     color: mode == 'deposit' ? Colors.black : Colors.white,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // =========================================================================
//   // دوال صندوق اليومي (بدون تغيير)
//   // =========================================================================

//   void _showOpenFloatDialog() {
//     final cashController = TextEditingController();
//     final networkController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('فتح عهدة جديدة', 'Open New Float'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _t('تخصص العهدة من الخزنة وتضاف لصندوق اليومي.',
//                       'Float is taken from safe and added to daily box.'),
//                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: cashController,
//                   keyboardType: TextInputType.number,
//                   label: _t('نقدي (ر.س)', 'Cash (SAR)'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: networkController,
//                   keyboardType: TextInputType.number,
//                   label: _t('شبكة (ر.س)', 'Network (SAR)'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(_t('إجمالي العهدة', 'Total Float'),
//                         style: const TextStyle(color: Colors.white70)),
//                     ValueListenableBuilder(
//                       valueListenable: cashController,
//                       builder: (_, __, ___) {
//                         final cash = double.tryParse(cashController.text) ?? 0;
//                         final network =
//                             double.tryParse(networkController.text) ?? 0;
//                         return Text(
//                           'ر.س ${(cash + network).toStringAsFixed(2)}',
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: kGold),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGold,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final cash = double.tryParse(cashController.text) ?? 0.0;
//                 final network = double.tryParse(networkController.text) ?? 0.0;
//                 if (cash <= 0 && network <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('يجب إدخال مبلغ في أحد الحقلين')),
//                   );
//                   return;
//                 }

//                 try {
//                   final safeBal = await FS.getCashBoxBalance();
//                   if (cash > safeBal['cash']!) {
//                     throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
//                   }
//                   if (network > safeBal['network']!) {
//                     throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
//                   }

//                   if (cash > 0) {
//                     await FS.deductFromCashBox(
//                       amount: cash,
//                       method: 'cash',
//                       note: 'فتح عهدة صندوق يومي',
//                     );
//                   }
//                   if (network > 0) {
//                     await FS.deductFromCashBox(
//                       amount: network,
//                       method: 'network',
//                       note: 'فتح عهدة صندوق يومي',
//                     );
//                   }

//                   if (cash > 0) {
//                     await FS.addToDailyBox(
//                       amount: cash,
//                       method: 'cash',
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : 'فتح عهدة',
//                       type: 'float_open',
//                     );
//                   }
//                   if (network > 0) {
//                     await FS.addToDailyBox(
//                       amount: network,
//                       method: 'network',
//                       note: noteController.text.isNotEmpty
//                           ? noteController.text
//                           : 'فتح عهدة',
//                       type: 'float_open',
//                     );
//                   }

//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(_t('تم فتح العهدة بنجاح',
//                             'Float opened successfully'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('فتح العهدة', 'Open Float'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showExpenseDialog() {
//     String method = 'cash';
//     String selectedCategory = expenseCategories.first;
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تسجيل مصروف', 'Record Expense'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCategory,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: expenseCategories.map((cat) {
//                         return DropdownMenuItem(value: cat, child: Text(cat));
//                       }).toList(),
//                       onChanged: (val) =>
//                           setDialogState(() => selectedCategory = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kRed,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromDailyBox(
//                     amount: amount,
//                     method: method,
//                     category: selectedCategory,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                     type: 'expense',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم تسجيل المصروف', 'Expense recorded'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('حفظ', 'Save'),
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDepositDialog() {
//     String method = 'cash';
//     String selectedCategory = depositCategories.first;
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تسجيل إيداع', 'Record Deposit'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCategory,
//                       isExpanded: true,
//                       dropdownColor: kCard,
//                       iconEnabledColor: kGold,
//                       style: const TextStyle(color: Colors.white),
//                       items: depositCategories.map((cat) {
//                         return DropdownMenuItem(value: cat, child: Text(cat));
//                       }).toList(),
//                       onChanged: (val) =>
//                           setDialogState(() => selectedCategory = val!),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGreen,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.addToDailyBox(
//                     amount: amount,
//                     method: method,
//                     category: selectedCategory,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : null,
//                     type: 'deposit',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t('تم تسجيل الإيداع', 'Deposit recorded'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('حفظ', 'Save'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPartialTransferToSafeDialog() {
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer to Safe'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 12),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGold,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }
//                 try {
//                   await FS.deductFromDailyBox(
//                     amount: amount,
//                     method: method,
//                     note: noteController.text.isNotEmpty
//                         ? noteController.text
//                         : 'تحويل للخزنة',
//                     type: 'transfer_to_safe',
//                   );
//                   await FS.addToCashBox(
//                     amount: amount,
//                     method: method,
//                     note: 'تحويل من الصندوق اليومي',
//                   );
//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(_t('تم التحويل', 'Transfer completed'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('تحويل', 'Transfer'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEndOfDayTransfer() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: const BorderSide(color: kCardBorder),
//         ),
//         title: Text(_t('توريد نهاية اليوم', 'End-of-Day Transfer'),
//             style: const TextStyle(color: Colors.white)),
//         content: Text(
//           _t('سيتم تحويل كامل رصيد الصندوق اليومي إلى الخزنة وإعادة تعيينه.',
//               'All daily box balance will be transferred to safe and reset.'),
//           style: const TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(_t('إلغاء', 'Cancel'),
//                 style: const TextStyle(color: kTextSecondary)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kRed,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24)),
//             ),
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(_t('تأكيد', 'Confirm'),
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//     if (confirm != true) return;

//     try {
//       final balance = await FS.getDailyBoxBalance();
//       double cash = balance['cash']!;
//       double network = balance['network']!;

//       if (cash > 0) {
//         await FS.addToCashBox(
//           amount: cash,
//           method: 'cash',
//           note: 'توريد نهاية اليوم (نقدي)',
//         );
//       }
//       if (network > 0) {
//         await FS.addToCashBox(
//           amount: network,
//           method: 'network',
//           note: 'توريد نهاية اليوم (شبكة)',
//         );
//       }

//       if (cash > 0) {
//         await FS.deductFromDailyBox(
//           amount: cash,
//           method: 'cash',
//           note: 'توريد نهاية اليوم',
//           type: 'end_of_day_transfer',
//         );
//       }
//       if (network > 0) {
//         await FS.deductFromDailyBox(
//           amount: network,
//           method: 'network',
//           note: 'توريد نهاية اليوم',
//           type: 'end_of_day_transfer',
//         );
//       }

//       await FS.resetDailyBox();

//       await _loadAllData();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(_t('تم توريد نهاية اليوم بنجاح',
//                 'End-of-day transfer completed'))),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ: $e')),
//       );
//     }
//   }

//   // =========================================================================
//   // دوال صندوق الكسر الجديدة (باستخدام FS.scrapCol() فقط)
//   // =========================================================================

//   /// تمويل صندوق الكسر (إضافة نقدية من مصدر آخر) - يضاف لليوم الحالي
//   void _showFundScrapDialog() {
//     String source = 'daily'; // 'daily' or 'safe'
//     String method = 'cash';
//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setDialogState) => _darkDialogShell(
//           title: _t('تمويل العهدة', 'Fund Float'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // اختيار المصدر
//                 _segmentedToggle(
//                   options: [
//                     MapEntry('daily', _t('صندوق اليومي', 'Daily Box')),
//                     MapEntry('safe', _t('الخزنة', 'Safe')),
//                   ],
//                   value: source,
//                   onChanged: (val) => setDialogState(() => source = val),
//                 ),
//                 const SizedBox(height: 16),
//                 // طريقة الدفع
//                 _segmentedToggle(
//                   options: [
//                     const MapEntry('cash', 'نقدي'),
//                     const MapEntry('network', 'شبكة'),
//                   ],
//                   value: method,
//                   onChanged: (val) => setDialogState(() => method = val),
//                 ),
//                 const SizedBox(height: 16),
//                 _darkField(
//                   controller: amountController,
//                   keyboardType: TextInputType.number,
//                   label: _t('المبلغ', 'Amount'),
//                   prefixText: 'ر.س ',
//                 ),
//                 const SizedBox(height: 14),
//                 _darkField(
//                   controller: noteController,
//                   label: _t('ملاحظة (اختياري)', 'Note (optional)'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(_t('إلغاء', 'Cancel'),
//                   style: const TextStyle(color: kTextSecondary)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kGold,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(24)),
//               ),
//               onPressed: () async {
//                 final amount = double.tryParse(amountController.text) ?? 0.0;
//                 if (amount <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('المبلغ يجب أن يكون أكبر من صفر')),
//                   );
//                   return;
//                 }

//                 try {
//                   // التحقق من الرصيد في المصدر وخصم
//                   if (source == 'daily') {
//                     final dailyBal = await FS.getDailyBoxBalance();
//                     if (method == 'cash' && amount > dailyBal['cash']!) {
//                       throw Exception(
//                           'الرصيد النقدي في الصندوق اليومي غير كافٍ');
//                     }
//                     if (method == 'network' && amount > dailyBal['network']!) {
//                       throw Exception('رصيد الشبكة في الصندوق اليومي غير كافٍ');
//                     }
//                     await FS.deductFromDailyBox(
//                       amount: amount,
//                       method: method,
//                       note: 'تمويل صندوق الكسر',
//                       type: 'fund_scrap',
//                     );
//                   } else if (source == 'safe') {
//                     final safeBal = await FS.getCashBoxBalance();
//                     if (method == 'cash' && amount > safeBal['cash']!) {
//                       throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
//                     }
//                     if (method == 'network' && amount > safeBal['network']!) {
//                       throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
//                     }
//                     await FS.deductFromCashBox(
//                       amount: amount,
//                       method: method,
//                       note: 'تمويل صندوق الكسر',
//                     );
//                   }

//                   // إضافة إلى صندوق الكسر باستخدام scrapCol().add()
//                   await FS.scrapCol().add({
//                     'cash': method == 'cash' ? amount : 0.0,
//                     'network': method == 'network' ? amount : 0.0,
//                     'type': 'fund',
//                     'date': DateTime.now(),
//                     'notes': noteController.text.isNotEmpty
//                         ? noteController.text
//                         : 'تمويل من ${source == 'daily' ? 'صندوق اليومي' : 'الخزنة'}',
//                     'createdAt': FieldValue.serverTimestamp(),
//                   });

//                   Navigator.pop(context);
//                   await _loadAllData();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(_t('تم تمويل صندوق الكسر بنجاح',
//                             'Scrap box funded successfully'))),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('خطأ: $e')),
//                   );
//                 }
//               },
//               child: Text(_t('تمويل', 'Fund'),
//                   style: const TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// إقفال صندوق الكسر (تحويل رصيد اليوم إلى الخزنة وتصفير اليوم)
//   void _closeScrapBox() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: kCard,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: const BorderSide(color: kCardBorder),
//         ),
//         title: Text(
//             _t('إقفال صندوق الكسر اليومي وتوريده للخزنة',
//                 'Close Daily Scrap Box and Transfer to Safe'),
//             style: const TextStyle(color: Colors.white)),
//         content: Text(
//           _t('سيتم تحويل كامل رصيد صندوق الكسر إلى الخزنة وإعادة تعيينه.',
//               'All scrap box balance will be transferred to safe and reset.'),
//           style: const TextStyle(color: Colors.white70),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(_t('إلغاء', 'Cancel'),
//                 style: const TextStyle(color: kTextSecondary)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: kRed,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24)),
//             ),
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(_t('تأكيد', 'Confirm'),
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//     if (confirm != true) return;

//     try {
//       // الحصول على رصيد اليوم الحالي
//       final scrapData = await _getScrapBoxDataToday();
//       double cash = scrapData['cash'];
//       double network = scrapData['network'];

//       if (cash > 0) {
//         await FS.addToCashBox(
//           amount: cash,
//           method: 'cash',
//           note: 'إقفال صندوق الكسر (نقدي)',
//         );
//       }
//       if (network > 0) {
//         await FS.addToCashBox(
//           amount: network,
//           method: 'network',
//           note: 'إقفال صندوق الكسر (شبكة)',
//         );
//       }

//       // تسجيل عملية الإقفال في صندوق الكسر (خصم الرصيد من اليوم)
//       if (cash > 0) {
//         await FS.scrapCol().add({
//           'cash': -cash,
//           'network': 0.0,
//           'type': 'close',
//           'date': DateTime.now(),
//           'notes': 'إقفال صندوق الكسر (نقدي)',
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }
//       if (network > 0) {
//         await FS.scrapCol().add({
//           'cash': 0.0,
//           'network': -network,
//           'type': 'close',
//           'date': DateTime.now(),
//           'notes': 'إقفال صندوق الكسر (شبكة)',
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//       }

//       await _loadAllData();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(_t('تم إقفال صندوق الكسر بنجاح',
//                 'Scrap box closed successfully'))),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('خطأ: $e')),
//       );
//     }
//   }

//   // =========================================================================
//   // بناء واجهة صندوق اليومي (بدون تغيير)
//   // =========================================================================
//   Widget _buildDailyBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('رصيد صندوق اليومي', 'Daily Box Balance'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 18),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'ر.س',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           text: (dailyCash + dailyNetwork).toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('شبكة', 'Network'),
//                             amount: dailyNetwork)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('نقدي', 'Cash'), amount: dailyCash)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('مصروف', 'Expense'),
//                       icon: Icons.remove_circle,
//                       color: kRed,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showExpenseDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع', 'Deposit'),
//                       icon: Icons.add_circle,
//                       color: kGreen,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showDepositDialog,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: double.infinity,
//                   child: _pillButton(
//                     label: _t('توريد نهاية اليوم للخزنة (كامل الرصيد)',
//                         'End-of-Day Transfer to Safe (Full Balance)'),
//                     icon: Icons.payments,
//                     color: kGold,
//                     filled: true,
//                     expanded: false,
//                     onPressed: _showEndOfDayTransfer,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('عهدة الصندوق اليومي', 'Daily Box Float'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _t(
//                     'سلم عهدة ابتدائية من الخزنة لمن يقف على الصندوق. وعند نهاية الوردية اجرد الدرج فعلياً وسجل الفرق.',
//                     'An initial float is given from the safe to the cashier. At the end of shift, count the actual drawer and record the difference.',
//                   ),
//                   style: const TextStyle(color: kTextSecondary, fontSize: 13),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Column(
//                         children: [
//                           Text(_t('نقدي', 'Cash'),
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 12)),
//                           Text('ر.س ${dailyFloatCash.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       Container(width: 1, height: 30, color: kCardBorder),
//                       Column(
//                         children: [
//                           Text(_t('شبكة', 'Network'),
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 12)),
//                           Text('ر.س ${dailyFloatNetwork.toStringAsFixed(0)}',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('فتح عهدة جديدة', 'Open New Float'),
//                       icon: Icons.add,
//                       color: kGold,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showOpenFloatDialog,
//                     ),
//                     _pillButton(
//                       label: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer'),
//                       icon: Icons.swap_horiz,
//                       color: kGold,
//                       filled: false,
//                       expanded: true,
//                       onPressed: _showPartialTransferToSafeDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           if (dailyTransactions.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             _darkCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _t('آخر الحركات', 'Recent Transactions'),
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 6),
//                   ...dailyTransactions.take(10).map((t) {
//                     final type = t['type'] ?? '';
//                     final method = t['method'] ?? '';
//                     final amount = (t['amount'] ?? 0).toDouble();
//                     final category = t['category'] ?? '';
//                     final note = t['note'] ?? '';
//                     final isAdd = (type == 'float_open' || type == 'deposit');
//                     final color = isAdd ? kGreen : kRed;
//                     final icon = isAdd ? Icons.add_circle : Icons.remove_circle;
//                     final typeLabel = {
//                           'float_open': _t('فتح عهدة', 'Open Float'),
//                           'deposit': _t('إيداع', 'Deposit'),
//                           'expense': _t('مصروف', 'Expense'),
//                           'transfer_to_safe':
//                               _t('تحويل للخزنة', 'Transfer to Safe'),
//                           'end_of_day_transfer':
//                               _t('توريد نهاية اليوم', 'End of Day'),
//                         }[type] ??
//                         type;

//                     return ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       dense: true,
//                       leading: Icon(icon, color: color),
//                       title: Text(
//                         '$typeLabel - ${method == 'cash' ? 'نقدي' : 'شبكة'}',
//                         style: const TextStyle(
//                             fontSize: 13.5, color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         category.isNotEmpty ? '$category | $note' : note,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 11.5),
//                       ),
//                       trailing: Text(
//                         '${isAdd ? '+' : '-'}ر.س ${amount.toStringAsFixed(0)}',
//                         style: TextStyle(
//                           color: color,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // بناء واجهة الخزنة (بدون تغيير)
//   // =========================================================================
//   Widget _buildSafeBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('الإجمالي', 'Total'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 18),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'ر.س',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           text: (safeCash + safeNetwork).toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('نقدي', 'Cash'), amount: safeCash)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('شبكة', 'Network'), amount: safeNetwork)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('سحب', 'Withdraw'),
//                       icon: Icons.arrow_upward,
//                       color: kRed,
//                       filled: false,
//                       onPressed: _showWithdrawCashDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع ', 'Manual Deposit'),
//                       icon: Icons.arrow_downward,
//                       color: kGreen,
//                       filled: true,
//                       onPressed: _showDepositCashDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 14),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: kFieldFill,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: kCardBorder),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _t('الإجمالي محوّلًا لعيار 24',
//                             'Total converted to 24K'),
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 12.5),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
//                         style: const TextStyle(
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             color: kGold),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
//                         '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
//                         '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 14),
//                 if (goldTransactions.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _t('آخر العمليات', 'Recent Transactions'),
//                         style: const TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       const SizedBox(height: 6),
//                       ...goldTransactions.take(5).map((t) {
//                         final isDeposit = t['type'] == 'deposit';
//                         final weight = (t['weight'] ?? 0.0).toDouble();
//                         final carat = (t['carat'] ?? 24).toDouble();
//                         final type = t['goldType'] == 'raw'
//                             ? _t('خام', 'Raw')
//                             : _t('مشغول', 'Worked');
//                         final date = (t['date'] as Timestamp?)?.toDate();
//                         final dateStr = date != null
//                             ? '${date.day}/${date.month}/${date.year}'
//                             : '';
//                         return ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           dense: true,
//                           leading: Icon(
//                             isDeposit ? Icons.add_circle : Icons.remove_circle,
//                             color: isDeposit ? kGreen : kRed,
//                           ),
//                           title: Text(
//                             '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
//                             style: const TextStyle(
//                                 fontSize: 13.5, color: Colors.white),
//                           ),
//                           subtitle: Text(dateStr,
//                               style: const TextStyle(
//                                   color: kTextSecondary, fontSize: 11.5)),
//                           trailing: Text(
//                             '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
//                             style: TextStyle(
//                               color: isDeposit ? kGreen : kRed,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   )
//                 else
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: Text(
//                         _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
//                         style: const TextStyle(color: kTextSecondary),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 14),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('سحب', 'Withdraw'),
//                       icon: Icons.arrow_downward,
//                       color: kRed,
//                       filled: false,
//                       onPressed: _showGoldWithdrawDialog,
//                     ),
//                     _pillButton(
//                       label: _t('إيداع', 'Deposit'),
//                       icon: Icons.arrow_upward,
//                       color: kGreen,
//                       filled: true,
//                       onPressed: _showGoldDepositDialog,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // بناء واجهة صندوق الكسر (مطابق للصورة)
//   // =========================================================================
//   Widget _buildScrapBoxTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         children: [
//           // بطاقة الرصيد الإجمالي والوزن
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       _t('صندوق الكسر', 'Scrap Box'),
//                       style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     // عرض الوزن بعيار 24
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: kGold.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: kGold.withOpacity(0.3)),
//                       ),
//                       child: Text(
//                         '${scrapGold24K.toStringAsFixed(2)} ${_t('جم بعيار 24', 'g 24K')}',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           color: kGold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 18),
//                 Center(
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'ر.س',
//                           style: TextStyle(
//                               fontSize: 16,
//                               color: kTextSecondary,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         const TextSpan(text: '  '),
//                         TextSpan(
//                           text: (scrapCash + scrapNetwork).toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontSize: 32,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('نقدي', 'Cash'), amount: scrapCash)),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: _buildBalanceItem(
//                             label: _t('شبكة', 'Network'),
//                             amount: scrapNetwork)),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // زر إقفال صندوق الكسر
//                 SizedBox(
//                   width: double.infinity,
//                   child: _pillButton(
//                     label: _t('إقفال صندوق الكسر اليومي وتوريده للخزنة',
//                         'Close Daily Scrap Box and Transfer to Safe'),
//                     icon: Icons.lock_clock,
//                     color: kRed,
//                     filled: true,
//                     expanded: false,
//                     onPressed: _closeScrapBox,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // قسم تمويل العهدة
//           _darkCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t('تمويل العهدة', 'Fund Float'),
//                   style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     _pillButton(
//                       label: _t('تمويل', 'Fund'),
//                       icon: Icons.add,
//                       color: kGold,
//                       filled: true,
//                       expanded: true,
//                       onPressed: _showFundScrapDialog,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _t('اختر المصدر (صندوق اليومي أو الخزنة) وطريقة الدفع',
//                       'Choose source (Daily Box or Safe) and payment method'),
//                   style: const TextStyle(color: kTextSecondary, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           // عرض آخر حركات صندوق الكسر (اختياري)
//           if (scrapTransactions.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             _darkCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     _t('آخر الحركات', 'Recent Transactions'),
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   const SizedBox(height: 6),
//                   ...scrapTransactions.take(10).map((t) {
//                     final type = t['type'] ?? '';
//                     final cash = (t['cash'] ?? 0.0).toDouble();
//                     final network = (t['network'] ?? 0.0).toDouble();
//                     final amount = cash + network;
//                     final isPositive = amount >= 0;
//                     final color = isPositive ? kGreen : kRed;
//                     final icon =
//                         isPositive ? Icons.add_circle : Icons.remove_circle;
//                     return ListTile(
//                       contentPadding: EdgeInsets.zero,
//                       dense: true,
//                       leading: Icon(icon, color: color),
//                       title: Text(
//                         type,
//                         style: const TextStyle(
//                             fontSize: 13.5, color: Colors.white),
//                       ),
//                       subtitle: Text(
//                         (t['data']?['notes'] ?? '') as String? ?? '',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                             color: kTextSecondary, fontSize: 11.5),
//                       ),
//                       trailing: Text(
//                         '${isPositive ? '+' : ''}ر.س ${amount.abs().toStringAsFixed(0)}',
//                         style: TextStyle(
//                           color: color,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   // الواجهة الرئيسية
//   // =========================================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         title: Text(_t('الصندوق', 'Cash Box')),
//         backgroundColor: const Color(0xFFD4AF37),
//         centerTitle: true,
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 indicator: BoxDecoration(
//                   color: Colors.black.withOpacity(0.28),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.black54,
//                 labelStyle:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//                 dividerColor: Colors.transparent,
//                 tabs: [
//                   Tab(text: _t('صندوق الكسر', 'Scrap Box')),
//                   Tab(text: _t('صندوق اليومي', 'Daily Box')),
//                   Tab(text: _t('الخزنة', 'Safe Box')),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: loading
//           ? Center(child: CircularProgressIndicator(color: kGold))
//           : TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildScrapBoxTab(),
//                 _buildDailyBoxTab(),
//                 _buildSafeBoxTab(),
//               ],
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';

class CashBoxPage extends StatefulWidget {
  const CashBoxPage({super.key});

  @override
  State<CashBoxPage> createState() => _CashBoxPageState();
}

class _CashBoxPageState extends State<CashBoxPage>
    with SingleTickerProviderStateMixin {
  // ===== ألوان التصميم =====
  static const Color kGold = Color(0xFFD4AF37);
  static const Color kBackground = Color(0xFF121212);
  static const Color kCard = Color(0xFF1C1C1C);
  static const Color kCardBorder = Color(0xFF2A2A2A);
  static const Color kFieldFill = Color(0xFF161616);
  static const Color kGreen = Color(0xFF4CAF50);
  static const Color kRed = Color(0xFFE05353);
  static const Color kTextSecondary = Color(0xFF9E9E9E);

  // ===== متغيرات الأقسام =====
  double totalBalance = 0.0;
  double cashTotal = 0.0;
  double networkTotal = 0.0;

  // ===== الخزنة (نقدي) =====
  double safeCash = 0.0;
  double safeNetwork = 0.0;

  // ===== الخزنة (ذهب) =====
  double goldTotal24K = 0.0;
  double goldTotalActual = 0.0;
  double goldScrapWeight = 0.0;
  double goldWorkedWeight = 0.0;
  List<Map<String, dynamic>> goldTransactions = [];

  // ===== صندوق اليومي =====
  double dailyCash = 0.0;
  double dailyNetwork = 0.0;
  List<Map<String, dynamic>> dailyTransactions = [];
  double dailyFloatCash = 0.0;
  double dailyFloatNetwork = 0.0;

  // ===== صندوق الكسر (تراكمي) =====
  double scrapCash = 0.0;
  double scrapNetwork = 0.0;
  List<Map<String, dynamic>> scrapTransactions = [];
  double scrapGold24K = 0.0;

  bool loading = true;
  String _lang = 'ar';
  late TabController _tabController;

  // قوائم التصنيفات
  final List<String> expenseCategories = [
    'سحب شخصي / سحب شريك',
    'أخرى',
  ];
  final List<String> depositCategories = [
    'إيرادات أخرى',
    'رأس مال / مساهمة شريك',
  ];

  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadLanguage();
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  // ===== تحميل جميع البيانات =====
  Future<void> _loadAllData() async {
    setState(() => loading = true);
    try {
      final cashBalance = await FS.getCashBoxBalance();
      safeCash = cashBalance['cash']!;
      safeNetwork = cashBalance['network']!;

      final goldSummary = await FS.getSafeGoldSummary();
      goldTotal24K = goldSummary['total24K'] ?? 0.0;
      goldTotalActual = goldSummary['totalActual'] ?? 0.0;
      goldScrapWeight = goldSummary['scrapWeight'] ?? 0.0;
      goldWorkedWeight = goldSummary['workedWeight'] ?? 0.0;
      goldTransactions =
          List<Map<String, dynamic>>.from(goldSummary['transactions'] ?? []);

      await _loadDailyBoxData();

      // تحميل بيانات صندوق الكسر التراكمي
      final scrapData = await _getScrapBoxTotal();
      scrapCash = scrapData['cash'];
      scrapNetwork = scrapData['network'];
      scrapTransactions = scrapData['transactions'];
      scrapGold24K = scrapData['gold24K'] ?? 0.0;

      // المجاميع الكلية
      totalBalance = (safeCash + safeNetwork) +
          (dailyCash + dailyNetwork) +
          (scrapCash + scrapNetwork);
      cashTotal = safeCash + dailyCash + scrapCash;
      networkTotal = safeNetwork + dailyNetwork + scrapNetwork;

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
      );
    }
  }

  Future<void> _loadDailyBoxData() async {
    try {
      final balance = await FS.getDailyBoxBalance();
      dailyCash = balance['cash']!;
      dailyNetwork = balance['network']!;

      final history = await FS.getDailyBoxHistory();
      dailyTransactions = history;

      double floatCash = 0.0;
      double floatNetwork = 0.0;
      for (var t in history) {
        if (t['type'] == 'float_open') {
          if (t['method'] == 'cash')
            floatCash += (t['amount'] ?? 0).toDouble();
          else if (t['method'] == 'network')
            floatNetwork += (t['amount'] ?? 0).toDouble();
        }
      }
      dailyFloatCash = floatCash;
      dailyFloatNetwork = floatNetwork;
    } catch (e) {
      print('⚠️ خطأ في تحميل الصندوق اليومي: $e');
    }
  }

  double _convertTo24Karat(double weight, String carat) {
    if (carat == "24") return weight;
    if (carat == "22") return weight * 22 / 24;
    if (carat == "21") return weight * 21 / 24;
    if (carat == "18") return weight * 18 / 24;
    if (carat == "14") return weight * 14 / 24;
    return weight;
  }

  Future<Map<String, dynamic>> _getScrapBoxTotal() async {
    double cash = 0.0, network = 0.0;
    List<Map<String, dynamic>> transactions = [];
    double gold24K = 0.0;

    const knownCarats = ["14", "18", "21", "22", "24"];
    const knownTypes = ["add", "sale", "payment", "transform"];

    try {
      final snapshot = await FS.scrapCol().get(
            const GetOptions(source: Source.server),
          );

      final allTx = snapshot.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        data["id"] = d.id;
        return data;
      }).toList();

      for (var t in allTx) {
        final type = t["type"] ?? "";
        final c = (t["cash"] ?? 0.0).toDouble();
        final n = (t["network"] ?? 0.0).toDouble();

        // ===== تطبيق الإشارات الصحيحة حسب نوع العملية =====
        switch (type) {
          case 'add': // شراء كسر → خروج نقدي
            cash -= c;
            network -= n;
            break;
          case 'sale': // بيع كسر → دخول نقدي
            cash += c;
            network += n;
            break;
          case 'payment': // سند صرف → خروج نقدي
            cash -= c;
            network -= n;
            break;
          case 'fund': // تمويل → دخول نقدي
            cash += c;
            network += n;
            break;
          case 'close': // إقفال → خروج (c و n سالبة أصلاً)
            cash += c; // c سالبة، فتقلل الرصيد
            network += n; // n سالبة، فتقلل الرصيد
            break;
          default:
            // أنواع غير معروفة، لا تؤثر على الرصيد
            break;
        }

        // ===== حساب وزن 24K =====
        if (type == "payment" &&
            t["carats"] != null &&
            (t["carats"] as List).isNotEmpty) {
          final carats = t["carats"] as List;
          for (var item in carats) {
            final carat = (item['carat'] ?? "18").toString();
            final weight = (item['weight'] ?? 0).toDouble();
            double convertedWeight = _convertTo24Karat(weight, carat);
            gold24K -= convertedWeight.abs();
          }
        } else {
          final carat = (t["carat"] ?? "18").toString();
          final weight = (t["weight"] ?? 0).toDouble();

          if (knownTypes.contains(type) && knownCarats.contains(carat)) {
            double convertedWeight = _convertTo24Karat(weight, carat);
            if (type == "add" || type == "transform") {
              gold24K += convertedWeight;
            } else if (type == "sale" || type == "payment") {
              gold24K -= convertedWeight.abs();
            }
          }
        }

        // ===== إضافة معالجة الإقفال لتصفير الوزن =====
        if (type == "close") {
          final goldVal = (t["gold24K"] ?? 0.0).toDouble();
          gold24K += goldVal; // goldVal سالبة، تقلل الرصيد إلى صفر
        }

        // ===== إضافة المعاملة للقائمة مع الإشارة الصحيحة =====
        // تحديد قيمة amount (مع الإشارة) لعرضها في قائمة الحركات
        double amount;
        if (type == 'add' || type == 'payment' || type == 'close') {
          amount = -(c + n); // سالب
        } else if (type == 'sale' || type == 'fund') {
          amount = (c + n); // موجب
        } else {
          amount = (c + n); // افتراضي
        }

        transactions.add({
          'type': _getTransactionLabel(type),
          'cash': c,
          'network': n,
          'amount': amount, // القيمة الصافية مع الإشارة
          'date': t['date'],
          'data': t,
        });
      }
    } catch (e) {
      print('Error calculating scrap balance: $e');
    }

    // ترتيب المعاملات من الأحدث للأقدم
    transactions.sort((a, b) {
      final dateA = a['date'];
      final dateB = b['date'];
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      final tA = dateA is Timestamp ? dateA.toDate() : dateA;
      final tB = dateB is Timestamp ? dateB.toDate() : dateB;
      return tB.compareTo(tA);
    });

    return {
      'cash': cash,
      'network': network,
      'transactions': transactions.take(50).toList(),
      'gold24K': gold24K,
    };
  }

  // Future<Map<String, dynamic>> _getScrapBoxTotal() async {
  //   double cash = 0.0, network = 0.0;
  //   List<Map<String, dynamic>> transactions = [];
  //   double gold24K = 0.0;

  //   const knownCarats = ["14", "18", "21", "22", "24"];
  //   const knownTypes = ["add", "sale", "payment", "transform"];

  //   try {
  //     final snapshot = await FS.scrapCol().get(
  //           const GetOptions(source: Source.server),
  //         );

  //     final allTx = snapshot.docs.map((d) {
  //       final data = d.data() as Map<String, dynamic>;
  //       data["id"] = d.id;
  //       return data;
  //     }).toList();

  //     for (var t in allTx) {
  //       final type = t["type"] ?? "";
  //       final c = (t["cash"] ?? 0.0).toDouble();
  //       final n = (t["network"] ?? 0.0).toDouble();

  //       cash += c;
  //       network += n;

  //       // حساب الوزن بعيار 24
  //       if (type == "payment" &&
  //           t["carats"] != null &&
  //           (t["carats"] as List).isNotEmpty) {
  //         final carats = t["carats"] as List;
  //         for (var item in carats) {
  //           final carat = (item['carat'] ?? "18").toString();
  //           final weight = (item['weight'] ?? 0).toDouble();
  //           double convertedWeight = _convertTo24Karat(weight, carat);
  //           gold24K -= convertedWeight.abs();
  //         }
  //       } else {
  //         final carat = (t["carat"] ?? "18").toString();
  //         final weight = (t["weight"] ?? 0).toDouble();

  //         if (knownTypes.contains(type) && knownCarats.contains(carat)) {
  //           double convertedWeight = _convertTo24Karat(weight, carat);
  //           if (type == "add" || type == "transform") {
  //             gold24K += convertedWeight;
  //           } else if (type == "sale" || type == "payment") {
  //             gold24K -= convertedWeight.abs();
  //           }
  //         }
  //       }

  //       // ✅ إضافة معالجة الإقفال (لتصفير الرصيد)
  //       if (type == "close") {
  //         final goldVal = (t["gold24K"] ?? 0.0).toDouble();
  //         gold24K += goldVal; // goldVal سالبة، فتقلل الرصيد إلى صفر
  //       }

  //       transactions.add({
  //         'type': _getTransactionLabel(type),
  //         'cash': c,
  //         'network': n,
  //         'date': t['date'],
  //         'data': t,
  //       });
  //     }
  //   } catch (e) {
  //     print('Error calculating scrap weight: $e');
  //   }

  //   transactions.sort((a, b) {
  //     final dateA = a['date'];
  //     final dateB = b['date'];
  //     if (dateA == null && dateB == null) return 0;
  //     if (dateA == null) return 1;
  //     if (dateB == null) return -1;
  //     final tA = dateA is Timestamp ? dateA.toDate() : dateA;
  //     final tB = dateB is Timestamp ? dateB.toDate() : dateB;
  //     return tB.compareTo(tA);
  //   });

  //   return {
  //     'cash': cash,
  //     'network': network,
  //     'transactions': transactions.take(50).toList(),
  //     'gold24K': gold24K,
  //   };
  // }

  // // ===== جلب رصيد صندوق الكسر التراكمي (محسوب بنفس طريقة التقارير) =====
  // Future<Map<String, dynamic>> _getScrapBoxTotal() async {
  //   double cash = 0.0, network = 0.0;
  //   List<Map<String, dynamic>> transactions = [];
  //   double gold24K = 0.0;

  //   // دالة مساعدة لتحويل الوزن إلى عيار 24
  //   double convertTo24(double weight, String caratStr) {
  //     final carat = double.tryParse(caratStr) ?? 18.0;
  //     return weight * (carat / 24);
  //   }

  //   final scrapSnap = await FS.scrapCol().get();
  //   for (var doc in scrapSnap.docs) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     final type = data['type'] ?? '';
  //     final c = (data['cash'] ?? 0.0).toDouble();
  //     final n = (data['network'] ?? 0.0).toDouble();

  //     // تجميع النقدي والشبكة (جميع العمليات)
  //     cash += c;
  //     network += n;

  //     // حساب وزن 24K حسب النوع (نفس منطق التقارير)
  //     if (type == 'add' || type == 'transform') {
  //       final carat = data['carat']?.toString() ?? '18';
  //       final weight = (data['weight'] ?? 0.0).toDouble();
  //       gold24K += convertTo24(weight, carat);
  //     } else if (type == 'sale') {
  //       final carat = data['carat']?.toString() ?? '18';
  //       final weight = (data['weight'] ?? 0.0).toDouble();
  //       gold24K -= convertTo24(weight, carat);
  //     } else if (type == 'payment') {
  //       // سند صرف: قد يكون عيار واحد أو متعدد
  //       final carats = data['carats'] as List?;
  //       if (carats != null && carats.isNotEmpty) {
  //         for (var item in carats) {
  //           final carat = item['carat']?.toString() ?? '18';
  //           final weight = (item['weight'] ?? 0.0).toDouble();
  //           gold24K -= convertTo24(weight, carat);
  //         }
  //       } else {
  //         final carat = data['carat']?.toString() ?? '18';
  //         final weight = (data['weight'] ?? 0.0).toDouble();
  //         gold24K -= convertTo24(weight, carat);
  //       }
  //     } else if (type == 'close') {
  //       // الإقفال يُضيف قيمة سالبة للذهب (لتتصفير الرصيد)
  //       final goldVal = (data['gold24K'] ?? 0.0).toDouble();
  //       gold24K += goldVal; // goldVal سالبة عادةً
  //     }
  //     // fund لا يؤثر على الذهب

  //     // إضافة المعاملة للقائمة (آخر 50)
  //     transactions.add({
  //       'type': _getTransactionLabel(type),
  //       'cash': c,
  //       'network': n,
  //       'date': data['date'],
  //       'data': data,
  //     });
  //   }

  //   // ترتيب من الأحدث للأقدم
  //   transactions.sort((a, b) {
  //     final dateA = a['date'];
  //     final dateB = b['date'];
  //     if (dateA == null && dateB == null) return 0;
  //     if (dateA == null) return 1;
  //     if (dateB == null) return -1;
  //     final tA = dateA is Timestamp ? dateA.toDate() : dateA;
  //     final tB = dateB is Timestamp ? dateB.toDate() : dateB;
  //     return tB.compareTo(tA);
  //   });

  //   return {
  //     'cash': cash,
  //     'network': network,
  //     'transactions': transactions.take(50).toList(),
  //     'gold24K': gold24K,
  //   };
  // }

  String _getTransactionLabel(String type) {
    switch (type) {
      case 'add':
        return _t('شراء كسر', 'Buy Scrap');
      case 'sale':
        return _t('بيع كسر', 'Sell Scrap');
      case 'payment':
        return _t('سند صرف', 'Payment');
      case 'fund':
        return _t('تمويل', 'Fund');
      case 'close':
        return _t('إقفال', 'Close');
      case 'transform':
        return _t('تحويل', 'Transform');
      default:
        return type;
    }
  }

  // =========================================================================
  // دوال الخزنة النقدية
  // =========================================================================
  void _showDepositCashDialog() {
    String method = 'cash';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('إيداع نقدي في الخزنة', 'Cash Deposit to Safe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 16),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 14),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                try {
                  await FS.addToCashBox(
                    amount: amount,
                    method: method,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : null,
                  );
                  Navigator.pop(context);
                  _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(_t('تم الإيداع بنجاح', 'Deposit successful'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('إيداع', 'Deposit'),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawCashDialog() {
    String method = 'cash';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('سحب نقدي من الخزنة', 'Cash Withdraw from Safe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 16),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 14),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                final balance = await FS.getCashBoxBalance();
                double available =
                    method == 'cash' ? balance['cash']! : balance['network']!;
                if (amount > available) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            _t('الرصيد غير كافٍ', 'Insufficient balance'))),
                  );
                  return;
                }
                try {
                  await FS.deductFromCashBox(
                    amount: amount,
                    method: method,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : null,
                  );
                  Navigator.pop(context);
                  _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            _t('تم السحب بنجاح', 'Withdrawal successful'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('سحب', 'Withdraw'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // دوال الخزنة (ذهب)
  // =========================================================================
  void _showGoldDepositDialog() {
    _showGoldDialog(mode: 'deposit');
  }

  void _showGoldWithdrawDialog() {
    _showGoldDialog(mode: 'withdraw');
  }

  void _showGoldDialog({required String mode}) {
    String goldType = 'raw';
    String carat = '21';
    final weightController = TextEditingController();
    final noteController = TextEditingController();

    final caratList = ['14', '18', '21', '22', '24'];
    final actionColor = mode == 'deposit' ? kGreen : kRed;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: mode == 'deposit'
              ? _t('إيداع ذهب في الخزنة', 'Gold Deposit to Safe')
              : _t('سحب ذهب من الخزنة', 'Gold Withdraw from Safe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _segmentedToggle(
                  options: [
                    MapEntry('raw', _t('غير مشغول (خام)', 'Raw')),
                    MapEntry('worked', _t('مشغول (قطع)', 'Worked')),
                  ],
                  value: goldType,
                  onChanged: (val) => setDialogState(() => goldType = val),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: kFieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: carat,
                      isExpanded: true,
                      dropdownColor: kCard,
                      iconEnabledColor: kGold,
                      style: const TextStyle(color: Colors.white),
                      items: caratList.map((c) {
                        return DropdownMenuItem(
                            value: c, child: Text('$c ${_t('عيار', 'K')}'));
                      }).toList(),
                      onChanged: (val) => setDialogState(() => carat = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _darkField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  label: _t('الوزن (جرام)', 'Weight (g)'),
                ),
                const SizedBox(height: 14),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: actionColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final weight = double.tryParse(weightController.text) ?? 0.0;
                if (weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('الوزن يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                final caratDouble = double.tryParse(carat) ?? 21.0;

                try {
                  if (mode == 'deposit') {
                    await FS.depositSafeGold(
                      goldType: goldType,
                      carat: caratDouble,
                      weight: weight,
                      note: noteController.text.isNotEmpty
                          ? noteController.text
                          : null,
                    );
                  } else {
                    final summary = await FS.getSafeGoldSummary();
                    final transactions =
                        summary['transactions'] as List<Map<String, dynamic>>;
                    double available = 0.0;
                    for (var t in transactions) {
                      if (t['goldType'] == goldType &&
                          (t['carat'] ?? 24).toDouble() == caratDouble) {
                        if (t['type'] == 'deposit') {
                          available += (t['weight'] ?? 0.0).toDouble();
                        } else if (t['type'] == 'withdraw') {
                          available -= (t['weight'] ?? 0.0).toDouble();
                        }
                      }
                    }
                    if (weight > available) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(_t(
                                'الرصيد غير كافٍ لهذا العيار والنوع',
                                'Insufficient balance for this carat and type'))),
                      );
                      return;
                    }
                    await FS.withdrawSafeGold(
                      goldType: goldType,
                      carat: caratDouble,
                      weight: weight,
                      note: noteController.text.isNotEmpty
                          ? noteController.text
                          : null,
                    );
                  }
                  Navigator.pop(context);
                  _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        mode == 'deposit'
                            ? _t('تم إيداع الذهب بنجاح',
                                'Gold deposited successfully')
                            : _t('تم سحب الذهب بنجاح',
                                'Gold withdrawn successfully'),
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(
                mode == 'deposit'
                    ? _t('إيداع', 'Deposit')
                    : _t('سحب', 'Withdraw'),
                style: TextStyle(
                    color: mode == 'deposit' ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // دوال صندوق اليومي
  // =========================================================================

  void _showOpenFloatDialog() {
    final cashController = TextEditingController();
    final networkController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('فتح عهدة جديدة', 'Open New Float'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _t('تخصص العهدة من الخزنة وتضاف لصندوق اليومي.',
                      'Float is taken from safe and added to daily box.'),
                  style: const TextStyle(color: kTextSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                _darkField(
                  controller: cashController,
                  keyboardType: TextInputType.number,
                  label: _t('نقدي (ر.س)', 'Cash (SAR)'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: networkController,
                  keyboardType: TextInputType.number,
                  label: _t('شبكة (ر.س)', 'Network (SAR)'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_t('إجمالي العهدة', 'Total Float'),
                        style: const TextStyle(color: Colors.white70)),
                    ValueListenableBuilder(
                      valueListenable: cashController,
                      builder: (_, __, ___) {
                        final cash = double.tryParse(cashController.text) ?? 0;
                        final network =
                            double.tryParse(networkController.text) ?? 0;
                        return Text(
                          'ر.س ${(cash + network).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kGold),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final cash = double.tryParse(cashController.text) ?? 0.0;
                final network = double.tryParse(networkController.text) ?? 0.0;
                if (cash <= 0 && network <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('يجب إدخال مبلغ في أحد الحقلين')),
                  );
                  return;
                }

                try {
                  final safeBal = await FS.getCashBoxBalance();
                  if (cash > safeBal['cash']!) {
                    throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
                  }
                  if (network > safeBal['network']!) {
                    throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
                  }

                  if (cash > 0) {
                    await FS.deductFromCashBox(
                      amount: cash,
                      method: 'cash',
                      note: 'فتح عهدة صندوق يومي',
                    );
                  }
                  if (network > 0) {
                    await FS.deductFromCashBox(
                      amount: network,
                      method: 'network',
                      note: 'فتح عهدة صندوق يومي',
                    );
                  }

                  if (cash > 0) {
                    await FS.addToDailyBox(
                      amount: cash,
                      method: 'cash',
                      note: noteController.text.isNotEmpty
                          ? noteController.text
                          : 'فتح عهدة',
                      type: 'float_open',
                    );
                  }
                  if (network > 0) {
                    await FS.addToDailyBox(
                      amount: network,
                      method: 'network',
                      note: noteController.text.isNotEmpty
                          ? noteController.text
                          : 'فتح عهدة',
                      type: 'float_open',
                    );
                  }

                  Navigator.pop(context);
                  await _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(_t('تم فتح العهدة بنجاح',
                            'Float opened successfully'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('فتح العهدة', 'Open Float'),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showExpenseDialog() {
    String method = 'cash';
    String selectedCategory = expenseCategories.first;
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('تسجيل مصروف', 'Record Expense'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: kFieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      dropdownColor: kCard,
                      iconEnabledColor: kGold,
                      style: const TextStyle(color: Colors.white),
                      items: expenseCategories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) =>
                          setDialogState(() => selectedCategory = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kRed,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                try {
                  await FS.deductFromDailyBox(
                    amount: amount,
                    method: method,
                    category: selectedCategory,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : null,
                    type: 'expense',
                  );
                  Navigator.pop(context);
                  await _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(_t('تم تسجيل المصروف', 'Expense recorded'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('حفظ', 'Save'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDepositDialog() {
    String method = 'cash';
    String selectedCategory = depositCategories.first;
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('تسجيل إيداع', 'Record Deposit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: kFieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      dropdownColor: kCard,
                      iconEnabledColor: kGold,
                      style: const TextStyle(color: Colors.white),
                      items: depositCategories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) =>
                          setDialogState(() => selectedCategory = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                try {
                  await FS.addToDailyBox(
                    amount: amount,
                    method: method,
                    category: selectedCategory,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : null,
                    type: 'deposit',
                  );
                  Navigator.pop(context);
                  await _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(_t('تم تسجيل الإيداع', 'Deposit recorded'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('حفظ', 'Save'),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPartialTransferToSafeDialog() {
    String method = 'cash';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer to Safe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 12),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }
                try {
                  await FS.deductFromDailyBox(
                    amount: amount,
                    method: method,
                    note: noteController.text.isNotEmpty
                        ? noteController.text
                        : 'تحويل للخزنة',
                    type: 'transfer_to_safe',
                  );
                  await FS.addToCashBox(
                    amount: amount,
                    method: method,
                    note: 'تحويل من الصندوق اليومي',
                  );
                  Navigator.pop(context);
                  await _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(_t('تم التحويل', 'Transfer completed'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('تحويل', 'Transfer'),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEndOfDayTransfer() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: kCardBorder),
        ),
        title: Text(_t('توريد نهاية اليوم', 'End-of-Day Transfer'),
            style: const TextStyle(color: Colors.white)),
        content: Text(
          _t('سيتم تحويل كامل رصيد الصندوق اليومي إلى الخزنة وإعادة تعيينه.',
              'All daily box balance will be transferred to safe and reset.'),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('إلغاء', 'Cancel'),
                style: const TextStyle(color: kTextSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('تأكيد', 'Confirm'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final balance = await FS.getDailyBoxBalance();
      double cash = balance['cash']!;
      double network = balance['network']!;

      if (cash > 0) {
        await FS.addToCashBox(
          amount: cash,
          method: 'cash',
          note: 'توريد نهاية اليوم (نقدي)',
        );
      }
      if (network > 0) {
        await FS.addToCashBox(
          amount: network,
          method: 'network',
          note: 'توريد نهاية اليوم (شبكة)',
        );
      }

      if (cash > 0) {
        await FS.deductFromDailyBox(
          amount: cash,
          method: 'cash',
          note: 'توريد نهاية اليوم',
          type: 'end_of_day_transfer',
        );
      }
      if (network > 0) {
        await FS.deductFromDailyBox(
          amount: network,
          method: 'network',
          note: 'توريد نهاية اليوم',
          type: 'end_of_day_transfer',
        );
      }

      await FS.resetDailyBox();

      await _loadAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_t('تم توريد نهاية اليوم بنجاح',
                'End-of-day transfer completed'))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  // =========================================================================
  // دوال صندوق الكسر
  // =========================================================================

  void _showFundScrapDialog() {
    String source = 'daily'; // 'daily' or 'safe'
    String method = 'cash';
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => _darkDialogShell(
          title: _t('تمويل العهدة', 'Fund Float'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اختيار المصدر
                _segmentedToggle(
                  options: [
                    MapEntry('daily', _t('صندوق اليومي', 'Daily Box')),
                    MapEntry('safe', _t('الخزنة', 'Safe')),
                  ],
                  value: source,
                  onChanged: (val) => setDialogState(() => source = val),
                ),
                const SizedBox(height: 16),
                // طريقة الدفع
                _segmentedToggle(
                  options: [
                    const MapEntry('cash', 'نقدي'),
                    const MapEntry('network', 'شبكة'),
                  ],
                  value: method,
                  onChanged: (val) => setDialogState(() => method = val),
                ),
                const SizedBox(height: 16),
                _darkField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: _t('المبلغ', 'Amount'),
                  prefixText: 'ر.س ',
                ),
                const SizedBox(height: 14),
                _darkField(
                  controller: noteController,
                  label: _t('ملاحظة (اختياري)', 'Note (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t('إلغاء', 'Cancel'),
                  style: const TextStyle(color: kTextSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('المبلغ يجب أن يكون أكبر من صفر')),
                  );
                  return;
                }

                try {
                  // التحقق من الرصيد في المصدر وخصم
                  if (source == 'daily') {
                    final dailyBal = await FS.getDailyBoxBalance();
                    if (method == 'cash' && amount > dailyBal['cash']!) {
                      throw Exception(
                          'الرصيد النقدي في الصندوق اليومي غير كافٍ');
                    }
                    if (method == 'network' && amount > dailyBal['network']!) {
                      throw Exception('رصيد الشبكة في الصندوق اليومي غير كافٍ');
                    }
                    await FS.deductFromDailyBox(
                      amount: amount,
                      method: method,
                      note: 'تمويل صندوق الكسر',
                      type: 'fund_scrap',
                    );
                  } else if (source == 'safe') {
                    final safeBal = await FS.getCashBoxBalance();
                    if (method == 'cash' && amount > safeBal['cash']!) {
                      throw Exception('الرصيد النقدي في الخزنة غير كافٍ');
                    }
                    if (method == 'network' && amount > safeBal['network']!) {
                      throw Exception('رصيد الشبكة في الخزنة غير كافٍ');
                    }
                    await FS.deductFromCashBox(
                      amount: amount,
                      method: method,
                      note: 'تمويل صندوق الكسر',
                    );
                  }

                  // إضافة إلى صندوق الكسر باستخدام scrapCol().add()
                  await FS.scrapCol().add({
                    'cash': method == 'cash' ? amount : 0.0,
                    'network': method == 'network' ? amount : 0.0,
                    'type': 'fund',
                    'date': DateTime.now(),
                    'notes': noteController.text.isNotEmpty
                        ? noteController.text
                        : 'تمويل من ${source == 'daily' ? 'صندوق اليومي' : 'الخزنة'}',
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                  await _loadAllData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(_t('تم تمويل صندوق الكسر بنجاح',
                            'Scrap box funded successfully'))),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ: $e')),
                  );
                }
              },
              child: Text(_t('تمويل', 'Fund'),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  /// إقفال صندوق الكسر (تحويل الرصيد التراكمي بالكامل إلى الخزنة وتصفيره)
  void _closeScrapBox() async {
    // نأخذ الرصيد الحالي من المتغيرات (المحدثة)
    final cash = scrapCash;
    final network = scrapNetwork;
    final gold = scrapGold24K;

    if (cash == 0 && network == 0 && gold == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_t('لا يوجد رصيد لإقفاله', 'No balance to close'))),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: kCardBorder),
        ),
        title: Text(
            _t('إقفال صندوق الكسر وتوريده للخزنة',
                'Close Scrap Box and Transfer to Safe'),
            style: const TextStyle(color: Colors.white)),
        content: Text(
          _t('سيتم تحويل كامل الرصيد (نقدي، شبكة، وذهب) إلى الخزنة، ثم تصفير الصندوق.',
              'All balance (cash, network, gold) will be transferred to safe and reset.'),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('إلغاء', 'Cancel'),
                style: const TextStyle(color: kTextSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('تأكيد', 'Confirm'),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      // 1. تحويل النقدي والشبكة إلى الخزنة
      if (cash > 0) {
        await FS.addToCashBox(
          amount: cash,
          method: 'cash',
          note: 'إقفال صندوق الكسر (نقدي)',
        );
      }
      if (network > 0) {
        await FS.addToCashBox(
          amount: network,
          method: 'network',
          note: 'إقفال صندوق الكسر (شبكة)',
        );
      }

      // 2. تحويل الذهب إلى الخزنة (كخام عيار 24)
      if (gold > 0) {
        await FS.depositSafeGold(
          goldType: 'raw',
          carat: 24,
          weight: gold,
          note: 'إقفال صندوق الكسر (ذهب)',
        );
      }

      // 3. تسجيل حركة إقفال سالبة في scrap لتصفير الرصيد
      await FS.scrapCol().add({
        'cash': -cash,
        'network': -network,
        'gold24K': -gold, // سالب لتصفير الوزن
        'type': 'close',
        'date': DateTime.now(),
        'notes': 'إقفال صندوق الكسر',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4. إعادة تحميل البيانات (سيصبح الرصيد صفراً)
      await _loadAllData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(_t('تم إقفال صندوق الكسر بنجاح',
                'Scrap box closed successfully'))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء الإقفال: $e')),
      );
    }
  }

  // =========================================================================
  // بناء واجهة صندوق اليومي
  // =========================================================================
  Widget _buildDailyBoxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('رصيد صندوق اليومي', 'Daily Box Balance'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 18),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ر.س',
                          style: TextStyle(
                              fontSize: 16,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: (dailyCash + dailyNetwork).toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('شبكة', 'Network'),
                            amount: dailyNetwork)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('نقدي', 'Cash'), amount: dailyCash)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _pillButton(
                      label: _t('مصروف', 'Expense'),
                      icon: Icons.remove_circle,
                      color: kRed,
                      filled: true,
                      expanded: true,
                      onPressed: _showExpenseDialog,
                    ),
                    _pillButton(
                      label: _t('إيداع', 'Deposit'),
                      icon: Icons.add_circle,
                      color: kGreen,
                      filled: true,
                      expanded: true,
                      onPressed: _showDepositDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: _pillButton(
                    label: _t('توريد نهاية اليوم للخزنة (كامل الرصيد)',
                        'End-of-Day Transfer to Safe (Full Balance)'),
                    icon: Icons.payments,
                    color: kGold,
                    filled: true,
                    expanded: false,
                    onPressed: _showEndOfDayTransfer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('عهدة الصندوق اليومي', 'Daily Box Float'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _t(
                    'سلم عهدة ابتدائية من الخزنة لمن يقف على الصندوق. وعند نهاية الوردية اجرد الدرج فعلياً وسجل الفرق.',
                    'An initial float is given from the safe to the cashier. At the end of shift, count the actual drawer and record the difference.',
                  ),
                  style: const TextStyle(color: kTextSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kFieldFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(_t('نقدي', 'Cash'),
                              style: const TextStyle(
                                  color: kTextSecondary, fontSize: 12)),
                          Text('ر.س ${dailyFloatCash.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(width: 1, height: 30, color: kCardBorder),
                      Column(
                        children: [
                          Text(_t('شبكة', 'Network'),
                              style: const TextStyle(
                                  color: kTextSecondary, fontSize: 12)),
                          Text('ر.س ${dailyFloatNetwork.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _pillButton(
                      label: _t('فتح عهدة جديدة', 'Open New Float'),
                      icon: Icons.add,
                      color: kGold,
                      filled: true,
                      expanded: true,
                      onPressed: _showOpenFloatDialog,
                    ),
                    _pillButton(
                      label: _t('تحويل جزئي إلى الخزنة', 'Partial Transfer'),
                      icon: Icons.swap_horiz,
                      color: kGold,
                      filled: false,
                      expanded: true,
                      onPressed: _showPartialTransferToSafeDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (dailyTransactions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _darkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('آخر الحركات', 'Recent Transactions'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  ...dailyTransactions.take(10).map((t) {
                    final type = t['type'] ?? '';
                    final method = t['method'] ?? '';
                    final amount = (t['amount'] ?? 0).toDouble();
                    final category = t['category'] ?? '';
                    final note = t['note'] ?? '';
                    final isAdd = (type == 'float_open' || type == 'deposit');
                    final color = isAdd ? kGreen : kRed;
                    final icon = isAdd ? Icons.add_circle : Icons.remove_circle;
                    final typeLabel = {
                          'float_open': _t('فتح عهدة', 'Open Float'),
                          'deposit': _t('إيداع', 'Deposit'),
                          'expense': _t('مصروف', 'Expense'),
                          'transfer_to_safe':
                              _t('تحويل للخزنة', 'Transfer to Safe'),
                          'end_of_day_transfer':
                              _t('توريد نهاية اليوم', 'End of Day'),
                        }[type] ??
                        type;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(icon, color: color),
                      title: Text(
                        '$typeLabel - ${method == 'cash' ? 'نقدي' : 'شبكة'}',
                        style: const TextStyle(
                            fontSize: 13.5, color: Colors.white),
                      ),
                      subtitle: Text(
                        category.isNotEmpty ? '$category | $note' : note,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 11.5),
                      ),
                      trailing: Text(
                        '${isAdd ? '+' : '-'}ر.س ${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // بناء واجهة الخزنة
  // =========================================================================
  Widget _buildSafeBoxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('الإجمالي', 'Total'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 18),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ر.س',
                          style: TextStyle(
                              fontSize: 16,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: (safeCash + safeNetwork).toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('نقدي', 'Cash'), amount: safeCash)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('شبكة', 'Network'), amount: safeNetwork)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _pillButton(
                      label: _t('سحب', 'Withdraw'),
                      icon: Icons.arrow_upward,
                      color: kRed,
                      filled: false,
                      onPressed: _showWithdrawCashDialog,
                    ),
                    _pillButton(
                      label: _t('إيداع ', 'Manual Deposit'),
                      icon: Icons.arrow_downward,
                      color: kGreen,
                      filled: true,
                      onPressed: _showDepositCashDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('الذهب المحفوظ بالخزنة', 'Gold in Safe'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kFieldFill,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('الإجمالي محوّلًا لعيار 24',
                            'Total converted to 24K'),
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12.5),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${goldTotal24K.toStringAsFixed(2)} ${_t('جم', 'g')}',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kGold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_t('الوزن الفعلي', 'Actual')} ${goldTotalActual.toStringAsFixed(2)} ${_t('جم', 'g')} '
                        '· ${_t('كسر', 'Scrap')} ${goldScrapWeight.toStringAsFixed(2)} '
                        '· ${_t('مشغول', 'Worked')} ${goldWorkedWeight.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (goldTransactions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('آخر العمليات', 'Recent Transactions'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      ...goldTransactions.take(5).map((t) {
                        final isDeposit = t['type'] == 'deposit';
                        final weight = (t['weight'] ?? 0.0).toDouble();
                        final carat = (t['carat'] ?? 24).toDouble();
                        final type = t['goldType'] == 'raw'
                            ? _t('خام', 'Raw')
                            : _t('مشغول', 'Worked');
                        final date = (t['date'] as Timestamp?)?.toDate();
                        final dateStr = date != null
                            ? '${date.day}/${date.month}/${date.year}'
                            : '';
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: Icon(
                            isDeposit ? Icons.add_circle : Icons.remove_circle,
                            color: isDeposit ? kGreen : kRed,
                          ),
                          title: Text(
                            '${isDeposit ? _t('إيداع', 'Deposit') : _t('سحب', 'Withdraw')} - $type $carat K',
                            style: const TextStyle(
                                fontSize: 13.5, color: Colors.white),
                          ),
                          subtitle: Text(dateStr,
                              style: const TextStyle(
                                  color: kTextSecondary, fontSize: 11.5)),
                          trailing: Text(
                            '${isDeposit ? '+' : '-'}${weight.toStringAsFixed(2)} جم',
                            style: TextStyle(
                              color: isDeposit ? kGreen : kRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _t('لا يوجد ذهب بالخزنة', 'No gold in safe'),
                        style: const TextStyle(color: kTextSecondary),
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _pillButton(
                      label: _t('سحب', 'Withdraw'),
                      icon: Icons.arrow_downward,
                      color: kRed,
                      filled: false,
                      onPressed: _showGoldWithdrawDialog,
                    ),
                    _pillButton(
                      label: _t('إيداع', 'Deposit'),
                      icon: Icons.arrow_upward,
                      color: kGreen,
                      filled: true,
                      onPressed: _showGoldDepositDialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // بناء واجهة صندوق الكسر (مطابق للصورة مع البيانات المحسوبة)
  // =========================================================================
  Widget _buildScrapBoxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ تم حذف Row الذي يحتوي على الوزن
                Text(
                  _t('صندوق الكسر', 'Scrap Box'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 18),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ر.س',
                          style: TextStyle(
                              fontSize: 16,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w500),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                          text: (scrapCash + scrapNetwork).toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('نقدي', 'Cash'), amount: scrapCash)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildBalanceItem(
                            label: _t('شبكة', 'Network'),
                            amount: scrapNetwork)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _pillButton(
                    label: _t('إقفال صندوق الكسر وتوريده للخزنة',
                        'Close Scrap Box and Transfer to Safe'),
                    icon: Icons.lock_clock,
                    color: kRed,
                    filled: true,
                    expanded: false,
                    onPressed: _closeScrapBox,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _darkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('تمويل العهدة', 'Fund Float'),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _pillButton(
                      label: _t('تمويل', 'Fund'),
                      icon: Icons.add,
                      color: kGold,
                      filled: true,
                      expanded: true,
                      onPressed: _showFundScrapDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _t('اختر المصدر (صندوق اليومي أو الخزنة) وطريقة الدفع',
                      'Choose source (Daily Box or Safe) and payment method'),
                  style: const TextStyle(color: kTextSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          if (scrapTransactions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _darkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('آخر الحركات', 'Recent Transactions'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  ...scrapTransactions.take(10).map((t) {
                    final type = t['type'] ?? '';
                    final amount = (t['amount'] ?? 0.0).toDouble();
                    final isPositive = amount >= 0;
                    final color = isPositive ? kGreen : kRed;
                    final icon =
                        isPositive ? Icons.add_circle : Icons.remove_circle;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(icon, color: color),
                      title: Text(
                        type,
                        style: const TextStyle(
                            fontSize: 13.5, color: Colors.white),
                      ),
                      subtitle: Text(
                        (t['data']?['notes'] ?? '') as String? ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: kTextSecondary, fontSize: 11.5),
                      ),
                      trailing: Text(
                        '${isPositive ? '+' : ''}ر.س ${amount.abs().toStringAsFixed(0)}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // عناصر تصميم مشتركة
  // =========================================================================

  Widget _segmentedToggle({
    required List<MapEntry<String, String>> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: options.map((opt) {
        final selected = opt.key == value;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(opt.key),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? kGold.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: selected ? kGold : kCardBorder, width: 1.2),
              ),
              child: Text(
                opt.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? kGold : Colors.white70,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _darkField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? prefixText,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: kGold, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: kFieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGold, width: 1.4),
        ),
      ),
    );
  }

  Widget _pillButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool filled = true,
    IconData? icon,
    bool expanded = true,
  }) {
    Widget btn = filled
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null
                ? Icon(icon, size: 18, color: Colors.black)
                : const SizedBox.shrink(),
            label: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon != null
                ? Icon(icon, size: 18, color: color)
                : const SizedBox.shrink(),
            label: Text(label,
                style: TextStyle(fontWeight: FontWeight.bold, color: color)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: color.withOpacity(0.6)),
              backgroundColor: color.withOpacity(0.08),
              minimumSize: const Size(0, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          );

    return expanded
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: btn,
            ),
          )
        : btn;
  }

  Widget _darkCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kCardBorder),
      ),
      child: child,
    );
  }

  Widget _darkDialogShell({
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return AlertDialog(
      backgroundColor: kCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kCardBorder),
      ),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      content: content,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: actions,
    );
  }

  Widget _buildBalanceItem({
    required String label,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: kFieldFill,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: kTextSecondary, fontSize: 12.5)),
          const SizedBox(height: 6),
          Text(
            'ر.س${amount.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // الواجهة الرئيسية
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(_t('الصندوق', 'Cash Box')),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.black.withOpacity(0.28),
                  borderRadius: BorderRadius.circular(30),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: _t('صندوق الكسر', 'Scrap Box')),
                  Tab(text: _t('صندوق اليومي', 'Daily Box')),
                  Tab(text: _t('الخزنة', 'Safe Box')),
                ],
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: kGold))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildScrapBoxTab(),
                _buildDailyBoxTab(),
                _buildSafeBoxTab(),
              ],
            ),
    );
  }
}
