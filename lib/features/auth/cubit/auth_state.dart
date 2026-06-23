part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

/// Login
final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMsg;

  LoginFailure(this.errorMsg);
}

/// Sign Up
final class SignupLoading extends AuthState {}

final class SignupSuccess extends AuthState {}

final class SignupFailure extends AuthState {
  final String errorMsg;
  SignupFailure(this.errorMsg);
}

/// Profile

class GetProfileLoading extends AuthState {}

class GetProfileSuccess extends AuthState {}

class ProfileUpdating extends AuthState {}

class ProfileUpdatingSuccess extends AuthState {}

class ProfileFailure extends AuthState {
  final String error;
  ProfileFailure(this.error);
}

class LogoutSuccess extends AuthState {}
