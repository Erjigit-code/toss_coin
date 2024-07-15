import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:coin_flip/screens/registration_screen/service/auth_servise.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final AuthService _authService;

  UserProfileBloc(this._authService) : super(UserProfileLoading()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<UserProfileState> emit) async {
    emit(UserProfileLoading());
    try {
      final user = await _authService.signInAnonymously();
      if (user != null) {
        final userDoc = await _authService.getUserData(user.uid);
        final nickname = userDoc['nickname'];
        final avatarUrl = userDoc['avatarUrl'];
        emit(UserProfileLoaded(nickname: nickname, avatarUrl: avatarUrl));
      } else {
        emit(UserProfileError("Failed to load user profile."));
      }
    } catch (e) {
      emit(UserProfileError("Error loading user profile: $e"));
    }
  }
}
