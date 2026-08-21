import 'dart:async';
import 'package:flutter/material.dart'; // إضافة استيراد Material للوصول إلى Colors
import 'package:flutter/services.dart';
import '../utils/scan_bus.dart';

/// يلتقط إدخال الماسح في وضع Keyboard Wedge.
/// - يجمع الأحرف السريعة في مخزن.
/// - يرسل عند الضغط على Enter أو عند انتهاء مهلة الخمول.
class HardwareBarcodeListener extends StatefulWidget {
  const HardwareBarcodeListener({
    super.key,
    required this.child,
    this.timeout = const Duration(milliseconds: 80),
    this.minLength = 3,
    this.showDebugOverlay = false,
    this.onBarcode,
  });

  final Widget child;
  final Duration timeout;
  final int minLength;
  final bool showDebugOverlay;

  /// نداء اختياري عند اكتمال المسح.
  final ValueChanged<String>? onBarcode;

  @override
  State<HardwareBarcodeListener> createState() =>
      _HardwareBarcodeListenerState();
}

class _HardwareBarcodeListenerState extends State<HardwareBarcodeListener> {
  final StringBuffer _buf = StringBuffer();
  Timer? _timer;
  String _last = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(debugLabel: 'HardwareBarcodeListener');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _flush() {
    final s = _buf.toString();
    _buf.clear();
    if (s.length >= widget.minLength) {
      _last = s;
      // وزّع على الحافلة العامة
      ScanBus.instance.emit(s);
      // نداء اختياري للمستمع الأعلى
      widget.onBarcode?.call(s);
      if (mounted && widget.showDebugOverlay) {
        setState(() {});
      }
    }
  }

  void _onKey(RawKeyEvent e) {
    if (e is! RawKeyDownEvent) return;

    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }

    if (e.logicalKey == LogicalKeyboardKey.enter ||
        e.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _timer?.cancel();
      _flush();
      return;
    }

    final ch = e.character;
    if (ch == null || ch.isEmpty) return;
    if (ch.codeUnitAt(0) < 32) return; // تجاهل محارف التحكم

    _buf.write(ch);
    _timer?.cancel();
    _timer = Timer(widget.timeout, _flush);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: _onKey,
      child: Stack(
        children: [
          widget.child,
          if (widget.showDebugOverlay)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _last.isEmpty ? 'جاهز للمسح' : 'آخر مسح: $_last',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }
}
