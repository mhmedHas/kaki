// import 'package:flutter/material.dart';
// import 'package:uhf_gold_shop/pages/RemainingKitsPage.dart';
// import 'package:uhf_gold_shop/pages/taskirat.dart';
// import '../services/firestore_service.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'expenses_page.dart';
// import 'TransformPage.dart';
// import 'cash_box_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'branches_page.dart';
// import 'EditPage.dart';
// import 'external_transactions_page.dart';
// import 'ExitPermissionPage.dart';
// import 'settings_page.dart';
// import 'settings_page.dart' show checkPassword;
// import 'ReturnsPage.dart';
// import 'preview_page.dart';
// import 'DeletedItemsPage.dart';

// class DailyTransactionsPage extends StatefulWidget {
//   const DailyTransactionsPage({super.key});

//   @override
//   State<DailyTransactionsPage> createState() => _DailyTransactionsPageState();
// }

// class _DailyTransactionsPageState extends State<DailyTransactionsPage> {
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

//   void _openPage(BuildContext context, Widget page) async {
//     String? pageKey;

//     if (page is PartPage) {
//       pageKey = 'Suppliers';
//     } else if (page is Part1Page)
//       pageKey = 'Vouchers';
//     else if (page is Part2Page)
//       pageKey = 'Funds';
//     else if (page is TransformPage)
//       pageKey = 'Transfers';
//     else if (page is EditPage)
//       pageKey = 'edit';
//     else if (page is BranchesPage)
//       pageKey = 'branches';
//     else if (page is ExternalTransactionsPage)
//       pageKey = 'Transactions';
//     else if (page is ExitPermissionPage) pageKey = 'Statements';

//     if (pageKey != null) {
//       final allowed = await checkPassword(context, pageKey);
//       if (!allowed) return;
//     }

//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("الحركة اليومية", "Daily Transactions")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.people,
//                     label: _t("الموردين", "Suppliers"),
//                     page: const PartPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.account_balance,
//                     label: _t("التسكيرات", "Minting"),
//                     page: const MintingPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.receipt_long,
//                     label: _t("سندات", "Vouchers"),
//                     page: const Part1Page(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.monetization_on,
//                     label: _t("الأموال", "Funds"),
//                     page: const Part2Page(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.mail_rounded,
//                     label: _t("التحويل", "Transfers"),
//                     page: const TransformPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.edit_outlined,
//                     label: _t("التعديل", "edit"),
//                     page: const EditPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.location_city,
//                     label: _t("الافرع", "branches"),
//                     page: const BranchesPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.outbond_outlined,
//                     label: _t("التعاملات", "Transactions"),
//                     page: const ExternalTransactionsPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.safety_check,
//                     label: _t("التصريحات", "Statements"),
//                     page: const ExitPermissionPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.delete,
//                     label: _t("المحذوفات", "Deletes"),
//                     page: const DeletedItemsPage(),
//                   ),
//                   _buildMenuCard(
//                     context,
//                     icon: Icons.keyboard_return_outlined,
//                     label: _t("المرتجعات", "Returns"),
//                     page: const ReturnsPage(),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(BuildContext context,
//       {required IconData icon, required String label, required Widget page}) {
//     return GestureDetector(
//       onTap: () => _openPage(context, page),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 4,
//         color: const Color(0xFFD4AF37).withOpacity(0.9),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 30, color: Colors.white),
//               const SizedBox(height: 10),
//               Text(
//                 label,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
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
// // 🔹 PartPage - صفحة الموردين الرئيسية
// // ============================================================
// class PartPage extends StatefulWidget {
//   const PartPage({super.key});

//   @override
//   State<PartPage> createState() => _PartPageState();
// }

// class _PartPageState extends State<PartPage> {
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("الموردين", "Suppliers")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: const SuppliersPage(),
//     );
//   }
// }

// // ============================================================
// // 🔹 SuppliersPage - صفحة الموردين الموحدة (معدلة)
// // ============================================================
// class SuppliersPage extends StatefulWidget {
//   const SuppliersPage({super.key});

//   @override
//   State<SuppliersPage> createState() => _SuppliersPageState();
// }

// class _SuppliersPageState extends State<SuppliersPage> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   final _formKey = GlobalKey<FormState>();
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final delegateCtrl = TextEditingController();
//   List<String> delegates = [];
//   bool isAdding = false;

//   bool isEditing = false;
//   String? editingSupplierId;

//   // دالة تحويل الوزن إلى 24 قيراط
//   double _convertTo24Karat(double weight, String carat) {
//     switch (carat) {
//       case '18':
//         return weight * (18 / 24);
//       case '21':
//         return weight * (21 / 24);
//       case '22':
//         return weight * (22 / 24);
//       default:
//         return weight;
//     }
//   }

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

//   Future<void> _addSupplier() async {
//     if (nameCtrl.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_t("ادخل اسم المورد", "Enter supplier name"))),
//       );
//       return;
//     }

//     setState(() => isAdding = true);

//     try {
//       await FS.addSupplier(
//         name: nameCtrl.text.trim(),
//         delegates: delegates,
//         phone: phoneCtrl.text.trim(),
//       );

//       nameCtrl.clear();
//       phoneCtrl.clear();
//       delegateCtrl.clear();
//       setState(() => delegates.clear());

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               _t("تم إضافة المورد بنجاح ✅", "Supplier added successfully ✅")),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('${_t("حدث خطأ", "Error")}: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() => isAdding = false);
//     }
//   }

//   void _addDelegate() {
//     if (delegateCtrl.text.trim().isNotEmpty) {
//       setState(() {
//         delegates.add(delegateCtrl.text.trim());
//         delegateCtrl.clear();
//       });
//     }
//   }

//   void _removeDelegate(String name) {
//     setState(() => delegates.remove(name));
//   }

//   // ============================================================
//   // 🔹 حساب رصيد المورد (مع دعم العيارات المتعددة)
//   // ============================================================
//   Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
//     final vouchers = await FS.getVouchersForSupplier(supplierId);

//     double payW = 0, recW = 0;
//     double payG = 0, recG = 0;

//     for (var v in vouchers) {
//       // التحقق من وجود عيارات متعددة
//       final carats = v["carats"] as List?;

//       if (carats != null && carats.isNotEmpty) {
//         // إذا كان السند يحتوي على عيارات متعددة
//         for (var c in carats) {
//           final weight = (c["weight"] ?? 0).toDouble();
//           final wage = (c["wage"] ?? 0).toDouble();
//           final carat = (c["carat"] ?? "").toString();
//           final weightIn24 = _convertTo24Karat(weight, carat);

//           if (v["type"] == "payment") {
//             payW += weightIn24;
//             payG += wage;
//           } else if (v["type"] == "receipt") {
//             recW += weightIn24;
//             recG += wage;
//           }
//         }
//       } else {
//         // السند العادي (عيار واحد)
//         final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//         final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
//         final carat = (v["carat"] ?? "").toString();
//         final weightIn24 = _convertTo24Karat(weight, carat);

//         if (v["type"] == "payment") {
//           payW += weightIn24;
//           payG += wage;
//         } else if (v["type"] == "receipt") {
//           recW += weightIn24;
//           recG += wage;
//         }
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

//   void _showAddDialog() {
//     nameCtrl.clear();
//     phoneCtrl.clear();
//     delegateCtrl.clear();
//     setState(() => delegates.clear());
//     isEditing = false;

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _buildSupplierDialog(
//         title: _t("إضافة مورد جديد", "Add New Supplier"),
//         isEditing: false,
//       ),
//     );
//   }

//   void _showEditDialog(Map<String, dynamic> supplier) {
//     nameCtrl.text = supplier["name"] ?? "";
//     phoneCtrl.text = supplier["phone"] ?? "";
//     setState(() {
//       delegates = List<String>.from(supplier["delegates"] ?? []);
//       isEditing = true;
//       editingSupplierId = supplier["id"];
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _buildSupplierDialog(
//         title: _t("تعديل المورد", "Edit Supplier"),
//         isEditing: true,
//         supplierId: supplier["id"],
//       ),
//     );
//   }

//   Widget _buildSupplierDialog({
//     required String title,
//     required bool isEditing,
//     String? supplierId,
//   }) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Row(
//         children: [
//           Icon(
//             isEditing ? Icons.edit : Icons.person_add,
//             color: const Color(0xFFD4AF37),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//         ],
//       ),
//       content: StatefulBuilder(
//         builder: (context, setStateDialog) {
//           return SizedBox(
//             width: MediaQuery.of(context).size.width * 0.85,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: nameCtrl,
//                   decoration: InputDecoration(
//                     labelText: _t("اسم المورد", "Supplier Name"),
//                     prefixIcon:
//                         const Icon(Icons.business, color: Color(0xFFD4AF37)),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade50,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: phoneCtrl,
//                   decoration: InputDecoration(
//                     labelText: _t("رقم الجوال", "Phone"),
//                     prefixIcon:
//                         const Icon(Icons.phone, color: Color(0xFFD4AF37)),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey.shade50,
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: delegateCtrl,
//                         decoration: InputDecoration(
//                           labelText: _t("مندوب", "Delegate"),
//                           prefixIcon: const Icon(Icons.person,
//                               color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey.shade50,
//                         ),
//                         onSubmitted: (_) => _addDelegateDialog(setStateDialog),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFD4AF37),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.add, color: Colors.white),
//                         onPressed: () => _addDelegateDialog(setStateDialog),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(
//                           minWidth: 48,
//                           minHeight: 48,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (delegates.isNotEmpty) ...[
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Wrap(
//                       spacing: 6,
//                       runSpacing: 4,
//                       children: delegates
//                           .map((d) => Chip(
//                                 label: Text(d,
//                                     style: const TextStyle(fontSize: 13)),
//                                 backgroundColor: Colors.white,
//                                 deleteIcon: const Icon(Icons.close, size: 16),
//                                 onDeleted: () =>
//                                     _removeDelegateDialog(d, setStateDialog),
//                                 side: BorderSide(color: Colors.grey.shade300),
//                               ))
//                           .toList(),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         },
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             _t("إلغاء", "Cancel"),
//             style: TextStyle(color: Colors.grey.shade600),
//           ),
//         ),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFD4AF37),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//           onPressed: () async {
//             if (nameCtrl.text.trim().isEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(_t("ادخل اسم المورد", "Enter supplier name")),
//                 ),
//               );
//               return;
//             }

//             if (isEditing && supplierId != null) {
//               await FS.updateSupplier(
//                 supplierId,
//                 {
//                   "name": nameCtrl.text.trim(),
//                   "phone": phoneCtrl.text.trim(),
//                   "delegates": delegates,
//                 },
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(_t("تم التعديل ✅", "Updated ✅")),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             } else {
//               await FS.addSupplier(
//                 name: nameCtrl.text.trim(),
//                 delegates: delegates,
//                 phone: phoneCtrl.text.trim(),
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(_t("تم الإضافة ✅", "Added ✅")),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             }

//             nameCtrl.clear();
//             phoneCtrl.clear();
//             delegateCtrl.clear();
//             setState(() => delegates.clear());
//             Navigator.pop(context);
//           },
//           child: Text(
//             isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _addDelegateDialog(StateSetter setStateDialog) {
//     if (delegateCtrl.text.trim().isNotEmpty) {
//       setStateDialog(() {
//         delegates.add(delegateCtrl.text.trim());
//         delegateCtrl.clear();
//       });
//     }
//   }

//   void _removeDelegateDialog(String name, StateSetter setStateDialog) {
//     setStateDialog(() => delegates.remove(name));
//   }

//   Future<void> _deleteSupplier(Map<String, dynamic> supplier) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
//         content:
//             Text(_t("حذف ${supplier["name"]}؟", "Delete ${supplier["name"]}?")),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(_t("إلغاء", "Cancel")),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(_t("حذف", "Delete"),
//                 style: const TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await FS.deleteSupplier(supplier["id"]);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_t("تم الحذف ✅", "Deleted ✅")),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
//     }
//   }

//   // ======================
//   // 🔹 عرض تفاصيل المورد
//   // ======================
//   void _showSupplierDetails(String supplierId) async {
//     final vouchers = await FS.getVouchersForSupplier(supplierId);

//     // ✅ ترتيب السندات من الأحدث إلى الأقدم
//     vouchers.sort((a, b) {
//       final dateA = a["date"] as Timestamp?;
//       final dateB = b["date"] as Timestamp?;
//       if (dateA == null && dateB == null) return 0;
//       if (dateA == null) return 1;
//       if (dateB == null) return -1;
//       return dateB.toDate().compareTo(dateA.toDate());
//     });

//     final receiptVouchers =
//         vouchers.where((v) => v["type"] == "receipt").toList();
//     final paymentVouchers =
//         vouchers.where((v) => v["type"] == "payment").toList();

//     // ✅ حساب تفاصيل العيارات مع دعم العيارات المتعددة
//     Map<String, Map<String, double>> _calculateSummary(
//         List<Map<String, dynamic>> voucherList) {
//       final Map<String, double> weightMap = {"18": 0, "21": 0, "22": 0};
//       final Map<String, double> wageMap = {"18": 0, "21": 0, "22": 0};
//       final Map<String, double> weight24Map = {"18": 0, "21": 0, "22": 0};

//       for (var v in voucherList) {
//         // التحقق من وجود عيارات متعددة
//         final carats = v["carats"] as List?;

//         if (carats != null && carats.isNotEmpty) {
//           // إذا كان السند يحتوي على عيارات متعددة
//           for (var c in carats) {
//             final carat = (c["carat"] ?? "").toString();
//             final weight = (c["weight"] ?? 0).toDouble();
//             final wage = (c["wage"] ?? 0).toDouble();

//             if (["18", "21", "22"].contains(carat)) {
//               weightMap[carat] = (weightMap[carat] ?? 0) + weight;
//               wageMap[carat] = (wageMap[carat] ?? 0) + wage;
//               weight24Map[carat] =
//                   (weight24Map[carat] ?? 0) + _convertTo24Karat(weight, carat);
//             }
//           }
//         } else {
//           // السند العادي (عيار واحد)
//           final carat = (v["carat"] ?? "").toString();
//           final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//           final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

//           if (["18", "21", "22"].contains(carat)) {
//             weightMap[carat] = (weightMap[carat] ?? 0) + weight;
//             wageMap[carat] = (wageMap[carat] ?? 0) + wage;
//             weight24Map[carat] =
//                 (weight24Map[carat] ?? 0) + _convertTo24Karat(weight, carat);
//           }
//         }
//       }
//       return {"weight": weightMap, "wage": wageMap, "weight24": weight24Map};
//     }

//     final receiptSummary = _calculateSummary(receiptVouchers);
//     final paymentSummary = _calculateSummary(paymentVouchers);

//     final totalReceiptWeight24 =
//         receiptSummary["weight24"]!.values.fold(0.0, (a, b) => a + b);
//     final totalReceiptWage =
//         receiptSummary["wage"]!.values.fold(0.0, (a, b) => a + b);
//     final totalPaymentWeight24 =
//         paymentSummary["weight24"]!.values.fold(0.0, (a, b) => a + b);
//     final totalPaymentWage =
//         paymentSummary["wage"]!.values.fold(0.0, (a, b) => a + b);

//     final balanceWeight24 = totalReceiptWeight24 - totalPaymentWeight24;
//     final balanceWage = totalReceiptWage - totalPaymentWage;
//     final allCleared =
//         balanceWeight24.abs() < 0.0001 && balanceWage.abs() < 0.0001;

//     if (!mounted) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.92,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         builder: (_, scrollController) {
//           return DefaultTabController(
//             length: 2,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 12),
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                   const SizedBox(height: 14),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 24,
//                           backgroundColor:
//                               const Color(0xFFD4AF37).withOpacity(0.15),
//                           child: const Icon(Icons.person,
//                               color: Color(0xFFD4AF37), size: 26),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 vouchers.isNotEmpty
//                                     ? (vouchers.first["supplierName"] ?? "")
//                                     : "",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 19,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "${vouchers.length} ${_t("عملية", "transactions")}",
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close, color: Colors.grey.shade600),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // ===== كارت الرصيد الإجمالي =====
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: allCleared
//                             ? Colors.green.shade50
//                             : balanceWeight24 > 0
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: allCleared
//                               ? Colors.green.shade200
//                               : balanceWeight24 > 0
//                                   ? Colors.red.shade200
//                                   : Colors.green.shade200,
//                         ),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: allCleared
//                                   ? Colors.green
//                                   : balanceWeight24 > 0
//                                       ? Colors.red
//                                       : Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               allCleared
//                                   ? Icons.check_rounded
//                                   : balanceWeight24 > 0
//                                       ? Icons.north_east_rounded
//                                       : Icons.south_west_rounded,
//                               color: Colors.white,
//                               size: 22,
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   allCleared
//                                       ? _t("✅ الحساب مُصفّى بالكامل",
//                                           "✅ Fully settled")
//                                       : balanceWeight24 > 0
//                                           ? _t("📤 رصيد للمورد (24 قيراط)",
//                                               "📤 Balance owed to supplier (equiv. 24K)")
//                                           : _t("📥 رصيد على المورد (24 قيراط)",
//                                               "📥 Supplier owes us (equiv. 24K)"),
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                     color: allCleared
//                                         ? Colors.green.shade800
//                                         : balanceWeight24 > 0
//                                             ? Colors.red.shade800
//                                             : Colors.green.shade800,
//                                   ),
//                                 ),
//                                 if (!allCleared) ...[
//                                   const SizedBox(height: 8),
//                                   Wrap(
//                                     spacing: 16,
//                                     runSpacing: 4,
//                                     children: [
//                                       _summaryValue(
//                                         icon: Icons.scale_outlined,
//                                         label: _t("الوزن", "Weight"),
//                                         value:
//                                             "${balanceWeight24.abs().toStringAsFixed(2)} جم",
//                                       ),
//                                       _summaryValue(
//                                         icon: Icons.payments_outlined,
//                                         label: _t("الأجر", "Wage"),
//                                         value: balanceWage
//                                             .abs()
//                                             .toStringAsFixed(2),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   const Divider(height: 1),

//                   Container(
//                     color: Colors.white,
//                     child: TabBar(
//                       indicatorColor: const Color(0xFFD4AF37),
//                       indicatorWeight: 3,
//                       labelColor: const Color(0xFFD4AF37),
//                       unselectedLabelColor: Colors.grey.shade600,
//                       labelStyle: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                       tabs: [
//                         Tab(text: _t("📥 قبض", "📥 Receipt")),
//                         Tab(text: _t("📤 صرف", "📤 Payment")),
//                       ],
//                     ),
//                   ),

//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         _buildTabContent(
//                           context,
//                           scrollController,
//                           voucherList: receiptVouchers,
//                           summaryMap: receiptSummary,
//                           type: 'receipt',
//                         ),
//                         _buildTabContent(
//                           context,
//                           scrollController,
//                           voucherList: paymentVouchers,
//                           summaryMap: paymentSummary,
//                           type: 'payment',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ==========================================
//   // 🔹 دالة مساعدة لبناء محتوى كل تبويب
//   // ==========================================
//   Widget _buildTabContent(
//     BuildContext context,
//     ScrollController scrollController, {
//     required List<Map<String, dynamic>> voucherList,
//     required Map<String, Map<String, double>> summaryMap,
//     required String type,
//   }) {
//     final isReceipt = type == 'receipt';
//     final color = isReceipt ? Colors.green : Colors.red;
//     final title = isReceipt
//         ? _t("تفاصيل القبض", "Receipt Details")
//         : _t("تفاصيل الصرف", "Payment Details");

//     final weightMap = summaryMap["weight"]!;
//     final wageMap = summaryMap["wage"]!;
//     final weight24Map = summaryMap["weight24"]!;

//     final caratsWithBalance = ["18", "21", "22"].where((c) {
//       return weightMap[c]!.abs() > 0.0001 || wageMap[c]!.abs() > 0.0001;
//     }).toList();

//     final totalWeight = weightMap.values.fold(0.0, (a, b) => a + b);
//     final totalWage = wageMap.values.fold(0.0, (a, b) => a + b);
//     final allCleared = caratsWithBalance.isEmpty;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
//       child: ListView(
//         controller: scrollController,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color:
//                   allCleared ? Colors.grey.shade100 : color.withOpacity(0.07),
//               borderRadius: BorderRadius.circular(18),
//               border: Border.all(
//                 color:
//                     allCleared ? Colors.grey.shade300 : color.withOpacity(0.3),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: allCleared ? Colors.grey : color,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     allCleared
//                         ? Icons.check_rounded
//                         : isReceipt
//                             ? Icons.south_west_rounded
//                             : Icons.north_east_rounded,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         allCleared
//                             ? _t("لا توجد معاملات", "No transactions")
//                             : title,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                           color: allCleared ? Colors.grey.shade600 : color,
//                         ),
//                       ),
//                       if (!allCleared) ...[
//                         const SizedBox(height: 8),
//                         Wrap(
//                           spacing: 16,
//                           runSpacing: 4,
//                           children: [
//                             _summaryValue(
//                               icon: Icons.scale_outlined,
//                               label: _t("الوزن", "Weight"),
//                               value:
//                                   "${totalWeight.abs().toStringAsFixed(2)} جم",
//                             ),
//                             _summaryValue(
//                               icon: Icons.payments_outlined,
//                               label: _t("الأجر", "Wage"),
//                               value: totalWage.abs().toStringAsFixed(2),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (!allCleared) ...[
//             const SizedBox(height: 18),
//             Row(
//               children: [
//                 Icon(
//                   Icons.category_outlined,
//                   color: color,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   _t("تفاصيل العيارات", "Carat Breakdown"),
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 130,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: caratsWithBalance.length,
//                 itemBuilder: (context, index) {
//                   final carat = caratsWithBalance[index];
//                   final weight = weightMap[carat]!;
//                   final wage = wageMap[carat]!;
//                   final weight24 = weight24Map[carat]!;
//                   final isZero = weight.abs() < 0.0001 && wage.abs() < 0.0001;

//                   Color cardColor;
//                   if (isZero) {
//                     cardColor = Colors.grey;
//                   } else {
//                     cardColor = isReceipt ? Colors.green : Colors.red;
//                   }

//                   return Container(
//                     width: 150,
//                     margin: const EdgeInsets.only(right: 12),
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: cardColor.withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(
//                         color: cardColor.withOpacity(0.3),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _t("عيار $carat", "K$carat"),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         if (!isZero) ...[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.scale_outlined,
//                                   size: 14, color: Colors.grey),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "${weight.abs().toStringAsFixed(2)} جم",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 13,
//                                   color: cardColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 2),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.payments_outlined,
//                                   size: 14, color: Colors.grey),
//                               const SizedBox(width: 4),
//                               Text(
//                                 "${wage.abs().toStringAsFixed(2)} ${_t("أجر", "wage")}",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: cardColor.withOpacity(0.85),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ] else ...[
//                           Text(
//                             _t("مصفى", "Cleared"),
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//           const SizedBox(height: 24),
//           Row(
//             children: [
//               Icon(
//                 isReceipt ? Icons.south_west_rounded : Icons.north_east_rounded,
//                 color: color,
//                 size: 18,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 isReceipt
//                     ? _t("سندات القبض", "Receipt Vouchers")
//                     : _t("سندات الصرف", "Payment Vouchers"),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15,
//                 ),
//               ),
//               const Spacer(),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   "${voucherList.length}",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: color,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           if (voucherList.isEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 30),
//               child: Center(
//                 child: Text(
//                   _t("لا توجد سندات", "No vouchers"),
//                   style: TextStyle(color: Colors.grey.shade500),
//                 ),
//               ),
//             )
//           else
//             ...voucherList.map((v) {
//               final carat = (v["carat"] ?? "").toString();
//               final weight =
//                   double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//               final weight24 = _convertTo24Karat(weight, carat);

//               // التحقق من وجود عيارات متعددة
//               final carats = v["carats"] as List?;
//               final hasMultipleCarats = carats != null && carats.isNotEmpty;

//               // حساب الوزن الإجمالي للعيارات المتعددة
//               double totalCaratsWeight = 0;
//               double totalCaratsWage = 0;

//               // بناء قائمة Widgets للعيارات
//               List<Widget> caratWidgets = [];
//               if (hasMultipleCarats) {
//                 for (var c in carats!) {
//                   totalCaratsWeight += (c['weight'] ?? 0).toDouble();
//                   totalCaratsWage += (c['wage'] ?? 0).toDouble();
//                   caratWidgets.add(
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 2),
//                       margin: const EdgeInsets.only(bottom: 2),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFD4AF37).withOpacity(0.08),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${_t('عيار', 'Carat')}: ${c['carat']} | ${_t('وزن', 'Weight')}: ${(c['weight'] ?? 0).toStringAsFixed(2)} ${_t('جم', 'g')} | ${_t('أجر', 'Wage')}: ${(c['wage'] ?? 0).toStringAsFixed(2)}",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 // إضافة إجمالي الوزن والأجر
//                 caratWidgets.add(
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                     margin: const EdgeInsets.only(top: 2),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       "${_t('إجمالي الوزن', 'Total Weight')}: ${totalCaratsWeight.toStringAsFixed(2)} ${_t('جم', 'g')} | ${_t('إجمالي الأجر', 'Total Wage')}: ${totalCaratsWage.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFFD4AF37),
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 10),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: Colors.grey.shade200),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.03),
//                       blurRadius: 6,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 18,
//                           backgroundColor: isReceipt
//                               ? Colors.green.shade50
//                               : Colors.red.shade50,
//                           child: Icon(
//                             isReceipt
//                                 ? Icons.south_west_rounded
//                                 : Icons.north_east_rounded,
//                             color: isReceipt ? Colors.green : Colors.red,
//                             size: 18,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     isReceipt
//                                         ? _t("سند قبض", "Receipt")
//                                         : _t("سند صرف", "Payment"),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   const Spacer(),
//                                   if (v["date"] != null)
//                                     Text(
//                                       DateFormat("dd/MM/yyyy HH:mm").format(
//                                         (v["date"] as Timestamp).toDate(),
//                                       ),
//                                       style: TextStyle(
//                                         fontSize: 11,
//                                         color: Colors.grey.shade500,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                               const SizedBox(height: 4),
//                               // عرض المندوب
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade100,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   "${_t('مندوب', 'Delegate')}: ${v["delegate"]?.toString() ?? "-"}",
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               // عرض العيارات
//                               if (hasMultipleCarats) ...[
//                                 ...caratWidgets,
//                               ] else ...[
//                                 Row(
//                                   children: [
//                                     _voucherChip(_t("عيار", "Carat"), carat),
//                                     const SizedBox(width: 4),
//                                     _voucherChip(_t("وزن", "Weight"),
//                                         "${weight.toStringAsFixed(2)} جم"),
//                                     const SizedBox(width: 4),
//                                     _voucherChip(
//                                         _t("أجر", "Wage"), "${v["wage"] ?? 0}"),
//                                   ],
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//         ],
//       ),
//     );
//   }

//   Widget _summaryValue({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 14, color: Colors.grey.shade700),
//         const SizedBox(width: 4),
//         Text(
//           "$label: $value",
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade800,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _voucherChip(String label, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         "$label: $value",
//         style: TextStyle(
//           fontSize: 11,
//           color: Colors.grey.shade700,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   // ======================
//   // 🔹 BUILD
//   // ======================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddDialog,
//         backgroundColor: const Color(0xFFD4AF37),
//         child: const Icon(Icons.add, color: Colors.white, size: 30),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText:
//                             _t("🔍 بحث عن مورد...", "🔍 Search supplier..."),
//                         border: InputBorder.none,
//                         hintStyle: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                       onChanged: (value) {
//                         // يمكن إضافة منطق البحث هنا
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFD4AF37).withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     _t(" الموردين", "Suppliers"),
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFFD4AF37),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: StreamBuilder<List<Map<String, dynamic>>>(
//               stream: FS.suppliersStream(),
//               builder: (context, snap) {
//                 if (!snap.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final suppliers = snap.data!;

//                 if (suppliers.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.people_outline,
//                           size: 64,
//                           color: Colors.grey.shade300,
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           _t("لا يوجد موردين", "No suppliers"),
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           _t("اضغط على زر + لإضافة مورد",
//                               "Tap + to add a supplier"),
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   itemCount: suppliers.length,
//                   itemBuilder: (_, i) {
//                     final s = suppliers[i];
//                     return _buildSupplierCard(s);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ======================
//   // 🔹 بطاقة المورد
//   // ======================
//   Widget _buildSupplierCard(Map<String, dynamic> supplier) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: FutureBuilder<Map<String, dynamic>>(
//         future: _supplierSummary(supplier["id"]),
//         builder: (context, snap) {
//           final isCleared = snap.hasData ? snap.data!["cleared"] : false;
//           final balanceWeight = snap.hasData ? snap.data!["weight"] : 0.0;
//           final balanceWage = snap.hasData ? snap.data!["wage"] : 0.0;

//           Color statusColor;
//           String statusText;
//           IconData statusIcon;

//           if (isCleared) {
//             statusColor = Colors.green;
//             statusText = _t("مصفى", "Cleared");
//             statusIcon = Icons.check_circle;
//           } else if (balanceWeight > 0) {
//             statusColor = Colors.red;
//             statusText = _t("له", "Owed");
//             statusIcon = Icons.arrow_upward;
//           } else {
//             statusColor = Colors.green;
//             statusText = _t("عليه", "Owes");
//             statusIcon = Icons.arrow_downward;
//           }

//           return InkWell(
//             onTap: () => _showSupplierDetails(supplier["id"]),
//             borderRadius: BorderRadius.circular(14),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 24,
//                     backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
//                     child: const Icon(Icons.person,
//                         color: Color(0xFFD4AF37), size: 28),
//                   ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           supplier["name"],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 2),
//                         if (supplier["phone"] != null &&
//                             supplier["phone"].toString().isNotEmpty)
//                           Text(
//                             "📞 ${supplier["phone"]}",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         if (supplier["delegates"] != null &&
//                             supplier["delegates"].isNotEmpty)
//                           Text(
//                             "👤 ${supplier["delegates"].join(", ")}",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade500,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         const SizedBox(height: 4),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(statusIcon, color: statusColor, size: 14),
//                               const SizedBox(width: 4),
//                               Text(
//                                 statusText,
//                                 style: TextStyle(
//                                   color: statusColor,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               if (!isCleared) ...[
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   "${balanceWeight.abs().toStringAsFixed(1)} جم",
//                                   style: TextStyle(
//                                     color: statusColor,
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   PopupMenuButton<String>(
//                     icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
//                     onSelected: (value) {
//                       if (value == 'edit') _showEditDialog(supplier);
//                       if (value == 'delete') _deleteSupplier(supplier);
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(
//                         value: 'edit',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.edit,
//                                 color: Colors.orange, size: 20),
//                             const SizedBox(width: 8),
//                             Text(_t("تعديل", "Edit")),
//                           ],
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'delete',
//                         child: Row(
//                           children: [
//                             const Icon(Icons.delete,
//                                 color: Colors.red, size: 20),
//                             const SizedBox(width: 8),
//                             Text(_t("حذف", "Delete")),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 Part1Page - صفحة السندات
// // ============================================================
// class Part1Page extends StatefulWidget {
//   const Part1Page({super.key});

//   @override
//   State<Part1Page> createState() => _Part1PageState();
// }

// class _Part1PageState extends State<Part1Page> {
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

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("السندات", "Vouchers")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               theme.colorScheme.surface,
//               theme.colorScheme.surface.withOpacity(0.8),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 1,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 4,
//                   children: [
//                     _buildMenuCard(
//                       context,
//                       icon: Icons.receipt_long,
//                       label: _t("سند قبض", "Receipt Voucher"),
//                       page: const ReceiptVoucherPage(),
//                     ),
//                     _buildMenuCard(
//                       context,
//                       icon: Icons.payments,
//                       label: _t("سند صرف", "Payment Voucher"),
//                       page: const PaymentVoucherPage(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     Widget? page,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap ??
//           () {
//             if (page != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => page),
//               );
//             }
//           },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 4,
//         color: const Color(0xFFD4AF37).withOpacity(0.9),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 36, color: Colors.white),
//               const SizedBox(width: 20),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
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
// // 🔹 Part2Page - صفحة الأموال
// // ============================================================
// class Part2Page extends StatefulWidget {
//   const Part2Page({super.key});

//   @override
//   State<Part2Page> createState() => _Part2PageState();
// }

// class _Part2PageState extends State<Part2Page> {
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

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("الأموال", "Funds")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               theme.colorScheme.surface,
//               theme.colorScheme.surface.withOpacity(0.8),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 1,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 4,
//                   children: [
//                     _buildMenuCard(
//                       context,
//                       icon: Icons.account_balance_wallet,
//                       label: _t("الصندوق", "Cash Box"),
//                       page: const CashBoxPage(),
//                     ),
//                     _buildMenuCard(
//                       context,
//                       icon: Icons.monetization_on,
//                       label: _t("المصروفات", "Expenses"),
//                       page: const ExpensesPage(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuCard(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     Widget? page,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap ??
//           () {
//             if (page != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => page),
//               );
//             }
//           },
//       child: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 4,
//         color: const Color(0xFFD4AF37).withOpacity(0.9),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 36, color: Colors.white),
//               const SizedBox(width: 20),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
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
// // 🔹 صفحة سند القبض (متعددة العيارات مع عرض الرصيد)
// // ============================================================
// class ReceiptVoucherPage extends StatefulWidget {
//   const ReceiptVoucherPage({super.key});

//   @override
//   State<ReceiptVoucherPage> createState() => _ReceiptVoucherPageState();
// }

// class _ReceiptVoucherPageState extends State<ReceiptVoucherPage> {
//   DateTime? date = DateTime.now();
//   String? supplierName;
//   String? supplierId;
//   String? delegate;

//   List<Map<String, dynamic>> caratItems = [];

//   // متغيرات الرصيد
//   double _balanceWeight24 = 0.0;
//   double _balanceWage = 0.0;
//   bool _isLoadingBalance = false;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _addNewCaratItem();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   void _addNewCaratItem() {
//     setState(() {
//       caratItems.add({
//         'carat': null,
//         'weight': 0.0,
//         'wage': 0.0,
//       });
//     });
//   }

//   void _removeCaratItem(int index) {
//     setState(() {
//       caratItems.removeAt(index);
//     });
//   }

//   // دالة تحويل الوزن إلى 24 قيراط
//   double _convertTo24Karat(double weight, String carat) {
//     switch (carat) {
//       case '18':
//         return weight * (18 / 24);
//       case '21':
//         return weight * (21 / 24);
//       case '22':
//         return weight * (22 / 24);
//       default:
//         return weight;
//     }
//   }

//   double _calculateTotalWeight() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['weight'] > 0) {
//         total += item['weight'];
//       }
//     }
//     return total;
//   }

//   double _calculateTotalWeight24() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['weight'] > 0) {
//         total += _convertTo24Karat(item['weight'], item['carat'].toString());
//       }
//     }
//     return total;
//   }

//   double _calculateTotalWage() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['wage'] > 0) {
//         total += item['wage'];
//       }
//     }
//     return total;
//   }

//   // ✅ جلب رصيد المورد محول إلى 24 قيراط (مصحح)
//   Future<void> _loadSupplierBalance(String supplierId) async {
//     setState(() => _isLoadingBalance = true);
//     try {
//       final vouchers = await FS.getVouchersForSupplier(supplierId);

//       double payW = 0, recW = 0;
//       double payG = 0, recG = 0;

//       for (var v in vouchers) {
//         // التحقق من وجود عيارات متعددة
//         final carats = v["carats"] as List?;

//         if (carats != null && carats.isNotEmpty) {
//           // إذا كان السند يحتوي على عيارات متعددة
//           for (var c in carats) {
//             final weight = (c["weight"] ?? 0).toDouble();
//             final wage = (c["wage"] ?? 0).toDouble();
//             final carat = (c["carat"] ?? "").toString();
//             final weightIn24 = _convertTo24Karat(weight, carat);

//             if (v["type"] == "payment") {
//               payW += weightIn24;
//               payG += wage;
//             } else if (v["type"] == "receipt") {
//               recW += weightIn24;
//               recG += wage;
//             }
//           }
//         } else {
//           // السند العادي (عيار واحد)
//           final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//           final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
//           final carat = (v["carat"] ?? "").toString();
//           final weightIn24 = _convertTo24Karat(weight, carat);

//           if (v["type"] == "payment") {
//             payW += weightIn24;
//             payG += wage;
//           } else if (v["type"] == "receipt") {
//             recW += weightIn24;
//             recG += wage;
//           }
//         }
//       }

//       // ✅ الرصيد = القبض - الصرف (محول إلى 24 قيراط)
//       final balanceWeight = recW - payW;
//       final balanceWage = recG - payG;

//       setState(() {
//         _balanceWeight24 = balanceWeight;
//         _balanceWage = balanceWage;
//       });
//     } catch (e) {
//       print('❌ خطأ في جلب الرصيد: $e');
//     } finally {
//       setState(() => _isLoadingBalance = false);
//     }
//   }

//   // حساب الرصيد المتبقي بعد الإضافة
//   double _getNewBalance() {
//     return _balanceWeight24 + _calculateTotalWeight24();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("سند القبض", "Receipt Voucher")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // بطاقة المعلومات الأساسية
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     // التاريخ
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today,
//                             color: Color(0xFFD4AF37), size: 20),
//                         const SizedBox(width: 8),
//                         Text(
//                           _t('التاريخ', 'Date'),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           DateFormat("yyyy-MM-dd").format(date!),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, size: 18),
//                           onPressed: () async {
//                             final picked = await showDatePicker(
//                               context: context,
//                               initialDate: date!,
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime(2100),
//                             );
//                             if (picked != null) {
//                               setState(() => date = picked);
//                             }
//                           },
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                     const Divider(height: 16),

//                     // اختيار المورد
//                     FutureBuilder(
//                       future: FS.getSuppliers(),
//                       builder: (context, snap) {
//                         if (!snap.hasData) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         final suppliers = snap.data!;
//                         return DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             labelText: _t("اختر المورد", "Select Supplier"),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             prefixIcon: const Icon(Icons.business,
//                                 color: Color(0xFFD4AF37), size: 20),
//                           ),
//                           value: supplierId,
//                           items: suppliers.map((s) {
//                             return DropdownMenuItem(
//                               value: s["id"].toString(),
//                               child: Text(s["name"]),
//                             );
//                           }).toList(),
//                           onChanged: (v) {
//                             setState(() {
//                               supplierId = v;
//                               supplierName = suppliers.firstWhere(
//                                   (s) => s["id"].toString() == v)["name"];
//                               delegate = null;
//                               _balanceWeight24 = 0.0;
//                               _balanceWage = 0.0;
//                             });
//                             if (v != null) {
//                               _loadSupplierBalance(v);
//                             }
//                           },
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 12),

//                     // اختيار المندوب
//                     if (supplierId != null)
//                       FutureBuilder(
//                         future: FS.getSuppliers(),
//                         builder: (context, snap) {
//                           if (!snap.hasData) return const SizedBox();
//                           final supplier = snap.data!
//                               .firstWhere((s) => s["id"] == supplierId);
//                           final delegates =
//                               List<String>.from(supplier["delegates"] ?? []);
//                           if (delegates.isEmpty) {
//                             return Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.shade50,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border:
//                                     Border.all(color: Colors.orange.shade200),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.warning,
//                                       color: Colors.orange.shade700, size: 18),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       _t("لا يوجد مناديب لهذا المورد",
//                                           "No delegates for this supplier"),
//                                       style: TextStyle(
//                                         color: Colors.orange.shade700,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: _t("اختر المندوب", "Select Delegate"),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               prefixIcon: const Icon(Icons.person,
//                                   color: Color(0xFFD4AF37), size: 20),
//                             ),
//                             value: delegate,
//                             items: delegates.map((d) {
//                               return DropdownMenuItem(
//                                 value: d,
//                                 child: Text(d),
//                               );
//                             }).toList(),
//                             onChanged: (v) => setState(() => delegate = v),
//                           );
//                         },
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             // ===== كارت الرصيد =====
//             // if (supplierId != null) ...[
//             //   const SizedBox(height: 8),
//             //   Container(
//             //     padding: const EdgeInsets.all(12),
//             //     decoration: BoxDecoration(
//             //       color: _getNewBalance() > 0
//             //           ? Colors.green.shade50
//             //           : _getNewBalance() < 0
//             //               ? Colors.red.shade50
//             //               : Colors.grey.shade50,
//             //       borderRadius: BorderRadius.circular(12),
//             //       border: Border.all(
//             //         color: _getNewBalance() > 0
//             //             ? Colors.green.shade300
//             //             : _getNewBalance() < 0
//             //                 ? Colors.red.shade300
//             //                 : Colors.grey.shade300,
//             //       ),
//             //     ),
//             //     child: Column(
//             //       children: [
//             //         Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           children: [
//             //             Text(
//             //               _t("الرصيد الحالي (24 قيراط)",
//             //                   "Current Balance (24K)"),
//             //               style: const TextStyle(
//             //                 fontWeight: FontWeight.bold,
//             //                 fontSize: 14,
//             //               ),
//             //             ),
//             //             if (_isLoadingBalance)
//             //               const SizedBox(
//             //                 width: 20,
//             //                 height: 20,
//             //                 child: CircularProgressIndicator(strokeWidth: 2),
//             //               )
//             //             else
//             //               Text(
//             //                 "${_balanceWeight24.toStringAsFixed(2)} ${_t('جم', 'g')}",
//             //                 style: TextStyle(
//             //                   fontWeight: FontWeight.bold,
//             //                   fontSize: 16,
//             //                   color: _balanceWeight24 > 0
//             //                       ? Colors.red
//             //                       : _balanceWeight24 < 0
//             //                           ? Colors.green
//             //                           : Colors.grey,
//             //                 ),
//             //               ),
//             //           ],
//             //         ),
//             //         const SizedBox(height: 4),
//             //         Row(
//             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //           children: [
//             //             Text(
//             //               _t("الرصيد بعد الإضافة", "Balance After Addition"),
//             //               style: const TextStyle(
//             //                 fontWeight: FontWeight.bold,
//             //                 fontSize: 14,
//             //               ),
//             //             ),
//             //             Text(
//             //               "${_getNewBalance().toStringAsFixed(2)} ${_t('جم', 'g')}",
//             //               style: TextStyle(
//             //                 fontWeight: FontWeight.bold,
//             //                 fontSize: 16,
//             //                 color: _getNewBalance() > 0
//             //                     ? Colors.red
//             //                     : _getNewBalance() < 0
//             //                         ? Colors.green
//             //                         : Colors.grey,
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //         if (_calculateTotalWeight24() > 0) ...[
//             //           const SizedBox(height: 4),
//             //           Container(
//             //             padding: const EdgeInsets.symmetric(
//             //                 horizontal: 8, vertical: 2),
//             //             decoration: BoxDecoration(
//             //               color: Colors.blue.shade50,
//             //               borderRadius: BorderRadius.circular(8),
//             //             ),
//             //             child: Text(
//             //               "${_t('قيد الإضافة', 'Adding')}: ${_calculateTotalWeight24().toStringAsFixed(2)} ${_t('جم (معادل 24)', 'g (equiv. 24K)')}",
//             //               style: TextStyle(
//             //                 fontSize: 12,
//             //                 color: Colors.blue.shade700,
//             //               ),
//             //             ),
//             //           ),
//             //         ],
//             //       ],
//             //     ),
//             //   ),
//             // ],

//             const SizedBox(height: 8),

//             // بطاقة العيارات المتعددة
//             Expanded(
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.category,
//                               color: Color(0xFFD4AF37), size: 20),
//                           const SizedBox(width: 6),
//                           Text(
//                             _t("العيارات", "Carats"),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           IconButton(
//                             icon: const Icon(Icons.add_circle,
//                                 color: Color(0xFFD4AF37), size: 28),
//                             onPressed: _addNewCaratItem,
//                             tooltip: _t("إضافة عيار", "Add Carat"),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFD4AF37).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               "${_t('الإجمالي', 'Total')}: ${_calculateTotalWeight().toStringAsFixed(2)} ${_t('جم', 'g')}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                                 color: Color(0xFFD4AF37),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 12),

//                       // قائمة العيارات
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: caratItems.length,
//                           itemBuilder: (context, index) {
//                             final item = caratItems[index];
//                             return _buildCaratItem(index, item);
//                           },
//                         ),
//                       ),

//                       // إجمالي الأجور
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFD4AF37).withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _t("إجمالي الأجور", "Total Wages"),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Text(
//                               "${_calculateTotalWage().toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Color(0xFFD4AF37),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       // زر الحفظ
//                       SizedBox(
//                         width: double.infinity,
//                         height: 44,
//                         child: ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFFD4AF37),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                           ),
//                           icon: const Icon(Icons.save,
//                               color: Colors.white, size: 20),
//                           label: Text(
//                             _t("حفظ", "Save"),
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           onPressed: () async {
//                             if (supplierId == null || delegate == null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(_t(
//                                       "يرجى اختيار المورد والمندوب",
//                                       "Please select supplier and delegate")),
//                                   backgroundColor: Colors.orange,
//                                 ),
//                               );
//                               return;
//                             }

//                             final validItems = caratItems
//                                 .where((item) =>
//                                     item['carat'] != null && item['weight'] > 0)
//                                 .toList();

//                             if (validItems.isEmpty) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(_t(
//                                       "يرجى إدخال عيار واحد على الأقل",
//                                       "Please enter at least one carat")),
//                                   backgroundColor: Colors.orange,
//                                 ),
//                               );
//                               return;
//                             }

//                             // تجهيز بيانات العيارات المتعددة
//                             List<Map<String, dynamic>> caratsData = [];
//                             for (var item in validItems) {
//                               caratsData.add({
//                                 'carat': item['carat'].toString(),
//                                 'weight': item['weight'],
//                                 'wage': item['wage'] ?? 0,
//                               });
//                             }

//                             // حفظ السند مع جميع العيارات
//                             await FS.addReceiptVoucher(
//                               supplierId: supplierId!,
//                               supplierName: supplierName!,
//                               delegate: delegate!,
//                               carat: 'multiple',
//                               weight: _calculateTotalWeight(),
//                               wage: _calculateTotalWage(),
//                               date: date!,
//                               carats: caratsData,
//                             );

//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(_t(
//                                     "تم حفظ السند بنجاح ✅ مع ${validItems.length} عيار",
//                                     "Receipt voucher saved successfully ✅ with ${validItems.length} carats")),
//                                 backgroundColor: Colors.green,
//                               ),
//                             );

//                             Future.delayed(const Duration(seconds: 1), () {
//                               Navigator.pop(context);
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCaratItem(int index, Map<String, dynamic> item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           // العيار - أصغر
//           Expanded(
//             flex: 3,
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 labelText: _t("العيار", "Carat"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               value: item['carat']?.toString(),
//               items: ["18", "21", "22"].map((c) {
//                 return DropdownMenuItem(
//                   value: c,
//                   child: Text(c),
//                 );
//               }).toList(),
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['carat'] = v;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 6),
//           // الوزن - أكبر
//           Expanded(
//             flex: 4,
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: _t("الوزن", "Weight"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixText: _t("جم", "g"),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['weight'] = double.tryParse(v) ?? 0;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 6),
//           // الأجر - متوسط
//           Expanded(
//             flex: 3,
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: _t("الأجر", "Wage"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['wage'] = double.tryParse(v) ?? 0;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 4),
//           // زر الحذف
//           IconButton(
//             icon: const Icon(Icons.remove_circle, color: Colors.red, size: 22),
//             onPressed:
//                 caratItems.length > 1 ? () => _removeCaratItem(index) : null,
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             tooltip: _t("حذف العيار", "Remove Carat"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 صفحة سند الصرف (متعددة العيارات مع عرض الرصيد)
// // ============================================================
// // ============================================================
// // 🔹 صفحة سند الصرف (متعددة العيارات مع عرض الرصيد)
// // ============================================================
// class PaymentVoucherPage extends StatefulWidget {
//   const PaymentVoucherPage({super.key});

//   @override
//   State<PaymentVoucherPage> createState() => _PaymentVoucherPageState();
// }

// class _PaymentVoucherPageState extends State<PaymentVoucherPage> {
//   DateTime? date = DateTime.now();
//   String? supplierName;
//   String? supplierId;
//   String? delegate;
//   String? paymentMethod;

//   List<Map<String, dynamic>> caratItems = [];

//   final cashCtrl = TextEditingController();
//   final networkCtrl = TextEditingController();

//   // متغيرات الرصيد
//   double _balanceWeight24 = 0.0;
//   double _balanceWage = 0.0;
//   bool _isLoadingBalance = false;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _addNewCaratItem();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   void _addNewCaratItem() {
//     setState(() {
//       caratItems.add({
//         'carat': null,
//         'weight': 0.0,
//         'wage': 0.0,
//       });
//     });
//   }

//   void _removeCaratItem(int index) {
//     setState(() {
//       caratItems.removeAt(index);
//     });
//   }

//   // دالة تحويل الوزن إلى 24 قيراط
//   double _convertTo24Karat(double weight, String carat) {
//     switch (carat) {
//       case '18':
//         return weight * (18 / 24);
//       case '21':
//         return weight * (21 / 24);
//       case '22':
//         return weight * (22 / 24);
//       default:
//         return weight;
//     }
//   }

//   double _calculateTotalWeight() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['weight'] > 0) {
//         total += item['weight'];
//       }
//     }
//     return total;
//   }

//   double _calculateTotalWeight24() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['weight'] > 0) {
//         total += _convertTo24Karat(item['weight'], item['carat'].toString());
//       }
//     }
//     return total;
//   }

//   double _calculateTotalWage() {
//     double total = 0;
//     for (var item in caratItems) {
//       if (item['carat'] != null && item['wage'] > 0) {
//         total += item['wage'];
//       }
//     }
//     return total;
//   }

//   // ✅ جلب رصيد المورد محول إلى 24 قيراط (مصحح)
//   Future<void> _loadSupplierBalance(String supplierId) async {
//     setState(() => _isLoadingBalance = true);
//     try {
//       final vouchers = await FS.getVouchersForSupplier(supplierId);

//       double payW = 0, recW = 0;
//       double payG = 0, recG = 0;

//       for (var v in vouchers) {
//         // التحقق من وجود عيارات متعددة
//         final carats = v["carats"] as List?;

//         if (carats != null && carats.isNotEmpty) {
//           // إذا كان السند يحتوي على عيارات متعددة
//           for (var c in carats) {
//             final weight = (c["weight"] ?? 0).toDouble();
//             final wage = (c["wage"] ?? 0).toDouble();
//             final carat = (c["carat"] ?? "").toString();
//             final weightIn24 = _convertTo24Karat(weight, carat);

//             if (v["type"] == "payment") {
//               payW += weightIn24;
//               payG += wage;
//             } else if (v["type"] == "receipt") {
//               recW += weightIn24;
//               recG += wage;
//             }
//           }
//         } else {
//           // السند العادي (عيار واحد)
//           final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
//           final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
//           final carat = (v["carat"] ?? "").toString();
//           final weightIn24 = _convertTo24Karat(weight, carat);

//           if (v["type"] == "payment") {
//             payW += weightIn24;
//             payG += wage;
//           } else if (v["type"] == "receipt") {
//             recW += weightIn24;
//             recG += wage;
//           }
//         }
//       }

//       // ✅ الرصيد = القبض - الصرف (محول إلى 24 قيراط)
//       final balanceWeight = recW - payW;
//       final balanceWage = recG - payG;

//       setState(() {
//         _balanceWeight24 = balanceWeight;
//         _balanceWage = balanceWage;
//       });
//     } catch (e) {
//       print('❌ خطأ في جلب الرصيد: $e');
//     } finally {
//       setState(() => _isLoadingBalance = false);
//     }
//   }

//   // حساب الرصيد المتبقي بعد الخصم
//   double _getRemainingBalance() {
//     return _balanceWeight24 - _calculateTotalWeight24();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("سند الصرف", "Payment Voucher")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // بطاقة المعلومات الأساسية
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     // التاريخ
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_today,
//                             color: Color(0xFFD4AF37), size: 20),
//                         const SizedBox(width: 8),
//                         Text(
//                           _t('التاريخ', 'Date'),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const Spacer(),
//                         Text(
//                           DateFormat("yyyy-MM-dd").format(date!),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, size: 18),
//                           onPressed: () async {
//                             final picked = await showDatePicker(
//                               context: context,
//                               initialDate: date!,
//                               firstDate: DateTime(2000),
//                               lastDate: DateTime(2100),
//                             );
//                             if (picked != null) {
//                               setState(() => date = picked);
//                             }
//                           },
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                     const Divider(height: 16),

//                     // اختيار المورد
//                     FutureBuilder(
//                       future: FS.getSuppliers(),
//                       builder: (context, snap) {
//                         if (!snap.hasData) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }
//                         final suppliers = snap.data!;
//                         return DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                             labelText: _t("اختر المورد", "Select Supplier"),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             prefixIcon: const Icon(Icons.business,
//                                 color: Color(0xFFD4AF37), size: 20),
//                           ),
//                           value: supplierId,
//                           items: suppliers.map((s) {
//                             return DropdownMenuItem(
//                               value: s["id"].toString(),
//                               child: Text(s["name"]),
//                             );
//                           }).toList(),
//                           onChanged: (v) {
//                             setState(() {
//                               supplierId = v;
//                               supplierName = suppliers.firstWhere(
//                                   (s) => s["id"].toString() == v)["name"];
//                               delegate = null;
//                               _balanceWeight24 = 0.0;
//                               _balanceWage = 0.0;
//                             });
//                             if (v != null) {
//                               _loadSupplierBalance(v);
//                             }
//                           },
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 12),

//                     // اختيار المندوب
//                     if (supplierId != null)
//                       FutureBuilder(
//                         future: FS.getSuppliers(),
//                         builder: (context, snap) {
//                           if (!snap.hasData) return const SizedBox();
//                           final supplier = snap.data!
//                               .firstWhere((s) => s["id"] == supplierId);
//                           final delegates =
//                               List<String>.from(supplier["delegates"] ?? []);
//                           if (delegates.isEmpty) {
//                             return Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 color: Colors.orange.shade50,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border:
//                                     Border.all(color: Colors.orange.shade200),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.warning,
//                                       color: Colors.orange.shade700, size: 18),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       _t("لا يوجد مناديب لهذا المورد",
//                                           "No delegates for this supplier"),
//                                       style: TextStyle(
//                                         color: Colors.orange.shade700,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }
//                           return DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: _t("اختر المندوب", "Select Delegate"),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               prefixIcon: const Icon(Icons.person,
//                                   color: Color(0xFFD4AF37), size: 20),
//                             ),
//                             value: delegate,
//                             items: delegates.map((d) {
//                               return DropdownMenuItem(
//                                 value: d,
//                                 child: Text(d),
//                               );
//                             }).toList(),
//                             onChanged: (v) => setState(() => delegate = v),
//                           );
//                         },
//                       ),

//                     const SizedBox(height: 12),

//                     // طريقة الدفع
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: _t("طريقة الدفع", "Payment Method"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         prefixIcon: const Icon(Icons.payment,
//                             color: Color(0xFFD4AF37), size: 20),
//                       ),
//                       value: paymentMethod,
//                       items: [
//                         _t("كاش", "Cash"),
//                         _t("شبكة", "Network"),
//                         _t("متعدد", "Mixed")
//                       ].map((m) {
//                         return DropdownMenuItem(value: m, child: Text(m));
//                       }).toList(),
//                       onChanged: (v) => setState(() => paymentMethod = v),
//                     ),

//                     // حقول المبالغ حسب طريقة الدفع
//                     if (paymentMethod == _t("كاش", "Cash") ||
//                         paymentMethod == _t("متعدد", "Mixed"))
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: TextField(
//                           controller: cashCtrl,
//                           decoration: InputDecoration(
//                             labelText: _t("💵 المبلغ كاش", "💵 Cash Amount"),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             prefixIcon: const Icon(Icons.money,
//                                 color: Color(0xFFD4AF37), size: 20),
//                           ),
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     if (paymentMethod == _t("شبكة", "Network") ||
//                         paymentMethod == _t("متعدد", "Mixed"))
//                       Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: TextField(
//                           controller: networkCtrl,
//                           decoration: InputDecoration(
//                             labelText:
//                                 _t("💳 المبلغ شبكة", "💳 Network Amount"),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 8),
//                             prefixIcon: const Icon(Icons.credit_card,
//                                 color: Color(0xFFD4AF37), size: 20),
//                           ),
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             // ===== كارت الرصيد =====
//             if (supplierId != null) ...[
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: _getRemainingBalance() > 0
//                       ? Colors.red.shade50
//                       : _getRemainingBalance() < 0
//                           ? Colors.green.shade50
//                           : _getRemainingBalance() == 0 && _balanceWeight24 != 0
//                               ? Colors.green.shade100
//                               : Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: _getRemainingBalance() > 0
//                         ? Colors.red.shade300
//                         : _getRemainingBalance() < 0
//                             ? Colors.green.shade300
//                             : _getRemainingBalance() == 0 &&
//                                     _balanceWeight24 != 0
//                                 ? Colors.green.shade400
//                                 : Colors.grey.shade300,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _t("الرصيد الحالي (24 قيراط)",
//                               "Current Balance (24K)"),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         if (_isLoadingBalance)
//                           const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                         else
//                           Text(
//                             "${_balanceWeight24.toStringAsFixed(2)} ${_t('جم', 'g')}",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: _balanceWeight24 > 0
//                                   ? Colors.red
//                                   : _balanceWeight24 < 0
//                                       ? Colors.green
//                                       : Colors.grey,
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _t("الرصيد المتبقي", "Remaining Balance"),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           "${_getRemainingBalance().toStringAsFixed(2)} ${_t('جم', 'g')}",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: _getRemainingBalance() > 0
//                                 ? Colors.red
//                                 : _getRemainingBalance() < 0
//                                     ? Colors.green
//                                     : _getRemainingBalance() == 0 &&
//                                             _balanceWeight24 != 0
//                                         ? Colors.green
//                                         : Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (_calculateTotalWeight24() > 0) ...[
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "${_t('قيد الخصم', 'Deducting')}: ${_calculateTotalWeight24().toStringAsFixed(2)} ${_t('جم (معادل 24)', 'g (equiv. 24K)')}",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.orange.shade700,
//                           ),
//                         ),
//                       ),
//                     ],
//                     if (_getRemainingBalance() < 0 &&
//                         _balanceWeight24 != 0) ...[
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           _t("⚠️ الخصم أكبر من الرصيد",
//                               "⚠️ Deduction exceeds balance"),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.red.shade700,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                     if (_getRemainingBalance() == 0 &&
//                         _balanceWeight24 != 0 &&
//                         _calculateTotalWeight24() > 0) ...[
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           _t("✅ تم تصفية الرصيد بالكامل",
//                               "✅ Balance fully settled"),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.green.shade700,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ],

//             const SizedBox(height: 8),

//             // بطاقة العيارات المتعددة
//             Expanded(
//               child: Card(
//                 elevation: 2,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.category,
//                               color: Color(0xFFD4AF37), size: 20),
//                           const SizedBox(width: 6),
//                           Text(
//                             _t("العيارات", "Carats"),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           IconButton(
//                             icon: const Icon(Icons.add_circle,
//                                 color: Color(0xFFD4AF37), size: 28),
//                             onPressed: _addNewCaratItem,
//                             tooltip: _t("إضافة عيار", "Add Carat"),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFD4AF37).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               "${_t('الإجمالي', 'Total')}: ${_calculateTotalWeight().toStringAsFixed(2)} ${_t('جم', 'g')}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                                 color: Color(0xFFD4AF37),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 12),

//                       // قائمة العيارات
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: caratItems.length,
//                           itemBuilder: (context, index) {
//                             final item = caratItems[index];
//                             return _buildCaratItem(index, item);
//                           },
//                         ),
//                       ),

//                       // إجمالي الأجور
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFD4AF37).withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               _t("إجمالي الأجور", "Total Wages"),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                             Text(
//                               "${_calculateTotalWage().toStringAsFixed(2)}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Color(0xFFD4AF37),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       // زر الحفظ
//                       SizedBox(
//                         width: double.infinity,
//                         height: 44,
//                         child: ElevatedButton.icon(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFFD4AF37),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                             ),
//                             icon: const Icon(Icons.save,
//                                 color: Colors.white, size: 20),
//                             label: Text(
//                               _t("حفظ", "Save"),
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             onPressed: () async {
//                               if (supplierId == null ||
//                                   delegate == null ||
//                                   paymentMethod == null) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(_t(
//                                         "يرجى إدخال جميع البيانات المطلوبة",
//                                         "Please fill all required fields")),
//                                     backgroundColor: Colors.orange,
//                                   ),
//                                 );
//                                 return;
//                               }

//                               final validItems = caratItems
//                                   .where((item) =>
//                                       item['carat'] != null &&
//                                       item['weight'] > 0)
//                                   .toList();

//                               if (validItems.isEmpty) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(_t(
//                                         "يرجى إدخال عيار واحد على الأقل",
//                                         "Please enter at least one carat")),
//                                     backgroundColor: Colors.orange,
//                                   ),
//                                 );
//                                 return;
//                               }

//                               // تجهيز بيانات العيارات المتعددة
//                               List<Map<String, dynamic>> caratsData = [];
//                               for (var item in validItems) {
//                                 caratsData.add({
//                                   'carat': item['carat'].toString(),
//                                   'weight': item['weight'],
//                                   'wage': item['wage'] ?? 0,
//                                 });
//                               }

//                               // حفظ السند - الدالة تقوم تلقائياً بخصم الكسر
//                               await FS.addPaymentVoucher(
//                                 supplierId: supplierId!,
//                                 supplierName: supplierName!,
//                                 delegate: delegate!,
//                                 carat: 'multiple',
//                                 weight: _calculateTotalWeight(),
//                                 wage: _calculateTotalWage(),
//                                 paymentMethod: paymentMethod!,
//                                 cash: cashCtrl.text.isEmpty
//                                     ? null
//                                     : double.parse(cashCtrl.text),
//                                 network: networkCtrl.text.isEmpty
//                                     ? null
//                                     : double.parse(networkCtrl.text),
//                                 date: date!,
//                                 carats: caratsData,
//                               );

//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(_t(
//                                       "تم حفظ السند بنجاح ✅ مع ${validItems.length} عيار وتم خصم الكسر",
//                                       "Payment voucher saved successfully ✅ with ${validItems.length} carats and scrap deducted")),
//                                   backgroundColor: Colors.green,
//                                 ),
//                               );

//                               Future.delayed(const Duration(seconds: 1), () {
//                                 Navigator.pop(context);
//                               });
//                             }
//                             // onPressed: () async {
//                             //   if (supplierId == null ||
//                             //       delegate == null ||
//                             //       paymentMethod == null) {
//                             //     ScaffoldMessenger.of(context).showSnackBar(
//                             //       SnackBar(
//                             //         content: Text(_t(
//                             //             "يرجى إدخال جميع البيانات المطلوبة",
//                             //             "Please fill all required fields")),
//                             //         backgroundColor: Colors.orange,
//                             //       ),
//                             //     );
//                             //     return;
//                             //   }

//                             //   final validItems = caratItems
//                             //       .where((item) =>
//                             //           item['carat'] != null && item['weight'] > 0)
//                             //       .toList();

//                             //   if (validItems.isEmpty) {
//                             //     ScaffoldMessenger.of(context).showSnackBar(
//                             //       SnackBar(
//                             //         content: Text(_t(
//                             //             "يرجى إدخال عيار واحد على الأقل",
//                             //             "Please enter at least one carat")),
//                             //         backgroundColor: Colors.orange,
//                             //       ),
//                             //     );
//                             //     return;
//                             //   }

//                             //   // تجهيز بيانات العيارات المتعددة
//                             //   List<Map<String, dynamic>> caratsData = [];
//                             //   for (var item in validItems) {
//                             //     caratsData.add({
//                             //       'carat': item['carat'].toString(),
//                             //       'weight': item['weight'],
//                             //       'wage': item['wage'] ?? 0,
//                             //     });
//                             //   }

//                             //   // حفظ السند مع جميع العيارات
//                             //   await FS.addPaymentVoucher(
//                             //     supplierId: supplierId!,
//                             //     supplierName: supplierName!,
//                             //     delegate: delegate!,
//                             //     carat: 'multiple',
//                             //     weight: _calculateTotalWeight(),
//                             //     wage: _calculateTotalWage(),
//                             //     paymentMethod: paymentMethod!,
//                             //     cash: cashCtrl.text.isEmpty
//                             //         ? null
//                             //         : double.parse(cashCtrl.text),
//                             //     network: networkCtrl.text.isEmpty
//                             //         ? null
//                             //         : double.parse(networkCtrl.text),
//                             //     date: date!,
//                             //     carats: caratsData,
//                             //   );

//                             //   // ✅ خصم من الكسر لكل عيار
//                             //   for (var item in validItems) {
//                             //     await FS.saveScrapPayment({
//                             //       "carat": item['carat'].toString(),
//                             //       "weight": item['weight'],
//                             //       "wage": item['wage'] ?? 0,
//                             //       "person": supplierName!,
//                             //       "paymentType": paymentMethod!,
//                             //       "cash": cashCtrl.text.isEmpty
//                             //           ? 0
//                             //           : double.parse(cashCtrl.text),
//                             //       "network": networkCtrl.text.isEmpty
//                             //           ? 0
//                             //           : double.parse(networkCtrl.text),
//                             //       "total": (cashCtrl.text.isEmpty
//                             //               ? 0
//                             //               : double.parse(cashCtrl.text)) +
//                             //           (networkCtrl.text.isEmpty
//                             //               ? 0
//                             //               : double.parse(networkCtrl.text)),
//                             //       "date": date!,
//                             //       "notes": "سند صرف للمورد ${supplierName!}",
//                             //       "type": "payment",
//                             //       "createdAt": FieldValue.serverTimestamp(),
//                             //     });
//                             //   }

//                             //   ScaffoldMessenger.of(context).showSnackBar(
//                             //     SnackBar(
//                             //       content: Text(_t(
//                             //           "تم حفظ السند بنجاح ✅ مع ${validItems.length} عيار وتم خصم الكسر",
//                             //           "Payment voucher saved successfully ✅ with ${validItems.length} carats and scrap deducted")),
//                             //       backgroundColor: Colors.green,
//                             //     ),
//                             //   );

//                             //   Future.delayed(const Duration(seconds: 1), () {
//                             //     Navigator.pop(context);
//                             //   });
//                             // },
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCaratItem(int index, Map<String, dynamic> item) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           // العيار - أصغر
//           Expanded(
//             flex: 3,
//             child: DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 labelText: _t("العيار", "Carat"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               value: item['carat']?.toString(),
//               items: ["18", "21", "22"].map((c) {
//                 return DropdownMenuItem(
//                   value: c,
//                   child: Text(c),
//                 );
//               }).toList(),
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['carat'] = v;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 6),
//           // الوزن - أكبر
//           Expanded(
//             flex: 4,
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: _t("الوزن", "Weight"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 suffixText: _t("جم", "g"),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['weight'] = double.tryParse(v) ?? 0;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 6),
//           // الأجر - متوسط
//           Expanded(
//             flex: 3,
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: _t("الأجر", "Wage"),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 isDense: true,
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (v) {
//                 setState(() {
//                   caratItems[index]['wage'] = double.tryParse(v) ?? 0;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(width: 4),
//           // زر الحذف
//           IconButton(
//             icon: const Icon(Icons.remove_circle, color: Colors.red, size: 22),
//             onPressed:
//                 caratItems.length > 1 ? () => _removeCaratItem(index) : null,
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             tooltip: _t("حذف العيار", "Remove Carat"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:uhf_gold_shop/pages/RemainingKitsPage.dart';
import 'package:uhf_gold_shop/pages/taskirat.dart';
import '../services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'expenses_page.dart';
import 'TransformPage.dart';
import 'cash_box_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'branches_page.dart';
import 'EditPage.dart';
import 'external_transactions_page.dart';
import 'ExitPermissionPage.dart';
import 'settings_page.dart';
import 'settings_page.dart' show checkPassword;
import 'ReturnsPage.dart';
import 'preview_page.dart';
import 'DeletedItemsPage.dart';

class DailyTransactionsPage extends StatefulWidget {
  const DailyTransactionsPage({super.key});

  @override
  State<DailyTransactionsPage> createState() => _DailyTransactionsPageState();
}

class _DailyTransactionsPageState extends State<DailyTransactionsPage> {
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

  void _openPage(BuildContext context, Widget page) async {
    String? pageKey;

    if (page is PartPage) {
      pageKey = 'Suppliers';
    } else if (page is Part1Page)
      pageKey = 'Vouchers';
    else if (page is Part2Page)
      pageKey = 'Funds';
    else if (page is TransformPage)
      pageKey = 'Transfers';
    else if (page is EditPage)
      pageKey = 'edit';
    else if (page is BranchesPage)
      pageKey = 'branches';
    else if (page is ExternalTransactionsPage)
      pageKey = 'Transactions';
    else if (page is ExitPermissionPage) pageKey = 'Statements';

    if (pageKey != null) {
      final allowed = await checkPassword(context, pageKey);
      if (!allowed) return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الحركة اليومية", "Daily Transactions")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.people,
                    label: _t("الموردين", "Suppliers"),
                    page: const PartPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.account_balance,
                    label: _t("التسكيرات", "Minting"),
                    page: const MintingPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.receipt_long,
                    label: _t("سندات", "Vouchers"),
                    page: const Part1Page(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.monetization_on,
                    label: _t("الأموال", "Funds"),
                    page: const Part2Page(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.mail_rounded,
                    label: _t("التحويل", "Transfers"),
                    page: const TransformPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.edit_outlined,
                    label: _t("التعديل", "edit"),
                    page: const EditPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.location_city,
                    label: _t("الافرع", "branches"),
                    page: const BranchesPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.outbond_outlined,
                    label: _t("التعاملات", "Transactions"),
                    page: const ExternalTransactionsPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.safety_check,
                    label: _t("التصريحات", "Statements"),
                    page: const ExitPermissionPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.delete,
                    label: _t("المحذوفات", "Deletes"),
                    page: const DeletedItemsPage(),
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.keyboard_return_outlined,
                    label: _t("المرتجعات", "Returns"),
                    page: const ReturnsPage(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon, required String label, required Widget page}) {
    return GestureDetector(
      onTap: () => _openPage(context, page),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: const Color(0xFFD4AF37).withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
// 🔹 PartPage - صفحة الموردين الرئيسية
// ============================================================
class PartPage extends StatefulWidget {
  const PartPage({super.key});

  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الموردين", "Suppliers")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: const SuppliersPage(),
    );
  }
}

// ============================================================
// 🔹 SuppliersPage - صفحة الموردين الموحدة (معدلة)
// ============================================================
class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final delegateCtrl = TextEditingController();
  List<String> delegates = [];
  bool isAdding = false;

  bool isEditing = false;
  String? editingSupplierId;

  // دالة تحويل الوزن إلى 24 قيراط
  double _convertTo24Karat(double weight, String carat) {
    switch (carat) {
      case '18':
        return weight * (18 / 24);
      case '21':
        return weight * (21 / 24);
      case '22':
        return weight * (22 / 24);
      default:
        return weight;
    }
  }

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

  Future<void> _addSupplier() async {
    if (nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t("ادخل اسم المورد", "Enter supplier name"))),
      );
      return;
    }

    setState(() => isAdding = true);

    try {
      await FS.addSupplier(
        name: nameCtrl.text.trim(),
        delegates: delegates,
        phone: phoneCtrl.text.trim(),
      );

      nameCtrl.clear();
      phoneCtrl.clear();
      delegateCtrl.clear();
      setState(() => delegates.clear());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _t("تم إضافة المورد بنجاح ✅", "Supplier added successfully ✅")),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_t("حدث خطأ", "Error")}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isAdding = false);
    }
  }

  void _addDelegate() {
    if (delegateCtrl.text.trim().isNotEmpty) {
      setState(() {
        delegates.add(delegateCtrl.text.trim());
        delegateCtrl.clear();
      });
    }
  }

  void _removeDelegate(String name) {
    setState(() => delegates.remove(name));
  }

  // ============================================================
  // 🔹 حساب رصيد المورد (مع دعم العيارات المتعددة)
  // ============================================================
  Future<Map<String, dynamic>> _supplierSummary(String supplierId) async {
    final vouchers = await FS.getVouchersForSupplier(supplierId);

    double payW = 0, recW = 0;
    double payG = 0, recG = 0;

    for (var v in vouchers) {
      // التحقق من وجود عيارات متعددة
      final carats = v["carats"] as List?;

      if (carats != null && carats.isNotEmpty) {
        // إذا كان السند يحتوي على عيارات متعددة
        for (var c in carats) {
          final weight = (c["weight"] ?? 0).toDouble();
          final wage = (c["wage"] ?? 0).toDouble();
          final carat = (c["carat"] ?? "").toString();
          final weightIn24 = _convertTo24Karat(weight, carat);

          if (v["type"] == "payment") {
            payW += weightIn24;
            payG += wage;
          } else if (v["type"] == "receipt") {
            recW += weightIn24;
            recG += wage;
          }
        }
      } else {
        // السند العادي (عيار واحد)
        final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
        final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
        final carat = (v["carat"] ?? "").toString();
        final weightIn24 = _convertTo24Karat(weight, carat);

        if (v["type"] == "payment") {
          payW += weightIn24;
          payG += wage;
        } else if (v["type"] == "receipt") {
          recW += weightIn24;
          recG += wage;
        }
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

  void _showAddDialog() {
    nameCtrl.clear();
    phoneCtrl.clear();
    delegateCtrl.clear();
    setState(() => delegates.clear());
    isEditing = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _buildSupplierDialog(
        title: _t("إضافة مورد جديد", "Add New Supplier"),
        isEditing: false,
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> supplier) {
    nameCtrl.text = supplier["name"] ?? "";
    phoneCtrl.text = supplier["phone"] ?? "";
    setState(() {
      delegates = List<String>.from(supplier["delegates"] ?? []);
      isEditing = true;
      editingSupplierId = supplier["id"];
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _buildSupplierDialog(
        title: _t("تعديل المورد", "Edit Supplier"),
        isEditing: true,
        supplierId: supplier["id"],
      ),
    );
  }

  Widget _buildSupplierDialog({
    required String title,
    required bool isEditing,
    String? supplierId,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(
            isEditing ? Icons.edit : Icons.person_add,
            color: const Color(0xFFD4AF37),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: StatefulBuilder(
        builder: (context, setStateDialog) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: _t("اسم المورد", "Supplier Name"),
                    prefixIcon:
                        const Icon(Icons.business, color: Color(0xFFD4AF37)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                    labelText: _t("رقم الجوال", "Phone"),
                    prefixIcon:
                        const Icon(Icons.phone, color: Color(0xFFD4AF37)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: delegateCtrl,
                        decoration: InputDecoration(
                          labelText: _t("مندوب", "Delegate"),
                          prefixIcon: const Icon(Icons.person,
                              color: Color(0xFFD4AF37)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        onSubmitted: (_) => _addDelegateDialog(setStateDialog),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _addDelegateDialog(setStateDialog),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                      ),
                    ),
                  ],
                ),
                if (delegates.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: delegates
                          .map((d) => Chip(
                                label: Text(d,
                                    style: const TextStyle(fontSize: 13)),
                                backgroundColor: Colors.white,
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () =>
                                    _removeDelegateDialog(d, setStateDialog),
                                side: BorderSide(color: Colors.grey.shade300),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            _t("إلغاء", "Cancel"),
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            if (nameCtrl.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_t("ادخل اسم المورد", "Enter supplier name")),
                ),
              );
              return;
            }

            if (isEditing && supplierId != null) {
              await FS.updateSupplier(
                supplierId,
                {
                  "name": nameCtrl.text.trim(),
                  "phone": phoneCtrl.text.trim(),
                  "delegates": delegates,
                },
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_t("تم التعديل ✅", "Updated ✅")),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              await FS.addSupplier(
                name: nameCtrl.text.trim(),
                delegates: delegates,
                phone: phoneCtrl.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_t("تم الإضافة ✅", "Added ✅")),
                  backgroundColor: Colors.green,
                ),
              );
            }

            nameCtrl.clear();
            phoneCtrl.clear();
            delegateCtrl.clear();
            setState(() => delegates.clear());
            Navigator.pop(context);
          },
          child: Text(
            isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _addDelegateDialog(StateSetter setStateDialog) {
    if (delegateCtrl.text.trim().isNotEmpty) {
      setStateDialog(() {
        delegates.add(delegateCtrl.text.trim());
        delegateCtrl.clear();
      });
    }
  }

  void _removeDelegateDialog(String name, StateSetter setStateDialog) {
    setStateDialog(() => delegates.remove(name));
  }

  Future<void> _deleteSupplier(Map<String, dynamic> supplier) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
        content:
            Text(_t("حذف ${supplier["name"]}؟", "Delete ${supplier["name"]}?")),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t("حذف", "Delete"),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FS.deleteSupplier(supplier["id"]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t("تم الحذف ✅", "Deleted ✅")),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ======================
  // 🔹 عرض تفاصيل المورد
  // ======================
  void _showSupplierDetails(String supplierId) async {
    final vouchers = await FS.getVouchersForSupplier(supplierId);

    // ✅ ترتيب السندات من الأحدث إلى الأقدم
    vouchers.sort((a, b) {
      final dateA = a["date"] as Timestamp?;
      final dateB = b["date"] as Timestamp?;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateB.toDate().compareTo(dateA.toDate());
    });

    final receiptVouchers =
        vouchers.where((v) => v["type"] == "receipt").toList();
    final paymentVouchers =
        vouchers.where((v) => v["type"] == "payment").toList();

    // ✅ حساب تفاصيل العيارات مع دعم العيارات المتعددة
    Map<String, Map<String, double>> _calculateSummary(
        List<Map<String, dynamic>> voucherList) {
      final Map<String, double> weightMap = {"18": 0, "21": 0, "22": 0};
      final Map<String, double> wageMap = {"18": 0, "21": 0, "22": 0};
      final Map<String, double> weight24Map = {"18": 0, "21": 0, "22": 0};

      for (var v in voucherList) {
        // التحقق من وجود عيارات متعددة
        final carats = v["carats"] as List?;

        if (carats != null && carats.isNotEmpty) {
          // إذا كان السند يحتوي على عيارات متعددة
          for (var c in carats) {
            final carat = (c["carat"] ?? "").toString();
            final weight = (c["weight"] ?? 0).toDouble();
            final wage = (c["wage"] ?? 0).toDouble();

            if (["18", "21", "22"].contains(carat)) {
              weightMap[carat] = (weightMap[carat] ?? 0) + weight;
              wageMap[carat] = (wageMap[carat] ?? 0) + wage;
              weight24Map[carat] =
                  (weight24Map[carat] ?? 0) + _convertTo24Karat(weight, carat);
            }
          }
        } else {
          // السند العادي (عيار واحد)
          final carat = (v["carat"] ?? "").toString();
          final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
          final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;

          if (["18", "21", "22"].contains(carat)) {
            weightMap[carat] = (weightMap[carat] ?? 0) + weight;
            wageMap[carat] = (wageMap[carat] ?? 0) + wage;
            weight24Map[carat] =
                (weight24Map[carat] ?? 0) + _convertTo24Karat(weight, carat);
          }
        }
      }
      return {"weight": weightMap, "wage": wageMap, "weight24": weight24Map};
    }

    final receiptSummary = _calculateSummary(receiptVouchers);
    final paymentSummary = _calculateSummary(paymentVouchers);

    final totalReceiptWeight24 =
        receiptSummary["weight24"]!.values.fold(0.0, (a, b) => a + b);
    final totalReceiptWage =
        receiptSummary["wage"]!.values.fold(0.0, (a, b) => a + b);
    final totalPaymentWeight24 =
        paymentSummary["weight24"]!.values.fold(0.0, (a, b) => a + b);
    final totalPaymentWage =
        paymentSummary["wage"]!.values.fold(0.0, (a, b) => a + b);

    final balanceWeight24 = totalReceiptWeight24 - totalPaymentWeight24;
    final balanceWage = totalReceiptWage - totalPaymentWage;
    final allCleared =
        balanceWeight24.abs() < 0.0001 && balanceWage.abs() < 0.0001;

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return DefaultTabController(
            length: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              const Color(0xFFD4AF37).withOpacity(0.15),
                          child: const Icon(Icons.person,
                              color: Color(0xFFD4AF37), size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vouchers.isNotEmpty
                                    ? (vouchers.first["supplierName"] ?? "")
                                    : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${vouchers.length} ${_t("عملية", "transactions")}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey.shade600),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== كارت الرصيد الإجمالي =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: allCleared
                            ? Colors.green.shade50
                            : balanceWeight24 > 0
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: allCleared
                              ? Colors.green.shade200
                              : balanceWeight24 > 0
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: allCleared
                                  ? Colors.green
                                  : balanceWeight24 > 0
                                      ? Colors.red
                                      : Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              allCleared
                                  ? Icons.check_rounded
                                  : balanceWeight24 > 0
                                      ? Icons.north_east_rounded
                                      : Icons.south_west_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  allCleared
                                      ? _t("✅ الحساب مُصفّى بالكامل",
                                          "✅ Fully settled")
                                      : balanceWeight24 > 0
                                          ? _t("📤 رصيد للمورد (24 قيراط)",
                                              "📤 Balance owed to supplier (equiv. 24K)")
                                          : _t("📥 رصيد على المورد (24 قيراط)",
                                              "📥 Supplier owes us (equiv. 24K)"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: allCleared
                                        ? Colors.green.shade800
                                        : balanceWeight24 > 0
                                            ? Colors.red.shade800
                                            : Colors.green.shade800,
                                  ),
                                ),
                                if (!allCleared) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 4,
                                    children: [
                                      _summaryValue(
                                        icon: Icons.scale_outlined,
                                        label: _t("الوزن", "Weight"),
                                        value:
                                            "${balanceWeight24.abs().toStringAsFixed(2)} جم",
                                      ),
                                      _summaryValue(
                                        icon: Icons.payments_outlined,
                                        label: _t("الأجر", "Wage"),
                                        value: balanceWage
                                            .abs()
                                            .toStringAsFixed(2),
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

                  const SizedBox(height: 12),
                  const Divider(height: 1),

                  Container(
                    color: Colors.white,
                    child: TabBar(
                      indicatorColor: const Color(0xFFD4AF37),
                      indicatorWeight: 3,
                      labelColor: const Color(0xFFD4AF37),
                      unselectedLabelColor: Colors.grey.shade600,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      tabs: [
                        Tab(text: _t("📥 قبض", "📥 Receipt")),
                        Tab(text: _t("📤 صرف", "📤 Payment")),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildTabContent(
                          context,
                          scrollController,
                          voucherList: receiptVouchers,
                          summaryMap: receiptSummary,
                          type: 'receipt',
                        ),
                        _buildTabContent(
                          context,
                          scrollController,
                          voucherList: paymentVouchers,
                          summaryMap: paymentSummary,
                          type: 'payment',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================
  // 🔹 دالة مساعدة لبناء محتوى كل تبويب
  // ==========================================
  Widget _buildTabContent(
    BuildContext context,
    ScrollController scrollController, {
    required List<Map<String, dynamic>> voucherList,
    required Map<String, Map<String, double>> summaryMap,
    required String type,
  }) {
    final isReceipt = type == 'receipt';
    final color = isReceipt ? Colors.green : Colors.red;
    final title = isReceipt
        ? _t("تفاصيل القبض", "Receipt Details")
        : _t("تفاصيل الصرف", "Payment Details");

    final weightMap = summaryMap["weight"]!;
    final wageMap = summaryMap["wage"]!;
    final weight24Map = summaryMap["weight24"]!;

    final caratsWithBalance = ["18", "21", "22"].where((c) {
      return weightMap[c]!.abs() > 0.0001 || wageMap[c]!.abs() > 0.0001;
    }).toList();

    final totalWeight = weightMap.values.fold(0.0, (a, b) => a + b);
    final totalWage = wageMap.values.fold(0.0, (a, b) => a + b);
    final allCleared = caratsWithBalance.isEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: ListView(
        controller: scrollController,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  allCleared ? Colors.grey.shade100 : color.withOpacity(0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    allCleared ? Colors.grey.shade300 : color.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: allCleared ? Colors.grey : color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    allCleared
                        ? Icons.check_rounded
                        : isReceipt
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allCleared
                            ? _t("لا توجد معاملات", "No transactions")
                            : title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: allCleared ? Colors.grey.shade600 : color,
                        ),
                      ),
                      if (!allCleared) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            _summaryValue(
                              icon: Icons.scale_outlined,
                              label: _t("الوزن", "Weight"),
                              value:
                                  "${totalWeight.abs().toStringAsFixed(2)} جم",
                            ),
                            _summaryValue(
                              icon: Icons.payments_outlined,
                              label: _t("الأجر", "Wage"),
                              value: totalWage.abs().toStringAsFixed(2),
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
          if (!allCleared) ...[
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: color,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _t("تفاصيل العيارات", "Carat Breakdown"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: caratsWithBalance.length,
                itemBuilder: (context, index) {
                  final carat = caratsWithBalance[index];
                  final weight = weightMap[carat]!;
                  final wage = wageMap[carat]!;
                  final weight24 = weight24Map[carat]!;
                  final isZero = weight.abs() < 0.0001 && wage.abs() < 0.0001;

                  Color cardColor;
                  if (isZero) {
                    cardColor = Colors.grey;
                  } else {
                    cardColor = isReceipt ? Colors.green : Colors.red;
                  }

                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: cardColor.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _t("عيار $carat", "K$carat"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if (!isZero) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.scale_outlined,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "${weight.abs().toStringAsFixed(2)} جم",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: cardColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.payments_outlined,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "${wage.abs().toStringAsFixed(2)} ${_t("أجر", "wage")}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cardColor.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Text(
                            _t("مصفى", "Cleared"),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(
                isReceipt ? Icons.south_west_rounded : Icons.north_east_rounded,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isReceipt
                    ? _t("سندات القبض", "Receipt Vouchers")
                    : _t("سندات الصرف", "Payment Vouchers"),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${voucherList.length}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (voucherList.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  _t("لا توجد سندات", "No vouchers"),
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            )
          else
            ...voucherList.map((v) {
              final carat = (v["carat"] ?? "").toString();
              final weight =
                  double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
              final weight24 = _convertTo24Karat(weight, carat);

              // التحقق من وجود عيارات متعددة
              final carats = v["carats"] as List?;
              final hasMultipleCarats = carats != null && carats.isNotEmpty;

              // حساب الوزن الإجمالي للعيارات المتعددة
              double totalCaratsWeight = 0;
              double totalCaratsWage = 0;

              // بناء قائمة Widgets للعيارات
              List<Widget> caratWidgets = [];
              if (hasMultipleCarats) {
                for (var c in carats!) {
                  totalCaratsWeight += (c['weight'] ?? 0).toDouble();
                  totalCaratsWage += (c['wage'] ?? 0).toDouble();
                  caratWidgets.add(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${_t('عيار', 'Carat')}: ${c['carat']} | ${_t('وزن', 'Weight')}: ${(c['weight'] ?? 0).toStringAsFixed(2)} ${_t('جم', 'g')} | ${_t('أجر', 'Wage')}: ${(c['wage'] ?? 0).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
                // إضافة إجمالي الوزن والأجر
                caratWidgets.add(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${_t('إجمالي الوزن', 'Total Weight')}: ${totalCaratsWeight.toStringAsFixed(2)} ${_t('جم', 'g')} | ${_t('إجمالي الأجر', 'Total Wage')}: ${totalCaratsWage.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isReceipt
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: Icon(
                            isReceipt
                                ? Icons.south_west_rounded
                                : Icons.north_east_rounded,
                            color: isReceipt ? Colors.green : Colors.red,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isReceipt
                                        ? _t("سند قبض", "Receipt")
                                        : _t("سند صرف", "Payment"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (v["date"] != null)
                                    Text(
                                      DateFormat("dd/MM/yyyy HH:mm").format(
                                        (v["date"] as Timestamp).toDate(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // عرض المندوب
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${_t('مندوب', 'Delegate')}: ${v["delegate"]?.toString() ?? "-"}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // عرض العيارات
                              if (hasMultipleCarats) ...[
                                ...caratWidgets,
                              ] else ...[
                                Row(
                                  children: [
                                    _voucherChip(_t("عيار", "Carat"), carat),
                                    const SizedBox(width: 4),
                                    _voucherChip(_t("وزن", "Weight"),
                                        "${weight.toStringAsFixed(2)} جم"),
                                    const SizedBox(width: 4),
                                    _voucherChip(
                                        _t("أجر", "Wage"), "${v["wage"] ?? 0}"),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _summaryValue({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade700),
        const SizedBox(width: 4),
        Text(
          "$label: $value",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _voucherChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ======================
  // 🔹 BUILD
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            _t("🔍 بحث عن مورد...", "🔍 Search supplier..."),
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      onChanged: (value) {
                        // يمكن إضافة منطق البحث هنا
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _t(" الموردين", "Suppliers"),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: FS.suppliersStream(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final suppliers = snap.data!;

                if (suppliers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _t("لا يوجد موردين", "No suppliers"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _t("اضغط على زر + لإضافة مورد",
                              "Tap + to add a supplier"),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: suppliers.length,
                  itemBuilder: (_, i) {
                    final s = suppliers[i];
                    return _buildSupplierCard(s);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ======================
  // 🔹 بطاقة المورد
  // ======================
  Widget _buildSupplierCard(Map<String, dynamic> supplier) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _supplierSummary(supplier["id"]),
        builder: (context, snap) {
          final isCleared = snap.hasData ? snap.data!["cleared"] : false;
          final balanceWeight = snap.hasData ? snap.data!["weight"] : 0.0;
          final balanceWage = snap.hasData ? snap.data!["wage"] : 0.0;

          Color statusColor;
          String statusText;
          IconData statusIcon;

          if (isCleared) {
            statusColor = Colors.green;
            statusText = _t("مصفى", "Cleared");
            statusIcon = Icons.check_circle;
          } else if (balanceWeight > 0) {
            statusColor = Colors.red;
            statusText = _t("له", "Owed");
            statusIcon = Icons.arrow_upward;
          } else {
            statusColor = Colors.green;
            statusText = _t("عليه", "Owes");
            statusIcon = Icons.arrow_downward;
          }

          return InkWell(
            onTap: () => _showSupplierDetails(supplier["id"]),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
                    child: const Icon(Icons.person,
                        color: Color(0xFFD4AF37), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        if (supplier["phone"] != null &&
                            supplier["phone"].toString().isNotEmpty)
                          Text(
                            "📞 ${supplier["phone"]}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        if (supplier["delegates"] != null &&
                            supplier["delegates"].isNotEmpty)
                          Text(
                            "👤 ${supplier["delegates"].join(", ")}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, color: statusColor, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              if (!isCleared) ...[
                                const SizedBox(width: 6),
                                Text(
                                  "${balanceWeight.abs().toStringAsFixed(1)} جم",
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    onSelected: (value) {
                      if (value == 'edit') _showEditDialog(supplier);
                      if (value == 'delete') _deleteSupplier(supplier);
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit,
                                color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(_t("تعديل", "Edit")),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(_t("حذف", "Delete")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// 🔹 Part1Page - صفحة السندات
// ============================================================
class Part1Page extends StatefulWidget {
  const Part1Page({super.key});

  @override
  State<Part1Page> createState() => _Part1PageState();
}

class _Part1PageState extends State<Part1Page> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("السندات", "Vouchers")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.receipt_long,
                      label: _t("سند قبض", "Receipt Voucher"),
                      page: const ReceiptVoucherPage(),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.payments,
                      label: _t("سند صرف", "Payment Voucher"),
                      page: const PaymentVoucherPage(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: const Color(0xFFD4AF37).withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
// 🔹 Part2Page - صفحة الأموال
// ============================================================
class Part2Page extends StatefulWidget {
  const Part2Page({super.key});

  @override
  State<Part2Page> createState() => _Part2PageState();
}

class _Part2PageState extends State<Part2Page> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الأموال", "Funds")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.account_balance_wallet,
                      label: _t("الصندوق", "Cash Box"),
                      page: const CashBoxPage(),
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.monetization_on,
                      label: _t("المصروفات", "Expenses"),
                      page: const ExpensesPage(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: const Color(0xFFD4AF37).withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
// 🔹 صفحة سند القبض (متعددة العيارات مع عرض الرصيد + Scroll)
// ============================================================
class ReceiptVoucherPage extends StatefulWidget {
  const ReceiptVoucherPage({super.key});

  @override
  State<ReceiptVoucherPage> createState() => _ReceiptVoucherPageState();
}

class _ReceiptVoucherPageState extends State<ReceiptVoucherPage> {
  DateTime? date = DateTime.now();
  String? supplierName;
  String? supplierId;
  String? delegate;

  List<Map<String, dynamic>> caratItems = [];

  // متغيرات الرصيد
  double _balanceWeight24 = 0.0;
  double _balanceWage = 0.0;
  bool _isLoadingBalance = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _addNewCaratItem();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  void _addNewCaratItem() {
    setState(() {
      caratItems.add({
        'carat': null,
        'weight': 0.0,
        'wage': 0.0,
      });
    });
  }

  void _removeCaratItem(int index) {
    setState(() {
      caratItems.removeAt(index);
    });
  }

  // دالة تحويل الوزن إلى 24 قيراط
  double _convertTo24Karat(double weight, String carat) {
    switch (carat) {
      case '18':
        return weight * (18 / 24);
      case '21':
        return weight * (21 / 24);
      case '22':
        return weight * (22 / 24);
      default:
        return weight;
    }
  }

  double _calculateTotalWeight() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['weight'] > 0) {
        total += item['weight'];
      }
    }
    return total;
  }

  double _calculateTotalWeight24() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['weight'] > 0) {
        total += _convertTo24Karat(item['weight'], item['carat'].toString());
      }
    }
    return total;
  }

  double _calculateTotalWage() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['wage'] > 0) {
        total += item['wage'];
      }
    }
    return total;
  }

  // ✅ جلب رصيد المورد محول إلى 24 قيراط (مصحح)
  Future<void> _loadSupplierBalance(String supplierId) async {
    setState(() => _isLoadingBalance = true);
    try {
      final vouchers = await FS.getVouchersForSupplier(supplierId);

      double payW = 0, recW = 0;
      double payG = 0, recG = 0;

      for (var v in vouchers) {
        // التحقق من وجود عيارات متعددة
        final carats = v["carats"] as List?;

        if (carats != null && carats.isNotEmpty) {
          // إذا كان السند يحتوي على عيارات متعددة
          for (var c in carats) {
            final weight = (c["weight"] ?? 0).toDouble();
            final wage = (c["wage"] ?? 0).toDouble();
            final carat = (c["carat"] ?? "").toString();
            final weightIn24 = _convertTo24Karat(weight, carat);

            if (v["type"] == "payment") {
              payW += weightIn24;
              payG += wage;
            } else if (v["type"] == "receipt") {
              recW += weightIn24;
              recG += wage;
            }
          }
        } else {
          // السند العادي (عيار واحد)
          final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
          final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
          final carat = (v["carat"] ?? "").toString();
          final weightIn24 = _convertTo24Karat(weight, carat);

          if (v["type"] == "payment") {
            payW += weightIn24;
            payG += wage;
          } else if (v["type"] == "receipt") {
            recW += weightIn24;
            recG += wage;
          }
        }
      }

      // ✅ الرصيد = القبض - الصرف (محول إلى 24 قيراط)
      final balanceWeight = recW - payW;
      final balanceWage = recG - payG;

      setState(() {
        _balanceWeight24 = balanceWeight;
        _balanceWage = balanceWage;
      });
    } catch (e) {
      print('❌ خطأ في جلب الرصيد: $e');
    } finally {
      setState(() => _isLoadingBalance = false);
    }
  }

  // حساب الرصيد المتبقي بعد الإضافة
  double _getNewBalance() {
    return _balanceWeight24 + _calculateTotalWeight24();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("سند القبض", "Receipt Voucher")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // بطاقة المعلومات الأساسية
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // التاريخ
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _t('التاريخ', 'Date'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat("yyyy-MM-dd").format(date!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date!,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => date = picked);
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    // اختيار المورد
                    FutureBuilder(
                      future: FS.getSuppliers(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final suppliers = snap.data!;
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: _t("اختر المورد", "Select Supplier"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            prefixIcon: const Icon(Icons.business,
                                color: Color(0xFFD4AF37), size: 20),
                          ),
                          value: supplierId,
                          items: suppliers.map((s) {
                            return DropdownMenuItem(
                              value: s["id"].toString(),
                              child: Text(s["name"]),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              supplierId = v;
                              supplierName = suppliers.firstWhere(
                                  (s) => s["id"].toString() == v)["name"];
                              delegate = null;
                              _balanceWeight24 = 0.0;
                              _balanceWage = 0.0;
                            });
                            if (v != null) {
                              _loadSupplierBalance(v);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // اختيار المندوب
                    if (supplierId != null)
                      FutureBuilder(
                        future: FS.getSuppliers(),
                        builder: (context, snap) {
                          if (!snap.hasData) return const SizedBox();
                          final supplier = snap.data!
                              .firstWhere((s) => s["id"] == supplierId);
                          final delegates =
                              List<String>.from(supplier["delegates"] ?? []);
                          if (delegates.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning,
                                      color: Colors.orange.shade700, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _t("لا يوجد مناديب لهذا المورد",
                                          "No delegates for this supplier"),
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: _t("اختر المندوب", "Select Delegate"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFFD4AF37), size: 20),
                            ),
                            value: delegate,
                            items: delegates.map((d) {
                              return DropdownMenuItem(
                                value: d,
                                child: Text(d),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => delegate = v),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // بطاقة العيارات المتعددة
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.category,
                            color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _t("العيارات", "Carats"),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Color(0xFFD4AF37), size: 28),
                          onPressed: _addNewCaratItem,
                          tooltip: _t("إضافة عيار", "Add Carat"),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${_t('الإجمالي', 'Total')}: ${_calculateTotalWeight().toStringAsFixed(2)} ${_t('جم', 'g')}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),

                    // قائمة العيارات (Column بدل ListView للسماح بالسكرول الكلي)
                    Column(
                      children: caratItems
                          .asMap()
                          .entries
                          .map((e) => _buildCaratItem(e.key, e.value))
                          .toList(),
                    ),

                    const SizedBox(height: 4),

                    // إجمالي الأجور
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _t("إجمالي الأجور", "Total Wages"),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${_calculateTotalWage().toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // زر الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.save,
                            color: Colors.white, size: 20),
                        label: Text(
                          _t("حفظ", "Save"),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (supplierId == null || delegate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_t("يرجى اختيار المورد والمندوب",
                                    "Please select supplier and delegate")),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          final validItems = caratItems
                              .where((item) =>
                                  item['carat'] != null && item['weight'] > 0)
                              .toList();

                          if (validItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_t(
                                    "يرجى إدخال عيار واحد على الأقل",
                                    "Please enter at least one carat")),
                                backgroundColor: Colors.orange,
                              ),
                            );
                            return;
                          }

                          // تجهيز بيانات العيارات المتعددة
                          List<Map<String, dynamic>> caratsData = [];
                          for (var item in validItems) {
                            caratsData.add({
                              'carat': item['carat'].toString(),
                              'weight': item['weight'],
                              'wage': item['wage'] ?? 0,
                            });
                          }

                          // حفظ السند مع جميع العيارات
                          await FS.addReceiptVoucher(
                            supplierId: supplierId!,
                            supplierName: supplierName!,
                            delegate: delegate!,
                            carat: 'multiple',
                            weight: _calculateTotalWeight(),
                            wage: _calculateTotalWage(),
                            date: date!,
                            carats: caratsData,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_t(
                                  "تم حفظ السند بنجاح ✅ مع ${validItems.length} عيار",
                                  "Receipt voucher saved successfully ✅ with ${validItems.length} carats")),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaratItem(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // العيار - أصغر
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: _t("العيار", "Carat"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              value: item['carat']?.toString(),
              items: ["18", "21", "22"].map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  caratItems[index]['carat'] = v;
                });
              },
            ),
          ),
          const SizedBox(width: 6),
          // الوزن - أكبر
          Expanded(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                labelText: _t("الوزن", "Weight"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: _t("جم", "g"),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                setState(() {
                  caratItems[index]['weight'] = double.tryParse(v) ?? 0;
                });
              },
            ),
          ),
          const SizedBox(width: 6),
          // الأجر - متوسط
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: _t("الأجر", "Wage"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                setState(() {
                  caratItems[index]['wage'] = double.tryParse(v) ?? 0;
                });
              },
            ),
          ),
          const SizedBox(width: 4),
          // زر الحذف
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red, size: 22),
            onPressed:
                caratItems.length > 1 ? () => _removeCaratItem(index) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: _t("حذف العيار", "Remove Carat"),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 🔹 صفحة سند الصرف (متعددة العيارات مع عرض الرصيد + Scroll)
// ============================================================
class PaymentVoucherPage extends StatefulWidget {
  const PaymentVoucherPage({super.key});

  @override
  State<PaymentVoucherPage> createState() => _PaymentVoucherPageState();
}

class _PaymentVoucherPageState extends State<PaymentVoucherPage> {
  DateTime? date = DateTime.now();
  String? supplierName;
  String? supplierId;
  String? delegate;
  String? paymentMethod;

  List<Map<String, dynamic>> caratItems = [];

  final cashCtrl = TextEditingController();
  final networkCtrl = TextEditingController();

  // متغيرات الرصيد
  double _balanceWeight24 = 0.0;
  double _balanceWage = 0.0;
  bool _isLoadingBalance = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _addNewCaratItem();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  void _addNewCaratItem() {
    setState(() {
      caratItems.add({
        'carat': null,
        'weight': 0.0,
        'wage': 0.0,
      });
    });
  }

  void _removeCaratItem(int index) {
    setState(() {
      caratItems.removeAt(index);
    });
  }

  // دالة تحويل الوزن إلى 24 قيراط
  double _convertTo24Karat(double weight, String carat) {
    switch (carat) {
      case '18':
        return weight * (18 / 24);
      case '21':
        return weight * (21 / 24);
      case '22':
        return weight * (22 / 24);
      default:
        return weight;
    }
  }

  double _calculateTotalWeight() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['weight'] > 0) {
        total += item['weight'];
      }
    }
    return total;
  }

  double _calculateTotalWeight24() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['weight'] > 0) {
        total += _convertTo24Karat(item['weight'], item['carat'].toString());
      }
    }
    return total;
  }

  double _calculateTotalWage() {
    double total = 0;
    for (var item in caratItems) {
      if (item['carat'] != null && item['wage'] > 0) {
        total += item['wage'];
      }
    }
    return total;
  }

  // ✅ جلب رصيد المورد محول إلى 24 قيراط (مصحح)
  Future<void> _loadSupplierBalance(String supplierId) async {
    setState(() => _isLoadingBalance = true);
    try {
      final vouchers = await FS.getVouchersForSupplier(supplierId);

      double payW = 0, recW = 0;
      double payG = 0, recG = 0;

      for (var v in vouchers) {
        // التحقق من وجود عيارات متعددة
        final carats = v["carats"] as List?;

        if (carats != null && carats.isNotEmpty) {
          // إذا كان السند يحتوي على عيارات متعددة
          for (var c in carats) {
            final weight = (c["weight"] ?? 0).toDouble();
            final wage = (c["wage"] ?? 0).toDouble();
            final carat = (c["carat"] ?? "").toString();
            final weightIn24 = _convertTo24Karat(weight, carat);

            if (v["type"] == "payment") {
              payW += weightIn24;
              payG += wage;
            } else if (v["type"] == "receipt") {
              recW += weightIn24;
              recG += wage;
            }
          }
        } else {
          // السند العادي (عيار واحد)
          final weight = double.tryParse(v["weight"]?.toString() ?? "0") ?? 0;
          final wage = double.tryParse(v["wage"]?.toString() ?? "0") ?? 0;
          final carat = (v["carat"] ?? "").toString();
          final weightIn24 = _convertTo24Karat(weight, carat);

          if (v["type"] == "payment") {
            payW += weightIn24;
            payG += wage;
          } else if (v["type"] == "receipt") {
            recW += weightIn24;
            recG += wage;
          }
        }
      }

      // ✅ الرصيد = القبض - الصرف (محول إلى 24 قيراط)
      final balanceWeight = recW - payW;
      final balanceWage = recG - payG;

      setState(() {
        _balanceWeight24 = balanceWeight;
        _balanceWage = balanceWage;
      });
    } catch (e) {
      print('❌ خطأ في جلب الرصيد: $e');
    } finally {
      setState(() => _isLoadingBalance = false);
    }
  }

  // حساب الرصيد المتبقي بعد الخصم
  double _getRemainingBalance() {
    return _balanceWeight24 - _calculateTotalWeight24();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("سند الصرف", "Payment Voucher")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // بطاقة المعلومات الأساسية
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // التاريخ
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _t('التاريخ', 'Date'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat("yyyy-MM-dd").format(date!),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date!,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() => date = picked);
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    // اختيار المورد
                    FutureBuilder(
                      future: FS.getSuppliers(),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final suppliers = snap.data!;
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: _t("اختر المورد", "Select Supplier"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            prefixIcon: const Icon(Icons.business,
                                color: Color(0xFFD4AF37), size: 20),
                          ),
                          value: supplierId,
                          items: suppliers.map((s) {
                            return DropdownMenuItem(
                              value: s["id"].toString(),
                              child: Text(s["name"]),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() {
                              supplierId = v;
                              supplierName = suppliers.firstWhere(
                                  (s) => s["id"].toString() == v)["name"];
                              delegate = null;
                              _balanceWeight24 = 0.0;
                              _balanceWage = 0.0;
                            });
                            if (v != null) {
                              _loadSupplierBalance(v);
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // اختيار المندوب
                    if (supplierId != null)
                      FutureBuilder(
                        future: FS.getSuppliers(),
                        builder: (context, snap) {
                          if (!snap.hasData) return const SizedBox();
                          final supplier = snap.data!
                              .firstWhere((s) => s["id"] == supplierId);
                          final delegates =
                              List<String>.from(supplier["delegates"] ?? []);
                          if (delegates.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.warning,
                                      color: Colors.orange.shade700, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _t("لا يوجد مناديب لهذا المورد",
                                          "No delegates for this supplier"),
                                      style: TextStyle(
                                        color: Colors.orange.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: _t("اختر المندوب", "Select Delegate"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color(0xFFD4AF37), size: 20),
                            ),
                            value: delegate,
                            items: delegates.map((d) {
                              return DropdownMenuItem(
                                value: d,
                                child: Text(d),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => delegate = v),
                          );
                        },
                      ),

                    const SizedBox(height: 12),

                    // طريقة الدفع
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: _t("طريقة الدفع", "Payment Method"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        prefixIcon: const Icon(Icons.payment,
                            color: Color(0xFFD4AF37), size: 20),
                      ),
                      value: paymentMethod,
                      items: [
                        _t("كاش", "Cash"),
                        _t("شبكة", "Network"),
                        _t("متعدد", "Mixed")
                      ].map((m) {
                        return DropdownMenuItem(value: m, child: Text(m));
                      }).toList(),
                      onChanged: (v) => setState(() => paymentMethod = v),
                    ),

                    // حقول المبالغ حسب طريقة الدفع
                    if (paymentMethod == _t("كاش", "Cash") ||
                        paymentMethod == _t("متعدد", "Mixed"))
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: cashCtrl,
                          decoration: InputDecoration(
                            labelText: _t("💵 المبلغ كاش", "💵 Cash Amount"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            prefixIcon: const Icon(Icons.money,
                                color: Color(0xFFD4AF37), size: 20),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    if (paymentMethod == _t("شبكة", "Network") ||
                        paymentMethod == _t("متعدد", "Mixed"))
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: networkCtrl,
                          decoration: InputDecoration(
                            labelText:
                                _t("💳 المبلغ شبكة", "💳 Network Amount"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            prefixIcon: const Icon(Icons.credit_card,
                                color: Color(0xFFD4AF37), size: 20),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ===== كارت الرصيد =====
            if (supplierId != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getRemainingBalance() > 0
                      ? Colors.red.shade50
                      : _getRemainingBalance() < 0
                          ? Colors.green.shade50
                          : _getRemainingBalance() == 0 && _balanceWeight24 != 0
                              ? Colors.green.shade100
                              : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getRemainingBalance() > 0
                        ? Colors.red.shade300
                        : _getRemainingBalance() < 0
                            ? Colors.green.shade300
                            : _getRemainingBalance() == 0 &&
                                    _balanceWeight24 != 0
                                ? Colors.green.shade400
                                : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _t("الرصيد الحالي (24 قيراط)",
                              "Current Balance (24K)"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (_isLoadingBalance)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Text(
                            "${_balanceWeight24.toStringAsFixed(2)} ${_t('جم', 'g')}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _balanceWeight24 > 0
                                  ? Colors.red
                                  : _balanceWeight24 < 0
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _t("الرصيد المتبقي", "Remaining Balance"),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${_getRemainingBalance().toStringAsFixed(2)} ${_t('جم', 'g')}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _getRemainingBalance() > 0
                                ? Colors.red
                                : _getRemainingBalance() < 0
                                    ? Colors.green
                                    : _getRemainingBalance() == 0 &&
                                            _balanceWeight24 != 0
                                        ? Colors.green
                                        : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (_calculateTotalWeight24() > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${_t('قيد الخصم', 'Deducting')}: ${_calculateTotalWeight24().toStringAsFixed(2)} ${_t('جم (معادل 24)', 'g (equiv. 24K)')}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                    if (_getRemainingBalance() < 0 &&
                        _balanceWeight24 != 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _t("⚠️ الخصم أكبر من الرصيد",
                              "⚠️ Deduction exceeds balance"),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (_getRemainingBalance() == 0 &&
                        _balanceWeight24 != 0 &&
                        _calculateTotalWeight24() > 0) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _t("✅ تم تصفية الرصيد بالكامل",
                              "✅ Balance fully settled"),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),

            // بطاقة العيارات المتعددة
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.category,
                            color: Color(0xFFD4AF37), size: 20),
                        const SizedBox(width: 6),
                        Text(
                          _t("العيارات", "Carats"),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Color(0xFFD4AF37), size: 28),
                          onPressed: _addNewCaratItem,
                          tooltip: _t("إضافة عيار", "Add Carat"),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${_t('الإجمالي', 'Total')}: ${_calculateTotalWeight().toStringAsFixed(2)} ${_t('جم', 'g')}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 12),

                    // قائمة العيارات (Column بدل ListView للسماح بالسكرول الكلي)
                    Column(
                      children: caratItems
                          .asMap()
                          .entries
                          .map((e) => _buildCaratItem(e.key, e.value))
                          .toList(),
                    ),

                    const SizedBox(height: 4),

                    // إجمالي الأجور
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _t("إجمالي الأجور", "Total Wages"),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${_calculateTotalWage().toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // زر الحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.save,
                              color: Colors.white, size: 20),
                          label: Text(
                            _t("حفظ", "Save"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (supplierId == null ||
                                delegate == null ||
                                paymentMethod == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_t(
                                      "يرجى إدخال جميع البيانات المطلوبة",
                                      "Please fill all required fields")),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            final validItems = caratItems
                                .where((item) =>
                                    item['carat'] != null && item['weight'] > 0)
                                .toList();

                            if (validItems.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_t(
                                      "يرجى إدخال عيار واحد على الأقل",
                                      "Please enter at least one carat")),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // تجهيز بيانات العيارات المتعددة
                            List<Map<String, dynamic>> caratsData = [];
                            for (var item in validItems) {
                              caratsData.add({
                                'carat': item['carat'].toString(),
                                'weight': item['weight'],
                                'wage': item['wage'] ?? 0,
                              });
                            }

                            // حفظ السند - الدالة تقوم تلقائياً بخصم الكسر
                            await FS.addPaymentVoucher(
                              supplierId: supplierId!,
                              supplierName: supplierName!,
                              delegate: delegate!,
                              carat: 'multiple',
                              weight: _calculateTotalWeight(),
                              wage: _calculateTotalWage(),
                              paymentMethod: paymentMethod!,
                              cash: cashCtrl.text.isEmpty
                                  ? null
                                  : double.parse(cashCtrl.text),
                              network: networkCtrl.text.isEmpty
                                  ? null
                                  : double.parse(networkCtrl.text),
                              date: date!,
                              carats: caratsData,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_t(
                                    "تم حفظ السند بنجاح ✅ مع ${validItems.length} عيار وتم خصم الكسر",
                                    "Payment voucher saved successfully ✅ with ${validItems.length} carats and scrap deducted")),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaratItem(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // العيار - أصغر
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: _t("العيار", "Carat"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              value: item['carat']?.toString(),
              items: ["18", "21", "22"].map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );
              }).toList(),
              onChanged: (v) {
                setState(() {
                  caratItems[index]['carat'] = v;
                });
              },
            ),
          ),
          const SizedBox(width: 6),
          // الوزن - أكبر
          Expanded(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                labelText: _t("الوزن", "Weight"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixText: _t("جم", "g"),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                setState(() {
                  caratItems[index]['weight'] = double.tryParse(v) ?? 0;
                });
              },
            ),
          ),
          const SizedBox(width: 6),
          // الأجر - متوسط
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: _t("الأجر", "Wage"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) {
                setState(() {
                  caratItems[index]['wage'] = double.tryParse(v) ?? 0;
                });
              },
            ),
          ),
          const SizedBox(width: 4),
          // زر الحذف
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red, size: 22),
            onPressed:
                caratItems.length > 1 ? () => _removeCaratItem(index) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: _t("حذف العيار", "Remove Carat"),
          ),
        ],
      ),
    );
  }
}
