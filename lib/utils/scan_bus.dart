import 'dart:async';

/// ناقل بسيط لمشاركة أكواد المسح بين الصفحات.
class ScanBus {
  ScanBus._();
  static final ScanBus instance = ScanBus._();

  final StreamController<String> _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void emit(String code) {
    _controller.add(code);
  }

  void dispose() {
    _controller.close();
  }
}
