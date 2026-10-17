// import 'package:flutter/material.dart';
// import 'package:uhf_gold_shop/services/firestore_service.dart';

// class OpeningBalanceEntryPage extends StatefulWidget {
//   const OpeningBalanceEntryPage({super.key});

//   @override
//   State<OpeningBalanceEntryPage> createState() =>
//       _OpeningBalanceEntryPageState();
// }

// class _OpeningBalanceEntryPageState extends State<OpeningBalanceEntryPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isSaving = false;

//   // ==================== 1) رصيد الكاش ====================
//   final _cashController = TextEditingController();

//   // ==================== 2) رصيد الشبكة ====================
//   final _networkController = TextEditingController();

//   // ==================== 3) الذهب المشغول (ديناميكي) ====================
//   final List<_CaratRow> _workedRows = [];

//   // ==================== 4) الكسر - الوزن (ديناميكي) ====================
//   final List<_CaratRow> _scrapRows = [];

//   static const Color goldColor = Color(0xFFD4AF37);

//   @override
//   void initState() {
//     super.initState();
//     // ✅ صف واحد فقط في البداية لكل قسم
//     _addWorkedRow();
//     _addScrapRow();
//   }

//   // ============ المشغول ============
//   void _addWorkedRow() {
//     setState(() {
//       _workedRows.add(_CaratRow());
//     });
//   }

//   void _removeWorkedRow(int index) {
//     if (_workedRows.length <= 1) {
//       // لو صف واحد فقط، نفرغه بدل الحذف
//       setState(() {
//         _workedRows[index].weightController.clear();
//         _workedRows[index].carat = '21';
//       });
//       return;
//     }
//     setState(() {
//       _workedRows[index].dispose();
//       _workedRows.removeAt(index);
//     });
//   }

//   // ============ الكسر ============
//   void _addScrapRow() {
//     setState(() {
//       _scrapRows.add(_CaratRow());
//     });
//   }

//   void _removeScrapRow(int index) {
//     if (_scrapRows.length <= 1) {
//       setState(() {
//         _scrapRows[index].weightController.clear();
//         _scrapRows[index].carat = '21';
//       });
//       return;
//     }
//     setState(() {
//       _scrapRows[index].dispose();
//       _scrapRows.removeAt(index);
//     });
//   }

//   @override
//   void dispose() {
//     _cashController.dispose();
//     _networkController.dispose();
//     for (var r in _workedRows) {
//       r.dispose();
//     }
//     for (var r in _scrapRows) {
//       r.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text(
//           'إضافة رصيد افتتاحي',
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
//                 // ============ 1) رصيد الكاش ============
//                 _buildSectionCard(
//                   icon: Icons.money,
//                   title: 'رصيد الكاش',
//                   child: _buildInputField(
//                     controller: _cashController,
//                     label: 'الكاش (ر.س)',
//                     icon: Icons.payments,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // ============ 2) رصيد الشبكة ============
//                 _buildSectionCard(
//                   icon: Icons.wifi,
//                   title: 'رصيد الشبكة',
//                   child: _buildInputField(
//                     controller: _networkController,
//                     label: 'الشبكة (ر.س)',
//                     icon: Icons.credit_card,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // ============ 3) الذهب المشغول ============
//                 _buildDynamicSection(
//                   icon: Icons.work,
//                   title: 'الذهب المشغول',
//                   rows: _workedRows,
//                   onAdd: _addWorkedRow,
//                   onRemove: _removeWorkedRow,
//                 ),
//                 const SizedBox(height: 12),

//                 // ============ 4) الكسر (الوزن) ============
//                 _buildDynamicSection(
//                   icon: Icons.crisis_alert,
//                   title: 'الكسر (الوزن)',
//                   rows: _scrapRows,
//                   onAdd: _addScrapRow,
//                   onRemove: _removeScrapRow,
//                 ),
//                 const SizedBox(height: 24),

//                 // ============ زر الحفظ ============
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
//   // 🔹 بناء الأقسام
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

//   // ============ القسم الديناميكي ============
//   Widget _buildDynamicSection({
//     required IconData icon,
//     required String title,
//     required List<_CaratRow> rows,
//     required VoidCallback onAdd,
//     required void Function(int) onRemove,
//   }) {
//     return _buildSectionCard(
//       icon: icon,
//       title: title,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ✅ عرض الصفوف الموجودة
//           ...rows.asMap().entries.map((entry) {
//             final index = entry.key;
//             final row = entry.value;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: Row(
//                 children: [
//                   // اختيار العيار
//                   Expanded(
//                     flex: 2,
//                     child: _buildDropdownField(
//                       value: row.carat,
//                       items: const ['24', '22', '21', '18', '14'],
//                       onChanged: (v) {
//                         setState(() => row.carat = v!);
//                       },
//                       label: 'العيار',
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // حقل الوزن
//                   Expanded(
//                     flex: 3,
//                     child: _buildInputField(
//                       controller: row.weightController,
//                       label: 'الوزن (جم)',
//                       icon: Icons.scale,
//                     ),
//                   ),
//                   // زر الحذف
//                   IconButton(
//                     icon: const Icon(
//                       Icons.delete_outline,
//                       color: Colors.red,
//                       size: 24,
//                     ),
//                     onPressed: () => onRemove(index),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             );
//           }),
//           // ✅ زر الإضافة +
//           Align(
//             alignment: Alignment.centerLeft,
//             child: IconButton(
//               onPressed: onAdd,
//               icon: Icon(Icons.add_circle, color: goldColor, size: 32),
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               tooltip: 'إضافة صف جديد',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

//   // ============================================================
//   // 🔹 منطق الحفظ
//   // ============================================================

//   Future<void> _saveAllData() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isSaving = true);

//     try {
//       final cashValue = double.tryParse(_cashController.text) ?? 0;
//       final networkValue = double.tryParse(_networkController.text) ?? 0;

//       // تجميع أوزان المشغول حسب العيار
//       final workedByCarat = <String, double>{
//         '24': 0,
//         '22': 0,
//         '21': 0,
//         '18': 0,
//         '14': 0,
//       };
//       for (var row in _workedRows) {
//         final w = double.tryParse(row.weightController.text) ?? 0;
//         if (workedByCarat.containsKey(row.carat)) {
//           workedByCarat[row.carat] = workedByCarat[row.carat]! + w;
//         }
//       }

//       // تجميع أوزان الكسر حسب العيار
//       final scrapByCarat = <String, double>{
//         '24': 0,
//         '22': 0,
//         '21': 0,
//         '18': 0,
//         '14': 0,
//       };
//       for (var row in _scrapRows) {
//         final w = double.tryParse(row.weightController.text) ?? 0;
//         if (scrapByCarat.containsKey(row.carat)) {
//           scrapByCarat[row.carat] = scrapByCarat[row.carat]! + w;
//         }
//       }

//       await FS.saveOpeningBalance(
//         dailyCashBoxCash: cashValue,
//         dailyCashBoxNetwork: networkValue,
//         safeCash: 0,
//         safeNetwork: 0,
//         scrapGoldByCarat: scrapByCarat,
//         workedGoldByCarat: workedByCarat,
//         scrapCustodyCash: 0,
//         scrapCustodyNetwork: 0,
//         scrapInStorage: const [],
//         inventory: const [],
//       );

//       _clearFields();

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('✅ تمت الإضافة بنجاح!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ خطأ: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//       );
//     } finally {
//       if (mounted) setState(() => _isSaving = false);
//     }
//   }

//   void _clearFields() {
//     _cashController.clear();
//     _networkController.clear();

//     setState(() {
//       // تفريغ وإعادة تعيين صفوف المشغول
//       for (var r in _workedRows) {
//         r.dispose();
//       }
//       _workedRows.clear();

//       // تفريغ وإعادة تعيين صفوف الكسر
//       for (var r in _scrapRows) {
//         r.dispose();
//       }
//       _scrapRows.clear();

//       // صف واحد افتراضي لكل قسم
//       _addWorkedRow();
//       _addScrapRow();
//     });
//   }
// }

// // ============================================================
// // 🔹 موديل صف العيار
// // ============================================================
// class _CaratRow {
//   String carat;
//   final TextEditingController weightController;

//   _CaratRow({this.carat = '21'}) : weightController = TextEditingController();

//   void dispose() {
//     weightController.dispose();
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

  // ==================== 1) رصيد الكاش ====================
  final _cashController = TextEditingController();

  // ==================== 2) رصيد الشبكة ====================
  final _networkController = TextEditingController();

  // ==================== 3) رصيد الخزنة ====================
  final _safeCashController = TextEditingController();
  final _safeNetworkController = TextEditingController();

  // ==================== 4) الذهب المشغول (ديناميكي) ====================
  final List<_CaratRow> _workedRows = [];

  // ==================== 5) الكسر - الوزن (ديناميكي) ====================
  final List<_CaratRow> _scrapRows = [];

  // ==================== 6) القروض على المحل (ديناميكي) ====================
  final List<_LoanRow> _loanRows = [];

  static const Color goldColor = Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    // ✅ صف واحد فقط في البداية لكل قسم
    _addWorkedRow();
    _addScrapRow();
    _addLoanRow();
  }

  // ============ المشغول ============
  void _addWorkedRow() {
    setState(() {
      _workedRows.add(_CaratRow());
    });
  }

  void _removeWorkedRow(int index) {
    if (_workedRows.length <= 1) {
      setState(() {
        _workedRows[index].weightController.clear();
        _workedRows[index].carat = '21';
      });
      return;
    }
    setState(() {
      _workedRows[index].dispose();
      _workedRows.removeAt(index);
    });
  }

  // ============ الكسر ============
  void _addScrapRow() {
    setState(() {
      _scrapRows.add(_CaratRow());
    });
  }

  void _removeScrapRow(int index) {
    if (_scrapRows.length <= 1) {
      setState(() {
        _scrapRows[index].weightController.clear();
        _scrapRows[index].carat = '21';
      });
      return;
    }
    setState(() {
      _scrapRows[index].dispose();
      _scrapRows.removeAt(index);
    });
  }

  // ============ القروض ============
  void _addLoanRow() {
    setState(() {
      _loanRows.add(_LoanRow());
    });
  }

  void _removeLoanRow(int index) {
    if (_loanRows.length <= 1) {
      setState(() {
        _loanRows[index].nameController.clear();
        _loanRows[index].amountController.clear();
      });
      return;
    }
    setState(() {
      _loanRows[index].dispose();
      _loanRows.removeAt(index);
    });
  }

  @override
  void dispose() {
    _cashController.dispose();
    _networkController.dispose();
    _safeCashController.dispose();
    _safeNetworkController.dispose();
    for (var r in _workedRows) {
      r.dispose();
    }
    for (var r in _scrapRows) {
      r.dispose();
    }
    for (var r in _loanRows) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'إضافة رصيد افتتاحي',
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
                // ============ 1) رصيد الكاش ============
                _buildSectionCard(
                  icon: Icons.money,
                  title: 'رصيد الكاش',
                  child: _buildInputField(
                    controller: _cashController,
                    label: 'الكاش (ر.س)',
                    icon: Icons.payments,
                  ),
                ),
                const SizedBox(height: 12),

                // ============ 2) رصيد الشبكة ============
                _buildSectionCard(
                  icon: Icons.wifi,
                  title: 'رصيد الشبكة',
                  child: _buildInputField(
                    controller: _networkController,
                    label: 'الشبكة (ر.س)',
                    icon: Icons.credit_card,
                  ),
                ),
                const SizedBox(height: 12),

                // ============ 3) رصيد الخزنة ============
                _buildSectionCard(
                  icon: Icons.account_balance_wallet,
                  title: 'رصيد الخزنة',
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _safeCashController,
                          label: 'الخزنة كاش (ر.س)',
                          icon: Icons.payments,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInputField(
                          controller: _safeNetworkController,
                          label: 'الخزنة شبكة (ر.س)',
                          icon: Icons.credit_card,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ============ 4) الذهب المشغول ============
                _buildDynamicSection(
                  icon: Icons.work,
                  title: 'الذهب المشغول',
                  rows: _workedRows,
                  onAdd: _addWorkedRow,
                  onRemove: _removeWorkedRow,
                ),
                const SizedBox(height: 12),

                // ============ 5) الكسر (الوزن) ============
                _buildDynamicSection(
                  icon: Icons.crisis_alert,
                  title: 'الكسر (الوزن)',
                  rows: _scrapRows,
                  onAdd: _addScrapRow,
                  onRemove: _removeScrapRow,
                ),
                const SizedBox(height: 12),

                // ============ 6) القروض على المحل ============
                _buildLoanSection(),
                const SizedBox(height: 24),

                // ============ زر الحفظ ============
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
  // 🔹 بناء الأقسام
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

  // ============ القسم الديناميكي (للذهب) ============
  Widget _buildDynamicSection({
    required IconData icon,
    required String title,
    required List<_CaratRow> rows,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
  }) {
    return _buildSectionCard(
      icon: icon,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ عرض الصفوف الموجودة
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // اختيار العيار
                  Expanded(
                    flex: 2,
                    child: _buildDropdownField(
                      value: row.carat,
                      items: const ['24', '22', '21', '18', '14'],
                      onChanged: (v) {
                        setState(() => row.carat = v!);
                      },
                      label: 'العيار',
                    ),
                  ),
                  const SizedBox(width: 8),
                  // حقل الوزن
                  Expanded(
                    flex: 3,
                    child: _buildInputField(
                      controller: row.weightController,
                      label: 'الوزن (جم)',
                      icon: Icons.scale,
                    ),
                  ),
                  // زر الحذف
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () => onRemove(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          // ✅ زر الإضافة +
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onAdd,
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

  // ============ قسم القروض ============
  Widget _buildLoanSection() {
    return _buildSectionCard(
      icon: Icons.account_balance,
      title: 'القروض على المحل',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._loanRows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // الجهة / البيان
                  Expanded(
                    flex: 3,
                    child: _buildInputField(
                      controller: row.nameController,
                      label: 'الجهة / البيان',
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // المبلغ
                  Expanded(
                    flex: 2,
                    child: _buildInputField(
                      controller: row.amountController,
                      label: 'المبلغ (ر.س)',
                      icon: Icons.payments,
                    ),
                  ),
                  // زر الحذف
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 24,
                    ),
                    onPressed: () => _removeLoanRow(index),
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
              onPressed: _addLoanRow,
              icon: Icon(Icons.add_circle, color: goldColor, size: 32),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إضافة قرض جديد',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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

  // ============================================================
  // 🔹 منطق الحفظ
  // ============================================================

  Future<void> _saveAllData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final cashValue = double.tryParse(_cashController.text) ?? 0;
      final networkValue = double.tryParse(_networkController.text) ?? 0;

      final safeCashValue = double.tryParse(_safeCashController.text) ?? 0;
      final safeNetworkValue =
          double.tryParse(_safeNetworkController.text) ?? 0;

      // تجميع أوزان المشغول حسب العيار
      final workedByCarat = <String, double>{
        '24': 0,
        '22': 0,
        '21': 0,
        '18': 0,
        '14': 0,
      };
      for (var row in _workedRows) {
        final w = double.tryParse(row.weightController.text) ?? 0;
        if (workedByCarat.containsKey(row.carat)) {
          workedByCarat[row.carat] = workedByCarat[row.carat]! + w;
        }
      }

      // تجميع أوزان الكسر حسب العيار
      final scrapByCarat = <String, double>{
        '24': 0,
        '22': 0,
        '21': 0,
        '18': 0,
        '14': 0,
      };
      for (var row in _scrapRows) {
        final w = double.tryParse(row.weightController.text) ?? 0;
        if (scrapByCarat.containsKey(row.carat)) {
          scrapByCarat[row.carat] = scrapByCarat[row.carat]! + w;
        }
      }

      // تجميع القروض (بس اللي فيها اسم أو مبلغ)
      final loansList = <Map<String, dynamic>>[];
      for (var row in _loanRows) {
        final name = row.nameController.text.trim();
        final amount = double.tryParse(row.amountController.text) ?? 0;
        if (name.isNotEmpty || amount > 0) {
          loansList.add({
            'name': name,
            'amount': amount,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      }

      await FS.saveOpeningBalance(
        dailyCashBoxCash: cashValue,
        dailyCashBoxNetwork: networkValue,
        safeCash: safeCashValue,
        safeNetwork: safeNetworkValue,
        scrapGoldByCarat: scrapByCarat,
        workedGoldByCarat: workedByCarat,
        scrapCustodyCash: 0,
        scrapCustodyNetwork: 0,
        scrapInStorage: const [],
        inventory: const [],
        loans: loansList,
      );

      _clearFields();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ تمت الإضافة بنجاح!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
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
    _cashController.clear();
    _networkController.clear();
    _safeCashController.clear();
    _safeNetworkController.clear();

    setState(() {
      // تفريغ وإعادة تعيين صفوف المشغول
      for (var r in _workedRows) {
        r.dispose();
      }
      _workedRows.clear();

      // تفريغ وإعادة تعيين صفوف الكسر
      for (var r in _scrapRows) {
        r.dispose();
      }
      _scrapRows.clear();

      // تفريغ وإعادة تعيين صفوف القروض
      for (var r in _loanRows) {
        r.dispose();
      }
      _loanRows.clear();

      // صف واحد افتراضي لكل قسم
      _addWorkedRow();
      _addScrapRow();
      _addLoanRow();
    });
  }
}

// ============================================================
// 🔹 موديل صف العيار
// ============================================================
class _CaratRow {
  String carat;
  final TextEditingController weightController;

  _CaratRow({this.carat = '21'}) : weightController = TextEditingController();

  void dispose() {
    weightController.dispose();
  }
}

// ============================================================
// 🔹 موديل صف القرض
// ============================================================
class _LoanRow {
  final TextEditingController nameController;
  final TextEditingController amountController;

  _LoanRow()
      : nameController = TextEditingController(),
        amountController = TextEditingController();

  void dispose() {
    nameController.dispose();
    amountController.dispose();
  }
}
