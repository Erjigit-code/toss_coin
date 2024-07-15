import 'package:coin_flip/services/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerService {
  final BuildContext context;

  ImagePickerService(this.context);

  Future<void> showImageSourceDialog(
      Function(String path) onImagePicked, ImagePickerType type) async {
    // Your existing implementation for picking image
  }
}
