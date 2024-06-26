import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/coin_bloc.dart';
import '../../screens/bacground/bloc/background_bloc.dart';

part 'initialization_event.dart';
part 'initialization_state.dart';

class InitializationBloc
    extends Bloc<InitializationEvent, InitializationState> {
  final CoinBloc coinBloc;
  final BackgroundBloc backgroundBloc;

  InitializationBloc({required this.coinBloc, required this.backgroundBloc})
      : super(InitializationInitial()) {
    on<InitializeApp>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
      InitializeApp event, Emitter<InitializationState> emit) async {
    emit(InitializationLoading());

    final prefs = await SharedPreferences.getInstance();
    final backgroundImage =
        prefs.getString('backgroundImage') ?? 'assets/images/school.jpeg';

    coinBloc.add(LoadCoinPreferences());
    backgroundBloc.add(LoadPreferences(backgroundImage: backgroundImage));

    emit(InitializationLoaded());
  }
}
