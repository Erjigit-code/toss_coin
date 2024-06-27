part of 'background_bloc.dart';

abstract class BackgroundState extends Equatable {
  const BackgroundState();

  @override
  List<Object> get props => [];
}

class BackgroundInitial extends BackgroundState {}

class BackgroundsLoaded extends BackgroundState {
  final List<String> backgrounds;
  final String selectedPath;

  const BackgroundsLoaded(this.backgrounds, this.selectedPath);

  BackgroundsLoaded copyWith({
    List<String>? backgrounds,
    String? selectedPath,
  }) {
    return BackgroundsLoaded(
      backgrounds ?? this.backgrounds,
      selectedPath ?? this.selectedPath,
    );
  }

  @override
  List<Object> get props => [backgrounds, selectedPath];
}
