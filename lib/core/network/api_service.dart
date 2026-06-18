import 'package:dio/dio.dart';

import 'api_exceptions.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// Get
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dioClient.dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.fromDioException(e);
    }
  }

  /// Post
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        data: body,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.fromDioException(e);
    }
  }

  /// Put
  Future<dynamic> put(String endpoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.put(
        endpoint,
        data: body,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.fromDioException(e);
    }
  }

  /// Delete
  Future<dynamic> delete(String endpoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.delete(
        endpoint,
        data: body,
      );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.fromDioException(e);
    }
  }
}
