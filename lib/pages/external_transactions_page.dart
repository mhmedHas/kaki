import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExternalTransactionsPage extends StatefulWidget {
  const ExternalTransactionsPage({super.key});

  @override
  State<ExternalTransactionsPage> createState() =>
      _ExternalTransactionsPageState();
}

class _ExternalTransactionsPageState
    extends State<ExternalTransactionsPage> {
  StreamSubscription<String>? _tagSubscription;

  String epcHex = '';
  bool isReading = false;
  bool busy = false;
  String? msg;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;


  Map<String, dynamic>? itemData;

  final shopController = TextEditingController();
  final managerController = TextEditingController();

  String? selectedUser;
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    _loadUserNames();
    _loadLanguage();

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (mounted) {
        setState(() {
          epcHex = tag;
          isReading = false;
        });
        _loadItemData();
      }
    });

    SeuicUhfService.open();
  }

  Future<void> _loadUserNames() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userNames = prefs.getStringList('userNames') ?? [];
      if (userNames.isNotEmpty) selectedUser = userNames.first;
    });
  }
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    shopController.dispose();
    managerController.dispose();
    super.dispose();
  }

  Future<void> _readChip() async {
    setState(() {
      isReading = true;
      msg = null;
    });

    try {
      final result = await SeuicUhfService.inventoryOnce();
      if (result == null || result.isEmpty) {
        setState(() => isReading = false);
        _showMsg("لم يتم العثور على شريحة", false);
      } else {
        setState(() {
          epcHex = result.toUpperCase();
          isReading = false;
        });
        _loadItemData();
      }
    } catch (e) {
      setState(() => isReading = false);
      _showMsg("خطأ في القراءة: $e", false);
    }
  }

  Future<void> _loadItemData() async {
    if (epcHex.isEmpty) return;

    try {
      final data = await FS.findItemByEpc(epcHex);
      setState(() {
        itemData = data;
      });
    } catch (e) {
      _showMsg("فشل تحميل البيانات", false);
    }
  }

  Future<void> _sendExternal() async {
    if (itemData == null) {
      _showMsg("اقرأ شريحة أولاً", false);
      return;
    }

    if (shopController.text.isEmpty ||
        managerController.text.isEmpty) {
      _showMsg("اكتب اسم المحل واسم المستلم", false);
      return;
    }

    if (selectedUser == null) {
      _showMsg("يرجى ضبط اسم المستخدم من الإعدادات", false);
      return;
    }

    setState(() => busy = true);

    try {
      await FS.sendToExternal(
        epc: epcHex,
        itemData: itemData!,
        shopName: shopController.text.trim(),
        managerName: managerController.text.trim(),
        sentBy: selectedUser!,
      );


      _showMsg("✅ تم إرسال القطعة بنجاح", true);

      setState(() {
        itemData = null;
        epcHex = '';
        shopController.clear();
        managerController.clear();
      });
    } catch (e) {
      _showMsg("فشل الإرسال: $e", false);
    } finally {
      setState(() => busy = false);
    }
  }
  void _showReceiveDialog(String epc) {

    String paymentType = "cash";

    final cashController = TextEditingController();
    final visaController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("استلام مبلغ"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  DropdownButton<String>(
                    value: paymentType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: "cash", child: Text("كاش")),
                      DropdownMenuItem(
                          value: "visa", child: Text("شبكة")),
                      DropdownMenuItem(
                          value: "multi", child: Text("متعدد")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        paymentType = val!;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  if (paymentType == "cash" ||
                      paymentType == "multi")
                    TextField(
                      controller: cashController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "مبلغ الكاش",
                      ),
                    ),
                  const SizedBox(height: 10),

                  if (paymentType == "visa" ||
                      paymentType == "multi")
                    TextField(
                      controller: visaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "مبلغ الشبكة",
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
                ),
                ElevatedButton(
                  onPressed: () async {

                    final cash =
                        double.tryParse(cashController.text) ?? 0;

                    final visa =
                        double.tryParse(visaController.text) ?? 0;

                    final total = cash + visa;

                    final paymentData = {
                      "type": "external",
                      "cash": cash,
                      "visa": visa,
                      "total": total,
                      "soldBy": selectedUser,
                    };

                    await FS.receiveExternalPayment(
                      epc: epc,
                      paymentData: paymentData,
                    );
                    await _deleteItemImages(epc);

                    Navigator.pop(context);
                  },
                  child: const Text("تأكيد"),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> _deleteItemImages(String epc) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // المسار الكامل للفولدر الخاص بالشريحة
      final folderRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(epc.toUpperCase());

      // جلب قائمة كل الملفات داخل الفولدر
      final ListResult result = await folderRef.listAll();

      if (result.items.isEmpty) {
        print('ℹ️ لا توجد صور للشريحة $epc (الفولدر فاضي)');
        // نحذف الحقل من Firestore برضو عشان النظافة
        //await _clearImagesFieldFromFirestore(epc);
        return;
      }

      print('🗑️ بدء حذف ${result.items.length} صورة للشريحة $epc');

      // حذف كل صورة
      for (Reference ref in result.items) {
        try {
          await ref.delete();
          print('✅ تم حذف: ${ref.name}');
        } catch (e) {
          print('❌ فشل حذف ملف: ${ref.name} | $e');
        }
      }

      // بعد الحذف، نحذف حقل images من Firestore
      //await _clearImagesFieldFromFirestore(epc);

      print('✅ تم حذف الفولدر بأكمله وحقل الصور من Firestore لـ $epc');
    } catch (e) {
      print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
      // ما نوقفش عملية البيع بسبب الصور
    }
  }



  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SizedBox(
            height: 600,
            child: StreamBuilder<QuerySnapshot>(
              stream: FS.getExternalTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("لا توجد تعاملات"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                    docs[index].data() as Map<String, dynamic>;
                    final epc = data['epc'];
                    final payload = data['payload'] as Map<String, dynamic>;


                    final sentAt = data['sentAt'] as Timestamp?;
                    final dateString = sentAt != null
                        ? "${sentAt.toDate().day}/${sentAt.toDate().month}/${sentAt.toDate().year} - "
                        "${sentAt.toDate().hour}:${sentAt.toDate().minute}"
                        : "";


                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 👇 المعلومات + زرار الصورة في نفس السطر
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  /// المعلومات
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "EPC: $epc",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (payload['carat'] != null)
                                          Text(_t("العيار: ${payload['carat']}", "carat: ${payload['carat']}")),
                                        if (payload['kind'] != null)
                                          Text(_t("القسم: ${payload['kind']}", "kind: ${payload['kind']}")),
                                        if (payload['type'] != null)
                                          Text(_t("القسم: ${payload['type']}", "kind: ${payload['type']}")),
                                        if (data['category'] == "bullion")
                                          Text(_t("القسم: سبائك", "kind: bullion")),
                                        if (payload['weight'] != null)
                                          Text(_t("الوزن: ${payload['weight']}", "weight: ${payload['weight']}")),
                                        if (payload['wage'] != null)
                                          Text(_t("الأجر: ${payload['wage']}", "Wage: ${payload['wage']}")),
                                        if (payload['cost'] != null)
                                          Text(_t("التكلفة: ${payload['cost']}", "Wage: ${payload['wage']}")),


                                        Text("المحل: ${data['shopName']}"),
                                        Text("المستلم: ${data['managerName']}"),
                                        Text("بواسطة: ${data['sentBy']}"),
                                        Text("تاريخ التعامل: $dateString"),
                                      ],
                                    ),
                                  ),

                                  /// زرار عرض الصور
                                  IconButton(
                                    icon: const Icon(Icons.image, color: Colors.blue ,size: 35,),
                                    onPressed: () async {
                                      final uid =
                                          FirebaseAuth.instance.currentUser!.uid;

                                      final storageRef = FirebaseStorage.instance
                                          .ref()
                                          .child('images')
                                          .child('users')
                                          .child(uid)
                                          .child(epc);

                                      try {
                                        final result = await storageRef.listAll();

                                        if (result.items.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                              Text("لا يوجد صور محفوظة"),
                                            ),
                                          );
                                          return;
                                        }

                                        final urls = await Future.wait(
                                          result.items
                                              .map((ref) =>
                                              ref.getDownloadURL()),
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (_) => Dialog(
                                            child: Container(
                                              padding:
                                              const EdgeInsets.all(8),
                                              width: double.maxFinite,
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    "صور الشريحة",
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: 8),
                                                  SizedBox(
                                                    height: 400,
                                                    child:
                                                    ListView.builder(
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      itemCount:
                                                      urls.length,
                                                      itemBuilder:
                                                          (_, i) =>
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                            child: Image.network(
                                                                urls[i]),
                                                          ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context),
                                                    child: const Text(
                                                        "إغلاق"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                            Text("فشل تحميل الصور"),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// 👇 الزرارين تحت المعلومات
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white
                                      ),
                                      onPressed: () async {
                                        await FS.returnExternal(epc);
                                      },
                                      child: const Text("إرجاع"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green, foregroundColor: Colors.white
                                      ),
                                      onPressed: () {
                                        _showReceiveDialog(epc);
                                      },
                                      child: const Text("استلام مبلغ"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );


                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showMsg(String text, bool success) {
    setState(() {
      msg = success ? text : text;
    });
  }

  List<Widget> _buildDetails() {
    if (itemData == null) return [];

    final payload = itemData!['payload'] ?? {};
    final category = itemData!['category'] ?? '';

    final List<Widget> details = [];

    details.add(
      Text(
        _t("الفئة: ${_getCategoryName(category)}", "Category: ${_getCategoryName(category)}"),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
    details.add(const SizedBox(height: 10));

    switch (category) {
      case "gold":
        details.addAll([
          _buildInfoRow(_t("العيار", "Carat"), payload['carat']),
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الأجر", "Wage"), payload['wage']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "scrap":
        details.addAll([
          _buildInfoRow(_t("العيار", "Carat"), payload['carat']),
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "bullion":
        details.addAll([
          _buildInfoRow(_t("الوزن", "Weight"), payload['weight']),
          _buildInfoRow(_t("الأجر", "Wage"), payload['wage']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      case "gem":
        details.addAll([
          _buildInfoRow(_t("نوع الحجر", "Gem Type"), payload['type']),
          _buildInfoRow(_t("التكلفة", "Cost"), payload['cost']),
          _buildInfoRow(_t("الكود", "Code"), payload['qrCode']),
          _buildInfoRow(_t("ملاحظات", "Notes"), payload['notes']),
        ]);
        break;

      default:
        details.add(
          Text(
            _t("❌ نوع غير معروف", "❌ Unknown Type"),
            style: const TextStyle(color: Colors.red),
          ),
        );

    }
    // ✅ إضافة الباركود أو QR في النهاية
    if (payload['qrCode'] != null && payload['qrCode'].toString().isNotEmpty) {
      details.add(const SizedBox(height: 16));
      details.add(
        Center(
          child: (payload['showQr'] == true)
              ? QrImageView(
            data: payload['qrCode'],
            version: QrVersions.auto,
            size: 100.0,
            backgroundColor: Colors.white,
          )
              : BarcodeWidget(
            barcode: Barcode.code128(),
            data: payload['qrCode'],
            width: 100,
            height: 40,
          ),
        ),
      );
      details.add(const SizedBox(height: 16));
    }

    return details;
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value?.toString() ?? '-', style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String cat) {
    switch (cat) {
      case 'gold':
        return _t("ذهب", "Gold");
      case 'scrap':
        return _t("كسر", "Scrap");
      case 'bullion':
        return _t("سبائك", "Bullion");
      case 'gem':
        return _t("أحجار كريمة", "Gemstone");
      default:
        return cat;
    }
  }
  void _showManualEpcDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t("إدخال الشريحة يدويًا", "Enter Tag Manually")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: _t("رقم الشريحة (EPC)", "Tag EPC"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AddEpcManualy(controller.text);
            },
            child: Text(_t("إضافة", "Add")),
          ),
        ],
      ),
    );
  }
  void AddEpcManualy(String Epc){
    SeuicUhfService.addEpcManualy(Epc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التعاملات الخارجية"),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showHistoryDialog,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        tooltip: _t("إدخال شريحة يدوي", "Manual Tag"),
        onPressed: _showManualEpcDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (userNames.isNotEmpty) ...[
                Text(
                  _t("اختر اسم المستخدم:", "Select User:"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                DropdownButton<String>(
                  value: selectedUser,
                  isExpanded: true,
                  hint: Text(_t("اختر المستخدم", "Select User")),
                  items: userNames.map((name) {
                    return DropdownMenuItem(value: name, child: Text(name));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedUser = val),
                ),
                const Divider(),
              ],
              /*ElevatedButton.icon(
                onPressed: isReading ? null : _readChip,
                icon: const Icon(Icons.nfc),
                label: const Text("قراءة الشريحة"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                ),
              ),*/
              const SizedBox(height: 20),

              if (itemData != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: _buildDetails(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: shopController,
                  decoration: const InputDecoration(
                    labelText: "اسم المحل",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: managerController,
                  decoration: const InputDecoration(
                    labelText: "اسم المستلم",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: busy ? null : _sendExternal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14), // يخليه أطول شوية
                    ),
                    child: const Text(
                      "إرسال القطعة",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )

              ],

              if (msg != null) ...[
                const SizedBox(height: 20),
                Text(
                  msg!,
                  style: TextStyle(
                    color: msg!.contains("✅")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
