import 'package:flutter/services.dart';

class NewPrinterStatus {
  final String status;
  final String message;

  NewPrinterStatus({
    required this.status,
    required this.message,
  });

  factory NewPrinterStatus.fromMap(Map<dynamic, dynamic> map) {
    return NewPrinterStatus(
      status: map['status'] ?? 'unknown',
      message: map['message'] ?? '',
    );
  }
}

class NewPrinterStatusListener {
  static const _channel = EventChannel('new_printer_status');

  static Stream<NewPrinterStatus> getStream() {
    return _channel.receiveBroadcastStream().map((event) {
      return NewPrinterStatus.fromMap(event);
    });
  }
}