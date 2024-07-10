class UserModel {
  String nickname;
  String avatarPath;
  int record;

  UserModel(
      {required this.nickname, required this.avatarPath, this.record = 0});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nickname: json['nickname'],
      avatarPath: json['avatarPath'],
      record: json['record'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'avatarPath': avatarPath,
      'record': record,
    };
  }
}
