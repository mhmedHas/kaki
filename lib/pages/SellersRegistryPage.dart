// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' hide TextDirection;

// // ═════════════════════════════════════════════════════════════
// // 🎯 صفحة سجل البائعين
// // ─────────────────────────────────────────────────────────────
// // التاب 1: البائعين والمبيعات (نفس المنطق القديم)
// // التاب 2: المصروفات والرواتب
// //   • راتب   → اسم الشخص + المبلغ + التاريخ
// //   • يومي   → اسم المصروف + القيمة + التاريخ + ملاحظة
// //   • ثابت   → اسم المصروف + القيمة + التاريخ + ملاحظة
// // ═════════════════════════════════════════════════════════════
// class SellersRegistryPage extends StatefulWidget {
//   const SellersRegistryPage({super.key});

//   @override
//   State<SellersRegistryPage> createState() => _SellersRegistryPageState();
// }

// class _SellersRegistryPageState extends State<SellersRegistryPage>
//     with SingleTickerProviderStateMixin {
//   static const Color goldColor = Color(0xFFD4AF37);
//   static const Color greenColor = Color(0xFF2E7D32);
//   static const Color redColor = Color(0xFFC62828);
//   static const Color bgColor = Color(0xFFFAF7F0);

//   final uid = FirebaseAuth.instance.currentUser!.uid;
//   late TabController _tabController;

//   // فلتر التاب التاني
//   String _expenseFilter = 'all'; // all | salary | daily | fixed

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   CollectionReference get _salesCol => FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('sales_history');

//   CollectionReference get _expensesCol => FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('sellerExpenses');

//   // ═══ Helpers ═══
//   double _d(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0;

//   String _seller(Map<String, dynamic> data) {
//     final p = data['payment'];
//     if (p is Map) {
//       final v = p['soldBy'];
//       if (v != null && v.toString().trim().isNotEmpty) return v.toString();
//     }
//     return 'غير محدد';
//   }

//   double _cash(Map<String, dynamic> data) {
//     final p = data['payment'];
//     return p is Map ? _d(p['cash']) : 0;
//   }

//   double _visa(Map<String, dynamic> data) {
//     final p = data['payment'];
//     return p is Map ? _d(p['visa']) : 0;
//   }

//   double _total(Map<String, dynamic> data) {
//     final p = data['payment'];
//     if (p is Map && p['total'] != null) return _d(p['total']);
//     return _cash(data) + _visa(data);
//   }

//   double _weight(Map<String, dynamic> data) {
//     final p = data['payload'];
//     if (p is Map) return _d(p['weight']);
//     return 0;
//   }

//   DateTime? _date(Map<String, dynamic> data) {
//     final ts = data['soldAt'];
//     if (ts is Timestamp) return ts.toDate();
//     return null;
//   }

//   String _fmtNum(double v) {
//     if (v == v.roundToDouble()) return v.toInt().toString();
//     return v.toStringAsFixed(2);
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🏗 Build
//   // ═════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: bgColor,
//         appBar: AppBar(
//           backgroundColor: goldColor,
//           foregroundColor: Colors.white,
//           centerTitle: true,
//           title: const Text(
//             'سجل البائعين',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           bottom: TabBar(
//             controller: _tabController,
//             indicatorColor: Colors.white,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white70,
//             tabs: const [
//               Tab(
//                 text: 'البائعين والمبيعات',
//                 icon: Icon(Icons.people, size: 20),
//               ),
//               Tab(
//                 text: 'المصروفات والرواتب',
//                 icon: Icon(Icons.receipt_long, size: 20),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _buildSellersTab(),
//             _buildExpensesTab(),
//           ],
//         ),
//         floatingActionButton: _tabController.index == 1
//             ? FloatingActionButton.extended(
//                 backgroundColor: goldColor,
//                 icon: const Icon(Icons.add, color: Colors.white),
//                 label: const Text(
//                   'إضافة',
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: _showAddSheet,
//               )
//             : null,
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 📌 TAB 1: SELLERS
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildSellersTab() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _salesCol.orderBy('soldAt', descending: true).snapshots(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(color: goldColor));
//         }
//         if (snap.hasError) return _errorState(snap.error.toString());

//         final docs = snap.data?.docs ?? [];
//         if (docs.isEmpty) {
//           return _emptyState(
//             icon: Icons.inbox_outlined,
//             title: 'لا يوجد سجل مبيعات بعد',
//             subtitle: 'لم يتم تسجيل أي عملية بيع',
//           );
//         }

//         final Map<String, List<QueryDocumentSnapshot>> bySeller = {};
//         for (final d in docs) {
//           final data = d.data() as Map<String, dynamic>;
//           final s = _seller(data);
//           bySeller.putIfAbsent(s, () => []).add(d);
//         }

//         final sellers = bySeller.keys.toList()
//           ..sort((a, b) {
//             final ta = _sellerTotal(bySeller[a]!);
//             final tb = _sellerTotal(bySeller[b]!);
//             return tb.total.compareTo(ta.total);
//           });

//         final grand = _sellerTotal(docs);

//         return ListView(
//           padding: const EdgeInsets.all(14),
//           children: [
//             _grandSummaryCard(docs.length, grand),
//             const SizedBox(height: 14),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Text(
//                 'البائعين (${sellers.length})',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFB8860B),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             ...sellers.map((s) => _sellerCard(s, bySeller[s]!)),
//             const SizedBox(height: 40),
//           ],
//         );
//       },
//     );
//   }

//   _Totals _sellerTotal(List<QueryDocumentSnapshot> docs) {
//     final t = _Totals();
//     for (final d in docs) {
//       final data = d.data() as Map<String, dynamic>;
//       t.count++;
//       t.cash += _cash(data);
//       t.visa += _visa(data);
//       t.total += _total(data);
//       t.weight += _weight(data);
//     }
//     return t;
//   }

//   Widget _grandSummaryCard(int count, _Totals t) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: goldColor.withOpacity(0.35),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _grandStat(Icons.inventory_2, 'عدد القطع', '$count'),
//               ),
//               Container(
//                   width: 1, height: 42, color: Colors.white.withOpacity(0.3)),
//               Expanded(
//                 child: _grandStat(Icons.scale, 'إجمالي الوزن',
//                     '${t.weight.toStringAsFixed(2)} جم'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Container(height: 1, color: Colors.white.withOpacity(0.25)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(child: _grandMoney('كاش', t.cash)),
//               Container(
//                   width: 1, height: 34, color: Colors.white.withOpacity(0.3)),
//               Expanded(child: _grandMoney('شبكة', t.visa)),
//               Container(
//                   width: 1, height: 34, color: Colors.white.withOpacity(0.3)),
//               Expanded(child: _grandMoney('الإجمالي', t.total, bold: true)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _grandStat(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 22),
//         const SizedBox(height: 4),
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 2),
//         Text(value,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _grandMoney(String label, double value, {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 3),
//         Text(
//           '${_fmtNum(value)} ر.س',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: bold ? 15 : 13,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _sellerCard(String seller, List<QueryDocumentSnapshot> docs) {
//     final t = _sellerTotal(docs);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: goldColor.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () => _showSellerDetails(seller, docs),
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 20,
//                       backgroundColor: goldColor,
//                       child: Icon(Icons.person, color: Colors.white, size: 22),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             seller,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '${t.count} قطعة',
//                             style: TextStyle(
//                                 fontSize: 11, color: Colors.grey.shade600),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(Icons.arrow_forward_ios,
//                         size: 16, color: Colors.grey),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Divider(color: Colors.grey.shade200, height: 1),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(child: _sellerStat('كاش', t.cash, greenColor)),
//                     Container(
//                         width: 1, height: 30, color: Colors.grey.shade300),
//                     Expanded(child: _sellerStat('شبكة', t.visa, Colors.blue)),
//                     Container(
//                         width: 1, height: 30, color: Colors.grey.shade300),
//                     Expanded(
//                         child: _sellerStat(
//                             'الإجمالي', t.total, const Color(0xFFB8860B),
//                             bold: true)),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.scale, size: 13, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Text(
//                       'الوزن: ${t.weight.toStringAsFixed(2)} جم',
//                       style:
//                           TextStyle(fontSize: 11, color: Colors.grey.shade700),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sellerStat(String label, double value, Color color,
//       {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(
//           _fmtNum(value),
//           style: TextStyle(
//             fontSize: bold ? 14 : 12,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   void _showSellerDetails(String seller, List<QueryDocumentSnapshot> docs) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _SellerDetailsSheet(
//         seller: seller,
//         docs: docs,
//         uid: uid,
//         cashFn: _cash,
//         visaFn: _visa,
//         totalFn: _total,
//         weightFn: _weight,
//         dateFn: _date,
//         fmtNum: _fmtNum,
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 📌 TAB 2: EXPENSES & SALARIES
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildExpensesTab() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _expensesCol.orderBy('date', descending: true).snapshots(),
//       builder: (context, snap) {
//         if (snap.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(color: goldColor));
//         }
//         if (snap.hasError) return _errorState(snap.error.toString());

//         final allDocs = snap.data?.docs ?? [];

//         // ✅ الفلترة حسب النوع
//         final docs = allDocs.where((d) {
//           if (_expenseFilter == 'all') return true;
//           final data = d.data() as Map<String, dynamic>;
//           final type = data['type']?.toString() ?? '';
//           if (_expenseFilter == 'salary') return type == 'salary';
//           if (_expenseFilter == 'daily') return type == 'daily_expense';
//           if (_expenseFilter == 'fixed') return type == 'fixed_expense';
//           return true;
//         }).toList();

//         // ✅ الإجماليات (من كل البيانات مش المفلترة)
//         double totalSalaries = 0;
//         double totalDaily = 0;
//         double totalFixed = 0;
//         for (final d in allDocs) {
//           final data = d.data() as Map<String, dynamic>;
//           final amount = _d(data['amount']);
//           final type = data['type']?.toString() ?? '';
//           if (type == 'salary') {
//             totalSalaries += amount;
//           } else if (type == 'daily_expense') {
//             totalDaily += amount;
//           } else if (type == 'fixed_expense') {
//             totalFixed += amount;
//           }
//         }

//         return ListView(
//           padding: const EdgeInsets.all(14),
//           children: [
//             _expensesSummaryCard(
//               allDocs.length,
//               totalSalaries,
//               totalDaily,
//               totalFixed,
//             ),
//             const SizedBox(height: 14),
//             _filterChips(),
//             const SizedBox(height: 12),
//             if (docs.isEmpty)
//               _emptyState(
//                 icon: Icons.receipt_long,
//                 title: _expenseFilter == 'all'
//                     ? 'لا توجد مصروفات أو رواتب'
//                     : 'لا يوجد بنود من النوع المختار',
//                 subtitle: 'اضغط زر الإضافة لتسجيل راتب أو مصروف',
//               )
//             else ...[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4),
//                 child: Text(
//                   'البنود (${docs.length})',
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFB8860B),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               ...docs.map((d) => _expenseCard(d)),
//             ],
//             const SizedBox(height: 100),
//           ],
//         );
//       },
//     );
//   }

//   Widget _filterChips() {
//     final filters = [
//       {'key': 'all', 'label': 'الكل', 'icon': Icons.list},
//       {'key': 'salary', 'label': 'رواتب', 'icon': Icons.payments},
//       {'key': 'daily', 'label': 'مصروفات يومية', 'icon': Icons.receipt},
//       {'key': 'fixed', 'label': 'مصروفات ثابتة', 'icon': Icons.receipt_long},
//     ];

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: filters.map((f) {
//           final isSelected = _expenseFilter == f['key'];
//           return Padding(
//             padding: const EdgeInsets.only(left: 8),
//             child: InkWell(
//               onTap: () => setState(() => _expenseFilter = f['key'] as String),
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? goldColor : Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isSelected ? goldColor : goldColor.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       f['icon'] as IconData,
//                       size: 16,
//                       color: isSelected ? Colors.white : goldColor,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       f['label'] as String,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color:
//                             isSelected ? Colors.white : const Color(0xFF444444),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _expensesSummaryCard(
//     int count,
//     double salaries,
//     double daily,
//     double fixed,
//   ) {
//     final grand = salaries + daily + fixed;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [redColor, Color(0xFF8B0000)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: redColor.withOpacity(0.3),
//             blurRadius: 14,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.receipt_long, color: Colors.white, size: 24),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text(
//                   'الإجمالي العام',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   '$count بند',
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Container(height: 1, color: Colors.white.withOpacity(0.25)),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Expanded(
//                 child: _expSummaryCol('رواتب', salaries, Icons.payments),
//               ),
//               Container(
//                   width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
//               Expanded(
//                 child: _expSummaryCol('يومية', daily, Icons.receipt),
//               ),
//               Container(
//                   width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
//               Expanded(
//                 child: _expSummaryCol('ثابتة', fixed, Icons.receipt_long),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Container(height: 1, color: Colors.white.withOpacity(0.25)),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('الإجمالي: ',
//                   style: TextStyle(color: Colors.white70, fontSize: 13)),
//               Text(
//                 '${_fmtNum(grand)} ر.س',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _expSummaryCol(String label, double value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white70, size: 18),
//         const SizedBox(height: 4),
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 3),
//         Text(
//           _fmtNum(value),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _expenseCard(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final type = data['type']?.toString() ?? 'expense';

//     final isSalary = type == 'salary';
//     final isDaily = type == 'daily_expense';
//     final isFixed = type == 'fixed_expense';

//     final color = isSalary
//         ? Colors.blue
//         : isDaily
//             ? Colors.orange
//             : redColor;
//     final label = isSalary
//         ? 'راتب'
//         : isDaily
//             ? 'مصروف يومي'
//             : 'مصروف ثابت';
//     final icon = isSalary
//         ? Icons.payments
//         : isDaily
//             ? Icons.receipt
//             : Icons.receipt_long;

//     // ✅ اسم البند
//     // - الراتب: الاسم = اسم الشخص
//     // - المصروف: الاسم = اسم المصروف
//     final name = data['name']?.toString() ?? label;
//     final amount = _d(data['amount']);
//     final notes = data['notes']?.toString() ?? '';
//     final ts = data['date'];
//     final date = ts is Timestamp ? ts.toDate() : null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: color, size: 22),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: color.withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         label,
//                         style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           color: color,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         name,
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 if (date != null)
//                   Row(
//                     children: [
//                       Icon(Icons.calendar_today,
//                           size: 11, color: Colors.grey.shade600),
//                       const SizedBox(width: 3),
//                       Text(
//                         DateFormat('yyyy/MM/dd').format(date),
//                         style: TextStyle(
//                             fontSize: 11, color: Colors.grey.shade700),
//                       ),
//                     ],
//                   ),
//                 if (notes.isNotEmpty) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     notes,
//                     style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '${_fmtNum(amount)} ر.س',
//                 style: TextStyle(
//                     fontSize: 15, fontWeight: FontWeight.bold, color: color),
//               ),
//               const SizedBox(height: 4),
//               InkWell(
//                 onTap: () => _confirmDeleteExpense(doc),
//                 borderRadius: BorderRadius.circular(6),
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   child: const Icon(Icons.delete_outline,
//                       size: 18, color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // ➕ إضافة
//   // ═════════════════════════════════════════════════════════════
//   Future<void> _showAddSheet() async {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _AddExpenseSheet(uid: uid),
//     );
//   }

//   Future<void> _confirmDeleteExpense(QueryDocumentSnapshot doc) async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('حذف البند'),
//         content: const Text('هل تريد حذف هذا البند نهائياً؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: redColor),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('حذف', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//     if (ok != true) return;
//     try {
//       await doc.reference.delete();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('✅ تم الحذف'), backgroundColor: Colors.green),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: redColor),
//       );
//     }
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🎨 Empty / Error
//   // ═════════════════════════════════════════════════════════════
//   Widget _emptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
//       child: Column(
//         children: [
//           Icon(icon, size: 80, color: Colors.grey.shade400),
//           const SizedBox(height: 14),
//           Text(
//             title,
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade700),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 6),
//           Text(
//             subtitle,
//             style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _errorState(String err) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 60, color: redColor),
//             const SizedBox(height: 12),
//             const Text('حدث خطأ',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 6),
//             Text(err,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // 📊 نموذج الإجماليات
// // ═════════════════════════════════════════════════════════════
// class _Totals {
//   int count = 0;
//   double cash = 0;
//   double visa = 0;
//   double total = 0;
//   double weight = 0;
// }

// // ═════════════════════════════════════════════════════════════
// // 📄 شيت تفاصيل البائع
// // ═════════════════════════════════════════════════════════════
// class _SellerDetailsSheet extends StatelessWidget {
//   final String seller;
//   final List<QueryDocumentSnapshot> docs;
//   final String uid;
//   final double Function(Map<String, dynamic>) cashFn;
//   final double Function(Map<String, dynamic>) visaFn;
//   final double Function(Map<String, dynamic>) totalFn;
//   final double Function(Map<String, dynamic>) weightFn;
//   final DateTime? Function(Map<String, dynamic>) dateFn;
//   final String Function(double) fmtNum;

//   const _SellerDetailsSheet({
//     required this.seller,
//     required this.docs,
//     required this.uid,
//     required this.cashFn,
//     required this.visaFn,
//     required this.totalFn,
//     required this.weightFn,
//     required this.dateFn,
//     required this.fmtNum,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double cash = 0, visa = 0, total = 0, weight = 0;
//     for (final d in docs) {
//       final data = d.data() as Map<String, dynamic>;
//       cash += cashFn(data);
//       visa += visaFn(data);
//       total += totalFn(data);
//       weight += weightFn(data);
//     }

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: DraggableScrollableSheet(
//         initialChildSize: 0.85,
//         minChildSize: 0.5,
//         maxChildSize: 0.95,
//         expand: false,
//         builder: (context, scrollController) => Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFFAF7F0),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
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
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Color(0xFFD4AF37),
//                       child: Icon(Icons.person, color: Colors.white, size: 22),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             seller,
//                             style: const TextStyle(
//                                 fontSize: 17, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '${docs.length} قطعة',
//                             style: TextStyle(
//                                 fontSize: 12, color: Colors.grey.shade600),
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
//               const SizedBox(height: 8),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(uid)
//                       .collection('sellerExpenses')
//                       .snapshots(),
//                   builder: (context, snap) {
//                     final allExpenses = snap.data?.docs ?? [];

//                     // رواتب هذا البائع فقط (لو الاسم مطابق)
//                     double mySalary = 0;
//                     final mySalaryDocs = <QueryDocumentSnapshot>[];
//                     for (final d in allExpenses) {
//                       final data = d.data() as Map<String, dynamic>;
//                       if (data['type']?.toString() == 'salary' &&
//                           data['name']?.toString() == seller) {
//                         mySalary += double.tryParse(
//                                 data['amount']?.toString() ?? '0') ??
//                             0;
//                         mySalaryDocs.add(d);
//                       }
//                     }

//                     return ListView(
//                       controller: scrollController,
//                       padding: const EdgeInsets.all(16),
//                       children: [
//                         _summaryCard(cash, visa, total, weight),
//                         const SizedBox(height: 12),
//                         if (mySalaryDocs.isNotEmpty) ...[
//                           _salaryCard(mySalary, mySalaryDocs),
//                           const SizedBox(height: 12),
//                         ],
//                         const Text(
//                           'سجل المبيعات',
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFB8860B)),
//                         ),
//                         const SizedBox(height: 8),
//                         ...docs.map((d) => _saleCard(d)),
//                         const SizedBox(height: 40),
//                       ],
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

//   Widget _summaryCard(double cash, double visa, double total, double weight) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
//         ),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(child: _sumCol('كاش', cash)),
//               Container(width: 1, height: 30, color: Colors.white30),
//               Expanded(child: _sumCol('شبكة', visa)),
//               Container(width: 1, height: 30, color: Colors.white30),
//               Expanded(child: _sumCol('الإجمالي', total, bold: true)),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Container(height: 1, color: Colors.white30),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.scale, color: Colors.white, size: 16),
//               const SizedBox(width: 6),
//               Text(
//                 'إجمالي الوزن: ${weight.toStringAsFixed(2)} جم',
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sumCol(String label, double value, {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 3),
//         Text(
//           fmtNum(value),
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: bold ? 15 : 13,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _salaryCard(double salary, List<QueryDocumentSnapshot> salaryDocs) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.blue.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.payments, color: Colors.blue.shade700, size: 20),
//               const SizedBox(width: 8),
//               const Text(
//                 'الراتب المسجل باسم هذا الشخص',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ...salaryDocs.map((d) {
//             final data = d.data() as Map<String, dynamic>;
//             final amount =
//                 double.tryParse(data['amount']?.toString() ?? '0') ?? 0;
//             final ts = data['date'];
//             final date = ts is Timestamp ? ts.toDate() : null;
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 3),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       date != null
//                           ? DateFormat('yyyy/MM/dd').format(date)
//                           : '—',
//                       style:
//                           TextStyle(fontSize: 12, color: Colors.grey.shade700),
//                     ),
//                   ),
//                   Text(
//                     '${fmtNum(amount)} ر.س',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue.shade700),
//                   ),
//                 ],
//               ),
//             );
//           }),
//           Divider(color: Colors.blue.shade200),
//           Row(
//             children: [
//               const Expanded(
//                 child: Text(
//                   'الإجمالي',
//                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 '${fmtNum(salary)} ر.س',
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade700),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _saleCard(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//     final category = data['category']?.toString() ?? '';
//     final date = dateFn(data);
//     final cash = cashFn(data);
//     final visa = visaFn(data);
//     final total = totalFn(data);

//     final catLabel = _catLabel(category);
//     final catColor = _catColor(category);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: catColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   catLabel,
//                   style: TextStyle(
//                       fontSize: 9,
//                       fontWeight: FontWeight.bold,
//                       color: catColor),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               if (payload['kind'] != null)
//                 Expanded(
//                   child: Text(
//                     payload['kind'].toString(),
//                     style: const TextStyle(
//                         fontSize: 12, fontWeight: FontWeight.w600),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 )
//               else
//                 const Spacer(),
//               if (date != null)
//                 Text(
//                   DateFormat('yyyy/MM/dd').format(date),
//                   style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Row(
//             children: [
//               if (payload['carat'] != null) ...[
//                 Icon(Icons.grade, size: 11, color: Colors.grey.shade600),
//                 const SizedBox(width: 2),
//                 Text('${payload['carat']}',
//                     style: const TextStyle(fontSize: 11)),
//                 const SizedBox(width: 8),
//               ],
//               if (payload['weight'] != null) ...[
//                 Icon(Icons.scale, size: 11, color: Colors.grey.shade600),
//                 const SizedBox(width: 2),
//                 Text('${payload['weight']} جم',
//                     style: const TextStyle(fontSize: 11)),
//               ],
//               const Spacer(),
//               Text(
//                 '${fmtNum(total)} ر.س',
//                 style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFB8860B)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               _miniChip('كاش', cash, Colors.green),
//               const SizedBox(width: 6),
//               _miniChip('شبكة', visa, Colors.blue),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _miniChip(String label, double value, Color color) {
//     if (value <= 0) return const SizedBox.shrink();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         '$label: ${fmtNum(value)}',
//         style:
//             TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
//       ),
//     );
//   }

//   String _catLabel(String c) {
//     switch (c) {
//       case 'gold':
//         return 'ذهب';
//       case 'scrap':
//         return 'كسر';
//       case 'bullion':
//         return 'سبائك';
//       case 'gem':
//         return 'أحجار';
//       default:
//         return c.isEmpty ? 'غير محدد' : c;
//     }
//   }

//   Color _catColor(String c) {
//     switch (c) {
//       case 'gold':
//         return const Color(0xFFD4AF37);
//       case 'scrap':
//         return Colors.green;
//       case 'bullion':
//         return Colors.blueGrey;
//       case 'gem':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // ➕ شيت الإضافة
// // ─────────────────────────────────────────────────────────────
// // 3 أنواع:
// //   • salary        → اسم الشخص + المبلغ + التاريخ
// //   • daily_expense → اسم المصروف + القيمة + التاريخ + ملاحظة
// //   • fixed_expense → اسم المصروف + القيمة + التاريخ + ملاحظة
// // ═════════════════════════════════════════════════════════════
// class _AddExpenseSheet extends StatefulWidget {
//   final String uid;
//   const _AddExpenseSheet({required this.uid});

//   @override
//   State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
// }

// class _AddExpenseSheetState extends State<_AddExpenseSheet> {
//   String _type = 'salary'; // salary | daily_expense | fixed_expense
//   final _nameController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _notesController = TextEditingController();
//   DateTime _date = DateTime.now();
//   bool _saving = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _amountController.dispose();
//     _notesController.dispose();
//     super.dispose();
//   }

//   bool get _isSalary => _type == 'salary';

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _date,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => _date = picked);
//   }

//   Future<void> _save() async {
//     final name = _nameController.text.trim();
//     final amount = double.tryParse(_amountController.text.trim()) ?? 0;
//     if (name.isEmpty) {
//       _snack(_isSalary ? 'يرجى إدخال اسم الشخص' : 'يرجى إدخال اسم المصروف',
//           Colors.orange);
//       return;
//     }
//     if (amount <= 0) {
//       _snack('يرجى إدخال مبلغ صحيح', Colors.orange);
//       return;
//     }
//     setState(() => _saving = true);
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.uid)
//           .collection('sellerExpenses')
//           .add({
//         'type': _type,
//         'name': name,
//         'amount': amount,
//         // ✅ الملاحظة فقط للمصروفات (الراتب مالوش ملاحظة)
//         if (!_isSalary) 'notes': _notesController.text.trim(),
//         'date': Timestamp.fromDate(_date),
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       if (!mounted) return;
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ تم الحفظ بنجاح'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       _snack('❌ خطأ: $e', Colors.red);
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   void _snack(String msg, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: color),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//           top: 16,
//           left: 16,
//           right: 16,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   const Icon(Icons.add_circle,
//                       color: Color(0xFFD4AF37), size: 24),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     child: Text(
//                       'إضافة جديدة',
//                       style:
//                           TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // ✅ اختيار النوع
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.all(4),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _typeBtn('راتب', Icons.payments, 'salary'),
//                     ),
//                     Expanded(
//                       child: _typeBtn('يومي', Icons.receipt, 'daily_expense'),
//                     ),
//                     Expanded(
//                       child:
//                           _typeBtn('ثابت', Icons.receipt_long, 'fixed_expense'),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // ✅ اسم (شخص للراتب / مصروف للباقي)
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: _isSalary
//                       ? 'اسم الشخص'
//                       : 'اسم المصروف (مثال: كهرباء، إيجار...)',
//                   prefixIcon: Icon(
//                     _isSalary ? Icons.person : Icons.label,
//                     color: const Color(0xFFD4AF37),
//                   ),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // ✅ المبلغ
//               TextField(
//                 controller: _amountController,
//                 keyboardType:
//                     const TextInputType.numberWithOptions(decimal: true),
//                 decoration: InputDecoration(
//                   labelText:
//                       _isSalary ? 'قيمة الراتب (ر.س)' : 'قيمة المصروف (ر.س)',
//                   prefixIcon: const Icon(Icons.money, color: Color(0xFFD4AF37)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // ✅ التاريخ
//               InkWell(
//                 onTap: _pickDate,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.calendar_today,
//                           color: Color(0xFFD4AF37)),
//                       const SizedBox(width: 10),
//                       Text(
//                         DateFormat('yyyy/MM/dd').format(_date),
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ✅ الملاحظة (للمصروفات فقط)
//               if (!_isSalary) ...[
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _notesController,
//                   maxLines: 2,
//                   decoration: InputDecoration(
//                     labelText: 'ملاحظة (اختياري)',
//                     prefixIcon:
//                         const Icon(Icons.note, color: Color(0xFFD4AF37)),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],

//               const SizedBox(height: 20),

//               // ✅ حفظ
//               SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton.icon(
//                   onPressed: _saving ? null : _save,
//                   icon: _saving
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                               strokeWidth: 2, color: Colors.white),
//                         )
//                       : const Icon(Icons.save),
//                   label: Text(_saving ? 'جاري الحفظ...' : 'حفظ'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD4AF37),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _typeBtn(String label, IconData icon, String type) {
//     final isSelected = _type == type;
//     return GestureDetector(
//       onTap: () => setState(() => _type = type),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon,
//                 size: 16,
//                 color: isSelected ? Colors.white : Colors.grey.shade600),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.white : Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

// ═════════════════════════════════════════════════════════════
// 🎯 صفحة سجل البائعين
// ─────────────────────────────────────────────────────────────
// التاب 1: البائعين والمبيعات
// التاب 2: المصروفات والرواتب
//   • راتب   → اسم الشخص + المبلغ + التاريخ
//   • يومي   → اسم المصروف + القيمة + التاريخ + ملاحظة
//   • ثابت   → اسم المصروف + القيمة + التاريخ + ملاحظة
//
// ✅ كل إضافة بتتحفظ في مكانين:
//    • users/{uid}/sellerExpenses    (لعرضها في هذه الصفحة)
//    • users/{uid}/expenses          (عشان تتخصم من إجمالي الصندوق
//                                     في الرصيد العام تلقائياً)
// ═════════════════════════════════════════════════════════════
class SellersRegistryPage extends StatefulWidget {
  const SellersRegistryPage({super.key});

  @override
  State<SellersRegistryPage> createState() => _SellersRegistryPageState();
}

class _SellersRegistryPageState extends State<SellersRegistryPage>
    with SingleTickerProviderStateMixin {
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color greenColor = Color(0xFF2E7D32);
  static const Color redColor = Color(0xFFC62828);
  static const Color bgColor = Color(0xFFFAF7F0);

  final uid = FirebaseAuth.instance.currentUser!.uid;
  late TabController _tabController;

  // فلتر التاب التاني
  String _expenseFilter = 'all'; // all | salary | daily | fixed

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  CollectionReference get _salesCol => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('sales_history');

  CollectionReference get _expensesCol => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('sellerExpenses');

  // ═══ Helpers ═══
  double _d(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0;

  String _seller(Map<String, dynamic> data) {
    final p = data['payment'];
    if (p is Map) {
      final v = p['soldBy'];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return 'غير محدد';
  }

  double _cash(Map<String, dynamic> data) {
    final p = data['payment'];
    return p is Map ? _d(p['cash']) : 0;
  }

  double _visa(Map<String, dynamic> data) {
    final p = data['payment'];
    return p is Map ? _d(p['visa']) : 0;
  }

  double _total(Map<String, dynamic> data) {
    final p = data['payment'];
    if (p is Map && p['total'] != null) return _d(p['total']);
    return _cash(data) + _visa(data);
  }

  double _weight(Map<String, dynamic> data) {
    final p = data['payload'];
    if (p is Map) return _d(p['weight']);
    return 0;
  }

  DateTime? _date(Map<String, dynamic> data) {
    final ts = data['soldAt'];
    if (ts is Timestamp) return ts.toDate();
    return null;
  }

  String _fmtNum(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(2);
  }

  // ═════════════════════════════════════════════════════════════
  // 🏗 Build
  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: goldColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'سجل البائعين',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(
                text: 'البائعين والمبيعات',
                icon: Icon(Icons.people, size: 20),
              ),
              Tab(
                text: 'المصروفات والرواتب',
                icon: Icon(Icons.receipt_long, size: 20),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildSellersTab(),
            _buildExpensesTab(),
          ],
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton.extended(
                backgroundColor: goldColor,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'إضافة',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: _showAddSheet,
              )
            : null,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 📌 TAB 1: SELLERS
  // ═════════════════════════════════════════════════════════════
  Widget _buildSellersTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _salesCol.orderBy('soldAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: goldColor));
        }
        if (snap.hasError) return _errorState(snap.error.toString());

        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) {
          return _emptyState(
            icon: Icons.inbox_outlined,
            title: 'لا يوجد سجل مبيعات بعد',
            subtitle: 'لم يتم تسجيل أي عملية بيع',
          );
        }

        final Map<String, List<QueryDocumentSnapshot>> bySeller = {};
        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          final s = _seller(data);
          bySeller.putIfAbsent(s, () => []).add(d);
        }

        final sellers = bySeller.keys.toList()
          ..sort((a, b) {
            final ta = _sellerTotal(bySeller[a]!);
            final tb = _sellerTotal(bySeller[b]!);
            return tb.total.compareTo(ta.total);
          });

        final grand = _sellerTotal(docs);

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _grandSummaryCard(docs.length, grand),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'البائعين (${sellers.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB8860B),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...sellers.map((s) => _sellerCard(s, bySeller[s]!)),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  _Totals _sellerTotal(List<QueryDocumentSnapshot> docs) {
    final t = _Totals();
    for (final d in docs) {
      final data = d.data() as Map<String, dynamic>;
      t.count++;
      t.cash += _cash(data);
      t.visa += _visa(data);
      t.total += _total(data);
      t.weight += _weight(data);
    }
    return t;
  }

  Widget _grandSummaryCard(int count, _Totals t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: goldColor.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _grandStat(Icons.inventory_2, 'عدد القطع', '$count'),
              ),
              Container(
                  width: 1, height: 42, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _grandStat(Icons.scale, 'إجمالي الوزن',
                    '${t.weight.toStringAsFixed(2)} جم'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withOpacity(0.25)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _grandMoney('كاش', t.cash)),
              Container(
                  width: 1, height: 34, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _grandMoney('شبكة', t.visa)),
              Container(
                  width: 1, height: 34, color: Colors.white.withOpacity(0.3)),
              Expanded(child: _grandMoney('الإجمالي', t.total, bold: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grandStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _grandMoney(String label, double value, {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 3),
        Text(
          '${_fmtNum(value)} ر.س',
          style: TextStyle(
            color: Colors.white,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _sellerCard(String seller, List<QueryDocumentSnapshot> docs) {
    final t = _sellerTotal(docs);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showSellerDetails(seller, docs),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: goldColor,
                      child: Icon(Icons.person, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seller,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${t.count} قطعة',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _sellerStat('كاش', t.cash, greenColor)),
                    Container(
                        width: 1, height: 30, color: Colors.grey.shade300),
                    Expanded(child: _sellerStat('شبكة', t.visa, Colors.blue)),
                    Container(
                        width: 1, height: 30, color: Colors.grey.shade300),
                    Expanded(
                        child: _sellerStat(
                            'الإجمالي', t.total, const Color(0xFFB8860B),
                            bold: true)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.scale, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'الوزن: ${t.weight.toStringAsFixed(2)} جم',
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sellerStat(String label, double value, Color color,
      {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          _fmtNum(value),
          style: TextStyle(
            fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showSellerDetails(String seller, List<QueryDocumentSnapshot> docs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SellerDetailsSheet(
        seller: seller,
        docs: docs,
        uid: uid,
        cashFn: _cash,
        visaFn: _visa,
        totalFn: _total,
        weightFn: _weight,
        dateFn: _date,
        fmtNum: _fmtNum,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 📌 TAB 2: EXPENSES & SALARIES
  // ═════════════════════════════════════════════════════════════
  Widget _buildExpensesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _expensesCol.orderBy('date', descending: true).snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: goldColor));
        }
        if (snap.hasError) return _errorState(snap.error.toString());

        final allDocs = snap.data?.docs ?? [];

        final docs = allDocs.where((d) {
          if (_expenseFilter == 'all') return true;
          final data = d.data() as Map<String, dynamic>;
          final type = data['type']?.toString() ?? '';
          if (_expenseFilter == 'salary') return type == 'salary';
          if (_expenseFilter == 'daily') return type == 'daily_expense';
          if (_expenseFilter == 'fixed') return type == 'fixed_expense';
          return true;
        }).toList();

        double totalSalaries = 0;
        double totalDaily = 0;
        double totalFixed = 0;
        for (final d in allDocs) {
          final data = d.data() as Map<String, dynamic>;
          final amount = _d(data['amount']);
          final type = data['type']?.toString() ?? '';
          if (type == 'salary') {
            totalSalaries += amount;
          } else if (type == 'daily_expense') {
            totalDaily += amount;
          } else if (type == 'fixed_expense') {
            totalFixed += amount;
          }
        }

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _expensesSummaryCard(
              allDocs.length,
              totalSalaries,
              totalDaily,
              totalFixed,
            ),
            const SizedBox(height: 14),
            _filterChips(),
            const SizedBox(height: 12),
            if (docs.isEmpty)
              _emptyState(
                icon: Icons.receipt_long,
                title: _expenseFilter == 'all'
                    ? 'لا توجد مصروفات أو رواتب'
                    : 'لا يوجد بنود من النوع المختار',
                subtitle: 'اضغط زر الإضافة لتسجيل راتب أو مصروف',
              )
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'البنود (${docs.length})',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB8860B),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...docs.map((d) => _expenseCard(d)),
            ],
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Widget _filterChips() {
    final filters = [
      {'key': 'all', 'label': 'الكل', 'icon': Icons.list},
      {'key': 'salary', 'label': 'رواتب', 'icon': Icons.payments},
      {'key': 'daily', 'label': 'مصروفات يومية', 'icon': Icons.receipt},
      {'key': 'fixed', 'label': 'مصروفات ثابتة', 'icon': Icons.receipt_long},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = _expenseFilter == f['key'];
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
              onTap: () => setState(() => _expenseFilter = f['key'] as String),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? goldColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? goldColor : goldColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      f['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.white : goldColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      f['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? Colors.white : const Color(0xFF444444),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _expensesSummaryCard(
    int count,
    double salaries,
    double daily,
    double fixed,
  ) {
    final grand = salaries + daily + fixed;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [redColor, Color(0xFF8B0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: redColor.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'الإجمالي العام (تم خصمه من الصندوق)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count بند',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white.withOpacity(0.25)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _expSummaryCol('رواتب', salaries, Icons.payments),
              ),
              Container(
                  width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _expSummaryCol('يومية', daily, Icons.receipt),
              ),
              Container(
                  width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
              Expanded(
                child: _expSummaryCol('ثابتة', fixed, Icons.receipt_long),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.white.withOpacity(0.25)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('الإجمالي: ',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text(
                '${_fmtNum(grand)} ر.س',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expSummaryCol(String label, double value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 3),
        Text(
          _fmtNum(value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _expenseCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final type = data['type']?.toString() ?? 'expense';

    final isSalary = type == 'salary';
    final isDaily = type == 'daily_expense';

    final color = isSalary
        ? Colors.blue
        : isDaily
            ? Colors.orange
            : redColor;
    final label = isSalary
        ? 'راتب'
        : isDaily
            ? 'مصروف يومي'
            : 'مصروف ثابت';
    final icon = isSalary
        ? Icons.payments
        : isDaily
            ? Icons.receipt
            : Icons.receipt_long;

    final name = data['name']?.toString() ?? label;
    final amount = _d(data['amount']);
    final notes = data['notes']?.toString() ?? '';
    final ts = data['date'];
    final date = ts is Timestamp ? ts.toDate() : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (date != null)
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 11, color: Colors.grey.shade600),
                      const SizedBox(width: 3),
                      Text(
                        DateFormat('yyyy/MM/dd').format(date),
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    notes,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_fmtNum(amount)} ر.س',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () => _confirmDeleteExpense(doc),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.delete_outline,
                      size: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // ➕ إضافة
  // ═════════════════════════════════════════════════════════════
  Future<void> _showAddSheet() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddExpenseSheet(uid: uid),
    );
  }

  // ✅ الحذف بيمسح من الـ collection الاتنين
  Future<void> _confirmDeleteExpense(QueryDocumentSnapshot doc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('حذف البند'),
        content: const Text(
          'هل تريد حذف هذا البند نهائياً؟\nسيتم إعادته للصندوق تلقائياً.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: redColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final data = doc.data() as Map<String, dynamic>;
      final linkedExpenseId = data['linkedExpenseId']?.toString();

      // 1) حذف من sellerExpenses
      await doc.reference.delete();

      // 2) حذف من expenses (لو موجود)
      if (linkedExpenseId != null && linkedExpenseId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('expenses')
              .doc(linkedExpenseId)
              .delete();
        } catch (_) {
          // ممكن يكون اتحذف من مكان تاني — مش مشكلة
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ تم الحذف وإرجاع المبلغ للصندوق'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: redColor),
      );
    }
  }

  // ═════════════════════════════════════════════════════════════
  // 🎨 Empty / Error
  // ═════════════════════════════════════════════════════════════
  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _errorState(String err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: redColor),
            const SizedBox(height: 12),
            const Text('حدث خطأ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(err,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// 📊 نموذج الإجماليات
// ═════════════════════════════════════════════════════════════
class _Totals {
  int count = 0;
  double cash = 0;
  double visa = 0;
  double total = 0;
  double weight = 0;
}

// ═════════════════════════════════════════════════════════════
// 📄 شيت تفاصيل البائع
// ═════════════════════════════════════════════════════════════
class _SellerDetailsSheet extends StatelessWidget {
  final String seller;
  final List<QueryDocumentSnapshot> docs;
  final String uid;
  final double Function(Map<String, dynamic>) cashFn;
  final double Function(Map<String, dynamic>) visaFn;
  final double Function(Map<String, dynamic>) totalFn;
  final double Function(Map<String, dynamic>) weightFn;
  final DateTime? Function(Map<String, dynamic>) dateFn;
  final String Function(double) fmtNum;

  const _SellerDetailsSheet({
    required this.seller,
    required this.docs,
    required this.uid,
    required this.cashFn,
    required this.visaFn,
    required this.totalFn,
    required this.weightFn,
    required this.dateFn,
    required this.fmtNum,
  });

  @override
  Widget build(BuildContext context) {
    double cash = 0, visa = 0, total = 0, weight = 0;
    for (final d in docs) {
      final data = d.data() as Map<String, dynamic>;
      cash += cashFn(data);
      visa += visaFn(data);
      total += totalFn(data);
      weight += weightFn(data);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF7F0),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFD4AF37),
                      child: Icon(Icons.person, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            seller,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${docs.length} قطعة',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
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
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('sellerExpenses')
                      .snapshots(),
                  builder: (context, snap) {
                    final allExpenses = snap.data?.docs ?? [];

                    double mySalary = 0;
                    final mySalaryDocs = <QueryDocumentSnapshot>[];
                    for (final d in allExpenses) {
                      final data = d.data() as Map<String, dynamic>;
                      if (data['type']?.toString() == 'salary' &&
                          data['name']?.toString() == seller) {
                        mySalary += double.tryParse(
                                data['amount']?.toString() ?? '0') ??
                            0;
                        mySalaryDocs.add(d);
                      }
                    }

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _summaryCard(cash, visa, total, weight),
                        const SizedBox(height: 12),
                        if (mySalaryDocs.isNotEmpty) ...[
                          _salaryCard(mySalary, mySalaryDocs),
                          const SizedBox(height: 12),
                        ],
                        const Text(
                          'سجل المبيعات',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB8860B)),
                        ),
                        const SizedBox(height: 8),
                        ...docs.map((d) => _saleCard(d)),
                        const SizedBox(height: 40),
                      ],
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

  Widget _summaryCard(double cash, double visa, double total, double weight) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _sumCol('كاش', cash)),
              Container(width: 1, height: 30, color: Colors.white30),
              Expanded(child: _sumCol('شبكة', visa)),
              Container(width: 1, height: 30, color: Colors.white30),
              Expanded(child: _sumCol('الإجمالي', total, bold: true)),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.white30),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.scale, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                'إجمالي الوزن: ${weight.toStringAsFixed(2)} جم',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sumCol(String label, double value, {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 3),
        Text(
          fmtNum(value),
          style: TextStyle(
            color: Colors.white,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _salaryCard(double salary, List<QueryDocumentSnapshot> salaryDocs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              const Text(
                'الراتب المسجل باسم هذا الشخص',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...salaryDocs.map((d) {
            final data = d.data() as Map<String, dynamic>;
            final amount =
                double.tryParse(data['amount']?.toString() ?? '0') ?? 0;
            final ts = data['date'];
            final date = ts is Timestamp ? ts.toDate() : null;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      date != null
                          ? DateFormat('yyyy/MM/dd').format(date)
                          : '—',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ),
                  Text(
                    '${fmtNum(amount)} ر.س',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700),
                  ),
                ],
              ),
            );
          }),
          Divider(color: Colors.blue.shade200),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'الإجمالي',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${fmtNum(salary)} ر.س',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _saleCard(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final payload = Map<String, dynamic>.from(data['payload'] ?? {});
    final category = data['category']?.toString() ?? '';
    final date = dateFn(data);
    final cash = cashFn(data);
    final visa = visaFn(data);
    final total = totalFn(data);

    final catLabel = _catLabel(category);
    final catColor = _catColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  catLabel,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: catColor),
                ),
              ),
              const SizedBox(width: 6),
              if (payload['kind'] != null)
                Expanded(
                  child: Text(
                    payload['kind'].toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                const Spacer(),
              if (date != null)
                Text(
                  DateFormat('yyyy/MM/dd').format(date),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (payload['carat'] != null) ...[
                Icon(Icons.grade, size: 11, color: Colors.grey.shade600),
                const SizedBox(width: 2),
                Text('${payload['carat']}',
                    style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 8),
              ],
              if (payload['weight'] != null) ...[
                Icon(Icons.scale, size: 11, color: Colors.grey.shade600),
                const SizedBox(width: 2),
                Text('${payload['weight']} جم',
                    style: const TextStyle(fontSize: 11)),
              ],
              const Spacer(),
              Text(
                '${fmtNum(total)} ر.س',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB8860B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _miniChip('كاش', cash, Colors.green),
              const SizedBox(width: 6),
              _miniChip('شبكة', visa, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniChip(String label, double value, Color color) {
    if (value <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '$label: ${fmtNum(value)}',
        style:
            TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  String _catLabel(String c) {
    switch (c) {
      case 'gold':
        return 'ذهب';
      case 'scrap':
        return 'كسر';
      case 'bullion':
        return 'سبائك';
      case 'gem':
        return 'أحجار';
      default:
        return c.isEmpty ? 'غير محدد' : c;
    }
  }

  Color _catColor(String c) {
    switch (c) {
      case 'gold':
        return const Color(0xFFD4AF37);
      case 'scrap':
        return Colors.green;
      case 'bullion':
        return Colors.blueGrey;
      case 'gem':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

// ═════════════════════════════════════════════════════════════
// ➕ شيت الإضافة
// ─────────────────────────────────────────────────────────────
// 3 أنواع:
//   • salary        → اسم الشخص + المبلغ + التاريخ
//   • daily_expense → اسم المصروف + القيمة + التاريخ + ملاحظة
//   • fixed_expense → اسم المصروف + القيمة + التاريخ + ملاحظة
//
// ✅ عند الحفظ:
//    1) يتضاف في sellerExpenses (لعرضه هنا)
//    2) يتضاف في expenses (عشان يتخصم من الصندوق تلقائياً)
// ═════════════════════════════════════════════════════════════
class _AddExpenseSheet extends StatefulWidget {
  final String uid;
  const _AddExpenseSheet({required this.uid});

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  String _type = 'salary'; // salary | daily_expense | fixed_expense
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _isSalary => _type == 'salary';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (name.isEmpty) {
      _snack(_isSalary ? 'يرجى إدخال اسم الشخص' : 'يرجى إدخال اسم المصروف',
          Colors.orange);
      return;
    }
    if (amount <= 0) {
      _snack('يرجى إدخال مبلغ صحيح', Colors.orange);
      return;
    }

    setState(() => _saving = true);
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(widget.uid);

      // ✅ 1) إضافة في sellerExpenses (لعرضها في هذه الصفحة)
      final sellerExpRef = await userDoc.collection('sellerExpenses').add({
        'type': _type,
        'name': name,
        'amount': amount,
        if (!_isSalary) 'notes': _notesController.text.trim(),
        'date': Timestamp.fromDate(_date),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ 2) إضافة في expenses (عشان تتخصم من الصندوق تلقائياً)
      final expenseTypeLabel = _isSalary
          ? 'راتب'
          : _type == 'daily_expense'
              ? 'مصروف يومي'
              : 'مصروف ثابت';

      final expenseRef = await userDoc.collection('expenses').add({
        'type': expenseTypeLabel,
        'name': name,
        'amount': amount,
        'note': _isSalary ? 'راتب: $name' : _notesController.text.trim(),
        'date': Timestamp.fromDate(_date),
        'paymentMethod': 'cash',
        // ربط عكسي — عشان لما نحذف من هنا نحذف من هناك
        'linkedSellerExpenseId': sellerExpRef.id,
        'source': 'sellers_page',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ 3) نحدّث الـ sellerExpenses بالـ linkedExpenseId
      await sellerExpRef.update({
        'linkedExpenseId': expenseRef.id,
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم الحفظ وتم خصمه من الصندوق'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _snack('❌ خطأ: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.add_circle,
                      color: Color(0xFFD4AF37), size: 24),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'إضافة جديدة',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.orange, size: 16),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'سيتم خصم المبلغ تلقائياً من إجمالي الصندوق',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ✅ اختيار النوع
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _typeBtn('راتب', Icons.payments, 'salary'),
                    ),
                    Expanded(
                      child: _typeBtn('يومي', Icons.receipt, 'daily_expense'),
                    ),
                    Expanded(
                      child:
                          _typeBtn('ثابت', Icons.receipt_long, 'fixed_expense'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: _isSalary
                      ? 'اسم الشخص'
                      : 'اسم المصروف (مثال: كهرباء، إيجار...)',
                  prefixIcon: Icon(
                    _isSalary ? Icons.person : Icons.label,
                    color: const Color(0xFFD4AF37),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText:
                      _isSalary ? 'قيمة الراتب (ر.س)' : 'قيمة المصروف (ر.س)',
                  prefixIcon: const Icon(Icons.money, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFFD4AF37)),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('yyyy/MM/dd').format(_date),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              if (!_isSalary) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'ملاحظة (اختياري)',
                    prefixIcon:
                        const Icon(Icons.note, color: Color(0xFFD4AF37)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.save),
                  label:
                      Text(_saving ? 'جاري الحفظ...' : 'حفظ وخصم من الصندوق'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeBtn(String label, IconData icon, String type) {
    final isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
