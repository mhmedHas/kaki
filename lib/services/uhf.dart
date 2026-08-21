import 'package:flutter/services.dart';

class Uhf {
  static const MethodChannel _m = MethodChannel('com.kaki.rfid/reader');
  static const EventChannel _e = EventChannel('com.kaki.rfid/reader/events');

  static Future<bool> open() async => await _m.invokeMethod<bool>('open') ?? false;
  static Future<bool> isAvailable() async => await _m.invokeMethod<bool>('isAvailable') ?? false;
  static Future<void> setRegion(String region) async => _m.invokeMethod('setRegion', {'region': region});
  static Future<void> setPower(int dbm) async => _m.invokeMethod('setPower', {'power': dbm});
  static Future<void> clearFilter() async => _m.invokeMethod('clearFilter');

  static Future<void> startReading() async => _m.invokeMethod('startReading');
  static Future<void> stopReading() async => _m.invokeMethod('stopReading');

  static Stream<List<String>> get tagsStream =>
      _e.receiveBroadcastStream().map((e) => (e as List).cast<String>());

  static Future<String?> readOnce() async => await _m.invokeMethod<String>('readOnce');

  // يكتب EPC (hex) إلى ذاكرة EPC (يتطلب تقديم بطاقة قريبة)
  static Future<bool> writeEpcHex(String epcHex) async =>
      await _m.invokeMethod<bool>('writeEpc', {'epcHex': epcHex}) ?? false;
}
