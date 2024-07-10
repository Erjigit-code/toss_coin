import 'package:coin_flip/services/image_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/background_bloc/background_bloc.dart';

enum ImagePickerType { background, avatar }

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final BuildContext context;

  ImagePickerService(this.context);

  Future<void> pickImage(ImageSource source, Function(String) onImageSelected,
      ImagePickerType type) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      onImageSelected(pickedFile.path);
      if (type == ImagePickerType.background) {
        BlocProvider.of<BackgroundBloc>(context)
            .add(ChangeBackground(pickedFile.path));
      }
    }
  }

  Future<void> requestGalleryPermission(
      Function(String) onImageSelected, ImagePickerType type) async {
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      await pickImage(ImageSource.gallery, onImageSelected, type);
    } else {
      _showPermissionDeniedDialog();
    }
  }

  Future<void> requestCameraPermission(
      Function(String) onImageSelected, ImagePickerType type) async {
    if (await Permission.camera.request().isGranted) {
      await pickImage(ImageSource.camera, onImageSelected, type);
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

  Future<void> showImageSourceDialog(
      Function(String) onImageSelected, ImagePickerType type) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceDialog(
          onGalleryTap: () {
            Navigator.of(context).pop();
            requestGalleryPermission(onImageSelected, type);
          },
          onCameraTap: () {
            Navigator.of(context).pop();
            requestCameraPermission(onImageSelected, type);
          },
        );
      },
    );
  }
}
