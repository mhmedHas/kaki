// // // // import 'package:flutter/material.dart';
// // // // import 'package:uhf_gold_shop/pages/opening_page.dart';
// // // // import 'package:uhf_gold_shop/services/firestore_service.dart';

// // // // /// ويدجت التوجيه: يتحقق هل الرصيد الافتتاحي متسجل ولا لأ
// // // // /// لو متسجل -> صفحة العرض | لو مش متسجل -> صفحة الإدخال
// // // // /// حطها في أول شاشة بعد تسجيل الدخول
// // // // class OpeningBalanceList extends StatelessWidget {
// // // //   const OpeningBalanceList({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return FutureBuilder<bool>(
// // // //       future: FS.hasOpeningBalance(),
// // // //       builder: (context, snapshot) {
// // // //         if (!snapshot.hasData) {
// // // //           return const Scaffold(
// // // //             body: Center(child: CircularProgressIndicator()),
// // // //           );
// // // //         }
// // // //         return snapshot.data == true
// // // //             ? const OpeningBalanceDisplayPage()
// // // //             : const OpeningBalanceEntryPage();
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // // class OpeningBalanceDisplayPage extends StatelessWidget {
// // // //   const OpeningBalanceDisplayPage({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Directionality(
// // // //       textDirection: TextDirection.rtl,
// // // //       child: Scaffold(
// // // //         appBar: AppBar(title: const Text('الرصيد الافتتاحي')),
// // // //         body: FutureBuilder<Map<String, dynamic>?>(
// // // //           future: FS.getOpeningBalance(),
// // // //           builder: (context, snap) {
// // // //             if (!snap.hasData) {
// // // //               return const Center(child: CircularProgressIndicator());
// // // //             }
// // // //             final data = snap.data;
// // // //             if (data == null) {
// // // //               return const Center(child: Text('لم يتم تسجيل رصيد افتتاحي بعد'));
// // // //             }
// // // //             return FutureBuilder<List<Map<String, dynamic>>>(
// // // //               future: FS.getPartnersOpeningCapital(),
// // // //               builder: (context, partnersSnap) {
// // // //                 final partners = partnersSnap.data ?? [];
// // // //                 return ListView(
// // // //                   padding: const EdgeInsets.all(16),
// // // //                   children: [
// // // //                     _card('صندوق اليومي', [
// // // //                       'نقدي: ${data['dailyCashBox']?['cash']}',
// // // //                       'شبكة: ${data['dailyCashBox']?['network']}',
// // // //                     ]),
// // // //                     _card('الخزنة', [
// // // //                       'نقدي: ${data['safe']?['cash']}',
// // // //                       'شبكة: ${data['safe']?['network']}',
// // // //                     ]),
// // // //                     _card('ذهب كسر (جم)', _caratLines(data['scrapGoldByCarat'])),
// // // //                     _card('ذهب مشغول (جم)',
// // // //                         _caratLines(data['workedGoldByCarat'])),
// // // //                     _card('عهدة الكسر', [
// // // //                       'نقدي: ${data['scrapCustody']?['cash']}',
// // // //                       'شبكة: ${data['scrapCustody']?['network']}',
// // // //                     ]),
// // // //                     _card(
// // // //                       'كسر بالمخزن',
// // // //                       ((data['scrapInStorage'] as List?) ?? [])
// // // //                           .map((e) => 'وزن: ${e['weight']} جم — عيار ${e['carat']}')
// // // //                           .toList(),
// // // //                     ),
// // // //                     _card(
// // // //                       'المخزون',
// // // //                       ((data['inventory'] as List?) ?? [])
// // // //                           .map((e) =>
// // // //                               'قيمة: ${e['value']} ر.س — وزن: ${e['weight']} جم — عيار ${e['carat']}')
// // // //                           .toList(),
// // // //                     ),
// // // //                     _card(
// // // //                       'رأس مال الشركاء (عيار 24)',
// // // //                       partners
// // // //                           .map((p) =>
// // // //                               '${p['partnerName']}: ${p['openingAmountCarat24']}')
// // // //                           .toList(),
// // // //                     ),
// // // //                   ],
// // // //                 );
// // // //               },
// // // //             );
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   List<String> _caratLines(dynamic map) {
// // // //     if (map == null) return [];
// // // //     final m = Map<String, dynamic>.from(map);
// // // //     return m.entries.map((e) => 'عيار ${e.key}: ${e.value} جم').toList();
// // // //   }

// // // //   Widget _card(String title, List<String> lines) {
// // // //     return Card(
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(12),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             Text(title,
// // // //                 style:
// // // //                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// // // //             const Divider(),
// // // //             if (lines.isEmpty)
// // // //               const Text('لا توجد بيانات', style: TextStyle(color: Colors.grey))
// // // //             else
// // // //               ...lines.map((l) => Padding(
// // // //                     padding: const EdgeInsets.symmetric(vertical: 2),
// // // //                     child: Text(l),
// // // //                   )),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // // opening_balance_display_page.dart
// // // import 'package:flutter/material.dart';
// // // import 'package:uhf_gold_shop/services/firestore_service.dart';

// // // class OpeningBalanceDisplayPage extends StatefulWidget {
// // //   const OpeningBalanceDisplayPage({super.key});

// // //   @override
// // //   State<OpeningBalanceDisplayPage> createState() =>
// // //       _OpeningBalanceDisplayPageState();
// // // }

// // // class _OpeningBalanceDisplayPageState extends State<OpeningBalanceDisplayPage> {
// // //   late Future<Map<String, dynamic>?> _balanceFuture;
// // //   late Future<List<Map<String, dynamic>>> _partnersFuture;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _refreshData();
// // //   }

// // //   void _refreshData() {
// // //     setState(() {
// // //       _balanceFuture = FS.getOpeningBalance();
// // //       _partnersFuture = FS.getPartnersOpeningCapital();
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('عرض الرصيد الافتتاحي'),
// // //         actions: [
// // //           IconButton(onPressed: _refreshData, icon: Icon(Icons.refresh)),
// // //         ],
// // //       ),
// // //       body: Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: Padding(
// // //           padding: EdgeInsets.all(16),
// // //           child: SingleChildScrollView(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 FutureBuilder<Map<String, dynamic>?>(
// // //                   future: _balanceFuture,
// // //                   builder: (context, snapshot) {
// // //                     if (snapshot.connectionState == ConnectionState.waiting) {
// // //                       return Center(child: CircularProgressIndicator());
// // //                     }
// // //                     if (snapshot.hasError || snapshot.data == null) {
// // //                       return Card(
// // //                         child: Padding(
// // //                           padding: EdgeInsets.all(20),
// // //                           child: Text(
// // //                             '❌ لا يوجد رصيد افتتاحي مسجل بعد',
// // //                             style: TextStyle(color: Colors.red),
// // //                           ),
// // //                         ),
// // //                       );
// // //                     }

// // //                     final data = snapshot.data!;
// // //                     final daily = data['dailyCashBox'] ?? {};
// // //                     final safe = data['safe'] ?? {};
// // //                     final scrapGold = data['scrapGoldByCarat'] ?? {};
// // //                     final workedGold = data['workedGoldByCarat'] ?? {};
// // //                     final custody = data['scrapCustody'] ?? {};
// // //                     final storage = data['scrapInStorage'] ?? [];
// // //                     final inv = data['inventory'] ?? [];

// // //                     return Column(
// // //                       children: [
// // //                         _sectionCard('صندوق اليومي', [
// // //                           'كاش: ${daily['cash'] ?? 0}',
// // //                           'شبكة: ${daily['network'] ?? 0}',
// // //                         ]),
// // //                         _sectionCard('الخزنة', [
// // //                           'كاش: ${safe['cash'] ?? 0}',
// // //                           'شبكة: ${safe['network'] ?? 0}',
// // //                         ]),
// // //                         _sectionCard('ذهب كسر', [
// // //                           'عيار 24: ${scrapGold['24'] ?? 0}',
// // //                           'عيار 22: ${scrapGold['22'] ?? 0}',
// // //                           'عيار 21: ${scrapGold['21'] ?? 0}',
// // //                           'عيار 18: ${scrapGold['18'] ?? 0}',
// // //                           'عيار 14: ${scrapGold['14'] ?? 0}',
// // //                         ]),
// // //                         _sectionCard('ذهب مشغول', [
// // //                           'عيار 24: ${workedGold['24'] ?? 0}',
// // //                           'عيار 22: ${workedGold['22'] ?? 0}',
// // //                           'عيار 21: ${workedGold['21'] ?? 0}',
// // //                           'عيار 18: ${workedGold['18'] ?? 0}',
// // //                           'عيار 14: ${workedGold['14'] ?? 0}',
// // //                         ]),
// // //                         _sectionCard('عهدة الكسر', [
// // //                           'كاش: ${custody['cash'] ?? 0}',
// // //                           'شبكة: ${custody['network'] ?? 0}',
// // //                         ]),
// // //                         _sectionCard('كسر بالمخزن',
// // //                             storage.map((e) => 'وزن: ${e['weight']} - عيار: ${e['carat']}').toList()),
// // //                         _sectionCard('المخزون',
// // //                             inv.map((e) => 'قيمة: ${e['value']} - وزن: ${e['weight']} - عيار: ${e['carat']}').toList()),
// // //                       ],
// // //                     );
// // //                   },
// // //                 ),
// // //                 SizedBox(height: 20),
// // //                 Divider(thickness: 2),
// // //                 Text('👥 رأس مال الشركاء',
// // //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// // //                 SizedBox(height: 10),
// // //                 FutureBuilder<List<Map<String, dynamic>>>(
// // //                   future: _partnersFuture,
// // //                   builder: (context, snapshot) {
// // //                     if (snapshot.connectionState == ConnectionState.waiting) {
// // //                       return CircularProgressIndicator();
// // //                     }
// // //                     if (snapshot.hasError || snapshot.data!.isEmpty) {
// // //                       return Text('لا يوجد شركاء مسجلين');
// // //                     }
// // //                     return Column(
// // //                       children: snapshot.data!.map((p) {
// // //                         return Card(
// // //                           child: ListTile(
// // //                             title: Text(p['partnerName'] ?? ''),
// // //                             subtitle: Text(
// // //                                 'رأس المال: ${p['openingAmountCarat24'] ?? 0} جرام عيار 24'),
// // //                           ),
// // //                         );
// // //                       }).toList(),
// // //                     );
// // //                   },
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _sectionCard(String title, List<String> items) {
// // //     return Card(
// // //       margin: EdgeInsets.symmetric(vertical: 6),
// // //       child: Padding(
// // //         padding: EdgeInsets.all(12),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(title,
// // //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// // //             SizedBox(height: 6),
// // //             ...items.map((e) => Text('• $e')).toList(),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// // class OpeningBalanceDisplayPage extends StatefulWidget {
// //   const OpeningBalanceDisplayPage({super.key});

// //   @override
// //   State<OpeningBalanceDisplayPage> createState() =>
// //       _OpeningBalanceDisplayPageState();
// // }

// // class _OpeningBalanceDisplayPageState extends State<OpeningBalanceDisplayPage> {
// //   static const Color goldColor = Color(0xFFD4AF37);
// //   static const Color goldDark = Color(0xFFB8860B);

// //   late Future<Map<String, dynamic>?> _balanceFuture;
// //   late Future<List<Map<String, dynamic>>> _partnersFuture;
// //   bool _isRefreshing = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   void _loadData() {
// //     _balanceFuture = FS.getOpeningBalance();
// //     _partnersFuture = FS.getPartnersOpeningCapital();
// //   }

// //   Future<void> _refreshData() async {
// //     setState(() => _isRefreshing = true);
// //     _loadData();
// //     // انتظار تحميل البيانات (حل مؤقت)
// //     await Future.delayed(const Duration(milliseconds: 300));
// //     if (mounted) setState(() => _isRefreshing = false);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: AppBar(
// //         title: const Text(
// //           'عرض الرصيد الافتتاحي',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: goldColor,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         actions: [
// //           IconButton(
// //             icon: _isRefreshing
// //                 ? const SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2,
// //                       color: Colors.white,
// //                     ),
// //                   )
// //                 : const Icon(Icons.refresh, color: Colors.white),
// //             onPressed: _isRefreshing ? null : _refreshData,
// //             tooltip: 'تحديث',
// //           ),
// //         ],
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // ===== قسم الرصيد الافتتاحي =====
// //                 FutureBuilder<Map<String, dynamic>?>(
// //                   future: _balanceFuture,
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Center(
// //                         child: Padding(
// //                           padding: EdgeInsets.all(40),
// //                           child: CircularProgressIndicator(
// //                             valueColor:
// //                                 AlwaysStoppedAnimation<Color>(goldColor),
// //                           ),
// //                         ),
// //                       );
// //                     }

// //                     if (snapshot.hasError) {
// //                       return _buildErrorCard(
// //                         'حدث خطأ أثناء تحميل البيانات',
// //                       );
// //                     }

// //                     if (!snapshot.hasData || snapshot.data == null) {
// //                       return _buildErrorCard(
// //                         '❌ لا يوجد رصيد افتتاحي مسجل بعد',
// //                         isError: false,
// //                       );
// //                     }

// //                     final data = snapshot.data!;
// //                     final daily = data['dailyCashBox'] ?? {};
// //                     final safe = data['safe'] ?? {};
// //                     final scrapGold = data['scrapGoldByCarat'] ?? {};
// //                     final workedGold = data['workedGoldByCarat'] ?? {};
// //                     final custody = data['scrapCustody'] ?? {};
// //                     final storage = data['scrapInStorage'] ?? [];
// //                     final inv = data['inventory'] ?? [];

// //                     return Column(
// //                       children: [
// //                         // 1. صندوق اليومي
// //                         _buildDisplayCard(
// //                           icon: Icons.business_center,
// //                           title: 'صندوق اليومي',
// //                           items: [
// //                             'كاش: ${_formatNumber(daily['cash'])}',
// //                             'شبكة: ${_formatNumber(daily['network'])}',
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 2. الخزنة
// //                         _buildDisplayCard(
// //                           icon: Icons.account_balance,
// //                           title: 'الخزنة',
// //                           items: [
// //                             'كاش: ${_formatNumber(safe['cash'])}',
// //                             'شبكة: ${_formatNumber(safe['network'])}',
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 3. ذهب كسر
// //                         _buildDisplayCard(
// //                           icon: Icons.crisis_alert,
// //                           title: 'ذهب كسر',
// //                           items: [
// //                             'عيار 24: ${_formatNumber(scrapGold['24'])} جم',
// //                             'عيار 22: ${_formatNumber(scrapGold['22'])} جم',
// //                             'عيار 21: ${_formatNumber(scrapGold['21'])} جم',
// //                             'عيار 18: ${_formatNumber(scrapGold['18'])} جم',
// //                             'عيار 14: ${_formatNumber(scrapGold['14'])} جم',
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 4. ذهب مشغول
// //                         _buildDisplayCard(
// //                           icon: Icons.work,
// //                           title: 'ذهب مشغول',
// //                           items: [
// //                             'عيار 24: ${_formatNumber(workedGold['24'])} جم',
// //                             'عيار 22: ${_formatNumber(workedGold['22'])} جم',
// //                             'عيار 21: ${_formatNumber(workedGold['21'])} جم',
// //                             'عيار 18: ${_formatNumber(workedGold['18'])} جم',
// //                             'عيار 14: ${_formatNumber(workedGold['14'])} جم',
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 5. عهدة الكسر
// //                         _buildDisplayCard(
// //                           icon: Icons.account_balance_wallet,
// //                           title: 'عهدة الكسر',
// //                           items: [
// //                             'كاش: ${_formatNumber(custody['cash'])}',
// //                             'شبكة: ${_formatNumber(custody['network'])}',
// //                           ],
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 6. كسر بالمخزن
// //                         _buildDisplayCard(
// //                           icon: Icons.storage,
// //                           title: 'كسر بالمخزن',
// //                           items: storage.isEmpty
// //                               ? ['لا توجد بيانات']
// //                               : storage
// //                                   .map((e) =>
// //                                       'وزن: ${_formatNumber(e['weight'])} - عيار: ${e['carat']}')
// //                                   .toList(),
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 7. المخزون
// //                         _buildDisplayCard(
// //                           icon: Icons.inventory,
// //                           title: 'المخزون',
// //                           items: inv.isEmpty
// //                               ? ['لا توجد بيانات']
// //                               : inv
// //                                   .map((e) =>
// //                                       'قيمة: ${_formatNumber(e['value'])} - وزن: ${_formatNumber(e['weight'])} - عيار: ${e['carat']}')
// //                                   .toList(),
// //                         ),
// //                         const SizedBox(height: 12),

// //                         // 8. تاريخ آخر تحديث
// //                         if (data['updatedAt'] != null)
// //                           _buildDisplayCard(
// //                             icon: Icons.update,
// //                             title: 'آخر تحديث',
// //                             items: [
// //                               _formatTimestamp(data['updatedAt']),
// //                             ],
// //                           ),
// //                       ],
// //                     );
// //                   },
// //                 ),

// //                 const SizedBox(height: 24),
// //                 const Divider(thickness: 2, color: goldColor),

// //                 // ===== قسم الشركاء =====
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: [
// //                     const Icon(Icons.people, color: goldColor, size: 28),
// //                     const SizedBox(width: 12),
// //                     const Text(
// //                       '👥 رأس مال الشركاء',
// //                       style: TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xFF333333),
// //                       ),
// //                     ),
// //                     const Spacer(),
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 12,
// //                         vertical: 4,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: goldColor.withOpacity(0.15),
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                       child: FutureBuilder<List<Map<String, dynamic>>>(
// //                         future: _partnersFuture,
// //                         builder: (context, snapshot) {
// //                           final count = snapshot.data?.length ?? 0;
// //                           return Text(
// //                             '$count ${count == 1 ? 'شريك' : 'شركاء'}',
// //                             style: TextStyle(
// //                               color: goldColor,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 13,
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),

// //                 FutureBuilder<List<Map<String, dynamic>>>(
// //                   future: _partnersFuture,
// //                   builder: (context, snapshot) {
// //                     if (snapshot.connectionState == ConnectionState.waiting) {
// //                       return const Center(
// //                         child: Padding(
// //                           padding: EdgeInsets.all(20),
// //                           child: CircularProgressIndicator(
// //                             valueColor:
// //                                 AlwaysStoppedAnimation<Color>(goldColor),
// //                           ),
// //                         ),
// //                       );
// //                     }

// //                     if (snapshot.hasError) {
// //                       return _buildErrorCard('حدث خطأ أثناء تحميل الشركاء');
// //                     }

// //                     final partners = snapshot.data ?? [];

// //                     if (partners.isEmpty) {
// //                       return Container(
// //                         padding: const EdgeInsets.all(20),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(16),
// //                           border: Border.all(
// //                             color: Colors.grey.shade200,
// //                             width: 1,
// //                           ),
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             'لا يوجد شركاء مسجلين',
// //                             style: TextStyle(
// //                               color: Colors.grey.shade500,
// //                               fontSize: 15,
// //                             ),
// //                           ),
// //                         ),
// //                       );
// //                     }

// //                     return Column(
// //                       children: partners.map((p) {
// //                         final name = p['partnerName'] ?? 'غير معروف';
// //                         final amount =
// //                             (p['openingAmountCarat24'] as num?)?.toDouble() ??
// //                                 0;
// //                         final id = p['id'] ?? '';

// //                         return Container(
// //                           margin: const EdgeInsets.only(bottom: 8),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(12),
// //                             border: Border.all(
// //                               color: goldColor.withOpacity(0.15),
// //                               width: 1,
// //                             ),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.03),
// //                                 blurRadius: 4,
// //                                 offset: const Offset(0, 1),
// //                               ),
// //                             ],
// //                           ),
// //                           child: ListTile(
// //                             leading: CircleAvatar(
// //                               backgroundColor: goldColor.withOpacity(0.15),
// //                               child: Text(
// //                                 name.isNotEmpty ? name[0] : '?',
// //                                 style: const TextStyle(
// //                                   color: goldColor,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                             ),
// //                             title: Text(
// //                               name,
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: 15,
// //                               ),
// //                             ),
// //                             subtitle: Text(
// //                               'رأس المال: ${_formatNumber(amount)} جرام عيار 24',
// //                               style: TextStyle(
// //                                 color: Colors.grey.shade600,
// //                                 fontSize: 13,
// //                               ),
// //                             ),
// //                             trailing: Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 10,
// //                                 vertical: 4,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: goldColor.withOpacity(0.1),
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                               child: Text(
// //                                 '${_formatNumber(amount)} جم',
// //                                 style: const TextStyle(
// //                                   color: goldColor,
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 13,
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         );
// //                       }).toList(),
// //                     );
// //                   },
// //                 ),
// //                 const SizedBox(height: 30),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 دوال مساعدة لبناء الواجهة
// //   // ============================================================

// //   Widget _buildDisplayCard({
// //     required IconData icon,
// //     required String title,
// //     required List<String> items,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: goldColor.withOpacity(0.2),
// //           width: 1,
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.04),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(icon, color: goldColor, size: 22),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 // أيقونة صغيرة توحي بالقراءة فقط
// //                 Icon(
// //                   Icons.remove_red_eye_outlined,
// //                   color: Colors.grey.shade400,
// //                   size: 18,
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             ...items.map((item) => Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 3),
// //                   child: Row(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         margin: const EdgeInsets.only(top: 6, right: 6),
// //                         width: 6,
// //                         height: 6,
// //                         decoration: BoxDecoration(
// //                           color: goldColor.withOpacity(0.6),
// //                           shape: BoxShape.circle,
// //                         ),
// //                       ),
// //                       Expanded(
// //                         child: Text(
// //                           item,
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: item.contains('لا توجد')
// //                                 ? Colors.grey.shade500
// //                                 : Colors.grey.shade800,
// //                             fontWeight: item.contains('لا توجد')
// //                                 ? FontWeight.normal
// //                                 : FontWeight.normal,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 )),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildErrorCard(String message, {bool isError = true}) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: isError ? Colors.red.shade50 : Colors.orange.shade50,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: isError ? Colors.red.shade200 : Colors.orange.shade200,
// //           width: 1,
// //         ),
// //       ),
// //       child: Center(
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               isError ? Icons.error_outline : Icons.info_outline,
// //               color: isError ? Colors.red.shade400 : Colors.orange.shade400,
// //             ),
// //             const SizedBox(width: 12),
// //             Text(
// //               message,
// //               style: TextStyle(
// //                 color: isError ? Colors.red.shade700 : Colors.orange.shade700,
// //                 fontSize: 15,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String _formatNumber(dynamic value) {
// //     if (value == null) return '0';
// //     if (value is num) {
// //       // إذا كان الرقم صحيحاً بدون كسور، نعرضه بدون كسور
// //       if (value == value.toInt()) {
// //         return value.toInt().toString();
// //       }
// //       return value.toStringAsFixed(2);
// //     }
// //     return value.toString();
// //   }

// //   String _formatTimestamp(dynamic timestamp) {
// //     if (timestamp == null) return 'غير معروف';
// //     try {
// //       if (timestamp is DateTime) {
// //         return '${timestamp.day.toString().padLeft(2, '0')}/'
// //             '${timestamp.month.toString().padLeft(2, '0')}/'
// //             '${timestamp.year} '
// //             '${timestamp.hour.toString().padLeft(2, '0')}:'
// //             '${timestamp.minute.toString().padLeft(2, '0')}';
// //       }
// //       return timestamp.toString();
// //     } catch (_) {
// //       return timestamp.toString();
// //     }
// //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// // class OpeningBalanceDisplayPage extends StatefulWidget {
// //   const OpeningBalanceDisplayPage({super.key});

// //   @override
// //   State<OpeningBalanceDisplayPage> createState() =>
// //       _OpeningBalanceDisplayPageState();
// // }

// // class _OpeningBalanceDisplayPageState extends State<OpeningBalanceDisplayPage> {
// //   static const Color goldColor = Color(0xFFD4AF37);
// //   static const Color goldDark = Color(0xFFB8860B);
// //   static const Color goldLight = Color(0xFFFFF8E1);

// //   late Future<Map<String, dynamic>?> _balanceFuture;
// //   late Future<List<Map<String, dynamic>>> _partnersFuture;
// //   bool _isRefreshing = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   void _loadData() {
// //     _balanceFuture = FS.getOpeningBalance();
// //     _partnersFuture = FS.getPartnersOpeningCapital();
// //   }

// //   Future<void> _refreshData() async {
// //     setState(() => _isRefreshing = true);
// //     _loadData();
// //     await Future.delayed(const Duration(milliseconds: 500));
// //     if (mounted) setState(() => _isRefreshing = false);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: AppBar(
// //         title: const Text(
// //           'عرض الرصيد الافتتاحي',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: goldColor,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //         actions: [
// //           IconButton(
// //             icon: _isRefreshing
// //                 ? const SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2,
// //                       color: Colors.white,
// //                     ),
// //                   )
// //                 : const Icon(Icons.refresh, color: Colors.white),
// //             onPressed: _isRefreshing ? null : _refreshData,
// //             tooltip: 'تحديث',
// //           ),
// //         ],
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: FutureBuilder<Map<String, dynamic>?>(
// //             future: _balanceFuture,
// //             builder: (context, snapshot) {
// //               if (snapshot.connectionState == ConnectionState.waiting) {
// //                 return const Center(
// //                   child: CircularProgressIndicator(
// //                     valueColor: AlwaysStoppedAnimation<Color>(goldColor),
// //                   ),
// //                 );
// //               }

// //               if (snapshot.hasError) {
// //                 return _buildErrorCard('حدث خطأ أثناء تحميل البيانات');
// //               }

// //               if (!snapshot.hasData || snapshot.data == null) {
// //                 return _buildErrorCard(
// //                   '❌ لا يوجد رصيد افتتاحي مسجل بعد',
// //                   isError: false,
// //                 );
// //               }

// //               final data = snapshot.data!;
// //               // التأكد من وجود الحقول بشكل صحيح
// //               final daily = data['dailyCashBox'] ?? {};
// //               final safe = data['safe'] ?? {};
// //               final scrapGold = data['scrapGoldByCarat'] ?? {};
// //               final workedGold = data['workedGoldByCarat'] ?? {};
// //               final custody = data['scrapCustody'] ?? {};
// //               final storage = data['scrapInStorage'] ?? [];
// //               final inv = data['inventory'] ?? [];

// //               // حساب الإجماليات
// //               final totalCash = (daily['cash'] ?? 0) +
// //                   (safe['cash'] ?? 0) +
// //                   (custody['cash'] ?? 0);
// //               final totalNetwork = (daily['network'] ?? 0) +
// //                   (safe['network'] ?? 0) +
// //                   (custody['network'] ?? 0);
// //               final totalScrap = (scrapGold['24'] ?? 0) +
// //                   (scrapGold['22'] ?? 0) +
// //                   (scrapGold['21'] ?? 0) +
// //                   (scrapGold['18'] ?? 0) +
// //                   (scrapGold['14'] ?? 0);
// //               final totalWorked = (workedGold['24'] ?? 0) +
// //                   (workedGold['22'] ?? 0) +
// //                   (workedGold['21'] ?? 0) +
// //                   (workedGold['18'] ?? 0) +
// //                   (workedGold['14'] ?? 0);

// //               return SingleChildScrollView(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // ===== بطاقة الملخص =====
// //                     _buildSummaryCard(
// //                       totalCash: totalCash,
// //                       totalNetwork: totalNetwork,
// //                       totalScrap: totalScrap,
// //                       totalWorked: totalWorked,
// //                     ),
// //                     const SizedBox(height: 20),

// //                     // ===== تفاصيل الأقسام =====
// //                     _buildSectionGrid(
// //                       title: 'صندوق اليومي',
// //                       icon: Icons.business_center,
// //                       items: {
// //                         'كاش': daily['cash'] ?? 0,
// //                         'شبكة': daily['network'] ?? 0,
// //                       },
// //                     ),
// //                     const SizedBox(height: 12),

// //                     _buildSectionGrid(
// //                       title: 'الخزنة',
// //                       icon: Icons.account_balance,
// //                       items: {
// //                         'كاش': safe['cash'] ?? 0,
// //                         'شبكة': safe['network'] ?? 0,
// //                       },
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // عرض ذهب كسر باستخدام Row بدلاً من Grid
// //                     _buildGoldSectionRow(
// //                       title: 'ذهب كسر',
// //                       icon: Icons.crisis_alert,
// //                       data: scrapGold,
// //                     ),
// //                     const SizedBox(height: 12),

// //                     _buildGoldSectionRow(
// //                       title: 'ذهب مشغول',
// //                       icon: Icons.work,
// //                       data: workedGold,
// //                     ),
// //                     const SizedBox(height: 12),

// //                     _buildSectionGrid(
// //                       title: 'عهدة الكسر',
// //                       icon: Icons.account_balance_wallet,
// //                       items: {
// //                         'كاش': custody['cash'] ?? 0,
// //                         'شبكة': custody['network'] ?? 0,
// //                       },
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // كسر بالمخزن
// //                     _buildDynamicListSection(
// //                       title: 'كسر بالمخزن',
// //                       icon: Icons.storage,
// //                       items: storage,
// //                       itemBuilder: (item) =>
// //                           'وزن: ${_formatNumber(item['weight'])} جم - عيار: ${item['carat']}',
// //                       emptyMessage: 'لا توجد قطع',
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // المخزون
// //                     _buildDynamicListSection(
// //                       title: 'المخزون',
// //                       icon: Icons.inventory,
// //                       items: inv,
// //                       itemBuilder: (item) =>
// //                           'قيمة: ${_formatNumber(item['value'])} - وزن: ${_formatNumber(item['weight'])} جم - عيار: ${item['carat']}',
// //                       emptyMessage: 'لا توجد مواد',
// //                     ),
// //                     const SizedBox(height: 12),

// //                     // تاريخ التحديث

// //                     // ===== قسم الشركاء =====
// //                     const Divider(thickness: 2, color: goldColor),
// //                     const SizedBox(height: 16),
// //                     _buildPartnersSection(),
// //                     const SizedBox(height: 30),
// //                   ],
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 دوال بناء الواجهة المحسّنة
// //   // ============================================================

// //   Widget _buildSummaryCard({
// //     required double totalCash,
// //     required double totalNetwork,
// //     required double totalScrap,
// //     required double totalWorked,
// //   }) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [goldColor, goldDark],
// //           begin: Alignment.topRight,
// //           end: Alignment.bottomLeft,
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: goldColor.withOpacity(0.3),
// //             blurRadius: 10,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           const Text(
// //             '📊 ملخص الرصيد',
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Wrap(
// //             spacing: 12,
// //             runSpacing: 8,
// //             alignment: WrapAlignment.center,
// //             children: [
// //               _summaryChip(Icons.money, 'كاش', totalCash),
// //               _summaryChip(Icons.wifi, 'شبكة', totalNetwork),
// //               _summaryChip(Icons.crisis_alert, 'ذهب كسر', totalScrap,
// //                   unit: 'جم'),
// //               _summaryChip(Icons.work, 'ذهب مشغول', totalWorked, unit: 'جم'),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _summaryChip(IconData icon, String label, double value,
// //       {String unit = ''}) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.2),
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, color: Colors.white, size: 16),
// //           const SizedBox(width: 6),
// //           Text(
// //             '$label: ${_formatNumber(value)} $unit',
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontWeight: FontWeight.w600,
// //               fontSize: 13,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // بطاقة عرض قسم بسيط (نقدي)
// //   Widget _buildSectionGrid({
// //     required String title,
// //     required IconData icon,
// //     required Map<String, dynamic> items,
// //   }) {
// //     return Container(
// //       decoration: _cardDecoration(),
// //       child: Padding(
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(icon, color: goldColor, size: 22),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             Wrap(
// //               spacing: 16,
// //               runSpacing: 8,
// //               children: items.entries.map((e) {
// //                 return Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   decoration: BoxDecoration(
// //                     color: goldLight,
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(
// //                     '${e.key}: ${_formatNumber(e.value)}',
// //                     style: const TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w500,
// //                       color: Color(0xFF444444),
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // بطاقة عرض الذهب باستخدام Row بدلاً من Grid (يمنع overflow)
// //   Widget _buildGoldSectionRow({
// //     required String title,
// //     required IconData icon,
// //     required Map<String, dynamic> data,
// //   }) {
// //     final carats = ['24', '22', '21', '18', '14'];
// //     final colors = [
// //       Colors.amber.shade700,
// //       Colors.amber.shade600,
// //       Colors.amber.shade500,
// //       Colors.amber.shade400,
// //       Colors.amber.shade300,
// //     ];

// //     return Container(
// //       decoration: _cardDecoration(),
// //       child: Padding(
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(icon, color: goldColor, size: 22),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             // استخدام Row مع Expanded لتوزيع 5 عناصر بالتساوي
// //             Row(
// //               children: List.generate(carats.length, (index) {
// //                 final carat = carats[index];
// //                 final value = data[carat] ?? 0;
// //                 return Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 2),
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(vertical: 8),
// //                       decoration: BoxDecoration(
// //                         color: colors[index].withOpacity(0.15),
// //                         borderRadius: BorderRadius.circular(10),
// //                         border: Border.all(
// //                           color: colors[index].withOpacity(0.3),
// //                           width: 1,
// //                         ),
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Text(
// //                             'عيار $carat',
// //                             style: TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.w600,
// //                               color: colors[index],
// //                             ),
// //                           ),
// //                           Text(
// //                             '${_formatNumber(value)} جم',
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.grey.shade800,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               }),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // بطاقة عرض قائمة ديناميكية (مثل المخزون والكسر)
// //   Widget _buildDynamicListSection({
// //     required String title,
// //     required IconData icon,
// //     required List<dynamic> items,
// //     required String Function(dynamic) itemBuilder,
// //     required String emptyMessage,
// //   }) {
// //     return Container(
// //       decoration: _cardDecoration(),
// //       child: Padding(
// //         padding: const EdgeInsets.all(14),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(icon, color: goldColor, size: 22),
// //                 const SizedBox(width: 10),
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 16,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //                 if (items.isNotEmpty) ...[
// //                   const Spacer(),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 10,
// //                       vertical: 2,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: goldColor.withOpacity(0.15),
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     child: Text(
// //                       '${items.length}',
// //                       style: TextStyle(
// //                         color: goldColor,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ],
// //             ),
// //             const SizedBox(height: 10),
// //             if (items.isEmpty)
// //               Center(
// //                 child: Text(
// //                   emptyMessage,
// //                   style: TextStyle(
// //                     color: Colors.grey.shade500,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //               )
// //             else
// //               Column(
// //                 children: items.map((item) {
// //                   return Container(
// //                     margin: const EdgeInsets.only(bottom: 6),
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 8,
// //                     ),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade50,
// //                       borderRadius: BorderRadius.circular(8),
// //                       border: Border.all(
// //                         color: Colors.grey.shade200,
// //                         width: 1,
// //                       ),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           Icons.circle,
// //                           color: goldColor.withOpacity(0.5),
// //                           size: 8,
// //                         ),
// //                         const SizedBox(width: 8),
// //                         Expanded(
// //                           child: Text(
// //                             itemBuilder(item),
// //                             style: const TextStyle(fontSize: 13),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }).toList(),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ===== قسم الشركاء (محسّن) =====
// //   Widget _buildPartnersSection() {
// //     return FutureBuilder<List<Map<String, dynamic>>>(
// //       future: _partnersFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const Center(
// //             child: Padding(
// //               padding: EdgeInsets.all(20),
// //               child: CircularProgressIndicator(
// //                 valueColor: AlwaysStoppedAnimation<Color>(goldColor),
// //               ),
// //             ),
// //           );
// //         }

// //         if (snapshot.hasError) {
// //           return _buildErrorCard('حدث خطأ أثناء تحميل الشركاء');
// //         }

// //         final partners = snapshot.data ?? [];

// //         return Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 const Icon(Icons.people, color: goldColor, size: 28),
// //                 const SizedBox(width: 12),
// //                 const Text(
// //                   '👥 رأس مال الشركاء',
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Color(0xFF333333),
// //                   ),
// //                 ),
// //                 const Spacer(),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 12,
// //                     vertical: 4,
// //                   ),
// //                   decoration: BoxDecoration(
// //                     color: goldColor.withOpacity(0.15),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Text(
// //                     '${partners.length} ${partners.length == 1 ? 'شريك' : 'شركاء'}',
// //                     style: TextStyle(
// //                       color: goldColor,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             if (partners.isEmpty)
// //               Container(
// //                 padding: const EdgeInsets.all(20),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: Colors.grey.shade200),
// //                 ),
// //                 child: Center(
// //                   child: Text(
// //                     'لا يوجد شركاء مسجلين',
// //                     style: TextStyle(color: Colors.grey.shade500),
// //                   ),
// //                 ),
// //               )
// //             else
// //               Column(
// //                 children: partners.map((p) {
// //                   final name = p['partnerName'] ?? 'غير معروف';
// //                   final amount =
// //                       (p['openingAmountCarat24'] as num?)?.toDouble() ?? 0;
// //                   return Container(
// //                     margin: const EdgeInsets.only(bottom: 8),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white,
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(
// //                         color: goldColor.withOpacity(0.15),
// //                         width: 1,
// //                       ),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.03),
// //                           blurRadius: 4,
// //                           offset: const Offset(0, 1),
// //                         ),
// //                       ],
// //                     ),
// //                     child: ListTile(
// //                       leading: CircleAvatar(
// //                         backgroundColor: goldColor.withOpacity(0.15),
// //                         child: Text(
// //                           name.isNotEmpty ? name[0] : '?',
// //                           style: const TextStyle(
// //                             color: goldColor,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                       title: Text(
// //                         name,
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.w600,
// //                           fontSize: 15,
// //                         ),
// //                       ),
// //                       subtitle: Text(
// //                         'رأس المال: ${_formatNumber(amount)} جرام عيار 24',
// //                         style: TextStyle(
// //                           color: Colors.grey.shade600,
// //                           fontSize: 13,
// //                         ),
// //                       ),
// //                       trailing: Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 10,
// //                           vertical: 4,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: goldColor.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                         child: Text(
// //                           '${_formatNumber(amount)} جم',
// //                           style: const TextStyle(
// //                             color: goldColor,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 13,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 }).toList(),
// //               ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 دوال مساعدة
// //   // ============================================================

// //   BoxDecoration _cardDecoration() {
// //     return BoxDecoration(
// //       color: Colors.white,
// //       borderRadius: BorderRadius.circular(16),
// //       border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Colors.black.withOpacity(0.04),
// //           blurRadius: 8,
// //           offset: const Offset(0, 2),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildErrorCard(String message, {bool isError = true}) {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: isError ? Colors.red.shade50 : Colors.orange.shade50,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: isError ? Colors.red.shade200 : Colors.orange.shade200,
// //           width: 1,
// //         ),
// //       ),
// //       child: Center(
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               isError ? Icons.error_outline : Icons.info_outline,
// //               color: isError ? Colors.red.shade400 : Colors.orange.shade400,
// //             ),
// //             const SizedBox(width: 12),
// //             Text(
// //               message,
// //               style: TextStyle(
// //                 color: isError ? Colors.red.shade700 : Colors.orange.shade700,
// //                 fontSize: 15,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String _formatNumber(dynamic value) {
// //     if (value == null) return '0';
// //     if (value is num) {
// //       if (value == value.toInt()) {
// //         return value.toInt().toString();
// //       }
// //       return value.toStringAsFixed(2);
// //     }
// //     return value.toString();
// //   }

// //   String _formatTimestamp(dynamic timestamp) {
// //     if (timestamp == null) return 'غير معروف';
// //     try {
// //       if (timestamp is DateTime) {
// //         return '${timestamp.day.toString().padLeft(2, '0')}/'
// //             '${timestamp.month.toString().padLeft(2, '0')}/'
// //             '${timestamp.year} '
// //             '${timestamp.hour.toString().padLeft(2, '0')}:'
// //             '${timestamp.minute.toString().padLeft(2, '0')}';
// //       }
// //       return timestamp.toString();
// //     } catch (_) {
// //       return timestamp.toString();
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:uhf_gold_shop/services/firestore_service.dart';

// class OpeningBalanceDisplayPage extends StatefulWidget {
//   const OpeningBalanceDisplayPage({super.key});

//   @override
//   State<OpeningBalanceDisplayPage> createState() =>
//       _OpeningBalanceDisplayPageState();
// }

// class _OpeningBalanceDisplayPageState extends State<OpeningBalanceDisplayPage> {
//   static const Color goldColor = Color(0xFFD4AF37);
//   static const Color goldDark = Color(0xFFB8860B);
//   static const Color goldLight = Color(0xFFFFF8E1);

//   late Future<Map<String, dynamic>?> _balanceFuture;
//   late Future<List<Map<String, dynamic>>> _partnersFuture;
//   bool _isRefreshing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     _balanceFuture = FS.getOpeningBalance();
//     _partnersFuture = FS.getPartnersOpeningCapital();
//   }

//   Future<void> _refreshData() async {
//     setState(() => _isRefreshing = true);
//     _loadData();
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (mounted) setState(() => _isRefreshing = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'عرض الرصيد الافتتاحي',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: goldColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: _isRefreshing
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                 : const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _isRefreshing ? null : _refreshData,
//             tooltip: 'تحديث',
//           ),
//         ],
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: FutureBuilder<Map<String, dynamic>?>(
//             future: _balanceFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(goldColor),
//                   ),
//                 );
//               }

//               if (snapshot.hasError) {
//                 return _buildErrorCard('حدث خطأ أثناء تحميل البيانات');
//               }

//               if (!snapshot.hasData || snapshot.data == null) {
//                 return _buildErrorCard(
//                   '❌ لا يوجد رصيد افتتاحي مسجل بعد',
//                   isError: false,
//                 );
//               }

//               final data = snapshot.data!;
//               final daily = data['dailyCashBox'] ?? {};
//               final safe = data['safe'] ?? {};
//               final scrapGold = data['scrapGoldByCarat'] ?? {};
//               final workedGold = data['workedGoldByCarat'] ?? {};
//               final custody = data['scrapCustody'] ?? {};
//               final storage = data['scrapInStorage'] ?? [];
//               final inv = data['inventory'] ?? [];

//               // حساب الإجماليات
//               final totalCash = (daily['cash'] ?? 0) +
//                   (safe['cash'] ?? 0) +
//                   (custody['cash'] ?? 0);
//               final totalNetwork = (daily['network'] ?? 0) +
//                   (safe['network'] ?? 0) +
//                   (custody['network'] ?? 0);
//               final totalScrap = (scrapGold['24'] ?? 0) +
//                   (scrapGold['22'] ?? 0) +
//                   (scrapGold['21'] ?? 0) +
//                   (scrapGold['18'] ?? 0) +
//                   (scrapGold['14'] ?? 0);
//               final totalWorked = (workedGold['24'] ?? 0) +
//                   (workedGold['22'] ?? 0) +
//                   (workedGold['21'] ?? 0) +
//                   (workedGold['18'] ?? 0) +
//                   (workedGold['14'] ?? 0);

//               // إجمالي كسر المخزن (مجموع الأوزان)
//               double totalStorageWeight = 0;
//               for (var item in storage) {
//                 totalStorageWeight += (item['weight'] ?? 0).toDouble();
//               }

//               // إجمالي المخزون (مجموع القيم)
//               double totalInventoryValue = 0;
//               for (var item in inv) {
//                 totalInventoryValue += (item['value'] ?? 0).toDouble();
//               }

//               return SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ===== بطاقة الملخص (مضافة إليها الإجماليات الجديدة) =====
//                     _buildSummaryCard(
//                       totalCash: totalCash,
//                       totalNetwork: totalNetwork,
//                       totalScrap: totalScrap,
//                       totalWorked: totalWorked,
//                       totalStorageWeight: totalStorageWeight,
//                       totalInventoryValue: totalInventoryValue,
//                     ),
//                     const SizedBox(height: 20),

//                     // ===== تفاصيل الأقسام =====
//                     _buildSectionGrid(
//                       title: 'صندوق اليومي',
//                       icon: Icons.business_center,
//                       items: {
//                         'كاش': daily['cash'] ?? 0,
//                         'شبكة': daily['network'] ?? 0,
//                       },
//                     ),
//                     const SizedBox(height: 12),

//                     _buildSectionGrid(
//                       title: 'الخزنة',
//                       icon: Icons.account_balance,
//                       items: {
//                         'كاش': safe['cash'] ?? 0,
//                         'شبكة': safe['network'] ?? 0,
//                       },
//                     ),
//                     const SizedBox(height: 12),

//                     _buildGoldSectionRow(
//                       title: 'ذهب كسر',
//                       icon: Icons.crisis_alert,
//                       data: scrapGold,
//                     ),
//                     const SizedBox(height: 12),

//                     _buildGoldSectionRow(
//                       title: 'ذهب مشغول',
//                       icon: Icons.work,
//                       data: workedGold,
//                     ),
//                     const SizedBox(height: 12),

//                     _buildSectionGrid(
//                       title: 'عهدة الكسر',
//                       icon: Icons.account_balance_wallet,
//                       items: {
//                         'كاش': custody['cash'] ?? 0,
//                         'شبكة': custody['network'] ?? 0,
//                       },
//                     ),
//                     const SizedBox(height: 12),

//                     // ===== كسر بالمخزن (مجمع حسب العيار) =====
//                     _buildGroupedStorageSection(storage),
//                     const SizedBox(height: 12),

//                     // ===== المخزون (عرض عادي) =====
//                     _buildDynamicListSection(
//                       title: 'المخزون',
//                       icon: Icons.inventory,
//                       items: inv,
//                       itemBuilder: (item) =>
//                           'قيمة: ${_formatNumber(item['value'])} - وزن: ${_formatNumber(item['weight'])} جم - عيار: ${item['carat']}',
//                       emptyMessage: 'لا توجد مواد',
//                     ),

//                     const SizedBox(height: 10),

//                     // ===== قسم الشركاء =====
//                     const Divider(thickness: 2, color: goldColor),
//                     const SizedBox(height: 16),
//                     _buildPartnersSection(),
//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 دوال بناء الواجهة المحسّنة
//   // ============================================================

//   Widget _buildSummaryCard({
//     required double totalCash,
//     required double totalNetwork,
//     required double totalScrap,
//     required double totalWorked,
//     required double totalStorageWeight,
//     required double totalInventoryValue,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [goldColor, goldDark],
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: goldColor.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Text(
//             '📊 ملخص الرصيد',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 12,
//             runSpacing: 8,
//             alignment: WrapAlignment.center,
//             children: [
//               _summaryChip(Icons.money, 'كاش', totalCash),
//               _summaryChip(Icons.wifi, 'شبكة', totalNetwork),
//               _summaryChip(Icons.crisis_alert, 'ذهب كسر', totalScrap,
//                   unit: 'جم'),
//               _summaryChip(Icons.work, 'ذهب مشغول', totalWorked, unit: 'جم'),
//               _summaryChip(Icons.storage, 'كسر المخزن', totalStorageWeight,
//                   unit: 'جم'),
//               _summaryChip(Icons.inventory, 'المخزون', totalInventoryValue,
//                   unit: 'ريال'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _summaryChip(IconData icon, String label, double value,
//       {String unit = ''}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: Colors.white, size: 16),
//           const SizedBox(width: 6),
//           Text(
//             '$label: ${_formatNumber(value)} $unit',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionGrid({
//     required String title,
//     required IconData icon,
//     required Map<String, dynamic> items,
//   }) {
//     return Container(
//       decoration: _cardDecoration(),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: goldColor, size: 22),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 16,
//               runSpacing: 8,
//               children: items.entries.map((e) {
//                 return Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: goldLight,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${e.key}: ${_formatNumber(e.value)}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF444444),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGoldSectionRow({
//     required String title,
//     required IconData icon,
//     required Map<String, dynamic> data,
//   }) {
//     final carats = ['24', '22', '21', '18', '14'];
//     final colors = [
//       Colors.amber.shade700,
//       Colors.amber.shade600,
//       Colors.amber.shade500,
//       Colors.amber.shade400,
//       Colors.amber.shade300,
//     ];

//     return Container(
//       decoration: _cardDecoration(),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: goldColor, size: 22),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: List.generate(carats.length, (index) {
//                 final carat = carats[index];
//                 final value = data[carat] ?? 0;
//                 return Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         color: colors[index].withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: colors[index].withOpacity(0.3),
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'عيار $carat',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: colors[index],
//                             ),
//                           ),
//                           Text(
//                             '${_formatNumber(value)} جم',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade800,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ===== عرض كسر المخزن مجمعاً حسب العيار =====
//   Widget _buildGroupedStorageSection(List<dynamic> storage) {
//     // تجميع الأوزان حسب العيار
//     Map<String, double> grouped = {};
//     for (var item in storage) {
//       final carat = item['carat']?.toString() ?? 'غير معروف';
//       final weight = (item['weight'] ?? 0).toDouble();
//       grouped[carat] = (grouped[carat] ?? 0) + weight;
//     }

//     // تحويل الخريطة إلى قائمة لعرضها
//     final items = grouped.entries.map((e) {
//       return 'عيار ${e.key}: ${_formatNumber(e.value)} جم';
//     }).toList();

//     return _buildDynamicListSection(
//       title: 'كسر بالمخزن',
//       icon: Icons.storage,
//       items: items,
//       itemBuilder: (item) => item,
//       emptyMessage: 'لا توجد قطع',
//     );
//   }

//   Widget _buildDynamicListSection({
//     required String title,
//     required IconData icon,
//     required List<dynamic> items,
//     required String Function(dynamic) itemBuilder,
//     required String emptyMessage,
//   }) {
//     return Container(
//       decoration: _cardDecoration(),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: goldColor, size: 22),
//                 const SizedBox(width: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//                 if (items.isNotEmpty) ...[
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: goldColor.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${items.length}',
//                       style: TextStyle(
//                         color: goldColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//             const SizedBox(height: 10),
//             if (items.isEmpty)
//               Center(
//                 child: Text(
//                   emptyMessage,
//                   style: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 14,
//                   ),
//                 ),
//               )
//             else
//               Column(
//                 children: items.map((item) {
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 6),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: Colors.grey.shade200,
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.circle,
//                           color: goldColor.withOpacity(0.5),
//                           size: 8,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             itemBuilder(item),
//                             style: const TextStyle(fontSize: 13),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ===== قسم الشركاء =====
//   Widget _buildPartnersSection() {
//     return FutureBuilder<List<Map<String, dynamic>>>(
//       future: _partnersFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(goldColor),
//               ),
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return _buildErrorCard('حدث خطأ أثناء تحميل الشركاء');
//         }

//         final partners = snapshot.data ?? [];

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.people, color: goldColor, size: 28),
//                 const SizedBox(width: 12),
//                 const Text(
//                   '👥 رأس مال الشركاء',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF333333),
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: goldColor.withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${partners.length} ${partners.length == 1 ? 'شريك' : 'شركاء'}',
//                     style: TextStyle(
//                       color: goldColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (partners.isEmpty)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'لا يوجد شركاء مسجلين',
//                     style: TextStyle(color: Colors.grey.shade500),
//                   ),
//                 ),
//               )
//             else
//               Column(
//                 children: partners.map((p) {
//                   final name = p['partnerName'] ?? 'غير معروف';
//                   final amount =
//                       (p['openingAmountCarat24'] as num?)?.toDouble() ?? 0;
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: goldColor.withOpacity(0.15),
//                         width: 1,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.03),
//                           blurRadius: 4,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: goldColor.withOpacity(0.15),
//                         child: Text(
//                           name.isNotEmpty ? name[0] : '?',
//                           style: const TextStyle(
//                             color: goldColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 15,
//                         ),
//                       ),
//                       subtitle: Text(
//                         'رأس المال: ${_formatNumber(amount)} جرام عيار 24',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 13,
//                         ),
//                       ),
//                       trailing: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: goldColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           '${_formatNumber(amount)} جم',
//                           style: const TextStyle(
//                             color: goldColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // 🔹 دوال مساعدة
//   // ============================================================

//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.04),
//           blurRadius: 8,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorCard(String message, {bool isError = true}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: isError ? Colors.red.shade50 : Colors.orange.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isError ? Colors.red.shade200 : Colors.orange.shade200,
//           width: 1,
//         ),
//       ),
//       child: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.info_outline,
//               color: isError ? Colors.red.shade400 : Colors.orange.shade400,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               message,
//               style: TextStyle(
//                 color: isError ? Colors.red.shade700 : Colors.orange.shade700,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatNumber(dynamic value) {
//     if (value == null) return '0';
//     if (value is num) {
//       if (value == value.toInt()) {
//         return value.toInt().toString();
//       }
//       return value.toStringAsFixed(2);
//     }
//     return value.toString();
//   }

//   String _formatTimestamp(dynamic timestamp) {
//     if (timestamp == null) return 'غير معروف';
//     try {
//       if (timestamp is DateTime) {
//         return '${timestamp.day.toString().padLeft(2, '0')}/'
//             '${timestamp.month.toString().padLeft(2, '0')}/'
//             '${timestamp.year} '
//             '${timestamp.hour.toString().padLeft(2, '0')}:'
//             '${timestamp.minute.toString().padLeft(2, '0')}';
//       }
//       return timestamp.toString();
//     } catch (_) {
//       return timestamp.toString();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:uhf_gold_shop/services/firestore_service.dart';

class OpeningBalanceDisplayPage extends StatefulWidget {
  const OpeningBalanceDisplayPage({super.key});

  @override
  State<OpeningBalanceDisplayPage> createState() =>
      _OpeningBalanceDisplayPageState();
}

class _OpeningBalanceDisplayPageState extends State<OpeningBalanceDisplayPage> {
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFFFF8E1);

  late Future<Map<String, dynamic>?> _balanceFuture;
  late Future<List<Map<String, dynamic>>> _partnersFuture;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _balanceFuture = FS.getOpeningBalance();
    _partnersFuture = FS.getPartnersOpeningCapital();
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    _loadData();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'عرض الرصيد الافتتاحي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: goldColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh, color: Colors.white),
            onPressed: _isRefreshing ? null : _refreshData,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _balanceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(goldColor),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _buildErrorCard('حدث خطأ أثناء تحميل البيانات');
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return _buildErrorCard(
                  '❌ لا يوجد رصيد افتتاحي مسجل بعد',
                  isError: false,
                );
              }

              final data = snapshot.data!;
              final daily = data['dailyCashBox'] ?? {};
              final safe = data['safe'] ?? {};
              final scrapGold = data['scrapGoldByCarat'] ?? {};
              final workedGold = data['workedGoldByCarat'] ?? {};
              final custody = data['scrapCustody'] ?? {};
              final storage = data['scrapInStorage'] ?? [];
              final inv = data['inventory'] ?? [];

              // حساب الإجماليات
              final totalCash = (daily['cash'] ?? 0) +
                  (safe['cash'] ?? 0) +
                  (custody['cash'] ?? 0);
              final totalNetwork = (daily['network'] ?? 0) +
                  (safe['network'] ?? 0) +
                  (custody['network'] ?? 0);
              final totalScrap = (scrapGold['24'] ?? 0) +
                  (scrapGold['22'] ?? 0) +
                  (scrapGold['21'] ?? 0) +
                  (scrapGold['18'] ?? 0) +
                  (scrapGold['14'] ?? 0);
              final totalWorked = (workedGold['24'] ?? 0) +
                  (workedGold['22'] ?? 0) +
                  (workedGold['21'] ?? 0) +
                  (workedGold['18'] ?? 0) +
                  (workedGold['14'] ?? 0);

              // إجمالي كسر المخزن (مجموع الأوزان)
              double totalStorageWeight = 0;
              for (var item in storage) {
                totalStorageWeight += (item['weight'] ?? 0).toDouble();
              }

              // ✅ إجمالي المخزون (مجموع الأوزان، وليس القيم)
              double totalInventoryWeight = 0;
              for (var item in inv) {
                totalInventoryWeight += (item['weight'] ?? 0).toDouble();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== بطاقة الملخص =====
                    _buildSummaryCard(
                      totalCash: totalCash,
                      totalNetwork: totalNetwork,
                      totalScrap: totalScrap,
                      totalWorked: totalWorked,
                      totalStorageWeight: totalStorageWeight,
                      totalInventoryWeight: totalInventoryWeight, // تم التعديل
                    ),
                    const SizedBox(height: 20),

                    // ===== تفاصيل الأقسام =====
                    _buildSectionGrid(
                      title: 'صندوق اليومي',
                      icon: Icons.business_center,
                      items: {
                        'كاش': daily['cash'] ?? 0,
                        'شبكة': daily['network'] ?? 0,
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildSectionGrid(
                      title: 'الخزنة',
                      icon: Icons.account_balance,
                      items: {
                        'كاش': safe['cash'] ?? 0,
                        'شبكة': safe['network'] ?? 0,
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildGoldSectionRow(
                      title: 'ذهب كسر',
                      icon: Icons.crisis_alert,
                      data: scrapGold,
                    ),
                    const SizedBox(height: 12),

                    _buildGoldSectionRow(
                      title: 'ذهب مشغول',
                      icon: Icons.work,
                      data: workedGold,
                    ),
                    const SizedBox(height: 12),

                    _buildSectionGrid(
                      title: 'عهدة الكسر',
                      icon: Icons.account_balance_wallet,
                      items: {
                        'كاش': custody['cash'] ?? 0,
                        'شبكة': custody['network'] ?? 0,
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildGroupedStorageSection(storage),
                    const SizedBox(height: 12),

                    _buildDynamicListSection(
                      title: 'المخزون',
                      icon: Icons.inventory,
                      items: inv,
                      itemBuilder: (item) =>
                          'قيمة: ${_formatNumber(item['value'])} - وزن: ${_formatNumber(item['weight'])} جم - عيار: ${item['carat']}',
                      emptyMessage: 'لا توجد مواد',
                    ),
                    const SizedBox(height: 12),

                    const Divider(thickness: 2, color: goldColor),
                    const SizedBox(height: 16),
                    _buildPartnersSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 دوال بناء الواجهة
  // ============================================================

  Widget _buildSummaryCard({
    required double totalCash,
    required double totalNetwork,
    required double totalScrap,
    required double totalWorked,
    required double totalStorageWeight,
    required double totalInventoryWeight, // تم التعديل
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [goldColor, goldDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: goldColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '📊 ملخص الرصيد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _summaryChip(Icons.money, 'كاش', totalCash),
              _summaryChip(Icons.wifi, 'شبكة', totalNetwork),
              _summaryChip(Icons.crisis_alert, 'ذهب كسر', totalScrap,
                  unit: 'جم'),
              _summaryChip(Icons.work, 'ذهب مشغول', totalWorked, unit: 'جم'),
              _summaryChip(Icons.storage, 'كسر المخزن', totalStorageWeight,
                  unit: 'جم'),
              // ✅ الآن المخزون يعرض الوزن الإجمالي
              _summaryChip(Icons.inventory, 'المخزون', totalInventoryWeight,
                  unit: 'جم'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(IconData icon, String label, double value,
      {String unit = ''}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            '$label: ${_formatNumber(value)} $unit',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionGrid({
    required String title,
    required IconData icon,
    required Map<String, dynamic> items,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: goldColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: items.entries.map((e) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: goldLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${e.key}: ${_formatNumber(e.value)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF444444),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldSectionRow({
    required String title,
    required IconData icon,
    required Map<String, dynamic> data,
  }) {
    final carats = ['24', '22', '21', '18', '14'];
    final colors = [
      Colors.amber.shade700,
      Colors.amber.shade600,
      Colors.amber.shade500,
      Colors.amber.shade400,
      Colors.amber.shade300,
    ];

    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: goldColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(carats.length, (index) {
                final carat = carats[index];
                final value = data[carat] ?? 0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: colors[index].withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colors[index].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عيار $carat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors[index],
                            ),
                          ),
                          Text(
                            '${_formatNumber(value)} جم',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedStorageSection(List<dynamic> storage) {
    Map<String, double> grouped = {};
    for (var item in storage) {
      final carat = item['carat']?.toString() ?? 'غير معروف';
      final weight = (item['weight'] ?? 0).toDouble();
      grouped[carat] = (grouped[carat] ?? 0) + weight;
    }
    final items = grouped.entries.map((e) {
      return 'عيار ${e.key}: ${_formatNumber(e.value)} جم';
    }).toList();

    return _buildDynamicListSection(
      title: 'كسر بالمخزن',
      icon: Icons.storage,
      items: items,
      itemBuilder: (item) => item,
      emptyMessage: 'لا توجد قطع',
    );
  }

  Widget _buildDynamicListSection({
    required String title,
    required IconData icon,
    required List<dynamic> items,
    required String Function(dynamic) itemBuilder,
    required String emptyMessage,
  }) {
    return Container(
      decoration: _cardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: goldColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                if (items.isNotEmpty) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: goldColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length}',
                      style: TextStyle(
                        color: goldColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              Center(
                child: Text(
                  emptyMessage,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
              )
            else
              Column(
                children: items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: goldColor.withOpacity(0.5),
                          size: 8,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            itemBuilder(item),
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnersSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _partnersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(goldColor),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorCard('حدث خطأ أثناء تحميل الشركاء');
        }

        final partners = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: goldColor, size: 28),
                const SizedBox(width: 12),
                const Text(
                  '👥 رأس مال الشركاء',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${partners.length} ${partners.length == 1 ? 'شريك' : 'شركاء'}',
                    style: TextStyle(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (partners.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Text(
                    'لا يوجد شركاء مسجلين',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              Column(
                children: partners.map((p) {
                  final name = p['partnerName'] ?? 'غير معروف';
                  final amount =
                      (p['openingAmountCarat24'] as num?)?.toDouble() ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: goldColor.withOpacity(0.15),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: goldColor.withOpacity(0.15),
                        child: Text(
                          name.isNotEmpty ? name[0] : '?',
                          style: const TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        'رأس المال: ${_formatNumber(amount)} جرام عيار 24',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: goldColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_formatNumber(amount)} جم',
                          style: const TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }

  // ============================================================
  // 🔹 دوال مساعدة
  // ============================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message, {bool isError = true}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isError ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? Colors.red.shade200 : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: isError ? Colors.red.shade400 : Colors.orange.shade400,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red.shade700 : Colors.orange.shade700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is num) {
      if (value == value.toInt()) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'غير معروف';
    try {
      if (timestamp is DateTime) {
        return '${timestamp.day.toString().padLeft(2, '0')}/'
            '${timestamp.month.toString().padLeft(2, '0')}/'
            '${timestamp.year} '
            '${timestamp.hour.toString().padLeft(2, '0')}:'
            '${timestamp.minute.toString().padLeft(2, '0')}';
      }
      return timestamp.toString();
    } catch (_) {
      return timestamp.toString();
    }
  }
}
