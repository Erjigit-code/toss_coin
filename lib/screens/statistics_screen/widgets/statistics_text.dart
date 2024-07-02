import 'package:flutter/material.dart';

class StatisticsText extends StatelessWidget {
  final String text;
  const StatisticsText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Exo',
        color: Colors.white,
        fontSize: 30,
      ),
    );
  }
}
