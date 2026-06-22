part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMsg;

  LoginFailure(this.errorMsg);
}

final class SignupLoading extends AuthState {}

final class SignupSuccess extends AuthState {}

final class SignupFailure extends AuthState {
  final String errorMsg;
  SignupFailure(this.errorMsg);
}
