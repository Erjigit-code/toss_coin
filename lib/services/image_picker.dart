import 'package:coin_flip/screens/bacground/bloc/background_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_source_dialog.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final BuildContext context;

  ImagePickerService(this.context);

  Future<void> pickImage(
      ImageSource source, Function(String) onImageSelected) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      onImageSelected(pickedFile.path);
      BlocProvider.of<BackgroundBloc>(context)
          .add(ChangeBackground(pickedFile.path));
    }
  }

  Future<void> requestGalleryPermission(
      Function(String) onImageSelected) async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      await pickImage(ImageSource.gallery, onImageSelected);
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> requestCameraPermission(Function(String) onImageSelected) async {
    if (await Permission.camera.request().isGranted) {
      await pickImage(ImageSource.camera, onImageSelected);
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> _showPermissionDeniedDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'You have denied the necessary permissions. Please enable them in settings to proceed.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showImageSourceDialog(Function(String) onImageSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceDialog(
          onGalleryTap: () {
            Navigator.of(context).pop();
            requestGalleryPermission(onImageSelected);
          },
          onCameraTap: () {
            Navigator.of(context).pop();
            requestCameraPermission(onImageSelected);
          },
        );
      },
    );
  }
}
