import 'package:cloud_functions/cloud_functions.dart';

/// Service for communicating with the deployed Kaki AI Firebase callable function.
class KakiAiService {
  KakiAiService._();

  static final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'us-central1',
  );

  static Future<String> ask(String question) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const KakiAiException('اكتب السؤال أولاً.');
    }

    try {
      final callable = _functions.httpsCallable(
        'analyze_gold_business_system',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 120),
        ),
      );

      final response = await callable.call(<String, dynamic>{
        'query': trimmedQuestion,
      });

      final data = response.data;

      if (data is Map) {
        final answer = data['answer'];
        if (answer != null && answer.toString().trim().isNotEmpty) {
          return answer.toString().trim();
        }
      }

      if (data != null && data.toString().trim().isNotEmpty) {
        return data.toString().trim();
      }

      throw const KakiAiException('وصل رد فارغ من خادم كاكي.');
    } on FirebaseFunctionsException catch (e) {
      final message = e.message?.trim();
      final details = e.details?.toString().trim();

      // Keep the real Firebase error visible while diagnosing the deployed
      // callable function. This is much more useful than a generic message.
      if (message != null && message.isNotEmpty) {
        throw KakiAiException(
          'خطأ من خادم كاكي: $message\nالكود: ${e.code}',
        );
      }

      if (details != null && details.isNotEmpty) {
        throw KakiAiException(
          'خطأ من خادم كاكي: $details\nالكود: ${e.code}',
        );
      }

      throw KakiAiException(
        'فشل الاتصال بالمساعد الذكي.\nالكود: ${e.code}',
      );
    } catch (e) {
      // Do not hide the actual exception during integration/debugging.
      throw KakiAiException('خطأ أثناء الاتصال بكاكي: $e');
    }
  }
}

class KakiAiException implements Exception {
  final String message;

  const KakiAiException(this.message);

  @override
  String toString() => message;
}
