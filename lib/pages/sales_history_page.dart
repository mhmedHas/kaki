// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// // class SalesHistoryPage extends StatefulWidget {
// //   const SalesHistoryPage({super.key});

// //   @override
// //   State<SalesHistoryPage> createState() => _SalesHistoryPageState();
// // }

// // class _SalesHistoryPageState extends State<SalesHistoryPage> {
// //   final uid = FirebaseAuth.instance.currentUser!.uid;

// //   bool deletingAll = false;

// //   CollectionReference get historyCol =>
// //       FirebaseFirestore.instance
// //           .collection('users')
// //           .doc(uid)
// //           .collection('sales_history');

// //   @override
// //   void initState() {
// //     super.initState();
// //     _deleteExpiredItems();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("سجل المبيعات"),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.delete_forever),
// //             onPressed: deletingAll ? null : _confirmDeleteAll,
// //           )
// //         ],
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: historyCol.orderBy("soldAt", descending: true).snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(
// //               child: CircularProgressIndicator(),
// //             );
// //           }

// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return const Center(
// //               child: Text(
// //                 "لا يوجد سجل مبيعات",
// //                 style: TextStyle(fontSize: 18),
// //               ),
// //             );
// //           }

// //           final docs = snapshot.data!.docs;

// //           return ListView.builder(
// //             padding: const EdgeInsets.all(12),
// //             itemCount: docs.length,
// //             itemBuilder: (context, index) {
// //               final doc = docs[index];

// //               final data = doc.data() as Map<String, dynamic>;

// //               final payload =
// //               Map<String, dynamic>.from(data['payload'] ?? {});

// //               final payment =
// //               Map<String, dynamic>.from(data['payment'] ?? {});

// //               final Timestamp? ts = data["soldAt"];

// //               String date = "";

// //               if (ts != null) {
// //                 date = DateFormat(
// //                   "yyyy/MM/dd   HH:mm",
// //                 ).format(ts.toDate());
// //               }

// //               return Card(
// //                 elevation: 4,
// //                 margin: const EdgeInsets.only(bottom: 12),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(12),
// //                   child: Column(
// //                     children: [

// //                       _row("رقم الشريحة", data["epcHex"] ?? ""),
// //                       if (payload['kind'] != null)
// //                         _row("النوع", payload["kind"] ?? ""),
// //                       if (payload['type'] != null)
// //                         _row("النوع", payload["type"] ?? ""),
// //                       if (data['category'] == "bullion")
// //                         _row("النوع", "سبائك" ?? ""),
// //                       if (payload['carat'] != null)
// //                         _row("العيار", payload["carat"] ?? ""),
// //                       if (payload['weight'] != null)
// //                         _row(
// //                           "الوزن",
// //                           "${payload["weight"] ?? 0}",
// //                         ),
// //                       if (payload['wage'] != null)
// //                         _row(
// //                           "الاجر",
// //                           "${payload["wage"] ?? 0}",
// //                         ),
// //                       if (payload['cost'] != null)
// //                         _row(
// //                           "التكلفة",
// //                           "${payload["cost"] ?? 0}",
// //                         ),

// //                       _row(
// //                         "الإجمالي",
// //                         "${payment["total"] ?? 0}",
// //                       ),
// //                       if (payment["type"] == "visa")
// //                         _row(
// //                           "طريقة الدفع",
// //                           "شبكة",
// //                         ),
// //                       if (payment["type"] == "cash")
// //                         _row(
// //                           "طريقة الدفع",
// //                           "كاش",
// //                         ),
// //                       if (payment["type"] == "multi")
// //                         _row(
// //                           "طريقة الدفع",
// //                           "متعدد",
// //                         ),
// //                       _row(
// //                         "البائع",
// //                         payment["soldBy"] ?? "",
// //                       ),

// //                       _row(
// //                         "تاريخ البيع",
// //                         date,
// //                       ),

// //                       const Divider(),

// //                       Row(
// //                         children: [

// //                           Expanded(
// //                             child: ElevatedButton.icon(
// //                               onPressed: () {
// //                                 _showImages(
// //                                   data["epcHex"],
// //                                 );
// //                               },
// //                               icon: const Icon(Icons.image),
// //                               label: const Text("الصور"),
// //                             ),
// //                           ),

// //                           const SizedBox(width: 10),

// //                           Expanded(
// //                             child: ElevatedButton.icon(
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Colors.red,
// //                                 foregroundColor: Colors.white,
// //                               ),
// //                               onPressed: () {
// //                                 _confirmDeleteOne(doc);
// //                               },
// //                               icon: const Icon(Icons.delete),
// //                               label: const Text("حذف"),
// //                             ),
// //                           ),

// //                         ],
// //                       )

// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _row(String title, String value) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 3),
// //       child: Row(
// //         children: [

// //           Expanded(
// //             flex: 3,
// //             child: Text(
// //               title,
// //               style: const TextStyle(
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),

// //           Expanded(
// //             flex: 5,
// //             child: Text(value),
// //           )

// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> _showImages(String epc) async {
// //     final folderRef = FirebaseStorage.instance
// //         .ref()
// //         .child('images')
// //         .child('users')
// //         .child(uid)
// //         .child('sales')
// //         .child(epc.toUpperCase());

// //     try {
// //       final result = await folderRef.listAll();

// //       if (result.items.isEmpty) {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(
// //               content: Text("لا توجد صور لهذه الشريحة"),
// //             ),
// //           );
// //         }
// //         return;
// //       }

// //       final urls = await Future.wait(
// //         result.items.map((e) => e.getDownloadURL()),
// //       );

// //       if (!mounted) return;

// //       showDialog(
// //         context: context,
// //         builder: (_) =>
// //             Dialog(
// //               child: Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: SizedBox(
// //                   width: double.maxFinite,
// //                   height: 450,
// //                   child: Column(
// //                     children: [
// //                       const Text(
// //                         "صور الشريحة",
// //                         style: TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),

// //                       const SizedBox(height: 12),

// //                       Expanded(
// //                         child: GridView.builder(
// //                           itemCount: urls.length,
// //                           gridDelegate:
// //                           const SliverGridDelegateWithFixedCrossAxisCount(
// //                             crossAxisCount: 1,
// //                             crossAxisSpacing: 8,
// //                             mainAxisSpacing: 8,
// //                           ),
// //                           itemBuilder: (_, index) {
// //                             return InkWell(
// //                               onTap: () {
// //                                 Navigator.pop(context);
// //                                 _openImage(urls[index]);
// //                               },
// //                               child: ClipRRect(
// //                                 borderRadius:
// //                                 BorderRadius.circular(10),
// //                                 child: Image.network(
// //                                   urls[index],
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                       ),

// //                       const SizedBox(height: 8),

// //                       ElevatedButton(
// //                         onPressed: () {
// //                           Navigator.pop(context);
// //                         },
// //                         child: const Text("إغلاق"),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //       );
// //     } catch (e) {
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(e.toString()),
// //           ),
// //         );
// //       }
// //     }
// //   }

// //   void _openImage(String url) {
// //     showDialog(
// //       context: context,
// //       builder: (_) =>
// //           Dialog(
// //             backgroundColor: Colors.black,
// //             insetPadding: EdgeInsets.zero,
// //             child: InteractiveViewer(
// //               minScale: 0.5,
// //               maxScale: 5,
// //               child: Image.network(url),
// //             ),
// //           ),
// //     );
// //   }

// //   Future<void> _confirmDeleteOne(DocumentSnapshot doc) async {
// //     final ok = await showDialog<bool>(
// //       context: context,
// //       builder: (_) =>
// //           AlertDialog(
// //             title: const Text("حذف السجل"),
// //             content: const Text(
// //               "هل تريد حذف هذا السجل مع جميع الصور الخاصة به؟",
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context, false),
// //                 child: const Text("إلغاء"),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () => Navigator.pop(context, true),
// //                 child: const Text("حذف"),
// //               ),
// //             ],
// //           ),
// //     );

// //     if (ok != true) return;

// //     final data = doc.data() as Map<String, dynamic>;

// //     await _deleteImages(data["epcHex"]);

// //     await doc.reference.delete();

// //     if (mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("تم حذف السجل"),
// //         ),
// //       );
// //     }
// //   }
// //   Future<void> _deleteImages(String epc) async {
// //     try {
// //       final folderRef = FirebaseStorage.instance
// //           .ref()
// //           .child("images")
// //           .child("users")
// //           .child(uid)
// //           .child("sales")
// //           .child(epc.toUpperCase());

// //       final result = await folderRef.listAll();

// //       for (final file in result.items) {
// //         await file.delete();
// //       }
// //     } catch (_) {}
// //   }

// //   Future<void> _confirmDeleteAll() async {
// //     final ok = await showDialog<bool>(
// //       context: context,
// //       builder: (_) =>
// //           AlertDialog(
// //             title: const Text("حذف السجل بالكامل"),
// //             content: const Text(
// //               "سيتم حذف جميع السجلات وجميع الصور، هل أنت متأكد؟",
// //             ),
// //             actions: [
// //               TextButton(
// //                 onPressed: () => Navigator.pop(context, false),
// //                 child: const Text("إلغاء"),
// //               ),
// //               ElevatedButton(
// //                 onPressed: () => Navigator.pop(context, true),
// //                 child: const Text("حذف"),
// //               ),
// //             ],
// //           ),
// //     );

// //     if (ok != true) return;

// //     setState(() {
// //       deletingAll = true;
// //     });

// //     try {
// //       final docs = await historyCol.get();

// //       for (final doc in docs.docs) {
// //         final data = doc.data() as Map<String, dynamic>;

// //         await _deleteImages(data["epcHex"]);

// //         await doc.reference.delete();
// //       }

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("تم حذف السجل بالكامل"),
// //           ),
// //         );
// //       }
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           deletingAll = false;
// //         });
// //       }
// //     }
// //   }

// //   Future<void> _deleteExpiredItems() async {
// //     try {
// //       final limit = DateTime.now().subtract(
// //         const Duration(days: 30),
// //       );

// //       final oldDocs = await historyCol
// //           .where(
// //         "soldAt",
// //         isLessThan: Timestamp.fromDate(limit),
// //       )
// //           .get();

// //       for (final doc in oldDocs.docs) {
// //         final data = doc.data() as Map<String, dynamic>;

// //         await _deleteImages(data["epcHex"]);

// //         await doc.reference.delete();
// //       }
// //     } catch (e) {
// //       debugPrint(e.toString());
// //     }
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class SalesHistoryPage extends StatefulWidget {
//   const SalesHistoryPage({super.key});

//   @override
//   State<SalesHistoryPage> createState() => _SalesHistoryPageState();
// }

// class _SalesHistoryPageState extends State<SalesHistoryPage> {
//   final uid = FirebaseAuth.instance.currentUser!.uid;

//   bool deletingAll = false;

//   /// 🔹 فلتر البائع (null = كل البائعين)
//   String? _selectedSeller;

//   /// 🔹 كاش الصور
//   final Map<String, List<String>> _imageCache = {};

//   CollectionReference get historyCol => FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('sales_history');

//   @override
//   void initState() {
//     super.initState();
//     _deleteExpiredItems();
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 Helpers
//   // ═════════════════════════════════════════════════════════════
//   double _d(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0;

//   DateTime _date(Map<String, dynamic> data) {
//     final ts = data['soldAt'];
//     if (ts is Timestamp) return ts.toDate();
//     return DateTime.fromMillisecondsSinceEpoch(0);
//   }

//   String _seller(Map<String, dynamic> data) {
//     final payment = data['payment'];
//     if (payment is Map) {
//       final v = payment['soldBy'];
//       if (v != null && v.toString().trim().isNotEmpty) return v.toString();
//     }
//     return '';
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

//   String _paymentType(Map<String, dynamic> data) {
//     final p = data['payment'];
//     return p is Map ? (p['type'] ?? '').toString() : '';
//   }

//   double _weight(Map<String, dynamic> data) {
//     final payload = data['payload'];
//     if (payload is Map) return _d(payload['weight']);
//     return 0;
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 الفلترة
//   // ═════════════════════════════════════════════════════════════
//   List<QueryDocumentSnapshot> _filtered(List<QueryDocumentSnapshot> docs) {
//     if (_selectedSeller == null) return docs;
//     return docs.where((d) {
//       final data = d.data() as Map<String, dynamic>;
//       return _seller(data) == _selectedSeller;
//     }).toList();
//   }

//   List<String> _allSellers(List<QueryDocumentSnapshot> docs) {
//     final set = <String>{};
//     for (final d in docs) {
//       final s = _seller(d.data() as Map<String, dynamic>);
//       if (s.isNotEmpty) set.add(s);
//     }
//     return set.toList()..sort();
//   }

//   Map<String, _SellerTotal> _sellerTotals(List<QueryDocumentSnapshot> docs) {
//     final map = <String, _SellerTotal>{};
//     for (final d in docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final seller = _seller(data);
//       if (seller.isEmpty) continue;
//       map.putIfAbsent(seller, () => _SellerTotal());
//       final t = map[seller]!;
//       t.count++;
//       t.cash += _cash(data);
//       t.visa += _visa(data);
//       t.total += _total(data);
//       t.weight += _weight(data);
//     }
//     return map;
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 صور (بكاش)
//   // ═════════════════════════════════════════════════════════════
//   Future<List<String>> _getImages(String epcHex) async {
//     final key = epcHex.toUpperCase();
//     if (_imageCache.containsKey(key)) return _imageCache[key]!;

//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child('sales')
//           .child(key);

//       final result = await ref.listAll();
//       if (result.items.isEmpty) {
//         _imageCache[key] = [];
//         return [];
//       }
//       final urls =
//           await Future.wait(result.items.map((e) => e.getDownloadURL()));
//       _imageCache[key] = urls;
//       return urls;
//     } catch (_) {
//       _imageCache[key] = [];
//       return [];
//     }
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 Build
//   // ═════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF7F0),
//       appBar: AppBar(
//         title: const Text("سجل المبيعات"),
//         backgroundColor: const Color(0xFFD4AF37),
//         foregroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_forever),
//             tooltip: "حذف الكل",
//             onPressed: deletingAll ? null : _confirmDeleteAll,
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: historyCol.orderBy("soldAt", descending: true).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return _buildErrorState(snapshot.error.toString());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return _buildEmptyState();
//           }

//           final allDocs = snapshot.data!.docs;
//           final sellers = _allSellers(allDocs);
//           final filtered = _filtered(allDocs);

//           if (_selectedSeller != null && !sellers.contains(_selectedSeller)) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (mounted) setState(() => _selectedSeller = null);
//             });
//           }

//           return RefreshIndicator(
//             onRefresh: () async => setState(() {}),
//             child: ListView(
//               padding: const EdgeInsets.all(14),
//               children: [
//                 _buildSummaryCard(filtered),
//                 const SizedBox(height: 14),
//                 _buildSellerFilter(sellers),
//                 const SizedBox(height: 14),
//                 if (_selectedSeller == null) ...[
//                   _buildSellersBreakdown(allDocs),
//                   const SizedBox(height: 14),
//                 ],
//                 if (filtered.isEmpty)
//                   _buildNoMatchState()
//                 else ...[
//                   Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//                     child: Text(
//                       _selectedSeller == null
//                           ? "كل عمليات البيع (${filtered.length})"
//                           : "سجل البائع: $_selectedSeller (${filtered.length})",
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFB8860B),
//                       ),
//                     ),
//                   ),
//                   for (final doc in filtered)
//                     _buildSaleCard(
//                       doc,
//                       doc.data() as Map<String, dynamic>,
//                     ),
//                 ],
//                 const SizedBox(height: 40),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 الحالات
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.inbox_outlined, size: 90, color: Colors.grey.shade400),
//           const SizedBox(height: 14),
//           Text(
//             "لا يوجد سجل مبيعات بعد",
//             style: TextStyle(
//               fontSize: 17,
//               color: Colors.grey.shade600,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoMatchState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 50),
//       child: Column(
//         children: [
//           Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
//           const SizedBox(height: 10),
//           Text(
//             "لا توجد مبيعات لهذا البائع",
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(String err) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 70, color: Colors.red),
//             const SizedBox(height: 12),
//             const Text(
//               "حدث خطأ في تحميل السجل",
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               err,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 11, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 ملخص علوي
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildSummaryCard(List<QueryDocumentSnapshot> docs) {
//     double cash = 0, visa = 0, total = 0, weight = 0;
//     for (final d in docs) {
//       final data = d.data() as Map<String, dynamic>;
//       cash += _cash(data);
//       visa += _visa(data);
//       total += _total(data);
//       weight += _weight(data);
//     }

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
//             color: const Color(0xFFD4AF37).withOpacity(0.35),
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
//                 child: _topStat(
//                   Icons.inventory_2,
//                   "عدد القطع",
//                   "${docs.length}",
//                 ),
//               ),
//               Container(
//                 width: 1,
//                 height: 42,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               Expanded(
//                 child: _topStat(
//                   Icons.scale,
//                   "إجمالي الوزن",
//                   "${weight.toStringAsFixed(2)} جم",
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
//                 child: _bottomStat("كاش", cash.toStringAsFixed(2)),
//               ),
//               Container(
//                 width: 1,
//                 height: 34,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               Expanded(
//                 child: _bottomStat("شبكة", visa.toStringAsFixed(2)),
//               ),
//               Container(
//                 width: 1,
//                 height: 34,
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               Expanded(
//                 child: _bottomStat(
//                   "الإجمالي",
//                   total.toStringAsFixed(2),
//                   bold: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _topStat(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 22),
//         const SizedBox(height: 4),
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _bottomStat(String label, String value, {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: const TextStyle(color: Colors.white70, fontSize: 11)),
//         const SizedBox(height: 3),
//         Text(
//           "$value ريال",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: bold ? 15 : 13,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 فلتر البائع
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildSellerFilter(List<String> sellers) {
//     if (sellers.isEmpty) return const SizedBox();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: const Color(0xFFD4AF37).withOpacity(0.3),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.person_search, color: Color(0xFFD4AF37), size: 22),
//           const SizedBox(width: 10),
//           Expanded(
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _selectedSeller,
//                 isExpanded: true,
//                 hint: const Text("كل البائعين"),
//                 items: [
//                   const DropdownMenuItem<String>(
//                     value: null,
//                     child: Text("كل البائعين"),
//                   ),
//                   ...sellers.map(
//                     (s) => DropdownMenuItem<String>(
//                       value: s,
//                       child: Text(s),
//                     ),
//                   ),
//                 ],
//                 onChanged: (v) => setState(() => _selectedSeller = v),
//               ),
//             ),
//           ),
//           if (_selectedSeller != null)
//             IconButton(
//               icon: const Icon(Icons.close, size: 20),
//               tooltip: "مسح الفلتر",
//               onPressed: () => setState(() => _selectedSeller = null),
//             ),
//         ],
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 إجماليات البائعين
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildSellersBreakdown(List<QueryDocumentSnapshot> docs) {
//     final totals = _sellerTotals(docs);
//     if (totals.isEmpty) return const SizedBox();

//     final entries = totals.entries.toList()
//       ..sort((a, b) => b.value.total.compareTo(a.value.total));

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: const Color(0xFFD4AF37).withOpacity(0.3),
//         ),
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
//               const Icon(Icons.groups, color: Color(0xFFD4AF37), size: 22),
//               const SizedBox(width: 8),
//               const Text(
//                 "إجماليات البائعين",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               const Spacer(),
//               Text(
//                 "اضغط للفلترة",
//                 style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           ...entries.map((e) => _buildSellerRow(e.key, e.value)),
//         ],
//       ),
//     );
//   }

//   Widget _buildSellerRow(String seller, _SellerTotal t) {
//     return InkWell(
//       onTap: () => setState(() => _selectedSeller = seller),
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFAF7F0),
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: const Color(0xFFD4AF37).withOpacity(0.2),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 14,
//                   backgroundColor: Color(0xFFD4AF37),
//                   child: Icon(Icons.person, size: 16, color: Colors.white),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     seller,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFD4AF37).withOpacity(0.15),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     "${t.count} قطعة",
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFFB8860B),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Icon(Icons.arrow_forward_ios,
//                     size: 11, color: Colors.grey),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child:
//                       _statCol("كاش", t.cash.toStringAsFixed(2), Colors.green),
//                 ),
//                 Expanded(
//                   child:
//                       _statCol("شبكة", t.visa.toStringAsFixed(2), Colors.blue),
//                 ),
//                 Expanded(
//                   child: _statCol(
//                     "الإجمالي",
//                     t.total.toStringAsFixed(2),
//                     const Color(0xFFB8860B),
//                     bold: true,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 const Icon(Icons.scale, size: 11, color: Colors.grey),
//                 const SizedBox(width: 4),
//                 Text(
//                   "الوزن: ${t.weight.toStringAsFixed(2)} جم",
//                   style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statCol(String label, String value, Color color,
//       {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: bold ? 13 : 12,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 كارت عملية بيع
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildSaleCard(
//     DocumentSnapshot doc,
//     Map<String, dynamic> data,
//   ) {
//     final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//     final epcHex = (data['epcHex'] ?? '').toString();
//     final category = (data['category'] ?? '').toString();
//     final paymentType = _paymentType(data);
//     final seller = _seller(data);
//     final date = _date(data);
//     final total = _total(data);
//     final cash = _cash(data);
//     final visa = _visa(data);

//     final catColor = _catColor(category);
//     final catLabel = _catLabel(category);

//     final dateStr =
//         date.year > 2000 ? DateFormat("yyyy/MM/dd  HH:mm").format(date) : "—";

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFFD4AF37).withOpacity(0.3),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ═══ الرأس ═══
//             Row(
//               children: [
//                 _badge(catLabel, catColor),
//                 const SizedBox(width: 6),
//                 if (paymentType.isNotEmpty)
//                   _badge(_payLabel(paymentType), _payColor(paymentType)),
//                 const Spacer(),
//                 Icon(Icons.calendar_today,
//                     size: 11, color: Colors.grey.shade500),
//                 const SizedBox(width: 4),
//                 Text(
//                   dateStr,
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // ═══ البيانات + الصور ═══
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _row(Icons.qr_code_2, "الشريحة",
//                           epcHex.isEmpty ? "—" : epcHex),
//                       if (payload['kind'] != null)
//                         _row(Icons.category, "النوع", "${payload['kind']}"),
//                       if (payload['type'] != null)
//                         _row(Icons.diamond, "النوع", "${payload['type']}"),
//                       if (category == "bullion")
//                         _row(Icons.workspace_premium, "النوع", "سبائك"),
//                       if (payload['carat'] != null)
//                         _row(Icons.grade, "العيار", "${payload['carat']}"),
//                       if (payload['weight'] != null)
//                         _row(Icons.scale, "الوزن", "${payload['weight']} جم"),
//                       if (payload['wage'] != null)
//                         _row(Icons.attach_money, "الأجر", "${payload['wage']}"),
//                       if (payload['cost'] != null)
//                         _row(Icons.payments, "التكلفة", "${payload['cost']}"),
//                       _row(
//                         Icons.person,
//                         "البائع",
//                         seller.isEmpty ? "—" : seller,
//                         valueColor: const Color(0xFFB8860B),
//                         bold: true,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   flex: 1,
//                   child: _buildImagesThumb(epcHex),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),
//             Divider(color: Colors.grey.shade200, height: 1),
//             const SizedBox(height: 10),

//             // ═══ المبالغ ═══
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFAF7F0),
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: const Color(0xFFD4AF37).withOpacity(0.2),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _moneyCol("كاش", cash, Colors.green),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 30,
//                     color: Colors.grey.shade300,
//                   ),
//                   Expanded(
//                     child: _moneyCol("شبكة", visa, Colors.blue),
//                   ),
//                   Container(
//                     width: 1,
//                     height: 30,
//                     color: Colors.grey.shade300,
//                   ),
//                   Expanded(
//                     child: _moneyCol(
//                       "الإجمالي",
//                       total,
//                       const Color(0xFFB8860B),
//                       bold: true,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 10),

//             // ═══ الأزرار ═══
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _showImages(epcHex),
//                     icon: const Icon(Icons.image, size: 18),
//                     label: const Text("الصور"),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: const Color(0xFFB8860B),
//                       side: BorderSide(
//                         color: const Color(0xFFD4AF37).withOpacity(0.6),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () => _confirmDeleteOne(doc),
//                     icon: const Icon(Icons.delete, size: 18),
//                     label: const Text("حذف"),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: BorderSide(
//                         color: Colors.red.withOpacity(0.5),
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _badge(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.13),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//           color: color,
//         ),
//       ),
//     );
//   }

//   Widget _row(IconData icon, String label, String value,
//       {Color? valueColor, bool bold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           Icon(icon, size: 13, color: Colors.grey.shade600),
//           const SizedBox(width: 5),
//           Text(
//             "$label: ",
//             style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: valueColor ?? Colors.black87,
//                 fontWeight: bold ? FontWeight.bold : FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _moneyCol(String label, double amount, Color color,
//       {bool bold = false}) {
//     return Column(
//       children: [
//         Text(label,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(
//           amount.toStringAsFixed(2),
//           style: TextStyle(
//             fontSize: bold ? 14 : 12,
//             fontWeight: bold ? FontWeight.bold : FontWeight.w600,
//             color: color,
//           ),
//         ),
//       ],
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 صور مصغرة
//   // ═════════════════════════════════════════════════════════════
//   Widget _buildImagesThumb(String epcHex) {
//     return SizedBox(
//       height: 120,
//       child: FutureBuilder<List<String>>(
//         future: _getImages(epcHex),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.grey.shade400,
//                 ),
//               ),
//             );
//           }
//           final urls = snap.data ?? [];
//           if (urls.isEmpty) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.image_not_supported,
//                       size: 26, color: Colors.grey.shade400),
//                   const SizedBox(height: 4),
//                   Text(
//                     "لا صور",
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: urls.length,
//             itemBuilder: (_, i) => Padding(
//               padding: const EdgeInsets.all(2),
//               child: GestureDetector(
//                 onTap: () => _openImage(urls[i]),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     urls[i],
//                     width: 90,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => Container(
//                       width: 90,
//                       color: Colors.grey.shade200,
//                       child: const Icon(Icons.broken_image,
//                           color: Colors.grey, size: 26),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 عرض الصور
//   // ═════════════════════════════════════════════════════════════
//   Future<void> _showImages(String epc) async {
//     if (epc.isEmpty) return;
//     final urls = await _getImages(epc);

//     if (!mounted) return;

//     if (urls.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("لا توجد صور لهذه الشريحة")),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: SizedBox(
//             width: double.maxFinite,
//             height: 480,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.image, color: Color(0xFFD4AF37)),
//                     const SizedBox(width: 8),
//                     const Expanded(
//                       child: Text(
//                         "صور الشريحة",
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(
//                   child: GridView.builder(
//                     itemCount: urls.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 8,
//                       mainAxisSpacing: 8,
//                     ),
//                     itemBuilder: (_, index) {
//                       return InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           _openImage(urls[index]);
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             urls[index],
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               color: Colors.grey.shade200,
//                               child: const Icon(Icons.broken_image,
//                                   color: Colors.grey),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _openImage(String url) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.black,
//         insetPadding: EdgeInsets.zero,
//         child: Stack(
//           children: [
//             InteractiveViewer(
//               minScale: 0.5,
//               maxScale: 5,
//               child: Image.network(url),
//             ),
//             Positioned(
//               top: 30,
//               right: 16,
//               child: CircleAvatar(
//                 backgroundColor: Colors.black54,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 حذف فردي / كلي
//   // ═════════════════════════════════════════════════════════════
//   Future<void> _confirmDeleteOne(DocumentSnapshot doc) async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text("حذف السجل"),
//         content: const Text(
//           "هل تريد حذف هذا السجل مع جميع الصور الخاصة به؟",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("حذف"),
//           ),
//         ],
//       ),
//     );
//     if (ok != true) return;

//     final data = doc.data() as Map<String, dynamic>;
//     await _deleteImages((data['epcHex'] ?? '').toString());
//     await doc.reference.delete();

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("تم حذف السجل")),
//       );
//     }
//   }

//   Future<void> _deleteImages(String epc) async {
//     if (epc.isEmpty) return;
//     try {
//       final key = epc.toUpperCase();
//       final folderRef = FirebaseStorage.instance
//           .ref()
//           .child("images")
//           .child("users")
//           .child(uid)
//           .child("sales")
//           .child(key);

//       final result = await folderRef.listAll();
//       for (final file in result.items) {
//         await file.delete();
//       }
//       _imageCache.remove(key);
//     } catch (_) {}
//   }

//   Future<void> _confirmDeleteAll() async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text("حذف السجل بالكامل"),
//         content: const Text(
//           "سيتم حذف جميع السجلات وجميع الصور، هل أنت متأكد؟",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("حذف الكل"),
//           ),
//         ],
//       ),
//     );
//     if (ok != true) return;

//     setState(() => deletingAll = true);

//     try {
//       final docs = await historyCol.get();
//       for (final doc in docs.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         await _deleteImages((data['epcHex'] ?? '').toString());
//         await doc.reference.delete();
//       }
//       _imageCache.clear();

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("تم حذف السجل بالكامل")),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => deletingAll = false);
//     }
//   }

//   Future<void> _deleteExpiredItems() async {
//     try {
//       final limit = DateTime.now().subtract(const Duration(days: 30));
//       final oldDocs = await historyCol
//           .where("soldAt", isLessThan: Timestamp.fromDate(limit))
//           .get();

//       for (final doc in oldDocs.docs) {
//         final data = doc.data() as Map<String, dynamic>;
//         await _deleteImages((data['epcHex'] ?? '').toString());
//         await doc.reference.delete();
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   // ═════════════════════════════════════════════════════════════
//   // 🔵 Helpers للتسميات والألوان
//   // ═════════════════════════════════════════════════════════════
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

//   String _payLabel(String t) {
//     switch (t) {
//       case 'cash':
//         return 'كاش';
//       case 'visa':
//         return 'شبكة';
//       case 'multi':
//         return 'متعدد';
//       default:
//         return t;
//     }
//   }

//   Color _payColor(String t) {
//     switch (t) {
//       case 'cash':
//         return Colors.green;
//       case 'visa':
//         return Colors.blue;
//       case 'multi':
//         return Colors.purple;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// // ═════════════════════════════════════════════════════════════
// // 🔵 نموذج إجماليات البائع
// // ═════════════════════════════════════════════════════════════
// class _SellerTotal {
//   int count = 0;
//   double cash = 0;
//   double visa = 0;
//   double total = 0;
//   double weight = 0;
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool deletingAll = false;

  /// 🔹 فلتر البائع (null = كل البائعين)
  String? _selectedSeller;

  /// 🔹 كاش الصور
  final Map<String, List<String>> _imageCache = {};

  CollectionReference get historyCol => FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('sales_history');

  @override
  void initState() {
    super.initState();
    _deleteExpiredItems();
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 Helpers
  // ═════════════════════════════════════════════════════════════
  double _d(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0;

  DateTime _date(Map<String, dynamic> data) {
    final ts = data['soldAt'];
    if (ts is Timestamp) return ts.toDate();
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _seller(Map<String, dynamic> data) {
    final payment = data['payment'];
    if (payment is Map) {
      final v = payment['soldBy'];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return '';
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

  String _paymentType(Map<String, dynamic> data) {
    final p = data['payment'];
    return p is Map ? (p['type'] ?? '').toString() : '';
  }

  double _weight(Map<String, dynamic> data) {
    final payload = data['payload'];
    if (payload is Map) return _d(payload['weight']);
    return 0;
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 الفلترة
  // ═════════════════════════════════════════════════════════════
  List<QueryDocumentSnapshot> _filtered(List<QueryDocumentSnapshot> docs) {
    if (_selectedSeller == null) return docs;
    return docs.where((d) {
      final data = d.data() as Map<String, dynamic>;
      return _seller(data) == _selectedSeller;
    }).toList();
  }

  List<String> _allSellers(List<QueryDocumentSnapshot> docs) {
    final set = <String>{};
    for (final d in docs) {
      final s = _seller(d.data() as Map<String, dynamic>);
      if (s.isNotEmpty) set.add(s);
    }
    return set.toList()..sort();
  }

  Map<String, _SellerTotal> _sellerTotals(List<QueryDocumentSnapshot> docs) {
    final map = <String, _SellerTotal>{};
    for (final d in docs) {
      final data = d.data() as Map<String, dynamic>;
      final seller = _seller(data);
      if (seller.isEmpty) continue;
      map.putIfAbsent(seller, () => _SellerTotal());
      final t = map[seller]!;
      t.count++;
      t.cash += _cash(data);
      t.visa += _visa(data);
      t.total += _total(data);
      t.weight += _weight(data);
    }
    return map;
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 صور (بكاش)
  // ═════════════════════════════════════════════════════════════
  Future<List<String>> _getImages(String epcHex) async {
    final key = epcHex.toUpperCase();
    if (_imageCache.containsKey(key)) return _imageCache[key]!;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child('sales')
          .child(key);

      final result = await ref.listAll();
      if (result.items.isEmpty) {
        _imageCache[key] = [];
        return [];
      }
      final urls =
          await Future.wait(result.items.map((e) => e.getDownloadURL()));
      _imageCache[key] = urls;
      return urls;
    } catch (_) {
      _imageCache[key] = [];
      return [];
    }
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 Build
  // ═════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      appBar: AppBar(
        title: const Text("سجل المبيعات"),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete_forever),
          //   tooltip: "حذف الكل",
          //   onPressed: deletingAll ? null : _confirmDeleteAll,
          // ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyCol.orderBy("soldAt", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          final allDocs = snapshot.data!.docs;
          final sellers = _allSellers(allDocs);
          final filtered = _filtered(allDocs);

          if (_selectedSeller != null && !sellers.contains(_selectedSeller)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedSeller = null);
            });
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _buildSummaryCard(filtered),
                const SizedBox(height: 14),
                _buildSellerFilter(sellers),
                const SizedBox(height: 14),
                if (_selectedSeller == null) ...[
                  _buildSellersBreakdown(allDocs),
                  const SizedBox(height: 14),
                ],
                if (filtered.isEmpty)
                  _buildNoMatchState()
                else ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      _selectedSeller == null
                          ? "كل عمليات البيع (${filtered.length})"
                          : "سجل البائع: $_selectedSeller (${filtered.length})",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB8860B),
                      ),
                    ),
                  ),
                  for (final doc in filtered)
                    _buildSaleCard(
                      doc,
                      doc.data() as Map<String, dynamic>,
                    ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 الحالات
  // ═════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 90, color: Colors.grey.shade400),
          const SizedBox(height: 14),
          Text(
            "لا يوجد سجل مبيعات بعد",
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          Text(
            "لا توجد مبيعات لهذا البائع",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              "حدث خطأ في تحميل السجل",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              err,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 ملخص علوي
  // ═════════════════════════════════════════════════════════════
  Widget _buildSummaryCard(List<QueryDocumentSnapshot> docs) {
    double cash = 0, visa = 0, total = 0, weight = 0;
    for (final d in docs) {
      final data = d.data() as Map<String, dynamic>;
      cash += _cash(data);
      visa += _visa(data);
      total += _total(data);
      weight += _weight(data);
    }

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
            color: const Color(0xFFD4AF37).withOpacity(0.35),
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
                child: _topStat(
                  Icons.inventory_2,
                  "عدد القطع",
                  "${docs.length}",
                ),
              ),
              Container(
                width: 1,
                height: 42,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _topStat(
                  Icons.scale,
                  "إجمالي الوزن",
                  "${weight.toStringAsFixed(2)} جم",
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
                child: _bottomStat("كاش", cash.toStringAsFixed(2)),
              ),
              Container(
                width: 1,
                height: 34,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _bottomStat("شبكة", visa.toStringAsFixed(2)),
              ),
              Container(
                width: 1,
                height: 34,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _bottomStat(
                  "الإجمالي",
                  total.toStringAsFixed(2),
                  bold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _bottomStat(String label, String value, {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 3),
        Text(
          "$value ريال",
          style: TextStyle(
            color: Colors.white,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 فلتر البائع
  // ═════════════════════════════════════════════════════════════
  Widget _buildSellerFilter(List<String> sellers) {
    if (sellers.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person_search, color: Color(0xFFD4AF37), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSeller,
                isExpanded: true,
                hint: const Text("كل البائعين"),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text("كل البائعين"),
                  ),
                  ...sellers.map(
                    (s) => DropdownMenuItem<String>(
                      value: s,
                      child: Text(s),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedSeller = v),
              ),
            ),
          ),
          if (_selectedSeller != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: "مسح الفلتر",
              onPressed: () => setState(() => _selectedSeller = null),
            ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 إجماليات البائعين
  // ═════════════════════════════════════════════════════════════
  Widget _buildSellersBreakdown(List<QueryDocumentSnapshot> docs) {
    final totals = _sellerTotals(docs);
    if (totals.isEmpty) return const SizedBox();

    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.total.compareTo(a.value.total));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
        ),
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
              const Icon(Icons.groups, color: Color(0xFFD4AF37), size: 22),
              const SizedBox(width: 8),
              const Text(
                "إجماليات البائعين",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const Spacer(),
              Text(
                "اضغط للفلترة",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...entries.map((e) => _buildSellerRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget _buildSellerRow(String seller, _SellerTotal t) {
    return InkWell(
      onTap: () => setState(() => _selectedSeller = seller),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFD4AF37),
                  child: Icon(Icons.person, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    seller,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${t.count} قطعة",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB8860B),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios,
                    size: 11, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child:
                      _statCol("كاش", t.cash.toStringAsFixed(2), Colors.green),
                ),
                Expanded(
                  child:
                      _statCol("شبكة", t.visa.toStringAsFixed(2), Colors.blue),
                ),
                Expanded(
                  child: _statCol(
                    "الإجمالي",
                    t.total.toStringAsFixed(2),
                    const Color(0xFFB8860B),
                    bold: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.scale, size: 11, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  "الوزن: ${t.weight.toStringAsFixed(2)} جم",
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCol(String label, String value, Color color,
      {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 13 : 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 كارت عملية بيع
  // ═════════════════════════════════════════════════════════════
  Widget _buildSaleCard(
    DocumentSnapshot doc,
    Map<String, dynamic> data,
  ) {
    final payload = Map<String, dynamic>.from(data['payload'] ?? {});
    final epcHex = (data['epcHex'] ?? '').toString();
    final category = (data['category'] ?? '').toString();
    final paymentType = _paymentType(data);
    final seller = _seller(data);
    final date = _date(data);
    final total = _total(data);
    final cash = _cash(data);
    final visa = _visa(data);

    final catColor = _catColor(category);
    final catLabel = _catLabel(category);

    final dateStr =
        date.year > 2000 ? DateFormat("yyyy/MM/dd  HH:mm").format(date) : "—";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══ الرأس ═══
            Row(
              children: [
                _badge(catLabel, catColor),
                const SizedBox(width: 6),
                if (paymentType.isNotEmpty)
                  _badge(_payLabel(paymentType), _payColor(paymentType)),
                const Spacer(),
                Icon(Icons.calendar_today,
                    size: 11, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ═══ البيانات + الصور ═══
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _row(Icons.qr_code_2, "الشريحة",
                          epcHex.isEmpty ? "—" : epcHex),
                      if (payload['kind'] != null)
                        _row(Icons.category, "النوع", "${payload['kind']}"),
                      if (payload['type'] != null)
                        _row(Icons.diamond, "النوع", "${payload['type']}"),
                      if (category == "bullion")
                        _row(Icons.workspace_premium, "النوع", "سبائك"),
                      if (payload['carat'] != null)
                        _row(Icons.grade, "العيار", "${payload['carat']}"),
                      if (payload['weight'] != null)
                        _row(Icons.scale, "الوزن", "${payload['weight']} جم"),
                      if (payload['wage'] != null)
                        _row(Icons.attach_money, "الأجر", "${payload['wage']}"),
                      if (payload['cost'] != null)
                        _row(Icons.payments, "التكلفة", "${payload['cost']}"),
                      _row(
                        Icons.person,
                        "البائع",
                        seller.isEmpty ? "—" : seller,
                        valueColor: const Color(0xFFB8860B),
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: _buildImagesThumb(epcHex),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 10),

            // ═══ المبالغ ═══
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _moneyCol("كاش", cash, Colors.green),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: _moneyCol("شبكة", visa, Colors.blue),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: _moneyCol(
                      "الإجمالي",
                      total,
                      const Color(0xFFB8860B),
                      bold: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ═══ الأزرار ═══
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade600),
          const SizedBox(width: 5),
          Text(
            "$label: ",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: valueColor ?? Colors.black87,
                fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyCol(String label, double amount, Color color,
      {bool bold = false}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          amount.toStringAsFixed(2),
          style: TextStyle(
            fontSize: bold ? 14 : 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 صور مصغرة
  // ═════════════════════════════════════════════════════════════
  Widget _buildImagesThumb(String epcHex) {
    return SizedBox(
      height: 120,
      child: FutureBuilder<List<String>>(
        future: _getImages(epcHex),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade400,
                ),
              ),
            );
          }
          final urls = snap.data ?? [];
          if (urls.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_not_supported,
                      size: 26, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text(
                    "لا صور",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.all(2),
              child: GestureDetector(
                onTap: () => _openImage(urls[i]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    urls[i],
                    width: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 26),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 عرض الصور
  // ═════════════════════════════════════════════════════════════
  Future<void> _showImages(String epc) async {
    if (epc.isEmpty) return;
    final urls = await _getImages(epc);

    if (!mounted) return;

    if (urls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا توجد صور لهذه الشريحة")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: double.maxFinite,
            height: 480,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.image, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "صور الشريحة",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    itemCount: urls.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _openImage(urls[index]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            urls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openImage(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.network(url),
            ),
            Positioned(
              top: 30,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 حذف فردي / كلي
  // ═════════════════════════════════════════════════════════════
  Future<void> _confirmDeleteOne(DocumentSnapshot doc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("حذف السجل"),
        content: const Text(
          "هل تريد حذف هذا السجل مع جميع الصور الخاصة به؟",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final data = doc.data() as Map<String, dynamic>;
    await _deleteImages((data['epcHex'] ?? '').toString());
    await doc.reference.delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حذف السجل")),
      );
    }
  }

  Future<void> _deleteImages(String epc) async {
    if (epc.isEmpty) return;
    try {
      final key = epc.toUpperCase();
      final folderRef = FirebaseStorage.instance
          .ref()
          .child("images")
          .child("users")
          .child(uid)
          .child("sales")
          .child(key);

      final result = await folderRef.listAll();
      for (final file in result.items) {
        await file.delete();
      }
      _imageCache.remove(key);
    } catch (_) {}
  }

  Future<void> _confirmDeleteAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("حذف السجل بالكامل"),
        content: const Text(
          "سيتم حذف جميع السجلات وجميع الصور، هل أنت متأكد؟",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("حذف الكل"),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => deletingAll = true);

    try {
      final docs = await historyCol.get();
      for (final doc in docs.docs) {
        final data = doc.data() as Map<String, dynamic>;
        await _deleteImages((data['epcHex'] ?? '').toString());
        await doc.reference.delete();
      }
      _imageCache.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم حذف السجل بالكامل")),
        );
      }
    } finally {
      if (mounted) setState(() => deletingAll = false);
    }
  }

  Future<void> _deleteExpiredItems() async {
    try {
      final limit = DateTime.now().subtract(const Duration(days: 30));
      final oldDocs = await historyCol
          .where("soldAt", isLessThan: Timestamp.fromDate(limit))
          .get();

      for (final doc in oldDocs.docs) {
        final data = doc.data() as Map<String, dynamic>;
        await _deleteImages((data['epcHex'] ?? '').toString());
        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ═════════════════════════════════════════════════════════════
  // 🔵 Helpers للتسميات والألوان
  // ═════════════════════════════════════════════════════════════
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

  String _payLabel(String t) {
    switch (t) {
      case 'cash':
        return 'كاش';
      case 'visa':
        return 'شبكة';
      case 'multi':
        return 'متعدد';
      default:
        return t;
    }
  }

  Color _payColor(String t) {
    switch (t) {
      case 'cash':
        return Colors.green;
      case 'visa':
        return Colors.blue;
      case 'multi':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

// ═════════════════════════════════════════════════════════════
// 🔵 نموذج إجماليات البائع
// ═════════════════════════════════════════════════════════════
class _SellerTotal {
  int count = 0;
  double cash = 0;
  double visa = 0;
  double total = 0;
  double weight = 0;
}
