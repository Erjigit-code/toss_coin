import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
    try {
      final box = Hive.box('settings');
      String backgroundImage =
          box.get('backgroundImage', defaultValue: 'assets/images/school.jpeg');
      emit(BackgroundsLoaded(event.backgrounds, backgroundImage));
      print(
          "Backgrounds successfully loaded with default from cache: $backgroundImage");
    } catch (e) {
      print("Error loading backgrounds: $e");
      emit(BackgroundsLoaded(event.backgrounds, 'assets/images/school.jpeg'));
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
        await _precacheImage(event.newBackground);
        emit((state as BackgroundsLoaded)
            .copyWith(selectedPath: event.newBackground));
      } catch (e) {}
    }
  }

  Future<void> _precacheImage(String imagePath) async {
    final isAsset = !imagePath.startsWith('/');
    if (isAsset) {
      await precacheImage(AssetImage(imagePath), context);
    } else {
      final file = File(imagePath);
      await precacheImage(FileImage(file), context);
      await DefaultCacheManager().putFile(imagePath, await file.readAsBytes());
    }
  }
}
