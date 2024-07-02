import 'dart:ui';

import 'package:coin_flip/screens/statistics_screen/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin_bloc/coin_bloc.dart';
import 'widgets/reset_record_button.dart';
import 'widgets/background_option.dart';
import 'widgets/coin_option.dart';

class SettingsScreen extends StatefulWidget {
  final String initialSelectedImage;

  const SettingsScreen({super.key, required this.initialSelectedImage});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String selectedImage;
  late String selectedCoin;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialSelectedImage;
    selectedCoin = BlocProvider.of<CoinBloc>(context).state.selectedCoin;
    print("SettingsScreen initState: selectedCoin=$selectedCoin");
  }

  Widget _buildWrappedContainer(Widget child) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Настройки"),
      ),
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
            child: Center(
              child: Column(
                children: [
                  _buildWrappedContainer(
                      BackgroundOption(selectedImage: selectedImage)),
                  _buildWrappedContainer(
                      CoinOption(selectedCoin: selectedCoin)),
                  _buildWrappedContainer(
                    ListTile(
                      title: const Text("Статистика"),
                      onTap: () {
                        print("Statistics button tapped");
                        BlocProvider.of<CoinBloc>(context)
                            .add(LoadStatistics());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticsScreen(),
                          ),
                        ).then((value) {
                          BlocProvider.of<CoinBloc>(context)
                              .add(LoadCoinPreferences());
                          print(
                              "Returning to MainScreen, reloading preferences...");
                        });
                      },
                    ),
                  ),
                  ResetRecordButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
