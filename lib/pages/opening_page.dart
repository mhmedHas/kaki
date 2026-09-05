// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:uhf_gold_shop/pages/report_opening_page.dart';
// // // // // import 'package:uhf_gold_shop/services/firestore_service.dart';

// // // // // const List<String> kCaratOptions = ['24', '22', '21', '18', '14'];

// // // // // class OpeningBalanceEntryPage extends StatefulWidget {
// // // // //   const OpeningBalanceEntryPage({super.key});

// // // // //   @override
// // // // //   State<OpeningBalanceEntryPage> createState() =>
// // // // //       _OpeningBalanceEntryPageState();
// // // // // }

// // // // // class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
// // // // //   final _formKey = GlobalKey<FormState>();
// // // // //   bool _saving = false;

// // // // //   // صندوق اليومي + الخزنة + عهدة الكسر
// // // // //   final _dailyCashCtrl = TextEditingController(text: '0');
// // // // //   final _dailyNetworkCtrl = TextEditingController(text: '0');
// // // // //   final _safeCashCtrl = TextEditingController(text: '0');
// // // // //   final _safeNetworkCtrl = TextEditingController(text: '0');
// // // // //   final _custodyCashCtrl = TextEditingController(text: '0');
// // // // //   final _custodyNetworkCtrl = TextEditingController(text: '0');

// // // // //   // ذهب كسر / ذهب مشغول — حقل وزن لكل عيار
// // // // //   final Map<String, TextEditingController> _scrapGoldCtrls = {
// // // // //     for (final c in kCaratOptions) c: TextEditingController(text: '0'),
// // // // //   };
// // // // //   final Map<String, TextEditingController> _workedGoldCtrls = {
// // // // //     for (final c in kCaratOptions) c: TextEditingController(text: '0'),
// // // // //   };

// // // // //   // كسر بالمخزن — قائمة عناصر (وزن + عيار تقديري)
// // // // //   final List<Map<String, dynamic>> _scrapInStorage = [];
// // // // //   final _scrapWeightCtrl = TextEditingController();
// // // // //   String _scrapCarat = kCaratOptions.first;

// // // // //   // المخزون — قائمة عناصر (قيمة + وزن + عيار تقديري)
// // // // //   final List<Map<String, dynamic>> _inventory = [];
// // // // //   final _invValueCtrl = TextEditingController();
// // // // //   final _invWeightCtrl = TextEditingController();
// // // // //   String _invCarat = kCaratOptions.first;

// // // // //   // رأس مال الشركاء — قائمة (اسم + مبلغ بعيار 24)
// // // // //   final List<Map<String, dynamic>> _partners = [];
// // // // //   final _partnerNameCtrl = TextEditingController();
// // // // //   final _partnerAmountCtrl = TextEditingController();

// // // // //   double _d(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

// // // // //   void _addScrapInStorage() {
// // // // //     final w = _d(_scrapWeightCtrl);
// // // // //     if (w <= 0) return;
// // // // //     setState(() {
// // // // //       _scrapInStorage.add({'weight': w, 'carat': _scrapCarat});
// // // // //       _scrapWeightCtrl.clear();
// // // // //     });
// // // // //   }

// // // // //   void _addInventoryItem() {
// // // // //     final v = _d(_invValueCtrl);
// // // // //     final w = _d(_invWeightCtrl);
// // // // //     if (v <= 0 && w <= 0) return;
// // // // //     setState(() {
// // // // //       _inventory.add({'value': v, 'weight': w, 'carat': _invCarat});
// // // // //       _invValueCtrl.clear();
// // // // //       _invWeightCtrl.clear();
// // // // //     });
// // // // //   }

// // // // //   void _addPartner() {
// // // // //     final name = _partnerNameCtrl.text.trim();
// // // // //     final amount = _d(_partnerAmountCtrl);
// // // // //     if (name.isEmpty) return;
// // // // //     setState(() {
// // // // //       _partners.add({'name': name, 'amount': amount});
// // // // //       _partnerNameCtrl.clear();
// // // // //       _partnerAmountCtrl.clear();
// // // // //     });
// // // // //   }

// // // // //   Future<void> _save() async {
// // // // //     if (_saving) return;

// // // // //     if (_partners.isEmpty) {
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         const SnackBar(content: Text('لازم تضيف شريك واحد على الأقل')),
// // // // //       );
// // // // //       return;
// // // // //     }

// // // // //     setState(() => _saving = true);
// // // // //     try {
// // // // //       await FS.saveOpeningBalance(
// // // // //         dailyCashBoxCash: _d(_dailyCashCtrl),
// // // // //         dailyCashBoxNetwork: _d(_dailyNetworkCtrl),
// // // // //         safeCash: _d(_safeCashCtrl),
// // // // //         safeNetwork: _d(_safeNetworkCtrl),
// // // // //         scrapGoldByCarat: {
// // // // //           for (final c in kCaratOptions) c: _d(_scrapGoldCtrls[c]!),
// // // // //         },
// // // // //         workedGoldByCarat: {
// // // // //           for (final c in kCaratOptions) c: _d(_workedGoldCtrls[c]!),
// // // // //         },
// // // // //         scrapCustodyCash: _d(_custodyCashCtrl),
// // // // //         scrapCustodyNetwork: _d(_custodyNetworkCtrl),
// // // // //         scrapInStorage: _scrapInStorage,
// // // // //         inventory: _inventory,
// // // // //       );

// // // // //       for (final p in _partners) {
// // // // //         await FS.addPartnerOpeningCapital(
// // // // //           partnerName: p['name'],
// // // // //           amountCarat24: p['amount'],
// // // // //         );
// // // // //       }

// // // // //       if (!mounted) return;
// // // // //       Navigator.of(context).pushReplacement(
// // // // //         MaterialPageRoute(builder: (_) => const OpeningBalanceDisplayPage()),
// // // // //       );
// // // // //     } catch (e) {
// // // // //       if (!mounted) return;
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         SnackBar(content: Text('حصل خطأ: $e')),
// // // // //       );
// // // // //     } finally {
// // // // //       if (mounted) setState(() => _saving = false);
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Directionality(
// // // // //       textDirection: TextDirection.rtl,
// // // // //       child: Scaffold(
// // // // //         appBar: AppBar(title: const Text('الرصيد الافتتاحي')),
// // // // //         body: Form(
// // // // //           key: _formKey,
// // // // //           child: ListView(
// // // // //             padding: const EdgeInsets.all(16),
// // // // //             children: [
// // // // //               const Text(
// // // // //                 'أدخل كل شيء كان موجود عندك يوم بدأت العمل بالتطبيق. '
// // // // //                 'من هذه اللحظة، كل التقارير هتتحسب بالمقارنة مع الرصيد ده. '
// // // // //                 'ملحوظة: البيانات دي بتتحفظ مرة واحدة ومش قابلة للتعديل بعدها.',
// // // // //                 style: TextStyle(color: Colors.grey),
// // // // //               ),
// // // // //               const SizedBox(height: 20),
// // // // //               _sectionTitle('صندوق اليومي'),
// // // // //               _twoFieldsRow('نقدي', _dailyCashCtrl, 'شبكة', _dailyNetworkCtrl),
// // // // //               _sectionTitle('الخزنة'),
// // // // //               _twoFieldsRow('نقدي', _safeCashCtrl, 'شبكة', _safeNetworkCtrl),
// // // // //               _sectionTitle('ذهب كسر (جم) — حسب العيار'),
// // // // //               _caratFieldsGrid(_scrapGoldCtrls),
// // // // //               _sectionTitle('ذهب مشغول (جم) — حسب العيار'),
// // // // //               _caratFieldsGrid(_workedGoldCtrls),
// // // // //               _sectionTitle('عهدة الكسر'),
// // // // //               _twoFieldsRow(
// // // // //                   'نقدي', _custodyCashCtrl, 'شبكة', _custodyNetworkCtrl),
// // // // //               _sectionTitle('كسر بالمخزن'),
// // // // //               _listBuilderSection(
// // // // //                 addRow: Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: TextField(
// // // // //                         controller: _scrapWeightCtrl,
// // // // //                         keyboardType: TextInputType.number,
// // // // //                         decoration:
// // // // //                             const InputDecoration(labelText: 'الوزن (جم)'),
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 8),
// // // // //                     _caratDropdown(_scrapCarat, (v) {
// // // // //                       setState(() => _scrapCarat = v!);
// // // // //                     }),
// // // // //                     IconButton(
// // // // //                       icon: const Icon(Icons.add_circle, color: Colors.green),
// // // // //                       onPressed: _addScrapInStorage,
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 items: _scrapInStorage,
// // // // //                 itemLabel: (item) =>
// // // // //                     'وزن: ${item['weight']} جم — عيار ${item['carat']}',
// // // // //                 onRemove: (i) => setState(() => _scrapInStorage.removeAt(i)),
// // // // //               ),
// // // // //               _sectionTitle('المخزون (القطع الموجودة قبل استخدام التطبيق)'),
// // // // //               _listBuilderSection(
// // // // //                 addRow: Column(
// // // // //                   children: [
// // // // //                     Row(
// // // // //                       children: [
// // // // //                         Expanded(
// // // // //                           child: TextField(
// // // // //                             controller: _invValueCtrl,
// // // // //                             keyboardType: TextInputType.number,
// // // // //                             decoration: const InputDecoration(
// // // // //                                 labelText: 'القيمة (ر.س)'),
// // // // //                           ),
// // // // //                         ),
// // // // //                         const SizedBox(width: 8),
// // // // //                         Expanded(
// // // // //                           child: TextField(
// // // // //                             controller: _invWeightCtrl,
// // // // //                             keyboardType: TextInputType.number,
// // // // //                             decoration:
// // // // //                                 const InputDecoration(labelText: 'الوزن (جم)'),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                     Row(
// // // // //                       children: [
// // // // //                         _caratDropdown(_invCarat, (v) {
// // // // //                           setState(() => _invCarat = v!);
// // // // //                         }),
// // // // //                         const Spacer(),
// // // // //                         IconButton(
// // // // //                           icon:
// // // // //                               const Icon(Icons.add_circle, color: Colors.green),
// // // // //                           onPressed: _addInventoryItem,
// // // // //                         ),
// // // // //                       ],
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 items: _inventory,
// // // // //                 itemLabel: (item) =>
// // // // //                     'قيمة: ${item['value']} ر.س — وزن: ${item['weight']} جم — عيار ${item['carat']}',
// // // // //                 onRemove: (i) => setState(() => _inventory.removeAt(i)),
// // // // //               ),
// // // // //               _sectionTitle('رأس مال الشركاء (بعيار 24 — لكل شريك)'),
// // // // //               _listBuilderSection(
// // // // //                 addRow: Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: TextField(
// // // // //                         controller: _partnerNameCtrl,
// // // // //                         decoration:
// // // // //                             const InputDecoration(labelText: 'اسم الشريك'),
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 8),
// // // // //                     Expanded(
// // // // //                       child: TextField(
// // // // //                         controller: _partnerAmountCtrl,
// // // // //                         keyboardType: TextInputType.number,
// // // // //                         decoration: const InputDecoration(
// // // // //                             labelText: 'المبلغ (عيار 24)'),
// // // // //                       ),
// // // // //                     ),
// // // // //                     IconButton(
// // // // //                       icon: const Icon(Icons.add_circle, color: Colors.green),
// // // // //                       onPressed: _addPartner,
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 items: _partners,
// // // // //                 itemLabel: (item) => '${item['name']} — ${item['amount']}',
// // // // //                 onRemove: (i) => setState(() => _partners.removeAt(i)),
// // // // //               ),
// // // // //               const SizedBox(height: 24),
// // // // //               SizedBox(
// // // // //                 width: double.infinity,
// // // // //                 child: ElevatedButton(
// // // // //                   onPressed: _saving ? null : _save,
// // // // //                   style: ElevatedButton.styleFrom(
// // // // //                     padding: const EdgeInsets.symmetric(vertical: 16),
// // // // //                   ),
// // // // //                   child: _saving
// // // // //                       ? const CircularProgressIndicator()
// // // // //                       : const Text('حفظ الرصيد الافتتاحي (مرة واحدة فقط)'),
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 24),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _sectionTitle(String title) => Padding(
// // // // //         padding: const EdgeInsets.only(top: 20, bottom: 8),
// // // // //         child: Text(title,
// // // // //             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
// // // // //       );

// // // // //   Widget _twoFieldsRow(String label1, TextEditingController c1, String label2,
// // // // //       TextEditingController c2) {
// // // // //     return Row(
// // // // //       children: [
// // // // //         Expanded(
// // // // //           child: TextField(
// // // // //             controller: c1,
// // // // //             keyboardType: TextInputType.number,
// // // // //             decoration: InputDecoration(labelText: label1),
// // // // //           ),
// // // // //         ),
// // // // //         const SizedBox(width: 8),
// // // // //         Expanded(
// // // // //           child: TextField(
// // // // //             controller: c2,
// // // // //             keyboardType: TextInputType.number,
// // // // //             decoration: InputDecoration(labelText: label2),
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget _caratFieldsGrid(Map<String, TextEditingController> ctrls) {
// // // // //     return Wrap(
// // // // //       spacing: 8,
// // // // //       runSpacing: 8,
// // // // //       children: kCaratOptions.map((c) {
// // // // //         return SizedBox(
// // // // //           width: 100,
// // // // //           child: TextField(
// // // // //             controller: ctrls[c],
// // // // //             keyboardType: TextInputType.number,
// // // // //             decoration: InputDecoration(labelText: 'عيار $c'),
// // // // //           ),
// // // // //         );
// // // // //       }).toList(),
// // // // //     );
// // // // //   }

// // // // //   Widget _caratDropdown(String value, ValueChanged<String?> onChanged) {
// // // // //     return DropdownButton<String>(
// // // // //       value: value,
// // // // //       items: kCaratOptions
// // // // //           .map((c) => DropdownMenuItem(value: c, child: Text('عيار $c')))
// // // // //           .toList(),
// // // // //       onChanged: onChanged,
// // // // //     );
// // // // //   }

// // // // //   Widget _listBuilderSection({
// // // // //     required Widget addRow,
// // // // //     required List<Map<String, dynamic>> items,
// // // // //     required String Function(Map<String, dynamic>) itemLabel,
// // // // //     required void Function(int) onRemove,
// // // // //   }) {
// // // // //     return Column(
// // // // //       children: [
// // // // //         addRow,
// // // // //         const SizedBox(height: 8),
// // // // //         ...items.asMap().entries.map((entry) {
// // // // //           final i = entry.key;
// // // // //           final item = entry.value;
// // // // //           return Card(
// // // // //             child: ListTile(
// // // // //               dense: true,
// // // // //               title: Text(itemLabel(item)),
// // // // //               trailing: IconButton(
// // // // //                 icon: const Icon(Icons.delete, color: Colors.red),
// // // // //                 onPressed: () => onRemove(i),
// // // // //               ),
// // // // //             ),
// // // // //           );
// // // // //         }),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }
// // // // // opening_balance_entry_page.dart
// // // // import 'package:flutter/material.dart';
// // // // import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// // // // class OpeningBalanceEntryPage extends StatefulWidget {
// // // //   const OpeningBalanceEntryPage({super.key});

// // // //   @override
// // // //   State<OpeningBalanceEntryPage> createState() =>
// // // //       _OpeningBalanceEntryPageState();
// // // // }

// // // // class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
// // // //   final _formKey = GlobalKey<FormState>();
// // // //   bool _isSaving = false;

// // // //   // جميع الحقول تبدأ بـ 0 (لا تُجلب بيانات قديمة)
// // // //   final _dailyCashController = TextEditingController(text: '0');
// // // //   final _dailyNetworkController = TextEditingController(text: '0');
// // // //   final _safeCashController = TextEditingController(text: '0');
// // // //   final _safeNetworkController = TextEditingController(text: '0');
// // // //   final _scrap24Controller = TextEditingController(text: '0');
// // // //   final _scrap22Controller = TextEditingController(text: '0');
// // // //   final _scrap21Controller = TextEditingController(text: '0');
// // // //   final _scrap18Controller = TextEditingController(text: '0');
// // // //   final _scrap14Controller = TextEditingController(text: '0');
// // // //   final _worked24Controller = TextEditingController(text: '0');
// // // //   final _worked22Controller = TextEditingController(text: '0');
// // // //   final _worked21Controller = TextEditingController(text: '0');
// // // //   final _worked18Controller = TextEditingController(text: '0');
// // // //   final _worked14Controller = TextEditingController(text: '0');
// // // //   final _custodyCashController = TextEditingController(text: '0');
// // // //   final _custodyNetworkController = TextEditingController(text: '0');

// // // //   // قوائم للإضافة
// // // //   List<Map<String, dynamic>> scrapInStorage = [];
// // // //   final _storageWeightController = TextEditingController();
// // // //   String _storageCarat = '21';

// // // //   List<Map<String, dynamic>> inventory = [];
// // // //   final _invValueController = TextEditingController();
// // // //   final _invWeightController = TextEditingController();
// // // //   String _invCarat = '18';

// // // //   List<Map<String, dynamic>> partners = [];
// // // //   final _partnerNameController = TextEditingController();
// // // //   final _partnerAmountController = TextEditingController();

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(title: Text('إضافة رصيد جديد'), centerTitle: true),
// // // //       body: Directionality(
// // // //         textDirection: TextDirection.rtl,
// // // //         child: Form(
// // // //           key: _formKey,
// // // //           child: SingleChildScrollView(
// // // //             padding: EdgeInsets.all(16),
// // // //             child: Column(
// // // //               children: [
// // // //                 // 1. صندوق اليومي
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('صندوق اليومي',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _dailyCashController,
// // // //                                   decoration: InputDecoration(labelText: 'كاش'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 10),
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _dailyNetworkController,
// // // //                                   decoration:
// // // //                                       InputDecoration(labelText: 'شبكة'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                         ]),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 2. الخزنة
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('الخزنة',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _safeCashController,
// // // //                                   decoration: InputDecoration(labelText: 'كاش'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 10),
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _safeNetworkController,
// // // //                                   decoration:
// // // //                                       InputDecoration(labelText: 'شبكة'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                         ]),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 3. ذهب كسر
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('ذهب كسر',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Wrap(
// // // //                           spacing: 10,
// // // //                           children: [
// // // //                             _buildCaratField('24', _scrap24Controller),
// // // //                             _buildCaratField('22', _scrap22Controller),
// // // //                             _buildCaratField('21', _scrap21Controller),
// // // //                             _buildCaratField('18', _scrap18Controller),
// // // //                             _buildCaratField('14', _scrap14Controller),
// // // //                           ],
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 4. ذهب مشغول
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('ذهب مشغول',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Wrap(
// // // //                           spacing: 10,
// // // //                           children: [
// // // //                             _buildCaratField('24', _worked24Controller),
// // // //                             _buildCaratField('22', _worked22Controller),
// // // //                             _buildCaratField('21', _worked21Controller),
// // // //                             _buildCaratField('18', _worked18Controller),
// // // //                             _buildCaratField('14', _worked14Controller),
// // // //                           ],
// // // //                         ),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 5. عهدة الكسر
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('عهدة الكسر',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _custodyCashController,
// // // //                                   decoration: InputDecoration(labelText: 'كاش'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 10),
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _custodyNetworkController,
// // // //                                   decoration:
// // // //                                       InputDecoration(labelText: 'شبكة'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                         ]),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 6. كسر بالمخزن (قائمة)
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('كسر بالمخزن (إضافة جديدة)',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _storageWeightController,
// // // //                                   decoration: InputDecoration(labelText: 'وزن'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 10),
// // // //                           Expanded(
// // // //                               child: DropdownButtonFormField<String>(
// // // //                             value: _storageCarat,
// // // //                             items: ['24', '22', '21', '18', '14']
// // // //                                 .map((c) => DropdownMenuItem(
// // // //                                     value: c, child: Text('عيار $c')))
// // // //                                 .toList(),
// // // //                             onChanged: (v) =>
// // // //                                 setState(() => _storageCarat = v!),
// // // //                             decoration: InputDecoration(labelText: 'العيار'),
// // // //                           )),
// // // //                           IconButton(
// // // //                               onPressed: () {
// // // //                                 if (_storageWeightController.text.isNotEmpty) {
// // // //                                   setState(() {
// // // //                                     scrapInStorage.add({
// // // //                                       'weight': double.parse(
// // // //                                           _storageWeightController.text),
// // // //                                       'carat': _storageCarat,
// // // //                                     });
// // // //                                     _storageWeightController.clear();
// // // //                                   });
// // // //                                 }
// // // //                               },
// // // //                               icon: Icon(Icons.add)),
// // // //                         ]),
// // // //                         ...scrapInStorage.map((item) => ListTile(
// // // //                             title: Text(
// // // //                                 'وزن: ${item['weight']} - عيار: ${item['carat']}'),
// // // //                             trailing: IconButton(
// // // //                                 icon: Icon(Icons.delete, color: Colors.red),
// // // //                                 onPressed: () => setState(
// // // //                                     () => scrapInStorage.remove(item))))),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 7. المخزون (قائمة)
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('المخزون (إضافة جديدة)',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _invValueController,
// // // //                                   decoration:
// // // //                                       InputDecoration(labelText: 'القيمة'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 5),
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _invWeightController,
// // // //                                   decoration:
// // // //                                       InputDecoration(labelText: 'الوزن'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           SizedBox(width: 5),
// // // //                           Expanded(
// // // //                               child: DropdownButtonFormField<String>(
// // // //                             value: _invCarat,
// // // //                             items: ['24', '22', '21', '18', '14']
// // // //                                 .map((c) => DropdownMenuItem(
// // // //                                     value: c, child: Text('عيار $c')))
// // // //                                 .toList(),
// // // //                             onChanged: (v) => setState(() => _invCarat = v!),
// // // //                             decoration: InputDecoration(labelText: 'العيار'),
// // // //                           )),
// // // //                           IconButton(
// // // //                               onPressed: () {
// // // //                                 if (_invValueController.text.isNotEmpty &&
// // // //                                     _invWeightController.text.isNotEmpty) {
// // // //                                   setState(() {
// // // //                                     inventory.add({
// // // //                                       'value': double.parse(
// // // //                                           _invValueController.text),
// // // //                                       'weight': double.parse(
// // // //                                           _invWeightController.text),
// // // //                                       'carat': _invCarat,
// // // //                                     });
// // // //                                     _invValueController.clear();
// // // //                                     _invWeightController.clear();
// // // //                                   });
// // // //                                 }
// // // //                               },
// // // //                               icon: Icon(Icons.add)),
// // // //                         ]),
// // // //                         ...inventory.map((item) => ListTile(
// // // //                             title: Text(
// // // //                                 'قيمة: ${item['value']} - وزن: ${item['weight']} - عيار: ${item['carat']}'),
// // // //                             trailing: IconButton(
// // // //                                 icon: Icon(Icons.delete, color: Colors.red),
// // // //                                 onPressed: () =>
// // // //                                     setState(() => inventory.remove(item))))),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 10),

// // // //                 // 8. الشركاء (قائمة)
// // // //                 Card(
// // // //                   child: Padding(
// // // //                     padding: EdgeInsets.all(12),
// // // //                     child: Column(
// // // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // // //                       children: [
// // // //                         Text('إضافة شركاء جدد (بعيار 24)',
// // // //                             style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                         Row(children: [
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _partnerNameController,
// // // //                                   decoration: InputDecoration(
// // // //                                       labelText: 'اسم الشريك'))),
// // // //                           SizedBox(width: 5),
// // // //                           Expanded(
// // // //                               child: TextFormField(
// // // //                                   controller: _partnerAmountController,
// // // //                                   decoration: InputDecoration(
// // // //                                       labelText: 'المبلغ (عيار 24)'),
// // // //                                   keyboardType: TextInputType.number)),
// // // //                           IconButton(
// // // //                               onPressed: () {
// // // //                                 if (_partnerNameController.text.isNotEmpty &&
// // // //                                     _partnerAmountController.text.isNotEmpty) {
// // // //                                   setState(() {
// // // //                                     partners.add({
// // // //                                       'name': _partnerNameController.text,
// // // //                                       'amount': double.parse(
// // // //                                           _partnerAmountController.text),
// // // //                                     });
// // // //                                     _partnerNameController.clear();
// // // //                                     _partnerAmountController.clear();
// // // //                                   });
// // // //                                 }
// // // //                               },
// // // //                               icon: Icon(Icons.add)),
// // // //                         ]),
// // // //                         ...partners.map((item) => ListTile(
// // // //                             title: Text(
// // // //                                 '${item['name']} - ${item['amount']} جرام عيار 24'),
// // // //                             trailing: IconButton(
// // // //                                 icon: Icon(Icons.delete, color: Colors.red),
// // // //                                 onPressed: () =>
// // // //                                     setState(() => partners.remove(item))))),
// // // //                       ],
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 SizedBox(height: 20),

// // // //                 // زر الحفظ
// // // //                 ElevatedButton(
// // // //                   onPressed: _isSaving ? null : _saveAllData,
// // // //                   style: ElevatedButton.styleFrom(
// // // //                       minimumSize: Size(double.infinity, 50)),
// // // //                   child: _isSaving
// // // //                       ? CircularProgressIndicator(color: Colors.white)
// // // //                       : Text('حفظ الإضافة', style: TextStyle(fontSize: 18)),
// // // //                 ),
// // // //                 SizedBox(height: 30),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildCaratField(String carat, TextEditingController ctrl) {
// // // //     return SizedBox(
// // // //       width: 80,
// // // //       child: TextFormField(
// // // //         controller: ctrl,
// // // //         decoration: InputDecoration(labelText: 'عيار $carat'),
// // // //         keyboardType: TextInputType.number,
// // // //       ),
// // // //     );
// // // //   }

// // // //   Future<void> _saveAllData() async {
// // // //     if (!_formKey.currentState!.validate()) return;
// // // //     setState(() => _isSaving = true);

// // // //     try {
// // // //       // حفظ الرصيد الجديد (يتراكم مع القديم)
// // // //       await FS.saveOpeningBalance(
// // // //         dailyCashBoxCash: double.tryParse(_dailyCashController.text) ?? 0,
// // // //         dailyCashBoxNetwork: double.tryParse(_dailyNetworkController.text) ?? 0,
// // // //         safeCash: double.tryParse(_safeCashController.text) ?? 0,
// // // //         safeNetwork: double.tryParse(_safeNetworkController.text) ?? 0,
// // // //         scrapGoldByCarat: {
// // // //           '24': double.tryParse(_scrap24Controller.text) ?? 0,
// // // //           '22': double.tryParse(_scrap22Controller.text) ?? 0,
// // // //           '21': double.tryParse(_scrap21Controller.text) ?? 0,
// // // //           '18': double.tryParse(_scrap18Controller.text) ?? 0,
// // // //           '14': double.tryParse(_scrap14Controller.text) ?? 0,
// // // //         },
// // // //         workedGoldByCarat: {
// // // //           '24': double.tryParse(_worked24Controller.text) ?? 0,
// // // //           '22': double.tryParse(_worked22Controller.text) ?? 0,
// // // //           '21': double.tryParse(_worked21Controller.text) ?? 0,
// // // //           '18': double.tryParse(_worked18Controller.text) ?? 0,
// // // //           '14': double.tryParse(_worked14Controller.text) ?? 0,
// // // //         },
// // // //         scrapCustodyCash: double.tryParse(_custodyCashController.text) ?? 0,
// // // //         scrapCustodyNetwork:
// // // //             double.tryParse(_custodyNetworkController.text) ?? 0,
// // // //         scrapInStorage: scrapInStorage,
// // // //         inventory: inventory,
// // // //       );

// // // //       // إضافة الشركاء الجدد فقط
// // // //       for (var p in partners) {
// // // //         await FS.addPartnerOpeningCapital(
// // // //           partnerName: p['name'],
// // // //           amountCarat24: p['amount'],
// // // //         );
// // // //       }

// // // //       // إفراغ الحقول بعد الحفظ
// // // //       _clearFields();

// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('✅ تمت الإضافة بنجاح!')),
// // // //       );
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('❌ خطأ: $e'), backgroundColor: Colors.red),
// // // //       );
// // // //     } finally {
// // // //       if (mounted) setState(() => _isSaving = false);
// // // //     }
// // // //   }

// // // //   void _clearFields() {
// // // //     _dailyCashController.text = '0';
// // // //     _dailyNetworkController.text = '0';
// // // //     _safeCashController.text = '0';
// // // //     _safeNetworkController.text = '0';
// // // //     _scrap24Controller.text = '0';
// // // //     _scrap22Controller.text = '0';
// // // //     _scrap21Controller.text = '0';
// // // //     _scrap18Controller.text = '0';
// // // //     _scrap14Controller.text = '0';
// // // //     _worked24Controller.text = '0';
// // // //     _worked22Controller.text = '0';
// // // //     _worked21Controller.text = '0';
// // // //     _worked18Controller.text = '0';
// // // //     _worked14Controller.text = '0';
// // // //     _custodyCashController.text = '0';
// // // //     _custodyNetworkController.text = '0';
// // // //     setState(() {
// // // //       scrapInStorage.clear();
// // // //       inventory.clear();
// // // //       partners.clear();
// // // //     });
// // // //   }
// // // // }
// // // import 'package:flutter/material.dart';
// // // import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// // // class OpeningBalanceEntryPage extends StatefulWidget {
// // //   const OpeningBalanceEntryPage({super.key});

// // //   @override
// // //   State<OpeningBalanceEntryPage> createState() =>
// // //       _OpeningBalanceEntryPageState();
// // // }

// // // class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   bool _isSaving = false;

// // //   final _dailyCashController = TextEditingController(text: '0');
// // //   final _dailyNetworkController = TextEditingController(text: '0');
// // //   final _safeCashController = TextEditingController(text: '0');
// // //   final _safeNetworkController = TextEditingController(text: '0');
// // //   final _scrap24Controller = TextEditingController(text: '0');
// // //   final _scrap22Controller = TextEditingController(text: '0');
// // //   final _scrap21Controller = TextEditingController(text: '0');
// // //   final _scrap18Controller = TextEditingController(text: '0');
// // //   final _scrap14Controller = TextEditingController(text: '0');
// // //   final _worked24Controller = TextEditingController(text: '0');
// // //   final _worked22Controller = TextEditingController(text: '0');
// // //   final _worked21Controller = TextEditingController(text: '0');
// // //   final _worked18Controller = TextEditingController(text: '0');
// // //   final _worked14Controller = TextEditingController(text: '0');
// // //   final _custodyCashController = TextEditingController(text: '0');
// // //   final _custodyNetworkController = TextEditingController(text: '0');

// // //   List<Map<String, dynamic>> scrapInStorage = [];
// // //   final _storageWeightController = TextEditingController();
// // //   String _storageCarat = '21';

// // //   List<Map<String, dynamic>> inventory = [];
// // //   final _invValueController = TextEditingController();
// // //   final _invWeightController = TextEditingController();
// // //   String _invCarat = '18';

// // //   List<Map<String, dynamic>> partners = [];
// // //   final _partnerNameController = TextEditingController();
// // //   final _partnerAmountController = TextEditingController();

// // //   static const Color goldColor = Color(0xFFD4AF37);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.grey.shade50,
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           'إضافة رصيد جديد',
// // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //         ),
// // //         centerTitle: true,
// // //         backgroundColor: goldColor,
// // //         elevation: 0,
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //       ),
// // //       body: Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: Form(
// // //           key: _formKey,
// // //           child: SingleChildScrollView(
// // //             padding: const EdgeInsets.all(16),
// // //             child: Column(
// // //               children: [
// // //                 // 1. صندوق اليومي
// // //                 _buildSectionCard(
// // //                   icon: Icons.business_center,
// // //                   title: 'صندوق اليومي',
// // //                   child: Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _dailyCashController,
// // //                           label: 'كاش',
// // //                           icon: Icons.money,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _dailyNetworkController,
// // //                           label: 'شبكة',
// // //                           icon: Icons.wifi,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // 2. الخزنة
// // //                 _buildSectionCard(
// // //                   icon: Icons.lock,
// // //                   title: 'الخزنة',
// // //                   child: Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _safeCashController,
// // //                           label: 'كاش',
// // //                           icon: Icons.money,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _safeNetworkController,
// // //                           label: 'شبكة',
// // //                           icon: Icons.wifi,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // 3. ذهب كسر
// // //                 _buildSectionCard(
// // //                   icon: Icons.crisis_alert,
// // //                   title: 'ذهب كسر',
// // //                   child: _buildCaratGrid(
// // //                     controllers: {
// // //                       '24': _scrap24Controller,
// // //                       '22': _scrap22Controller,
// // //                       '21': _scrap21Controller,
// // //                       '18': _scrap18Controller,
// // //                       '14': _scrap14Controller,
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // 4. ذهب مشغول
// // //                 _buildSectionCard(
// // //                   icon: Icons.work,
// // //                   title: 'ذهب مشغول',
// // //                   child: _buildCaratGrid(
// // //                     controllers: {
// // //                       '24': _worked24Controller,
// // //                       '22': _worked22Controller,
// // //                       '21': _worked21Controller,
// // //                       '18': _worked18Controller,
// // //                       '14': _worked14Controller,
// // //                     },
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // 5. عهدة الكسر
// // //                 _buildSectionCard(
// // //                   icon: Icons.account_balance_wallet,
// // //                   title: 'عهدة الكسر',
// // //                   child: Row(
// // //                     children: [
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _custodyCashController,
// // //                           label: 'كاش',
// // //                           icon: Icons.money,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Expanded(
// // //                         child: _buildInputField(
// // //                           controller: _custodyNetworkController,
// // //                           label: 'شبكة',
// // //                           icon: Icons.wifi,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // ===== 6. كسر بالمخزن (حل Overflow) =====
// // //                 _buildSectionCard(
// // //                   icon: Icons.storage,
// // //                   title: 'كسر بالمخزن (إضافة جديدة)',
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           // تقليل flex لحقل الوزن
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: _buildInputField(
// // //                               controller: _storageWeightController,
// // //                               label: 'وزن (جم)',
// // //                               icon: Icons.scale,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 8),
// // //                           // تقليل flex لحقل العيار
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: _buildDropdownField(
// // //                               value: _storageCarat,
// // //                               items: ['24', '22', '21', '18', '14'],
// // //                               onChanged: (v) =>
// // //                                   setState(() => _storageCarat = v!),
// // //                               label: 'العيار',
// // //                             ),
// // //                           ),
// // //                           // زر الإضافة بحجم أصغر قليلاً
// // //                           IconButton(
// // //                             onPressed: () {
// // //                               if (_storageWeightController.text.isNotEmpty) {
// // //                                 setState(() {
// // //                                   scrapInStorage.add({
// // //                                     'weight': double.parse(
// // //                                         _storageWeightController.text),
// // //                                     'carat': _storageCarat,
// // //                                   });
// // //                                   _storageWeightController.clear();
// // //                                 });
// // //                               }
// // //                             },
// // //                             icon: Icon(Icons.add_circle,
// // //                                 color: goldColor, size: 28),
// // //                             padding: EdgeInsets.zero,
// // //                             constraints: const BoxConstraints(),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       if (scrapInStorage.isNotEmpty) ...[
// // //                         const SizedBox(height: 10),
// // //                         ...scrapInStorage.map((item) => _buildListItem(
// // //                               text:
// // //                                   'وزن: ${item['weight']} جم - عيار: ${item['carat']}',
// // //                               onDelete: () =>
// // //                                   setState(() => scrapInStorage.remove(item)),
// // //                             )),
// // //                       ],
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // ===== 7. المخزون (حل Overflow) =====
// // //                 _buildSectionCard(
// // //                   icon: Icons.inventory,
// // //                   title: 'المخزون (إضافة جديدة)',
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           // تقليل flex لكل حقل
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: _buildInputField(
// // //                               controller: _invValueController,
// // //                               label: 'القيمة',
// // //                               icon: Icons.attach_money,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 6),
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: _buildInputField(
// // //                               controller: _invWeightController,
// // //                               label: 'وزن (جم)',
// // //                               icon: Icons.scale,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 6),
// // //                           Expanded(
// // //                             flex: 2,
// // //                             child: _buildDropdownField(
// // //                               value: _invCarat,
// // //                               items: ['24', '22', '21', '18', '14'],
// // //                               onChanged: (v) => setState(() => _invCarat = v!),
// // //                               label: 'العيار',
// // //                             ),
// // //                           ),
// // //                           IconButton(
// // //                             onPressed: () {
// // //                               if (_invValueController.text.isNotEmpty &&
// // //                                   _invWeightController.text.isNotEmpty) {
// // //                                 setState(() {
// // //                                   inventory.add({
// // //                                     'value':
// // //                                         double.parse(_invValueController.text),
// // //                                     'weight':
// // //                                         double.parse(_invWeightController.text),
// // //                                     'carat': _invCarat,
// // //                                   });
// // //                                   _invValueController.clear();
// // //                                   _invWeightController.clear();
// // //                                 });
// // //                               }
// // //                             },
// // //                             icon: Icon(Icons.add_circle,
// // //                                 color: goldColor, size: 28),
// // //                             padding: EdgeInsets.zero,
// // //                             constraints: const BoxConstraints(),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       if (inventory.isNotEmpty) ...[
// // //                         const SizedBox(height: 10),
// // //                         ...inventory.map((item) => _buildListItem(
// // //                               text:
// // //                                   'قيمة: ${item['value']} - وزن: ${item['weight']} جم - عيار: ${item['carat']}',
// // //                               onDelete: () =>
// // //                                   setState(() => inventory.remove(item)),
// // //                             )),
// // //                       ],
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 12),

// // //                 // ===== 8. الشركاء (حل Overflow) =====
// // //                 _buildSectionCard(
// // //                   icon: Icons.people,
// // //                   title: 'إضافة شركاء جدد (بعيار 24)',
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             flex: 3,
// // //                             child: _buildInputField(
// // //                               controller: _partnerNameController,
// // //                               label: 'اسم الشريك',
// // //                               icon: Icons.person,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 8),
// // //                           Expanded(
// // //                             flex: 3,
// // //                             child: _buildInputField(
// // //                               controller: _partnerAmountController,
// // //                               label: 'المبلغ (جم)',
// // //                               icon: Icons.money,
// // //                             ),
// // //                           ),
// // //                           IconButton(
// // //                             onPressed: () {
// // //                               if (_partnerNameController.text.isNotEmpty &&
// // //                                   _partnerAmountController.text.isNotEmpty) {
// // //                                 setState(() {
// // //                                   partners.add({
// // //                                     'name': _partnerNameController.text,
// // //                                     'amount': double.parse(
// // //                                         _partnerAmountController.text),
// // //                                   });
// // //                                   _partnerNameController.clear();
// // //                                   _partnerAmountController.clear();
// // //                                 });
// // //                               }
// // //                             },
// // //                             icon: Icon(Icons.add_circle,
// // //                                 color: goldColor, size: 28),
// // //                             padding: EdgeInsets.zero,
// // //                             constraints: const BoxConstraints(),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       if (partners.isNotEmpty) ...[
// // //                         const SizedBox(height: 10),
// // //                         ...partners.map((item) => _buildListItem(
// // //                               text:
// // //                                   '${item['name']} - ${item['amount']} جم عيار 24',
// // //                               onDelete: () =>
// // //                                   setState(() => partners.remove(item)),
// // //                             )),
// // //                       ],
// // //                     ],
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 24),

// // //                 SizedBox(
// // //                   width: double.infinity,
// // //                   height: 56,
// // //                   child: ElevatedButton.icon(
// // //                     onPressed: _isSaving ? null : _saveAllData,
// // //                     icon: _isSaving
// // //                         ? const SizedBox(
// // //                             width: 24,
// // //                             height: 24,
// // //                             child: CircularProgressIndicator(
// // //                               strokeWidth: 2,
// // //                               color: Colors.white,
// // //                             ),
// // //                           )
// // //                         : const Icon(Icons.save, color: Colors.white),
// // //                     label: Text(
// // //                       _isSaving ? 'جاري الحفظ...' : 'حفظ الإضافة',
// // //                       style: const TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                         color: Colors.white,
// // //                       ),
// // //                     ),
// // //                     style: ElevatedButton.styleFrom(
// // //                       backgroundColor: goldColor,
// // //                       foregroundColor: Colors.white,
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),
// // //                       elevation: 2,
// // //                     ),
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 20),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ============================================================
// // //   // 🔹 دوال بناء الواجهة (مع تحسينات لمنع Overflow)
// // //   // ============================================================

// // //   Widget _buildSectionCard({
// // //     required IconData icon,
// // //     required String title,
// // //     required Widget child,
// // //   }) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.04),
// // //             blurRadius: 8,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(14),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Row(
// // //               children: [
// // //                 Icon(icon, color: goldColor, size: 22),
// // //                 const SizedBox(width: 10),
// // //                 Text(
// // //                   title,
// // //                   style: const TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Color(0xFF333333),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //             const SizedBox(height: 12),
// // //             child,
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildInputField({
// // //     required TextEditingController controller,
// // //     required String label,
// // //     required IconData icon,
// // //   }) {
// // //     return TextFormField(
// // //       controller: controller,
// // //       keyboardType: TextInputType.number,
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         labelStyle: const TextStyle(fontSize: 12), // تصغير الخط لتوفير مساحة
// // //         prefixIcon: Icon(icon, color: goldColor, size: 18),
// // //         border: const OutlineInputBorder(
// // //           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //         ),
// // //         enabledBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(10),
// // //           borderSide: BorderSide(color: Colors.grey.shade300),
// // //         ),
// // //         focusedBorder: const OutlineInputBorder(
// // //           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //           borderSide: BorderSide(color: goldColor, width: 2),
// // //         ),
// // //         contentPadding:
// // //             const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// // //         isDense: true, // تقليل الارتفاع الداخلي للحقل
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDropdownField({
// // //     required String value,
// // //     required List<String> items,
// // //     required Function(String?) onChanged,
// // //     required String label,
// // //   }) {
// // //     return DropdownButtonFormField<String>(
// // //       value: value,
// // //       items: items.map((c) {
// // //         return DropdownMenuItem(value: c, child: Text('عيار $c'));
// // //       }).toList(),
// // //       onChanged: onChanged,
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         labelStyle: const TextStyle(fontSize: 12),
// // //         border: const OutlineInputBorder(
// // //           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //         ),
// // //         enabledBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(10),
// // //           borderSide: BorderSide(color: Colors.grey.shade300),
// // //         ),
// // //         focusedBorder: const OutlineInputBorder(
// // //           borderRadius: BorderRadius.all(Radius.circular(10)),
// // //           borderSide: BorderSide(color: goldColor, width: 2),
// // //         ),
// // //         contentPadding:
// // //             const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// // //         isDense: true,
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildCaratGrid({
// // //     required Map<String, TextEditingController> controllers,
// // //   }) {
// // //     return GridView.count(
// // //       shrinkWrap: true,
// // //       physics: const NeverScrollableScrollPhysics(),
// // //       crossAxisCount: 5,
// // //       crossAxisSpacing: 6,
// // //       mainAxisSpacing: 6,
// // //       childAspectRatio: 1.3,
// // //       children: controllers.entries.map((entry) {
// // //         return TextFormField(
// // //           controller: entry.value,
// // //           keyboardType: TextInputType.number,
// // //           textAlign: TextAlign.center,
// // //           decoration: InputDecoration(
// // //             labelText: 'عيار ${entry.key}',
// // //             labelStyle: const TextStyle(fontSize: 10),
// // //             border: const OutlineInputBorder(
// // //               borderRadius: BorderRadius.all(Radius.circular(10)),
// // //             ),
// // //             enabledBorder: OutlineInputBorder(
// // //               borderRadius: BorderRadius.circular(10),
// // //               borderSide: BorderSide(color: Colors.grey.shade300),
// // //             ),
// // //             focusedBorder: const OutlineInputBorder(
// // //               borderRadius: BorderRadius.all(Radius.circular(10)),
// // //               borderSide: BorderSide(color: goldColor, width: 2),
// // //             ),
// // //             contentPadding: const EdgeInsets.symmetric(vertical: 6),
// // //             isDense: true,
// // //           ),
// // //         );
// // //       }).toList(),
// // //     );
// // //   }

// // //   Widget _buildListItem({
// // //     required String text,
// // //     required VoidCallback onDelete,
// // //   }) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 6),
// // //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade50,
// // //         borderRadius: BorderRadius.circular(10),
// // //         border: Border.all(color: Colors.grey.shade200),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Icon(Icons.circle, color: goldColor.withOpacity(0.5), size: 6),
// // //           const SizedBox(width: 6),
// // //           Expanded(
// // //             child: Text(
// // //               text,
// // //               style: const TextStyle(fontSize: 12),
// // //               overflow: TextOverflow.ellipsis,
// // //             ),
// // //           ),
// // //           IconButton(
// // //             icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
// // //             onPressed: onDelete,
// // //             padding: EdgeInsets.zero,
// // //             constraints: const BoxConstraints(),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ============================================================
// // //   // 🔹 دوال المنطق (بدون تغيير)
// // //   // ============================================================

// // //   Future<void> _saveAllData() async {
// // //     if (!_formKey.currentState!.validate()) return;
// // //     setState(() => _isSaving = true);

// // //     try {
// // //       await FS.saveOpeningBalance(
// // //         dailyCashBoxCash: double.tryParse(_dailyCashController.text) ?? 0,
// // //         dailyCashBoxNetwork: double.tryParse(_dailyNetworkController.text) ?? 0,
// // //         safeCash: double.tryParse(_safeCashController.text) ?? 0,
// // //         safeNetwork: double.tryParse(_safeNetworkController.text) ?? 0,
// // //         scrapGoldByCarat: {
// // //           '24': double.tryParse(_scrap24Controller.text) ?? 0,
// // //           '22': double.tryParse(_scrap22Controller.text) ?? 0,
// // //           '21': double.tryParse(_scrap21Controller.text) ?? 0,
// // //           '18': double.tryParse(_scrap18Controller.text) ?? 0,
// // //           '14': double.tryParse(_scrap14Controller.text) ?? 0,
// // //         },
// // //         workedGoldByCarat: {
// // //           '24': double.tryParse(_worked24Controller.text) ?? 0,
// // //           '22': double.tryParse(_worked22Controller.text) ?? 0,
// // //           '21': double.tryParse(_worked21Controller.text) ?? 0,
// // //           '18': double.tryParse(_worked18Controller.text) ?? 0,
// // //           '14': double.tryParse(_worked14Controller.text) ?? 0,
// // //         },
// // //         scrapCustodyCash: double.tryParse(_custodyCashController.text) ?? 0,
// // //         scrapCustodyNetwork:
// // //             double.tryParse(_custodyNetworkController.text) ?? 0,
// // //         scrapInStorage: scrapInStorage,
// // //         inventory: inventory,
// // //       );

// // //       for (var p in partners) {
// // //         await FS.addPartnerOpeningCapital(
// // //           partnerName: p['name'],
// // //           amountCarat24: p['amount'],
// // //         );
// // //       }

// // //       _clearFields();

// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: const Text('✅ تمت الإضافة بنجاح!'),
// // //           backgroundColor: Colors.green,
// // //           behavior: SnackBarBehavior.floating,
// // //           shape:
// // //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //         ),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(
// // //           content: Text('❌ خطأ: $e'),
// // //           backgroundColor: Colors.red,
// // //           behavior: SnackBarBehavior.floating,
// // //           shape:
// // //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// // //         ),
// // //       );
// // //     } finally {
// // //       if (mounted) setState(() => _isSaving = false);
// // //     }
// // //   }

// // //   void _clearFields() {
// // //     _dailyCashController.text = '0';
// // //     _dailyNetworkController.text = '0';
// // //     _safeCashController.text = '0';
// // //     _safeNetworkController.text = '0';
// // //     _scrap24Controller.text = '0';
// // //     _scrap22Controller.text = '0';
// // //     _scrap21Controller.text = '0';
// // //     _scrap18Controller.text = '0';
// // //     _scrap14Controller.text = '0';
// // //     _worked24Controller.text = '0';
// // //     _worked22Controller.text = '0';
// // //     _worked21Controller.text = '0';
// // //     _worked18Controller.text = '0';
// // //     _worked14Controller.text = '0';
// // //     _custodyCashController.text = '0';
// // //     _custodyNetworkController.text = '0';
// // //     setState(() {
// // //       scrapInStorage.clear();
// // //       inventory.clear();
// // //       partners.clear();
// // //     });
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// // class OpeningBalanceEntryPage extends StatefulWidget {
// //   const OpeningBalanceEntryPage({super.key});

// //   @override
// //   State<OpeningBalanceEntryPage> createState() =>
// //       _OpeningBalanceEntryPageState();
// // }

// // class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   bool _isSaving = false;

// //   // 1. صندوق اليومي
// //   final _dailyCashController = TextEditingController(text: '0');
// //   final _dailyNetworkController = TextEditingController(text: '0');

// //   // 2. الخزنة
// //   final _safeCashController = TextEditingController(text: '0');
// //   final _safeNetworkController = TextEditingController(text: '0');

// //   // 3. ذهب كسر
// //   final _scrap24Controller = TextEditingController(text: '0');
// //   final _scrap22Controller = TextEditingController(text: '0');
// //   final _scrap21Controller = TextEditingController(text: '0');
// //   final _scrap18Controller = TextEditingController(text: '0');
// //   final _scrap14Controller = TextEditingController(text: '0');

// //   // 4. ذهب مشغول
// //   final _worked24Controller = TextEditingController(text: '0');
// //   final _worked22Controller = TextEditingController(text: '0');
// //   final _worked21Controller = TextEditingController(text: '0');
// //   final _worked18Controller = TextEditingController(text: '0');
// //   final _worked14Controller = TextEditingController(text: '0');

// //   // 5. عهدة الكسر
// //   final _custodyCashController = TextEditingController(text: '0');
// //   final _custodyNetworkController = TextEditingController(text: '0');

// //   // 6. كسر بالمخزن (إضافة جديدة)
// //   List<Map<String, dynamic>> scrapInStorage = [];
// //   final _storageWeightController = TextEditingController();
// //   String _storageCarat = '21';

// //   // 7. المخزون (إضافة جديدة)
// //   List<Map<String, dynamic>> inventory = [];
// //   final _invValueController = TextEditingController();
// //   final _invWeightController = TextEditingController();
// //   String _invCarat = '18';

// //   // 8. الشركاء
// //   List<Map<String, dynamic>> partners = [];
// //   final _partnerNameController = TextEditingController();
// //   final _partnerAmountController = TextEditingController();

// //   static const Color goldColor = Color(0xFFD4AF37);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade50,
// //       appBar: AppBar(
// //         title: const Text(
// //           'إضافة رصيد افتتاحى',
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: goldColor,
// //         elevation: 0,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Form(
// //           key: _formKey,
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               children: [
// //                 // 1. صندوق اليومي
// //                 _buildSectionCard(
// //                   icon: Icons.business_center,
// //                   title: 'صندوق اليومي',
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _dailyCashController,
// //                           label: 'كاش',
// //                           icon: Icons.money,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _dailyNetworkController,
// //                           label: 'شبكة',
// //                           icon: Icons.wifi,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 2. الخزنة
// //                 _buildSectionCard(
// //                   icon: Icons.lock,
// //                   title: 'الخزنة',
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _safeCashController,
// //                           label: 'كاش',
// //                           icon: Icons.money,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _safeNetworkController,
// //                           label: 'شبكة',
// //                           icon: Icons.wifi,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 3. ذهب كسر (محسّن لمنع overflow)
// //                 _buildSectionCard(
// //                   icon: Icons.crisis_alert,
// //                   title: 'ذهب كسر',
// //                   child: _buildCaratRow(
// //                     controllers: {
// //                       '24': _scrap24Controller,
// //                       '22': _scrap22Controller,
// //                       '21': _scrap21Controller,
// //                       '18': _scrap18Controller,
// //                       '14': _scrap14Controller,
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 4. ذهب مشغول (محسّن)
// //                 _buildSectionCard(
// //                   icon: Icons.work,
// //                   title: 'ذهب مشغول',
// //                   child: _buildCaratRow(
// //                     controllers: {
// //                       '24': _worked24Controller,
// //                       '22': _worked22Controller,
// //                       '21': _worked21Controller,
// //                       '18': _worked18Controller,
// //                       '14': _worked14Controller,
// //                     },
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 5. عهدة الكسر
// //                 _buildSectionCard(
// //                   icon: Icons.account_balance_wallet,
// //                   title: 'عهدة الكسر',
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _custodyCashController,
// //                           label: 'كاش',
// //                           icon: Icons.money,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: _buildInputField(
// //                           controller: _custodyNetworkController,
// //                           label: 'شبكة',
// //                           icon: Icons.wifi,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 6. كسر بالمخزن (باستخدام Row + Expanded)
// //                 _buildSectionCard(
// //                   icon: Icons.storage,
// //                   title: 'كسر بالمخزن (إضافة جديدة)',
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildDropdownField(
// //                               value: _storageCarat,
// //                               items: const ['24', '22', '21', '18', '14'],
// //                               onChanged: (v) =>
// //                                   setState(() => _storageCarat = v!),
// //                               label: 'العيار',
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildInputField(
// //                               controller: _storageWeightController,
// //                               label: 'وزن (جم)',
// //                               icon: Icons.scale,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             onPressed: () {
// //                               if (_storageWeightController.text.isNotEmpty) {
// //                                 setState(() {
// //                                   scrapInStorage.add({
// //                                     'weight': double.parse(
// //                                         _storageWeightController.text),
// //                                     'carat': _storageCarat,
// //                                   });
// //                                   _storageWeightController.clear();
// //                                 });
// //                               }
// //                             },
// //                             icon: Icon(Icons.add_circle,
// //                                 color: goldColor, size: 32),
// //                             padding: EdgeInsets.zero,
// //                             constraints: const BoxConstraints(),
// //                           ),
// //                         ],
// //                       ),
// //                       if (scrapInStorage.isNotEmpty) ...[
// //                         const SizedBox(height: 10),
// //                         ...scrapInStorage.map((item) => _buildListItem(
// //                               text:
// //                                   'وزن: ${item['weight']} جم - عيار: ${item['carat']}',
// //                               onDelete: () =>
// //                                   setState(() => scrapInStorage.remove(item)),
// //                             )),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 7. المخزون (باستخدام Row + Expanded)
// //                 _buildSectionCard(
// //                   icon: Icons.inventory,
// //                   title: 'المخزون (إضافة جديدة)',
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildDropdownField(
// //                               value: _invCarat,
// //                               items: const ['24', '22', '21', '18', '14'],
// //                               onChanged: (v) => setState(() => _invCarat = v!),
// //                               label: 'العيار',
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildInputField(
// //                               controller: _invWeightController,
// //                               label: 'وزن (جم)',
// //                               icon: Icons.scale,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildInputField(
// //                               controller: _invValueController,
// //                               label: 'القيمة',
// //                               icon: Icons.attach_money,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             onPressed: () {
// //                               if (_invValueController.text.isNotEmpty &&
// //                                   _invWeightController.text.isNotEmpty) {
// //                                 setState(() {
// //                                   inventory.add({
// //                                     'value':
// //                                         double.parse(_invValueController.text),
// //                                     'weight':
// //                                         double.parse(_invWeightController.text),
// //                                     'carat': _invCarat,
// //                                   });
// //                                   _invValueController.clear();
// //                                   _invWeightController.clear();
// //                                 });
// //                               }
// //                             },
// //                             icon: Icon(Icons.add_circle,
// //                                 color: goldColor, size: 32),
// //                             padding: EdgeInsets.zero,
// //                             constraints: const BoxConstraints(),
// //                           ),
// //                         ],
// //                       ),
// //                       if (inventory.isNotEmpty) ...[
// //                         const SizedBox(height: 10),
// //                         ...inventory.map((item) => _buildListItem(
// //                               text:
// //                                   'عيار: ${item['carat']} - وزن: ${item['weight']} جم - قيمة: ${item['value']}',
// //                               onDelete: () =>
// //                                   setState(() => inventory.remove(item)),
// //                             )),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // 8. الشركاء (باستخدام Row + Expanded)
// //                 _buildSectionCard(
// //                   icon: Icons.people,
// //                   title: 'إضافة شركاء جدد (بعيار 24)',
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             flex: 3,
// //                             child: _buildInputField(
// //                               controller: _partnerNameController,
// //                               label: 'اسم الشريك',
// //                               icon: Icons.person,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           Expanded(
// //                             flex: 2,
// //                             child: _buildInputField(
// //                               controller: _partnerAmountController,
// //                               label: 'الوزن (جم)',
// //                               icon: Icons.money,
// //                             ),
// //                           ),
// //                           IconButton(
// //                             onPressed: () {
// //                               if (_partnerNameController.text.isNotEmpty &&
// //                                   _partnerAmountController.text.isNotEmpty) {
// //                                 setState(() {
// //                                   partners.add({
// //                                     'name': _partnerNameController.text,
// //                                     'amount': double.parse(
// //                                         _partnerAmountController.text),
// //                                   });
// //                                   _partnerNameController.clear();
// //                                   _partnerAmountController.clear();
// //                                 });
// //                               }
// //                             },
// //                             icon: Icon(Icons.add_circle,
// //                                 color: goldColor, size: 32),
// //                             padding: EdgeInsets.zero,
// //                             constraints: const BoxConstraints(),
// //                           ),
// //                         ],
// //                       ),
// //                       if (partners.isNotEmpty) ...[
// //                         const SizedBox(height: 10),
// //                         ...partners.map((item) => _buildListItem(
// //                               text:
// //                                   '${item['name']} - ${item['amount']} جم عيار 24',
// //                               onDelete: () =>
// //                                   setState(() => partners.remove(item)),
// //                             )),
// //                       ],
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 24),

// //                 // زر الحفظ
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: 56,
// //                   child: ElevatedButton.icon(
// //                     onPressed: _isSaving ? null : _saveAllData,
// //                     icon: _isSaving
// //                         ? const SizedBox(
// //                             width: 24,
// //                             height: 24,
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               color: Colors.white,
// //                             ),
// //                           )
// //                         : const Icon(Icons.save, color: Colors.white),
// //                     label: Text(
// //                       _isSaving ? 'جاري الحفظ...' : 'حفظ الإضافة',
// //                       style: const TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.white,
// //                       ),
// //                     ),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: goldColor,
// //                       foregroundColor: Colors.white,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                       elevation: 2,
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 دوال بناء الواجهة (محسّنة بالكامل)
// //   // ============================================================

// //   Widget _buildSectionCard({
// //     required IconData icon,
// //     required String title,
// //     required Widget child,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
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
// //               ],
// //             ),
// //             const SizedBox(height: 12),
// //             child,
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // حقل إدخال نصي (مع isDense لتقليل الارتفاع)
// //   Widget _buildInputField({
// //     required TextEditingController controller,
// //     required String label,
// //     required IconData icon,
// //   }) {
// //     return TextFormField(
// //       controller: controller,
// //       keyboardType: TextInputType.number,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: const TextStyle(fontSize: 12),
// //         prefixIcon: Icon(icon, color: goldColor, size: 18),
// //         border: const OutlineInputBorder(
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //           borderSide: BorderSide(color: Colors.grey.shade300),
// //         ),
// //         focusedBorder: const OutlineInputBorder(
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //           borderSide: BorderSide(color: goldColor, width: 2),
// //         ),
// //         contentPadding:
// //             const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
// //         isDense: true,
// //       ),
// //     );
// //   }

// //   // حقل اختيار منسدل (مع isExpanded: true لمنع overflow)
// //   Widget _buildDropdownField({
// //     required String value,
// //     required List<String> items,
// //     required Function(String?) onChanged,
// //     required String label,
// //   }) {
// //     return DropdownButtonFormField<String>(
// //       value: value,
// //       isExpanded: true, // 🔥 يحل مشكلة overflow
// //       items: items.map((c) {
// //         return DropdownMenuItem(
// //           value: c,
// //           child: Text(
// //             'عيار $c',
// //             overflow: TextOverflow.ellipsis,
// //             style: const TextStyle(fontSize: 12),
// //           ),
// //         );
// //       }).toList(),
// //       onChanged: onChanged,
// //       decoration: InputDecoration(
// //         labelText: label,
// //         labelStyle: const TextStyle(fontSize: 12),
// //         border: const OutlineInputBorder(
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //           borderSide: BorderSide(color: Colors.grey.shade300),
// //         ),
// //         focusedBorder: const OutlineInputBorder(
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //           borderSide: BorderSide(color: goldColor, width: 2),
// //         ),
// //         contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
// //         isDense: true,
// //       ),
// //     );
// //   }

// //   // صف عيارات ذهب (5 حقول موزعة بالتساوي)
// //   Widget _buildCaratRow({
// //     required Map<String, TextEditingController> controllers,
// //   }) {
// //     return Row(
// //       children: controllers.entries.map((entry) {
// //         return Expanded(
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 2),
// //             child: TextFormField(
// //               controller: entry.value,
// //               keyboardType: TextInputType.number,
// //               textAlign: TextAlign.center,
// //               decoration: InputDecoration(
// //                 labelText: 'عيار ${entry.key}',
// //                 labelStyle: const TextStyle(fontSize: 10),
// //                 border: const OutlineInputBorder(
// //                   borderRadius: BorderRadius.all(Radius.circular(8)),
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                   borderSide: BorderSide(color: Colors.grey.shade300),
// //                 ),
// //                 focusedBorder: const OutlineInputBorder(
// //                   borderRadius: BorderRadius.all(Radius.circular(8)),
// //                   borderSide: BorderSide(color: goldColor, width: 2),
// //                 ),
// //                 contentPadding: const EdgeInsets.symmetric(vertical: 8),
// //                 isDense: true,
// //               ),
// //             ),
// //           ),
// //         );
// //       }).toList(),
// //     );
// //   }

// //   // عنصر قائمة قابل للحذف
// //   Widget _buildListItem({
// //     required String text,
// //     required VoidCallback onDelete,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 6),
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(Icons.circle, color: goldColor.withOpacity(0.5), size: 6),
// //           const SizedBox(width: 6),
// //           Expanded(
// //             child: Text(
// //               text,
// //               style: const TextStyle(fontSize: 12),
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
// //             onPressed: onDelete,
// //             padding: EdgeInsets.zero,
// //             constraints: const BoxConstraints(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // 🔹 دوال المنطق (نفس الكود الأصلي)
// //   // ============================================================

// //   Future<void> _saveAllData() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     setState(() => _isSaving = true);

// //     try {
// //       await FS.saveOpeningBalance(
// //         dailyCashBoxCash: double.tryParse(_dailyCashController.text) ?? 0,
// //         dailyCashBoxNetwork: double.tryParse(_dailyNetworkController.text) ?? 0,
// //         safeCash: double.tryParse(_safeCashController.text) ?? 0,
// //         safeNetwork: double.tryParse(_safeNetworkController.text) ?? 0,
// //         scrapGoldByCarat: {
// //           '24': double.tryParse(_scrap24Controller.text) ?? 0,
// //           '22': double.tryParse(_scrap22Controller.text) ?? 0,
// //           '21': double.tryParse(_scrap21Controller.text) ?? 0,
// //           '18': double.tryParse(_scrap18Controller.text) ?? 0,
// //           '14': double.tryParse(_scrap14Controller.text) ?? 0,
// //         },
// //         workedGoldByCarat: {
// //           '24': double.tryParse(_worked24Controller.text) ?? 0,
// //           '22': double.tryParse(_worked22Controller.text) ?? 0,
// //           '21': double.tryParse(_worked21Controller.text) ?? 0,
// //           '18': double.tryParse(_worked18Controller.text) ?? 0,
// //           '14': double.tryParse(_worked14Controller.text) ?? 0,
// //         },
// //         scrapCustodyCash: double.tryParse(_custodyCashController.text) ?? 0,
// //         scrapCustodyNetwork:
// //             double.tryParse(_custodyNetworkController.text) ?? 0,
// //         scrapInStorage: scrapInStorage,
// //         inventory: inventory,
// //       );

// //       for (var p in partners) {
// //         await FS.addPartnerOpeningCapital(
// //           partnerName: p['name'],
// //           amountCarat24: p['amount'],
// //         );
// //       }

// //       _clearFields();

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('✅ تمت الإضافة بنجاح!'),
// //           backgroundColor: Colors.green,
// //           behavior: SnackBarBehavior.floating,
// //           shape:
// //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         ),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('❌ خطأ: $e'),
// //           backgroundColor: Colors.red,
// //           behavior: SnackBarBehavior.floating,
// //           shape:
// //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //         ),
// //       );
// //     } finally {
// //       if (mounted) setState(() => _isSaving = false);
// //     }
// //   }

// //   void _clearFields() {
// //     _dailyCashController.text = '0';
// //     _dailyNetworkController.text = '0';
// //     _safeCashController.text = '0';
// //     _safeNetworkController.text = '0';
// //     _scrap24Controller.text = '0';
// //     _scrap22Controller.text = '0';
// //     _scrap21Controller.text = '0';
// //     _scrap18Controller.text = '0';
// //     _scrap14Controller.text = '0';
// //     _worked24Controller.text = '0';
// //     _worked22Controller.text = '0';
// //     _worked21Controller.text = '0';
// //     _worked18Controller.text = '0';
// //     _worked14Controller.text = '0';
// //     _custodyCashController.text = '0';
// //     _custodyNetworkController.text = '0';
// //     setState(() {
// //       scrapInStorage.clear();
// //       inventory.clear();
// //       partners.clear();
// //     });
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:uhf_gold_shop/services/firestore_service.dart'; // غيّر المسار حسب مشروعك

// class OpeningBalanceEntryPage extends StatefulWidget {
//   const OpeningBalanceEntryPage({super.key});

//   @override
//   State<OpeningBalanceEntryPage> createState() =>
//       _OpeningBalanceEntryPageState();
// }

// class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSaving = false;

//   // 1. صندوق اليومي (تبدأ فارغة)
//   final _dailyCashController = TextEditingController();
//   final _dailyNetworkController = TextEditingController();

//   // 2. الخزنة
//   final _safeCashController = TextEditingController();
//   final _safeNetworkController = TextEditingController();

//   // 3. ذهب كسر
//   final _scrap24Controller = TextEditingController();
//   final _scrap22Controller = TextEditingController();
//   final _scrap21Controller = TextEditingController();
//   final _scrap18Controller = TextEditingController();
//   final _scrap14Controller = TextEditingController();

//   // 4. ذهب مشغول
//   final _worked24Controller = TextEditingController();
//   final _worked22Controller = TextEditingController();
//   final _worked21Controller = TextEditingController();
//   final _worked18Controller = TextEditingController();
//   final _worked14Controller = TextEditingController();

//   // 5. عهدة الكسر
//   final _custodyCashController = TextEditingController();
//   final _custodyNetworkController = TextEditingController();

//   // 6. كسر بالمخزن (إضافة جديدة)
//   List<Map<String, dynamic>> scrapInStorage = [];
//   final _storageWeightController = TextEditingController();
//   String _storageCarat = '21';

//   // 7. المخزون (إضافة جديدة)
//   List<Map<String, dynamic>> inventory = [];
//   final _invValueController = TextEditingController();
//   final _invWeightController = TextEditingController();
//   String _invCarat = '18';

//   // 8. الشركاء
//   List<Map<String, dynamic>> partners = [];
//   final _partnerNameController = TextEditingController();
//   final _partnerAmountController = TextEditingController();

//   static const Color goldColor = Color(0xFFD4AF37);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'إضافة رصيد افتتاحى',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: goldColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // 1. صندوق اليومي
//                 _buildSectionCard(
//                   icon: Icons.business_center,
//                   title: 'صندوق اليومي',
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _dailyCashController,
//                           label: 'كاش',
//                           icon: Icons.money,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _dailyNetworkController,
//                           label: 'شبكة',
//                           icon: Icons.wifi,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 2. الخزنة
//                 _buildSectionCard(
//                   icon: Icons.lock,
//                   title: 'الخزنة',
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _safeCashController,
//                           label: 'كاش',
//                           icon: Icons.money,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _safeNetworkController,
//                           label: 'شبكة',
//                           icon: Icons.wifi,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 3. ذهب كسر
//                 _buildSectionCard(
//                   icon: Icons.crisis_alert,
//                   title: 'ذهب كسر',
//                   child: _buildCaratRow(
//                     controllers: {
//                       '24': _scrap24Controller,
//                       '22': _scrap22Controller,
//                       '21': _scrap21Controller,
//                       '18': _scrap18Controller,
//                       '14': _scrap14Controller,
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 4. ذهب مشغول
//                 _buildSectionCard(
//                   icon: Icons.work,
//                   title: 'ذهب مشغول',
//                   child: _buildCaratRow(
//                     controllers: {
//                       '24': _worked24Controller,
//                       '22': _worked22Controller,
//                       '21': _worked21Controller,
//                       '18': _worked18Controller,
//                       '14': _worked14Controller,
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 5. عهدة الكسر
//                 _buildSectionCard(
//                   icon: Icons.account_balance_wallet,
//                   title: 'عهدة الكسر',
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _custodyCashController,
//                           label: 'كاش',
//                           icon: Icons.money,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _buildInputField(
//                           controller: _custodyNetworkController,
//                           label: 'شبكة',
//                           icon: Icons.wifi,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 6. كسر بالمخزن
//                 _buildSectionCard(
//                   icon: Icons.storage,
//                   title: 'كسر بالمخزن (إضافة جديدة)',
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: _buildDropdownField(
//                               value: _storageCarat,
//                               items: const ['24', '22', '21', '18', '14'],
//                               onChanged: (v) =>
//                                   setState(() => _storageCarat = v!),
//                               label: 'العيار',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             flex: 2,
//                             child: _buildInputField(
//                               controller: _storageWeightController,
//                               label: 'وزن (جم)',
//                               icon: Icons.scale,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               if (_storageWeightController.text.isNotEmpty) {
//                                 setState(() {
//                                   scrapInStorage.add({
//                                     'weight': double.parse(
//                                         _storageWeightController.text),
//                                     'carat': _storageCarat,
//                                   });
//                                   _storageWeightController.clear();
//                                 });
//                               }
//                             },
//                             icon: Icon(Icons.add_circle,
//                                 color: goldColor, size: 32),
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                           ),
//                         ],
//                       ),
//                       if (scrapInStorage.isNotEmpty) ...[
//                         const SizedBox(height: 10),
//                         ...scrapInStorage.map((item) => _buildListItem(
//                               text:
//                                   'وزن: ${item['weight']} جم - عيار: ${item['carat']}',
//                               onDelete: () =>
//                                   setState(() => scrapInStorage.remove(item)),
//                             )),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 7. المخزون
//                 _buildSectionCard(
//                   icon: Icons.inventory,
//                   title: 'المخزون (إضافة جديدة)',
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: _buildDropdownField(
//                               value: _invCarat,
//                               items: const ['24', '22', '21', '18', '14'],
//                               onChanged: (v) => setState(() => _invCarat = v!),
//                               label: 'العيار',
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             flex: 2,
//                             child: _buildInputField(
//                               controller: _invWeightController,
//                               label: 'وزن (جم)',
//                               icon: Icons.scale,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             flex: 2,
//                             child: _buildInputField(
//                               controller: _invValueController,
//                               label: 'القيمة',
//                               icon: Icons.attach_money,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               if (_invValueController.text.isNotEmpty &&
//                                   _invWeightController.text.isNotEmpty) {
//                                 setState(() {
//                                   inventory.add({
//                                     'value':
//                                         double.parse(_invValueController.text),
//                                     'weight':
//                                         double.parse(_invWeightController.text),
//                                     'carat': _invCarat,
//                                   });
//                                   _invValueController.clear();
//                                   _invWeightController.clear();
//                                 });
//                               }
//                             },
//                             icon: Icon(Icons.add_circle,
//                                 color: goldColor, size: 32),
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                           ),
//                         ],
//                       ),
//                       if (inventory.isNotEmpty) ...[
//                         const SizedBox(height: 10),
//                         ...inventory.map((item) => _buildListItem(
//                               text:
//                                   'عيار: ${item['carat']} - وزن: ${item['weight']} جم - قيمة: ${item['value']}',
//                               onDelete: () =>
//                                   setState(() => inventory.remove(item)),
//                             )),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // 8. الشركاء
//                 _buildSectionCard(
//                   icon: Icons.people,
//                   title: 'إضافة شركاء جدد (بعيار 24)',
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: _buildInputField(
//                               controller: _partnerNameController,
//                               label: 'اسم الشريك',
//                               icon: Icons.person,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             flex: 2,
//                             child: _buildInputField(
//                               controller: _partnerAmountController,
//                               label: 'الوزن (جم)',
//                               icon: Icons.money,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               if (_partnerNameController.text.isNotEmpty &&
//                                   _partnerAmountController.text.isNotEmpty) {
//                                 setState(() {
//                                   partners.add({
//                                     'name': _partnerNameController.text,
//                                     'amount': double.parse(
//                                         _partnerAmountController.text),
//                                   });
//                                   _partnerNameController.clear();
//                                   _partnerAmountController.clear();
//                                 });
//                               }
//                             },
//                             icon: Icon(Icons.add_circle,
//                                 color: goldColor, size: 32),
//                             padding: EdgeInsets.zero,
//                             constraints: const BoxConstraints(),
//                           ),
//                         ],
//                       ),
//                       if (partners.isNotEmpty) ...[
//                         const SizedBox(height: 10),
//                         ...partners.map((item) => _buildListItem(
//                               text:
//                                   '${item['name']} - ${item['amount']} جم عيار 24',
//                               onDelete: () =>
//                                   setState(() => partners.remove(item)),
//                             )),
//                       ],
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // زر الحفظ
//                 SizedBox(
//                   width: double.infinity,
//                   height: 56,
//                   child: ElevatedButton.icon(
//                     onPressed: _isSaving ? null : _saveAllData,
//                     icon: _isSaving
//                         ? const SizedBox(
//                             width: 24,
//                             height: 24,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Icon(Icons.save, color: Colors.white),
//                     label: Text(
//                       _isSaving ? 'جاري الحفظ...' : 'حفظ الإضافة',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: goldColor,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 دوال بناء الواجهة (محسّنة)
//   // ============================================================

//   Widget _buildSectionCard({
//     required IconData icon,
//     required String title,
//     required Widget child,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: goldColor.withOpacity(0.2), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
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
//             const SizedBox(height: 12),
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   // حقل إدخال نصي (يبدأ فارغاً)
//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(fontSize: 12),
//         prefixIcon: Icon(icon, color: goldColor, size: 18),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: goldColor, width: 2),
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         isDense: true,
//       ),
//     );
//   }

//   // حقل اختيار منسدل
//   Widget _buildDropdownField({
//     required String value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     required String label,
//   }) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       isExpanded: true,
//       items: items.map((c) {
//         return DropdownMenuItem(
//           value: c,
//           child: Text(
//             'عيار $c',
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(fontSize: 12),
//           ),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(fontSize: 12),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           borderSide: BorderSide(color: goldColor, width: 2),
//         ),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
//         isDense: true,
//       ),
//     );
//   }

//   // صف عيارات ذهب (5 حقول موزعة بالتساوي)
//   Widget _buildCaratRow({
//     required Map<String, TextEditingController> controllers,
//   }) {
//     return Row(
//       children: controllers.entries.map((entry) {
//         return Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2),
//             child: TextFormField(
//               controller: entry.value,
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               decoration: InputDecoration(
//                 labelText: 'عيار ${entry.key}',
//                 labelStyle: const TextStyle(fontSize: 10),
//                 border: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8)),
//                   borderSide: BorderSide(color: goldColor, width: 2),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 8),
//                 isDense: true,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   // عنصر قائمة قابل للحذف
//   Widget _buildListItem({
//     required String text,
//     required VoidCallback onDelete,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.circle, color: goldColor.withOpacity(0.5), size: 6),
//           const SizedBox(width: 6),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 12),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
//             onPressed: onDelete,
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // 🔹 دوال المنطق (مع معالجة القيم الفارغة)
//   // ============================================================

//   Future<void> _saveAllData() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isSaving = true);

//     try {
//       await FS.saveOpeningBalance(
//         dailyCashBoxCash: double.tryParse(_dailyCashController.text) ?? 0,
//         dailyCashBoxNetwork: double.tryParse(_dailyNetworkController.text) ?? 0,
//         safeCash: double.tryParse(_safeCashController.text) ?? 0,
//         safeNetwork: double.tryParse(_safeNetworkController.text) ?? 0,
//         scrapGoldByCarat: {
//           '24': double.tryParse(_scrap24Controller.text) ?? 0,
//           '22': double.tryParse(_scrap22Controller.text) ?? 0,
//           '21': double.tryParse(_scrap21Controller.text) ?? 0,
//           '18': double.tryParse(_scrap18Controller.text) ?? 0,
//           '14': double.tryParse(_scrap14Controller.text) ?? 0,
//         },
//         workedGoldByCarat: {
//           '24': double.tryParse(_worked24Controller.text) ?? 0,
//           '22': double.tryParse(_worked22Controller.text) ?? 0,
//           '21': double.tryParse(_worked21Controller.text) ?? 0,
//           '18': double.tryParse(_worked18Controller.text) ?? 0,
//           '14': double.tryParse(_worked14Controller.text) ?? 0,
//         },
//         scrapCustodyCash: double.tryParse(_custodyCashController.text) ?? 0,
//         scrapCustodyNetwork:
//             double.tryParse(_custodyNetworkController.text) ?? 0,
//         scrapInStorage: scrapInStorage,
//         inventory: inventory,
//       );

//       for (var p in partners) {
//         await FS.addPartnerOpeningCapital(
//           partnerName: p['name'],
//           amountCarat24: p['amount'],
//         );
//       }

//       _clearFields();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ تمت الإضافة بنجاح!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ خطأ: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(12)),
//           ),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   void _clearFields() {
//     // إعادة تعيين جميع الحقول إلى فارغة
//     _dailyCashController.text = '';
//     _dailyNetworkController.text = '';
//     _safeCashController.text = '';
//     _safeNetworkController.text = '';
//     _scrap24Controller.text = '';
//     _scrap22Controller.text = '';
//     _scrap21Controller.text = '';
//     _scrap18Controller.text = '';
//     _scrap14Controller.text = '';
//     _worked24Controller.text = '';
//     _worked22Controller.text = '';
//     _worked21Controller.text = '';
//     _worked18Controller.text = '';
//     _worked14Controller.text = '';
//     _custodyCashController.text = '';
//     _custodyNetworkController.text = '';
//     setState(() {
//       scrapInStorage.clear();
//       inventory.clear();
//       partners.clear();
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:uhf_gold_shop/services/firestore_service.dart';

class OpeningBalanceEntryPage extends StatefulWidget {
  const OpeningBalanceEntryPage({super.key});

  @override
  State<OpeningBalanceEntryPage> createState() =>
      _OpeningBalanceEntryPageState();
}

class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // ------------------- الأقسام الثابتة -------------------
  final _dailyCashController = TextEditingController();
  final _dailyNetworkController = TextEditingController();
  final _safeCashController = TextEditingController();
  final _safeNetworkController = TextEditingController();
  final _scrap24Controller = TextEditingController();
  final _scrap22Controller = TextEditingController();
  final _scrap21Controller = TextEditingController();
  final _scrap18Controller = TextEditingController();
  final _scrap14Controller = TextEditingController();
  final _worked24Controller = TextEditingController();
  final _worked22Controller = TextEditingController();
  final _worked21Controller = TextEditingController();
  final _worked18Controller = TextEditingController();
  final _worked14Controller = TextEditingController();
  final _custodyCashController = TextEditingController();
  final _custodyNetworkController = TextEditingController();

  // ------------------- الأقسام الديناميكية -------------------
  List<Map<String, dynamic>> storageItems = [];
  List<Map<String, dynamic>> inventoryItems = [];
  List<Map<String, dynamic>> partnerItems = [];

  static const Color goldColor = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    // إضافة صف فارغ لكل قسم عند بدء الصفحة
    _addStorageRow();
    _addInventoryRow();
    _addPartnerRow();
  }

  // دوال إضافة صفوف جديدة
  void _addStorageRow() {
    setState(() {
      storageItems.add({
        'carat': '21',
        'weight': '',
      });
    });
  }

  void _addInventoryRow() {
    setState(() {
      inventoryItems.add({
        'carat': '18',
        'weight': '',
        'value': '',
      });
    });
  }

  void _addPartnerRow() {
    setState(() {
      partnerItems.add({
        'name': '',
        'amount': '',
      });
    });
  }

  // دوال حذف صف (مع ترك صف واحد على الأقل)
  void _removeStorageRow(int index) {
    if (storageItems.length > 1) {
      setState(() {
        storageItems.removeAt(index);
      });
    } else {
      // يمكن إفراغ الحقول بدلاً من الحذف
      setState(() {
        storageItems[index]['weight'] = '';
        storageItems[index]['carat'] = '21';
      });
    }
  }

  void _removeInventoryRow(int index) {
    if (inventoryItems.length > 1) {
      setState(() {
        inventoryItems.removeAt(index);
      });
    } else {
      setState(() {
        inventoryItems[index]['weight'] = '';
        inventoryItems[index]['value'] = '';
        inventoryItems[index]['carat'] = '18';
      });
    }
  }

  void _removePartnerRow(int index) {
    if (partnerItems.length > 1) {
      setState(() {
        partnerItems.removeAt(index);
      });
    } else {
      setState(() {
        partnerItems[index]['name'] = '';
        partnerItems[index]['amount'] = '';
      });
    }
  }

  @override
  void dispose() {
    // تحرير الـ Controllers الثابتة
    _dailyCashController.dispose();
    _dailyNetworkController.dispose();
    _safeCashController.dispose();
    _safeNetworkController.dispose();
    _scrap24Controller.dispose();
    _scrap22Controller.dispose();
    _scrap21Controller.dispose();
    _scrap18Controller.dispose();
    _scrap14Controller.dispose();
    _worked24Controller.dispose();
    _worked22Controller.dispose();
    _worked21Controller.dispose();
    _worked18Controller.dispose();
    _worked14Controller.dispose();
    _custodyCashController.dispose();
    _custodyNetworkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'إضافة رصيد افتتاحى',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: goldColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 1. صندوق اليومي
                _buildSectionCard(
                  icon: Icons.business_center,
                  title: 'صندوق اليومي',
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _dailyCashController,
                          label: 'كاش',
                          icon: Icons.money,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _dailyNetworkController,
                          label: 'شبكة',
                          icon: Icons.wifi,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. الخزنة
                _buildSectionCard(
                  icon: Icons.lock,
                  title: 'الخزنة',
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _safeCashController,
                          label: 'كاش',
                          icon: Icons.money,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _safeNetworkController,
                          label: 'شبكة',
                          icon: Icons.wifi,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3. ذهب كسر
                _buildSectionCard(
                  icon: Icons.crisis_alert,
                  title: 'ذهب كسر',
                  child: _buildCaratRow(
                    controllers: {
                      '24': _scrap24Controller,
                      '22': _scrap22Controller,
                      '21': _scrap21Controller,
                      '18': _scrap18Controller,
                      '14': _scrap14Controller,
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // 4. ذهب مشغول
                _buildSectionCard(
                  icon: Icons.work,
                  title: 'ذهب مشغول',
                  child: _buildCaratRow(
                    controllers: {
                      '24': _worked24Controller,
                      '22': _worked22Controller,
                      '21': _worked21Controller,
                      '18': _worked18Controller,
                      '14': _worked14Controller,
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // 5. عهدة الكسر
                _buildSectionCard(
                  icon: Icons.account_balance_wallet,
                  title: 'عهدة الكسر',
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _custodyCashController,
                          label: 'كاش',
                          icon: Icons.money,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _custodyNetworkController,
                          label: 'شبكة',
                          icon: Icons.wifi,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ========== 6. كسر بالمخزن (صفوف متعددة) ==========
                _buildDynamicStorageSection(),
                const SizedBox(height: 12),

                // ========== 7. المخزون (صفوف متعددة) ==========
                _buildDynamicInventorySection(),
                const SizedBox(height: 12),

                // ========== 8. الشركاء (صفوف متعددة) ==========
                _buildDynamicPartnerSection(),
                const SizedBox(height: 24),

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveAllData,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      _isSaving ? 'جاري الحفظ...' : 'حفظ الإضافة',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔹 دوال بناء الواجهة
  // ============================================================

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
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
      ),
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
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // حقل إدخال مع Controller (للأقسام الثابتة)
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: goldColor, size: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: goldColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        isDense: true,
      ),
    );
  }

  // حقل إدخال ديناميكي بدون Controller (يستخدم onChanged)
  Widget _buildDynamicInputField({
    required String initialValue,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        prefixIcon: Icon(icon, color: goldColor, size: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: goldColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        isDense: true,
      ),
    );
  }

  // حقل اختيار منسدل
  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      items: items.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text(
            'عيار $c',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: goldColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        isDense: true,
      ),
    );
  }

  Widget _buildCaratRow({
    required Map<String, TextEditingController> controllers,
  }) {
    return Row(
      children: controllers.entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: TextFormField(
              controller: entry.value,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: 'عيار ${entry.key}',
                labelStyle: const TextStyle(fontSize: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: goldColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==================== الأقسام الديناميكية ====================

  Widget _buildDynamicStorageSection() {
    return _buildSectionCard(
      icon: Icons.storage,
      title: 'كسر بالمخزن (إضافة جديدة)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...storageItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdownField(
                      value: item['carat'] ?? '21',
                      items: const ['24', '22', '21', '18', '14'],
                      onChanged: (v) {
                        setState(() {
                          storageItems[index]['carat'] = v!;
                        });
                      },
                      label: 'العيار',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildDynamicInputField(
                      initialValue: item['weight'] ?? '',
                      label: 'وزن (جم)',
                      icon: Icons.scale,
                      onChanged: (value) {
                        storageItems[index]['weight'] = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 24),
                    onPressed: () => _removeStorageRow(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _addStorageRow,
              icon: Icon(Icons.add_circle, color: goldColor, size: 32),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إضافة صف جديد',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicInventorySection() {
    return _buildSectionCard(
      icon: Icons.inventory,
      title: 'المخزون (إضافة جديدة)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...inventoryItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDropdownField(
                      value: item['carat'] ?? '18',
                      items: const ['24', '22', '21', '18', '14'],
                      onChanged: (v) {
                        setState(() {
                          inventoryItems[index]['carat'] = v!;
                        });
                      },
                      label: 'العيار',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildDynamicInputField(
                      initialValue: item['weight'] ?? '',
                      label: 'وزن (جم)',
                      icon: Icons.scale,
                      onChanged: (value) {
                        inventoryItems[index]['weight'] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildDynamicInputField(
                      initialValue: item['value'] ?? '',
                      label: 'القيمة',
                      icon: Icons.attach_money,
                      onChanged: (value) {
                        inventoryItems[index]['value'] = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 24),
                    onPressed: () => _removeInventoryRow(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _addInventoryRow,
              icon: Icon(Icons.add_circle, color: goldColor, size: 32),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إضافة صف جديد',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicPartnerSection() {
    return _buildSectionCard(
      icon: Icons.people,
      title: 'إضافة شركاء جدد (بعيار 24)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...partnerItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildDynamicInputField(
                      initialValue: item['name'] ?? '',
                      label: 'اسم الشريك',
                      icon: Icons.person,
                      onChanged: (value) {
                        partnerItems[index]['name'] = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildDynamicInputField(
                      initialValue: item['amount'] ?? '',
                      label: 'الوزن (جم)',
                      icon: Icons.money,
                      onChanged: (value) {
                        partnerItems[index]['amount'] = value;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 24),
                    onPressed: () => _removePartnerRow(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: _addPartnerRow,
              icon: Icon(Icons.add_circle, color: goldColor, size: 32),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إضافة صف جديد',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔹 منطق الحفظ
  // ============================================================

  Future<void> _saveAllData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      // تصفية الصفوف الفارغة
      List<Map<String, dynamic>> scrapInStorage = storageItems
          .where((item) =>
              item['weight'] != null && item['weight']!.toString().isNotEmpty)
          .map((item) => {
                'weight': double.parse(item['weight']!),
                'carat': item['carat'],
              })
          .toList();

      List<Map<String, dynamic>> inventory = inventoryItems
          .where((item) =>
              item['weight'] != null &&
              item['weight']!.toString().isNotEmpty &&
              item['value'] != null &&
              item['value']!.toString().isNotEmpty)
          .map((item) => {
                'weight': double.parse(item['weight']!),
                'value': double.parse(item['value']!),
                'carat': item['carat'],
              })
          .toList();

      List<Map<String, dynamic>> partners = partnerItems
          .where((item) =>
              item['name'] != null &&
              item['name']!.toString().isNotEmpty &&
              item['amount'] != null &&
              item['amount']!.toString().isNotEmpty)
          .map((item) => {
                'name': item['name']!,
                'amount': double.parse(item['amount']!),
              })
          .toList();

      await FS.saveOpeningBalance(
        dailyCashBoxCash: double.tryParse(_dailyCashController.text) ?? 0,
        dailyCashBoxNetwork: double.tryParse(_dailyNetworkController.text) ?? 0,
        safeCash: double.tryParse(_safeCashController.text) ?? 0,
        safeNetwork: double.tryParse(_safeNetworkController.text) ?? 0,
        scrapGoldByCarat: {
          '24': double.tryParse(_scrap24Controller.text) ?? 0,
          '22': double.tryParse(_scrap22Controller.text) ?? 0,
          '21': double.tryParse(_scrap21Controller.text) ?? 0,
          '18': double.tryParse(_scrap18Controller.text) ?? 0,
          '14': double.tryParse(_scrap14Controller.text) ?? 0,
        },
        workedGoldByCarat: {
          '24': double.tryParse(_worked24Controller.text) ?? 0,
          '22': double.tryParse(_worked22Controller.text) ?? 0,
          '21': double.tryParse(_worked21Controller.text) ?? 0,
          '18': double.tryParse(_worked18Controller.text) ?? 0,
          '14': double.tryParse(_worked14Controller.text) ?? 0,
        },
        scrapCustodyCash: double.tryParse(_custodyCashController.text) ?? 0,
        scrapCustodyNetwork:
            double.tryParse(_custodyNetworkController.text) ?? 0,
        scrapInStorage: scrapInStorage,
        inventory: inventory,
      );

      for (var p in partners) {
        await FS.addPartnerOpeningCapital(
          partnerName: p['name'],
          amountCarat24: p['amount'],
        );
      }

      _clearFields();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تمت الإضافة بنجاح!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ خطأ: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _clearFields() {
    // تفريغ الحقول الثابتة
    _dailyCashController.text = '';
    _dailyNetworkController.text = '';
    _safeCashController.text = '';
    _safeNetworkController.text = '';
    _scrap24Controller.text = '';
    _scrap22Controller.text = '';
    _scrap21Controller.text = '';
    _scrap18Controller.text = '';
    _scrap14Controller.text = '';
    _worked24Controller.text = '';
    _worked22Controller.text = '';
    _worked21Controller.text = '';
    _worked18Controller.text = '';
    _worked14Controller.text = '';
    _custodyCashController.text = '';
    _custodyNetworkController.text = '';

    // إعادة تعيين الصفوف بحيث يبقى صف فارغ واحد لكل قسم
    setState(() {
      storageItems.clear();
      inventoryItems.clear();
      partnerItems.clear();
      _addStorageRow();
      _addInventoryRow();
      _addPartnerRow();
    });
  }
}
