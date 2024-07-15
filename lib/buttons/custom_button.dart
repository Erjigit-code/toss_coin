import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isActive;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    required this.imagePath,
    this.isActive = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scale = isActive ? 1.2 : 1.0;

    return GestureDetector(
      onTap: onPressed,
      child: Transform.scale(
        scale: scale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlue, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: isActive
                      ? Border.all(width: 1.5, color: Colors.white)
                      : Border.all(width: 0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 24, width: 24),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'exo'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
