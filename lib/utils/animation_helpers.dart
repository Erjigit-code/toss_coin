import 'dart:math';
import 'package:flutter/animation.dart';

class AnimationSet {
  final Animation<double> rotationAnimation;
  final Animation<double> verticalAnimation;
  final Animation<double> bounceVerticalAnimation;
  final Animation<double> diagonalRotationXAnimation;
  final Animation<double> diagonalRotationZAnimation;

  AnimationSet({
    required this.rotationAnimation,
    required this.verticalAnimation,
    required this.bounceVerticalAnimation,
    required this.diagonalRotationXAnimation,
    required this.diagonalRotationZAnimation,
  });
}

AnimationSet initializeAnimations(AnimationController verticalController,
    AnimationController bounceController, double throwHeight) {
  final rotationAnimation = Tween<double>(begin: 0, end: 20 * pi).animate(
    CurvedAnimation(parent: verticalController, curve: Curves.linear),
  );

  final verticalAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: throwHeight)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: throwHeight, end: 0)
          .chain(CurveTween(curve: Curves.easeIn)),
      weight: 50,
    ),
  ]).animate(CurvedAnimation(parent: verticalController, curve: Curves.easeIn));

  final bounceVerticalAnimation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0, end: throwHeight * 0.2)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 50,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: throwHeight * 0.2, end: 0)
          .chain(CurveTween(curve: Curves.bounceOut)),
      weight: 50,
    ),
  ]).animate(bounceController);

  final diagonalRotationXAnimation =
      Tween<double>(begin: 0, end: 2 * pi).animate(
    CurvedAnimation(parent: bounceController, curve: Curves.linear),
  );

  final diagonalRotationZAnimation =
      Tween<double>(begin: 0, end: 2 * pi).animate(
    CurvedAnimation(parent: bounceController, curve: Curves.linear),
  );

  return AnimationSet(
    rotationAnimation: rotationAnimation,
    verticalAnimation: verticalAnimation,
    bounceVerticalAnimation: bounceVerticalAnimation,
    diagonalRotationXAnimation: diagonalRotationXAnimation,
    diagonalRotationZAnimation: diagonalRotationZAnimation,
  );
}
