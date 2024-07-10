import 'package:flutter/material.dart';

class TextFieldWithShadow extends StatelessWidget {
  const TextFieldWithShadow({
    Key? key,
    required this.nicknameController,
    this.errorText,
  }) : super(key: key);

  final TextEditingController nicknameController;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(
                  color: Colors.grey, fontSize: 16, fontFamily: 'Exo-m'),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blue,
                size: 30,
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 9, left: 15, right: 15),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
