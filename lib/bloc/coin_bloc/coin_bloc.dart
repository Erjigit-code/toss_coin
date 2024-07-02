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
            selectedCoin: 'euro',
            totalFlips: 0,
            headsCount: 0,
            tailsCount: 0)) {
    on<FlipCoin>(_onFlipCoin);
    on<_RecordLoaded>(_onRecordLoaded);
    on<UpdateStreakAndRecord>(_onUpdateStreakAndRecord);
    on<ResetRecord>(_onResetRecord);
    on<_PreferencesLoaded>(_onCoinPreferencesLoaded);
    on<ChangeCoin>(_onChangeCoin);
    on<LoadCoinPreferences>(_onLoadCoinPreferences);
    on<LoadStatistics>(
        _onLoadStatistics); // Добавляем обработчик события LoadStatistics
  }

  Future<void> _onLoadCoinPreferences(
      LoadCoinPreferences event, Emitter<CoinState> emit) async {
    print("Loading coin preferences...");
    try {
      final prefs = await SharedPreferences.getInstance();
      final record = prefs.getInt('record') ?? 0;
      final selectedCoin = prefs.getString('selectedCoin') ?? 'euro';
      final totalFlips = prefs.getInt('totalFlips') ?? 0;
      final headsCount = prefs.getInt('headsCount') ?? 0;
      final tailsCount = prefs.getInt('tailsCount') ?? 0;
      final currentStreak = prefs.getInt('currentStreak') ?? 0;

      emit(CoinPreferencesLoaded(record, selectedCoin, totalFlips, headsCount,
          tailsCount, currentStreak));
      print("Coin preferences successfully loaded.");
    } catch (e) {
      emit(CoinError("Error loading coin preferences."));
      print("Error loading coin preferences: $e");
    }
  }

  void _onChangeCoin(ChangeCoin event, Emitter<CoinState> emit) async {
    emit(CoinChanged(
        state.currentStreak,
        state.record,
        state.isHeads,
        state.userPrediction,
        event.newCoin,
        state.totalFlips,
        state.headsCount,
        state.tailsCount));
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
    int newTotalFlips = state.totalFlips + 1;
    int newHeadsCount = state.headsCount + (event.isHeads ? 1 : 0);
    int newTailsCount = state.tailsCount + (event.isHeads ? 0 : 1);

    if (event.userPrediction == (event.isHeads ? 'Head' : 'Tail')) {
      newStreak++;
      if (newStreak > newRecord) {
        newRecord = newStreak;
        _saveRecord(newRecord);
      }
    } else {
      newStreak = 0;
    }

    _saveStatistics(newStreak, newTotalFlips, newHeadsCount, newTailsCount);

    final newState = CoinFlipped(
        event.isHeads,
        newStreak,
        newRecord,
        state.userPrediction,
        state.selectedCoin,
        newTotalFlips,
        newHeadsCount,
        newTailsCount);
    emit(newState);
  }

  Future<void> _saveStatistics(
      int currentStreak, int totalFlips, int headsCount, int tailsCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentStreak', currentStreak);
    await prefs.setInt('totalFlips', totalFlips);
    await prefs.setInt('headsCount', headsCount);
    await prefs.setInt('tailsCount', tailsCount);
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
    await prefs.setInt('currentStreak', 0);
    await prefs.setInt('totalFlips', 0);
    await prefs.setInt('headsCount', 0);
    await prefs.setInt('tailsCount', 0);
    emit(state.copyWith(
        record: 0,
        currentStreak: 0,
        totalFlips: 0,
        headsCount: 0,
        tailsCount: 0));
  }

  void _onCoinPreferencesLoaded(
      _PreferencesLoaded event, Emitter<CoinState> emit) {
    emit(
        state.copyWith(record: event.record, selectedCoin: event.selectedCoin));
  }

  void _onLoadStatistics(LoadStatistics event, Emitter<CoinState> emit) {
    final totalFlips = state.totalFlips;
    final headsCount = state.headsCount;
    final tailsCount = state.tailsCount;
    final selectedCoin = state.selectedCoin;

    emit(StatisticsLoaded(totalFlips, headsCount, tailsCount, selectedCoin));
  }
}
