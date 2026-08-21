import 'package:flutter/services.dart';

class SeuicScannerService {
  static const MethodChannel _channel = MethodChannel('com.seuic.scanner');
  static const EventChannel _eventChannel = EventChannel('com.seuic.scanner/events');

  static Future<bool> open() async {
    try {
      return await _channel.invokeMethod('open') ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> close() async {
    try {
      await _channel.invokeMethod('close');
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> startScan() async {
    try {
      await _channel.invokeMethod('startScan');
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> stopScan() async {
    try {
      await _channel.invokeMethod('stopScan');
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> enable() async {
    try {
      await _channel.invokeMethod('enable');
    } catch (e) {
      // Handle error
    }
  }

  static Future<void> disable() async {
    try {
      await _channel.invokeMethod('disable');
    } catch (e) {
      // Handle error
    }
  }

  static Future<int> getParams(int paramCode) async {
    try {
      return await _channel.invokeMethod('getParams', {'paramCode': paramCode}) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> setParams(int paramCode, int value) async {
    try {
      return await _channel.invokeMethod('setParams', {
        'paramCode': paramCode,
        'value': value,
      }) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Stream<Map<String, dynamic>> get scanStream =>
      _eventChannel.receiveBroadcastStream().map((event) {
        return {
          'barcode': event['barcode'] ?? '',
          'codeType': event['codeType'] ?? '',
          'length': event['length'] ?? 0,
        };
      });
}
