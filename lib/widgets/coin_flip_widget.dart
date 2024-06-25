import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin_bloc.dart';
import '../utils/coin_image_provider.dart';

class CoinFlipWidget extends StatelessWidget {
  final AnimationController verticalController;
  final AnimationController bounceController;
  final Animation<double> rotationAnimation;
  final Animation<double> verticalAnimation;
  final Animation<double> diagonalRotationXAnimation;
  final Animation<double> diagonalRotationZAnimation;
  final Animation<double> bounceVerticalAnimation;
  final VoidCallback onFlipCoin;

  const CoinFlipWidget({
    super.key,
    required this.verticalController,
    required this.bounceController,
    required this.rotationAnimation,
    required this.verticalAnimation,
    required this.diagonalRotationXAnimation,
    required this.diagonalRotationZAnimation,
    required this.bounceVerticalAnimation,
    required this.onFlipCoin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: onFlipCoin,
        child: AnimatedBuilder(
          animation: Listenable.merge([verticalController, bounceController]),
          builder: (context, child) {
            final double angle = rotationAnimation.value;
            final double verticalOffset = verticalController.isAnimating
                ? verticalAnimation.value
                : bounceVerticalAnimation.value;
            final double diagonalXAngle = diagonalRotationXAnimation.value;
            final double diagonalZAngle = diagonalRotationZAnimation.value;

            return Transform.translate(
              offset: Offset(0, verticalOffset),
              child: Transform(
                alignment: Alignment.center,
                transform: bounceController.isAnimating
                    ? (Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(-diagonalXAngle)
                      ..rotateZ(diagonalZAngle))
                    : (Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(-angle)),
                child: BlocBuilder<CoinBloc, CoinState>(
                  builder: (context, state) {
                    return state.isHeads
                        ? Image.asset(
                            CoinImageProvider.getCoinImage(
                                state.selectedCoin, true),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            CoinImageProvider.getCoinImage(
                                state.selectedCoin, false),
                            fit: BoxFit.cover,
                          );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
