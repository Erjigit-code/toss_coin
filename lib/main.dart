import 'package:coin_flip/widgets/app_initializer.dart';
import 'package:coin_flip/bloc/UserProfile_bloc/user_profile_bloc.dart';
import 'package:coin_flip/bloc/records_bloc/user_records_bloc.dart';
import 'package:coin_flip/constants/constants.dart';
import 'package:coin_flip/firebase_options.dart';
import 'package:coin_flip/generated/codegen_loader.g.dart';
import 'package:coin_flip/widgets/initial_Screen.dart';

import 'package:coin_flip/screens/language_screen/app_localzation.dart';
import 'package:coin_flip/screens/registration_screen/service/auth_servise.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_flip/bloc/coin_bloc/coin_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/initialization_bloc/initialization_bloc.dart';
import 'bloc/background_bloc/background_bloc.dart';
import 'widgets/custom_material_localizations.dart';
import 'widgets/custom_cupertino_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  await Hive.openBox(Constants.settingsBox);
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      assetLoader: const CodegenLoader(),
      supportedLocales: Constants.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: Constants.defaultLocale,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final authService = AuthService();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        BlocProvider<UserProfileBloc>(
          create: (context) =>
              UserProfileBloc(authService)..add(LoadUserProfile()),
        ),
        BlocProvider<UserRecordsBloc>(
          create: (context) => UserRecordsBloc()..add(LoadUserRecords()),
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
            home: const InitialScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
