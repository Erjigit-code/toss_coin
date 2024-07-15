part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final String nickname;
  final String avatarUrl;

  const UserProfileLoaded({required this.nickname, required this.avatarUrl});

  @override
  List<Object?> get props => [nickname, avatarUrl];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
