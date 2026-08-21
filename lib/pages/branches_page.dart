import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart'; // عدّل المسار لو مختلف
import 'package:shared_preferences/shared_preferences.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
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

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الأفرع", "Branches")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 1, // زرار واحد في السطر
          mainAxisSpacing: 12,
          childAspectRatio: 4, // مستطيل (تقدر تزود أو تقلل)
          children: [
            _buildMenuCard(
              context,
              icon: Icons.add_business,
              label: _t("إضافة فرع", "Add Branch"),
              page: const AddBranchPage(),
            ),
            _buildMenuCard(
              context,
              icon: Icons.list_alt,
              label: _t("سجل الأفرع", "Branches List"),
              page: const BranchesListPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: const Color(0xFFD4AF37).withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= Add Branch Page =================
class AddBranchPage extends StatefulWidget {
  const AddBranchPage({super.key});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  final nameCtrl = TextEditingController();
  final uidCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final managerCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final delegateCtrl = TextEditingController();
  List<String> delegates = [];
  DateTime selectedDate = DateTime.now();
  bool saving = false;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => selectedDate = d);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("إضافة فرع", "Add Branch")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInput(
                controller: nameCtrl,
                label: _t("اسم الفرع", "Branch Name"),
                icon: Icons.business),
            const SizedBox(height: 12),
            _buildInput(
                controller: uidCtrl,
                label: _t("رقم الفرع", "Branch Number"),
                icon: Icons.discount),
            const SizedBox(height: 12),
            _buildInput(
                controller: addressCtrl,
                label: _t("العنوان", "Address"),
                icon: Icons.location_on),
            const SizedBox(height: 12),
            _buildInput(
                controller: managerCtrl,
                label: _t("اسم مدير الفرع", "Branch Manager"),
                icon: Icons.person),
            const SizedBox(height: 12),
            _buildInput(
                controller: phoneCtrl,
                label: _t("رقم الهاتف", "Phone Number"),
                icon: Icons.phone,
                keyboard: TextInputType.phone),
            const SizedBox(height: 12),

            // مندوبين مع زر إضافة
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                      controller: delegateCtrl,
                      label: _t("اسم المندوب", "Delegate Name"),
                      icon: Icons.person_outline),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37)),
                  onPressed: () {
                    final t = delegateCtrl.text.trim();
                    if (t.isNotEmpty) {
                      setState(() {
                        delegates.add(t);
                        delegateCtrl.clear();
                      });
                    }
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: delegates
                  .map((d) => Chip(
                        label: Text(d),
                        onDeleted: () => setState(() => delegates.remove(d)),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 20),

            // التاريخ
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 8),
                Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37)),
                  onPressed: _pickDate,
                  child: Text(_t("تغيير التاريخ", "Change Date")),
                )
              ],
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: saving ? null : _save,
                child: saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_t("حفظ", "Save"),
                        style: const TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      {required TextEditingController controller,
      required String label,
      IconData? icon,
      TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            icon != null ? Icon(icon, color: const Color(0xFFD4AF37)) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _save() async {
    final name = nameCtrl.text.trim();
    final uid = uidCtrl.text.trim();
    final address = addressCtrl.text.trim();
    final manager = managerCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t("ادخل اسم الفرع", "Enter branch name"))));
      return;
    }
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t("ادخل رقم الفرع", "Enter branch number"))));
      return;
    }

    setState(() => saving = true);
    try {
      await FS.addBranch(
        name: name,
        uid: uid,
        address: address,
        manager: manager,
        phone: phone,
        delegates: delegates,
        date: selectedDate,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t("تم حفظ الفرع ✅", "Branch saved ✅"))));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_t("خطأ: $e", "Error: $e"))));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }
}

/// ================= Branches List Page =================
class BranchesListPage extends StatefulWidget {
  const BranchesListPage({super.key});

  @override
  State<BranchesListPage> createState() => _BranchesListPageState();
}

class _BranchesListPageState extends State<BranchesListPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _lang = prefs.getString('languageCode') ?? 'ar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("سجل الأفرع", "Branches Record")),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FS.branchesStream(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final branches = snap.data!;
          if (branches.isEmpty) {
            return Center(
                child:
                    Text(_t("لا يوجد فروع حالياً", "No branches available")));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: branches.length,
            itemBuilder: (_, i) {
              final b = branches[i];
              final dateText = b['date'] is Timestamp
                  ? (b['date'] as Timestamp).toDate().toString().split(' ')[0]
                  : (b['date'] is DateTime
                      ? (b['date'] as DateTime).toString().split(' ')[0]
                      : '-');

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    b['name'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (b['uid'] != null) Text("🆔 ${b['uid']}"),
                      if (b['address'] != null) Text("📍 ${b['address']}"),
                      if (b['manager'] != null)
                        Text("👤 ${_t('المدير', 'Manager')}: ${b['manager']}"),
                      if (b['phone'] != null) Text("📞 ${b['phone']}"),
                      if (b['delegates'] != null &&
                          (b['delegates'] as List).isNotEmpty)
                        Text(
                            "👥 ${_t('مندوبين', 'Delegates')}: ${(b['delegates'] as List).join(', ')}"),
                      Text("📅 $dateText"),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'edit') {
                        _showEditDialog(context, b);
                      } else if (v == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title:
                                Text(_t("تأكيد الحذف", "Delete Confirmation")),
                            content: Text(
                                "${_t("هل تريد حذف الفرع", "Do you want to delete branch")} ${b['name']}؟"),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(_t("إلغاء", "Cancel"))),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text(_t("حذف", "Delete"),
                                      style:
                                          const TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await FS.deleteBranch(b['id']);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  _t("تم حذف الفرع ✅", "Branch deleted ✅"))));
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [
                            const Icon(Icons.edit, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(_t("تعديل", "Edit"))
                          ])),
                      PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            const Icon(Icons.delete, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(_t("حذف", "Delete"))
                          ])),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> branch) {
    final nameCtrl = TextEditingController(text: branch['name'] ?? '');
    final uidCtrl = TextEditingController(text: branch['uid'] ?? '');
    final addressCtrl = TextEditingController(text: branch['address'] ?? '');
    final managerCtrl = TextEditingController(text: branch['manager'] ?? '');
    final phoneCtrl = TextEditingController(text: branch['phone'] ?? '');
    final delegatesKey = GlobalKey<_EditDelegatesState>();
    DateTime date = branch['date'] is Timestamp
        ? (branch['date'] as Timestamp).toDate()
        : (branch['date'] is DateTime ? branch['date'] : DateTime.now());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text("${_t("تعديل الفرع", "Edit branch")} ${branch['name'] ?? ''}"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                      labelText: _t("اسم الفرع", "Branch name"))),
              const SizedBox(height: 8),
              TextField(
                  controller: uidCtrl,
                  decoration: InputDecoration(
                      labelText: _t("رقم الفرع", "Branch number"))),
              const SizedBox(height: 8),
              TextField(
                  controller: addressCtrl,
                  decoration:
                      InputDecoration(labelText: _t("العنوان", "Address"))),
              const SizedBox(height: 8),
              TextField(
                  controller: managerCtrl,
                  decoration: InputDecoration(
                      labelText: _t("اسم المدير", "Manager name"))),
              const SizedBox(height: 8),
              TextField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                      labelText: _t("رقم الهاتف", "Phone number"))),
              const SizedBox(height: 8),
              EditDelegates(
                  key: delegatesKey,
                  initialDelegates:
                      List<String>.from(branch['delegates'] ?? [])),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text(DateFormat('yyyy-MM-dd').format(date)),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (d != null) date = d;
                    },
                    child: Text(_t("تغيير", "Change")),
                  )
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t("إلغاء", "Cancel"))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () async {
              final delegates = delegatesKey.currentState?.getDelegates() ?? [];
              await FS.updateBranch(branch['id'], {
                'name': nameCtrl.text.trim(),
                'uid': uidCtrl.text.trim(),
                'address': addressCtrl.text.trim(),
                'manager': managerCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'delegates': delegates,
                'date': Timestamp.fromDate(date),
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_t("تم التعديل ✅", "Updated successfully ✅"))));
            },
            child: Text(_t("حفظ", "Save")),
          )
        ],
      ),
    );
  }
}

/// Helper widget to edit delegates inside dialog
class EditDelegates extends StatefulWidget {
  final List<String> initialDelegates;
  const EditDelegates({super.key, this.initialDelegates = const []});

  @override
  State<EditDelegates> createState() => _EditDelegatesState();
}

class _EditDelegatesState extends State<EditDelegates> {
  late List<String> delegates;
  final ctrl = TextEditingController();
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
    delegates = List<String>.from(widget.initialDelegates);
  }

  List<String> getDelegates() => delegates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
                    controller: ctrl,
                    decoration:
                        InputDecoration(labelText: _t("المندوب", "Delegate")))),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37)),
              onPressed: () {
                final t = ctrl.text.trim();
                if (t.isNotEmpty) {
                  setState(() {
                    delegates.add(t);
                    ctrl.clear();
                  });
                }
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: delegates
              .map((d) => Chip(
                  label: Text(d),
                  onDeleted: () => setState(() => delegates.remove(d))))
              .toList(),
        )
      ],
    );
  }
}
