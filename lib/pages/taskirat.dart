// // // // ============================================================
// // // // 📄 ملف: MintingPage.dart
// // // // ============================================================
// // // // السيناريو الجديد:
// // // // 1. المورد يسلم ذهب (وزن، عيار) إلى المحل.
// // // // 2. المحل يشتري نفس الوزن من الذهب الخام من مكتب التسكيرات.
// // // // 3. المحل يسلم الذهب الخام للمورد (أو المورد يستلمه من المكتب مباشرة).
// // // // 4. المحل يدفع للمكتب ثمن الذهب الخام (كاش/شبكة).
// // // // 5. بعد استلام الخام، يتم إغلاق التسكيرة بتسجيل الوزن المستلم فعليًا والمصنعية.
// // // // ============================================================

// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:intl/intl.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../services/firestore_service.dart';

// // // // ============================================================
// // // // 🔹 صفحة إدارة مكاتب التسكيرات
// // // // ============================================================
// // // class MintOfficesManagementPage extends StatefulWidget {
// // //   const MintOfficesManagementPage({super.key});

// // //   @override
// // //   State<MintOfficesManagementPage> createState() =>
// // //       _MintOfficesManagementPageState();
// // // }

// // // class _MintOfficesManagementPageState extends State<MintOfficesManagementPage> {
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

// // //   void _showAddOfficeDialog() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (_) => const AddEditOfficeDialog(),
// // //     );
// // //   }

// // //   void _showEditOfficeDialog(Map<String, dynamic> office) {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (_) => AddEditOfficeDialog(office: office),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.add, color: Colors.white),
// // //             onPressed: _showAddOfficeDialog,
// // //             tooltip: _t("إضافة مكتب", "Add Office"),
// // //           ),
// // //         ],
// // //       ),
// // //       body: StreamBuilder<QuerySnapshot>(
// // //         stream: FS.mintOfficesStream(),
// // //         builder: (context, snap) {
// // //           if (snap.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// // //             return Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   Icon(Icons.location_city,
// // //                       size: 64, color: Colors.grey.shade300),
// // //                   const SizedBox(height: 12),
// // //                   Text(
// // //                     _t("لا توجد مكاتب", "No offices"),
// // //                     style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   Text(
// // //                     _t("اضغط على + لإضافة مكتب", "Tap + to add an office"),
// // //                     style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           }

// // //           final docs = snap.data!.docs;
// // //           return ListView.builder(
// // //             padding: const EdgeInsets.all(12),
// // //             itemCount: docs.length,
// // //             itemBuilder: (ctx, index) {
// // //               final data = docs[index].data() as Map<String, dynamic>;
// // //               final id = docs[index].id;
// // //               return _buildOfficeCard(id, data);
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildOfficeCard(String id, Map<String, dynamic> data) {
// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 10),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// // //       elevation: 2,
// // //       child: ListTile(
// // //         leading: CircleAvatar(
// // //           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
// // //           child: const Icon(Icons.location_city, color: Color(0xFFD4AF37)),
// // //         ),
// // //         title: Text(data['name'] ?? ''),
// // //         subtitle: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             if (data['address'] != null &&
// // //                 data['address'].toString().isNotEmpty)
// // //               Text('📍 ${data['address']}'),
// // //             if (data['phone'] != null && data['phone'].toString().isNotEmpty)
// // //               Text('📞 ${data['phone']}'),
// // //           ],
// // //         ),
// // //         trailing: PopupMenuButton<String>(
// // //           onSelected: (value) {
// // //             if (value == 'edit') _showEditOfficeDialog(data);
// // //             if (value == 'delete') _deleteOffice(id, data['name']);
// // //           },
// // //           itemBuilder: (context) => [
// // //             PopupMenuItem(
// // //               value: 'edit',
// // //               child: Row(
// // //                 children: [
// // //                   const Icon(Icons.edit, color: Colors.orange, size: 20),
// // //                   const SizedBox(width: 8),
// // //                   Text(_t("تعديل", "Edit")),
// // //                 ],
// // //               ),
// // //             ),
// // //             PopupMenuItem(
// // //               value: 'delete',
// // //               child: Row(
// // //                 children: [
// // //                   const Icon(Icons.delete, color: Colors.red, size: 20),
// // //                   const SizedBox(width: 8),
// // //                   Text(_t("حذف", "Delete")),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _deleteOffice(String id, String name) async {
// // //     final confirm = await showDialog<bool>(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
// // //         content: Text(_t("حذف المكتب $name؟", "Delete office $name?")),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: Text(_t("إلغاء", "Cancel")),
// // //           ),
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, true),
// // //             child: Text(_t("حذف", "Delete"),
// // //                 style: const TextStyle(color: Colors.red)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //     if (confirm == true) {
// // //       await FS.deleteMintOffice(id);
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(_t("تم حذف المكتب ✅", "Office deleted ✅")),
// // //           backgroundColor: Colors.redAccent,
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }

// // // // ============================================================
// // // // 🔹 حوار إضافة/تعديل مكتب تسكيرات
// // // // ============================================================
// // // class AddEditOfficeDialog extends StatefulWidget {
// // //   final Map<String, dynamic>? office;
// // //   const AddEditOfficeDialog({super.key, this.office});

// // //   @override
// // //   State<AddEditOfficeDialog> createState() => _AddEditOfficeDialogState();
// // // }

// // // class _AddEditOfficeDialogState extends State<AddEditOfficeDialog> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final _nameCtrl = TextEditingController();
// // //   final _addressCtrl = TextEditingController();
// // //   final _phoneCtrl = TextEditingController();

// // //   String _lang = 'ar';
// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;
// // //   bool _isEditing = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //     if (widget.office != null) {
// // //       _isEditing = true;
// // //       _nameCtrl.text = widget.office!['name'] ?? '';
// // //       _addressCtrl.text = widget.office!['address'] ?? '';
// // //       _phoneCtrl.text = widget.office!['phone'] ?? '';
// // //     }
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AlertDialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //       title: Row(
// // //         children: [
// // //           Icon(
// // //             _isEditing ? Icons.edit : Icons.add_business,
// // //             color: const Color(0xFFD4AF37),
// // //           ),
// // //           const SizedBox(width: 10),
// // //           Text(_isEditing
// // //               ? _t("تعديل مكتب", "Edit Office")
// // //               : _t("إضافة مكتب", "Add Office")),
// // //         ],
// // //       ),
// // //       content: SizedBox(
// // //         width: MediaQuery.of(context).size.width * 0.85,
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               TextFormField(
// // //                 controller: _nameCtrl,
// // //                 decoration: InputDecoration(
// // //                   labelText: _t("اسم المكتب", "Office Name"),
// // //                   prefixIcon:
// // //                       const Icon(Icons.business, color: Color(0xFFD4AF37)),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //                 validator: (v) =>
// // //                     v == null || v.isEmpty ? _t("مطلوب", "Required") : null,
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _addressCtrl,
// // //                 decoration: InputDecoration(
// // //                   labelText: _t("العنوان", "Address"),
// // //                   prefixIcon:
// // //                       const Icon(Icons.location_on, color: Color(0xFFD4AF37)),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _phoneCtrl,
// // //                 decoration: InputDecoration(
// // //                   labelText: _t("رقم الهاتف", "Phone"),
// // //                   prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
// // //                   border: OutlineInputBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //                 keyboardType: TextInputType.phone,
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //       actions: [
// // //         TextButton(
// // //           onPressed: () => Navigator.pop(context),
// // //           child: Text(_t("إلغاء", "Cancel")),
// // //         ),
// // //         ElevatedButton(
// // //           style: ElevatedButton.styleFrom(
// // //             backgroundColor: const Color(0xFFD4AF37),
// // //             shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //           ),
// // //           onPressed: _submit,
// // //           child: Text(
// // //             _isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
// // //             style: const TextStyle(
// // //                 color: Colors.white, fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   void _submit() async {
// // //     if (!_formKey.currentState!.validate()) return;

// // //     try {
// // //       if (_isEditing) {
// // //         await FS.updateMintOffice(
// // //           widget.office!['id'],
// // //           {
// // //             'name': _nameCtrl.text.trim(),
// // //             'address': _addressCtrl.text.trim(),
// // //             'phone': _phoneCtrl.text.trim(),
// // //           },
// // //         );
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(_t("تم تعديل المكتب ✅", "Office updated ✅")),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       } else {
// // //         await FS.addMintOffice(
// // //           name: _nameCtrl.text.trim(),
// // //           address: _addressCtrl.text.trim(),
// // //           phone: _phoneCtrl.text.trim(),
// // //         );
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(_t("تم إضافة المكتب ✅", "Office added ✅")),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //       }
// // //       Navigator.pop(context);
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('${_t("خطأ", "Error")}: $e'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }

// // // // ============================================================
// // // // 🔹 صفحة التسكيرات الرئيسية
// // // // ============================================================
// // // class MintingPage extends StatefulWidget {
// // //   const MintingPage({super.key});

// // //   @override
// // //   State<MintingPage> createState() => _MintingPageState();
// // // }

// // // class _MintingPageState extends State<MintingPage> {
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

// // //   void _showAddMintingDialog() {
// // //     showDialog(
// // //       context: context,
// // //       barrierDismissible: false,
// // //       builder: (_) => const AddMintingDialog(),
// // //     );
// // //   }

// // //   void _openOfficesManagement() {
// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(_t("التسكيرات", "Minting")),
// // //         backgroundColor: const Color(0xFFD4AF37),
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.settings, color: Colors.white),
// // //             onPressed: _openOfficesManagement,
// // //             tooltip: _t("إدارة المكاتب", "Manage Offices"),
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.add, color: Colors.white),
// // //             onPressed: _showAddMintingDialog,
// // //             tooltip: _t("إضافة تسكيرة", "Add Minting"),
// // //           ),
// // //         ],
// // //       ),
// // //       body: StreamBuilder<QuerySnapshot>(
// // //         stream: FS.mintingsStream(),
// // //         builder: (context, snap) {
// // //           if (snap.connectionState == ConnectionState.waiting) {
// // //             return const Center(child: CircularProgressIndicator());
// // //           }
// // //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// // //             return Center(
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   Icon(Icons.account_balance,
// // //                       size: 64, color: Colors.grey.shade300),
// // //                   const SizedBox(height: 12),
// // //                   Text(
// // //                     _t("لا توجد تسكيرات", "No minting records"),
// // //                     style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   Text(
// // //                     _t("اضغط على + لإضافة تسكيرة جديدة",
// // //                         "Tap + to add a new minting"),
// // //                     style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
// // //                   ),
// // //                 ],
// // //               ),
// // //             );
// // //           }

// // //           final docs = snap.data!.docs;
// // //           return ListView.builder(
// // //             padding: const EdgeInsets.all(12),
// // //             itemCount: docs.length,
// // //             itemBuilder: (ctx, index) {
// // //               final data = docs[index].data() as Map<String, dynamic>;
// // //               final id = docs[index].id;
// // //               return _buildMintingCard(id, data);
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMintingCard(String id, Map<String, dynamic> data) {
// // //     final status = data['status'] ?? 'open';
// // //     final isClosed = status == 'closed';
// // //     final supplierName = data['supplierName'] ?? '';
// // //     final officeName = data['officeName'] ?? '';
// // //     final weight = (data['weight'] ?? 0).toDouble();
// // //     final carat = data['carat'] ?? '';
// // //     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
// // //     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

// // //     final sentWeight = (data['sentWeight'] ?? weight).toDouble();
// // //     final returnedWeight = (data['returnedWeight'] ?? 0).toDouble();
// // //     final diff = sentWeight - returnedWeight;
// // //     final finalWage = (data['finalWage'] ?? 0).toDouble();

// // //     Color statusColor = isClosed ? Colors.green : Colors.orange;
// // //     String statusText =
// // //         isClosed ? _t("مقفولة", "Closed") : _t("مفتوحة", "Open");

// // //     return Card(
// // //       margin: const EdgeInsets.only(bottom: 10),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// // //       elevation: 2,
// // //       child: InkWell(
// // //         borderRadius: BorderRadius.circular(14),
// // //         onTap: () {
// // //           _showMintingDetails(id, data);
// // //         },
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(12),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Row(
// // //                 children: [
// // //                   CircleAvatar(
// // //                     backgroundColor: statusColor.withOpacity(0.15),
// // //                     child: Icon(
// // //                       isClosed ? Icons.lock_outline : Icons.lock_open,
// // //                       color: statusColor,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 12),
// // //                   Expanded(
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         Text(
// // //                           '#$id — $supplierName',
// // //                           style: const TextStyle(
// // //                             fontWeight: FontWeight.bold,
// // //                             fontSize: 16,
// // //                           ),
// // //                           maxLines: 1,
// // //                           overflow: TextOverflow.ellipsis,
// // //                         ),
// // //                         Text(
// // //                           '$officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
// // //                           style: TextStyle(
// // //                               fontSize: 13, color: Colors.grey.shade600),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                   Container(
// // //                     padding:
// // //                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// // //                     decoration: BoxDecoration(
// // //                       color: statusColor.withOpacity(0.1),
// // //                       borderRadius: BorderRadius.circular(12),
// // //                     ),
// // //                     child: Text(
// // //                       statusText,
// // //                       style: TextStyle(
// // //                         color: statusColor,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 12,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 8),
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                 children: [
// // //                   _infoChip(
// // //                       Icons.scale, '${weight.toStringAsFixed(2)} جم', carat),
// // //                   _infoChip(Icons.money, '${goldPrice.toStringAsFixed(2)}',
// // //                       _t('ثمن الخام', 'Raw Price')),
// // //                   _infoChip(Icons.payment, data['paymentMethod'] ?? '', ''),
// // //                 ],
// // //               ),
// // //               if (isClosed) ...[
// // //                 const Divider(height: 16),
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //                   children: [
// // //                     _infoChip(Icons.send, '${sentWeight.toStringAsFixed(2)} جم',
// // //                         _t('مرسل', 'Sent')),
// // //                     _infoChip(
// // //                         Icons.reply,
// // //                         '${returnedWeight.toStringAsFixed(2)} جم',
// // //                         _t('مستلم', 'Received')),
// // //                     _infoChip(
// // //                       Icons.trending_up,
// // //                       '${diff.toStringAsFixed(2)} جم',
// // //                       diff > 0 ? _t('نقص', 'Loss') : _t('زيادة', 'Gain'),
// // //                       color: diff > 0 ? Colors.red : Colors.green,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _infoChip(IconData icon, String label, String sub,
// // //       {Color color = Colors.grey}) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade100,
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           Icon(icon, size: 16, color: color),
// // //           const SizedBox(width: 4),
// // //           Text(
// // //             label,
// // //             style: TextStyle(
// // //                 fontSize: 13, fontWeight: FontWeight.w600, color: color),
// // //           ),
// // //           if (sub.isNotEmpty) ...[
// // //             const SizedBox(width: 4),
// // //             Text(
// // //               sub,
// // //               style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _showMintingDetails(String id, Map<String, dynamic> data) {
// // //     showModalBottomSheet(
// // //       context: context,
// // //       isScrollControlled: true,
// // //       backgroundColor: Colors.transparent,
// // //       builder: (_) => MintingDetailsSheet(id: id, data: data),
// // //     );
// // //   }
// // // }

// // // // ============================================================
// // // // 🔹 حوار إضافة تسكيرة جديدة
// // // // ============================================================
// // // class AddMintingDialog extends StatefulWidget {
// // //   const AddMintingDialog({super.key});

// // //   @override
// // //   State<AddMintingDialog> createState() => _AddMintingDialogState();
// // // }

// // // class _AddMintingDialogState extends State<AddMintingDialog> {
// // //   String _lang = 'ar';
// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // //   final _formKey = GlobalKey<FormState>();
// // //   String? _supplierId;
// // //   String? _supplierName;
// // //   String? _officeId;
// // //   String? _officeName;
// // //   String _carat = '21';
// // //   final _weightCtrl = TextEditingController();
// // //   final _goldPriceCtrl = TextEditingController();
// // //   String _paymentMethod = 'cash';

// // //   List<Map<String, dynamic>> _offices = [];
// // //   bool _isLoading = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //     _loadOffices();
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   Future<void> _loadOffices() async {
// // //     setState(() => _isLoading = true);
// // //     try {
// // //       final list = await FS.getMintOffices();
// // //       setState(() {
// // //         _offices = list;
// // //         if (_offices.isNotEmpty) {
// // //           _officeId = _offices.first['id'];
// // //           _officeName = _offices.first['name'];
// // //         }
// // //       });
// // //     } catch (e) {
// // //       print('Error loading offices: $e');
// // //     } finally {
// // //       setState(() => _isLoading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AlertDialog(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // //       title: Row(
// // //         children: [
// // //           const Icon(Icons.account_balance, color: Color(0xFFD4AF37)),
// // //           const SizedBox(width: 10),
// // //           Text(_t("تسكيرة جديدة", "New Minting")),
// // //         ],
// // //       ),
// // //       content: SizedBox(
// // //         width: MediaQuery.of(context).size.width * 0.9,
// // //         child: _isLoading
// // //             ? const Center(child: CircularProgressIndicator())
// // //             : Form(
// // //                 key: _formKey,
// // //                 child: SingleChildScrollView(
// // //                   child: Column(
// // //                     mainAxisSize: MainAxisSize.min,
// // //                     children: [
// // //                       // ===== المورد =====
// // //                       FutureBuilder(
// // //                         future: FS.getSuppliers(),
// // //                         builder: (context, snap) {
// // //                           if (!snap.hasData) {
// // //                             return const CircularProgressIndicator();
// // //                           }
// // //                           final suppliers = snap.data!;
// // //                           return DropdownButtonFormField<String>(
// // //                             decoration: InputDecoration(
// // //                               labelText: _t("المورد (الذي سلم الذهب)",
// // //                                   "Supplier (who gave gold)"),
// // //                               prefixIcon: const Icon(Icons.business,
// // //                                   color: Color(0xFFD4AF37)),
// // //                               border: OutlineInputBorder(
// // //                                 borderRadius: BorderRadius.circular(12),
// // //                               ),
// // //                             ),
// // //                             value: _supplierId,
// // //                             items: suppliers.map((s) {
// // //                               return DropdownMenuItem<String>(
// // //                                 value: s['id'],
// // //                                 child: Text(s['name']),
// // //                               );
// // //                             }).toList(),
// // //                             onChanged: (v) {
// // //                               setState(() {
// // //                                 _supplierId = v;
// // //                                 _supplierName = suppliers
// // //                                     .firstWhere((s) => s['id'] == v)['name'];
// // //                               });
// // //                             },
// // //                             validator: (v) => v == null
// // //                                 ? _t("اختر مورد", "Select supplier")
// // //                                 : null,
// // //                           );
// // //                         },
// // //                       ),
// // //                       const SizedBox(height: 12),

// // //                       // ===== مكتب التسكيرات (بائع الخام) =====
// // //                       DropdownButtonFormField<String>(
// // //                         decoration: InputDecoration(
// // //                           labelText: _t("مكتب التسكيرات (بائع الخام)",
// // //                               "Mint Office (raw gold seller)"),
// // //                           prefixIcon: const Icon(Icons.location_city,
// // //                               color: Color(0xFFD4AF37)),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                         ),
// // //                         value: _officeId,
// // //                         items: _offices.map((o) {
// // //                           return DropdownMenuItem<String>(
// // //                             value: o['id'],
// // //                             child: Text(o['name']),
// // //                           );
// // //                         }).toList(),
// // //                         onChanged: (v) {
// // //                           setState(() {
// // //                             _officeId = v;
// // //                             _officeName = _offices
// // //                                 .firstWhere((o) => o['id'] == v)['name'];
// // //                           });
// // //                         },
// // //                         validator: (v) =>
// // //                             v == null ? _t("اختر مكتب", "Select office") : null,
// // //                       ),
// // //                       const SizedBox(height: 12),

// // //                       // ===== العيار والوزن =====
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: DropdownButtonFormField<String>(
// // //                               decoration: InputDecoration(
// // //                                 labelText: _t("العيار", "Carat"),
// // //                                 border: OutlineInputBorder(
// // //                                   borderRadius: BorderRadius.circular(12),
// // //                                 ),
// // //                               ),
// // //                               value: _carat,
// // //                               items: ['18', '21', '22'].map((c) {
// // //                                 return DropdownMenuItem<String>(
// // //                                     value: c, child: Text(c));
// // //                               }).toList(),
// // //                               onChanged: (v) => setState(() => _carat = v!),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 12),
// // //                           Expanded(
// // //                             flex: 3,
// // //                             child: TextFormField(
// // //                               controller: _weightCtrl,
// // //                               decoration: InputDecoration(
// // //                                 labelText: _t("الوزن (جم) المطلوب شراؤه",
// // //                                     "Weight (g) to purchase"),
// // //                                 border: OutlineInputBorder(
// // //                                   borderRadius: BorderRadius.circular(12),
// // //                                 ),
// // //                                 suffixText: _t("جم", "g"),
// // //                               ),
// // //                               keyboardType: TextInputType.number,
// // //                               validator: (v) {
// // //                                 if (v == null || v.isEmpty)
// // //                                   return _t("مطلوب", "Required");
// // //                                 if (double.tryParse(v) == null)
// // //                                   return _t("رقم غير صحيح", "Invalid number");
// // //                                 return null;
// // //                               },
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       const SizedBox(height: 12),

// // //                       // ===== ثمن الخام =====
// // //                       TextFormField(
// // //                         controller: _goldPriceCtrl,
// // //                         decoration: InputDecoration(
// // //                           labelText: _t(
// // //                               "ثمن الذهب الخام (جنيه)", "Raw gold price (EGP)"),
// // //                           prefixIcon:
// // //                               const Icon(Icons.money, color: Color(0xFFD4AF37)),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           suffixText: _t("جنيه", "EGP"),
// // //                         ),
// // //                         keyboardType: TextInputType.number,
// // //                         validator: (v) {
// // //                           if (v == null || v.isEmpty)
// // //                             return _t("مطلوب", "Required");
// // //                           if (double.tryParse(v) == null)
// // //                             return _t("رقم غير صحيح", "Invalid number");
// // //                           return null;
// // //                         },
// // //                       ),
// // //                       const SizedBox(height: 6),

// // //                       // طريقة الدفع للمكتب
// // //                       DropdownButtonFormField<String>(
// // //                         decoration: InputDecoration(
// // //                           labelText: _t(
// // //                               "طريقة الدفع للمكتب", "Payment method to office"),
// // //                           prefixIcon: const Icon(Icons.payment,
// // //                               color: Color(0xFFD4AF37)),
// // //                           border: OutlineInputBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                         ),
// // //                         value: _paymentMethod,
// // //                         items: const [
// // //                           DropdownMenuItem<String>(
// // //                               value: 'cash', child: Text('كاش')),
// // //                           DropdownMenuItem<String>(
// // //                               value: 'network', child: Text('شبكة')),
// // //                         ],
// // //                         onChanged: (v) => setState(() => _paymentMethod = v!),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //       ),
// // //       actions: [
// // //         TextButton(
// // //           onPressed: () => Navigator.pop(context),
// // //           child: Text(_t("إلغاء", "Cancel")),
// // //         ),
// // //         ElevatedButton(
// // //           style: ElevatedButton.styleFrom(
// // //             backgroundColor: const Color(0xFFD4AF37),
// // //             shape: RoundedRectangleBorder(
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //           ),
// // //           onPressed: _submit,
// // //           child: Text(
// // //             _t("حفظ", "Save"),
// // //             style: const TextStyle(
// // //                 color: Colors.white, fontWeight: FontWeight.bold),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   void _submit() async {
// // //     if (!_formKey.currentState!.validate()) return;
// // //     if (_supplierId == null || _officeId == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text(
// // //               _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     final weight = double.parse(_weightCtrl.text);
// // //     final goldPrice = double.parse(_goldPriceCtrl.text);

// // //     try {
// // //       // 1️⃣ حفظ التسكيرة
// // //       await FS.addMinting(
// // //         supplierId: _supplierId!,
// // //         supplierName: _supplierName!,
// // //         officeId: _officeId!,
// // //         officeName: _officeName!,
// // //         carat: _carat,
// // //         weight: weight,
// // //         goldPrice: goldPrice,
// // //         paymentMethod: _paymentMethod,
// // //         date: DateTime.now(),
// // //       );

// // //       // 2️⃣ خصم ثمن الخام من الخزنة (دفع للمكتب)
// // //       await FS.deductFromCashBox(
// // //         amount: goldPrice,
// // //         method: _paymentMethod,
// // //         note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName',
// // //       );

// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(_t("تم إضافة التسكيرة وخصم ثمن الخام ✅",
// // //                 "Minting added and raw gold price deducted ✅")),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //         Navigator.pop(context);
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('${_t("خطأ", "Error")}: $e'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }

// // // // ============================================================
// // // // 🔹 ورقة تفاصيل التسكيرة (مع إمكانية الإغلاق)
// // // // ============================================================
// // // class MintingDetailsSheet extends StatefulWidget {
// // //   final String id;
// // //   final Map<String, dynamic> data;

// // //   const MintingDetailsSheet({super.key, required this.id, required this.data});

// // //   @override
// // //   State<MintingDetailsSheet> createState() => _MintingDetailsSheetState();
// // // }

// // // class _MintingDetailsSheetState extends State<MintingDetailsSheet> {
// // //   String _lang = 'ar';
// // //   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

// // //   final _sentWeightCtrl = TextEditingController();
// // //   final _returnedWeightCtrl = TextEditingController();
// // //   final _finalWageCtrl = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //     _sentWeightCtrl.text =
// // //         (widget.data['sentWeight'] ?? widget.data['weight'] ?? 0).toString();
// // //     _returnedWeightCtrl.text = (widget.data['returnedWeight'] ?? 0).toString();
// // //     _finalWageCtrl.text = (widget.data['finalWage'] ?? 0).toString();
// // //   }

// // //   Future<void> _loadLanguage() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       _lang = prefs.getString('languageCode') ?? 'ar';
// // //     });
// // //   }

// // //   bool get _isClosed => widget.data['status'] == 'closed';

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DraggableScrollableSheet(
// // //       initialChildSize: 0.9,
// // //       minChildSize: 0.5,
// // //       maxChildSize: 0.95,
// // //       builder: (_, scrollController) {
// // //         return Container(
// // //           decoration: const BoxDecoration(
// // //             color: Colors.white,
// // //             borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
// // //           ),
// // //           child: Column(
// // //             children: [
// // //               Container(
// // //                 margin: const EdgeInsets.only(top: 12),
// // //                 width: 40,
// // //                 height: 4,
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.grey.shade300,
// // //                   borderRadius: BorderRadius.circular(2),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               Expanded(
// // //                 child: ListView(
// // //                   controller: scrollController,
// // //                   padding: const EdgeInsets.all(16),
// // //                   children: [
// // //                     _buildHeader(),
// // //                     const Divider(height: 24),
// // //                     _buildInfoRow(),
// // //                     const Divider(height: 24),
// // //                     if (_isClosed) _buildClosedResult() else _buildCloseForm(),
// // //                     const SizedBox(height: 20),
// // //                     if (!_isClosed)
// // //                       ElevatedButton(
// // //                         style: ElevatedButton.styleFrom(
// // //                           backgroundColor: Colors.green,
// // //                           shape: RoundedRectangleBorder(
// // //                             borderRadius: BorderRadius.circular(12),
// // //                           ),
// // //                           minimumSize: const Size(double.infinity, 48),
// // //                         ),
// // //                         onPressed: _closeMinting,
// // //                         child: Text(
// // //                           _t("إغلاق التسكيرة", "Close Minting"),
// // //                           style: const TextStyle(
// // //                               color: Colors.white, fontSize: 16),
// // //                         ),
// // //                       ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget _buildHeader() {
// // //     return Row(
// // //       children: [
// // //         CircleAvatar(
// // //           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
// // //           child: const Icon(Icons.account_balance, color: Color(0xFFD4AF37)),
// // //         ),
// // //         const SizedBox(width: 12),
// // //         Expanded(
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 '#${widget.id} — ${widget.data['supplierName'] ?? ""}',
// // //                 style:
// // //                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// // //               ),
// // //               Text(
// // //                 '${widget.data['officeName'] ?? ""} • ${DateFormat("dd/MM/yyyy HH:mm").format((widget.data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
// // //                 style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         Container(
// // //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //           decoration: BoxDecoration(
// // //             color: _isClosed
// // //                 ? Colors.green.withOpacity(0.1)
// // //                 : Colors.orange.withOpacity(0.1),
// // //             borderRadius: BorderRadius.circular(12),
// // //           ),
// // //           child: Text(
// // //             _isClosed ? _t("مقفولة", "Closed") : _t("مفتوحة", "Open"),
// // //             style: TextStyle(
// // //               color: _isClosed ? Colors.green : Colors.orange,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildInfoRow() {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //       children: [
// // //         _detailItem(Icons.scale, _t("الوزن", "Weight"),
// // //             '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
// // //         _detailItem(
// // //             Icons.money, _t("العيار", "Carat"), widget.data['carat'] ?? ''),
// // //         _detailItem(Icons.payments, _t("ثمن الخام", "Raw Price"),
// // //             '${widget.data['goldPrice'] ?? 0} ${_t('جنيه', 'EGP')}'),
// // //         _detailItem(Icons.payment, _t("طريقة الدفع", "Payment Method"),
// // //             widget.data['paymentMethod'] ?? ''),
// // //       ],
// // //     );
// // //   }

// // //   Widget _detailItem(IconData icon, String label, String value) {
// // //     return Column(
// // //       children: [
// // //         Icon(icon, color: const Color(0xFFD4AF37), size: 20),
// // //         const SizedBox(height: 4),
// // //         Text(label,
// // //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// // //         Text(value,
// // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildClosedResult() {
// // //     final sent = double.tryParse(_sentWeightCtrl.text) ?? 0;
// // //     final returned = double.tryParse(_returnedWeightCtrl.text) ?? 0;
// // //     final diff = sent - returned;
// // //     final finalWage = double.tryParse(_finalWageCtrl.text) ?? 0;

// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade50,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: Colors.grey.shade300),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             _t("نتيجة التسكيرة", "Minting Result"),
// // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // //           ),
// // //           const SizedBox(height: 8),
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //             children: [
// // //               _resultItem(_t("مرسل", "Sent"),
// // //                   '${sent.toStringAsFixed(2)} ${_t('جم', 'g')}', Colors.blue),
// // //               _resultItem(
// // //                   _t("مستلم", "Received"),
// // //                   '${returned.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // //                   Colors.green),
// // //               _resultItem(
// // //                 _t("الفرق", "Diff"),
// // //                 '${diff.toStringAsFixed(2)} ${_t('جم', 'g')}',
// // //                 diff > 0 ? Colors.red : Colors.green,
// // //               ),
// // //               _resultItem(
// // //                   _t("المصنعية النهائية", "Final Wage"),
// // //                   '${finalWage.toStringAsFixed(2)} ${_t('جنيه', 'EGP')}',
// // //                   Colors.orange),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _resultItem(String label, String value, Color color) {
// // //     return Column(
// // //       children: [
// // //         Text(label,
// // //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
// // //         Text(value,
// // //             style: TextStyle(
// // //                 fontWeight: FontWeight.bold, fontSize: 14, color: color)),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildCloseForm() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade50,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: Colors.grey.shade300),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Text(
// // //             _t("إغلاق التسكيرة - إدخال النتائج",
// // //                 "Close Minting - Enter Results"),
// // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // //           ),
// // //           const SizedBox(height: 12),
// // //           TextFormField(
// // //             controller: _sentWeightCtrl,
// // //             decoration: InputDecoration(
// // //               labelText:
// // //                   _t("الوزن المرسل للمورد (جم)", "Weight sent to supplier (g)"),
// // //               border:
// // //                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // //               suffixText: _t("جم", "g"),
// // //             ),
// // //             keyboardType: TextInputType.number,
// // //           ),
// // //           const SizedBox(height: 8),
// // //           TextFormField(
// // //             controller: _returnedWeightCtrl,
// // //             decoration: InputDecoration(
// // //               labelText: _t("الوزن المستلم من المورد (جم)",
// // //                   "Weight received from supplier (g)"),
// // //               border:
// // //                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // //               suffixText: _t("جم", "g"),
// // //             ),
// // //             keyboardType: TextInputType.number,
// // //           ),
// // //           const SizedBox(height: 8),
// // //           TextFormField(
// // //             controller: _finalWageCtrl,
// // //             decoration: InputDecoration(
// // //               labelText: _t("المصنعية النهائية (جنيه)", "Final Wage (EGP)"),
// // //               border:
// // //                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
// // //               suffixText: _t("جنيه", "EGP"),
// // //             ),
// // //             keyboardType: TextInputType.number,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void _closeMinting() async {
// // //     final sent = double.tryParse(_sentWeightCtrl.text);
// // //     final returned = double.tryParse(_returnedWeightCtrl.text);
// // //     final finalWage = double.tryParse(_finalWageCtrl.text);

// // //     if (sent == null || returned == null || finalWage == null) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content:
// // //               Text(_t("يرجى إدخال أرقام صحيحة", "Please enter valid numbers")),
// // //           backgroundColor: Colors.orange,
// // //         ),
// // //       );
// // //       return;
// // //     }

// // //     try {
// // //       await FS.closeMinting(
// // //         widget.id,
// // //         sentWeight: sent,
// // //         returnedWeight: returned,
// // //         finalWage: finalWage,
// // //       );
// // //       if (mounted) {
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           SnackBar(
// // //             content: Text(_t("تم إغلاق التسكيرة ✅", "Minting closed ✅")),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //         Navigator.pop(context);
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('${_t("خطأ", "Error")}: $e'),
// // //           backgroundColor: Colors.red,
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }
// // // ============================================================
// // // 📄 ملف: MintingPage.dart (نسخة كاملة ومعدلة)
// // // ============================================================

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:intl/intl.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/firestore_service.dart'; // تأكد من وجود هذا المسار

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
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => const AddEditOfficeDialog(),
// //     );
// //   }

// //   void _showEditOfficeDialog(Map<String, dynamic> office) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => AddEditOfficeDialog(office: office),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.add, color: Colors.white),
// //             onPressed: _showAddOfficeDialog,
// //             tooltip: _t("إضافة مكتب", "Add Office"),
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
// //                   Text(
// //                     _t("لا توجد مكاتب", "No offices"),
// //                     style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     _t("اضغط على + لإضافة مكتب", "Tap + to add an office"),
// //                     style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
// //                   ),
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
// //       margin: const EdgeInsets.only(bottom: 10),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //       elevation: 2,
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
// //           child: const Icon(Icons.location_city, color: Color(0xFFD4AF37)),
// //         ),
// //         title: Text(data['name'] ?? ''),
// //         subtitle: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (data['address'] != null &&
// //                 data['address'].toString().isNotEmpty)
// //               Text('📍 ${data['address']}'),
// //             if (data['phone'] != null && data['phone'].toString().isNotEmpty)
// //               Text('📞 ${data['phone']}'),
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
// //             onPressed: () => Navigator.pop(context, false),
// //             child: Text(_t("إلغاء", "Cancel")),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             child: Text(_t("حذف", "Delete"),
// //                 style: const TextStyle(color: Colors.red)),
// //           ),
// //         ],
// //       ),
// //     );
// //     if (confirm == true) {
// //       await FS.deleteMintOffice(id);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(_t("تم حذف المكتب ✅", "Office deleted ✅")),
// //           backgroundColor: Colors.redAccent,
// //         ),
// //       );
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
// //           Icon(
// //             _isEditing ? Icons.edit : Icons.add_business,
// //             color: const Color(0xFFD4AF37),
// //           ),
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
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
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
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _phoneCtrl,
// //                 decoration: InputDecoration(
// //                   labelText: _t("رقم الهاتف", "Phone"),
// //                   prefixIcon: const Icon(Icons.phone, color: Color(0xFFD4AF37)),
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //                 keyboardType: TextInputType.phone,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       actions: [
// //         TextButton(
// //           onPressed: () => Navigator.pop(context),
// //           child: Text(_t("إلغاء", "Cancel")),
// //         ),
// //         ElevatedButton(
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: const Color(0xFFD4AF37),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //           ),
// //           onPressed: _submit,
// //           child: Text(
// //             _isEditing ? _t("تعديل", "Update") : _t("إضافة", "Add"),
// //             style: const TextStyle(
// //                 color: Colors.white, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   void _submit() async {
// //     if (!_formKey.currentState!.validate()) return;

// //     try {
// //       if (_isEditing) {
// //         await FS.updateMintOffice(
// //           widget.office!['id'],
// //           {
// //             'name': _nameCtrl.text.trim(),
// //             'address': _addressCtrl.text.trim(),
// //             'phone': _phoneCtrl.text.trim(),
// //           },
// //         );
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(_t("تم تعديل المكتب ✅", "Office updated ✅")),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       } else {
// //         await FS.addMintOffice(
// //           name: _nameCtrl.text.trim(),
// //           address: _addressCtrl.text.trim(),
// //           phone: _phoneCtrl.text.trim(),
// //         );
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(_t("تم إضافة المكتب ✅", "Office added ✅")),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //       }
// //       Navigator.pop(context);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('${_t("خطأ", "Error")}: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// // }

// // // ============================================================
// // // 🔹 صفحة التسكيرات الرئيسية (المعدلة بالكامل)
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
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (_) => const AddMintingDialog(),
// //     );
// //   }

// //   void _openOfficesManagement() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()),
// //     );
// //   }

// //   // فتح صفحة التسكيرات المغلقة
// //   void _openClosedMintings() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (_) => const ClosedMintingsPage()),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(_t("التسكيرات", "Minting")),
// //         backgroundColor: const Color(0xFFD4AF37),
// //         actions: [
// //           // زر المكتبة (التسكيرات المغلقة) في البار العلوي
// //           IconButton(
// //             icon: const Icon(Icons.folder, color: Colors.white),
// //             onPressed: _openClosedMintings,
// //             tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
// //           ),
// //           // زر إدارة المكاتب
// //           IconButton(
// //             icon: const Icon(Icons.settings, color: Colors.white),
// //             onPressed: _openOfficesManagement,
// //             tooltip: _t("إدارة المكاتب", "Manage Offices"),
// //           ),
// //         ],
// //       ),
// //       // زر إضافة تسكيرة في أسفل اليمين (FAB)
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: _showAddMintingDialog,
// //         backgroundColor: const Color(0xFFD4AF37),
// //         child: const Icon(Icons.add, color: Colors.white),
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FS.mintingsStream(),
// //         builder: (context, snap) {
// //           if (snap.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.account_balance,
// //                       size: 64, color: Colors.grey.shade300),
// //                   const SizedBox(height: 12),
// //                   Text(
// //                     _t("لا توجد تسكيرات", "No minting records"),
// //                     style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     _t("اضغط على + لإضافة تسكيرة جديدة",
// //                         "Tap + to add a new minting"),
// //                     style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
// //                   ),
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
// //               return _buildMintingCard(id, data);
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   // البطاقة الجديدة: تعرض البيانات فقط + زر إغلاق
// //   Widget _buildMintingCard(String id, Map<String, dynamic> data) {
// //     final status = data['status'] ?? 'open';
// //     final isClosed = status == 'closed';
// //     final supplierName = data['supplierName'] ?? '';
// //     final officeName = data['officeName'] ?? '';
// //     final weight = (data['weight'] ?? 0).toDouble();
// //     final carat = data['carat'] ?? '';
// //     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
// //     final manufacturing = (data['manufacturing'] ?? 0).toDouble();
// //     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

// //     Color statusColor = isClosed ? Colors.green : Colors.orange;

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
// //       elevation: 3,
// //       child: Padding(
// //         padding: const EdgeInsets.all(12),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // البيانات الأساسية
// //             Row(
// //               children: [
// //                 CircleAvatar(
// //                   backgroundColor: statusColor.withOpacity(0.15),
// //                   child: Icon(
// //                     isClosed ? Icons.lock_outline : Icons.lock_open,
// //                     color: statusColor,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         '#$id — $supplierName',
// //                         style: const TextStyle(
// //                             fontWeight: FontWeight.bold, fontSize: 16),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       Text(
// //                         '$officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
// //                         style: TextStyle(
// //                             fontSize: 13, color: Colors.grey.shade600),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Container(
// //                   padding:
// //                       const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
// //                   decoration: BoxDecoration(
// //                     color: statusColor.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Text(
// //                     isClosed ? _t("مقفولة", "Closed") : _t("مفتوحة", "Open"),
// //                     style: TextStyle(
// //                       color: statusColor,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),

// //             // عرض البيانات فقط (بدون إدخال نتائج)
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: [
// //                 _infoChip(
// //                     Icons.scale, '${weight.toStringAsFixed(2)} جم', carat),
// //                 _infoChip(Icons.money, '${goldPrice.toStringAsFixed(2)}',
// //                     _t('ثمن الخام', 'Raw Price')),
// //                 _infoChip(Icons.handyman, '${manufacturing.toStringAsFixed(2)}',
// //                     _t('مصنعية', 'Manuf.')),
// //                 _infoChip(Icons.payment, data['paymentMethod'] ?? '', ''),
// //               ],
// //             ),

// //             const SizedBox(height: 12),

// //             // زر إغلاق التسكيرة
// //             if (!isClosed)
// //               SizedBox(
// //                 width: double.infinity,
// //                 child: ElevatedButton.icon(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.red.shade400,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                   onPressed: () async {
// //                     // إغلاق التسكيرة
// //                     await FS.closeMinting(id,
// //                         sentWeight: weight,
// //                         returnedWeight: weight,
// //                         finalWage: manufacturing);
// //                     if (context.mounted) {
// //                       // الانتقال لصفحة التسكيرات المغلقة
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (_) => const ClosedMintingsPage()),
// //                       );
// //                     }
// //                   },
// //                   icon: const Icon(Icons.close, color: Colors.white),
// //                   label: Text(
// //                     _t("إغلاق التسكيرة", "Close Minting"),
// //                     style: const TextStyle(color: Colors.white),
// //                   ),
// //                 ),
// //               )
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _infoChip(IconData icon, String label, String sub,
// //       {Color color = Colors.grey}) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(icon, size: 14, color: color),
// //           const SizedBox(width: 4),
// //           Text(
// //             label,
// //             style: TextStyle(
// //                 fontSize: 12, fontWeight: FontWeight.w600, color: color),
// //           ),
// //           if (sub.isNotEmpty) ...[
// //             const SizedBox(width: 4),
// //             Text(
// //               sub,
// //               style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // ============================================================
// // // 🔹 صفحة التسكيرات المغلقة (جديدة)
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
// //         stream: FS.closedMintingsStream(),
// //         builder: (context, snap) {
// //           if (snap.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           }
// //           if (!snap.hasData || snap.data!.docs.isEmpty) {
// //             return const Center(child: Text("لا توجد تسكيرات مغلقة"));
// //           }
// //           final docs = snap.data!.docs;
// //           return ListView.builder(
// //             padding: const EdgeInsets.all(12),
// //             itemCount: docs.length,
// //             itemBuilder: (context, index) {
// //               final data = docs[index].data() as Map<String, dynamic>;
// //               final id = docs[index].id;
// //               return Card(
// //                 color: Colors.grey.shade100,
// //                 child: ListTile(
// //                   leading: const Icon(Icons.lock, color: Colors.green),
// //                   title: Text('#$id — ${data['supplierName'] ?? ""}'),
// //                   subtitle: Text(
// //                     '${data['officeName'] ?? ""} • ${DateFormat("dd/MM/yyyy").format((data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// // // ============================================================
// // // 🔹 حوار إضافة تسكيرة جديدة (مع إضافة حقل المصنعية)
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
// //   final _manufacturingCtrl = TextEditingController(); // حقل المصنعية
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
// //                       // ===== المورد =====
// //                       FutureBuilder(
// //                         future: FS.getSuppliers(),
// //                         builder: (context, snap) {
// //                           if (!snap.hasData) {
// //                             return const CircularProgressIndicator();
// //                           }
// //                           final suppliers = snap.data!;
// //                           return DropdownButtonFormField<String>(
// //                             decoration: InputDecoration(
// //                               labelText: _t("المورد (الذي سلم الذهب)",
// //                                   "Supplier (who gave gold)"),
// //                               prefixIcon: const Icon(Icons.business,
// //                                   color: Color(0xFFD4AF37)),
// //                               border: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(12),
// //                               ),
// //                             ),
// //                             value: _supplierId,
// //                             items: suppliers.map((s) {
// //                               return DropdownMenuItem<String>(
// //                                 value: s['id'],
// //                                 child: Text(s['name']),
// //                               );
// //                             }).toList(),
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

// //                       // ===== مكتب التسكيرات =====
// //                       DropdownButtonFormField<String>(
// //                         decoration: InputDecoration(
// //                           labelText: _t("مكتب التسكيرات (بائع الخام)",
// //                               "Mint Office (raw gold seller)"),
// //                           prefixIcon: const Icon(Icons.location_city,
// //                               color: Color(0xFFD4AF37)),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                         ),
// //                         value: _officeId,
// //                         items: _offices.map((o) {
// //                           return DropdownMenuItem<String>(
// //                             value: o['id'],
// //                             child: Text(o['name']),
// //                           );
// //                         }).toList(),
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

// //                       // ===== العيار والوزن =====
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 2,
// //                             child: DropdownButtonFormField<String>(
// //                               decoration: InputDecoration(
// //                                 labelText: _t("العيار", "Carat"),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                               ),
// //                               value: _carat,
// //                               items: ['18', '21', '22'].map((c) {
// //                                 return DropdownMenuItem<String>(
// //                                     value: c, child: Text(c));
// //                               }).toList(),
// //                               onChanged: (v) => setState(() => _carat = v!),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 12),
// //                           Expanded(
// //                             flex: 3,
// //                             child: TextFormField(
// //                               controller: _weightCtrl,
// //                               decoration: InputDecoration(
// //                                 labelText: _t("الوزن (جم) المطلوب شراؤه",
// //                                     "Weight (g) to purchase"),
// //                                 border: OutlineInputBorder(
// //                                   borderRadius: BorderRadius.circular(12),
// //                                 ),
// //                                 suffixText: _t("جم", "g"),
// //                               ),
// //                               keyboardType: TextInputType.number,
// //                               validator: (v) {
// //                                 if (v == null || v.isEmpty)
// //                                   return _t("مطلوب", "Required");
// //                                 if (double.tryParse(v) == null)
// //                                   return _t("رقم غير صحيح", "Invalid number");
// //                                 return null;
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 12),

// //                       // ===== ثمن الخام =====
// //                       TextFormField(
// //                         controller: _goldPriceCtrl,
// //                         decoration: InputDecoration(
// //                           labelText: _t(
// //                               "ثمن الذهب الخام (جنيه)", "Raw gold price (EGP)"),
// //                           prefixIcon:
// //                               const Icon(Icons.money, color: Color(0xFFD4AF37)),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           suffixText: _t("جنيه", "EGP"),
// //                         ),
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

// //                       // ===== حقل المصنعية الجديد =====
// //                       TextFormField(
// //                         controller: _manufacturingCtrl,
// //                         decoration: InputDecoration(
// //                           labelText:
// //                               _t("المصنعية (جنيه)", "Manufacturing (EGP)"),
// //                           prefixIcon: const Icon(Icons.handyman,
// //                               color: Color(0xFFD4AF37)),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           suffixText: _t("جنيه", "EGP"),
// //                         ),
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

// //                       // طريقة الدفع للمكتب
// //                       DropdownButtonFormField<String>(
// //                         decoration: InputDecoration(
// //                           labelText: _t(
// //                               "طريقة الدفع للمكتب", "Payment method to office"),
// //                           prefixIcon: const Icon(Icons.payment,
// //                               color: Color(0xFFD4AF37)),
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                         ),
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
// //           onPressed: () => Navigator.pop(context),
// //           child: Text(_t("إلغاء", "Cancel")),
// //         ),
// //         ElevatedButton(
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: const Color(0xFFD4AF37),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //           ),
// //           onPressed: _submit,
// //           child: Text(
// //             _t("حفظ", "Save"),
// //             style: const TextStyle(
// //                 color: Colors.white, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   void _submit() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     if (_supplierId == null || _officeId == null) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(
// //               _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
// //           backgroundColor: Colors.orange,
// //         ),
// //       );
// //       return;
// //     }

// //     final weight = double.parse(_weightCtrl.text);
// //     final goldPrice = double.parse(_goldPriceCtrl.text);
// //     final manufacturing =
// //         double.parse(_manufacturingCtrl.text); // قراءة المصنعية

// //     try {
// //       // 1️⃣ حفظ التسكيرة مع المصنعية
// //       await FS.addMinting(
// //         supplierId: _supplierId!,
// //         supplierName: _supplierName!,
// //         officeId: _officeId!,
// //         officeName: _officeName!,
// //         carat: _carat,
// //         weight: weight,
// //         goldPrice: goldPrice,
// //         manufacturing: manufacturing, // إرسال المصنعية
// //         paymentMethod: _paymentMethod,
// //         date: DateTime.now(),
// //       );

// //       // 2️⃣ الخصم مباشرة من الخزنة (تم إلغاء رسالة "لا يوجد رصيد كافٍ" في السيرفس)
// //       // لن تظهر رسالة حمراء حتى لو كان الرصيد 0.
// //       await FS.deductFromCashBox(
// //         amount: goldPrice,
// //         method: _paymentMethod,
// //         note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName',
// //       );

// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text(_t("تم إضافة التسكيرة وخصم ثمن الخام ✅",
// //                 "Minting added and raw gold price deducted ✅")),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         Navigator.pop(context);
// //       }
// //     } catch (e) {
// //       // بما أن السيرفس تم تعديله، لن يصل هذا الخطأ هنا بسبب الرصيد
// //       if (mounted) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('${_t("خطأ", "Error")}: $e'),
// //             backgroundColor: Colors.red,
// //           ),
// //         );
// //       }
// //     }
// //   }
// // }
// // ============================================================
// // 📄 ملف: MintingPage.dart (نسخة كاملة ومعدلة - حل مشكلة ظهور البيانات)
// // ============================================================

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
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const AddEditOfficeDialog(),
//     );
//   }

//   void _showEditOfficeDialog(Map<String, dynamic> office) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AddEditOfficeDialog(office: office),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("مكاتب التسكيرات", "Mint Offices")),
//         backgroundColor: const Color(0xFFD4AF37),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add, color: Colors.white),
//             onPressed: _showAddOfficeDialog,
//             tooltip: _t("إضافة مكتب", "Add Office"),
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
//       margin: const EdgeInsets.only(bottom: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       elevation: 2,
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
//           child: const Icon(Icons.location_city, color: Color(0xFFD4AF37)),
//         ),
//         title: Text(data['name'] ?? '',
//             maxLines: 1, overflow: TextOverflow.ellipsis),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (data['address'] != null &&
//                 data['address'].toString().isNotEmpty)
//               Text('📍 ${data['address']}',
//                   maxLines: 1, overflow: TextOverflow.ellipsis),
//             if (data['phone'] != null && data['phone'].toString().isNotEmpty)
//               Text('📞 ${data['phone']}'),
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
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_t("تم حذف المكتب ✅", "Office deleted ✅")),
//           backgroundColor: Colors.redAccent,
//         ),
//       );
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
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("تم تعديل المكتب ✅"), backgroundColor: Colors.green));
//       } else {
//         await FS.addMintOffice(
//           name: _nameCtrl.text.trim(),
//           address: _addressCtrl.text.trim(),
//           phone: _phoneCtrl.text.trim(),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("تم إضافة المكتب ✅"), backgroundColor: Colors.green));
//       }
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//     }
//   }
// }

// // ============================================================
// // 🔹 صفحة التسكيرات الرئيسية (معدلة للفلترة داخل الواجهة)
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
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const AddMintingDialog(),
//     );
//   }

//   void _openOfficesManagement() {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (_) => const MintOfficesManagementPage()));
//   }

//   void _openClosedMintings() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (_) => const ClosedMintingsPage()));
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
//           IconButton(
//             icon: const Icon(Icons.folder, color: Colors.white),
//             onPressed: _openClosedMintings,
//             tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.white),
//             onPressed: _openOfficesManagement,
//             tooltip: _t("إدارة المكاتب", "Manage Offices"),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddMintingDialog,
//         backgroundColor: const Color(0xFFD4AF37),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         // تم التعديل: استخدام mintingsStream (تجلب الكل) للفلترة محلياً
//         stream: FS.mintingsStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
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

//           // 🛠️ الفلترة هنا: نجلب كل الدوكس ونعرض فقط التي حالتها "open" أو التي لا يوجد بها status (لتسكيرات قديمة)
//           final allDocs = snap.data!.docs;
//           final openDocs = allDocs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final status =
//                 data['status'] ?? 'open'; // الافتراضي مفتوح لو مش موجود
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
//             padding: const EdgeInsets.all(12),
//             itemCount: openDocs.length,
//             itemBuilder: (ctx, index) {
//               final data = openDocs[index].data() as Map<String, dynamic>;
//               final id = openDocs[index].id;
//               return _buildMintingCard(id, data);
//             },
//           );
//         },
//       ),
//     );
//   }

//   // البطاقة الجديدة: تم إصلاح حجمها واستخدام Wrap
//   Widget _buildMintingCard(String id, Map<String, dynamic> data) {
//     final status = data['status'] ?? 'open';
//     final isClosed = status == 'closed';
//     final supplierName = data['supplierName'] ?? '';
//     final officeName = data['officeName'] ?? '';
//     final weight = (data['weight'] ?? 0).toDouble();
//     final carat = data['carat'] ?? '';
//     final goldPrice = (data['goldPrice'] ?? 0).toDouble();
//     final manufacturing = (data['manufacturing'] ?? 0).toDouble();
//     final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

//     Color statusColor = isClosed ? Colors.green : Colors.orange;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 10),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       elevation: 3,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () => _showMintingDetails(id, data),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // البيانات الأساسية
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: statusColor.withOpacity(0.15),
//                     child: Icon(isClosed ? Icons.lock_outline : Icons.lock_open,
//                         color: statusColor),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('#$id — $supplierName',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                         Text(
//                             '$officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
//                             style: TextStyle(
//                                 fontSize: 13, color: Colors.grey.shade600),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                         isClosed
//                             ? _t("مقفولة", "Closed")
//                             : _t("مفتوحة", "Open"),
//                         style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12)),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // 🛠️ Wrap لحل مشكلة حجم الشاشة
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   _infoChip(
//                       Icons.scale, '${weight.toStringAsFixed(2)} جم', carat),
//                   _infoChip(Icons.money, '${goldPrice.toStringAsFixed(2)}',
//                       _t('ثمن الخام', 'Raw Price')),
//                   _infoChip(
//                       Icons.handyman,
//                       '${manufacturing.toStringAsFixed(2)}',
//                       _t('مصنعية', 'Manuf.')),
//                   _infoChip(Icons.payment, data['paymentMethod'] ?? '', ''),
//                 ],
//               ),

//               const SizedBox(height: 12),

//               if (!isClosed)
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade400,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                     onPressed: () async {
//                       await FS.closeMinting(id,
//                           sentWeight: weight,
//                           returnedWeight: weight,
//                           finalWage: manufacturing);
//                       if (context.mounted) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const ClosedMintingsPage()));
//                       }
//                     },
//                     icon: const Icon(Icons.close, color: Colors.white),
//                     label: Text(_t("إغلاق التسكيرة", "Close Minting"),
//                         style: const TextStyle(color: Colors.white)),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _infoChip(IconData icon, String label, String sub,
//       {Color color = Colors.grey}) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 14, color: color),
//           const SizedBox(width: 4),
//           Text(label,
//               style: TextStyle(
//                   fontSize: 12, fontWeight: FontWeight.w600, color: color)),
//           if (sub.isNotEmpty) ...[
//             const SizedBox(width: 4),
//             Text(sub,
//                 style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 صفحة التسكيرات المغلقة (فلترة محلية)
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
//         // تم التعديل: استخدام mintingsStream (تجلب الكل) للفلترة محلياً
//         stream: FS.mintingsStream(),
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snap.hasData || snap.data!.docs.isEmpty) {
//             return const Center(child: Text("لا توجد تسكيرات مغلقة"));
//           }

//           // 🛠️ الفلترة هنا: نجلب كل الدوكس ونعرض فقط التي حالتها "closed"
//           final allDocs = snap.data!.docs;
//           final closedDocs = allDocs.where((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             final status = data['status'] ?? 'open';
//             return status == 'closed';
//           }).toList();

//           if (closedDocs.isEmpty) {
//             return const Center(child: Text("لا توجد تسكيرات مغلقة"));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: closedDocs.length,
//             itemBuilder: (context, index) {
//               final data = closedDocs[index].data() as Map<String, dynamic>;
//               final id = closedDocs[index].id;
//               return Card(
//                 color: Colors.grey.shade100,
//                 child: ListTile(
//                   leading: const Icon(Icons.lock, color: Colors.green),
//                   title: Text('#$id — ${data['supplierName'] ?? ""}',
//                       maxLines: 1, overflow: TextOverflow.ellipsis),
//                   subtitle: Text(
//                     '${data['officeName'] ?? ""} • ${DateFormat("dd/MM/yyyy").format((data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // ============================================================
// // 🔹 حوار إضافة تسكيرة جديدة (مع إضافة حقل المصنعية)
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
//                           if (!snap.hasData) {
//                             return const CircularProgressIndicator();
//                           }
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
//                             items: suppliers.map((s) {
//                               return DropdownMenuItem<String>(
//                                 value: s['id'],
//                                 child: Text(s['name'],
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis),
//                               );
//                             }).toList(),
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
//                         items: _offices.map((o) {
//                           return DropdownMenuItem<String>(
//                             value: o['id'],
//                             child: Text(o['name'],
//                                 maxLines: 1, overflow: TextOverflow.ellipsis),
//                           );
//                         }).toList(),
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
//                             flex: 2,
//                             child: DropdownButtonFormField<String>(
//                               decoration: InputDecoration(
//                                 labelText: _t("العيار", "Carat"),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                               ),
//                               value: _carat,
//                               items: ['18', '21', '22'].map((c) {
//                                 return DropdownMenuItem<String>(
//                                     value: c, child: Text(c));
//                               }).toList(),
//                               onChanged: (v) => setState(() => _carat = v!),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             flex: 3,
//                             child: TextFormField(
//                               controller: _weightCtrl,
//                               decoration: InputDecoration(
//                                 labelText: _t("الوزن (جم) المطلوب شراؤه",
//                                     "Weight (g) to purchase"),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12)),
//                                 suffixText: _t("جم", "g"),
//                               ),
//                               keyboardType: TextInputType.number,
//                               validator: (v) {
//                                 if (v == null || v.isEmpty)
//                                   return _t("مطلوب", "Required");
//                                 if (double.tryParse(v) == null)
//                                   return _t("رقم غير صحيح", "Invalid number");
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _goldPriceCtrl,
//                         decoration: InputDecoration(
//                           labelText: _t(
//                               "ثمن الذهب الخام (جنيه)", "Raw gold price (EGP)"),
//                           prefixIcon:
//                               const Icon(Icons.money, color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           suffixText: _t("جنيه", "EGP"),
//                         ),
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
//                           labelText:
//                               _t("المصنعية (جنيه)", "Manufacturing (EGP)"),
//                           prefixIcon: const Icon(Icons.handyman,
//                               color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                           suffixText: _t("جنيه", "EGP"),
//                         ),
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
//                           labelText: _t(
//                               "طريقة الدفع للمكتب", "Payment method to office"),
//                           prefixIcon: const Icon(Icons.payment,
//                               color: Color(0xFFD4AF37)),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12)),
//                         ),
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
//             backgroundColor: const Color(0xFFD4AF37),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           ),
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
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(
//                 _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
//             backgroundColor: Colors.orange),
//       );
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
//         amount: goldPrice,
//         method: _paymentMethod,
//         note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName',
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("تم إضافة التسكيرة وخصم ثمن الخام ✅"),
//               backgroundColor: Colors.green),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
//       }
//     }
//   }
// }

// // ============================================================
// // 🔹 ورقة تفاصيل التسكيرة (تُفتح عند الضغط على البطاقة)
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
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: ListView(
//                   controller: scrollController,
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundColor:
//                               const Color(0xFFD4AF37).withOpacity(0.15),
//                           child: const Icon(Icons.account_balance,
//                               color: Color(0xFFD4AF37)),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                   '#${widget.id} — ${widget.data['supplierName'] ?? ""}',
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                               Text(
//                                   '${widget.data['officeName'] ?? ""} • ${DateFormat("dd/MM/yyyy HH:mm").format((widget.data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
//                                   style: TextStyle(
//                                       color: Colors.grey.shade600,
//                                       fontSize: 14),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: (widget.data['status'] == 'closed')
//                                 ? Colors.green.withOpacity(0.1)
//                                 : Colors.orange.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             (widget.data['status'] == 'closed')
//                                 ? _t("مقفولة", "Closed")
//                                 : _t("مفتوحة", "Open"),
//                             style: TextStyle(
//                               color: (widget.data['status'] == 'closed')
//                                   ? Colors.green
//                                   : Colors.orange,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(height: 24),
//                     Wrap(
//                       spacing: 16,
//                       runSpacing: 16,
//                       children: [
//                         _detailItem(Icons.scale, _t("الوزن", "Weight"),
//                             '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
//                         _detailItem(Icons.money, _t("العيار", "Carat"),
//                             widget.data['carat'] ?? ''),
//                         _detailItem(
//                             Icons.payments,
//                             _t("ثمن الخام", "Raw Price"),
//                             '${widget.data['goldPrice'] ?? 0} ${_t('جنيه', 'EGP')}'),
//                         _detailItem(
//                             Icons.handyman,
//                             _t("المصنعية", "Manufacturing"),
//                             '${widget.data['manufacturing'] ?? 0} ${_t('جنيه', 'EGP')}'),
//                         _detailItem(
//                             Icons.payment,
//                             _t("طريقة الدفع", "Payment Method"),
//                             widget.data['paymentMethod'] ?? ''),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _detailItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: const Color(0xFFD4AF37), size: 20),
//         const SizedBox(height: 4),
//         Text(label,
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//         Text(value,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//       ],
//     );
//   }
// }
// ============================================================
// 📄 ملف: MintingPage.dart (نسخة التصميم الجديد والمنظم)
// ============================================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';

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
// 🔹 صفحة التسكيرات الرئيسية (التصميم المحسن والمنظم)
// ============================================================
class MintingPage extends StatefulWidget {
  const MintingPage({super.key});

  @override
  State<MintingPage> createState() => _MintingPageState();
}

class _MintingPageState extends State<MintingPage> {
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

  void _showAddMintingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AddMintingDialog());
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
          // إضافة مسافات للأيقونات في الأعلى
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: const Icon(Icons.history, color: Colors.white, size: 28),
              onPressed: _openClosedMintings,
              tooltip: _t("التسكيرات المغلقة", "Closed Mintings"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.business, color: Colors.white, size: 28),
              onPressed: _openOfficesManagement,
              tooltip: _t("إدارة المكاتب", "Manage Offices"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMintingDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FS.mintingsStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snap.hasData || snap.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Text(
                      _t("اضغط على + لإضافة تسكيرة جديدة",
                          "Tap + to add a new minting"),
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                ],
              ),
            );
          }

          // الفلترة داخل الواجهة
          final allDocs = snap.data!.docs;
          final openDocs = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final status = data['status'] ?? 'open';
            return status == 'open';
          }).toList();

          if (openDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(_t("لا توجد تسكيرات مفتوحة", "No open minting records"),
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                ],
              ),
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
      ),
    );
  }

  Widget _buildMintingCard(String id, Map<String, dynamic> data,
      {required bool isClosed}) {
    final supplierName = data['supplierName'] ?? '';
    final officeName = data['officeName'] ?? '';
    final weight = (data['weight'] ?? 0).toDouble();
    final carat = data['carat'] ?? '';
    final goldPrice = (data['goldPrice'] ?? 0).toDouble();
    final manufacturing = (data['manufacturing'] ?? 0).toDouble();
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

    Color statusColor = isClosed ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showMintingDetails(id, data),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: statusColor.withOpacity(0.15),
                    child: Icon(isClosed ? Icons.lock_outline : Icons.lock_open,
                        color: statusColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(supplierName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                            ' $officeName • ${DateFormat("dd/MM/yyyy").format(date)}',
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
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                        isClosed
                            ? _t("مقفولة", "Closed")
                            : _t("مفتوحة", "Open"),
                        style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🛠️ تصميم المعلومات بشكل منظم ومتباعد (بدون تلاصق)
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade50,
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(color: Colors.grey.shade200),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           _detailItem(Icons.scale, _t("الوزن", "Weight"),
              //               '${weight.toStringAsFixed(2)} جم'),
              //           _detailItem(Icons.diamond_outlined,
              //               _t("العيار", "Carat"), carat),
              //         ],
              //       ),
              //       const SizedBox(height: 16),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           _detailItem(Icons.money, _t("ثمن الخام", "Raw Price"),
              //               '${goldPrice.toStringAsFixed(2)} ريال'),
              //           _detailItem(Icons.handyman, _t("المصنعية", "Manuf."),
              //               '${manufacturing.toStringAsFixed(2)} ريال'),
              //         ],
              //       ),
              //       const SizedBox(height: 16),
              //       Align(
              //         alignment: Alignment.centerRight,
              //         child: _detailItem(Icons.payment, _t("الدفع", "Payment"),
              //             data['paymentMethod'] ?? ''),
              //       ),
              //     ],
              //   ),
              // ),

              const SizedBox(height: 16),

              if (!isClosed)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      await FS.closeMinting(id,
                          sentWeight: weight,
                          returnedWeight: weight,
                          finalWage: manufacturing);
                      if (context.mounted)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ClosedMintingsPage()));
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: Text(_t("إغلاق التسكيرة", "Close Minting"),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء عنصر التفاصيل بشكل أنيق
  Widget _detailItem(IconData icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 🔹 صفحة التسكيرات المغلقة (بنفس التصميم المنظم)
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
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (!snap.hasData || snap.data!.docs.isEmpty)
            return const Center(child: Text("لا توجد تسكيرات مغلقة"));

          final allDocs = snap.data!.docs;
          final closedDocs = allDocs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['status'] ?? 'open') == 'closed';
          }).toList();

          if (closedDocs.isEmpty)
            return const Center(child: Text("لا توجد تسكيرات مغلقة"));

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

// بطاقة مغلقة بنفس تصميم البطاقة المفتوحة (بدون زر إغلاق)
class ClosedMintingsCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const ClosedMintingsCard({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    final supplierName = data['supplierName'] ?? '';
    final officeName = data['officeName'] ?? '';
    final weight = (data['weight'] ?? 0).toDouble();
    final carat = data['carat'] ?? '';
    final goldPrice = (data['goldPrice'] ?? 0).toDouble();
    final manufacturing = (data['manufacturing'] ?? 0).toDouble();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(
                            ' $officeName •  ${DateFormat("dd/MM/yyyy").format(date)}',
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
              const SizedBox(height: 20),
              // نفس التصميم المنظم
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(color: Colors.grey.shade200),
              //   ),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           _detailItem(Icons.scale, "الوزن",
              //               '${weight.toStringAsFixed(2)} جم'),
              //           _detailItem(Icons.diamond_outlined, "العيار", carat),
              //         ],
              //       ),
              //       const SizedBox(height: 16),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           _detailItem(Icons.money, "ثمن الخام",
              //               '${goldPrice.toStringAsFixed(2)} ريال'),
              //           _detailItem(Icons.handyman, "المصنعية",
              //               '${manufacturing.toStringAsFixed(2)} ريال'),
              //         ],
              //       ),
              //       const SizedBox(height: 16),
              //       Align(
              //         alignment: Alignment.centerRight,
              //         child: _detailItem(
              //             Icons.payment, "الدفع", data['paymentMethod'] ?? ''),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// 🔹 حوار إضافة تسكيرة جديدة (بالريال)
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
  String _carat = '21';
  final _weightCtrl = TextEditingController();
  final _goldPriceCtrl = TextEditingController();
  final _manufacturingCtrl = TextEditingController();
  String _paymentMethod = 'cash';

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
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadOffices() async {
    setState(() => _isLoading = true);
    try {
      final list = await FS.getMintOffices();
      setState(() {
        _offices = list;
        if (_offices.isNotEmpty) {
          _officeId = _offices.first['id'];
          _officeName = _offices.first['name'];
        }
      });
    } catch (e) {
      print('Error loading offices: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                      FutureBuilder(
                        future: FS.getSuppliers(),
                        builder: (context, snap) {
                          if (!snap.hasData)
                            return const CircularProgressIndicator();
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
                                    value: s['id'],
                                    child: Text(s['name'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _supplierId = v;
                                _supplierName = suppliers
                                    .firstWhere((s) => s['id'] == v)['name'];
                              });
                            },
                            validator: (v) => v == null
                                ? _t("اختر مورد", "Select supplier")
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: _t("مكتب التسكيرات (بائع الخام)",
                              "Mint Office (raw gold seller)"),
                          prefixIcon: const Icon(Icons.location_city,
                              color: Color(0xFFD4AF37)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        value: _officeId,
                        items: _offices
                            .map((o) => DropdownMenuItem<String>(
                                value: o['id'],
                                child: Text(o['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _officeId = v;
                            _officeName = _offices
                                .firstWhere((o) => o['id'] == v)['name'];
                          });
                        },
                        validator: (v) =>
                            v == null ? _t("اختر مكتب", "Select office") : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                    labelText: _t("العيار", "Carat"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                value: _carat,
                                items: ['18', '21', '22']
                                    .map((c) => DropdownMenuItem<String>(
                                        value: c, child: Text(c)))
                                    .toList(),
                                onChanged: (v) => setState(() => _carat = v!),
                              )),
                          const SizedBox(width: 12),
                          Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _weightCtrl,
                                decoration: InputDecoration(
                                    labelText: _t("الوزن (جم) المطلوب شراؤه",
                                        "Weight (g)"),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    suffixText: _t("جم", "g")),
                                keyboardType: TextInputType.number,
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return _t("مطلوب", "Required");
                                  if (double.tryParse(v) == null)
                                    return _t("رقم غير صحيح", "Invalid number");
                                  return null;
                                },
                              )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _goldPriceCtrl,
                        decoration: InputDecoration(
                            labelText: _t("ثمن الذهب الخام (ريال)",
                                "Raw gold price (SAR)"),
                            prefixIcon: const Icon(Icons.money,
                                color: Color(0xFFD4AF37)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            suffixText: _t("ريال", "SAR")),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return _t("مطلوب", "Required");
                          if (double.tryParse(v) == null)
                            return _t("رقم غير صحيح", "Invalid number");
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
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
                          if (v == null || v.isEmpty)
                            return _t("مطلوب", "Required");
                          if (double.tryParse(v) == null)
                            return _t("رقم غير صحيح", "Invalid number");
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText:
                                _t("طريقة الدفع للمكتب", "Payment method"),
                            prefixIcon: const Icon(Icons.payment,
                                color: Color(0xFFD4AF37)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        value: _paymentMethod,
                        items: const [
                          DropdownMenuItem<String>(
                              value: 'cash', child: Text('كاش')),
                          DropdownMenuItem<String>(
                              value: 'network', child: Text('شبكة')),
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
    if (_supplierId == null || _officeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              _t("يرجى اختيار المورد والمكتب", "Select supplier and office")),
          backgroundColor: Colors.orange));
      return;
    }

    final weight = double.parse(_weightCtrl.text);
    final goldPrice = double.parse(_goldPriceCtrl.text);
    final manufacturing = double.parse(_manufacturingCtrl.text);

    try {
      await FS.addMinting(
        supplierId: _supplierId!,
        supplierName: _supplierName!,
        officeId: _officeId!,
        officeName: _officeName!,
        carat: _carat,
        weight: weight,
        goldPrice: goldPrice,
        manufacturing: manufacturing,
        paymentMethod: _paymentMethod,
        date: DateTime.now(),
      );

      await FS.deductFromCashBox(
          amount: goldPrice,
          method: _paymentMethod,
          note: 'شراء ذهب خام من مكتب $_officeName للمورد $_supplierName');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("تم إضافة التسكيرة وخصم ثمن الخام ✅"),
            backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    }
  }
}

// ============================================================
// 🔹 ورقة تفاصيل التسكيرة (تحسين هائل: تحويلها لصفوف منظمة)
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
                    // رأس التفاصيل
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
                                      fontSize: 24),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('${widget.data['officeName'] ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  '${DateFormat("dd/MM/yyyy HH:mm").format((widget.data['date'] as Timestamp?)?.toDate() ?? DateTime.now())}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: (widget.data['status'] == 'closed')
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
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
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),

                    // 🛠️ قائمة التفاصيل الأنيقة (بدون تراص)
                    Text(_t("بيانات التسكيرة", "Minting Details"),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.scale, _t("الوزن", "Weight"),
                        '${widget.data['weight'] ?? 0} ${_t('جم', 'g')}'),
                    _buildDetailRow(Icons.diamond_outlined,
                        _t("العيار", "Carat"), widget.data['carat'] ?? ''),
                    _buildDetailRow(Icons.money, _t("ثمن الخام", "Raw Price"),
                        '${widget.data['goldPrice'] ?? 0} ${_t('ريال', 'SAR')}'),
                    _buildDetailRow(
                        Icons.handyman,
                        _t("المصنعية", "Manufacturing"),
                        '${widget.data['manufacturing'] ?? 0} ${_t('ريال', 'SAR')}'),
                    _buildDetailRow(
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

  // 🛠️ دالة لبناء صف أنيق في التفاصيل
  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
