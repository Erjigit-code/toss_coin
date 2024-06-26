part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  final int currentStreak;
  final int record;
  final bool isHeads;
  final String userPrediction;
  final String selectedCoin;

  const CoinState(this.currentStreak, this.record, this.isHeads,
      this.userPrediction, this.selectedCoin);

  @override
  List<Object> get props =>
      [currentStreak, record, isHeads, userPrediction, selectedCoin];

  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinInitial(
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      isHeads ?? this.isHeads,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinInitial extends CoinState {
  const CoinInitial(int currentStreak, int record, bool isHeads,
      String userPrediction, String selectedCoin)
      : super(currentStreak, record, isHeads, userPrediction, selectedCoin);
}

class CoinFlipping extends CoinState {
  const CoinFlipping(int currentStreak, int record, bool isHeads,
      String userPrediction, String selectedCoin)
      : super(currentStreak, record, isHeads, userPrediction, selectedCoin);
}

class CoinFlipped extends CoinState {
  const CoinFlipped(bool isHeads, int currentStreak, int record,
      String userPrediction, String selectedCoin)
      : super(currentStreak, record, isHeads, userPrediction, selectedCoin);

  @override
  List<Object> get props =>
      [isHeads, currentStreak, record, userPrediction, selectedCoin];
}

class CoinChanged extends CoinState {
  const CoinChanged(int currentStreak, int record, bool isHeads,
      String userPrediction, String selectedCoin)
      : super(currentStreak, record, isHeads, userPrediction, selectedCoin);
}
