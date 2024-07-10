import 'dart:ui';
import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:coin_flip/screens/coin_selection_screen/widgets/coin_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin_bloc/coin_bloc.dart';
import 'widgets/coin_list.dart';

class CoinSelectionScreen extends StatefulWidget {
  final String initialSelectedCoin;

  const CoinSelectionScreen({super.key, required this.initialSelectedCoin});

  @override
  CoinSelectionScreenState createState() => CoinSelectionScreenState();
}

class CoinSelectionScreenState extends State<CoinSelectionScreen> {
  late String selectedCoin;
  late FixedExtentScrollController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedCoin = widget.initialSelectedCoin;
    selectedIndex = coins.indexWhere((coin) => coin['id'] == selectedCoin);

    // Create an infinite list by repeating the coins list
    infiniteCoins = List.generate(1000, (index) => coins[index % coins.length]);

    // Set the initial scroll position to somewhere in the middle
    _controller = FixedExtentScrollController(initialItem: 500 + selectedIndex);

    BlocProvider.of<CoinBloc>(context).add(LoadCoinPreferences());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoinBloc, CoinState>(
      listener: (context, state) {
        if (state is CoinPreferencesLoaded) {
          setState(() {
            selectedCoin = state.selectedCoin;
            selectedIndex =
                coins.indexWhere((coin) => coin['id'] == selectedCoin);
            _controller.jumpToItem(500 + selectedIndex);
          });
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(LocaleKeys.coin_select.tr()),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                BlocProvider.of<CoinBloc>(context)
                    .add(ChangeCoin(selectedCoin));
                Navigator.pop(context, selectedCoin);
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background/back.jpeg'), // Путь к вашему изображению
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
                child: ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 220,
                  perspective: 0.008,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedIndex = index % coins.length;
                      selectedCoin = infiniteCoins[index]['id']!;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= infiniteCoins.length) {
                        return null;
                      }
                      final coin = infiniteCoins[index];
                      return CoinTile(
                        headImagePath: coin['head']!,
                        tailImagePath: coin['tail']!,
                        id: coin['id']!,
                        title: coin[
                            'title']!, //тут нужно передать Text(LocaleKeys.соответствующий перевод к определенной валюте.tr()),
                        isSelected: selectedCoin == coin['id'],
                      );
                    },
                    childCount: infiniteCoins.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
