import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_flip/bloc/coin_bloc/coin_bloc.dart';
import 'package:coin_flip/screens/main_screen/main_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/initialization_bloc/initialization_bloc.dart';
import 'bloc/background_bloc/background_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> backgrounds = [
      'assets/images/school.jpeg',
      'assets/images/stadium.jpeg',
      'assets/images/pool.jpeg',
      'assets/images/space.jpeg',
      'assets/images/view.jpg',
      'assets/images/house.jpeg',
    ];
    final List<String> precachedImages = [
      'assets/images/rus_head.png',
      'assets/images/rus_tail.png',
      'assets/images/kg_tail.png',
      'assets/images/kg_head.png',
      'assets/images/euro_tail.png',
      'assets/images/euro_head.png',
      'assets/images/us_head.png',
      'assets/images/us_tail.png',
      'assets/background/back.jpeg',
      'assets/background/back2.jpeg'
    ];

    for (var background in backgrounds) {
      precacheImage(AssetImage(background), context);
    }
    for (var preload in precachedImages) {
      precacheImage(AssetImage(preload), context);
    }

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
          create: (context) {
            final initializationBloc = InitializationBloc(
              coinBloc: BlocProvider.of<CoinBloc>(context),
              backgroundBloc: BlocProvider.of<BackgroundBloc>(context),
            );
            print("Adding InitializeApp event...");
            initializationBloc.add(InitializeApp());
            return initializationBloc;
          },
        ),
      ],
      child: BlocBuilder<InitializationBloc, InitializationState>(
        buildWhen: (previous, current) => current is! InitializationLoading,
        builder: (context, state) {
          if (state is InitializationLoaded) {
            return MaterialApp(
              title: 'Coin Flip',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MainScreen(),
            );
          } else {
            return MaterialApp(
              title: 'Coin Flip',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Scaffold(
                body: Center(
                  child: Text('Initialization is in progress...'),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
