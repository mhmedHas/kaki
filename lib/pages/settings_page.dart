// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:restart_app/restart_app.dart';
// // // // import 'dart:typed_data';
// // // // import 'package:image_picker/image_picker.dart';
// // // // import 'package:image/image.dart' as imglib;
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'label_layout_editor.dart';

// // // // enum CodeDisplayMode { qr, barcode }

// // // // enum ReportFrequency { daily, weekly, monthly }

// // // // // ======== تعريف وضع الماسح الضوئي ========
// // // // enum ScannerMode { primary, secondary }

// // // // // ======== نموذج الباسورد ========
// // // // class PasswordEntry {
// // // //   final String id;
// // // //   final String name;
// // // //   final String password;
// // // //   final List<String> pages;

// // // //   PasswordEntry({
// // // //     required this.id,
// // // //     required this.name,
// // // //     required this.password,
// // // //     required this.pages,
// // // //   });

// // // //   Map<String, dynamic> toJson() => {
// // // //         'id': id,
// // // //         'name': name,
// // // //         'password': password,
// // // //         'pages': pages,
// // // //       };

// // // //   factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
// // // //         id: json['id'],
// // // //         name: json['name'] ?? '',
// // // //         password: json['password'],
// // // //         pages: List<String>.from(json['pages'] ?? []),
// // // //       );
// // // // }

// // // // // ======== دوال حفظ وجلب الباسوردات (global) ========
// // // // Future<void> savePasswordEntries(List<PasswordEntry> entries) async {
// // // //   final prefs = await SharedPreferences.getInstance();
// // // //   final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
// // // //   await prefs.setStringList('passwordEntries', encoded);
// // // // }

// // // // Future<List<PasswordEntry>> loadPasswordEntries() async {
// // // //   final prefs = await SharedPreferences.getInstance();
// // // //   final encoded = prefs.getStringList('passwordEntries') ?? [];
// // // //   return encoded.map((s) => PasswordEntry.fromJson(jsonDecode(s))).toList();
// // // // }

// // // // // ======== checkPassword (global - بتشتغل مع النظام الجديد) ========
// // // // Future<bool> checkPassword(BuildContext context, String pageKey) async {
// // // //   final entries = await loadPasswordEntries();

// // // //   // إيجاد كل الباسوردات اللي بتحمي الصفحة دي
// // // //   final guardingEntries =
// // // //       entries.where((e) => e.pages.contains(pageKey)).toList();

// // // //   // لو مفيش باسورد بيحمي الصفحة → افتح عادي
// // // //   if (guardingEntries.isEmpty) return true;

// // // //   final controller = TextEditingController();
// // // //   bool accessGranted = false;

// // // //   await showDialog(
// // // //     context: context,
// // // //     barrierDismissible: false,
// // // //     builder: (_) => AlertDialog(
// // // //       title: const Text("أدخل الرقم السري"),
// // // //       content: TextField(
// // // //         controller: controller,
// // // //         obscureText: true,
// // // //         autofocus: true,
// // // //         decoration: const InputDecoration(
// // // //           hintText: "الرقم السري",
// // // //           border: OutlineInputBorder(),
// // // //         ),
// // // //         onSubmitted: (_) {
// // // //           final typed = controller.text.trim();
// // // //           final valid = guardingEntries.any((e) => e.password == typed);
// // // //           if (valid) {
// // // //             accessGranted = true;
// // // //             Navigator.pop(context);
// // // //           } else {
// // // //             ScaffoldMessenger.of(context).showSnackBar(
// // // //               const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// // // //             );
// // // //           }
// // // //         },
// // // //       ),
// // // //       actions: [
// // // //         TextButton(
// // // //           onPressed: () => Navigator.pop(context),
// // // //           child: const Text("إلغاء"),
// // // //         ),
// // // //         TextButton(
// // // //           onPressed: () {
// // // //             final typed = controller.text.trim();
// // // //             final valid = guardingEntries.any((e) => e.password == typed);
// // // //             if (valid) {
// // // //               accessGranted = true;
// // // //               Navigator.pop(context);
// // // //             } else {
// // // //               ScaffoldMessenger.of(context).showSnackBar(
// // // //                 const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// // // //               );
// // // //             }
// // // //           },
// // // //           child: const Text("تأكيد"),
// // // //         ),
// // // //       ],
// // // //     ),
// // // //   );

// // // //   return accessGranted;
// // // // }

// // // // // ======== SettingsPage ========
// // // // class SettingsPage extends StatefulWidget {
// // // //   const SettingsPage({super.key});

// // // //   @override
// // // //   State<SettingsPage> createState() => _SettingsPageState();
// // // // }

// // // // class _SettingsPageState extends State<SettingsPage> {
// // // //   static String get uid => FirebaseAuth.instance.currentUser!.uid;

// // // //   CodeDisplayMode _mode = CodeDisplayMode.qr;
// // // //   ReportFrequency _frequency = ReportFrequency.daily;

// // // //   // ✅ وضع الماسح الضوئي
// // // //   ScannerMode _scannerMode = ScannerMode.secondary;

// // // //   final TextEditingController _userController = TextEditingController();

// // // //   List<String> _userNames = [];
// // // //   Map<String, int> _pagePowers = {};

// // // //   String _selectedLanguage = 'ar';
// // // //   bool _isArabic = true;

// // // //   String _t(String ar, String en) => _isArabic ? ar : en;

// // // //   Uint8List? _logoImageBytes;
// // // //   String? _logoBase64;

// // // //   // ======== نظام الباسوردات الجديد ========
// // // //   List<PasswordEntry> _passwordEntries = [];

// // // //   // ======== الصفحات المتاحة ========
// // // //   Map<String, String> get _allPages => _isArabic
// // // //       ? {
// // // //           'reports': 'صفحة التقارير',
// // // //           'inventory': 'صفحة الجرد',
// // // //           'Setting': 'صفحة الإعدادات',
// // // //           'Input': 'صفحة الإدخال والرصيد الافتتاحي',
// // // //           'Daily': 'صفحة الحركة اليومية',
// // // //           'scrap': 'صفحة الكسر',
// // // //           'sales': 'صفحة البيع',
// // // //           'inventoryDepartment': 'صفحة جرد الاقسام',
// // // //           'Suppliers': 'صفحة الموردين',
// // // //           'Vouchers': 'صفحة السندات',
// // // //           'Funds': 'صفحة الاموال',
// // // //           'Transfers': 'صفحة التحويل',
// // // //           'edit': 'صفحة التعديل',
// // // //           'branches': 'صفحة الافرع',
// // // //           'Transactions': 'صفحة التعاملات',
// // // //           'Statements': 'صفحة تصريحات الخروج'
// // // //         }
// // // //       : {
// // // //           'reports': 'Reports Page',
// // // //           'inventory': 'Inventory Page',
// // // //           'Setting': 'Settings Page',
// // // //           'Input': 'Input & Opening Balance Page',
// // // //           'Daily': 'Daily Movement Page',
// // // //           'scrap': 'Scrap Page',
// // // //           'sales': 'Sales Page',
// // // //           'inventoryDepartment': 'Inventory Departments Page',
// // // //           'Suppliers': 'Suppliers Page',
// // // //           'Vouchers': 'Vouchers Page',
// // // //           'Funds': 'Funds Page',
// // // //           'Transfers': 'Transfers Page',
// // // //           'edit': 'Edit Page',
// // // //           'branches': 'Branches Page',
// // // //           'Transactions': 'Transactions Page',
// // // //           'Statements': 'Statements Page',
// // // //         };

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _loadSettings();
// // // //     _loadLogoFromPrefs();
// // // //     _loadEntries();
// // // //     _loadScannerMode(); // ✅ تحميل وضع الماسح
// // // //   }

// // // //   // ======== تحميل الباسوردات ========
// // // //   Future<void> _loadEntries() async {
// // // //     final entries = await loadPasswordEntries();
// // // //     setState(() => _passwordEntries = entries);
// // // //   }

// // // //   // ======== تحميل وضع الماسح ========
// // // //   Future<void> _loadScannerMode() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     final mode = prefs.getString('scannerMode');
// // // //     if (mode != null) {
// // // //       setState(() {
// // // //         _scannerMode = ScannerMode.values.firstWhere(
// // // //           (e) => e.name == mode,
// // // //           orElse: () => ScannerMode.secondary,
// // // //         );
// // // //       });
// // // //     }
// // // //   }

// // // //   // ======== حفظ وضع الماسح ========
// // // //   Future<void> _saveScannerMode(ScannerMode mode) async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     await prefs.setString('scannerMode', mode.name);
// // // //     setState(() {
// // // //       _scannerMode = mode;
// // // //     });
// // // //   }

// // // //   Future<void> _loadLogoFromPrefs() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     final savedBase64 = prefs.getString('custom_logo_base64');
// // // //     if (savedBase64 != null && savedBase64.isNotEmpty) {
// // // //       setState(() {
// // // //         _logoBase64 = savedBase64;
// // // //         _logoImageBytes = base64Decode(savedBase64);
// // // //       });
// // // //     }
// // // //   }

// // // //   Future<void> _pickLogoImage() async {
// // // //     final picker = ImagePicker();
// // // //     final pickedFile = await picker.pickImage(
// // // //       source: ImageSource.gallery,
// // // //       maxWidth: 400,
// // // //       maxHeight: 400,
// // // //       imageQuality: 80,
// // // //     );

// // // //     if (pickedFile != null) {
// // // //       final rawBytes = await pickedFile.readAsBytes();
// // // //       imglib.Image? img = imglib.decodeImage(rawBytes);
// // // //       img = imglib.grayscale(img!);

// // // //       const threshold = 130;
// // // //       for (int y = 0; y < img.height; y++) {
// // // //         for (int x = 0; x < img.width; x++) {
// // // //           final px = img.getPixel(x, y);
// // // //           final luminance = imglib.getLuminance(px);
// // // //           if (luminance > threshold) {
// // // //             img.setPixel(x, y, imglib.ColorInt8.rgb(255, 255, 255));
// // // //           } else {
// // // //             img.setPixel(x, y, imglib.ColorInt8.rgb(0, 0, 0));
// // // //           }
// // // //         }
// // // //       }

// // // //       final pngBytes = imglib.encodePng(img);
// // // //       final base64String = base64Encode(pngBytes);

// // // //       setState(() {
// // // //         _logoImageBytes = pngBytes;
// // // //         _logoBase64 = base64String;
// // // //       });

// // // //       final prefs = await SharedPreferences.getInstance();
// // // //       await prefs.setString('custom_logo_base64', base64String);

// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         const SnackBar(
// // // //             content: Text(
// // // //                 "تم حفظ اللوجو بعد المعالجة للطباعة اضغط على حفظ الاعدادات للتأكيد")),
// // // //       );
// // // //     }
// // // //   }

// // // //   Future<void> _removeLogo() async {
// // // //     setState(() {
// // // //       _logoImageBytes = null;
// // // //       _logoBase64 = null;
// // // //     });
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     await prefs.remove('custom_logo_base64');
// // // //   }

// // // //   Future<void> _loadSettings() async {
// // // //     final prefs = await SharedPreferences.getInstance();

// // // //     _selectedLanguage = prefs.getString('languageCode') ?? 'ar';
// // // //     _isArabic = _selectedLanguage == 'ar';

// // // //     final savedMode = prefs.getString('displayMode');
// // // //     if (savedMode != null) {
// // // //       _mode = CodeDisplayMode.values.firstWhere(
// // // //         (e) => e.name == savedMode,
// // // //         orElse: () => CodeDisplayMode.qr,
// // // //       );
// // // //     }

// // // //     final savedFreq = prefs.getString('reportFrequency');
// // // //     if (savedFreq != null) {
// // // //       _frequency = ReportFrequency.values.firstWhere(
// // // //         (e) => e.name == savedFreq,
// // // //         orElse: () => ReportFrequency.daily,
// // // //       );
// // // //     }

// // // //     _userNames = prefs.getStringList('userNames') ?? [];

// // // //     final powerJson = prefs.getString('pagePowers');
// // // //     if (powerJson != null) {
// // // //       final decoded = json.decode(powerJson);
// // // //       _pagePowers =
// // // //           Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
// // // //     }

// // // //     setState(() {});
// // // //   }

// // // //   Future<void> _saveSettings() async {
// // // //     final prefs = await SharedPreferences.getInstance();

// // // //     await prefs.setString('displayMode', _mode.name);
// // // //     await prefs.setString('reportFrequency', _frequency.name);
// // // //     await prefs.setStringList('userNames', _userNames);
// // // //     await prefs.setString('pagePowers', json.encode(_pagePowers));
// // // //     await prefs.setString('languageCode', _selectedLanguage);
// // // //     await prefs.setString('scannerMode', _scannerMode.name); // ✅ حفظ وضع الماسح

// // // //     Restart.restartApp();
// // // //   }

// // // //   void _addUserName() {
// // // //     final name = _userController.text.trim();
// // // //     if (name.isNotEmpty && !_userNames.contains(name)) {
// // // //       setState(() {
// // // //         _userNames.add(name);
// // // //         _userController.clear();
// // // //       });
// // // //     }
// // // //   }

// // // //   void _removeUserName(String name) {
// // // //     setState(() {
// // // //       _userNames.remove(name);
// // // //     });
// // // //   }

// // // //   Widget buildUidCard(String uid) {
// // // //     return Container(
// // // //       margin: const EdgeInsets.all(5),
// // // //       padding: const EdgeInsets.all(5),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.grey.shade100,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.grey.shade300),
// // // //         boxShadow: const [
// // // //           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
// // // //         ],
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           Expanded(
// // // //             child: SelectableText(
// // // //               uid,
// // // //               style: const TextStyle(
// // // //                   fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
// // // //             ),
// // // //           ),
// // // //           IconButton(
// // // //             icon: const Icon(Icons.copy),
// // // //             onPressed: () {
// // // //               Clipboard.setData(ClipboardData(text: uid));
// // // //               ScaffoldMessenger.of(context).showSnackBar(
// // // //                 const SnackBar(content: Text("تم نسخ UID")),
// // // //               );
// // // //             },
// // // //           )
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ======== Widget كارت باسورد واحد ========
// // // //   Widget _buildPasswordCard(PasswordEntry entry, int index) {
// // // //     return Card(
// // // //       margin: const EdgeInsets.symmetric(vertical: 8),
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // // //       elevation: 2,
// // // //       child: ExpansionTile(
// // // //         title: Text(
// // // //           entry.name.isEmpty
// // // //               ? _t("باسورد ${index + 1}", "Password ${index + 1}")
// // // //               : entry.name,
// // // //           style: const TextStyle(fontWeight: FontWeight.bold),
// // // //         ),
// // // //         subtitle: Text(
// // // //           '${_t("يحمي", "Protects")} ${entry.pages.length} ${_t("صفحة", "page(s)")}',
// // // //         ),
// // // //         trailing: Row(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             IconButton(
// // // //               icon: const Icon(Icons.edit, color: Colors.blue),
// // // //               onPressed: () =>
// // // //                   _showPasswordDialog(existing: entry, index: index),
// // // //             ),
// // // //             IconButton(
// // // //               icon: const Icon(Icons.delete, color: Colors.red),
// // // //               onPressed: () => _deleteEntry(index),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         children: [
// // // //           Padding(
// // // //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Text(
// // // //                   _t("الصفحات المحمية:", "Protected pages:"),
// // // //                   style: const TextStyle(fontWeight: FontWeight.bold),
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 if (entry.pages.isEmpty)
// // // //                   Text(
// // // //                     _t("لا توجد صفحات مختارة", "No pages selected"),
// // // //                     style: TextStyle(color: Colors.grey[600]),
// // // //                   ),
// // // //                 ...entry.pages.map((p) => Padding(
// // // //                       padding: const EdgeInsets.symmetric(vertical: 2),
// // // //                       child: Row(
// // // //                         children: [
// // // //                           const Icon(Icons.lock, size: 14),
// // // //                           const SizedBox(width: 6),
// // // //                           Text(_allPages[p] ?? p),
// // // //                         ],
// // // //                       ),
// // // //                     )),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ======== Dialog الإضافة والتعديل (مشترك) ========
// // // //   Future<void> _showPasswordDialog({
// // // //     PasswordEntry? existing,
// // // //     int? index,
// // // //   }) async {
// // // //     final nameCtrl = TextEditingController(text: existing?.name ?? '');
// // // //     final passCtrl = TextEditingController(text: existing?.password ?? '');
// // // //     List<String> selectedPages = List.from(existing?.pages ?? []);
// // // //     bool obscure = true;

// // // //     await showDialog(
// // // //       context: context,
// // // //       builder: (ctx) => StatefulBuilder(
// // // //         builder: (ctx, setLocal) => AlertDialog(
// // // //           title: Text(existing == null
// // // //               ? _t("إضافة باسورد جديد", "Add New Password")
// // // //               : _t("تعديل الباسورد", "Edit Password")),
// // // //           content: SingleChildScrollView(
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 TextField(
// // // //                   controller: nameCtrl,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: _t("اسم وصفي (اختياري)", "Label (optional)"),
// // // //                     hintText: _t("مثال: باسورد المدير", "e.g. Admin password"),
// // // //                     border: const OutlineInputBorder(),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 12),
// // // //                 TextField(
// // // //                   controller: passCtrl,
// // // //                   obscureText: obscure,
// // // //                   decoration: InputDecoration(
// // // //                     labelText: _t("الرقم السري", "Password"),
// // // //                     border: const OutlineInputBorder(),
// // // //                     suffixIcon: IconButton(
// // // //                       icon: Icon(
// // // //                           obscure ? Icons.visibility : Icons.visibility_off),
// // // //                       onPressed: () => setLocal(() => obscure = !obscure),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 Text(
// // // //                   _t("اختر الصفحات:", "Select Pages:"),
// // // //                   style: const TextStyle(fontWeight: FontWeight.bold),
// // // //                 ),
// // // //                 ..._allPages.entries.map((e) => CheckboxListTile(
// // // //                       dense: true,
// // // //                       title: Text(e.value),
// // // //                       value: selectedPages.contains(e.key),
// // // //                       onChanged: (val) => setLocal(() {
// // // //                         if (val == true) {
// // // //                           selectedPages.add(e.key);
// // // //                         } else {
// // // //                           selectedPages.remove(e.key);
// // // //                         }
// // // //                       }),
// // // //                     )),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           actions: [
// // // //             TextButton(
// // // //               onPressed: () => Navigator.pop(ctx),
// // // //               child: Text(_t("إلغاء", "Cancel")),
// // // //             ),
// // // //             ElevatedButton(
// // // //               onPressed: () async {
// // // //                 final pass = passCtrl.text.trim();
// // // //                 if (pass.isEmpty) {
// // // //                   ScaffoldMessenger.of(context).showSnackBar(
// // // //                     SnackBar(
// // // //                         content:
// // // //                             Text(_t("أدخل الرقم السري", "Enter a password"))),
// // // //                   );
// // // //                   return;
// // // //                 }
// // // //                 final newEntry = PasswordEntry(
// // // //                   id: existing?.id ??
// // // //                       DateTime.now().millisecondsSinceEpoch.toString(),
// // // //                   name: nameCtrl.text.trim(),
// // // //                   password: pass,
// // // //                   pages: selectedPages,
// // // //                 );
// // // //                 setState(() {
// // // //                   if (index != null) {
// // // //                     _passwordEntries[index] = newEntry;
// // // //                   } else {
// // // //                     _passwordEntries.add(newEntry);
// // // //                   }
// // // //                 });
// // // //                 await savePasswordEntries(_passwordEntries);
// // // //                 Navigator.pop(ctx);
// // // //               },
// // // //               child: Text(_t("حفظ", "Save")),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Future<void> _deleteEntry(int index) async {
// // // //     final confirm = await showDialog<bool>(
// // // //       context: context,
// // // //       builder: (_) => AlertDialog(
// // // //         title: Text(_t("حذف الباسورد؟", "Delete Password?")),
// // // //         content: Text(_t("هل أنت متأكد من حذف هذا الباسورد؟",
// // // //             "Are you sure you want to delete this password?")),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context, false),
// // // //             child: Text(_t("إلغاء", "Cancel")),
// // // //           ),
// // // //           ElevatedButton(
// // // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // // //             onPressed: () => Navigator.pop(context, true),
// // // //             child: Text(_t("حذف", "Delete"),
// // // //                 style: const TextStyle(color: Colors.white)),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //     if (confirm == true) {
// // // //       setState(() => _passwordEntries.removeAt(index));
// // // //       await savePasswordEntries(_passwordEntries);
// // // //     }
// // // //   }

// // // //   // ======== القسم الرئيسي لإدارة الباسوردات ========
// // // //   Widget _buildMultiPasswordSection() {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const SizedBox(height: 20),
// // // //         Text(
// // // //           _t("🔒 إدارة الباسوردات:", "🔒 Password Manager:"),
// // // //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //         ),
// // // //         const SizedBox(height: 12),
// // // //         if (_passwordEntries.isEmpty)
// // // //           Padding(
// // // //             padding: const EdgeInsets.symmetric(vertical: 8),
// // // //             child: Text(
// // // //               _t("لا يوجد باسوردات مضافة بعد", "No passwords added yet"),
// // // //               style: TextStyle(color: Colors.grey[600]),
// // // //             ),
// // // //           ),
// // // //         ..._passwordEntries
// // // //             .asMap()
// // // //             .entries
// // // //             .map((e) => _buildPasswordCard(e.value, e.key)),
// // // //         const SizedBox(height: 12),
// // // //         SizedBox(
// // // //           width: double.infinity,
// // // //           child: ElevatedButton.icon(
// // // //             icon: const Icon(Icons.add),
// // // //             label: Text(_t("إضافة باسورد جديد", "Add New Password")),
// // // //             style: ElevatedButton.styleFrom(
// // // //               padding: const EdgeInsets.symmetric(vertical: 14),
// // // //               shape: RoundedRectangleBorder(
// // // //                   borderRadius: BorderRadius.circular(12)),
// // // //             ),
// // // //             onPressed: () => _showPasswordDialog(),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildPrintLayoutSection() {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         const SizedBox(height: 20),
// // // //         Text(
// // // //           _t('🖨️ إعدادات تخطيط الطباعة:', '🖨️ Print Layout Settings:'),
// // // //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //         ),
// // // //         const SizedBox(height: 6),
// // // //         Text(
// // // //           _t(
// // // //             'حدّد مكان كل عنصر على الاستيكر (نص، QR، لوجو...) بالضبط.',
// // // //             'Customize each element\'s position on the label (text, QR, logo...).',
// // // //           ),
// // // //           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// // // //         ),
// // // //         const SizedBox(height: 14),
// // // //         _layoutButton(
// // // //           icon: Icons.grain,
// // // //           title: _t('تخطيط استيكر الذهب', 'Gold Label Layout'),
// // // //           subtitle: _t('وزن • عيار • مقاس • QR/باركود • لوجو',
// // // //               'Weight • Carat • Size • QR/Barcode • Logo'),
// // // //           color: const Color(0xFFD4AF37),
// // // //           onTap: () => _openLayoutEditor('gold'),
// // // //         ),
// // // //         const SizedBox(height: 10),
// // // //         _layoutButton(
// // // //           icon: Icons.view_in_ar,
// // // //           title: _t('تخطيط استيكر السبائك', 'Bullion Label Layout'),
// // // //           subtitle: _t('وزن • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// // // //               'Weight • Note1 • Note2 • QR/Barcode • Logo'),
// // // //           color: Colors.blueGrey,
// // // //           onTap: () => _openLayoutEditor('bullion'),
// // // //         ),
// // // //         const SizedBox(height: 10),
// // // //         _layoutButton(
// // // //           icon: Icons.diamond,
// // // //           title: _t('تخطيط استيكر الأحجار', 'Gem Label Layout'),
// // // //           subtitle: _t('نوع الحجر • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// // // //               'Gem Type • Note1 • Note2 • QR/Barcode • Logo'),
// // // //           color: Colors.deepPurple,
// // // //           onTap: () => _openLayoutEditor('gem'),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _layoutButton({
// // // //     required IconData icon,
// // // //     required String title,
// // // //     required String subtitle,
// // // //     required Color color,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return Material(
// // // //       color: Colors.transparent,
// // // //       child: InkWell(
// // // //         onTap: onTap,
// // // //         borderRadius: BorderRadius.circular(14),
// // // //         child: Container(
// // // //           padding: const EdgeInsets.all(16),
// // // //           decoration: BoxDecoration(
// // // //             color: color.withOpacity(0.07),
// // // //             borderRadius: BorderRadius.circular(14),
// // // //             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
// // // //           ),
// // // //           child: Row(
// // // //             children: [
// // // //               Container(
// // // //                 width: 48,
// // // //                 height: 48,
// // // //                 decoration: BoxDecoration(
// // // //                   color: color.withOpacity(0.15),
// // // //                   borderRadius: BorderRadius.circular(10),
// // // //                 ),
// // // //                 child: Icon(icon, color: color, size: 26),
// // // //               ),
// // // //               const SizedBox(width: 14),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(title,
// // // //                         style: const TextStyle(
// // // //                             fontSize: 14, fontWeight: FontWeight.bold)),
// // // //                     const SizedBox(height: 3),
// // // //                     Text(subtitle,
// // // //                         style:
// // // //                             TextStyle(fontSize: 11, color: Colors.grey[600])),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   void _openLayoutEditor(String type) {
// // // //     Navigator.push(
// // // //       context,
// // // //       MaterialPageRoute(
// // // //         builder: (_) => LabelLayoutEditorPage(labelType: type),
// // // //       ),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Directionality(
// // // //       textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
// // // //       child: Scaffold(
// // // //         appBar: AppBar(
// // // //           title: Text(_t("الإعدادات", "Settings")),
// // // //           backgroundColor: const Color(0xFFD4AF37),
// // // //         ),
// // // //         body: ListView(
// // // //           padding: const EdgeInsets.all(20),
// // // //           children: [
// // // //             // UID
// // // //             Text(
// // // //               _t("رقم الفرع الخاص بك", "Number of your branch"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             buildUidCard(uid),
// // // //             const SizedBox(height: 12),

// // // //             // طريقة عرض الكود
// // // //             Text(
// // // //               _t("طريقة عرض الكود:", "Code Display Mode:"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             RadioListTile<CodeDisplayMode>(
// // // //               title: Text(_t("QR Code", "QR Code")),
// // // //               value: CodeDisplayMode.qr,
// // // //               groupValue: _mode,
// // // //               onChanged: (val) {
// // // //                 if (val != null) setState(() => _mode = val);
// // // //               },
// // // //             ),
// // // //             RadioListTile<CodeDisplayMode>(
// // // //               title: Text(_t("Barcode", "Barcode")),
// // // //               value: CodeDisplayMode.barcode,
// // // //               groupValue: _mode,
// // // //               onChanged: (val) {
// // // //                 if (val != null) setState(() => _mode = val);
// // // //               },
// // // //             ),

// // // //             const SizedBox(height: 30),

// // // //             // تكرار التقرير
// // // //             Text(
// // // //               _t("تكرار التقرير:", "Report Frequency:"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             RadioListTile<ReportFrequency>(
// // // //               title: Text(_t("يومي", "Daily")),
// // // //               value: ReportFrequency.daily,
// // // //               groupValue: _frequency,
// // // //               onChanged: (val) {
// // // //                 if (val != null) setState(() => _frequency = val);
// // // //               },
// // // //             ),
// // // //             RadioListTile<ReportFrequency>(
// // // //               title: Text(_t("أسبوعي", "Weekly")),
// // // //               value: ReportFrequency.weekly,
// // // //               groupValue: _frequency,
// // // //               onChanged: (val) {
// // // //                 if (val != null) setState(() => _frequency = val);
// // // //               },
// // // //             ),
// // // //             RadioListTile<ReportFrequency>(
// // // //               title: Text(_t("شهري", "Monthly")),
// // // //               value: ReportFrequency.monthly,
// // // //               groupValue: _frequency,
// // // //               onChanged: (val) {
// // // //                 if (val != null) setState(() => _frequency = val);
// // // //               },
// // // //             ),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),
// // // //             const SizedBox(height: 20),

// // // //             // 👥 أسماء المستخدمين
// // // //             Text(
// // // //               _t("👥 أسماء المستخدمين:", "👥 User Names:"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: TextField(
// // // //                     controller: _userController,
// // // //                     decoration: InputDecoration(
// // // //                       labelText: _t("أدخل اسم المستخدم", "Enter user name"),
// // // //                       border: const OutlineInputBorder(),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(width: 8),
// // // //                 ElevatedButton(
// // // //                   onPressed: _addUserName,
// // // //                   child: Text(_t("➕ إضافة", "➕ Add")),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             if (_userNames.isEmpty)
// // // //               Text(_t("لا يوجد مستخدمين مسجلين بعد.", "No users added yet.")),
// // // //             if (_userNames.isNotEmpty)
// // // //               Column(
// // // //                 children: _userNames
// // // //                     .map((name) => ListTile(
// // // //                           title: Text(name),
// // // //                           trailing: IconButton(
// // // //                             icon: const Icon(Icons.delete, color: Colors.red),
// // // //                             onPressed: () => _removeUserName(name),
// // // //                           ),
// // // //                         ))
// // // //                     .toList(),
// // // //               ),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),

// // // //             // 🔒 إدارة الباسوردات
// // // //             _buildMultiPasswordSection(),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),
// // // //             const SizedBox(height: 20),

// // // //             // ===== إعدادات الماسح الضوئي =====
// // // //             Text(
// // // //               _t("📷 إعدادات الماسح:", "📷 Scanner Settings:"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             RadioListTile<ScannerMode>(
// // // //               title: Text(
// // // //                   _t("الماسح الأساسي ", "Primary Scanner (Hides input field)")),
// // // //               value: ScannerMode.primary,
// // // //               groupValue: _scannerMode,
// // // //               onChanged: (val) {
// // // //                 if (val != null) _saveScannerMode(val);
// // // //               },
// // // //             ),
// // // //             RadioListTile<ScannerMode>(
// // // //               title: Text(_t(
// // // //                   "الماسح المساعد ", "Secondary Scanner (Shows input field)")),
// // // //               value: ScannerMode.secondary,
// // // //               groupValue: _scannerMode,
// // // //               onChanged: (val) {
// // // //                 if (val != null) _saveScannerMode(val);
// // // //               },
// // // //             ),
// // // //             // const SizedBox(height: 10),
// // // //             // Text(
// // // //             //   _t(
// // // //             //     "🔹 الأساسي: يقرأ الشريحة تلقائياً ولا يحتاج لإدخال يدوي.",
// // // //             //     "🔹 Primary: Reads the tag automatically, no manual input needed.",
// // // //             //   ),
// // // //             //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// // // //             // ),
// // // //             // Text(
// // // //             //   _t(
// // // //             //     "🔸 المساعد: يتيح لك إدخال رقم الشريحة يدوياً بعد الطباعة.",
// // // //             //     "🔸 Secondary: Allows manual tag entry after printing.",
// // // //             //   ),
// // // //             //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// // // //             // ),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),
// // // //             const SizedBox(height: 20),

// // // //             // 🌐 اللغة
// // // //             Text(
// // // //               _t("🌐 اللغة:", "🌐 Language:"),
// // // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             Row(
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: RadioListTile<String>(
// // // //                     title: const Text("العربية"),
// // // //                     value: 'ar',
// // // //                     groupValue: _selectedLanguage,
// // // //                     onChanged: (val) {
// // // //                       if (val != null) {
// // // //                         setState(() {
// // // //                           _selectedLanguage = val;
// // // //                           _isArabic = true;
// // // //                         });
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //                 Expanded(
// // // //                   child: RadioListTile<String>(
// // // //                     title: const Text("English"),
// // // //                     value: 'en',
// // // //                     groupValue: _selectedLanguage,
// // // //                     onChanged: (val) {
// // // //                       if (val != null) {
// // // //                         setState(() {
// // // //                           _selectedLanguage = val;
// // // //                           _isArabic = false;
// // // //                         });
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),

// // // //             // 🖨️ إعدادات تخطيط الطباعة
// // // //             _buildPrintLayoutSection(),

// // // //             const SizedBox(height: 30),
// // // //             const Divider(thickness: 1.5),
// // // //             const SizedBox(height: 20),

// // // //             // شعار المتجر
// // // //             const Text(
// // // //               "شعار المتجر (اللوجو):",
// // // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             Center(
// // // //               child: Container(
// // // //                 width: 150,
// // // //                 height: 150,
// // // //                 decoration: BoxDecoration(
// // // //                   border: Border.all(color: Colors.grey),
// // // //                   borderRadius: BorderRadius.circular(12),
// // // //                 ),
// // // //                 child: _logoImageBytes != null
// // // //                     ? ClipRRect(
// // // //                         borderRadius: BorderRadius.circular(12),
// // // //                         child:
// // // //                             Image.memory(_logoImageBytes!, fit: BoxFit.contain),
// // // //                       )
// // // //                     : const Icon(Icons.image, size: 60, color: Colors.grey),
// // // //               ),
// // // //             ),
// // // //             const SizedBox(height: 12),
// // // //             Row(
// // // //               mainAxisAlignment: MainAxisAlignment.center,
// // // //               children: [
// // // //                 ElevatedButton.icon(
// // // //                   onPressed: _pickLogoImage,
// // // //                   icon: const Icon(Icons.photo_library),
// // // //                   label: const Text("اختيار لوجو جديد"),
// // // //                 ),
// // // //                 const SizedBox(width: 10),
// // // //                 if (_logoImageBytes != null)
// // // //                   ElevatedButton.icon(
// // // //                     onPressed: _removeLogo,
// // // //                     icon: const Icon(Icons.delete, color: Colors.red),
// // // //                     label: const Text("حذف"),
// // // //                     style: ElevatedButton.styleFrom(
// // // //                         backgroundColor: Colors.red[50]),
// // // //                   ),
// // // //               ],
// // // //             ),

// // // //             const SizedBox(height: 30),
// // // //             ElevatedButton(
// // // //               onPressed: _saveSettings,
// // // //               child: Text(_t("💾 حفظ الإعدادات", "💾 Save Settings")),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:restart_app/restart_app.dart';
// // // import 'dart:typed_data';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:image/image.dart' as imglib;
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/services.dart';
// // // import 'label_layout_editor.dart';

// // // enum CodeDisplayMode { qr, barcode }

// // // enum ReportFrequency { daily, weekly, monthly }

// // // // ======== تعريف وضع الماسح الضوئي ========
// // // enum ScannerMode { primary, secondary }

// // // // ======== نموذج الباسورد ========
// // // class PasswordEntry {
// // //   final String id;
// // //   final String name;
// // //   final String password;
// // //   final List<String> pages;

// // //   PasswordEntry({
// // //     required this.id,
// // //     required this.name,
// // //     required this.password,
// // //     required this.pages,
// // //   });

// // //   Map<String, dynamic> toJson() => {
// // //         'id': id,
// // //         'name': name,
// // //         'password': password,
// // //         'pages': pages,
// // //       };

// // //   factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
// // //         id: json['id'],
// // //         name: json['name'] ?? '',
// // //         password: json['password'],
// // //         pages: List<String>.from(json['pages'] ?? []),
// // //       );
// // // }

// // // // ======== دوال حفظ وجلب الباسوردات (global) ========
// // // Future<void> savePasswordEntries(List<PasswordEntry> entries) async {
// // //   final prefs = await SharedPreferences.getInstance();
// // //   final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
// // //   await prefs.setStringList('passwordEntries', encoded);
// // // }

// // // Future<List<PasswordEntry>> loadPasswordEntries() async {
// // //   final prefs = await SharedPreferences.getInstance();
// // //   final encoded = prefs.getStringList('passwordEntries') ?? [];
// // //   return encoded.map((s) => PasswordEntry.fromJson(jsonDecode(s))).toList();
// // // }

// // // // ======== checkPassword (global - بتشتغل مع النظام الجديد) ========
// // // Future<bool> checkPassword(BuildContext context, String pageKey) async {
// // //   final entries = await loadPasswordEntries();

// // //   // إيجاد كل الباسوردات اللي بتحمي الصفحة دي
// // //   final guardingEntries =
// // //       entries.where((e) => e.pages.contains(pageKey)).toList();

// // //   // لو مفيش باسورد بيحمي الصفحة → افتح عادي
// // //   if (guardingEntries.isEmpty) return true;

// // //   final controller = TextEditingController();
// // //   bool accessGranted = false;

// // //   await showDialog(
// // //     context: context,
// // //     barrierDismissible: false,
// // //     builder: (_) => AlertDialog(
// // //       title: const Text("أدخل الرقم السري"),
// // //       content: TextField(
// // //         controller: controller,
// // //         obscureText: true,
// // //         autofocus: true,
// // //         decoration: const InputDecoration(
// // //           hintText: "الرقم السري",
// // //           border: OutlineInputBorder(),
// // //         ),
// // //         onSubmitted: (_) {
// // //           final typed = controller.text.trim();
// // //           final valid = guardingEntries.any((e) => e.password == typed);
// // //           if (valid) {
// // //             accessGranted = true;
// // //             Navigator.pop(context);
// // //           } else {
// // //             ScaffoldMessenger.of(context).showSnackBar(
// // //               const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// // //             );
// // //           }
// // //         },
// // //       ),
// // //       actions: [
// // //         TextButton(
// // //           onPressed: () => Navigator.pop(context),
// // //           child: const Text("إلغاء"),
// // //         ),
// // //         TextButton(
// // //           onPressed: () {
// // //             final typed = controller.text.trim();
// // //             final valid = guardingEntries.any((e) => e.password == typed);
// // //             if (valid) {
// // //               accessGranted = true;
// // //               Navigator.pop(context);
// // //             } else {
// // //               ScaffoldMessenger.of(context).showSnackBar(
// // //                 const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// // //               );
// // //             }
// // //           },
// // //           child: const Text("تأكيد"),
// // //         ),
// // //       ],
// // //     ),
// // //   );

// // //   return accessGranted;
// // // }

// // // // ======== SettingsPage ========
// // // class SettingsPage extends StatefulWidget {
// // //   const SettingsPage({super.key});

// // //   @override
// // //   State<SettingsPage> createState() => _SettingsPageState();
// // // }

// // // class _SettingsPageState extends State<SettingsPage> {
// // //   static String get uid => FirebaseAuth.instance.currentUser!.uid;

// // //   CodeDisplayMode _mode = CodeDisplayMode.qr;
// // //   ReportFrequency _frequency = ReportFrequency.daily;

// // //   // ✅ وضع الماسح الضوئي
// // //   ScannerMode _scannerMode = ScannerMode.secondary;

// // //   // ===== ظهور تبويبات صفحة الصندوق =====
// // //   bool _showScrapBoxTab = true;
// // //   bool _showDailyBoxTab = true;
// // //   bool _showSafeBoxTab = true;

// // //   final TextEditingController _userController = TextEditingController();

// // //   List<String> _userNames = [];
// // //   Map<String, int> _pagePowers = {};

// // //   String _selectedLanguage = 'ar';
// // //   bool _isArabic = true;

// // //   String _t(String ar, String en) => _isArabic ? ar : en;

// // //   Uint8List? _logoImageBytes;
// // //   String? _logoBase64;

// // //   // ======== نظام الباسوردات الجديد ========
// // //   List<PasswordEntry> _passwordEntries = [];

// // //   // ======== الصفحات المتاحة ========
// // //   Map<String, String> get _allPages => _isArabic
// // //       ? {
// // //           'reports': 'صفحة التقارير',
// // //           'inventory': 'صفحة الجرد',
// // //           'Setting': 'صفحة الإعدادات',
// // //           'Input': 'صفحة الإدخال والرصيد الافتتاحي',
// // //           'Daily': 'صفحة الحركة اليومية',
// // //           'scrap': 'صفحة الكسر',
// // //           'sales': 'صفحة البيع',
// // //           'inventoryDepartment': 'صفحة جرد الاقسام',
// // //           'Suppliers': 'صفحة الموردين',
// // //           'Vouchers': 'صفحة السندات',
// // //           'Funds': 'صفحة الاموال',
// // //           'Transfers': 'صفحة التحويل',
// // //           'edit': 'صفحة التعديل',
// // //           'branches': 'صفحة الافرع',
// // //           'Transactions': 'صفحة التعاملات',
// // //           'Statements': 'صفحة تصريحات الخروج'
// // //         }
// // //       : {
// // //           'reports': 'Reports Page',
// // //           'inventory': 'Inventory Page',
// // //           'Setting': 'Settings Page',
// // //           'Input': 'Input & Opening Balance Page',
// // //           'Daily': 'Daily Movement Page',
// // //           'scrap': 'Scrap Page',
// // //           'sales': 'Sales Page',
// // //           'inventoryDepartment': 'Inventory Departments Page',
// // //           'Suppliers': 'Suppliers Page',
// // //           'Vouchers': 'Vouchers Page',
// // //           'Funds': 'Funds Page',
// // //           'Transfers': 'Transfers Page',
// // //           'edit': 'Edit Page',
// // //           'branches': 'Branches Page',
// // //           'Transactions': 'Transactions Page',
// // //           'Statements': 'Statements Page',
// // //         };

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadSettings();
// // //     _loadLogoFromPrefs();
// // //     _loadEntries();
// // //     _loadScannerMode(); // ✅ تحميل وضع الماسح
// // //   }

// // //   // ======== تحميل الباسوردات ========
// // //   Future<void> _loadEntries() async {
// // //     final entries = await loadPasswordEntries();
// // //     setState(() => _passwordEntries = entries);
// // //   }

// // //   // ======== تحميل وضع الماسح ========
// // //   Future<void> _loadScannerMode() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final mode = prefs.getString('scannerMode');
// // //     if (mode != null) {
// // //       setState(() {
// // //         _scannerMode = ScannerMode.values.firstWhere(
// // //           (e) => e.name == mode,
// // //           orElse: () => ScannerMode.secondary,
// // //         );
// // //       });
// // //     }
// // //   }

// // //   // ======== حفظ وضع الماسح ========
// // //   Future<void> _saveScannerMode(ScannerMode mode) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('scannerMode', mode.name);
// // //     setState(() {
// // //       _scannerMode = mode;
// // //     });
// // //   }

// // //   Future<void> _loadLogoFromPrefs() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final savedBase64 = prefs.getString('custom_logo_base64');
// // //     if (savedBase64 != null && savedBase64.isNotEmpty) {
// // //       setState(() {
// // //         _logoBase64 = savedBase64;
// // //         _logoImageBytes = base64Decode(savedBase64);
// // //       });
// // //     }
// // //   }

// // //   Future<void> _pickLogoImage() async {
// // //     final picker = ImagePicker();
// // //     final pickedFile = await picker.pickImage(
// // //       source: ImageSource.gallery,
// // //       maxWidth: 400,
// // //       maxHeight: 400,
// // //       imageQuality: 80,
// // //     );

// // //     if (pickedFile != null) {
// // //       final rawBytes = await pickedFile.readAsBytes();
// // //       imglib.Image? img = imglib.decodeImage(rawBytes);
// // //       img = imglib.grayscale(img!);

// // //       const threshold = 130;
// // //       for (int y = 0; y < img.height; y++) {
// // //         for (int x = 0; x < img.width; x++) {
// // //           final px = img.getPixel(x, y);
// // //           final luminance = imglib.getLuminance(px);
// // //           if (luminance > threshold) {
// // //             img.setPixel(x, y, imglib.ColorInt8.rgb(255, 255, 255));
// // //           } else {
// // //             img.setPixel(x, y, imglib.ColorInt8.rgb(0, 0, 0));
// // //           }
// // //         }
// // //       }

// // //       final pngBytes = imglib.encodePng(img);
// // //       final base64String = base64Encode(pngBytes);

// // //       setState(() {
// // //         _logoImageBytes = pngBytes;
// // //         _logoBase64 = base64String;
// // //       });

// // //       final prefs = await SharedPreferences.getInstance();
// // //       await prefs.setString('custom_logo_base64', base64String);

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(
// // //             content: Text(
// // //                 "تم حفظ اللوجو بعد المعالجة للطباعة اضغط على حفظ الاعدادات للتأكيد")),
// // //       );
// // //     }
// // //   }

// // //   Future<void> _removeLogo() async {
// // //     setState(() {
// // //       _logoImageBytes = null;
// // //       _logoBase64 = null;
// // //     });
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.remove('custom_logo_base64');
// // //   }

// // //   Future<void> _loadSettings() async {
// // //     final prefs = await SharedPreferences.getInstance();

// // //     _selectedLanguage = prefs.getString('languageCode') ?? 'ar';
// // //     _isArabic = _selectedLanguage == 'ar';

// // //     final savedMode = prefs.getString('displayMode');
// // //     if (savedMode != null) {
// // //       _mode = CodeDisplayMode.values.firstWhere(
// // //         (e) => e.name == savedMode,
// // //         orElse: () => CodeDisplayMode.qr,
// // //       );
// // //     }

// // //     final savedFreq = prefs.getString('reportFrequency');
// // //     if (savedFreq != null) {
// // //       _frequency = ReportFrequency.values.firstWhere(
// // //         (e) => e.name == savedFreq,
// // //         orElse: () => ReportFrequency.daily,
// // //       );
// // //     }

// // //     _userNames = prefs.getStringList('userNames') ?? [];

// // //     final powerJson = prefs.getString('pagePowers');
// // //     if (powerJson != null) {
// // //       final decoded = json.decode(powerJson);
// // //       _pagePowers =
// // //           Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
// // //     }

// // //     // ===== تحميل إعدادات ظهور تبويبات الصندوق =====
// // //     _showScrapBoxTab = prefs.getBool('showScrapBoxTab') ?? true;
// // //     _showDailyBoxTab = prefs.getBool('showDailyBoxTab') ?? true;
// // //     _showSafeBoxTab = prefs.getBool('showSafeBoxTab') ?? true;

// // //     setState(() {});
// // //   }

// // //   Future<void> _saveSettings() async {
// // //     final prefs = await SharedPreferences.getInstance();

// // //     await prefs.setString('displayMode', _mode.name);
// // //     await prefs.setString('reportFrequency', _frequency.name);
// // //     await prefs.setStringList('userNames', _userNames);
// // //     await prefs.setString('pagePowers', json.encode(_pagePowers));
// // //     await prefs.setString('languageCode', _selectedLanguage);
// // //     await prefs.setString('scannerMode', _scannerMode.name); // ✅ حفظ وضع الماسح

// // //     // ===== حفظ إعدادات ظهور تبويبات الصندوق =====
// // //     await prefs.setBool('showScrapBoxTab', _showScrapBoxTab);
// // //     await prefs.setBool('showDailyBoxTab', _showDailyBoxTab);
// // //     await prefs.setBool('showSafeBoxTab', _showSafeBoxTab);

// // //     Restart.restartApp();
// // //   }

// // //   void _addUserName() {
// // //     final name = _userController.text.trim();
// // //     if (name.isNotEmpty && !_userNames.contains(name)) {
// // //       setState(() {
// // //         _userNames.add(name);
// // //         _userController.clear();
// // //       });
// // //     }
// // //   }

// // //   void _removeUserName(String name) {
// // //     setState(() {
// // //       _userNames.remove(name);
// // //     });
// // //   }

// // //   Widget buildUidCard(String uid) {
// // //     return Container(
// // //       margin: const EdgeInsets.all(5),
// // //       padding: const EdgeInsets.all(5),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade100,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.grey.shade300),
// // //         boxShadow: const [
// // //           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
// // //         ],
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Expanded(
// // //             child: SelectableText(
// // //               uid,
// // //               style: const TextStyle(
// // //                   fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
// // //             ),
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.copy),
// // //             onPressed: () {
// // //               Clipboard.setData(ClipboardData(text: uid));
// // //               ScaffoldMessenger.of(context).showSnackBar(
// // //                 const SnackBar(content: Text("تم نسخ UID")),
// // //               );
// // //             },
// // //           )
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ======== Widget كارت باسورد واحد ========
// // //   Widget _buildPasswordCard(PasswordEntry entry, int index) {
// // //     return Card(
// // //       margin: const EdgeInsets.symmetric(vertical: 8),
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //       elevation: 2,
// // //       child: ExpansionTile(
// // //         title: Text(
// // //           entry.name.isEmpty
// // //               ? _t("باسورد ${index + 1}", "Password ${index + 1}")
// // //               : entry.name,
// // //           style: const TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         subtitle: Text(
// // //           '${_t("يحمي", "Protects")} ${entry.pages.length} ${_t("صفحة", "page(s)")}',
// // //         ),
// // //         trailing: Row(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             IconButton(
// // //               icon: const Icon(Icons.edit, color: Colors.blue),
// // //               onPressed: () =>
// // //                   _showPasswordDialog(existing: entry, index: index),
// // //             ),
// // //             IconButton(
// // //               icon: const Icon(Icons.delete, color: Colors.red),
// // //               onPressed: () => _deleteEntry(index),
// // //             ),
// // //           ],
// // //         ),
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   _t("الصفحات المحمية:", "Protected pages:"),
// // //                   style: const TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 if (entry.pages.isEmpty)
// // //                   Text(
// // //                     _t("لا توجد صفحات مختارة", "No pages selected"),
// // //                     style: TextStyle(color: Colors.grey[600]),
// // //                   ),
// // //                 ...entry.pages.map((p) => Padding(
// // //                       padding: const EdgeInsets.symmetric(vertical: 2),
// // //                       child: Row(
// // //                         children: [
// // //                           const Icon(Icons.lock, size: 14),
// // //                           const SizedBox(width: 6),
// // //                           Text(_allPages[p] ?? p),
// // //                         ],
// // //                       ),
// // //                     )),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ======== Dialog الإضافة والتعديل (مشترك) ========
// // //   Future<void> _showPasswordDialog({
// // //     PasswordEntry? existing,
// // //     int? index,
// // //   }) async {
// // //     final nameCtrl = TextEditingController(text: existing?.name ?? '');
// // //     final passCtrl = TextEditingController(text: existing?.password ?? '');
// // //     List<String> selectedPages = List.from(existing?.pages ?? []);
// // //     bool obscure = true;

// // //     await showDialog(
// // //       context: context,
// // //       builder: (ctx) => StatefulBuilder(
// // //         builder: (ctx, setLocal) => AlertDialog(
// // //           title: Text(existing == null
// // //               ? _t("إضافة باسورد جديد", "Add New Password")
// // //               : _t("تعديل الباسورد", "Edit Password")),
// // //           content: SingleChildScrollView(
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 TextField(
// // //                   controller: nameCtrl,
// // //                   decoration: InputDecoration(
// // //                     labelText: _t("اسم وصفي (اختياري)", "Label (optional)"),
// // //                     hintText: _t("مثال: باسورد المدير", "e.g. Admin password"),
// // //                     border: const OutlineInputBorder(),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),
// // //                 TextField(
// // //                   controller: passCtrl,
// // //                   obscureText: obscure,
// // //                   decoration: InputDecoration(
// // //                     labelText: _t("الرقم السري", "Password"),
// // //                     border: const OutlineInputBorder(),
// // //                     suffixIcon: IconButton(
// // //                       icon: Icon(
// // //                           obscure ? Icons.visibility : Icons.visibility_off),
// // //                       onPressed: () => setLocal(() => obscure = !obscure),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 16),
// // //                 Text(
// // //                   _t("اختر الصفحات:", "Select Pages:"),
// // //                   style: const TextStyle(fontWeight: FontWeight.bold),
// // //                 ),
// // //                 ..._allPages.entries.map((e) => CheckboxListTile(
// // //                       dense: true,
// // //                       title: Text(e.value),
// // //                       value: selectedPages.contains(e.key),
// // //                       onChanged: (val) => setLocal(() {
// // //                         if (val == true) {
// // //                           selectedPages.add(e.key);
// // //                         } else {
// // //                           selectedPages.remove(e.key);
// // //                         }
// // //                       }),
// // //                     )),
// // //               ],
// // //             ),
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () => Navigator.pop(ctx),
// // //               child: Text(_t("إلغاء", "Cancel")),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () async {
// // //                 final pass = passCtrl.text.trim();
// // //                 if (pass.isEmpty) {
// // //                   ScaffoldMessenger.of(context).showSnackBar(
// // //                     SnackBar(
// // //                         content:
// // //                             Text(_t("أدخل الرقم السري", "Enter a password"))),
// // //                   );
// // //                   return;
// // //                 }
// // //                 final newEntry = PasswordEntry(
// // //                   id: existing?.id ??
// // //                       DateTime.now().millisecondsSinceEpoch.toString(),
// // //                   name: nameCtrl.text.trim(),
// // //                   password: pass,
// // //                   pages: selectedPages,
// // //                 );
// // //                 setState(() {
// // //                   if (index != null) {
// // //                     _passwordEntries[index] = newEntry;
// // //                   } else {
// // //                     _passwordEntries.add(newEntry);
// // //                   }
// // //                 });
// // //                 await savePasswordEntries(_passwordEntries);
// // //                 Navigator.pop(ctx);
// // //               },
// // //               child: Text(_t("حفظ", "Save")),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Future<void> _deleteEntry(int index) async {
// // //     final confirm = await showDialog<bool>(
// // //       context: context,
// // //       builder: (_) => AlertDialog(
// // //         title: Text(_t("حذف الباسورد؟", "Delete Password?")),
// // //         content: Text(_t("هل أنت متأكد من حذف هذا الباسورد؟",
// // //             "Are you sure you want to delete this password?")),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context, false),
// // //             child: Text(_t("إلغاء", "Cancel")),
// // //           ),
// // //           ElevatedButton(
// // //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// // //             onPressed: () => Navigator.pop(context, true),
// // //             child: Text(_t("حذف", "Delete"),
// // //                 style: const TextStyle(color: Colors.white)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //     if (confirm == true) {
// // //       setState(() => _passwordEntries.removeAt(index));
// // //       await savePasswordEntries(_passwordEntries);
// // //     }
// // //   }

// // //   // ======== القسم الرئيسي لإدارة الباسوردات ========
// // //   Widget _buildMultiPasswordSection() {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const SizedBox(height: 20),
// // //         Text(
// // //           _t("🔒 إدارة الباسوردات:", "🔒 Password Manager:"),
// // //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 12),
// // //         if (_passwordEntries.isEmpty)
// // //           Padding(
// // //             padding: const EdgeInsets.symmetric(vertical: 8),
// // //             child: Text(
// // //               _t("لا يوجد باسوردات مضافة بعد", "No passwords added yet"),
// // //               style: TextStyle(color: Colors.grey[600]),
// // //             ),
// // //           ),
// // //         ..._passwordEntries
// // //             .asMap()
// // //             .entries
// // //             .map((e) => _buildPasswordCard(e.value, e.key)),
// // //         const SizedBox(height: 12),
// // //         SizedBox(
// // //           width: double.infinity,
// // //           child: ElevatedButton.icon(
// // //             icon: const Icon(Icons.add),
// // //             label: Text(_t("إضافة باسورد جديد", "Add New Password")),
// // //             style: ElevatedButton.styleFrom(
// // //               padding: const EdgeInsets.symmetric(vertical: 14),
// // //               shape: RoundedRectangleBorder(
// // //                   borderRadius: BorderRadius.circular(12)),
// // //             ),
// // //             onPressed: () => _showPasswordDialog(),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildPrintLayoutSection() {
// // //     return Column(
// // //       crossAxisAlignment: CrossAxisAlignment.start,
// // //       children: [
// // //         const SizedBox(height: 20),
// // //         Text(
// // //           _t('🖨️ إعدادات تخطيط الطباعة:', '🖨️ Print Layout Settings:'),
// // //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //         ),
// // //         const SizedBox(height: 6),
// // //         Text(
// // //           _t(
// // //             'حدّد مكان كل عنصر على الاستيكر (نص، QR، لوجو...) بالضبط.',
// // //             'Customize each element\'s position on the label (text, QR, logo...).',
// // //           ),
// // //           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// // //         ),
// // //         const SizedBox(height: 14),
// // //         _layoutButton(
// // //           icon: Icons.grain,
// // //           title: _t('تخطيط استيكر الذهب', 'Gold Label Layout'),
// // //           subtitle: _t('وزن • عيار • مقاس • QR/باركود • لوجو',
// // //               'Weight • Carat • Size • QR/Barcode • Logo'),
// // //           color: const Color(0xFFD4AF37),
// // //           onTap: () => _openLayoutEditor('gold'),
// // //         ),
// // //         const SizedBox(height: 10),
// // //         _layoutButton(
// // //           icon: Icons.view_in_ar,
// // //           title: _t('تخطيط استيكر السبائك', 'Bullion Label Layout'),
// // //           subtitle: _t('وزن • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// // //               'Weight • Note1 • Note2 • QR/Barcode • Logo'),
// // //           color: Colors.blueGrey,
// // //           onTap: () => _openLayoutEditor('bullion'),
// // //         ),
// // //         const SizedBox(height: 10),
// // //         _layoutButton(
// // //           icon: Icons.diamond,
// // //           title: _t('تخطيط استيكر الأحجار', 'Gem Label Layout'),
// // //           subtitle: _t('نوع الحجر • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// // //               'Gem Type • Note1 • Note2 • QR/Barcode • Logo'),
// // //           color: Colors.deepPurple,
// // //           onTap: () => _openLayoutEditor('gem'),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _layoutButton({
// // //     required IconData icon,
// // //     required String title,
// // //     required String subtitle,
// // //     required Color color,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return Material(
// // //       color: Colors.transparent,
// // //       child: InkWell(
// // //         onTap: onTap,
// // //         borderRadius: BorderRadius.circular(14),
// // //         child: Container(
// // //           padding: const EdgeInsets.all(16),
// // //           decoration: BoxDecoration(
// // //             color: color.withOpacity(0.07),
// // //             borderRadius: BorderRadius.circular(14),
// // //             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
// // //           ),
// // //           child: Row(
// // //             children: [
// // //               Container(
// // //                 width: 48,
// // //                 height: 48,
// // //                 decoration: BoxDecoration(
// // //                   color: color.withOpacity(0.15),
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //                 child: Icon(icon, color: color, size: 26),
// // //               ),
// // //               const SizedBox(width: 14),
// // //               Expanded(
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(title,
// // //                         style: const TextStyle(
// // //                             fontSize: 14, fontWeight: FontWeight.bold)),
// // //                     const SizedBox(height: 3),
// // //                     Text(subtitle,
// // //                         style:
// // //                             TextStyle(fontSize: 11, color: Colors.grey[600])),
// // //                   ],
// // //                 ),
// // //               ),
// // //               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void _openLayoutEditor(String type) {
// // //     Navigator.push(
// // //       context,
// // //       MaterialPageRoute(
// // //         builder: (_) => LabelLayoutEditorPage(labelType: type),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Directionality(
// // //       textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           title: Text(_t("الإعدادات", "Settings")),
// // //           backgroundColor: const Color(0xFFD4AF37),
// // //         ),
// // //         body: ListView(
// // //           padding: const EdgeInsets.all(20),
// // //           children: [
// // //             // UID
// // //             Text(
// // //               _t("رقم الفرع الخاص بك", "Number of your branch"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             buildUidCard(uid),
// // //             const SizedBox(height: 12),

// // //             // طريقة عرض الكود
// // //             Text(
// // //               _t("طريقة عرض الكود:", "Code Display Mode:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             RadioListTile<CodeDisplayMode>(
// // //               title: Text(_t("QR Code", "QR Code")),
// // //               value: CodeDisplayMode.qr,
// // //               groupValue: _mode,
// // //               onChanged: (val) {
// // //                 if (val != null) setState(() => _mode = val);
// // //               },
// // //             ),
// // //             RadioListTile<CodeDisplayMode>(
// // //               title: Text(_t("Barcode", "Barcode")),
// // //               value: CodeDisplayMode.barcode,
// // //               groupValue: _mode,
// // //               onChanged: (val) {
// // //                 if (val != null) setState(() => _mode = val);
// // //               },
// // //             ),

// // //             const SizedBox(height: 30),

// // //             // تكرار التقرير
// // //             Text(
// // //               _t("تكرار التقرير:", "Report Frequency:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             RadioListTile<ReportFrequency>(
// // //               title: Text(_t("يومي", "Daily")),
// // //               value: ReportFrequency.daily,
// // //               groupValue: _frequency,
// // //               onChanged: (val) {
// // //                 if (val != null) setState(() => _frequency = val);
// // //               },
// // //             ),
// // //             RadioListTile<ReportFrequency>(
// // //               title: Text(_t("أسبوعي", "Weekly")),
// // //               value: ReportFrequency.weekly,
// // //               groupValue: _frequency,
// // //               onChanged: (val) {
// // //                 if (val != null) setState(() => _frequency = val);
// // //               },
// // //             ),
// // //             RadioListTile<ReportFrequency>(
// // //               title: Text(_t("شهري", "Monthly")),
// // //               value: ReportFrequency.monthly,
// // //               groupValue: _frequency,
// // //               onChanged: (val) {
// // //                 if (val != null) setState(() => _frequency = val);
// // //               },
// // //             ),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),
// // //             const SizedBox(height: 20),

// // //             // 👥 أسماء المستخدمين
// // //             Text(
// // //               _t("👥 أسماء المستخدمين:", "👥 User Names:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: TextField(
// // //                     controller: _userController,
// // //                     decoration: InputDecoration(
// // //                       labelText: _t("أدخل اسم المستخدم", "Enter user name"),
// // //                       border: const OutlineInputBorder(),
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(width: 8),
// // //                 ElevatedButton(
// // //                   onPressed: _addUserName,
// // //                   child: Text(_t("➕ إضافة", "➕ Add")),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 12),
// // //             if (_userNames.isEmpty)
// // //               Text(_t("لا يوجد مستخدمين مسجلين بعد.", "No users added yet.")),
// // //             if (_userNames.isNotEmpty)
// // //               Column(
// // //                 children: _userNames
// // //                     .map((name) => ListTile(
// // //                           title: Text(name),
// // //                           trailing: IconButton(
// // //                             icon: const Icon(Icons.delete, color: Colors.red),
// // //                             onPressed: () => _removeUserName(name),
// // //                           ),
// // //                         ))
// // //                     .toList(),
// // //               ),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),

// // //             // 🔒 إدارة الباسوردات
// // //             _buildMultiPasswordSection(),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),
// // //             const SizedBox(height: 20),

// // //             // ===== إعدادات الماسح الضوئي =====
// // //             Text(
// // //               _t("📷 إعدادات الماسح:", "📷 Scanner Settings:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             RadioListTile<ScannerMode>(
// // //               title: Text(
// // //                   _t("الماسح الأساسي ", "Primary Scanner (Hides input field)")),
// // //               value: ScannerMode.primary,
// // //               groupValue: _scannerMode,
// // //               onChanged: (val) {
// // //                 if (val != null) _saveScannerMode(val);
// // //               },
// // //             ),
// // //             RadioListTile<ScannerMode>(
// // //               title: Text(_t(
// // //                   "الماسح المساعد ", "Secondary Scanner (Shows input field)")),
// // //               value: ScannerMode.secondary,
// // //               groupValue: _scannerMode,
// // //               onChanged: (val) {
// // //                 if (val != null) _saveScannerMode(val);
// // //               },
// // //             ),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),
// // //             const SizedBox(height: 20),

// // //             // ===== 📦 تبويبات صفحة الصندوق =====
// // //             Text(
// // //               _t("📦 تبويبات صفحة الصندوق:", "📦 Cash Box Tabs:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 6),
// // //             Text(
// // //               _t(
// // //                 "اختر التبويبات التي تظهر في صفحة الصندوق.",
// // //                 "Choose which tabs appear on the Cash Box page.",
// // //               ),
// // //               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             SwitchListTile(
// // //               title: Text(_t("صندوق الكسر", "Scrap Box")),
// // //               value: _showScrapBoxTab,
// // //               onChanged: (val) => setState(() => _showScrapBoxTab = val),
// // //             ),
// // //             SwitchListTile(
// // //               title: Text(_t("صندوق اليومي", "Daily Box")),
// // //               value: _showDailyBoxTab,
// // //               onChanged: (val) => setState(() => _showDailyBoxTab = val),
// // //             ),
// // //             SwitchListTile(
// // //               title: Text(_t("الخزنة", "Safe Box")),
// // //               value: _showSafeBoxTab,
// // //               onChanged: (val) => setState(() => _showSafeBoxTab = val),
// // //             ),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),
// // //             const SizedBox(height: 20),

// // //             // 🌐 اللغة
// // //             Text(
// // //               _t("🌐 اللغة:", "🌐 Language:"),
// // //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Row(
// // //               children: [
// // //                 Expanded(
// // //                   child: RadioListTile<String>(
// // //                     title: const Text("العربية"),
// // //                     value: 'ar',
// // //                     groupValue: _selectedLanguage,
// // //                     onChanged: (val) {
// // //                       if (val != null) {
// // //                         setState(() {
// // //                           _selectedLanguage = val;
// // //                           _isArabic = true;
// // //                         });
// // //                       }
// // //                     },
// // //                   ),
// // //                 ),
// // //                 Expanded(
// // //                   child: RadioListTile<String>(
// // //                     title: const Text("English"),
// // //                     value: 'en',
// // //                     groupValue: _selectedLanguage,
// // //                     onChanged: (val) {
// // //                       if (val != null) {
// // //                         setState(() {
// // //                           _selectedLanguage = val;
// // //                           _isArabic = false;
// // //                         });
// // //                       }
// // //                     },
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),

// // //             // 🖨️ إعدادات تخطيط الطباعة
// // //             _buildPrintLayoutSection(),

// // //             const SizedBox(height: 30),
// // //             const Divider(thickness: 1.5),
// // //             const SizedBox(height: 20),

// // //             // شعار المتجر
// // //             const Text(
// // //               "شعار المتجر (اللوجو):",
// // //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Center(
// // //               child: Container(
// // //                 width: 150,
// // //                 height: 150,
// // //                 decoration: BoxDecoration(
// // //                   border: Border.all(color: Colors.grey),
// // //                   borderRadius: BorderRadius.circular(12),
// // //                 ),
// // //                 child: _logoImageBytes != null
// // //                     ? ClipRRect(
// // //                         borderRadius: BorderRadius.circular(12),
// // //                         child:
// // //                             Image.memory(_logoImageBytes!, fit: BoxFit.contain),
// // //                       )
// // //                     : const Icon(Icons.image, size: 60, color: Colors.grey),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Row(
// // //               mainAxisAlignment: MainAxisAlignment.center,
// // //               children: [
// // //                 ElevatedButton.icon(
// // //                   onPressed: _pickLogoImage,
// // //                   icon: const Icon(Icons.photo_library),
// // //                   label: const Text("اختيار لوجو جديد"),
// // //                 ),
// // //                 const SizedBox(width: 10),
// // //                 if (_logoImageBytes != null)
// // //                   ElevatedButton.icon(
// // //                     onPressed: _removeLogo,
// // //                     icon: const Icon(Icons.delete, color: Colors.red),
// // //                     label: const Text("حذف"),
// // //                     style: ElevatedButton.styleFrom(
// // //                         backgroundColor: Colors.red[50]),
// // //                   ),
// // //               ],
// // //             ),

// // //             const SizedBox(height: 30),
// // //             ElevatedButton(
// // //               onPressed: _saveSettings,
// // //               child: Text(_t("💾 حفظ الإعدادات", "💾 Save Settings")),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:restart_app/restart_app.dart';
// // import 'dart:typed_data';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:image/image.dart' as imglib;
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/services.dart';
// // import 'package:uhf_gold_shop/services/kaki_ai_service.dart'
// //     show KakiPasswordService;
// // import 'label_layout_editor.dart';

// // enum CodeDisplayMode { qr, barcode }

// // enum ReportFrequency { daily, weekly, monthly }

// // // ======== تعريف وضع الماسح الضوئي ========
// // enum ScannerMode { primary, secondary }

// // // ======== نموذج الباسورد ========
// // class PasswordEntry {
// //   final String id;
// //   final String name;
// //   final String password;
// //   final List<String> pages;

// //   PasswordEntry({
// //     required this.id,
// //     required this.name,
// //     required this.password,
// //     required this.pages,
// //   });

// //   Map<String, dynamic> toJson() => {
// //         'id': id,
// //         'name': name,
// //         'password': password,
// //         'pages': pages,
// //       };

// //   factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
// //         id: json['id'],
// //         name: json['name'] ?? '',
// //         password: json['password'],
// //         pages: List<String>.from(json['pages'] ?? []),
// //       );
// // }

// // // ======== دوال حفظ وجلب الباسوردات (global) ========
// // Future<void> savePasswordEntries(List<PasswordEntry> entries) async {
// //   final prefs = await SharedPreferences.getInstance();
// //   final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
// //   await prefs.setStringList('passwordEntries', encoded);
// // }

// // Future<List<PasswordEntry>> loadPasswordEntries() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   final encoded = prefs.getStringList('passwordEntries') ?? [];
// //   return encoded.map((s) => PasswordEntry.fromJson(jsonDecode(s))).toList();
// // }

// // // ======== checkPassword (global - بتشتغل مع النظام الجديد) ========
// // Future<bool> checkPassword(BuildContext context, String pageKey) async {
// //   final entries = await loadPasswordEntries();

// //   // إيجاد كل الباسوردات اللي بتحمي الصفحة دي
// //   final guardingEntries =
// //       entries.where((e) => e.pages.contains(pageKey)).toList();

// //   // لو مفيش باسورد بيحمي الصفحة → افتح عادي
// //   if (guardingEntries.isEmpty) return true;

// //   final controller = TextEditingController();
// //   bool accessGranted = false;

// //   await showDialog(
// //     context: context,
// //     barrierDismissible: false,
// //     builder: (_) => AlertDialog(
// //       title: const Text("أدخل الرقم السري"),
// //       content: TextField(
// //         controller: controller,
// //         obscureText: true,
// //         autofocus: true,
// //         decoration: const InputDecoration(
// //           hintText: "الرقم السري",
// //           border: OutlineInputBorder(),
// //         ),
// //         onSubmitted: (_) {
// //           final typed = controller.text.trim();
// //           final valid = guardingEntries.any((e) => e.password == typed);
// //           if (valid) {
// //             accessGranted = true;
// //             Navigator.pop(context);
// //           } else {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// //             );
// //           }
// //         },
// //       ),
// //       actions: [
// //         TextButton(
// //           onPressed: () => Navigator.pop(context),
// //           child: const Text("إلغاء"),
// //         ),
// //         TextButton(
// //           onPressed: () {
// //             final typed = controller.text.trim();
// //             final valid = guardingEntries.any((e) => e.password == typed);
// //             if (valid) {
// //               accessGranted = true;
// //               Navigator.pop(context);
// //             } else {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
// //               );
// //             }
// //           },
// //           child: const Text("تأكيد"),
// //         ),
// //       ],
// //     ),
// //   );

// //   return accessGranted;
// // }

// // // ======== SettingsPage ========
// // class SettingsPage extends StatefulWidget {
// //   const SettingsPage({super.key});

// //   @override
// //   State<SettingsPage> createState() => _SettingsPageState();
// // }

// // class _SettingsPageState extends State<SettingsPage> {
// //   static String get uid => FirebaseAuth.instance.currentUser!.uid;

// //   CodeDisplayMode _mode = CodeDisplayMode.qr;
// //   ReportFrequency _frequency = ReportFrequency.daily;

// //   // ✅ وضع الماسح الضوئي
// //   ScannerMode _scannerMode = ScannerMode.secondary;

// //   // ===== ظهور تبويبات صفحة الصندوق =====
// //   bool _showScrapBoxTab = true;
// //   bool _showDailyBoxTab = true;
// //   bool _showSafeBoxTab = true;

// //   final TextEditingController _userController = TextEditingController();

// //   List<String> _userNames = [];
// //   Map<String, int> _pagePowers = {};

// //   String _selectedLanguage = 'ar';
// //   bool _isArabic = true;

// //   String _t(String ar, String en) => _isArabic ? ar : en;

// //   Uint8List? _logoImageBytes;
// //   String? _logoBase64;

// //   // ======== نظام الباسوردات الجديد ========
// //   List<PasswordEntry> _passwordEntries = [];

// //   // ======== الصفحات المتاحة ========
// //   Map<String, String> get _allPages => _isArabic
// //       ? {
// //           'reports': 'صفحة التقارير',
// //           'inventory': 'صفحة الجرد',
// //           'Setting': 'صفحة الإعدادات',
// //           'Input': 'صفحة الإدخال والرصيد الافتتاحي',
// //           'Daily': 'صفحة الحركة اليومية',
// //           'scrap': 'صفحة الكسر',
// //           'sales': 'صفحة البيع',
// //           'inventoryDepartment': 'صفحة جرد الاقسام',
// //           'Suppliers': 'صفحة الموردين',
// //           'Vouchers': 'صفحة السندات',
// //           'Funds': 'صفحة الاموال',
// //           'Transfers': 'صفحة التحويل',
// //           'edit': 'صفحة التعديل',
// //           'branches': 'صفحة الافرع',
// //           'Transactions': 'صفحة التعاملات',
// //           'Statements': 'صفحة تصريحات الخروج'
// //         }
// //       : {
// //           'reports': 'Reports Page',
// //           'inventory': 'Inventory Page',
// //           'Setting': 'Settings Page',
// //           'Input': 'Input & Opening Balance Page',
// //           'Daily': 'Daily Movement Page',
// //           'scrap': 'Scrap Page',
// //           'sales': 'Sales Page',
// //           'inventoryDepartment': 'Inventory Departments Page',
// //           'Suppliers': 'Suppliers Page',
// //           'Vouchers': 'Vouchers Page',
// //           'Funds': 'Funds Page',
// //           'Transfers': 'Transfers Page',
// //           'edit': 'Edit Page',
// //           'branches': 'Branches Page',
// //           'Transactions': 'Transactions Page',
// //           'Statements': 'Statements Page',
// //         };

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSettings();
// //     _loadLogoFromPrefs();
// //     _loadEntries();
// //     _loadScannerMode(); // ✅ تحميل وضع الماسح
// //   }

// //   // ======== تحميل الباسوردات ========
// //   Future<void> _loadEntries() async {
// //     final entries = await loadPasswordEntries();
// //     setState(() => _passwordEntries = entries);
// //   }

// //   // ======== تحميل وضع الماسح ========
// //   Future<void> _loadScannerMode() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final mode = prefs.getString('scannerMode');
// //     if (mode != null) {
// //       setState(() {
// //         _scannerMode = ScannerMode.values.firstWhere(
// //           (e) => e.name == mode,
// //           orElse: () => ScannerMode.secondary,
// //         );
// //       });
// //     }
// //   }

// //   // ======== حفظ وضع الماسح ========
// //   Future<void> _saveScannerMode(ScannerMode mode) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('scannerMode', mode.name);
// //     setState(() {
// //       _scannerMode = mode;
// //     });
// //   }

// //   Future<void> _loadLogoFromPrefs() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final savedBase64 = prefs.getString('custom_logo_base64');
// //     if (savedBase64 != null && savedBase64.isNotEmpty) {
// //       setState(() {
// //         _logoBase64 = savedBase64;
// //         _logoImageBytes = base64Decode(savedBase64);
// //       });
// //     }
// //   }

// //   Future<void> _pickLogoImage() async {
// //     final picker = ImagePicker();
// //     final pickedFile = await picker.pickImage(
// //       source: ImageSource.gallery,
// //       maxWidth: 400,
// //       maxHeight: 400,
// //       imageQuality: 80,
// //     );

// //     if (pickedFile != null) {
// //       final rawBytes = await pickedFile.readAsBytes();
// //       imglib.Image? img = imglib.decodeImage(rawBytes);
// //       img = imglib.grayscale(img!);

// //       const threshold = 130;
// //       for (int y = 0; y < img.height; y++) {
// //         for (int x = 0; x < img.width; x++) {
// //           final px = img.getPixel(x, y);
// //           final luminance = imglib.getLuminance(px);
// //           if (luminance > threshold) {
// //             img.setPixel(x, y, imglib.ColorInt8.rgb(255, 255, 255));
// //           } else {
// //             img.setPixel(x, y, imglib.ColorInt8.rgb(0, 0, 0));
// //           }
// //         }
// //       }

// //       final pngBytes = imglib.encodePng(img);
// //       final base64String = base64Encode(pngBytes);

// //       setState(() {
// //         _logoImageBytes = pngBytes;
// //         _logoBase64 = base64String;
// //       });

// //       final prefs = await SharedPreferences.getInstance();
// //       await prefs.setString('custom_logo_base64', base64String);

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //             content: Text(
// //                 "تم حفظ اللوجو بعد المعالجة للطباعة اضغط على حفظ الاعدادات للتأكيد")),
// //       );
// //     }
// //   }

// //   Future<void> _removeLogo() async {
// //     setState(() {
// //       _logoImageBytes = null;
// //       _logoBase64 = null;
// //     });
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.remove('custom_logo_base64');
// //   }

// //   Future<void> _loadSettings() async {
// //     final prefs = await SharedPreferences.getInstance();

// //     _selectedLanguage = prefs.getString('languageCode') ?? 'ar';
// //     _isArabic = _selectedLanguage == 'ar';

// //     final savedMode = prefs.getString('displayMode');
// //     if (savedMode != null) {
// //       _mode = CodeDisplayMode.values.firstWhere(
// //         (e) => e.name == savedMode,
// //         orElse: () => CodeDisplayMode.qr,
// //       );
// //     }

// //     final savedFreq = prefs.getString('reportFrequency');
// //     if (savedFreq != null) {
// //       _frequency = ReportFrequency.values.firstWhere(
// //         (e) => e.name == savedFreq,
// //         orElse: () => ReportFrequency.daily,
// //       );
// //     }

// //     _userNames = prefs.getStringList('userNames') ?? [];

// //     final powerJson = prefs.getString('pagePowers');
// //     if (powerJson != null) {
// //       final decoded = json.decode(powerJson);
// //       _pagePowers =
// //           Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
// //     }

// //     // ===== تحميل إعدادات ظهور تبويبات الصندوق =====
// //     _showScrapBoxTab = prefs.getBool('showScrapBoxTab') ?? true;
// //     _showDailyBoxTab = prefs.getBool('showDailyBoxTab') ?? true;
// //     _showSafeBoxTab = prefs.getBool('showSafeBoxTab') ?? true;

// //     setState(() {});
// //   }

// //   Future<void> _saveSettings() async {
// //     final prefs = await SharedPreferences.getInstance();

// //     await prefs.setString('displayMode', _mode.name);
// //     await prefs.setString('reportFrequency', _frequency.name);
// //     await prefs.setStringList('userNames', _userNames);
// //     await prefs.setString('pagePowers', json.encode(_pagePowers));
// //     await prefs.setString('languageCode', _selectedLanguage);
// //     await prefs.setString('scannerMode', _scannerMode.name); // ✅ حفظ وضع الماسح

// //     // ===== حفظ إعدادات ظهور تبويبات الصندوق =====
// //     await prefs.setBool('showScrapBoxTab', _showScrapBoxTab);
// //     await prefs.setBool('showDailyBoxTab', _showDailyBoxTab);
// //     await prefs.setBool('showSafeBoxTab', _showSafeBoxTab);

// //     Restart.restartApp();
// //   }

// //   void _addUserName() {
// //     final name = _userController.text.trim();
// //     if (name.isNotEmpty && !_userNames.contains(name)) {
// //       setState(() {
// //         _userNames.add(name);
// //         _userController.clear();
// //       });
// //     }
// //   }

// //   void _removeUserName(String name) {
// //     setState(() {
// //       _userNames.remove(name);
// //     });
// //   }

// //   Widget buildUidCard(String uid) {
// //     return Container(
// //       margin: const EdgeInsets.all(5),
// //       padding: const EdgeInsets.all(5),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade300),
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: SelectableText(
// //               uid,
// //               style: const TextStyle(
// //                   fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
// //             ),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.copy),
// //             onPressed: () {
// //               Clipboard.setData(ClipboardData(text: uid));
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(content: Text("تم نسخ UID")),
// //               );
// //             },
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   // ======== Widget كارت باسورد واحد ========
// //   Widget _buildPasswordCard(PasswordEntry entry, int index) {
// //     return Card(
// //       margin: const EdgeInsets.symmetric(vertical: 8),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       elevation: 2,
// //       child: ExpansionTile(
// //         title: Text(
// //           entry.name.isEmpty
// //               ? _t("باسورد ${index + 1}", "Password ${index + 1}")
// //               : entry.name,
// //           style: const TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         subtitle: Text(
// //           '${_t("يحمي", "Protects")} ${entry.pages.length} ${_t("صفحة", "page(s)")}',
// //         ),
// //         trailing: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             IconButton(
// //               icon: const Icon(Icons.edit, color: Colors.blue),
// //               onPressed: () =>
// //                   _showPasswordDialog(existing: entry, index: index),
// //             ),
// //             IconButton(
// //               icon: const Icon(Icons.delete, color: Colors.red),
// //               onPressed: () => _deleteEntry(index),
// //             ),
// //           ],
// //         ),
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   _t("الصفحات المحمية:", "Protected pages:"),
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 if (entry.pages.isEmpty)
// //                   Text(
// //                     _t("لا توجد صفحات مختارة", "No pages selected"),
// //                     style: TextStyle(color: Colors.grey[600]),
// //                   ),
// //                 ...entry.pages.map((p) => Padding(
// //                       padding: const EdgeInsets.symmetric(vertical: 2),
// //                       child: Row(
// //                         children: [
// //                           const Icon(Icons.lock, size: 14),
// //                           const SizedBox(width: 6),
// //                           Text(_allPages[p] ?? p),
// //                         ],
// //                       ),
// //                     )),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ======== Dialog الإضافة والتعديل (مشترك) ========
// //   Future<void> _showPasswordDialog({
// //     PasswordEntry? existing,
// //     int? index,
// //   }) async {
// //     final nameCtrl = TextEditingController(text: existing?.name ?? '');
// //     final passCtrl = TextEditingController(text: existing?.password ?? '');
// //     List<String> selectedPages = List.from(existing?.pages ?? []);
// //     bool obscure = true;

// //     await showDialog(
// //       context: context,
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (ctx, setLocal) => AlertDialog(
// //           title: Text(existing == null
// //               ? _t("إضافة باسورد جديد", "Add New Password")
// //               : _t("تعديل الباسورد", "Edit Password")),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 TextField(
// //                   controller: nameCtrl,
// //                   decoration: InputDecoration(
// //                     labelText: _t("اسم وصفي (اختياري)", "Label (optional)"),
// //                     hintText: _t("مثال: باسورد المدير", "e.g. Admin password"),
// //                     border: const OutlineInputBorder(),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: passCtrl,
// //                   obscureText: obscure,
// //                   decoration: InputDecoration(
// //                     labelText: _t("الرقم السري", "Password"),
// //                     border: const OutlineInputBorder(),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                           obscure ? Icons.visibility : Icons.visibility_off),
// //                       onPressed: () => setLocal(() => obscure = !obscure),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Text(
// //                   _t("اختر الصفحات:", "Select Pages:"),
// //                   style: const TextStyle(fontWeight: FontWeight.bold),
// //                 ),
// //                 ..._allPages.entries.map((e) => CheckboxListTile(
// //                       dense: true,
// //                       title: Text(e.value),
// //                       value: selectedPages.contains(e.key),
// //                       onChanged: (val) => setLocal(() {
// //                         if (val == true) {
// //                           selectedPages.add(e.key);
// //                         } else {
// //                           selectedPages.remove(e.key);
// //                         }
// //                       }),
// //                     )),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(ctx),
// //               child: Text(_t("إلغاء", "Cancel")),
// //             ),
// //             ElevatedButton(
// //               onPressed: () async {
// //                 final pass = passCtrl.text.trim();
// //                 if (pass.isEmpty) {
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                         content:
// //                             Text(_t("أدخل الرقم السري", "Enter a password"))),
// //                   );
// //                   return;
// //                 }
// //                 final newEntry = PasswordEntry(
// //                   id: existing?.id ??
// //                       DateTime.now().millisecondsSinceEpoch.toString(),
// //                   name: nameCtrl.text.trim(),
// //                   password: pass,
// //                   pages: selectedPages,
// //                 );
// //                 setState(() {
// //                   if (index != null) {
// //                     _passwordEntries[index] = newEntry;
// //                   } else {
// //                     _passwordEntries.add(newEntry);
// //                   }
// //                 });
// //                 await savePasswordEntries(_passwordEntries);
// //                 Navigator.pop(ctx);
// //               },
// //               child: Text(_t("حفظ", "Save")),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _deleteEntry(int index) async {
// //     final confirm = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text(_t("حذف الباسورد؟", "Delete Password?")),
// //         content: Text(_t("هل أنت متأكد من حذف هذا الباسورد؟",
// //             "Are you sure you want to delete this password?")),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             child: Text(_t("إلغاء", "Cancel")),
// //           ),
// //           ElevatedButton(
// //             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //             onPressed: () => Navigator.pop(context, true),
// //             child: Text(_t("حذف", "Delete"),
// //                 style: const TextStyle(color: Colors.white)),
// //           ),
// //         ],
// //       ),
// //     );
// //     if (confirm == true) {
// //       setState(() => _passwordEntries.removeAt(index));
// //       await savePasswordEntries(_passwordEntries);
// //     }
// //   }

// //   // ======== القسم الرئيسي لإدارة الباسوردات ========
// //   Widget _buildMultiPasswordSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const SizedBox(height: 20),
// //         Text(
// //           _t("🔒 إدارة الباسوردات:", "🔒 Password Manager:"),
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 12),
// //         if (_passwordEntries.isEmpty)
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 8),
// //             child: Text(
// //               _t("لا يوجد باسوردات مضافة بعد", "No passwords added yet"),
// //               style: TextStyle(color: Colors.grey[600]),
// //             ),
// //           ),
// //         ..._passwordEntries
// //             .asMap()
// //             .entries
// //             .map((e) => _buildPasswordCard(e.value, e.key)),
// //         const SizedBox(height: 12),
// //         SizedBox(
// //           width: double.infinity,
// //           child: ElevatedButton.icon(
// //             icon: const Icon(Icons.add),
// //             label: Text(_t("إضافة باسورد جديد", "Add New Password")),
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(vertical: 14),
// //               shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(12)),
// //             ),
// //             onPressed: () => _showPasswordDialog(),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ============================================================
// //   // 🔐 قسم باسورد شات كاكي
// //   // ============================================================
// //   Widget _buildKakiChatPasswordSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           _t("🔐 باسورد شات كاكي:", "🔐 Kaki Chat Password:"),
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(
// //           _t(
// //             ". غيّره لحماية شات كاكي — كل الأجهزة اللي داخلة بنفس الحساب هتطلب الباسورد الجديد.",
// //             ". Change it to protect Kaki Chat — every device signed in with this account will require the new password.",
// //           ),
// //           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// //         ),
// //         const SizedBox(height: 12),
// //         SizedBox(
// //           width: double.infinity,
// //           child: ElevatedButton.icon(
// //             icon: const Icon(Icons.lock_reset),
// //             label: Text(_t("تغيير الباسورد", "Change Password")),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFFD4AF37),
// //               foregroundColor: Colors.white,
// //               padding: const EdgeInsets.symmetric(vertical: 14),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             onPressed: _showKakiPasswordDialog,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ===== Dialog تغيير باسورد شات كاكي =====
// //   Future<void> _showKakiPasswordDialog() async {
// //     final currentCtrl = TextEditingController();
// //     final newCtrl = TextEditingController();
// //     final confirmCtrl = TextEditingController();
// //     bool obscure = true;
// //     bool loading = false;

// //     await showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (ctx) => StatefulBuilder(
// //         builder: (ctx, setLocal) => AlertDialog(
// //           title: Row(
// //             children: [
// //               const Icon(Icons.lock, color: Color(0xFFD4AF37)),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: Text(
// //                   _t("تغيير باسورد شات كاكي", "Change Kaki Chat Password"),
// //                   style: const TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 TextField(
// //                   controller: currentCtrl,
// //                   obscureText: obscure,
// //                   enabled: !loading,
// //                   decoration: InputDecoration(
// //                     labelText: _t("الباسورد الحالي", "Current password"),
// //                     // hintText: _t("الافتراضي: 0000", "Default: 0000"),
// //                     border: const OutlineInputBorder(),
// //                     prefixIcon: const Icon(Icons.lock_outline),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: newCtrl,
// //                   obscureText: obscure,
// //                   enabled: !loading,
// //                   decoration: InputDecoration(
// //                     labelText: _t("الباسورد الجديد", "New password"),
// //                     border: const OutlineInputBorder(),
// //                     prefixIcon: const Icon(Icons.lock_reset),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),
// //                 TextField(
// //                   controller: confirmCtrl,
// //                   obscureText: obscure,
// //                   enabled: !loading,
// //                   decoration: InputDecoration(
// //                     labelText:
// //                         _t("تأكيد الباسورد الجديد", "Confirm new password"),
// //                     border: const OutlineInputBorder(),
// //                     prefixIcon: const Icon(Icons.check_circle_outline),
// //                     suffixIcon: IconButton(
// //                       icon: Icon(
// //                         obscure ? Icons.visibility : Icons.visibility_off,
// //                       ),
// //                       onPressed: () => setLocal(() => obscure = !obscure),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: loading ? null : () => Navigator.pop(ctx),
// //               child: Text(_t("إلغاء", "Cancel")),
// //             ),
// //             ElevatedButton(
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: const Color(0xFFD4AF37),
// //                 foregroundColor: Colors.white,
// //               ),
// //               onPressed: loading
// //                   ? null
// //                   : () async {
// //                       final current = currentCtrl.text.trim();
// //                       final newPass = newCtrl.text.trim();
// //                       final confirm = confirmCtrl.text.trim();

// //                       if (current.isEmpty ||
// //                           newPass.isEmpty ||
// //                           confirm.isEmpty) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content:
// //                                 Text(_t("املأ جميع الحقول", "Fill all fields")),
// //                           ),
// //                         );
// //                         return;
// //                       }
// //                       if (newPass.length < 4) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text(_t(
// //                               "الباسورد لازم 4 أحرف على الأقل",
// //                               "Password must be at least 4 characters",
// //                             )),
// //                           ),
// //                         );
// //                         return;
// //                       }
// //                       if (newPass != confirm) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text(_t(
// //                               "الباسورد الجديد غير متطابق",
// //                               "New passwords don't match",
// //                             )),
// //                           ),
// //                         );
// //                         return;
// //                       }

// //                       setLocal(() => loading = true);
// //                       try {
// //                         final ok =
// //                             await KakiPasswordService.verifyPassword(current);
// //                         if (!ok) {
// //                           setLocal(() => loading = false);
// //                           if (!mounted) return;
// //                           ScaffoldMessenger.of(context).showSnackBar(
// //                             SnackBar(
// //                               content: Text(_t(
// //                                 "❌ الباسورد الحالي غير صحيح",
// //                                 "❌ Current password is wrong",
// //                               )),
// //                             ),
// //                           );
// //                           return;
// //                         }
// //                         await KakiPasswordService.setPassword(newPass);
// //                         if (!mounted) return;
// //                         Navigator.pop(ctx);
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(
// //                             content: Text(_t(
// //                               "✅ تم تغيير الباسورد بنجاح",
// //                               "✅ Password changed successfully",
// //                             )),
// //                           ),
// //                         );
// //                       } catch (e) {
// //                         setLocal(() => loading = false);
// //                         if (!mounted) return;
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(content: Text('$e')),
// //                         );
// //                       }
// //                     },
// //               child: loading
// //                   ? const SizedBox(
// //                       width: 18,
// //                       height: 18,
// //                       child: CircularProgressIndicator(
// //                         strokeWidth: 2,
// //                         color: Colors.white,
// //                       ),
// //                     )
// //                   : Text(_t("حفظ", "Save")),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPrintLayoutSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const SizedBox(height: 20),
// //         Text(
// //           _t('🖨️ إعدادات تخطيط الطباعة:', '🖨️ Print Layout Settings:'),
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(
// //           _t(
// //             'حدّد مكان كل عنصر على الاستيكر (نص، QR، لوجو...) بالضبط.',
// //             'Customize each element\'s position on the label (text, QR, logo...).',
// //           ),
// //           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// //         ),
// //         const SizedBox(height: 14),
// //         _layoutButton(
// //           icon: Icons.grain,
// //           title: _t('تخطيط استيكر الذهب', 'Gold Label Layout'),
// //           subtitle: _t('وزن • عيار • مقاس • QR/باركود • لوجو',
// //               'Weight • Carat • Size • QR/Barcode • Logo'),
// //           color: const Color(0xFFD4AF37),
// //           onTap: () => _openLayoutEditor('gold'),
// //         ),
// //         const SizedBox(height: 10),
// //         _layoutButton(
// //           icon: Icons.view_in_ar,
// //           title: _t('تخطيط استيكر السبائك', 'Bullion Label Layout'),
// //           subtitle: _t('وزن • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// //               'Weight • Note1 • Note2 • QR/Barcode • Logo'),
// //           color: Colors.blueGrey,
// //           onTap: () => _openLayoutEditor('bullion'),
// //         ),
// //         const SizedBox(height: 10),
// //         _layoutButton(
// //           icon: Icons.diamond,
// //           title: _t('تخطيط استيكر الأحجار', 'Gem Label Layout'),
// //           subtitle: _t('نوع الحجر • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
// //               'Gem Type • Note1 • Note2 • QR/Barcode • Logo'),
// //           color: Colors.deepPurple,
// //           onTap: () => _openLayoutEditor('gem'),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _layoutButton({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //     required Color color,
// //     required VoidCallback onTap,
// //   }) {
// //     return Material(
// //       color: Colors.transparent,
// //       child: InkWell(
// //         onTap: onTap,
// //         borderRadius: BorderRadius.circular(14),
// //         child: Container(
// //           padding: const EdgeInsets.all(16),
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.07),
// //             borderRadius: BorderRadius.circular(14),
// //             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
// //           ),
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: 48,
// //                 height: 48,
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.15),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Icon(icon, color: color, size: 26),
// //               ),
// //               const SizedBox(width: 14),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(title,
// //                         style: const TextStyle(
// //                             fontSize: 14, fontWeight: FontWeight.bold)),
// //                     const SizedBox(height: 3),
// //                     Text(subtitle,
// //                         style:
// //                             TextStyle(fontSize: 11, color: Colors.grey[600])),
// //                   ],
// //                 ),
// //               ),
// //               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _openLayoutEditor(String type) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => LabelLayoutEditorPage(labelType: type),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Directionality(
// //       textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text(_t("الإعدادات", "Settings")),
// //           backgroundColor: const Color(0xFFD4AF37),
// //         ),
// //         body: ListView(
// //           padding: const EdgeInsets.all(20),
// //           children: [
// //             // UID
// //             Text(
// //               _t("رقم الفرع الخاص بك", "Number of your branch"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             buildUidCard(uid),
// //             const SizedBox(height: 12),

// //             // طريقة عرض الكود
// //             Text(
// //               _t("طريقة عرض الكود:", "Code Display Mode:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             RadioListTile<CodeDisplayMode>(
// //               title: Text(_t("QR Code", "QR Code")),
// //               value: CodeDisplayMode.qr,
// //               groupValue: _mode,
// //               onChanged: (val) {
// //                 if (val != null) setState(() => _mode = val);
// //               },
// //             ),
// //             RadioListTile<CodeDisplayMode>(
// //               title: Text(_t("Barcode", "Barcode")),
// //               value: CodeDisplayMode.barcode,
// //               groupValue: _mode,
// //               onChanged: (val) {
// //                 if (val != null) setState(() => _mode = val);
// //               },
// //             ),

// //             const SizedBox(height: 30),

// //             // تكرار التقرير
// //             Text(
// //               _t("تكرار التقرير:", "Report Frequency:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             RadioListTile<ReportFrequency>(
// //               title: Text(_t("يومي", "Daily")),
// //               value: ReportFrequency.daily,
// //               groupValue: _frequency,
// //               onChanged: (val) {
// //                 if (val != null) setState(() => _frequency = val);
// //               },
// //             ),
// //             RadioListTile<ReportFrequency>(
// //               title: Text(_t("أسبوعي", "Weekly")),
// //               value: ReportFrequency.weekly,
// //               groupValue: _frequency,
// //               onChanged: (val) {
// //                 if (val != null) setState(() => _frequency = val);
// //               },
// //             ),
// //             RadioListTile<ReportFrequency>(
// //               title: Text(_t("شهري", "Monthly")),
// //               value: ReportFrequency.monthly,
// //               groupValue: _frequency,
// //               onChanged: (val) {
// //                 if (val != null) setState(() => _frequency = val);
// //               },
// //             ),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // 👥 أسماء المستخدمين
// //             Text(
// //               _t("👥 أسماء المستخدمين:", "👥 User Names:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _userController,
// //                     decoration: InputDecoration(
// //                       labelText: _t("أدخل اسم المستخدم", "Enter user name"),
// //                       border: const OutlineInputBorder(),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 ElevatedButton(
// //                   onPressed: _addUserName,
// //                   child: Text(_t("➕ إضافة", "➕ Add")),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             if (_userNames.isEmpty)
// //               Text(_t("لا يوجد مستخدمين مسجلين بعد.", "No users added yet.")),
// //             if (_userNames.isNotEmpty)
// //               Column(
// //                 children: _userNames
// //                     .map((name) => ListTile(
// //                           title: Text(name),
// //                           trailing: IconButton(
// //                             icon: const Icon(Icons.delete, color: Colors.red),
// //                             onPressed: () => _removeUserName(name),
// //                           ),
// //                         ))
// //                     .toList(),
// //               ),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),

// //             // 🔒 إدارة الباسوردات
// //             _buildMultiPasswordSection(),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // ===== إعدادات الماسح الضوئي =====
// //             Text(
// //               _t("📷 إعدادات الماسح:", "📷 Scanner Settings:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             RadioListTile<ScannerMode>(
// //               title: Text(
// //                   _t("الماسح الأساسي ", "Primary Scanner (Hides input field)")),
// //               value: ScannerMode.primary,
// //               groupValue: _scannerMode,
// //               onChanged: (val) {
// //                 if (val != null) _saveScannerMode(val);
// //               },
// //             ),
// //             RadioListTile<ScannerMode>(
// //               title: Text(_t(
// //                   "الماسح المساعد ", "Secondary Scanner (Shows input field)")),
// //               value: ScannerMode.secondary,
// //               groupValue: _scannerMode,
// //               onChanged: (val) {
// //                 if (val != null) _saveScannerMode(val);
// //               },
// //             ),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // ===== 📦 تبويبات صفحة الصندوق =====
// //             Text(
// //               _t("📦 تبويبات صفحة الصندوق:", "📦 Cash Box Tabs:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 6),
// //             Text(
// //               _t(
// //                 "اختر التبويبات التي تظهر في صفحة الصندوق.",
// //                 "Choose which tabs appear on the Cash Box page.",
// //               ),
// //               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
// //             ),
// //             const SizedBox(height: 8),
// //             SwitchListTile(
// //               title: Text(_t("صندوق الكسر", "Scrap Box")),
// //               value: _showScrapBoxTab,
// //               onChanged: (val) => setState(() => _showScrapBoxTab = val),
// //             ),
// //             SwitchListTile(
// //               title: Text(_t("صندوق اليومي", "Daily Box")),
// //               value: _showDailyBoxTab,
// //               onChanged: (val) => setState(() => _showDailyBoxTab = val),
// //             ),
// //             SwitchListTile(
// //               title: Text(_t("الخزنة", "Safe Box")),
// //               value: _showSafeBoxTab,
// //               onChanged: (val) => setState(() => _showSafeBoxTab = val),
// //             ),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // 🌐 اللغة
// //             Text(
// //               _t("🌐 اللغة:", "🌐 Language:"),
// //               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: RadioListTile<String>(
// //                     title: const Text("العربية"),
// //                     value: 'ar',
// //                     groupValue: _selectedLanguage,
// //                     onChanged: (val) {
// //                       if (val != null) {
// //                         setState(() {
// //                           _selectedLanguage = val;
// //                           _isArabic = true;
// //                         });
// //                       }
// //                     },
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: RadioListTile<String>(
// //                     title: const Text("English"),
// //                     value: 'en',
// //                     groupValue: _selectedLanguage,
// //                     onChanged: (val) {
// //                       if (val != null) {
// //                         setState(() {
// //                           _selectedLanguage = val;
// //                           _isArabic = false;
// //                         });
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),

// //             // 🖨️ إعدادات تخطيط الطباعة
// //             _buildPrintLayoutSection(),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // 🔐 باسورد شات كاكي
// //             _buildKakiChatPasswordSection(),

// //             const SizedBox(height: 30),
// //             const Divider(thickness: 1.5),
// //             const SizedBox(height: 20),

// //             // شعار المتجر
// //             const Text(
// //               "شعار المتجر (اللوجو):",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 12),
// //             Center(
// //               child: Container(
// //                 width: 150,
// //                 height: 150,
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.grey),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: _logoImageBytes != null
// //                     ? ClipRRect(
// //                         borderRadius: BorderRadius.circular(12),
// //                         child:
// //                             Image.memory(_logoImageBytes!, fit: BoxFit.contain),
// //                       )
// //                     : const Icon(Icons.image, size: 60, color: Colors.grey),
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 ElevatedButton.icon(
// //                   onPressed: _pickLogoImage,
// //                   icon: const Icon(Icons.photo_library),
// //                   label: const Text("اختيار لوجو جديد"),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 if (_logoImageBytes != null)
// //                   ElevatedButton.icon(
// //                     onPressed: _removeLogo,
// //                     icon: const Icon(Icons.delete, color: Colors.red),
// //                     label: const Text("حذف"),
// //                     style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.red[50]),
// //                   ),
// //               ],
// //             ),

// //             const SizedBox(height: 30),
// //             ElevatedButton(
// //               onPressed: _saveSettings,
// //               child: Text(_t("💾 حفظ الإعدادات", "💾 Save Settings")),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:restart_app/restart_app.dart';
// import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as imglib;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:uhf_gold_shop/services/kaki_ai_service.dart'
//     show KakiPasswordService;
// import 'label_layout_editor.dart';

// enum CodeDisplayMode { qr, barcode }

// enum ReportFrequency { daily, weekly, monthly }

// // ======== تعريف وضع الماسح الضوئي ========
// enum ScannerMode { primary, secondary }

// // ======== نموذج الباسورد ========
// class PasswordEntry {
//   final String id;
//   final String name;
//   final String password;
//   final List<String> pages;

//   PasswordEntry({
//     required this.id,
//     required this.name,
//     required this.password,
//     required this.pages,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//         'password': password,
//         'pages': pages,
//       };

//   factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
//         id: json['id'],
//         name: json['name'] ?? '',
//         password: json['password'],
//         pages: List<String>.from(json['pages'] ?? []),
//       );
// }

// // ======== دوال حفظ وجلب الباسوردات (global) ========
// Future<void> savePasswordEntries(List<PasswordEntry> entries) async {
//   final prefs = await SharedPreferences.getInstance();
//   final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
//   await prefs.setStringList('passwordEntries', encoded);
// }

// Future<List<PasswordEntry>> loadPasswordEntries() async {
//   final prefs = await SharedPreferences.getInstance();
//   final encoded = prefs.getStringList('passwordEntries') ?? [];
//   return encoded.map((s) => PasswordEntry.fromJson(jsonDecode(s))).toList();
// }

// // ======== checkPassword (global - بتشتغل مع النظام الجديد) ========
// Future<bool> checkPassword(BuildContext context, String pageKey) async {
//   final entries = await loadPasswordEntries();

//   // إيجاد كل الباسوردات اللي بتحمي الصفحة دي
//   final guardingEntries =
//       entries.where((e) => e.pages.contains(pageKey)).toList();

//   // لو مفيش باسورد بيحمي الصفحة → افتح عادي
//   if (guardingEntries.isEmpty) return true;

//   final controller = TextEditingController();
//   bool accessGranted = false;

//   await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       title: const Text("أدخل الرقم السري"),
//       content: TextField(
//         controller: controller,
//         obscureText: true,
//         autofocus: true,
//         decoration: const InputDecoration(
//           hintText: "الرقم السري",
//           border: OutlineInputBorder(),
//         ),
//         onSubmitted: (_) {
//           final typed = controller.text.trim();
//           final valid = guardingEntries.any((e) => e.password == typed);
//           if (valid) {
//             accessGranted = true;
//             Navigator.pop(context);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
//             );
//           }
//         },
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("إلغاء"),
//         ),
//         TextButton(
//           onPressed: () {
//             final typed = controller.text.trim();
//             final valid = guardingEntries.any((e) => e.password == typed);
//             if (valid) {
//               accessGranted = true;
//               Navigator.pop(context);
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
//               );
//             }
//           },
//           child: const Text("تأكيد"),
//         ),
//       ],
//     ),
//   );

//   return accessGranted;
// }

// // ======== SettingsPage ========
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   static String get uid => FirebaseAuth.instance.currentUser!.uid;

//   CodeDisplayMode _mode = CodeDisplayMode.qr;
//   ReportFrequency _frequency = ReportFrequency.daily;

//   // ✅ وضع الماسح الضوئي
//   ScannerMode _scannerMode = ScannerMode.secondary;

//   // ===== ظهور تبويبات صفحة الصندوق =====
//   bool _showScrapBoxTab = true;
//   bool _showDailyBoxTab = true;
//   bool _showSafeBoxTab = true;

//   final TextEditingController _userController = TextEditingController();

//   List<String> _userNames = [];
//   Map<String, int> _pagePowers = {};

//   // ✅ تصنيفات الذهب المخصصة
//   List<String> _customGoldTypes = [];
//   final TextEditingController _goldTypeController = TextEditingController();

//   String _selectedLanguage = 'ar';
//   bool _isArabic = true;

//   String _t(String ar, String en) => _isArabic ? ar : en;

//   Uint8List? _logoImageBytes;
//   String? _logoBase64;

//   // ======== نظام الباسوردات الجديد ========
//   List<PasswordEntry> _passwordEntries = [];

//   // ======== الصفحات المتاحة ========
//   Map<String, String> get _allPages => _isArabic
//       ? {
//           'reports': 'صفحة التقارير',
//           'inventory': 'صفحة الجرد',
//           'Setting': 'صفحة الإعدادات',
//           'Input': 'صفحة الإدخال والرصيد الافتتاحي',
//           'Daily': 'صفحة الحركة اليومية',
//           'scrap': 'صفحة الكسر',
//           'sales': 'صفحة البيع',
//           'inventoryDepartment': 'صفحة جرد الاقسام',
//           'Suppliers': 'صفحة الموردين',
//           'Vouchers': 'صفحة السندات',
//           'Funds': 'صفحة الاموال',
//           'Transfers': 'صفحة التحويل',
//           'edit': 'صفحة التعديل',
//           'branches': 'صفحة الافرع',
//           'Transactions': 'صفحة التعاملات',
//           'Statements': 'صفحة تصريحات الخروج'
//         }
//       : {
//           'reports': 'Reports Page',
//           'inventory': 'Inventory Page',
//           'Setting': 'Settings Page',
//           'Input': 'Input & Opening Balance Page',
//           'Daily': 'Daily Movement Page',
//           'scrap': 'Scrap Page',
//           'sales': 'Sales Page',
//           'inventoryDepartment': 'Inventory Departments Page',
//           'Suppliers': 'Suppliers Page',
//           'Vouchers': 'Vouchers Page',
//           'Funds': 'Funds Page',
//           'Transfers': 'Transfers Page',
//           'edit': 'Edit Page',
//           'branches': 'Branches Page',
//           'Transactions': 'Transactions Page',
//           'Statements': 'Statements Page',
//         };

//   @override
//   void initState() {
//     super.initState();
//     _loadSettings();
//     _loadLogoFromPrefs();
//     _loadEntries();
//     _loadScannerMode(); // ✅ تحميل وضع الماسح
//   }

//   // ======== تحميل الباسوردات ========
//   Future<void> _loadEntries() async {
//     final entries = await loadPasswordEntries();
//     setState(() => _passwordEntries = entries);
//   }

//   // ======== تحميل وضع الماسح ========
//   Future<void> _loadScannerMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final mode = prefs.getString('scannerMode');
//     if (mode != null) {
//       setState(() {
//         _scannerMode = ScannerMode.values.firstWhere(
//           (e) => e.name == mode,
//           orElse: () => ScannerMode.secondary,
//         );
//       });
//     }
//   }

//   // ======== حفظ وضع الماسح ========
//   Future<void> _saveScannerMode(ScannerMode mode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('scannerMode', mode.name);
//     setState(() {
//       _scannerMode = mode;
//     });
//   }

//   Future<void> _loadLogoFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedBase64 = prefs.getString('custom_logo_base64');
//     if (savedBase64 != null && savedBase64.isNotEmpty) {
//       setState(() {
//         _logoBase64 = savedBase64;
//         _logoImageBytes = base64Decode(savedBase64);
//       });
//     }
//   }

//   Future<void> _pickLogoImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//       maxWidth: 400,
//       maxHeight: 400,
//       imageQuality: 80,
//     );

//     if (pickedFile != null) {
//       final rawBytes = await pickedFile.readAsBytes();
//       imglib.Image? img = imglib.decodeImage(rawBytes);
//       img = imglib.grayscale(img!);

//       const threshold = 130;
//       for (int y = 0; y < img.height; y++) {
//         for (int x = 0; x < img.width; x++) {
//           final px = img.getPixel(x, y);
//           final luminance = imglib.getLuminance(px);
//           if (luminance > threshold) {
//             img.setPixel(x, y, imglib.ColorInt8.rgb(255, 255, 255));
//           } else {
//             img.setPixel(x, y, imglib.ColorInt8.rgb(0, 0, 0));
//           }
//         }
//       }

//       final pngBytes = imglib.encodePng(img);
//       final base64String = base64Encode(pngBytes);

//       setState(() {
//         _logoImageBytes = pngBytes;
//         _logoBase64 = base64String;
//       });

//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('custom_logo_base64', base64String);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 "تم حفظ اللوجو بعد المعالجة للطباعة اضغط على حفظ الاعدادات للتأكيد")),
//       );
//     }
//   }

//   Future<void> _removeLogo() async {
//     setState(() {
//       _logoImageBytes = null;
//       _logoBase64 = null;
//     });
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('custom_logo_base64');
//   }

//   Future<void> _loadSettings() async {
//     final prefs = await SharedPreferences.getInstance();

//     _selectedLanguage = prefs.getString('languageCode') ?? 'ar';
//     _isArabic = _selectedLanguage == 'ar';

//     final savedMode = prefs.getString('displayMode');
//     if (savedMode != null) {
//       _mode = CodeDisplayMode.values.firstWhere(
//         (e) => e.name == savedMode,
//         orElse: () => CodeDisplayMode.qr,
//       );
//     }

//     final savedFreq = prefs.getString('reportFrequency');
//     if (savedFreq != null) {
//       _frequency = ReportFrequency.values.firstWhere(
//         (e) => e.name == savedFreq,
//         orElse: () => ReportFrequency.daily,
//       );
//     }

//     _userNames = prefs.getStringList('userNames') ?? [];

//     final powerJson = prefs.getString('pagePowers');
//     if (powerJson != null) {
//       final decoded = json.decode(powerJson);
//       _pagePowers =
//           Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
//     }

//     // ===== تحميل إعدادات ظهور تبويبات الصندوق =====
//     _showScrapBoxTab = prefs.getBool('showScrapBoxTab') ?? true;
//     _showDailyBoxTab = prefs.getBool('showDailyBoxTab') ?? true;
//     _showSafeBoxTab = prefs.getBool('showSafeBoxTab') ?? true;

//     // ===== تحميل تصنيفات الذهب المخصصة =====
//     _customGoldTypes = prefs.getStringList('customGoldTypes') ?? [];

//     setState(() {});
//   }

//   Future<void> _saveSettings() async {
//     final prefs = await SharedPreferences.getInstance();

//     await prefs.setString('displayMode', _mode.name);
//     await prefs.setString('reportFrequency', _frequency.name);
//     await prefs.setStringList('userNames', _userNames);
//     await prefs.setString('pagePowers', json.encode(_pagePowers));
//     await prefs.setString('languageCode', _selectedLanguage);
//     await prefs.setString('scannerMode', _scannerMode.name); // ✅ حفظ وضع الماسح

//     // ===== حفظ إعدادات ظهور تبويبات الصندوق =====
//     await prefs.setBool('showScrapBoxTab', _showScrapBoxTab);
//     await prefs.setBool('showDailyBoxTab', _showDailyBoxTab);
//     await prefs.setBool('showSafeBoxTab', _showSafeBoxTab);

//     // ===== حفظ تصنيفات الذهب المخصصة =====
//     await prefs.setStringList('customGoldTypes', _customGoldTypes);

//     Restart.restartApp();
//   }

//   void _addUserName() {
//     final name = _userController.text.trim();
//     if (name.isNotEmpty && !_userNames.contains(name)) {
//       setState(() {
//         _userNames.add(name);
//         _userController.clear();
//       });
//     }
//   }

//   void _removeUserName(String name) {
//     setState(() {
//       _userNames.remove(name);
//     });
//   }

//   // ======== إضافة / حذف تصنيف ذهب مخصص ========
//   Future<void> _addGoldType() async {
//     final type = _goldTypeController.text.trim();
//     if (type.isEmpty) return;
//     if (_customGoldTypes.contains(type)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content:
//               Text(_t("⚠️ التصنيف موجود بالفعل", "⚠️ Type already exists")),
//         ),
//       );
//       return;
//     }
//     setState(() {
//       _customGoldTypes.add(type);
//       _goldTypeController.clear();
//     });
//     // حفظ فوري
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('customGoldTypes', _customGoldTypes);
//   }

//   Future<void> _removeGoldType(String type) async {
//     setState(() {
//       _customGoldTypes.remove(type);
//     });
//     // حفظ فوري
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('customGoldTypes', _customGoldTypes);
//   }

//   Widget buildUidCard(String uid) {
//     return Container(
//       margin: const EdgeInsets.all(5),
//       padding: const EdgeInsets.all(5),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: SelectableText(
//               uid,
//               style: const TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.copy),
//             onPressed: () {
//               Clipboard.setData(ClipboardData(text: uid));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("تم نسخ UID")),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   // ======== Widget كارت باسورد واحد ========
//   Widget _buildPasswordCard(PasswordEntry entry, int index) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: ExpansionTile(
//         title: Text(
//           entry.name.isEmpty
//               ? _t("باسورد ${index + 1}", "Password ${index + 1}")
//               : entry.name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           '${_t("يحمي", "Protects")} ${entry.pages.length} ${_t("صفحة", "page(s)")}',
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.blue),
//               onPressed: () =>
//                   _showPasswordDialog(existing: entry, index: index),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () => _deleteEntry(index),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   _t("الصفحات المحمية:", "Protected pages:"),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 if (entry.pages.isEmpty)
//                   Text(
//                     _t("لا توجد صفحات مختارة", "No pages selected"),
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ...entry.pages.map((p) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.lock, size: 14),
//                           const SizedBox(width: 6),
//                           Text(_allPages[p] ?? p),
//                         ],
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ======== Dialog الإضافة والتعديل (مشترك) ========
//   Future<void> _showPasswordDialog({
//     PasswordEntry? existing,
//     int? index,
//   }) async {
//     final nameCtrl = TextEditingController(text: existing?.name ?? '');
//     final passCtrl = TextEditingController(text: existing?.password ?? '');
//     List<String> selectedPages = List.from(existing?.pages ?? []);
//     bool obscure = true;

//     await showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setLocal) => AlertDialog(
//           title: Text(existing == null
//               ? _t("إضافة باسورد جديد", "Add New Password")
//               : _t("تعديل الباسورد", "Edit Password")),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: nameCtrl,
//                   decoration: InputDecoration(
//                     labelText: _t("اسم وصفي (اختياري)", "Label (optional)"),
//                     hintText: _t("مثال: باسورد المدير", "e.g. Admin password"),
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: passCtrl,
//                   obscureText: obscure,
//                   decoration: InputDecoration(
//                     labelText: _t("الرقم السري", "Password"),
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                           obscure ? Icons.visibility : Icons.visibility_off),
//                       onPressed: () => setLocal(() => obscure = !obscure),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _t("اختر الصفحات:", "Select Pages:"),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 ..._allPages.entries.map((e) => CheckboxListTile(
//                       dense: true,
//                       title: Text(e.value),
//                       value: selectedPages.contains(e.key),
//                       onChanged: (val) => setLocal(() {
//                         if (val == true) {
//                           selectedPages.add(e.key);
//                         } else {
//                           selectedPages.remove(e.key);
//                         }
//                       }),
//                     )),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text(_t("إلغاء", "Cancel")),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final pass = passCtrl.text.trim();
//                 if (pass.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text(_t("أدخل الرقم السري", "Enter a password"))),
//                   );
//                   return;
//                 }
//                 final newEntry = PasswordEntry(
//                   id: existing?.id ??
//                       DateTime.now().millisecondsSinceEpoch.toString(),
//                   name: nameCtrl.text.trim(),
//                   password: pass,
//                   pages: selectedPages,
//                 );
//                 setState(() {
//                   if (index != null) {
//                     _passwordEntries[index] = newEntry;
//                   } else {
//                     _passwordEntries.add(newEntry);
//                   }
//                 });
//                 await savePasswordEntries(_passwordEntries);
//                 Navigator.pop(ctx);
//               },
//               child: Text(_t("حفظ", "Save")),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _deleteEntry(int index) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(_t("حذف الباسورد؟", "Delete Password?")),
//         content: Text(_t("هل أنت متأكد من حذف هذا الباسورد؟",
//             "Are you sure you want to delete this password?")),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(_t("إلغاء", "Cancel")),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () => Navigator.pop(context, true),
//             child: Text(_t("حذف", "Delete"),
//                 style: const TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       setState(() => _passwordEntries.removeAt(index));
//       await savePasswordEntries(_passwordEntries);
//     }
//   }

//   // ======== القسم الرئيسي لإدارة الباسوردات ========
//   Widget _buildMultiPasswordSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(
//           _t("🔒 إدارة الباسوردات:", "🔒 Password Manager:"),
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         if (_passwordEntries.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Text(
//               _t("لا يوجد باسوردات مضافة بعد", "No passwords added yet"),
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//         ..._passwordEntries
//             .asMap()
//             .entries
//             .map((e) => _buildPasswordCard(e.value, e.key)),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.add),
//             label: Text(_t("إضافة باسورد جديد", "Add New Password")),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//             ),
//             onPressed: () => _showPasswordDialog(),
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // 🔐 قسم باسورد شات كاكي
//   // ============================================================
//   Widget _buildKakiChatPasswordSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _t("🔐 باسورد شات كاكي:", "🔐 Kaki Chat Password:"),
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           _t(
//             ". غيّره لحماية شات كاكي — كل الأجهزة اللي داخلة بنفس الحساب هتطلب الباسورد الجديد.",
//             ". Change it to protect Kaki Chat — every device signed in with this account will require the new password.",
//           ),
//           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.lock_reset),
//             label: Text(_t("تغيير الباسورد", "Change Password")),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFD4AF37),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: _showKakiPasswordDialog,
//           ),
//         ),
//       ],
//     );
//   }

//   // ===== Dialog تغيير باسورد شات كاكي =====
//   Future<void> _showKakiPasswordDialog() async {
//     final currentCtrl = TextEditingController();
//     final newCtrl = TextEditingController();
//     final confirmCtrl = TextEditingController();
//     bool obscure = true;
//     bool loading = false;

//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx, setLocal) => AlertDialog(
//           title: Row(
//             children: [
//               const Icon(Icons.lock, color: Color(0xFFD4AF37)),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   _t("تغيير باسورد شات كاكي", "Change Kaki Chat Password"),
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: currentCtrl,
//                   obscureText: obscure,
//                   enabled: !loading,
//                   decoration: InputDecoration(
//                     labelText: _t("الباسورد الحالي", "Current password"),
//                     // hintText: _t("الافتراضي: 0000", "Default: 0000"),
//                     border: const OutlineInputBorder(),
//                     prefixIcon: const Icon(Icons.lock_outline),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: newCtrl,
//                   obscureText: obscure,
//                   enabled: !loading,
//                   decoration: InputDecoration(
//                     labelText: _t("الباسورد الجديد", "New password"),
//                     border: const OutlineInputBorder(),
//                     prefixIcon: const Icon(Icons.lock_reset),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: confirmCtrl,
//                   obscureText: obscure,
//                   enabled: !loading,
//                   decoration: InputDecoration(
//                     labelText:
//                         _t("تأكيد الباسورد الجديد", "Confirm new password"),
//                     border: const OutlineInputBorder(),
//                     prefixIcon: const Icon(Icons.check_circle_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscure ? Icons.visibility : Icons.visibility_off,
//                       ),
//                       onPressed: () => setLocal(() => obscure = !obscure),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: loading ? null : () => Navigator.pop(ctx),
//               child: Text(_t("إلغاء", "Cancel")),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFD4AF37),
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: loading
//                   ? null
//                   : () async {
//                       final current = currentCtrl.text.trim();
//                       final newPass = newCtrl.text.trim();
//                       final confirm = confirmCtrl.text.trim();

//                       if (current.isEmpty ||
//                           newPass.isEmpty ||
//                           confirm.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                                 Text(_t("املأ جميع الحقول", "Fill all fields")),
//                           ),
//                         );
//                         return;
//                       }
//                       if (newPass.length < 4) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(_t(
//                               "الباسورد لازم 4 أحرف على الأقل",
//                               "Password must be at least 4 characters",
//                             )),
//                           ),
//                         );
//                         return;
//                       }
//                       if (newPass != confirm) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(_t(
//                               "الباسورد الجديد غير متطابق",
//                               "New passwords don't match",
//                             )),
//                           ),
//                         );
//                         return;
//                       }

//                       setLocal(() => loading = true);
//                       try {
//                         final ok =
//                             await KakiPasswordService.verifyPassword(current);
//                         if (!ok) {
//                           setLocal(() => loading = false);
//                           if (!mounted) return;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(_t(
//                                 "❌ الباسورد الحالي غير صحيح",
//                                 "❌ Current password is wrong",
//                               )),
//                             ),
//                           );
//                           return;
//                         }
//                         await KakiPasswordService.setPassword(newPass);
//                         if (!mounted) return;
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(_t(
//                               "✅ تم تغيير الباسورد بنجاح",
//                               "✅ Password changed successfully",
//                             )),
//                           ),
//                         );
//                       } catch (e) {
//                         setLocal(() => loading = false);
//                         if (!mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('$e')),
//                         );
//                       }
//                     },
//               child: loading
//                   ? const SizedBox(
//                       width: 18,
//                       height: 18,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : Text(_t("حفظ", "Save")),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPrintLayoutSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(
//           _t('🖨️ إعدادات تخطيط الطباعة:', '🖨️ Print Layout Settings:'),
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           _t(
//             'حدّد مكان كل عنصر على الاستيكر (نص، QR، لوجو...) بالضبط.',
//             'Customize each element\'s position on the label (text, QR, logo...).',
//           ),
//           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 14),
//         _layoutButton(
//           icon: Icons.grain,
//           title: _t('تخطيط استيكر الذهب', 'Gold Label Layout'),
//           subtitle: _t('وزن • عيار • مقاس • QR/باركود • لوجو',
//               'Weight • Carat • Size • QR/Barcode • Logo'),
//           color: const Color(0xFFD4AF37),
//           onTap: () => _openLayoutEditor('gold'),
//         ),
//         const SizedBox(height: 10),
//         _layoutButton(
//           icon: Icons.view_in_ar,
//           title: _t('تخطيط استيكر السبائك', 'Bullion Label Layout'),
//           subtitle: _t('وزن • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
//               'Weight • Note1 • Note2 • QR/Barcode • Logo'),
//           color: Colors.blueGrey,
//           onTap: () => _openLayoutEditor('bullion'),
//         ),
//         const SizedBox(height: 10),
//         _layoutButton(
//           icon: Icons.diamond,
//           title: _t('تخطيط استيكر الأحجار', 'Gem Label Layout'),
//           subtitle: _t('نوع الحجر • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
//               'Gem Type • Note1 • Note2 • QR/Barcode • Logo'),
//           color: Colors.deepPurple,
//           onTap: () => _openLayoutEditor('gem'),
//         ),
//       ],
//     );
//   }

//   Widget _layoutButton({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(14),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.07),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: color, size: 26),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(title,
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 3),
//                     Text(subtitle,
//                         style:
//                             TextStyle(fontSize: 11, color: Colors.grey[600])),
//                   ],
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _openLayoutEditor(String type) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => LabelLayoutEditorPage(labelType: type),
//       ),
//     );
//   }

//   // ============================================================
//   // 🏷️ قسم تصنيفات الذهب المخصصة
//   // ============================================================
//   Widget _buildCustomGoldTypesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           _t("🏷️ تصنيفات الذهب المخصصة:", "🏷️ Custom Gold Types:"),
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           _t(
//             "التصنيفات المضافة هنا ستظهر في أول قائمة النوع في صفحة الإدخال.",
//             "Types added here will appear at the top of the Type list in the Input page.",
//           ),
//           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _goldTypeController,
//                 decoration: InputDecoration(
//                   labelText: _t("اسم التصنيف الجديد", "New type name"),
//                   hintText: _t("مثال: دبلة", "e.g. Ring"),
//                   border: const OutlineInputBorder(),
//                 ),
//                 onSubmitted: (_) => _addGoldType(),
//               ),
//             ),
//             const SizedBox(width: 8),
//             ElevatedButton(
//               onPressed: _addGoldType,
//               child: Text(_t("➕ إضافة", "➕ Add")),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         if (_customGoldTypes.isEmpty)
//           Text(
//             _t("لا توجد تصنيفات مخصصة بعد.", "No custom types yet."),
//             style: TextStyle(color: Colors.grey[600]),
//           ),
//         if (_customGoldTypes.isNotEmpty)
//           Column(
//             children: _customGoldTypes
//                 .map((type) => ListTile(
//                       dense: true,
//                       leading:
//                           const Icon(Icons.label, color: Color(0xFFD4AF37)),
//                       title: Text(type),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete, color: Colors.red),
//                         onPressed: () => _removeGoldType(type),
//                       ),
//                     ))
//                 .toList(),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(_t("الإعدادات", "Settings")),
//           backgroundColor: const Color(0xFFD4AF37),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.all(20),
//           children: [
//             // UID
//             Text(
//               _t("رقم الفرع الخاص بك", "Number of your branch"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             buildUidCard(uid),
//             const SizedBox(height: 12),

//             // طريقة عرض الكود
//             Text(
//               _t("طريقة عرض الكود:", "Code Display Mode:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             RadioListTile<CodeDisplayMode>(
//               title: Text(_t("QR Code", "QR Code")),
//               value: CodeDisplayMode.qr,
//               groupValue: _mode,
//               onChanged: (val) {
//                 if (val != null) setState(() => _mode = val);
//               },
//             ),
//             RadioListTile<CodeDisplayMode>(
//               title: Text(_t("Barcode", "Barcode")),
//               value: CodeDisplayMode.barcode,
//               groupValue: _mode,
//               onChanged: (val) {
//                 if (val != null) setState(() => _mode = val);
//               },
//             ),

//             const SizedBox(height: 30),

//             // تكرار التقرير
//             Text(
//               _t("تكرار التقرير:", "Report Frequency:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             RadioListTile<ReportFrequency>(
//               title: Text(_t("يومي", "Daily")),
//               value: ReportFrequency.daily,
//               groupValue: _frequency,
//               onChanged: (val) {
//                 if (val != null) setState(() => _frequency = val);
//               },
//             ),
//             RadioListTile<ReportFrequency>(
//               title: Text(_t("أسبوعي", "Weekly")),
//               value: ReportFrequency.weekly,
//               groupValue: _frequency,
//               onChanged: (val) {
//                 if (val != null) setState(() => _frequency = val);
//               },
//             ),
//             RadioListTile<ReportFrequency>(
//               title: Text(_t("شهري", "Monthly")),
//               value: ReportFrequency.monthly,
//               groupValue: _frequency,
//               onChanged: (val) {
//                 if (val != null) setState(() => _frequency = val);
//               },
//             ),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // 👥 أسماء المستخدمين
//             Text(
//               _t("👥 أسماء المستخدمين:", "👥 User Names:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _userController,
//                     decoration: InputDecoration(
//                       labelText: _t("أدخل اسم المستخدم", "Enter user name"),
//                       border: const OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _addUserName,
//                   child: Text(_t("➕ إضافة", "➕ Add")),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (_userNames.isEmpty)
//               Text(_t("لا يوجد مستخدمين مسجلين بعد.", "No users added yet.")),
//             if (_userNames.isNotEmpty)
//               Column(
//                 children: _userNames
//                     .map((name) => ListTile(
//                           title: Text(name),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _removeUserName(name),
//                           ),
//                         ))
//                     .toList(),
//               ),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // 🏷️ تصنيفات الذهب المخصصة
//             _buildCustomGoldTypesSection(),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),

//             // 🔒 إدارة الباسوردات
//             _buildMultiPasswordSection(),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // ===== إعدادات الماسح الضوئي =====
//             Text(
//               _t("📷 إعدادات الماسح:", "📷 Scanner Settings:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             RadioListTile<ScannerMode>(
//               title: Text(
//                   _t("الماسح الأساسي ", "Primary Scanner (Hides input field)")),
//               value: ScannerMode.primary,
//               groupValue: _scannerMode,
//               onChanged: (val) {
//                 if (val != null) _saveScannerMode(val);
//               },
//             ),
//             RadioListTile<ScannerMode>(
//               title: Text(_t(
//                   "الماسح المساعد ", "Secondary Scanner (Shows input field)")),
//               value: ScannerMode.secondary,
//               groupValue: _scannerMode,
//               onChanged: (val) {
//                 if (val != null) _saveScannerMode(val);
//               },
//             ),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // ===== 📦 تبويبات صفحة الصندوق =====
//             Text(
//               _t("📦 تبويبات صفحة الصندوق:", "📦 Cash Box Tabs:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               _t(
//                 "اختر التبويبات التي تظهر في صفحة الصندوق.",
//                 "Choose which tabs appear on the Cash Box page.",
//               ),
//               style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 8),
//             SwitchListTile(
//               title: Text(_t("صندوق الكسر", "Scrap Box")),
//               value: _showScrapBoxTab,
//               onChanged: (val) => setState(() => _showScrapBoxTab = val),
//             ),
//             SwitchListTile(
//               title: Text(_t("صندوق اليومي", "Daily Box")),
//               value: _showDailyBoxTab,
//               onChanged: (val) => setState(() => _showDailyBoxTab = val),
//             ),
//             SwitchListTile(
//               title: Text(_t("الخزنة", "Safe Box")),
//               value: _showSafeBoxTab,
//               onChanged: (val) => setState(() => _showSafeBoxTab = val),
//             ),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // 🌐 اللغة
//             Text(
//               _t("🌐 اللغة:", "🌐 Language:"),
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text("العربية"),
//                     value: 'ar',
//                     groupValue: _selectedLanguage,
//                     onChanged: (val) {
//                       if (val != null) {
//                         setState(() {
//                           _selectedLanguage = val;
//                           _isArabic = true;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: RadioListTile<String>(
//                     title: const Text("English"),
//                     value: 'en',
//                     groupValue: _selectedLanguage,
//                     onChanged: (val) {
//                       if (val != null) {
//                         setState(() {
//                           _selectedLanguage = val;
//                           _isArabic = false;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),

//             // 🖨️ إعدادات تخطيط الطباعة
//             _buildPrintLayoutSection(),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // 🔐 باسورد شات كاكي
//             _buildKakiChatPasswordSection(),

//             const SizedBox(height: 30),
//             const Divider(thickness: 1.5),
//             const SizedBox(height: 20),

//             // شعار المتجر
//             const Text(
//               "شعار المتجر (اللوجو):",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Center(
//               child: Container(
//                 width: 150,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: _logoImageBytes != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child:
//                             Image.memory(_logoImageBytes!, fit: BoxFit.contain),
//                       )
//                     : const Icon(Icons.image, size: 60, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _pickLogoImage,
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text("اختيار لوجو جديد"),
//                 ),
//                 const SizedBox(width: 10),
//                 if (_logoImageBytes != null)
//                   ElevatedButton.icon(
//                     onPressed: _removeLogo,
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     label: const Text("حذف"),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red[50]),
//                   ),
//               ],
//             ),

//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _saveSettings,
//               child: Text(_t("💾 حفظ الإعدادات", "💾 Save Settings")),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:uhf_gold_shop/services/kaki_ai_service.dart'
    show KakiPasswordService;
import 'label_layout_editor.dart';
import 'dart:async';

enum CodeDisplayMode { qr, barcode }

enum ReportFrequency { daily, weekly, monthly }

// ======== تعريف وضع الماسح الضوئي ========
enum ScannerMode { primary, secondary }

// ======== نموذج الباسورد ========
class PasswordEntry {
  final String id;
  final String name;
  final String password;
  final List<String> pages;

  PasswordEntry({
    required this.id,
    required this.name,
    required this.password,
    required this.pages,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'pages': pages,
      };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
        id: json['id'],
        name: json['name'] ?? '',
        password: json['password'],
        pages: List<String>.from(json['pages'] ?? []),
      );
}

// ======== دوال حفظ وجلب الباسوردات (global) ========
Future<void> savePasswordEntries(List<PasswordEntry> entries) async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = entries.map((e) => jsonEncode(e.toJson())).toList();
  await prefs.setStringList('passwordEntries', encoded);
}

Future<List<PasswordEntry>> loadPasswordEntries() async {
  final prefs = await SharedPreferences.getInstance();
  final encoded = prefs.getStringList('passwordEntries') ?? [];
  return encoded.map((s) => PasswordEntry.fromJson(jsonDecode(s))).toList();
}

// ======== checkPassword (global - بتشتغل مع النظام الجديد) ========
Future<bool> checkPassword(BuildContext context, String pageKey) async {
  final entries = await loadPasswordEntries();

  // إيجاد كل الباسوردات اللي بتحمي الصفحة دي
  final guardingEntries =
      entries.where((e) => e.pages.contains(pageKey)).toList();

  // لو مفيش باسورد بيحمي الصفحة → افتح عادي
  if (guardingEntries.isEmpty) return true;

  final controller = TextEditingController();
  bool accessGranted = false;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("أدخل الرقم السري"),
      content: TextField(
        controller: controller,
        obscureText: true,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "الرقم السري",
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) {
          final typed = controller.text.trim();
          final valid = guardingEntries.any((e) => e.password == typed);
          if (valid) {
            accessGranted = true;
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        TextButton(
          onPressed: () {
            final typed = controller.text.trim();
            final valid = guardingEntries.any((e) => e.password == typed);
            if (valid) {
              accessGranted = true;
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("❌ الرقم السري غير صحيح")),
              );
            }
          },
          child: const Text("تأكيد"),
        ),
      ],
    ),
  );

  return accessGranted;
}

// ============================================================
// 🏷️ خدمة تصنيفات الذهب المخصصة (Firestore)
// ============================================================
class CustomGoldTypesService {
  static final _db = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _doc() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('customGoldTypes');
  }

  /// Stream للاستماع اللحظي — أي إضافة/حذف بتنعكس فوراً
  static Stream<List<String>> stream() {
    return _doc().snapshots().map((snap) {
      final data = snap.data();
      if (data == null) return <String>[];
      return List<String>.from(data['types'] ?? []);
    });
  }

  /// جلب لمرة واحدة
  static Future<List<String>> getAll() async {
    final snap = await _doc().get();
    final data = snap.data();
    if (data == null) return <String>[];
    return List<String>.from(data['types'] ?? []);
  }

  /// إضافة تصنيف
  static Future<void> add(String type) async {
    await _doc().set({
      'types': FieldValue.arrayUnion([type]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// حذف تصنيف
  static Future<void> remove(String type) async {
    await _doc().set({
      'types': FieldValue.arrayRemove([type]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}

// ======== SettingsPage ========
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  CodeDisplayMode _mode = CodeDisplayMode.qr;
  ReportFrequency _frequency = ReportFrequency.daily;

  // ✅ وضع الماسح الضوئي
  ScannerMode _scannerMode = ScannerMode.secondary;

  // ===== ظهور تبويبات صفحة الصندوق =====
  bool _showScrapBoxTab = true;
  bool _showDailyBoxTab = true;
  bool _showSafeBoxTab = true;

  final TextEditingController _userController = TextEditingController();

  List<String> _userNames = [];
  Map<String, int> _pagePowers = {};

  // ✅ تصنيفات الذهب المخصصة (الآن من Firestore)
  List<String> _customGoldTypes = [];
  final TextEditingController _goldTypeController = TextEditingController();
  StreamSubscription<List<String>>? _goldTypesSub;

  String _selectedLanguage = 'ar';
  bool _isArabic = true;

  String _t(String ar, String en) => _isArabic ? ar : en;

  Uint8List? _logoImageBytes;
  String? _logoBase64;

  // ======== نظام الباسوردات الجديد ========
  List<PasswordEntry> _passwordEntries = [];

  // ======== الصفحات المتاحة ========
  Map<String, String> get _allPages => _isArabic
      ? {
          'reports': 'صفحة التقارير',
          'inventory': 'صفحة الجرد',
          'Setting': 'صفحة الإعدادات',
          'Input': 'صفحة الإدخال والرصيد الافتتاحي',
          'Daily': 'صفحة الحركة اليومية',
          'scrap': 'صفحة الكسر',
          'sales': 'صفحة البيع',
          'inventoryDepartment': 'صفحة جرد الاقسام',
          'Suppliers': 'صفحة الموردين',
          'Vouchers': 'صفحة السندات',
          'Funds': 'صفحة الاموال',
          'Transfers': 'صفحة التحويل',
          'edit': 'صفحة التعديل',
          'branches': 'صفحة الافرع',
          'Transactions': 'صفحة التعاملات',
          'Statements': 'صفحة تصريحات الخروج'
        }
      : {
          'reports': 'Reports Page',
          'inventory': 'Inventory Page',
          'Setting': 'Settings Page',
          'Input': 'Input & Opening Balance Page',
          'Daily': 'Daily Movement Page',
          'scrap': 'Scrap Page',
          'sales': 'Sales Page',
          'inventoryDepartment': 'Inventory Departments Page',
          'Suppliers': 'Suppliers Page',
          'Vouchers': 'Vouchers Page',
          'Funds': 'Funds Page',
          'Transfers': 'Transfers Page',
          'edit': 'Edit Page',
          'branches': 'Branches Page',
          'Transactions': 'Transactions Page',
          'Statements': 'Statements Page',
        };

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadLogoFromPrefs();
    _loadEntries();
    _loadScannerMode(); // ✅ تحميل وضع الماسح
    _listenToCustomGoldTypes(); // ✅ استماع لتصنيفات الذهب من Firestore
  }

  // ======== تحميل الباسوردات ========
  Future<void> _loadEntries() async {
    final entries = await loadPasswordEntries();
    setState(() => _passwordEntries = entries);
  }

  // ======== الاستماع اللحظي لتصنيفات الذهب من Firestore ========
  void _listenToCustomGoldTypes() {
    _goldTypesSub?.cancel();
    _goldTypesSub = CustomGoldTypesService.stream().listen((types) {
      if (!mounted) return;
      setState(() => _customGoldTypes = types);
    });
  }

  // ======== تحميل وضع الماسح ========
  Future<void> _loadScannerMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('scannerMode');
    if (mode != null) {
      setState(() {
        _scannerMode = ScannerMode.values.firstWhere(
          (e) => e.name == mode,
          orElse: () => ScannerMode.secondary,
        );
      });
    }
  }

  // ======== حفظ وضع الماسح ========
  Future<void> _saveScannerMode(ScannerMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('scannerMode', mode.name);
    setState(() {
      _scannerMode = mode;
    });
  }

  Future<void> _loadLogoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedBase64 = prefs.getString('custom_logo_base64');
    if (savedBase64 != null && savedBase64.isNotEmpty) {
      setState(() {
        _logoBase64 = savedBase64;
        _logoImageBytes = base64Decode(savedBase64);
      });
    }
  }

  Future<void> _pickLogoImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final rawBytes = await pickedFile.readAsBytes();
      imglib.Image? img = imglib.decodeImage(rawBytes);
      img = imglib.grayscale(img!);

      const threshold = 130;
      for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
          final px = img.getPixel(x, y);
          final luminance = imglib.getLuminance(px);
          if (luminance > threshold) {
            img.setPixel(x, y, imglib.ColorInt8.rgb(255, 255, 255));
          } else {
            img.setPixel(x, y, imglib.ColorInt8.rgb(0, 0, 0));
          }
        }
      }

      final pngBytes = imglib.encodePng(img);
      final base64String = base64Encode(pngBytes);

      setState(() {
        _logoImageBytes = pngBytes;
        _logoBase64 = base64String;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('custom_logo_base64', base64String);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "تم حفظ اللوجو بعد المعالجة للطباعة اضغط على حفظ الاعدادات للتأكيد")),
      );
    }
  }

  Future<void> _removeLogo() async {
    setState(() {
      _logoImageBytes = null;
      _logoBase64 = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('custom_logo_base64');
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _selectedLanguage = prefs.getString('languageCode') ?? 'ar';
    _isArabic = _selectedLanguage == 'ar';

    final savedMode = prefs.getString('displayMode');
    if (savedMode != null) {
      _mode = CodeDisplayMode.values.firstWhere(
        (e) => e.name == savedMode,
        orElse: () => CodeDisplayMode.qr,
      );
    }

    final savedFreq = prefs.getString('reportFrequency');
    if (savedFreq != null) {
      _frequency = ReportFrequency.values.firstWhere(
        (e) => e.name == savedFreq,
        orElse: () => ReportFrequency.daily,
      );
    }

    _userNames = prefs.getStringList('userNames') ?? [];

    final powerJson = prefs.getString('pagePowers');
    if (powerJson != null) {
      final decoded = json.decode(powerJson);
      _pagePowers =
          Map<String, int>.from(decoded.map((k, v) => MapEntry(k, v as int)));
    }

    // ===== تحميل إعدادات ظهور تبويبات الصندوق =====
    _showScrapBoxTab = prefs.getBool('showScrapBoxTab') ?? true;
    _showDailyBoxTab = prefs.getBool('showDailyBoxTab') ?? true;
    _showSafeBoxTab = prefs.getBool('showSafeBoxTab') ?? true;

    setState(() {});
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('displayMode', _mode.name);
    await prefs.setString('reportFrequency', _frequency.name);
    await prefs.setStringList('userNames', _userNames);
    await prefs.setString('pagePowers', json.encode(_pagePowers));
    await prefs.setString('languageCode', _selectedLanguage);
    await prefs.setString('scannerMode', _scannerMode.name); // ✅ حفظ وضع الماسح

    // ===== حفظ إعدادات ظهور تبويبات الصندوق =====
    await prefs.setBool('showScrapBoxTab', _showScrapBoxTab);
    await prefs.setBool('showDailyBoxTab', _showDailyBoxTab);
    await prefs.setBool('showSafeBoxTab', _showSafeBoxTab);

    Restart.restartApp();
  }

  void _addUserName() {
    final name = _userController.text.trim();
    if (name.isNotEmpty && !_userNames.contains(name)) {
      setState(() {
        _userNames.add(name);
        _userController.clear();
      });
    }
  }

  void _removeUserName(String name) {
    setState(() {
      _userNames.remove(name);
    });
  }

  // ======== إضافة / حذف تصنيف ذهب مخصص (Firestore) ========
  Future<void> _addGoldType() async {
    final type = _goldTypeController.text.trim();
    if (type.isEmpty) return;
    if (_customGoldTypes.contains(type)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(_t("⚠️ التصنيف موجود بالفعل", "⚠️ Type already exists")),
        ),
      );
      return;
    }
    try {
      await CustomGoldTypesService.add(type);
      _goldTypeController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t("✅ تم إضافة التصنيف", "✅ Type added")),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_t("❌ فشل الإضافة", "❌ Failed to add")}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeGoldType(String type) async {
    try {
      await CustomGoldTypesService.remove(type);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t("✅ تم حذف التصنيف", "✅ Type removed")),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_t("❌ فشل الحذف", "❌ Failed to remove")}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _goldTypesSub?.cancel();
    _userController.dispose();
    _goldTypeController.dispose();
    super.dispose();
  }

  Widget buildUidCard(String uid) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              uid,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: uid));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم نسخ UID")),
              );
            },
          )
        ],
      ),
    );
  }

  // ======== Widget كارت باسورد واحد ========
  Widget _buildPasswordCard(PasswordEntry entry, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          entry.name.isEmpty
              ? _t("باسورد ${index + 1}", "Password ${index + 1}")
              : entry.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_t("يحمي", "Protects")} ${entry.pages.length} ${_t("صفحة", "page(s)")}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () =>
                  _showPasswordDialog(existing: entry, index: index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteEntry(index),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t("الصفحات المحمية:", "Protected pages:"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (entry.pages.isEmpty)
                  Text(
                    _t("لا توجد صفحات مختارة", "No pages selected"),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ...entry.pages.map((p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.lock, size: 14),
                          const SizedBox(width: 6),
                          Text(_allPages[p] ?? p),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======== Dialog الإضافة والتعديل (مشترك) ========
  Future<void> _showPasswordDialog({
    PasswordEntry? existing,
    int? index,
  }) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final passCtrl = TextEditingController(text: existing?.password ?? '');
    List<String> selectedPages = List.from(existing?.pages ?? []);
    bool obscure = true;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(existing == null
              ? _t("إضافة باسورد جديد", "Add New Password")
              : _t("تعديل الباسورد", "Edit Password")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: _t("اسم وصفي (اختياري)", "Label (optional)"),
                    hintText: _t("مثال: باسورد المدير", "e.g. Admin password"),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: _t("الرقم السري", "Password"),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setLocal(() => obscure = !obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _t("اختر الصفحات:", "Select Pages:"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ..._allPages.entries.map((e) => CheckboxListTile(
                      dense: true,
                      title: Text(e.value),
                      value: selectedPages.contains(e.key),
                      onChanged: (val) => setLocal(() {
                        if (val == true) {
                          selectedPages.add(e.key);
                        } else {
                          selectedPages.remove(e.key);
                        }
                      }),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(_t("إلغاء", "Cancel")),
            ),
            ElevatedButton(
              onPressed: () async {
                final pass = passCtrl.text.trim();
                if (pass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(_t("أدخل الرقم السري", "Enter a password"))),
                  );
                  return;
                }
                final newEntry = PasswordEntry(
                  id: existing?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text.trim(),
                  password: pass,
                  pages: selectedPages,
                );
                setState(() {
                  if (index != null) {
                    _passwordEntries[index] = newEntry;
                  } else {
                    _passwordEntries.add(newEntry);
                  }
                });
                await savePasswordEntries(_passwordEntries);
                Navigator.pop(ctx);
              },
              child: Text(_t("حفظ", "Save")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEntry(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t("حذف الباسورد؟", "Delete Password?")),
        content: Text(_t("هل أنت متأكد من حذف هذا الباسورد؟",
            "Are you sure you want to delete this password?")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t("حذف", "Delete"),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _passwordEntries.removeAt(index));
      await savePasswordEntries(_passwordEntries);
    }
  }

  // ======== القسم الرئيسي لإدارة الباسوردات ========
  Widget _buildMultiPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          _t("🔒 إدارة الباسوردات:", "🔒 Password Manager:"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_passwordEntries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _t("لا يوجد باسوردات مضافة بعد", "No passwords added yet"),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ..._passwordEntries
            .asMap()
            .entries
            .map((e) => _buildPasswordCard(e.value, e.key)),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(_t("إضافة باسورد جديد", "Add New Password")),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _showPasswordDialog(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 🔐 قسم باسورد شات كاكي
  // ============================================================
  Widget _buildKakiChatPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t("🔐 باسورد شات كاكي:", "🔐 Kaki Chat Password:"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          _t(
            ". غيّره لحماية شات كاكي — كل الأجهزة اللي داخلة بنفس الحساب هتطلب الباسورد الجديد.",
            ". Change it to protect Kaki Chat — every device signed in with this account will require the new password.",
          ),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.lock_reset),
            label: Text(_t("تغيير الباسورد", "Change Password")),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _showKakiPasswordDialog,
          ),
        ),
      ],
    );
  }

  // ===== Dialog تغيير باسورد شات كاكي =====
  Future<void> _showKakiPasswordDialog() async {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    bool obscure = true;
    bool loading = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.lock, color: Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _t("تغيير باسورد شات كاكي", "Change Kaki Chat Password"),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentCtrl,
                  obscureText: obscure,
                  enabled: !loading,
                  decoration: InputDecoration(
                    labelText: _t("الباسورد الحالي", "Current password"),
                    // hintText: _t("الافتراضي: 0000", "Default: 0000"),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newCtrl,
                  obscureText: obscure,
                  enabled: !loading,
                  decoration: InputDecoration(
                    labelText: _t("الباسورد الجديد", "New password"),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_reset),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmCtrl,
                  obscureText: obscure,
                  enabled: !loading,
                  decoration: InputDecoration(
                    labelText:
                        _t("تأكيد الباسورد الجديد", "Confirm new password"),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.check_circle_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setLocal(() => obscure = !obscure),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.pop(ctx),
              child: Text(_t("إلغاء", "Cancel")),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.white,
              ),
              onPressed: loading
                  ? null
                  : () async {
                      final current = currentCtrl.text.trim();
                      final newPass = newCtrl.text.trim();
                      final confirm = confirmCtrl.text.trim();

                      if (current.isEmpty ||
                          newPass.isEmpty ||
                          confirm.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(_t("املأ جميع الحقول", "Fill all fields")),
                          ),
                        );
                        return;
                      }
                      if (newPass.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_t(
                              "الباسورد لازم 4 أحرف على الأقل",
                              "Password must be at least 4 characters",
                            )),
                          ),
                        );
                        return;
                      }
                      if (newPass != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_t(
                              "الباسورد الجديد غير متطابق",
                              "New passwords don't match",
                            )),
                          ),
                        );
                        return;
                      }

                      setLocal(() => loading = true);
                      try {
                        final ok =
                            await KakiPasswordService.verifyPassword(current);
                        if (!ok) {
                          setLocal(() => loading = false);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_t(
                                "❌ الباسورد الحالي غير صحيح",
                                "❌ Current password is wrong",
                              )),
                            ),
                          );
                          return;
                        }
                        await KakiPasswordService.setPassword(newPass);
                        if (!mounted) return;
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_t(
                              "✅ تم تغيير الباسورد بنجاح",
                              "✅ Password changed successfully",
                            )),
                          ),
                        );
                      } catch (e) {
                        setLocal(() => loading = false);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$e')),
                        );
                      }
                    },
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_t("حفظ", "Save")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintLayoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          _t('🖨️ إعدادات تخطيط الطباعة:', '🖨️ Print Layout Settings:'),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          _t(
            'حدّد مكان كل عنصر على الاستيكر (نص، QR، لوجو...) بالضبط.',
            'Customize each element\'s position on the label (text, QR, logo...).',
          ),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 14),
        _layoutButton(
          icon: Icons.grain,
          title: _t('تخطيط استيكر الذهب', 'Gold Label Layout'),
          subtitle: _t('وزن • عيار • مقاس • QR/باركود • لوجو',
              'Weight • Carat • Size • QR/Barcode • Logo'),
          color: const Color(0xFFD4AF37),
          onTap: () => _openLayoutEditor('gold'),
        ),
        const SizedBox(height: 10),
        _layoutButton(
          icon: Icons.view_in_ar,
          title: _t('تخطيط استيكر السبائك', 'Bullion Label Layout'),
          subtitle: _t('وزن • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
              'Weight • Note1 • Note2 • QR/Barcode • Logo'),
          color: Colors.blueGrey,
          onTap: () => _openLayoutEditor('bullion'),
        ),
        const SizedBox(height: 10),
        _layoutButton(
          icon: Icons.diamond,
          title: _t('تخطيط استيكر الأحجار', 'Gem Label Layout'),
          subtitle: _t('نوع الحجر • ملاحظة 1 • ملاحظة 2 • QR/باركود • لوجو',
              'Gem Type • Note1 • Note2 • QR/Barcode • Logo'),
          color: Colors.deepPurple,
          onTap: () => _openLayoutEditor('gem'),
        ),
      ],
    );
  }

  Widget _layoutButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _openLayoutEditor(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LabelLayoutEditorPage(labelType: type),
      ),
    );
  }

  // ============================================================
  // 🏷️ قسم تصنيفات الذهب المخصصة (Firestore)
  // ============================================================
  Widget _buildCustomGoldTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t("🏷️ تصنيفات الذهب المخصصة:", "🏷️ Custom Gold Types:"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          _t(
            "التصنيفات المضافة هنا ستظهر في أول قائمة النوع في صفحة الإدخال، ومتزامنة عبر كل الأجهزة.",
            "Types added here will appear at the top of the Type list in the Input page, synced across all devices.",
          ),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _goldTypeController,
                decoration: InputDecoration(
                  labelText: _t("اسم التصنيف الجديد", "New type name"),
                  hintText: _t("مثال: دبلة", "e.g. Ring"),
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addGoldType(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addGoldType,
              child: Text(_t("➕ إضافة", "➕ Add")),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_customGoldTypes.isEmpty)
          Text(
            _t("لا توجد تصنيفات مخصصة بعد.", "No custom types yet."),
            style: TextStyle(color: Colors.grey[600]),
          ),
        if (_customGoldTypes.isNotEmpty)
          Column(
            children: _customGoldTypes
                .map((type) => ListTile(
                      dense: true,
                      leading:
                          const Icon(Icons.label, color: Color(0xFFD4AF37)),
                      title: Text(type),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeGoldType(type),
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_t("الإعدادات", "Settings")),
          backgroundColor: const Color(0xFFD4AF37),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // UID
            Text(
              _t("رقم الفرع الخاص بك", "Number of your branch"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            buildUidCard(uid),
            const SizedBox(height: 12),

            // طريقة عرض الكود
            Text(
              _t("طريقة عرض الكود:", "Code Display Mode:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioListTile<CodeDisplayMode>(
              title: Text(_t("QR Code", "QR Code")),
              value: CodeDisplayMode.qr,
              groupValue: _mode,
              onChanged: (val) {
                if (val != null) setState(() => _mode = val);
              },
            ),
            RadioListTile<CodeDisplayMode>(
              title: Text(_t("Barcode", "Barcode")),
              value: CodeDisplayMode.barcode,
              groupValue: _mode,
              onChanged: (val) {
                if (val != null) setState(() => _mode = val);
              },
            ),

            const SizedBox(height: 30),

            // تكرار التقرير
            Text(
              _t("تكرار التقرير:", "Report Frequency:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioListTile<ReportFrequency>(
              title: Text(_t("يومي", "Daily")),
              value: ReportFrequency.daily,
              groupValue: _frequency,
              onChanged: (val) {
                if (val != null) setState(() => _frequency = val);
              },
            ),
            RadioListTile<ReportFrequency>(
              title: Text(_t("أسبوعي", "Weekly")),
              value: ReportFrequency.weekly,
              groupValue: _frequency,
              onChanged: (val) {
                if (val != null) setState(() => _frequency = val);
              },
            ),
            RadioListTile<ReportFrequency>(
              title: Text(_t("شهري", "Monthly")),
              value: ReportFrequency.monthly,
              groupValue: _frequency,
              onChanged: (val) {
                if (val != null) setState(() => _frequency = val);
              },
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // 👥 أسماء المستخدمين
            Text(
              _t("👥 أسماء المستخدمين:", "👥 User Names:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: _t("أدخل اسم المستخدم", "Enter user name"),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addUserName,
                  child: Text(_t("➕ إضافة", "➕ Add")),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_userNames.isEmpty)
              Text(_t("لا يوجد مستخدمين مسجلين بعد.", "No users added yet.")),
            if (_userNames.isNotEmpty)
              Column(
                children: _userNames
                    .map((name) => ListTile(
                          title: Text(name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeUserName(name),
                          ),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // 🏷️ تصنيفات الذهب المخصصة
            _buildCustomGoldTypesSection(),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),

            // 🔒 إدارة الباسوردات
            _buildMultiPasswordSection(),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // ===== إعدادات الماسح الضوئي =====
            Text(
              _t("📷 إعدادات الماسح:", "📷 Scanner Settings:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioListTile<ScannerMode>(
              title: Text(
                  _t("الماسح الأساسي ", "Primary Scanner (Hides input field)")),
              value: ScannerMode.primary,
              groupValue: _scannerMode,
              onChanged: (val) {
                if (val != null) _saveScannerMode(val);
              },
            ),
            RadioListTile<ScannerMode>(
              title: Text(_t(
                  "الماسح المساعد ", "Secondary Scanner (Shows input field)")),
              value: ScannerMode.secondary,
              groupValue: _scannerMode,
              onChanged: (val) {
                if (val != null) _saveScannerMode(val);
              },
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // ===== 📦 تبويبات صفحة الصندوق =====
            Text(
              _t("📦 تبويبات صفحة الصندوق:", "📦 Cash Box Tabs:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              _t(
                "اختر التبويبات التي تظهر في صفحة الصندوق.",
                "Choose which tabs appear on the Cash Box page.",
              ),
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(_t("صندوق الكسر", "Scrap Box")),
              value: _showScrapBoxTab,
              onChanged: (val) => setState(() => _showScrapBoxTab = val),
            ),
            SwitchListTile(
              title: Text(_t("صندوق اليومي", "Daily Box")),
              value: _showDailyBoxTab,
              onChanged: (val) => setState(() => _showDailyBoxTab = val),
            ),
            SwitchListTile(
              title: Text(_t("الخزنة", "Safe Box")),
              value: _showSafeBoxTab,
              onChanged: (val) => setState(() => _showSafeBoxTab = val),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // 🌐 اللغة
            Text(
              _t("🌐 اللغة:", "🌐 Language:"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("العربية"),
                    value: 'ar',
                    groupValue: _selectedLanguage,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLanguage = val;
                          _isArabic = true;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text("English"),
                    value: 'en',
                    groupValue: _selectedLanguage,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedLanguage = val;
                          _isArabic = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),

            // 🖨️ إعدادات تخطيط الطباعة
            _buildPrintLayoutSection(),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // 🔐 باسورد شات كاكي
            _buildKakiChatPasswordSection(),

            const SizedBox(height: 30),
            const Divider(thickness: 1.5),
            const SizedBox(height: 20),

            // شعار المتجر
            const Text(
              "شعار المتجر (اللوجو):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _logoImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            Image.memory(_logoImageBytes!, fit: BoxFit.contain),
                      )
                    : const Icon(Icons.image, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickLogoImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text("اختيار لوجو جديد"),
                ),
                const SizedBox(width: 10),
                if (_logoImageBytes != null)
                  ElevatedButton.icon(
                    onPressed: _removeLogo,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text("حذف"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[50]),
                  ),
              ],
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text(_t("💾 حفظ الإعدادات", "💾 Save Settings")),
            ),
          ],
        ),
      ),
    );
  }
}
