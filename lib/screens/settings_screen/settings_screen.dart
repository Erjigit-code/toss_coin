import 'dart:ui';
import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:coin_flip/screens/language_screen/language_screen.dart';
import 'package:coin_flip/screens/statistics_screen/statistics_screen.dart';
import 'package:coin_flip/screens/user_record_screen/user_record_screen.dart';
import 'package:coin_flip/widgets/smooth_back.dart';
import 'package:easy_localization/easy_localization.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCoin = BlocProvider.of<CoinBloc>(context).state.selectedCoin;
    print("SettingsScreen didChangeDependencies: selectedCoin=$selectedCoin");
  }

  Widget _buildWrappedContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
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
        title: Text(LocaleKeys.settings.tr()),
      ),
      body: Stack(
        children: [
          const SmoothBack(),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 30.0),
            child: Center(
              child: Column(
                children: [
                  _buildWrappedContainer(
                      BackgroundOption(selectedImage: selectedImage)),
                  _buildWrappedContainer(
                      CoinOption(selectedCoin: selectedCoin)),
                  _buildWrappedContainer(
                    ListTile(
                      title: Text(LocaleKeys.statistics.tr()),
                      titleTextStyle:
                          const TextStyle(fontSize: 23, fontFamily: 'Exo'),
                      onTap: () {
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
                        });
                      },
                    ),
                  ),
                  _buildWrappedContainer(
                    ListTile(
                      title: Text(LocaleKeys.choose_language.tr()),
                      titleTextStyle:
                          const TextStyle(fontSize: 23, fontFamily: 'Exo'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LanguageScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildWrappedContainer(
                    ListTile(
                      title: Text(LocaleKeys.global_records.tr()),
                      titleTextStyle:
                          const TextStyle(fontSize: 23, fontFamily: 'Exo'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserRecordsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildWrappedContainer(
                    ResetRecordButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
