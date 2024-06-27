import 'dart:io'; // Добавлено для использования File
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'background_event.dart';
part 'background_state.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  final BuildContext context;

  BackgroundBloc(this.context) : super(BackgroundInitial()) {
    on<LoadBackgrounds>(_onLoadBackgrounds);
    on<LoadPreferences>(_onLoadPreferences);
    on<ChangeBackground>(_onChangeBackground);
  }

  void _onLoadBackgrounds(
      LoadBackgrounds event, Emitter<BackgroundState> emit) {
    print("Loading backgrounds...");
    try {
      emit(BackgroundsLoaded(event.backgrounds, 'assets/images/school.jpeg'));
      print("Backgrounds successfully loaded.");
    } catch (e) {
      print("Error loading backgrounds: $e");
    }
  }

  void _onLoadPreferences(
      LoadPreferences event, Emitter<BackgroundState> emit) async {
    final box = Hive.box('settings');
    try {
      final backgroundImage =
          box.get('backgroundImage', defaultValue: 'assets/images/school.jpeg');
      print("Loaded background image from Hive: $backgroundImage");
      if (state is BackgroundsLoaded) {
        emit(BackgroundsLoaded(
            (state as BackgroundsLoaded).backgrounds, backgroundImage));
        print("Preferences successfully loaded.");
      }
    } catch (e) {
      print("Error loading preferences: $e");
    }
  }

  void _onChangeBackground(
      ChangeBackground event, Emitter<BackgroundState> emit) async {
    if (state is BackgroundsLoaded) {
      final box = Hive.box('settings');
      try {
        await box.put('backgroundImage', event.newBackground);
        print("Changed background to: ${event.newBackground}");
        await _precacheImage(event.newBackground);
        emit((state as BackgroundsLoaded)
            .copyWith(selectedPath: event.newBackground));
        print("Background successfully changed and precached.");
      } catch (e) {
        print("Error changing background: $e");
      }
    }
  }

  Future<void> _precacheImage(String imagePath) async {
    final isAsset = !imagePath.startsWith('/');
    if (isAsset) {
      await precacheImage(AssetImage(imagePath), context);
    } else {
      await precacheImage(FileImage(File(imagePath)), context);
    }
  }
}
