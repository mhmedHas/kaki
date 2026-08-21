import 'dart:async';
import 'package:flutter/services.dart';
import '../utils/scan_bus.dart';

/// يدمج مصدرين:
/// 1) أحداث البث من الأندرويد عبر EventChannel (seuic/scanner)
/// 2) إدخال Keyboard Wedge القادم من HardwareBarcodeListener عبر ScanBus
class BarcodeEvents {
  BarcodeEvents._() {
    // استقبل أحداث القناة الأصلية
    _nativeSub = const EventChannel('seuic/scanner')
        .receiveBroadcastStream()
        .cast<dynamic>()
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .listen(_merged.add);

    // استقبل من ScanBus
    _busSub = ScanBus.instance.stream.listen(_merged.add);
  }

  static final BarcodeEvents instance = BarcodeEvents._();

  final StreamController<String> _merged = StreamController<String>.broadcast();
  late final StreamSubscription _nativeSub;
  late final StreamSubscription _busSub;

  Stream<String> get stream => _merged.stream;

  void dispose() {
    _nativeSub.cancel();
    _busSub.cancel();
    _merged.close();
  }
}
