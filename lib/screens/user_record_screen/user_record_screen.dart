import 'dart:ui';

import 'package:coin_flip/bloc/UserProfile_bloc/user_profile_bloc.dart';
import 'package:coin_flip/bloc/records_bloc/user_records_bloc.dart';
import 'package:coin_flip/generated/locale_keys.g.dart';
import 'package:coin_flip/screens/user_record_screen/get_image.dart';
import 'package:coin_flip/screens/user_record_screen/user_record.dart';
import 'package:coin_flip/smooth_back.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dialogs.dart'; // Импортируем файл с диалогами

class UserRecordsScreen extends StatefulWidget {
  const UserRecordsScreen({super.key});

  @override
  UserRecordsScreenState createState() => UserRecordsScreenState();
}

class UserRecordsScreenState extends State<UserRecordsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("LocaleKeys.global_records.tr()"),
        backgroundColor: Colors.transparent,
      ),
      body: BlocProvider(
        create: (context) => UserRecordsBloc()..add(LoadUserRecords()),
        child: BlocBuilder<UserRecordsBloc, UserRecordsState>(
          builder: (context, state) {
            if (state is UserRecordsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserRecordsLoaded) {
              // Сортировка записей по очкам в порядке убывания
              List<UserRecord> records = state.records;
              records.sort((a, b) => b.record.compareTo(a.record));

              return Stack(
                children: [
                  SmoothBack(),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      UserRecord record = records[index];
                      bool isCurrentUser = false;

                      final userProfileState =
                          context.read<UserProfileBloc>().state;
                      if (userProfileState is UserProfileLoaded) {
                        isCurrentUser =
                            record.nickname == userProfileState.nickname;
                      }

                      return GestureDetector(
                        onTap: () {
                          showUserProfileDialog(context,
                              record); // Используем функцию для показа диалога
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          color: isCurrentUser
                              ? Colors.white.withOpacity(0.6)
                              : Colors.transparent,
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: isCurrentUser ? 'Exo' : 'Exo-m',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    showAvatar(context,
                                        record); // Используем функцию для показа аватара
                                  },
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: getImageWidget(record.avatarUrl),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  record.nickname,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: isCurrentUser ? 'Exo' : 'Exo-m',
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Text(
                              record.record.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: isCurrentUser ? 'Exo' : 'Exo-m',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (state is UserRecordsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown error'));
            }
          },
        ),
      ),
    );
  }
}
