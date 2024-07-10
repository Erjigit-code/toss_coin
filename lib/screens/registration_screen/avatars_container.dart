import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarsContainer extends StatelessWidget {
  const AvatarsContainer({
    super.key,
    required String? selectedAvatar,
    required this.avatarSvg,
  }) : _selectedAvatar = selectedAvatar;

  final String? _selectedAvatar;
  final String avatarSvg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4), // добавляем отступы вокруг аватара
      decoration: BoxDecoration(
        border: Border.all(
          color:
              _selectedAvatar == avatarSvg ? Colors.blue : Colors.transparent,
          width: 4,
        ),
        borderRadius:
            BorderRadius.circular(44), // Увеличиваем радиус для границы
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: ClipOval(
          child: Stack(
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: SvgPicture.string(
                  avatarSvg,
                  fit: BoxFit.cover,
                ),
              ),
              if (_selectedAvatar == avatarSvg)
                Positioned.fill(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 0.5),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
