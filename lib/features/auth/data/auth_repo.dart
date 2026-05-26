import 'package:dio/dio.dart';

import '../../../core/network/api_exceptions.dart';
import '../../../core/network/api_service.dart';
import '../../../core/utils/pref_helpers.dart';
import 'user_model.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();

  static const String _loginEndpoint = '/login';
  static const String _registerEndpoint = '/register';
  static const String _getProfile = '/profile';
  static const String _updateProfile = '/update-profile';
  static const String _logout = '/logout';
  bool isGuest = false;
  UserModel? _currentUser;

  /// Login
  Future<UserModel?> login({
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
        isGuest = false;
        _currentUser = user;
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
  Future<UserModel?> signup({
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
        isGuest = false;
        _currentUser = user;
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

  /// Get Profile Data
  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelpers.getToken();
      if (token == null || token == 'guest') {
        return null;
      }

      final response = await _apiService.get(_getProfile);
      final user = UserModel.fromJson(response['data']);
      _currentUser = user;
      return user;
    } on DioException catch (e) {
      throw ApiExceptions(errorMassage: e.toString());
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  /// Update Profile Data
  Future<UserModel?> updateProfile({
    required String name,
    required String email,
    String? address,
    String? image,
    String? visa,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'address': address,
        if (image != null && image.isNotEmpty)
          'image': await MultipartFile.fromFile(
            image,
            filename: image.split('/').last,
          ),
        if (visa != null && visa.isNotEmpty) 'Visa': visa,
      });
      final response = await _apiService.post(
        _updateProfile,
        formData,
      );
      if (response is Failure) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];

        if (code != 200 && code != 201) {
          throw Failure(errorMassage: msg ?? 'Unknown error');
        }
      }
      final updatedUser = UserModel.fromJson(response['data']);
      _currentUser = updatedUser;
      return updatedUser;
    } on DioException catch (e) {
      throw ApiExceptions.fromDioException(e);
    } catch (e) {
      throw Failure(errorMassage: e.toString());
    }
  }

  /// LogOut
  Future<void> logout() async {
    final response = await _apiService.post(_logout, {});
    if (response['data'] != null) {
      throw Failure(errorMassage: 'Error in Logout !!');
    }
    await PrefHelpers.clearToken();
    _currentUser = null;
    isGuest = true;
  }

  /// AutoLogin
  Future<UserModel?> autoLogin() async {
    final token = await PrefHelpers.getToken();

    if (token == null || token == 'guest') {
      _currentUser = null;
      return null;
    }

    isGuest = false;

    try {
      final user = await getProfileData();
      _currentUser = user;
      return user;
    } catch (e) {
      await PrefHelpers.clearToken();
      isGuest = true;
      _currentUser = null;
      return null;
    }
  }

  /// continue as guest
  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelpers.saveToken('guest');
  }

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => !isGuest && _currentUser != null;
}
