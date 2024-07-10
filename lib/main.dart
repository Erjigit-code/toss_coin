import 'package:coin_flip/firebase_options.dart';
import 'package:coin_flip/generated/codegen_loader.g.dart';
import 'package:coin_flip/screens/language_screen/app_localzation.dart';
import 'package:coin_flip/screens/registration_screen/registration_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_flip/bloc/coin_bloc/coin_bloc.dart';
import 'package:coin_flip/screens/main_screen/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/initialization_bloc/initialization_bloc.dart';
import 'bloc/background_bloc/background_bloc.dart';
import 'custom_material_localizations.dart';
import 'custom_cupertino_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      assetLoader: const CodegenLoader(),
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
        Locale('ru'),
        Locale('kg'),
        Locale('tr'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building MyApp with locale: ${context.locale}");
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinBloc>(
          create: (context) => CoinBloc()..add(LoadCoinPreferences()),
        ),
        BlocProvider<BackgroundBloc>(
          create: (context) => BackgroundBloc(context)
            ..add(const LoadBackgrounds([
              'assets/images/school.jpeg',
              'assets/images/stadium.jpeg',
              'assets/images/pool.jpeg',
              'assets/images/space.jpeg',
              'assets/images/view.jpg',
              'assets/images/house.jpeg',
            ])),
        ),
        BlocProvider<InitializationBloc>(
          create: (context) => InitializationBloc(
            coinBloc: BlocProvider.of<CoinBloc>(context),
            backgroundBloc: BlocProvider.of<BackgroundBloc>(context),
          )..add(InitializeApp()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: [
              ...context.localizationDelegates,
              CustomMaterialLocalizations.delegate,
              CustomCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Coin Flip',
            home: InitialScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkIfRegistered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.data == true) {
          return AppInitializer();
        } else {
          return RegistrationScreen();
        }
      },
    );
  }

  Future<bool> _checkIfRegistered() async {
    final box = await Hive.openBox('settings');
    return box.containsKey('user');
  }
}

class AppInitializer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        if (state is InitializationLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is InitializationLoaded) {
          return MainScreen();
        } else if (state is InitializationError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading data: ${state.message}'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Unexpected error loading data'),
            ),
          );
        }
      },
    );
  }
}
