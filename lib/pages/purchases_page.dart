// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:excel/excel.dart' as xls;
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';
// import 'dart:ui' as ui;

// // ============================================================
// // 🔹 فلتر الفترة الزمنية
// // ============================================================
// enum _PeriodFilter { daily, weekly, monthly, all }

// // ============================================================
// // 🔹 صفحة المشتريات - تجميع كل المشتريات (ذهب + كسر + خام + مصنعية)
// // ============================================================
// class PurchasesPage extends StatefulWidget {
//   const PurchasesPage({super.key});

//   @override
//   State<PurchasesPage> createState() => _PurchasesPageState();
// }

// class _PurchasesPageState extends State<PurchasesPage>
//     with SingleTickerProviderStateMixin {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   late TabController _tabController;
//   bool _isLoading = true;
//   bool _isExporting = false;

//   // ✅ الفلتر الزمني
//   _PeriodFilter _period = _PeriodFilter.all;

//   // ====== ملخص الذهب ======
//   double _totalGoldWeight24 = 0;
//   double _totalGoldCost = 0;
//   double _avgGoldPrice = 0;

//   // ====== غير الذهبية ======
//   double _totalNonGoldCost = 0;
//   List<Map<String, dynamic>> _nonGoldItems = [];

//   // ====== تفصيل التكلفة ======
//   double _suppliersGoldCost = 0;
//   double _suppliersWagesCost = 0;
//   int _suppliersPaymentsCount = 0;

//   double _scrapCost = 0;
//   int _scrapCount = 0;

//   double _rawGoldCost = 0;
//   double _mintingWagesCost = 0;
//   int _mintingCount = 0;

//   // ====== الأوزان المشتراة ======
//   double _suppliersWeight = 0;
//   double _suppliersWeight24 = 0;
//   double _scrapWeight = 0;
//   double _scrapWeight24 = 0;
//   double _rawGoldWeight = 0;

//   // ====== بيانات خام للتصدير ======
//   List<Map<String, dynamic>> _suppliersVouchersRaw = [];
//   List<Map<String, dynamic>> _scrapTxRaw = [];
//   List<Map<String, dynamic>> _mintingsRaw = [];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _loadLanguage();
//     _loadData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!mounted) return;
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   // ✅ تاريخ بداية الفلتر (null = بدون فلتر)
//   DateTime? get _startDate {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     switch (_period) {
//       case _PeriodFilter.daily:
//         return today;
//       case _PeriodFilter.weekly:
//         return today.subtract(const Duration(days: 7));
//       case _PeriodFilter.monthly:
//         return DateTime(now.year, now.month, 1);
//       case _PeriodFilter.all:
//         return null;
//     }
//   }

//   // تحويل أي عيار إلى معيار 24
//   double _to24(double weight, String carat) {
//     switch (carat) {
//       case '24':
//         return weight;
//       case '22':
//         return weight * 22 / 24;
//       case '21':
//         return weight * 21 / 24;
//       case '18':
//         return weight * 18 / 24;
//       case '14':
//         return weight * 14 / 24;
//       default:
//         return weight;
//     }
//   }

//   String _fmt(double v, {int digits = 2}) => v.toStringAsFixed(digits);

//   // ============================================================
//   // 🔹 تحميل كل البيانات من Firestore
//   // ============================================================
//   Future<void> _loadData() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       final startDate = _startDate;

//       // ---------- 1) الموردين ----------
//       final suppliers = await FS.getSuppliers();
//       double sGoldCost = 0;
//       double sWages = 0;
//       double sWeight = 0;
//       double sWeight24 = 0;
//       int sCount = 0;
//       final List<Map<String, dynamic>> sRaw = [];

//       for (final sup in suppliers) {
//         final vouchers = await FS.getVouchersForSupplier(sup['id']);
//         for (final v in vouchers) {
//           if (v['type'] != 'receipt') continue;

//           // ✅ فلتر التاريخ
//           final vDate = (v['date'] as Timestamp?)?.toDate();
//           if (startDate != null && vDate != null && vDate.isBefore(startDate)) {
//             continue;
//           }

//           sCount++;

//           final goldPart =
//               ((v['goldPrice'] ?? v['total'] ?? 0) as num).toDouble();
//           final wagePart = ((v['wage'] ?? 0) as num).toDouble();
//           sGoldCost += goldPart;
//           sWages += wagePart;

//           final carats = v['carats'] as List?;
//           double vWeight = 0;
//           double vWeight24 = 0;
//           if (carats != null && carats.isNotEmpty) {
//             for (final c in carats) {
//               final carat = (c['carat'] ?? '18').toString();
//               final w = ((c['weight'] ?? 0) as num).toDouble();
//               vWeight += w;
//               vWeight24 += _to24(w, carat);
//             }
//           } else {
//             final carat = (v['carat'] ?? '18').toString();
//             final w = double.tryParse(v['weight']?.toString() ?? '0') ?? 0;
//             vWeight += w;
//             vWeight24 += _to24(w, carat);
//           }
//           sWeight += vWeight;
//           sWeight24 += vWeight24;

//           sRaw.add({
//             'supplier': sup['name'] ?? '',
//             'delegate': v['delegate'] ?? '',
//             'carat': v['carat'] ?? 'multiple',
//             'weight': vWeight,
//             'weight24': vWeight24,
//             'wage': wagePart,
//             'goldPrice': goldPart,
//             'total': ((v['total'] ?? 0) as num).toDouble(),
//             'date': vDate,
//             'type': 'قبض من مورد',
//           });
//         }
//       }

//       // ---------- 2) الكسر ----------
//       final scrapTxs = await FS.scrapTransactionsStream().first;
//       double scrapCost = 0;
//       double scrapWeight = 0;
//       double scrapWeight24 = 0;
//       int scrapCount = 0;
//       final List<Map<String, dynamic>> scRaw = [];

//       for (final t in scrapTxs) {
//         if (t['type'] == 'add') {
//           // ✅ فلتر التاريخ
//           final tDate = (t['date'] as Timestamp?)?.toDate();
//           if (startDate != null && tDate != null && tDate.isBefore(startDate)) {
//             continue;
//           }

//           scrapCount++;
//           final w = ((t['weight'] ?? 0) as num).toDouble();
//           final c = (t['carat'] ?? '18').toString();
//           final w24 = _to24(w, c);
//           final tot = ((t['total'] ?? 0) as num).toDouble();
//           scrapWeight += w;
//           scrapWeight24 += w24;
//           scrapCost += tot;

//           scRaw.add({
//             'person': t['person'] ?? '',
//             'carat': c,
//             'weight': w,
//             'weight24': w24,
//             'total': tot,
//             'cash': ((t['cash'] ?? 0) as num).toDouble(),
//             'network': ((t['network'] ?? 0) as num).toDouble(),
//             'date': tDate,
//             'notes': t['notes'] ?? '',
//             'type': 'شراء كسر',
//           });
//         }
//       }

//       // ---------- 3) التسكيرات ----------
//       final mintSnap = await FS.mintingsStream().first;
//       double rawCost = 0;
//       double mintWages = 0;
//       double rawWeight = 0;
//       int mintCount = 0;
//       final List<Map<String, dynamic>> mRaw = [];

//       for (final doc in mintSnap.docs) {
//         final data = doc.data() as Map<String, dynamic>;

//         // ✅ فلتر التاريخ
//         final mDate = (data['date'] as Timestamp?)?.toDate();
//         if (startDate != null && mDate != null && mDate.isBefore(startDate)) {
//           continue;
//         }

//         mintCount++;
//         final gc = ((data['goldPrice'] ?? 0) as num).toDouble();
//         final mw = ((data['manufacturing'] ?? 0) as num).toDouble();
//         final ww = ((data['weight'] ?? 0) as num).toDouble();
//         rawCost += gc;
//         mintWages += mw;
//         rawWeight += ww;

//         mRaw.add({
//           'id': doc.id,
//           'supplier': data['supplierName'] ?? '',
//           'office': data['officeName'] ?? '',
//           'carat': data['carat'] ?? '',
//           'weight': ww,
//           'goldPrice': gc,
//           'manufacturing': mw,
//           'paymentMethod': data['paymentMethod'] ?? '',
//           'status': data['status'] ?? 'open',
//           'date': mDate,
//           'type': 'تسكيرة',
//         });
//       }

//       // ---------- 4) المشتريات غير الذهبية ----------
//       Query nonGoldQuery = FirebaseFirestore.instance
//           .collection('non_gold_purchases')
//           .orderBy('date', descending: true);

//       // ✅ فلتر التاريخ من Firestore مباشرة
//       if (startDate != null) {
//         nonGoldQuery = nonGoldQuery.where(
//           'date',
//           isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
//         );
//       }

//       final nonGoldSnap = await nonGoldQuery.get();

//       double nonGoldCost = 0;
//       final List<Map<String, dynamic>> ngList = [];
//       for (final doc in nonGoldSnap.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         nonGoldCost += ((data['total'] ?? 0) as num).toDouble();
//         ngList.add({
//           'id': doc.id,
//           ...data,
//         });
//       }

//       // ---------- الإجماليات ----------
//       final totalGoldCost =
//           sGoldCost + sWages + scrapCost + rawCost + mintWages;
//       final totalGoldWeight24 = sWeight24 + scrapWeight24;
//       final avgPrice =
//           totalGoldWeight24 > 0 ? totalGoldCost / totalGoldWeight24 : 0.0;

//       if (!mounted) return;
//       setState(() {
//         _suppliersGoldCost = sGoldCost;
//         _suppliersWagesCost = sWages;
//         _suppliersPaymentsCount = sCount;
//         _suppliersWeight = sWeight;
//         _suppliersWeight24 = sWeight24;

//         _scrapCost = scrapCost;
//         _scrapCount = scrapCount;
//         _scrapWeight = scrapWeight;
//         _scrapWeight24 = scrapWeight24;

//         _rawGoldCost = rawCost;
//         _mintingWagesCost = mintWages;
//         _mintingCount = mintCount;
//         _rawGoldWeight = rawWeight;

//         _totalGoldCost = totalGoldCost;
//         _totalGoldWeight24 = totalGoldWeight24;
//         _avgGoldPrice = avgPrice;

//         _totalNonGoldCost = nonGoldCost;
//         _nonGoldItems = ngList;

//         _suppliersVouchersRaw = sRaw;
//         _scrapTxRaw = scRaw;
//         _mintingsRaw = mRaw;

//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint('❌ Error loading purchases: $e');
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   // ============================================================
//   // 🔹 تصدير Excel
//   // ============================================================

//   // ✅ اسم الفترة بالعربي/الإنجليزي للتصدير
//   String _periodLabel() {
//     switch (_period) {
//       case _PeriodFilter.daily:
//         return _lang == 'ar' ? 'يومي' : 'Daily';
//       case _PeriodFilter.weekly:
//         return _lang == 'ar' ? 'أسبوعي' : 'Weekly';
//       case _PeriodFilter.monthly:
//         return _lang == 'ar' ? 'شهري' : 'Monthly';
//       case _PeriodFilter.all:
//         return _lang == 'ar' ? 'الكل' : 'All';
//     }
//   }

//   // ============================================================
//   // 🔹 إضافة مشتريات غير ذهبية
//   // ============================================================
//   Future<void> _showAddNonGoldDialog() async {
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => _AddNonGoldDialog(lang: _lang),
//     );
//     if (result == true) {
//       await _loadData();
//     }
//   }

//   // ============================================================
//   // 🔹 BUILD
//   // ============================================================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F10),
//       appBar: AppBar(
//         title: Text(
//           _t('المشتريات', 'Purchases'),
//           style:
//               const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFF1A1A1A),
//         iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _isLoading ? null : _loadData,
//             tooltip: _t('تحديث', 'Refresh'),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
//           : RefreshIndicator(
//               color: const Color(0xFFD4AF37),
//               onRefresh: _loadData,
//               child: ListView(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
//                 children: [
//                   // ✅ الفلتر الزمني
//                   _buildPeriodFilter(),
//                   const SizedBox(height: 14),
//                   _buildTotalGoldCard(),
//                   const SizedBox(height: 14),
//                   _buildSmallCardsRow(),
//                   const SizedBox(height: 16),
//                   _buildTabSelector(),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 950,
//                     child: TabBarView(
//                       controller: _tabController,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         _buildGoldTab(),
//                         _buildNonGoldTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   // ============================================================
//   // 🔹 فلتر الفترة الزمنية
//   // ============================================================
//   Widget _buildPeriodFilter() {
//     return Container(
//       padding: const EdgeInsets.all(6),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Row(
//         children: [
//           _buildPeriodButton(
//             label: _t('يومي', 'Daily'),
//             icon: Icons.today,
//             period: _PeriodFilter.daily,
//           ),
//           const SizedBox(width: 6),
//           _buildPeriodButton(
//             label: _t('أسبوعي', 'Weekly'),
//             icon: Icons.date_range,
//             period: _PeriodFilter.weekly,
//           ),
//           const SizedBox(width: 6),
//           _buildPeriodButton(
//             label: _t('شهري', 'Monthly'),
//             icon: Icons.calendar_month,
//             period: _PeriodFilter.monthly,
//           ),
//           const SizedBox(width: 6),
//           _buildPeriodButton(
//             label: _t('الكل', 'All'),
//             icon: Icons.all_inclusive,
//             period: _PeriodFilter.all,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPeriodButton({
//     required String label,
//     required IconData icon,
//     required _PeriodFilter period,
//   }) {
//     final isSelected = _period == period;
//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: () {
//           if (_period == period) return;
//           setState(() => _period = period);
//           _loadData();
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
//           decoration: BoxDecoration(
//             color: isSelected
//                 ? const Color(0xFFD4AF37).withOpacity(0.15)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 icon,
//                 size: 18,
//                 color:
//                     isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade500,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11.5,
//                   fontWeight: FontWeight.bold,
//                   color: isSelected
//                       ? const Color(0xFFD4AF37)
//                       : Colors.grey.shade500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 بطاقة الشرح
//   // ============================================================

//   // ============================================================
//   // 🔹 بطاقة إجمالي مشتريات الذهب
//   // ============================================================
//   Widget _buildTotalGoldCard() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF1F1B14),
//             const Color(0xFF161412),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: const Color(0xFFD4AF37).withOpacity(0.25),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             _t('إجمالي مشتريات الذهب', 'Total Gold Purchases'),
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade300,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 '${_fmt(_totalGoldCost)} ',
//                 style: const TextStyle(
//                   fontSize: 34,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFD4AF37),
//                 ),
//               ),
//               Text(
//                 _t('ر.س', 'SAR'),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFFD4AF37),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _t(
//               '${_fmt(_totalGoldWeight24, digits: 2)} جم بمعيار 24  •  متوسط التكلفة ${_fmt(_avgGoldPrice)} ريال/جم',
//               '${_fmt(_totalGoldWeight24, digits: 2)} g @ 24K  •  Avg cost ${_fmt(_avgGoldPrice)} SAR/g',
//             ),
//             textAlign: TextAlign.right,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 بطاقتين صغيرتين
//   // ============================================================
//   Widget _buildSmallCardsRow() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildMiniCard(
//             title: _t('إجمالي كل المشتريات', 'All Purchases'),
//             value: _totalGoldCost + _totalNonGoldCost,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildMiniCard(
//             title: _t('مشتريات غير ذهبية', 'Non-Gold Purchases'),
//             value: _totalNonGoldCost,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMiniCard({required String title, required double value}) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 12.5,
//               color: Colors.grey.shade400,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '${_fmt(value)} ${_t('ر.س', 'SAR')}',
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 أزرار التبويب
//   // ============================================================
//   Widget _buildTabSelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(
//           color: const Color(0xFFD4AF37).withOpacity(0.15),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: const Color(0xFFD4AF37)),
//         ),
//         indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelColor: const Color(0xFFD4AF37),
//         unselectedLabelColor: Colors.grey.shade500,
//         labelStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//         tabs: [
//           Tab(text: _t('مشتريات الذهب', 'Gold Purchases')),
//           Tab(text: _t('غير ذهبية', 'Non-Gold')),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 التبويب الأول: مشتريات الذهب
//   // ============================================================
//   Widget _buildGoldTab() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       physics: const NeverScrollableScrollPhysics(),
//       children: [
//         _buildCostBreakdownCard(),
//         const SizedBox(height: 14),
//         _buildWeightsCard(),
//         const SizedBox(height: 14),
//         _buildPaymentsCountFooter(),
//       ],
//     );
//   }

//   // ============================================================
//   // 🔹 بطاقة تفصيل التكلفة
//   // ============================================================
//   Widget _buildCostBreakdownCard() {
//     return _buildSectionCard(
//       title: _t('تفصيل تكلفة الذهب', 'Gold Cost Breakdown'),
//       children: [
//         _buildRow(
//           label: _t('ذهب من الموردين ($_suppliersPaymentsCount دفعة)',
//               'Gold from suppliers ($_suppliersPaymentsCount payments)'),
//           value: _suppliersGoldCost,
//         ),
//         _buildRow(
//           label: _t('أجور ومصنعية الموردين', 'Suppliers wages'),
//           value: _suppliersWagesCost,
//         ),
//         _buildRow(
//           label: _t('شراء كسر ($_scrapCount عملية)',
//               'Scrap purchases ($_scrapCount)'),
//           value: _scrapCost,
//         ),
//         _buildRow(
//           label: _t('شراء ذهب خام للتسكير', 'Raw gold for minting'),
//           value: _rawGoldCost,
//         ),
//         _buildRow(
//           label: _t('أجور التسكير', 'Minting wages'),
//           value: _mintingWagesCost,
//         ),
//         const Divider(color: Color(0xFF2A2A2A), height: 20),
//         _buildRow(
//           label: _t('الإجمالي', 'Total'),
//           value: _totalGoldCost,
//           highlight: true,
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // 🔹 بطاقة الأوزان
//   // ============================================================
//   Widget _buildWeightsCard() {
//     return _buildSectionCard(
//       title: _t('الأوزان المشتراة', 'Purchased Weights'),
//       children: [
//         _buildWeightRow(
//           label: _t('من الموردين', 'From suppliers'),
//           weight: _suppliersWeight,
//           weight24: _suppliersWeight24,
//         ),
//         _buildWeightRow(
//           label: _t('كسر', 'Scrap'),
//           weight: _scrapWeight,
//           weight24: _scrapWeight24,
//         ),
//         _buildWeightRow(
//           label: _t('ذهب خام', 'Raw gold'),
//           weight: _rawGoldWeight,
//           weight24: null,
//         ),
//         const Divider(color: Color(0xFF2A2A2A), height: 20),
//         _buildWeightRow(
//           label: _t('الإجمالي بمعيار 24', 'Total @ 24K'),
//           weight: null,
//           weight24: _totalGoldWeight24,
//           highlight: true,
//         ),
//       ],
//     );
//   }

//   Widget _buildPaymentsCountFooter() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         _t('دفعات الموردين ($_suppliersPaymentsCount)',
//             'Supplier Payments ($_suppliersPaymentsCount)'),
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.grey.shade600,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 التبويب الثاني: غير ذهبية
//   // ============================================================
//   Widget _buildNonGoldTab() {
//     if (_nonGoldItems.isEmpty) {
//       return ListView(
//         padding: EdgeInsets.zero,
//         physics: const NeverScrollableScrollPhysics(),
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
//             child: Column(
//               children: [
//                 Icon(Icons.inventory_2_outlined,
//                     size: 64, color: Colors.grey.shade700),
//                 const SizedBox(height: 16),
//                 Text(
//                   _t('لا توجد مشتريات غير ذهبية', 'No non-gold purchases yet'),
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _t('سجّل التحف والعدد والأدوات من هنا',
//                       'Record artifacts, tools, and supplies here'),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD4AF37),
//                     foregroundColor: Colors.black,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: _showAddNonGoldDialog,
//                   icon: const Icon(Icons.add),
//                   label: Text(
//                       _t('إضافة مشتريات غير ذهبية', 'Add Non-Gold Purchase')),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     }

//     return ListView(
//       padding: EdgeInsets.zero,
//       physics: const NeverScrollableScrollPhysics(),
//       children: [
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1A1A1A),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: const Color(0xFF2A2A2A)),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.inventory_2, color: Color(0xFFD4AF37)),
//               const SizedBox(width: 10),
//               Text(
//                 _t('إجمالي غير الذهبية', 'Non-Gold Total'),
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade300,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 '${_fmt(_totalNonGoldCost)} ${_t('ر.س', 'SAR')}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFD4AF37),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         ..._nonGoldItems.map((item) => _buildNonGoldItemCard(item)),
//       ],
//     );
//   }

//   Widget _buildNonGoldItemCard(Map<String, dynamic> item) {
//     final name = (item['name'] ?? '').toString();
//     final category = (item['category'] ?? '').toString();
//     final quantity = ((item['quantity'] ?? 0) as num).toDouble();
//     final unit = (item['unit'] ?? '').toString();
//     final unitPrice = ((item['unitPrice'] ?? 0) as num).toDouble();
//     final total = ((item['total'] ?? 0) as num).toDouble();
//     final supplier = (item['supplier'] ?? '').toString();
//     final notes = (item['notes'] ?? '').toString();
//     final d = item['date'];
//     DateTime? dt;
//     if (d is Timestamp) dt = d.toDate();

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFD4AF37).withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   category,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFD4AF37),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Text(
//                 '${_fmt(total)} ${_t('ر.س', 'SAR')}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFD4AF37),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 12,
//             runSpacing: 4,
//             children: [
//               if (quantity > 0)
//                 Text(
//                   '${_t('الكمية', 'Qty')}: ${_fmt(quantity, digits: 0)} $unit',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
//                 ),
//               if (unitPrice > 0)
//                 Text(
//                   '${_t('سعر الوحدة', 'Unit')}: ${_fmt(unitPrice)}',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
//                 ),
//               if (supplier.isNotEmpty)
//                 Text(
//                   '${_t('المورد', 'Supplier')}: $supplier',
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
//                 ),
//               if (dt != null)
//                 Text(
//                   DateFormat('yyyy-MM-dd').format(dt),
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                 ),
//             ],
//           ),
//           if (notes.isNotEmpty) ...[
//             const SizedBox(height: 6),
//             Text(
//               notes,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade500,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 عناصر مساعدة
//   // ============================================================
//   Widget _buildSectionCard({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A1A),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             title,
//             textAlign: TextAlign.right,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFFD4AF37),
//             ),
//           ),
//           const SizedBox(height: 14),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildRow({
//     required String label,
//     required double value,
//     bool highlight = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: highlight ? Colors.white : Colors.grey.shade400,
//                 fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//           Text(
//             '${_fmt(value)} ${_t('ر.س', 'SAR')}',
//             style: TextStyle(
//               fontSize: highlight ? 16 : 14,
//               fontWeight: FontWeight.bold,
//               color: highlight ? const Color(0xFFD4AF37) : Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeightRow({
//     required String label,
//     double? weight,
//     double? weight24,
//     bool highlight = false,
//   }) {
//     String value;
//     if (weight24 != null && weight != null) {
//       value =
//           '${_fmt(weight, digits: 2)} جم (${_fmt(weight24, digits: 2)} بمعيار 24)';
//     } else if (weight24 != null) {
//       value = '${_fmt(weight24, digits: 2)} جم';
//     } else {
//       value = '${_fmt(weight ?? 0, digits: 2)} جم';
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: highlight ? Colors.white : Colors.grey.shade400,
//                 fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: highlight ? 15 : 13,
//               fontWeight: FontWeight.bold,
//               color: highlight ? const Color(0xFFD4AF37) : Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 حوار إضافة مشتريات غير ذهبية
// // ============================================================
// class _AddNonGoldDialog extends StatefulWidget {
//   final String lang;
//   const _AddNonGoldDialog({required this.lang});

//   @override
//   State<_AddNonGoldDialog> createState() => _AddNonGoldDialogState();
// }

// class _AddNonGoldDialogState extends State<_AddNonGoldDialog> {
//   String get _lang => widget.lang;
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _qtyCtrl = TextEditingController(text: '1');
//   final _unitPriceCtrl = TextEditingController();
//   final _supplierCtrl = TextEditingController();
//   final _notesCtrl = TextEditingController();

//   String _category = 'تحف فنية';
//   String _unit = 'قطعة';
//   DateTime _date = DateTime.now();
//   bool _saving = false;

//   static const _categories = [
//     'تحف فنية',
//     'عدد وأدوات',
//     'خامات',
//     'مستلزمات تغليف',
//     'أخرى',
//   ];

//   static const _units = ['قطعة', 'علبة', 'كرتونة', 'كجم', 'لتر', 'متر'];

//   double get _total {
//     final q = double.tryParse(_qtyCtrl.text) ?? 0;
//     final p = double.tryParse(_unitPriceCtrl.text) ?? 0;
//     return q * p;
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _qtyCtrl.dispose();
//     _unitPriceCtrl.dispose();
//     _supplierCtrl.dispose();
//     _notesCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _save() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _saving = true);
//     try {
//       await FirebaseFirestore.instance.collection('non_gold_purchases').add({
//         'name': _nameCtrl.text.trim(),
//         'category': _category,
//         'quantity': double.tryParse(_qtyCtrl.text) ?? 0,
//         'unit': _unit,
//         'unitPrice': double.tryParse(_unitPriceCtrl.text) ?? 0,
//         'total': _total,
//         'supplier': _supplierCtrl.text.trim(),
//         'notes': _notesCtrl.text.trim(),
//         'date': Timestamp.fromDate(_date),
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 _t('✅ تم إضافة الير الذهبية', '✅ Non-gold purchase added')),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context, true);
//       }
//     } catch (e) {
//       debugPrint('❌ Save error: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_t('❌ فشل الحفظ: $e', '❌ Save failed: $e')),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _saving = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat('yyyy-MM-dd');
//     return Directionality(
//       textDirection:
//           _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
//       child: AlertDialog(
//         backgroundColor: const Color(0xFF1A1A1A),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Row(
//           children: [
//             const Icon(Icons.inventory_2, color: Color(0xFFD4AF37)),
//             const SizedBox(width: 10),
//             Text(
//               _t('مشتريات غير ذهبية', 'Non-Gold Purchase'),
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.9,
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _field(
//                     controller: _nameCtrl,
//                     label: _t('اسم الصنف', 'Item name'),
//                     icon: Icons.label_outline,
//                     validator: (v) => v == null || v.trim().isEmpty
//                         ? _t('مطلوب', 'Required')
//                         : null,
//                   ),
//                   const SizedBox(height: 12),
//                   DropdownButtonFormField<String>(
//                     value: _category,
//                     dropdownColor: const Color(0xFF1A1A1A),
//                     style: const TextStyle(color: Colors.white),
//                     decoration: _deco(
//                       label: _t('التصنيف', 'Category'),
//                       icon: Icons.category_outlined,
//                     ),
//                     items: _categories
//                         .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//                         .toList(),
//                     onChanged: (v) =>
//                         setState(() => _category = v ?? _category),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _field(
//                           controller: _qtyCtrl,
//                           label: _t('الكمية', 'Quantity'),
//                           icon: Icons.numbers,
//                           keyboard: TextInputType.number,
//                           validator: (v) {
//                             final n = double.tryParse(v ?? '');
//                             if (n == null || n <= 0) {
//                               return _t('رقم غير صحيح', 'Invalid');
//                             }
//                             return null;
//                           },
//                           onChanged: (_) => setState(() {}),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           value: _unit,
//                           dropdownColor: const Color(0xFF1A1A1A),
//                           style: const TextStyle(color: Colors.white),
//                           decoration: _deco(
//                             label: _t('الوحدة', 'Unit'),
//                             icon: Icons.straighten,
//                           ),
//                           items: _units
//                               .map((u) =>
//                                   DropdownMenuItem(value: u, child: Text(u)))
//                               .toList(),
//                           onChanged: (v) => setState(() => _unit = v ?? _unit),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   _field(
//                     controller: _unitPriceCtrl,
//                     label: _t('سعر الوحدة (ر.س)', 'Unit price (SAR)'),
//                     icon: Icons.attach_money,
//                     keyboard: TextInputType.number,
//                     validator: (v) {
//                       final n = double.tryParse(v ?? '');
//                       if (n == null || n < 0) {
//                         return _t('رقم غير صحيح', 'Invalid');
//                       }
//                       return null;
//                     },
//                     onChanged: (_) => setState(() {}),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFD4AF37).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: const Color(0xFFD4AF37).withOpacity(0.3)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _t('الإجمالي', 'Total'),
//                           style: const TextStyle(
//                             color: Color(0xFFD4AF37),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           '${_total.toStringAsFixed(2)} ${_t('ر.س', 'SAR')}',
//                           style: const TextStyle(
//                             color: Color(0xFFD4AF37),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _field(
//                     controller: _supplierCtrl,
//                     label: _t('المورد (اختياري)', 'Supplier (optional)'),
//                     icon: Icons.business,
//                   ),
//                   const SizedBox(height: 12),
//                   InkWell(
//                     onTap: () async {
//                       final d = await showDatePicker(
//                         context: context,
//                         initialDate: _date,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime(2100),
//                       );
//                       if (d != null) setState(() => _date = d);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade700),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.calendar_today,
//                               color: Color(0xFFD4AF37), size: 20),
//                           const SizedBox(width: 10),
//                           Text(
//                             '${_t('التاريخ', 'Date')}: ${df.format(_date)}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _field(
//                     controller: _notesCtrl,
//                     label: _t('ملاحظات (اختياري)', 'Notes (optional)'),
//                     icon: Icons.note_outlined,
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _saving ? null : () => Navigator.pop(context, false),
//             child: Text(
//               _t('إلغاء', 'Cancel'),
//               style: TextStyle(color: Colors.grey.shade400),
//             ),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFD4AF37),
//               foregroundColor: Colors.black,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: _saving ? null : _save,
//             child: _saving
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.black,
//                     ),
//                   )
//                 : Text(
//                     _t('حفظ', 'Save'),
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   InputDecoration _deco({required String label, required IconData icon}) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: Colors.grey.shade400),
//       prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade700),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFFD4AF37)),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Colors.red),
//       ),
//     );
//   }

//   Widget _field({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType? keyboard,
//     String? Function(String?)? validator,
//     void Function(String)? onChanged,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboard,
//       validator: validator,
//       onChanged: onChanged,
//       maxLines: maxLines,
//       style: const TextStyle(color: Colors.white),
//       decoration: _deco(label: label, icon: icon),
//     );
//   }
// }
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as xls;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import 'dart:ui' as ui;

// ============================================================
// 🔹 فلتر الفترة الزمنية
// ============================================================
enum _PeriodFilter { daily, weekly, monthly, all }

// ============================================================
// 🔹 صفحة المشتريات - تجميع كل المشتريات (ذهب + كسر + خام + مصنعية)
// ============================================================
class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage>
    with SingleTickerProviderStateMixin {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  late TabController _tabController;
  bool _isLoading = true;
  bool _isExporting = false;

  // ✅ الفلتر الزمني
  _PeriodFilter _period = _PeriodFilter.all;

  // ====== ملخص الذهب ======
  double _totalGoldWeight24 = 0;
  double _totalGoldCost = 0;
  double _avgGoldPrice = 0;

  // ====== غير الذهبية ======
  double _totalNonGoldCost = 0;
  List<Map<String, dynamic>> _nonGoldItems = [];

  // ====== تفصيل التكلفة ======
  double _suppliersGoldCost = 0;
  double _suppliersWagesCost = 0;
  int _suppliersPaymentsCount = 0;

  double _scrapCost = 0;
  int _scrapCount = 0;

  double _rawGoldCost = 0;
  double _mintingWagesCost = 0;
  int _mintingCount = 0;

  // ====== الأوزان المشتراة ======
  double _suppliersWeight = 0;
  double _suppliersWeight24 = 0;
  double _scrapWeight = 0;
  double _scrapWeight24 = 0;
  double _rawGoldWeight = 0;

  // ====== بيانات خام للتصدير ======
  List<Map<String, dynamic>> _suppliersVouchersRaw = [];
  List<Map<String, dynamic>> _scrapTxRaw = [];
  List<Map<String, dynamic>> _mintingsRaw = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLanguage();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  // ✅ تاريخ بداية الفلتر (null = بدون فلتر)
  DateTime? get _startDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (_period) {
      case _PeriodFilter.daily:
        return today;
      case _PeriodFilter.weekly:
        return today.subtract(const Duration(days: 7));
      case _PeriodFilter.monthly:
        return DateTime(now.year, now.month, 1);
      case _PeriodFilter.all:
        return null;
    }
  }

  // تحويل أي عيار إلى معيار 24
  double _to24(double weight, String carat) {
    switch (carat) {
      case '24':
        return weight;
      case '22':
        return weight * 22 / 24;
      case '21':
        return weight * 21 / 24;
      case '18':
        return weight * 18 / 24;
      case '14':
        return weight * 14 / 24;
      default:
        return weight;
    }
  }

  // ✅ تحويل من معيار 24 إلى معيار 21
  double _to21(double weight24) {
    return weight24 * 24 / 21;
  }

  String _fmt(double v, {int digits = 2}) => v.toStringAsFixed(digits);

  // ============================================================
  // 🔹 تحميل كل البيانات من Firestore
  // ============================================================
  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final startDate = _startDate;

      // ---------- 1) الموردين ----------
      final suppliers = await FS.getSuppliers();
      double sGoldCost = 0;
      double sWages = 0;
      double sWeight = 0;
      double sWeight24 = 0;
      int sCount = 0;
      final List<Map<String, dynamic>> sRaw = [];

      for (final sup in suppliers) {
        final vouchers = await FS.getVouchersForSupplier(sup['id']);
        for (final v in vouchers) {
          if (v['type'] != 'receipt') continue;

          // ✅ فلتر التاريخ
          final vDate = (v['date'] as Timestamp?)?.toDate();
          if (startDate != null && vDate != null && vDate.isBefore(startDate)) {
            continue;
          }

          sCount++;

          final goldPart =
              ((v['goldPrice'] ?? v['total'] ?? 0) as num).toDouble();
          final wagePart = ((v['wage'] ?? 0) as num).toDouble();
          sGoldCost += goldPart;
          sWages += wagePart;

          final carats = v['carats'] as List?;
          double vWeight = 0;
          double vWeight24 = 0;
          if (carats != null && carats.isNotEmpty) {
            for (final c in carats) {
              final carat = (c['carat'] ?? '18').toString();
              final w = ((c['weight'] ?? 0) as num).toDouble();
              vWeight += w;
              vWeight24 += _to24(w, carat);
            }
          } else {
            final carat = (v['carat'] ?? '18').toString();
            final w = double.tryParse(v['weight']?.toString() ?? '0') ?? 0;
            vWeight += w;
            vWeight24 += _to24(w, carat);
          }
          sWeight += vWeight;
          sWeight24 += vWeight24;

          sRaw.add({
            'supplier': sup['name'] ?? '',
            'delegate': v['delegate'] ?? '',
            'carat': v['carat'] ?? 'multiple',
            'weight': vWeight,
            'weight24': vWeight24,
            'wage': wagePart,
            'goldPrice': goldPart,
            'total': ((v['total'] ?? 0) as num).toDouble(),
            'date': vDate,
            'type': 'قبض من مورد',
          });
        }
      }

      // ---------- 2) الكسر ----------
      final scrapTxs = await FS.scrapTransactionsStream().first;
      double scrapCost = 0;
      double scrapWeight = 0;
      double scrapWeight24 = 0;
      int scrapCount = 0;
      final List<Map<String, dynamic>> scRaw = [];

      for (final t in scrapTxs) {
        if (t['type'] == 'add') {
          // ✅ فلتر التاريخ
          final tDate = (t['date'] as Timestamp?)?.toDate();
          if (startDate != null && tDate != null && tDate.isBefore(startDate)) {
            continue;
          }

          scrapCount++;
          final w = ((t['weight'] ?? 0) as num).toDouble();
          final c = (t['carat'] ?? '18').toString();
          final w24 = _to24(w, c);
          final tot = ((t['total'] ?? 0) as num).toDouble();
          scrapWeight += w;
          scrapWeight24 += w24;
          scrapCost += tot;

          scRaw.add({
            'person': t['person'] ?? '',
            'carat': c,
            'weight': w,
            'weight24': w24,
            'total': tot,
            'cash': ((t['cash'] ?? 0) as num).toDouble(),
            'network': ((t['network'] ?? 0) as num).toDouble(),
            'date': tDate,
            'notes': t['notes'] ?? '',
            'type': 'شراء كسر',
          });
        }
      }

      // ---------- 3) التسكيرات ----------
      final mintSnap = await FS.mintingsStream().first;
      double rawCost = 0;
      double mintWages = 0;
      double rawWeight = 0;
      int mintCount = 0;
      final List<Map<String, dynamic>> mRaw = [];

      for (final doc in mintSnap.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // ✅ فلتر التاريخ
        final mDate = (data['date'] as Timestamp?)?.toDate();
        if (startDate != null && mDate != null && mDate.isBefore(startDate)) {
          continue;
        }

        mintCount++;
        final gc = ((data['goldPrice'] ?? 0) as num).toDouble();
        final mw = ((data['manufacturing'] ?? 0) as num).toDouble();
        final ww = ((data['weight'] ?? 0) as num).toDouble();
        rawCost += gc;
        mintWages += mw;
        rawWeight += ww;

        mRaw.add({
          'id': doc.id,
          'supplier': data['supplierName'] ?? '',
          'office': data['officeName'] ?? '',
          'carat': data['carat'] ?? '',
          'weight': ww,
          'goldPrice': gc,
          'manufacturing': mw,
          'paymentMethod': data['paymentMethod'] ?? '',
          'status': data['status'] ?? 'open',
          'date': mDate,
          'type': 'تسكيرة',
        });
      }

      // ---------- 4) المشتريات غير الذهبية ----------
      Query nonGoldQuery = FirebaseFirestore.instance
          .collection('non_gold_purchases')
          .orderBy('date', descending: true);

      // ✅ فلتر التاريخ من Firestore مباشرة
      if (startDate != null) {
        nonGoldQuery = nonGoldQuery.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }

      final nonGoldSnap = await nonGoldQuery.get();

      double nonGoldCost = 0;
      final List<Map<String, dynamic>> ngList = [];
      for (final doc in nonGoldSnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        nonGoldCost += ((data['total'] ?? 0) as num).toDouble();
        ngList.add({
          'id': doc.id,
          ...data,
        });
      }

      // ---------- الإجماليات ----------
      final totalGoldCost =
          sGoldCost + sWages + scrapCost + rawCost + mintWages;
      final totalGoldWeight24 = sWeight24 + scrapWeight24;
      final avgPrice =
          totalGoldWeight24 > 0 ? totalGoldCost / totalGoldWeight24 : 0.0;

      if (!mounted) return;
      setState(() {
        _suppliersGoldCost = sGoldCost;
        _suppliersWagesCost = sWages;
        _suppliersPaymentsCount = sCount;
        _suppliersWeight = sWeight;
        _suppliersWeight24 = sWeight24;

        _scrapCost = scrapCost;
        _scrapCount = scrapCount;
        _scrapWeight = scrapWeight;
        _scrapWeight24 = scrapWeight24;

        _rawGoldCost = rawCost;
        _mintingWagesCost = mintWages;
        _mintingCount = mintCount;
        _rawGoldWeight = rawWeight;

        _totalGoldCost = totalGoldCost;
        _totalGoldWeight24 = totalGoldWeight24;
        _avgGoldPrice = avgPrice;

        _totalNonGoldCost = nonGoldCost;
        _nonGoldItems = ngList;

        _suppliersVouchersRaw = sRaw;
        _scrapTxRaw = scRaw;
        _mintingsRaw = mRaw;

        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error loading purchases: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ============================================================
  // 🔹 إضافة مشتريات غير ذهبية
  // ============================================================
  Future<void> _showAddNonGoldDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AddNonGoldDialog(lang: _lang),
    );
    if (result == true) {
      await _loadData();
    }
  }

  // ============================================================
  // 🔹 BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        title: Text(
          _t('المشتريات', 'Purchases'),
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: _t('تحديث', 'Refresh'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)))
          : RefreshIndicator(
              color: const Color(0xFFD4AF37),
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                children: [
                  // ✅ الفلتر الزمني
                  _buildPeriodFilter(),
                  const SizedBox(height: 14),
                  _buildTotalGoldCard(),
                  const SizedBox(height: 14),
                  _buildSmallCardsRow(),
                  const SizedBox(height: 16),
                  _buildTabSelector(),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 950,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildGoldTab(),
                        _buildNonGoldTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ============================================================
  // 🔹 فلتر الفترة الزمنية
  // ============================================================
  Widget _buildPeriodFilter() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          _buildPeriodButton(
            label: _t('يومي', 'Daily'),
            icon: Icons.today,
            period: _PeriodFilter.daily,
          ),
          const SizedBox(width: 6),
          _buildPeriodButton(
            label: _t('أسبوعي', 'Weekly'),
            icon: Icons.date_range,
            period: _PeriodFilter.weekly,
          ),
          const SizedBox(width: 6),
          _buildPeriodButton(
            label: _t('شهري', 'Monthly'),
            icon: Icons.calendar_month,
            period: _PeriodFilter.monthly,
          ),
          const SizedBox(width: 6),
          _buildPeriodButton(
            label: _t('الكل', 'All'),
            icon: Icons.all_inclusive,
            period: _PeriodFilter.all,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton({
    required String label,
    required IconData icon,
    required _PeriodFilter period,
  }) {
    final isSelected = _period == period;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (_period == period) return;
          setState(() => _period = period);
          _loadData();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37).withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color:
                    isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade500,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 بطاقة إجمالي مشتريات الذهب (تم تحسين شكلها)
  // ============================================================
  Widget _buildTotalGoldCard() {
    final totalWeight21 = _to21(_totalGoldWeight24);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1F1B14),
            const Color(0xFF161412),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _t('إجمالي مشتريات الذهب', 'Total Gold Purchases'),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${_fmt(_totalGoldCost)} ',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
              Text(
                _t('ر.س', 'SAR'),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildWeightBadge(
                  title: _t('وزن عيار 24', '24K Weight'),
                  value: _totalGoldWeight24,
                  color: const Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildWeightBadge(
                  title: _t('وزن عيار 21', '21K Weight'),
                  value: totalWeight21,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _t(
              'متوسط التكلفة ${_fmt(_avgGoldPrice)} ريال/جم',
              'Avg cost ${_fmt(_avgGoldPrice)} SAR/g',
            ),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightBadge({
    required String title,
    required double value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 11, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            '${_fmt(value)} جم',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 بطاقتين صغيرتين
  // ============================================================
  Widget _buildSmallCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMiniCard(
            title: _t('إجمالي كل المشتريات', 'All Purchases'),
            value: _totalGoldCost + _totalNonGoldCost,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniCard(
            title: _t('مشتريات غير ذهبية', 'Non-Gold Purchases'),
            value: _totalNonGoldCost,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({required String title, required double value}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_fmt(value)} ${_t('ر.س', 'SAR')}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 أزرار التبويب
  // ============================================================
  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFD4AF37).withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFD4AF37)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFFD4AF37),
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: [
          Tab(text: _t('مشتريات الذهب', 'Gold Purchases')),
          Tab(text: _t('غير ذهبية', 'Non-Gold')),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 التبويب الأول: مشتريات الذهب
  // ============================================================
  Widget _buildGoldTab() {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCostBreakdownCard(),
        const SizedBox(height: 14),
        _buildWeightsCard(),
        const SizedBox(height: 14),
        _buildPaymentsCountFooter(),
      ],
    );
  }

  // ============================================================
  // 🔹 بطاقة تفصيل التكلفة
  // ============================================================
  Widget _buildCostBreakdownCard() {
    return _buildSectionCard(
      title: _t('تفصيل تكلفة الذهب', 'Gold Cost Breakdown'),
      children: [
        _buildRow(
          label: _t('ذهب من الموردين ($_suppliersPaymentsCount دفعة)',
              'Gold from suppliers ($_suppliersPaymentsCount payments)'),
          value: _suppliersGoldCost,
        ),
        _buildRow(
          label: _t('أجور ومصنعية الموردين', 'Suppliers wages'),
          value: _suppliersWagesCost,
        ),
        _buildRow(
          label: _t('شراء كسر ($_scrapCount عملية)',
              'Scrap purchases ($_scrapCount)'),
          value: _scrapCost,
        ),
        _buildRow(
          label: _t('شراء ذهب خام للتسكير', 'Raw gold for minting'),
          value: _rawGoldCost,
        ),
        _buildRow(
          label: _t('أجور التسكير', 'Minting wages'),
          value: _mintingWagesCost,
        ),
        const Divider(color: Color(0xFF2A2A2A), height: 20),
        _buildRow(
          label: _t('الإجمالي', 'Total'),
          value: _totalGoldCost,
          highlight: true,
        ),
      ],
    );
  }

  // ============================================================
  // 🔹 بطاقة الأوزان (تم تحسين شكلها بالكامل)
  // ============================================================
  Widget _buildWeightsCard() {
    return _buildSectionCard(
      title: _t('الأوزان المشتراة', 'Purchased Weights'),
      children: [
        _buildWeightRow(
          label: _t('من الموردين', 'From suppliers'),
          weight: _suppliersWeight,
          weight24: _suppliersWeight24,
        ),
        _buildWeightRow(
          label: _t('كسر', 'Scrap'),
          weight: _scrapWeight,
          weight24: _scrapWeight24,
        ),
        _buildWeightRow(
          label: _t('ذهب خام', 'Raw gold'),
          weight: _rawGoldWeight,
          weight24: null,
        ),
        const Divider(color: Color(0xFF2A2A2A), height: 20),
        _buildWeightRow(
          label: _t('الإجمالي', 'Total'),
          weight: null,
          weight24: _totalGoldWeight24,
          highlight: true,
        ),
      ],
    );
  }

  Widget _buildPaymentsCountFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        _t('دفعات الموردين ($_suppliersPaymentsCount)',
            'Supplier Payments ($_suppliersPaymentsCount)'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 التبويب الثاني: غير ذهبية
  // ============================================================
  Widget _buildNonGoldTab() {
    if (_nonGoldItems.isEmpty) {
      return ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: Colors.grey.shade700),
                const SizedBox(height: 16),
                Text(
                  _t('لا توجد مشتريات غير ذهبية', 'No non-gold purchases yet'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _t('سجّل التحف والعدد والأدوات من هنا',
                      'Record artifacts, tools, and supplies here'),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showAddNonGoldDialog,
                  icon: const Icon(Icons.add),
                  label: Text(
                      _t('إضافة مشتريات غير ذهبية', 'Add Non-Gold Purchase')),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.inventory_2, color: Color(0xFFD4AF37)),
              const SizedBox(width: 10),
              Text(
                _t('إجمالي غير الذهبية', 'Non-Gold Total'),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                ),
              ),
              const Spacer(),
              Text(
                '${_fmt(_totalNonGoldCost)} ${_t('ر.س', 'SAR')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._nonGoldItems.map((item) => _buildNonGoldItemCard(item)),
      ],
    );
  }

  Widget _buildNonGoldItemCard(Map<String, dynamic> item) {
    final name = (item['name'] ?? '').toString();
    final category = (item['category'] ?? '').toString();
    final quantity = ((item['quantity'] ?? 0) as num).toDouble();
    final unit = (item['unit'] ?? '').toString();
    final unitPrice = ((item['unitPrice'] ?? 0) as num).toDouble();
    final total = ((item['total'] ?? 0) as num).toDouble();
    final supplier = (item['supplier'] ?? '').toString();
    final notes = (item['notes'] ?? '').toString();
    final d = item['date'];
    DateTime? dt;
    if (d is Timestamp) dt = d.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${_fmt(total)} ${_t('ر.س', 'SAR')}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              if (quantity > 0)
                Text(
                  '${_t('الكمية', 'Qty')}: ${_fmt(quantity, digits: 0)} $unit',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              if (unitPrice > 0)
                Text(
                  '${_t('سعر الوحدة', 'Unit')}: ${_fmt(unitPrice)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              if (supplier.isNotEmpty)
                Text(
                  '${_t('المورد', 'Supplier')}: $supplier',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              if (dt != null)
                Text(
                  DateFormat('yyyy-MM-dd').format(dt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
            ],
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              notes,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 عناصر مساعدة
  // ============================================================
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required double value,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: highlight ? Colors.white : Colors.grey.shade400,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '${_fmt(value)} ${_t('ر.س', 'SAR')}',
            style: TextStyle(
              fontSize: highlight ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: highlight ? const Color(0xFFD4AF37) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ التصميم الجديد لصف الوزن (بادجات منفصلة ومريحة للعين)
  Widget _buildWeightRow({
    required String label,
    double? weight,
    double? weight24,
    bool highlight = false,
  }) {
    if (weight24 == null) {
      // حالة الذهب الخام (بدون تحويل عيارات)
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${_fmt(weight ?? 0)} جم',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    final weight21 = _to21(weight24);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFD4AF37).withOpacity(0.1)
            : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(12),
        border: highlight
            ? Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5))
            : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
                  color: highlight ? const Color(0xFFD4AF37) : Colors.white,
                ),
              ),
              if (weight != null)
                Text(
                  '${_fmt(weight)} جم',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: highlight ? const Color(0xFFD4AF37) : Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInnerBadge(
                  'عيار 24',
                  '${_fmt(weight24)} جم',
                  const Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInnerBadge(
                  'عيار 21',
                  '${_fmt(weight21)} جم',
                  Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInnerBadge(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: color)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 🔹 حوار إضافة مشتريات غير ذهبية
// ============================================================
class _AddNonGoldDialog extends StatefulWidget {
  final String lang;
  const _AddNonGoldDialog({required this.lang});

  @override
  State<_AddNonGoldDialog> createState() => _AddNonGoldDialogState();
}

class _AddNonGoldDialogState extends State<_AddNonGoldDialog> {
  String get _lang => widget.lang;
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: '1');
  final _unitPriceCtrl = TextEditingController();
  final _supplierCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _category = 'تحف فنية';
  String _unit = 'قطعة';
  DateTime _date = DateTime.now();
  bool _saving = false;

  static const _categories = [
    'تحف فنية',
    'عدد وأدوات',
    'خامات',
    'مستلزمات تغليف',
    'أخرى',
  ];

  static const _units = ['قطعة', 'علبة', 'كرتونة', 'كجم', 'لتر', 'متر'];

  double get _total {
    final q = double.tryParse(_qtyCtrl.text) ?? 0;
    final p = double.tryParse(_unitPriceCtrl.text) ?? 0;
    return q * p;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _unitPriceCtrl.dispose();
    _supplierCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('non_gold_purchases').add({
        'name': _nameCtrl.text.trim(),
        'category': _category,
        'quantity': double.tryParse(_qtyCtrl.text) ?? 0,
        'unit': _unit,
        'unitPrice': double.tryParse(_unitPriceCtrl.text) ?? 0,
        'total': _total,
        'supplier': _supplierCtrl.text.trim(),
        'notes': _notesCtrl.text.trim(),
        'date': Timestamp.fromDate(_date),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _t('✅ تم إضافة الير الذهبية', '✅ Non-gold purchase added')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ Save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_t('❌ فشل الحفظ: $e', '❌ Save failed: $e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Directionality(
      textDirection:
          _lang == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.inventory_2, color: Color(0xFFD4AF37)),
            const SizedBox(width: 10),
            Text(
              _t('مشتريات غير ذهبية', 'Non-Gold Purchase'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _field(
                    controller: _nameCtrl,
                    label: _t('اسم الصنف', 'Item name'),
                    icon: Icons.label_outline,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? _t('مطلوب', 'Required')
                        : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white),
                    decoration: _deco(
                      label: _t('التصنيف', 'Category'),
                      icon: Icons.category_outlined,
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _category = v ?? _category),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          controller: _qtyCtrl,
                          label: _t('الكمية', 'Quantity'),
                          icon: Icons.numbers,
                          keyboard: TextInputType.number,
                          validator: (v) {
                            final n = double.tryParse(v ?? '');
                            if (n == null || n <= 0) {
                              return _t('رقم غير صحيح', 'Invalid');
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _unit,
                          dropdownColor: const Color(0xFF1A1A1A),
                          style: const TextStyle(color: Colors.white),
                          decoration: _deco(
                            label: _t('الوحدة', 'Unit'),
                            icon: Icons.straighten,
                          ),
                          items: _units
                              .map((u) =>
                                  DropdownMenuItem(value: u, child: Text(u)))
                              .toList(),
                          onChanged: (v) => setState(() => _unit = v ?? _unit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _unitPriceCtrl,
                    label: _t('سعر الوحدة (ر.س)', 'Unit price (SAR)'),
                    icon: Icons.attach_money,
                    keyboard: TextInputType.number,
                    validator: (v) {
                      final n = double.tryParse(v ?? '');
                      if (n == null || n < 0) {
                        return _t('رقم غير صحيح', 'Invalid');
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _t('الإجمالي', 'Total'),
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_total.toStringAsFixed(2)} ${_t('ر.س', 'SAR')}',
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _supplierCtrl,
                    label: _t('المورد (اختياري)', 'Supplier (optional)'),
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) setState(() => _date = d);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xFFD4AF37), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            '${_t('التاريخ', 'Date')}: ${df.format(_date)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _field(
                    controller: _notesCtrl,
                    label: _t('ملاحظات (اختياري)', 'Notes (optional)'),
                    icon: Icons.note_outlined,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: Text(
              _t('إلغاء', 'Cancel'),
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    _t('حفظ', 'Save'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  InputDecoration _deco({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: _deco(label: label, icon: icon),
    );
  }
}
