part of 'coin_bloc.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class FlipCoin extends CoinEvent {
  final bool isHeads;
  final String userPrediction;

  const FlipCoin(this.isHeads, this.userPrediction);

  @override
  List<Object> get props => [isHeads, userPrediction];
}

class _RecordLoaded extends CoinEvent {
  final int record;

  const _RecordLoaded(this.record);

  @override
  List<Object> get props => [record];
}

class UpdateStreakAndRecord extends CoinEvent {
  final String userPrediction;
  final bool isHeads;

  const UpdateStreakAndRecord(this.userPrediction, this.isHeads);

  @override
  List<Object> get props => [userPrediction, isHeads];
}

class ResetRecord extends CoinEvent {}

class _PreferencesLoaded extends CoinEvent {
  final int record;
  final String selectedCoin;

  const _PreferencesLoaded(this.record, this.selectedCoin);

  @override
  List<Object> get props => [record, selectedCoin];
}

class ChangeCoin extends CoinEvent {
  final String newCoin;

  const ChangeCoin(this.newCoin);

  @override
  List<Object> get props => [newCoin];
}

class LoadCoinPreferences extends CoinEvent {}
