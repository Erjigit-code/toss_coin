import 'package:flutter/material.dart';

class AnimationControllerProvider {
  static AnimationController createVerticalController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );
  }

  static AnimationController createBounceController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );
  }
}
