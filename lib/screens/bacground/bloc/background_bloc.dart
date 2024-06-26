import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart'; // Для precacheImage
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'background_event.dart';
part 'background_state.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  final BuildContext context;

  BackgroundBloc(this.context) : super(BackgroundInitial()) {
    on<LoadBackgrounds>(_onLoadBackgrounds);
    on<LoadPreferences>(_onLoadPreferences);
    on<ChangeBackground>(_onChangeBackground);
  }

  void _precacheImages(List<Map<String, String>> backgrounds) {
    for (var background in backgrounds) {
      precacheImage(AssetImage(background['path']!), context);
    }
  }

  void _onLoadBackgrounds(
      LoadBackgrounds event, Emitter<BackgroundState> emit) {
    _precacheImages(event.backgrounds); // Предварительная загрузка изображений
    emit(BackgroundsLoaded(event.backgrounds, 'assets/images/school.jpeg'));
  }

  void _onLoadPreferences(
      LoadPreferences event, Emitter<BackgroundState> emit) {
    if (state is BackgroundsLoaded) {
      emit(BackgroundsLoaded(
          (state as BackgroundsLoaded).backgrounds, event.backgroundImage));
    }
  }

  void _onChangeBackground(
      ChangeBackground event, Emitter<BackgroundState> emit) async {
    if (state is BackgroundsLoaded) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('backgroundImage', event.newBackground);
      emit((state as BackgroundsLoaded)
          .copyWith(selectedPath: event.newBackground));
    }
  }
}
