import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
              child: Text(
                LocaleKeys.choose_from_gallery.tr(),
                style: const TextStyle(
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
