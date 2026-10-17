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
// //         title: Text(
// //           _t("إدارة الكسر", "Scrap Management"),
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         elevation: 0,
// //         centerTitle: true,
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [
// //               const Color(0xFFD4AF37).withOpacity(0.1),
// //               Colors.white,
// //             ],
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 10),
// //               Text(
// //                 _t("اختر العملية المطلوبة", "Choose Operation"),
// //                 style: TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.w600,
// //                   color: Colors.grey[700],
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               Expanded(
// //                 child: GridView.count(
// //                   crossAxisCount: 2,
// //                   crossAxisSpacing: 16,
// //                   mainAxisSpacing: 16,
// //                   childAspectRatio: 1.1,
// //                   children: [
// //                     _buildMenuCard(
// //                       icon: Icons.shopping_cart,
// //                       label: _t("شراء كسر", "Buy Scrap"),
// //                       color: Colors.green,
// //                       page: const ScrapAddForm(),
// //                     ),
// //                     _buildMenuCard(
// //                       icon: Icons.sell,
// //                       label: _t("بيع كسر", "Sell Scrap"),
// //                       color: Colors.blue,
// //                       page: const ScrapSaleForm(),
// //                     ),
// //                     _buildMenuCard(
// //                       icon: Icons.bar_chart,
// //                       label: _t("التقارير", "Reports"),
// //                       color: Colors.purple,
// //                       page: const ScrapReports(),
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

// //   Widget _buildMenuCard({
// //     required IconData icon,
// //     required String label,
// //     required Color color,
// //     required Widget page,
// //   }) {
// //     return GestureDetector(
// //       onTap: () => _openPart(page),
// //       child: Card(
// //         elevation: 6,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         shadowColor: color.withOpacity(0.3),
// //         child: Container(
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(20),
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [
// //                 color.withOpacity(0.15),
// //                 color.withOpacity(0.05),
// //               ],
// //             ),
// //           ),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.15),
// //                   shape: BoxShape.circle,
// //                 ),
// //                 child: Icon(icon, size: 40, color: color),
// //               ),
// //               const SizedBox(height: 12),
// //               Text(
// //                 label,
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.grey[800],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ============================================================
// // // نموذج شراء الكسر (محسّن)
// // // ============================================================
// // class ScrapAddForm extends StatefulWidget {
// //   const ScrapAddForm({super.key});

// //   @override
// //   State<ScrapAddForm> createState() => _ScrapAddFormState();
// // }

// // class _ScrapAddFormState extends State<ScrapAddForm> {
// //   final _formKey = GlobalKey<FormState>();
// //   String carat = "18";
// //   final weightController = TextEditingController();
// //   final cashController = TextEditingController();
// //   final networkController = TextEditingController();
// //   final personController = TextEditingController();
// //   final notesController = TextEditingController();
// //   String paymentType = "كاش";
// //   DateTime date = DateTime.now();
// //   bool isLoading = false;

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
// //     if (!_formKey.currentState!.validate()) return;

// //     if (weightController.text.isEmpty) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
// //       return;
// //     }

// //     double cashVal = 0;
// //     double netVal = 0;

// //     if (paymentType == "كاش") {
// //       cashVal = double.tryParse(cashController.text) ?? 0;
// //     } else if (paymentType == "شبكة") {
// //       netVal = double.tryParse(networkController.text) ?? 0;
// //     } else if (paymentType == "متعدد") {
// //       cashVal = double.tryParse(cashController.text) ?? 0;
// //       netVal = double.tryParse(networkController.text) ?? 0;
// //     }

// //     double total = cashVal + netVal;

// //     if (total == 0) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
// //       return;
// //     }

// //     if (personController.text.trim().isEmpty) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
// //           Colors.red);
// //       return;
// //     }

// //     setState(() => isLoading = true);

// //     try {
// //       await FS.saveScrapAdd({
// //         "carat": carat,
// //         "weight": double.tryParse(weightController.text) ?? 0,
// //         "person": personController.text.trim(),
// //         "paymentType": paymentType,
// //         "cash": cashVal,
// //         "network": netVal,
// //         "total": total,
// //         "date": date,
// //         "notes": notesController.text.trim(),
// //         "type": "add",
// //         "createdAt": FieldValue.serverTimestamp(),
// //       });

// //       setState(() {
// //         weightController.clear();
// //         cashController.clear();
// //         networkController.clear();
// //         notesController.clear();
// //         personController.clear();
// //         paymentType = 'كاش';
// //         carat = '18';
// //         isLoading = false;
// //       });

// //       _showSnackbar(
// //           _t("✅ تم تسجيل الشراء بنجاح", "✅ Purchase saved successfully"),
// //           Colors.green);
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //       _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
// //     }
// //   }

// //   void _showSnackbar(String msg, Color color) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(msg),
// //         backgroundColor: color,
// //         behavior: SnackBarBehavior.floating,
// //         duration: const Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final df = DateFormat("yyyy-MM-dd");
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("شراء كسر", "Buy Scrap")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         elevation: 0,
// //         centerTitle: true,
// //         actions: [
// //           if (isLoading)
// //             const Padding(
// //               padding: EdgeInsets.all(16),
// //               child: CircularProgressIndicator(color: Colors.white),
// //             ),
// //         ],
// //       ),
// //       body: Form(
// //         key: _formKey,
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Card(
// //             elevation: 4,
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildSectionTitle(_t("بيانات العملية", "Transaction Data"),
// //                       Icons.info_outline),
// //                   const SizedBox(height: 16),

// //                   // اسم الشخص
// //                   TextFormField(
// //                     controller: personController,
// //                     decoration: InputDecoration(
// //                       labelText: _t("اسم الشخص", "Person Name"),
// //                       hintText: _t("أدخل اسم العميل", "Enter client name"),
// //                       prefixIcon:
// //                           const Icon(Icons.person, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     validator: (v) => v!.trim().isEmpty
// //                         ? _t("الاسم مطلوب", "Name is required")
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // العيار
// //                   DropdownButtonFormField(
// //                     value: carat,
// //                     decoration: InputDecoration(
// //                       labelText: _t("العيار", "Carat"),
// //                       prefixIcon:
// //                           const Icon(Icons.star, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     items: ["14", "18", "21", "22", "24"]
// //                         .map((e) => DropdownMenuItem(
// //                               value: e,
// //                               child: Text("${_t("عيار", "Carat")} $e"),
// //                             ))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => carat = v ?? "18"),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // الوزن
// //                   TextFormField(
// //                     controller: weightController,
// //                     decoration: InputDecoration(
// //                       labelText: _t("الوزن (جم)", "Weight (g)"),
// //                       hintText:
// //                           _t("أدخل الوزن بالجرام", "Enter weight in grams"),
// //                       prefixIcon: const Icon(Icons.fitness_center,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                     validator: (v) => v!.isEmpty
// //                         ? _t("الوزن مطلوب", "Weight is required")
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // طريقة الدفع
// //                   DropdownButtonFormField(
// //                     value: paymentType,
// //                     decoration: InputDecoration(
// //                       labelText: _t("طريقة الدفع", "Payment Type"),
// //                       prefixIcon:
// //                           const Icon(Icons.payment, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     items: ["كاش", "شبكة", "متعدد"]
// //                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // المبالغ
// //                   if (paymentType == "كاش" || paymentType == "متعدد")
// //                     TextFormField(
// //                       controller: cashController,
// //                       decoration: InputDecoration(
// //                         labelText: _t("المبلغ كاش", "Cash Amount"),
// //                         hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
// //                         prefixIcon:
// //                             const Icon(Icons.money, color: Colors.green),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   if (paymentType == "متعدد") const SizedBox(height: 12),
// //                   if (paymentType == "شبكة" || paymentType == "متعدد")
// //                     TextFormField(
// //                       controller: networkController,
// //                       decoration: InputDecoration(
// //                         labelText: _t("المبلغ شبكة", "Card Amount"),
// //                         hintText:
// //                             _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
// //                         prefixIcon:
// //                             const Icon(Icons.credit_card, color: Colors.blue),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   const SizedBox(height: 16),

// //                   // التاريخ
// //                   ListTile(
// //                     contentPadding: EdgeInsets.zero,
// //                     title: Text(
// //                       "${_t("التاريخ", "Date")}: ${df.format(date)}",
// //                       style: const TextStyle(fontSize: 16),
// //                     ),
// //                     trailing: IconButton(
// //                       icon: const Icon(Icons.calendar_today,
// //                           color: Color(0xFFD4AF37)),
// //                       onPressed: () async {
// //                         final d = await showDatePicker(
// //                           context: context,
// //                           initialDate: date,
// //                           firstDate: DateTime(2020),
// //                           lastDate: DateTime(2030),
// //                         );
// //                         if (d != null) setState(() => date = d);
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // ملاحظات
// //                   TextFormField(
// //                     controller: notesController,
// //                     maxLines: 2,
// //                     decoration: InputDecoration(
// //                       labelText: _t('ملاحظات', 'Notes'),
// //                       hintText:
// //                           _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
// //                       prefixIcon:
// //                           const Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // زر الحفظ
// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 55,
// //                     child: ElevatedButton(
// //                       onPressed: isLoading ? null : _save,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         elevation: 3,
// //                       ),
// //                       child: isLoading
// //                           ? const SizedBox(
// //                               height: 20,
// //                               width: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : Text(
// //                               _t("💾 حفظ العملية", "💾 Save Transaction"),
// //                               style: const TextStyle(
// //                                   fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
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

// //   Widget _buildSectionTitle(String title, IconData icon) {
// //     return Row(
// //       children: [
// //         Icon(icon, color: const Color(0xFFD4AF37), size: 22),
// //         const SizedBox(width: 8),
// //         Text(
// //           title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ============================================================
// // // نموذج بيع الكسر (محسّن)
// // // ============================================================
// // class ScrapSaleForm extends StatefulWidget {
// //   const ScrapSaleForm({super.key});

// //   @override
// //   State<ScrapSaleForm> createState() => _ScrapSaleFormState();
// // }

// // class _ScrapSaleFormState extends State<ScrapSaleForm> {
// //   final _formKey = GlobalKey<FormState>();
// //   final weightController = TextEditingController();
// //   final cashController = TextEditingController();
// //   final networkController = TextEditingController();
// //   final personController = TextEditingController();
// //   final notesController = TextEditingController();
// //   String carat = "18";
// //   String paymentType = "كاش";
// //   DateTime date = DateTime.now();
// //   bool isLoading = false;

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

// //   Future<double> _getCurrentBalance(String carat) async {
// //     try {
// //       final txs = await FS.getScrapTransactionsByCarat(carat);
// //       double balance = 0;
// //       for (var t in txs) {
// //         final type = t["type"];
// //         final weight = (t["weight"] ?? 0).toDouble();
// //         if (type == "add" || type == "transform") {
// //           balance += weight;
// //         } else if (type == "sale" || type == "payment") {
// //           balance -= weight.abs();
// //         }
// //       }
// //       return balance;
// //     } catch (e) {
// //       return 0;
// //     }
// //   }

// //   Future<void> _save() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     if (weightController.text.isEmpty) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك ادخل الوزن", "⚠️ Please enter weight"), Colors.red);
// //       return;
// //     }

// //     double weight = double.tryParse(weightController.text) ?? 0;

// //     // التحقق من الرصيد
// //     double balance = await _getCurrentBalance(carat);
// //     if (weight > balance) {
// //       _showSnackbar(
// //         _t("⚠️ الرصيد غير كافٍ! المتوفر: $balance جم",
// //             "⚠️ Insufficient balance! Available: $balance g"),
// //         Colors.red,
// //       );
// //       return;
// //     }

// //     double cashVal = 0;
// //     double netVal = 0;

// //     if (paymentType == "كاش") {
// //       cashVal = double.tryParse(cashController.text) ?? 0;
// //     } else if (paymentType == "شبكة") {
// //       netVal = double.tryParse(networkController.text) ?? 0;
// //     } else if (paymentType == "متعدد") {
// //       cashVal = double.tryParse(cashController.text) ?? 0;
// //       netVal = double.tryParse(networkController.text) ?? 0;
// //     }

// //     double total = cashVal + netVal;

// //     if (total == 0) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك أدخل المبلغ", "⚠️ Please enter amount"), Colors.red);
// //       return;
// //     }

// //     if (personController.text.trim().isEmpty) {
// //       _showSnackbar(
// //           _t("⚠️ من فضلك ادخل اسم الشخص", "⚠️ Please enter person name"),
// //           Colors.red);
// //       return;
// //     }

// //     setState(() => isLoading = true);

// //     try {
// //       await FS.saveScrapSale({
// //         "carat": carat,
// //         "weight": weight,
// //         "person": personController.text.trim(),
// //         "paymentType": paymentType,
// //         "cash": cashVal,
// //         "network": netVal,
// //         "total": total,
// //         "date": date,
// //         "notes": notesController.text.trim(),
// //         "type": "sale",
// //         "createdAt": FieldValue.serverTimestamp(),
// //       });

// //       setState(() {
// //         weightController.clear();
// //         cashController.clear();
// //         networkController.clear();
// //         notesController.clear();
// //         personController.clear();
// //         paymentType = 'كاش';
// //         carat = '18';
// //         isLoading = false;
// //       });

// //       _showSnackbar(_t("✅ تم تسجيل البيع بنجاح", "✅ Sale saved successfully"),
// //           Colors.green);
// //     } catch (e) {
// //       setState(() => isLoading = false);
// //       _showSnackbar(_t("❌ حدث خطأ: ", "❌ Error: ") + e.toString(), Colors.red);
// //     }
// //   }

// //   void _showSnackbar(String msg, Color color) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(msg),
// //         backgroundColor: color,
// //         behavior: SnackBarBehavior.floating,
// //         duration: const Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final df = DateFormat("yyyy-MM-dd");
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("بيع كسر", "Sell Scrap")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         elevation: 0,
// //         centerTitle: true,
// //         actions: [
// //           if (isLoading)
// //             const Padding(
// //               padding: EdgeInsets.all(16),
// //               child: CircularProgressIndicator(color: Colors.white),
// //             ),
// //         ],
// //       ),
// //       body: Form(
// //         key: _formKey,
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(16),
// //           child: Card(
// //             elevation: 4,
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //             child: Padding(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   _buildSectionTitle(
// //                       _t("بيانات البيع", "Sale Data"), Icons.info_outline),
// //                   const SizedBox(height: 16),

// //                   // اسم الشخص
// //                   TextFormField(
// //                     controller: personController,
// //                     decoration: InputDecoration(
// //                       labelText: _t("اسم الشخص", "Person Name"),
// //                       hintText: _t("أدخل اسم العميل", "Enter client name"),
// //                       prefixIcon:
// //                           const Icon(Icons.person, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     validator: (v) => v!.trim().isEmpty
// //                         ? _t("الاسم مطلوب", "Name is required")
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // العيار
// //                   DropdownButtonFormField(
// //                     value: carat,
// //                     decoration: InputDecoration(
// //                       labelText: _t("العيار", "Carat"),
// //                       prefixIcon:
// //                           const Icon(Icons.star, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     items: ["14", "18", "21", "22", "24"]
// //                         .map((e) => DropdownMenuItem(
// //                               value: e,
// //                               child: Text("${_t("عيار", "Carat")} $e"),
// //                             ))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => carat = v ?? "18"),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // الوزن
// //                   TextFormField(
// //                     controller: weightController,
// //                     decoration: InputDecoration(
// //                       labelText: _t("الوزن (جم)", "Weight (g)"),
// //                       hintText:
// //                           _t("أدخل الوزن بالجرام", "Enter weight in grams"),
// //                       prefixIcon: const Icon(Icons.fitness_center,
// //                           color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                     validator: (v) => v!.isEmpty
// //                         ? _t("الوزن مطلوب", "Weight is required")
// //                         : null,
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // طريقة الدفع
// //                   DropdownButtonFormField(
// //                     value: paymentType,
// //                     decoration: InputDecoration(
// //                       labelText: _t("طريقة الدفع", "Payment Type"),
// //                       prefixIcon:
// //                           const Icon(Icons.payment, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                     items: ["كاش", "شبكة", "متعدد"]
// //                         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
// //                         .toList(),
// //                     onChanged: (v) => setState(() => paymentType = v ?? "كاش"),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // المبالغ
// //                   if (paymentType == "كاش" || paymentType == "متعدد")
// //                     TextFormField(
// //                       controller: cashController,
// //                       decoration: InputDecoration(
// //                         labelText: _t("المبلغ كاش", "Cash Amount"),
// //                         hintText: _t("أدخل المبلغ نقداً", "Enter cash amount"),
// //                         prefixIcon:
// //                             const Icon(Icons.money, color: Colors.green),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   if (paymentType == "متعدد") const SizedBox(height: 12),
// //                   if (paymentType == "شبكة" || paymentType == "متعدد")
// //                     TextFormField(
// //                       controller: networkController,
// //                       decoration: InputDecoration(
// //                         labelText: _t("المبلغ شبكة", "Card Amount"),
// //                         hintText:
// //                             _t("أدخل المبلغ بالبطاقة", "Enter card amount"),
// //                         prefixIcon:
// //                             const Icon(Icons.credit_card, color: Colors.blue),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   const SizedBox(height: 16),

// //                   // التاريخ
// //                   ListTile(
// //                     contentPadding: EdgeInsets.zero,
// //                     title: Text(
// //                       "${_t("التاريخ", "Date")}: ${df.format(date)}",
// //                       style: const TextStyle(fontSize: 16),
// //                     ),
// //                     trailing: IconButton(
// //                       icon: const Icon(Icons.calendar_today,
// //                           color: Color(0xFFD4AF37)),
// //                       onPressed: () async {
// //                         final d = await showDatePicker(
// //                           context: context,
// //                           initialDate: date,
// //                           firstDate: DateTime(2020),
// //                           lastDate: DateTime(2030),
// //                         );
// //                         if (d != null) setState(() => date = d);
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // ملاحظات
// //                   TextFormField(
// //                     controller: notesController,
// //                     maxLines: 2,
// //                     decoration: InputDecoration(
// //                       labelText: _t('ملاحظات', 'Notes'),
// //                       hintText:
// //                           _t('أضف ملاحظات (اختياري)', 'Add notes (optional)'),
// //                       prefixIcon:
// //                           const Icon(Icons.note, color: Color(0xFFD4AF37)),
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 24),

// //                   // زر الحفظ
// //                   SizedBox(
// //                     width: double.infinity,
// //                     height: 55,
// //                     child: ElevatedButton(
// //                       onPressed: isLoading ? null : _save,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFFD4AF37),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         elevation: 3,
// //                       ),
// //                       child: isLoading
// //                           ? const SizedBox(
// //                               height: 20,
// //                               width: 20,
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Colors.white,
// //                               ),
// //                             )
// //                           : Text(
// //                               _t("💾 تسجيل البيع", "💾 Save Sale"),
// //                               style: const TextStyle(
// //                                   fontSize: 18, fontWeight: FontWeight.bold),
// //                             ),
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

// //   Widget _buildSectionTitle(String title, IconData icon) {
// //     return Row(
// //       children: [
// //         Icon(icon, color: const Color(0xFFD4AF37), size: 22),
// //         const SizedBox(width: 8),
// //         Text(
// //           title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ============================================================
// // // صفحة التقارير (محسّنة - مع إظهار العيارات بشكل منفصل)
// // // ============================================================

// // // ============================================================
// // // صفحة التقارير (محسّنة - مع إظهار العيارات بشكل منفصل)
// // // ============================================================
// // class ScrapReports extends StatefulWidget {
// //   const ScrapReports({super.key});

// //   @override
// //   State<ScrapReports> createState() => _ScrapReportsState();
// // }

// // class _ScrapReportsState extends State<ScrapReports> {
// //   String searchQuery = "";

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

// //   String _formatWeight(double grams) {
// //     if (grams == 0) return "0.000";
// //     bool isNegative = grams < 0;
// //     grams = grams.abs();
// //     String formatted = grams.toStringAsFixed(3);
// //     while (formatted.endsWith('0') && formatted.contains('.')) {
// //       formatted = formatted.substring(0, formatted.length - 1);
// //     }
// //     if (formatted.endsWith('.')) {
// //       formatted = formatted.substring(0, formatted.length - 1);
// //     }
// //     if (!formatted.contains('.')) {
// //       formatted = '$formatted.000';
// //     } else {
// //       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// //       while (decimalPlaces < 3) {
// //         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
// //         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// //       }
// //     }
// //     return isNegative ? "- $formatted" : formatted;
// //   }

// //   double _convertTo24Karat(double weight, String carat) {
// //     if (carat == "24") return weight;
// //     if (carat == "22") return weight * 22 / 24;
// //     if (carat == "21") return weight * 21 / 24;
// //     if (carat == "18") return weight * 18 / 24;
// //     if (carat == "14") return weight * 14 / 24;
// //     return weight;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         elevation: 0,
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: () => setState(() {}),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           // البحث
// //           Container(
// //             padding: const EdgeInsets.all(12),
// //             color: Colors.grey[100],
// //             child: TextField(
// //               decoration: InputDecoration(
// //                 hintText: _t("🔍 بحث باسم الشخص", "🔍 Search by person"),
// //                 prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 filled: true,
// //                 fillColor: Colors.white,
// //                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
// //               ),
// //               onChanged: (val) =>
// //                   setState(() => searchQuery = val.toLowerCase()),
// //             ),
// //           ),
// //           Expanded(
// //             child: StreamBuilder(
// //               stream: FS.scrapTransactionsStream(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.hasError) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(Icons.error_outline,
// //                             size: 60, color: Colors.red[300]),
// //                         const SizedBox(height: 16),
// //                         Text(_t("⚠️ حدث خطأ في تحميل البيانات",
// //                             "⚠️ Error loading data")),
// //                         const SizedBox(height: 8),
// //                         ElevatedButton(
// //                           onPressed: () => setState(() {}),
// //                           child: Text(_t("إعادة المحاولة", "Retry")),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }

// //                 if (!snapshot.hasData) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }

// //                 List<Map<String, dynamic>> allTx =
// //                     List.from(snapshot.data as List);

// //                 if (searchQuery.isNotEmpty) {
// //                   allTx = allTx.where((t) {
// //                     final person = (t["person"] ?? "").toString().toLowerCase();
// //                     return person.contains(searchQuery);
// //                   }).toList();
// //                 }

// //                 if (allTx.isEmpty) {
// //                   return Center(
// //                     child: Column(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(Icons.search_off,
// //                             size: 60, color: Colors.grey[400]),
// //                         const SizedBox(height: 16),
// //                         Text(
// //                           _t("لا توجد معاملات تطابق البحث",
// //                               "No matching transactions"),
// //                           style:
// //                               TextStyle(fontSize: 16, color: Colors.grey[600]),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }

// //                 // ✅ حساب الإحصائيات مع دعم العيارات المتعددة
// //                 Map<String, Map<String, double>> stats = {
// //                   "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// //                   "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// //                   "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// //                   "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// //                 };

// //                 Map<String, double> totalByCarat = {
// //                   "14": 0,
// //                   "18": 0,
// //                   "21": 0,
// //                   "22": 0,
// //                   "24": 0
// //                 };
// //                 double totalCash = 0;
// //                 double totalNetwork = 0;
// //                 double balance24K = 0;

// //                 for (var t in allTx) {
// //                   print(
// //                       '📗 ${t["id"]} | type=${t["type"]} | carat=${t["carat"]} | weight=${t["weight"]} | carats=${t["carats"]}');

// //                   final type = t["type"] ?? "";

// //                   // ✅ معالجة العيارات المتعددة في سند الصرف
// //                   if (type == "payment" &&
// //                       t["carats"] != null &&
// //                       (t["carats"] as List).isNotEmpty) {
// //                     final carats = t["carats"] as List;
// //                     for (var c in carats) {
// //                       final carat = (c['carat'] ?? "18").toString();
// //                       final weight = (c['weight'] ?? 0).toDouble();
// //                       final wage = (c['wage'] ?? 0).toDouble();

// //                       // إضافة إلى إحصائيات الصرف
// //                       if (stats["payment"]!.containsKey(carat)) {
// //                         stats["payment"]![carat] =
// //                             (stats["payment"]![carat] ?? 0) + weight;
// //                       }

// //                       // خصم من الإجمالي لكل عيار
// //                       totalByCarat[carat] =
// //                           (totalByCarat[carat] ?? 0) - weight.abs();

// //                       // خصم من الرصيد 24
// //                       double convertedWeight = _convertTo24Karat(weight, carat);
// //                       balance24K -= convertedWeight.abs();
// //                     }
// //                   }
// //                   // ✅ معالجة العيار الواحد
// //                   else {
// //                     final carat = (t["carat"] ?? "18").toString();
// //                     final weight = (t["weight"] ?? 0).toDouble();

// //                     if (stats.containsKey(type) &&
// //                         stats[type]!.containsKey(carat)) {
// //                       stats[type]![carat] =
// //                           (stats[type]![carat]! + weight).toDouble();

// //                       double signedWeight = weight;
// //                       if (type == "sale" || type == "payment") {
// //                         signedWeight = -weight.abs();
// //                       }
// //                       totalByCarat[carat] =
// //                           (totalByCarat[carat]! + signedWeight).toDouble();

// //                       double convertedWeight = _convertTo24Karat(weight, carat);
// //                       if (type == "add" || type == "transform") {
// //                         balance24K += convertedWeight;
// //                       } else if (type == "sale" || type == "payment") {
// //                         balance24K -= convertedWeight.abs();
// //                       }
// //                     }
// //                   }

// //                   totalCash += (t["cash"] ?? 0).toDouble();
// //                   totalNetwork += (t["network"] ?? 0).toDouble();
// //                 }

// //                 return ListView(
// //                   children: [
// //                     // بطاقة الملخص
// //                     Card(
// //                       margin: const EdgeInsets.all(12),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(16),
// //                       ),
// //                       elevation: 4,
// //                       child: Padding(
// //                         padding: const EdgeInsets.all(16),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Row(
// //                               children: [
// //                                 Icon(Icons.summarize,
// //                                     color: const Color(0xFFD4AF37)),
// //                                 const SizedBox(width: 8),
// //                                 Text(
// //                                   _t("📊 ملخص الإجماليات", "📊 Summary Totals"),
// //                                   style: const TextStyle(
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                                 const Spacer(),
// //                                 Text(
// //                                   "${allTx.length} ${_t("عملية", "transactions")}",
// //                                   style: TextStyle(
// //                                       fontSize: 12, color: Colors.grey[600]),
// //                                 ),
// //                               ],
// //                             ),
// //                             const SizedBox(height: 12),
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 border: Border.all(color: Colors.grey[300]!),
// //                                 borderRadius: BorderRadius.circular(10),
// //                               ),
// //                               child: SingleChildScrollView(
// //                                 scrollDirection: Axis.horizontal,
// //                                 child: DataTable(
// //                                   columnSpacing: 12,
// //                                   headingRowColor: MaterialStateProperty.all(
// //                                     const Color(0xFFD4AF37).withOpacity(0.1),
// //                                   ),
// //                                   columns: [
// //                                     DataColumn(
// //                                         label: Text(_t("العيار", "Carat"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                     DataColumn(
// //                                         label: Text(_t("شراء", "Add"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.green))),
// //                                     DataColumn(
// //                                         label: Text(_t("بيع", "Sale"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.blue))),
// //                                     DataColumn(
// //                                         label: Text(_t("سند صرف", "Payment"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.red))),
// //                                     DataColumn(
// //                                         label: Text(_t("تحويل", "Transform"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold,
// //                                                 color: Colors.orange))),
// //                                     DataColumn(
// //                                         label: Text(_t("الإجمالي", "Total"),
// //                                             style: const TextStyle(
// //                                                 fontWeight: FontWeight.bold))),
// //                                   ],
// //                                   rows: ["14", "18", "21", "22", "24"]
// //                                       .map((carat) {
// //                                     double addVal = stats["add"]![carat]!;
// //                                     double saleVal =
// //                                         stats["sale"]![carat]!.abs();
// //                                     double paymentVal =
// //                                         stats["payment"]![carat]!.abs();
// //                                     double transformVal =
// //                                         stats["transform"]![carat]!;
// //                                     double total = totalByCarat[carat]!;

// //                                     return DataRow(
// //                                       cells: [
// //                                         DataCell(
// //                                             Text("${_t("ع", "C")} $carat")),
// //                                         DataCell(Text(addVal.toStringAsFixed(1),
// //                                             style: const TextStyle(
// //                                                 color: Colors.green))),
// //                                         DataCell(Text(
// //                                             saleVal.toStringAsFixed(1),
// //                                             style: const TextStyle(
// //                                                 color: Colors.blue))),
// //                                         DataCell(Text(
// //                                             paymentVal.toStringAsFixed(1),
// //                                             style: const TextStyle(
// //                                                 color: Colors.red))),
// //                                         DataCell(Text(
// //                                             transformVal.toStringAsFixed(1),
// //                                             style: const TextStyle(
// //                                                 color: Colors.orange))),
// //                                         DataCell(
// //                                           Text(
// //                                             total.toStringAsFixed(1),
// //                                             style: TextStyle(
// //                                               fontWeight: FontWeight.bold,
// //                                               color: total < 0
// //                                                   ? Colors.red
// //                                                   : Colors.green,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     );
// //                                   }).toList(),
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(height: 16),
// //                             Container(
// //                               padding: const EdgeInsets.all(12),
// //                               decoration: BoxDecoration(
// //                                 color: balance24K < 0
// //                                     ? Colors.red.shade50
// //                                     : Colors.green.shade50,
// //                                 borderRadius: BorderRadius.circular(10),
// //                                 border: Border.all(
// //                                   color: balance24K < 0
// //                                       ? Colors.red.shade200
// //                                       : Colors.green.shade200,
// //                                 ),
// //                               ),
// //                               child: Row(
// //                                 mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                 children: [
// //                                   Row(
// //                                     children: [
// //                                       Icon(
// //                                         balance24K < 0
// //                                             ? Icons.warning
// //                                             : Icons.check_circle,
// //                                         color: balance24K < 0
// //                                             ? Colors.red
// //                                             : Colors.green,
// //                                       ),
// //                                       const SizedBox(width: 8),
// //                                       Text(
// //                                         _t("الرصيد الحالي (24)",
// //                                             "Current Balance (24K)"),
// //                                         style: const TextStyle(
// //                                           fontWeight: FontWeight.bold,
// //                                           fontSize: 16,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   Text(
// //                                     _formatWeight(balance24K),
// //                                     style: TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 18,
// //                                       color: balance24K < 0
// //                                           ? Colors.red
// //                                           : Colors.green,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                             const SizedBox(height: 12),
// //                           ],
// //                         ),
// //                       ),
// //                     ),

// //                     // قائمة الأشخاص
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// //                       child: Text(
// //                         _t("👤 قائمة الأشخاص", "👤 Persons List"),
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     _buildPersonsList(allTx),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildPersonsList(List<Map<String, dynamic>> allTx) {
// //     Map<String, List<Map<String, dynamic>>> personsMap = {};
// //     for (var t in allTx) {
// //       String person = (t["person"] ?? "").toString();
// //       if (person.isNotEmpty) {
// //         if (!personsMap.containsKey(person)) {
// //           personsMap[person] = [];
// //         }
// //         personsMap[person]!.add(t);
// //       }
// //     }

// //     List<String> sortedPersons = personsMap.keys.toList()
// //       ..sort((a, b) => a.compareTo(b));

// //     if (sortedPersons.isEmpty) {
// //       return Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(32),
// //           child: Text(
// //             _t("لا يوجد أشخاص", "No persons found"),
// //             style: TextStyle(color: Colors.grey[600]),
// //           ),
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       shrinkWrap: true,
// //       physics: const NeverScrollableScrollPhysics(),
// //       itemCount: sortedPersons.length,
// //       itemBuilder: (context, i) {
// //         String person = sortedPersons[i];
// //         List<Map<String, dynamic>> transactions = personsMap[person]!;

// //         // ✅ حساب رصيد الشخص لكل عيار مع دعم العيارات المتعددة
// //         Map<String, double> balanceByCarat = {
// //           "14": 0,
// //           "18": 0,
// //           "21": 0,
// //           "22": 0,
// //           "24": 0
// //         };
// //         double totalCash = 0;

// //         for (var t in transactions) {
// //           final type = t["type"] ?? "";

// //           // ✅ معالجة سند الصرف متعدد العيارات
// //           if (type == "payment" &&
// //               t["carats"] != null &&
// //               (t["carats"] as List).isNotEmpty) {
// //             final carats = t["carats"] as List;
// //             for (var c in carats) {
// //               final carat = (c['carat'] ?? "18").toString();
// //               final weight = (c['weight'] ?? 0).toDouble();
// //               balanceByCarat[carat] =
// //                   (balanceByCarat[carat] ?? 0) - weight.abs();
// //             }
// //           }
// //           // ✅ معالجة المعاملات العادية
// //           else {
// //             final carat = (t["carat"] ?? "18").toString();
// //             final weight = (t["weight"] ?? 0).toDouble();

// //             if (type == "add" || type == "transform") {
// //               balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
// //             } else if (type == "sale" || type == "payment") {
// //               balanceByCarat[carat] =
// //                   (balanceByCarat[carat] ?? 0) - weight.abs();
// //             }
// //           }
// //           totalCash += (t["cash"] ?? 0).toDouble();
// //         }

// //         // بناء نص الرصيد لكل عيار
// //         List<String> caratBalances = [];
// //         for (var entry in balanceByCarat.entries) {
// //           if (entry.value != 0) {
// //             caratBalances.add("${entry.key}: ${_formatWeight(entry.value)} جم");
// //           }
// //         }
// //         String balanceText = caratBalances.isEmpty
// //             ? _t("مصفى", "Cleared")
// //             : caratBalances.join(" | ");

// //         return Card(
// //           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: ListTile(
// //             leading: CircleAvatar(
// //               backgroundColor: Colors.blue.shade100,
// //               child: const Icon(
// //                 Icons.person,
// //                 color: Colors.blue,
// //               ),
// //             ),
// //             title: Text(
// //               person,
// //               style: const TextStyle(fontWeight: FontWeight.bold),
// //             ),
// //             subtitle: Text(
// //               "${transactions.length} ${_t("عملية", "transactions")} ",
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey[700],
// //               ),
// //             ),
// //             trailing: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 if (totalCash > 0)
// //                   // Text(
// //                   //   "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
// //                   //   style: const TextStyle(
// //                   //     fontSize: 12,
// //                   //     color: Colors.grey,
// //                   //   ),
// //                   // ),
// //                   const SizedBox(width: 8),
// //                 Icon(
// //                   Icons.arrow_forward_ios,
// //                   size: 14,
// //                   color: Colors.grey[400],
// //                 ),
// //               ],
// //             ),
// //             onTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (_) => ScrapPersonDetails(person: person),
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// // // class ScrapReports extends StatefulWidget {
// // //   const ScrapReports({super.key});

// // //   @override
// // //   State<ScrapReports> createState() => _ScrapReportsState();
// // // }

// // // class _ScrapReportsState extends State<ScrapReports> {
// // //   String searchQuery = "";

// // //   String _lang = 'ar';
// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   String _formatWeight(double grams) {
// // //     if (grams == 0) return "0.000";
// // //     bool isNegative = grams < 0;
// // //     grams = grams.abs();
// // //     String formatted = grams.toStringAsFixed(3);
// // //     while (formatted.endsWith('0') && formatted.contains('.')) {
// // //       formatted = formatted.substring(0, formatted.length - 1);
// // //     }
// // //     if (formatted.endsWith('.')) {
// // //       formatted = formatted.substring(0, formatted.length - 1);
// // //     }
// // //     if (!formatted.contains('.')) {
// // //       formatted = '$formatted.000';
// // //     } else {
// // //       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// // //       while (decimalPlaces < 3) {
// // //         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
// // //         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// // //       }
// // //     }
// // //     return isNegative ? "- $formatted" : formatted;
// // //   }

// // //   double _convertTo24Karat(double weight, String carat) {
// // //     if (carat == "24") return weight;
// // //     if (carat == "22") return weight * 22 / 24;
// // //     if (carat == "21") return weight * 21 / 24;
// // //     if (carat == "18") return weight * 18 / 24;
// // //     if (carat == "14") return weight * 14 / 24;
// // //     return weight;
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         elevation: 0,
// // //         centerTitle: true,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.refresh),
// // //             onPressed: () => setState(() {}),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           // البحث
// // //           Container(
// // //             padding: const EdgeInsets.all(12),
// // //             color: Colors.grey[100],
// // //             child: TextField(
// // //               decoration: InputDecoration(
// // //                 hintText: _t("🔍 بحث باسم الشخص", "🔍 Search by person"),
// // //                 prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
// // //                 border: OutlineInputBorder(
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //                 filled: true,
// // //                 fillColor: Colors.white,
// // //                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
// // //               ),
// // //               onChanged: (val) =>
// // //                   setState(() => searchQuery = val.toLowerCase()),
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: StreamBuilder(
// // //               stream: FS.scrapTransactionsStream(),
// // //               builder: (context, snapshot) {
// // //                 if (snapshot.hasError) {
// // //                   return Center(
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.error_outline,
// // //                             size: 60, color: Colors.red[300]),
// // //                         const SizedBox(height: 16),
// // //                         Text(_t("⚠️ حدث خطأ في تحميل البيانات",
// // //                             "⚠️ Error loading data")),
// // //                         const SizedBox(height: 8),
// // //                         ElevatedButton(
// // //                           onPressed: () => setState(() {}),
// // //                           child: Text(_t("إعادة المحاولة", "Retry")),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   );
// // //                 }

// // //                 if (!snapshot.hasData) {
// // //                   return const Center(child: CircularProgressIndicator());
// // //                 }

// // //                 List<Map<String, dynamic>> allTx =
// // //                     List.from(snapshot.data as List);

// // //                 if (searchQuery.isNotEmpty) {
// // //                   allTx = allTx.where((t) {
// // //                     final person = (t["person"] ?? "").toString().toLowerCase();
// // //                     return person.contains(searchQuery);
// // //                   }).toList();
// // //                 }

// // //                 if (allTx.isEmpty) {
// // //                   return Center(
// // //                     child: Column(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.search_off,
// // //                             size: 60, color: Colors.grey[400]),
// // //                         const SizedBox(height: 16),
// // //                         Text(
// // //                           _t("لا توجد معاملات تطابق البحث",
// // //                               "No matching transactions"),
// // //                           style:
// // //                               TextStyle(fontSize: 16, color: Colors.grey[600]),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   );
// // //                 }

// // //                 // حساب الإحصائيات
// // //                 Map<String, Map<String, double>> stats = {
// // //                   "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// // //                   "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// // //                   "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// // //                   "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
// // //                 };

// // //                 Map<String, double> totalByCarat = {
// // //                   "14": 0,
// // //                   "18": 0,
// // //                   "21": 0,
// // //                   "22": 0,
// // //                   "24": 0
// // //                 };
// // //                 double totalCash = 0;
// // //                 double totalNetwork = 0;
// // //                 double balance24K = 0;

// // //                 for (var t in allTx) {
// // //                   final type = t["type"] ?? "";
// // //                   final carat = (t["carat"] ?? "18").toString();
// // //                   final weight = (t["weight"] ?? 0).toDouble();

// // //                   if (stats.containsKey(type) &&
// // //                       stats[type]!.containsKey(carat)) {
// // //                     stats[type]![carat] =
// // //                         (stats[type]![carat]! + weight).toDouble();

// // //                     double signedWeight = weight;
// // //                     if (type == "sale" || type == "payment") {
// // //                       signedWeight = -weight.abs();
// // //                     }
// // //                     totalByCarat[carat] =
// // //                         (totalByCarat[carat]! + signedWeight).toDouble();

// // //                     double convertedWeight = _convertTo24Karat(weight, carat);
// // //                     if (type == "add" || type == "transform") {
// // //                       balance24K += convertedWeight;
// // //                     } else if (type == "sale" || type == "payment") {
// // //                       balance24K -= convertedWeight.abs();
// // //                     }
// // //                   }

// // //                   totalCash += (t["cash"] ?? 0).toDouble();
// // //                   totalNetwork += (t["network"] ?? 0).toDouble();
// // //                 }

// // //                 return ListView(
// // //                   children: [
// // //                     // بطاقة الملخص
// // //                     Card(
// // //                       margin: const EdgeInsets.all(12),
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(16),
// // //                       ),
// // //                       elevation: 4,
// // //                       child: Padding(
// // //                         padding: const EdgeInsets.all(16),
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Row(
// // //                               children: [
// // //                                 Icon(Icons.summarize,
// // //                                     color: const Color(0xFFD4AF37)),
// // //                                 const SizedBox(width: 8),
// // //                                 Text(
// // //                                   _t("📊 ملخص الإجماليات", "📊 Summary Totals"),
// // //                                   style: const TextStyle(
// // //                                     fontSize: 18,
// // //                                     fontWeight: FontWeight.bold,
// // //                                   ),
// // //                                 ),
// // //                                 const Spacer(),
// // //                                 Text(
// // //                                   "${allTx.length} ${_t("عملية", "transactions")}",
// // //                                   style: TextStyle(
// // //                                       fontSize: 12, color: Colors.grey[600]),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             const SizedBox(height: 12),
// // //                             Container(
// // //                               decoration: BoxDecoration(
// // //                                 border: Border.all(color: Colors.grey[300]!),
// // //                                 borderRadius: BorderRadius.circular(10),
// // //                               ),
// // //                               child: SingleChildScrollView(
// // //                                 scrollDirection: Axis.horizontal,
// // //                                 child: DataTable(
// // //                                   columnSpacing: 12,
// // //                                   headingRowColor: MaterialStateProperty.all(
// // //                                     const Color(0xFFD4AF37).withOpacity(0.1),
// // //                                   ),
// // //                                   columns: [
// // //                                     DataColumn(
// // //                                         label: Text(_t("العيار", "Carat"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold))),
// // //                                     DataColumn(
// // //                                         label: Text(_t("شراء", "Add"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold,
// // //                                                 color: Colors.green))),
// // //                                     DataColumn(
// // //                                         label: Text(_t("بيع", "Sale"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold,
// // //                                                 color: Colors.blue))),
// // //                                     DataColumn(
// // //                                         label: Text(_t("سند صرف", "Payment"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold,
// // //                                                 color: Colors.red))),
// // //                                     DataColumn(
// // //                                         label: Text(_t("تحويل", "Transform"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold,
// // //                                                 color: Colors.orange))),
// // //                                     DataColumn(
// // //                                         label: Text(_t("الإجمالي", "Total"),
// // //                                             style: const TextStyle(
// // //                                                 fontWeight: FontWeight.bold))),
// // //                                   ],
// // //                                   rows: ["14", "18", "21", "22", "24"]
// // //                                       .map((carat) {
// // //                                     double addVal = stats["add"]![carat]!;
// // //                                     double saleVal =
// // //                                         stats["sale"]![carat]!.abs();
// // //                                     double paymentVal =
// // //                                         stats["payment"]![carat]!.abs();
// // //                                     double transformVal =
// // //                                         stats["transform"]![carat]!;
// // //                                     double total = totalByCarat[carat]!;

// // //                                     return DataRow(
// // //                                       cells: [
// // //                                         DataCell(
// // //                                             Text("${_t("ع", "C")} $carat")),
// // //                                         DataCell(Text(addVal.toStringAsFixed(1),
// // //                                             style: const TextStyle(
// // //                                                 color: Colors.green))),
// // //                                         DataCell(Text(
// // //                                             saleVal.toStringAsFixed(1),
// // //                                             style: const TextStyle(
// // //                                                 color: Colors.blue))),
// // //                                         DataCell(Text(
// // //                                             paymentVal.toStringAsFixed(1),
// // //                                             style: const TextStyle(
// // //                                                 color: Colors.red))),
// // //                                         DataCell(Text(
// // //                                             transformVal.toStringAsFixed(1),
// // //                                             style: const TextStyle(
// // //                                                 color: Colors.orange))),
// // //                                         DataCell(
// // //                                           Text(
// // //                                             total.toStringAsFixed(1),
// // //                                             style: TextStyle(
// // //                                               fontWeight: FontWeight.bold,
// // //                                               color: total < 0
// // //                                                   ? Colors.red
// // //                                                   : Colors.green,
// // //                                             ),
// // //                                           ),
// // //                                         ),
// // //                                       ],
// // //                                     );
// // //                                   }).toList(),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             const SizedBox(height: 16),
// // //                             Container(
// // //                               padding: const EdgeInsets.all(12),
// // //                               decoration: BoxDecoration(
// // //                                 color: balance24K < 0
// // //                                     ? Colors.red.shade50
// // //                                     : Colors.green.shade50,
// // //                                 borderRadius: BorderRadius.circular(10),
// // //                                 border: Border.all(
// // //                                   color: balance24K < 0
// // //                                       ? Colors.red.shade200
// // //                                       : Colors.green.shade200,
// // //                                 ),
// // //                               ),
// // //                               child: Row(
// // //                                 mainAxisAlignment:
// // //                                     MainAxisAlignment.spaceBetween,
// // //                                 children: [
// // //                                   Row(
// // //                                     children: [
// // //                                       Icon(
// // //                                         balance24K < 0
// // //                                             ? Icons.warning
// // //                                             : Icons.check_circle,
// // //                                         color: balance24K < 0
// // //                                             ? Colors.red
// // //                                             : Colors.green,
// // //                                       ),
// // //                                       const SizedBox(width: 8),
// // //                                       Text(
// // //                                         _t("الرصيد الحالي (24)",
// // //                                             "Current Balance (24K)"),
// // //                                         style: const TextStyle(
// // //                                           fontWeight: FontWeight.bold,
// // //                                           fontSize: 16,
// // //                                         ),
// // //                                       ),
// // //                                     ],
// // //                                   ),
// // //                                   Text(
// // //                                     _formatWeight(balance24K),
// // //                                     style: TextStyle(
// // //                                       fontWeight: FontWeight.bold,
// // //                                       fontSize: 18,
// // //                                       color: balance24K < 0
// // //                                           ? Colors.red
// // //                                           : Colors.green,
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //                             const SizedBox(height: 12),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ),

// // //                     // قائمة الأشخاص (كل شخص وعياراته)
// // //                     Padding(
// // //                       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //                       child: Text(
// // //                         _t("👤 قائمة الأشخاص", "👤 Persons List"),
// // //                         style: const TextStyle(
// // //                           fontSize: 16,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     _buildPersonsList(allTx),
// // //                   ],
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildPersonsList(List<Map<String, dynamic>> allTx) {
// // //     Map<String, List<Map<String, dynamic>>> personsMap = {};
// // //     for (var t in allTx) {
// // //       String person = (t["person"] ?? "").toString();
// // //       if (person.isNotEmpty) {
// // //         if (!personsMap.containsKey(person)) {
// // //           personsMap[person] = [];
// // //         }
// // //         personsMap[person]!.add(t);
// // //       }
// // //     }

// // //     List<String> sortedPersons = personsMap.keys.toList()
// // //       ..sort((a, b) => a.compareTo(b));

// // //     if (sortedPersons.isEmpty) {
// // //       return Center(
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(32),
// // //           child: Text(
// // //             _t("لا يوجد أشخاص", "No persons found"),
// // //             style: TextStyle(color: Colors.grey[600]),
// // //           ),
// // //         ),
// // //       );
// // //     }

// // //     return ListView.builder(
// // //       shrinkWrap: true,
// // //       physics: const NeverScrollableScrollPhysics(),
// // //       itemCount: sortedPersons.length,
// // //       itemBuilder: (context, i) {
// // //         String person = sortedPersons[i];
// // //         List<Map<String, dynamic>> transactions = personsMap[person]!;

// // //         // حساب رصيد الشخص لكل عيار
// // //         Map<String, double> balanceByCarat = {
// // //           "14": 0,
// // //           "18": 0,
// // //           "21": 0,
// // //           "22": 0,
// // //           "24": 0
// // //         };
// // //         double totalCash = 0;

// // //         for (var t in transactions) {
// // //           final type = t["type"] ?? "";
// // //           final carat = (t["carat"] ?? "18").toString();
// // //           final weight = (t["weight"] ?? 0).toDouble();

// // //           if (type == "add" || type == "transform") {
// // //             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
// // //           } else if (type == "sale" || type == "payment") {
// // //             balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) - weight.abs();
// // //           }
// // //           totalCash += (t["cash"] ?? 0).toDouble();
// // //         }

// // //         // بناء نص الرصيد لكل عيار على حدة
// // //         List<String> caratBalances = [];
// // //         for (var entry in balanceByCarat.entries) {
// // //           if (entry.value != 0) {
// // //             caratBalances.add("${entry.key}: ${_formatWeight(entry.value)} جم");
// // //           }
// // //         }
// // //         String balanceText = caratBalances.isEmpty
// // //             ? _t("مصفى", "Cleared")
// // //             : caratBalances.join(" | ");

// // //         return Card(
// // //           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //           ),
// // //           child: ListTile(
// // //             leading: CircleAvatar(
// // //               backgroundColor: Colors.blue.shade100,
// // //               child: const Icon(
// // //                 Icons.person,
// // //                 color: Colors.blue,
// // //               ),
// // //             ),
// // //             title: Text(
// // //               person,
// // //               style: const TextStyle(fontWeight: FontWeight.bold),
// // //             ),
// // //             subtitle: Text(
// // //               "${transactions.length} ${_t("عملية", "transactions")} • $balanceText",
// // //               style: TextStyle(
// // //                 fontSize: 12,
// // //                 color: Colors.grey[700],
// // //               ),
// // //             ),
// // //             trailing: Row(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 if (totalCash > 0)
// // //                   Text(
// // //                     "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
// // //                     style: const TextStyle(
// // //                       fontSize: 12,
// // //                       color: Colors.grey,
// // //                     ),
// // //                   ),
// // //                 const SizedBox(width: 8),
// // //                 Icon(
// // //                   Icons.arrow_forward_ios,
// // //                   size: 14,
// // //                   color: Colors.grey[400],
// // //                 ),
// // //               ],
// // //             ),
// // //             onTap: () {
// // //               Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(
// // //                   builder: (_) => ScrapPersonDetails(person: person),
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }

// // // ============================================================
// // // صفحة تفاصيل الشخص (محسّنة - بدون تجميع السندات)
// // // ============================================================
// // class ScrapPersonDetails extends StatefulWidget {
// //   final String person;
// //   const ScrapPersonDetails({super.key, required this.person});

// //   @override
// //   State<ScrapPersonDetails> createState() => _ScrapPersonDetailsState();
// // }

// // class _ScrapPersonDetailsState extends State<ScrapPersonDetails> {
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

// //   String _formatWeight(double grams) {
// //     if (grams == 0) return "0.000";
// //     bool isNegative = grams < 0;
// //     grams = grams.abs();
// //     String formatted = grams.toStringAsFixed(3);
// //     while (formatted.endsWith('0') && formatted.contains('.')) {
// //       formatted = formatted.substring(0, formatted.length - 1);
// //     }
// //     if (formatted.endsWith('.')) {
// //       formatted = formatted.substring(0, formatted.length - 1);
// //     }
// //     if (!formatted.contains('.')) {
// //       formatted = '$formatted.000';
// //     } else {
// //       int decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// //       while (decimalPlaces < 3) {
// //         formatted = '$formatted${'0' * (3 - decimalPlaces)}';
// //         decimalPlaces = formatted.length - formatted.indexOf('.') - 1;
// //       }
// //     }
// //     return isNegative ? "- $formatted" : formatted;
// //   }

// //   double _convertTo24Karat(double weight, String carat) {
// //     if (carat == "24") return weight;
// //     if (carat == "22") return weight * 22 / 24;
// //     if (carat == "21") return weight * 21 / 24;
// //     if (carat == "18") return weight * 18 / 24;
// //     if (carat == "14") return weight * 14 / 24;
// //     return weight;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("معاملات ", "Transactions of ") + widget.person),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         elevation: 0,
// //         centerTitle: true,
// //       ),
// //       body: FutureBuilder(
// //         future: FS.getScrapTransactions(widget.person),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
// //                   const SizedBox(height: 16),
// //                   Text(_t("⚠️ حدث خطأ", "⚠️ Error")),
// //                   ElevatedButton(
// //                     onPressed: () => setState(() {}),
// //                     child: Text(_t("إعادة المحاولة", "Retry")),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }

// //           if (!snapshot.hasData) {
// //             return const Center(child: CircularProgressIndicator());
// //           }

// //           List<Map<String, dynamic>> txs =
// //               List.from(snapshot.data as List<Map<String, dynamic>>);

// //           if (txs.isEmpty) {
// //             return Center(
// //               child: Text(_t("لا توجد معاملات لهذا الشخص",
// //                   "No transactions for this person")),
// //             );
// //           }

// //           // ✅ ترتيب المعاملات من الأحدث إلى الأقدم
// //           txs.sort((a, b) {
// //             final dateA = a['date'] as Timestamp?;
// //             final dateB = b['date'] as Timestamp?;
// //             if (dateA == null && dateB == null) return 0;
// //             if (dateA == null) return 1;
// //             if (dateB == null) return -1;
// //             return dateB.toDate().compareTo(dateA.toDate());
// //           });

// //           // حساب الإحصائيات لكل عيار
// //           Map<String, double> balanceByCarat = {
// //             "14": 0,
// //             "18": 0,
// //             "21": 0,
// //             "22": 0,
// //             "24": 0
// //           };
// //           double totalCash = 0;
// //           double totalNetwork = 0;
// //           double balance24K = 0;

// //           for (var t in txs) {
// //             final type = t["type"] ?? "";

// //             if (type == "payment" &&
// //                 t["carats"] != null &&
// //                 (t["carats"] as List).isNotEmpty) {
// //               final carats = t["carats"] as List;
// //               for (var c in carats) {
// //                 final carat = (c['carat'] ?? "18").toString();
// //                 final weight = (c['weight'] ?? 0).toDouble();
// //                 double convertedWeight = _convertTo24Karat(weight, carat);
// //                 balanceByCarat[carat] =
// //                     (balanceByCarat[carat] ?? 0) - weight.abs();
// //                 balance24K -= convertedWeight.abs();
// //               }
// //             } else {
// //               final carat = (t["carat"] ?? "18").toString();
// //               final weight = (t["weight"] ?? 0).toDouble();
// //               double convertedWeight = _convertTo24Karat(weight, carat);

// //               if (type == "add") {
// //                 balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
// //                 balance24K += convertedWeight;
// //               } else if (type == "sale") {
// //                 balanceByCarat[carat] =
// //                     (balanceByCarat[carat] ?? 0) - weight.abs();
// //                 balance24K -= convertedWeight.abs();
// //               } else if (type == "payment") {
// //                 balanceByCarat[carat] =
// //                     (balanceByCarat[carat] ?? 0) - weight.abs();
// //                 balance24K -= convertedWeight.abs();
// //               } else if (type == "transform") {
// //                 balanceByCarat[carat] = (balanceByCarat[carat] ?? 0) + weight;
// //                 balance24K += convertedWeight;
// //               }
// //             }

// //             totalCash += (t["cash"] ?? 0).toDouble();
// //             totalNetwork += (t["network"] ?? 0).toDouble();
// //           }

// //           // بناء نص الرصيد لكل عيار
// //           List<String> caratBalances = [];
// //           for (var entry in balanceByCarat.entries) {
// //             if (entry.value != 0) {
// //               caratBalances
// //                   .add("${entry.key}: ${_formatWeight(entry.value)} جم");
// //             }
// //           }
// //           String balanceText = caratBalances.isEmpty
// //               ? _t("مصفى", "Cleared")
// //               : caratBalances.join(" | ");

// //           return Column(
// //             children: [
// //               // بطاقة الملخص
// //               Card(
// //                 margin: const EdgeInsets.all(12),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16),
// //                 ),
// //                 elevation: 4,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(16),
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           CircleAvatar(
// //                             backgroundColor: balance24K < 0
// //                                 ? Colors.red.shade100
// //                                 : Colors.green.shade100,
// //                             child: Icon(
// //                               Icons.person,
// //                               color: balance24K < 0 ? Colors.red : Colors.green,
// //                               size: 30,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 12),
// //                           Expanded(
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   widget.person,
// //                                   style: const TextStyle(
// //                                     fontSize: 18,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const Divider(),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: Container(
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.green.shade50,
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border:
// //                                     Border.all(color: Colors.green.shade200),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Text(_t("نقد", "Cash"),
// //                                       style: TextStyle(
// //                                           fontSize: 12,
// //                                           color: Colors.grey[600])),
// //                                   Text(
// //                                       "${totalCash.toStringAsFixed(0)} ${_t("ج", "EGP")}",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold)),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Container(
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.blue.shade50,
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border: Border.all(color: Colors.blue.shade200),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Text(_t("شبكة", "Card"),
// //                                       style: TextStyle(
// //                                           fontSize: 12,
// //                                           color: Colors.grey[600])),
// //                                   Text(
// //                                       "${totalNetwork.toStringAsFixed(0)} ${_t("ج", "EGP")}",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold)),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             child: Container(
// //                               padding: const EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.purple.shade50,
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 border:
// //                                     Border.all(color: Colors.purple.shade200),
// //                               ),
// //                               child: Column(
// //                                 children: [
// //                                   Text(_t("الإجمالي", "Total"),
// //                                       style: TextStyle(
// //                                           fontSize: 12,
// //                                           color: Colors.grey[600])),
// //                                   Text(
// //                                       "${(totalCash + totalNetwork).toStringAsFixed(0)} ${_t("ج", "EGP")}",
// //                                       style: const TextStyle(
// //                                           fontWeight: FontWeight.bold)),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               // ✅ قائمة المعاملات (بدون تجميع)
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: txs.length,
// //                   itemBuilder: (context, i) {
// //                     final t = txs[i];
// //                     final type = t['type'] ?? "";
// //                     final date = (t['date'] as Timestamp).toDate();
// //                     final formattedDate =
// //                         DateFormat("yyyy-MM-dd HH:mm").format(date);

// //                     // ============================================================
// //                     // ✅ سند صرف (عيار واحد أو متعدد)
// //                     // ============================================================
// //                     if (type == 'payment') {
// //                       // الحصول على العيارات
// //                       List<Map<String, dynamic>> carats = [];
// //                       double totalWeight = 0;
// //                       double totalWage = 0;
// //                       String delegate = t['delegate'] ?? '';
// //                       String notes = t['notes'] ?? '';

// //                       if (t['carats'] != null &&
// //                           (t['carats'] as List).isNotEmpty) {
// //                         carats = List.from(t['carats'] as List);
// //                         totalWeight = t['totalWeight'] ?? 0.0;
// //                         totalWage = t['totalWage'] ?? 0.0;

// //                         // إذا كان هناك carats ولكن totalWeight غير موجود
// //                         if (totalWeight == 0 && carats.isNotEmpty) {
// //                           for (var c in carats) {
// //                             totalWeight += (c['weight'] ?? 0).toDouble();
// //                             totalWage += (c['wage'] ?? 0).toDouble();
// //                           }
// //                         }
// //                       } else {
// //                         // عيار واحد
// //                         carats.add({
// //                           'carat': t['carat'] ?? '18',
// //                           'weight': (t['weight'] ?? 0).toDouble(),
// //                           'wage': (t['wage'] ?? 0).toDouble(),
// //                         });
// //                         totalWeight = (t['weight'] ?? 0).toDouble();
// //                         totalWage = (t['wage'] ?? 0).toDouble();
// //                       }

// //                       return Card(
// //                         margin: const EdgeInsets.symmetric(
// //                             horizontal: 12, vertical: 6),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         elevation: 2,
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(16),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               // ✅ العنوان
// //                               Row(
// //                                 children: [
// //                                   CircleAvatar(
// //                                     backgroundColor:
// //                                         Colors.red.withOpacity(0.15),
// //                                     radius: 18,
// //                                     child: const Icon(
// //                                       Icons.receipt_long,
// //                                       color: Colors.red,
// //                                       size: 20,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(width: 12),
// //                                   Expanded(
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text(
// //                                           _t("سند صرف", "Payment Voucher"),
// //                                           style: const TextStyle(
// //                                             fontWeight: FontWeight.bold,
// //                                             fontSize: 16,
// //                                           ),
// //                                         ),
// //                                         if (delegate.isNotEmpty)
// //                                           Text(
// //                                             "مندوب: $delegate",
// //                                             style: TextStyle(
// //                                               fontSize: 13,
// //                                               color: Colors.grey[700],
// //                                             ),
// //                                           ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   Text(
// //                                     formattedDate,
// //                                     style: TextStyle(
// //                                       fontSize: 12,
// //                                       color: Colors.grey[500],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                               const SizedBox(height: 12),
// //                               const Divider(height: 1),
// //                               const SizedBox(height: 12),

// //                               // ✅ عرض كل عيار
// //                               ...carats.map((c) {
// //                                 final carat = c['carat'] ?? '18';
// //                                 final weight = (c['weight'] ?? 0).toDouble();
// //                                 final wage = (c['wage'] ?? 0).toDouble();

// //                                 return Padding(
// //                                   padding:
// //                                       const EdgeInsets.symmetric(vertical: 4),
// //                                   child: Row(
// //                                     children: [
// //                                       // العيار
// //                                       Container(
// //                                         padding: const EdgeInsets.symmetric(
// //                                             horizontal: 10, vertical: 4),
// //                                         decoration: BoxDecoration(
// //                                           color: const Color(0xFFD4AF37)
// //                                               .withOpacity(0.15),
// //                                           borderRadius:
// //                                               BorderRadius.circular(8),
// //                                           border: Border.all(
// //                                             color: const Color(0xFFD4AF37)
// //                                                 .withOpacity(0.3),
// //                                           ),
// //                                         ),
// //                                         child: Text(
// //                                           "${_t('عيار', 'Carat')} $carat",
// //                                           style: const TextStyle(
// //                                             fontSize: 13,
// //                                             fontWeight: FontWeight.w600,
// //                                             color: Color(0xFFD4AF37),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 16),
// //                                       // الوزن
// //                                       Text(
// //                                         "${_t('وزن', 'Weight')}: ${weight.toStringAsFixed(2)} ${_t('جم', 'g')}",
// //                                         style: const TextStyle(
// //                                           fontSize: 14,
// //                                           fontWeight: FontWeight.w500,
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 16),
// //                                       // الأجر
// //                                       Text(
// //                                         "${_t('أجر', 'Wage')}: ${wage.toStringAsFixed(2)}",
// //                                         style: const TextStyle(
// //                                           fontSize: 14,
// //                                           fontWeight: FontWeight.w500,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 );
// //                               }).toList(),

// //                               const SizedBox(height: 12),

// //                               // ✅ إجمالي الوزن والأجر
// //                               Container(
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 12, vertical: 10),
// //                                 decoration: BoxDecoration(
// //                                   color:
// //                                       const Color(0xFFD4AF37).withOpacity(0.08),
// //                                   borderRadius: BorderRadius.circular(10),
// //                                   border: Border.all(
// //                                     color: const Color(0xFFD4AF37)
// //                                         .withOpacity(0.2),
// //                                   ),
// //                                 ),
// //                                 child: Row(
// //                                   mainAxisAlignment:
// //                                       MainAxisAlignment.spaceBetween,
// //                                   children: [
// //                                     Text(
// //                                       "${_t('إجمالي الوزن', 'Total Weight')}: ${totalWeight.toStringAsFixed(2)} ${_t('جم', 'g')}",
// //                                       style: const TextStyle(
// //                                         fontWeight: FontWeight.bold,
// //                                         fontSize: 14,
// //                                         color: Color(0xFFD4AF37),
// //                                       ),
// //                                     ),
// //                                     Text(
// //                                       "${_t('إجمالي الأجر', 'Total Wage')}: ${totalWage.toStringAsFixed(2)}",
// //                                       style: const TextStyle(
// //                                         fontWeight: FontWeight.bold,
// //                                         fontSize: 14,
// //                                         color: Color(0xFFD4AF37),
// //                                       ),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ),

// //                               // ✅ الملاحظات
// //                               if (notes.isNotEmpty)
// //                                 Padding(
// //                                   padding: const EdgeInsets.only(top: 10),
// //                                   child: Text(
// //                                     "${_t('ملاحظات', 'Notes')}: $notes",
// //                                     style: TextStyle(
// //                                       fontSize: 13,
// //                                       color: Colors.grey[600],
// //                                     ),
// //                                   ),
// //                                 ),
// //                             ],
// //                           ),
// //                         ),
// //                       );
// //                     }

// //                     // ============================================================
// //                     // ✅ باقي المعاملات (شراء، بيع، تحويل)
// //                     // ============================================================
// //                     final carat = (t['carat'] ?? '18').toString();
// //                     final weight = (t['weight'] ?? 0).toDouble();
// //                     final wage = (t['wage'] ?? 0).toDouble();

// //                     Map<String, dynamic> typeInfo = _getTypeInfo(type);

// //                     return Card(
// //                       margin: const EdgeInsets.symmetric(
// //                           horizontal: 12, vertical: 4),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       child: ListTile(
// //                         leading: CircleAvatar(
// //                           backgroundColor: typeInfo["color"].withOpacity(0.2),
// //                           child:
// //                               Icon(typeInfo["icon"], color: typeInfo["color"]),
// //                         ),
// //                         title: Text(
// //                           typeInfo["label"],
// //                           style: const TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             if (type != 'payment')
// //                               Text("${_t('العيار', 'Carat')}: $carat"),
// //                             Text(
// //                                 "${_t('الوزن', 'Weight')}: ${weight.abs().toStringAsFixed(2)} ${_t('جم', 'g')}"),
// //                             if (wage > 0) Text("${_t('الأجر', 'Wage')}: $wage"),
// //                             if (t['delegate'] != null &&
// //                                 t['delegate'].toString().isNotEmpty)
// //                               Text(
// //                                   "${_t('مندوب', 'Delegate')}: ${t['delegate']}"),
// //                             if (t['notes'] != null &&
// //                                 t['notes'].toString().isNotEmpty)
// //                               Text("${_t('ملاحظات', 'Notes')}: ${t['notes']}"),
// //                             Text("${_t('التاريخ', 'Date')}: $formattedDate"),
// //                           ],
// //                         ),
// //                         trailing: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 8, vertical: 4),
// //                           decoration: BoxDecoration(
// //                             color: type == 'sale' || type == 'payment'
// //                                 ? Colors.red.shade50
// //                                 : Colors.green.shade50,
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             type == 'sale' || type == 'payment'
// //                                 ? "-${weight.abs().toStringAsFixed(2)}"
// //                                 : "+${weight.toStringAsFixed(2)}",
// //                             style: TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                               color: type == 'sale' || type == 'payment'
// //                                   ? Colors.red
// //                                   : Colors.green,
// //                             ),
// //                           ),
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

// //   Map<String, dynamic> _getTypeInfo(String type) {
// //     switch (type) {
// //       case "add":
// //         return {
// //           "label": _t("شراء كسر", "Buy Scrap"),
// //           "icon": Icons.arrow_downward,
// //           "color": Colors.green
// //         };
// //       case "sale":
// //         return {
// //           "label": _t("بيع كسر", "Sell Scrap"),
// //           "icon": Icons.arrow_upward,
// //           "color": Colors.blue
// //         };
// //       case "payment":
// //         return {
// //           "label": _t("سند صرف", "Payment"),
// //           "icon": Icons.receipt_long,
// //           "color": Colors.red
// //         };
// //       case "transform":
// //         return {
// //           "label": _t("تحويل", "Transform"),
// //           "icon": Icons.swap_horiz,
// //           "color": Colors.orange
// //         };
// //       default:
// //         return {"label": type, "icon": Icons.help, "color": Colors.grey};
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/firestore_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ============================================================
// // صفحة الكسر الرئيسية - شراء + تقارير فقط
// // ============================================================
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
//     Navigator.push(context, MaterialPageRoute(builder: (_) => part));
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
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         shadowColor: color.withOpacity(0.3),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
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
// // نموذج شراء الكسر
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
// // صفحة التقارير - التصميم العملي
// // ============================================================
// class ScrapReports extends StatefulWidget {
//   const ScrapReports({super.key});

//   @override
//   State<ScrapReports> createState() => _ScrapReportsState();
// }

// class _ScrapReportsState extends State<ScrapReports>
//     with SingleTickerProviderStateMixin {
//   String searchQuery = "";
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadLanguage();
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

//   // ====================== Helpers ======================
//   String _formatWeight(double grams) {
//     if (grams == 0) return "0.000";
//     final isNegative = grams < 0;
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

//   double _getTxTotalWeight(Map<String, dynamic> t) {
//     final carats = t["carats"] as List?;
//     if (carats != null && carats.isNotEmpty) {
//       double total = 0;
//       for (var c in carats) {
//         total += (c["weight"] ?? 0).toDouble();
//       }
//       return total;
//     }
//     return (t["weight"] ?? 0).toDouble();
//   }

//   List<Map<String, dynamic>> _sortByDateDesc(List<Map<String, dynamic>> txs) {
//     final sorted = List<Map<String, dynamic>>.from(txs);
//     sorted.sort((a, b) {
//       final dateA = a["date"] as Timestamp?;
//       final dateB = b["date"] as Timestamp?;
//       if (dateA == null && dateB == null) return 0;
//       if (dateA == null) return 1;
//       if (dateB == null) return -1;
//       return dateB.toDate().compareTo(dateA.toDate());
//     });
//     return sorted;
//   }

//   // ====================== Build ======================
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FS.scrapTransactionsStream(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
//               backgroundColor: const Color(0xFFD4AF37),
//             ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
//                   const SizedBox(height: 16),
//                   Text(_t(
//                       "⚠️ حدث خطأ في تحميل البيانات", "⚠️ Error loading data")),
//                   const SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () => setState(() {}),
//                     child: Text(_t("إعادة المحاولة", "Retry")),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         if (!snapshot.hasData) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
//               backgroundColor: const Color(0xFFD4AF37),
//             ),
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         }

//         List<Map<String, dynamic>> allTx = List.from(snapshot.data as List);

//         if (searchQuery.isNotEmpty) {
//           allTx = allTx.where((t) {
//             final person = (t["person"] ?? "").toString().toLowerCase();
//             return person.contains(searchQuery);
//           }).toList();
//         }

//         final sales = _sortByDateDesc(
//             allTx.where((t) => t["type"] == "payment").toList());
//         final purchases =
//             _sortByDateDesc(allTx.where((t) => t["type"] == "add").toList());

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
//             backgroundColor: const Color(0xFFD4AF37),
//             elevation: 0,
//             centerTitle: true,
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.analytics_outlined),
//                 tooltip: _t("الملخص التفصيلي", "Detailed Summary"),
//                 onPressed: () => _showSummarySheet(allTx),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.refresh),
//                 tooltip: _t("تحديث", "Refresh"),
//                 onPressed: () => setState(() {}),
//               ),
//             ],
//             bottom: TabBar(
//               controller: _tabController,
//               indicatorColor: Colors.white,
//               indicatorWeight: 3,
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white60,
//               labelStyle:
//                   const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//               tabs: [
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.sell, size: 18),
//                       const SizedBox(width: 6),
//                       Text(_t("المبيعات", "Sales")),
//                       const SizedBox(width: 6),
//                       _buildCountBadge(sales.length, Colors.blue),
//                     ],
//                   ),
//                 ),
//                 Tab(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(Icons.shopping_cart, size: 18),
//                       const SizedBox(width: 6),
//                       Text(_t("المشتريات", "Purchases")),
//                       const SizedBox(width: 6),
//                       _buildCountBadge(purchases.length, Colors.green),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           body: Column(
//             children: [
//               // ===== البحث =====
//               Container(
//                 padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
//                 color: Colors.white,
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: _t("🔍 بحث باسم الشخص / المورد",
//                         "🔍 Search by person / supplier"),
//                     prefixIcon:
//                         const Icon(Icons.search, color: Color(0xFFD4AF37)),
//                     suffixIcon: searchQuery.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.close, size: 18),
//                             onPressed: () => setState(() => searchQuery = ""),
//                           )
//                         : null,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     isDense: true,
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                   ),
//                   onChanged: (val) =>
//                       setState(() => searchQuery = val.toLowerCase()),
//                 ),
//               ),

//               // ===== التابات =====
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     _buildSalesTab(sales),
//                     _buildPurchasesTab(purchases),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton.extended(
//             onPressed: () => _showSummarySheet(allTx),
//             backgroundColor: const Color(0xFFD4AF37),
//             icon: const Icon(Icons.analytics, color: Colors.white),
//             label: Text(
//               _t("الملخص", "Summary"),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCountBadge(int count, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         "$count",
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 📤 تاب المبيعات
//   // ============================================================
//   Widget _buildSalesTab(List<Map<String, dynamic>> sales) {
//     const color = Colors.blue;

//     if (sales.isEmpty) {
//       return _buildEmptyState(
//         icon: Icons.sell_outlined,
//         title: _t("لا توجد مبيعات للموردين", "No sales to suppliers"),
//         subtitle: _t("المبيعات بتتسجل من سند الصرف في صفحة الموردين",
//             "Sales are recorded from Payment Voucher"),
//         color: color,
//       );
//     }

//     final grouped = _groupByPerson(sales);

//     return Column(
//       children: [
//         _buildStatsBar(sales, color),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
//             itemCount: grouped.length,
//             itemBuilder: (context, i) {
//               final entry = grouped[i];
//               return _buildPersonCard(
//                 personName: entry.key,
//                 txs: entry.value,
//                 color: color,
//                 isSales: true,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // 📥 تاب المشتريات
//   // ============================================================
//   Widget _buildPurchasesTab(List<Map<String, dynamic>> purchases) {
//     const color = Colors.green;

//     if (purchases.isEmpty) {
//       return _buildEmptyState(
//         icon: Icons.shopping_cart_outlined,
//         title: _t("لا توجد مشتريات", "No purchases"),
//         subtitle: _t("المشتريات بتتسجل من صفحة شراء الكسر",
//             "Purchases are recorded from Buy Scrap page"),
//         color: color,
//       );
//     }

//     final grouped = _groupByPerson(purchases);

//     return Column(
//       children: [
//         _buildStatsBar(purchases, color),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
//             itemCount: grouped.length,
//             itemBuilder: (context, i) {
//               final entry = grouped[i];
//               return _buildPersonCard(
//                 personName: entry.key,
//                 txs: entry.value,
//                 color: color,
//                 isSales: false,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // تجميع حسب الاسم
//   // ============================================================
//   List<MapEntry<String, List<Map<String, dynamic>>>> _groupByPerson(
//       List<Map<String, dynamic>> txs) {
//     Map<String, List<Map<String, dynamic>>> grouped = {};
//     for (var t in txs) {
//       final person = (t["person"] ?? "غير معروف").toString();
//       grouped.putIfAbsent(person, () => []).add(t);
//     }

//     for (var key in grouped.keys) {
//       grouped[key] = _sortByDateDesc(grouped[key]!);
//     }

//     final entries = grouped.entries.toList();
//     entries.sort((a, b) {
//       final dateA = a.value.first["date"] as Timestamp?;
//       final dateB = b.value.first["date"] as Timestamp?;
//       if (dateA == null && dateB == null) return 0;
//       if (dateA == null) return 1;
//       if (dateB == null) return -1;
//       return dateB.toDate().compareTo(dateA.toDate());
//     });
//     return entries;
//   }

//   // ============================================================
//   // كارت الشخص/المورد (صغير)
//   // ============================================================
//   Widget _buildPersonCard({
//     required String personName,
//     required List<Map<String, dynamic>> txs,
//     required Color color,
//     required bool isSales,
//   }) {
//     double totalWeight = 0;
//     double totalAmount = 0;
//     for (var t in txs) {
//       totalWeight += _getTxTotalWeight(t);
//       totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
//     }

//     final lastDate = (txs.first["date"] as Timestamp?)?.toDate();
//     final lastDateStr =
//         lastDate != null ? DateFormat("yyyy-MM-dd").format(lastDate) : "-";
//     final lastTimeStr =
//         lastDate != null ? DateFormat("HH:mm").format(lastDate) : "";

//     final delegate = txs.first["delegate"]?.toString() ?? "";

//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.06),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () => _openPersonDetails(
//             personName: personName,
//             txs: txs,
//             color: color,
//             isSales: isSales,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   backgroundColor: color.withOpacity(0.15),
//                   child: Icon(
//                     isSales ? Icons.store : Icons.person,
//                     color: color,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               personName,
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             "$lastDateStr  $lastTimeStr",
//                             style: TextStyle(
//                               fontSize: 9,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: color.withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             child: Text(
//                               "${txs.length} ${_t("عملية", "txs")}",
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                                 color: color,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           Icon(Icons.scale, size: 11, color: Colors.grey[600]),
//                           const SizedBox(width: 2),
//                           Text(
//                             "${_formatWeight(totalWeight)}",
//                             style: const TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           if (totalAmount > 0) ...[
//                             const SizedBox(width: 8),
//                             Icon(Icons.payments,
//                                 size: 11, color: Colors.grey[600]),
//                             const SizedBox(width: 2),
//                             Text(
//                               "${totalAmount.toStringAsFixed(0)} ج",
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600,
//                                 color: color,
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                       if (delegate.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 3),
//                           child: Row(
//                             children: [
//                               Icon(Icons.badge_outlined,
//                                   size: 10, color: Colors.grey[500]),
//                               const SizedBox(width: 3),
//                               Text(
//                                 delegate,
//                                 style: TextStyle(
//                                   fontSize: 9,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.arrow_forward_ios,
//                     size: 12, color: Colors.grey[400]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // فتح صفحة تفاصيل الشخص
//   // ============================================================
//   void _openPersonDetails({
//     required String personName,
//     required List<Map<String, dynamic>> txs,
//     required Color color,
//     required bool isSales,
//   }) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _PersonDetailsPage(
//           personName: personName,
//           txs: txs,
//           color: color,
//           isSales: isSales,
//           lang: _lang,
//           formatWeight: _formatWeight,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 📊 شريط الإحصائيات
//   // ============================================================
//   Widget _buildStatsBar(List<Map<String, dynamic>> txs, Color color) {
//     double totalWeight = 0;
//     double totalAmount = 0;
//     for (var t in txs) {
//       totalWeight += _getTxTotalWeight(t);
//       totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
//     }

//     return Container(
//       margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           _buildStatItem(
//             icon: Icons.receipt_long,
//             label: _t("عملية", "Operations"),
//             value: "${txs.length}",
//             color: color,
//           ),
//           _buildStatDivider(color),
//           _buildStatItem(
//             icon: Icons.scale,
//             label: _t("إجمالي الوزن", "Total Weight"),
//             value: "${_formatWeight(totalWeight)} جم",
//             color: color,
//           ),
//           _buildStatDivider(color),
//           _buildStatItem(
//             icon: Icons.payments,
//             label: _t("إجمالي المبلغ", "Total Amount"),
//             value: "${totalAmount.toStringAsFixed(0)} ج",
//             color: color,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, size: 18, color: color),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(fontSize: 9, color: Colors.grey[700]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatDivider(Color color) {
//     return Container(
//       width: 1,
//       height: 40,
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       color: color.withOpacity(0.2),
//     );
//   }

//   // ============================================================
//   // 🚫 حالة فارغة
//   // ============================================================
//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//   }) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, size: 50, color: color.withOpacity(0.5)),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 📈 الملخص التفصيلي (Bottom Sheet)
//   // ============================================================
//   void _showSummarySheet(List<Map<String, dynamic>> allTx) {
//     Map<String, Map<String, double>> stats = {
//       "add": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//       "sale": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//       "payment": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//       "transform": {"14": 0, "18": 0, "21": 0, "22": 0, "24": 0},
//     };

//     Map<String, double> totalByCarat = {
//       "14": 0,
//       "18": 0,
//       "21": 0,
//       "22": 0,
//       "24": 0
//     };
//     double balance24K = 0;

//     for (var t in allTx) {
//       final type = t["type"] ?? "";

//       if (type == "payment" &&
//           t["carats"] != null &&
//           (t["carats"] as List).isNotEmpty) {
//         final carats = t["carats"] as List;
//         for (var c in carats) {
//           final carat = (c['carat'] ?? "18").toString();
//           final weight = (c['weight'] ?? 0).toDouble();

//           if (stats["payment"]!.containsKey(carat)) {
//             stats["payment"]![carat] = (stats["payment"]![carat] ?? 0) + weight;
//           }
//           totalByCarat[carat] = (totalByCarat[carat] ?? 0) - weight.abs();
//           balance24K -= _convertTo24Karat(weight, carat).abs();
//         }
//       } else {
//         final carat = (t["carat"] ?? "18").toString();
//         final weight = (t["weight"] ?? 0).toDouble();

//         if (stats.containsKey(type) && stats[type]!.containsKey(carat)) {
//           stats[type]![carat] = (stats[type]![carat]! + weight).toDouble();

//           double signedWeight = weight;
//           if (type == "sale" || type == "payment") {
//             signedWeight = -weight.abs();
//           }
//           totalByCarat[carat] =
//               (totalByCarat[carat]! + signedWeight).toDouble();

//           double convertedWeight = _convertTo24Karat(weight, carat);
//           if (type == "add" || type == "transform") {
//             balance24K += convertedWeight;
//           } else if (type == "sale" || type == "payment") {
//             balance24K -= convertedWeight.abs();
//           }
//         }
//       }
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.75,
//         minChildSize: 0.4,
//         maxChildSize: 0.95,
//         builder: (_, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFD4AF37).withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Icon(Icons.analytics,
//                           color: Color(0xFFD4AF37), size: 22),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _t("📊 الملخص التفصيلي", "📊 Detailed Summary"),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "${allTx.length} ${_t("عملية إجمالية", "total transactions")}",
//                             style: TextStyle(
//                                 fontSize: 11, color: Colors.grey[600]),
//                           ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               Expanded(
//                 child: ListView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: balance24K < 0
//                               ? [
//                                   Colors.red.shade50,
//                                   Colors.red.shade100.withOpacity(0.5)
//                                 ]
//                               : [
//                                   Colors.green.shade50,
//                                   Colors.green.shade100.withOpacity(0.5)
//                                 ],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: balance24K < 0
//                               ? Colors.red.shade200
//                               : Colors.green.shade200,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: balance24K < 0 ? Colors.red : Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               balance24K < 0
//                                   ? Icons.warning_rounded
//                                   : Icons.check_circle_rounded,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _t("الرصيد الحالي (معادل 24)",
//                                       "Current Balance (24K)"),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "${_formatWeight(balance24K)} جم",
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: balance24K < 0
//                                         ? Colors.red.shade800
//                                         : Colors.green.shade800,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columnSpacing: 14,
//                           headingRowHeight: 40,
//                           dataRowHeight: 42,
//                           headingRowColor: MaterialStateProperty.all(
//                             const Color(0xFFD4AF37).withOpacity(0.1),
//                           ),
//                           columns: [
//                             DataColumn(
//                               label: Text(_t("العيار", "Carat"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                             DataColumn(
//                               label: Text(_t("شراء", "Add"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green)),
//                             ),
//                             DataColumn(
//                               label: Text(_t("بيع", "Sale"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue)),
//                             ),
//                             DataColumn(
//                               label: Text(_t("سند صرف", "Payment"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red)),
//                             ),
//                             DataColumn(
//                               label: Text(_t("تحويل", "Transform"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.orange)),
//                             ),
//                             DataColumn(
//                               label: Text(_t("الإجمالي", "Total"),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold)),
//                             ),
//                           ],
//                           rows: ["14", "18", "21", "22", "24"].map((carat) {
//                             double addVal = stats["add"]![carat]!;
//                             double saleVal = stats["sale"]![carat]!.abs();
//                             double paymentVal = stats["payment"]![carat]!.abs();
//                             double transformVal = stats["transform"]![carat]!;
//                             double total = totalByCarat[carat]!;

//                             return DataRow(cells: [
//                               DataCell(
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 3),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFD4AF37)
//                                         .withOpacity(0.15),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(
//                                     "عيار $carat",
//                                     style: const TextStyle(
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFFD4AF37),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               DataCell(Text(addVal.toStringAsFixed(1),
//                                   style: const TextStyle(color: Colors.green))),
//                               DataCell(Text(saleVal.toStringAsFixed(1),
//                                   style: const TextStyle(color: Colors.blue))),
//                               DataCell(Text(paymentVal.toStringAsFixed(1),
//                                   style: const TextStyle(color: Colors.red))),
//                               DataCell(Text(transformVal.toStringAsFixed(1),
//                                   style:
//                                       const TextStyle(color: Colors.orange))),
//                               DataCell(Text(
//                                 total.toStringAsFixed(1),
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: total < 0 ? Colors.red : Colors.green,
//                                 ),
//                               )),
//                             ]);
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
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
// // صفحة تفاصيل الشخص/المورد
// // ============================================================
// class _PersonDetailsPage extends StatelessWidget {
//   final String personName;
//   final List<Map<String, dynamic>> txs;
//   final Color color;
//   final bool isSales;
//   final String lang;
//   final String Function(double) formatWeight;

//   const _PersonDetailsPage({
//     required this.personName,
//     required this.txs,
//     required this.color,
//     required this.isSales,
//     required this.lang,
//     required this.formatWeight,
//   });

//   String _t(String ar, String en) => lang == 'ar' ? ar : en;

//   double _getTxTotalWeight(Map<String, dynamic> t) {
//     final carats = t["carats"] as List?;
//     if (carats != null && carats.isNotEmpty) {
//       double total = 0;
//       for (var c in carats) {
//         total += (c["weight"] ?? 0).toDouble();
//       }
//       return total;
//     }
//     return (t["weight"] ?? 0).toDouble();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double totalWeight = 0;
//     double totalAmount = 0;
//     double totalWage = 0;
//     for (var t in txs) {
//       totalWeight += _getTxTotalWeight(t);
//       totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
//       final carats = t["carats"] as List?;
//       if (carats != null && carats.isNotEmpty) {
//         for (var c in carats) {
//           totalWage += (c["wage"] ?? 0).toDouble();
//         }
//       } else {
//         totalWage += (t["wage"] ?? 0).toDouble();
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Icon(isSales ? Icons.store : Icons.person,
//                 color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 personName,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: color,
//         elevation: 0,
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           // شريط الإحصائيات
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             decoration: BoxDecoration(
//               color: color,
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 _buildStat(
//                   _t("عمليات", "Operations"),
//                   "${txs.length}",
//                   Icons.receipt_long,
//                 ),
//                 _buildDivider(),
//                 _buildStat(
//                   _t("الوزن", "Weight"),
//                   "${formatWeight(totalWeight)} جم",
//                   Icons.scale,
//                 ),
//                 _buildDivider(),
//                 _buildStat(
//                   _t("الأجر", "Wage"),
//                   "${totalWage.toStringAsFixed(0)}",
//                   Icons.payments_outlined,
//                 ),
//                 if (totalAmount > 0) ...[
//                   _buildDivider(),
//                   _buildStat(
//                     _t("المبلغ", "Amount"),
//                     "${totalAmount.toStringAsFixed(0)} ج",
//                     Icons.attach_money,
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           // قائمة المعاملات
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: txs.length,
//               itemBuilder: (context, i) {
//                 return _buildMiniTxCard(txs[i], context);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStat(String label, String value, IconData icon) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, size: 16, color: Colors.white70),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 9, color: Colors.white70),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       width: 1,
//       height: 35,
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       color: Colors.white.withOpacity(0.3),
//     );
//   }

//   // ============================================================
//   // كارت معاملة مصغّر
//   // ============================================================
//   Widget _buildMiniTxCard(Map<String, dynamic> t, BuildContext context) {
//     final date = (t["date"] as Timestamp?)?.toDate();
//     final dateStr = date != null ? DateFormat("yyyy-MM-dd").format(date) : "-";
//     final timeStr = date != null ? DateFormat("HH:mm").format(date) : "";
//     final delegate = t["delegate"]?.toString() ?? "";
//     final notes = t["notes"]?.toString() ?? "";
//     final carats = t["carats"] as List?;
//     final hasMulti = carats != null && carats.isNotEmpty;

//     double totalWeight = _getTxTotalWeight(t);
//     final totalAmount = ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();

//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               width: 3,
//               decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.calendar_today,
//                             size: 11, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Text(
//                           "$dateStr  •  $timeStr",
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         const Spacer(),
//                         if (delegate.isNotEmpty) ...[
//                           Icon(Icons.badge_outlined,
//                               size: 11, color: Colors.grey[600]),
//                           const SizedBox(width: 3),
//                           Text(
//                             delegate,
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Wrap(
//                       spacing: 6,
//                       runSpacing: 4,
//                       children: hasMulti
//                           ? carats!.map((c) {
//                               return _buildMiniCaratChip(
//                                 (c["carat"] ?? "18").toString(),
//                                 (c["weight"] ?? 0).toDouble(),
//                                 (c["wage"] ?? 0).toDouble(),
//                               );
//                             }).toList()
//                           : [
//                               _buildMiniCaratChip(
//                                 (t["carat"] ?? "18").toString(),
//                                 totalWeight,
//                                 (t["wage"] ?? 0).toDouble(),
//                               ),
//                             ],
//                     ),
//                     if (hasMulti) ...[
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(Icons.summarize_outlined,
//                               size: 12, color: color),
//                           const SizedBox(width: 4),
//                           Text(
//                             "${_t("إجمالي", "Total")}: ${totalWeight.toStringAsFixed(2)} جم",
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.bold,
//                               color: color,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                     if (totalAmount > 0) ...[
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.12),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(Icons.attach_money, size: 11, color: color),
//                             const SizedBox(width: 2),
//                             Text(
//                               "${totalAmount.toStringAsFixed(0)} ${_t("ج", "EGP")}",
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                                 color: color,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                     if (notes.isNotEmpty) ...[
//                       const SizedBox(height: 5),
//                       Row(
//                         children: [
//                           Icon(Icons.notes, size: 10, color: Colors.grey[500]),
//                           const SizedBox(width: 3),
//                           Expanded(
//                             child: Text(
//                               notes,
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 color: Colors.grey[600],
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMiniCaratChip(String carat, double weight, double wage) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFD4AF37), Color(0xFFB8941F)],
//         ),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "ع $carat",
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Container(
//             width: 1,
//             height: 10,
//             color: Colors.white.withOpacity(0.5),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             "${weight.toStringAsFixed(2)}",
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           ),
//           if (wage > 0) ...[
//             const SizedBox(width: 4),
//             Container(
//               width: 1,
//               height: 10,
//               color: Colors.white.withOpacity(0.5),
//             ),
//             const SizedBox(width: 4),
//             Text(
//               "${wage.toStringAsFixed(0)}",
//               style: const TextStyle(
//                 fontSize: 9,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// صفحة الكسر الرئيسية - شراء + تقارير فقط
// ============================================================
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => part));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: color.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
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
// نموذج شراء الكسر
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
// صفحة التقارير
// ============================================================
class ScrapReports extends StatefulWidget {
  const ScrapReports({super.key});

  @override
  State<ScrapReports> createState() => _ScrapReportsState();
}

class _ScrapReportsState extends State<ScrapReports>
    with SingleTickerProviderStateMixin {
  String searchQuery = "";
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLanguage();
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

  // ====================== Helpers ======================
  String _formatWeight(double grams) {
    if (grams == 0) return "0.000";
    final isNegative = grams < 0;
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

  double _getTxTotalWeight(Map<String, dynamic> t) {
    final carats = t["carats"] as List?;
    if (carats != null && carats.isNotEmpty) {
      double total = 0;
      for (var c in carats) {
        total += (c["weight"] ?? 0).toDouble();
      }
      return total;
    }
    return (t["weight"] ?? 0).toDouble();
  }

  List<Map<String, dynamic>> _sortByDateDesc(List<Map<String, dynamic>> txs) {
    final sorted = List<Map<String, dynamic>>.from(txs);
    sorted.sort((a, b) {
      final dateA = a["date"] as Timestamp?;
      final dateB = b["date"] as Timestamp?;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.toDate().compareTo(dateA.toDate());
    });
    return sorted;
  }

  // ====================== Build ======================
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FS.scrapTransactionsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
              backgroundColor: const Color(0xFFD4AF37),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(_t(
                      "⚠️ حدث خطأ في تحميل البيانات", "⚠️ Error loading data")),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text(_t("إعادة المحاولة", "Retry")),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
              backgroundColor: const Color(0xFFD4AF37),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        List<Map<String, dynamic>> allTx = List.from(snapshot.data as List);

        if (searchQuery.isNotEmpty) {
          allTx = allTx.where((t) {
            final person = (t["person"] ?? "").toString().toLowerCase();
            return person.contains(searchQuery);
          }).toList();
        }

        // final sales = _sortByDateDesc(
        //     allTx.where((t) => t["type"] == "payment").toList());
        final sales = _sortByDateDesc(allTx
            .where((t) => t["type"] == "payment" && t["affectsScrap"] != false)
            .toList());
        final purchases =
            _sortByDateDesc(allTx.where((t) => t["type"] == "add").toList());

        return Scaffold(
          appBar: AppBar(
            title: Text(_t("📊 تقارير الكسر", "📊 Scrap Reports")),
            backgroundColor: const Color(0xFFD4AF37),
            elevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                tooltip: _t("الملخص التفصيلي", "Detailed Summary"),
                onPressed: () => _showSummarySheet(allTx),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: _t("تحديث", "Refresh"),
                onPressed: () => setState(() {}),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sell, size: 18),
                      const SizedBox(width: 6),
                      Text(_t("المبيعات", "Sales")),
                      const SizedBox(width: 6),
                      _buildCountBadge(sales.length, Colors.blue),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart, size: 18),
                      const SizedBox(width: 6),
                      Text(_t("المشتريات", "Purchases")),
                      const SizedBox(width: 6),
                      _buildCountBadge(purchases.length, Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // ===== البحث =====
              Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: _t("🔍 بحث باسم الشخص / المورد",
                        "🔍 Search by person / supplier"),
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFFD4AF37)),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () => setState(() => searchQuery = ""),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                  onChanged: (val) =>
                      setState(() => searchQuery = val.toLowerCase()),
                ),
              ),

              // ===== التابات =====
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSalesTab(sales),
                    _buildPurchasesTab(purchases),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showSummarySheet(allTx),
            backgroundColor: const Color(0xFFD4AF37),
            icon: const Icon(Icons.analytics, color: Colors.white),
            label: Text(
              _t("الملخص", "Summary"),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountBadge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$count",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // 📤 تاب المبيعات
  // ============================================================
  Widget _buildSalesTab(List<Map<String, dynamic>> sales) {
    const color = Colors.blue;

    if (sales.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sell_outlined,
        title: _t("لا توجد مبيعات للموردين", "No sales to suppliers"),
        subtitle: _t("المبيعات بتتسجل من سند الصرف في صفحة الموردين",
            "Sales are recorded from Payment Voucher"),
        color: color,
      );
    }

    final grouped = _groupByPerson(sales);

    return Column(
      children: [
        _buildStatsBar(sales, color),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
            itemCount: grouped.length,
            itemBuilder: (context, i) {
              final entry = grouped[i];
              return _buildPersonCard(
                personName: entry.key,
                txs: entry.value,
                color: color,
                isSales: true,
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 📥 تاب المشتريات
  // ============================================================
  Widget _buildPurchasesTab(List<Map<String, dynamic>> purchases) {
    const color = Colors.green;

    if (purchases.isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: _t("لا توجد مشتريات", "No purchases"),
        subtitle: _t("المشتريات بتتسجل من صفحة شراء الكسر",
            "Purchases are recorded from Buy Scrap page"),
        color: color,
      );
    }

    final grouped = _groupByPerson(purchases);

    return Column(
      children: [
        _buildStatsBar(purchases, color),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
            itemCount: grouped.length,
            itemBuilder: (context, i) {
              final entry = grouped[i];
              return _buildPersonCard(
                personName: entry.key,
                txs: entry.value,
                color: color,
                isSales: false,
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // تجميع حسب الاسم
  // ============================================================
  List<MapEntry<String, List<Map<String, dynamic>>>> _groupByPerson(
      List<Map<String, dynamic>> txs) {
    Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var t in txs) {
      final person = (t["person"] ?? "غير معروف").toString();
      grouped.putIfAbsent(person, () => []).add(t);
    }

    for (var key in grouped.keys) {
      grouped[key] = _sortByDateDesc(grouped[key]!);
    }

    final entries = grouped.entries.toList();
    entries.sort((a, b) {
      final dateA = a.value.first["date"] as Timestamp?;
      final dateB = b.value.first["date"] as Timestamp?;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.toDate().compareTo(dateA.toDate());
    });
    return entries;
  }

  // ============================================================
  // كارت الشخص/المورد (صغير)
  // ============================================================
  Widget _buildPersonCard({
    required String personName,
    required List<Map<String, dynamic>> txs,
    required Color color,
    required bool isSales,
  }) {
    double totalWeight = 0;
    double totalAmount = 0;
    for (var t in txs) {
      totalWeight += _getTxTotalWeight(t);
      totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
    }

    final lastDate = (txs.first["date"] as Timestamp?)?.toDate();
    final lastDateStr =
        lastDate != null ? DateFormat("yyyy-MM-dd").format(lastDate) : "-";
    final lastTimeStr =
        lastDate != null ? DateFormat("HH:mm").format(lastDate) : "";

    final delegate = txs.first["delegate"]?.toString() ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openPersonDetails(
            personName: personName,
            txs: txs,
            color: color,
            isSales: isSales,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(
                    isSales ? Icons.store : Icons.person,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              personName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "$lastDateStr  $lastTimeStr",
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "${txs.length} ${_t("عملية", "txs")}",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.scale, size: 11, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Text(
                            "${_formatWeight(totalWeight)}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (totalAmount > 0) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.payments,
                                size: 11, color: Colors.grey[600]),
                            const SizedBox(width: 2),
                            Text(
                              "${totalAmount.toStringAsFixed(0)} ج",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (delegate.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(
                            children: [
                              Icon(Icons.badge_outlined,
                                  size: 10, color: Colors.grey[500]),
                              const SizedBox(width: 3),
                              Text(
                                delegate,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 12, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // فتح صفحة تفاصيل الشخص
  // ============================================================
  void _openPersonDetails({
    required String personName,
    required List<Map<String, dynamic>> txs,
    required Color color,
    required bool isSales,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PersonDetailsPage(
          personName: personName,
          txs: txs,
          color: color,
          isSales: isSales,
          lang: _lang,
          formatWeight: _formatWeight,
        ),
      ),
    );
  }

  // ============================================================
  // 📊 شريط الإحصائيات
  // ============================================================
  Widget _buildStatsBar(List<Map<String, dynamic>> txs, Color color) {
    double totalWeight = 0;
    double totalAmount = 0;
    for (var t in txs) {
      totalWeight += _getTxTotalWeight(t);
      totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.receipt_long,
            label: _t("عملية", "Operations"),
            value: "${txs.length}",
            color: color,
          ),
          _buildStatDivider(color),
          _buildStatItem(
            icon: Icons.scale,
            label: _t("إجمالي الوزن", "Total Weight"),
            value: "${_formatWeight(totalWeight)} جم",
            color: color,
          ),
          _buildStatDivider(color),
          _buildStatItem(
            icon: Icons.payments,
            label: _t("إجمالي المبلغ", "Total Amount"),
            value: "${totalAmount.toStringAsFixed(0)} ج",
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider(Color color) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: color.withOpacity(0.2),
    );
  }

  // ============================================================
  // 🚫 حالة فارغة
  // ============================================================
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: color.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 📈 الملخص التفصيلي (Bottom Sheet)
  // ============================================================
  void _showSummarySheet(List<Map<String, dynamic>> allTx) {
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
    double balance24K = 0;

    for (var t in allTx) {
      final type = t["type"] ?? "";

      if (type == "payment" &&
          t["carats"] != null &&
          (t["carats"] as List).isNotEmpty) {
        final carats = t["carats"] as List;
        for (var c in carats) {
          final carat = (c['carat'] ?? "18").toString();
          final weight = (c['weight'] ?? 0).toDouble();

          if (stats["payment"]!.containsKey(carat)) {
            stats["payment"]![carat] = (stats["payment"]![carat] ?? 0) + weight;
          }
          totalByCarat[carat] = (totalByCarat[carat] ?? 0) - weight.abs();
          balance24K -= _convertTo24Karat(weight, carat).abs();
        }
      } else {
        final carat = (t["carat"] ?? "18").toString();
        final weight = (t["weight"] ?? 0).toDouble();

// ✅ تجاهل سندات المكتب في تقارير الكسر
        if (type == "payment" && t["affectsScrap"] == false) {
          continue;
        }

        if (stats.containsKey(type) && stats[type]!.containsKey(carat)) {
          stats[type]![carat] = (stats[type]![carat]! + weight).toDouble();

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
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.analytics,
                          color: Color(0xFFD4AF37), size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _t("📊 الملخص التفصيلي", "📊 Detailed Summary"),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${allTx.length} ${_t("عملية إجمالية", "total transactions")}",
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: balance24K < 0
                              ? [
                                  Colors.red.shade50,
                                  Colors.red.shade100.withOpacity(0.5)
                                ]
                              : [
                                  Colors.green.shade50,
                                  Colors.green.shade100.withOpacity(0.5)
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: balance24K < 0
                              ? Colors.red.shade200
                              : Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: balance24K < 0 ? Colors.red : Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              balance24K < 0
                                  ? Icons.warning_rounded
                                  : Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _t("الرصيد الحالي (معادل 24)",
                                      "Current Balance (24K)"),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${_formatWeight(balance24K)} جم",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: balance24K < 0
                                        ? Colors.red.shade800
                                        : Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 14,
                          headingRowHeight: 40,
                          dataRowHeight: 42,
                          headingRowColor: MaterialStateProperty.all(
                            const Color(0xFFD4AF37).withOpacity(0.1),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(_t("العيار", "Carat"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text(_t("شراء", "Add"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ),
                            DataColumn(
                              label: Text(_t("بيع", "Sale"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            ),
                            DataColumn(
                              label: Text(_t("سند صرف", "Payment"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ),
                            DataColumn(
                              label: Text(_t("تحويل", "Transform"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange)),
                            ),
                            DataColumn(
                              label: Text(_t("الإجمالي", "Total"),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                          rows: ["14", "18", "21", "22", "24"].map((carat) {
                            double addVal = stats["add"]![carat]!;
                            double saleVal = stats["sale"]![carat]!.abs();
                            double paymentVal = stats["payment"]![carat]!.abs();
                            double transformVal = stats["transform"]![carat]!;
                            double total = totalByCarat[carat]!;

                            return DataRow(cells: [
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4AF37)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "عيار $carat",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFD4AF37),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(addVal.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.green))),
                              DataCell(Text(saleVal.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.blue))),
                              DataCell(Text(paymentVal.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.red))),
                              DataCell(Text(transformVal.toStringAsFixed(1),
                                  style:
                                      const TextStyle(color: Colors.orange))),
                              DataCell(Text(
                                total.toStringAsFixed(1),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: total < 0 ? Colors.red : Colors.green,
                                ),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
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
// صفحة تفاصيل الشخص/المورد
// ============================================================
class _PersonDetailsPage extends StatelessWidget {
  final String personName;
  final List<Map<String, dynamic>> txs;
  final Color color;
  final bool isSales;
  final String lang;
  final String Function(double) formatWeight;

  const _PersonDetailsPage({
    required this.personName,
    required this.txs,
    required this.color,
    required this.isSales,
    required this.lang,
    required this.formatWeight,
  });

  String _t(String ar, String en) => lang == 'ar' ? ar : en;

  double _getTxTotalWeight(Map<String, dynamic> t) {
    final carats = t["carats"] as List?;
    if (carats != null && carats.isNotEmpty) {
      double total = 0;
      for (var c in carats) {
        total += (c["weight"] ?? 0).toDouble();
      }
      return total;
    }
    return (t["weight"] ?? 0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    double totalWeight = 0;
    double totalAmount = 0;
    double totalWage = 0;
    for (var t in txs) {
      totalWeight += _getTxTotalWeight(t);
      totalAmount += ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();
      final carats = t["carats"] as List?;
      if (carats != null && carats.isNotEmpty) {
        for (var c in carats) {
          totalWage += (c["wage"] ?? 0).toDouble();
        }
      } else {
        totalWage += (t["wage"] ?? 0).toDouble();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(isSales ? Icons.store : Icons.person,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                personName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // شريط الإحصائيات
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStat(
                  _t("عمليات", "Operations"),
                  "${txs.length}",
                  Icons.receipt_long,
                ),
                _buildDivider(),
                _buildStat(
                  _t("الوزن", "Weight"),
                  "${formatWeight(totalWeight)} جم",
                  Icons.scale,
                ),
                _buildDivider(),
                _buildStat(
                  _t("الأجر", "Wage"),
                  "${totalWage.toStringAsFixed(0)}",
                  Icons.payments_outlined,
                ),
                if (totalAmount > 0) ...[
                  _buildDivider(),
                  _buildStat(
                    _t("المبلغ", "Amount"),
                    "${totalAmount.toStringAsFixed(0)} ج",
                    Icons.attach_money,
                  ),
                ],
              ],
            ),
          ),

          // قائمة المعاملات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: txs.length,
              itemBuilder: (context, i) {
                return _buildMiniTxCard(txs[i], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white.withOpacity(0.3),
    );
  }

  // ============================================================
  // كارت المعاملة (التصميم الكامل)
  // ============================================================
  Widget _buildMiniTxCard(Map<String, dynamic> t, BuildContext context) {
    final date = (t["date"] as Timestamp?)?.toDate();
    final formattedDate =
        date != null ? DateFormat("yyyy-MM-dd HH:mm").format(date) : "-";
    final delegate = t["delegate"]?.toString() ?? "";
    final notes = t["notes"]?.toString() ?? "";
    final carats = t["carats"] as List?;
    final hasMulti = carats != null && carats.isNotEmpty;

    double totalWeight = 0;
    double totalWage = 0;

    if (hasMulti) {
      for (var c in carats!) {
        totalWeight += (c["weight"] ?? 0).toDouble();
        totalWage += (c["wage"] ?? 0).toDouble();
      }
    } else {
      totalWeight = (t["weight"] ?? 0).toDouble();
      totalWage = (t["wage"] ?? 0).toDouble();
    }

    final totalAmount = ((t["cash"] ?? 0) + (t["network"] ?? 0)).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== الهيدر =====
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  radius: 18,
                  child: Icon(
                    isSales ? Icons.receipt_long : Icons.arrow_downward,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSales
                            ? _t("سند صرف", "Payment Voucher")
                            : _t("شراء كسر", "Buy Scrap"),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (delegate.isNotEmpty)
                        Text(
                          "${_t("مندوب", "Delegate")}: $delegate",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ===== العيارات =====
            if (hasMulti)
              ...carats!.map((c) {
                final carat = c["carat"] ?? "18";
                final weight = (c["weight"] ?? 0).toDouble();
                final wage = (c["wage"] ?? 0).toDouble();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
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
                      Text(
                        "${_t('وزن', 'Weight')}: ${weight.toStringAsFixed(2)} ${_t('جم', 'g')}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "${_t('أجر', 'Wage')}: ${wage.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "${_t('عيار', 'Carat')} ${t["carat"] ?? "18"}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${_t('وزن', 'Weight')}: ${totalWeight.toStringAsFixed(2)} ${_t('جم', 'g')}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (totalWage > 0)
                      Text(
                        "${_t('أجر', 'Wage')}: ${totalWage.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // ===== إجمالي الوزن والأجر =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_t('إجمالي الوزن', 'Total Weight')}: ${totalWeight.toStringAsFixed(2)} ${_t('جم', 'g')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  Text(
                    "${_t('إجمالي الأجر', 'Total Wage')}: ${totalWage.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ],
              ),
            ),

            // ===== المبلغ =====
            if (totalAmount > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 16, color: color),
                        const SizedBox(width: 4),
                        Text(
                          _t("المبلغ الإجمالي", "Total Amount"),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${totalAmount.toStringAsFixed(0)} ${_t("ج", "EGP")}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ===== الملاحظات =====
            if (notes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Icon(Icons.notes, size: 13, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "${_t('ملاحظات', 'Notes')}: $notes",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
