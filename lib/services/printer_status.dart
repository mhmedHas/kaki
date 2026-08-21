// import 'package:flutter/services.dart';
//
// class PrinterStatus {
//   final String status; // success, error, progress, started, cancelled
//   final String message;
//   final DateTime timestamp;
//
//   PrinterStatus({
//     required this.status,
//     required this.message,
//     required this.timestamp,
//   });
//
//   factory PrinterStatus.fromMap(Map<dynamic, dynamic> map) {
//     return PrinterStatus(
//       status: map['status'] as String? ?? 'unknown',
//       message: map['message'] as String? ?? '',
//       timestamp: DateTime.fromMillisecondsSinceEpoch(
//         map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
//       ),
//     );
//   }
// }
//
// class PrinterStatusListener {
//   static const _channel = EventChannel('printer_status_channel');
//
//   static Stream<PrinterStatus> getPrintStatusStream() {
//     return _channel.receiveBroadcastStream().map((event) {
//       return PrinterStatus.fromMap(event);
//     });
//   }
// }
