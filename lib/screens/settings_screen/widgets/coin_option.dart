import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/coin_bloc/coin_bloc.dart';
import '../../coin_selection_screen/select_coin_screen.dart';

class CoinOption extends StatelessWidget {
  final String selectedCoin;

  const CoinOption({super.key, required this.selectedCoin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoinBloc, CoinState>(
      builder: (context, state) {
        return _buildSettingsOption(
          title: LocaleKeys.coin_select.tr(),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoinSelectionScreen(
                  initialSelectedCoin: selectedCoin,
                ),
              ),
            );
            if (result != null) {
              if (context.mounted) {
                BlocProvider.of<CoinBloc>(context).add(ChangeCoin(result));
              }
            }
          },
        );
      },
    );
  }

  Widget _buildSettingsOption(
      {required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      titleTextStyle: TextStyle(fontSize: 23, fontFamily: 'Exo'),
      onTap: onTap,
    );
  }
}
