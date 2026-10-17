// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/firestore_service.dart';

// // // ============================================================
// // // 🔹 صفحة إدارة مكاتب التسكيرات
// // // ============================================================
// // class MintOfficesManagementPage extends StatefulWidget {
// //   const MintOfficesManagementPage({super.key});

// //   @override
// //   State<MintOfficesManagementPage> createState() =>
// //       _MintOfficesManagementPageState();
// // }

// // class _MintOfficesManagementPageState extends State<MintOfficesManagementPage> {
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

// //   void _showAddOfficeDialog() {
// //     showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (_) => const AddEditOfficeDialog());
// //   }

// //   void _showEditOfficeDialog(Map<String, dynamic> office) {
// //     showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (_) => AddEditOfficeDialog(office: office));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 8.0),
// //             child: IconButton(
// //               icon: const Icon(Icons.add, color: Colors.white),
// //               onPressed: _showAddOfficeDialog,
// //               tooltip: _t("إضافة مكتب", "Add Office"),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FS.mintOfficesStream(),
// //         builder: (context, snap) {
// //           if (snap.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.location_city,
// //                       size: 64, color: Colors.grey.shade300),
// //                   const SizedBox(height: 12),
// //                   Text(_t("لا توجد مكاتب", "No offices"),
// //                       style:
// //                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
// //                   const SizedBox(height: 8),
// //                   Text(_t("اضغط على + لإضافة مكتب", "Tap + to add an office"),
// //                       style:
// //                           TextStyle(fontSize: 14, color: Colors.grey.shade400)),
// //                 ],
// //               ),
// //             );
// //           }

// //           final docs = snap.data!.docs;
// //           return ListView.builder(
// //             padding: const EdgeInsets.all(12),
// //             itemCount: docs.length,
// //             itemBuilder: (ctx, index) {
// //               final data = docs[index].data() as Map<String, dynamic>;
// //               final id = docs[index].id;
// //               return _buildOfficeCard(id, data);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildOfficeCard(String id, Map<String, dynamic> data) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //       elevation: 3,
// //       child: ListTile(
// //         contentPadding:
// //             const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //         leading: CircleAvatar(
// //           radius: 25,
// //           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
// //           child: const Icon(Icons.location_city,
// //               color: Color(0xFFD4AF37), size: 28),
// //         ),
// //         title: Text(data['name'] ?? '',
// //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
// //             maxLines: 1,
// //             overflow: TextOverflow.ellipsis),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(height: 4),
// //             if (data['address'] != null &&
// //                 data['address'].toString().isNotEmpty)
// //               Text('📍 ${data['address']}',
// //                   style: const TextStyle(fontSize: 14),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis),
// //             if (data['phone'] != null && data['phone'].toString().isNotEmpty)
// //               Text('📞 ${data['phone']}',
// //                   style: const TextStyle(fontSize: 14),
// //                   maxLines: 1,
// //                   overflow: TextOverflow.ellipsis),
// //           ],
// //         ),
// //         trailing: PopupMenuButton<String>(
// //           onSelected: (value) {
// //             if (value == 'edit') _showEditOfficeDialog(data);
// //             if (value == 'delete') _deleteOffice(id, data['name']);
// //           },
// //           itemBuilder: (context) => [
// //             PopupMenuItem(
// //               value: 'edit',
// //               child: Row(
// //                 children: [
// //                   const Icon(Icons.edit, color: Colors.orange, size: 20),
// //                   const SizedBox(width: 8),
// //                   Text(_t("تعديل", "Edit")),
// //                 ],
// //               ),
// //             ),
// //             PopupMenuItem(
// //               value: 'delete',
// //               child: Row(
// //                 children: [
// //                   const Icon(Icons.delete, color: Colors.red, size: 20),
// //                   const SizedBox(width: 8),
// //                   Text(_t("حذف", "Delete")),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _deleteOffice(String id, String name) async {
// //     final confirm = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
// //         content: Text(_t("حذف المكتب $name؟", "Delete office $name?")),
// //         actions: [
// //           TextButton(
// //               onPressed: () => Navigator.pop(context, false),
// //               child: Text(_t("إلغاء", "Cancel"))),
// //           TextButton(
// //               onPressed: () => Navigator.pop(context, true),
// //               child: Text(_t("حذف", "Delete"),
// //                   style: const TextStyle(color: Colors.red))),
// //         ],
// //       ),
// //     );
// //     if (confirm == true) {
// //       await FS.deleteMintOffice(id);
// //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// //           content: Text("تم حذف المكتب ✅"), backgroundColor: Colors.redAccent));
// //     }
// //   }
// // }

// // // ============================================================
// // // 🔹 حوار إضافة/تعديل مكتب تسكيرات
// // // ============================================================
// // class AddEditOfficeDialog extends StatefulWidget {
// //   final Map<String, dynamic>? office;
// //   const AddEditOfficeDialog({super.key, this.office});

// //   @override
// //   State<AddEditOfficeDialog> createState() => _AddEditOfficeDialogState();
// // }

// // class _AddEditOfficeDialogState extends State<AddEditOfficeDialog> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _nameCtrl = TextEditingController();
// //   final _addressCtrl = TextEditingController();
// //   final _phoneCtrl = TextEditingController();

// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
// //   bool _isEditing = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //     if (widget.office != null) {
// //       _isEditing = true;
// //       _nameCtrl.text = widget.office!['name'] ?? '';
// //       _addressCtrl.text = widget.office!['address'] ?? '';
// //       _phoneCtrl.text = widget.office!['phone'] ?? '';
// //     }
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       title: Row(
// //         children: [
// //           Icon(_isEditing ? Icons.edit : Icons.add_business,
// //               color: const Color(0xFFD4AF37)),
// //           const SizedBox(width: 10),
// //           Text(_isEditing
// //               ? _t("تعديل مكتب", "Edit Office")
// //               : _t("إضافة مكتب", "Add Office")),
// //         ],
// //       ),
// //       content: SizedBox(
// //         width: MediaQuery.of(context).size.width * 0.85,
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               TextFormField(
// //                 controller: _nameCtrl,
// //                 decoration: InputDecoration(
// //                   labelText: _t("اسم المكتب", "Office Name"),
// //                   prefixIcon:
// //                       const Icon(Icons.business, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                 ),
// //                 validator: (v) =>
// //                     v == null || v.isEmpty ? _t("مطلوب", "Required") : null,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _addressCtrl,
// //                 decoration: InputDecoration(
// //                   labelText: _t("العنوان", "Address"),
// //                   prefixIcon:
// //                       const Icon(Icons.location_on, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _phoneCtrl,
// //                 decoration: InputDecoration(
// //                   labelText: _t("رقم الهاتف", "Phone"),
// //                   prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(12)),
// //                 ),
// //                 keyboardType: TextInputType.phone,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       actions: [
// //         TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text(_t("إلغاء", "Cancel"))),
// //         ElevatedButton(
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: const Color(0xFFD4AF37),
// //             shape:
// //                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //           ),
// //           onPressed: _submit,
// //           child: Text(_isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
// //               style: const TextStyle(
// //                   color: Colors.white, fontWeight: FontWeight.bold)),
// //         ),
// //       ],
// //     );
// //   }

// //   void _submit() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     try {
// //       if (_isEditing) {
// //         await FS.updateMintOffice(widget.office!['id'], {
// //           'name': _nameCtrl.text.trim(),
// //           'address': _addressCtrl.text.trim(),
// //           'phone': _phoneCtrl.text.trim(),
// //         });
// //       } else {
// //         await FS.addMintOffice(
// //             name: _nameCtrl.text.trim(),
// //             address: _addressCtrl.text.trim(),
// //             phone: _phoneCtrl.text.trim());
// //       }
// //       if (context.mounted) Navigator.pop(context);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
// //     }
// //   }
// // }

// // // ============================================================
// // // 🔹 صفحة التسكيرات الرئيسية (التصميم المحسن والمنظم)
// // // ============================================================
// // class MintingPage extends StatefulWidget {
// //   const MintingPage({super.key});

// //   @override
// //   State<MintingPage> createState() => _MintingPageState();
// // }

// // class _MintingPageState extends State<MintingPage> {
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

// //   void _showAddMintingDialog() {
// //     showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (_) => const AddMintingDialog());
// //   }

// //   void _openOfficesManagement() {
// //     Navigator.push(context,
// //         MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()));
// //   }

// //   void _openClosedMintings() {
// //     Navigator.push(
// //         context, MaterialPageRoute(builder: (_) => const ClosedMintingsPage()));
// //   }

// //   void _showMintingDetails(String id, Map<String, dynamic> data) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (_) => MintingDetailsSheet(id: id, data: data),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("التسكيرات", "Minting")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         actions: [
// //           // إضافة مسافات للأيقونات في الأعلى
// //           Padding(
// //             padding: const EdgeInsets.only(left: 10.0),
// //             child: IconButton(
// //               icon: const Icon(Icons.history, color: Colors.white, size: 28),
// //               onPressed: _openClosedMintings,
// //               tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
// //             child: IconButton(
// //               icon: const Icon(Icons.business, color: Colors.white, size: 28),
// //               onPressed: _openOfficesManagement,
// //               tooltip: _t("إدارة المكاتب", "Manage Offices"),
// //             ),
// //           ),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _showAddMintingDialog,
// //         backgroundColor: const Color(0xFFD4AF37),
// //         child: const Icon(Icons.add, color: Colors.white),
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FS.mintingsStream(),
// //         builder: (context, snap) {
// //           if (snap.connectionState == ConnectionState.waiting)
// //             return const Center(child: CircularProgressIndicator());
// //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.account_balance,
// //                       size: 64, color: Colors.grey.shade300),
// //                   const SizedBox(height: 12),
// //                   Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
// //                       style:
// //                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                       _t("اضغط على + لإضافة تسكيرة جديدة",
// //                           "Tap + to add a new minting"),
// //                       style:
// //                           TextStyle(fontSize: 14, color: Colors.grey.shade400)),
// //                 ],
// //               ),
// //             );
// //           }

// //           // الفلترة داخل الواجهة
// //           final allDocs = snap.data!.docs;
// //           final openDocs = allDocs.where((doc) {
// //             final data = doc.data() as Map<String, dynamic>;
// //             final status = data['status'] ?? 'open';
// //             return status == 'open';
// //           }).toList();

// //           if (openDocs.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.account_balance,
// //                       size: 64, color: Colors.grey.shade300),
// //                   const SizedBox(height: 12),
// //                   Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
// //                       style:
// //                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
// //                 ],
// //               ),
// //             );
// //           }

// //           return ListView.builder(
// //             padding: const EdgeInsets.all(16),
// //             itemCount: openDocs.length,
// //             itemBuilder: (ctx, index) {
// //               final data = openDocs[index].data() as Map<String, dynamic>;
// //               final id = openDocs[index].id;
// //               return _buildMintingCard(id, data, isClosed: false);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildMintingCard(String id, Map<String, dynamic> data,
// //       {required bool isClosed}) {
// //     final supplierName = data['supplierName'] ?? '';
// //     final officeName = data['officeName'] ?? '';
// //     final weight = (data['weight'] ?? 0).toDouble();
// //     final carat = data['carat'] ?? '';
// //     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
// //     final manufacturing = (data['manufacturing'] ?? 0).toDouble();
// //     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

// //     Color statusColor = isClosed ? Colors.green : Colors.orange;

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       elevation: 4,
// //       color: Colors.white,
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(20),
// //         onTap: () => _showMintingDetails(id, data),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // رأس البطاقة
// //               Row(
// //                 children: [
// //                   CircleAvatar(
// //                     radius: 25,
// //                     backgroundColor: statusColor.withOpacity(0.15),
// //                     child: Icon(isClosed ? Icons.lock_outline : Icons.lock_open,
// //                         color: statusColor, size: 28),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(supplierName,
// //                             style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 20,
// //                                 color: Colors.black87),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis),
// //                         const SizedBox(height: 4),
// //                         Text(
// //                             ' $officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
// //                             style: TextStyle(
// //                                 fontSize: 14, color: Colors.grey.shade600),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis),
// //                       ],
// //                     ),
// //                   ),
// //                   Container(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: statusColor.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     child: Text(
// //                         isClosed
// //                             ? _t("مقفولة", "Closed")
// //                             : _t("مفتوحة", "Open"),
// //                         style: TextStyle(
// //                             color: statusColor,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 14)),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),

// //               // 🛠️ تصميم المعلومات بشكل منظم ومتباعد (بدون تلاصق)
// //               // Container(
// //               //   padding: const EdgeInsets.all(16),
// //               //   decoration: BoxDecoration(
// //               //     color: Colors.grey.shade50,
// //               //     borderRadius: BorderRadius.circular(16),
// //               //     border: Border.all(color: Colors.grey.shade200),
// //               //   ),
// //               //   child: Column(
// //               //     children: [
// //               //       Row(
// //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               //         children: [
// //               //           _detailItem(Icons.scale, _t("الوزن", "Weight"),
// //               //               '${weight.toStringAsFixed(2)} جم'),
// //               //           _detailItem(Icons.diamond_outlined,
// //               //               _t("العيار", "Carat"), carat),
// //               //         ],
// //               //       ),
// //               //       const SizedBox(height: 16),
// //               //       Row(
// //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               //         children: [
// //               //           _detailItem(Icons.money, _t("ثمن الخام", "Raw Price"),
// //               //               '${goldPrice.toStringAsFixed(2)} ريال'),
// //               //           _detailItem(Icons.handyman, _t("المصنعية", "Manuf."),
// //               //               '${manufacturing.toStringAsFixed(2)} ريال'),
// //               //         ],
// //               //       ),
// //               //       const SizedBox(height: 16),
// //               //       Align(
// //               //         alignment: Alignment.centerRight,
// //               //         child: _detailItem(Icons.payment, _t("الدفع", "Payment"),
// //               //             data['paymentMethod'] ?? ''),
// //               //       ),
// //               //     ],
// //               //   ),
// //               // ),

// //               const SizedBox(height: 16),

// //               if (!isClosed)
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton.icon(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.red.shade400,
// //                       shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12)),
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                     ),
// //                     onPressed: () async {
// //                       await FS.closeMinting(id,
// //                           sentWeight: weight,
// //                           returnedWeight: weight,
// //                           finalWage: manufacturing);
// //                       if (context.mounted)
// //                         Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                                 builder: (_) => const ClosedMintingsPage()));
// //                     },
// //                     icon: const Icon(Icons.close, color: Colors.white),
// //                     label: Text(_t("إغلاق التسكيرة", "Close Minting"),
// //                         style:
// //                             const TextStyle(color: Colors.white, fontSize: 16)),
// //                   ),
// //                 )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // دالة مساعدة لبناء عنصر التفاصيل بشكل أنيق
// //   Widget _detailItem(IconData icon, String title, String value) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon, size: 24, color: const Color(0xFFD4AF37)),
// //         const SizedBox(width: 8),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(title,
// //                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// //             const SizedBox(height: 2),
// //             Text(value,
// //                 style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                     color: Colors.black87)),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ============================================================
// // // 🔹 صفحة التسكيرات المغلقة (بنفس التصميم المنظم)
// // // ============================================================
// // class ClosedMintingsPage extends StatefulWidget {
// //   const ClosedMintingsPage({super.key});

// //   @override
// //   State<ClosedMintingsPage> createState() => _ClosedMintingsPageState();
// // }

// // class _ClosedMintingsPageState extends State<ClosedMintingsPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("التسكيرات المغلقة"),
// //         backgroundColor: Colors.grey.shade700,
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FS.mintingsStream(),
// //         builder: (context, snap) {
// //           if (snap.connectionState == ConnectionState.waiting)
// //             return const Center(child: CircularProgressIndicator());
// //           if (!snap.hasData || snap.data!.docs.isEmpty)
// //             return const Center(child: Text("لا توجد تسكيرات مغلقة"));

// //           final allDocs = snap.data!.docs;
// //           final closedDocs = allDocs.where((doc) {
// //             final data = doc.data() as Map<String, dynamic>;
// //             return (data['status'] ?? 'open') == 'closed';
// //           }).toList();

// //           if (closedDocs.isEmpty)
// //             return const Center(child: Text("لا توجد تسكيرات مغلقة"));

// //           return ListView.builder(
// //             padding: const EdgeInsets.all(12),
// //             itemCount: closedDocs.length,
// //             itemBuilder: (context, index) {
// //               final data = closedDocs[index].data() as Map<String, dynamic>;
// //               final id = closedDocs[index].id;
// //               return ClosedMintingsCard(id: id, data: data);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // // بطاقة مغلقة بنفس تصميم البطاقة المفتوحة (بدون زر إغلاق)
// // class ClosedMintingsCard extends StatelessWidget {
// //   final String id;
// //   final Map<String, dynamic> data;

// //   const ClosedMintingsCard({super.key, required this.id, required this.data});

// //   @override
// //   Widget build(BuildContext context) {
// //     final supplierName = data['supplierName'] ?? '';
// //     final officeName = data['officeName'] ?? '';
// //     final weight = (data['weight'] ?? 0).toDouble();
// //     final carat = data['carat'] ?? '';
// //     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
// //     final manufacturing = (data['manufacturing'] ?? 0).toDouble();
// //     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       elevation: 4,
// //       color: Colors.grey.shade50,
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(20),
// //         onTap: () {
// //           showModalBottomSheet(
// //             context: context,
// //             isScrollControlled: true,
// //             backgroundColor: Colors.transparent,
// //             builder: (_) => MintingDetailsSheet(id: id, data: data),
// //           );
// //         },
// //         child: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   const CircleAvatar(
// //                     radius: 25,
// //                     backgroundColor: Colors.green,
// //                     child: Icon(Icons.lock, color: Colors.white, size: 28),
// //                   ),
// //                   const SizedBox(width: 16),
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(supplierName,
// //                             style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 20,
// //                                 color: Colors.black87),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis),
// //                         const SizedBox(height: 4),
// //                         Text(
// //                             ' $officeName •  ${DateFormat("dd/MM/yyyy").format(date)}',
// //                             style: TextStyle(
// //                                 fontSize: 14, color: Colors.grey.shade600),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis),
// //                       ],
// //                     ),
// //                   ),
// //                   Container(
// //                     padding:
// //                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: Colors.green.withOpacity(0.1),
// //                       borderRadius: BorderRadius.circular(16),
// //                     ),
// //                     child: const Text("مقفولة",
// //                         style: TextStyle(
// //                             color: Colors.green,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 14)),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 20),
// //               // نفس التصميم المنظم
// //               // Container(
// //               //   padding: const EdgeInsets.all(16),
// //               //   decoration: BoxDecoration(
// //               //     color: Colors.white,
// //               //     borderRadius: BorderRadius.circular(16),
// //               //     border: Border.all(color: Colors.grey.shade200),
// //               //   ),
// //               //   child: Column(
// //               //     children: [
// //               //       Row(
// //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               //         children: [
// //               //           _detailItem(Icons.scale, "الوزن",
// //               //               '${weight.toStringAsFixed(2)} جم'),
// //               //           _detailItem(Icons.diamond_outlined, "العيار", carat),
// //               //         ],
// //               //       ),
// //               //       const SizedBox(height: 16),
// //               //       Row(
// //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               //         children: [
// //               //           _detailItem(Icons.money, "ثمن الخام",
// //               //               '${goldPrice.toStringAsFixed(2)} ريال'),
// //               //           _detailItem(Icons.handyman, "المصنعية",
// //               //               '${manufacturing.toStringAsFixed(2)} ريال'),
// //               //         ],
// //               //       ),
// //               //       const SizedBox(height: 16),
// //               //       Align(
// //               //         alignment: Alignment.centerRight,
// //               //         child: _detailItem(
// //               //             Icons.payment, "الدفع", data['paymentMethod'] ?? ''),
// //               //       ),
// //               //     ],
// //               //   ),
// //               // ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _detailItem(IconData icon, String title, String value) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon, size: 24, color: Colors.grey),
// //         const SizedBox(width: 8),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(title,
// //                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// //             const SizedBox(height: 2),
// //             Text(value,
// //                 style: const TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 16,
// //                     color: Colors.black87)),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// // }

// // // ============================================================
// // // 🔹 حوار إضافة تسكيرة جديدة (بالريال)
// // // ============================================================
// // class AddMintingDialog extends StatefulWidget {
// //   const AddMintingDialog({super.key});

// //   @override
// //   State<AddMintingDialog> createState() => _AddMintingDialogState();
// // }

// // class _AddMintingDialogState extends State<AddMintingDialog> {
// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   final _formKey = GlobalKey<FormState>();
// //   String? _supplierId;
// //   String? _supplierName;
// //   String? _officeId;
// //   String? _officeName;
// //   String _carat = '21';
// //   final _weightCtrl = TextEditingController();
// //   final _goldPriceCtrl = TextEditingController();
// //   final _manufacturingCtrl = TextEditingController();
// //   String _paymentMethod = 'cash';

// //   List<Map<String, dynamic>> _offices = [];
// //   bool _isLoading = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLanguage();
// //     _loadOffices();
// //   }

// //   Future<void> _loadLanguage() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _lang = prefs.getString('languageCode') ?? 'ar';
// //     });
// //   }

// //   Future<void> _loadOffices() async {
// //     setState(() => _isLoading = true);
// //     try {
// //       final list = await FS.getMintOffices();
// //       setState(() {
// //         _offices = list;
// //         if (_offices.isNotEmpty) {
// //           _officeId = _offices.first['id'];
// //           _officeName = _offices.first['name'];
// //         }
// //       });
// //     } catch (e) {
// //       print('Error loading offices: $e');
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       title: Row(
// //         children: [
// //           const Icon(Icons.account_balance, color: Color(0xFFD4AF37)),
// //           const SizedBox(width: 10),
// //           Text(_t("تسكيرة جديدة", "New Minting")),
// //         ],
// //       ),
// //       content: SizedBox(
// //         width: MediaQuery.of(context).size.width * 0.9,
// //         child: _isLoading
// //             ? const Center(child: CircularProgressIndicator())
// //             : Form(
// //                 key: _formKey,
// //                 child: SingleChildScrollView(
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       FutureBuilder(
// //                         future: FS.getSuppliers(),
// //                         builder: (context, snap) {
// //                           if (!snap.hasData)
// //                             return const CircularProgressIndicator();
// //                           final suppliers = snap.data!;
// //                           return DropdownButtonFormField<String>(
// //                             decoration: InputDecoration(
// //                               labelText: _t("المورد (الذي سلم الذهب)",
// //                                   "Supplier (who gave gold)"),
// //                               prefixIcon: const Icon(Icons.business,
// //                                   color: Color(0xFFD4AF37)),
// //                               border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(12)),
// //                             ),
// //                             value: _supplierId,
// //                             items: suppliers
// //                                 .map((s) => DropdownMenuItem<String>(
// //                                     value: s['id'],
// //                                     child: Text(s['name'],
// //                                         maxLines: 1,
// //                                         overflow: TextOverflow.ellipsis)))
// //                                 .toList(),
// //                             onChanged: (v) {
// //                               setState(() {
// //                                 _supplierId = v;
// //                                 _supplierName = suppliers
// //                                     .firstWhere((s) => s['id'] == v)['name'];
// //                               });
// //                             },
// //                             validator: (v) => v == null
// //                                 ? _t("اختر مورد", "Select supplier")
// //                                 : null,
// //                           );
// //                         },
// //                       ),
// //                       const SizedBox(height: 12),
// //                       DropdownButtonFormField<String>(
// //                         decoration: InputDecoration(
// //                           labelText: _t("مكتب التسكيرات (بائع الخام)",
// //                               "Mint Office (raw gold seller)"),
// //                           prefixIcon: const Icon(Icons.location_city,
// //                               color: Color(0xFFD4AF37)),
// //                           border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12)),
// //                         ),
// //                         value: _officeId,
// //                         items: _offices
// //                             .map((o) => DropdownMenuItem<String>(
// //                                 value: o['id'],
// //                                 child: Text(o['name'],
// //                                     maxLines: 1,
// //                                     overflow: TextOverflow.ellipsis)))
// //                             .toList(),
// //                         onChanged: (v) {
// //                           setState(() {
// //                             _officeId = v;
// //                             _officeName = _offices
// //                                 .firstWhere((o) => o['id'] == v)['name'];
// //                           });
// //                         },
// //                         validator: (v) =>
// //                             v == null ? _t("اختر مكتب", "Select office") : null,
// //                       ),
// //                       const SizedBox(height: 12),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                               flex: 2,
// //                               child: DropdownButtonFormField<String>(
// //                                 decoration: InputDecoration(
// //                                     labelText: _t("العيار", "Carat"),
// //                                     border: OutlineInputBorder(
// //                                         borderRadius:
// //                                             BorderRadius.circular(12))),
// //                                 value: _carat,
// //                                 items: ['18', '21', '22']
// //                                     .map((c) => DropdownMenuItem<String>(
// //                                         value: c, child: Text(c)))
// //                                     .toList(),
// //                                 onChanged: (v) => setState(() => _carat = v!),
// //                               )),
// //                           const SizedBox(width: 12),
// //                           Expanded(
// //                               flex: 3,
// //                               child: TextFormField(
// //                                 controller: _weightCtrl,
// //                                 decoration: InputDecoration(
// //                                     labelText: _t("الوزن (جم) المطلوب شراؤه",
// //                                         "Weight (g)"),
// //                                     border: OutlineInputBorder(
// //                                         borderRadius:
// //                                             BorderRadius.circular(12)),
// //                                     suffixText: _t("جم", "g")),
// //                                 keyboardType: TextInputType.number,
// //                                 validator: (v) {
// //                                   if (v == null || v.isEmpty)
// //                                     return _t("مطلوب", "Required");
// //                                   if (double.tryParse(v) == null)
// //                                     return _t("رقم غير صحيح", "Invalid number");
// //                                   return null;
// //                                 },
// //                               )),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 12),
// //                       TextFormField(
// //                         controller: _goldPriceCtrl,
// //                         decoration: InputDecoration(
// //                             labelText: _t("ثمن الذهب الخام (ريال)",
// //                                 "Raw gold price (SAR)"),
// //                             prefixIcon: const Icon(Icons.money,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                             suffixText: _t("ريال", "SAR")),
// //                         keyboardType: TextInputType.number,
// //                         validator: (v) {
// //                           if (v == null || v.isEmpty)
// //                             return _t("مطلوب", "Required");
// //                           if (double.tryParse(v) == null)
// //                             return _t("رقم غير صحيح", "Invalid number");
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 12),
// //                       TextFormField(
// //                         controller: _manufacturingCtrl,
// //                         decoration: InputDecoration(
// //                             labelText:
// //                                 _t("المصنعية (ريال)", "Manufacturing (SAR)"),
// //                             prefixIcon: const Icon(Icons.handyman,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(12)),
// //                             suffixText: _t("ريال", "SAR")),
// //                         keyboardType: TextInputType.number,
// //                         validator: (v) {
// //                           if (v == null || v.isEmpty)
// //                             return _t("مطلوب", "Required");
// //                           if (double.tryParse(v) == null)
// //                             return _t("رقم غير صحيح", "Invalid number");
// //                           return null;
// //                         },
// //                       ),
// //                       const SizedBox(height: 6),
// //                       DropdownButtonFormField<String>(
// //                         decoration: InputDecoration(
// //                             labelText:
// //                                 _t("طريقة الدفع للمكتب", "Payment method"),
// //                             prefixIcon: const Icon(Icons.payment,
// //                                 color: Color(0xFFD4AF37)),
// //                             border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(12))),
// //                         value: _paymentMethod,
// //                         items: const [
// //                           DropdownMenuItem<String>(
// //                               value: 'cash', child: Text('كاش')),
// //                           DropdownMenuItem<String>(
// //                               value: 'network', child: Text('شبكة')),
// //                         ],
// //                         onChanged: (v) => setState(() => _paymentMethod = v!),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //       ),
// //       actions: [
// //         TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: Text(_t("إلغاء", "Cancel"))),
// //         ElevatedButton(
// //           style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFFD4AF37),
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12))),
// //           onPressed: _submit,
// //           child: Text(_t("حفظ", "Save"),
// //               style: const TextStyle(
// //                   color: Colors.white, fontWeight: FontWeight.bold)),
// //         ),
// //       ],
// //     );
// //   }

// //   void _submit() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     if (_supplierId == null || _officeId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //           content: Text(
// //               _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
// //           backgroundColor: Colors.orange));
// //       return;
// //     }

// //     final weight = double.parse(_weightCtrl.text);
// //     final goldPrice = double.parse(_goldPriceCtrl.text);
// //     final manufacturing = double.parse(_manufacturingCtrl.text);

// //     try {
// //       await FS.addMinting(
// //         supplierId: _supplierId!,
// //         supplierName: _supplierName!,
// //         officeId: _officeId!,
// //         officeName: _officeName!,
// //         carat: _carat,
// //         weight: weight,
// //         goldPrice: goldPrice,
// //         manufacturing: manufacturing,
// //         paymentMethod: _paymentMethod,
// //         date: DateTime.now(),
// //       );

// //       await FS.deductFromCashBox(
// //           amount: goldPrice,
// //           method: _paymentMethod,
// //           note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName');

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
// //             content: Text("تم إضافة التسكيرة وخصم ثمن الخام ✅"),
// //             backgroundColor: Colors.green));
// //         Navigator.pop(context);
// //       }
// //     } catch (e) {
// //       if (mounted)
// //         ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
// //     }
// //   }
// // }

// // // ============================================================
// // // 🔹 ورقة تفاصيل التسكيرة (تحسين هائل: تحويلها لصفوف منظمة)
// // // ============================================================
// // class MintingDetailsSheet extends StatefulWidget {
// //   final String id;
// //   final Map<String, dynamic> data;

// //   const MintingDetailsSheet({super.key, required this.id, required this.data});

// //   @override
// //   State<MintingDetailsSheet> createState() => _MintingDetailsSheetState();
// // }

// // class _MintingDetailsSheetState extends State<MintingDetailsSheet> {
// //   String _lang = 'ar';
// //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// //   @override
// //   Widget build(BuildContext context) {
// //     return DraggableScrollableSheet(
// //       initialChildSize: 0.8,
// //       minChildSize: 0.5,
// //       maxChildSize: 0.95,
// //       builder: (_, scrollController) {
// //         return Container(
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
// //           ),
// //           child: Column(
// //             children: [
// //               Container(
// //                   margin: const EdgeInsets.only(top: 12),
// //                   width: 40,
// //                   height: 4,
// //                   decoration: BoxDecoration(
// //                       color: Colors.grey.shade300,
// //                       borderRadius: BorderRadius.circular(2))),
// //               const SizedBox(height: 12),
// //               Expanded(
// //                 child: ListView(
// //                   controller: scrollController,
// //                   padding: const EdgeInsets.all(24),
// //                   children: [
// //                     // رأس التفاصيل
// //                     Row(
// //                       children: [
// //                         CircleAvatar(
// //                           radius: 30,
// //                           backgroundColor:
// //                               const Color(0xFFD4AF37).withOpacity(0.15),
// //                           child: const Icon(Icons.account_balance,
// //                               color: Color(0xFFD4AF37), size: 32),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text('${widget.data['supplierName'] ?? ""}',
// //                                   style: const TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       fontSize: 24),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis),
// //                               const SizedBox(height: 4),
// //                               Text('${widget.data['officeName'] ?? ""}',
// //                                   style: TextStyle(
// //                                       fontSize: 16,
// //                                       color: Colors.grey.shade600),
// //                                   maxLines: 1,
// //                                   overflow: TextOverflow.ellipsis),
// //                               Text(
// //                                   '${DateFormat("dd/MM/yyyy HH:mm").format((widget.data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
// //                                   style: TextStyle(
// //                                       fontSize: 14,
// //                                       color: Colors.grey.shade500)),
// //                             ],
// //                           ),
// //                         ),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 16, vertical: 8),
// //                           decoration: BoxDecoration(
// //                             color: (widget.data['status'] == 'closed')
// //                                 ? Colors.green.withOpacity(0.1)
// //                                 : Colors.orange.withOpacity(0.1),
// //                             borderRadius: BorderRadius.circular(16),
// //                           ),
// //                           child: Text(
// //                             (widget.data['status'] == 'closed')
// //                                 ? _t("مقفولة", "Closed")
// //                                 : _t("مفتوحة", "Open"),
// //                             style: TextStyle(
// //                                 color: (widget.data['status'] == 'closed')
// //                                     ? Colors.green
// //                                     : Colors.orange,
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 16),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const Divider(height: 40),

// //                     // 🛠️ قائمة التفاصيل الأنيقة (بدون تراص)
// //                     Text(_t("بيانات التسكيرة", "Minting Details"),
// //                         style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black87)),
// //                     const SizedBox(height: 16),
// //                     _buildDetailRow(Icons.scale, _t("الوزن", "Weight"),
// //                         '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
// //                     _buildDetailRow(Icons.diamond_outlined,
// //                         _t("العيار", "Carat"), widget.data['carat'] ?? ''),
// //                     _buildDetailRow(Icons.money, _t("ثمن الخام", "Raw Price"),
// //                         '${widget.data['goldPrice'] ?? 0} ${_t('ريال', 'SAR')}'),
// //                     _buildDetailRow(
// //                         Icons.handyman,
// //                         _t("المصنعية", "Manufacturing"),
// //                         '${widget.data['manufacturing'] ?? 0} ${_t('ريال', 'SAR')}'),
// //                     _buildDetailRow(
// //                         Icons.payment,
// //                         _t("طريقة الدفع", "Payment Method"),
// //                         widget.data['paymentMethod'] ?? ''),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // 🛠️ دالة لبناء صف أنيق في التفاصيل
// //   Widget _buildDetailRow(IconData icon, String title, String value) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(icon, size: 26, color: const Color(0xFFD4AF37)),
// //           const SizedBox(width: 16),
// //           Expanded(
// //             child: Text(title,
// //                 style: const TextStyle(fontSize: 16, color: Colors.black87)),
// //           ),
// //           Text(value,
// //               style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.black)),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/firestore_service.dart';

// // ============================================================
// // 🔹 صفحة إدارة مكاتب التسكيرات
// // ============================================================
// class MintOfficesManagementPage extends StatefulWidget {
//   const MintOfficesManagementPage({super.key});

//   @override
//   State<MintOfficesManagementPage> createState() =>
//       _MintOfficesManagementPageState();
// }

// class _MintOfficesManagementPageState extends State<MintOfficesManagementPage> {
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

//   void _showAddOfficeDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const AddEditOfficeDialog());
//   }

//   void _showEditOfficeDialog(Map<String, dynamic> office) {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => AddEditOfficeDialog(office: office));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: IconButton(
//               icon: const Icon(Icons.add, color: Colors.white),
//               onPressed: _showAddOfficeDialog,
//               tooltip: _t("إضافة مكتب", "Add Office"),
//             ),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FS.mintOfficesStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snap.hasData || snap.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.location_city,
//                       size: 64, color: Colors.grey.shade300),
//                   const SizedBox(height: 12),
//                   Text(_t("لا توجد مكاتب", "No offices"),
//                       style:
//                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                   const SizedBox(height: 8),
//                   Text(_t("اضغط على + لإضافة مكتب", "Tap + to add an office"),
//                       style:
//                           TextStyle(fontSize: 14, color: Colors.grey.shade400)),
//                 ],
//               ),
//             );
//           }

//           final docs = snap.data!.docs;
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: docs.length,
//             itemBuilder: (ctx, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//               final id = docs[index].id;
//               return _buildOfficeCard(id, data);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOfficeCard(String id, Map<String, dynamic> data) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       elevation: 3,
//       child: ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
//           child: const Icon(Icons.location_city,
//               color: Color(0xFFD4AF37), size: 28),
//         ),
//         title: Text(data['name'] ?? '',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             if (data['address'] != null &&
//                 data['address'].toString().isNotEmpty)
//               Text('📍 ${data['address']}',
//                   style: const TextStyle(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis),
//             if (data['phone'] != null && data['phone'].toString().isNotEmpty)
//               Text('📞 ${data['phone']}',
//                   style: const TextStyle(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis),
//           ],
//         ),
//         trailing: PopupMenuButton<String>(
//           onSelected: (value) {
//             if (value == 'edit') _showEditOfficeDialog(data);
//             if (value == 'delete') _deleteOffice(id, data['name']);
//           },
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               value: 'edit',
//               child: Row(
//                 children: [
//                   const Icon(Icons.edit, color: Colors.orange, size: 20),
//                   const SizedBox(width: 8),
//                   Text(_t("تعديل", "Edit")),
//                 ],
//               ),
//             ),
//             PopupMenuItem(
//               value: 'delete',
//               child: Row(
//                 children: [
//                   const Icon(Icons.delete, color: Colors.red, size: 20),
//                   const SizedBox(width: 8),
//                   Text(_t("حذف", "Delete")),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _deleteOffice(String id, String name) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
//         content: Text(_t("حذف المكتب $name؟", "Delete office $name?")),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text(_t("إلغاء", "Cancel"))),
//           TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: Text(_t("حذف", "Delete"),
//                   style: const TextStyle(color: Colors.red))),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       await FS.deleteMintOffice(id);
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text("تم حذف المكتب ✅"), backgroundColor: Colors.redAccent));
//     }
//   }
// }

// // ============================================================
// // 🔹 حوار إضافة/تعديل مكتب تسكيرات
// // ============================================================
// class AddEditOfficeDialog extends StatefulWidget {
//   final Map<String, dynamic>? office;
//   const AddEditOfficeDialog({super.key, this.office});

//   @override
//   State<AddEditOfficeDialog> createState() => _AddEditOfficeDialogState();
// }

// class _AddEditOfficeDialogState extends State<AddEditOfficeDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
//   bool _isEditing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     if (widget.office != null) {
//       _isEditing = true;
//       _nameCtrl.text = widget.office!['name'] ?? '';
//       _addressCtrl.text = widget.office!['address'] ?? '';
//       _phoneCtrl.text = widget.office!['phone'] ?? '';
//     }
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Row(
//         children: [
//           Icon(_isEditing ? Icons.edit : Icons.add_business,
//               color: const Color(0xFFD4AF37)),
//           const SizedBox(width: 10),
//           Text(_isEditing
//               ? _t("تعديل مكتب", "Edit Office")
//               : _t("إضافة مكتب", "Add Office")),
//         ],
//       ),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.85,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _nameCtrl,
//                 decoration: InputDecoration(
//                   labelText: _t("اسم المكتب", "Office Name"),
//                   prefixIcon:
//                       const Icon(Icons.business, color: Color(0xFFD4AF37)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 validator: (v) =>
//                     v == null || v.isEmpty ? _t("مطلوب", "Required") : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _addressCtrl,
//                 decoration: InputDecoration(
//                   labelText: _t("العنوان", "Address"),
//                   prefixIcon:
//                       const Icon(Icons.location_on, color: Color(0xFFD4AF37)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _phoneCtrl,
//                 decoration: InputDecoration(
//                   labelText: _t("رقم الهاتف", "Phone"),
//                   prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 keyboardType: TextInputType.phone,
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(_t("إلغاء", "Cancel"))),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFD4AF37),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           onPressed: _submit,
//           child: Text(_isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     try {
//       if (_isEditing) {
//         await FS.updateMintOffice(widget.office!['id'], {
//           'name': _nameCtrl.text.trim(),
//           'address': _addressCtrl.text.trim(),
//           'phone': _phoneCtrl.text.trim(),
//         });
//       } else {
//         await FS.addMintOffice(
//             name: _nameCtrl.text.trim(),
//             address: _addressCtrl.text.trim(),
//             phone: _phoneCtrl.text.trim());
//       }
//       if (context.mounted) Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//     }
//   }
// }

// // ============================================================
// // 🔹 صفحة التسكيرات الرئيسية (التصميم المحسن والمنظم)
// // ============================================================
// class MintingPage extends StatefulWidget {
//   const MintingPage({super.key});

//   @override
//   State<MintingPage> createState() => _MintingPageState();
// }

// class _MintingPageState extends State<MintingPage> {
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

//   void _showAddMintingDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const AddMintingDialog());
//   }

//   void _openOfficesManagement() {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()));
//   }

//   void _openClosedMintings() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (_) => const ClosedMintingsPage()));
//   }

//   // ✅ جديد: فتح صفحة رصيد الذهب والمدفوعات
//   void _openGoldBalance() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (_) => const GoldBalancePage()));
//   }

//   void _showMintingDetails(String id, Map<String, dynamic> data) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => MintingDetailsSheet(id: id, data: data),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("التسكيرات", "Minting")),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           // ✅ جديد: زر شراء الذهب / رصيد الذهب
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: IconButton(
//               icon: const Icon(Icons.savings, color: Colors.white, size: 28),
//               onPressed: _openGoldBalance,
//               tooltip: _t("شراء ذهب / رصيد الذهب", "Buy Gold / Balance"),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: IconButton(
//               icon: const Icon(Icons.history, color: Colors.white, size: 28),
//               onPressed: _openClosedMintings,
//               tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//             child: IconButton(
//               icon: const Icon(Icons.business, color: Colors.white, size: 28),
//               onPressed: _openOfficesManagement,
//               tooltip: _t("إدارة المكاتب", "Manage Offices"),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddMintingDialog,
//         backgroundColor: const Color(0xFFD4AF37),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FS.mintingsStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting)
//             return const Center(child: CircularProgressIndicator());
//           if (!snap.hasData || snap.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.account_balance,
//                       size: 64, color: Colors.grey.shade300),
//                   const SizedBox(height: 12),
//                   Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
//                       style:
//                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                   const SizedBox(height: 8),
//                   Text(
//                       _t("اضغط على + لإضافة تسكيرة جديدة",
//                           "Tap + to add a new minting"),
//                       style:
//                           TextStyle(fontSize: 14, color: Colors.grey.shade400)),
//                 ],
//               ),
//             );
//           }

//           final allDocs = snap.data!.docs;
//           final openDocs = allDocs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final status = data['status'] ?? 'open';
//             return status == 'open';
//           }).toList();

//           if (openDocs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.account_balance,
//                       size: 64, color: Colors.grey.shade300),
//                   const SizedBox(height: 12),
//                   Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
//                       style:
//                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: openDocs.length,
//             itemBuilder: (ctx, index) {
//               final data = openDocs[index].data() as Map<String, dynamic>;
//               final id = openDocs[index].id;
//               return _buildMintingCard(id, data, isClosed: false);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMintingCard(String id, Map<String, dynamic> data,
//       {required bool isClosed}) {
//     final supplierName = data['supplierName'] ?? '';
//     final officeName = data['officeName'] ?? '';
//     final weight = (data['weight'] ?? 0).toDouble();
//     final carat = data['carat'] ?? '';
//     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
//     final manufacturing = (data['manufacturing'] ?? 0).toDouble();
//     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

//     Color statusColor = isClosed ? Colors.green : Colors.orange;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 4,
//       color: Colors.white,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () => _showMintingDetails(id, data),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 25,
//                     backgroundColor: statusColor.withOpacity(0.15),
//                     child: Icon(isClosed ? Icons.lock_outline : Icons.lock_open,
//                         color: statusColor, size: 28),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(supplierName,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Colors.black87),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                         const SizedBox(height: 4),
//                         Text(
//                             ' $officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey.shade600),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(
//                         isClosed
//                             ? _t("مقفولة", "Closed")
//                             : _t("مفتوحة", "Open"),
//                         style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const SizedBox(height: 16),
//               if (!isClosed)
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade400,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () async {
//                       await FS.closeMinting(id,
//                           sentWeight: weight,
//                           returnedWeight: weight,
//                           finalWage: manufacturing);
//                       if (context.mounted)
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const ClosedMintingsPage()));
//                     },
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     label: Text(_t("إغلاق التسكيرة", "Close Minting"),
//                         style:
//                             const TextStyle(color: Colors.white, fontSize: 16)),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _detailItem(IconData icon, String title, String value) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 24, color: const Color(0xFFD4AF37)),
//         const SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//             const SizedBox(height: 2),
//             Text(value,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.black87)),
//           ],
//         ),
//       ],
//     );
//   }
// }

// // ============================================================
// // 🔹 صفحة التسكيرات المغلقة
// // ============================================================
// class ClosedMintingsPage extends StatefulWidget {
//   const ClosedMintingsPage({super.key});

//   @override
//   State<ClosedMintingsPage> createState() => _ClosedMintingsPageState();
// }

// class _ClosedMintingsPageState extends State<ClosedMintingsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("التسكيرات المغلقة"),
//         backgroundColor: Colors.grey.shade700,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FS.mintingsStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting)
//             return const Center(child: CircularProgressIndicator());
//           if (!snap.hasData || snap.data!.docs.isEmpty)
//             return const Center(child: Text("لا توجد تسكيرات مغلقة"));

//           final allDocs = snap.data!.docs;
//           final closedDocs = allDocs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return (data['status'] ?? 'open') == 'closed';
//           }).toList();

//           if (closedDocs.isEmpty)
//             return const Center(child: Text("لا توجد تسكيرات مغلقة"));

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: closedDocs.length,
//             itemBuilder: (context, index) {
//               final data = closedDocs[index].data() as Map<String, dynamic>;
//               final id = closedDocs[index].id;
//               return ClosedMintingsCard(id: id, data: data);
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ClosedMintingsCard extends StatelessWidget {
//   final String id;
//   final Map<String, dynamic> data;

//   const ClosedMintingsCard({super.key, required this.id, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final supplierName = data['supplierName'] ?? '';
//     final officeName = data['officeName'] ?? '';
//     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 4,
//       color: Colors.grey.shade50,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//             builder: (_) => MintingDetailsSheet(id: id, data: data),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 25,
//                     backgroundColor: Colors.green,
//                     child: Icon(Icons.lock, color: Colors.white, size: 28),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(supplierName,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                                 color: Colors.black87),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                         const SizedBox(height: 4),
//                         Text(
//                             ' $officeName •  ${DateFormat("dd/MM/yyyy").format(date)}',
//                             style: TextStyle(
//                                 fontSize: 14, color: Colors.grey.shade600),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: const Text("مقفولة",
//                         style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 حوار إضافة تسكيرة جديدة
// // ============================================================
// class AddMintingDialog extends StatefulWidget {
//   const AddMintingDialog({super.key});

//   @override
//   State<AddMintingDialog> createState() => _AddMintingDialogState();
// }

// class _AddMintingDialogState extends State<AddMintingDialog> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   final _formKey = GlobalKey<FormState>();
//   String? _supplierId;
//   String? _supplierName;
//   String? _officeId;
//   String? _officeName;
//   String _carat = '21';
//   final _weightCtrl = TextEditingController();
//   final _goldPriceCtrl = TextEditingController();
//   final _manufacturingCtrl = TextEditingController();
//   String _paymentMethod = 'cash';

//   List<Map<String, dynamic>> _offices = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _loadOffices();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadOffices() async {
//     setState(() => _isLoading = true);
//     try {
//       final list = await FS.getMintOffices();
//       setState(() {
//         _offices = list;
//         if (_offices.isNotEmpty) {
//           _officeId = _offices.first['id'];
//           _officeName = _offices.first['name'];
//         }
//       });
//     } catch (e) {
//       print('Error loading offices: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Row(
//         children: [
//           const Icon(Icons.account_balance, color: Color(0xFFD4AF37)),
//           const SizedBox(width: 10),
//           Text(_t("تسكيرة جديدة", "New Minting")),
//         ],
//       ),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.9,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       FutureBuilder(
//                         future: FS.getSuppliers(),
//                         builder: (context, snap) {
//                           if (!snap.hasData)
//                             return const CircularProgressIndicator();
//                           final suppliers = snap.data!;
//                           return DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: _t("المورد (الذي سلم الذهب)",
//                                   "Supplier (who gave gold)"),
//                               prefixIcon: const Icon(Icons.business,
//                                   color: Color(0xFFD4AF37)),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                             ),
//                             value: _supplierId,
//                             items: suppliers
//                                 .map((s) => DropdownMenuItem<String>(
//                                     value: s['id'],
//                                     child: Text(s['name'],
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis)))
//                                 .toList(),
//                             onChanged: (v) {
//                               setState(() {
//                                 _supplierId = v;
//                                 _supplierName = suppliers
//                                     .firstWhere((s) => s['id'] == v)['name'];
//                               });
//                             },
//                             validator: (v) => v == null
//                                 ? _t("اختر مورد", "Select supplier")
//                                 : null,
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: _t("مكتب التسكيرات (بائع الخام)",
//                               "Mint Office (raw gold seller)"),
//                           prefixIcon: const Icon(Icons.location_city,
//                               color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         value: _officeId,
//                         items: _offices
//                             .map((o) => DropdownMenuItem<String>(
//                                 value: o['id'],
//                                 child: Text(o['name'],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis)))
//                             .toList(),
//                         onChanged: (v) {
//                           setState(() {
//                             _officeId = v;
//                             _officeName = _offices
//                                 .firstWhere((o) => o['id'] == v)['name'];
//                           });
//                         },
//                         validator: (v) =>
//                             v == null ? _t("اختر مكتب", "Select office") : null,
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                               flex: 2,
//                               child: DropdownButtonFormField<String>(
//                                 decoration: InputDecoration(
//                                     labelText: _t("العيار", "Carat"),
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12))),
//                                 value: _carat,
//                                 items: ['18', '21', '22']
//                                     .map((c) => DropdownMenuItem<String>(
//                                         value: c, child: Text(c)))
//                                     .toList(),
//                                 onChanged: (v) => setState(() => _carat = v!),
//                               )),
//                           const SizedBox(width: 12),
//                           Expanded(
//                               flex: 3,
//                               child: TextFormField(
//                                 controller: _weightCtrl,
//                                 decoration: InputDecoration(
//                                     labelText: _t("الوزن (جم) المطلوب شراؤه",
//                                         "Weight (g)"),
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                     suffixText: _t("جم", "g")),
//                                 keyboardType: TextInputType.number,
//                                 validator: (v) {
//                                   if (v == null || v.isEmpty)
//                                     return _t("مطلوب", "Required");
//                                   if (double.tryParse(v) == null)
//                                     return _t("رقم غير صحيح", "Invalid number");
//                                   return null;
//                                 },
//                               )),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _goldPriceCtrl,
//                         decoration: InputDecoration(
//                             labelText: _t("ثمن الذهب الخام (ريال)",
//                                 "Raw gold price (SAR)"),
//                             prefixIcon: const Icon(Icons.money,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             suffixText: _t("ريال", "SAR")),
//                         keyboardType: TextInputType.number,
//                         validator: (v) {
//                           if (v == null || v.isEmpty)
//                             return _t("مطلوب", "Required");
//                           if (double.tryParse(v) == null)
//                             return _t("رقم غير صحيح", "Invalid number");
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _manufacturingCtrl,
//                         decoration: InputDecoration(
//                             labelText:
//                                 _t("المصنعية (ريال)", "Manufacturing (SAR)"),
//                             prefixIcon: const Icon(Icons.handyman,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             suffixText: _t("ريال", "SAR")),
//                         keyboardType: TextInputType.number,
//                         validator: (v) {
//                           if (v == null || v.isEmpty)
//                             return _t("مطلوب", "Required");
//                           if (double.tryParse(v) == null)
//                             return _t("رقم غير صحيح", "Invalid number");
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 6),
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                             labelText:
//                                 _t("طريقة الدفع للمكتب", "Payment method"),
//                             prefixIcon: const Icon(Icons.payment,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12))),
//                         value: _paymentMethod,
//                         items: const [
//                           DropdownMenuItem<String>(
//                               value: 'cash', child: Text('كاش')),
//                           DropdownMenuItem<String>(
//                               value: 'network', child: Text('شبكة')),
//                         ],
//                         onChanged: (v) => setState(() => _paymentMethod = v!),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(_t("إلغاء", "Cancel"))),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFD4AF37),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12))),
//           onPressed: _submit,
//           child: Text(_t("حفظ", "Save"),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_supplierId == null || _officeId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//               _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
//           backgroundColor: Colors.orange));
//       return;
//     }

//     final weight = double.parse(_weightCtrl.text);
//     final goldPrice = double.parse(_goldPriceCtrl.text);
//     final manufacturing = double.parse(_manufacturingCtrl.text);

//     try {
//       await FS.addMinting(
//         supplierId: _supplierId!,
//         supplierName: _supplierName!,
//         officeId: _officeId!,
//         officeName: _officeName!,
//         carat: _carat,
//         weight: weight,
//         goldPrice: goldPrice,
//         manufacturing: manufacturing,
//         paymentMethod: _paymentMethod,
//         date: DateTime.now(),
//       );

//       await FS.deductFromCashBox(
//           amount: goldPrice,
//           method: _paymentMethod,
//           note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName');

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("تم إضافة التسكيرة وخصم ثمن الخام ✅"),
//             backgroundColor: Colors.green));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted)
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//     }
//   }
// }

// // ============================================================
// // 🔹 ورقة تفاصيل التسكيرة
// // ============================================================
// class MintingDetailsSheet extends StatefulWidget {
//   final String id;
//   final Map<String, dynamic> data;

//   const MintingDetailsSheet({super.key, required this.id, required this.data});

//   @override
//   State<MintingDetailsSheet> createState() => _MintingDetailsSheetState();
// }

// class _MintingDetailsSheetState extends State<MintingDetailsSheet> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.8,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       builder: (_, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                   margin: const EdgeInsets.only(top: 12),
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(2))),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: ListView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(24),
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor:
//                               const Color(0xFFD4AF37).withOpacity(0.15),
//                           child: const Icon(Icons.account_balance,
//                               color: Color(0xFFD4AF37), size: 32),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('${widget.data['supplierName'] ?? ""}',
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 24),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               const SizedBox(height: 4),
//                               Text('${widget.data['officeName'] ?? ""}',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey.shade600),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               Text(
//                                   '${DateFormat("dd/MM/yyyy HH:mm").format((widget.data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey.shade500)),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 8),
//                           decoration: BoxDecoration(
//                             color: (widget.data['status'] == 'closed')
//                                 ? Colors.green.withOpacity(0.1)
//                                 : Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             (widget.data['status'] == 'closed')
//                                 ? _t("مقفولة", "Closed")
//                                 : _t("مفتوحة", "Open"),
//                             style: TextStyle(
//                                 color: (widget.data['status'] == 'closed')
//                                     ? Colors.green
//                                     : Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(height: 40),
//                     Text(_t("بيانات التسكيرة", "Minting Details"),
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87)),
//                     const SizedBox(height: 16),
//                     _buildDetailRow(Icons.scale, _t("الوزن", "Weight"),
//                         '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
//                     _buildDetailRow(Icons.diamond_outlined,
//                         _t("العيار", "Carat"), widget.data['carat'] ?? ''),
//                     _buildDetailRow(Icons.money, _t("ثمن الخام", "Raw Price"),
//                         '${widget.data['goldPrice'] ?? 0} ${_t('ريال', 'SAR')}'),
//                     _buildDetailRow(
//                         Icons.handyman,
//                         _t("المصنعية", "Manufacturing"),
//                         '${widget.data['manufacturing'] ?? 0} ${_t('ريال', 'SAR')}'),
//                     _buildDetailRow(
//                         Icons.payment,
//                         _t("طريقة الدفع", "Payment Method"),
//                         widget.data['paymentMethod'] ?? ''),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String title, String value) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 26, color: const Color(0xFFD4AF37)),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(title,
//                 style: const TextStyle(fontSize: 16, color: Colors.black87)),
//           ),
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black)),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // 🆕 صفحة رصيد الذهب والمدفوعات
// // ============================================================
// class GoldBalancePage extends StatefulWidget {
//   const GoldBalancePage({super.key});

//   @override
//   State<GoldBalancePage> createState() => _GoldBalancePageState();
// }

// class _GoldBalancePageState extends State<GoldBalancePage> {
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

//   void _showBuyGoldDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) => const BuyGoldDialog());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("رصيد الذهب والمدفوعات", "Gold Balance & Payments")),
//         backgroundColor: const Color(0xFFD4AF37),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showBuyGoldDialog,
//         backgroundColor: const Color(0xFFD4AF37),
//         icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
//         label: Text(_t("شراء ذهب", "Buy Gold"),
//             style: const TextStyle(color: Colors.white)),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FS.goldPurchasesStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting)
//             return const Center(child: CircularProgressIndicator());
//           if (!snap.hasData || snap.data!.docs.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.savings, size: 64, color: Colors.grey.shade300),
//                   const SizedBox(height: 12),
//                   Text(_t("لا توجد مشتريات", "No purchases"),
//                       style:
//                           TextStyle(fontSize: 18, color: Colors.grey.shade600)),
//                   const SizedBox(height: 8),
//                   Text(
//                       _t("اضغط على + لشراء ذهب من مكتب",
//                           "Tap + to buy gold from an office"),
//                       style:
//                           TextStyle(fontSize: 14, color: Colors.grey.shade400)),
//                 ],
//               ),
//             );
//           }

//           final docs = snap.data!.docs;
//           double totalWeight = 0;
//           double totalDebt = 0;
//           final Map<String, Map<String, double>> officeBalances = {};

//           for (final doc in docs) {
//             final data = doc.data() as Map<String, dynamic>;
//             final w = (data['weight'] ?? 0).toDouble();
//             final remaining = (data['remaining'] ?? 0).toDouble();
//             final officeName = data['officeName'] ?? '';
//             final carat = data['carat'] ?? '';
//             totalWeight += w;
//             totalDebt += remaining;
//             officeBalances.putIfAbsent(officeName, () => {});
//             officeBalances[officeName]![carat] =
//                 (officeBalances[officeName]![carat] ?? 0) + w;
//           }

//           return ListView(
//             padding: const EdgeInsets.all(12),
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: _summaryCard(
//                       icon: Icons.scale,
//                       title: _t("إجمالي الذهب", "Total Gold"),
//                       value:
//                           '${totalWeight.toStringAsFixed(2)} ${_t("جم", "g")}',
//                       color: const Color(0xFFD4AF37),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: _summaryCard(
//                       icon: Icons.account_balance_wallet,
//                       title: _t("إجمالي المديونية", "Total Debt"),
//                       value:
//                           '${totalDebt.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
//                       color: Colors.red.shade400,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               if (officeBalances.isNotEmpty) ...[
//                 Text(_t("رصيد الذهب لكل مكتب", "Gold Balance per Office"),
//                     style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 ...officeBalances.entries.map((entry) {
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor:
//                             const Color(0xFFD4AF37).withOpacity(0.15),
//                         child: const Icon(Icons.location_city,
//                             color: Color(0xFFD4AF37)),
//                       ),
//                       title: Text(entry.key,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text(entry.value.entries
//                           .map((e) =>
//                               '${e.key}: ${e.value.toStringAsFixed(2)} ${_t("جم", "g")}')
//                           .join('  •  ')),
//                     ),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 16),
//               ],
//               Text(_t("سجل المشتريات", "Purchases History"),
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               ...docs.map((doc) {
//                 final data = doc.data() as Map<String, dynamic>;
//                 return _purchaseCard(doc.id, data);
//               }).toList(),
//               const SizedBox(height: 80),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _summaryCard({
//     required IconData icon,
//     required String title,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 26),
//           const SizedBox(height: 8),
//           Text(title,
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
//           const SizedBox(height: 4),
//           Text(value,
//               style: TextStyle(
//                   fontSize: 17, fontWeight: FontWeight.bold, color: color)),
//         ],
//       ),
//     );
//   }

//   Widget _purchaseCard(String id, Map<String, dynamic> data) {
//     final officeName = data['officeName'] ?? '';
//     final carat = data['carat'] ?? '';
//     final weight = (data['weight'] ?? 0).toDouble();
//     final total = (data['totalPrice'] ?? 0).toDouble();
//     final paid = (data['paid'] ?? 0).toDouble();
//     final remaining = (data['remaining'] ?? 0).toDouble();
//     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
//     final isPaid = remaining <= 0;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 22,
//                   backgroundColor:
//                       (isPaid ? Colors.green : Colors.orange).withOpacity(0.15),
//                   child: Icon(isPaid ? Icons.check_circle : Icons.schedule,
//                       color: isPaid ? Colors.green : Colors.orange),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(officeName,
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis),
//                       const SizedBox(height: 2),
//                       Text(
//                           '${DateFormat("dd/MM/yyyy").format(date)} • $carat • ${weight.toStringAsFixed(2)} ${_t("جم", "g")}',
//                           style: TextStyle(
//                               fontSize: 13, color: Colors.grey.shade600)),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: (isPaid ? Colors.green : Colors.orange)
//                         .withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                       isPaid ? _t("مدفوع", "Paid") : _t("آجل", "Credit"),
//                       style: TextStyle(
//                           color: isPaid ? Colors.green : Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _miniInfo(_t("الإجمالي", "Total"),
//                     '${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
//                 _miniInfo(_t("المدفوع", "Paid"),
//                     '${paid.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
//                 _miniInfo(_t("المتبقي", "Remaining"),
//                     '${remaining.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
//                     color: isPaid ? Colors.green : Colors.red),
//               ],
//             ),
//             if (!isPaid) ...[
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFD4AF37),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                   ),
//                   onPressed: () => _showPayDialog(id, data),
//                   icon:
//                       const Icon(Icons.payment, color: Colors.white, size: 18),
//                   label: Text(_t("تسديد دفعة", "Pay Installment"),
//                       style: const TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _miniInfo(String title, String value, {Color? color}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title,
//             style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: color ?? Colors.black87)),
//       ],
//     );
//   }

//   void _showPayDialog(String id, Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => PayDebtDialog(purchaseId: id, data: data),
//     );
//   }
// }

// // ============================================================
// // 🆕 حوار شراء ذهب من مكتب
// // ============================================================
// class BuyGoldDialog extends StatefulWidget {
//   const BuyGoldDialog({super.key});

//   @override
//   State<BuyGoldDialog> createState() => _BuyGoldDialogState();
// }

// class _BuyGoldDialogState extends State<BuyGoldDialog> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   final _formKey = GlobalKey<FormState>();
//   String? _officeId;
//   String? _officeName;
//   String _carat = '21';
//   final _weightCtrl = TextEditingController();
//   final _pricePerGramCtrl = TextEditingController();
//   final _paidCtrl = TextEditingController();
//   String _paymentMethod = 'cash';
//   String _paymentType = 'full'; // full, partial, credit

//   List<Map<String, dynamic>> _offices = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _loadOffices();
//   }

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   Future<void> _loadOffices() async {
//     setState(() => _isLoading = true);
//     try {
//       final list = await FS.getMintOffices();
//       setState(() {
//         _offices = list;
//         if (_offices.isNotEmpty) {
//           _officeId = _offices.first['id'];
//           _officeName = _offices.first['name'];
//         }
//       });
//     } catch (e) {
//       print('Error loading offices: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   double get _totalPrice {
//     final w = double.tryParse(_weightCtrl.text) ?? 0;
//     final p = double.tryParse(_pricePerGramCtrl.text) ?? 0;
//     return w * p;
//   }

//   double get _paidAmount {
//     if (_paymentType == 'full') return _totalPrice;
//     if (_paymentType == 'credit') return 0;
//     return double.tryParse(_paidCtrl.text) ?? 0;
//   }

//   double get _remaining =>
//       (_totalPrice - _paidAmount).clamp(0, double.infinity);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Row(
//         children: [
//           const Icon(Icons.add_shopping_cart, color: Color(0xFFD4AF37)),
//           const SizedBox(width: 10),
//           Text(_t("شراء ذهب من مكتب", "Buy Gold from Office")),
//         ],
//       ),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.9,
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                           labelText: _t("المكتب", "Office"),
//                           prefixIcon: const Icon(Icons.location_city,
//                               color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
//                         value: _officeId,
//                         items: _offices
//                             .map((o) => DropdownMenuItem<String>(
//                                 value: o['id'],
//                                 child: Text(o['name'],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis)))
//                             .toList(),
//                         onChanged: (v) {
//                           setState(() {
//                             _officeId = v;
//                             _officeName = _offices
//                                 .firstWhere((o) => o['id'] == v)['name'];
//                           });
//                         },
//                         validator: (v) =>
//                             v == null ? _t("اختر مكتب", "Select office") : null,
//                       ),
//                       const SizedBox(height: 12),
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                             labelText: _t("العيار", "Carat"),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12))),
//                         value: _carat,
//                         items: ['18', '21', '22']
//                             .map((c) => DropdownMenuItem<String>(
//                                 value: c, child: Text(c)))
//                             .toList(),
//                         onChanged: (v) => setState(() => _carat = v!),
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _weightCtrl,
//                         decoration: InputDecoration(
//                             labelText: _t("الوزن (جم)", "Weight (g)"),
//                             prefixIcon: const Icon(Icons.scale,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             suffixText: _t("جم", "g")),
//                         keyboardType: TextInputType.number,
//                         onChanged: (_) => setState(() {}),
//                         validator: (v) {
//                           if (v == null || v.isEmpty)
//                             return _t("مطلوب", "Required");
//                           if (double.tryParse(v) == null)
//                             return _t("رقم غير صحيح", "Invalid number");
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _pricePerGramCtrl,
//                         decoration: InputDecoration(
//                             labelText:
//                                 _t("سعر الجرام (ريال)", "Price per gram"),
//                             prefixIcon: const Icon(Icons.attach_money,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                             suffixText: _t("ريال", "SAR")),
//                         keyboardType: TextInputType.number,
//                         onChanged: (_) => setState(() {}),
//                         validator: (v) {
//                           if (v == null || v.isEmpty)
//                             return _t("مطلوب", "Required");
//                           if (double.tryParse(v) == null)
//                             return _t("رقم غير صحيح", "Invalid number");
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFD4AF37).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(_t("الإجمالي", "Total"),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             Text(
//                                 '${_totalPrice.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFFD4AF37),
//                                     fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       DropdownButtonFormField<String>(
//                         decoration: InputDecoration(
//                             labelText: _t("نوع الدفع", "Payment type"),
//                             prefixIcon: const Icon(Icons.payment,
//                                 color: Color(0xFFD4AF37)),
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12))),
//                         value: _paymentType,
//                         items: [
//                           DropdownMenuItem(
//                               value: 'full',
//                               child: Text(_t("دفع كامل", "Full payment"))),
//                           DropdownMenuItem(
//                               value: 'partial',
//                               child: Text(_t("دفع جزئي", "Partial payment"))),
//                           DropdownMenuItem(
//                               value: 'credit',
//                               child: Text(
//                                   _t("آجل (بدون دفع)", "Credit (no payment)"))),
//                         ],
//                         onChanged: (v) => setState(() => _paymentType = v!),
//                       ),
//                       if (_paymentType == 'partial') ...[
//                         const SizedBox(height: 12),
//                         TextFormField(
//                           controller: _paidCtrl,
//                           decoration: InputDecoration(
//                               labelText: _t("المبلغ المدفوع الآن (ريال)",
//                                   "Amount paid now"),
//                               prefixIcon: const Icon(Icons.money,
//                                   color: Color(0xFFD4AF37)),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                               suffixText: _t("ريال", "SAR")),
//                           keyboardType: TextInputType.number,
//                           onChanged: (_) => setState(() {}),
//                           validator: (v) {
//                             if (_paymentType != 'partial') return null;
//                             if (v == null || v.isEmpty)
//                               return _t("مطلوب", "Required");
//                             final amt = double.tryParse(v);
//                             if (amt == null)
//                               return _t("رقم غير صحيح", "Invalid number");
//                             if (amt > _totalPrice)
//                               return _t("أكبر من الإجمالي", "Exceeds total");
//                             return null;
//                           },
//                         ),
//                       ],
//                       const SizedBox(height: 10),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: (_remaining > 0 ? Colors.red : Colors.green)
//                               .withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(_t("المتبقي", "Remaining"),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold)),
//                             Text(
//                                 '${_remaining.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: _remaining > 0
//                                         ? Colors.red
//                                         : Colors.green,
//                                     fontSize: 16)),
//                           ],
//                         ),
//                       ),
//                       if (_paidAmount > 0) ...[
//                         const SizedBox(height: 12),
//                         DropdownButtonFormField<String>(
//                           decoration: InputDecoration(
//                               labelText: _t("طريقة الدفع", "Payment method"),
//                               prefixIcon: const Icon(Icons.credit_card,
//                                   color: Color(0xFFD4AF37)),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12))),
//                           value: _paymentMethod,
//                           items: [
//                             DropdownMenuItem(
//                                 value: 'cash', child: Text(_t("كاش", "Cash"))),
//                             DropdownMenuItem(
//                                 value: 'network',
//                                 child: Text(_t("شبكة", "Network"))),
//                           ],
//                           onChanged: (v) => setState(() => _paymentMethod = v!),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(_t("إلغاء", "Cancel"))),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFD4AF37),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12))),
//           onPressed: _submit,
//           child: Text(_t("حفظ", "Save"),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_officeId == null) return;

//     final weight = double.parse(_weightCtrl.text);
//     final pricePerGram = double.parse(_pricePerGramCtrl.text);
//     final total = weight * pricePerGram;
//     final paid = _paidAmount;
//     final remaining = total - paid;

//     try {
//       await FS.addGoldPurchase(
//         officeId: _officeId!,
//         officeName: _officeName!,
//         carat: _carat,
//         weight: weight,
//         pricePerGram: pricePerGram,
//         totalPrice: total,
//         paid: paid,
//         remaining: remaining,
//         paymentMethod: _paymentMethod,
//         paymentType: _paymentType,
//         date: DateTime.now(),
//       );

//       if (paid > 0) {
//         await FS.deductFromCashBox(
//             amount: paid,
//             method: _paymentMethod,
//             note:
//                 'شراء ذهب من مكتب $_officeName (${weight.toStringAsFixed(2)} جم عيار $_carat)');
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content:
//                 Text(_t("تم تسجيل شراء الذهب ✅", "Gold purchase recorded ✅")),
//             backgroundColor: Colors.green));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted)
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//     }
//   }
// }

// // ============================================================
// // 🆕 حوار تسديد دفعة (تقسيط)
// // ============================================================
// class PayDebtDialog extends StatefulWidget {
//   final String purchaseId;
//   final Map<String, dynamic> data;
//   const PayDebtDialog(
//       {super.key, required this.purchaseId, required this.data});

//   @override
//   State<PayDebtDialog> createState() => _PayDebtDialogState();
// }

// class _PayDebtDialogState extends State<PayDebtDialog> {
//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   final _formKey = GlobalKey<FormState>();
//   final _amountCtrl = TextEditingController();
//   String _paymentMethod = 'cash';

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
//     final remaining = (widget.data['remaining'] ?? 0).toDouble();
//     final paid = (widget.data['paid'] ?? 0).toDouble();
//     final total = (widget.data['totalPrice'] ?? 0).toDouble();

//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Row(
//         children: [
//           const Icon(Icons.payment, color: Color(0xFFD4AF37)),
//           const SizedBox(width: 10),
//           Text(_t("تسديد دفعة", "Pay Installment")),
//         ],
//       ),
//       content: SizedBox(
//         width: MediaQuery.of(context).size.width * 0.85,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     _row(_t("الإجمالي", "Total"),
//                         '${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
//                     const SizedBox(height: 6),
//                     _row(_t("المدفوع", "Paid"),
//                         '${paid.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
//                     const SizedBox(height: 6),
//                     _row(_t("المتبقي", "Remaining"),
//                         '${remaining.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
//                         color: Colors.red),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 14),
//               TextFormField(
//                 controller: _amountCtrl,
//                 decoration: InputDecoration(
//                     labelText: _t("المبلغ (ريال)", "Amount"),
//                     prefixIcon:
//                         const Icon(Icons.money, color: Color(0xFFD4AF37)),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     suffixText: _t("ريال", "SAR")),
//                 keyboardType: TextInputType.number,
//                 validator: (v) {
//                   if (v == null || v.isEmpty) return _t("مطلوب", "Required");
//                   final amt = double.tryParse(v);
//                   if (amt == null) return _t("رقم غير صحيح", "Invalid number");
//                   if (amt <= 0) return _t("أكبر من صفر", "Must be positive");
//                   if (amt > remaining)
//                     return _t("أكبر من المتبقي", "Exceeds remaining");
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                     labelText: _t("طريقة الدفع", "Payment method"),
//                     prefixIcon:
//                         const Icon(Icons.credit_card, color: Color(0xFFD4AF37)),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12))),
//                 value: _paymentMethod,
//                 items: [
//                   DropdownMenuItem(
//                       value: 'cash', child: Text(_t("كاش", "Cash"))),
//                   DropdownMenuItem(
//                       value: 'network', child: Text(_t("شبكة", "Network"))),
//                 ],
//                 onChanged: (v) => setState(() => _paymentMethod = v!),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(_t("إلغاء", "Cancel"))),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFD4AF37),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12))),
//           onPressed: _submit,
//           child: Text(_t("تسديد", "Pay"),
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }

//   Widget _row(String title, String value, {Color? color}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: TextStyle(color: Colors.grey.shade700)),
//         Text(value,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
//       ],
//     );
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final amount = double.parse(_amountCtrl.text);

//     try {
//       await FS.addGoldPayment(
//         purchaseId: widget.purchaseId,
//         amount: amount,
//         paymentMethod: _paymentMethod,
//         date: DateTime.now(),
//       );

//       await FS.deductFromCashBox(
//           amount: amount,
//           method: _paymentMethod,
//           note: 'تسديد دفعة لمكتب ${widget.data['officeName']}');

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(_t("تم تسجيل الدفعة ✅", "Payment recorded ✅")),
//             backgroundColor: Colors.green));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted)
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';

// ============================================================
// 🔧 Helper: حساب رصيد الذهب لكل مكتب (مشتريات − تسكيرات)
// ============================================================
Future<Map<String, double>> getOfficeGoldBalance(String officeId) async {
  try {
    final fs = FirebaseFirestore.instance;
    final purchases = await fs
        .collection('gold_purchases')
        .where('officeId', isEqualTo: officeId)
        .get();
    final mintings = await fs
        .collection('mintings')
        .where('officeId', isEqualTo: officeId)
        .get();

    final balance = <String, double>{};

    for (var doc in purchases.docs) {
      final data = doc.data();
      final carats = data['carats'] as List?;
      if (carats != null && carats.isNotEmpty) {
        for (var c in carats) {
          final carat = (c['carat'] ?? '').toString();
          final weight = (c['weight'] ?? 0).toDouble();
          if (carat.isEmpty) continue;
          balance[carat] = (balance[carat] ?? 0) + weight;
        }
      } else {
        final carat = (data['carat'] ?? '').toString();
        final weight = (data['weight'] ?? 0).toDouble();
        if (carat.isNotEmpty) {
          balance[carat] = (balance[carat] ?? 0) + weight;
        }
      }
    }

    for (var doc in mintings.docs) {
      final data = doc.data();
      final carat = (data['carat'] ?? '').toString();
      final weight = (data['weight'] ?? 0).toDouble();
      if (carat.isNotEmpty && carat != 'multiple') {
        balance[carat] = (balance[carat] ?? 0) - weight;
      }
    }

    // إزالة العيارات اللي رصيدها صفر أو أقل
    balance.removeWhere((k, v) => v.abs() < 0.0001);
    return balance;
  } catch (e) {
    print('❌ getOfficeGoldBalance error: $e');
    return {};
  }
}

// ============================================================
// 🔹 صفحة إدارة مكاتب التسكيرات
// ============================================================
class MintOfficesManagementPage extends StatefulWidget {
  const MintOfficesManagementPage({super.key});

  @override
  State<MintOfficesManagementPage> createState() =>
      _MintOfficesManagementPageState();
}

class _MintOfficesManagementPageState extends State<MintOfficesManagementPage> {
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

  void _showAddOfficeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AddEditOfficeDialog());
  }

  void _showEditOfficeDialog(Map<String, dynamic> office) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AddEditOfficeDialog(office: office));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _showAddOfficeDialog,
              tooltip: _t("إضافة مكتب", "Add Office"),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FS.mintOfficesStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_city,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(_t("لا توجد مكاتب", "No offices"),
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(_t("اضغط على + لإضافة مكتب", "Tap + to add an office"),
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                ],
              ),
            );
          }

          final docs = snap.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;
              return _buildOfficeCard(id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildOfficeCard(String id, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
          child: const Icon(Icons.location_city,
              color: Color(0xFFD4AF37), size: 28),
        ),
        title: Text(data['name'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (data['address'] != null &&
                data['address'].toString().isNotEmpty)
              Text('📍 ${data['address']}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            if (data['phone'] != null && data['phone'].toString().isNotEmpty)
              Text('📞 ${data['phone']}',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _showEditOfficeDialog(data);
            if (value == 'delete') _deleteOffice(id, data['name']);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(_t("تعديل", "Edit")),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(_t("حذف", "Delete")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteOffice(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
        content: Text(_t("حذف المكتب $name؟", "Delete office $name?")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(_t("إلغاء", "Cancel"))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(_t("حذف", "Delete"),
                  style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await FS.deleteMintOffice(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("تم حذف المكتب ✅"), backgroundColor: Colors.redAccent));
    }
  }
}

// ============================================================
// 🔹 حوار إضافة/تعديل مكتب تسكيرات
// ============================================================
class AddEditOfficeDialog extends StatefulWidget {
  final Map<String, dynamic>? office;
  const AddEditOfficeDialog({super.key, this.office});

  @override
  State<AddEditOfficeDialog> createState() => _AddEditOfficeDialogState();
}

class _AddEditOfficeDialogState extends State<AddEditOfficeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    if (widget.office != null) {
      _isEditing = true;
      _nameCtrl.text = widget.office!['name'] ?? '';
      _addressCtrl.text = widget.office!['address'] ?? '';
      _phoneCtrl.text = widget.office!['phone'] ?? '';
    }
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(_isEditing ? Icons.edit : Icons.add_business,
              color: const Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Text(_isEditing
              ? _t("تعديل مكتب", "Edit Office")
              : _t("إضافة مكتب", "Add Office")),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: _t("اسم المكتب", "Office Name"),
                  prefixIcon:
                      const Icon(Icons.business, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? _t("مطلوب", "Required") : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressCtrl,
                decoration: InputDecoration(
                  labelText: _t("العنوان", "Address"),
                  prefixIcon:
                      const Icon(Icons.location_on, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: InputDecoration(
                  labelText: _t("رقم الهاتف", "Phone"),
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t("إلغاء", "Cancel"))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _submit,
          child: Text(_isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      if (_isEditing) {
        await FS.updateMintOffice(widget.office!['id'], {
          'name': _nameCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
        });
      } else {
        await FS.addMintOffice(
            name: _nameCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
            phone: _phoneCtrl.text.trim());
      }
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    }
  }
}

// ============================================================
// 🔹 صفحة التسكيرات الرئيسية — [جديد: 3 تبويبات]
// ============================================================
class MintingPage extends StatefulWidget {
  const MintingPage({super.key});

  @override
  State<MintingPage> createState() => _MintingPageState();
}

class _MintingPageState extends State<MintingPage>
    with SingleTickerProviderStateMixin {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() => _currentTab = _tabController.index);
    });
    _loadLanguage();
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

  // ---------- أزرار الفتح ----------
  void _showAddMintingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AddMintingDialog()).then((_) {
      setState(() {}); // إعادة بناء ليعكس رصيد الذهب الجديد
    });
  }

  void _showBuyGoldDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const BuyGoldDialog()).then((_) {
      setState(() {});
    });
  }

  void _openOfficesManagement() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()));
  }

  void _openClosedMintings() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const ClosedMintingsPage()));
  }

  void _showMintingDetails(String id, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MintingDetailsSheet(id: id, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("التسكيرات", "Minting")),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.business, color: Colors.white, size: 26),
            onPressed: _openOfficesManagement,
            tooltip: _t("إدارة المكاتب", "Manage Offices"),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, color: Colors.white, size: 26),
            onPressed: _openClosedMintings,
            tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(
              icon: const Icon(Icons.list_alt, size: 20),
              text: _t("المفتوحة", "Open"),
            ),
            Tab(
              icon: const Icon(Icons.savings, size: 20),
              text: _t("رصيد الذهب", "Balance"),
            ),
            Tab(
              icon: const Icon(Icons.shopping_cart, size: 20),
              text: _t("سجل الشراء", "Purchases"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOpenMintingsTab(),
          _buildGoldBalanceTab(),
          _buildPurchaseHistoryTab(),
        ],
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton(
              onPressed: _showAddMintingDialog,
              backgroundColor: const Color(0xFFD4AF37),
              tooltip: _t("تسكيرة جديدة", "New Minting"),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : FloatingActionButton.extended(
              onPressed: _showBuyGoldDialog,
              backgroundColor: const Color(0xFFD4AF37),
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
              label: Text(_t("شراء ذهب", "Buy Gold"),
                  style: const TextStyle(color: Colors.white)),
            ),
    );
  }

  // ============================================================
  // 📑 التبويب 1: التسكيرات المفتوحة
  // ============================================================
  Widget _buildOpenMintingsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FS.mintingsStream(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return _emptyState(
            icon: Icons.account_balance,
            title: _t("لا توجد تسكيرات مفتوحة", "No open minting records"),
            subtitle: _t(
                "اضغط على + لإضافة تسكيرة جديدة", "Tap + to add a new minting"),
          );
        }

        final openDocs = snap.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return (data['status'] ?? 'open') == 'open';
        }).toList();

        if (openDocs.isEmpty) {
          return _emptyState(
            icon: Icons.account_balance,
            title: _t("لا توجد تسكيرات مفتوحة", "No open minting records"),
            subtitle: _t("كل التسكيرات مغلقة", "All mintings are closed"),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: openDocs.length,
          itemBuilder: (ctx, index) {
            final data = openDocs[index].data() as Map<String, dynamic>;
            final id = openDocs[index].id;
            return _buildMintingCard(id, data, isClosed: false);
          },
        );
      },
    );
  }

  // ============================================================
  // 📑 التبويب 2: رصيد الذهب لكل مكتب
  // ============================================================
  Widget _buildGoldBalanceTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FS.goldPurchasesStream(),
      builder: (context, purchasesSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FS.mintingsStream(),
          builder: (context, mintingsSnap) {
            if (purchasesSnap.connectionState == ConnectionState.waiting ||
                mintingsSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final purchases = purchasesSnap.data?.docs ?? [];
            final mintings = mintingsSnap.data?.docs ?? [];

            // اجمع المشتريات لكل مكتب
            final Map<String, Map<String, double>> officeBalances = {};
            final Map<String, double> totalDebt = {};

            for (var doc in purchases) {
              final data = doc.data() as Map<String, dynamic>;
              final officeName = (data['officeName'] ?? '').toString();
              if (officeName.isEmpty) continue;

              officeBalances.putIfAbsent(officeName, () => {});
              totalDebt[officeName] = (totalDebt[officeName] ?? 0) +
                  ((data['remaining'] ?? 0).toDouble());

              final carats = data['carats'] as List?;
              if (carats != null && carats.isNotEmpty) {
                for (var c in carats) {
                  final carat = (c['carat'] ?? '').toString();
                  final weight = (c['weight'] ?? 0).toDouble();
                  if (carat.isEmpty) continue;
                  officeBalances[officeName]![carat] =
                      (officeBalances[officeName]![carat] ?? 0) + weight;
                }
              } else {
                final carat = (data['carat'] ?? '').toString();
                final weight = (data['weight'] ?? 0).toDouble();
                if (carat.isNotEmpty) {
                  officeBalances[officeName]![carat] =
                      (officeBalances[officeName]![carat] ?? 0) + weight;
                }
              }
            }

            // اخصم التسكيرات
            for (var doc in mintings) {
              final data = doc.data() as Map<String, dynamic>;
              final officeName = (data['officeName'] ?? '').toString();
              final carat = (data['carat'] ?? '').toString();
              final weight = (data['weight'] ?? 0).toDouble();

              if (officeName.isEmpty || carat.isEmpty || carat == 'multiple')
                continue;
              if (officeBalances.containsKey(officeName)) {
                officeBalances[officeName]![carat] =
                    (officeBalances[officeName]![carat] ?? 0) - weight;
              }
            }

            // نظّف الأصفار
            for (var office in officeBalances.keys.toList()) {
              officeBalances[office]!.removeWhere((k, v) => v.abs() < 0.0001);
            }

            // إجماليات
            double totalAllWeight = 0;
            double totalAllDebt = 0;
            for (var office in officeBalances.values) {
              for (var w in office.values) {
                totalAllWeight += w;
              }
            }
            for (var d in totalDebt.values) {
              totalAllDebt += d;
            }

            if (officeBalances.isEmpty && totalAllDebt == 0) {
              return _emptyState(
                icon: Icons.savings,
                title: _t("لا يوجد رصيد ذهب", "No gold balance"),
                subtitle: _t("اضغط على + لشراء ذهب من مكتب",
                    "Tap + to buy gold from an office"),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => setState(() {}),
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  // ملخص علوي
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.scale,
                          title: _t("إجمالي الذهب", "Total Gold"),
                          value:
                              '${totalAllWeight.toStringAsFixed(2)} ${_t("جم", "g")}',
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.account_balance_wallet,
                          title: _t("إجمالي المديونية", "Total Debt"),
                          value:
                              '${totalAllDebt.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _t("رصيد كل مكتب", "Balance per Office"),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...officeBalances.entries.map((entry) {
                    final office = entry.key;
                    final carats = entry.value;
                    final debt = totalDebt[office] ?? 0;
                    final totalOfficeWeight =
                        carats.values.fold(0.0, (a, b) => a + b);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      const Color(0xFFD4AF37).withOpacity(0.15),
                                  child: const Icon(Icons.location_city,
                                      color: Color(0xFFD4AF37), size: 22),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    office,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (debt > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${debt.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                                      style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (carats.isEmpty)
                              Text(
                                _t("لا يوجد رصيد متاح", "No available balance"),
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 13),
                              )
                            else
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: carats.entries.map((e) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37)
                                          .withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xFFD4AF37)
                                              .withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      '${_t("عيار", "K")} ${e.key}: ${e.value.toStringAsFixed(2)} ${_t("جم", "g")}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${_t("الإجمالي", "Total")}: ${totalOfficeWeight.toStringAsFixed(2)} ${_t("جم", "g")}',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // 📑 التبويب 3: سجل الشراء والتقسيط
  // ============================================================
  Widget _buildPurchaseHistoryTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FS.goldPurchasesStream(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return _emptyState(
            icon: Icons.shopping_cart,
            title: _t("لا توجد مشتريات", "No purchases"),
            subtitle: _t("اضغط على + لشراء ذهب من مكتب",
                "Tap + to buy gold from an office"),
          );
        }

        final docs = snap.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(14),
          itemCount: docs.length,
          itemBuilder: (ctx, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return _purchaseCard(docs[i].id, data);
          },
        );
      },
    );
  }

  // ============================================================
  // 🔨 Widgets مساعدة
  // ============================================================
  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildMintingCard(String id, Map<String, dynamic> data,
      {required bool isClosed}) {
    final supplierName = data['supplierName'] ?? '';
    final officeName = data['officeName'] ?? '';
    final weight = (data['weight'] ?? 0).toDouble();
    final manufacturing = (data['manufacturing'] ?? 0).toDouble();
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    final carat = data['carat'] ?? '';

    Color statusColor = isClosed ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showMintingDetails(id, data),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: statusColor.withOpacity(0.15),
                    child: Icon(isClosed ? Icons.lock_outline : Icons.lock_open,
                        color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(supplierName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(
                            '$officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                        isClosed
                            ? _t("مقفولة", "Closed")
                            : _t("مفتوحة", "Open"),
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _chip(Icons.scale,
                      '${weight.toStringAsFixed(2)} ${_t("جم", "g")}'),
                  if (carat.toString().isNotEmpty)
                    _chip(Icons.diamond_outlined, '$carat'),
                  _chip(Icons.handyman,
                      '${manufacturing.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
                ],
              ),
              if (!isClosed) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () async {
                      await FS.closeMinting(id,
                          sentWeight: weight,
                          returnedWeight: weight,
                          finalWage: manufacturing);
                      if (context.mounted) setState(() {});
                    },
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 18),
                    label: Text(_t("إغلاق التسكيرة", "Close Minting"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _purchaseCard(String id, Map<String, dynamic> data) {
    final officeName = data['officeName'] ?? '';
    final total = (data['totalPrice'] ?? 0).toDouble();
    final paid = (data['paid'] ?? 0).toDouble();
    final remaining = (data['remaining'] ?? 0).toDouble();
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    final isPaid = remaining <= 0.0001;
    final carats = data['carats'] as List?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      (isPaid ? Colors.green : Colors.orange).withOpacity(0.15),
                  child: Icon(isPaid ? Icons.check_circle : Icons.schedule,
                      color: isPaid ? Colors.green : Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(officeName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(DateFormat("dd/MM/yyyy • HH:mm").format(date),
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPaid ? Colors.green : Colors.orange)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                      isPaid ? _t("مدفوع", "Paid") : _t("آجل", "Credit"),
                      style: TextStyle(
                          color: isPaid ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (carats != null && carats.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: carats.map((c) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'عيار ${c['carat']} • ${(c['weight'] ?? 0).toStringAsFixed(2)} جم',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniInfo(
                    _t("الإجمالي", "Total"), '${total.toStringAsFixed(2)}'),
                _miniInfo(_t("المدفوع", "Paid"), '${paid.toStringAsFixed(2)}',
                    color: Colors.green),
                _miniInfo(_t("المتبقي", "Remaining"),
                    '${remaining.toStringAsFixed(2)}',
                    color: isPaid ? Colors.green : Colors.red),
              ],
            ),
            if (!isPaid) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PayDebtDialog(purchaseId: id, data: data),
                    ).then((_) => setState(() {}));
                  },
                  icon:
                      const Icon(Icons.payment, color: Colors.white, size: 18),
                  label: Text(_t("تسديد دفعة", "Pay Installment"),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _miniInfo(String title, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.black87)),
      ],
    );
  }
}

// ============================================================
// 🔹 صفحة التسكيرات المغلقة
// ============================================================
class ClosedMintingsPage extends StatefulWidget {
  const ClosedMintingsPage({super.key});

  @override
  State<ClosedMintingsPage> createState() => _ClosedMintingsPageState();
}

class _ClosedMintingsPageState extends State<ClosedMintingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التسكيرات المغلقة"),
        backgroundColor: Colors.grey.shade700,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FS.mintingsStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد تسكيرات مغلقة"));
          }
          final closedDocs = snap.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] ?? 'open') == 'closed';
          }).toList();
          if (closedDocs.isEmpty) {
            return const Center(child: Text("لا توجد تسكيرات مغلقة"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: closedDocs.length,
            itemBuilder: (context, index) {
              final data = closedDocs[index].data() as Map<String, dynamic>;
              final id = closedDocs[index].id;
              return ClosedMintingsCard(id: id, data: data);
            },
          );
        },
      ),
    );
  }
}

class ClosedMintingsCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const ClosedMintingsCard({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    final supplierName = data['supplierName'] ?? '';
    final officeName = data['officeName'] ?? '';
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.grey.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => MintingDetailsSheet(id: id, data: data),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.green,
                child: Icon(Icons.lock, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplierName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                        '$officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text("مقفولة",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 🆕 حوار إضافة تسكيرة جديدة — [يعتمد على رصيد المكتب]
// ============================================================
class AddMintingDialog extends StatefulWidget {
  const AddMintingDialog({super.key});

  @override
  State<AddMintingDialog> createState() => _AddMintingDialogState();
}

class _AddMintingDialogState extends State<AddMintingDialog> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  final _formKey = GlobalKey<FormState>();
  String? _supplierId;
  String? _supplierName;
  String? _officeId;
  String? _officeName;
  String? _carat;
  final _weightCtrl = TextEditingController();
  final _manufacturingCtrl = TextEditingController();
  String _paymentMethod = 'cash';

  List<Map<String, dynamic>> _offices = [];
  Map<String, double> _officeBalance = {};
  bool _isLoading = false;
  bool _isLoadingBalance = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadOffices();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _lang = prefs.getString('languageCode') ?? 'ar');
  }

  Future<void> _loadOffices() async {
    setState(() => _isLoading = true);
    try {
      final list = await FS.getMintOffices();
      if (!mounted) return;
      setState(() {
        _offices = list;
        if (_offices.isNotEmpty) {
          _officeId = _offices.first['id'].toString();
          _officeName = _offices.first['name'];
        }
      });
      if (_officeId != null) _loadBalance(_officeId!);
    } catch (e) {
      print('Error loading offices: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadBalance(String officeId) async {
    setState(() {
      _isLoadingBalance = true;
      _officeBalance = {};
      _carat = null;
    });
    try {
      final b = await getOfficeGoldBalance(officeId);
      if (!mounted) return;
      setState(() {
        _officeBalance = b;
        if (b.isNotEmpty) {
          _carat = b.keys.first;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoadingBalance = false);
    }
  }

  double get _availableWeight =>
      _carat != null ? (_officeBalance[_carat] ?? 0) : 0;
  double get _enteredWeight => double.tryParse(_weightCtrl.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.account_balance, color: Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Text(_t("تسكيرة جديدة", "New Minting")),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // المورد
                      FutureBuilder(
                        future: FS.getSuppliers(),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return const LinearProgressIndicator();
                          }
                          final suppliers = snap.data!;
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: _t("المورد (الذي سلم الذهب)",
                                  "Supplier (who gave gold)"),
                              prefixIcon: const Icon(Icons.business,
                                  color: Color(0xFFD4AF37)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            value: _supplierId,
                            items: suppliers
                                .map((s) => DropdownMenuItem<String>(
                                    value: s['id'].toString(),
                                    child: Text(s['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _supplierId = v;
                                _supplierName = suppliers.firstWhere(
                                    (s) => s['id'].toString() == v)['name'];
                              });
                            },
                            validator: (v) => v == null
                                ? _t("اختر مورد", "Select supplier")
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // المكتب
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _t("مكتب التسكيرات (مصدر الذهب)",
                              "Mint Office (gold source)"),
                          prefixIcon: const Icon(Icons.location_city,
                              color: Color(0xFFD4AF37)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _officeId,
                        items: _offices
                            .map((o) => DropdownMenuItem<String>(
                                value: o['id'].toString(),
                                child: Text(o['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _officeId = v;
                            _officeName = _offices.firstWhere(
                                (o) => o['id'].toString() == v)['name'];
                          });
                          if (v != null) _loadBalance(v);
                        },
                        validator: (v) =>
                            v == null ? _t("اختر مكتب", "Select office") : null,
                      ),
                      const SizedBox(height: 12),

                      // عرض رصيد المكتب
                      if (_isLoadingBalance)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        )
                      else if (_officeId != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _officeBalance.isEmpty
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: _officeBalance.isEmpty
                                    ? Colors.red.shade200
                                    : Colors.green.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                      _officeBalance.isEmpty
                                          ? Icons.warning_amber
                                          : Icons.check_circle_outline,
                                      size: 16,
                                      color: _officeBalance.isEmpty
                                          ? Colors.red.shade700
                                          : Colors.green.shade700),
                                  const SizedBox(width: 6),
                                  Text(
                                    _officeBalance.isEmpty
                                        ? _t("لا يوجد رصيد ذهب في هذا المكتب",
                                            "No gold balance at this office")
                                        : _t("رصيد الذهب المتاح",
                                            "Available Gold Balance"),
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _officeBalance.isEmpty
                                            ? Colors.red.shade700
                                            : Colors.green.shade700),
                                  ),
                                ],
                              ),
                              if (_officeBalance.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: _officeBalance.entries
                                      .map((e) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.green.shade200),
                                            ),
                                            child: Text(
                                              'عيار ${e.key}: ${e.value.toStringAsFixed(2)} جم',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),

                      // العيار (من المتاح فقط)
                      if (_officeBalance.isNotEmpty) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: _t("العيار", "Carat"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                value: _carat,
                                items: _officeBalance.keys
                                    .map((c) => DropdownMenuItem<String>(
                                        value: c, child: Text('عيار $c')))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _carat = v;
                                    _weightCtrl.clear();
                                  });
                                },
                                validator: (v) => v == null
                                    ? _t("اختر عيار", "Select carat")
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _weightCtrl,
                                decoration: InputDecoration(
                                  labelText: _t("الوزن (جم)", "Weight (g)"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  suffixText: _t("جم", "g"),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return _t("مطلوب", "Required");
                                  }
                                  final w = double.tryParse(v);
                                  if (w == null || w <= 0) {
                                    return _t("رقم غير صحيح", "Invalid");
                                  }
                                  if (w > _availableWeight + 0.0001) {
                                    return _t(
                                        "أكبر من المتاح", "Exceeds available");
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.info_outline,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              '${_t("المتاح", "Available")}: ${_availableWeight.toStringAsFixed(2)} ${_t("جم", "g")}  •  ${_t("المتبقي بعد التسكيرة", "Remaining")}: ${(_availableWeight - _enteredWeight).clamp(0, double.infinity).toStringAsFixed(2)} ${_t("جم", "g")}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      // المصنعية
                      TextFormField(
                        controller: _manufacturingCtrl,
                        decoration: InputDecoration(
                            labelText:
                                _t("المصنعية (ريال)", "Manufacturing (SAR)"),
                            prefixIcon: const Icon(Icons.handyman,
                                color: Color(0xFFD4AF37)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixText: _t("ريال", "SAR")),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return _t("مطلوب", "Required");
                          }
                          if (double.tryParse(v) == null) {
                            return _t("رقم غير صحيح", "Invalid");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // طريقة الدفع
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: _t(
                                "طريقة دفع المصنعية", "Manufacturing Payment"),
                            prefixIcon: const Icon(Icons.payment,
                                color: Color(0xFFD4AF37)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        value: _paymentMethod,
                        items: [
                          DropdownMenuItem(
                              value: 'cash', child: Text(_t("كاش", "Cash"))),
                          DropdownMenuItem(
                              value: 'network',
                              child: Text(_t("شبكة", "Network"))),
                        ],
                        onChanged: (v) => setState(() => _paymentMethod = v!),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t("إلغاء", "Cancel"))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: _submit,
          child: Text(_t("حفظ", "Save"),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_supplierId == null || _officeId == null || _carat == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(_t("يرجى إكمال البيانات", "Please complete the fields")),
          backgroundColor: Colors.orange));
      return;
    }

    final weight = double.parse(_weightCtrl.text);
    final manufacturing = double.parse(_manufacturingCtrl.text);

    if (weight > _availableWeight + 0.0001) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_t("الوزن أكبر من رصيد المكتب المتاح",
              "Weight exceeds office balance")),
          backgroundColor: Colors.red));
      return;
    }

    try {
      await FS.addMinting(
        supplierId: _supplierId!,
        supplierName: _supplierName!,
        officeId: _officeId!,
        officeName: _officeName!,
        carat: _carat!,
        weight: weight,
        goldPrice: 0, // الذهب مدفوع مسبقًا عند الشراء
        manufacturing: manufacturing,
        paymentMethod: _paymentMethod,
        date: DateTime.now(),
      );

      // خصم المصنعية فقط (الذهب مدفوع مسبقًا)
      if (manufacturing > 0) {
        await FS.deductFromCashBox(
            amount: manufacturing,
            method: _paymentMethod,
            note:
                'مصنعية تسكيرة للمورد $_supplierName من مكتب $_officeName ($_carat - ${weight.toStringAsFixed(2)} جم)');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_t(
                "تم إنشاء التسكيرة وخصم ${weight.toStringAsFixed(2)} جم من رصيد المكتب ✅",
                "Minting created & ${weight.toStringAsFixed(2)}g deducted from office ✅")),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
      }
    }
  }
}

// ============================================================
// 🔹 ورقة تفاصيل التسكيرة
// ============================================================
class MintingDetailsSheet extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const MintingDetailsSheet({super.key, required this.id, required this.data});

  @override
  State<MintingDetailsSheet> createState() => _MintingDetailsSheetState();
}

class _MintingDetailsSheetState extends State<MintingDetailsSheet> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
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
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              const Color(0xFFD4AF37).withOpacity(0.15),
                          child: const Icon(Icons.account_balance,
                              color: Color(0xFFD4AF37), size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.data['supplierName'] ?? ""}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('${widget.data['officeName'] ?? ""}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  DateFormat("dd/MM/yyyy HH:mm").format(
                                      (widget.data['date'] as Timestamp?)
                                              ?.toDate() ??
                                          DateTime.now()),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: (widget.data['status'] == 'closed')
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            (widget.data['status'] == 'closed')
                                ? _t("مقفولة", "Closed")
                                : _t("مفتوحة", "Open"),
                            style: TextStyle(
                                color: (widget.data['status'] == 'closed')
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Text(_t("بيانات التسكيرة", "Minting Details"),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 16),
                    _detailRow(Icons.scale, _t("الوزن", "Weight"),
                        '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
                    _detailRow(Icons.diamond_outlined, _t("العيار", "Carat"),
                        widget.data['carat'] ?? ''),
                    _detailRow(Icons.handyman, _t("المصنعية", "Manufacturing"),
                        '${widget.data['manufacturing'] ?? 0} ${_t('ريال', 'SAR')}'),
                    _detailRow(
                        Icons.payment,
                        _t("طريقة الدفع", "Payment Method"),
                        widget.data['paymentMethod'] ?? ''),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

// ============================================================
// 🆕 حوار شراء ذهب — [متعدد العيارات]
// ============================================================
class BuyGoldDialog extends StatefulWidget {
  const BuyGoldDialog({super.key});

  @override
  State<BuyGoldDialog> createState() => _BuyGoldDialogState();
}

class _BuyGoldDialogState extends State<BuyGoldDialog> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  final _formKey = GlobalKey<FormState>();
  String? _officeId;
  String? _officeName;

  // قائمة العيارات
  List<Map<String, dynamic>> _caratItems = [
    {'carat': '21', 'weight': 0.0, 'pricePerGram': 0.0},
  ];

  String _paymentMethod = 'cash';
  String _paymentType = 'full';
  final _paidCtrl = TextEditingController();

  List<Map<String, dynamic>> _offices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadOffices();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _lang = prefs.getString('languageCode') ?? 'ar');
  }

  Future<void> _loadOffices() async {
    setState(() => _isLoading = true);
    try {
      final list = await FS.getMintOffices();
      if (!mounted) return;
      setState(() {
        _offices = list;
        if (_offices.isNotEmpty) {
          _officeId = _offices.first['id'].toString();
          _officeName = _offices.first['name'];
        }
      });
    } catch (e) {
      print('Error loading offices: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addCaratItem() {
    setState(() {
      _caratItems.add({'carat': '21', 'weight': 0.0, 'pricePerGram': 0.0});
    });
  }

  void _removeCaratItem(int index) {
    if (_caratItems.length <= 1) return;
    setState(() => _caratItems.removeAt(index));
  }

  double get _totalPrice {
    double t = 0;
    for (var item in _caratItems) {
      final w = (item['weight'] ?? 0).toDouble();
      final p = (item['pricePerGram'] ?? 0).toDouble();
      t += w * p;
    }
    return t;
  }

  double get _paidAmount {
    if (_paymentType == 'full') return _totalPrice;
    if (_paymentType == 'credit') return 0;
    return double.tryParse(_paidCtrl.text) ?? 0;
  }

  double get _remaining =>
      (_totalPrice - _paidAmount).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.add_shopping_cart, color: Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(_t("شراء ذهب من مكتب", "Buy Gold from Office"),
                style: const TextStyle(fontSize: 17)),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // المكتب
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _t("المكتب", "Office"),
                          prefixIcon: const Icon(Icons.location_city,
                              color: Color(0xFFD4AF37)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _officeId,
                        items: _offices
                            .map((o) => DropdownMenuItem<String>(
                                value: o['id'].toString(),
                                child: Text(o['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _officeId = v;
                            _officeName = _offices.firstWhere(
                                (o) => o['id'].toString() == v)['name'];
                          });
                        },
                        validator: (v) =>
                            v == null ? _t("اختر مكتب", "Select office") : null,
                      ),
                      const SizedBox(height: 12),

                      // قائمة العيارات
                      Row(
                        children: [
                          const Icon(Icons.category,
                              color: Color(0xFFD4AF37), size: 20),
                          const SizedBox(width: 6),
                          Text(_t("العيارات", "Carats"),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Color(0xFFD4AF37), size: 26),
                            onPressed: _addCaratItem,
                            tooltip: _t("إضافة عيار", "Add Carat"),
                          ),
                        ],
                      ),
                      const Divider(height: 8),
                      Column(
                        children: _caratItems
                            .asMap()
                            .entries
                            .map((e) => _buildCaratRow(e.key, e.value))
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // الإجمالي
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_t("الإجمالي", "Total"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${_totalPrice.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD4AF37),
                                    fontSize: 16)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // نوع الدفع
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: _t("نوع الدفع", "Payment type"),
                            prefixIcon: const Icon(Icons.payment,
                                color: Color(0xFFD4AF37)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        value: _paymentType,
                        items: [
                          DropdownMenuItem(
                              value: 'full',
                              child: Text(_t("دفع كامل", "Full payment"))),
                          DropdownMenuItem(
                              value: 'partial',
                              child: Text(_t("دفع جزئي", "Partial payment"))),
                          DropdownMenuItem(
                              value: 'credit',
                              child: Text(
                                  _t("آجل (بدون دفع)", "Credit (no payment)"))),
                        ],
                        onChanged: (v) => setState(() => _paymentType = v!),
                      ),

                      if (_paymentType == 'partial') ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _paidCtrl,
                          decoration: InputDecoration(
                              labelText: _t("المبلغ المدفوع الآن (ريال)",
                                  "Amount paid now"),
                              prefixIcon: const Icon(Icons.money,
                                  color: Color(0xFFD4AF37)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              suffixText: _t("ريال", "SAR")),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (_paymentType != 'partial') return null;
                            if (v == null || v.isEmpty) {
                              return _t("مطلوب", "Required");
                            }
                            final amt = double.tryParse(v);
                            if (amt == null)
                              return _t("رقم غير صحيح", "Invalid");
                            if (amt > _totalPrice) {
                              return _t("أكبر من الإجمالي", "Exceeds total");
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (_remaining > 0 ? Colors.red : Colors.green)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_t("المتبقي", "Remaining"),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${_remaining.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _remaining > 0
                                        ? Colors.red
                                        : Colors.green,
                                    fontSize: 16)),
                          ],
                        ),
                      ),

                      if (_paidAmount > 0) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              labelText: _t("طريقة الدفع", "Payment method"),
                              prefixIcon: const Icon(Icons.credit_card,
                                  color: Color(0xFFD4AF37)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          value: _paymentMethod,
                          items: [
                            DropdownMenuItem(
                                value: 'cash', child: Text(_t("كاش", "Cash"))),
                            DropdownMenuItem(
                                value: 'network',
                                child: Text(_t("شبكة", "Network"))),
                          ],
                          onChanged: (v) => setState(() => _paymentMethod = v!),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t("إلغاء", "Cancel"))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: _submit,
          child: Text(_t("حفظ", "Save"),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildCaratRow(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: _t("العيار", "Carat"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    isDense: true,
                  ),
                  value: item['carat']?.toString(),
                  items: ['14', '18', '21', '22', '24']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _caratItems[index]['carat'] = v);
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 3,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _t("الوزن", "Weight"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixText: _t("جم", "g"),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    setState(() =>
                        _caratItems[index]['weight'] = double.tryParse(v) ?? 0);
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) return _t("مطلوب", "Req");
                    if (double.tryParse(v) == null) {
                      return _t("خطأ", "Invalid");
                    }
                    return null;
                  },
                ),
              ),
              if (_caratItems.length > 1)
                IconButton(
                  icon: const Icon(Icons.remove_circle,
                      color: Colors.red, size: 22),
                  onPressed: () => _removeCaratItem(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              labelText: _t("سعر الجرام (ريال)", "Price per gram (SAR)"),
              prefixIcon:
                  const Icon(Icons.attach_money, color: Color(0xFFD4AF37)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixText: _t("ريال", "SAR"),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              setState(() =>
                  _caratItems[index]['pricePerGram'] = double.tryParse(v) ?? 0);
            },
            validator: (v) {
              if (v == null || v.isEmpty) return _t("مطلوب", "Req");
              if (double.tryParse(v) == null) return _t("خطأ", "Invalid");
              return null;
            },
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_officeId == null) return;

    final validCarats = _caratItems
        .where((c) =>
            c['carat'] != null &&
            (c['weight'] ?? 0) > 0 &&
            (c['pricePerGram'] ?? 0) > 0)
        .toList();

    if (validCarats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_t("أدخل عيار واحد على الأقل بوزن وسعر",
              "Enter at least one valid carat")),
          backgroundColor: Colors.orange));
      return;
    }

    final total = _totalPrice;
    final paid = _paidAmount;
    final remaining = total - paid;

    try {
      // اجمع الوزن الكلي
      double totalWeight = 0;
      for (var c in validCarats) {
        totalWeight += (c['weight'] as num).toDouble();
      }

      // نبني الـ carats data
      final caratsData = validCarats
          .map((c) => {
                'carat': c['carat'].toString(),
                'weight': (c['weight'] as num).toDouble(),
                'pricePerGram': (c['pricePerGram'] as num).toDouble(),
              })
          .toList();

      await FS.addGoldPurchase(
        officeId: _officeId!,
        officeName: _officeName!,
        carat: 'multiple',
        weight: totalWeight,
        pricePerGram: 0,
        totalPrice: total,
        paid: paid,
        remaining: remaining,
        paymentMethod: _paymentMethod,
        paymentType: _paymentType,
        date: DateTime.now(),
        carats: caratsData,
      );

      if (paid > 0) {
        await FS.deductFromCashBox(
            amount: paid,
            method: _paymentMethod,
            note:
                'شراء ذهب من مكتب $_officeName (${validCarats.length} عيارات)');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(_t("تم تسجيل شراء الذهب ✅", "Gold purchase recorded ✅")),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
      }
    }
  }
}

// ============================================================
// 🆕 حوار تسديد دفعة
// ============================================================
class PayDebtDialog extends StatefulWidget {
  final String purchaseId;
  final Map<String, dynamic> data;
  const PayDebtDialog(
      {super.key, required this.purchaseId, required this.data});

  @override
  State<PayDebtDialog> createState() => _PayDebtDialogState();
}

class _PayDebtDialogState extends State<PayDebtDialog> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  String _paymentMethod = 'cash';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _lang = prefs.getString('languageCode') ?? 'ar');
  }

  @override
  Widget build(BuildContext context) {
    final remaining = (widget.data['remaining'] ?? 0).toDouble();
    final paid = (widget.data['paid'] ?? 0).toDouble();
    final total = (widget.data['totalPrice'] ?? 0).toDouble();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.payment, color: Color(0xFFD4AF37)),
          const SizedBox(width: 10),
          Text(_t("تسديد دفعة", "Pay Installment")),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _row(_t("الإجمالي", "Total"),
                        '${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
                    const SizedBox(height: 6),
                    _row(_t("المدفوع", "Paid"),
                        '${paid.toStringAsFixed(2)} ${_t("ريال", "SAR")}'),
                    const SizedBox(height: 6),
                    _row(_t("المتبقي", "Remaining"),
                        '${remaining.toStringAsFixed(2)} ${_t("ريال", "SAR")}',
                        color: Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _amountCtrl,
                decoration: InputDecoration(
                    labelText: _t("المبلغ (ريال)", "Amount"),
                    prefixIcon:
                        const Icon(Icons.money, color: Color(0xFFD4AF37)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    suffixText: _t("ريال", "SAR")),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return _t("مطلوب", "Required");
                  final amt = double.tryParse(v);
                  if (amt == null) return _t("رقم غير صحيح", "Invalid");
                  if (amt <= 0) return _t("أكبر من صفر", "Must be positive");
                  if (amt > remaining) {
                    return _t("أكبر من المتبقي", "Exceeds remaining");
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: _t("طريقة الدفع", "Payment method"),
                    prefixIcon:
                        const Icon(Icons.credit_card, color: Color(0xFFD4AF37)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                value: _paymentMethod,
                items: [
                  DropdownMenuItem(
                      value: 'cash', child: Text(_t("كاش", "Cash"))),
                  DropdownMenuItem(
                      value: 'network', child: Text(_t("شبكة", "Network"))),
                ],
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t("إلغاء", "Cancel"))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: _submit,
          child: Text(_t("تسديد", "Pay"),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _row(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade700)),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color ?? Colors.black87)),
      ],
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text);

    try {
      await FS.addGoldPayment(
        purchaseId: widget.purchaseId,
        amount: amount,
        paymentMethod: _paymentMethod,
        date: DateTime.now(),
      );

      await FS.deductFromCashBox(
          amount: amount,
          method: _paymentMethod,
          note: 'تسديد دفعة لمكتب ${widget.data['officeName']}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_t("تم تسجيل الدفعة ✅", "Payment recorded ✅")),
            backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
