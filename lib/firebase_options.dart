import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('This platform is not configured.');
    }
  }

  // Android (com.example.uhf_gold_shop)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeQl4oLMUu807w0ylWTsBmQAoLw6e3ZoE',
    appId: '1:687907492866:android:ad879051128b83222a831b',
    messagingSenderId: '687907492866',
    projectId: 'kaki-f9832',
    storageBucket: 'kaki-f9832.firebasestorage.app',
  );
}
