import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<String> uploadItemImage({
    required String epc,
    required File image,
  }) async {
    final ref = _storage
        .ref()
        .child('items_images')
        .child(epc)
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // ✅ مهم جدًا
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      cacheControl: 'public,max-age=3600',
    );

    await ref.putFile(image, metadata);

    return await ref.getDownloadURL();
  }
}
