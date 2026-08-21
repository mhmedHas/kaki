import 'package:flutter/services.dart';

/// Flutter API layer للطابعة الجديدة (LPAPI-2026-01-08-R)
/// بنفس شكل printer_api.dart تماماً – يستخدم MethodChannel("new_printer")
class NewPrinterAPI {
  static const _channel = MethodChannel('new_printer');

  // ─────────────────────────────────────────────────────────────────────
  //  البحث عن الطابعات
  // ─────────────────────────────────────────────────────────────────────
  static Future<List<Map<String, String>>> getBluetoothPrinters() async {
    try {
      final List result =
      await _channel.invokeMethod('scanBluetoothPrinters');
      return result.map((e) => Map<String, String>.from(e)).toList();
    } on PlatformException catch (e) {
      print('خطأ في البحث عن الطابعات (new): ${e.message}');
      throw Exception('فشل البحث عن الطابعات: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  الاتصال بطابعة
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> connectBluetooth(String mac) async {
    try {
      final bool result =
      await _channel.invokeMethod('connectBluetooth', {'mac': mac});
      return result;
    } on PlatformException catch (e) {
      print('خطأ في الاتصال بالطابعة (new): ${e.message}');
      throw Exception('فشل الاتصال: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  قطع الاتصال
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> disconnect() async {
    try {
      final bool result =
      await _channel.invokeMethod('disconnectPrinter');
      return result;
    } on PlatformException catch (e) {
      print('خطأ في فصل الطابعة (new): ${e.message}');
      throw Exception('فشل فصل الطابعة: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  طباعة ليبل الذهب
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> printGoldLabel({
    String? weight,
    String? carat,
    String? size,
    required String showQr,
    required String qrCode,
    String? customLogoBase64,
    Map<String, dynamic>? labelLayout,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('printGoldLabel', {
        'weight': weight,
        'carat': carat,
        'size': size,
        'showQr': showQr,
        'qrCode': qrCode,
        'customLogoBase64': customLogoBase64,
        'labelLayout': labelLayout,
      });
      return result;
    } on PlatformException catch (e) {
      print('خطأ في طباعة ليبل الذهب (new): ${e.message}');
      throw Exception('فشل الطباعة: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  طباعة ليبل السبيكة
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> printBullionLabel({
    String? weight,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
    String? customLogoBase64,
    Map<String, dynamic>? labelLayout,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('printBullionLabel', {
        'weight': weight,
        'note1': note1,
        'note2': note2,
        'showQr': showQr,
        'qrCode': qrCode,
        'customLogoBase64': customLogoBase64,
        'labelLayout': labelLayout,
      });
      return result;
    } on PlatformException catch (e) {
      print('خطأ في طباعة ليبل السبيكة (new): ${e.message}');
      throw Exception('فشل الطباعة: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  طباعة ليبل الأحجار الكريمة
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> printGemLabel({
    String? gemType,
    String? note1,
    String? note2,
    required String showQr,
    required String qrCode,
    String? customLogoBase64,
    Map<String, dynamic>? labelLayout,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('printGemLabel', {
        'gemType': gemType,
        'note1': note1,
        'note2': note2,
        'showQr': showQr,
        'qrCode': qrCode,
        'customLogoBase64': customLogoBase64,
        'labelLayout': labelLayout,
      });
      return result;
    } on PlatformException catch (e) {
      print('خطأ في طباعة ليبل الأحجار (new): ${e.message}');
      throw Exception('فشل الطباعة: ${e.message}');
    }
  }

  // ─────────────────────────────────────────────────────────────────────
  //  حالة الاتصال
  // ─────────────────────────────────────────────────────────────────────
  static Future<bool> isConnected() async {
    try {
      final bool result =
      await _channel.invokeMethod('isPrinterConnected');
      return result;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
