import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/coin_bloc/coin_bloc.dart';
import 'widgets/reset_record_button.dart';
import 'widgets/background_option.dart';
import 'widgets/coin_option.dart';

class SettingsScreen extends StatefulWidget {
  final String initialSelectedImage;

  const SettingsScreen({super.key, required this.initialSelectedImage});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late String selectedImage;
  late String selectedCoin;

  @override
  void initState() {
    super.initState();
    selectedImage = widget.initialSelectedImage;
    selectedCoin = BlocProvider.of<CoinBloc>(context).state.selectedCoin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackgroundOption(selectedImage: selectedImage),
          CoinOption(selectedCoin: selectedCoin),
          const Divider(),
          ResetRecordButton(),
        ],
      ),
    );
  }
}
