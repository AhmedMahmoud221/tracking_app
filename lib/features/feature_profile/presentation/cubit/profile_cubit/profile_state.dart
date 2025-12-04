part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class LogoutLoadingState extends ProfileState {}

class LogoutSuccessState extends ProfileState {}

class LogoutErrorState extends ProfileState {
  final String message;
  LogoutErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
