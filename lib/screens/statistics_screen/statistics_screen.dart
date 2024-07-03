import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin_bloc/coin_bloc.dart';
import 'widgets/statistics_content.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(LocaleKeys.statistics.tr()),
      ),
      body: BlocBuilder<CoinBloc, CoinState>(
        builder: (context, state) {
          if (state is StatisticsLoaded) {
            return StatisticsContent(state: state);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
