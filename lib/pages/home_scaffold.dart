// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import '../services/firestore_service.dart';
// // import 'input_page.dart';
// // import 'inventory_page.dart';
// // import 'sales_page.dart';
// // import 'reports_page.dart';
// // import 'scrap_page.dart';
// // import 'settings_page.dart';
// // import 'inventory_department.dart';

// // import 'daily_transactions_page.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'settings_page.dart' show checkPassword;
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:flutter/services.dart';

// // // ✅ تحميل اللغة المختارة
// // Future<String> getSelectedLanguage() async {
// //   final prefs = await SharedPreferences.getInstance();
// //   return prefs.getString('languageCode') ?? 'ar';
// // }

// // // ✅ دالة الترجمة
// // String _t(String key, String lang) {
// //   final map = {
// //     'ar': {
// //       'settings': 'الإعدادات',
// //       'store': 'المتجر',
// //       'input': 'الإدخال',
// //       'opening': 'ر.الافتتاحي',
// //       'scrap': 'الكسر',
// //       'reports': 'التقارير',
// //       'inventory': 'الجرد',
// //       'sales': 'البيع',
// //       'edit': 'التعديل',
// //       'daily': 'الحركة اليومية',
// //       'branches': 'الأفرع',
// //       'logout': 'تسجيل الخروج',
// //       'confirm_logout': 'هل أنت متأكد من تسجيل الخروج؟',
// //       'cancel': 'إلغاء',
// //       'confirm': 'تسجيل الخروج',
// //       'buy_devices': 'لشراء الاستيكرات والأجهزة',
// //       'app_name': 'KAKi RFID',
// //       'inventoryDepartment': 'جرد الاقسام'
// //     },
// //     'en': {
// //       'settings': 'Settings',
// //       'store': 'Store',
// //       'input': 'Input',
// //       'opening': 'O.Balance',
// //       'scrap': 'Scrap',
// //       'reports': 'Reports',
// //       'inventory': 'Inventory',
// //       'sales': 'Sales',
// //       'edit': 'Edit',
// //       'daily': 'Daily Transactions',
// //       'branches': 'Branches',
// //       'logout': 'Logout',
// //       'confirm_logout': 'Are you sure you want to logout?',
// //       'cancel': 'Cancel',
// //       'confirm': 'Logout',
// //       'buy_devices': 'Buy Stickers & Devices',
// //       'app_name': 'KAKi RFID',
// //       'inventoryDepartment': 'Inventory Departments'
// //     },
// //   };

// //   return map[lang]?[key] ?? key;
// // }

// // class HomeScaffold extends StatefulWidget {
// //   const HomeScaffold({super.key});

// //   @override
// //   State<HomeScaffold> createState() => _HomeScaffoldState();
// // }

// // class _HomeScaffoldState extends State<HomeScaffold> {
// //   String _lang = 'ar';
// //   String? _userEmail; // ← جديد: لتخزين الإيميل
// //   //String? _Uid;
// //   //final uhf = UhfService();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadLang();
// //     _loadUserEmail(); // ← تحميل الإيميل عند بدء الصفحة
// //     /*uhf.listenItemsLive();  // تحميل مباشر

// //     uhf.connect("10.0.0.1");
// //     uhf.listen();*/
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       FS.listenForTransfers(context);
// //     });
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       FS.listenToTransferUpdates();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     FS.stopListening();
// //     FS.cancelTransferListener();
// //     super.dispose();
// //   }

// //   Future<void> _loadLang() async {
// //     _lang = await getSelectedLanguage();
// //     setState(() {});
// //   }

// //   // ← دالة جديدة: جلب الإيميل
// //   void _loadUserEmail() {
// //     final user = FirebaseAuth.instance.currentUser;
// //     //final uid = FirebaseAuth.instance.currentUser!.uid;
// //     setState(() {
// //       _userEmail = user?.email ?? 'مستخدم غير معروف';
// //       //_Uid = uid;
// //       // لو حابب تعرض اسم المستخدم بدل الإيميل:
// //       // _userEmail = user?.displayName ?? user?.email ?? 'مستخدم';
// //     });
// //   }

// //   void _openPage(BuildContext context, Widget page) async {
// //     String? pageKey;

// //     if (page is ReportsPage)
// //       pageKey = 'reports';
// //     else if (page is InventoryPage)
// //       pageKey = 'inventory';
// //     else if (page is InventoryDepartment)
// //       pageKey = 'inventoryDepartment';
// //     else if (page is SalesPage)
// //       pageKey = 'sales';
// //     else if (page is ScrapPage)
// //       pageKey = 'scrap';
// //     else if (page is SettingsPage)
// //       pageKey = 'Setting';
// //     else if (page is DailyTransactionsPage)
// //       pageKey = 'Daily';
// //     else if (page is InputPage) pageKey = 'Input';

// //     if (pageKey != null) {
// //       final allowed = await checkPassword(context, pageKey);
// //       if (!allowed) return;
// //     }

// //     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
// //   }

// //   Future<void> _openWebsite() async {
// //     final Uri url = Uri.parse("http://www.kaki.live/");
// //     if (!await launchUrl(
// //       url,
// //       mode: LaunchMode.externalApplication,
// //     )) {
// //       throw Exception('Could not launch $url');
// //     }
// //   }

// //   Future<void> _copyToClipboard(String text, BuildContext context) async {
// //     await Clipboard.setData(ClipboardData(text: text));
// //     if (context.mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('تم نسخ: $text')),
// //       );
// //     }
// //   }

// //   /*Widget _priceRow(String title, double price) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(fontSize: 14),
// //           ),
// //           Text(
// //             '${price.toStringAsFixed(2)} ريال',
// //             style: const TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFFD4AF37),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }*/
// //   Widget _goldTile(String title, double price) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 8),
// //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           begin: Alignment.centerRight,
// //           end: Alignment.centerLeft,
// //           colors: [
// //             Color(0xFFFFF4D6),
// //             Color(0xFFFFFFFF),
// //           ],
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(
// //           color: Color(0xFFD4AF37),
// //           width: 0.7,
// //         ),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Text(
// //               title,
// //               style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color(0xFFD4AF37),
// //               ),
// //             ),
// //           ),
// //           Text(
// //             '${price.toStringAsFixed(2)} ريال',
// //             style: const TextStyle(
// //               fontSize: 12,
// //               fontWeight: FontWeight.w600,
// //               color: Color(0xFFD4AF37),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     final colorScheme = theme.colorScheme;

// //     return Scaffold(
// //       appBar: AppBar(
// //         flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [
// //                 const Color(0xFFD4AF37).withOpacity(0.9),
// //                 const Color(0xFFB8860B).withOpacity(0.8),
// //               ],
// //             ),
// //           ),
// //         ),
// //         // إزالة الـ title العادي واستبداله بـ Row مخصص
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             // ✅ الجانب الأيسر (شمال في RTL) → الإعدادات + المتجر
// //             PopupMenuButton<String>(
// //               icon: const Icon(Icons.menu, color: Colors.white),
// //               onSelected: (value) async {
// //                 if (value == 'settings') {
// //                   _openPage(context, const SettingsPage());
// //                 }

// //                 if (value == 'support') {
// //                   showDialog(
// //                     context: context,
// //                     builder: (context) => AlertDialog(
// //                       backgroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(16),
// //                       ),
// //                       title: const Text(
// //                         'خدمة العملاء',
// //                         textAlign: TextAlign.center,
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           color: Color(0xFFD4AF37),
// //                         ),
// //                       ),
// //                       contentPadding: const EdgeInsets.symmetric(
// //                           horizontal: 24, vertical: 16),
// //                       content: ConstrainedBox(
// //                         constraints:
// //                             const BoxConstraints(minWidth: 300, maxWidth: 400),
// //                         child: SingleChildScrollView(
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               // اتصال
// //                               ListTile(
// //                                 leading: const Icon(Icons.phone,
// //                                     color: Color(0xFFD4AF37)),
// //                                 title: const Text(
// //                                   '0544441037',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500),
// //                                 ),
// //                                 trailing: IconButton(
// //                                   icon: const Icon(Icons.copy,
// //                                       color: Colors.grey),
// //                                   onPressed: () =>
// //                                       _copyToClipboard('0544441037', context),
// //                                 ),
// //                                 onTap: () async {
// //                                   await _copyToClipboard('0544441037', context);

// //                                   Navigator.pop(context); // اقفل الديالوج

// //                                   await Future.delayed(
// //                                       const Duration(milliseconds: 300));

// //                                   final uri =
// //                                       Uri(scheme: 'tel', path: '0544441037');
// //                                   if (await canLaunchUrl(uri)) {
// //                                     await launchUrl(uri,
// //                                         mode: LaunchMode.externalApplication);
// //                                   }
// //                                 },
// //                               ),

// //                               // واتساب
// //                               ListTile(
// //                                 leading: const Icon(
// //                                   FontAwesomeIcons.whatsapp,
// //                                   color: Color(0xFFD4AF37),
// //                                 ),
// //                                 title: const Text(
// //                                   '+966544441037',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500),
// //                                 ),
// //                                 trailing: IconButton(
// //                                   icon: const Icon(Icons.copy,
// //                                       color: Colors.grey),
// //                                   onPressed: () => _copyToClipboard(
// //                                       '+966544441037', context),
// //                                 ),
// //                                 onTap: () async {
// //                                   await _copyToClipboard(
// //                                       '+966544441037', context);

// //                                   Navigator.pop(context);

// //                                   await Future.delayed(
// //                                       const Duration(milliseconds: 300));

// //                                   final uri =
// //                                       Uri.parse('https://wa.me/966544441037');
// //                                   if (await canLaunchUrl(uri)) {
// //                                     await launchUrl(uri,
// //                                         mode: LaunchMode.externalApplication);
// //                                   } else {
// //                                     ScaffoldMessenger.of(context).showSnackBar(
// //                                       const SnackBar(
// //                                           content: Text(
// //                                               'واتساب غير مثبت على الجهاز')),
// //                                     );
// //                                   }
// //                                 },
// //                               ),

// //                               // إيميل
// //                               ListTile(
// //                                 leading: const Icon(Icons.email,
// //                                     color: Color(0xFFD4AF37)),
// //                                 title: const Text(
// //                                   'Info@kaki.live',
// //                                   textAlign: TextAlign.center,
// //                                   style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.w500),
// //                                 ),
// //                                 trailing: IconButton(
// //                                   icon: const Icon(Icons.copy,
// //                                       color: Colors.grey),
// //                                   onPressed: () => _copyToClipboard(
// //                                       'Info@kaki.live', context),
// //                                 ),
// //                                 onTap: () async {
// //                                   await _copyToClipboard(
// //                                       'Info@kaki.live', context);

// //                                   Navigator.pop(context);

// //                                   await Future.delayed(
// //                                       const Duration(milliseconds: 300));

// //                                   final uri = Uri(
// //                                     scheme: 'mailto',
// //                                     path: 'Info@kaki.live',
// //                                   );
// //                                   if (await canLaunchUrl(uri)) {
// //                                     await launchUrl(uri,
// //                                         mode: LaunchMode.externalApplication);
// //                                   }
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       actions: [
// //                         TextButton(
// //                           onPressed: () => Navigator.pop(context),
// //                           child: const Text(
// //                             'إغلاق',
// //                             style: TextStyle(
// //                                 color: Color(0xFFD4AF37), fontSize: 16),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   );
// //                 }

// //                 if (value == 'logout') {
// //                   final result = await showDialog<bool>(
// //                     context: context,
// //                     builder: (context) => AlertDialog(
// //                       title: Text(_t('logout', _lang)),
// //                       content: Text(_t('confirm_logout', _lang)),
// //                       actions: [
// //                         TextButton(
// //                           onPressed: () => Navigator.pop(context, false),
// //                           child: Text(_t('cancel', _lang)),
// //                         ),
// //                         ElevatedButton(
// //                           onPressed: () => Navigator.pop(context, true),
// //                           child: Text(_t('confirm', _lang)),
// //                         ),
// //                       ],
// //                     ),
// //                   );

// //                   if (result == true) {
// //                     await FirebaseAuth.instance.signOut();
// //                   }
// //                 }
// //               },
// //               itemBuilder: (context) => [
// //                 PopupMenuItem(
// //                   value: 'settings',
// //                   child: Row(
// //                     children: [
// //                       const Icon(Icons.settings),
// //                       const SizedBox(width: 8),
// //                       Text(_t('settings', _lang)),
// //                     ],
// //                   ),
// //                 ),
// //                 PopupMenuItem(
// //                   value: 'support',
// //                   child: Row(
// //                     children: const [
// //                       Icon(Icons.headset_mic),
// //                       SizedBox(width: 8),
// //                       Text('خدمة العملاء'),
// //                     ],
// //                   ),
// //                 ),
// //                 PopupMenuItem(
// //                   value: 'logout',
// //                   child: Row(
// //                     children: const [
// //                       Icon(Icons.logout, color: Colors.red),
// //                       SizedBox(width: 8),
// //                       Text('تسجيل الخروج'),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),

// //             // ✅ الوسط → اسم التطبيق + الإيميل
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Text(
// //                   _t('app_name', _lang),
// //                   style: const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 18,
// //                   ),
// //                 ),
// //                 Text(
// //                   _userEmail ?? '...',
// //                   style: const TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 15,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 /*Text(
// //                   _Uid ?? '...',
// //                   style: const TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 15,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                   overflow: TextOverflow.ellipsis,
// //                 ),*/
// //               ],
// //             ),

// //             // ✅ الجانب الأيمن (يمين في RTL) → زر تسجيل الخروج
// //             IconButton(
// //               icon: const Icon(Icons.storefront_rounded, color: Colors.white),
// //               tooltip: _t('store', _lang),
// //               onPressed: _openWebsite,
// //             ),
// //           ],
// //         ),
// //         centerTitle: true, // عشان الوسط يفضل في النص
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         automaticallyImplyLeading:
// //             false, // مهم جدًا: عشان ما يضيفش زر back تلقائي
// //       ),
// //       body: _lang.isEmpty
// //           ? const Center(child: CircularProgressIndicator())
// //           : Container(
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   begin: Alignment.topCenter,
// //                   end: Alignment.bottomCenter,
// //                   colors: [
// //                     colorScheme.surface,
// //                     colorScheme.surface.withOpacity(0.8),
// //                   ],
// //                 ),
// //               ),
// //               child: Padding(
// //                 padding: const EdgeInsets.all(10),
// //                 child: Column(
// //                   children: [
// //                     FutureBuilder<Map<int, double>>(
// //                       future: fetchGoldPrices(),
// //                       builder: (context, snapshot) {
// //                         if (!snapshot.hasData) {
// //                           return const Center(
// //                               child: CircularProgressIndicator());
// //                         }

// //                         final prices = snapshot.data!;

// //                         return Directionality(
// //                           textDirection: TextDirection.rtl,
// //                           child: Container(
// //                             margin: const EdgeInsets.all(12),
// //                             padding: const EdgeInsets.all(12),
// //                             decoration: BoxDecoration(
// //                               color: const Color(0xFFFFFBF5),
// //                               borderRadius: BorderRadius.circular(22),
// //                               boxShadow: const [
// //                                 BoxShadow(
// //                                     color: Colors.black12,
// //                                     blurRadius: 8,
// //                                     offset: Offset(0, 4)),
// //                               ],
// //                             ),
// //                             child: Column(
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     Expanded(
// //                                         child:
// //                                             _goldTile('عيار 18', prices[18]!)),
// //                                     const SizedBox(width: 8),
// //                                     Expanded(
// //                                         child:
// //                                             _goldTile('عيار 21', prices[21]!)),
// //                                   ],
// //                                 ),
// //                                 const SizedBox(height: 8),
// //                                 Row(
// //                                   children: [
// //                                     Expanded(
// //                                         child:
// //                                             _goldTile('عيار 22', prices[22]!)),
// //                                     const SizedBox(width: 8),
// //                                     Expanded(
// //                                         child:
// //                                             _goldTile('عيار 24', prices[24]!)),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildMenuCard(
// //                             context,
// //                             icon: Icons.bar_chart_rounded,
// //                             label: _t('reports', _lang),
// //                             page: const ReportsPage(),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         Expanded(
// //                           child: _buildMenuCard(
// //                             context,
// //                             icon: Icons.account_balance_wallet,
// //                             label: _t('opening', _lang),
// //                             page: const InputPage(fromOpeningBalance: true),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 1),
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: _buildMenuCard(
// //                             context,
// //                             icon: Icons.add_box_rounded,
// //                             label: _t('input', _lang),
// //                             page: const InputPage(fromOpeningBalance: false),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         Expanded(
// //                           child: _buildMenuCard(
// //                             context,
// //                             icon: Icons.list_alt_rounded,
// //                             label: _t('daily', _lang),
// //                             page: DailyTransactionsPage(),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 1),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 70,
// //                       child: GestureDetector(
// //                         onTap: () => _openPage(context, const InventoryPage()),
// //                         child: Card(
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16)),
// //                           elevation: 4,
// //                           color: const Color(0xFFD4AF37).withOpacity(0.9),
// //                           child: Center(
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 const Icon(Icons.inventory_2_rounded,
// //                                     size: 30, color: Colors.white),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   _t('inventory', _lang),
// //                                   style: const TextStyle(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 1),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 70,
// //                       child: GestureDetector(
// //                         onTap: () =>
// //                             _openPage(context, const InventoryDepartment()),
// //                         child: Card(
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16)),
// //                           elevation: 4,
// //                           color: const Color(0xFFD4AF37).withOpacity(0.9),
// //                           child: Center(
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 const Icon(Icons.inventory_2_rounded,
// //                                     size: 30, color: Colors.white),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   _t('inventoryDepartment', _lang),
// //                                   style: const TextStyle(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 1),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 70,
// //                       child: GestureDetector(
// //                         onTap: () => _openPage(context, ScrapPage()),
// //                         child: Card(
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16)),
// //                           elevation: 4,
// //                           color: const Color(0xFFD4AF37).withOpacity(0.9),
// //                           child: Center(
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 const Icon(Icons.recycling_rounded,
// //                                     size: 30, color: Colors.white),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   _t('scrap', _lang),
// //                                   style: const TextStyle(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 1),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       height: 70,
// //                       child: GestureDetector(
// //                         onTap: () => _openPage(context, const SalesPage()),
// //                         child: Card(
// //                           shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(16)),
// //                           elevation: 4,
// //                           color: const Color(0xFFD4AF37).withOpacity(0.9),
// //                           child: Center(
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 const Icon(Icons.point_of_sale_rounded,
// //                                     size: 30, color: Colors.white),
// //                                 const SizedBox(width: 12),
// //                                 Text(
// //                                   _t('sales', _lang),
// //                                   style: const TextStyle(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.white,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 1),
// //                     /*Row(
// //                 children: [
// //                   Expanded(
// //                     child: _buildMenuCard(
// //                       context,
// //                       icon: Icons.list_alt_rounded,
// //                       label: _t('daily', _lang),
// //                       page: const DailyTransactionsPage(),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Expanded(
// //                     child: _buildMenuCard(
// //                       context,
// //                       icon: Icons.location_city,
// //                       label: _t('branches', _lang),
// //                       page: const BranchesPage(),
// //                     ),
// //                   ),
// //                 ],
// //               ),*/
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }

// //   Future<Map<int, double>> fetchGoldPrices() async {
// //     final res = await http.get(
// //       Uri.parse(
// //         'https://goldprices-usqjvutvvq-uc.a.run.app',
// //       ),
// //     );

// //     print('STATUS: ${res.statusCode}');
// //     print('BODY: ${res.body}');

// //     if (res.statusCode != 200) {
// //       return {18: 0, 21: 0, 22: 0, 24: 0};
// //     }

// //     final data = jsonDecode(res.body);

// //     return {
// //       18: (data['g18'] as num).toDouble(),
// //       21: (data['g21'] as num).toDouble(),
// //       22: (data['g22'] as num).toDouble(),
// //       24: (data['g24'] as num).toDouble(),
// //     };
// //   }

// //   Widget _buildMenuCard(BuildContext context,
// //       {required IconData icon, required String label, required Widget page}) {
// //     return AspectRatio(
// //       aspectRatio: 2.8,
// //       child: GestureDetector(
// //         onTap: () => _openPage(context, page),
// //         child: Card(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           elevation: 4,
// //           color: const Color(0xFFD4AF37).withOpacity(0.9),
// //           child: Center(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(icon, size: 20, color: Colors.white),
// //                   const SizedBox(width: 8),
// //                   Text(
// //                     label,
// //                     style: const TextStyle(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
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
// // // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/firestore_service.dart';
// import 'input_page.dart';
// import 'inventory_page.dart';
// import 'sales_page.dart';
// import 'reports_page.dart';
// import 'scrap_page.dart';
// import 'settings_page.dart';
// import 'inventory_department.dart';
// import 'RemainingKitsPage.dart'; // ✅ استيراد صفحة بقايا الأطقم

// import 'daily_transactions_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'settings_page.dart' show checkPassword;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter/services.dart';

// // ✅ تحميل اللغة المختارة
// Future<String> getSelectedLanguage() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString('languageCode') ?? 'ar';
// }

// // ✅ دالة الترجمة
// String _t(String key, String lang) {
//   final map = {
//     'ar': {
//       'settings': 'الإعدادات',
//       'store': 'المتجر',
//       'input': 'الإدخال',
//       'opening': 'ر.الافتتاحي',
//       'scrap': 'الكسر',
//       'reports': 'التقارير',
//       'inventory': 'الجرد',
//       'sales': 'البيع',
//       'edit': 'التعديل',
//       'daily': 'الحركة اليومية',
//       'branches': 'الأفرع',
//       'logout': 'تسجيل الخروج',
//       'confirm_logout': 'هل أنت متأكد من تسجيل الخروج؟',
//       'cancel': 'إلغاء',
//       'confirm': 'تسجيل الخروج',
//       'buy_devices': 'لشراء الاستيكرات والأجهزة',
//       'app_name': 'KAKi RFID',
//       'inventoryDepartment': 'جرد الاقسام',
//       'remainingKits': 'بقايا الأطقم'
//     },
//     'en': {
//       'settings': 'Settings',
//       'store': 'Store',
//       'input': 'Input',
//       'opening': 'O.Balance',
//       'scrap': 'Scrap',
//       'reports': 'Reports',
//       'inventory': 'Inventory',
//       'sales': 'Sales',
//       'edit': 'Edit',
//       'daily': 'Daily Transactions',
//       'branches': 'Branches',
//       'logout': 'Logout',
//       'confirm_logout': 'Are you sure you want to logout?',
//       'cancel': 'Cancel',
//       'confirm': 'Logout',
//       'buy_devices': 'Buy Stickers & Devices',
//       'app_name': 'KAKi RFID',
//       'inventoryDepartment': 'Inventory Departments',
//       'remainingKits': 'Remaining Kits'
//     },
//   };

//   return map[lang]?[key] ?? key;
// }

// class HomeScaffold extends StatefulWidget {
//   const HomeScaffold({super.key});

//   @override
//   State<HomeScaffold> createState() => _HomeScaffoldState();
// }

// class _HomeScaffoldState extends State<HomeScaffold> {
//   String _lang = 'ar';
//   String? _userEmail;
//   bool _hasRemainingKits = false; // ✅ متغير للتحكم في ظهور زر بقايا الأطقم

//   @override
//   void initState() {
//     super.initState();
//     _loadLang();
//     _loadUserEmail();
//     _checkRemainingKits(); // ✅ التحقق من وجود بقايا أطقم

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FS.listenForTransfers(context);
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       FS.listenToTransferUpdates();
//     });
//   }

//   @override
//   void dispose() {
//     FS.stopListening();
//     FS.cancelTransferListener();
//     super.dispose();
//   }

//   Future<void> _loadLang() async {
//     _lang = await getSelectedLanguage();
//     setState(() {});
//   }

//   void _loadUserEmail() {
//     final user = FirebaseAuth.instance.currentUser;
//     setState(() {
//       _userEmail = user?.email ?? 'مستخدم غير معروف';
//     });
//   }

//   // ✅ دالة للتحقق من وجود بقايا أطقم
//   Future<void> _checkRemainingKits() async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid == null) {
//         setState(() => _hasRemainingKits = false);
//         return;
//       }

//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .collection('setRemainders')
//           .limit(1)
//           .get();

//       setState(() {
//         _hasRemainingKits = snapshot.docs.isNotEmpty;
//       });
//     } catch (e) {
//       print('❌ خطأ في التحقق من بقايا الأطقم: $e');
//       setState(() => _hasRemainingKits = false);
//     }
//   }

//   // ✅ دالة لفتح صفحة بقايا الأطقم وتحديث الحالة بعد العودة
//   Future<void> _openRemainingKitsPage() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const RemainingKitsPage(),
//       ),
//     );
//     // ✅ بعد الرجوع من الصفحة، نحدث الحالة
//     await _checkRemainingKits();
//   }

//   void _openPage(BuildContext context, Widget page) async {
//     String? pageKey;

//     if (page is ReportsPage) {
//       pageKey = 'reports';
//     } else if (page is InventoryPage)
//       pageKey = 'inventory';
//     else if (page is InventoryDepartment)
//       pageKey = 'inventoryDepartment';
//     else if (page is SalesPage)
//       pageKey = 'sales';
//     else if (page is ScrapPage)
//       pageKey = 'scrap';
//     else if (page is SettingsPage)
//       pageKey = 'Setting';
//     else if (page is DailyTransactionsPage)
//       pageKey = 'Daily';
//     else if (page is InputPage) pageKey = 'Input';

//     if (pageKey != null) {
//       final allowed = await checkPassword(context, pageKey);
//       if (!allowed) return;
//     }

//     Navigator.push(context, MaterialPageRoute(builder: (_) => page));
//   }

//   Future<void> _openWebsite() async {
//     final Uri url = Uri.parse("http://www.kaki.live/");
//     if (!await launchUrl(
//       url,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   Future<void> _copyToClipboard(String text, BuildContext context) async {
//     await Clipboard.setData(ClipboardData(text: text));
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم نسخ: $text')),
//       );
//     }
//   }

//   Widget _goldTile(String title, double price) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.centerLeft,
//           colors: [
//             Color(0xFFFFF4D6),
//             Color(0xFFFFFFFF),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Color(0xFFD4AF37),
//           width: 0.7,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFD4AF37),
//               ),
//             ),
//           ),
//           Text(
//             '${price.toStringAsFixed(2)} ريال',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFFD4AF37),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 const Color(0xFFD4AF37).withOpacity(0.9),
//                 const Color(0xFFB8860B).withOpacity(0.8),
//               ],
//             ),
//           ),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.menu, color: Colors.white),
//               onSelected: (value) async {
//                 if (value == 'settings') {
//                   _openPage(context, const SettingsPage());
//                 }

//                 if (value == 'support') {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       title: const Text(
//                         'خدمة العملاء',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFD4AF37),
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 16),
//                       content: ConstrainedBox(
//                         constraints:
//                             const BoxConstraints(minWidth: 300, maxWidth: 400),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               ListTile(
//                                 leading: const Icon(Icons.phone,
//                                     color: Color(0xFFD4AF37)),
//                                 title: const Text(
//                                   '0544441037',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.copy,
//                                       color: Colors.grey),
//                                   onPressed: () =>
//                                       _copyToClipboard('0544441037', context),
//                                 ),
//                                 onTap: () async {
//                                   await _copyToClipboard('0544441037', context);

//                                   Navigator.pop(context);

//                                   await Future.delayed(
//                                       const Duration(milliseconds: 300));

//                                   final uri =
//                                       Uri(scheme: 'tel', path: '0544441037');
//                                   if (await canLaunchUrl(uri)) {
//                                     await launchUrl(uri,
//                                         mode: LaunchMode.externalApplication);
//                                   }
//                                 },
//                               ),
//                               ListTile(
//                                 leading: const Icon(
//                                   FontAwesomeIcons.whatsapp,
//                                   color: Color(0xFFD4AF37),
//                                 ),
//                                 title: const Text(
//                                   '+966544441037',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.copy,
//                                       color: Colors.grey),
//                                   onPressed: () => _copyToClipboard(
//                                       '+966544441037', context),
//                                 ),
//                                 onTap: () async {
//                                   await _copyToClipboard(
//                                       '+966544441037', context);

//                                   Navigator.pop(context);

//                                   await Future.delayed(
//                                       const Duration(milliseconds: 300));

//                                   final uri =
//                                       Uri.parse('https://wa.me/966544441037');
//                                   if (await canLaunchUrl(uri)) {
//                                     await launchUrl(uri,
//                                         mode: LaunchMode.externalApplication);
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                               'واتساب غير مثبت على الجهاز')),
//                                     );
//                                   }
//                                 },
//                               ),
//                               ListTile(
//                                 leading: const Icon(Icons.email,
//                                     color: Color(0xFFD4AF37)),
//                                 title: const Text(
//                                   'Info@kaki.live',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.copy,
//                                       color: Colors.grey),
//                                   onPressed: () => _copyToClipboard(
//                                       'Info@kaki.live', context),
//                                 ),
//                                 onTap: () async {
//                                   await _copyToClipboard(
//                                       'Info@kaki.live', context);

//                                   Navigator.pop(context);

//                                   await Future.delayed(
//                                       const Duration(milliseconds: 300));

//                                   final uri = Uri(
//                                     scheme: 'mailto',
//                                     path: 'Info@kaki.live',
//                                   );
//                                   if (await canLaunchUrl(uri)) {
//                                     await launchUrl(uri,
//                                         mode: LaunchMode.externalApplication);
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text(
//                             'إغلاق',
//                             style: TextStyle(
//                                 color: Color(0xFFD4AF37), fontSize: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 if (value == 'logout') {
//                   final result = await showDialog<bool>(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: Text(_t('logout', _lang)),
//                       content: Text(_t('confirm_logout', _lang)),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, false),
//                           child: Text(_t('cancel', _lang)),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => Navigator.pop(context, true),
//                           child: Text(_t('confirm', _lang)),
//                         ),
//                       ],
//                     ),
//                   );

//                   if (result == true) {
//                     await FirebaseAuth.instance.signOut();
//                   }
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'settings',
//                   child: Row(
//                     children: [
//                       const Icon(Icons.settings),
//                       const SizedBox(width: 8),
//                       Text(_t('settings', _lang)),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'support',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.headset_mic),
//                       SizedBox(width: 8),
//                       Text('خدمة العملاء'),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: 'logout',
//                   child: Row(
//                     children: const [
//                       Icon(Icons.logout, color: Colors.red),
//                       SizedBox(width: 8),
//                       Text('تسجيل الخروج'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   _t('app_name', _lang),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 Text(
//                   _userEmail ?? '...',
//                   style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//             IconButton(
//               icon: const Icon(Icons.storefront_rounded, color: Colors.white),
//               tooltip: _t('store', _lang),
//               onPressed: _openWebsite,
//             ),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//       ),
//       body: _lang.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     colorScheme.surface,
//                     colorScheme.surface.withOpacity(0.8),
//                   ],
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     FutureBuilder<Map<int, double>>(
//                       future: fetchGoldPrices(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         }

//                         final prices = snapshot.data!;

//                         return Directionality(
//                           textDirection: TextDirection.rtl,
//                           child: Container(
//                             margin: const EdgeInsets.all(12),
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFFFBF5),
//                               borderRadius: BorderRadius.circular(22),
//                               boxShadow: const [
//                                 BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 8,
//                                     offset: Offset(0, 4)),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                         child:
//                                             _goldTile('عيار 18', prices[18]!)),
//                                     const SizedBox(width: 8),
//                                     Expanded(
//                                         child:
//                                             _goldTile('عيار 21', prices[21]!)),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                         child:
//                                             _goldTile('عيار 22', prices[22]!)),
//                                     const SizedBox(width: 8),
//                                     Expanded(
//                                         child:
//                                             _goldTile('عيار 24', prices[24]!)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildMenuCard(
//                             context,
//                             icon: Icons.bar_chart_rounded,
//                             label: _t('reports', _lang),
//                             page: const ReportsPage(),
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: _buildMenuCard(
//                             context,
//                             icon: Icons.account_balance_wallet,
//                             label: _t('opening', _lang),
//                             page: const InputPage(fromOpeningBalance: true),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 1),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildMenuCard(
//                             context,
//                             icon: Icons.add_box_rounded,
//                             label: _t('input', _lang),
//                             page: const InputPage(fromOpeningBalance: false),
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: _buildMenuCard(
//                             context,
//                             icon: Icons.list_alt_rounded,
//                             label: _t('daily', _lang),
//                             page: DailyTransactionsPage(),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 1),
//                     if (_hasRemainingKits) ...[
//                       const SizedBox(height: 1),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 70,
//                         child: GestureDetector(
//                           onTap: _openRemainingKitsPage,
//                           child: Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 4,
//                             color: const Color(0xFFD4AF37).withOpacity(0.9),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(Icons.inventory_2_outlined,
//                                       size: 30, color: Colors.white),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     _t('remainingKits', _lang),
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     SizedBox(
//                       width: double.infinity,
//                       height: 70,
//                       child: GestureDetector(
//                         onTap: () => _openPage(context, const InventoryPage()),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           elevation: 4,
//                           color: const Color(0xFFD4AF37).withOpacity(0.9),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.inventory_2_rounded,
//                                     size: 30, color: Colors.white),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   _t('inventory', _lang),
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 70,
//                       child: GestureDetector(
//                         onTap: () =>
//                             _openPage(context, const InventoryDepartment()),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           elevation: 4,
//                           color: const Color(0xFFD4AF37).withOpacity(0.9),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.inventory_2_rounded,
//                                     size: 30, color: Colors.white),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   _t('inventoryDepartment', _lang),
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 70,
//                       child: GestureDetector(
//                         onTap: () => _openPage(context, ScrapPage()),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           elevation: 4,
//                           color: const Color(0xFFD4AF37).withOpacity(0.9),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.recycling_rounded,
//                                     size: 30, color: Colors.white),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   _t('scrap', _lang),
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 70,
//                       child: GestureDetector(
//                         onTap: () => _openPage(context, const SalesPage()),
//                         child: Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16)),
//                           elevation: 4,
//                           color: const Color(0xFFD4AF37).withOpacity(0.9),
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.point_of_sale_rounded,
//                                     size: 30, color: Colors.white),
//                                 const SizedBox(width: 12),
//                                 Text(
//                                   _t('sales', _lang),
//                                   style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Future<Map<int, double>> fetchGoldPrices() async {
//     final res = await http.get(
//       Uri.parse(
//         'https://goldprices-usqjvutvvq-uc.a.run.app',
//       ),
//     );

//     print('STATUS: ${res.statusCode}');
//     print('BODY: ${res.body}');

//     if (res.statusCode != 200) {
//       return {18: 0, 21: 0, 22: 0, 24: 0};
//     }

//     final data = jsonDecode(res.body);

//     return {
//       18: (data['g18'] as num).toDouble(),
//       21: (data['g21'] as num).toDouble(),
//       22: (data['g22'] as num).toDouble(),
//       24: (data['g24'] as num).toDouble(),
//     };
//   }

//   Widget _buildMenuCard(BuildContext context,
//       {required IconData icon, required String label, required Widget page}) {
//     return AspectRatio(
//       aspectRatio: 2.8,
//       child: GestureDetector(
//         onTap: () => _openPage(context, page),
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           elevation: 4,
//           color: const Color(0xFFD4AF37).withOpacity(0.9),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(icon, size: 20, color: Colors.white),
//                   const SizedBox(width: 8),
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
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
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';
import 'input_page.dart';
import 'inventory_page.dart';
import 'sales_page.dart';
import 'reports_page.dart';
import 'scrap_page.dart';
import 'settings_page.dart';
import 'inventory_department.dart';
import 'RemainingKitsPage.dart';

import 'daily_transactions_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_page.dart' show checkPassword;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

Future<String> getSelectedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('languageCode') ?? 'ar';
}

String _t(String key, String lang) {
  final map = {
    'ar': {
      'settings': 'الإعدادات',
      'store': 'المتجر',
      'input': 'الإدخال',
      'opening': 'الافتتاحي',
      'scrap': 'الكسر',
      'reports': 'التقارير',
      'inventory': 'الجرد',
      'sales': 'البيع',
      'edit': 'التعديل',
      'daily': 'الحركة اليومية',
      'branches': 'الأفرع',
      'logout': 'تسجيل الخروج',
      'confirm_logout': 'هل أنت متأكد من تسجيل الخروج؟',
      'cancel': 'إلغاء',
      'confirm': 'تسجيل الخروج',
      'buy_devices': 'لشراء الاستيكرات والأجهزة',
      'app_name': 'KAKi RFID',
      'inventoryDepartment': 'جرد الأقسام',
      'remainingKits': ' الرصيد المعلق'
    },
    'en': {
      'settings': 'Settings',
      'store': 'Store',
      'input': 'Input',
      'opening': 'O.Balance',
      'scrap': 'Scrap',
      'reports': 'Reports',
      'inventory': 'Inventory',
      'sales': 'Sales',
      'edit': 'Edit',
      'daily': 'Daily Transactions',
      'branches': 'Branches',
      'logout': 'Logout',
      'confirm_logout': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'confirm': 'Logout',
      'buy_devices': 'Buy Stickers & Devices',
      'app_name': 'KAKi RFID',
      'inventoryDepartment': 'Inventory Departments',
      'remainingKits': 'Remaining Kits'
    },
  };

  return map[lang]?[key] ?? key;
}

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  String _lang = 'ar';
  String? _userEmail;
  bool _hasRemainingKits = false;

  @override
  void initState() {
    super.initState();
    _loadLang();
    _loadUserEmail();
    _checkRemainingKits();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FS.listenForTransfers(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FS.listenToTransferUpdates();
    });
  }

  @override
  void dispose() {
    FS.stopListening();
    FS.cancelTransferListener();
    super.dispose();
  }

  Future<void> _loadLang() async {
    _lang = await getSelectedLanguage();
    setState(() {});
  }

  void _loadUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userEmail = user?.email ?? 'مستخدم غير معروف';
    });
  }

  Future<void> _checkRemainingKits() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() => _hasRemainingKits = false);
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('setRemainders')
          .limit(1)
          .get();

      setState(() {
        _hasRemainingKits = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('❌ خطأ في التحقق من بقايا الأطقم: $e');
      setState(() => _hasRemainingKits = false);
    }
  }

  Future<void> _openRemainingKitsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RemainingKitsPage(),
      ),
    );
    await _checkRemainingKits();
  }

  void _openPage(BuildContext context, Widget page) async {
    String? pageKey;

    if (page is ReportsPage) {
      pageKey = 'reports';
    } else if (page is InventoryPage)
      pageKey = 'inventory';
    else if (page is InventoryDepartment)
      pageKey = 'inventoryDepartment';
    else if (page is SalesPage)
      pageKey = 'sales';
    else if (page is ScrapPage)
      pageKey = 'scrap';
    else if (page is SettingsPage)
      pageKey = 'Setting';
    else if (page is DailyTransactionsPage)
      pageKey = 'Daily';
    else if (page is InputPage) pageKey = 'Input';

    if (pageKey != null) {
      final allowed = await checkPassword(context, pageKey);
      if (!allowed) return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _openWebsite() async {
    final Uri url = Uri.parse("http://www.kaki.live/");
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم نسخ: $text')),
      );
    }
  }

  Widget _goldTile(String title, double price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Color(0xFFFFF4D6),
            Color(0xFFFFFFFF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37),
          width: 0.7,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD4AF37),
              ),
            ),
          ),
          Text(
            '${price.toStringAsFixed(2)} ريال',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4AF37),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFD4AF37).withOpacity(0.9),
                const Color(0xFFB8860B).withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) async {
                if (value == 'settings') {
                  _openPage(context, const SettingsPage());
                }

                if (value == 'support') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'خدمة العملاء',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      content: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: 300, maxWidth: 400),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.phone,
                                    color: Color(0xFFD4AF37)),
                                title: const Text(
                                  '0544441037',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.grey),
                                  onPressed: () =>
                                      _copyToClipboard('0544441037', context),
                                ),
                                onTap: () async {
                                  await _copyToClipboard('0544441037', context);

                                  Navigator.pop(context);

                                  await Future.delayed(
                                      const Duration(milliseconds: 300));

                                  final uri =
                                      Uri(scheme: 'tel', path: '0544441037');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Color(0xFFD4AF37),
                                ),
                                title: const Text(
                                  '+966544441037',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.grey),
                                  onPressed: () => _copyToClipboard(
                                      '+966544441037', context),
                                ),
                                onTap: () async {
                                  await _copyToClipboard(
                                      '+966544441037', context);

                                  Navigator.pop(context);

                                  await Future.delayed(
                                      const Duration(milliseconds: 300));

                                  final uri =
                                      Uri.parse('https://wa.me/966544441037');
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'واتساب غير مثبت على الجهاز')),
                                    );
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.email,
                                    color: Color(0xFFD4AF37)),
                                title: const Text(
                                  'Info@kaki.live',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.grey),
                                  onPressed: () => _copyToClipboard(
                                      'Info@kaki.live', context),
                                ),
                                onTap: () async {
                                  await _copyToClipboard(
                                      'Info@kaki.live', context);

                                  Navigator.pop(context);

                                  await Future.delayed(
                                      const Duration(milliseconds: 300));

                                  final uri = Uri(
                                    scheme: 'mailto',
                                    path: 'Info@kaki.live',
                                  );
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'إغلاق',
                            style: TextStyle(
                                color: Color(0xFFD4AF37), fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (value == 'logout') {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(_t('logout', _lang)),
                      content: Text(_t('confirm_logout', _lang)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(_t('cancel', _lang)),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(_t('confirm', _lang)),
                        ),
                      ],
                    ),
                  );

                  if (result == true) {
                    await FirebaseAuth.instance.signOut();
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      const Icon(Icons.settings),
                      const SizedBox(width: 8),
                      Text(_t('settings', _lang)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'support',
                  child: Row(
                    children: const [
                      Icon(Icons.headset_mic),
                      SizedBox(width: 8),
                      Text('خدمة العملاء'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text('تسجيل الخروج'),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _t('app_name', _lang),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  _userEmail ?? '...',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.storefront_rounded, color: Colors.white),
              tooltip: _t('store', _lang),
              onPressed: _openWebsite,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _lang.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    FutureBuilder<Map<int, double>>(
                      future: fetchGoldPrices(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final prices = snapshot.data!;

                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBF5),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child:
                                            _goldTile('عيار 18', prices[18]!)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child:
                                            _goldTile('عيار 21', prices[21]!)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        child:
                                            _goldTile('عيار 22', prices[22]!)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child:
                                            _goldTile('عيار 24', prices[24]!)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // ✅ الأزرار العلوية الأربعة مع زر بقايا الأطقم في المنتصف
                    // الصف الأول: التقارير + الافتتاحي
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            context,
                            icon: Icons.bar_chart_rounded,
                            label: _t('reports', _lang),
                            page: const ReportsPage(),
                            // تصغير الأزرار عند ظهور زر بقايا الأطقم
                            aspectRatio: _hasRemainingKits ? 3.5 : 2.8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildMenuCard(
                            context,
                            icon: Icons.account_balance_wallet,
                            label: _t('opening', _lang),
                            page: const InputPage(fromOpeningBalance: true),
                            aspectRatio: _hasRemainingKits ? 3.5 : 2.8,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 1),

                    // ✅ زر بقايا الأطقم في المنتصف
                    if (_hasRemainingKits) ...[
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: GestureDetector(
                          onTap: _openRemainingKitsPage,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            color: const Color(0xFFD4AF37).withOpacity(0.9),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 26,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _t('remainingKits', _lang),
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
                        ),
                      ),
                      const SizedBox(height: 1),
                    ],

                    // ✅ الصف الثاني: الإدخال + الحركة اليومية
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuCard(
                            context,
                            icon: Icons.add_box_rounded,
                            label: _t('input', _lang),
                            page: const InputPage(fromOpeningBalance: false),
                            aspectRatio: _hasRemainingKits ? 3.5 : 2.8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: _buildMenuCard(
                            context,
                            icon: Icons.list_alt_rounded,
                            label: _t('daily', _lang),
                            page: DailyTransactionsPage(),
                            aspectRatio: _hasRemainingKits ? 3.5 : 2.8,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // ✅ الأزرار السفلية
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: GestureDetector(
                        onTap: () => _openPage(context, const InventoryPage()),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          color: const Color(0xFFD4AF37).withOpacity(0.9),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inventory_2_rounded,
                                    size: 30, color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  _t('inventory', _lang),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: GestureDetector(
                        onTap: () =>
                            _openPage(context, const InventoryDepartment()),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          color: const Color(0xFFD4AF37).withOpacity(0.9),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inventory_2_rounded,
                                    size: 30, color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  _t('inventoryDepartment', _lang),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: GestureDetector(
                        onTap: () => _openPage(context, ScrapPage()),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          color: const Color(0xFFD4AF37).withOpacity(0.9),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.recycling_rounded,
                                    size: 30, color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  _t('scrap', _lang),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: GestureDetector(
                        onTap: () => _openPage(context, const SalesPage()),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          color: const Color(0xFFD4AF37).withOpacity(0.9),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.point_of_sale_rounded,
                                    size: 30, color: Colors.white),
                                const SizedBox(width: 12),
                                Text(
                                  _t('sales', _lang),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<Map<int, double>> fetchGoldPrices() async {
    final res = await http.get(
      Uri.parse(
        'https://goldprices-usqjvutvvq-uc.a.run.app',
      ),
    );

    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    if (res.statusCode != 200) {
      return {18: 0, 21: 0, 22: 0, 24: 0};
    }

    final data = jsonDecode(res.body);

    return {
      18: (data['g18'] as num).toDouble(),
      21: (data['g21'] as num).toDouble(),
      22: (data['g22'] as num).toDouble(),
      24: (data['g24'] as num).toDouble(),
    };
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget page,
      double? aspectRatio}) {
    return AspectRatio(
      aspectRatio: aspectRatio ?? 2.8,
      child: GestureDetector(
        onTap: () => _openPage(context, page),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          color: const Color(0xFFD4AF37).withOpacity(0.9),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
