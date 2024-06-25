import 'package:coin_flip/widgets/%D1%81oin_flip_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin_bloc.dart';

class CoinFlipAnimationWidget extends StatelessWidget {
  final GlobalKey<CoinFlipAnimationState> coinFlipKey;
  final Function(String) updateResult;

  CoinFlipAnimationWidget(
      {required this.coinFlipKey, required this.updateResult});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        coinFlipKey.currentState?.flipCoin('');
      },
      child: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          return CoinFlipAnimation(
            key: coinFlipKey,
            selectedCoin: state.selectedCoin,
            onResult: (newResult) {
              updateResult(newResult);
            },
          );
        },
      ),
    );
  }
}
