import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final dynamic backgroundImage;

  const BackgroundWidget({Key? key, required this.backgroundImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
