import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_flip/screens/registration_screen/service/auth_servise.dart';
import 'package:coin_flip/screens/user_record_screen/user_record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();

  Future<void> uploadUserData(String nickname, File avatar, int record) async {
    try {
      // Получение текущего пользователя через AuthService
      User? user = await _authService.signInAnonymously();

      if (user != null) {
        String fileName = basename(avatar.path);
        Reference storageRef =
            _storage.ref().child('avatars/${user.uid}/$fileName');

        // Запуск загрузки файла
        UploadTask uploadTask = storageRef.putFile(avatar);
        TaskSnapshot snapshot = await uploadTask;
        String avatarUrl = await snapshot.ref.getDownloadURL();

        // Параллельное выполнение сохранения данных в Firestore и других возможных операций
        await Future.wait([
          _firestore.collection('users').doc(user.uid).set({
            'nickname': nickname,
            'avatarUrl': avatarUrl,
            'record': record,
          }),
          // Здесь можно добавить другие параллельные операции, если необходимо
        ]);
      } else {
        print("User is not authenticated.");
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateUserRecord(String uid, int record) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'record': record,
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<UserRecord>> fetchUserRecords() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('record', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return UserRecord(
          nickname: doc['nickname'] ?? '',
          avatarUrl: doc['avatarUrl'] ?? '',
          record: doc['record'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
