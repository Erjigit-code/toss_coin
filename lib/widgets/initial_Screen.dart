import 'package:coin_flip/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:coin_flip/screens/registration_screen/registration_screen.dart';
import 'package:coin_flip/widgets/app_initializer.dart';
import 'package:coin_flip/bloc/initialization_bloc/initialization_bloc.dart';
import '../constants/constants.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isImagesPreCached = false;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  void _checkRegistrationStatus() async {
    final box = Hive.box(Constants.settingsBox);
    final isRegistered = box.get('isRegistered', defaultValue: false);
    setState(() {
      _isRegistered = isRegistered;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isImagesPreCached) {
      precacheImages();
      _isImagesPreCached = true;
    }
  }

  void precacheImages() {
    const images = [
      'assets/images/school.jpeg',
      'assets/images/stadium.jpeg',
      'assets/images/pool.jpeg',
      'assets/images/space.jpeg',
      'assets/images/view.jpg',
      'assets/images/house.jpeg',
      'assets/background/back.jpeg',
      'assets/background/back2.jpeg',
      'assets/images/rus_head.png',
      'assets/images/rus_tail.png',
      'assets/images/euro_tail.png',
      'assets/images/euro_head.png',
      'assets/images/kg_head.png',
      'assets/images/kg_tail.png',
      'assets/images/us_tail.png',
      'assets/images/us_head.png',
    ];

    for (var imagePath in images) {
      precacheImage(AssetImage(imagePath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitializationBloc, InitializationState>(
      builder: (context, state) {
        if (_isRegistered) {
          return const MainScreen();
        } else {
          return const RegistrationScreen();
        }
      },
    );
  }
}
