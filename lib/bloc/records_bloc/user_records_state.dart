part of 'user_records_bloc.dart';

abstract class UserRecordsState extends Equatable {
  const UserRecordsState();

  @override
  List<Object> get props => [];
}

class UserRecordsLoading extends UserRecordsState {}

class UserRecordsLoaded extends UserRecordsState {
  final List<UserRecord> records;

  const UserRecordsLoaded(this.records);

  @override
  List<Object> get props => [records];
}

class UserRecordsError extends UserRecordsState {
  final String message;

  const UserRecordsError(this.message);

  @override
  List<Object> get props => [message];
}
