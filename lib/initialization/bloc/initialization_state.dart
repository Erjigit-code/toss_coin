part of 'initialization_bloc.dart';

abstract class InitializationState extends Equatable {
  const InitializationState();

  @override
  List<Object> get props => [];
}

class InitializationInitial extends InitializationState {}

class InitializationLoading extends InitializationState {}

class InitializationLoaded extends InitializationState {}
