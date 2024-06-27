import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  CoinBloc()
      : super(const CoinInitial(
            currentStreak: 0,
            record: 0,
            isHeads: false,
            userPrediction: '',
            selectedCoin: 'euro')) {
    on<FlipCoin>(_onFlipCoin);
    on<_RecordLoaded>(_onRecordLoaded);
    on<UpdateStreakAndRecord>(_onUpdateStreakAndRecord);
    on<ResetRecord>(_onResetRecord);
    on<_PreferencesLoaded>(_onCoinPreferencesLoaded);
    on<ChangeCoin>(_onChangeCoin);
    on<LoadCoinPreferences>(_onLoadCoinPreferences);
  }

  Future<void> _onLoadCoinPreferences(
      LoadCoinPreferences event, Emitter<CoinState> emit) async {
    print("Loading coin preferences...");
    try {
      final prefs = await SharedPreferences.getInstance();
      final record = prefs.getInt('record') ?? 0;
      final selectedCoin = prefs.getString('selectedCoin') ?? 'euro';
      emit(CoinPreferencesLoaded(record, selectedCoin));
      print("Coin preferences successfully loaded.");
    } catch (e) {
      emit(CoinError("Error loading coin preferences."));
      print("Error loading coin preferences: $e");
    }
  }

  void _onChangeCoin(ChangeCoin event, Emitter<CoinState> emit) async {
    emit(CoinChanged(state.currentStreak, state.record, state.isHeads,
        state.userPrediction, event.newCoin));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCoin', event.newCoin);
  }

  void _onFlipCoin(FlipCoin event, Emitter<CoinState> emit) {
    emit(state.copyWith(
        isHeads: event.isHeads, userPrediction: event.userPrediction));
    add(UpdateStreakAndRecord(event.userPrediction, event.isHeads));
  }

  void _onUpdateStreakAndRecord(
      UpdateStreakAndRecord event, Emitter<CoinState> emit) {
    int newStreak = state.currentStreak;
    int newRecord = state.record;

    if (event.userPrediction == (event.isHeads ? 'Head' : 'Tail')) {
      newStreak++;
      if (newStreak > newRecord) {
        newRecord = newStreak;
        _saveRecord(newRecord);
      }
    } else {
      newStreak = 0;
    }

    final newState = CoinFlipped(event.isHeads, newStreak, newRecord,
        state.userPrediction, state.selectedCoin);
    emit(newState);
  }

  Future<void> _saveRecord(int record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('record', record);
  }

  void _onRecordLoaded(_RecordLoaded event, Emitter<CoinState> emit) {
    emit(state.copyWith(record: event.record));
  }

  Future<void> _onResetRecord(
      ResetRecord event, Emitter<CoinState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('record', 0);
    emit(state.copyWith(record: 0));
  }

  void _onCoinPreferencesLoaded(
      _PreferencesLoaded event, Emitter<CoinState> emit) {
    emit(
        state.copyWith(record: event.record, selectedCoin: event.selectedCoin));
  }
}
