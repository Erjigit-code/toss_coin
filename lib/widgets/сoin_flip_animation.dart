import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:coin_flip/utils/animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin_bloc.dart';
import '../utils/animation_helpers.dart';
import '../utils/audio_player.dart';
import 'coin_flip_widget.dart';

class CoinFlipAnimation extends StatefulWidget {
  final Function(String) onResult;
  final String selectedCoin;
  const CoinFlipAnimation(
      {super.key, required this.onResult, required this.selectedCoin});

  @override
  CoinFlipAnimationState createState() => CoinFlipAnimationState();
}

class CoinFlipAnimationState extends State<CoinFlipAnimation>
    with TickerProviderStateMixin {
  late AnimationController _verticalController;
  late AnimationController _bounceController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _verticalAnimation;
  late Animation<double> _diagonalRotationXAnimation;
  late Animation<double> _diagonalRotationZAnimation;
  late Animation<double> _bounceVerticalAnimation;

  bool _resultSet = false;
  final double throwHeight = -300;
  String? userPrediction;
  late bool isHeads = false;

  @override
  void initState() {
    super.initState();
    isHeads = false;
    _initializeControllers();
    _initializeAnimations();
    _addStatusListeners();
    AudioPlayerProvider.addAudioListeners();
    AudioPlayerProvider.preloadAudio();
  }

  void _initializeControllers() {
    _verticalController =
        AnimationControllerProvider.createVerticalController(this);
    _bounceController =
        AnimationControllerProvider.createBounceController(this);
  }

  void _initializeAnimations() {
    final animations = initializeAnimations(
      _verticalController,
      _bounceController,
      throwHeight,
    );

    _rotationAnimation = animations.rotationAnimation;
    _verticalAnimation = animations.verticalAnimation;
    _bounceVerticalAnimation = animations.bounceVerticalAnimation;
    _diagonalRotationXAnimation = animations.diagonalRotationXAnimation;
    _diagonalRotationZAnimation = animations.diagonalRotationZAnimation;
  }

  void _addStatusListeners() {
    _verticalController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.forward(from: 0);
      }
    });

    _bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_resultSet) {
        _resultSet = true;
        final bool finalResult = _determineResult();

        setState(() {
          isHeads = finalResult;
        });

        BlocProvider.of<CoinBloc>(context)
            .add(FlipCoin(isHeads, userPrediction ?? ''));
      }
    });
  }

  bool _determineResult() {
    final angle = _rotationAnimation.value;
    final diagonalXAngle = _diagonalRotationXAnimation.value;
    final isVerticalCompleted = _verticalController.isCompleted;
    final isBounceCompleted = _bounceController.isCompleted;
    final bool verticalResult = isVerticalCompleted && angle % (2 * pi) > pi;
    final bool bounceResult =
        isBounceCompleted && diagonalXAngle % (2 * pi) > pi;
    return !(verticalResult || bounceResult);
  }

  void flipCoin([String? prediction]) {
    if (!_verticalController.isAnimating && !_bounceController.isAnimating) {
      final double randomXAngle = Random().nextDouble() * 2 * pi;
      final bool rotateClockwise = Random().nextBool();
      isHeads = Random().nextBool();

      setState(() {
        _diagonalRotationXAnimation =
            Tween<double>(begin: 0, end: randomXAngle).animate(
          CurvedAnimation(parent: _bounceController, curve: Curves.linear),
        );

        _diagonalRotationZAnimation = Tween<double>(
          begin: 0,
          end: rotateClockwise ? 2 * pi : -2 * pi,
        ).animate(
            CurvedAnimation(parent: _bounceController, curve: Curves.linear));

        userPrediction = prediction ?? '';
      });

      _resultSet = false;
      _verticalController.forward(from: 0);
      AudioPlayerProvider.tossAudioPlayer
          .play(AssetSource('sounds/coin_toss.mp3'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoinFlipWidget(
      verticalController: _verticalController,
      bounceController: _bounceController,
      rotationAnimation: _rotationAnimation,
      verticalAnimation: _verticalAnimation,
      diagonalRotationXAnimation: _diagonalRotationXAnimation,
      diagonalRotationZAnimation: _diagonalRotationZAnimation,
      bounceVerticalAnimation: _bounceVerticalAnimation,
      onFlipCoin: () => flipCoin(''),
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _bounceController.dispose();
    AudioPlayerProvider.tossAudioPlayer.dispose();
    AudioPlayerProvider.dropAudioPlayer.dispose();
    super.dispose();
  }
}
