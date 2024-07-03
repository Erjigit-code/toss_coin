import 'dart:io'; // добавлено для использования File
import 'dart:ui';

import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/image_picker.dart';
import 'widgets/choose_image.dart';
import '../../bloc/background_bloc/background_bloc.dart';

class BackgroundSelectionScreen extends StatelessWidget {
  final String initialSelectedImage;

  const BackgroundSelectionScreen(
      {super.key, required this.initialSelectedImage});

  @override
  Widget build(BuildContext context) {
    final imagePickerService = ImagePickerService(
        context); // Создайте экземпляр службы выбора изображений

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.background_select.tr()),
      ),
      body: BlocBuilder<BackgroundBloc, BackgroundState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is BackgroundsLoaded) {
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/background/back2.jpeg'), // Путь к вашему изображению
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 85, // резервируем место для кнопки
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: state.backgrounds.length,
                    itemBuilder: (context, index) {
                      final background = state.backgrounds[index];
                      final isAsset = !background.startsWith(
                          '/'); // Проверка, является ли путь ассетом или файлом

                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<BackgroundBloc>(context)
                              .add(ChangeBackground(background));
                          Navigator.pop(context, background);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: isAsset
                                      ? AssetImage(background)
                                      : FileImage(File(
                                          background)), // Используем AssetImage или FileImage
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: state.selectedPath == background
                                    ? Border.all(
                                        color: Colors.white.withOpacity(0.7),
                                        width: 5)
                                    : null,
                              ),
                            ),
                            if (state.selectedPath == background)
                              Icon(
                                Icons.check_circle,
                                color: Colors.white.withOpacity(0.7),
                                size: 100,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ChooseImageButton(
                      onPressed: () {
                        imagePickerService
                            .showImageSourceDialog((selectedImagePath) {
                          // Обработайте выбранное изображение, если нужно
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
