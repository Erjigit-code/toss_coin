part of 'coin_bloc.dart';

abstract class CoinState extends Equatable {
  final int currentStreak;
  final int record;
  final bool isHeads;
  final String userPrediction;
  final String selectedCoin;
  final int totalFlips;
  final int headsCount;
  final int tailsCount;

  const CoinState({
    required this.currentStreak,
    required this.record,
    required this.isHeads,
    required this.userPrediction,
    required this.selectedCoin,
    required this.totalFlips,
    required this.headsCount,
    required this.tailsCount,
  });

  @override
  List<Object> get props => [
        currentStreak,
        record,
        isHeads,
        userPrediction,
        selectedCoin,
        totalFlips,
        headsCount,
        tailsCount,
      ];

  CoinState copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  });
}

class CoinInitial extends CoinState {
  const CoinInitial({
    required int currentStreak,
    required int record,
    required bool isHeads,
    required String userPrediction,
    required String selectedCoin,
    required int totalFlips,
    required int headsCount,
    required int tailsCount,
  }) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: isHeads,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
          totalFlips: totalFlips,
          headsCount: headsCount,
          tailsCount: tailsCount,
        );

  @override
  CoinInitial copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinInitial(
      currentStreak: currentStreak ?? this.currentStreak,
      record: record ?? this.record,
      isHeads: isHeads ?? this.isHeads,
      userPrediction: userPrediction ?? this.userPrediction,
      selectedCoin: selectedCoin ?? this.selectedCoin,
      totalFlips: totalFlips ?? this.totalFlips,
      headsCount: headsCount ?? this.headsCount,
      tailsCount: tailsCount ?? this.tailsCount,
    );
  }
}

class CoinPreferencesLoaded extends CoinState {
  const CoinPreferencesLoaded(
    int record,
    String selectedCoin,
    int totalFlips,
    int headsCount,
    int tailsCount,
    int currentStreak,
  ) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: false,
          userPrediction: '',
          selectedCoin: selectedCoin,
          totalFlips: totalFlips,
          headsCount: headsCount,
          tailsCount: tailsCount,
        );

  @override
  CoinPreferencesLoaded copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinPreferencesLoaded(
      record ?? this.record,
      selectedCoin ?? this.selectedCoin,
      totalFlips ?? this.totalFlips,
      headsCount ?? this.headsCount,
      tailsCount ?? this.tailsCount,
      currentStreak ?? this.currentStreak,
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
    int totalFlips,
    int headsCount,
    int tailsCount,
  ) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: isHeads,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
          totalFlips: totalFlips,
          headsCount: headsCount,
          tailsCount: tailsCount,
        );

  @override
  CoinChanged copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinChanged(
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      isHeads ?? this.isHeads,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
      totalFlips ?? this.totalFlips,
      headsCount ?? this.headsCount,
      tailsCount ?? this.tailsCount,
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
    int totalFlips,
    int headsCount,
    int tailsCount,
  ) : super(
          currentStreak: currentStreak,
          record: record,
          isHeads: isHeads,
          userPrediction: userPrediction,
          selectedCoin: selectedCoin,
          totalFlips: totalFlips,
          headsCount: headsCount,
          tailsCount: tailsCount,
        );

  @override
  CoinFlipped copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  }) {
    return CoinFlipped(
      isHeads ?? this.isHeads,
      currentStreak ?? this.currentStreak,
      record ?? this.record,
      userPrediction ?? this.userPrediction,
      selectedCoin ?? this.selectedCoin,
      totalFlips ?? this.totalFlips,
      headsCount ?? this.headsCount,
      tailsCount ?? this.tailsCount,
    );
  }
}

class StatisticsLoaded extends CoinState {
  const StatisticsLoaded(
    int totalFlips,
    int headsCount,
    int tailsCount,
    String selectedCoin,
  ) : super(
          currentStreak: 0,
          record: 0,
          isHeads: false,
          userPrediction: '',
          selectedCoin: selectedCoin,
          totalFlips: totalFlips,
          headsCount: headsCount,
          tailsCount: tailsCount,
        );

  @override
  StatisticsLoaded copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
  }) {
    return StatisticsLoaded(
      totalFlips ?? this.totalFlips,
      headsCount ?? this.headsCount,
      tailsCount ?? this.tailsCount,
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
          selectedCoin: 'euro',
          totalFlips: 0,
          headsCount: 0,
          tailsCount: 0,
        );

  @override
  CoinError copyWith({
    int? currentStreak,
    int? record,
    bool? isHeads,
    String? userPrediction,
    String? selectedCoin,
    int? totalFlips,
    int? headsCount,
    int? tailsCount,
    String? message,
  }) {
    return CoinError(
      message ?? this.message,
    );
  }

  @override
  List<Object> get props => [message];
}
