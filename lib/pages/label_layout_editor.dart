import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/new_printer_api.dart';
import '../services/new_printer_status.dart';
import 'label_layout_model.dart';
import 'package:uhf_gold_shop/services/printer_api.dart';
import 'package:uhf_gold_shop/services/printer_status.dart';

// =========================================================
//  صفحة محرر تخطيط الاستيكر  –  LabelLayoutEditorPage
// =========================================================
class LabelLayoutEditorPage extends StatefulWidget {
  final String labelType; // 'gold' | 'bullion' | 'gem'
  const LabelLayoutEditorPage({super.key, required this.labelType});

  @override
  State<LabelLayoutEditorPage> createState() => _LabelLayoutEditorPageState();
}

class _LabelLayoutEditorPageState extends State<LabelLayoutEditorPage>
    with SingleTickerProviderStateMixin {
  late LabelLayout _layout;
  String? _selectedId;
  bool _loading = true;

  late TabController _tabCtrl;

  // الحد الأقصى للعرض بالبيكسل – الـ canvas يتمدد/يتقلص بنسبة الستيكر
  static const double _maxCanvasW = 340.0;
  static const double _maxCanvasH = 300.0;

  // نحسب الـ scale بحيث لا يتجاوز الـ canvas الحدود القصوى في أي اتجاه
  double get _scale {
    final scaleByW = _maxCanvasW / _layout.stickerW;
    final scaleByH = _maxCanvasH / _layout.stickerH;
    return scaleByW < scaleByH ? scaleByW : scaleByH;
  }

  double get _canvasW => _layout.stickerW * _scale;
  double get _canvasH => _layout.stickerH * _scale;

  // موقع مؤقت أثناء السحب – مفصول عن الـ model لسلاسة الحركة
  Offset? _dragCurrent; // بوحدة مم
  String? _draggingId;

  bool _isPrinting = false;
  String? _errorMessage;
  String? _successMessage;
  String? _progressMessage;

  // حالة الطابعة
  bool _isPrinterConnected = false;
  String _connectedPrinterName = "غير متصلة";
  String? _connectedPrinterMac;
  StreamSubscription<NewPrinterStatus>? _printerStatusSubscription;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadLayout();
    _printerStatusSubscription =
        NewPrinterStatusListener.getStream().listen((status) {
      setState(() {
        _errorMessage = null;
        _successMessage = null;
        _progressMessage = null;

        switch (status.status) {
          case 'connected':
            final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
            _isPrinterConnected = true;
            _connectedPrinterName = match?.group(1) ?? "طابعة Niimbot";
            _connectedPrinterMac = match?.group(1); // في الغالب هو الـ MAC
            _successMessage = "متصل بـ $_connectedPrinterName";
            break;

          case 'disconnected':
            _isPrinterConnected = false;
            _connectedPrinterName = "غير متصلة";
            _connectedPrinterMac = null;
            _errorMessage = "تم قطع الاتصال بالطابعة";
            break;

          case 'connecting':
          case 'auto_connecting':
            _progressMessage = status.message;
            break;

          case 'printing':
          case 'progress':
            _progressMessage = status.message;
            _isPrinting = true;
            break;

          case 'success':
            _successMessage = status.message;
            _isPrinting = false;
            break;

          case 'error':
            _errorMessage = status.message;
            _isPrinting = false;
            if (status.message.contains("قطع الاتصال") ||
                status.message.contains("غير متصلة")) {
              _isPrinterConnected = false;
              _connectedPrinterName = "غير متصلة";
              _connectedPrinterMac = null;
            }
            break;

          case 'initialized':
            _successMessage = status.message;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _printerStatusSubscription?.cancel();
    super.dispose();
  }

  // نقل دالة اختيار والاتصال بالطابعة
  Future<void> _selectAndConnectPrinter() async {
    _clearMessages();
    try {
      final printers = await NewPrinterAPI.getBluetoothPrinters();
      if (printers.isEmpty) {
        setState(() {
          _errorMessage = "لا توجد طابعات Niimbot في النطاق";
        });
        return;
      }

      final selectedMac = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("اختر طابعة Niimbot"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: printers.length,
              itemBuilder: (context, i) {
                final name = printers[i]["name"] ?? "Niimbot";
                final addr = printers[i]["address"] ?? "";
                final isCurrent = addr == _connectedPrinterMac;
                return ListTile(
                  leading: Icon(
                    Icons.print,
                    color: isCurrent ? Colors.green : const Color(0xFFD4AF37),
                  ),
                  title: Text(name,
                      style: TextStyle(
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Text(addr),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(ctx, addr),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("إلغاء")),
          ],
        ),
      );

      if (selectedMac != null) {
        setState(() => _progressMessage = "جاري الاتصال...");
        final success = await NewPrinterAPI.connectBluetooth(selectedMac);
        if (!success) {
          setState(() => _errorMessage = "فشل الاتصال، تأكد من تشغيل الطابعة");
        }
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    }
  }

  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _progressMessage = null;
    });
  }

  Future<void> _loadLayout() async {
    final l = await LabelLayoutStorage.load(widget.labelType);
    setState(() {
      _layout = l;
      _loading = false;
    });
  }

  Future<void> _save() async {
    await LabelLayoutStorage.save(_layout);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ تم حفظ التخطيط بنجاح'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إعادة الضبط'),
        content: const Text(
            'هل تريد حذف التخطيط المحفوظ والرجوع للإعدادات الافتراضية؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('إعادة ضبط', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await LabelLayoutStorage.reset(widget.labelType);
      await _loadLayout();
      setState(() => _selectedId = null);
    }
  }

  LabelElement? get _selected =>
      _selectedId == null ? null : _layout.getElement(_selectedId!);

  void _select(String id) => setState(() => _selectedId = id);

  void _updateElement(LabelElement updated) {
    setState(() {
      final idx = _layout.elements.indexWhere((e) => e.id == updated.id);
      if (idx >= 0) _layout.elements[idx] = updated;

      // ── sync تلقائي بين QR/Logo و Barcode/Logo_bar ──
      if (updated.id == 'qr' || updated.id == 'barcode') {
        final qrOn = updated.id == 'qr'
            ? updated.visible
            : (_layout.getElement('qr')?.visible ?? false);
        final barcodeOn = updated.id == 'barcode'
            ? updated.visible
            : (_layout.getElement('barcode')?.visible ?? false);

        // لو فعّل QR → logo يتفعل، barcode + logo_bar يتلغوا
        // لو فعّل barcode → logo_bar يتفعل، qr + logo يتلغوا
        // لو الاتنين اتلغوا → logo يتلغي، logo_bar يتلغي

        _setVisible('logo', qrOn && !barcodeOn);
        _setVisible('logo_bar', barcodeOn && !qrOn);

        // لو فعّل QR يلغي barcode وبالعكس
        if (updated.id == 'qr' && updated.visible) {
          _setVisible('barcode', false);
        } else if (updated.id == 'barcode' && updated.visible) {
          _setVisible('qr', false);
        }
      }
    });
  }

  void _setVisible(String id, bool visible) {
    final idx = _layout.elements.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _layout.elements[idx] = _layout.elements[idx].copyWith(visible: visible);
    }
  }

  // ضبط موقع العنصر داخل حدود الستيكر
  /*Offset _clamp(double x, double y, LabelElement el) {
    final maxX = (_layout.stickerW - el.w).clamp(0.0, double.infinity);
    final maxY = (_layout.stickerH - el.h).clamp(0.0, double.infinity);
    return Offset(x.clamp(0.0, maxX), y.clamp(0.0, maxY));
  }*/
  Offset _clamp(double x, double y, LabelElement el) {
    // نسمح يخرج برا شوية
    final minX = -el.w + 2; // يخرج شمال
    final minY = -el.h + 2;

    final maxX = _layout.stickerW - 2; // يخرج يمين
    final maxY = _layout.stickerH - 2;

    return Offset(
      x.clamp(minX, maxX),
      y.clamp(minY, maxY),
    );
  }

  // ضبط حجم العنصر بحيث لا يتجاوز حجم الستيكر
  LabelElement _clampElementSize(LabelElement el) {
    final w = el.w.clamp(1.0, _layout.stickerW);
    final h = el.h.clamp(1.0, _layout.stickerH);
    final pos = _clamp(el.x, el.y, el.copyWith(w: w, h: h));
    return el.copyWith(w: w, h: h, x: pos.dx, y: pos.dy);
  }

  // يُستدعى بعد أي تغيير في حجم الستيكر – يعيد ضبط كل العناصر
  void _clampAllElements() {
    setState(() {
      _layout.elements = _layout.elements.map(_clampElementSize).toList();
    });
  }

  void _nudge(LabelElement el, double dx, double dy) {
    final clamped = _clamp(el.x + dx, el.y + dy, el);
    _updateElement(el.copyWith(x: clamped.dx, y: clamped.dy));
  }

  void _rotate(LabelElement el) {
    _updateElement(el.copyWith(rotation: (el.rotation + 90) % 360));
  }

  // ===================================================
  //  BUILD
  // ===================================================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD4AF37),
          title: Text(' تخطيط طباعة ${_typeLabel(widget.labelType)}'),
          actions: [
            IconButton(
                icon: const Icon(Icons.style_outlined),
                tooltip: 'الملفات المحفوظة',
                onPressed: _showProfilesSheet),
            IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'إعادة ضبط',
                onPressed: _reset),
            IconButton(
                icon: const Icon(Icons.save), tooltip: 'حفظ', onPressed: _save),
          ],
          bottom: TabBar(
            controller: _tabCtrl,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.purple,
            tabs: const [
              Tab(icon: Icon(Icons.design_services), text: 'التخطيط'),
              Tab(icon: Icon(Icons.tune), text: 'الخصائص'),
            ],
          ),
        ),
        body: Column(
          children: [
            // 👇 الكارد بتاع الطابعة
            Padding(
              padding: const EdgeInsets.all(0),
              child: Card(
                color: _isPrinterConnected
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        _isPrinterConnected
                            ? Icons.print
                            : Icons.print_disabled,
                        color: _isPrinterConnected ? Colors.green : Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الطابعة",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]),
                            ),
                            Text(
                              _isPrinterConnected ? "متصلة" : "غير متصلة",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isPrinterConnected
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _selectAndConnectPrinter,
                        icon: const Icon(Icons.bluetooth_searching, size: 18),
                        label: Text(_isPrinterConnected ? "متصلة" : "اتصال"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPrinterConnected
                              ? Colors.green
                              : const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await NewPrinterAPI.disconnect();
                        },
                        icon: const Icon(Icons.bluetooth_disabled, size: 18),
                        label: const Text("فصل"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 👇 التابات تاخد باقي الشاشة
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildLayoutTab(),
                  _buildPropertiesTab(),
                ],
              ),
            ),
          ],
        ),
        /*floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70), // زوّد الرقم حسب ما تحب
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton.extended(
                heroTag: 'fab_test_print',
                backgroundColor: const Color(0xFFD4AF37),
                onPressed: _isPrinting ? null : _printTestLabel,
                icon: _isPrinting
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.print_outlined),
                label: Text(_isPrinting ? 'جاري...' : 'طباعة'),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.extended(
                heroTag: 'fab_save',
                backgroundColor: const Color(0xFFD4AF37),
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('حفظ'),
              ),
            ],
          ),
        ),*/
      ),
    );
  }

  // ===================================================
  //  طباعة تجريبية
  // ===================================================

  /// يطبع ستيكر تجريبي ببيانات وهمية عشان المستخدم يتأكد من مواضع العناصر
  Future<void> _printTestLabel() async {
    _clearMessages();
    setState(() => _isPrinting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? logoBase64 = prefs.getString('custom_logo_base64');

      // نحدد showQr من العناصر الظاهرة في الـ layout
      final qrVisible = _layout.getElement('qr')?.visible ?? false;
      final String showQr = qrVisible ? 'true' : 'false';

      bool success = false;

      switch (widget.labelType) {
        case 'gold':
          success = await NewPrinterAPI.printGoldLabel(
            weight: '3.50',
            carat: '21',
            size: '7',
            showQr: showQr,
            qrCode: '123456789',
            customLogoBase64: logoBase64,
            labelLayout: _layout.toJson(),
          );
          break;

        case 'bullion':
          success = await NewPrinterAPI.printBullionLabel(
            weight: '10.00',
            note1: 'ملاحظة 1',
            note2: 'ملاحظة 2',
            showQr: showQr,
            qrCode: '123456789',
            customLogoBase64: logoBase64,
            labelLayout: _layout.toJson(),
          );
          break;

        case 'gem':
          success = await NewPrinterAPI.printGemLabel(
            gemType: 'ياقوت',
            note1: 'ملاحظة 1',
            note2: 'ملاحظة 2',
            showQr: showQr,
            qrCode: '123456789',
            customLogoBase64: logoBase64,
            labelLayout: _layout.toJson(),
          );
          break;
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🖨️ تمت الطباعة التجريبية بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          setState(() => _errorMessage = 'فشلت الطباعة، تأكد من اتصال الطابعة');
        }
      }
    } catch (e) {
      setState(() =>
          _errorMessage = 'خطأ: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  // ===================================================
  //  Profiles – Bottom Sheet
  // ===================================================

  /// يفتح الـ Bottom Sheet اللي بيعرض الـ profiles الموجودة
  Future<void> _showProfilesSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfilesSheet(
        labelType: widget.labelType,
        currentLayout: _layout,
        onLoad: (profile) {
          setState(() {
            _layout = LabelLayout(
              labelType: widget.labelType,
              stickerW: profile.layout.stickerW,
              stickerH: profile.layout.stickerH,
              density: profile.layout.density,
              elements:
                  profile.layout.elements.map((e) => e.copyWith()).toList(),
            );
            _selectedId = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم تحميل "${profile.name}"'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  // ===================================================
  //  تبويب التخطيط
  // ===================================================
  Widget _buildLayoutTab() {
    final el = _selected;
    return Column(
      children: [
        _buildStickerSizeRow(),
        const Divider(height: 1),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              /*const Text(
                '🖱️ اسحب العنصر • أسهم للتحريك الدقيق • 🔄 للتدوير',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),*/
              const SizedBox(height: 8),
              _buildCanvas(),
              const SizedBox(height: 8),
              _buildLegend(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isPrinting ? null : _printTestLabel,
                        icon: _isPrinting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.print_outlined),
                        label: Text(_isPrinting ? 'جاري...' : 'طباعة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ),
              if (el != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _rotate(el),
                      icon: const Icon(Icons.rotate_right),
                      label: const Text('تدوير +90°'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNudgePad(el),
                      ],
                    ),
                  ],
                )
            ]),
          ),
        ),
        const Divider(height: 1),
        Expanded(flex: 1, child: _buildElementsList()),
      ],
    );
  }

  Widget _buildStickerSizeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف حجم الاستيكر
          Row(children: [
            const Icon(Icons.crop, size: 18, color: Color(0xFFD4AF37)),
            const SizedBox(width: 6),
            const Text('حجم الاستيكر:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            _mmField('العرض', _layout.stickerW, (v) {
              setState(() => _layout.stickerW = v);
              _clampAllElements();
            }),
            const SizedBox(width: 6),
            const Text('×'),
            const SizedBox(width: 6),
            _mmField('الارتفاع', _layout.stickerH, (v) {
              setState(() => _layout.stickerH = v);
              _clampAllElements();
            }),
            const SizedBox(width: 4),
            const Text('مم', style: TextStyle(color: Colors.grey)),
          ]),
          const SizedBox(height: 4),
          // صف كثافة الطباعة
          _buildDensityRow(),
        ],
      ),
    );
  }

  Widget _buildDensityRow() {
    const labels = ['خفيف جداً', 'خفيف', 'متوسط', 'غامق', 'غامق جداً'];
    final density = _layout.density.clamp(1, 5);
    return Row(
      children: [
        const Icon(Icons.opacity, size: 18, color: Color(0xFFD4AF37)),
        const SizedBox(width: 6),
        const Text('الكثافة:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD4AF37),
              thumbColor: const Color(0xFFD4AF37),
              overlayColor: const Color(0x30D4AF37),
              inactiveTrackColor: Colors.grey.shade300,
              trackHeight: 4,
            ),
            child: Slider(
              value: density.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (v) => setState(() => _layout.density = v.round()),
            ),
          ),
        ),
        SizedBox(
          width: 70,
          child: Text(
            '${labels[density - 1]} ($density)',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _mmField(String hint, double val, ValueChanged<double> onChanged) {
    final ctrl = TextEditingController(text: val.toStringAsFixed(1));
    return SizedBox(
      width: 60,
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (s) {
          final d = double.tryParse(s);
          if (d != null && d > 0) onChanged(d);
        },
      ),
    );
  }

  // ===================================================
  //  Canvas الرئيسي
  //  ✅ الأسهم وزر التدوير كـ Positioned مستقلة في الـ Stack
  //     خارج GestureDetector العنصر تماماً → لا تعارض
  // ===================================================
  Widget _buildCanvas() {
    final sel = _selected;

    double? selLeft, selTop, selW, selH;
    if (sel != null) {
      final isDragging = _draggingId == sel.id && _dragCurrent != null;
      final mmX = isDragging ? _dragCurrent!.dx : sel.x;
      final mmY = isDragging ? _dragCurrent!.dy : sel.y;
      selLeft = mmX * _scale;
      selTop = mmY * _scale;
      selW = sel.w * _scale;
      selH = sel.h * _scale;
    }

    const arrowSz = 26.0;
    const gap = 4.0;

    // ── Stack خارجي Clip.none للأسهم وزر التدوير ──
    // ── Stack داخلي Clip.hardEdge يمنع العناصر من الخروج بصرياً ──
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الـ canvas نفسه مع العناصر – يقطع أي حاجة تخرج برا
          Container(
            width: _canvasW,
            height: _canvasH,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
              ],
            ),
            child: ClipRect(
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // شبكة مساعدة
                  CustomPaint(
                    size: Size(_canvasW, _canvasH),
                    painter: _GridPainter(scale: _scale),
                  ),
                  // ── العناصر القابلة للسحب ──
                  ..._layout.elements.map((el) => _buildDraggableEl(el)),
                ],
              ),
            ),
          ),

          // ── الأسهم وزر التدوير خارج الـ canvas تماماً ──
          /*if (sel != null && selLeft != null) ...[

            // ⬆️ أعلى
            Positioned(
              left: selLeft! + selW! / 2 - arrowSz / 2,
              top:  selTop! - arrowSz - gap,
              child: _canvasBtn(
                color: Colors.red,
                icon: Icons.keyboard_arrow_up,
                onTap: () => _nudge(sel, 0, -1),
              ),
            ),

            // ⬇️ أسفل
            Positioned(
              left: selLeft + selW / 2 - arrowSz / 2,
              top:  selTop + selH! + gap,
              child: _canvasBtn(
                color: Colors.red,
                icon: Icons.keyboard_arrow_down,
                onTap: () => _nudge(sel, 0, 1),
              ),
            ),

            // ⬅️ يسار
            Positioned(
              left: selLeft - arrowSz - gap,
              top:  selTop + selH! / 2 - arrowSz / 2,
              child: _canvasBtn(
                color: Colors.red,
                icon: Icons.keyboard_arrow_left,
                onTap: () => _nudge(sel, -1, 0),
              ),
            ),

            // ➡️ يمين
            Positioned(
              left: selLeft + selW + gap,
              top:  selTop + selH / 2 - arrowSz / 2,
              child: _canvasBtn(
                color: Colors.red,
                icon: Icons.keyboard_arrow_right,
                onTap: () => _nudge(sel, 1, 0),
              ),
            ),

            // 🔄 زر التدوير – زاوية يمين-أعلى
            Positioned(
              left: selLeft + selW + gap,
              top:  selTop - arrowSz - gap,
              child: _canvasBtn(
                color: Colors.orange,
                icon: Icons.rotate_right,
                onTap: () => _rotate(sel),
              ),
            ),

            // عرض درجة الدوران إن كانت غير صفر
            if (sel.rotation != 0)
              Positioned(
                left: selLeft + selW / 2 - 14,
                top:  selTop + selH / 2 - 8,
                child: IgnorePointer(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${sel.rotation}°',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],*/
        ],
      ),
    );
  }

  // زر دائري موحد على الـ canvas (أسهم + تدوير)
  Widget _canvasBtn({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, blurRadius: 3, offset: Offset(1, 1))
          ],
        ),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }

  // ── عنصر قابل للسحب (بدون أسهم داخله) ──
  Widget _buildDraggableEl(LabelElement el) {
    // ← لو مش visible متبناش خالص في الـ canvas
    if (!el.visible) return const SizedBox.shrink();

    final isSelected = el.id == _selectedId;
    final isDragging = _draggingId == el.id && _dragCurrent != null;
    final mmX = isDragging ? _dragCurrent!.dx : el.x;
    final mmY = isDragging ? _dragCurrent!.dy : el.y;

    return Positioned(
      left: mmX * _scale,
      top: mmY * _scale,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _select(el.id),
        onPanStart: (_) {
          setState(() {
            _selectedId = el.id;
            _draggingId = el.id;
            _dragCurrent = Offset(el.x, el.y);
          });
        },
        onPanUpdate: (d) {
          if (_draggingId != el.id) return;
          final cur = _dragCurrent ?? Offset(el.x, el.y);
          final clamped = _clamp(
            cur.dx + d.delta.dx / _scale,
            cur.dy + d.delta.dy / _scale,
            el,
          );
          setState(() => _dragCurrent = clamped);
        },
        onPanEnd: (_) {
          if (_draggingId == el.id && _dragCurrent != null) {
            _updateElement(
                el.copyWith(x: _dragCurrent!.dx, y: _dragCurrent!.dy));
          }
          setState(() {
            _draggingId = null;
            _dragCurrent = null;
          });
        },
        child: Opacity(
          opacity: el.visible ? 1.0 : 0.35,
          child: Transform.rotate(
            angle: el.rotation * pi / 180,
            child: Container(
              width: el.w * _scale,
              height: el.h * _scale,
              decoration: BoxDecoration(
                color: _elementColor(el.id).withOpacity(0.25),
                border: Border.all(
                  color: isSelected ? Colors.red : _elementColor(el.id),
                  width: isSelected ? 2.5 : 1,
                ),
              ),
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      _elementPreviewText(el),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: _elementColor(el.id),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===================================================
  //  Legend + List
  // ===================================================
  Widget _buildLegend() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _layout.elements.map((el) {
        return GestureDetector(
          onTap: () => _select(el.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _elementColor(el.id).withOpacity(0.15),
              border: Border.all(
                color: el.id == _selectedId ? Colors.red : _elementColor(el.id),
                width: el.id == _selectedId ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, color: _elementColor(el.id)),
              const SizedBox(width: 4),
              Text(el.label, style: const TextStyle(fontSize: 11)),
              //if (!el.visible)
              //const Text(' 🙈', style: TextStyle(fontSize: 10)),
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildElementsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: _layout.elements.length,
      itemBuilder: (_, i) {
        final el = _layout.elements[i];
        final isSelected = el.id == _selectedId;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 3),
          color: isSelected ? const Color(0xFFFFF9E6) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            dense: true,
            leading: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _elementColor(el.id),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            title: Text(el.label,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: Text(
              'X:${el.x.toStringAsFixed(1)} Y:${el.y.toStringAsFixed(1)} | '
              '${el.w.toStringAsFixed(1)}×${el.h.toStringAsFixed(1)} مم'
              '${el.rotation != 0 ? '  •  ${el.rotation}°' : ''}',
              style: const TextStyle(fontSize: 11),
            ),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Switch(
                value: el.visible,
                onChanged: (v) => _updateElement(el.copyWith(visible: v)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeThumbColor: const Color(0xFFD4AF37),
              ),
              IconButton(
                icon: const Icon(Icons.tune, size: 18),
                onPressed: () {
                  _select(el.id);
                  _tabCtrl.animateTo(1);
                },
              ),
            ]),
            onTap: () => _select(el.id),
          ),
        );
      },
    );
  }

  // ===================================================
  //  تبويب الخصائص
  // ===================================================
  Widget _buildPropertiesTab() {
    final el = _selected;
    if (el == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'اضغط على أي عنصر في التخطيط\nلتعديل خصائصه',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _elementColor(el.id).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _elementColor(el.id)),
            ),
            child: Row(children: [
              Container(width: 20, height: 20, color: _elementColor(el.id)),
              const SizedBox(width: 10),
              Text(el.label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Switch(
                value: el.visible,
                onChanged: (v) => _updateElement(el.copyWith(visible: v)),
                activeThumbColor: const Color(0xFFD4AF37),
              ),
              const Text('ظاهر'),
            ]),
          ),
          const SizedBox(height: 20),
          _sectionTitle('📍 الموقع (مم)'),
          Row(children: [
            Expanded(
                child: _propField('X (من اليسار)', el.x,
                    (v) => _updateElement(_clampedEl(el, x: v)))),
            const SizedBox(width: 12),
            Expanded(
                child: _propField('Y (من الأعلى)', el.y,
                    (v) => _updateElement(_clampedEl(el, y: v)))),
          ]),
          const SizedBox(height: 16),
          _sectionTitle('📐 الحجم (مم)'),
          Row(children: [
            Expanded(
                child: _propField('العرض', el.w, (v) {
              final updated = _clampElementSize(el.copyWith(w: v));
              _updateElement(updated);
            })),
            const SizedBox(width: 12),
            Expanded(
                child: _propField('الارتفاع', el.h, (v) {
              final updated = _clampElementSize(el.copyWith(h: v));
              _updateElement(updated);
            })),
          ]),
          const SizedBox(height: 16),
          if (_isTextElement(el.id)) ...[
            _sectionTitle('🔤 حجم الخط (مم)'),
            _propField('حجم الخط', el.fontSize,
                (v) => _updateElement(el.copyWith(fontSize: v.clamp(1, 20)))),
            const SizedBox(height: 16),
          ],
          _sectionTitle('🔄 الدوران'),
          Wrap(
            spacing: 8,
            children: [0, 90, 180, 270]
                .map((deg) => ChoiceChip(
                      label: Text('$deg°'),
                      selected: el.rotation == deg,
                      selectedColor: const Color(0xFFD4AF37),
                      onSelected: (_) =>
                          _updateElement(el.copyWith(rotation: deg)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _rotate(el),
            icon: const Icon(Icons.rotate_right),
            label: const Text('تدوير +90°'),
          ),
          const SizedBox(height: 16),
          _sectionTitle('🎯 تحريك دقيق (1 مم)'),
          _buildNudgePad(el),
          const SizedBox(height: 16),
          _sectionTitle('⚡ محاذاة سريعة'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _alignBtn('⬅️ يسار', () => _updateElement(_clampedEl(el, x: 0))),
              _alignBtn(
                  '➡️ يمين',
                  () => _updateElement(
                      _clampedEl(el, x: _layout.stickerW - el.w))),
              _alignBtn('⬆️ أعلى', () => _updateElement(_clampedEl(el, y: 0))),
              _alignBtn(
                  '⬇️ أسفل',
                  () => _updateElement(
                      _clampedEl(el, y: _layout.stickerH - el.h))),
              _alignBtn(
                  '↔️ توسيط أفقي',
                  () => _updateElement(
                      _clampedEl(el, x: (_layout.stickerW - el.w) / 2))),
              _alignBtn(
                  '↕️ توسيط عمودي',
                  () => _updateElement(
                      _clampedEl(el, y: (_layout.stickerH - el.h) / 2))),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNudgePad(LabelElement el) {
    const btnSize = 40.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _nudgeBtn(
                Icons.keyboard_arrow_up, btnSize, () => _nudge(el, 0, -0.25)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _nudgeBtn(Icons.keyboard_arrow_right, btnSize,
                    () => _nudge(el, 0.25, 0)),
                const SizedBox(width: btnSize, height: btnSize),
                _nudgeBtn(Icons.keyboard_arrow_left, btnSize,
                    () => _nudge(el, -0.25, 0)),
              ],
            ),
            _nudgeBtn(
                Icons.keyboard_arrow_down, btnSize, () => _nudge(el, 0, 0.25)),
          ],
        ),
        const SizedBox(width: 16),
        Text(
          'X: ${el.x.toStringAsFixed(2)}\nY: ${el.y.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _nudgeBtn(IconData icon, double size, VoidCallback onTap) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onTap,
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      );

  Widget _propField(
      String label, double value, ValueChanged<double> onChanged) {
    final ctrl = TextEditingController(text: value.toStringAsFixed(2));
    return TextField(
      controller: ctrl,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: 'مم',
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onSubmitted: (s) {
        final d = double.tryParse(s);
        if (d != null) onChanged(d);
      },
    );
  }

  Widget _alignBtn(String label, VoidCallback onPressed) => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: Text(label),
      );

  LabelElement _clampedEl(LabelElement el, {double? x, double? y}) {
    final clamped = _clamp(x ?? el.x, y ?? el.y, el);
    return el.copyWith(x: clamped.dx, y: clamped.dy);
  }

  // ======== Helpers ========
  bool _isTextElement(String id) => [
        'weight',
        'carat',
        'size',
        'note1',
        'note2',
        'gemType',
        'qrCode_text'
      ].contains(id);

  String _elementPreviewText(LabelElement el) {
    switch (el.id) {
      case 'weight':
        return 'W 3.50';
      case 'carat':
        return 'K 21';
      case 'size':
        return 'S 7';
      case 'note1':
        return 'Note 1';
      case 'note2':
        return 'Note 2';
      case 'gemType':
        return 'ياقوت';
      case 'qrCode_text':
        return '123456789';
      case 'qr':
        return '▣ QR';
      case 'barcode':
        return '║║ Barcode';
      case 'logo':
      case 'logo_bar':
        return '🏷 Logo';
      default:
        return el.label;
    }
  }

  Color _elementColor(String id) {
    switch (id) {
      case 'weight':
        return Colors.blue;
      case 'carat':
        return Colors.green;
      case 'size':
        return Colors.purple;
      case 'note1':
        return Colors.teal;
      case 'note2':
        return Colors.indigo;
      case 'gemType':
        return Colors.deepOrange;
      case 'qrCode_text':
        return Colors.brown;
      case 'qr':
        return Colors.black87;
      case 'barcode':
        return Colors.grey[700]!;
      case 'logo':
      case 'logo_bar':
        return const Color(0xFFD4AF37);
      default:
        return Colors.blueGrey;
    }
  }

  String _typeLabel(String t) {
    switch (t) {
      case 'bullion':
        return 'السبائك';
      case 'gem':
        return 'الأحجار الكريمة';
      default:
        return 'الذهب';
    }
  }
}

// ======== Bottom Sheet: إدارة الـ Profiles ========
class _ProfilesSheet extends StatefulWidget {
  final String labelType;
  final LabelLayout currentLayout;
  final void Function(LabelProfile profile) onLoad;

  const _ProfilesSheet({
    required this.labelType,
    required this.currentLayout,
    required this.onLoad,
  });

  @override
  State<_ProfilesSheet> createState() => _ProfilesSheetState();
}

class _ProfilesSheetState extends State<_ProfilesSheet> {
  List<LabelProfile> _profiles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await LabelProfileStorage.loadAll(widget.labelType);
    if (mounted)
      setState(() {
        _profiles = list;
        _loading = false;
      });
  }

  // ── حفظ الـ layout الحالي كـ profile جديد ──
  Future<void> _saveNew() async {
    final name = await _askName(context);
    if (name == null || name.trim().isEmpty) return;

    final profile = LabelProfile(
      id: LabelProfileStorage.generateId(),
      name: name.trim(),
      labelType: widget.labelType,
      savedAt: DateTime.now(),
      layout: widget.currentLayout,
    );
    await LabelProfileStorage.save(profile);
    await _load();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ تم حفظ "${profile.name}"'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ── تحميل profile ──
  void _loadProfile(LabelProfile profile) {
    widget.onLoad(profile);
    Navigator.pop(context);
  }

  // ── حذف profile بعد تأكيد ──
  Future<void> _deleteProfile(LabelProfile profile) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الملف'),
        content: Text('هل تريد حذف "${profile.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true) {
      await LabelProfileStorage.delete(widget.labelType, profile.id);
      await _load();
    }
  }

  // ── dialog لإدخال اسم الـ profile ──
  static Future<String?> _askName(BuildContext context) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('اسم الملف الجديد'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'مثال: ستيكر ذهب كبير',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (v) => Navigator.pop(context, v),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37)),
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: screenH * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // ── Handle ──
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.style_outlined, color: Color(0xFFD4AF37)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'الملفات المحفوظة',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                    ),
                    onPressed: _saveNew,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('حفظ الحالي'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // ── القائمة ──
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _profiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open,
                                  size: 60, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              const Text(
                                'لا يوجد ملفات محفوظة بعد\nاضغط "حفظ الحالي" لإضافة أول ملف',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _profiles.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 16),
                          itemBuilder: (_, i) {
                            final p = _profiles[i];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color(0xFFD4AF37).withOpacity(0.15),
                                child: const Icon(Icons.description_outlined,
                                    color: Color(0xFFD4AF37)),
                              ),
                              title: Text(
                                p.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${_formatDate(p.savedAt)}  •  '
                                '${p.layout.stickerW.toStringAsFixed(0)}×'
                                '${p.layout.stickerH.toStringAsFixed(0)} مم  •  '
                                'كثافة ${p.layout.density}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // زر تحميل
                                  IconButton(
                                    icon: const Icon(Icons.download_rounded,
                                        color: Color(0xFFD4AF37)),
                                    tooltip: 'تحميل',
                                    onPressed: () => _loadProfile(p),
                                  ),
                                  // زر حذف
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    tooltip: 'حذف',
                                    onPressed: () => _deleteProfile(p),
                                  ),
                                ],
                              ),
                              onTap: () => _loadProfile(p),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======== رسم الشبكة المساعدة ========
class _GridPainter extends CustomPainter {
  final double scale;
  const _GridPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final light = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;
    for (double x = 0; x <= size.width; x += scale * 5) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), light);
    }
    for (double y = 0; y <= size.height; y += scale * 5) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), light);
    }

    final bold = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += scale * 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), bold);
    }
    for (double y = 0; y <= size.height; y += scale * 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), bold);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.scale != scale;
}
