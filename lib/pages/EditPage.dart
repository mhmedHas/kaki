import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import '../utils/image_compressor.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
//import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  StreamSubscription<String>? _tagSubscription;
  String epcHex = '';
  bool isReading = false;
  bool busy = false; // للتحميل العام (رفع صور أو حفظ بيانات)
  String? msg;

  Map<String, dynamic>? itemData;
  String? category;
  List<String> currentImages = [];
  final List<String> typeOptions = [
    'خاتم',
    'اسورة',
    'خاتم و اسورة',
    'بنجرة',
    'حلق',
    'خلخال',
    'تعليقة',
    'حزام',
    'تاج',
    'كف',
    'عقد',
    'انسيال',
    'سلسال',
    'شوكر',
    'طوق',
    'مخنق',
    'سبحة',
    'طقم',
    'طقم هافست',
    'غير ذلك'
  ];

  String? selectedGoldType = '';
  bool showSetComponents = false;
  List<String> selectedSetComponents = [];
  List<String> get setComponentOptions => typeOptions
      .where(
        (type) => type != 'طقم' && type != 'طقم هافست',
      )
      .toList();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  final Map<String, TextEditingController> controllers = {
    "carat": TextEditingController(),
    "weight": TextEditingController(),
    "wage": TextEditingController(),
    "qrCode": TextEditingController(),
    "type": TextEditingController(),
    "cost": TextEditingController(),
    "notes": TextEditingController(),
    "EPC": TextEditingController(),
    "entryDate": TextEditingController(),
    "size": TextEditingController(),
  };

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  // متغيرات تحديد قوة القارئ
  int _readerPower = 26; // القيمة الحالية
  int _tempPower = 26; // قيمة السلايدر المؤقتة

  void _resetPage() {
    setState(() {
      epcHex = '';
      itemData = null;
      category = null;
      msg = null;
      currentImages.clear();
      selectedImage = null;

      for (var c in controllers.values) {
        c.clear();
      }

      selectedGoldType = '';
      selectedSetComponents.clear();
      showSetComponents = false;
    });
  }
  /*static const MethodChannel debugChannel = MethodChannel("debug/channel");

  final List<String> debugLogs = [];

  void addDebug(String msg) {
    if (!mounted) return;

    setState(() {
      debugLogs.insert(
        0,
        "${DateTime.now().toString().substring(11, 19)}  $msg",
      );

      if (debugLogs.length > 40) {
        debugLogs.removeLast();
      }
    });
  }*/

  @override
  void initState() {
    super.initState();
    _resetPage();

    //SeuicUhfService.sendBoolean(false);
    _loadLanguage();
    //_setPagePower();
    //_loadSavedReaderPower();

    _tagSubscription = SeuicUhfService.tagStream.listen((tag) {
      if (mounted) {
        setState(() {
          epcHex = tag;
          isReading = false;
        });
        _loadItemData();
      }
    });
    /*debugChannel.setMethodCallHandler((call) async {
      if (call.method == "debug") {
        addDebug(call.arguments.toString());
      }
    });*/

    SeuicUhfService.open();
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

      final savedPower = pagePowers['edit'];
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

  void _showPowerSheet() {
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_tempPower dBm',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
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
                              pagePowers =
                                  Map<String, int>.from(json.decode(powerJson));
                            }

                            pagePowers['edit'] = _readerPower;
                            await prefs.setString(
                                'pagePowers', json.encode(pagePowers));

                            Navigator.pop(context);

                            /*_showMsg(
                              _t('تم ضبط قوة القارئ بنجاح', 'Reader power updated'),
                              true,
                            );*/
                            showAppMessage(
                                context,
                                _t('تم ضبط قوة القارئ بنجاح',
                                    'Reader power updated'));
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
  }

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
    _resetPage();
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _readChip() async {
    setState(() => isReading = true);
    try {
      final result = await SeuicUhfService.inventoryOnce();
      if (result == null || result.isEmpty) {
        _showMsg(_t('لم يتم العثور على شريحة', 'No tag found'), false);
        setState(() => isReading = false);
        return;
      }
      setState(() {
        epcHex = result.toUpperCase();
        isReading = false;
      });
      _loadItemData();
    } catch (e) {
      _showMsg(_t('خطأ في قراءة الشريحة: $e', 'Error reading tag: $e'), false);
      setState(() => isReading = false);
    }
  }

  Future<void> _loadItemData() async {
    if (epcHex.isEmpty) return;
    setState(() => busy = true);
    try {
      final data = await FS.findItemByEpc(epcHex);
      if (data == null) {
        _showMsg(
            _t("الشريحة غير موجودة تأكد من صحة البيانات",
                "Epc not exist, ensure existing data"),
            false);
        return;
      }
      setState(() {
        itemData = data;
        category = data['category'];
        currentImages = List<String>.from(data['images'] ?? []);
      });

      if (data['payload'] != null) {
        final p = data['payload'];
        controllers["carat"]!.text = p['carat']?.toString() ?? '';
        controllers["weight"]!.text = p['weight']?.toString() ?? '';
        controllers["wage"]!.text = p['wage']?.toString() ?? '';
        controllers["qrCode"]!.text = p['qrCode']?.toString() ?? '';
        controllers["type"]!.text = p['type']?.toString() ?? '';
        controllers["cost"]!.text = p['cost']?.toString() ?? '';
        controllers["notes"]!.text = p['notes']?.toString() ?? '';
        controllers["EPC"]!.text = data['epcHex']?.toString() ?? '';
        controllers["size"]!.text = p['size']?.toString() ?? '';
        selectedGoldType = p['kind']?.toString() ?? '';
        selectedSetComponents = p['setComponents'];

        // Load entry date from createdAt
        final createdAt = data['createdAt'];
        if (createdAt != null) {
          final date = createdAt is Timestamp
              ? createdAt.toDate()
              : DateTime.tryParse(createdAt.toString());
          if (date != null) {
            controllers["entryDate"]!.text =
                "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
          }
        }
      }
      _showMsg(_t('تم تحميل البيانات بنجاح', 'Data loaded successfully'), true);
    } catch (e) {
      //_showMsg(_t("فشل تحميل البيانات: $e", "Failed to load data: $e"), false);
    } finally {
      setState(() => busy = false);
    }
  }

  // ==================== وظائف الصور ====================
  Future<void> _pickImage() async {
    final xFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (xFile != null) {
      setState(() => selectedImage = File(xFile.path));
    }
  }

  Future<void> _uploadOrReplaceImage({String? oldUrl}) async {
    if (selectedImage == null) {
      _showMsg(_t('اختر صورة أولاً', 'Select an image first'), false);
      return;
    }

    setState(() => busy = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final compressed = await compressImage(selectedImage!);
      if (compressed == null) {
        _showMsg(_t('فشل ضغط الصورة', 'Image compression failed'), false);
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(epcHex) // هنا epcHex من الـ state
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // نفس الـ metadata اللي شغال عندك في الإدخال
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public,max-age=300',
      );

      // رفع بنفس الطريقة بالظبط
      await storageRef.putFile(compressed, metadata);

      final url = await storageRef.getDownloadURL();

      // لو استبدال → نحذف القديمة من Firestore أولاً
      if (oldUrl != null) {
        await FS.updateItem(epcHex, {
          'images': FieldValue.arrayRemove([oldUrl]),
        });
        // وحذف من Storage كمان
        try {
          await FirebaseStorage.instance.refFromURL(oldUrl).delete();
        } catch (e) {
          print('تحذير: فشل حذف الصورة القديمة من Storage: $e');
        }
      }

      // نضيف الجديدة
      await FS.updateItem(epcHex, {
        'images': FieldValue.arrayUnion([url]),
      });

      setState(() {
        if (oldUrl != null) {
          currentImages.remove(oldUrl);
        }
        currentImages.add(url);
        selectedImage = null;
      });

      _showMsg(
        oldUrl != null
            ? _t('تم استبدال الصورة بنجاح', 'Image replaced successfully')
            : _t('تم رفع الصورة بنجاح', 'Image uploaded successfully'),
        true,
      );
    } catch (e, stack) {
      print('خطأ في رفع الصورة: $e');
      print(stack);
      _showMsg(_t('فشل رفع الصورة: $e', 'Upload failed: $e'), false);
    } finally {
      setState(() => busy = false);
    }
  }

  Future<void> _deleteImage(String url) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            title: Text(_t('تأكيد الحذف', 'Confirm Delete')),
            content: Text(_t('هل تريد حذف هذه الصورة نهائيًا؟',
                'Delete this image permanently?')),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(c, false),
                  child: Text(_t('لا', 'No'))),
              TextButton(
                  onPressed: () => Navigator.pop(c, true),
                  child: Text(_t('نعم', 'Yes'))),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    setState(() => busy = true);
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      await FS.updateItem(epcHex, {
        'images': FieldValue.arrayRemove([url])
      });
      setState(() => currentImages.remove(url));
      _showMsg(_t('تم حذف الصورة', 'Image deleted'), true);
    } catch (e) {
      _showMsg(_t('فشل حذف الصورة', 'Failed to delete image'), false);
    } finally {
      setState(() => busy = false);
    }
  }

  // ==================== حفظ التعديلات النصية ====================
  Future<void> _saveChanges() async {
    if (epcHex.isEmpty || itemData == null) {
      _showMsg(_t("اقرأ الشريحة أولاً", "Read the tag first"), false);
      return;
    }
    if (controllers["notes"]!.text.trim() == "") {
      _showMsg(_t("ادخل سبب التعديلً", "Enter the reason for the edit"), false);
      return;
    }

    setState(() => busy = true);

    try {
      final Map<String, dynamic> updates = {};

      switch (category) {
        case "gold":
          final w = double.tryParse(controllers["weight"]!.text) ?? 0;
          final wg = double.tryParse(controllers["wage"]!.text) ?? 0;
          updates.addAll({
            "epcHex": controllers["EPC"]!.text.toUpperCase().trim(),
            "payload.carat": controllers["carat"]!.text.trim(),
            "payload.kind": selectedGoldType,
            if (selectedGoldType == 'طقم' || selectedGoldType == 'طقم هافست')
              "payload.setComponents": selectedSetComponents,
            "payload.weight": w,
            "payload.wage": w * wg,
            "payload.qrCode": controllers["qrCode"]!.text.trim(),
            "payload.notes": controllers["notes"]!.text.trim(),
          });
          break;
        case "scrap":
          updates.addAll({
            "epcHex": controllers["EPC"]!.text.toUpperCase().trim(),
            "payload.carat": controllers["carat"]!.text.trim(),
            "payload.weight": double.tryParse(controllers["weight"]!.text) ?? 0,
            "payload.qrCode": controllers["qrCode"]!.text.trim(),
            "payload.notes": controllers["notes"]!.text.trim(),
          });
          break;
        case "bullion":
          final w = double.tryParse(controllers["weight"]!.text) ?? 0;
          final wg = double.tryParse(controllers["wage"]!.text) ?? 0;
          updates.addAll({
            "epcHex": controllers["EPC"]!.text.toUpperCase().trim(),
            "payload.weight": w,
            "payload.wage": w * wg,
            "payload.qrCode": controllers["qrCode"]!.text.trim(),
            "payload.notes": controllers["notes"]!.text.trim(),
          });
          break;
        case "gem":
          updates.addAll({
            "epcHex": controllers["EPC"]!.text.toUpperCase().trim(),
            "payload.type": controllers["type"]!.text.trim(),
            "payload.cost": double.tryParse(controllers["cost"]!.text) ?? 0,
            "payload.qrCode": controllers["qrCode"]!.text.trim(),
            "payload.notes": controllers["notes"]!.text.trim(),
          });
          break;
      }

      await FS.updateItem(epcHex, updates);

      _showMsg(
          _t("✅ تم حفظ التعديلات بنجاح", "✅ Changes saved successfully"), true);
    } catch (e) {
      _showMsg(
          _t("فشل حفظ التعديلات: $e", "Failed to save changes: $e"), false);
    } finally {
      setState(() => busy = false);
    }
  }

  void _showMsg(String text, bool success) {
    setState(() {
      msg = success ? '✅ $text' : '❌ $text';
    });
    // اختفاء الرسالة بعد 4 ثواني
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => msg = null);
    });
  }

  void _showFullImage(BuildContext context, String imageUrl) {
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
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    if (currentImages.isEmpty) {
      return Text(
        _t('لا توجد صور للقطعة', 'No images for this item'),
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: [
        // الصور الحالية - عرض فقط بدون تعديل
        if (currentImages.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: currentImages.map((url) {
              return GestureDetector(
                onTap: () => _showFullImage(context, url),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    url,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildForm() {
    if (category == null) return const SizedBox();

    switch (category) {
      case "gold":
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _showDeleteDialog(context, epcHex);
                },
                child: const Text(
                  'حذف الشريحة',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controllers["EPC"],
              decoration: InputDecoration(
                labelText: _t("رقم الشريحة", "EPC Number"),
                prefixIcon: const Icon(Icons.qr_code, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllers["entryDate"],
              decoration: InputDecoration(
                labelText: _t("تاريخ الإدخال", "Entry Date"),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["carat"],
                decoration: InputDecoration(labelText: _t("العيار", "Carat"))),
            const SizedBox(height: 16),
            //const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedGoldType,
              decoration: InputDecoration(
                labelText: _t('النوع', 'Type'),
                prefixIcon: Icon(Icons.category, color: Color(0xFFD4AF37)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              items: typeOptions.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGoldType = newValue;
                  showSetComponents =
                      newValue == 'طقم' || newValue == 'طقم هافست';

                  if (!showSetComponents) {
                    selectedSetComponents.clear();
                  }
                });
              },
            ),
            if (showSetComponents) ...[
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('مكونات الطقم', 'Set Components'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: setComponentOptions.map((component) {
                        final isSelected =
                            selectedSetComponents.contains(component);
                        return FilterChip(
                          label: Text(component),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedSetComponents.add(component);
                              } else {
                                selectedSetComponents.remove(component);
                              }
                            });
                          },
                          selectedColor:
                              const Color(0xFFD4AF37).withOpacity(0.3),
                          checkmarkColor: const Color(0xFFD4AF37),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextField(
                controller: controllers["weight"],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _t("الوزن", "Weight"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["wage"],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _t("الأجر", "Wage"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["size"],
                decoration: InputDecoration(labelText: _t("المقاس", "Size"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["qrCode"],
                decoration: InputDecoration(labelText: _t("الكود", "Code"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["notes"],
                decoration: InputDecoration(
                    labelText: _t("سبب التعديل", "Edit Reason"))),
          ],
        );
      case "bullion":
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _showDeleteDialog(context, epcHex);
                },
                child: const Text(
                  'حذف الشريحة',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controllers["EPC"],
              decoration: InputDecoration(
                labelText: _t("رقم الشريحة", "EPC Number"),
                prefixIcon: const Icon(Icons.qr_code, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllers["entryDate"],
              decoration: InputDecoration(
                labelText: _t("تاريخ الإدخال", "Entry Date"),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["weight"],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _t("الوزن", "Weight"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["wage"],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _t("الأجر", "Wage"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["size"],
                decoration: InputDecoration(labelText: _t("المقاس", "Size"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["qrCode"],
                decoration: InputDecoration(labelText: _t("الكود", "Code"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["notes"],
                decoration: InputDecoration(
                    labelText: _t("سبب التعديل", "Edit Reason"))),
          ],
        );
      case "gem":
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  _showDeleteDialog(context, epcHex);
                },
                child: const Text(
                  'حذف الشريحة',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controllers["EPC"],
              decoration: InputDecoration(
                labelText: _t("رقم الشريحة", "EPC Number"),
                prefixIcon: const Icon(Icons.qr_code, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllers["entryDate"],
              decoration: InputDecoration(
                labelText: _t("تاريخ الإدخال", "Entry Date"),
                prefixIcon:
                    const Icon(Icons.calendar_today, color: Color(0xFFD4AF37)),
              ),
              readOnly: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["type"],
                decoration:
                    InputDecoration(labelText: _t("نوع الحجر", "Stone Type"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["cost"],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: _t("التكلفة", "Cost"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["size"],
                decoration: InputDecoration(labelText: _t("المقاس", "Size"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["qrCode"],
                decoration: InputDecoration(labelText: _t("الكود", "Code"))),
            const SizedBox(height: 16),
            TextField(
                controller: controllers["notes"],
                decoration: InputDecoration(
                    labelText: _t("سبب التعديل", "Edit Reason"))),
          ],
        );
      default:
        return Text(_t("❌ نوع غير مدعوم", "❌ Unsupported type"));
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
            ),
            onPressed: () {
              final epc = controller.text.trim();
              Navigator.pop(ctx);

              if (epc.isEmpty) {
                _showMsg(_t("أدخل رقم الشريحة", "Enter tag EPC"), false);
                return;
              }

              setState(() {
                epcHex = epc;
                isReading = false;
              });

              _loadItemData();
            },
            child: Text(_t("تحميل", "Load")),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String epcHex) {
    int secondsLeft = 5;
    bool isEnabled = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          // 👈 المهم
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              // تشغيل العداد
              Future.delayed(const Duration(seconds: 1), () {
                if (secondsLeft > 0) {
                  setState(() {
                    secondsLeft--;
                    if (secondsLeft == 0) {
                      isEnabled = true;
                    }
                  });
                }
              });

              return AlertDialog(
                title: const Text(
                  'تحذير',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.right,
                ),
                content: Text(
                  'هل أنت متأكد؟\n'
                  'سيتم حذف الشريحة نهائيًا ولا يمكن التراجع.\n\n'
                  '${isEnabled ? '' : 'تأكيد الحذف بعد $secondsLeft ثواني'}',
                  textAlign: TextAlign.right,
                ),
                actionsAlignment: MainAxisAlignment.start, // 👈 يمين
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled ? Colors.red : Colors.grey,
                    ),
                    onPressed: isEnabled
                        ? () async {
                            await FS.deleteItem(epcHex);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text(
                      'تأكيد الحذف',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("صفحة التعديلات", "Edit Page")),
        backgroundColor: const Color(0xFFD4AF37),
        /*actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: _t('قوة القارئ', 'Reader Power'),
            onPressed: _showPowerSheet,
          ),
        ],*/
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
              /*Card(
                color: Colors.black,
                child: SizedBox(
                  height: 220,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Debug Console",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: debugLogs.length,
                          itemBuilder: (_, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: Text(
                                debugLogs[i],
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/

              const SizedBox(height: 20),
              if (itemData != null) ...[
                Text(_t("صور القطعة", "Item Images"),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _buildImagesSection(),
                const Divider(height: 40, thickness: 1),
              ],
              if (itemData != null) _buildForm(),
              if (itemData != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: busy ? null : _saveChanges,
                    icon: busy
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.save),
                    label: Text(busy
                        ? _t("جاري الحفظ...", "Saving...")
                        : _t("حفظ التعديلات", "Save Changes")),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
              if (msg != null) ...[
                const SizedBox(height: 20),
                Card(
                  color: msg!.contains('✅') ? Colors.green[50] : Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(msg!,
                        style: TextStyle(
                            color: msg!.contains('✅')
                                ? Colors.green[800]
                                : Colors.red[800],
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
