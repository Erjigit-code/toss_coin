part of 'user_records_bloc.dart';

abstract class UserRecordsEvent extends Equatable {
  const UserRecordsEvent();

  @override
  List<Object> get props => [];
}

class LoadUserRecords extends UserRecordsEvent {}
