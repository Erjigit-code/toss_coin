import 'package:flutter/material.dart';

class StatisticsRow extends StatelessWidget {
  final String label;
  final String imagePath;
  const StatisticsRow({required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Exo',
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        Image.asset(
          imagePath,
          width: 80,
          height: 80,
        ),
      ],
    );
  }
}
