import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coin_flip/screens/main_screen/main_screen.dart';

import 'package:coin_flip/bloc/initialization_bloc/initialization_bloc.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        if (state is InitializationLoaded) {
          return const MainScreen();
        } else if (state is InitializationError) {
          return Scaffold(
            body: Center(child: Text('Error loading data: ${state.message}')),
          );
        } else {
          return const MainScreen(); // Переход сразу на MainScreen без индикаторов загрузки
        }
      },
    );
  }
}
