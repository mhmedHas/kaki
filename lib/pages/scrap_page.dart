// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import '../services/firestore_service.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class ScrapPage extends StatefulWidget {
// //   const ScrapPage({super.key});

// //   @override
// //   State<ScrapPage> createState() => _ScrapPageState();
// // }

// // class _ScrapPageState extends State<ScrapPage> {
// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   void _openPart(Widget part) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (_) => part),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("الكسر", "Scrap")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           children: [
// //             _buildMenuCard(
// //                 icon: Icons.shopping_cart,
// //                 label: _t("شراء", "Buy"),
// //                 page: const ScrapAddForm()),
// //             const SizedBox(height: 20),
// //             _buildMenuCard(
// //                 icon: Icons.sell,
// //                 label: _t("بيع", "Sell"),
// //                 page: const ScrapSaleForm()),
// //             const SizedBox(height: 20),
// //             _buildMenuCard(
// //                 icon: Icons.bar_chart,
// //                 label: _t("التقارير", "Reports"),
// //                 page: const ScrapReports()),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMenuCard(
// //       {required IconData icon, required String label, required Widget page}) {
// //     return GestureDetector(
// //       onTap: () => _openPart(page),
// //       child: Card(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         elevation: 4,
// //         color: const Color(0xFFD4AF37).withOpacity(0.9),
// //         child: Container(
// //           width: double.infinity,
// //           height: 100,
// //           padding: const EdgeInsets.all(16),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Icon(icon, size: 48, color: Colors.white),
// //               const SizedBox(width: 16),
// //               Text(label,
// //                   style: const TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white)),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ScrapAddForm extends StatefulWidget {
// //   const ScrapAddForm({super.key});

// //   @override
// //   State<ScrapAddForm> createState() => _ScrapAddFormState();
// // }

// // class _ScrapAddFormState extends State<ScrapAddForm> {
// //   String carat = "18";
// //   final weight = TextEditingController();
// //   final cash = TextEditingController();
// //   final network = TextEditingController();
// //   String paymentType = "كاش";
// //   DateTime date = DateTime.now();
// //   final notes = TextEditingController();

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   Future<void> _save() async {
// //     if (weight.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(_t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight")),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     double cashVal = 0;
// //     double netVal = 0;

// //     if (paymentType == "كاش") {
// //       cashVal = double.tryParse(cash.text) ?? 0;
// //     } else if (paymentType == "شبكة") {
// //       netVal = double.tryParse(network.text) ?? 0;
// //     } else if (paymentType == "متعدد") {
// //       cashVal = double.tryParse(cash.text) ?? 0;
// //       netVal = double.tryParse(network.text) ?? 0;
// //     }

// //     double total = cashVal + netVal;

// //     if (cashVal == 0 && netVal == 0) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content:
// //               Text(_t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter the amount")),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     await FS.saveScrapAdd({
// //       "carat": carat,
// //       "weight": double.tryParse(weight.text) ?? 0,
// //       "person": paymentType, // نوع الدفع
// //       "cash": cashVal,
// //       "network": netVal,
// //       "total": total,
// //       "date": date,
// //       "notes": notes.text.trim(),
// //       "type": "add", // ✅ مهم للتقارير
// //     });
// //     //if (!mounted) return;

// //     setState(() {
// //       weight.clear();
// //       cash.clear();
// //       network.clear();
// //       notes.clear();
// //       //carat = '18';
// //       paymentType = 'كاش';
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //           content: Text(_t("✅ تم تسجيل عملية الشراء بنجاح",
// //               "✅ Purchase saved successfully"))),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final df = DateFormat("yyyy-MM-dd");
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("شراء كسر", "Buy Scrap")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: ListView(
// //           children: [
// //             DropdownButtonFormField(
// //               initialValue: carat,
// //               items: ["14", "18", "21", "22", "24"]
// //                   .map((e) => DropdownMenuItem(
// //                       value: e, child: Text("${_t("عيار", "Carat")} $e")))
// //                   .toList(),
// //               onChanged: (v) => setState(() => carat = v ?? "18"),
// //               decoration: InputDecoration(labelText: _t("العيار", "Carat")),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: weight,
// //               decoration:
// //                   InputDecoration(labelText: _t("الوزن (جم)", "Weight (g)")),
// //               keyboardType: TextInputType.number,
// //             ),
// //             const SizedBox(height: 12),
// //             DropdownButtonFormField(
// //               initialValue: paymentType,
// //               items: ["كاش", "شبكة", "متعدد"]
// //                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                   .toList(),
// //               onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
// //               decoration:
// //                   InputDecoration(labelText: _t("طريقة الدفع", "Payment Type")),
// //             ),
// //             const SizedBox(height: 12),
// //             if (paymentType == "كاش" || paymentType == "متعدد")
// //               TextField(
// //                 controller: cash,
// //                 decoration: InputDecoration(
// //                   labelText: _t("المبلغ كاش", "Cash Amount"),
// //                   prefixIcon: Icon(Icons.money, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.all(Radius.circular(12)),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.number,
// //               ),
// //             if (paymentType == "متعدد") const SizedBox(height: 12),
// //             if (paymentType == "شبكة" || paymentType == "متعدد")
// //               TextField(
// //                 controller: network,
// //                 decoration: InputDecoration(
// //                   labelText: _t("المبلغ شبكة", "Card Amount"),
// //                   prefixIcon: Icon(Icons.credit_card, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.all(Radius.circular(12)),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.number,
// //               ),
// //             const SizedBox(height: 16),
// //             TextField(
// //               controller: notes,
// //               maxLines: 3,
// //               decoration: InputDecoration(
// //                 labelText: _t('ملاحظات', 'Notes'),
// //                 prefixIcon: Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.all(Radius.circular(12)),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             ListTile(
// //               title: Text("${_t("التاريخ", "Date")}: ${df.format(date)}"),
// //               trailing: IconButton(
// //                 icon: const Icon(Icons.date_range),
// //                 onPressed: () async {
// //                   final d = await showDatePicker(
// //                     context: context,
// //                     initialDate: date,
// //                     firstDate: DateTime(2000),
// //                     lastDate: DateTime(2100),
// //                   );
// //                   if (d != null) setState(() => date = d);
// //                 },
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: _save,
// //               child: Text(_t("حفظ", "Save")),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ScrapSaleForm extends StatefulWidget {
// //   const ScrapSaleForm({super.key});

// //   @override
// //   State<ScrapSaleForm> createState() => _ScrapSaleFormState();
// // }

// // class _ScrapSaleFormState extends State<ScrapSaleForm> {
// //   final weight = TextEditingController();
// //   final cash = TextEditingController();
// //   final network = TextEditingController();
// //   DateTime date = DateTime.now();
// //   String carat = "18";
// //   String paymentType = "كاش"; // 👈 نوع الدفع
// //   final notes = TextEditingController();

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   Future<void> _save() async {
// //     if (weight.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(_t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight")),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     // تحديد المبالغ حسب نوع الدفع
// //     double cashVal = 0;
// //     double netVal = 0;

// //     if (paymentType == "كاش") {
// //       cashVal = double.tryParse(cash.text) ?? 0;
// //     } else if (paymentType == "شبكة") {
// //       netVal = double.tryParse(network.text) ?? 0;
// //     } else if (paymentType == "متعدد") {
// //       cashVal = double.tryParse(cash.text) ?? 0;
// //       netVal = double.tryParse(network.text) ?? 0;
// //     }

// //     double total = cashVal + netVal;

// //     if (cashVal == 0 && netVal == 0) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content:
// //               Text(_t("⚠️ من فضلك أدخل قيمة المبلغ", "⚠️ Please enter amount")),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //       return;
// //     }

// //     await FS.saveScrapSale({
// //       "carat": carat,
// //       "person": paymentType,
// //       "notes": notes.text.trim(),
// //       "weight": double.tryParse(weight.text) ?? 0,
// //       "cash": cashVal,
// //       "network": netVal,
// //       "total": total,
// //       "date": date,
// //       "type": "sale",
// //     });

// //     setState(() {
// //       weight.clear();
// //       cash.clear();
// //       network.clear();
// //       notes.clear();
// //       //carat = '18';
// //       paymentType = 'كاش';
// //     });

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //           content:
// //               Text(_t("✅ تم تسجيل البيع بنجاح", "✅ Sale saved successfully"))),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final df = DateFormat("yyyy-MM-dd");
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("بيع كسر", "Sell Scrap")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: ListView(
// //           children: [
// //             DropdownButtonFormField(
// //               initialValue: carat,
// //               items: ["14", "18", "21", "22", "24"]
// //                   .map((e) => DropdownMenuItem(
// //                       value: e, child: Text("${_t("عيار", "Carat")} $e")))
// //                   .toList(),
// //               onChanged: (v) => setState(() => carat = v ?? "18"),
// //               decoration: InputDecoration(labelText: _t("العيار", "Carat")),
// //             ),
// //             const SizedBox(height: 12),
// //             TextField(
// //               controller: weight,
// //               decoration:
// //                   InputDecoration(labelText: _t("الوزن (جم)", "Weight (g)")),
// //               keyboardType: TextInputType.number,
// //             ),
// //             const SizedBox(height: 12),
// //             DropdownButtonFormField(
// //               initialValue: paymentType,
// //               items: ["كاش", "شبكة", "متعدد"]
// //                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                   .toList(),
// //               onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
// //               decoration:
// //                   InputDecoration(labelText: _t("طريقة الدفع", "Payment Type")),
// //             ),
// //             const SizedBox(height: 12),
// //             if (paymentType == "كاش" || paymentType == "متعدد")
// //               TextField(
// //                 controller: cash,
// //                 decoration: InputDecoration(
// //                   labelText: _t("المبلغ كاش", "Cash Amount"),
// //                   prefixIcon: Icon(Icons.money, color: const Color(0xFFD4AF37)),
// //                   border: const OutlineInputBorder(
// //                     borderRadius: BorderRadius.all(Radius.circular(12)),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.number,
// //               ),
// //             if (paymentType == "متعدد") const SizedBox(height: 12),
// //             if (paymentType == "شبكة" || paymentType == "متعدد")
// //               TextField(
// //                 controller: network,
// //                 decoration: InputDecoration(
// //                   labelText: _t("المبلغ شبكة", "Card Amount"),
// //                   prefixIcon:
// //                       Icon(Icons.credit_card, color: const Color(0xFFD4AF37)),
// //                   border: const OutlineInputBorder(
// //                     borderRadius: BorderRadius.all(Radius.circular(12)),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.number,
// //               ),
// //             const SizedBox(height: 16),
// //             TextField(
// //               controller: notes,
// //               maxLines: 3,
// //               decoration: InputDecoration(
// //                 labelText: _t('ملاحظات', 'Notes'),
// //                 prefixIcon: Icon(Icons.note, color: const Color(0xFFD4AF37)),
// //                 border: const OutlineInputBorder(
// //                   borderRadius: BorderRadius.all(Radius.circular(12)),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             ListTile(
// //               title: Text("${_t("التاريخ", "Date")}: ${df.format(date)}"),
// //               trailing: IconButton(
// //                 icon: const Icon(Icons.date_range),
// //                 onPressed: () async {
// //                   final d = await showDatePicker(
// //                     context: context,
// //                     initialDate: date,
// //                     firstDate: DateTime(2000),
// //                     lastDate: DateTime(2100),
// //                   );
// //                   if (d != null) setState(() => date = d);
// //                 },
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: _save,
// //               child: Text(_t("تسجيل البيع", "Save Sale")),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ScrapReports extends StatefulWidget {
// //   const ScrapReports({super.key});

// //   @override
// //   State<ScrapReports> createState() => _ScrapReportsState();
// // }

// // class _ScrapReportsState extends State<ScrapReports> {
// //   String query = ""; // 🔍 متغير البحث

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("تقارير الكسر", "Scrap Reports")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: Container(
// //         color: Colors.white,
// //         child: ListView(
// //           children: [
// //             StreamBuilder(
// //               stream: FS.scrapTransactionsStream(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 final txs = snapshot.data as List<Map<String, dynamic>>;

// //                 final totalByTypeAndCarat = {
// //                   "add": {
// //                     "14": 0.0,
// //                     "18": 0.0,
// //                     "21": 0.0,
// //                     "22": 0.0,
// //                     "24": 0.0
// //                   },
// //                   "sale": {
// //                     "14": 0.0,
// //                     "18": 0.0,
// //                     "21": 0.0,
// //                     "22": 0.0,
// //                     "24": 0.0
// //                   },
// //                   "payment": {
// //                     "14": 0.0,
// //                     "18": 0.0,
// //                     "21": 0.0,
// //                     "22": 0.0,
// //                     "24": 0.0
// //                   },
// //                   "transform": {
// //                     "14": 0.0,
// //                     "18": 0.0,
// //                     "21": 0.0,
// //                     "22": 0.0,
// //                     "24": 0.0
// //                   },
// //                 };

// //                 for (var t in txs) {
// //                   final type = t["type"];
// //                   final carat = t["carat"]?.toString() ?? "18";
// //                   final weight = (t["weight"] ?? 0).toDouble();

// //                   if (totalByTypeAndCarat.containsKey(type) &&
// //                       totalByTypeAndCarat[type]!.containsKey(carat)) {
// //                     final signedWeight = (type == "add" || type == "transform")
// //                         ? weight
// //                         : -weight;
// //                     totalByTypeAndCarat[type]![carat] =
// //                         (totalByTypeAndCarat[type]![carat]! + signedWeight);
// //                   }
// //                 }

// //                 final totalByCarat = {
// //                   "14": 0.0,
// //                   "18": 0.0,
// //                   "21": 0.0,
// //                   "22": 0.0,
// //                   "24": 0.0
// //                 };
// //                 totalByTypeAndCarat.forEach((type, carats) {
// //                   carats.forEach((carat, value) {
// //                     totalByCarat[carat] = totalByCarat[carat]! + value;
// //                   });
// //                 });

// //                 final totalBalance = totalByTypeAndCarat["add"]!["14"]! +
// //                     totalByTypeAndCarat["add"]!["18"]! +
// //                     totalByTypeAndCarat["add"]!["21"]! +
// //                     totalByTypeAndCarat["add"]!["22"]! +
// //                     totalByTypeAndCarat["add"]!["24"]! +
// //                     totalByTypeAndCarat["transform"]!["14"]! +
// //                     totalByTypeAndCarat["transform"]!["18"]! +
// //                     totalByTypeAndCarat["transform"]!["21"]! +
// //                     totalByTypeAndCarat["transform"]!["22"]! +
// //                     totalByTypeAndCarat["transform"]!["24"]! +
// //                     totalByTypeAndCarat["sale"]!["14"]! +
// //                     totalByTypeAndCarat["sale"]!["18"]! +
// //                     totalByTypeAndCarat["sale"]!["21"]! +
// //                     totalByTypeAndCarat["sale"]!["22"]! +
// //                     totalByTypeAndCarat["sale"]!["24"]! +
// //                     totalByTypeAndCarat["payment"]!["14"]! +
// //                     totalByTypeAndCarat["payment"]!["18"]! +
// //                     totalByTypeAndCarat["payment"]!["21"]! +
// //                     totalByTypeAndCarat["payment"]!["22"]! +
// //                     totalByTypeAndCarat["payment"]!["24"]!;

// //                 final kilos = totalBalance ~/ 1000;
// //                 final grams = (totalBalance % 1000).floor();
// //                 final milligrams =
// //                     ((totalBalance - totalBalance.floor()) * 1000).round();

// //                 return Card(
// //                   margin:
// //                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(16),
// //                     child: Column(
// //                       children: [
// //                         Text(_t("📊 ملخص الإجماليات", "📊 Summary Totals"),
// //                             style: const TextStyle(
// //                                 fontWeight: FontWeight.bold, fontSize: 18)),
// //                         const SizedBox(height: 12),
// //                         Table(
// //                           border: TableBorder.all(color: Colors.grey.shade300),
// //                           defaultVerticalAlignment:
// //                               TableCellVerticalAlignment.middle,
// //                           children: [
// //                             TableRow(
// //                               decoration:
// //                                   const BoxDecoration(color: Color(0xFFEFEFEF)),
// //                               children: [
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("العيار", "Carat"),
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("شراء", "Add"),
// //                                       textAlign: TextAlign.center,
// //                                       style:
// //                                           const TextStyle(color: Colors.green)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("بيع", "Sale"),
// //                                       textAlign: TextAlign.center,
// //                                       style:
// //                                           const TextStyle(color: Colors.blue)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("سند صرف", "Payment"),
// //                                       textAlign: TextAlign.center,
// //                                       style:
// //                                           const TextStyle(color: Colors.red)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("تحويل", "Transform"),
// //                                       textAlign: TextAlign.center,
// //                                       style: const TextStyle(
// //                                           color: Colors.orange)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(_t("إجمالي", "Total"),
// //                                       textAlign: TextAlign.center,
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold)),
// //                                 ),
// //                               ],
// //                             ),
// //                             ...["14", "18", "21", "22", "24"].map((carat) {
// //                               return TableRow(children: [
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text("${_t("عيار", "Carat")} $carat"),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(
// //                                       (totalByTypeAndCarat["add"]![carat]
// //                                               as num)
// //                                           .toStringAsFixed(1)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(
// //                                       (totalByTypeAndCarat["sale"]![carat]
// //                                               as num)
// //                                           .toStringAsFixed(1)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(
// //                                       (totalByTypeAndCarat["payment"]![carat]
// //                                               as num)
// //                                           .toStringAsFixed(1)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(
// //                                       (totalByTypeAndCarat["transform"]![carat]
// //                                               as num)
// //                                           .toStringAsFixed(1)),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.all(8.0),
// //                                   child: Text(
// //                                     "${(totalByCarat[carat] as num).round()}",
// //                                     style: const TextStyle(
// //                                         fontWeight: FontWeight.bold),
// //                                   ),
// //                                 ),
// //                               ]);
// //                             }),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),
// //                         Text(
// //                           "${_t("الرصيد الحالي", "Current Balance")}: $kilos ${_t("كيلو", "kg")}, $grams ${_t("جم", "g")}, $milligrams ${_t("ملي", "mg")}",
// //                           style: const TextStyle(
// //                               fontWeight: FontWeight.bold, fontSize: 16),
// //                         )
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.all(12.0),
// //               child: TextField(
// //                 decoration: InputDecoration(
// //                   labelText: _t("ابحث باسم الشخص", "Search by person name"),
// //                   prefixIcon: const Icon(Icons.search),
// //                   border: const OutlineInputBorder(),
// //                 ),
// //                 onChanged: (val) {
// //                   setState(() {
// //                     query = val.toLowerCase();
// //                   });
// //                 },
// //               ),
// //             ),
// //             StreamBuilder(
// //               stream: FS.scrapPersonsStream(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 final persons = snapshot.data as List<String>;
// //                 final filtered = persons
// //                     .where((p) => p.toLowerCase().contains(query))
// //                     .toList();

// //                 if (filtered.isEmpty) {
// //                   return Center(
// //                       child: Text(_t("لا يوجد نتائج", "No results found")));
// //                 }

// //                 return ListView.builder(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: filtered.length,
// //                   itemBuilder: (context, i) {
// //                     final personName = filtered[i];
// //                     return Card(
// //                       margin: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 6),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: ListTile(
// //                         leading: const CircleAvatar(
// //                           backgroundColor: Colors.blueAccent,
// //                           child: Icon(Icons.person, color: Colors.white),
// //                         ),
// //                         title: Text(
// //                           personName,
// //                           style: const TextStyle(
// //                               fontSize: 18, fontWeight: FontWeight.bold),
// //                         ),
// //                         /*trailing: PopupMenuButton<String>(
// //                           onSelected: (value) async {
// //                             if (value == "edit") {
// //                               final controller = TextEditingController(text: personName);
// //                               final newName = await showDialog<String>(
// //                                 context: context,
// //                                 builder: (_) {
// //                                   return AlertDialog(
// //                                     title: Text(_t("تعديل الاسم", "Edit Name")),
// //                                     content: TextField(
// //                                       controller: controller,
// //                                       decoration: InputDecoration(
// //                                         labelText: _t("الاسم الجديد", "New Name"),
// //                                       ),
// //                                     ),
// //                                     actions: [
// //                                       TextButton(
// //                                         onPressed: () => Navigator.pop(context),
// //                                         child: Text(_t("إلغاء", "Cancel")),
// //                                       ),
// //                                       ElevatedButton(
// //                                         onPressed: () => Navigator.pop(context, controller.text.trim()),
// //                                         child: Text(_t("حفظ", "Save")),
// //                                       ),
// //                                     ],
// //                                   );
// //                                 },
// //                               );
// //                               if (newName != null && newName.isNotEmpty) {
// //                                 await FS.updateScrapPerson(personName, newName);
// //                               }
// //                             } else if (value == "delete") {
// //                               final confirm = await showDialog<bool>(
// //                                 context: context,
// //                                 builder: (_) => AlertDialog(
// //                                   title: Text(_t("تأكيد الحذف", "Confirm Delete")),
// //                                   content: Text(_t(
// //                                       "هل تريد حذف $personName وكل معاملاته؟",
// //                                       "Do you want to delete $personName and all transactions?")),
// //                                   actions: [
// //                                     TextButton(
// //                                       onPressed: () => Navigator.pop(context, false),
// //                                       child: Text(_t("إلغاء", "Cancel")),
// //                                     ),
// //                                     ElevatedButton(
// //                                       onPressed: () => Navigator.pop(context, true),
// //                                       style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //                                       child: Text(_t("حذف", "Delete")),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               );
// //                               if (confirm == true) {
// //                                 await FS.deleteScrapPerson(personName);
// //                               }
// //                             }
// //                           },
// //                           itemBuilder: (context) => [
// //                             PopupMenuItem(value: "edit", child: Text(_t("تعديل", "Edit"))),
// //                             PopupMenuItem(value: "delete", child: Text(_t("حذف", "Delete"))),
// //                           ],
// //                         ),*/
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                                 builder: (_) =>
// //                                     ScrapPersonDetails(name: personName)),
// //                           );
// //                         },
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ScrapPersonDetails extends StatelessWidget {
// //   final String name;
// //   ScrapPersonDetails({super.key, required this.name});

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     _lang = prefs.getString('languageCode') ?? 'ar';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     _loadLanguage(); // تحميل اللغة
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("المعاملات مع $name", "Transactions with $name")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //       ),
// //       body: FutureBuilder(
// //         future: FS.getScrapTransactions(name),
// //         builder: (context, snapshot) {
// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           final txs = snapshot.data as List<Map<String, dynamic>>;

// //           if (txs.isEmpty) {
// //             return Center(
// //                 child: Text(_t("لا توجد معاملات بعد", "No transactions yet")));
// //           }

// //           final totalAdd = txs
// //               .where((t) => t["type"] == "add")
// //               .fold<double>(0, (sum, t) => sum + (t["weight"] ?? 0));
// //           final totalreceipt = txs
// //               .where((t) => t["type"] == "transform")
// //               .fold<double>(0, (sum, t) => sum + (t["weight"] ?? 0));
// //           final totalpayment = txs
// //               .where((t) => t["type"] == "payment")
// //               .fold<double>(0, (sum, t) => sum + (t["weight"] ?? 0));
// //           final totalSale = txs
// //               .where((t) => t["type"] == "sale")
// //               .fold<double>(0, (sum, t) => sum + (t["weight"] ?? 0));

// //           return Column(
// //             children: [
// //               Card(
// //                 margin: const EdgeInsets.all(12),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16),
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                           "${_t("إجمالي الشراء", "Total Add")}: $totalAdd ${_t("جم", "g")}",
// //                           style: const TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.green)),
// //                       Text(
// //                           "${_t("إجمالي البيع", "Total Sale")}: $totalSale ${_t("جم", "g")}",
// //                           style: const TextStyle(
// //                               fontWeight: FontWeight.bold, color: Colors.blue)),
// //                       Text(
// //                           "${_t("إجمالي سند الصرف", "Total Payment")}: $totalpayment ${_t("جم", "g")}",
// //                           style: const TextStyle(
// //                               fontWeight: FontWeight.bold, color: Colors.red)),
// //                       Text(
// //                           "${_t("إجمالي التحويل", "Total Transform")}: $totalreceipt ${_t("جم", "g")}",
// //                           style: const TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.orange)),
// //                       Text(
// //                         "${_t("الرصيد الحالي", "Current Balance")}: ${totalAdd + totalreceipt - (totalpayment + totalSale)} ${_t("جم", "g")}",
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.bold, fontSize: 16),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               const Divider(),
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: txs.length,
// //                   itemBuilder: (context, i) {
// //                     final t = txs[i];
// //                     final type = t['type'];
// //                     final weight = t['weight'] ?? 0;
// //                     final date = (t['date'] as Timestamp).toDate();
// //                     final formattedDate =
// //                         "${date.year}-${date.month}-${date.day}";

// //                     String title = "";
// //                     IconData icon = Icons.arrow_upward;
// //                     Color color = Colors.red;

// //                     if (type == "add") {
// //                       title = _t("شراء كسر", "Buy Scrap");
// //                       icon = Icons.arrow_downward;
// //                       color = Colors.green;
// //                     } else if (type == "sale") {
// //                       title = _t("بيع كسر", "Sell Scrap");
// //                       icon = Icons.arrow_upward;
// //                       color = Colors.blue;
// //                     } else if (type == "payment") {
// //                       title = _t("سند صرف", "Payment");
// //                       icon = Icons.receipt_long;
// //                       color = Colors.red;
// //                     } else if (type == "transform") {
// //                       title = _t("تحويل", "Transform");
// //                       icon = Icons.mail_rounded;
// //                       color = Colors.orange;
// //                     }

// //                     return Card(
// //                       margin: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 6),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: ListTile(
// //                         leading: Icon(icon, color: color),
// //                         title: Text(
// //                           title,
// //                           style: const TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                                 "${_t("الوزن", "Weight")}: $weight ${_t("جم", "g")}"),
// //                             if (t["carat"] != null)
// //                               Text("${_t("العيار", "Carat")}: ${t['carat']}"),
// //                             if (t["notes"] != null)
// //                               Text(
// //                                   "${_t("الملاحظات", "Notes")}: ${t['notes']}"),
// //                             Text("${_t("التاريخ", "Date")}: $formattedDate"),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ScrapPage extends StatefulWidget {
//   const ScrapPage({super.key});

//   @override
//   State<ScrapPage> createState() => _ScrapPageState();
// }

// class _ScrapPageState extends State<ScrapPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   void _openPart(Widget part) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => part),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _t("إدارة الكسر", "Scrap Management"),
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFFD4AF37).withOpacity(0.1),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               Text(
//                 _t("اختر العملية المطلوبة", "Choose Operation"),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 1.1,
//                   children: [
//                     _buildMenuCard(
//                       icon: Icons.shopping_cart,
//                       label: _t("شراء كسر", "Buy Scrap"),
//                       color: Colors.green,
//                       page: const ScrapAddForm(),
//                     ),
//                     _buildMenuCard(
//                       icon: Icons.sell,
//                       label: _t("بيع كسر", "Sell Scrap"),
//                       color: Colors.blue,
//                       page: const ScrapSaleForm(),
//                     ),
//                     // _buildMenuCard(
//                     //   icon: Icons.swap_horiz,
//                     //   label: _t("تحويل", "Transform"),
//                     //   color: Colors.orange,
//                     //   page: const ScrapTransformForm(),
//                     // ),
//                     _buildMenuCard(
//                       icon: Icons.bar_chart,
//                       label: _t("التقارير", "Reports"),
//                       color: Colors.purple,
//                       page: const ScrapReports(),
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

//   Widget _buildMenuCard({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required Widget page,
//   }) {
//     return GestureDetector(
//       onTap: () => _openPart(page),
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         shadowColor: color.withOpacity(0.3),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 color.withOpacity(0.15),
//                 color.withOpacity(0.05),
//               ],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, size: 40, color: color),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // نموذج شراء الكسر (محسّن)
// // ============================================================
// class ScrapAddForm extends StatefulWidget {
//   const ScrapAddForm({super.key});

//   @override
//   State<ScrapAddForm> createState() => _ScrapAddFormState();
// }

// class _ScrapAddFormState extends State<ScrapAddForm> {
//   final _formKey = GlobalKey<FormState>();
//   String carat = "18";
//   final weightController = TextEditingController();
//   final cashController = TextEditingController();
//   final networkController = TextEditingController();
//   final personController = TextEditingController();
//   final notesController = TextEditingController();
//   String paymentType = "كاش";
//   DateTime date = DateTime.now();
//   bool isLoading = false;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (weightController.text.isEmpty) {
//       _showSnackbar(
//           _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
//       return;
//     }

//     double cashVal = 0;
//     double netVal = 0;

//     if (paymentType == "كاش") {
//       cashVal = double.tryParse(cashController.text) ?? 0;
//     } else if (paymentType == "شبكة") {
//       netVal = double.tryParse(networkController.text) ?? 0;
//     } else if (paymentType == "متعدد") {
//       cashVal = double.tryParse(cashController.text) ?? 0;
//       netVal = double.tryParse(networkController.text) ?? 0;
//     }

//     double total = cashVal + netVal;

//     if (total == 0) {
//       _showSnackbar(
//           _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
//       return;
//     }

//     if (personController.text.trim().isEmpty) {
//       _showSnackbar(
//           _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
//           Colors.red);
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       await FS.saveScrapAdd({
//         "carat": carat,
//         "weight": double.tryParse(weightController.text) ?? 0,
//         "person": personController.text.trim(),
//         "paymentType": paymentType,
//         "cash": cashVal,
//         "network": netVal,
//         "total": total,
//         "date": date,
//         "notes": notesController.text.trim(),
//         "type": "add",
//         "createdAt": FieldValue.serverTimestamp(),
//       });

//       setState(() {
//         weightController.clear();
//         cashController.clear();
//         networkController.clear();
//         notesController.clear();
//         personController.clear();
//         paymentType = 'كاش';
//         carat = '18';
//         isLoading = false;
//       });

//       _showSnackbar(
//           _t("✅ تم تسجيل الشراء بنجاح", "✅ Purchase saved successfully"),
//           Colors.green);
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
//     }
//   }

//   void _showSnackbar(String msg, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat("yyyy-MM-dd");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("شراء كسر", "Buy Scrap")),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           if (isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Card(
//             elevation: 4,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle(_t("بيانات العملية", "Transaction Data"),
//                       Icons.info_outline),
//                   const SizedBox(height: 16),

//                   // اسم الشخص
//                   TextFormField(
//                     controller: personController,
//                     decoration: InputDecoration(
//                       labelText: _t("اسم الشخص", "Person Name"),
//                       hintText: _t("أدخل اسم العميل", "Enter client name"),
//                       prefixIcon:
//                           const Icon(Icons.person, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (v) => v!.trim().isEmpty
//                         ? _t("الاسم مطلوب", "Name is required")
//                         : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // العيار
//                   DropdownButtonFormField(
//                     value: carat,
//                     decoration: InputDecoration(
//                       labelText: _t("العيار", "Carat"),
//                       prefixIcon:
//                           const Icon(Icons.star, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     items: ["14", "18", "21", "22", "24"]
//                         .map((e) => DropdownMenuItem(
//                               value: e,
//                               child: Text("${_t("عيار", "Carat")} $e"),
//                             ))
//                         .toList(),
//                     onChanged: (v) => setState(() => carat = v ?? "18"),
//                   ),
//                   const SizedBox(height: 16),

//                   // الوزن
//                   TextFormField(
//                     controller: weightController,
//                     decoration: InputDecoration(
//                       labelText: _t("الوزن (جم)", "Weight (g)"),
//                       hintText:
//                           _t("أدخل الوزن بالجرام", "Enter weight in grams"),
//                       prefixIcon: const Icon(Icons.fitness_center,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (v) => v!.isEmpty
//                         ? _t("الوزن مطلوب", "Weight is required")
//                         : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // طريقة الدفع
//                   DropdownButtonFormField(
//                     value: paymentType,
//                     decoration: InputDecoration(
//                       labelText: _t("طريقة الدفع", "Payment Type"),
//                       prefixIcon:
//                           const Icon(Icons.payment, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     items: ["كاش", "شبكة", "متعدد"]
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
//                   ),
//                   const SizedBox(height: 16),

//                   // المبالغ
//                   if (paymentType == "كاش" || paymentType == "متعدد")
//                     TextFormField(
//                       controller: cashController,
//                       decoration: InputDecoration(
//                         labelText: _t("المبلغ كاش", "Cash Amount"),
//                         hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
//                         prefixIcon:
//                             const Icon(Icons.money, color: Colors.green),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   if (paymentType == "متعدد") const SizedBox(height: 12),
//                   if (paymentType == "شبكة" || paymentType == "متعدد")
//                     TextFormField(
//                       controller: networkController,
//                       decoration: InputDecoration(
//                         labelText: _t("المبلغ شبكة", "Card Amount"),
//                         hintText:
//                             _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
//                         prefixIcon:
//                             const Icon(Icons.credit_card, color: Colors.blue),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   const SizedBox(height: 16),

//                   // التاريخ
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: Text(
//                       "${_t("التاريخ", "Date")}: ${df.format(date)}",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.calendar_today,
//                           color: Color(0xFFD4AF37)),
//                       onPressed: () async {
//                         final d = await showDatePicker(
//                           context: context,
//                           initialDate: date,
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime(2030),
//                         );
//                         if (d != null) setState(() => date = d);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // ملاحظات
//                   TextFormField(
//                     controller: notesController,
//                     maxLines: 2,
//                     decoration: InputDecoration(
//                       labelText: _t('ملاحظات', 'Notes'),
//                       hintText:
//                           _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
//                       prefixIcon:
//                           const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // زر الحفظ
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : _save,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFD4AF37),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 3,
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               _t("💾 حفظ العملية", "💾 Save Transaction"),
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
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

//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: const Color(0xFFD4AF37), size: 22),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// // ============================================================
// // نموذج بيع الكسر (محسّن)
// // ============================================================
// class ScrapSaleForm extends StatefulWidget {
//   const ScrapSaleForm({super.key});

//   @override
//   State<ScrapSaleForm> createState() => _ScrapSaleFormState();
// }

// class _ScrapSaleFormState extends State<ScrapSaleForm> {
//   final _formKey = GlobalKey<FormState>();
//   final weightController = TextEditingController();
//   final cashController = TextEditingController();
//   final networkController = TextEditingController();
//   final personController = TextEditingController();
//   final notesController = TextEditingController();
//   String carat = "18";
//   String paymentType = "كاش";
//   DateTime date = DateTime.now();
//   bool isLoading = false;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<double> _getCurrentBalance(String carat) async {
//     try {
//       final txs = await FS.getScrapTransactionsByCarat(carat);
//       double balance = 0;
//       for (var t in txs) {
//         final type = t["type"];
//         final weight = (t["weight"] ?? 0).toDouble();
//         if (type == "add" || type == "transform") {
//           balance += weight;
//         } else if (type == "sale" || type == "payment") {
//           balance -= weight.abs();
//         }
//       }
//       return balance;
//     } catch (e) {
//       return 0;
//     }
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (weightController.text.isEmpty) {
//       _showSnackbar(
//           _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
//       return;
//     }

//     double weight = double.tryParse(weightController.text) ?? 0;

//     // التحقق من الرصيد
//     double balance = await _getCurrentBalance(carat);
//     if (weight > balance) {
//       _showSnackbar(
//         _t("⚠️ الرصيد غير كافٍ! المتوفر: $balance جم",
//             "⚠️ Insufficient balance! Available: $balance g"),
//         Colors.red,
//       );
//       return;
//     }

//     double cashVal = 0;
//     double netVal = 0;

//     if (paymentType == "كاش") {
//       cashVal = double.tryParse(cashController.text) ?? 0;
//     } else if (paymentType == "شبكة") {
//       netVal = double.tryParse(networkController.text) ?? 0;
//     } else if (paymentType == "متعدد") {
//       cashVal = double.tryParse(cashController.text) ?? 0;
//       netVal = double.tryParse(networkController.text) ?? 0;
//     }

//     double total = cashVal + netVal;

//     if (total == 0) {
//       _showSnackbar(
//           _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
//       return;
//     }

//     if (personController.text.trim().isEmpty) {
//       _showSnackbar(
//           _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
//           Colors.red);
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       await FS.saveScrapSale({
//         "carat": carat,
//         "weight": weight,
//         "person": personController.text.trim(),
//         "paymentType": paymentType,
//         "cash": cashVal,
//         "network": netVal,
//         "total": total,
//         "date": date,
//         "notes": notesController.text.trim(),
//         "type": "sale",
//         "createdAt": FieldValue.serverTimestamp(),
//       });

//       setState(() {
//         weightController.clear();
//         cashController.clear();
//         networkController.clear();
//         notesController.clear();
//         personController.clear();
//         paymentType = 'كاش';
//         carat = '18';
//         isLoading = false;
//       });

//       _showSnackbar(_t("✅ تم تسجيل البيع بنجاح", "✅ Sale saved successfully"),
//           Colors.green);
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
//     }
//   }

//   void _showSnackbar(String msg, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat("yyyy-MM-dd");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("بيع كسر", "Sell Scrap")),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           if (isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Card(
//             elevation: 4,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle(
//                       _t("بيانات البيع", "Sale Data"), Icons.info_outline),
//                   const SizedBox(height: 16),

//                   // اسم الشخص
//                   TextFormField(
//                     controller: personController,
//                     decoration: InputDecoration(
//                       labelText: _t("اسم الشخص", "Person Name"),
//                       hintText: _t("أدخل اسم العميل", "Enter client name"),
//                       prefixIcon:
//                           const Icon(Icons.person, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (v) => v!.trim().isEmpty
//                         ? _t("الاسم مطلوب", "Name is required")
//                         : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // العيار
//                   DropdownButtonFormField(
//                     value: carat,
//                     decoration: InputDecoration(
//                       labelText: _t("العيار", "Carat"),
//                       prefixIcon:
//                           const Icon(Icons.star, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     items: ["14", "18", "21", "22", "24"]
//                         .map((e) => DropdownMenuItem(
//                               value: e,
//                               child: Text("${_t("عيار", "Carat")} $e"),
//                             ))
//                         .toList(),
//                     onChanged: (v) => setState(() => carat = v ?? "18"),
//                   ),
//                   const SizedBox(height: 16),

//                   // الوزن
//                   TextFormField(
//                     controller: weightController,
//                     decoration: InputDecoration(
//                       labelText: _t("الوزن (جم)", "Weight (g)"),
//                       hintText:
//                           _t("أدخل الوزن بالجرام", "Enter weight in grams"),
//                       prefixIcon: const Icon(Icons.fitness_center,
//                           color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (v) => v!.isEmpty
//                         ? _t("الوزن مطلوب", "Weight is required")
//                         : null,
//                   ),
//                   const SizedBox(height: 16),

//                   // طريقة الدفع
//                   DropdownButtonFormField(
//                     value: paymentType,
//                     decoration: InputDecoration(
//                       labelText: _t("طريقة الدفع", "Payment Type"),
//                       prefixIcon:
//                           const Icon(Icons.payment, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     items: ["كاش", "شبكة", "متعدد"]
//                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                         .toList(),
//                     onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
//                   ),
//                   const SizedBox(height: 16),

//                   // المبالغ
//                   if (paymentType == "كاش" || paymentType == "متعدد")
//                     TextFormField(
//                       controller: cashController,
//                       decoration: InputDecoration(
//                         labelText: _t("المبلغ كاش", "Cash Amount"),
//                         hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
//                         prefixIcon:
//                             const Icon(Icons.money, color: Colors.green),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   if (paymentType == "متعدد") const SizedBox(height: 12),
//                   if (paymentType == "شبكة" || paymentType == "متعدد")
//                     TextFormField(
//                       controller: networkController,
//                       decoration: InputDecoration(
//                         labelText: _t("المبلغ شبكة", "Card Amount"),
//                         hintText:
//                             _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
//                         prefixIcon:
//                             const Icon(Icons.credit_card, color: Colors.blue),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                   const SizedBox(height: 16),

//                   // التاريخ
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     title: Text(
//                       "${_t("التاريخ", "Date")}: ${df.format(date)}",
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.calendar_today,
//                           color: Color(0xFFD4AF37)),
//                       onPressed: () async {
//                         final d = await showDatePicker(
//                           context: context,
//                           initialDate: date,
//                           firstDate: DateTime(2020),
//                           lastDate: DateTime(2030),
//                         );
//                         if (d != null) setState(() => date = d);
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // ملاحظات
//                   TextFormField(
//                     controller: notesController,
//                     maxLines: 2,
//                     decoration: InputDecoration(
//                       labelText: _t('ملاحظات', 'Notes'),
//                       hintText:
//                           _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
//                       prefixIcon:
//                           const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // زر الحفظ
//                   SizedBox(
//                     width: double.infinity,
//                     height: 55,
//                     child: ElevatedButton(
//                       onPressed: isLoading ? null : _save,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFD4AF37),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 3,
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               _t("💾 تسجيل البيع", "💾 Save Sale"),
//                               style: const TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
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

//   Widget _buildSectionTitle(String title, IconData icon) {
//     return Row(
//       children: [
//         Icon(icon, color: const Color(0xFFD4AF37), size: 22),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// // ============================================================
// // صفحة التقارير (محسّنة - تم إزالة الفلاتر)
// // ============================================================
// class ScrapReports extends StatefulWidget {
//   const ScrapReports({super.key});

//   @override
//   State<ScrapReports> createState() => _ScrapReportsState();
// }

// class _ScrapReportsState extends State<ScrapReports> {
//   String searchQuery = "";

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _formatWeight(double grams) {
//     if (grams == 0) return "0.000";

//     bool isNegative = grams < 0;
//     grams = grams.abs();

//     // تقريب إلى 3 أرقام عشرية
//     String formatted = grams.toStringAsFixed(3);

//     // إزالة الأصفار الزائدة من اليمين مع الاحتفاظ بثلاثة أرقام عشرية
//     while (formatted.endsWith('0') && formatted.contains('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }
//     if (formatted.endsWith('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }

//     // التأكد من وجود 3 أرقام عشرية على الأقل
//     if (!formatted.contains('.')) {
//       formatted = '$formatted.000';
//     } else {
//       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       while (decimalPlaces < 3) {
//         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
//         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       }
//     }

//     return isNegative ? "- $formatted" : formatted;
//   }

//   /// تحويل الوزن من عيار معين إلى عيار 24 (يستخدم فقط للرصيد الحالي)
//   double _convertTo24Karat(double weight, String carat) {
//     if (carat == "24") return weight;
//     if (carat == "22") return weight * 22 / 24;
//     if (carat == "21") return weight * 21 / 24;
//     if (carat == "18") return weight * 18 / 24;
//     if (carat == "14") return weight * 14 / 24;
//     return weight;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => setState(() {}),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // البحث فقط (تم إزالة باقي الفلاتر)
//           Container(
//             padding: const EdgeInsets.all(12),
//             color: Colors.grey[100],
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: _t("🔍 بحث باسم الشخص", "🔍 Search by person"),
//                 prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//               ),
//               onChanged: (val) =>
//                   setState(() => searchQuery = val.toLowerCase()),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FS.scrapTransactionsStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error_outline,
//                             size: 60, color: Colors.red[300]),
//                         const SizedBox(height: 16),
//                         Text(_t("⚠️ حدث خطأ في تحميل البيانات",
//                             "⚠️ Error loading data")),
//                         const SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: () => setState(() {}),
//                           child: Text(_t("إعادة المحاولة", "Retry")),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 List<Map<String, dynamic>> allTx =
//                     List.from(snapshot.data as List);

//                 // تطبيق البحث فقط
//                 if (searchQuery.isNotEmpty) {
//                   allTx = allTx.where((t) {
//                     final person = (t["person"] ?? "").toString().toLowerCase();
//                     return person.contains(searchQuery);
//                   }).toList();
//                 }

//                 if (allTx.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.search_off,
//                             size: 60, color: Colors.grey[400]),
//                         const SizedBox(height: 16),
//                         Text(
//                           _t("لا توجد معاملات تطابق البحث",
//                               "No matching transactions"),
//                           style:
//                               TextStyle(fontSize: 16, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // حساب الإحصائيات
//                 Map<String, Map<String, double>> stats = {
//                   "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                 };

//                 Map<String, double> totalByCarat = {
//                   "14": 0,
//                   "18": 0,
//                   "21": 0,
//                   "22": 0,
//                   "24": 0
//                 };
//                 double totalCash = 0;
//                 double totalNetwork = 0;

//                 // حساب الرصيد بعيار 24
//                 double balance24K = 0;

//                 for (var t in allTx) {
//                   final type = t["type"] ?? "";
//                   final carat = (t["carat"] ?? "18").toString();
//                   final weight = (t["weight"] ?? 0).toDouble();

//                   if (stats.containsKey(type) &&
//                       stats[type]!.containsKey(carat)) {
//                     stats[type]![carat] =
//                         (stats[type]![carat]! + weight).toDouble();

//                     // حساب الإجمالي لكل عيار (مع الإشارة الصحيحة)
//                     double signedWeight = weight;
//                     if (type == "sale" || type == "payment") {
//                       signedWeight = -weight.abs();
//                     }
//                     totalByCarat[carat] =
//                         (totalByCarat[carat]! + signedWeight).toDouble();

//                     // حساب الرصيد بعيار 24 (يستخدم فقط للرصيد الحالي)
//                     double convertedWeight = _convertTo24Karat(weight, carat);
//                     if (type == "add" || type == "transform") {
//                       balance24K += convertedWeight;
//                     } else if (type == "sale" || type == "payment") {
//                       balance24K -= convertedWeight.abs();
//                     }
//                   }

//                   totalCash += (t["cash"] ?? 0).toDouble();
//                   totalNetwork += (t["network"] ?? 0).toDouble();
//                 }

//                 return ListView(
//                   children: [
//                     // بطاقة الملخص
//                     Card(
//                       margin: const EdgeInsets.all(12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.summarize,
//                                     color: const Color(0xFFD4AF37)),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   _t("📊 ملخص الإجماليات", "📊 Summary Totals"),
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   "${allTx.length} ${_t("عملية", "transactions")}",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey[600]),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey[300]!),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   columnSpacing: 12,
//                                   headingRowColor: MaterialStateProperty.all(
//                                     const Color(0xFFD4AF37).withOpacity(0.1),
//                                   ),
//                                   columns: [
//                                     DataColumn(
//                                         label: Text(_t("العيار", "Carat"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text(_t("شراء", "Add"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.green))),
//                                     DataColumn(
//                                         label: Text(_t("بيع", "Sale"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.blue))),
//                                     DataColumn(
//                                         label: Text(_t("سند صرف", "Payment"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.red))),
//                                     DataColumn(
//                                         label: Text(_t("تحويل", "Transform"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.orange))),
//                                     DataColumn(
//                                         label: Text(_t("الإجمالي", "Total"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                   ],
//                                   rows: ["14", "18", "21", "22", "24"]
//                                       .map((carat) {
//                                     double addVal = stats["add"]![carat]!;
//                                     double saleVal =
//                                         stats["sale"]![carat]!.abs();
//                                     double paymentVal =
//                                         stats["payment"]![carat]!.abs();
//                                     double transformVal =
//                                         stats["transform"]![carat]!;
//                                     double total = totalByCarat[carat]!;

//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                             Text("${_t("ع", "C")} $carat")),
//                                         DataCell(Text(addVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.green))),
//                                         DataCell(Text(
//                                             saleVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.blue))),
//                                         DataCell(Text(
//                                             paymentVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.red))),
//                                         DataCell(Text(
//                                             transformVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.orange))),
//                                         DataCell(
//                                           Text(
//                                             total.toStringAsFixed(1),
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: total < 0
//                                                   ? Colors.red
//                                                   : Colors.green,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             // الرصيد الحالي بعيار 24 (هذا فقط للرصيد الحالي)
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: balance24K < 0
//                                     ? Colors.red.shade50
//                                     : Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: balance24K < 0
//                                       ? Colors.red.shade200
//                                       : Colors.green.shade200,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         balance24K < 0
//                                             ? Icons.warning
//                                             : Icons.check_circle,
//                                         color: balance24K < 0
//                                             ? Colors.red
//                                             : Colors.green,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         _t("الرصيد الحالي (24)",
//                                             "Current Balance (24K)"),
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     _formatWeight(balance24K),
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: balance24K < 0
//                                           ? Colors.red
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // قائمة الأشخاص (كل شخص بعيارته الأساسية بدون تحويل)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         _t("👤 قائمة الأشخاص", "👤 Persons List"),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildPersonsList(allTx),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonsList(List<Map<String, dynamic>> allTx) {
//     // تجميع الأشخاص
//     Map<String, List<Map<String, dynamic>>> personsMap = {};
//     for (var t in allTx) {
//       String person = (t["person"] ?? "").toString();
//       if (person.isNotEmpty) {
//         if (!personsMap.containsKey(person)) {
//           personsMap[person] = [];
//         }
//         personsMap[person]!.add(t);
//       }
//     }

//     // ترتيب الأشخاص أبجدياً
//     List<String> sortedPersons = personsMap.keys.toList()
//       ..sort((a, b) => a.compareTo(b));

//     if (sortedPersons.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Text(
//             _t("لا يوجد أشخاص", "No persons found"),
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: sortedPersons.length,
//       itemBuilder: (context, i) {
//         String person = sortedPersons[i];
//         List<Map<String, dynamic>> transactions = personsMap[person]!;

//         // حساب رصيد الشخص بعياراته الأساسية (بدون تحويل)
//         Map<String, double> balanceByCarat = {
//           "14": 0,
//           "18": 0,
//           "21": 0,
//           "22": 0,
//           "24": 0
//         };
//         double totalCash = 0;

//         for (var t in transactions) {
//           final type = t["type"] ?? "";
//           final carat = (t["carat"] ?? "18").toString();
//           final weight = (t["weight"] ?? 0).toDouble();

//           if (type == "add" || type == "transform") {
//             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
//           } else if (type == "sale" || type == "payment") {
//             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) - weight.abs();
//           }
//           totalCash += (t["cash"] ?? 0).toDouble();
//         }

//         // إزالة العيارات التي صفرها
//         List<String> caratsWithBalance = [];
//         for (var entry in balanceByCarat.entries) {
//           if (entry.value != 0) {
//             caratsWithBalance
//                 .add("${entry.key}: ${_formatWeight(entry.value)}");
//           }
//         }

//         String balanceText =
//             caratsWithBalance.isEmpty ? "0.000" : caratsWithBalance.join(" | ");

//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue.shade100,
//               child: const Icon(
//                 Icons.person,
//                 color: Colors.blue,
//               ),
//             ),
//             title: Text(
//               person,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               "${transactions.length} ${_t("عملية", "transactions")} • $balanceText",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[700],
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (totalCash > 0)
//                   Text(
//                     "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 const SizedBox(width: 8),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 14,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ScrapPersonDetails(person: person),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// // ============================================================
// // صفحة تفاصيل الشخص (محسّنة)
// // ============================================================
// class ScrapPersonDetails extends StatefulWidget {
//   final String person;
//   const ScrapPersonDetails({super.key, required this.person});

//   @override
//   State<ScrapPersonDetails> createState() => _ScrapPersonDetailsState();
// }

// class _ScrapPersonDetailsState extends State<ScrapPersonDetails> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _formatWeight(double grams) {
//     if (grams == 0) return "0.000";

//     bool isNegative = grams < 0;
//     grams = grams.abs();

//     // تقريب إلى 3 أرقام عشرية
//     String formatted = grams.toStringAsFixed(3);

//     // إزالة الأصفار الزائدة من اليمين مع الاحتفاظ بثلاثة أرقام عشرية
//     while (formatted.endsWith('0') && formatted.contains('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }
//     if (formatted.endsWith('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }

//     // التأكد من وجود 3 أرقام عشرية على الأقل
//     if (!formatted.contains('.')) {
//       formatted = '$formatted.000';
//     } else {
//       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       while (decimalPlaces < 3) {
//         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
//         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       }
//     }

//     return isNegative ? "- $formatted" : formatted;
//   }

//   double _convertTo24Karat(double weight, String carat) {
//     if (carat == "24") return weight;
//     if (carat == "22") return weight * 22 / 24;
//     if (carat == "21") return weight * 21 / 24;
//     if (carat == "18") return weight * 18 / 24;
//     if (carat == "14") return weight * 14 / 24;
//     return weight;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("معاملات ", "Transactions of ") + widget.person),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: FutureBuilder(
//         future: FS.getScrapTransactions(widget.person),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
//                   const SizedBox(height: 16),
//                   Text(_t("⚠️ حدث خطأ", "⚠️ Error")),
//                   ElevatedButton(
//                     onPressed: () => setState(() {}),
//                     child: Text(_t("إعادة المحاولة", "Retry")),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final txs = snapshot.data as List<Map<String, dynamic>>;
//           if (txs.isEmpty) {
//             return Center(
//               child: Text(_t("لا توجد معاملات لهذا الشخص",
//                   "No transactions for this person")),
//             );
//           }

//           // حساب الإحصائيات
//           double totalAdd = 0;
//           double totalSale = 0;
//           double totalPayment = 0;
//           double totalTransform = 0;
//           double totalCash = 0;
//           double totalNetwork = 0;
//           double balance24K = 0;

//           for (var t in txs) {
//             final type = t["type"] ?? "";
//             final carat = (t["carat"] ?? "18").toString();
//             final weight = (t["weight"] ?? 0).toDouble();
//             double convertedWeight = _convertTo24Karat(weight, carat);

//             if (type == "add") {
//               totalAdd += weight;
//               balance24K += convertedWeight;
//             } else if (type == "sale") {
//               totalSale += weight.abs();
//               balance24K -= convertedWeight.abs();
//             } else if (type == "payment") {
//               totalPayment += weight.abs();
//               balance24K -= convertedWeight.abs();
//             } else if (type == "transform") {
//               totalTransform += weight;
//               balance24K += convertedWeight;
//             }
//             totalCash += (t["cash"] ?? 0).toDouble();
//             totalNetwork += (t["network"] ?? 0).toDouble();
//           }

//           return Column(
//             children: [
//               // بطاقة الملخص
//               Card(
//                 margin: const EdgeInsets.all(12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: balance24K < 0
//                                 ? Colors.red.shade100
//                                 : Colors.green.shade100,
//                             child: Icon(
//                               Icons.person,
//                               color: balance24K < 0 ? Colors.red : Colors.green,
//                               size: 30,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.person,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 // Text(
//                                 //   "${txs.length} ${_t("عملية", "transactions")}",
//                                 //   style: TextStyle(color: Colors.grey[600]),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                           // Container(
//                           //   padding: const EdgeInsets.symmetric(
//                           //       horizontal: 16, vertical: 8),
//                           //   decoration: BoxDecoration(
//                           //     color: balance24K < 0
//                           //         ? Colors.red.shade50
//                           //         : Colors.green.shade50,
//                           //     borderRadius: BorderRadius.circular(20),
//                           //     border: Border.all(
//                           //       color: balance24K < 0
//                           //           ? Colors.red.shade200
//                           //           : Colors.green.shade200,
//                           //     ),
//                           //   ),
//                           //   child: Column(
//                           //     crossAxisAlignment: CrossAxisAlignment.center,
//                           //     children: [
//                           //       Text(
//                           //         _formatWeight(balance24K),
//                           //         style: TextStyle(
//                           //           fontWeight: FontWeight.bold,
//                           //           color: balance24K < 0
//                           //               ? Colors.red
//                           //               : Colors.green,
//                           //         ),
//                           //       ),
//                           //       Text(
//                           //         "(24K)",
//                           //         style: TextStyle(
//                           //           fontSize: 10,
//                           //           color: Colors.grey[600],
//                           //         ),
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       const Divider(),
//                       // Row(
//                       //   children: [
//                       //     _buildStatCard(
//                       //         _t("شراء", "Add"), totalAdd, Colors.green),
//                       //     _buildStatCard(
//                       //         _t("بيع", "Sale"), totalSale, Colors.blue),
//                       //     _buildStatCard(_t("سند صرف", "Payment"), totalPayment,
//                       //         Colors.red),
//                       //     _buildStatCard(_t("تحويل", "Transform"),
//                       //         totalTransform, Colors.orange),
//                       //   ],
//                       // ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border:
//                                     Border.all(color: Colors.green.shade200),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(_t("نقد", "Cash"),
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600])),
//                                   Text(
//                                       "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.shade50,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(color: Colors.blue.shade200),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(_t("شبكة", "Card"),
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600])),
//                                   Text(
//                                       "${totalNetwork.toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.purple.shade50,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border:
//                                     Border.all(color: Colors.purple.shade200),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(_t("الإجمالي", "Total"),
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.grey[600])),
//                                   Text(
//                                       "${(totalCash + totalNetwork).toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // قائمة المعاملات
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: txs.length,
//                   itemBuilder: (context, i) {
//                     final t = txs[i];
//                     final type = t['type'] ?? "";
//                     final carat = (t['carat'] ?? "18").toString();
//                     final weight = (t['weight'] ?? 0).toDouble();
//                     final date = (t['date'] as Timestamp).toDate();
//                     final formattedDate =
//                         DateFormat("yyyy-MM-dd HH:mm").format(date);

//                     Map<String, dynamic> typeInfo = _getTypeInfo(type);
//                     double signedWeight = type == "sale" || type == "payment"
//                         ? -weight.abs()
//                         : weight;

//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 4),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: typeInfo["color"].withOpacity(0.2),
//                           child:
//                               Icon(typeInfo["icon"], color: typeInfo["color"]),
//                         ),
//                         title: Text(
//                           typeInfo["label"],
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                                 "${_t("الوزن", "Weight")}: ${weight.abs().toStringAsFixed(1)} ${_t("جم", "g")}"),
//                             Text("${_t("العيار", "Carat")}: $carat"),
//                             if (t["notes"] != null &&
//                                 t["notes"].toString().isNotEmpty)
//                               Text("${_t("ملاحظات", "Notes")}: ${t['notes']}"),
//                             Text("${_t("التاريخ", "Date")}: $formattedDate"),
//                           ],
//                         ),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: signedWeight < 0
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             "${signedWeight >= 0 ? "+" : ""}${signedWeight.toStringAsFixed(1)}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   signedWeight < 0 ? Colors.red : Colors.green,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatCard(String label, double value, Color color) {
//     return Expanded(
//       child: Column(
//         children: [
//           Text(value.toStringAsFixed(1),
//               style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//           Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
//         ],
//       ),
//     );
//   }

//   Map<String, dynamic> _getTypeInfo(String type) {
//     switch (type) {
//       case "add":
//         return {
//           "label": _t("شراء", "Buy"),
//           "icon": Icons.arrow_downward,
//           "color": Colors.green
//         };
//       case "sale":
//         return {
//           "label": _t("بيع", "Sell"),
//           "icon": Icons.arrow_upward,
//           "color": Colors.blue
//         };
//       case "payment":
//         return {
//           "label": _t("سند صرف", "Payment"),
//           "icon": Icons.receipt_long,
//           "color": Colors.red
//         };
//       case "transform":
//         return {
//           "label": _t("تحويل", "Transform"),
//           "icon": Icons.swap_horiz,
//           "color": Colors.orange
//         };
//       default:
//         return {"label": type, "icon": Icons.help, "color": Colors.grey};
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScrapPage extends StatefulWidget {
  const ScrapPage({super.key});

  @override
  State<ScrapPage> createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  void _openPart(Widget part) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => part),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t("إدارة الكسر", "Scrap Management"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFD4AF37).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                _t("اختر العملية المطلوبة", "Choose Operation"),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildMenuCard(
                      icon: Icons.shopping_cart,
                      label: _t("شراء كسر", "Buy Scrap"),
                      color: Colors.green,
                      page: const ScrapAddForm(),
                    ),
                    _buildMenuCard(
                      icon: Icons.sell,
                      label: _t("بيع كسر", "Sell Scrap"),
                      color: Colors.blue,
                      page: const ScrapSaleForm(),
                    ),
                    _buildMenuCard(
                      icon: Icons.bar_chart,
                      label: _t("التقارير", "Reports"),
                      color: Colors.purple,
                      page: const ScrapReports(),
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

  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () => _openPart(page),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: color.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// نموذج شراء الكسر (محسّن)
// ============================================================
class ScrapAddForm extends StatefulWidget {
  const ScrapAddForm({super.key});

  @override
  State<ScrapAddForm> createState() => _ScrapAddFormState();
}

class _ScrapAddFormState extends State<ScrapAddForm> {
  final _formKey = GlobalKey<FormState>();
  String carat = "18";
  final weightController = TextEditingController();
  final cashController = TextEditingController();
  final networkController = TextEditingController();
  final personController = TextEditingController();
  final notesController = TextEditingController();
  String paymentType = "كاش";
  DateTime date = DateTime.now();
  bool isLoading = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (weightController.text.isEmpty) {
      _showSnackbar(
          _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
      return;
    }

    double cashVal = 0;
    double netVal = 0;

    if (paymentType == "كاش") {
      cashVal = double.tryParse(cashController.text) ?? 0;
    } else if (paymentType == "شبكة") {
      netVal = double.tryParse(networkController.text) ?? 0;
    } else if (paymentType == "متعدد") {
      cashVal = double.tryParse(cashController.text) ?? 0;
      netVal = double.tryParse(networkController.text) ?? 0;
    }

    double total = cashVal + netVal;

    if (total == 0) {
      _showSnackbar(
          _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
      return;
    }

    if (personController.text.trim().isEmpty) {
      _showSnackbar(
          _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
          Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      await FS.saveScrapAdd({
        "carat": carat,
        "weight": double.tryParse(weightController.text) ?? 0,
        "person": personController.text.trim(),
        "paymentType": paymentType,
        "cash": cashVal,
        "network": netVal,
        "total": total,
        "date": date,
        "notes": notesController.text.trim(),
        "type": "add",
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        weightController.clear();
        cashController.clear();
        networkController.clear();
        notesController.clear();
        personController.clear();
        paymentType = 'كاش';
        carat = '18';
        isLoading = false;
      });

      _showSnackbar(
          _t("✅ تم تسجيل الشراء بنجاح", "✅ Purchase saved successfully"),
          Colors.green);
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("شراء كسر", "Buy Scrap")),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(_t("بيانات العملية", "Transaction Data"),
                      Icons.info_outline),
                  const SizedBox(height: 16),

                  // اسم الشخص
                  TextFormField(
                    controller: personController,
                    decoration: InputDecoration(
                      labelText: _t("اسم الشخص", "Person Name"),
                      hintText: _t("أدخل اسم العميل", "Enter client name"),
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v!.trim().isEmpty
                        ? _t("الاسم مطلوب", "Name is required")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // العيار
                  DropdownButtonFormField(
                    value: carat,
                    decoration: InputDecoration(
                      labelText: _t("العيار", "Carat"),
                      prefixIcon:
                          const Icon(Icons.star, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ["14", "18", "21", "22", "24"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text("${_t("عيار", "Carat")} $e"),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => carat = v ?? "18"),
                  ),
                  const SizedBox(height: 16),

                  // الوزن
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: _t("الوزن (جم)", "Weight (g)"),
                      hintText:
                          _t("أدخل الوزن بالجرام", "Enter weight in grams"),
                      prefixIcon: const Icon(Icons.fitness_center,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? _t("الوزن مطلوب", "Weight is required")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // طريقة الدفع
                  DropdownButtonFormField(
                    value: paymentType,
                    decoration: InputDecoration(
                      labelText: _t("طريقة الدفع", "Payment Type"),
                      prefixIcon:
                          const Icon(Icons.payment, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ["كاش", "شبكة", "متعدد"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
                  ),
                  const SizedBox(height: 16),

                  // المبالغ
                  if (paymentType == "كاش" || paymentType == "متعدد")
                    TextFormField(
                      controller: cashController,
                      decoration: InputDecoration(
                        labelText: _t("المبلغ كاش", "Cash Amount"),
                        hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
                        prefixIcon:
                            const Icon(Icons.money, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  if (paymentType == "متعدد") const SizedBox(height: 12),
                  if (paymentType == "شبكة" || paymentType == "متعدد")
                    TextFormField(
                      controller: networkController,
                      decoration: InputDecoration(
                        labelText: _t("المبلغ شبكة", "Card Amount"),
                        hintText:
                            _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
                        prefixIcon:
                            const Icon(Icons.credit_card, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 16),

                  // التاريخ
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "${_t("التاريخ", "Date")}: ${df.format(date)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today,
                          color: Color(0xFFD4AF37)),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => date = d);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ملاحظات
                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: _t('ملاحظات', 'Notes'),
                      hintText:
                          _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
                      prefixIcon:
                          const Icon(Icons.note, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _t("💾 حفظ العملية", "💾 Save Transaction"),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================
// نموذج بيع الكسر (محسّن)
// ============================================================
class ScrapSaleForm extends StatefulWidget {
  const ScrapSaleForm({super.key});

  @override
  State<ScrapSaleForm> createState() => _ScrapSaleFormState();
}

class _ScrapSaleFormState extends State<ScrapSaleForm> {
  final _formKey = GlobalKey<FormState>();
  final weightController = TextEditingController();
  final cashController = TextEditingController();
  final networkController = TextEditingController();
  final personController = TextEditingController();
  final notesController = TextEditingController();
  String carat = "18";
  String paymentType = "كاش";
  DateTime date = DateTime.now();
  bool isLoading = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<double> _getCurrentBalance(String carat) async {
    try {
      final txs = await FS.getScrapTransactionsByCarat(carat);
      double balance = 0;
      for (var t in txs) {
        final type = t["type"];
        final weight = (t["weight"] ?? 0).toDouble();
        if (type == "add" || type == "transform") {
          balance += weight;
        } else if (type == "sale" || type == "payment") {
          balance -= weight.abs();
        }
      }
      return balance;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (weightController.text.isEmpty) {
      _showSnackbar(
          _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
      return;
    }

    double weight = double.tryParse(weightController.text) ?? 0;

    // التحقق من الرصيد
    double balance = await _getCurrentBalance(carat);
    if (weight > balance) {
      _showSnackbar(
        _t("⚠️ الرصيد غير كافٍ! المتوفر: $balance جم",
            "⚠️ Insufficient balance! Available: $balance g"),
        Colors.red,
      );
      return;
    }

    double cashVal = 0;
    double netVal = 0;

    if (paymentType == "كاش") {
      cashVal = double.tryParse(cashController.text) ?? 0;
    } else if (paymentType == "شبكة") {
      netVal = double.tryParse(networkController.text) ?? 0;
    } else if (paymentType == "متعدد") {
      cashVal = double.tryParse(cashController.text) ?? 0;
      netVal = double.tryParse(networkController.text) ?? 0;
    }

    double total = cashVal + netVal;

    if (total == 0) {
      _showSnackbar(
          _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
      return;
    }

    if (personController.text.trim().isEmpty) {
      _showSnackbar(
          _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
          Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      await FS.saveScrapSale({
        "carat": carat,
        "weight": weight,
        "person": personController.text.trim(),
        "paymentType": paymentType,
        "cash": cashVal,
        "network": netVal,
        "total": total,
        "date": date,
        "notes": notesController.text.trim(),
        "type": "sale",
        "createdAt": FieldValue.serverTimestamp(),
      });

      setState(() {
        weightController.clear();
        cashController.clear();
        networkController.clear();
        notesController.clear();
        personController.clear();
        paymentType = 'كاش';
        carat = '18';
        isLoading = false;
      });

      _showSnackbar(_t("✅ تم تسجيل البيع بنجاح", "✅ Sale saved successfully"),
          Colors.green);
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
    }
  }

  void _showSnackbar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat("yyyy-MM-dd");
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("بيع كسر", "Sell Scrap")),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      _t("بيانات البيع", "Sale Data"), Icons.info_outline),
                  const SizedBox(height: 16),

                  // اسم الشخص
                  TextFormField(
                    controller: personController,
                    decoration: InputDecoration(
                      labelText: _t("اسم الشخص", "Person Name"),
                      hintText: _t("أدخل اسم العميل", "Enter client name"),
                      prefixIcon:
                          const Icon(Icons.person, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => v!.trim().isEmpty
                        ? _t("الاسم مطلوب", "Name is required")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // العيار
                  DropdownButtonFormField(
                    value: carat,
                    decoration: InputDecoration(
                      labelText: _t("العيار", "Carat"),
                      prefixIcon:
                          const Icon(Icons.star, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ["14", "18", "21", "22", "24"]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text("${_t("عيار", "Carat")} $e"),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => carat = v ?? "18"),
                  ),
                  const SizedBox(height: 16),

                  // الوزن
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: _t("الوزن (جم)", "Weight (g)"),
                      hintText:
                          _t("أدخل الوزن بالجرام", "Enter weight in grams"),
                      prefixIcon: const Icon(Icons.fitness_center,
                          color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty
                        ? _t("الوزن مطلوب", "Weight is required")
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // طريقة الدفع
                  DropdownButtonFormField(
                    value: paymentType,
                    decoration: InputDecoration(
                      labelText: _t("طريقة الدفع", "Payment Type"),
                      prefixIcon:
                          const Icon(Icons.payment, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ["كاش", "شبكة", "متعدد"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
                  ),
                  const SizedBox(height: 16),

                  // المبالغ
                  if (paymentType == "كاش" || paymentType == "متعدد")
                    TextFormField(
                      controller: cashController,
                      decoration: InputDecoration(
                        labelText: _t("المبلغ كاش", "Cash Amount"),
                        hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
                        prefixIcon:
                            const Icon(Icons.money, color: Colors.green),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  if (paymentType == "متعدد") const SizedBox(height: 12),
                  if (paymentType == "شبكة" || paymentType == "متعدد")
                    TextFormField(
                      controller: networkController,
                      decoration: InputDecoration(
                        labelText: _t("المبلغ شبكة", "Card Amount"),
                        hintText:
                            _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
                        prefixIcon:
                            const Icon(Icons.credit_card, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 16),

                  // التاريخ
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "${_t("التاريخ", "Date")}: ${df.format(date)}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today,
                          color: Color(0xFFD4AF37)),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (d != null) setState(() => date = d);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ملاحظات
                  TextFormField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: _t('ملاحظات', 'Notes'),
                      hintText:
                          _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
                      prefixIcon:
                          const Icon(Icons.note, color: Color(0xFFD4AF37)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _t("💾 تسجيل البيع", "💾 Save Sale"),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================
// صفحة التقارير (محسّنة - مع إظهار العيارات بشكل منفصل)
// ============================================================

// ============================================================
// صفحة التقارير (محسّنة - مع إظهار العيارات بشكل منفصل)
// ============================================================
class ScrapReports extends StatefulWidget {
  const ScrapReports({super.key});

  @override
  State<ScrapReports> createState() => _ScrapReportsState();
}

class _ScrapReportsState extends State<ScrapReports> {
  String searchQuery = "";

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  String _formatWeight(double grams) {
    if (grams == 0) return "0.000";
    bool isNegative = grams < 0;
    grams = grams.abs();
    String formatted = grams.toStringAsFixed(3);
    while (formatted.endsWith('0') && formatted.contains('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (!formatted.contains('.')) {
      formatted = '$formatted.000';
    } else {
      int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
      while (decimalPlaces < 3) {
        formatted = '$formatted${'0' * (3 - decimalPlaces)}';
        decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
      }
    }
    return isNegative ? "- $formatted" : formatted;
  }

  double _convertTo24Karat(double weight, String carat) {
    if (carat == "24") return weight;
    if (carat == "22") return weight * 22 / 24;
    if (carat == "21") return weight * 21 / 24;
    if (carat == "18") return weight * 18 / 24;
    if (carat == "14") return weight * 14 / 24;
    return weight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          // البحث
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: TextField(
              decoration: InputDecoration(
                hintText: _t("🔍 بحث باسم الشخص", "🔍 Search by person"),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (val) =>
                  setState(() => searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FS.scrapTransactionsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 60, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(_t("⚠️ حدث خطأ في تحميل البيانات",
                            "⚠️ Error loading data")),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: Text(_t("إعادة المحاولة", "Retry")),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Map<String, dynamic>> allTx =
                    List.from(snapshot.data as List);

                if (searchQuery.isNotEmpty) {
                  allTx = allTx.where((t) {
                    final person = (t["person"] ?? "").toString().toLowerCase();
                    return person.contains(searchQuery);
                  }).toList();
                }

                if (allTx.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _t("لا توجد معاملات تطابق البحث",
                              "No matching transactions"),
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ حساب الإحصائيات مع دعم العيارات المتعددة
                Map<String, Map<String, double>> stats = {
                  "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
                  "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
                  "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
                  "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
                };

                Map<String, double> totalByCarat = {
                  "14": 0,
                  "18": 0,
                  "21": 0,
                  "22": 0,
                  "24": 0
                };
                double totalCash = 0;
                double totalNetwork = 0;
                double balance24K = 0;

                for (var t in allTx) {
                  final type = t["type"] ?? "";

                  // ✅ معالجة العيارات المتعددة في سند الصرف
                  if (type == "payment" &&
                      t["carats"] != null &&
                      (t["carats"] as List).isNotEmpty) {
                    final carats = t["carats"] as List;
                    for (var c in carats) {
                      final carat = (c['carat'] ?? "18").toString();
                      final weight = (c['weight'] ?? 0).toDouble();
                      final wage = (c['wage'] ?? 0).toDouble();

                      // إضافة إلى إحصائيات الصرف
                      if (stats["payment"]!.containsKey(carat)) {
                        stats["payment"]![carat] =
                            (stats["payment"]![carat] ?? 0) + weight;
                      }

                      // خصم من الإجمالي لكل عيار
                      totalByCarat[carat] =
                          (totalByCarat[carat] ?? 0) - weight.abs();

                      // خصم من الرصيد 24
                      double convertedWeight = _convertTo24Karat(weight, carat);
                      balance24K -= convertedWeight.abs();
                    }
                  }
                  // ✅ معالجة العيار الواحد
                  else {
                    final carat = (t["carat"] ?? "18").toString();
                    final weight = (t["weight"] ?? 0).toDouble();

                    if (stats.containsKey(type) &&
                        stats[type]!.containsKey(carat)) {
                      stats[type]![carat] =
                          (stats[type]![carat]! + weight).toDouble();

                      double signedWeight = weight;
                      if (type == "sale" || type == "payment") {
                        signedWeight = -weight.abs();
                      }
                      totalByCarat[carat] =
                          (totalByCarat[carat]! + signedWeight).toDouble();

                      double convertedWeight = _convertTo24Karat(weight, carat);
                      if (type == "add" || type == "transform") {
                        balance24K += convertedWeight;
                      } else if (type == "sale" || type == "payment") {
                        balance24K -= convertedWeight.abs();
                      }
                    }
                  }

                  totalCash += (t["cash"] ?? 0).toDouble();
                  totalNetwork += (t["network"] ?? 0).toDouble();
                }

                return ListView(
                  children: [
                    // بطاقة الملخص
                    Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.summarize,
                                    color: const Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  _t("📊 ملخص الإجماليات", "📊 Summary Totals"),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${allTx.length} ${_t("عملية", "transactions")}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 12,
                                  headingRowColor: MaterialStateProperty.all(
                                    const Color(0xFFD4AF37).withOpacity(0.1),
                                  ),
                                  columns: [
                                    DataColumn(
                                        label: Text(_t("العيار", "Carat"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text(_t("شراء", "Add"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green))),
                                    DataColumn(
                                        label: Text(_t("بيع", "Sale"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue))),
                                    DataColumn(
                                        label: Text(_t("سند صرف", "Payment"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red))),
                                    DataColumn(
                                        label: Text(_t("تحويل", "Transform"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange))),
                                    DataColumn(
                                        label: Text(_t("الإجمالي", "Total"),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: ["14", "18", "21", "22", "24"]
                                      .map((carat) {
                                    double addVal = stats["add"]![carat]!;
                                    double saleVal =
                                        stats["sale"]![carat]!.abs();
                                    double paymentVal =
                                        stats["payment"]![carat]!.abs();
                                    double transformVal =
                                        stats["transform"]![carat]!;
                                    double total = totalByCarat[carat]!;

                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Text("${_t("ع", "C")} $carat")),
                                        DataCell(Text(addVal.toStringAsFixed(1),
                                            style: const TextStyle(
                                                color: Colors.green))),
                                        DataCell(Text(
                                            saleVal.toStringAsFixed(1),
                                            style: const TextStyle(
                                                color: Colors.blue))),
                                        DataCell(Text(
                                            paymentVal.toStringAsFixed(1),
                                            style: const TextStyle(
                                                color: Colors.red))),
                                        DataCell(Text(
                                            transformVal.toStringAsFixed(1),
                                            style: const TextStyle(
                                                color: Colors.orange))),
                                        DataCell(
                                          Text(
                                            total.toStringAsFixed(1),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: total < 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: balance24K < 0
                                    ? Colors.red.shade50
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: balance24K < 0
                                      ? Colors.red.shade200
                                      : Colors.green.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        balance24K < 0
                                            ? Icons.warning
                                            : Icons.check_circle,
                                        color: balance24K < 0
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _t("الرصيد الحالي (24)",
                                            "Current Balance (24K)"),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _formatWeight(balance24K),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: balance24K < 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // قائمة الأشخاص
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        _t("👤 قائمة الأشخاص", "👤 Persons List"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPersonsList(allTx),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonsList(List<Map<String, dynamic>> allTx) {
    Map<String, List<Map<String, dynamic>>> personsMap = {};
    for (var t in allTx) {
      String person = (t["person"] ?? "").toString();
      if (person.isNotEmpty) {
        if (!personsMap.containsKey(person)) {
          personsMap[person] = [];
        }
        personsMap[person]!.add(t);
      }
    }

    List<String> sortedPersons = personsMap.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    if (sortedPersons.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            _t("لا يوجد أشخاص", "No persons found"),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedPersons.length,
      itemBuilder: (context, i) {
        String person = sortedPersons[i];
        List<Map<String, dynamic>> transactions = personsMap[person]!;

        // ✅ حساب رصيد الشخص لكل عيار مع دعم العيارات المتعددة
        Map<String, double> balanceByCarat = {
          "14": 0,
          "18": 0,
          "21": 0,
          "22": 0,
          "24": 0
        };
        double totalCash = 0;

        for (var t in transactions) {
          final type = t["type"] ?? "";

          // ✅ معالجة سند الصرف متعدد العيارات
          if (type == "payment" &&
              t["carats"] != null &&
              (t["carats"] as List).isNotEmpty) {
            final carats = t["carats"] as List;
            for (var c in carats) {
              final carat = (c['carat'] ?? "18").toString();
              final weight = (c['weight'] ?? 0).toDouble();
              balanceByCarat[carat] =
                  (balanceByCarat[carat] ?? 0) - weight.abs();
            }
          }
          // ✅ معالجة المعاملات العادية
          else {
            final carat = (t["carat"] ?? "18").toString();
            final weight = (t["weight"] ?? 0).toDouble();

            if (type == "add" || type == "transform") {
              balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
            } else if (type == "sale" || type == "payment") {
              balanceByCarat[carat] =
                  (balanceByCarat[carat] ?? 0) - weight.abs();
            }
          }
          totalCash += (t["cash"] ?? 0).toDouble();
        }

        // بناء نص الرصيد لكل عيار
        List<String> caratBalances = [];
        for (var entry in balanceByCarat.entries) {
          if (entry.value != 0) {
            caratBalances.add("${entry.key}: ${_formatWeight(entry.value)} جم");
          }
        }
        String balanceText = caratBalances.isEmpty
            ? _t("مصفى", "Cleared")
            : caratBalances.join(" | ");

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
            title: Text(
              person,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${transactions.length} ${_t("عملية", "transactions")} ",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (totalCash > 0)
                  // Text(
                  //   "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                  const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScrapPersonDetails(person: person),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
// class ScrapReports extends StatefulWidget {
//   const ScrapReports({super.key});

//   @override
//   State<ScrapReports> createState() => _ScrapReportsState();
// }

// class _ScrapReportsState extends State<ScrapReports> {
//   String searchQuery = "";

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   String _formatWeight(double grams) {
//     if (grams == 0) return "0.000";
//     bool isNegative = grams < 0;
//     grams = grams.abs();
//     String formatted = grams.toStringAsFixed(3);
//     while (formatted.endsWith('0') && formatted.contains('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }
//     if (formatted.endsWith('.')) {
//       formatted = formatted.substring(0, formatted.length - 1);
//     }
//     if (!formatted.contains('.')) {
//       formatted = '$formatted.000';
//     } else {
//       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       while (decimalPlaces < 3) {
//         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
//         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
//       }
//     }
//     return isNegative ? "- $formatted" : formatted;
//   }

//   double _convertTo24Karat(double weight, String carat) {
//     if (carat == "24") return weight;
//     if (carat == "22") return weight * 22 / 24;
//     if (carat == "21") return weight * 21 / 24;
//     if (carat == "18") return weight * 18 / 24;
//     if (carat == "14") return weight * 14 / 24;
//     return weight;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
//         backgroundColor: const Color(0xFFD4AF37),
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => setState(() {}),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // البحث
//           Container(
//             padding: const EdgeInsets.all(12),
//             color: Colors.grey[100],
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: _t("🔍 بحث باسم الشخص", "🔍 Search by person"),
//                 prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 filled: true,
//                 fillColor: Colors.white,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//               ),
//               onChanged: (val) =>
//                   setState(() => searchQuery = val.toLowerCase()),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FS.scrapTransactionsStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.error_outline,
//                             size: 60, color: Colors.red[300]),
//                         const SizedBox(height: 16),
//                         Text(_t("⚠️ حدث خطأ في تحميل البيانات",
//                             "⚠️ Error loading data")),
//                         const SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: () => setState(() {}),
//                           child: Text(_t("إعادة المحاولة", "Retry")),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 List<Map<String, dynamic>> allTx =
//                     List.from(snapshot.data as List);

//                 if (searchQuery.isNotEmpty) {
//                   allTx = allTx.where((t) {
//                     final person = (t["person"] ?? "").toString().toLowerCase();
//                     return person.contains(searchQuery);
//                   }).toList();
//                 }

//                 if (allTx.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.search_off,
//                             size: 60, color: Colors.grey[400]),
//                         const SizedBox(height: 16),
//                         Text(
//                           _t("لا توجد معاملات تطابق البحث",
//                               "No matching transactions"),
//                           style:
//                               TextStyle(fontSize: 16, color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // حساب الإحصائيات
//                 Map<String, Map<String, double>> stats = {
//                   "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                   "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//                 };

//                 Map<String, double> totalByCarat = {
//                   "14": 0,
//                   "18": 0,
//                   "21": 0,
//                   "22": 0,
//                   "24": 0
//                 };
//                 double totalCash = 0;
//                 double totalNetwork = 0;
//                 double balance24K = 0;

//                 for (var t in allTx) {
//                   final type = t["type"] ?? "";
//                   final carat = (t["carat"] ?? "18").toString();
//                   final weight = (t["weight"] ?? 0).toDouble();

//                   if (stats.containsKey(type) &&
//                       stats[type]!.containsKey(carat)) {
//                     stats[type]![carat] =
//                         (stats[type]![carat]! + weight).toDouble();

//                     double signedWeight = weight;
//                     if (type == "sale" || type == "payment") {
//                       signedWeight = -weight.abs();
//                     }
//                     totalByCarat[carat] =
//                         (totalByCarat[carat]! + signedWeight).toDouble();

//                     double convertedWeight = _convertTo24Karat(weight, carat);
//                     if (type == "add" || type == "transform") {
//                       balance24K += convertedWeight;
//                     } else if (type == "sale" || type == "payment") {
//                       balance24K -= convertedWeight.abs();
//                     }
//                   }

//                   totalCash += (t["cash"] ?? 0).toDouble();
//                   totalNetwork += (t["network"] ?? 0).toDouble();
//                 }

//                 return ListView(
//                   children: [
//                     // بطاقة الملخص
//                     Card(
//                       margin: const EdgeInsets.all(12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.summarize,
//                                     color: const Color(0xFFD4AF37)),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   _t("📊 ملخص الإجماليات", "📊 Summary Totals"),
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Text(
//                                   "${allTx.length} ${_t("عملية", "transactions")}",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.grey[600]),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             Container(
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey[300]!),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: DataTable(
//                                   columnSpacing: 12,
//                                   headingRowColor: MaterialStateProperty.all(
//                                     const Color(0xFFD4AF37).withOpacity(0.1),
//                                   ),
//                                   columns: [
//                                     DataColumn(
//                                         label: Text(_t("العيار", "Carat"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                     DataColumn(
//                                         label: Text(_t("شراء", "Add"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.green))),
//                                     DataColumn(
//                                         label: Text(_t("بيع", "Sale"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.blue))),
//                                     DataColumn(
//                                         label: Text(_t("سند صرف", "Payment"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.red))),
//                                     DataColumn(
//                                         label: Text(_t("تحويل", "Transform"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Colors.orange))),
//                                     DataColumn(
//                                         label: Text(_t("الإجمالي", "Total"),
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold))),
//                                   ],
//                                   rows: ["14", "18", "21", "22", "24"]
//                                       .map((carat) {
//                                     double addVal = stats["add"]![carat]!;
//                                     double saleVal =
//                                         stats["sale"]![carat]!.abs();
//                                     double paymentVal =
//                                         stats["payment"]![carat]!.abs();
//                                     double transformVal =
//                                         stats["transform"]![carat]!;
//                                     double total = totalByCarat[carat]!;

//                                     return DataRow(
//                                       cells: [
//                                         DataCell(
//                                             Text("${_t("ع", "C")} $carat")),
//                                         DataCell(Text(addVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.green))),
//                                         DataCell(Text(
//                                             saleVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.blue))),
//                                         DataCell(Text(
//                                             paymentVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.red))),
//                                         DataCell(Text(
//                                             transformVal.toStringAsFixed(1),
//                                             style: const TextStyle(
//                                                 color: Colors.orange))),
//                                         DataCell(
//                                           Text(
//                                             total.toStringAsFixed(1),
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: total < 0
//                                                   ? Colors.red
//                                                   : Colors.green,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }).toList(),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: balance24K < 0
//                                     ? Colors.red.shade50
//                                     : Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: balance24K < 0
//                                       ? Colors.red.shade200
//                                       : Colors.green.shade200,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         balance24K < 0
//                                             ? Icons.warning
//                                             : Icons.check_circle,
//                                         color: balance24K < 0
//                                             ? Colors.red
//                                             : Colors.green,
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Text(
//                                         _t("الرصيد الحالي (24)",
//                                             "Current Balance (24K)"),
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     _formatWeight(balance24K),
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                       color: balance24K < 0
//                                           ? Colors.red
//                                           : Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // قائمة الأشخاص (كل شخص وعياراته)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         _t("👤 قائمة الأشخاص", "👤 Persons List"),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildPersonsList(allTx),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonsList(List<Map<String, dynamic>> allTx) {
//     Map<String, List<Map<String, dynamic>>> personsMap = {};
//     for (var t in allTx) {
//       String person = (t["person"] ?? "").toString();
//       if (person.isNotEmpty) {
//         if (!personsMap.containsKey(person)) {
//           personsMap[person] = [];
//         }
//         personsMap[person]!.add(t);
//       }
//     }

//     List<String> sortedPersons = personsMap.keys.toList()
//       ..sort((a, b) => a.compareTo(b));

//     if (sortedPersons.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Text(
//             _t("لا يوجد أشخاص", "No persons found"),
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: sortedPersons.length,
//       itemBuilder: (context, i) {
//         String person = sortedPersons[i];
//         List<Map<String, dynamic>> transactions = personsMap[person]!;

//         // حساب رصيد الشخص لكل عيار
//         Map<String, double> balanceByCarat = {
//           "14": 0,
//           "18": 0,
//           "21": 0,
//           "22": 0,
//           "24": 0
//         };
//         double totalCash = 0;

//         for (var t in transactions) {
//           final type = t["type"] ?? "";
//           final carat = (t["carat"] ?? "18").toString();
//           final weight = (t["weight"] ?? 0).toDouble();

//           if (type == "add" || type == "transform") {
//             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
//           } else if (type == "sale" || type == "payment") {
//             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) - weight.abs();
//           }
//           totalCash += (t["cash"] ?? 0).toDouble();
//         }

//         // بناء نص الرصيد لكل عيار على حدة
//         List<String> caratBalances = [];
//         for (var entry in balanceByCarat.entries) {
//           if (entry.value != 0) {
//             caratBalances.add("${entry.key}: ${_formatWeight(entry.value)} جم");
//           }
//         }
//         String balanceText = caratBalances.isEmpty
//             ? _t("مصفى", "Cleared")
//             : caratBalances.join(" | ");

//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue.shade100,
//               child: const Icon(
//                 Icons.person,
//                 color: Colors.blue,
//               ),
//             ),
//             title: Text(
//               person,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               "${transactions.length} ${_t("عملية", "transactions")} • $balanceText",
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[700],
//               ),
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (totalCash > 0)
//                   Text(
//                     "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 const SizedBox(width: 8),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 14,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ScrapPersonDetails(person: person),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// ============================================================
// صفحة تفاصيل الشخص (محسّنة - بدون تجميع السندات)
// ============================================================
class ScrapPersonDetails extends StatefulWidget {
  final String person;
  const ScrapPersonDetails({super.key, required this.person});

  @override
  State<ScrapPersonDetails> createState() => _ScrapPersonDetailsState();
}

class _ScrapPersonDetailsState extends State<ScrapPersonDetails> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  String _formatWeight(double grams) {
    if (grams == 0) return "0.000";
    bool isNegative = grams < 0;
    grams = grams.abs();
    String formatted = grams.toStringAsFixed(3);
    while (formatted.endsWith('0') && formatted.contains('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    if (!formatted.contains('.')) {
      formatted = '$formatted.000';
    } else {
      int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
      while (decimalPlaces < 3) {
        formatted = '$formatted${'0' * (3 - decimalPlaces)}';
        decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
      }
    }
    return isNegative ? "- $formatted" : formatted;
  }

  double _convertTo24Karat(double weight, String carat) {
    if (carat == "24") return weight;
    if (carat == "22") return weight * 22 / 24;
    if (carat == "21") return weight * 21 / 24;
    if (carat == "18") return weight * 18 / 24;
    if (carat == "14") return weight * 14 / 24;
    return weight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("معاملات ", "Transactions of ") + widget.person),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FS.getScrapTransactions(widget.person),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(_t("⚠️ حدث خطأ", "⚠️ Error")),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text(_t("إعادة المحاولة", "Retry")),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Map<String, dynamic>> txs =
              List.from(snapshot.data as List<Map<String, dynamic>>);

          if (txs.isEmpty) {
            return Center(
              child: Text(_t("لا توجد معاملات لهذا الشخص",
                  "No transactions for this person")),
            );
          }

          // ✅ ترتيب المعاملات من الأحدث إلى الأقدم
          txs.sort((a, b) {
            final dateA = a['date'] as Timestamp?;
            final dateB = b['date'] as Timestamp?;
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;
            return dateB.toDate().compareTo(dateA.toDate());
          });

          // حساب الإحصائيات لكل عيار
          Map<String, double> balanceByCarat = {
            "14": 0,
            "18": 0,
            "21": 0,
            "22": 0,
            "24": 0
          };
          double totalCash = 0;
          double totalNetwork = 0;
          double balance24K = 0;

          for (var t in txs) {
            final type = t["type"] ?? "";

            if (type == "payment" &&
                t["carats"] != null &&
                (t["carats"] as List).isNotEmpty) {
              final carats = t["carats"] as List;
              for (var c in carats) {
                final carat = (c['carat'] ?? "18").toString();
                final weight = (c['weight'] ?? 0).toDouble();
                double convertedWeight = _convertTo24Karat(weight, carat);
                balanceByCarat[carat] =
                    (balanceByCarat[carat] ?? 0) - weight.abs();
                balance24K -= convertedWeight.abs();
              }
            } else {
              final carat = (t["carat"] ?? "18").toString();
              final weight = (t["weight"] ?? 0).toDouble();
              double convertedWeight = _convertTo24Karat(weight, carat);

              if (type == "add") {
                balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
                balance24K += convertedWeight;
              } else if (type == "sale") {
                balanceByCarat[carat] =
                    (balanceByCarat[carat] ?? 0) - weight.abs();
                balance24K -= convertedWeight.abs();
              } else if (type == "payment") {
                balanceByCarat[carat] =
                    (balanceByCarat[carat] ?? 0) - weight.abs();
                balance24K -= convertedWeight.abs();
              } else if (type == "transform") {
                balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
                balance24K += convertedWeight;
              }
            }

            totalCash += (t["cash"] ?? 0).toDouble();
            totalNetwork += (t["network"] ?? 0).toDouble();
          }

          // بناء نص الرصيد لكل عيار
          List<String> caratBalances = [];
          for (var entry in balanceByCarat.entries) {
            if (entry.value != 0) {
              caratBalances
                  .add("${entry.key}: ${_formatWeight(entry.value)} جم");
            }
          }
          String balanceText = caratBalances.isEmpty
              ? _t("مصفى", "Cleared")
              : caratBalances.join(" | ");

          return Column(
            children: [
              // بطاقة الملخص
              Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: balance24K < 0
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            child: Icon(
                              Icons.person,
                              color: balance24K < 0 ? Colors.red : Colors.green,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.person,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: Column(
                                children: [
                                  Text(_t("نقد", "Cash"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  Text(
                                      "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Column(
                                children: [
                                  Text(_t("شبكة", "Card"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  Text(
                                      "${totalNetwork.toStringAsFixed(0)} ${_t("ج", "EGP")}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.purple.shade200),
                              ),
                              child: Column(
                                children: [
                                  Text(_t("الإجمالي", "Total"),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  Text(
                                      "${(totalCash + totalNetwork).toStringAsFixed(0)} ${_t("ج", "EGP")}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ✅ قائمة المعاملات (بدون تجميع)
              Expanded(
                child: ListView.builder(
                  itemCount: txs.length,
                  itemBuilder: (context, i) {
                    final t = txs[i];
                    final type = t['type'] ?? "";
                    final date = (t['date'] as Timestamp).toDate();
                    final formattedDate =
                        DateFormat("yyyy-MM-dd HH:mm").format(date);

                    // ============================================================
                    // ✅ سند صرف (عيار واحد أو متعدد)
                    // ============================================================
                    if (type == 'payment') {
                      // الحصول على العيارات
                      List<Map<String, dynamic>> carats = [];
                      double totalWeight = 0;
                      double totalWage = 0;
                      String delegate = t['delegate'] ?? '';
                      String notes = t['notes'] ?? '';

                      if (t['carats'] != null &&
                          (t['carats'] as List).isNotEmpty) {
                        carats = List.from(t['carats'] as List);
                        totalWeight = t['totalWeight'] ?? 0.0;
                        totalWage = t['totalWage'] ?? 0.0;

                        // إذا كان هناك carats ولكن totalWeight غير موجود
                        if (totalWeight == 0 && carats.isNotEmpty) {
                          for (var c in carats) {
                            totalWeight += (c['weight'] ?? 0).toDouble();
                            totalWage += (c['wage'] ?? 0).toDouble();
                          }
                        }
                      } else {
                        // عيار واحد
                        carats.add({
                          'carat': t['carat'] ?? '18',
                          'weight': (t['weight'] ?? 0).toDouble(),
                          'wage': (t['wage'] ?? 0).toDouble(),
                        });
                        totalWeight = (t['weight'] ?? 0).toDouble();
                        totalWage = (t['wage'] ?? 0).toDouble();
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ العنوان
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.red.withOpacity(0.15),
                                    radius: 18,
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _t("سند صرف", "Payment Voucher"),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        if (delegate.isNotEmpty)
                                          Text(
                                            "مندوب: $delegate",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),

                              // ✅ عرض كل عيار
                              ...carats.map((c) {
                                final carat = c['carat'] ?? '18';
                                final weight = (c['weight'] ?? 0).toDouble();
                                final wage = (c['wage'] ?? 0).toDouble();

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      // العيار
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37)
                                              .withOpacity(0.15),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFD4AF37)
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          "${_t('عيار', 'Carat')} $carat",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFD4AF37),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // الوزن
                                      Text(
                                        "${_t('وزن', 'Weight')}: ${weight.toStringAsFixed(2)} ${_t('جم', 'g')}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // الأجر
                                      Text(
                                        "${_t('أجر', 'Wage')}: ${wage.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),

                              const SizedBox(height: 12),

                              // ✅ إجمالي الوزن والأجر
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFD4AF37).withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37)
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${_t('إجمالي الوزن', 'Total Weight')}: ${totalWeight.toStringAsFixed(2)} ${_t('جم', 'g')}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                    Text(
                                      "${_t('إجمالي الأجر', 'Total Wage')}: ${totalWage.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ✅ الملاحظات
                              if (notes.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${_t('ملاحظات', 'Notes')}: $notes",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ============================================================
                    // ✅ باقي المعاملات (شراء، بيع، تحويل)
                    // ============================================================
                    final carat = (t['carat'] ?? '18').toString();
                    final weight = (t['weight'] ?? 0).toDouble();
                    final wage = (t['wage'] ?? 0).toDouble();

                    Map<String, dynamic> typeInfo = _getTypeInfo(type);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: typeInfo["color"].withOpacity(0.2),
                          child:
                              Icon(typeInfo["icon"], color: typeInfo["color"]),
                        ),
                        title: Text(
                          typeInfo["label"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (type != 'payment')
                              Text("${_t('العيار', 'Carat')}: $carat"),
                            Text(
                                "${_t('الوزن', 'Weight')}: ${weight.abs().toStringAsFixed(2)} ${_t('جم', 'g')}"),
                            if (wage > 0) Text("${_t('الأجر', 'Wage')}: $wage"),
                            if (t['delegate'] != null &&
                                t['delegate'].toString().isNotEmpty)
                              Text(
                                  "${_t('مندوب', 'Delegate')}: ${t['delegate']}"),
                            if (t['notes'] != null &&
                                t['notes'].toString().isNotEmpty)
                              Text("${_t('ملاحظات', 'Notes')}: ${t['notes']}"),
                            Text("${_t('التاريخ', 'Date')}: $formattedDate"),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: type == 'sale' || type == 'payment'
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            type == 'sale' || type == 'payment'
                                ? "-${weight.abs().toStringAsFixed(2)}"
                                : "+${weight.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: type == 'sale' || type == 'payment'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Map<String, dynamic> _getTypeInfo(String type) {
    switch (type) {
      case "add":
        return {
          "label": _t("شراء كسر", "Buy Scrap"),
          "icon": Icons.arrow_downward,
          "color": Colors.green
        };
      case "sale":
        return {
          "label": _t("بيع كسر", "Sell Scrap"),
          "icon": Icons.arrow_upward,
          "color": Colors.blue
        };
      case "payment":
        return {
          "label": _t("سند صرف", "Payment"),
          "icon": Icons.receipt_long,
          "color": Colors.red
        };
      case "transform":
        return {
          "label": _t("تحويل", "Transform"),
          "icon": Icons.swap_horiz,
          "color": Colors.orange
        };
      default:
        return {"label": type, "icon": Icons.help, "color": Colors.grey};
    }
  }
}
