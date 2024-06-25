import 'package:coin_flip/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coin_bloc.dart';
import '../buttons/prediction_buttons_widget.dart';
import '../widgets/background_widget.dart';
import '../widgets/coin_flip2.dart';
import '../widgets/score_container_widget.dart';
import '../widgets/result_container_widget.dart';
import '../widgets/сoin_flip_animation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? result;
  String? userPrediction;
  String? activeButton;
  final GlobalKey<CoinFlipAnimationState> _coinFlipKey =
      GlobalKey<CoinFlipAnimationState>();

  void updateResult(String newResult) {
    setState(() {
      result = newResult;
    });
    // Log the result
  }

  void startCoinFlip(String prediction) {
    setState(() {
      userPrediction = prediction;
      activeButton = prediction;
    });
    _coinFlipKey.currentState?.flipCoin(prediction);
  }

  @override
  Widget build(BuildContext context) {
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
                    initialSelectedImage: BlocProvider.of<CoinBloc>(context)
                        .state
                        .backgroundImage,
                  ),
                ),
              );
              if (selectedBackground != null) {
                BlocProvider.of<CoinBloc>(context)
                    .add(ChangeBackground(selectedBackground));
              }
            },
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            BackgroundWidget(),
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
      ),
    );
  }
}
