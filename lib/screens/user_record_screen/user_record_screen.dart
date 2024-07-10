import 'package:coin_flip/bloc/records_bloc/user_records_bloc.dart';
import 'package:coin_flip/screens/user_record_screen/get_image.dart';
import 'package:coin_flip/screens/user_record_screen/user_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class UserRecordsScreen extends StatefulWidget {
  const UserRecordsScreen({super.key});

  @override
  _UserRecordsScreenState createState() => _UserRecordsScreenState();
}

class _UserRecordsScreenState extends State<UserRecordsScreen> {
  String? currentUserNickname;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserNickname();
  }

  Future<void> _loadCurrentUserNickname() async {
    final box = await Hive.openBox('settings');
    setState(() {
      currentUserNickname = box.get('user')['nickname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Records'),
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

              return ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  UserRecord record = records[index];
                  bool isCurrentUser = record.nickname == currentUserNickname;

                  return Container(
                    color: isCurrentUser
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.transparent,
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: TextStyle(fontSize: 20, fontFamily: 'Exo-m'),
                          ),
                          SizedBox(width: 10),
                          CircleAvatar(
                            child: ClipOval(
                              child: getImageWidget(record.avatarUrl),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            record.nickname,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: isCurrentUser ? 'Exo' : 'Exo-m',
                              color: isCurrentUser ? Colors.blue : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        record.record.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: isCurrentUser ? 'Exo' : 'Exo-m',
                          color: isCurrentUser ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
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
