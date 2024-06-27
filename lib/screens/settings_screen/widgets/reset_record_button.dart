import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/coin_bloc/coin_bloc.dart';

class ResetRecordButton extends StatefulWidget {
  const ResetRecordButton({super.key});

  @override
  _ResetRecordButtonState createState() => _ResetRecordButtonState();
}

class _ResetRecordButtonState extends State<ResetRecordButton> {
  bool isConfirmingReset = false;
  int countdown = 3;

  @override
  Widget build(BuildContext context) {
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
            void startCountdown() {
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0) {
                  setState(() {
                    countdown--;
                  });
                  startCountdown();
                }
              });
            }

            if (countdown == 3) {
              startCountdown();
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
