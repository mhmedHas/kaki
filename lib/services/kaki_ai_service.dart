import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

/// Service for communicating with the deployed Kaki AI HTTP endpoint.
class KakiAiService {
  KakiAiService._();

  static const String endpoint =
      'https://analyze-gold-business-system-usqjvtuvvq-uc.a.run.app';

  static Future<String> ask(String question) async {
    final trimmedQuestion = question.trim();
    if (trimmedQuestion.isEmpty) {
      throw const KakiAiException('اكتب السؤال أولاً.');
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const KakiAiException('يجب تسجيل الدخول أولاً.');
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Send the Firebase ID token when available. The backend can verify it
    // without exposing any Firebase credentials in the Flutter app.
    try {
      final token = await user.getIdToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Keep the request usable for deployments where the endpoint is public.
    }

    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: headers,
          body: jsonEncode({
            'query': trimmedQuestion,
          }),
        )
        .timeout(const Duration(seconds: 90));

    return _parseResponse(response);
  }

  static String _parseResponse(http.Response response) {
    dynamic data;

    try {
      data = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      data = utf8.decode(response.bodyBytes);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'تعذر الحصول على رد من خادم كاكي.';

      if (data is Map<String, dynamic>) {
        final value = data['error'] ?? data['message'] ?? data['detail'];
        if (value != null && value.toString().trim().isNotEmpty) {
          message = value.toString();
        }
      } else if (data is String && data.trim().isNotEmpty) {
        message = data.trim();
      }

      throw KakiAiException('$message (HTTP ${response.statusCode})');
    }

    if (data is Map<String, dynamic>) {
      for (final key in const ['answer', 'response', 'result', 'message']) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    throw const KakiAiException('وصل رد فارغ من خادم كاكي.');
  }
}

class KakiAiException implements Exception {
  final String message;

  const KakiAiException(this.message);

  @override
  String toString() => message;
}
