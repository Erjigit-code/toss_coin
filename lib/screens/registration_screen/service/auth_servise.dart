import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  Future<User?> signInAnonymously() async {
    UserCredential userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  Future<String> uploadAvatar(User user, Uint8List avatarData) async {
    TaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child(
            'avatars/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.svg')
        .putData(avatarData);
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveUserToFirestore(
      User user, String nickname, String avatarUrl) async {
    await _firestore.collection('users').doc(user.uid).set({
      'nickname':
          nickname.toLowerCase(), // Lowercase for case-insensitive search
      'avatarUrl': avatarUrl,
      'record': 0,
    });
  }

  Future<void> saveUserLocally(String nickname, String avatarPath) async {
    final box = await Hive.openBox('settings');
    await box.put('user', {
      'nickname': nickname,
      'avatarPath': avatarPath,
    });
  }

  Future<bool> isNicknameTaken(String nickname) async {
    User? user = _firebaseAuth.currentUser;
    user ??= await signInAnonymously();

    final querySnapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: nickname.toLowerCase())
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
