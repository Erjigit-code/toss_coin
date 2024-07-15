import 'package:coin_flip/screens/registration_screen/avatars_container.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarSvg;
  final String? selectedAvatar;
  final Function() onTap;

  const AvatarWidget({
    Key? key,
    required this.avatarSvg,
    required this.selectedAvatar,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AvatarsContainer(
        selectedAvatar: selectedAvatar,
        avatarSvg: avatarSvg,
      ),
    );
  }
}
