import 'package:flutter/material.dart';

class ImageSourceDialog extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const ImageSourceDialog({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black.withOpacity(0.65),
      title: const Text(
        'Выберите источник изображения',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(
              Icons.photo_size_select_actual_outlined,
              color: Colors.amber,
            ),
            title: const Text(
              'Галерея',
              style: TextStyle(color: Colors.white),
            ),
            onTap: onGalleryTap,
          ),
          ListTile(
            leading: const Icon(
              Icons.camera_enhance_rounded,
              color: Colors.amber,
            ),
            title: const Text(
              'Камера',
              style: TextStyle(color: Colors.white),
            ),
            onTap: onCameraTap,
          ),
        ],
      ),
    );
  }
}
