// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../services/firestore_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ExpensesPage extends StatefulWidget {
//   const ExpensesPage({super.key});

//   @override
//   State<ExpensesPage> createState() => _ExpensesPageState();
// }

// class _ExpensesPageState extends State<ExpensesPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   final _formKey = GlobalKey<FormState>();
//   final _typeController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _noteController = TextEditingController();
//   final DateTime? _date = DateTime.now();

//   String? _filterType;
//   DateTimeRange? _filterDateRange;

//   String _lang = 'ar';
//   String _t(String ar, String en) => _lang == 'ar' ? ar : en;

//   Future<void> _loadLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _lang = prefs.getString('languageCode') ?? 'ar';
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguage();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   Future<void> _addExpense() async {
//     if (_formKey.currentState!.validate()) {
//       await FS.addExpense(
//         type: _typeController.text.trim(),
//         amount: double.parse(_amountController.text.trim()),
//         date: _date ?? DateTime.now(),
//         note: _noteController.text.trim(),
//       );

//       _typeController.clear();
//       _amountController.clear();
//       _noteController.clear();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               _t("✅ تم حفظ المصروف بنجاح", "✅ Expense saved successfully")),
//         ),
//       );
//     }
//   }

//   /*Future<void> _selectDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _date ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => _date = picked);
//   }*/

//   Future<void> _pickDateRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       initialDateRange: _filterDateRange,
//     );
//     if (picked != null) {
//       setState(() => _filterDateRange = picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final df = DateFormat('yyyy-MM-dd');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_t("المصروفات", "Expenses")),
//         backgroundColor: const Color(0xFFD4AF37),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.black,
//           labelColor: Colors.black,
//           unselectedLabelColor: Colors.white,
//           tabs: [
//             Tab(text: _t("إضافة مصروف", "Add Expense")),
//             Tab(text: _t("سجل المصروفات", "Expense Log")),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // ✅ تبويب 1 - إضافة مصروف
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: ListView(
//                 children: [
//                   FutureBuilder<List<String>>(
//                     future: FS.getExpenseTypes(),
//                     builder: (context, snapshot) {
//                       final allTypes = snapshot.data ?? [];
//                       return Autocomplete<String>(
//                         optionsBuilder: (TextEditingValue textEditingValue) {
//                           if (textEditingValue.text.isEmpty) {
//                             return allTypes;
//                           }
//                           return allTypes.where((type) => type
//                               .toLowerCase()
//                               .contains(textEditingValue.text.toLowerCase()));
//                         },
//                         onSelected: (selection) {
//                           _typeController.text =
//                               selection; // ✅ يربط القيمة المختارة بالحقل فعلاً
//                         },
//                         fieldViewBuilder:
//                             (context, controller, focusNode, onFieldSubmitted) {
//                           controller.text =
//                               _typeController.text; // ✅ حافظ القيمة الحالية
//                           controller.addListener(() {
//                             _typeController.text =
//                                 controller.text; // ✅ يحدث المتغير عند كل كتابة
//                           });
//                           return TextFormField(
//                             controller: controller,
//                             focusNode: focusNode,
//                             decoration: InputDecoration(
//                               labelText: _t("نوع المصروف", "Expense Type"),
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (v) => v!.isEmpty
//                                 ? _t("أدخل نوع المصروف", "Enter expense type")
//                                 : null,
//                           );
//                         },
//                         optionsViewBuilder: (context, onSelected, options) {
//                           return Align(
//                             alignment: Alignment.topLeft,
//                             child: Material(
//                               elevation: 4.0,
//                               borderRadius: BorderRadius.circular(8),
//                               child: SizedBox(
//                                 height: 200,
//                                 child: ListView.builder(
//                                   padding: EdgeInsets.zero,
//                                   itemCount: options.length,
//                                   itemBuilder: (context, index) {
//                                     final option = options.elementAt(index);
//                                     return ListTile(
//                                       title: Text(option),
//                                       onTap: () => onSelected(option),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _amountController,
//                     decoration: InputDecoration(
//                       labelText: _t("المبلغ", "Amount"),
//                       border: const OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (v) =>
//                         v!.isEmpty ? _t("أدخل المبلغ", "Enter amount") : null,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _noteController,
//                     decoration: InputDecoration(
//                       labelText: _t("ملاحظات (اختياري)", "Notes (optional)"),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   /*Row(
//                     children: [
//                       Expanded(
//                         child: Text("${_t("التاريخ", "Date")}: ${df.format(_date!)}"),
//                       ),
//                       /*ElevatedButton(
//                         onPressed: _selectDate,
//                         child: Text(_t("اختيار تاريخ", "Select Date")),
//                       ),*/
//                     ],
//                   ),*/
//                   ListTile(
//                     leading: const Icon(Icons.calendar_today,
//                         color: Color(0xFFD4AF37)),
//                     title: Text(_t('التاريخ', 'Date')),
//                     subtitle: Text(DateFormat("yyyy-MM-dd").format(_date!)),
//                     /*trailing: IconButton(
//                       icon: const Icon(Icons.date_range),
//                       onPressed: () async {
//                         final d = await showDatePicker(
//                           context: context,
//                           initialDate: date,
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2100),
//                         );
//                         if (d != null) setState(() => date = d);
//                       },
//                     ),*/
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: _addExpense,
//                     icon: const Icon(Icons.save),
//                     label: Text(_t("حفظ المصروف", "Save Expense")),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFD4AF37),
//                       foregroundColor: Colors.black,
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ✅ تبويب 2 - سجل المصروفات (مع الفلترة)
//           // ✅ تبويب 2 - سجل المصروفات (مع فلترة من Dropdown)
//           Column(
//             children: [
//               // 🔍 شريط الفلترة
//               Container(
//                 color: Colors.grey.shade100,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   children: [
//                     StreamBuilder<List<String>>(
//                       stream:
//                           FS.expenseTypesStream(), // ✅ دالة جديدة تجيب الأنواع
//                       builder: (context, snapshot) {
//                         final types = snapshot.data ?? [];
//                         return Row(
//                           children: [
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 initialValue: _filterType,
//                                 hint: Text(_t(
//                                     "اختر نوع المصروف", "Select Expense Type")),
//                                 isExpanded: true,
//                                 items: [
//                                   DropdownMenuItem(
//                                     value: null,
//                                     child: Text(_t("الكل", "All")),
//                                   ),
//                                   ...types.map(
//                                     (t) => DropdownMenuItem(
//                                       value: t,
//                                       child: Text(t),
//                                     ),
//                                   ),
//                                 ],
//                                 onChanged: (val) {
//                                   setState(() => _filterType = val);
//                                 },
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 6),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             ElevatedButton.icon(
//                               onPressed: _pickDateRange,
//                               icon: const Icon(Icons.date_range),
//                               label: Text(_t("اختيار المدة", "Select Range")),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFFD4AF37),
//                                 foregroundColor: Colors.black,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                     if (_filterDateRange != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "${_t("من", "From")}: ${DateFormat('yyyy-MM-dd').format(_filterDateRange!.start)}  ${_t("إلى", "To")}: ${DateFormat('yyyy-MM-dd').format(_filterDateRange!.end)}",
//                               style: const TextStyle(fontSize: 13),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 setState(() => _filterDateRange = null);
//                               },
//                               icon: const Icon(Icons.clear, size: 18),
//                             )
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1, thickness: 1),

//               // 📋 قائمة المصروفات
//               Expanded(
//                 child: StreamBuilder(
//                   stream: FS.expensesStream(
//                     typeFilter: _filterType,
//                     dateRange: _filterDateRange,
//                   ),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final expenses = snapshot.data!;
//                     if (expenses.isEmpty) {
//                       return Center(
//                         child: Text(
//                           _t("لا توجد مصروفات مطابقة للفلترة",
//                               "No expenses match the filter"),
//                           textAlign: TextAlign.center,
//                         ),
//                       );
//                     }
//                     final df = DateFormat('yyyy-MM-dd');
//                     return ListView.builder(
//                       itemCount: expenses.length,
//                       itemBuilder: (context, i) {
//                         final e = expenses[i];
//                         final date = (e['date'] as Timestamp).toDate();
//                         return Card(
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 6),
//                           child: ListTile(
//                             title: Text(e['type']),
//                             subtitle:
//                                 Text("${df.format(date)}\n${e['note'] ?? ''}"),
//                             trailing: Text(
//                               " ${e['amount']} ${_t("ريال", "SAR")}",
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             onLongPress: () async {
//                               await FS.deleteExpense(e['id']);
//                             },
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final DateTime? _date = DateTime.now();

  // ✅ جديد: طريقة الدفع
  String _paymentMethod = 'cash'; // 'cash' أو 'network'

  String? _filterType;
  String? _filterPayment; // ✅ جديد: فلتر بطريقة الدفع
  DateTimeRange? _filterDateRange;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _typeController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());

    // ✅ نرسل طريقة الدفع مع المبلغ
    await FS.addExpense(
      type: _typeController.text.trim(),
      amount: amount,
      date: _date ?? DateTime.now(),
      note: _noteController.text.trim(),
      paymentMethod: _paymentMethod, // ✅ جديد
    );

    _typeController.clear();
    _amountController.clear();
    _noteController.clear();
    setState(() => _paymentMethod = 'cash');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_t("✅ تم حفظ المصروف بنجاح", "✅ Expense saved successfully")),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _filterDateRange,
    );
    if (picked != null) {
      setState(() => _filterDateRange = picked);
    }
  }

  // ✅ تسمية طريقة الدفع
  String _paymentLabel(String? method) {
    if (method == 'network') return _t("شبكة", "Network");
    return _t("كاش", "Cash");
  }

  // ✅ لون طريقة الدفع
  Color _paymentColor(String? method) {
    return method == 'network' ? Colors.blue : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("المصروفات", "Expenses")),
        backgroundColor: const Color(0xFFD4AF37),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(text: _t("إضافة مصروف", "Add Expense")),
            Tab(text: _t("سجل المصروفات", "Expense Log")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ============================================
          // تبويب 1 - إضافة مصروف
          // ============================================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // نوع المصروف
                  FutureBuilder<List<String>>(
                    future: FS.getExpenseTypes(),
                    builder: (context, snapshot) {
                      final allTypes = snapshot.data ?? [];
                      return Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return allTypes;
                          }
                          return allTypes.where((type) => type
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (selection) {
                          _typeController.text = selection;
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onFieldSubmitted) {
                          controller.text = _typeController.text;
                          controller.addListener(() {
                            _typeController.text = controller.text;
                          });
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: _t("نوع المصروف", "Expense Type"),
                              prefixIcon: const Icon(Icons.category,
                                  color: Color(0xFFD4AF37)),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty
                                ? _t("أدخل نوع المصروف", "Enter expense type")
                                : null,
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final option = options.elementAt(index);
                                    return ListTile(
                                      title: Text(option),
                                      onTap: () => onSelected(option),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // المبلغ
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: _t("المبلغ", "Amount"),
                      prefixIcon: const Icon(Icons.attach_money,
                          color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.isEmpty ? _t("أدخل المبلغ", "Enter amount") : null,
                  ),
                  const SizedBox(height: 10),

                  // ============================================
                  // ✅ جديد: طريقة الدفع (كاش / شبكة)
                  // ============================================
                  DropdownButtonFormField<String>(
                    value: _paymentMethod,
                    decoration: InputDecoration(
                      labelText: _t("طريقة الدفع", "Payment Method"),
                      prefixIcon:
                          const Icon(Icons.payment, color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'cash',
                        child: Row(
                          children: [
                            const Icon(Icons.money,
                                color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Text(_t("كاش", "Cash")),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'network',
                        child: Row(
                          children: [
                            const Icon(Icons.credit_card,
                                color: Colors.blue, size: 18),
                            const SizedBox(width: 8),
                            Text(_t("شبكة", "Network")),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => _paymentMethod = v ?? 'cash'),
                  ),
                  const SizedBox(height: 10),

                  // ملاحظات
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: _t("ملاحظات (اختياري)", "Notes (optional)"),
                      prefixIcon:
                          const Icon(Icons.note, color: Color(0xFFD4AF37)),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // التاريخ
                  ListTile(
                    leading: const Icon(Icons.calendar_today,
                        color: Color(0xFFD4AF37)),
                    title: Text(_t('التاريخ', 'Date')),
                    subtitle: Text(DateFormat("yyyy-MM-dd").format(_date!)),
                  ),
                  const SizedBox(height: 20),

                  // زر الحفظ
                  ElevatedButton.icon(
                    onPressed: _addExpense,
                    icon: const Icon(Icons.save),
                    label: Text(_t("حفظ المصروف", "Save Expense")),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================
          // تبويب 2 - سجل المصروفات
          // ============================================
          Column(
            children: [
              // 🔍 شريط الفلترة
              Container(
                color: Colors.grey.shade100,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    StreamBuilder<List<String>>(
                      stream: FS.expenseTypesStream(),
                      builder: (context, snapshot) {
                        final types = snapshot.data ?? [];
                        return Column(
                          children: [
                            // فلتر النوع
                            DropdownButtonFormField<String>(
                              initialValue: _filterType,
                              hint: Text(_t(
                                  "اختر نوع المصروف", "Select Expense Type")),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(_t("الكل", "All")),
                                ),
                                ...types.map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() => _filterType = val);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ✅ جديد: فلتر طريقة الدفع
                            DropdownButtonFormField<String>(
                              initialValue: _filterPayment,
                              hint: Text(_t("طريقة الدفع", "Payment Method")),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(_t("الكل", "All")),
                                ),
                                DropdownMenuItem(
                                  value: 'cash',
                                  child: Text(_t("كاش", "Cash")),
                                ),
                                DropdownMenuItem(
                                  value: 'network',
                                  child: Text(_t("شبكة", "Network")),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() => _filterPayment = val);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _pickDateRange,
                            icon: const Icon(Icons.date_range),
                            label: Text(_t("اختيار المدة", "Select Range")),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4AF37),
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_filterDateRange != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_t("من", "From")}: ${DateFormat('yyyy-MM-dd').format(_filterDateRange!.start)}  ${_t("إلى", "To")}: ${DateFormat('yyyy-MM-dd').format(_filterDateRange!.end)}",
                              style: const TextStyle(fontSize: 13),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => _filterDateRange = null);
                              },
                              icon: const Icon(Icons.clear, size: 18),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),

              // 📋 قائمة المصروفات
              Expanded(
                child: StreamBuilder(
                  stream: FS.expensesStream(
                    typeFilter: _filterType,
                    dateRange: _filterDateRange,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var expenses = snapshot.data!;

                    // ✅ فلتر طريقة الدفع
                    if (_filterPayment != null) {
                      expenses = expenses.where((e) {
                        final m = e['paymentMethod'] ?? 'cash';
                        return m == _filterPayment;
                      }).toList();
                    }

                    if (expenses.isEmpty) {
                      return Center(
                        child: Text(
                          _t("لا توجد مصروفات مطابقة للفلترة",
                              "No expenses match the filter"),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final df = DateFormat('yyyy-MM-dd');
                    return ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, i) {
                        final e = expenses[i];
                        final date = (e['date'] as Timestamp).toDate();
                        final method = e['paymentMethod'] ?? 'cash';

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: ListTile(
                            // ✅ أيقونة حسب طريقة الدفع
                            leading: CircleAvatar(
                              backgroundColor:
                                  _paymentColor(method).withOpacity(0.15),
                              child: Icon(
                                method == 'network'
                                    ? Icons.credit_card
                                    : Icons.money,
                                color: _paymentColor(method),
                                size: 20,
                              ),
                            ),
                            title: Text(e['type'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ✅ عرض طريقة الدفع
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        _paymentColor(method).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _paymentLabel(method),
                                    style: TextStyle(
                                      color: _paymentColor(method),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(df.format(date)),
                                if ((e['note'] ?? '').toString().isNotEmpty)
                                  Text(e['note']),
                              ],
                            ),
                            trailing: Text(
                              "${e['amount']} ${_t("ريال", "SAR")}",
                              style: TextStyle(
                                color: _paymentColor(method),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onLongPress: () async {
                              await FS.deleteExpense(e['id']);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
