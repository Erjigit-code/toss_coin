import 'dart:io'; // Добавлено для использования File
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/prediction_buttons_widget.dart';
import '../../bloc/initialization_bloc/initialization_bloc.dart';
import '../bacground/widgets/background_widget.dart';
import 'widgets/coin_flip2.dart';
import 'widgets/result_container_widget.dart';
import 'widgets/score_container_widget.dart';
import 'widgets/сoin_flip_animation.dart';
import '../../bloc/background_bloc/background_bloc.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  String? result;
  String? userPrediction;
  String? activeButton;
  final GlobalKey<CoinFlipAnimationState> _coinFlipKey =
      GlobalKey<CoinFlipAnimationState>();

  @override
  void initState() {
    super.initState();
    print("MainScreen initState called");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("MainScreen didChangeDependencies called");
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("MainScreen didUpdateWidget called");
  }

  @override
  void dispose() {
    print("MainScreen dispose called");
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("MainScreen build called");
    return BlocBuilder<InitializationBloc, InitializationState>(
      buildWhen: (previous, current) =>
          previous != current && current is BackgroundsLoaded,
      builder: (context, state) {
        if (state is InitializationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is InitializationLoaded) {
          return BlocBuilder<BackgroundBloc, BackgroundState>(
            builder: (context, backgroundState) {
              if (backgroundState is BackgroundsLoaded) {
                return _buildMainScreen(context, backgroundState.selectedPath);
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        } else if (state is InitializationError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading data: ${state.message}'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Unexpected error loading data'),
            ),
          );
        }
      },
    );
  }

  Widget _buildMainScreen(BuildContext context, String backgroundImagePath) {
    final isAsset = !backgroundImagePath.startsWith('/');
    final backgroundImage = isAsset
        ? AssetImage(backgroundImagePath)
        : FileImage(File(backgroundImagePath));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Орёл или Решка"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final selectedBackground = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    initialSelectedImage:
                        (BlocProvider.of<BackgroundBloc>(context).state
                                as BackgroundsLoaded)
                            .selectedPath,
                  ),
                ),
              );
              if (selectedBackground != null) {
                BlocProvider.of<BackgroundBloc>(context)
                    .add(ChangeBackground(selectedBackground));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          BackgroundWidget(backgroundImage: backgroundImage),
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: kToolbarHeight),
                ScoreContainerWidget(),
                const Spacer(),
                const SizedBox(height: 110),
                CoinFlipAnimationWidget(
                  coinFlipKey: _coinFlipKey,
                  updateResult: updateResult,
                ),
                const Spacer(),
              ],
            ),
          ),
          if (result != null) ResultContainerWidget(result: result!),
          PredictionButtonsWidget(
            activeButton: activeButton,
            onPredictionSelected: startCoinFlip,
          ),
        ],
      ),
    );
  }

  void updateResult(String newResult) {
    setState(() {
      result = newResult;
    });
  }

  void startCoinFlip(String prediction) {
    setState(() {
      userPrediction = prediction;
      activeButton = prediction;
    });
    _coinFlipKey.currentState?.flipCoin(prediction);
  }
}
