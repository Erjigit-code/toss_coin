import 'package:coin_flip/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../buttons/prediction_buttons_widget.dart';
import '../initialization/bloc/initialization_bloc.dart';
import '../widgets/background_widget.dart';
import '../widgets/coin_flip2.dart';
import '../widgets/score_container_widget.dart';
import '../widgets/result_container_widget.dart';
import '../widgets/сoin_flip_animation.dart';
import 'bacground/bloc/background_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  String? result;
  String? userPrediction;
  String? activeButton;
  final GlobalKey<CoinFlipAnimationState> _coinFlipKey =
      GlobalKey<CoinFlipAnimationState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        if (state is InitializationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is InitializationLoaded) {
          return _buildMainScreen(context);
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Error loading data'),
            ),
          );
        }
      },
    );
  }

  Widget _buildMainScreen(BuildContext context) {
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
      body: BlocBuilder<BackgroundBloc, BackgroundState>(
        builder: (context, state) {
          if (state is BackgroundsLoaded) {
            return Stack(
              children: <Widget>[
                BackgroundWidget(backgroundImage: state.selectedPath),
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
