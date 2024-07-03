import 'dart:ui';
import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../bloc/coin_bloc/coin_bloc.dart';
import 'statistics_text.dart';
import 'statistics_row.dart';

class StatisticsContent extends StatelessWidget {
  final CoinState state;
  const StatisticsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalFlips = state.totalFlips;
    final headsCount = state.headsCount;
    final tailsCount = state.tailsCount;
    final headsPercentage =
        totalFlips > 0 ? (headsCount / totalFlips) * 100 : 0;
    final tailsPercentage =
        totalFlips > 0 ? (tailsCount / totalFlips) * 100 : 0;

    // Получение выбранной монеты из состояния
    final String selectedCoin = state.selectedCoin;
    print("StatisticsContent: selectedCoin=$selectedCoin");

    final String headsImagePath = 'assets/images/${selectedCoin}_head.png';
    final String tailsImagePath = 'assets/images/${selectedCoin}_tail.png';

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background/back.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(45),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatisticsText(
                    text: "${LocaleKeys.total_flips.tr()} $totalFlips",
                  ),
                  StatisticsRow(
                    label:
                        "${LocaleKeys.tail_.tr()}: ${headsPercentage.toStringAsFixed(2)}%",
                    imagePath: headsImagePath, // Изображение для "орла"
                  ),
                  StatisticsRow(
                    label:
                        "${LocaleKeys.head_.tr()}: ${tailsPercentage.toStringAsFixed(2)}%",
                    imagePath: tailsImagePath, // Изображение для "решки"
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
