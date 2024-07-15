import 'dart:io';
import 'dart:typed_data';
import 'package:coin_flip/screens/registration_screen/image_gallery.dart';
import 'package:coin_flip/screens/registration_screen/text_field.dart';
import 'package:coin_flip/screens/registration_screen/widgets/avatar_widget.dart';
import 'package:coin_flip/services/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:coin_flip/widgets/app_initializer.dart';
import 'package:coin_flip/constants/constants.dart';
import 'package:coin_flip/screens/registration_screen/service/auth_servise.dart';

import 'dart:async';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _avatarPath;
  bool _isLoading = false;
  String? _selectedAvatar;
  Uint8List? _uploadedAvatar;
  final AuthService _authService = AuthService();
  bool _isNicknameTaken = false;
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onNicknameChanged);
  }

  void _onNicknameChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkNickname(_nicknameController.text);
    });
  }

  Future<void> _checkNickname(String nickname) async {
    if (nickname.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser ??
          await _authService.signInAnonymously();
      if (user != null) {
        bool isTaken = await _authService.isNicknameTaken(nickname);
        setState(() {
          _isNicknameTaken = isTaken;
        });
      } else {
        print("User is not authenticated.");
      }
    }
  }

  Future<void> _pickImage() async {
    final imagePickerService = ImagePickerService(context);
    await imagePickerService.showImageSourceDialog((path) {
      setState(() {
        _avatarPath = path;
        _selectedAvatar = null;
        _uploadedAvatar = File(path).readAsBytesSync();
      });
    }, ImagePickerType.avatar);
  }

  Future<void> _saveUser() async {
    final nickname = _nicknameController.text;
    if (nickname.isNotEmpty &&
        (_selectedAvatar != null || _uploadedAvatar != null)) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isNicknameTaken) {
          _showSnackBar(
              'This nickname is already taken. Please choose another one.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        User? user = await _authService.signInAnonymously();
        if (user != null) {
          String avatarUrl = _uploadedAvatar != null
              ? await _authService.uploadAvatar(user, _uploadedAvatar!)
              : await _authService.uploadAvatar(
                  user, Uint8List.fromList(_selectedAvatar!.codeUnits));

          await Future.wait([
            _authService.saveUserToFirestore(user, nickname, avatarUrl),
            _authService.saveUserLocally(
                nickname, _avatarPath ?? _selectedAvatar!)
          ]);

          final box = Hive.box(Constants.settingsBox);
          await box.put('isRegistered', true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppInitializer()),
          );
        }
      } catch (e) {
        print('Error during registration: $e');
        _showSnackBar('Error during registration: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _showSnackBar('Please enter a nickname and select an avatar.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 242, 240),
        title: const Text(
          'Sign-up',
          style: TextStyle(
            fontFamily: 'Exo',
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 243, 242, 240),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              TextFieldWithShadow(
                nicknameController: _nicknameController,
                focusNode: _focusNode,
                errorText: _isNicknameTaken
                    ? 'This nickname is already taken. Please choose another one.'
                    : null,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text(
                        "Select an Avatar",
                        style: TextStyle(
                          fontFamily: 'Exo',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: List.generate(9, (index) {
                            final avatarSvg =
                                RandomAvatarString(index.toString());
                            return AvatarWidget(
                              avatarSvg: avatarSvg,
                              selectedAvatar: _selectedAvatar,
                              onTap: () {
                                setState(() {
                                  _selectedAvatar = avatarSvg;
                                  _uploadedAvatar = null;
                                });
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: PickImageFromGallery(avatarPath: _avatarPath),
              ),
              const SizedBox(height: 150),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: 400,
                      height: 50,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        ),
                        onPressed: _saveUser,
                        child: const Text(
                          'Sign-up',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Exo',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
