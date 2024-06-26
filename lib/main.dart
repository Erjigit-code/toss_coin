import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_flip/bloc/coin_bloc.dart';
import 'package:coin_flip/screens/main_screen.dart';

import 'initialization/bloc/initialization_bloc.dart';
import 'screens/bacground/bloc/background_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> backgrounds = [
      {'path': 'assets/images/school.jpeg', 'title': 'School'},
      {'path': 'assets/images/stadium.jpeg', 'title': 'Stadium'},
      {'path': 'assets/images/pool.jpeg', 'title': 'Pool'},
      {'path': 'assets/images/space.jpeg', 'title': 'Space'},
      {'path': 'assets/images/view.jpg', 'title': 'View'},
      {'path': 'assets/images/house.jpeg', 'title': 'House'},
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinBloc>(
          create: (context) => CoinBloc()..add(LoadCoinPreferences()),
        ),
        BlocProvider<BackgroundBloc>(
          create: (context) =>
              BackgroundBloc(context)..add(LoadBackgrounds(backgrounds)),
        ),
        BlocProvider<InitializationBloc>(
          create: (context) => InitializationBloc(
            coinBloc: BlocProvider.of<CoinBloc>(context),
            backgroundBloc: BlocProvider.of<BackgroundBloc>(context),
          )..add(InitializeApp()),
        ),
      ],
      child: MaterialApp(
        title: 'Coin Flip',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
