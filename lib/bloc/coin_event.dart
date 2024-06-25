part of 'coin_bloc.dart';

abstract class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

class FlipCoin extends CoinEvent {
  final String userPrediction;
  final bool isHeads;

  const FlipCoin(this.userPrediction, this.isHeads);

  @override
  List<Object> get props => [userPrediction, isHeads];
}

class ChangeBackground extends CoinEvent {
  final String newBackground;

  const ChangeBackground(this.newBackground);

  @override
  List<Object> get props => [newBackground];
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
  final String backgroundImage;
  final String selectedCoin;

  const _PreferencesLoaded(
      this.record, this.backgroundImage, this.selectedCoin);

  @override
  List<Object> get props => [record, backgroundImage, selectedCoin];
}

class ChangeCoin extends CoinEvent {
  final String newCoin;

  const ChangeCoin(this.newCoin);

  @override
  List<Object> get props => [newCoin];
}
