import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';

import 'package:coin_flip/screens/user_record_screen/image_cache.dart';

Widget getImageWidget(String imageUrl,
    {double height = 60, double width = 60}) {
  return FutureBuilder<Uint8List>(
    future: ImageCacheManager.getFromCache(imageUrl),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        }
        if (snapshot.hasData) {
          final Uint8List imageData = snapshot.data!;
          String mimeType = getMimeType(imageData);
          if (mimeType == 'image/svg+xml') {
            return SvgPicture.memory(
              imageData,
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          } else {
            // Здесь используется CachedNetworkImage для растровых изображений
            return CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.red),
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          }
        } else {
          return const Icon(Icons.error, color: Colors.red);
        }
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else {
        return const Icon(Icons.error, color: Colors.red);
      }
    },
  );
}

String getMimeType(Uint8List bytes) {
  // Simple data type check
  if (bytes.length > 4 &&
      bytes[0] == 0x3C && // <
      bytes[1] == 0x73 && // s
      bytes[2] == 0x76 && // v
      bytes[3] == 0x67 && // g
      bytes[4] == 0x20) {
    // space
    return 'image/svg+xml';
  }
  return 'image/png'; // Assume everything else is bitmap
}
