import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'dart:typed_data';

Widget getImageWidget(String imageUrl) {
  return FutureBuilder<Uint8List>(
    future: fetchImage(imageUrl),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return const Icon(Icons.error, color: Colors.red);
        }

        if (snapshot.hasData) {
          final Uint8List imageData = snapshot.data!;
          final String mimeType = getMimeType(imageData);

          if (mimeType == 'image/svg+xml') {
            return SvgPicture.memory(
              imageData,
              placeholderBuilder: (BuildContext context) =>
                  const CircularProgressIndicator(),
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            );
          } else {
            return Image.memory(
              imageData,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
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

Future<Uint8List> fetchImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image');
  }
}

String getMimeType(Uint8List bytes) {
  // Простая проверка типа данных
  if (bytes.length > 4 &&
          bytes[0] == 0x3C && // <
          bytes[1] == 0x73 && // s
          bytes[2] == 0x76 && // v
          bytes[3] == 0x67 && // g
          bytes[4] == 0x20 // space
      ) {
    return 'image/svg+xml';
  }
  return 'image/png'; // Предполагаем, что все остальные - растровые изображения
}
