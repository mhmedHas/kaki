//
//
// import 'package:flutter/services.dart';
//
// class PrinterAPI {
//   static const platform = MethodChannel('printer_channel');
//
//   static Future<List<Map<String, String>>> getBluetoothPrinters() async {
//     try {
//       final List result = await platform.invokeMethod('scanBluetoothPrinters');
//       return result.map((e) => Map<String, String>.from(e)).toList();
//     } on PlatformException catch (e) {
//       print("خطأ في البحث عن الطابعات: ${e.message}");
//       throw Exception("فشل البحث عن الطابعات: ${e.message}");
//     }
//   }
//
//   static Future<bool> connectBluetooth(String mac) async {
//     try {
//       final bool result = await platform.invokeMethod('connectBluetooth', {"mac": mac});
//       return result;
//     } on PlatformException catch (e) {
//       print("خطأ في الاتصال بالطابعة: ${e.message}");
//       throw Exception("فشل الاتصال: ${e.message}");
//     }
//   }
//   static Future<bool> disconnectPrinter() async {
//     try {
//       final bool result = await platform.invokeMethod('disconnectPrinter');
//       return result;
//     } on PlatformException catch (e) {
//       print("خطأ في فصل الطابعة: ${e.message}");
//       throw Exception("فشل فصل الطابعة: ${e.message}");
//     }
//   }
//
//   static Future<bool> printGoldLabel({
//     String? weight,
//     String? carat,
//     String? size,
//     required String showQr,
//     required String qrCode,
//     String? customLogoBase64,  // ← أضف ده
//   }) async {
//     return await platform.invokeMethod('printGoldLabel', {
//       "weight": weight,
//       "carat": carat,
//       "size": size,
//       "showQr": showQr,
//       "qrCode": qrCode,
//       "customLogoBase64": customLogoBase64,  // ← وابعته هنا
//     });
//   }
//   static Future<bool> printBullionLabel({
//     String? weight,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//     String? customLogoBase64,  // ← أضف ده
//   }) async {
//     return await platform.invokeMethod('printBullionLabel', {
//       "weight": weight,
//       "note1": note1,
//       "note2": note2,
//       "showQr": showQr,
//       "qrCode": qrCode,
//       "customLogoBase64": customLogoBase64,  // ← وابعته هنا
//     });
//   }
//   static Future<bool> printGemLabel({
//     String? gemType,
//     String? note1,
//     String? note2,
//     required String showQr,
//     required String qrCode,
//     String? customLogoBase64,  // ← أضف ده
//   }) async {
//     return await platform.invokeMethod('printGemLabel', {
//       "gemType": gemType,
//       "note1": note1,
//       "note2": note2,
//       "showQr": showQr,
//       "qrCode": qrCode,
//       "customLogoBase64": customLogoBase64,  // ← وابعته هنا
//     });
//   }
//
// }
