import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:QuickBite/features/auth/data/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepo authRepo = AuthRepo();

  UserModel? currentUser;

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      await authRepo.login(email: email, password: password);
      emit(LoginSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) error = e.errorMassage;
      emit(LoginFailure(error));
    }
  }

  /// Signup
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(SignupLoading());
    try {
      final user = await authRepo.signup(
        email: email,
        password: password,
        name: name,
      );
      if (user != null) emit(SignupSuccess());
    } catch (e) {
      String error = 'unhandled error';
      if (e is Failure) error = e.toString();
      emit(SignupFailure(error));
    }
  }

  /// Get Profile
  Future<void> getProfileData() async {
    emit(GetProfileLoading());
    try {
      final user = await authRepo.getProfileData();
      currentUser = user;
      emit(GetProfileSuccess());
    } catch (e) {
      String error = 'Error loading profile';
      if (e is Failure) error = e.errorMassage;
      emit(ProfileFailure(error));
    }
  }

  /// Update Profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? image,
  }) async {
    emit(ProfileUpdating());
    try {
      await authRepo.updateProfile(
        name: name,
        email: email,
        address: address,
        visa: visa ?? '',
        image: image,
      );

      final user = await authRepo.getProfileData();
      currentUser = user;
      emit(ProfileUpdatingSuccess());
    } catch (e) {
      String error = 'Error updating profile';
      if (e is Failure) error = e.errorMassage;
      emit(ProfileFailure(error));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await authRepo.logout();
      currentUser = null;
      emit(LogoutSuccess());
    } catch (e) {
      String error = 'Error logging out';
      if (e is Failure) error = e.errorMassage;
      emit(ProfileFailure(error));
    }
  }
}
