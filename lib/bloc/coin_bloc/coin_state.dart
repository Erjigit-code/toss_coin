part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  final int currentStreak;
  final int record;
  final bool isHeads;
  final String userPrediction;
  final String selectedCoin;

  const CoinState({
    required this.currentStreak,
    required this.record,
    required this.isHeads,
    required this.userPrediction,
    required this.selectedCoin,
  });

  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  });

  @override
  List<Object> get props => [
        currentStreak,
        record,
        isHeads,
        userPrediction,
        selectedCoin,
      ];
}

class CoinInitial extends CoinState {
  const CoinInitial({
    required int currentStreak,
    required int record,
    required bool isHeads,
    required String userPrediction,
    required String selectedCoin,
  }) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: isHeads,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
        );

  @override
  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinInitial(
      currentStreak: currentStreak ?? this.currentStreak,
      record: record ?? this.record,
      isHeads: isHeads ?? this.isHeads,
      userPrediction: userPrediction ?? this.userPrediction,
      selectedCoin: selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinFlipped extends CoinState {
  const CoinFlipped(
    bool isHeads,
    int currentStreak,
    int record,
    String userPrediction,
    String selectedCoin,
  ) : super(
          isHeads: isHeads,
          currentStreak: currentStreak,
          record: record,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
        );

  @override
  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinFlipped(
      isHeads ?? this.isHeads,
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinPreferencesLoaded extends CoinState {
  const CoinPreferencesLoaded(int record, String selectedCoin)
      : super(
            currentStreak: 0,
            record: record,
            isHeads: false,
            userPrediction: '',
            selectedCoin: selectedCoin);

  @override
  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinPreferencesLoaded(
      record ?? this.record,
      selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinChanged extends CoinState {
  const CoinChanged(
    int currentStreak,
    int record,
    bool isHeads,
    String userPrediction,
    String selectedCoin,
  ) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: isHeads,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
        );

  @override
  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return CoinChanged(
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      isHeads ?? this.isHeads,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
    );
  }
}

class CoinError extends CoinState {
  final String message;

  const CoinError(this.message)
      : super(
            currentStreak: 0,
            record: 0,
            isHeads: false,
            userPrediction: '',
            selectedCoin: 'euro');

  @override
  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
  }) {
    return this;
  }

  @override
  List<Object> get props => [message, ...super.props];
}
