import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/print_page.dart'; // هنا موجود PdfReport
import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // ✅ Firebase initialization
    try {
      await Firebase.initializeApp();
    } catch (e) {
      // لو Already initialized مش مشكلة
    }
    final now = DateTime.now();

    if (task == "dailyReport") {
      final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      return await PdfReport.runScheduledReport(start, end);
    }

    if (task == "weeklyReport") {
      final start = now.subtract(Duration(days: now.weekday - 1));
      final end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
      return await PdfReport.runScheduledReport(start, end);
    }

    if (task == "monthlyReport") {
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      return await PdfReport.runScheduledReport(start, end);
    }

    return Future.value(false);
  });
}

/// دالة لتشغيل الجدولة حسب الإعدادات
Future<void> scheduleReportTask() async {
  final prefs = await SharedPreferences.getInstance();
  final freq = prefs.getString('reportFrequency') ?? "daily";

  // لازم نلغي أي tasks قديمة علشان مايبقاش فيه تكرار
  await Workmanager().cancelAll();

  if (freq == "daily") {
    await Workmanager().registerPeriodicTask(
      "dailyTask",
      "dailyReport",
      //frequency: const Duration(hours: 24),
      frequency: const Duration(hours: 24), // ⏰ كل 20 دقيقة
      initialDelay: const Duration(seconds: 10), // ممكن تأخير أول تشغيل دقيقة
      constraints: Constraints(
        networkType: NetworkType.connected, // يشتغل لو فيه إنترنت
      ),
    );
  } else if (freq == "weekly") {
    await Workmanager().registerPeriodicTask(
      "weeklyTask",
      "weeklyReport",
      frequency: const Duration(days: 7),
    );
  } else if (freq == "monthly") {
    await Workmanager().registerPeriodicTask(
      "monthlyTask",
      "monthlyReport",
      frequency: const Duration(days: 30),
    );
  }
}
