import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';
import '../services/seuic_uhf_service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;
  
  String epcHex = '';
  Map<String, dynamic>? itemData;
  bool isLoading = false;
  List<String> imageUrls = [];
  bool isReading = false;
  StreamSubscription<String>? _uhfSubscription;

  final TextEditingController epcController = TextEditingController();

  Map<String, dynamic>? tagsLookup;
  List<Map<String, dynamic>> AllTags = [];

  Future<void> _loadAllTags() async {
    final allTags = await FS.getAllEpcAndQr();
    tagsLookup = {};

    for (var item in allTags) {
      final epc = item['epcHex']?.toString();
      final qr = item['qrCode']?.toString().toUpperCase();

      if (epc != null) {
        tagsLookup![epc] = item;
      }

      if (qr != null) {
        tagsLookup![qr] = item;
      }
    }

    setState(() {
      AllTags = allTags;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadAllTags();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _startReading() async {
    setState(() {
      isReading = true;
    });

    _uhfSubscription = SeuicUhfService.tagStream.listen((tag) async {
      if (!mounted) return;

      final tags = tag.split("ENTER").where((t) => t.trim().isNotEmpty).toList();

      for (final raw in tags) {
        final tagValue = raw.trim();
        if (tagValue.isEmpty) continue;

        final normalizedTag = tagValue.toUpperCase();
        final result = tagsLookup?[normalizedTag];
        if (result == null) continue;

        final newEpc = result['epcHex']?.toString() ?? normalizedTag;

        if (!mounted) return;
        setState(() {
          epcHex = newEpc;
          epcController.text = newEpc;
        });
        await _loadItemData();
        break;
      }
    });

    await SeuicUhfService.inventoryStart();
  }

  void _stopReading() {
    _uhfSubscription?.cancel();
    SeuicUhfService.inventoryStop();
    setState(() {
      isReading = false;
    });
  }

  Future<void> _loadItemData() async {
    if (epcHex.isEmpty) return;

    setState(() {
      isLoading = true;
      itemData = null;
      imageUrls = [];
    });

    try {
      final data = tagsLookup![epcHex.toUpperCase()] ?? await FS.findItemByEpc(epcHex);
      if (data != null) {
        setState(() {
          itemData = data;
        });
        await _loadImages();
      } else {
        setState(() {
          isLoading = false;
        });
        _showMessage(_t('القطعة غير موجودة', 'Item not found'), Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage(_t('خطأ: ${e.toString()}', 'Error: ${e.toString()}'), Colors.red);
    }
  }

  Future<void> _loadImages() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(epcHex.toUpperCase());

      final result = await storageRef.listAll();
      final urls = await Future.wait(result.items.map((e) => e.getDownloadURL()));
      
      setState(() {
        imageUrls = urls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _showFullImage(String imageUrl) {
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

  @override
  void dispose() {
    _stopReading();
    epcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payload = itemData?['payload'] as Map<String, dynamic>? ?? {};
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
        title: Text(_t('معاينة القطعة', 'Item Preview')),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: epcController,
                            decoration: InputDecoration(
                              labelText: _t('رقم الشريحة أو الباركود', 'EPC or Barcode'),
                              prefixIcon: const Icon(Icons.qr_code),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                epcHex = value.trim();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: epcHex.isNotEmpty ? _loadItemData : null,
                          icon: const Icon(Icons.search),
                          label: Text(_t('بحث', 'Search')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isReading ? _stopReading : _startReading,
                            icon: Icon(isReading ? Icons.stop : Icons.radar),
                            label: Text(isReading ? _t('إيقاف القراءة', 'Stop Reading') : _t('قراءة الشريحة', 'Read Chip')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isReading ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                epcHex = '';
                                epcController.clear();
                                itemData = null;
                                imageUrls = [];
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: Text(_t('مسح', 'Clear')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Loading indicator
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

            // Item details
            if (!isLoading && itemData != null) ...[
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t('تفاصيل القطعة', 'Item Details'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 12),

                        // EPC/QR Code
                        if (itemData!['epcHex'] != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.qr_code, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 8),
                              Text(
                                '${_t('رقم الشريحة', 'EPC')}: ${itemData!['epcHex']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Code/Barcode
                        if (payload['qrCode'] != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.barcode_reader, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 8),
                              Text(
                                '${_t('الكود', 'Code')}: ${payload['qrCode']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Barcode display
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: payload['showQr'] == true
                                  ? QrImageView(
                                      data: payload['qrCode'],
                                      version: QrVersions.auto,
                                      size: 100,
                                    )
                                  : BarcodeWidget(
                                      barcode: Barcode.code128(),
                                      data: payload['qrCode'],
                                      width: 200,
                                      height: 60,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Weight
                        if (payload['weight'] != null) ...[
                          Row(
                            children: [
                              const Icon(Icons.scale, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 8),
                              Text(
                                '${_t('الوزن', 'Weight')}: ${payload['weight']} جرام',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Size
                        if (payload['size'] != null && payload['size'].toString().isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(Icons.straighten, color: Color(0xFFD4AF37)),
                              const SizedBox(width: 8),
                              Text(
                                '${_t('المقاس', 'Size')}: ${payload['size']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],

                        // Category specific details
                        if (itemData!['category'] == 'gold') ...[
                          if (payload['carat'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.grade, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('العيار', 'Carat')}: ${payload['carat']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (payload['wage'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('الأجر', 'Wage')}: ${payload['wage']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (payload['kind'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.category, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('النوع', 'Type')}: ${payload['kind']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],

                        if (itemData!['category'] == 'gem') ...[
                          if (payload['type'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.diamond, color: Colors.purple),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('نوع الحجر', 'Stone Type')}: ${payload['type']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (payload['cost'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.attach_money, color: Colors.purple),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('التكلفة', 'Cost')}: ${payload['cost']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],

                        if (itemData!['category'] == 'bullion') ...[
                          if (payload['wage'] != null) ...[
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, color: Color(0xFFD4AF37)),
                                const SizedBox(width: 8),
                                Text(
                                  '${_t('الأجر', 'Wage')}: ${payload['wage']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Images section
              if (imageUrls.isNotEmpty) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t('صور القطعة', 'Item Images'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8),
                              child: GestureDetector(
                                onTap: () => _showFullImage(imageUrls[index]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrls[index],
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      ),
    );
  }
}
