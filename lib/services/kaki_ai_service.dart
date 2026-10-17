// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// /// Service for communicating with the deployed Kaki AI Firebase callable function.
// class KakiAiService {
//   KakiAiService._();

//   static final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
//     region: 'us-central1',
//   );

//   static Future<String> ask(String question) async {
//     final trimmedQuestion = question.trim();
//     if (trimmedQuestion.isEmpty) {
//       throw const KakiAiException('اكتب السؤال أولاً.');
//     }

//     try {
//       // The callable function requires req.auth. Make sure the same Firebase
//       // Auth session used by the app has a valid ID token before calling it.
//       final auth = FirebaseAuth.instance;
//       final user = auth.currentUser;

//       if (user == null) {
//         throw const KakiAiException(
//           'لا يوجد مستخدم مسجل الدخول في Firebase Auth. سجّل الدخول أولاً.',
//         );
//       }

//       // Force-refresh the token during integration so the callable request
//       // definitely carries the current Firebase Auth credentials.
//       await user.getIdToken(true);

//       final callable = _functions.httpsCallable(
//         'analyze_gold_business_system',
//         options: HttpsCallableOptions(
//           timeout: const Duration(seconds: 120),
//         ),
//       );

//       final response = await callable.call(<String, dynamic>{
//         'query': trimmedQuestion,
//       });

//       final data = response.data;

//       if (data is Map) {
//         final answer = data['answer'];
//         if (answer != null && answer.toString().trim().isNotEmpty) {
//           return answer.toString().trim();
//         }
//       }

//       if (data != null && data.toString().trim().isNotEmpty) {
//         return data.toString().trim();
//       }

//       throw const KakiAiException('وصل رد فارغ من خادم كاكي.');
//     } on FirebaseFunctionsException catch (e) {
//       final message = e.message?.trim();
//       final details = e.details?.toString().trim();

//       if (message != null && message.isNotEmpty) {
//         throw KakiAiException(
//           'خطأ من خادم كاكي: $message\nالكود: ${e.code}',
//         );
//       }

//       if (details != null && details.isNotEmpty) {
//         throw KakiAiException(
//           'خطأ من خادم كاكي: $details\nالكود: ${e.code}',
//         );
//       }

//       throw KakiAiException(
//         'فشل الاتصال بالمساعد الذكي.\nالكود: ${e.code}',
//       );
//     } catch (e) {
//       if (e is KakiAiException) {
//         rethrow;
//       }

//       throw KakiAiException('خطأ أثناء الاتصال بكاكي: $e');
//     }
//   }
// }

// class KakiAiException implements Exception {
//   final String message;

//   const KakiAiException(this.message);

//   @override
//   String toString() => message;
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================
/// KAKI AI SERVICE
/// ============================================================
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
      // The callable function requires req.auth. Make sure the same Firebase
      // Auth session used by the app has a valid ID token before calling it.
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser;

      if (user == null) {
        throw const KakiAiException(
          'لا يوجد مستخدم مسجل الدخول في Firebase Auth. سجّل الدخول أولاً.',
        );
      }

      // Force-refresh the token during integration so the callable request
      // definitely carries the current Firebase Auth credentials.
      await user.getIdToken(true);

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
      if (e is KakiAiException) {
        rethrow;
      }

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

/// ============================================================
/// KAKI PASSWORD SERVICE
/// باسورد شات كاكي — مربوط بالـ UID في Firestore
/// كل الأجهزة اللي داخلة بنفس الحساب هتقرأ نفس الباسورد.
/// ============================================================
class KakiPasswordService {
  KakiPasswordService._();

  static const String _defaultPassword = '0000';
  static const String _unlockTimeKey = 'kaki_chat_unlock_time';
  static const String _unlockUidKey = 'kaki_chat_unlock_uid';
  static const Duration _sessionDuration = Duration(hours: 24);

  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference<Map<String, dynamic>>? _docRef() {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('kaki_chat');
  }

  /// يقرأ الباسورد من Firestore.
  /// لو الـ document مش موجود → ينشئه بالباسورد الافتراضي "0000".
  static Future<String> getPassword() async {
    final docRef = _docRef();
    if (docRef == null) {
      throw const KakiPasswordException('لا يوجد مستخدم مسجل الدخول.');
    }
    try {
      final snap = await docRef.get();
      if (!snap.exists) {
        await docRef.set({
          'password': _defaultPassword,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return _defaultPassword;
      }
      final pass = snap.data()?['password']?.toString();
      if (pass == null || pass.isEmpty) return _defaultPassword;
      return pass;
    } catch (e) {
      throw KakiPasswordException('فشل قراءة باسورد الشات: $e');
    }
  }

  /// يحفظ الباسورد الجديد في Firestore.
  /// (المستخدم لازم يكون أدخل الباسورد الحالي صح قبل النداء ده.)
  static Future<void> setPassword(String newPassword) async {
    final docRef = _docRef();
    if (docRef == null) {
      throw const KakiPasswordException('لا يوجد مستخدم مسجل الدخول.');
    }
    try {
      await docRef.set(
        {
          'password': newPassword,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw KakiPasswordException('فشل حفظ الباسورد: $e');
    }
  }

  /// يتحقق من الباسورد المدخل ضد القيمة المخزنة.
  static Future<bool> verifyPassword(String input) async {
    final stored = await getPassword();
    return stored == input.trim();
  }

  /// يحفظ جلسة فتح الشات لمدة 24 ساعة على الجهاز الحالي (مربوطة بالـ UID).
  static Future<void> markUnlocked() async {
    final uid = _uid;
    if (uid == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unlockTimeKey, DateTime.now().millisecondsSinceEpoch);
    await prefs.setString(_unlockUidKey, uid);
  }

  /// هل الشات مفتوح حالياً على الجهاز ده (خلال آخر 24 ساعة)؟
  static Future<bool> isUnlocked() async {
    final uid = _uid;
    if (uid == null) return false;
    final prefs = await SharedPreferences.getInstance();
    final savedUid = prefs.getString(_unlockUidKey);
    if (savedUid != uid) return false;
    final ts = prefs.getInt(_unlockTimeKey);
    if (ts == null) return false;
    final elapsed = DateTime.now().millisecondsSinceEpoch - ts;
    return elapsed < _sessionDuration.inMilliseconds;
  }

  /// يمسح الجلسة (مثلاً عند تسجيل الخروج).
  static Future<void> clearUnlock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockTimeKey);
    await prefs.remove(_unlockUidKey);
  }
}

class KakiPasswordException implements Exception {
  final String message;
  const KakiPasswordException(this.message);
  @override
  String toString() => message;
}
