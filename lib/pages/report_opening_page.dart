// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import '../services/firestore_service.dart';

// // class OpeningBalanceReportPage extends StatefulWidget {
// //   const OpeningBalanceReportPage({super.key});

// //   @override
// //   State<OpeningBalanceReportPage> createState() =>
// //       _OpeningBalanceReportPageState();
// // }

// // class _OpeningBalanceReportPageState extends State<OpeningBalanceReportPage> {
// //   static const Color goldColor = Color(0xFFD4AF37);
// //   static const Color greenColor = Color(0xFF2E7D32);
// //   static const Color redColor = Color(0xFFC62828);

// //   bool _isLoading = true;
// //   String? _error;

// //   // ===== الافتتاحي =====
// //   Map<String, dynamic>? _opening;

// //   // ===== الفعلي الحالي =====
// //   double _curCash = 0;
// //   double _curNet = 0;

// //   Map<String, double> _curWorkedByCarat = {
// //     "24": 0,
// //     "22": 0,
// //     "21": 0,
// //     "18": 0,
// //     "14": 0
// //   };

// //   Map<String, double> _curScrapByCarat = {
// //     "24": 0,
// //     "22": 0,
// //     "21": 0,
// //     "18": 0,
// //     "14": 0
// //   };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAll();
// //   }

// //   Future<void> _loadAll() async {
// //     setState(() {
// //       _isLoading = true;
// //       _error = null;
// //     });

// //     try {
// //       // 1) الافتتاحي
// //       _opening = await FS.getOpeningBalance();

// //       // 2) الكاش والشبكة الكلي (نفس حسابات GeneralBalancePage)
// //       final results = await Future.wait([
// //         FS.salesCol().get(),
// //         FS.scrapCol().where("type", isEqualTo: "sale").get(),
// //         FS.scrapCol().where("type", isEqualTo: "add").get(),
// //         FS.vouchersCol().where("type", isEqualTo: "payment").get(),
// //         FS.expensesCol().get(),
// //         FS.depositsCol().get(),
// //         FS.ImportedCol().get(),
// //       ]);

// //       final salesSnap = results[0];
// //       final scrapSaleSnap = results[1];
// //       final scrapBuySnap = results[2];
// //       final vouchersSnap = results[3];
// //       final expSnap = results[4];
// //       final depositSnap = results[5];
// //       final importSnap = results[6];

// //       double cash = 0;
// //       double visa = 0;

// //       // مبيعات القطع (تدخل)
// //       for (var d in salesSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash += (data['payment']?['cash'] ?? 0).toDouble();
// //         visa += (data['payment']?['visa'] ?? 0).toDouble();
// //       }

// //       // بيع الكسر (يدخل)
// //       for (var d in scrapSaleSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash += (data['cash'] ?? 0).toDouble();
// //         visa += (data['network'] ?? 0).toDouble();
// //       }

// //       // شراء الكسر (يخرج)
// //       for (var d in scrapBuySnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash -= (data['cash'] ?? 0).toDouble();
// //         visa -= (data['network'] ?? 0).toDouble();
// //       }

// //       // سندات الصرف (تخرج)
// //       for (var d in vouchersSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash -= (data['cash'] ?? 0).toDouble();
// //         visa -= (data['network'] ?? 0).toDouble();
// //       }

// //       // المصروفات (تخرج)
// //       for (var d in expSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
// //         cash -= amount;
// //       }

// //       // توريد للإدارة (يخرج)
// //       for (var d in depositSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash -= (data['cash'] ?? 0).toDouble();
// //         visa -= (data['visa'] ?? 0).toDouble();
// //       }

// //       // استيراد من الإدارة (يدخل)
// //       for (var d in importSnap.docs) {
// //         final data = d.data() as Map<String, dynamic>;
// //         cash += (data['cash'] ?? 0).toDouble();
// //         visa += (data['visa'] ?? 0).toDouble();
// //       }

// //       _curCash = cash;
// //       _curNet = visa;

// //       // 3) الذهب المشغول الحالي (items - category='gold')
// //       try {
// //         final itemsSnap = await FS.itemsCol().get();
// //         _curWorkedByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

// //         for (var doc in itemsSnap.docs) {
// //           final data = doc.data() as Map<String, dynamic>;
// //           if (data['category'] != 'gold') continue;

// //           final payload = Map<String, dynamic>.from(data['payload'] ?? {});
// //           final weight = (payload['weight'] ?? 0).toDouble();
// //           final carat = payload['carat']?.toString() ?? '';

// //           if (_curWorkedByCarat.containsKey(carat)) {
// //             _curWorkedByCarat[carat] = _curWorkedByCarat[carat]! + weight;
// //           }
// //         }
// //       } catch (_) {}

// //       // 4) الكسر الحالي (scrapCol)
// //       try {
// //         final scrapAllSnap = await FS.scrapCol().get();
// //         _curScrapByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

// //         for (var doc in scrapAllSnap.docs) {
// //           final t = doc.data() as Map<String, dynamic>;
// //           final type = (t['type'] ?? '').toString();

// //           // سندات صرف متعددة العيارات
// //           if (type == 'payment' &&
// //               t['carats'] != null &&
// //               (t['carats'] as List).isNotEmpty) {
// //             for (var c in t['carats']) {
// //               final carat = (c['carat'] ?? '18').toString();
// //               final weight = (c['weight'] ?? 0).toDouble();
// //               if (_curScrapByCarat.containsKey(carat)) {
// //                 _curScrapByCarat[carat] =
// //                     _curScrapByCarat[carat]! - weight.abs();
// //               }
// //             }
// //             continue;
// //           }

// //           final carat = (t['carat'] ?? '18').toString();
// //           final weight = (t['weight'] ?? 0).toDouble();
// //           if (!_curScrapByCarat.containsKey(carat)) continue;

// //           if (type == 'add' || type == 'transform') {
// //             _curScrapByCarat[carat] = _curScrapByCarat[carat]! + weight;
// //           } else if (type == 'sale' || type == 'payment') {
// //             _curScrapByCarat[carat] = _curScrapByCarat[carat]! - weight.abs();
// //           }
// //         }
// //       } catch (_) {}

// //       if (mounted) setState(() => _isLoading = false);
// //     } catch (e) {
// //       if (mounted) {
// //         setState(() {
// //           _error = e.toString();
// //           _isLoading = false;
// //         });
// //       }
// //     }
// //   }

// //   double _to24(double w, String carat) {
// //     final c = double.tryParse(carat) ?? 24;
// //     return w * (c / 24);
// //   }

// //   String _fmt(dynamic v) {
// //     if (v == null) return '0';
// //     final d = (v is num) ? v.toDouble() : (double.tryParse(v.toString()) ?? 0);
// //     if (d == 0) return '0';

// //     final isNegative = d < 0;
// //     final abs = d.abs();

// //     String intPart;
// //     String decPart = '';

// //     if (abs == abs.roundToDouble()) {
// //       intPart = abs.toInt().toString();
// //     } else {
// //       final str = abs.toStringAsFixed(2);
// //       final parts = str.split('.');
// //       intPart = parts[0];
// //       decPart = '.${parts[1]}';
// //     }

// //     final buffer = StringBuffer();
// //     for (int i = 0; i < intPart.length; i++) {
// //       if (i > 0 && (intPart.length - i) % 3 == 0) {
// //         buffer.write(',');
// //       }
// //       buffer.write(intPart[i]);
// //     }

// //     final formatted = '${buffer.toString()}$decPart';
// //     return isNegative ? '-$formatted' : formatted;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F5),
// //       appBar: AppBar(
// //         title: const Text(
// //           'مقارنة الرصيد الافتتاحي',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: goldColor,
// //         centerTitle: true,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.refresh, color: Colors.white),
// //             onPressed: _isLoading ? null : _loadAll,
// //           ),
// //         ],
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: _isLoading
// //             ? const Center(child: CircularProgressIndicator(color: goldColor))
// //             : _error != null
// //                 ? _errorCard('خطأ: $_error')
// //                 : RefreshIndicator(
// //                     color: goldColor,
// //                     onRefresh: _loadAll,
// //                     child: _buildBody(),
// //                   ),
// //       ),
// //     );
// //   }

// //   Widget _buildBody() {
// //     if (_opening == null) {
// //       return ListView(
// //         children: [
// //           const SizedBox(height: 100),
// //           _infoCard('لا يوجد رصيد افتتاحي مسجل'),
// //         ],
// //       );
// //     }

// //     final o = _opening!;
// //     final daily = o['dailyCashBox'] ?? {};
// //     final scrap = o['scrapGoldByCarat'] ?? {};
// //     final worked = o['workedGoldByCarat'] ?? {};

// //     // ✅ الافتتاحي: من dailyCashBox (لأن الإدخال الجديد يحفظ فيه)
// //     final oCash = (daily['cash'] ?? 0).toDouble();
// //     final oNet = (daily['network'] ?? 0).toDouble();

// //     // إجماليات الذهب بعيار 24
// //     double oScrapGold24 = 0, oWorkedGold24 = 0;
// //     for (var c in ['24', '22', '21', '18', '14']) {
// //       oScrapGold24 += _to24((scrap[c] ?? 0).toDouble(), c);
// //       oWorkedGold24 += _to24((worked[c] ?? 0).toDouble(), c);
// //     }

// //     double cScrapGold24 = 0, cWorkedGold24 = 0;
// //     _curScrapByCarat.forEach((c, w) {
// //       cScrapGold24 += _to24(w, c);
// //     });
// //     _curWorkedByCarat.forEach((c, w) {
// //       cWorkedGold24 += _to24(w, c);
// //     });

// //     return ListView(
// //       padding: const EdgeInsets.all(14),
// //       children: [
// //         // ===== 4 كروت كبيرة =====
// //         _bigCard(
// //           label: 'الكاش',
// //           opening: oCash,
// //           actual: _curCash,
// //           unit: 'ر.س',
// //           icon: Icons.money,
// //         ),
// //         const SizedBox(height: 10),

// //         _bigCard(
// //           label: 'الشبكة',
// //           opening: oNet,
// //           actual: _curNet,
// //           unit: 'ر.س',
// //           icon: Icons.wifi,
// //         ),
// //         const SizedBox(height: 10),

// //         _bigCard(
// //           label: 'الذهب المشغول',
// //           opening: oWorkedGold24,
// //           actual: cWorkedGold24,
// //           unit: 'جم',
// //           icon: Icons.work,
// //         ),
// //         const SizedBox(height: 10),

// //         _bigCard(
// //           label: 'الكسر',
// //           opening: oScrapGold24,
// //           actual: cScrapGold24,
// //           unit: 'جم',
// //           icon: Icons.crisis_alert,
// //         ),
// //         const SizedBox(height: 20),

// //         // ===== تفاصيل الذهب المشغول =====
// //         _tableContainer(
// //           title: 'الذهب المشغول - حسب العيار',
// //           rows: [
// //             for (var c in ['24', '22', '21', '18', '14'])
// //               _rowData(
// //                 'عيار $c',
// //                 (worked[c] ?? 0).toDouble(),
// //                 _curWorkedByCarat[c] ?? 0,
// //                 unit: 'جم',
// //               ),
// //           ],
// //         ),
// //         const SizedBox(height: 16),

// //         // ===== تفاصيل الكسر =====
// //         _tableContainer(
// //           title: 'الكسر - حسب العيار',
// //           rows: [
// //             for (var c in ['24', '22', '21', '18', '14'])
// //               _rowData(
// //                 'عيار $c',
// //                 (scrap[c] ?? 0).toDouble(),
// //                 _curScrapByCarat[c] ?? 0,
// //                 unit: 'جم',
// //               ),
// //           ],
// //         ),

// //         const SizedBox(height: 30),
// //       ],
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 كارت كبير
// //   // ============================================================
// //   Widget _bigCard({
// //     required String label,
// //     required double opening,
// //     required double actual,
// //     required String unit,
// //     required IconData icon,
// //   }) {
// //     final diff = actual - opening;
// //     final isSame = diff.abs() < 0.01;
// //     final color =
// //         isSame ? Colors.grey.shade700 : (diff > 0 ? greenColor : redColor);
// //     final sign = diff > 0 ? '+' : '';

// //     return Container(
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: goldColor.withOpacity(0.3)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 6,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(6),
// //                 decoration: BoxDecoration(
// //                   color: goldColor.withOpacity(0.15),
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Icon(icon, color: goldColor, size: 18),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: Text(
// //                   label,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 12),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child:
// //                     _valueBox('افتتاحي', opening, unit, Colors.grey.shade600),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: _valueBox('حالي', actual, unit, const Color(0xFF333333)),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Icon(
// //                   isSame
// //                       ? Icons.remove
// //                       : (diff > 0 ? Icons.arrow_upward : Icons.arrow_downward),
// //                   size: 14,
// //                   color: color,
// //                 ),
// //                 const SizedBox(width: 4),
// //                 Text(
// //                   'الفرق: $sign${_fmt(diff)} $unit',
// //                   style: TextStyle(
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.bold,
// //                     color: color,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _valueBox(String label, double value, String unit, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// //           ),
// //           const SizedBox(height: 2),
// //           FittedBox(
// //             fit: BoxFit.scaleDown,
// //             alignment: Alignment.centerRight,
// //             child: Text(
// //               '${_fmt(value)} $unit',
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 fontWeight: FontWeight.bold,
// //                 color: color,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 جدول
// //   // ============================================================
// //   Widget _tableContainer({
// //     required String title,
// //     required List<_RowData> rows,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: goldColor.withOpacity(0.25)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.03),
// //             blurRadius: 6,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
// //             decoration: BoxDecoration(
// //               color: goldColor.withOpacity(0.1),
// //               borderRadius: const BorderRadius.only(
// //                 topLeft: Radius.circular(14),
// //                 topRight: Radius.circular(14),
// //               ),
// //             ),
// //             child: Text(
// //               title,
// //               style: const TextStyle(
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFF444444),
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
// //             child: Row(
// //               children: [
// //                 const Expanded(
// //                   flex: 3,
// //                   child: Text(
// //                     'البند',
// //                     style: TextStyle(
// //                       fontSize: 11,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF888888),
// //                     ),
// //                   ),
// //                 ),
// //                 _headCell('افتتاحي'),
// //                 _headCell('حالي'),
// //                 _headCell('الفرق'),
// //               ],
// //             ),
// //           ),
// //           const Divider(height: 1, color: Color(0xFFEEEEEE)),
// //           ...rows.map(_buildRow).toList(),
// //           const SizedBox(height: 4),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _headCell(String text) {
// //     return Expanded(
// //       flex: 2,
// //       child: Text(
// //         text,
// //         textAlign: TextAlign.center,
// //         style: const TextStyle(
// //           fontSize: 11,
// //           fontWeight: FontWeight.bold,
// //           color: Color(0xFF888888),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildRow(_RowData r) {
// //     final diff = r.actual - r.opening;
// //     final isSame = diff.abs() < 0.01;
// //     final color =
// //         isSame ? Colors.grey.shade600 : (diff > 0 ? greenColor : redColor);
// //     final sign = diff > 0 ? '+' : '';

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
// //       decoration: const BoxDecoration(
// //         border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               r.label,
// //               style: const TextStyle(fontSize: 12),
// //             ),
// //           ),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               _fmt(r.opening),
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
// //             ),
// //           ),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               _fmt(r.actual),
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             flex: 2,
// //             child: Text(
// //               isSame ? '0' : '$sign${_fmt(diff)}',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //                 color: color,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   _RowData _rowData(String label, double opening, double actual,
// //       {String unit = 'ر.س'}) {
// //     return _RowData(
// //       label: label,
// //       opening: opening,
// //       actual: actual,
// //       unit: unit,
// //     );
// //   }

// //   Widget _errorCard(String msg) {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Text(
// //           msg,
// //           textAlign: TextAlign.center,
// //           style: const TextStyle(color: redColor, fontSize: 14),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _infoCard(String msg) {
// //     return Container(
// //       margin: const EdgeInsets.all(16),
// //       padding: const EdgeInsets.all(24),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(14),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Center(
// //         child: Text(
// //           msg,
// //           style: TextStyle(color: Colors.grey.shade600),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _RowData {
// //   final String label;
// //   final double opening;
// //   final double actual;
// //   final String unit;
// //   _RowData({
// //     required this.label,
// //     required this.opening,
// //     required this.actual,
// //     required this.unit,
// //   });
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/firestore_service.dart';

// class OpeningBalanceReportPage extends StatefulWidget {
//   const OpeningBalanceReportPage({super.key});

//   @override
//   State<OpeningBalanceReportPage> createState() =>
//       _OpeningBalanceReportPageState();
// }

// class _OpeningBalanceReportPageState extends State<OpeningBalanceReportPage> {
//   static const Color goldColor = Color(0xFFD4AF37);
//   static const Color greenColor = Color(0xFF2E7D32);
//   static const Color redColor = Color(0xFFC62828);

//   // ⚠️ تأكد من مسار مستند الرصيد الافتتاحي في مشروعك
//   static const String _obCollection = 'opening_balance';
//   static const String _obDocId = 'main';

//   bool _isLoading = true;
//   String? _error;

//   // ===== الافتتاحي =====
//   Map<String, dynamic>? _opening;

//   // ===== الفعلي الحالي =====
//   double _curCash = 0;
//   double _curNet = 0;

//   Map<String, double> _curWorkedByCarat = {
//     "24": 0,
//     "22": 0,
//     "21": 0,
//     "18": 0,
//     "14": 0,
//   };

//   Map<String, double> _curScrapByCarat = {
//     "24": 0,
//     "22": 0,
//     "21": 0,
//     "18": 0,
//     "14": 0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadAll();
//   }

//   // ============================================================
//   // 🔹 دالة قراءة الأرقام بشكل آمن (لمنع الأرقام العشوائية)
//   // ============================================================
//   double _safeDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is num) {
//       if (value.isNaN || value.isInfinite) return 0.0;
//       return value.toDouble();
//     }
//     if (value is String) {
//       final cleaned = value.replaceAll(',', '').trim();
//       final parsed = double.tryParse(cleaned);
//       if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
//       return parsed;
//     }
//     return 0.0;
//   }

//   Future<void> _loadAll() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       // 1) الافتتاحي
//       _opening = await FS.getOpeningBalance();

//       // 2) الكاش والشبكة الكلي
//       final results = await Future.wait([
//         FS.salesCol().get(),
//         FS.scrapCol().where("type", isEqualTo: "sale").get(),
//         FS.scrapCol().where("type", isEqualTo: "add").get(),
//         FS.vouchersCol().where("type", isEqualTo: "payment").get(),
//         FS.expensesCol().get(),
//         FS.depositsCol().get(),
//         FS.ImportedCol().get(),
//       ]);

//       final salesSnap = results[0];
//       final scrapSaleSnap = results[1];
//       final scrapBuySnap = results[2];
//       final vouchersSnap = results[3];
//       final expSnap = results[4];
//       final depositSnap = results[5];
//       final importSnap = results[6];

//       double cash = 0;
//       double visa = 0;

//       // مبيعات القطع (تدخل)
//       for (var d in salesSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['payment']?['cash']);
//         visa += _safeDouble(data['payment']?['visa']);
//       }

//       // بيع الكسر (يدخل)
//       for (var d in scrapSaleSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['cash']);
//         visa += _safeDouble(data['network']);
//       }

//       // شراء الكسر (يخرج)
//       for (var d in scrapBuySnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['network']);
//       }

//       // سندات الصرف (تخرج)
//       for (var d in vouchersSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['network']);
//       }

//       // المصروفات (تخرج)
//       for (var d in expSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['amount']);
//       }

//       // توريد للإدارة (يخرج)
//       for (var d in depositSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['visa']);
//       }

//       // استيراد من الإدارة (يدخل)
//       for (var d in importSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['cash']);
//         visa += _safeDouble(data['visa']);
//       }

//       _curCash = cash;
//       _curNet = visa;

//       // 3) الذهب المشغول الحالي
//       try {
//         final itemsSnap = await FS.itemsCol().get();
//         _curWorkedByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

//         for (var doc in itemsSnap.docs) {
//           final data = doc.data() as Map<String, dynamic>;
//           if (data['category'] != 'gold') continue;

//           final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//           final weight = _safeDouble(payload['weight']);
//           final carat = payload['carat']?.toString() ?? '';

//           if (_curWorkedByCarat.containsKey(carat)) {
//             _curWorkedByCarat[carat] = _curWorkedByCarat[carat]! + weight;
//           }
//         }
//       } catch (_) {}

//       // 4) الكسر الحالي
//       try {
//         final scrapAllSnap = await FS.scrapCol().get();
//         _curScrapByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

//         for (var doc in scrapAllSnap.docs) {
//           final t = doc.data() as Map<String, dynamic>;
//           final type = (t['type'] ?? '').toString();

//           if (type == 'payment' &&
//               t['carats'] != null &&
//               (t['carats'] as List).isNotEmpty) {
//             for (var c in t['carats']) {
//               final carat = (c['carat'] ?? '18').toString();
//               final weight = _safeDouble(c['weight']);
//               if (_curScrapByCarat.containsKey(carat)) {
//                 _curScrapByCarat[carat] =
//                     _curScrapByCarat[carat]! - weight.abs();
//               }
//             }
//             continue;
//           }

//           final carat = (t['carat'] ?? '18').toString();
//           final weight = _safeDouble(t['weight']);
//           if (!_curScrapByCarat.containsKey(carat)) continue;

//           if (type == 'add' || type == 'transform') {
//             _curScrapByCarat[carat] = _curScrapByCarat[carat]! + weight;
//           } else if (type == 'sale' || type == 'payment') {
//             _curScrapByCarat[carat] = _curScrapByCarat[carat]! - weight.abs();
//           }
//         }
//       } catch (_) {}

//       if (mounted) setState(() => _isLoading = false);
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _error = e.toString();
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   double _to24(double w, String carat) {
//     final c = _safeDouble(carat);
//     return w * (c / 24);
//   }

//   String _fmt(dynamic v) {
//     if (v == null) return '0';
//     final d = _safeDouble(v);
//     if (d == 0) return '0';

//     final isNegative = d < 0;
//     final abs = d.abs();

//     String intPart;
//     String decPart = '';

//     if (abs == abs.roundToDouble()) {
//       intPart = abs.toInt().toString();
//     } else {
//       final str = abs.toStringAsFixed(2);
//       final parts = str.split('.');
//       intPart = parts[0];
//       decPart = '.${parts[1]}';
//     }

//     final buffer = StringBuffer();
//     for (int i = 0; i < intPart.length; i++) {
//       if (i > 0 && (intPart.length - i) % 3 == 0) {
//         buffer.write(',');
//       }
//       buffer.write(intPart[i]);
//     }

//     final formatted = '${buffer.toString()}$decPart';
//     return isNegative ? '-$formatted' : formatted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text(
//           'مقارنة الرصيد الافتتاحي',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: goldColor,
//         centerTitle: true,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _isLoading ? null : _loadAll,
//           ),
//         ],
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator(color: goldColor))
//             : _error != null
//                 ? _errorCard('خطأ: $_error')
//                 : RefreshIndicator(
//                     color: goldColor,
//                     onRefresh: _loadAll,
//                     child: _buildBody(),
//                   ),
//       ),
//       // ✅ زر السحب الموحد بالأسفل
//       floatingActionButton: _opening == null || _isLoading
//           ? null
//           : FloatingActionButton.extended(
//               onPressed: () => _showUnifiedWithdrawSheet(),
//               backgroundColor: goldColor,
//               icon:
//                   const Icon(Icons.remove_circle_outline, color: Colors.white),
//               label: const Text(
//                 'سحب من الرصيد',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildBody() {
//     if (_opening == null) {
//       return ListView(
//         children: [
//           const SizedBox(height: 100),
//           _infoCard('لا يوجد رصيد افتتاحي مسجل'),
//         ],
//       );
//     }

//     final o = _opening!;
//     final daily = o['dailyCashBox'] ?? {};
//     final scrap = o['scrapGoldByCarat'] ?? {};
//     final worked = o['workedGoldByCarat'] ?? {};

//     // ✅ الافتتاحي
//     final oCash = _safeDouble(daily['cash']);
//     final oNet = _safeDouble(daily['network']);

//     // ✅ رصيد الخزنة الافتتاحي
//     final oSafeCash = _safeDouble(o['safeCash']);
//     final oSafeNet = _safeDouble(o['safeNetwork']);

//     // إجماليات الذهب بعيار 24
//     double oScrapGold24 = 0, oWorkedGold24 = 0;
//     for (var c in ['24', '22', '21', '18', '14']) {
//       oScrapGold24 += _to24(_safeDouble(scrap[c]), c);
//       oWorkedGold24 += _to24(_safeDouble(worked[c]), c);
//     }

//     double cScrapGold24 = 0, cWorkedGold24 = 0;
//     _curScrapByCarat.forEach((c, w) {
//       cScrapGold24 += _to24(w, c);
//     });
//     _curWorkedByCarat.forEach((c, w) {
//       cWorkedGold24 += _to24(w, c);
//     });

//     return ListView(
//       padding: const EdgeInsets.all(14),
//       children: [
//         // ===== كروت الفلوس =====
//         _bigCard(
//           label: 'الكاش',
//           opening: oCash,
//           actual: _curCash,
//           unit: 'ر.س',
//           icon: Icons.money,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الشبكة',
//           opening: oNet,
//           actual: _curNet,
//           unit: 'ر.س',
//           icon: Icons.wifi,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الخزنة - كاش',
//           opening: oSafeCash,
//           actual: 0,
//           unit: 'ر.س',
//           icon: Icons.account_balance_wallet,
//           hideCompare: true,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الخزنة - شبكة',
//           opening: oSafeNet,
//           actual: 0,
//           unit: 'ر.س',
//           icon: Icons.account_balance_wallet,
//           hideCompare: true,
//         ),
//         const SizedBox(height: 10),

//         // ===== الذهب =====
//         _bigCard(
//           label: 'الذهب المشغول',
//           opening: oWorkedGold24,
//           actual: cWorkedGold24,
//           unit: 'جم',
//           icon: Icons.work,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الكسر',
//           opening: oScrapGold24,
//           actual: cScrapGold24,
//           unit: 'جم',
//           icon: Icons.crisis_alert,
//         ),
//         const SizedBox(height: 20),

//         // ===== تفاصيل الذهب المشغول =====
//         _tableContainer(
//           title: 'الذهب المشغول - حسب العيار',
//           rows: [
//             for (var c in ['24', '22', '21', '18', '14'])
//               _rowData(
//                 'عيار $c',
//                 _safeDouble(worked[c]),
//                 _curWorkedByCarat[c] ?? 0,
//                 unit: 'جم',
//               ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         // ===== تفاصيل الكسر =====
//         _tableContainer(
//           title: 'الكسر - حسب العيار',
//           rows: [
//             for (var c in ['24', '22', '21', '18', '14'])
//               _rowData(
//                 'عيار $c',
//                 _safeDouble(scrap[c]),
//                 _curScrapByCarat[c] ?? 0,
//                 unit: 'جم',
//               ),
//           ],
//         ),

//         const SizedBox(height: 16),

//         // ===== القروض =====
//         _loansSection(o['loans']),

//         const SizedBox(height: 80), // مساحة للزر العائم
//       ],
//     );
//   }

//   // ============================================================
//   // 🔹 كارت كبير
//   // ============================================================
//   Widget _bigCard({
//     required String label,
//     required double opening,
//     required double actual,
//     required String unit,
//     required IconData icon,
//     bool hideCompare = false,
//   }) {
//     final diff = actual - opening;
//     final isSame = diff.abs() < 0.01;
//     final color =
//         isSame ? Colors.grey.shade700 : (diff > 0 ? greenColor : redColor);
//     final sign = diff > 0 ? '+' : '';

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: goldColor.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: goldColor, size: 18),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (hideCompare)
//             _valueBox(
//                 'الرصيد الافتتاحي', opening, unit, const Color(0xFF333333))
//           else
//             Row(
//               children: [
//                 Expanded(
//                   child:
//                       _valueBox('افتتاحي', opening, unit, Colors.grey.shade600),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child:
//                       _valueBox('حالي', actual, unit, const Color(0xFF333333)),
//                 ),
//               ],
//             ),
//           if (!hideCompare) ...[
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     isSame
//                         ? Icons.remove
//                         : (diff > 0
//                             ? Icons.arrow_upward
//                             : Icons.arrow_downward),
//                     size: 14,
//                     color: color,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'الفرق: $sign${_fmt(diff)} $unit',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _valueBox(String label, double value, String unit, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
//           ),
//           const SizedBox(height: 2),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerRight,
//             child: Text(
//               '${_fmt(value)} $unit',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 قسم القروض
//   // ============================================================
//   Widget _loansSection(dynamic loansData) {
//     List<Map<String, dynamic>> loans = [];
//     if (loansData is List) {
//       for (var l in loansData) {
//         if (l is Map) {
//           loans.add(Map<String, dynamic>.from(l));
//         }
//       }
//     }

//     double total = 0;
//     for (var l in loans) {
//       total += _safeDouble(l['amount']);
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: goldColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(14),
//                 topRight: Radius.circular(14),
//               ),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.account_balance, color: goldColor, size: 18),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     'القروض على المحل - الرصيد الافتتاحي',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF444444),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: goldColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'الإجمالي: ${_fmt(total)} ر.س',
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (loans.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Text(
//                 'لا توجد قروض مسجلة',
//                 style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//               ),
//             )
//           else ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Row(
//                 children: const [
//                   Expanded(
//                     flex: 4,
//                     child: Text(
//                       'الجهة / البيان',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF888888),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'المبلغ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF888888),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 40),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, color: Color(0xFFEEEEEE)),
//             ...loans.asMap().entries.map((entry) {
//               final idx = entry.key;
//               final loan = entry.value;
//               final name = (loan['name'] ?? '').toString();
//               final amount = _safeDouble(loan['amount']);
//               return Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//                 decoration: const BoxDecoration(
//                     // border:
//                     //     Border(borderSide: BorderSide(color: Color(0xFFF0F0F0))),
//                     ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: Text(
//                         name.isEmpty ? '—' : name,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         _fmt(amount),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: redColor,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: IconButton(
//                         icon: const Icon(Icons.delete_outline,
//                             color: Colors.red, size: 20),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         tooltip: 'حذف / تسوية القرض',
//                         onPressed: () => _removeLoan(idx),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   Future<void> _removeLoan(int index) async {
//     final o = _opening;
//     if (o == null) return;

//     final loansData = o['loans'];
//     if (loansData is! List) return;

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'تأكيد الحذف',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         content: const Text('سيتم حذف هذا القرض من الرصيد الافتتاحي نهائياً.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: redColor),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text(
//               'حذف',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     try {
//       final updated = List<Map<String, dynamic>>.from(
//         loansData.map((e) => Map<String, dynamic>.from(e as Map)),
//       );
//       updated.removeAt(index);

//       await FirebaseFirestore.instance
//           .collection(_obCollection)
//           .doc(_obDocId)
//           .update({
//         'loans': updated,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ تم حذف القرض من الرصيد الافتتاحي'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _loadAll();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // ============================================================
//   // 🔹 نافذة السحب الموحدة (Bottom Sheet)
//   // ============================================================
//   void _showUnifiedWithdrawSheet() {
//     final o = _opening;
//     if (o == null) return;

//     // متغيرات الحالة داخل النافذة
//     String mainType = 'money'; // 'money' أو 'gold'
//     String moneyType = 'cash'; // 'cash', 'network', 'safeCash', 'safeNetwork'
//     String goldType = 'worked'; // 'worked' أو 'scrap'
//     String selectedCarat = '21';

//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setSt) {
//             // حساب المتاح بناءً على الاختيار الحالي
//             double available = 0;
//             if (mainType == 'money') {
//               if (moneyType == 'cash') {
//                 available = _safeDouble((o['dailyCashBox'] ?? {})['cash']);
//               } else if (moneyType == 'network') {
//                 available = _safeDouble((o['dailyCashBox'] ?? {})['network']);
//               } else if (moneyType == 'safeCash') {
//                 available = _safeDouble(o['safeCash']);
//               } else if (moneyType == 'safeNetwork') {
//                 available = _safeDouble(o['safeNetwork']);
//               }
//             } else {
//               if (goldType == 'worked') {
//                 available =
//                     _safeDouble((o['workedGoldByCarat'] ?? {})[selectedCarat]);
//               } else {
//                 available =
//                     _safeDouble((o['scrapGoldByCarat'] ?? {})[selectedCarat]);
//               }
//             }

//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//                 top: 16,
//                 left: 16,
//                 right: 16,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // مقبض النافذة
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // العنوان
//                     Row(
//                       children: [
//                         const Icon(Icons.remove_circle_outline,
//                             color: goldColor, size: 24),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'سحب من الرصيد الافتتاحي',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF333333),
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () => Navigator.pop(ctx),
//                           icon: const Icon(Icons.close, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),

//                     // تنبيه
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.orange.shade200),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info_outline,
//                               color: Colors.orange, size: 20),
//                           const SizedBox(width: 8),
//                           const Expanded(
//                             child: Text(
//                               'الخصم هيتم من الرصيد الافتتاحي فقط، الرصيد الحالي مش هيتأثر.',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // اختيار النوع الرئيسي (كاش / ذهب)
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'كاش / شبكة',
//                               isSelected: mainType == 'money',
//                               onTap: () => setSt(() => mainType = 'money'),
//                             ),
//                           ),
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'ذهب',
//                               isSelected: mainType == 'gold',
//                               onTap: () => setSt(() => mainType = 'gold'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // ===== خيارات الفلوس =====
//                     if (mainType == 'money') ...[
//                       DropdownButtonFormField<String>(
//                         value: moneyType,
//                         isExpanded: true,
//                         decoration: InputDecoration(
//                           labelText: 'نوع الرصيد',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           prefixIcon: const Icon(Icons.money, color: goldColor),
//                         ),
//                         items: const [
//                           DropdownMenuItem(value: 'cash', child: Text('الكاش')),
//                           DropdownMenuItem(
//                               value: 'network', child: Text('الشبكة')),
//                           DropdownMenuItem(
//                               value: 'safeCash', child: Text('الخزنة - كاش')),
//                           DropdownMenuItem(
//                               value: 'safeNetwork',
//                               child: Text('الخزنة - شبكة')),
//                         ],
//                         onChanged: (v) => setSt(() => moneyType = v!),
//                       ),
//                     ],

//                     // ===== خيارات الذهب =====
//                     if (mainType == 'gold') ...[
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'مشغول',
//                               isSelected: goldType == 'worked',
//                               onTap: () => setSt(() => goldType = 'worked'),
//                               isSmall: true,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'كسر',
//                               isSelected: goldType == 'scrap',
//                               onTap: () => setSt(() => goldType = 'scrap'),
//                               isSmall: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: selectedCarat,
//                         isExpanded: true,
//                         decoration: InputDecoration(
//                           labelText: 'العيار',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           prefixIcon:
//                               const Icon(Icons.diamond, color: goldColor),
//                         ),
//                         items: const ['24', '22', '21', '18', '14']
//                             .map((c) => DropdownMenuItem(
//                                   value: c,
//                                   child: Text('عيار $c'),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setSt(() => selectedCarat = v!),
//                       ),
//                     ],

//                     const SizedBox(height: 16),

//                     // عرض المتاح
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: goldColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info, color: goldColor, size: 20),
//                           const SizedBox(width: 8),
//                           Text(
//                             'المتاح: ${_fmt(available)} ${mainType == 'money' ? 'ر.س' : 'جم'}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF333333),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // حقل الإدخال
//                     TextField(
//                       controller: amountController,
//                       keyboardType:
//                           const TextInputType.numberWithOptions(decimal: true),
//                       decoration: InputDecoration(
//                         labelText: mainType == 'money'
//                             ? 'المبلغ المسحوب (ر.س)'
//                             : 'الوزن المسحوب (جم)',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: Icon(
//                           mainType == 'money' ? Icons.money : Icons.scale,
//                           color: goldColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // حقل الملاحظة
//                     TextField(
//                       controller: noteController,
//                       decoration: InputDecoration(
//                         labelText: 'ملاحظة (اختياري)',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: const Icon(Icons.note, color: goldColor),
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // زر التأكيد
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton.icon(
//                         onPressed: () => _executeWithdraw(
//                           ctx: ctx,
//                           mainType: mainType,
//                           moneyType: moneyType,
//                           goldType: goldType,
//                           carat: selectedCarat,
//                           amount: _safeDouble(amountController.text),
//                           note: noteController.text.trim(),
//                           available: available,
//                         ),
//                         icon: const Icon(Icons.check, color: Colors.white),
//                         label: const Text(
//                           'تأكيد السحب',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: goldColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildToggleButton({
//     required String text,
//     required bool isSelected,
//     required VoidCallback onTap,
//     bool isSmall = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: isSmall ? 10 : 12),
//         decoration: BoxDecoration(
//           color: isSelected ? goldColor : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: isSmall ? 14 : 15,
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.white : Colors.grey.shade600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 تنفيذ عملية السحب
//   // ============================================================
//   Future<void> _executeWithdraw({
//     required BuildContext ctx,
//     required String mainType,
//     required String moneyType,
//     required String goldType,
//     required String carat,
//     required double amount,
//     required String note,
//     required double available,
//   }) async {
//     if (amount <= 0) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('الرجاء إدخال قيمة صحيحة أكبر من صفر'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (amount > available) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('القيمة أكبر من الرصيد الافتتاحي المتاح'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     Navigator.pop(ctx); // إغلاق النافذة

//     try {
//       String fieldPath = '';
//       if (mainType == 'money') {
//         if (moneyType == 'cash') fieldPath = 'dailyCashBox.cash';
//         if (moneyType == 'network') fieldPath = 'dailyCashBox.network';
//         if (moneyType == 'safeCash') fieldPath = 'safeCash';
//         if (moneyType == 'safeNetwork') fieldPath = 'safeNetwork';
//       } else {
//         if (goldType == 'worked') fieldPath = 'workedGoldByCarat.$carat';
//         if (goldType == 'scrap') fieldPath = 'scrapGoldByCarat.$carat';
//       }

//       await FirebaseFirestore.instance
//           .collection(_obCollection)
//           .doc(_obDocId)
//           .update({
//         fieldPath: FieldValue.increment(-amount),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'lastWithdrawNote': note, // اختياري لحفظ آخر ملاحظة
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             '✅ تم سحب ${_fmt(amount)} ${mainType == 'money' ? 'ر.س' : 'جم'} بنجاح',
//           ),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _loadAll();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // ============================================================
//   // 🔹 جدول
//   // ============================================================
//   Widget _tableContainer({
//     required String title,
//     required List<_RowData> rows,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: goldColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(14),
//                 topRight: Radius.circular(14),
//               ),
//             ),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF444444),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Row(
//               children: [
//                 const Expanded(
//                   flex: 3,
//                   child: Text(
//                     'البند',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF888888),
//                     ),
//                   ),
//                 ),
//                 _headCell('افتتاحي'),
//                 _headCell('حالي'),
//                 _headCell('الفرق'),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFEEEEEE)),
//           ...rows.map(_buildRow).toList(),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   Widget _headCell(String text) {
//     return Expanded(
//       flex: 2,
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF888888),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(_RowData r) {
//     final diff = r.actual - r.opening;
//     final isSame = diff.abs() < 0.01;
//     final color =
//         isSame ? Colors.grey.shade600 : (diff > 0 ? greenColor : redColor);
//     final sign = diff > 0 ? '+' : '';

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               r.label,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               _fmt(r.opening),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               _fmt(r.actual),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               isSame ? '0' : '$sign${_fmt(diff)}',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _RowData _rowData(String label, double opening, double actual,
//       {String unit = 'ر.س'}) {
//     return _RowData(
//       label: label,
//       opening: opening,
//       actual: actual,
//       unit: unit,
//     );
//   }

//   Widget _errorCard(String msg) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Text(
//           msg,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: redColor, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   Widget _infoCard(String msg) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Center(
//         child: Text(
//           msg,
//           style: TextStyle(color: Colors.grey.shade600),
//         ),
//       ),
//     );
//   }
// }

// class _RowData {
//   final String label;
//   final double opening;
//   final double actual;
//   final String unit;
//   _RowData({
//     required this.label,
//     required this.opening,
//     required this.actual,
//     required this.unit,
//   });
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart' hide TextDirection;
// import '../services/firestore_service.dart';

// class OpeningBalanceReportPage extends StatefulWidget {
//   const OpeningBalanceReportPage({super.key});

//   @override
//   State<OpeningBalanceReportPage> createState() =>
//       _OpeningBalanceReportPageState();
// }

// class _OpeningBalanceReportPageState extends State<OpeningBalanceReportPage> {
//   static const Color goldColor = Color(0xFFD4AF37);
//   static const Color greenColor = Color(0xFF2E7D32);
//   static const Color redColor = Color(0xFFC62828);

//   static const String _obCollection = 'opening_balance';
//   static const String _obDocId = 'main';

//   bool _isLoading = true;
//   String? _error;

//   // ===== الافتتاحي =====
//   Map<String, dynamic>? _opening;

//   // ✅ تاريخ الإضافة فقط
//   DateTime? _createdAt;

//   // ===== الفعلي الحالي =====
//   double _curCash = 0;
//   double _curNet = 0;

//   Map<String, double> _curWorkedByCarat = {
//     "24": 0,
//     "22": 0,
//     "21": 0,
//     "18": 0,
//     "14": 0,
//   };

//   Map<String, double> _curScrapByCarat = {
//     "24": 0,
//     "22": 0,
//     "21": 0,
//     "18": 0,
//     "14": 0,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadAll();
//   }

//   // ✅ قراءة التاريخ من Firestore بشكل آمن
//   DateTime? _parseDate(dynamic value) {
//     if (value == null) return null;
//     if (value is Timestamp) return value.toDate();
//     if (value is DateTime) return value;
//     if (value is String) return DateTime.tryParse(value);
//     return null;
//   }

//   // ✅ تنسيق التاريخ (يوم/شهر/سنة فقط — بدون وقت)
//   String _fmtDate(DateTime d) {
//     return DateFormat('dd/MM/yyyy').format(d);
//   }

//   double _safeDouble(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is num) {
//       if (value.isNaN || value.isInfinite) return 0.0;
//       return value.toDouble();
//     }
//     if (value is String) {
//       final cleaned = value.replaceAll(',', '').trim();
//       final parsed = double.tryParse(cleaned);
//       if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
//       return parsed;
//     }
//     return 0.0;
//   }

//   Future<void> _loadAll() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       // 1) الافتتاحي
//       _opening = await FS.getOpeningBalance();

//       // ✅ قراءة تاريخ الإضافة فقط
//       if (_opening != null) {
//         _createdAt = _parseDate(_opening!['createdAt']);

//         // لو مفيش createdAt (سجل قديم)، نستخدم updatedAt كبديل
//         if (_createdAt == null) {
//           _createdAt = _parseDate(_opening!['updatedAt']);
//         }
//       }

//       // 2) الكاش والشبكة الكلي
//       final results = await Future.wait([
//         FS.salesCol().get(),
//         FS.scrapCol().where("type", isEqualTo: "sale").get(),
//         FS.scrapCol().where("type", isEqualTo: "add").get(),
//         FS.vouchersCol().where("type", isEqualTo: "payment").get(),
//         FS.expensesCol().get(),
//         FS.depositsCol().get(),
//         FS.ImportedCol().get(),
//       ]);

//       final salesSnap = results[0];
//       final scrapSaleSnap = results[1];
//       final scrapBuySnap = results[2];
//       final vouchersSnap = results[3];
//       final expSnap = results[4];
//       final depositSnap = results[5];
//       final importSnap = results[6];

//       double cash = 0;
//       double visa = 0;

//       for (var d in salesSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['payment']?['cash']);
//         visa += _safeDouble(data['payment']?['visa']);
//       }

//       for (var d in scrapSaleSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['cash']);
//         visa += _safeDouble(data['network']);
//       }

//       for (var d in scrapBuySnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['network']);
//       }

//       for (var d in vouchersSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['network']);
//       }

//       for (var d in expSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['amount']);
//       }

//       for (var d in depositSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash -= _safeDouble(data['cash']);
//         visa -= _safeDouble(data['visa']);
//       }

//       for (var d in importSnap.docs) {
//         final data = d.data() as Map<String, dynamic>;
//         cash += _safeDouble(data['cash']);
//         visa += _safeDouble(data['visa']);
//       }

//       _curCash = cash;
//       _curNet = visa;

//       // 3) الذهب المشغول
//       try {
//         final itemsSnap = await FS.itemsCol().get();
//         _curWorkedByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

//         for (var doc in itemsSnap.docs) {
//           final data = doc.data() as Map<String, dynamic>;
//           if (data['category'] != 'gold') continue;

//           final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//           final weight = _safeDouble(payload['weight']);
//           final carat = payload['carat']?.toString() ?? '';

//           if (_curWorkedByCarat.containsKey(carat)) {
//             _curWorkedByCarat[carat] = _curWorkedByCarat[carat]! + weight;
//           }
//         }
//       } catch (_) {}

//       // 4) الكسر
//       try {
//         final scrapAllSnap = await FS.scrapCol().get();
//         _curScrapByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

//         for (var doc in scrapAllSnap.docs) {
//           final t = doc.data() as Map<String, dynamic>;
//           final type = (t['type'] ?? '').toString();

//           if (type == 'payment' &&
//               t['carats'] != null &&
//               (t['carats'] as List).isNotEmpty) {
//             for (var c in t['carats']) {
//               final carat = (c['carat'] ?? '18').toString();
//               final weight = _safeDouble(c['weight']);
//               if (_curScrapByCarat.containsKey(carat)) {
//                 _curScrapByCarat[carat] =
//                     _curScrapByCarat[carat]! - weight.abs();
//               }
//             }
//             continue;
//           }

//           final carat = (t['carat'] ?? '18').toString();
//           final weight = _safeDouble(t['weight']);
//           if (!_curScrapByCarat.containsKey(carat)) continue;

//           if (type == 'add' || type == 'transform') {
//             _curScrapByCarat[carat] = _curScrapByCarat[carat]! + weight;
//           } else if (type == 'sale' || type == 'payment') {
//             _curScrapByCarat[carat] = _curScrapByCarat[carat]! - weight.abs();
//           }
//         }
//       } catch (_) {}

//       if (mounted) setState(() => _isLoading = false);
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _error = e.toString();
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   double _to24(double w, String carat) {
//     final c = _safeDouble(carat);
//     return w * (c / 24);
//   }

//   String _fmt(dynamic v) {
//     if (v == null) return '0';
//     final d = _safeDouble(v);
//     if (d == 0) return '0';

//     final isNegative = d < 0;
//     final abs = d.abs();

//     String intPart;
//     String decPart = '';

//     if (abs == abs.roundToDouble()) {
//       intPart = abs.toInt().toString();
//     } else {
//       final str = abs.toStringAsFixed(2);
//       final parts = str.split('.');
//       intPart = parts[0];
//       decPart = '.${parts[1]}';
//     }

//     final buffer = StringBuffer();
//     for (int i = 0; i < intPart.length; i++) {
//       if (i > 0 && (intPart.length - i) % 3 == 0) {
//         buffer.write(',');
//       }
//       buffer.write(intPart[i]);
//     }

//     final formatted = '${buffer.toString()}$decPart';
//     return isNegative ? '-$formatted' : formatted;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text(
//           'مقارنة الرصيد الافتتاحي',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: goldColor,
//         centerTitle: true,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _isLoading ? null : _loadAll,
//           ),
//         ],
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator(color: goldColor))
//             : _error != null
//                 ? _errorCard('خطأ: $_error')
//                 : RefreshIndicator(
//                     color: goldColor,
//                     onRefresh: _loadAll,
//                     child: _buildBody(),
//                   ),
//       ),
//       floatingActionButton: _opening == null || _isLoading
//           ? null
//           : FloatingActionButton.extended(
//               onPressed: () => _showUnifiedWithdrawSheet(),
//               backgroundColor: goldColor,
//               icon:
//                   const Icon(Icons.remove_circle_outline, color: Colors.white),
//               label: const Text(
//                 'سحب من الرصيد',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildBody() {
//     if (_opening == null) {
//       return ListView(
//         children: [
//           const SizedBox(height: 100),
//           _infoCard('لا يوجد رصيد افتتاحي مسجل'),
//         ],
//       );
//     }

//     final o = _opening!;
//     final daily = o['dailyCashBox'] ?? {};
//     final scrap = o['scrapGoldByCarat'] ?? {};
//     final worked = o['workedGoldByCarat'] ?? {};

//     final oCash = _safeDouble(daily['cash']);
//     final oNet = _safeDouble(daily['network']);

//     final oSafeCash = _safeDouble(o['safeCash']);
//     final oSafeNet = _safeDouble(o['safeNetwork']);

//     double oScrapGold24 = 0, oWorkedGold24 = 0;
//     for (var c in ['24', '22', '21', '18', '14']) {
//       oScrapGold24 += _to24(_safeDouble(scrap[c]), c);
//       oWorkedGold24 += _to24(_safeDouble(worked[c]), c);
//     }

//     double cScrapGold24 = 0, cWorkedGold24 = 0;
//     _curScrapByCarat.forEach((c, w) {
//       cScrapGold24 += _to24(w, c);
//     });
//     _curWorkedByCarat.forEach((c, w) {
//       cWorkedGold24 += _to24(w, c);
//     });

//     return ListView(
//       padding: const EdgeInsets.all(14),
//       children: [
//         // ✅ كارت تاريخ الإضافة
//         _createdAtCard(),
//         const SizedBox(height: 12),

//         _bigCard(
//           label: 'الكاش',
//           opening: oCash,
//           actual: _curCash,
//           unit: 'ر.س',
//           icon: Icons.money,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الشبكة',
//           opening: oNet,
//           actual: _curNet,
//           unit: 'ر.س',
//           icon: Icons.wifi,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الخزنة - كاش',
//           opening: oSafeCash,
//           actual: 0,
//           unit: 'ر.س',
//           icon: Icons.account_balance_wallet,
//           hideCompare: true,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الخزنة - شبكة',
//           opening: oSafeNet,
//           actual: 0,
//           unit: 'ر.س',
//           icon: Icons.account_balance_wallet,
//           hideCompare: true,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الذهب المشغول',
//           opening: oWorkedGold24,
//           actual: cWorkedGold24,
//           unit: 'جم',
//           icon: Icons.work,
//         ),
//         const SizedBox(height: 10),

//         _bigCard(
//           label: 'الكسر',
//           opening: oScrapGold24,
//           actual: cScrapGold24,
//           unit: 'جم',
//           icon: Icons.crisis_alert,
//         ),
//         const SizedBox(height: 20),

//         _tableContainer(
//           title: 'الذهب المشغول - حسب العيار',
//           rows: [
//             for (var c in ['24', '22', '21', '18', '14'])
//               _rowData(
//                 'عيار $c',
//                 _safeDouble(worked[c]),
//                 _curWorkedByCarat[c] ?? 0,
//                 unit: 'جم',
//               ),
//           ],
//         ),
//         const SizedBox(height: 16),

//         _tableContainer(
//           title: 'الكسر - حسب العيار',
//           rows: [
//             for (var c in ['24', '22', '21', '18', '14'])
//               _rowData(
//                 'عيار $c',
//                 _safeDouble(scrap[c]),
//                 _curScrapByCarat[c] ?? 0,
//                 unit: 'جم',
//               ),
//           ],
//         ),

//         const SizedBox(height: 16),

//         _loansSection(o['loans']),

//         const SizedBox(height: 80),
//       ],
//     );
//   }

//   // ============================================================
//   // ✅ كارت تاريخ الإضافة فقط
//   // ============================================================
//   Widget _createdAtCard() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             goldColor.withOpacity(0.12),
//             goldColor.withOpacity(0.04),
//           ],
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//         ),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.35)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: goldColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(
//               Icons.event_available,
//               color: goldColor,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'تاريخ إضافة الرصيد الافتتاحي',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF666666),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _createdAt != null ? _fmtDate(_createdAt!) : 'غير متوفر',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: _createdAt != null
//                         ? const Color(0xFF333333)
//                         : Colors.grey.shade500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 كارت كبير
//   // ============================================================
//   Widget _bigCard({
//     required String label,
//     required double opening,
//     required double actual,
//     required String unit,
//     required IconData icon,
//     bool hideCompare = false,
//   }) {
//     final diff = actual - opening;
//     final isSame = diff.abs() < 0.01;
//     final color =
//         isSame ? Colors.grey.shade700 : (diff > 0 ? greenColor : redColor);
//     final sign = diff > 0 ? '+' : '';

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: goldColor.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: goldColor, size: 18),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (hideCompare)
//             _valueBox(
//                 'الرصيد الافتتاحي', opening, unit, const Color(0xFF333333))
//           else
//             Row(
//               children: [
//                 Expanded(
//                   child:
//                       _valueBox('افتتاحي', opening, unit, Colors.grey.shade600),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child:
//                       _valueBox('حالي', actual, unit, const Color(0xFF333333)),
//                 ),
//               ],
//             ),
//           if (!hideCompare) ...[
//             const SizedBox(height: 10),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     isSame
//                         ? Icons.remove
//                         : (diff > 0
//                             ? Icons.arrow_upward
//                             : Icons.arrow_downward),
//                     size: 14,
//                     color: color,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'الفرق: $sign${_fmt(diff)} $unit',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _valueBox(String label, double value, String unit, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
//           ),
//           const SizedBox(height: 2),
//           FittedBox(
//             fit: BoxFit.scaleDown,
//             alignment: Alignment.centerRight,
//             child: Text(
//               '${_fmt(value)} $unit',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 قسم القروض
//   // ============================================================
//   Widget _loansSection(dynamic loansData) {
//     List<Map<String, dynamic>> loans = [];
//     if (loansData is List) {
//       for (var l in loansData) {
//         if (l is Map) {
//           loans.add(Map<String, dynamic>.from(l));
//         }
//       }
//     }

//     double total = 0;
//     for (var l in loans) {
//       total += _safeDouble(l['amount']);
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: goldColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(14),
//                 topRight: Radius.circular(14),
//               ),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.account_balance, color: goldColor, size: 18),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     'القروض على المحل - الرصيد الافتتاحي',
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF444444),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: goldColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     'الإجمالي: ${_fmt(total)} ر.س',
//                     style: const TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (loans.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Text(
//                 'لا توجد قروض مسجلة',
//                 style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
//               ),
//             )
//           else ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Row(
//                 children: const [
//                   Expanded(
//                     flex: 4,
//                     child: Text(
//                       'الجهة / البيان',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF888888),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Text(
//                       'المبلغ',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF888888),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 40),
//                 ],
//               ),
//             ),
//             const Divider(height: 1, color: Color(0xFFEEEEEE)),
//             ...loans.asMap().entries.map((entry) {
//               final idx = entry.key;
//               final loan = entry.value;
//               final name = (loan['name'] ?? '').toString();
//               final amount = _safeDouble(loan['amount']);
//               return Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 4,
//                       child: Text(
//                         name.isEmpty ? '—' : name,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         _fmt(amount),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                           color: redColor,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: IconButton(
//                         icon: const Icon(Icons.delete_outline,
//                             color: Colors.red, size: 20),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                         tooltip: 'حذف / تسوية القرض',
//                         onPressed: () => _removeLoan(idx),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   Future<void> _removeLoan(int index) async {
//     final o = _opening;
//     if (o == null) return;

//     final loansData = o['loans'];
//     if (loansData is! List) return;

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'تأكيد الحذف',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         content: const Text('سيتم حذف هذا القرض من الرصيد الافتتاحي نهائياً.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: redColor),
//             onPressed: () => Navigator.pop(ctx, true),
//             child: const Text(
//               'حذف',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     try {
//       final updated = List<Map<String, dynamic>>.from(
//         loansData.map((e) => Map<String, dynamic>.from(e as Map)),
//       );
//       updated.removeAt(index);

//       await FirebaseFirestore.instance
//           .collection(_obCollection)
//           .doc(_obDocId)
//           .update({
//         'loans': updated,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ تم حذف القرض من الرصيد الافتتاحي'),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _loadAll();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   // ============================================================
//   // 🔹 نافذة السحب الموحدة
//   // ============================================================
//   void _showUnifiedWithdrawSheet() {
//     final o = _opening;
//     if (o == null) return;

//     String mainType = 'money';
//     String moneyType = 'cash';
//     String goldType = 'worked';
//     String selectedCarat = '21';

//     final amountController = TextEditingController();
//     final noteController = TextEditingController();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) {
//         return StatefulBuilder(
//           builder: (context, setSt) {
//             double available = 0;
//             if (mainType == 'money') {
//               if (moneyType == 'cash') {
//                 available = _safeDouble((o['dailyCashBox'] ?? {})['cash']);
//               } else if (moneyType == 'network') {
//                 available = _safeDouble((o['dailyCashBox'] ?? {})['network']);
//               } else if (moneyType == 'safeCash') {
//                 available = _safeDouble(o['safeCash']);
//               } else if (moneyType == 'safeNetwork') {
//                 available = _safeDouble(o['safeNetwork']);
//               }
//             } else {
//               if (goldType == 'worked') {
//                 available =
//                     _safeDouble((o['workedGoldByCarat'] ?? {})[selectedCarat]);
//               } else {
//                 available =
//                     _safeDouble((o['scrapGoldByCarat'] ?? {})[selectedCarat]);
//               }
//             }

//             return Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//               ),
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//                 top: 16,
//                 left: 16,
//                 right: 16,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         const Icon(Icons.remove_circle_outline,
//                             color: goldColor, size: 24),
//                         const SizedBox(width: 8),
//                         const Text(
//                           'سحب من الرصيد الافتتاحي',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF333333),
//                           ),
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () => Navigator.pop(ctx),
//                           icon: const Icon(Icons.close, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade50,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.orange.shade200),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info_outline,
//                               color: Colors.orange, size: 20),
//                           const SizedBox(width: 8),
//                           const Expanded(
//                             child: Text(
//                               'الخصم هيتم من الرصيد الافتتاحي فقط، الرصيد الحالي مش هيتأثر.',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.all(4),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'كاش / شبكة',
//                               isSelected: mainType == 'money',
//                               onTap: () => setSt(() => mainType = 'money'),
//                             ),
//                           ),
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'ذهب',
//                               isSelected: mainType == 'gold',
//                               onTap: () => setSt(() => mainType = 'gold'),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     if (mainType == 'money') ...[
//                       DropdownButtonFormField<String>(
//                         value: moneyType,
//                         isExpanded: true,
//                         decoration: InputDecoration(
//                           labelText: 'نوع الرصيد',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           prefixIcon: const Icon(Icons.money, color: goldColor),
//                         ),
//                         items: const [
//                           DropdownMenuItem(value: 'cash', child: Text('الكاش')),
//                           DropdownMenuItem(
//                               value: 'network', child: Text('الشبكة')),
//                           DropdownMenuItem(
//                               value: 'safeCash', child: Text('الخزنة - كاش')),
//                           DropdownMenuItem(
//                               value: 'safeNetwork',
//                               child: Text('الخزنة - شبكة')),
//                         ],
//                         onChanged: (v) => setSt(() => moneyType = v!),
//                       ),
//                     ],
//                     if (mainType == 'gold') ...[
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'مشغول',
//                               isSelected: goldType == 'worked',
//                               onTap: () => setSt(() => goldType = 'worked'),
//                               isSmall: true,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _buildToggleButton(
//                               text: 'كسر',
//                               isSelected: goldType == 'scrap',
//                               onTap: () => setSt(() => goldType = 'scrap'),
//                               isSmall: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       DropdownButtonFormField<String>(
//                         value: selectedCarat,
//                         isExpanded: true,
//                         decoration: InputDecoration(
//                           labelText: 'العيار',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           prefixIcon:
//                               const Icon(Icons.diamond, color: goldColor),
//                         ),
//                         items: const ['24', '22', '21', '18', '14']
//                             .map((c) => DropdownMenuItem(
//                                   value: c,
//                                   child: Text('عيار $c'),
//                                 ))
//                             .toList(),
//                         onChanged: (v) => setSt(() => selectedCarat = v!),
//                       ),
//                     ],
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: goldColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.info, color: goldColor, size: 20),
//                           const SizedBox(width: 8),
//                           Text(
//                             'المتاح: ${_fmt(available)} ${mainType == 'money' ? 'ر.س' : 'جم'}',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF333333),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: amountController,
//                       keyboardType:
//                           const TextInputType.numberWithOptions(decimal: true),
//                       decoration: InputDecoration(
//                         labelText: mainType == 'money'
//                             ? 'المبلغ المسحوب (ر.س)'
//                             : 'الوزن المسحوب (جم)',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: Icon(
//                           mainType == 'money' ? Icons.money : Icons.scale,
//                           color: goldColor,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: noteController,
//                       decoration: InputDecoration(
//                         labelText: 'ملاحظة (اختياري)',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         prefixIcon: const Icon(Icons.note, color: goldColor),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton.icon(
//                         onPressed: () => _executeWithdraw(
//                           ctx: ctx,
//                           mainType: mainType,
//                           moneyType: moneyType,
//                           goldType: goldType,
//                           carat: selectedCarat,
//                           amount: _safeDouble(amountController.text),
//                           note: noteController.text.trim(),
//                           available: available,
//                         ),
//                         icon: const Icon(Icons.check, color: Colors.white),
//                         label: const Text(
//                           'تأكيد السحب',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: goldColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildToggleButton({
//     required String text,
//     required bool isSelected,
//     required VoidCallback onTap,
//     bool isSmall = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: isSmall ? 10 : 12),
//         decoration: BoxDecoration(
//           color: isSelected ? goldColor : Colors.transparent,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: isSmall ? 14 : 15,
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.white : Colors.grey.shade600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _executeWithdraw({
//     required BuildContext ctx,
//     required String mainType,
//     required String moneyType,
//     required String goldType,
//     required String carat,
//     required double amount,
//     required String note,
//     required double available,
//   }) async {
//     if (amount <= 0) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('الرجاء إدخال قيمة صحيحة أكبر من صفر'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (amount > available) {
//       ScaffoldMessenger.of(ctx).showSnackBar(
//         const SnackBar(
//           content: Text('القيمة أكبر من الرصيد الافتتاحي المتاح'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     Navigator.pop(ctx);

//     try {
//       String fieldPath = '';
//       if (mainType == 'money') {
//         if (moneyType == 'cash') fieldPath = 'dailyCashBox.cash';
//         if (moneyType == 'network') fieldPath = 'dailyCashBox.network';
//         if (moneyType == 'safeCash') fieldPath = 'safeCash';
//         if (moneyType == 'safeNetwork') fieldPath = 'safeNetwork';
//       } else {
//         if (goldType == 'worked') fieldPath = 'workedGoldByCarat.$carat';
//         if (goldType == 'scrap') fieldPath = 'scrapGoldByCarat.$carat';
//       }

//       await FirebaseFirestore.instance
//           .collection(_obCollection)
//           .doc(_obDocId)
//           .update({
//         fieldPath: FieldValue.increment(-amount),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'lastWithdrawNote': note,
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             '✅ تم سحب ${_fmt(amount)} ${mainType == 'money' ? 'ر.س' : 'جم'} بنجاح',
//           ),
//           backgroundColor: Colors.green,
//         ),
//       );
//       _loadAll();
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   Widget _tableContainer({
//     required String title,
//     required List<_RowData> rows,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: goldColor.withOpacity(0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: goldColor.withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(14),
//                 topRight: Radius.circular(14),
//               ),
//             ),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF444444),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             child: Row(
//               children: [
//                 const Expanded(
//                   flex: 3,
//                   child: Text(
//                     'البند',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF888888),
//                     ),
//                   ),
//                 ),
//                 _headCell('افتتاحي'),
//                 _headCell('حالي'),
//                 _headCell('الفرق'),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: Color(0xFFEEEEEE)),
//           ...rows.map(_buildRow).toList(),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }

//   Widget _headCell(String text) {
//     return Expanded(
//       flex: 2,
//       child: Text(
//         text,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF888888),
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(_RowData r) {
//     final diff = r.actual - r.opening;
//     final isSame = diff.abs() < 0.01;
//     final color =
//         isSame ? Colors.grey.shade600 : (diff > 0 ? greenColor : redColor);
//     final sign = diff > 0 ? '+' : '';

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               r.label,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               _fmt(r.opening),
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               _fmt(r.actual),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               isSame ? '0' : '$sign${_fmt(diff)}',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _RowData _rowData(String label, double opening, double actual,
//       {String unit = 'ر.س'}) {
//     return _RowData(
//       label: label,
//       opening: opening,
//       actual: actual,
//       unit: unit,
//     );
//   }

//   Widget _errorCard(String msg) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Text(
//           msg,
//           textAlign: TextAlign.center,
//           style: const TextStyle(color: redColor, fontSize: 14),
//         ),
//       ),
//     );
//   }

//   Widget _infoCard(String msg) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Center(
//         child: Text(
//           msg,
//           style: TextStyle(color: Colors.grey.shade600),
//         ),
//       ),
//     );
//   }
// }

// class _RowData {
//   final String label;
//   final double opening;
//   final double actual;
//   final String unit;
//   _RowData({
//     required this.label,
//     required this.opening,
//     required this.actual,
//     required this.unit,
//   });
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../services/firestore_service.dart';

class OpeningBalanceReportPage extends StatefulWidget {
  const OpeningBalanceReportPage({super.key});

  @override
  State<OpeningBalanceReportPage> createState() =>
      _OpeningBalanceReportPageState();
}

class _OpeningBalanceReportPageState extends State<OpeningBalanceReportPage> {
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color greenColor = Color(0xFF2E7D32);
  static const Color redColor = Color(0xFFC62828);

  static const String _obCollection = 'opening_balance';
  static const String _obDocId = 'main';

  bool _isLoading = true;
  String? _error;

  // ===== الافتتاحي =====
  Map<String, dynamic>? _opening;

  // ✅ تاريخ الإضافة فقط
  DateTime? _createdAt;

  // ===== الفعلي الحالي =====
  double _curCash = 0;
  double _curNet = 0;
  double _curSafeCash = 0; // ✅ جديد
  double _curSafeNetwork = 0; // ✅ جديد

  Map<String, double> _curWorkedByCarat = {
    "24": 0,
    "22": 0,
    "21": 0,
    "18": 0,
    "14": 0,
  };

  Map<String, double> _curScrapByCarat = {
    "24": 0,
    "22": 0,
    "21": 0,
    "18": 0,
    "14": 0,
  };

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  // ✅ قراءة التاريخ من Firestore بشكل آمن
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  // ✅ تنسيق التاريخ (يوم/شهر/سنة فقط — بدون وقت)
  String _fmtDate(DateTime d) {
    return DateFormat('dd/MM/yyyy').format(d);
  }

  double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) {
      if (value.isNaN || value.isInfinite) return 0.0;
      return value.toDouble();
    }
    if (value is String) {
      final cleaned = value.replaceAll(',', '').trim();
      final parsed = double.tryParse(cleaned);
      if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
      return parsed;
    }
    return 0.0;
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1) الافتتاحي
      _opening = await FS.getOpeningBalance();

      // ✅ قراءة تاريخ الإضافة فقط
      if (_opening != null) {
        _createdAt = _parseDate(_opening!['createdAt']);

        // لو مفيش createdAt (سجل قديم)، نستخدم updatedAt كبديل
        if (_createdAt == null) {
          _createdAt = _parseDate(_opening!['updatedAt']);
        }
      }

      // 2) الكاش والشبكة الكلي
      final results = await Future.wait([
        FS.salesCol().get(),
        FS.scrapCol().where("type", isEqualTo: "sale").get(),
        FS.scrapCol().where("type", isEqualTo: "add").get(),
        FS.vouchersCol().where("type", isEqualTo: "payment").get(),
        FS.expensesCol().get(),
        FS.depositsCol().get(),
        FS.ImportedCol().get(),
      ]);

      final salesSnap = results[0];
      final scrapSaleSnap = results[1];
      final scrapBuySnap = results[2];
      final vouchersSnap = results[3];
      final expSnap = results[4];
      final depositSnap = results[5];
      final importSnap = results[6];

      double cash = 0;
      double visa = 0;

      for (var d in salesSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash += _safeDouble(data['payment']?['cash']);
        visa += _safeDouble(data['payment']?['visa']);
      }

      for (var d in scrapSaleSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash += _safeDouble(data['cash']);
        visa += _safeDouble(data['network']);
      }

      for (var d in scrapBuySnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash -= _safeDouble(data['cash']);
        visa -= _safeDouble(data['network']);
      }

      for (var d in vouchersSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash -= _safeDouble(data['cash']);
        visa -= _safeDouble(data['network']);
      }

      for (var d in expSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash -= _safeDouble(data['amount']);
      }

      for (var d in depositSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash -= _safeDouble(data['cash']);
        visa -= _safeDouble(data['visa']);
      }

      for (var d in importSnap.docs) {
        final data = d.data() as Map<String, dynamic>;
        cash += _safeDouble(data['cash']);
        visa += _safeDouble(data['visa']);
      }

      _curCash = cash;
      _curNet = visa;

      // ✅ قراءة رصيد الخزنة الحالي (كاش + شبكة)
      try {
        final safeBal = await FS.getCashBoxBalance();
        _curSafeCash = _safeDouble(safeBal['cash']);
        _curSafeNetwork = _safeDouble(safeBal['network']);
      } catch (e) {
        _curSafeCash = 0;
        _curSafeNetwork = 0;
        print('Error loading safe balance: $e');
      }

      // 3) الذهب المشغول
      try {
        final itemsSnap = await FS.itemsCol().get();
        _curWorkedByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

        for (var doc in itemsSnap.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['category'] != 'gold') continue;

          final payload = Map<String, dynamic>.from(data['payload'] ?? {});
          final weight = _safeDouble(payload['weight']);
          final carat = payload['carat']?.toString() ?? '';

          if (_curWorkedByCarat.containsKey(carat)) {
            _curWorkedByCarat[carat] = _curWorkedByCarat[carat]! + weight;
          }
        }
      } catch (_) {}

      // 4) الكسر
      try {
        final scrapAllSnap = await FS.scrapCol().get();
        _curScrapByCarat = {"24": 0, "22": 0, "21": 0, "18": 0, "14": 0};

        for (var doc in scrapAllSnap.docs) {
          final t = doc.data() as Map<String, dynamic>;
          final type = (t['type'] ?? '').toString();

          if (type == 'payment' &&
              t['carats'] != null &&
              (t['carats'] as List).isNotEmpty) {
            for (var c in t['carats']) {
              final carat = (c['carat'] ?? '18').toString();
              final weight = _safeDouble(c['weight']);
              if (_curScrapByCarat.containsKey(carat)) {
                _curScrapByCarat[carat] =
                    _curScrapByCarat[carat]! - weight.abs();
              }
            }
            continue;
          }

          final carat = (t['carat'] ?? '18').toString();
          final weight = _safeDouble(t['weight']);
          if (!_curScrapByCarat.containsKey(carat)) continue;

          if (type == 'add' || type == 'transform') {
            _curScrapByCarat[carat] = _curScrapByCarat[carat]! + weight;
          } else if (type == 'sale' || type == 'payment') {
            _curScrapByCarat[carat] = _curScrapByCarat[carat]! - weight.abs();
          }
        }
      } catch (_) {}

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  double _to24(double w, String carat) {
    final c = _safeDouble(carat);
    return w * (c / 24);
  }

  String _fmt(dynamic v) {
    if (v == null) return '0';
    final d = _safeDouble(v);
    if (d == 0) return '0';

    final isNegative = d < 0;
    final abs = d.abs();

    String intPart;
    String decPart = '';

    if (abs == abs.roundToDouble()) {
      intPart = abs.toInt().toString();
    } else {
      final str = abs.toStringAsFixed(2);
      final parts = str.split('.');
      intPart = parts[0];
      decPart = '.${parts[1]}';
    }

    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }

    final formatted = '${buffer.toString()}$decPart';
    return isNegative ? '-$formatted' : formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'مقارنة الرصيد الافتتاحي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: goldColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isLoading ? null : _loadAll,
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: goldColor))
            : _error != null
                ? _errorCard('خطأ: $_error')
                : RefreshIndicator(
                    color: goldColor,
                    onRefresh: _loadAll,
                    child: _buildBody(),
                  ),
      ),
      floatingActionButton: _opening == null || _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showUnifiedWithdrawSheet(),
              backgroundColor: goldColor,
              icon:
                  const Icon(Icons.remove_circle_outline, color: Colors.white),
              label: const Text(
                'سحب من الرصيد',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
    );
  }

  Widget _buildBody() {
    if (_opening == null) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          _infoCard('لا يوجد رصيد افتتاحي مسجل'),
        ],
      );
    }

    final o = _opening!;
    final daily = o['dailyCashBox'] ?? {};
    final scrap = o['scrapGoldByCarat'] ?? {};
    final worked = o['workedGoldByCarat'] ?? {};

    final oCash = _safeDouble(daily['cash']);
    final oNet = _safeDouble(daily['network']);

    final oSafeCash = _safeDouble(o['safeCash']);
    final oSafeNet = _safeDouble(o['safeNetwork']);

    double oScrapGold24 = 0, oWorkedGold24 = 0;
    for (var c in ['24', '22', '21', '18', '14']) {
      oScrapGold24 += _to24(_safeDouble(scrap[c]), c);
      oWorkedGold24 += _to24(_safeDouble(worked[c]), c);
    }

    double cScrapGold24 = 0, cWorkedGold24 = 0;
    _curScrapByCarat.forEach((c, w) {
      cScrapGold24 += _to24(w, c);
    });
    _curWorkedByCarat.forEach((c, w) {
      cWorkedGold24 += _to24(w, c);
    });

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // ✅ كارت تاريخ الإضافة
        _createdAtCard(),
        const SizedBox(height: 12),

        _bigCard(
          label: 'الكاش',
          opening: oCash,
          actual: _curCash,
          unit: 'ر.س',
          icon: Icons.money,
        ),
        const SizedBox(height: 10),

        _bigCard(
          label: 'الشبكة',
          opening: oNet,
          actual: _curNet,
          unit: 'ر.س',
          icon: Icons.wifi,
        ),
        const SizedBox(height: 10),

        // ✅ الخزنة - كاش (الآن مع الرصيد الحالي والمقارنة)
        _bigCard(
          label: 'الخزنة - كاش',
          opening: oSafeCash,
          actual: _curSafeCash,
          unit: 'ر.س',
          icon: Icons.account_balance_wallet,
        ),
        const SizedBox(height: 10),

        // ✅ الخزنة - شبكة (الآن مع الرصيد الحالي والمقارنة)
        _bigCard(
          label: 'الخزنة - شبكة',
          opening: oSafeNet,
          actual: _curSafeNetwork,
          unit: 'ر.س',
          icon: Icons.account_balance_wallet,
        ),
        const SizedBox(height: 10),

        _bigCard(
          label: 'الذهب المشغول',
          opening: oWorkedGold24,
          actual: cWorkedGold24,
          unit: 'جم',
          icon: Icons.work,
        ),
        const SizedBox(height: 10),

        _bigCard(
          label: 'الكسر',
          opening: oScrapGold24,
          actual: cScrapGold24,
          unit: 'جم',
          icon: Icons.crisis_alert,
        ),
        const SizedBox(height: 20),

        _tableContainer(
          title: 'الذهب المشغول - حسب العيار',
          rows: [
            for (var c in ['24', '22', '21', '18', '14'])
              _rowData(
                'عيار $c',
                _safeDouble(worked[c]),
                _curWorkedByCarat[c] ?? 0,
                unit: 'جم',
              ),
          ],
        ),
        const SizedBox(height: 16),

        _tableContainer(
          title: 'الكسر - حسب العيار',
          rows: [
            for (var c in ['24', '22', '21', '18', '14'])
              _rowData(
                'عيار $c',
                _safeDouble(scrap[c]),
                _curScrapByCarat[c] ?? 0,
                unit: 'جم',
              ),
          ],
        ),

        const SizedBox(height: 16),

        _loansSection(o['loans']),

        const SizedBox(height: 80),
      ],
    );
  }

  // ============================================================
  // ✅ كارت تاريخ الإضافة فقط
  // ============================================================
  Widget _createdAtCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            goldColor.withOpacity(0.12),
            goldColor.withOpacity(0.04),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldColor.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.event_available,
              color: goldColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تاريخ إضافة الرصيد الافتتاحي',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _createdAt != null ? _fmtDate(_createdAt!) : 'غير متوفر',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _createdAt != null
                        ? const Color(0xFF333333)
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 كارت كبير
  // ============================================================
  Widget _bigCard({
    required String label,
    required double opening,
    required double actual,
    required String unit,
    required IconData icon,
    bool hideCompare = false,
  }) {
    final diff = actual - opening;
    final isSame = diff.abs() < 0.01;
    final color =
        isSame ? Colors.grey.shade700 : (diff > 0 ? greenColor : redColor);
    final sign = diff > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: goldColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (hideCompare)
            _valueBox(
                'الرصيد الافتتاحي', opening, unit, const Color(0xFF333333))
          else
            Row(
              children: [
                Expanded(
                  child:
                      _valueBox('افتتاحي', opening, unit, Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      _valueBox('حالي', actual, unit, const Color(0xFF333333)),
                ),
              ],
            ),
          if (!hideCompare) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSame
                        ? Icons.remove
                        : (diff > 0
                            ? Icons.arrow_upward
                            : Icons.arrow_downward),
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'الفرق: $sign${_fmt(diff)} $unit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _valueBox(String label, double value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '${_fmt(value)} $unit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 قسم القروض
  // ============================================================
  Widget _loansSection(dynamic loansData) {
    List<Map<String, dynamic>> loans = [];
    if (loansData is List) {
      for (var l in loansData) {
        if (l is Map) {
          loans.add(Map<String, dynamic>.from(l));
        }
      }
    }

    double total = 0;
    for (var l in loans) {
      total += _safeDouble(l['amount']);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: goldColor, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'القروض على المحل - الرصيد الافتتاحي',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF444444),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: goldColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'الإجمالي: ${_fmt(total)} ر.س',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (loans.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'لا توجد قروض مسجلة',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'الجهة / البيان',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'المبلغ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            ...loans.asMap().entries.map((entry) {
              final idx = entry.key;
              final loan = entry.value;
              final name = (loan['name'] ?? '').toString();
              final amount = _safeDouble(loan['amount']);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        name.isEmpty ? '—' : name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _fmt(amount),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: redColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'حذف / تسوية القرض',
                        onPressed: () => _removeLoan(idx),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Future<void> _removeLoan(int index) async {
    final o = _opening;
    if (o == null) return;

    final loansData = o['loans'];
    if (loansData is! List) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تأكيد الحذف',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: const Text('سيتم حذف هذا القرض من الرصيد الافتتاحي نهائياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: redColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final updated = List<Map<String, dynamic>>.from(
        loansData.map((e) => Map<String, dynamic>.from(e as Map)),
      );
      updated.removeAt(index);

      await FirebaseFirestore.instance
          .collection(_obCollection)
          .doc(_obDocId)
          .update({
        'loans': updated,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ تم حذف القرض من الرصيد الافتتاحي'),
          backgroundColor: Colors.green,
        ),
      );
      _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // ============================================================
  // 🔹 نافذة السحب الموحدة
  // ============================================================
  void _showUnifiedWithdrawSheet() {
    final o = _opening;
    if (o == null) return;

    String mainType = 'money';
    String moneyType = 'cash';
    String goldType = 'worked';
    String selectedCarat = '21';

    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSt) {
            double available = 0;
            if (mainType == 'money') {
              if (moneyType == 'cash') {
                available = _safeDouble((o['dailyCashBox'] ?? {})['cash']);
              } else if (moneyType == 'network') {
                available = _safeDouble((o['dailyCashBox'] ?? {})['network']);
              } else if (moneyType == 'safeCash') {
                available = _safeDouble(o['safeCash']);
              } else if (moneyType == 'safeNetwork') {
                available = _safeDouble(o['safeNetwork']);
              }
            } else {
              if (goldType == 'worked') {
                available =
                    _safeDouble((o['workedGoldByCarat'] ?? {})[selectedCarat]);
              } else {
                available =
                    _safeDouble((o['scrapGoldByCarat'] ?? {})[selectedCarat]);
              }
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
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
                        const Icon(Icons.remove_circle_outline,
                            color: goldColor, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'سحب من الرصيد الافتتاحي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'الخصم هيتم من الرصيد الافتتاحي فقط، الرصيد الحالي مش هيتأثر.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildToggleButton(
                              text: 'كاش / شبكة',
                              isSelected: mainType == 'money',
                              onTap: () => setSt(() => mainType = 'money'),
                            ),
                          ),
                          Expanded(
                            child: _buildToggleButton(
                              text: 'ذهب',
                              isSelected: mainType == 'gold',
                              onTap: () => setSt(() => mainType = 'gold'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (mainType == 'money') ...[
                      DropdownButtonFormField<String>(
                        value: moneyType,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'نوع الرصيد',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.money, color: goldColor),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'cash', child: Text('الكاش')),
                          DropdownMenuItem(
                              value: 'network', child: Text('الشبكة')),
                          DropdownMenuItem(
                              value: 'safeCash', child: Text('الخزنة - كاش')),
                          DropdownMenuItem(
                              value: 'safeNetwork',
                              child: Text('الخزنة - شبكة')),
                        ],
                        onChanged: (v) => setSt(() => moneyType = v!),
                      ),
                    ],
                    if (mainType == 'gold') ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildToggleButton(
                              text: 'مشغول',
                              isSelected: goldType == 'worked',
                              onTap: () => setSt(() => goldType = 'worked'),
                              isSmall: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildToggleButton(
                              text: 'كسر',
                              isSelected: goldType == 'scrap',
                              onTap: () => setSt(() => goldType = 'scrap'),
                              isSmall: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCarat,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'العيار',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon:
                              const Icon(Icons.diamond, color: goldColor),
                        ),
                        items: const ['24', '22', '21', '18', '14']
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text('عيار $c'),
                                ))
                            .toList(),
                        onChanged: (v) => setSt(() => selectedCarat = v!),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: goldColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: goldColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'المتاح: ${_fmt(available)} ${mainType == 'money' ? 'ر.س' : 'جم'}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: mainType == 'money'
                            ? 'المبلغ المسحوب (ر.س)'
                            : 'الوزن المسحوب (جم)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(
                          mainType == 'money' ? Icons.money : Icons.scale,
                          color: goldColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: 'ملاحظة (اختياري)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.note, color: goldColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => _executeWithdraw(
                          ctx: ctx,
                          mainType: mainType,
                          moneyType: moneyType,
                          goldType: goldType,
                          carat: selectedCarat,
                          amount: _safeDouble(amountController.text),
                          note: noteController.text.trim(),
                          available: available,
                        ),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          'تأكيد السحب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    bool isSmall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmall ? 10 : 12),
        decoration: BoxDecoration(
          color: isSelected ? goldColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSmall ? 14 : 15,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _executeWithdraw({
    required BuildContext ctx,
    required String mainType,
    required String moneyType,
    required String goldType,
    required String carat,
    required double amount,
    required String note,
    required double available,
  }) async {
    if (amount <= 0) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال قيمة صحيحة أكبر من صفر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount > available) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('القيمة أكبر من الرصيد الافتتاحي المتاح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(ctx);

    try {
      String fieldPath = '';
      if (mainType == 'money') {
        if (moneyType == 'cash') fieldPath = 'dailyCashBox.cash';
        if (moneyType == 'network') fieldPath = 'dailyCashBox.network';
        if (moneyType == 'safeCash') fieldPath = 'safeCash';
        if (moneyType == 'safeNetwork') fieldPath = 'safeNetwork';
      } else {
        if (goldType == 'worked') fieldPath = 'workedGoldByCarat.$carat';
        if (goldType == 'scrap') fieldPath = 'scrapGoldByCarat.$carat';
      }

      await FirebaseFirestore.instance
          .collection(_obCollection)
          .doc(_obDocId)
          .update({
        fieldPath: FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastWithdrawNote': note,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ تم سحب ${_fmt(amount)} ${mainType == 'money' ? 'ر.س' : 'جم'} بنجاح',
          ),
          backgroundColor: Colors.green,
        ),
      );
      _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _tableContainer({
    required String title,
    required List<_RowData> rows,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: goldColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: goldColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: Text(
                    'البند',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                _headCell('افتتاحي'),
                _headCell('حالي'),
                _headCell('الفرق'),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ...rows.map(_buildRow).toList(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _headCell(String text) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF888888),
        ),
      ),
    );
  }

  Widget _buildRow(_RowData r) {
    final diff = r.actual - r.opening;
    final isSame = diff.abs() < 0.01;
    final color =
        isSame ? Colors.grey.shade600 : (diff > 0 ? greenColor : redColor);
    final sign = diff > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              r.label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _fmt(r.opening),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _fmt(r.actual),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              isSame ? '0' : '$sign${_fmt(diff)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _RowData _rowData(String label, double opening, double actual,
      {String unit = 'ر.س'}) {
    return _RowData(
      label: label,
      opening: opening,
      actual: actual,
      unit: unit,
    );
  }

  Widget _errorCard(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: redColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _infoCard(String msg) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          msg,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }
}

class _RowData {
  final String label;
  final double opening;
  final double actual;
  final String unit;
  _RowData({
    required this.label,
    required this.opening,
    required this.actual,
    required this.unit,
  });
}
