import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: Text(
        LocaleKeys.source_of_image.tr(),
        style: const TextStyle(
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
            title: Text(
              LocaleKeys.gallery.tr(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: onGalleryTap,
          ),
          ListTile(
            leading: const Icon(
              Icons.camera_enhance_rounded,
              color: Colors.amber,
            ),
            title: Text(
              LocaleKeys.camera.tr(),
              style: TextStyle(color: Colors.white),
            ),
            onTap: onCameraTap,
          ),
        ],
      ),
    );
  }
}
