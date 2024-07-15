import 'package:flutter/material.dart';
import 'package:coin_flip/screens/user_record_screen/user_record.dart';
import 'package:coin_flip/screens/user_record_screen/get_image.dart';

Future<void> showUserProfileDialog(BuildContext context, UserRecord record) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.7),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showAvatar(context, record);
              },
              child: CircleAvatar(
                radius: 50,
                child: ClipOval(
                  child:
                      getImageWidget(record.avatarUrl, height: 100, width: 100),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              record.nickname,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Exo',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '"LocaleKeys.rec.tr()": ${record.record}',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Exo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("LocaleKeys.close.tr()"),
          ),
        ],
      );
    },
  );
}

Future<void> showAvatar(BuildContext context, UserRecord record) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.9), // Затемнение фона
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 300,
                height: 300,
                child:
                    getImageWidget(record.avatarUrl, height: 300, width: 300),
              ),
            ],
          ),
        ),
      );
    },
  );
}
