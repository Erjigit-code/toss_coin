import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool dialogOpen = false;

  @override
  void dispose() {
    dialogOpen = false; // Ensure dialogOpen is false when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        LocaleKeys.reset_record.tr(),
        style: const TextStyle(fontSize: 23, fontFamily: 'Exo'),
      ),
      onTap: () {
        _showResetConfirmationDialog();
      },
    );
  }

  void _showResetConfirmationDialog() {
    dialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void startCountdown() {
              Future.delayed(const Duration(seconds: 1), () {
                if (countdown > 0 && mounted && dialogOpen) {
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
              title: Text(LocaleKeys.confirmation_.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${LocaleKeys.request_coinfirmation.tr()} ($countdown)"),
                  const SizedBox(height: 16),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    dialogOpen = false;
                    Navigator.of(context).pop();
                    setState(() {
                      countdown = 3;
                    });
                  },
                  child: Text(LocaleKeys.cancel.tr()),
                ),
                ElevatedButton(
                  onPressed: countdown == 0
                      ? () {
                          dialogOpen = false;
                          BlocProvider.of<CoinBloc>(context).add(ResetRecord());
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: Text(LocaleKeys.yes.tr()),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      if (mounted) {
        setState(() {
          countdown = 3;
          dialogOpen = false;
        });
      }
    });
  }
}
