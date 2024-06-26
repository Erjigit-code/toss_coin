import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String backgroundImage;

  const BackgroundWidget({super.key, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        backgroundImage,
        fit: BoxFit.cover,
        cacheWidth: 1000, // Предварительная загрузка изображения с кэшированием
      ),
    );
  }
}
