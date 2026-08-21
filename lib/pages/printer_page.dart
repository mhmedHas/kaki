// lib/pages/printer_page.dart

import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'label_layout_model.dart';
import '../services/new_printer_status.dart';
import '../services/new_printer_api.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({super.key});

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  bool _isPrinting = false;
  String? _errorMessage;
  String? _successMessage;
  String? _progressMessage;

  // حالة الطابعة
  bool _isPrinterConnected = false;
  String _connectedPrinterName = "غير متصلة";
  String? _connectedPrinterMac;

  // حقول ليبل الذهب
  final TextEditingController _weightController =
      TextEditingController(text: "36.8");
  final TextEditingController _caratController =
      TextEditingController(text: "21");
  final TextEditingController _sizeController =
      TextEditingController(text: "6");
  final TextEditingController _showQrController =
      TextEditingController(text: "true");
  final TextEditingController _qrCodeController =
      TextEditingController(text: "GOLD25112025");

  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();

  Future<bool> _ensureBluetoothPermissions() async {
    try {
      await _bluetoothClassicPlugin.initPermissions();
      return true;
    } catch (e) {
      setState(() {
        _errorMessage = "يرجى تفعيل أذونات البلوتوث الكاملة من إعدادات التطبيق";
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    // الاستماع لحالة الطابعة من الـ Native
    NewPrinterStatusListener.getStream().listen((status) {
      setState(() {
        _errorMessage = null;
        _successMessage = null;
        _progressMessage = null;

        switch (status.status) {
          case 'connected':
            final match = RegExp(r'متصل بـ (.+)').firstMatch(status.message);
            _isPrinterConnected = true;
            _connectedPrinterName = match?.group(1) ?? "طابعة LPAPI";
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

  void _clearMessages() {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
      _progressMessage = null;
    });
  }

  // دالة اختيار والاتصال بالطابعة (مستقلة)
  Future<void> _selectAndConnectPrinter() async {
    _clearMessages();
    try {
      if (!await _ensureBluetoothPermissions()) {
        return;
      }

      final printers = await NewPrinterAPI.getBluetoothPrinters();
      if (printers.isEmpty) {
        setState(() {
          _errorMessage = "لا توجد طابعات LPAPI في النطاق";
        });
        return;
      }

      final selectedMac = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("اختر طابعة LPAPI"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: printers.length,
              itemBuilder: (context, i) {
                final name = printers[i]["name"] ?? "طابعة LPAPI";
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

  // دالة الطباعة (بدون اتصال)
  Future<void> _printGoldLabel() async {
    _clearMessages();

    if (!_isPrinterConnected) {
      setState(() =>
          _errorMessage = "الطابعة غير متصلة، اضغط على زر الطابعة للاتصال");
      return;
    }

    if (_weightController.text.trim().isEmpty ||
        _caratController.text.trim().isEmpty ||
        _sizeController.text.trim().isEmpty ||
        _showQrController.text.trim().isEmpty ||
        _qrCodeController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isPrinting = true);

    try {
      final layout = await LabelLayoutStorage.load('gold');
      final success = await NewPrinterAPI.printGoldLabel(
        weight: _weightController.text.trim(),
        carat: _caratController.text.trim(),
        size: _sizeController.text.trim(),
        showQr: _showQrController.text.trim(),
        qrCode: _qrCodeController.text.trim(),
        labelLayout: layout.toJson(),
      );

      if (!success) {
        setState(
            () => _errorMessage = "فشل في الطباعة، تأكد من الورق والبطارية");
      }
    } catch (e) {
      setState(() =>
          _errorMessage = "خطأ: ${e.toString().replaceAll('Exception: ', '')}");
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("طابعة ليبلات الذهب"),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === شريط حالة الطابعة في الأعلى ===
            Card(
              color: _isPrinterConnected
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      _isPrinterConnected ? Icons.print : Icons.print_disabled,
                      color: _isPrinterConnected ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "حالة الطابعة",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          Text(
                            _isPrinterConnected
                                ? _connectedPrinterName
                                : "غير متصلة",
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
                      icon: const Icon(Icons.bluetooth_searching, size: 20),
                      label: Text(_isPrinterConnected ? "متصلة" : "اتصال"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPrinterConnected
                            ? Colors.orange
                            : const Color(0xFFD4AF37),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // رسائل الحالة
            if (_errorMessage != null)
              _buildMessage(_errorMessage!, Colors.red),
            if (_successMessage != null)
              _buildMessage(_successMessage!, Colors.green),
            if (_progressMessage != null)
              _buildMessage(_progressMessage!, Colors.blue, true),

            const SizedBox(height: 20),
            const Text("بيانات ليبل الذهب",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4AF37))),
            const SizedBox(height: 15),

            _buildField(_weightController, "الوزن", Icons.person),
            _buildField(_caratController, "العيار", Icons.scale,
                keyboardType: TextInputType.numberWithOptions(decimal: true)),
            _buildField(_sizeController, "المقاس", Icons.star),
            _buildField(
                _showQrController, "QR or Barcode ", Icons.attach_money),
            _buildField(_qrCodeController, "الكود", Icons.qr_code_scanner),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed:
                  _isPrinting || !_isPrinterConnected ? null : _printGoldLabel,
              icon: _isPrinting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.print, size: 28),
              label: Text(_isPrinting ? "جاري الطباعة..." : "طباعة ليبل الذهب"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isPrinterConnected ? const Color(0xFFD4AF37) : Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "مقاس الليبل: 50×30 مم",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2)),
        ),
      ),
    );
  }

  Widget _buildMessage(String msg, Color color, [bool loading = false]) {
    final isError = color == Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
                  loading
                      ? Icons.print
                      : (color == Colors.green
                          ? Icons.check_circle
                          : Icons.error),
                  color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg.split('. ')[0],
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w600)),
                if (isError && msg.contains('. '))
                  Text(msg.split('. ').skip(1).join('. '),
                      style: TextStyle(color: Colors.red[700], fontSize: 12)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: _clearMessages),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _caratController.dispose();
    _sizeController.dispose();
    _showQrController.dispose();
    _qrCodeController.dispose();
    super.dispose();
  }
}
