import 'package:dio/dio.dart';

import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_service.dart';
import '../../../core/utils/pref_helpers.dart';
import 'user_model.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  static const String _loginEndpoint = '/login';
  static const String _registerEndpoint = '/register';
  static const String _logout = '/logout';
  static const String getProfileData = '/profile';

  /// Login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(_loginEndpoint, {
        'email': email,
        'password': password,
      });

      if (response is Failure) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];
        if (code != 200 || data == null) {
          throw Failure(errorMassage: msg);
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null && user.token!.isNotEmpty) {
          await PrefHelpers.saveToken(user.token!);
        }
        return user;
      } else {
        throw Failure(
          errorMassage: 'Unexpected error from server',
        );
      }
    } on DioException catch (e) {
      throw ApiExceptions.fromDioException(e);
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  /// Signup
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        _registerEndpoint,
        {'email': email, 'password': password, 'name': name},
      );

      if (response is Failure) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];
        final coder = int.tryParse(code);
        if (coder != 200 || data == null) {
          throw Failure(errorMassage: msg);
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null && user.token!.isNotEmpty) {
          await PrefHelpers.saveToken(user.token!);
        }
        return user;
      } else {
        throw Failure(
          errorMassage: 'Unexpected error from server',
        );
      }
    } on DioException catch (e) {
      throw ApiExceptions.fromDioException(e);
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  // /// Get Profile Data
  // Future<UserModel> getProfile() async {
  //   final response = await _apiService.get(_profileEndpoint);

  //   if (response is ApiExceptions) {
  //     throw response;
  //   }

  //   final userJson = _extractUserJson(response);
  //   return UserModel.fromJson(userJson);
  // }

  // /// Update Profile Data
  // Future<UserModel> updateProfile({
  //   required String name,
  //   required String email,
  //   String? address,
  //   String? image,
  //   String? visa,
  // }) async {
  //   final response = await _apiService
  //       .put(_updateProfileEndpoint, {
  //         'name': name,
  //         'email': email,
  //         if (address != null) 'address': address,
  //         if (image != null) 'image': image,
  //         if (visa != null) 'visa': visa,
  //       });

  //   if (response is ApiExceptions) {
  //     throw response;
  //   }

  //   final userJson = _extractUserJson(response);
  //   return UserModel.fromJson(userJson);
  // }

  // /// LogOut
  // Future<void> logout() async {
  //   await PrefHelpers.clearToken();
  // }

  // Map<String, dynamic> _extractUserJson(dynamic response) {
  //   if (response is Map<String, dynamic>) {
  //     if (response['data'] is Map<String, dynamic>) {
  //       return Map<String, dynamic>.from(
  //         response['data'] as Map,
  //       );
  //     }
  //     if (response['user'] is Map<String, dynamic>) {
  //       return Map<String, dynamic>.from(
  //         response['user'] as Map,
  //       );
  //     }
  //     return Map<String, dynamic>.from(response);
  //   }
  //   throw ApiExceptions(errorMassage: 'Invalid response format');
  // }
}
