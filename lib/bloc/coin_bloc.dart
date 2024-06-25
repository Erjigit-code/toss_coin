import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc()
      : super(
            CoinInitial('assets/images/school.jpeg', 0, 0, false, '', 'euro')) {
    _loadPreferences();
    on<FlipCoin>(_onFlipCoin);
    on<ChangeBackground>(_onChangeBackground);
    on<_RecordLoaded>(_onRecordLoaded);
    on<UpdateStreakAndRecord>(_onUpdateStreakAndRecord);
    on<ResetRecord>(_onResetRecord);
    on<_PreferencesLoaded>(_onPreferencesLoaded);
    on<ChangeCoin>(_onChangeCoin);
  }

  void _onChangeCoin(ChangeCoin event, Emitter<CoinState> emit) async {
    emit(CoinChanged(state.backgroundImage, state.currentStreak, state.record,
        state.isHeads, state.userPrediction, event.newCoin));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'selectedCoin', event.newCoin); // Save the selected coin
  }

  void _onFlipCoin(FlipCoin event, Emitter<CoinState> emit) {
    print(
        'FlipCoin event: isHeads = ${event.isHeads}, userPrediction = ${event.userPrediction}');
    emit(state.copyWith(
        isHeads: event.isHeads, userPrediction: event.userPrediction));
    add(UpdateStreakAndRecord(event.userPrediction, event.isHeads));
  }

  void _onUpdateStreakAndRecord(
      UpdateStreakAndRecord event, Emitter<CoinState> emit) {
    int newStreak = state.currentStreak;
    int newRecord = state.record;

    if (event.userPrediction == (event.isHeads ? 'Решка' : 'Орёл')) {
      newStreak++;
      if (newStreak > newRecord) {
        newRecord = newStreak;
        _saveRecord(newRecord);
      }
    } else {
      newStreak = 0;
    }

    print(
        'UpdateStreakAndRecord event: isHeads = ${event.isHeads}, newStreak = $newStreak, newRecord = $newRecord');
    final newState = CoinFlipped(event.isHeads, state.backgroundImage,
        newStreak, newRecord, state.userPrediction, state.selectedCoin);
    emit(newState);
  }

  void _onChangeBackground(
      ChangeBackground event, Emitter<CoinState> emit) async {
    emit(BackgroundChanged(event.newBackground, state.currentStreak,
        state.record, state.isHeads, state.userPrediction, state.selectedCoin));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundImage', event.newBackground);
  }

  void _saveRecord(int record) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('record', record);
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final record = prefs.getInt('record') ?? 0;
    final backgroundImage =
        prefs.getString('backgroundImage') ?? 'assets/images/school.jpeg';
    final selectedCoin = prefs.getString('selectedCoin') ?? 'euro';
    add(_PreferencesLoaded(record, backgroundImage, selectedCoin));
  }

  void _onRecordLoaded(_RecordLoaded event, Emitter<CoinState> emit) {
    emit(state.copyWith(record: event.record));
  }

  void _onResetRecord(ResetRecord event, Emitter<CoinState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('record', 0);
    emit(state.copyWith(record: 0));
  }

  void _onPreferencesLoaded(_PreferencesLoaded event, Emitter<CoinState> emit) {
    emit(state.copyWith(
        record: event.record,
        backgroundImage: event.backgroundImage,
        selectedCoin: event.selectedCoin));
  }
}
