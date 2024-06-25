import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../services/image_picker.dart';
import '../widgets/choose_image.dart';

class BackgroundSelectionScreen extends StatefulWidget {
  final String initialSelectedImage;

  const BackgroundSelectionScreen(
      {super.key, required this.initialSelectedImage});

  @override
  _BackgroundSelectionScreenState createState() =>
      _BackgroundSelectionScreenState();
}

class _BackgroundSelectionScreenState extends State<BackgroundSelectionScreen> {
  final ValueNotifier<String> _selectedImageNotifier =
      ValueNotifier<String>('');
  late ImagePickerService _imagePickerService;

  final List<Map<String, String>> backgrounds = [
    {'path': 'assets/images/school.jpeg', 'title': 'School'},
    {'path': 'assets/images/stadium.jpeg', 'title': 'Stadium'},
    {'path': 'assets/images/pool.jpeg', 'title': 'Pool'},
    {'path': 'assets/images/space.jpeg', 'title': 'Space'},
    {'path': 'assets/images/view.jpg', 'title': 'View'},
    {'path': 'assets/images/house.jpeg', 'title': 'House'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedImageNotifier.value = widget.initialSelectedImage;
    _imagePickerService = ImagePickerService(context);
  }

  @override
  void dispose() {
    _selectedImageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Выбор Фона",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context, _selectedImageNotifier.value);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/back2.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
                  child: Center(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: backgrounds.length,
                      itemBuilder: (context, index) {
                        final background = backgrounds[index];
                        return ValueListenableBuilder<String>(
                          valueListenable: _selectedImageNotifier,
                          builder: (context, selectedImage, child) {
                            return _buildImageTile(
                                background['path']!, background['title']!);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              ChooseImageButton(
                onPressed: () {
                  _imagePickerService.showImageSourceDialog((selectedPath) {
                    _selectedImageNotifier.value = selectedPath;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(String imagePath, String title) {
    return GestureDetector(
      onTap: () {
        _selectedImageNotifier.value = imagePath;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imagePath.startsWith('/')
                    ? FileImage(File(imagePath))
                    : AssetImage(imagePath) as ImageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
              border: _selectedImageNotifier.value == imagePath
                  ? Border.all(color: Colors.white.withOpacity(0.7), width: 5)
                  : null,
            ),
          ),
          if (_selectedImageNotifier.value == imagePath)
            Icon(
              Icons.check_circle,
              color: Colors.white.withOpacity(0.7),
              size: 100,
            ),
        ],
      ),
    );
  }
}
