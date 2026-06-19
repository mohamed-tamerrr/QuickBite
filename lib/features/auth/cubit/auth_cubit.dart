import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthRepo authRepo = AuthRepo();

  TextEditingController email = TextEditingController(
    text: "mohamed.tamer@gmail.com",
  );

  TextEditingController password = TextEditingController(
    text: "123456789",
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authRepo.login(email: email, password: password);
      emit(AuthSuccess());
    } catch (e) {
      String error = 'Something went wrong !';
      if (e is Failure) {
        error = e.errorMassage;
      }
      emit(AuthFailure(error));
    }
  }
}
