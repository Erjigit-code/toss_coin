import 'package:flutter/material.dart';

class SmoothBack extends StatelessWidget {
  const SmoothBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/back.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
