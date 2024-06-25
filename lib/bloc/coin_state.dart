part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  final String backgroundImage;
  final int currentStreak;
  final int record;
  final bool isHeads;
  final String userPrediction;
  final String selectedCoin;

  const CoinState(this.backgroundImage, this.currentStreak, this.record,
      this.isHeads, this.userPrediction, this.selectedCoin);

  @override
  List<Object> get props => [
        backgroundImage,
        currentStreak,
        record,
        isHeads,
        userPrediction,
        selectedCoin
      ];

  CoinState copyWith({
    String? backgroundImage,
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinInitial(
      backgroundImage ?? this.backgroundImage,
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      isHeads ?? this.isHeads,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinInitial extends CoinState {
  const CoinInitial(String backgroundImage, int currentStreak, int record,
      bool isHeads, String userPrediction, String selectedCoin)
      : super(backgroundImage, currentStreak, record, isHeads, userPrediction,
            selectedCoin);
}

class CoinFlipping extends CoinState {
  const CoinFlipping(String backgroundImage, int currentStreak, int record,
      bool isHeads, String userPrediction, String selectedCoin)
      : super(backgroundImage, currentStreak, record, isHeads, userPrediction,
            selectedCoin);
}

class CoinFlipped extends CoinState {
  const CoinFlipped(bool isHeads, String backgroundImage, int currentStreak,
      int record, String userPrediction, String selectedCoin)
      : super(backgroundImage, currentStreak, record, isHeads, userPrediction,
            selectedCoin);

  @override
  List<Object> get props => [
        isHeads,
        backgroundImage,
        currentStreak,
        record,
        userPrediction,
        selectedCoin
      ];
}

class BackgroundChanged extends CoinState {
  const BackgroundChanged(String backgroundImage, int currentStreak, int record,
      bool isHeads, String userPrediction, String selectedCoin)
      : super(backgroundImage, currentStreak, record, isHeads, userPrediction,
            selectedCoin);
}

class CoinChanged extends CoinState {
  const CoinChanged(String backgroundImage, int currentStreak, int record,
      bool isHeads, String userPrediction, String selectedCoin)
      : super(backgroundImage, currentStreak, record, isHeads, userPrediction,
            selectedCoin);
}
