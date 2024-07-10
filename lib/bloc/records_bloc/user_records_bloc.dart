import 'package:coin_flip/firebase_service.dart';
import 'package:coin_flip/screens/user_record_screen/user_record.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_records_event.dart';
part 'user_records_state.dart';

class UserRecordsBloc extends Bloc<UserRecordsEvent, UserRecordsState> {
  final FirebaseService _firebaseService = FirebaseService();

  UserRecordsBloc() : super(UserRecordsLoading()) {
    on<LoadUserRecords>(_onLoadUserRecords);
  }

  Future<void> _onLoadUserRecords(
      LoadUserRecords event, Emitter<UserRecordsState> emit) async {
    emit(UserRecordsLoading());
    try {
      List<UserRecord> records = await _firebaseService.fetchUserRecords();
      records.sort((a, b) => b.record.compareTo(a.record));
      emit(UserRecordsLoaded(records));
    } catch (e) {
      emit(UserRecordsError("Error loading user records: $e"));
    }
  }
}
