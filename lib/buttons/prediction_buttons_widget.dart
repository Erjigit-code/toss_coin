import 'package:flutter/material.dart';
import 'package:coin_flip/buttons/custom_button.dart';

class PredictionButtonsWidget extends StatelessWidget {
  final String? activeButton;
  final Function(String) onPredictionSelected;

  const PredictionButtonsWidget({
    super.key,
    required this.activeButton,
    required this.onPredictionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(
            label: "Орел",
            imagePath: 'assets/images/icon1.png',
            isActive: activeButton == 'Орёл',
            onPressed: () {
              onPredictionSelected('Орёл');
            },
          ),
          CustomButton(
            label: "Решка",
            imagePath: 'assets/images/icon2.png',
            isActive: activeButton == 'Решка',
            onPressed: () {
              onPredictionSelected('Решка');
            },
          ),
        ],
      ),
    );
  }
}
