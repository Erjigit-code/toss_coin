import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../coin_bloc/coin_bloc.dart';
import '../background_bloc/background_bloc.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  final CoinBloc coinBloc;
  final BackgroundBloc backgroundBloc;

  InitializationBloc({required this.coinBloc, required this.backgroundBloc})
      : super(InitializationInitial()) {
    on<InitializeApp>(_onInitializeApp);
    print("InitializationBloc created with Initial state: $state");
  }

  Future<void> _onInitializeApp(
      InitializeApp event, Emitter<InitializationState> emit) async {
    emit(InitializationLoading());
    print("State changed to InitializationLoading");
    try {
      final box = Hive.box('settings');
      print("Initialization: Hive box opened.");
      final backgroundImage =
          box.get('backgroundImage', defaultValue: 'assets/images/school.jpeg');
      print(
          "Initialization: Background image loaded from Hive: $backgroundImage");

      // Проверка, что события вызываются только один раз
      coinBloc.add(LoadCoinPreferences());
      backgroundBloc.add(LoadPreferences(backgroundImage: backgroundImage));
      print(
          "Initialization: LoadCoinPreferences and LoadPreferences events added.");

      emit(InitializationLoaded());
      print("State changed to InitializationLoaded");
    } catch (e) {
      final errorMessage = "Error during initialization: $e";
      emit(InitializationError(errorMessage));
      print(errorMessage);
    }
  }
}
