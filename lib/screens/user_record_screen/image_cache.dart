import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager {
  static final CacheManager customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 15),
      maxNrOfCacheObjects: 100,
    ),
  );

  static Future<Uint8List> getFromCache(String url) async {
    try {
      FileInfo? fileInfo = await customCacheManager.getFileFromCache(url);
      if (fileInfo != null) {
        return await fileInfo.file.readAsBytes();
      } else {
        return await downloadAndCacheImage(url);
      }
    } catch (e) {
      return await downloadAndCacheImage(url);
    }
  }

  static Future<Uint8List> downloadAndCacheImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await customCacheManager.putFile(url, response.bodyBytes);
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
