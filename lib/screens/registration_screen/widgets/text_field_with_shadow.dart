import 'package:flutter/material.dart';

class TextFieldWithShadow extends StatelessWidget {
  final TextEditingController nicknameController;
  final FocusNode focusNode;
  final String? errorText;

  const TextFieldWithShadow({
    Key? key,
    required this.nicknameController,
    required this.focusNode,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nicknameController,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'Nickname',
        errorText: errorText,
        border: OutlineInputBorder(),
        // Add your existing decoration properties
      ),
    );
  }
}
