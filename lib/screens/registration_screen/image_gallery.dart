import 'dart:io';
import 'package:flutter/material.dart';

class PickImageFromGallery extends StatelessWidget {
  const PickImageFromGallery({
    super.key,
    required String? avatarPath,
  }) : _avatarPath = avatarPath;

  final String? _avatarPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.9),
            blurRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              // изменяем цвет в зависимости от состояния
              backgroundImage:
                  _avatarPath != null ? FileImage(File(_avatarPath)) : null,
              child: _avatarPath == null
                  ? const Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Choose from gallery',
              style: TextStyle(fontSize: 16, fontFamily: 'Exo-m'),
            ),
          ],
        ),
      ),
    );
  }
}
