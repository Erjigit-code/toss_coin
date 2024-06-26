part of 'background_bloc.dart';

abstract class BackgroundEvent extends Equatable {
  const BackgroundEvent();

  @override
  List<Object> get props => [];
}

class LoadBackgrounds extends BackgroundEvent {
  final List<Map<String, String>> backgrounds;

  const LoadBackgrounds(this.backgrounds);

  @override
  List<Object> get props => [backgrounds];
}

class LoadPreferences extends BackgroundEvent {
  final String backgroundImage;

  const LoadPreferences({required this.backgroundImage});

  @override
  List<Object> get props => [backgroundImage];
}

class ChangeBackground extends BackgroundEvent {
  final String newBackground;

  const ChangeBackground(this.newBackground);

  @override
  List<Object> get props => [newBackground];
}
