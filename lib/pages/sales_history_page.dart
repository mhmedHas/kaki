import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool deletingAll = false;

  CollectionReference get historyCol =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('sales_history');

  @override
  void initState() {
    super.initState();
    _deleteExpiredItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل المبيعات"),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: deletingAll ? null : _confirmDeleteAll,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: historyCol.orderBy("soldAt", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "لا يوجد سجل مبيعات",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              final data = doc.data() as Map<String, dynamic>;

              final payload =
              Map<String, dynamic>.from(data['payload'] ?? {});

              final payment =
              Map<String, dynamic>.from(data['payment'] ?? {});

              final Timestamp? ts = data["soldAt"];

              String date = "";

              if (ts != null) {
                date = DateFormat(
                  "yyyy/MM/dd   HH:mm",
                ).format(ts.toDate());
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [

                      _row("رقم الشريحة", data["epcHex"] ?? ""),
                      if (payload['kind'] != null)
                        _row("النوع", payload["kind"] ?? ""),
                      if (payload['type'] != null)
                        _row("النوع", payload["type"] ?? ""),
                      if (data['category'] == "bullion")
                        _row("النوع", "سبائك" ?? ""),
                      if (payload['carat'] != null)
                        _row("العيار", payload["carat"] ?? ""),
                      if (payload['weight'] != null)
                        _row(
                          "الوزن",
                          "${payload["weight"] ?? 0}",
                        ),
                      if (payload['wage'] != null)
                        _row(
                          "الاجر",
                          "${payload["wage"] ?? 0}",
                        ),
                      if (payload['cost'] != null)
                        _row(
                          "التكلفة",
                          "${payload["cost"] ?? 0}",
                        ),

                      _row(
                        "الإجمالي",
                        "${payment["total"] ?? 0}",
                      ),
                      if (payment["type"] == "visa")
                        _row(
                          "طريقة الدفع",
                          "شبكة",
                        ),
                      if (payment["type"] == "cash")
                        _row(
                          "طريقة الدفع",
                          "كاش",
                        ),
                      if (payment["type"] == "multi")
                        _row(
                          "طريقة الدفع",
                          "متعدد",
                        ),
                      _row(
                        "البائع",
                        payment["soldBy"] ?? "",
                      ),

                      _row(
                        "تاريخ البيع",
                        date,
                      ),

                      const Divider(),

                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showImages(
                                  data["epcHex"],
                                );
                              },
                              icon: const Icon(Icons.image),
                              label: const Text("الصور"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                _confirmDeleteOne(doc);
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text("حذف"),
                            ),
                          ),

                        ],
                      )

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

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [

          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(value),
          )

        ],
      ),
    );
  }

  Future<void> _showImages(String epc) async {
    final folderRef = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('users')
        .child(uid)
        .child('sales')
        .child(epc.toUpperCase());

    try {
      final result = await folderRef.listAll();

      if (result.items.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("لا توجد صور لهذه الشريحة"),
            ),
          );
        }
        return;
      }

      final urls = await Future.wait(
        result.items.map((e) => e.getDownloadURL()),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
            Dialog(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.maxFinite,
                  height: 450,
                  child: Column(
                    children: [
                      const Text(
                        "صور الشريحة",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: GridView.builder(
                          itemCount: urls.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _openImage(urls[index]);
                              },
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.circular(10),
                                child: Image.network(
                                  urls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("إغلاق"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void _openImage(String url) {
    showDialog(
      context: context,
      builder: (_) =>
          Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5,
              child: Image.network(url),
            ),
          ),
    );
  }

  Future<void> _confirmDeleteOne(DocumentSnapshot doc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("حذف السجل"),
            content: const Text(
              "هل تريد حذف هذا السجل مع جميع الصور الخاصة به؟",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("حذف"),
              ),
            ],
          ),
    );

    if (ok != true) return;

    final data = doc.data() as Map<String, dynamic>;

    await _deleteImages(data["epcHex"]);

    await doc.reference.delete();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف السجل"),
        ),
      );
    }
  }
  Future<void> _deleteImages(String epc) async {
    try {
      final folderRef = FirebaseStorage.instance
          .ref()
          .child("images")
          .child("users")
          .child(uid)
          .child("sales")
          .child(epc.toUpperCase());

      final result = await folderRef.listAll();

      for (final file in result.items) {
        await file.delete();
      }
    } catch (_) {}
  }

  Future<void> _confirmDeleteAll() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text("حذف السجل بالكامل"),
            content: const Text(
              "سيتم حذف جميع السجلات وجميع الصور، هل أنت متأكد؟",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("حذف"),
              ),
            ],
          ),
    );

    if (ok != true) return;

    setState(() {
      deletingAll = true;
    });

    try {
      final docs = await historyCol.get();

      for (final doc in docs.docs) {
        final data = doc.data() as Map<String, dynamic>;

        await _deleteImages(data["epcHex"]);

        await doc.reference.delete();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم حذف السجل بالكامل"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          deletingAll = false;
        });
      }
    }
  }

  Future<void> _deleteExpiredItems() async {
    try {
      final limit = DateTime.now().subtract(
        const Duration(days: 30),
      );

      final oldDocs = await historyCol
          .where(
        "soldAt",
        isLessThan: Timestamp.fromDate(limit),
      )
          .get();

      for (final doc in oldDocs.docs) {
        final data = doc.data() as Map<String, dynamic>;

        await _deleteImages(data["epcHex"]);

        await doc.reference.delete();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}