part of 'logout_cubit.dart';

abstract class LogOutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends LogOutState {}

class LogoutLoadingState extends LogOutState {}

class LogoutSuccessState extends LogOutState {}

class LogoutErrorState extends LogOutState {
  final String message;
  LogoutErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
