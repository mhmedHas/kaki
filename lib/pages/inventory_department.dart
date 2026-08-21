import 'dart:async';
import 'package:flutter/material.dart';
import '../services/seuic_uhf_service.dart';
import '../services/firestore_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class InventoryDepartment extends StatefulWidget {
  const InventoryDepartment({super.key});

  @override
  State<InventoryDepartment> createState() => _InventoryDepartmentState();
}

class _InventoryDepartmentState extends State<InventoryDepartment> {
  List<String> epcs = [];
  Map<String, Map<String, dynamic>?> itemsData = {};
  bool isReading = false;
  bool busy = false;
  String? msg;
  StreamSubscription<String>? _tagSubscription;
  int itemsCount = 0;
  double saveProgress = 0.0;
  int savedCount = 0;
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  int _readerPower = 26; // القيمة الحالية
  int _tempPower = 26; // قيمة السلايدر المؤقتة
  List<Map<String, dynamic>> AllTags = [];
  Timer? _uiUpdateTimer;
  final Set<String> _pendingEpcs = {};
  late Map<String, Map<String, dynamic>> tagsLookup;

  List<String> allDepartments = [];
  List<String> selectedDepartments = [];
  Map<String, Map<String, dynamic>> departmentsCount = {};
  Map<String, Map<String, dynamic>> scannedDepartmentsCount = {};

  @override
  void initState() {
    super.initState();
    //SeuicUhfService.sendBoolean(true);
    //SeuicUhfService.listenForInitStatus(context);
    _loadLanguage();
    //_setPagePower();
    _loadItemsCount();
    //_loadSavedReaderPower();
    GetAllEpcAndQr();
    _uiUpdateTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      if (!mounted) return;

      if (_pendingEpcs.isNotEmpty) {
        setState(() {
          epcs.addAll(_pendingEpcs);
          _pendingEpcs.clear();
        });
      }
    });

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;
      if (selectedDepartments.isEmpty) return;

      final tags =
          tag.split("ENTER").where((t) => t.trim().isNotEmpty).toList();

      for (final raw in tags) {
        final epc = raw;

        /*final result = AllTags.firstWhere(
              (e) =>
          e['epcHex'] == epc.toUpperCase() ||
              e['qrCode'] == epc,
          orElse: () => {},
        );
        if (result.isEmpty) continue;*/
        final result = tagsLookup[epc.toUpperCase()];
        if (result == null) continue;
        final payload = result['payload'] as Map<String, dynamic>?;
        final kind = payload?['kind']?.toString();
        final type = payload?['type']?.toString();
        var category = result['category']?.toString();
        if (category == 'bullion') {
          category = 'سبائك';
        }

        if (!selectedDepartments.contains(kind) &&
            !selectedDepartments.contains(type) &&
            !selectedDepartments.contains(category)) {
          continue; // ⛔ تخطى العملية بالكامل
        }

        if (!epcs.contains(epc) &&
            !epcs.contains(result['epcHex']) &&
            !epcs.contains(result['qrCode'])) {
          /*setState(() {
            epcs.add(epc);
            itemsData[epc] = result;
          });*/
          _pendingEpcs.add(epc);
          itemsData[epc] = result;
          _calculateScannedDepartmentsCount();

          /*final itemData = await FS.findItemByEpc(epc);
          if (!mounted) return;
          setState(() {
            itemsData[epc] = itemData;
          });*/
        }
      }
    });

    SeuicUhfService.open();
  }

  Future<void> GetAllEpcAndQr() async {
    final allTags = await FS.getAllEpcAndQr();
    tagsLookup = {};

    for (var item in allTags) {
      final epc = item['epcHex']?.toString();
      final qr = item['qrCode']?.toString().toUpperCase();

      if (epc != null) {
        tagsLookup[epc] = item;
      }

      if (qr != null) {
        tagsLookup[qr] = item;
      }
    }

    setState(() {
      AllTags = allTags;
    });
  }

  Future<void> _loadDepartments() async {
    final snapshot = await FS.itemsCol().get();

    final Set<String> kinds = {};
    kinds.add("سبائك");

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final payload = data['payload'] ?? {};

      if (payload['kind'] != null && payload['kind'].toString().isNotEmpty) {
        kinds.add(payload['kind']);
      }

      if (payload['type'] != null && payload['type'].toString().isNotEmpty) {
        kinds.add(payload['type']);
      }
    }

    setState(() {
      allDepartments = kinds.toList();
    });
  }

  void _showDepartmentsDialog() async {
    await _loadDepartments();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t("اختر الأقسام", "Select Departments")),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: allDepartments.map((dept) {
                    final isSelected = selectedDepartments.contains(dept);

                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(dept),
                      onChanged: (value) {
                        setDialogState(() {
                          if (value == true) {
                            selectedDepartments.add(dept);
                          } else {
                            selectedDepartments.remove(dept);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(_t("إلغاء", "Cancel")),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // يحدث الشاشة الرئيسية
                    Navigator.pop(context);
                    _calculateDepartmentsCountFromLocal();
                  },
                  child: Text(_t("حفظ", "Save")),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _calculateDepartmentsCountFromLocal() {
    if (selectedDepartments.isEmpty) {
      setState(() => departmentsCount.clear());
      return;
    }

    final selectedSet = selectedDepartments.toSet();

    Map<String, Map<String, dynamic>> tempCounts = {
      for (var dept in selectedDepartments)
        dept: {
          "count": 0,
          "weight": 0.0,
        }
    };

    for (var item in AllTags) {
      final payload = item['payload'] as Map<String, dynamic>?;
      if (payload == null) continue;

      final kind = payload['kind']?.toString();
      final type = payload['type']?.toString();
      if (item['category'] == "bullion" && selectedSet.contains('سبائك')) {
        tempCounts['سبائك']!["count"]++;
        tempCounts['سبائك']!["weight"] +=
            double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      }

      if (kind != null && selectedSet.contains(kind)) {
        tempCounts[kind]!["count"]++;
        tempCounts[kind]!["weight"] +=
            double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;
      }

      if (type != null && selectedSet.contains(type)) {
        tempCounts[type]!["count"]++;
      }
    }

    setState(() {
      departmentsCount = tempCounts;
    });
  }

  void _calculateScannedDepartmentsCount() {
    Map<String, Map<String, dynamic>> tempCounts = {};
    void addDept(String dept, double weight) {
      tempCounts.putIfAbsent(
        dept,
        () => {
          "count": 0,
          "weight": 0.0,
        },
      );

      tempCounts[dept]!["count"]++;
      tempCounts[dept]!["weight"] += weight;
    }

    for (var item in itemsData.values) {
      if (item == null) continue;

      final payload = item['payload'] as Map<String, dynamic>?;
      if (payload == null) continue;
      final weight = double.tryParse(payload['weight']?.toString() ?? "0") ?? 0;

      final category = item['category']?.toString();
      print("CATEGORY: $category");

      final kind = payload['kind']?.toString();
      final type = payload['type']?.toString();
      if (category == 'bullion') {
        addDept('سبائك', weight);
      }

      if (kind != null) {
        addDept(kind, weight);
      }

      if (type != null) {
        addDept(type, weight);
      }
    }

    setState(() {
      scannedDepartmentsCount = tempCounts;
    });
  }

  Map<String, double> _calculateRegisteredCaratWeights() {
    Map<String, double> result = {
      '18': 0,
      '21': 0,
      '22': 0,
    };

    for (var item in AllTags) {
      final payload = item['payload'] as Map<String, dynamic>?;
      if (payload == null) continue;

      final carat = payload['carat']?.toString() ?? '';

      if (carat == '18' || carat == '21' || carat == '22') {
        final weight =
            double.tryParse(payload['weight']?.toString() ?? '0') ?? 0;

        result[carat] = result[carat]! + weight;
      }
    }

    return result;
  }

  Map<String, double> _calculateScannedCaratWeights() {
    Map<String, double> result = {
      '18': 0,
      '21': 0,
      '22': 0,
    };

    for (var item in itemsData.values) {
      if (item == null) continue;

      final payload = item['payload'] as Map<String, dynamic>?;
      if (payload == null) continue;

      final carat = payload['carat']?.toString() ?? '';

      if (carat == '18' || carat == '21' || carat == '22') {
        final weight =
            double.tryParse(payload['weight']?.toString() ?? '0') ?? 0;

        result[carat] = result[carat]! + weight;
      }
    }

    return result;
  }

  Map<String, List<Map<String, dynamic>>> missingByDepartment = {};

  void _calculateMissingItems() {
    missingByDepartment.clear();

    if (selectedDepartments.isEmpty) return;

    final selectedSet = selectedDepartments.toSet();
    final scannedEpcs = itemsData.keys.toSet();

    for (var item in AllTags) {
      final epc = item['epcHex']?.toString().toUpperCase();
      if (epc == null) continue;

      final payload = item['payload'] as Map<String, dynamic>?;
      final QR = payload?['qrCode']?.toString();
      if (payload == null) continue;

      final kind = payload['kind']?.toString();
      final type = payload['type']?.toString();
      final category = item['category']?.toString().toLowerCase();

      String? department;

      // تحديد القسم
      if (category == 'bullion' && selectedSet.contains('سبائك')) {
        department = 'سبائك';
      } else if (kind != null && selectedSet.contains(kind)) {
        department = kind;
      } else if (type != null && selectedSet.contains(type)) {
        department = type;
      }

      if (department == null) continue;

      // لو مش متجرد يبقى مفقود
      if (!scannedEpcs.contains(epc) && !scannedEpcs.contains(QR)) {
        missingByDepartment.putIfAbsent(department, () => []);
        missingByDepartment[department]!.add(item);
      }
    }

    setState(() {});
  }

  void _showMissingDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            child: SizedBox(
              height: 600,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: missingByDepartment.entries.map((entry) {
                  final department = entry.key;
                  final items = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$department (${items.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...items.map((item) {
                        final payload =
                            item['payload'] as Map<String, dynamic>? ?? {};

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// البيانات
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (item['epcHex'] != null &&
                                          item['epcHex'].toString().isNotEmpty)
                                        Text("رقم الشريحة: ${item['epcHex']}"),
                                      if (payload['carat'] != null &&
                                          payload['carat']
                                              .toString()
                                              .isNotEmpty)
                                        Text("العيار: ${payload['carat']}"),
                                      if (payload['size'] != null &&
                                          payload['size'].toString().isNotEmpty)
                                        Text("المقاس: ${payload['size']}"),
                                      if (payload['weight'] != null)
                                        Text("الوزن: ${payload['weight']}"),
                                      if (payload['wage'] != null)
                                        Text("الاجر: ${payload['wage']}"),
                                      if (payload['notes'] != null)
                                        Text("الملاحظات: ${payload['notes']}"),
                                      if (item['createdAt'] != null)
                                        Text(
                                            "تاريخ الادخال: ${_formatDate(item['createdAt'])}"),
                                      if (payload['qrCode'] != null &&
                                          payload['qrCode']
                                              .toString()
                                              .isNotEmpty)
                                        Text("الكود: ${payload['qrCode']}"),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                /// الكود + زر الصور
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// QR او Barcode
                                    if (payload['qrCode'] != null &&
                                        payload['qrCode'].toString().isNotEmpty)
                                      payload['showQr'] == true
                                          ? QrImageView(
                                              data: payload['qrCode'],
                                              size: 70,
                                            )
                                          : BarcodeWidget(
                                              barcode: Barcode.code128(),
                                              data: payload['qrCode'],
                                              width: 100,
                                              height: 40,
                                              drawText: false,
                                            ),

                                    const SizedBox(height: 8),

                                    /// زر الصور
                                    if (item['epcHex'] != null)
                                      IconButton(
                                        iconSize: 45,
                                        icon: const Icon(Icons.image,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final epcHex = item['epcHex'];
                                          final uid = FirebaseAuth
                                              .instance.currentUser!.uid;

                                          final storageRef = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child('images')
                                              .child('users')
                                              .child(uid)
                                              .child(epcHex);

                                          try {
                                            final result =
                                                await storageRef.listAll();

                                            if (result.items.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "لا يوجد صور محفوظة")),
                                              );
                                              return;
                                            }

                                            final urls = await Future.wait(
                                              result.items.map((ref) =>
                                                  ref.getDownloadURL()),
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (_) => Dialog(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
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
                                                          height: 10),
                                                      SizedBox(
                                                        height: 350,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              urls.length,
                                                          itemBuilder: (_, i) =>
                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.9),
                                                                  builder: (_) =>
                                                                      GestureDetector(
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                    child:
                                                                        Dialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      insetPadding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              10),
                                                                      child:
                                                                          InteractiveViewer(
                                                                        minScale:
                                                                            0.8,
                                                                        maxScale:
                                                                            4,
                                                                        child: Image.network(
                                                                            urls[
                                                                                i],
                                                                            fit:
                                                                                BoxFit.contain),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: Image
                                                                    .network(
                                                                  urls[i],
                                                                  width: 250,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child:
                                                            const Text("إغلاق"),
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
                                                      Text("فشل تحميل الصور")),
                                            );
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return "";

    final date = timestamp.toDate(); // تحويل من Timestamp لـ DateTime

    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  void _showNoMissingDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.verified,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 12),
              Text(
                "لا يوجد عناصر مفقودة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "تم جرد جميع العناصر بنجاح",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً"),
            )
          ],
        );
      },
    );
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadSavedReaderPower() async {
    final prefs = await SharedPreferences.getInstance();
    final powerJson = prefs.getString('pagePowers');

    if (powerJson != null) {
      final Map<String, dynamic> pagePowers =
          Map<String, dynamic>.from(json.decode(powerJson));

      final savedPower = pagePowers['inventoryDepartment'];
      if (savedPower != null) {
        setState(() {
          _readerPower = savedPower;
          _tempPower = savedPower;
        });

        // تطبيق القوة فعليًا على القارئ
        await SeuicUhfService.setPower(savedPower);
      }
    }
  }

  /*void _showPowerSheet() {
    _tempPower = _readerPower;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _t('قوة قارئ RFID', 'RFID Reader Power'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '${_tempPower} dBm',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  Slider(
                    min: 1,
                    max: 33,
                    divisions: 25,
                    value: _tempPower.toDouble(),
                    label: _tempPower.toString(),
                    onChanged: (v) {
                      setModalState(() {
                        _tempPower = v.round();
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(_t('إلغاء', 'Cancel')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                          ),
                          onPressed: () async {
                            setState(() {
                              _readerPower = _tempPower;
                            });

                            // تطبيق القوة فورًا
                            await SeuicUhfService.setPower(_readerPower);

                            // حفظها للصفحة
                            final prefs = await SharedPreferences.getInstance();
                            final powerJson = prefs.getString('pagePowers');
                            Map<String, int> pagePowers = {};

                            if (powerJson != null) {
                              pagePowers = Map<String, int>.from(json.decode(powerJson));
                            }

                            pagePowers['inventoryDepartment'] = _readerPower;
                            await prefs.setString('pagePowers', json.encode(pagePowers));

                            Navigator.pop(context);
                            showAppMessage(context, _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'));

                          },
                          child: Text(_t('حفظ', 'Save')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }*/
  void showAppMessage(BuildContext context, String msg) {
    final isSuccess = msg.contains('تمت') ||
        msg.contains('تم') ||
        msg.contains('written') ||
        msg.contains('Saved');

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Text(msg),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadItemsCount() async {
    final count = await FS.getItemsCount();
    setState(() {
      itemsCount = count;
    });
  }

  Future<void> _saveInventory() async {
    if (epcs.isEmpty) {
      setState(() => msg = _t(
          'يجب قراءة شريحة واحدة على الأقل', 'At least one chip must be read'));

      return;
    }

    setState(() {
      busy = true;
      msg = null;
      saveProgress = 0.0;
      savedCount = 0;
    });
    // ✅ تشغيل وضع إبقاء الشاشة مفتوحة
    await WakelockPlus.enable();

    try {
      final total = epcs.length;
      int done = 0;
      for (final epc in epcs) {
        final itemData = itemsData[epc]; // ✅ البيانات الخاصة بالشريحة
        if (itemData != null && itemData.isNotEmpty) {
          await FS.upsertInventory(
              itemData['epcHex'], itemData); // ✅ ابعتها مع الحفظ
        }
        done++;
        setState(() {
          savedCount = done;
          saveProgress = done / total;
        });
      }
      setState(() {
        msg = _t('تم حفظ عملية جرد بنجاح', 'Inventory saved successfully');
        epcs.clear();
        itemsData.clear();
        saveProgress = 1.0;
      });
    } catch (e) {
      setState(() => msg = _t('فشل الحفظ: $e', 'Save failed: $e'));
    } finally {
      // ✅ إيقاف إبقاء الشاشة بعد الانتهاء
      await WakelockPlus.disable();
      setState(() => busy = false);
    }
  }

  // ✅ حساب الإجماليات
  /*Map<String, dynamic> _calculateTotals() {
    double totalWeight = 0;
    double totalWage = 0;
    double totalCost = 0;

    double bullionWeight = 0;
    double bullionWage = 0;
    int bullionCount = 0;

    double carat18 = 0, carat18Wage = 0;
    int carat18Count = 0;

    double carat21 = 0, carat21Wage = 0;
    int carat21Count = 0;

    double carat22 = 0, carat22Wage = 0;
    int carat22Count = 0;

    double scrapWeight = 0;
    double scrapWage = 0;
    int scrapCount = 0;

    int gemsCount = 0;
    double gemsCost = 0;

    for (var item in itemsData.values) {
      if (item == null) continue;
      final payload = (item['payload'] as Map<String, dynamic>?) ?? {};
      final category = item['category'] as String?;

      if (category == 'gold') {
        final weight = (payload['weight'] ?? 0).toDouble();
        final wage = (payload['wage'] ?? 0).toDouble();
        final carat = payload['carat']?.toString();

        totalWeight += weight;
        totalWage += wage;

        if (carat == '18') {
          carat18 += weight;
          carat18Wage += wage;
          carat18Count++;
        }
        if (carat == '21') {
          carat21 += weight;
          carat21Wage += wage;
          carat21Count++;
        }
        if (carat == '22') {
          carat22 += weight;
          carat22Wage += wage;
          carat22Count++;
        }
      } else if (category == 'gem') {
        final cost = (payload['cost'] ?? 0).toDouble();
        totalCost += cost;
        gemsCost += cost;
        gemsCount++;
      } else if (category == 'scrap') {
        final weight = (payload['weight'] ?? 0).toDouble();
        final wage = (payload['wage'] ?? 0).toDouble();
        scrapWeight += weight;
        scrapWage += wage;
        scrapCount++;
        totalWeight += weight;
      } else if (category == 'bullion') {
        final weight = (payload['weight'] ?? 0).toDouble();
        final wage = (payload['wage'] ?? 0).toDouble();
        totalWeight += weight;
        totalWage += wage;
        bullionWeight += weight;
        bullionWage += wage;
        bullionCount++;
      }
    }

    return {
      'count': itemsData.values.where((item) => item != null).length,
      'totalWeight': totalWeight,
      'totalWage': totalWage,
      'totalCost': totalCost,
      'bullionWeight': bullionWeight,
      'bullionWage': bullionWage,
      'bullionCount': bullionCount,
      'carat18': carat18,
      'carat18Wage': carat18Wage,
      'carat18Count': carat18Count,
      'carat21': carat21,
      'carat21Wage': carat21Wage,
      'carat21Count': carat21Count,
      'carat22': carat22,
      'carat22Wage': carat22Wage,
      'carat22Count': carat22Count,
      'scrapWeight': scrapWeight,
      'scrapWage': scrapWage,
      'scrapCount': scrapCount,
      'gemsCount': gemsCount,
      'gemsCost': gemsCost,
    };
  }
  double _percent(int value,int totalcount) {
    if (totalcount == 0) return 0;
    return (value / totalcount) * 100;
  }
  Widget _caratRow(String title, int count,int totalcount, Color color) {
    final percent = _percent(count,totalcount);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style:  TextStyle(color: color,fontWeight: FontWeight.bold)),
              Text(
                '${count.toStringAsFixed(0)}   •  ${percent.toStringAsFixed(1)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: color.withOpacity(.15),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
    );
  }
  Widget sectionCard(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    final totals = _calculateTotals();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // 👈 على اليمين
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("📊 الإجماليات", "Totals"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const Divider(),
              sectionCard(
                'توزيع الاقسام حسب عدد الشرائح',
                Column(
                  children: [
                    _caratRow(
                      'عيار 18',
                      totals['carat18Count']!,
                      totals['count'],
                      Colors.orange,
                    ),
                    _caratRow(
                      'عيار 21',
                      totals['carat21Count']!,
                      totals['count'],
                      Colors.green,
                    ),
                    _caratRow(
                      'عيار 22',
                      totals['carat22Count']!,
                      totals['count'],
                      Colors.blueAccent,
                    ),
                    _caratRow(
                      'سبائك',
                      totals['gemsCount']!,
                      totals['count'],
                      Colors.red,
                    ),
                    _caratRow(
                      'احجار',
                      totals['gemsCount']!,
                      totals['count'],
                      Colors.purple,
                    ),


                  ],
                ),
              ),
              const Divider(),

              // 🟢 الملخص العام
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("📌 الملخص العام", "📌 General Summary"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('إجمالي عدد الشرائح', 'Total number of chips'),
                totals['count'].toString(),
              ),
              _buildDetailRow(
                Icons.scale,
                _t('إجمالي الوزن الكلي', 'Total weight'),
                '${totals['totalWeight'].toStringAsFixed(2)} ${_t('جم', 'g')}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي الأجر الكلي', 'Total wage'),
                '${totals['totalWage'].toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي التكلفة الكلية', 'Total cost'),
                '${totals['totalCost'].toStringAsFixed(2)}',
              ),

              const Divider(),

              // 🟢 عيار 18
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("⭐ عيار 18", "⭐ Carat 18"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('عدد الشرائح', 'Number of chips'),
                totals['carat18Count'].toString(),
              ),
              _buildDetailRow(
                Icons.scale,
                _t('إجمالي الوزن', 'Total weight'),
                '${totals['carat18'].toStringAsFixed(2)} ${_t('جم', 'g')}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي الأجر', 'Total wage'),
                '${totals['carat18Wage'].toStringAsFixed(2)}',
              ),

              const Divider(),

              // 🟢 عيار 21
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("⭐ عيار 21", "⭐ Carat 21"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('عدد الشرائح', 'Number of chips'),
                totals['carat21Count'].toString(),
              ),
              _buildDetailRow(
                Icons.scale,
                _t('إجمالي الوزن', 'Total weight'),
                '${totals['carat21'].toStringAsFixed(2)} ${_t('جم', 'g')}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي الأجر', 'Total wage'),
                '${totals['carat21Wage'].toStringAsFixed(2)}',
              ),

              const Divider(),

              // 🟢 عيار 22
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("⭐ عيار 22", "⭐ Carat 22"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('عدد الشرائح', 'Number of chips'),
                totals['carat22Count'].toString(),
              ),
              _buildDetailRow(
                Icons.scale,
                _t('إجمالي الوزن', 'Total weight'),
                '${totals['carat22'].toStringAsFixed(2)} ${_t('جم', 'g')}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي الأجر', 'Total wage'),
                '${totals['carat22Wage'].toStringAsFixed(2)}',
              ),

              const Divider(),

              // 🟢 السبائك
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("🏅 السبائك", "🏅 Bullions"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('عدد الشرائح', 'Number of chips'),
                totals['bullionCount'].toString(),
              ),
              _buildDetailRow(
                Icons.scale,
                _t('إجمالي الوزن', 'Total weight'),
                '${totals['bullionWeight'].toStringAsFixed(2)} ${_t('جم', 'g')}',
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي الأجر', 'Total wage'),
                '${totals['bullionWage'].toStringAsFixed(2)}',
              ),

              const Divider(),

              // 🟢 الأحجار
              SizedBox(
                width: double.infinity,
                child: Text(
                  _t("💎 الأحجار", "💎 Gems"),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              _buildDetailRow(
                Icons.format_list_numbered,
                _t('عدد الشرائح (أحجار)', 'Number of chips (Gems)'),
                totals['gemsCount'].toString(),
              ),
              _buildDetailRow(
                Icons.attach_money,
                _t('إجمالي التكلفة', 'Total cost'),
                '${totals['gemsCost'].toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildItemDetailsCard() {
    return Expanded(
      child: ListView(
        children: [
          _buildTotalsCard(), // ✅ يظهر في الأول
          ...epcs.where((epc) => itemsData[epc] != null).map((epc) {
            final itemData = itemsData[epc]!;
            return Card(
              color: Colors.black,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.qr_code, color: Color(0xFFD4AF37)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'EPC: $epc',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              epcs.remove(epc);
                              itemsData.remove(epc);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildItemDetails(itemData),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  Widget _buildCodeWithImages(
      BuildContext context,
      Map<String, dynamic> payload,
      String epcHex,
      ) {
    if (payload['qrCode'] == null) {
      return _buildDetailRow(
        Icons.qr_code_2,
        _t('الكود', 'Code'),
        _t('غير محدد', 'Not specified'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // QR أو Barcode
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: payload['showQr'] == true
                ? QrImageView(
              data: payload['qrCode'],
              version: QrVersions.auto,
              size: 90,
            )
                : BarcodeWidget(
              barcode: Barcode.code128(),
              data: payload['qrCode'],
              width: 120,
              height: 45,
            ),
          ),

          const SizedBox(width: 16),

          // زرار عرض الصور
          GestureDetector(
            onTap: () async {
              final uid = FirebaseAuth.instance.currentUser!.uid;
              final storageRef = FirebaseStorage.instance
                  .ref()
                  .child('images')
                  .child('users')
                  .child(uid)
                  .child(epcHex.toUpperCase());

              try {
                final result = await storageRef.listAll();
                if (result.items.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text(_t('لا يوجد صور محفوظة', 'No saved images')),
                    ),
                  );
                  return;
                }

                final urls = await Future.wait(
                  result.items.map((e) => e.getDownloadURL()),
                );

                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _t('صور الشريحة', 'Chip Images'),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: urls.length,
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.all(6),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.9),
                                    builder: (_) => GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Dialog(
                                        backgroundColor: Colors.transparent,
                                        insetPadding: const EdgeInsets.all(10),
                                        child: InteractiveViewer(
                                          minScale: 0.8,
                                          maxScale: 4,
                                          child: Image.network(urls[i], fit: BoxFit.contain),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    urls[i],
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(_t('إغلاق', 'Close')),
                        )
                      ],
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_t(
                        'فشل تحميل الصور', 'Failed to load images')),
                  ),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.image,
                      color: Colors.white, size: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  _t('عرض الصور', 'View Images'),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }



  Widget _buildItemDetails(Map<String, dynamic> itemData) {
    final payload = (itemData['payload'] as Map<String, dynamic>?) ?? {};
    final category = itemData['category'] as String?;

    if (category == 'gold') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.workspace_premium, _t('التصنيف', 'Category'), _t('ذهب', 'Gold')),
            _buildDetailRow(Icons.grade, _t('العيار', 'Carat'),
                payload['carat']?.toString() ?? _t('غير محدد', 'Not specified')),
            _buildDetailRow(Icons.scale, _t('الوزن', 'Weight'),
                payload['weight'] != null ? '${payload['weight']} جم' : _t('غير محدد', 'Not specified')),
            if (payload['wage'] != null)
              _buildDetailRow(Icons.attach_money, _t('الأجر', 'Wage'), payload['wage'].toString()),
            if (payload['size'] != null)
              _buildDetailRow(
                Icons.photo_size_select_small_sharp,
                _t('المقاس', 'size'),
                payload['size'].toString(),
              ),
            _buildDetailRow(Icons.qr_code_2, _t('الكود', 'Code'),
                payload['qrCode']?.toString() ?? _t('غير محدد', 'Not specified')),
            _buildCodeWithImages(context, payload, itemData['epcHex']),
          ],
        ),
      );

    } else if (category == 'gem') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.diamond,
              _t('التصنيف', 'Category'),
              _t('أحجار كريمة', 'Gemstones'),
            ),
            _buildDetailRow(
              Icons.auto_awesome,
              _t('نوع الحجر', 'Stone Type'),
              payload['type']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildDetailRow(
              Icons.attach_money,
              _t('التكلفة', 'Cost'),
              payload['cost']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildDetailRow(
              Icons.qr_code_2,
              _t('الكود', 'Code'),
              payload['qrCode']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildCodeWithImages(context, payload, itemData['epcHex']),
          ],
        ),
      );

    } else if (category == 'scrap') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.recycling,
              _t('التصنيف', 'Category'),
              _t('كسر', 'Scrap'),
            ),
            _buildDetailRow(
              Icons.grade,
              _t('العيار', 'Carat'),
              payload['carat']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildDetailRow(
              Icons.scale,
              _t('الوزن', 'Weight'),
              payload['weight'] != null
                  ? '${payload['weight']} g'
                  : _t('غير محدد', 'Not specified'),
            ),
            if (payload['wage'] != null)
              _buildDetailRow(
                Icons.attach_money,
                _t('الأجر', 'Wage'),
                payload['wage'].toString(),
              ),
            _buildDetailRow(
              Icons.qr_code_2,
              _t('الكود', 'Code'),
              payload['qrCode']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildCodeWithImages(context, payload, itemData['epcHex']),
          ],
        ),
      );

    } else if (category == 'bullion') {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.workspace_premium,
              _t('التصنيف', 'Category'),
              _t('سبائك', 'Bullion'),
            ),
            _buildDetailRow(
              Icons.scale,
              _t('الوزن', 'Weight'),
              payload['weight'] != null
                  ? '${payload['weight']} g'
                  : _t('غير محدد', 'Not specified'),
            ),
            if (payload['wage'] != null)
              _buildDetailRow(
                Icons.attach_money,
                _t('الأجر', 'Wage'),
                payload['wage'].toString(),
              ),

            _buildDetailRow(
              Icons.qr_code_2,
              _t('الكود', 'Code'),
              payload['qrCode']?.toString() ?? _t('غير محدد', 'Not specified'),
            ),
            _buildCodeWithImages(context, payload, itemData['epcHex']),
          ],
        ),
      );

    }


    return Text(
      _t('تفاصيل غير متوفرة', 'Details not available'),
      style: const TextStyle(color: Colors.grey),
    );

  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white))),
        ],
      ),
    );
  }
  void _showMsg(String text, bool success) {
    setState(() {
      msg = success ? '✅ $text' : '❌ $text';
    });
    // اختفاء الرسالة بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => msg = null);
    });
  }*/
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

  /*void _addEpc(String epc)  async{
    //epc = epc.trim().toUpperCase();

    if (epc.isEmpty) return;

    final result = await FS.epcandcode(epc);
    print(epcs);

    if (epcs.contains(epc) && epcs.contains(epc.trim().toUpperCase()) && epcs.contains(result?['epcHex'] ) || epcs.contains(result?['qrCode'] )) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t("تمت اضافة الشريحة من قبل", "Tag already added"))),
      );
      return;
    }

    if (!epcs.contains(epc)) {
      setState(() {
        epcs.add(epc);
      });

      final itemData = await FS.findItemByEpc(epc);
      if (!mounted) return;
      setState(() {
        itemsData[epc] = itemData;
      });
    }
  }*/
  void AddEpcManualy(String Epc) {
    SeuicUhfService.addEpcManualy(Epc);
  }

  @override
  Widget build(BuildContext context) {
    final registeredCarats = _calculateRegisteredCaratWeights();
    final scannedCarats = _calculateScannedCaratWeights();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_t('جرد الاقسام', 'Inventory Departments')),
        backgroundColor: const Color(0xFFD4AF37),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: _t('قوة القارئ', 'Reader Power'),
            onPressed: _showPowerSheet,
          ),
        ],*/
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4AF37),
        tooltip: _t("إدخال شريحة يدوي", "Manual Tag"),
        onPressed: _showManualEpcDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (msg != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    msg!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // يخلي النص دايمًا في اليمين
                children: [
                  if (busy)
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(
                            value: saveProgress,
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(saveProgress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16), // مسافة بسيطة قبل العداد
                      ],
                    ),
                  Text(
                    "${_t("كل العناصر المسجلة مسبقا", "Previously registered items")}: $itemsCount",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.category, color: Colors.white),
                onPressed: _showDepartmentsDialog,
                label: Text(
                  _t("اختيار الأقسام", "Select Departments"),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              if (departmentsCount.isNotEmpty) const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(),
                child: Text(
                  _t("عدد الاقسام المسجة مسبقا", "Number of dept existed"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: departmentsCount.entries.map((entry) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD4AF37)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.category,
                              size: 18, color: Color(0xFFD4AF37)),
                          const SizedBox(width: 6),
                          Text(
                            "${entry.key}\n${entry.value['count']} قطعة\n${entry.value['weight'].toStringAsFixed(2)} جم",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              if (scannedDepartmentsCount.isNotEmpty)
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        _t("العناصر التي تم جردها حسب القسم",
                            "Items inventoried by category"),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 الكروت
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: scannedDepartmentsCount.entries.map((entry) {
                        final count = entry.value['count'];
                        final weight = entry.value['weight'];

                        return Container(
                          width: 130,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                            border: Border.all(
                              color: const Color(0xFFD4AF37),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.inventory_2,
                                color: Color(0xFFD4AF37),
                                size: 20,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Column(
                                children: [
                                  Text(
                                    "$count قطعة",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    "${weight.toStringAsFixed(2)} جم",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: [
                                for (final carat in ['18', '21', '22'])
                                  SizedBox(
                                    width: 110,
                                    child: Card(
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "عيار $carat",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "المسجل",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              "${registeredCarats[carat]!.toStringAsFixed(2)} جم",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "المجرود",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              "${scannedCarats[carat]!.toStringAsFixed(2)} جم",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.warning, color: Colors.white),
                label: const Text(
                  "عرض المفقود",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _calculateMissingItems();

                  if (missingByDepartment.isEmpty) {
                    _showNoMissingDialog();
                  } else {
                    _showMissingDialog();
                  }
                },
              ),

              //_buildItemDetailsCard(),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                onPressed: busy ? null : _saveInventory,
                label: Text(
                  busy
                      ? _t("جارٍ الحفظ...", "Saving...")
                      : _t("حفظ في الجرد", "Save Inventory"),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
