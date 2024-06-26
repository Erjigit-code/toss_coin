import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/coin_bloc.dart';
import 'bacground/background_slct_screen.dart';
import 'bacground/bloc/background_bloc.dart';
import 'select_coin_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String initialSelectedImage;

  const SettingsScreen({super.key, required this.initialSelectedImage});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedImage;
  late String selectedCoin;
  bool isConfirmingReset = false;
  int countdown = 3;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialSelectedImage;
    selectedCoin = BlocProvider.of<CoinBloc>(context).state.selectedCoin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<BackgroundBloc, BackgroundState>(
            builder: (context, state) {
              return _buildSettingsOption(
                title: "Выбор Фона",
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BackgroundSelectionScreen(
                          initialSelectedImage: selectedImage),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      selectedImage = result;
                    });
                    BlocProvider.of<BackgroundBloc>(context)
                        .add(ChangeBackground(result));
                  }
                },
              );
            },
          ),
          BlocBuilder<CoinBloc, CoinState>(
            builder: (context, state) {
              return _buildSettingsOption(
                title: "Выбор монеты",
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoinSelectionScreen(
                          initialSelectedCoin: selectedCoin),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      selectedCoin = result;
                    });
                    BlocProvider.of<CoinBloc>(context)
                        .add(ChangeCoin(selectedCoin));
                  }
                },
              );
            },
          ),
          const Divider(),
          _buildResetRecordButton(),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(
      {required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildResetRecordButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              _showResetConfirmationDialog();
            },
            child: const Text("Сбросить рекорд"),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void _startCountdown() {
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0) {
                  setState(() {
                    countdown--;
                  });
                  _startCountdown();
                }
              });
            }

            if (countdown == 3) {
              _startCountdown();
            }

            return AlertDialog(
              title: const Text('Подтверждение'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Вы уверены, что хотите сбросить рекорд? ($countdown)"),
                  const SizedBox(height: 16),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Отмена"),
                ),
                ElevatedButton(
                  onPressed: countdown == 0
                      ? () {
                          BlocProvider.of<CoinBloc>(context).add(ResetRecord());
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("Да"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
