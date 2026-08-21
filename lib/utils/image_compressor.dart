import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File?> compressImage(File file) async {
  final dir = await getTemporaryDirectory();

  final targetPath = p.join(
    dir.path,
    'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  final XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 60,
    minWidth: 1280,
    minHeight: 1280,
    format: CompressFormat.jpeg,
    keepExif: false,
  );

  if (result == null) return null;

  // ✅ التحويل الصحيح
  return File(result.path);
}
