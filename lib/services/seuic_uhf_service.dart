import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';


class SeuicUhfService {
  static const MethodChannel _channel = MethodChannel('com.seuic.uhf');
  static const MethodChannel _debugChannel = MethodChannel('debug/scanner');
  static const EventChannel _eventChannel = EventChannel('seuic/scanner');
  static const MethodChannel _statusChannel = MethodChannel('com.seuic.uhf_status');
  /*static const platform = MethodChannel('com.example.yourapp/boolean');

  static Future<void> sendBoolean(bool value) async {
    try {
      await platform.invokeMethod('setBoolean', {'value': value});
    } on PlatformException catch (e) {
      print("Failed to send boolean: ${e.message}");
    }
  }*/
  static Future<bool> addEpcManualy(String Epc) async {
    try {
      _tagController.add(Epc);
      return true;
    } catch (e) {
      return false;
    }
  }


  static StreamSubscription<dynamic>? _subscription;
  static final StreamController<String> _tagController = StreamController<String>.broadcast();
  // Stream للاستماع للشرائح المقروءة
  static Stream<String> get tagStream => _tagController.stream;


  /*// Stream أساسي للـ List
  static final StreamController<List<String>> _batchController = StreamController<List<String>>.broadcast();
  /// للصفحات الجديدة (Batch)
  static Stream<List<String>> get batchTagStream => _batchController.stream;*/



  static Future<void> initialize() async {
    _subscription = _eventChannel.receiveBroadcastStream().listen(
          (dynamic data) {
            /*if (data is List) {
              final tags = List<String>.from(data);
              if (tags.isNotEmpty) {
                _batchController.add(tags);
              }
            }*/

            if (data is String && data.isNotEmpty) {
              //_tagController.add(data);
              final tags = data.split(RegExp(r'[\r\n]+|ENTER'));
              for (var tag in tags) {
                tag = tag.trim();
                if (tag.isNotEmpty) {
                  _tagController.add(tag);
                }
              }

            }

          },
      onError: (error) {
        print('UHF EventChannel error: $error');
      },
    );
  }

  static void dispose() {
    //_batchController.close();
    _subscription?.cancel();
    _tagController.close();
  }

  static Future<bool> openUhfApp() async {
    try {
      await _debugChannel.invokeMethod('openUhfApp');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> open() async {
    try {
      await initialize();
      return await _channel.invokeMethod('open') ?? false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> open1() async {
    try {
      //await initialize();
      return await _channel.invokeMethod('open') ?? false;
    } catch (e) {
      return false;
    }
  }
  static void listenForInitStatus(BuildContext context) {
    _statusChannel.setMethodCallHandler((call) async {
      if (call.method == "initStatus") {
        final status = call.arguments.toString();
        String message;
        Color color;

        switch (status) {
          case "success":
            message = "✅ تم تهيئة قارئ UHF بنجاح وتحديد القوة.";
            color = Colors.green;
            break;
          case "failed":
            message = "⚠️ فشل في فتح قارئ UHF. لم يتم تحديد قوة القارئ.";
            color = Colors.orange;
            break;
          case "error":
            message = "❌ خطأ أثناء تهيئة قارئ UHF.";
            color = Colors.red;
            break;
          default:
            message = "⚠️ حالة غير معروفة لقارئ UHF.";
            color = Colors.grey;
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, textDirection: TextDirection.rtl),
              backgroundColor: color,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    });
  }


  static Future<void> close() async {
    try {
      dispose();
      await _channel.invokeMethod('close');
    } catch (e) {
      // Handle error
    }
  }

  static Future<String?> getFirmwareVersion() async {
    try {
      return await _channel.invokeMethod('getFirmwareVersion');
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getTemperature() async {
    try {
      return await _channel.invokeMethod('getTemperature');
    } catch (e) {
      return null;
    }
  }

  static Future<int> getPower() async {
    try {
      return await _channel.invokeMethod('getPower') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /*static Future<bool> setPower(int power) async {
    try {
      return await _channel.invokeMethod('setPower', {'power': power}) ?? false;
    } catch (e) {
      return false;
    }
  }*/
  static Future<bool> setPower(int power) async {
    try {
      // تحقق أولاً لو الـ UHF مفتوح (عبر getPower كـ proxy)
      final currentPower = await getPower();
      if (currentPower == 0) {  // لو 0، معناها مش مفتوح
        print('⚠️ UHF غير مفتوح، فتح أولاً...');
        await open1();
        await Future.delayed(const Duration(milliseconds: 500));  // انتظر شوية
      }

      final success = await _channel.invokeMethod('setPower', {'power': power}) ?? false;
      return success;
    } catch (e) {
      print('❌ خطأ في setPower: $e');
      return false;
    }
  }

  static Future<String?> getRegion() async {
    try {
      return await _channel.invokeMethod('getRegion');
    } catch (e) {
      return null;
    }
  }

  static Future<bool> setRegion(String region) async {
    try {
      return await _channel.invokeMethod('setRegion', {'region': region}) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> inventoryOnce({int timeout = 5000}) async {
    try {
      // بدء القراءة عبر التطبيق الأساسي
      await _channel.invokeMethod('inventoryOnce', {'timeout': timeout});

      // انتظار النتيجة من EventChannel
      final completer = Completer<String?>();
      late StreamSubscription subscription;

      subscription = tagStream.listen((tag) {
        if (!completer.isCompleted) {
          completer.complete(tag);
          subscription.cancel();
        }
      });

      // انتظار لمدة timeout
      Timer(Duration(milliseconds: timeout), () {
        if (!completer.isCompleted) {
          completer.complete(null);
          subscription.cancel();
        }
      });

      return await completer.future;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> inventoryStart() async {
    try {
      return await _channel.invokeMethod('inventoryStart') ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> inventoryStop() async {
    try {
      return await _channel.invokeMethod('inventoryStop') ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<int> getTagIDCount() async {
    try {
      return await _channel.invokeMethod('getTagIDCount') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<String>> getTagIDs() async {
    try {
      final result = await _channel.invokeMethod('getTagIDs');
      return (result as List?)?.cast<String>() ?? [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> writeTagData({
    required String epc,
    String password = "00000000",
    int bank = 1,
    int offset = 0,
    required String data,
  }) async {
    try {
      return await _channel.invokeMethod('writeTagData', {
        'epc': epc,
        'password': password,
        'bank': bank,
        'offset': offset,
        'data': data,
      }) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> readTagData({
    required String epc,
    String password = "00000000",
    int bank = 3,
    int offset = 0,
    int length = 32,
  }) async {
    try {
      return await _channel.invokeMethod('readTagData', {
        'epc': epc,
        'password': password,
        'bank': bank,
        'offset': offset,
        'length': length,
      });
    } catch (e) {
      return null;
    }
  }
}
