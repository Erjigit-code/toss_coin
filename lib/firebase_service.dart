import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadUserData(String nickname, File avatar, int record) async {
    try {
      // Получение текущего пользователя
      User? user = _auth.currentUser;
      if (user == null) {
        // Регистрация анонимного пользователя
        UserCredential userCredential = await _auth.signInAnonymously();
        user = userCredential.user;
      }

      // Загрузка аватара в Firebase Storage
      String fileName = basename(avatar.path);
      Reference storageRef =
          _storage.ref().child('avatars/${user!.uid}/$fileName');
      UploadTask uploadTask = storageRef.putFile(avatar);
      TaskSnapshot snapshot = await uploadTask;
      String avatarUrl = await snapshot.ref.getDownloadURL();

      // Сохранение данных пользователя в Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'nickname': nickname,
        'avatarUrl': avatarUrl,
        'record': record,
      });
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
}
