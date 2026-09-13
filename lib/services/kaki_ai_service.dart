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
      final details = e.message?.trim();
      if (details != null && details.isNotEmpty) {
        throw KakiAiException('$details (${e.code})');
      }

      throw KakiAiException(
        'فشل الاتصال بالمساعد الذكي (${e.code}).',
      );
    } catch (e) {
      if (e is KakiAiException) {
        rethrow;
      }

      throw KakiAiException('حدث خطأ غير متوقع أثناء الاتصال بالمساعد الذكي.');
    }
  }
}

class KakiAiException implements Exception {
  final String message;

  const KakiAiException(this.message);

  @override
  String toString() => message;
}
