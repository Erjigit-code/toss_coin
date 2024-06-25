import 'package:flutter/material.dart';

class ChooseImageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChooseImageButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.white.withOpacity(0.4))),
              onPressed: onPressed,
              child: const Text(
                "Выбрать из галереи",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
