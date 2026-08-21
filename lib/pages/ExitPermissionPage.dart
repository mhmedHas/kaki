import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class ExitPermissionPage extends StatefulWidget {
  const ExitPermissionPage({super.key});

  @override
  State<ExitPermissionPage> createState() => _ExitPermissionPageState();
}

class _ExitPermissionPageState extends State<ExitPermissionPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  StreamSubscription<String>? _tagSubscription;

  String epcHex = '';
  Map<String, dynamic>? itemData;

  bool loading = false;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _loadLanguage();

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (tag == epcHex) return;

      setState(() {
        epcHex = tag;
      });

      _loadItem();
    });

    SeuicUhfService.open();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tagSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadItem() async {
    final data = await FS.findItemByEpc(epcHex);
    setState(() => itemData = data);
  }

  Future<void> _allowExit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || itemData == null) return;

    setState(() => loading = true);

    // ✅ تحقق هل موجود قبل كده
    final exists = await FS.checkIfExists(epcHex, user.uid);

    if (exists) {
      setState(() => loading = false);

      _showMsg(_t(
        "تم إصدار تصريح لهذه الشريحة من قبل",
        "Already permitted before",
      ));
      return;
    }

    await FS.addStatement(epcHex, itemData!, user.uid);

    // ✅ امسح البيانات بعد الحفظ
    setState(() {
      epcHex = '';
      itemData = null;
      loading = false;
    });

    _showMsg(_t("تم إصدار تصريح خروج", "Exit permitted"));
  }
  Future<void> _cancel(String epc) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FS.cancelStatement(epc, user.uid);

    _showMsg(_t("تم إلغاء التصريح", "Permission deleted"));
  }

  // ================= إدخال يدوي =================
  void _showManualEpcDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t("إدخال الشريحة", "Manual Entry")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _t("رقم الشريحة", "Tag EPC"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          ElevatedButton(
            onPressed: () {
              final epc = controller.text.trim();
              Navigator.pop(ctx);

              if (epc.isEmpty) {
                _showMsg(_t("أدخل رقم الشريحة", "Enter EPC"));
                return;
              }

              setState(() => epcHex = epc);
              _loadItem();
            },
            child: Text(_t("تحميل", "Load")),
          ),
        ],
      ),
    );
  }
  void _openFullImage(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.blue,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.download,color: Colors.blue,),
                onPressed: () => _downloadImage(imageUrl),
              ),
            ],
          ),

          body: InteractiveViewer(
            child: Center(
              child: Image.network(
                imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("لا توجد صورة"));
                },
              ),
            ),
          ),
        );
      },
    );
  }
  bool downloading = false;

  Future<void> _downloadImage(String url) async {
    try {
      setState(() => downloading = true);

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      await Dio().download(url, filePath);

      setState(() => downloading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحميل الصورة")),
      );
    } catch (e) {
      setState(() => downloading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل تحميل الصورة")),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(_t("تصاريح الخروج", "Exit Permissions")),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          labelStyle: const TextStyle(
            fontSize: 16,
          ),
          tabs: [
            Tab(text: _t("اصدار تصريح", "Issuing a permit")),
            Tab(text: _t("التصاريح", "Permissions")),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showManualEpcDialog,
        backgroundColor: const Color(0xFFD4AF37),
        child: const Icon(Icons.add),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          // ================= TAB 1 =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  Text("EPC: ${epcHex.isEmpty ? '-' : epcHex}"),

                  const SizedBox(height: 15),

                  if (itemData != null)
                    _buildDetailsCard()
                  else if (epcHex.isNotEmpty)
                    Text(_t("لا توجد بيانات", "No data")),

                ],
              ),
            ),
          ),

          // ================= TAB 2 =================
          StreamBuilder(
            stream: FS.getStatements(user!.uid),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return Center(child: Text(_t("لا يوجد تصاريح", "No permissions")));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, i) {
                  final data = docs[i];
                  final payload = data['payload'] ?? {};
                  final images = (data.data() as Map<String, dynamic>)['images'] ?? [];


                  return StatefulBuilder(
                    builder: (context, setLocalState) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    IconButton(
                                      icon: const Icon(Icons.image, color: Colors.blue),
                                      onPressed: () {
                                        if (images.isNotEmpty) {
                                          _openFullImage(images[0]);
                                        }
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _cancel(data['epcHex']),
                                    ),

                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("EPC: ${data['epcHex']}"),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                _infoRow(_t("القسم", "category"), data['category']),

                                if (payload['carat'] != null)
                                  _infoRow(_t("العيار", "Carat"), payload['carat']),

                                if (payload['weight'] != null)
                                  _infoRow(_t("الوزن", "Weight"), payload['weight']),

                                if (payload['wage'] != null)
                                  _infoRow(_t("الأجر", "Wage"), payload['wage']),

                                if (payload['cost'] != null)
                                  _infoRow(_t("التكلفة", "cost"), payload['cost']),

                                if (payload['type'] != null)
                                  _infoRow(_t("النوع", "type"), payload['type']),

                                if (payload['kind'] != null)
                                  _infoRow(_t("النوع", "type"), payload['kind']),

                                if (payload['qrCode'] != null)
                                  _infoRow(_t("الكود", "Code"), payload['qrCode']),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= تفاصيل =================
  Widget _buildDetailsCard() {
    final payload = itemData!['payload'] ?? {};
    final images = itemData!['images'] ?? [];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            if (images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  images[0],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 10),

            _infoRow(_t("القسم", "category"), itemData!['category']),
            if (payload['carat'] != null )
              _infoRow(_t("العيار", "Carat"), payload['carat']),
            if (payload['Weight'] != null )
              _infoRow(_t("الوزن", "Weight"), payload['weight']),
            if (payload['wage'] != null )
              _infoRow(_t("الأجر", "Wage"), payload['wage']),
            if (payload['cost'] != null )
              _infoRow(_t("التكلفه", "cost"), payload['cost']),
            if (payload['type'] != null )
              _infoRow(_t("النوع", "type"), payload['type']),
            if (payload['kind'] != null )
              _infoRow(_t("النوع", "type"), payload['kind']),
            if (payload['qrCode'] != null )
              _infoRow(_t("الكود", "Code"), payload['qrCode']),



            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _allowExit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    :
                Text(
                  _t("تصريح خروج", "Allow Exit"),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value?.toString() ?? "-")),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}