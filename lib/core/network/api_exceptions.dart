import 'package:dio/dio.dart';

class Failure {
  final String errorMassage;
  final int? statusCode;
  const Failure({required this.errorMassage, this.statusCode});

  @override
  String toString() {
    return errorMassage;
  }
}

class ApiExceptions extends Failure {
  ApiExceptions({required super.errorMassage, super.statusCode});

  factory ApiExceptions.fromDioException(DioException dioexp) {
    final statusCode = dioexp.response?.statusCode;
    final data = dioexp.response?.data;

    if (data is Map<String, dynamic>) {
      return ApiExceptions(
        errorMassage: data['message'],
        statusCode: statusCode,
      );
    }

    if (statusCode == 302) {
      return ApiExceptions(
        errorMassage: 'This Email Already Taken',
      );
    }

    switch (dioexp.type) {
      case DioExceptionType.connectionTimeout:
        return ApiExceptions(
          errorMassage: 'Connection timeout with ApiServer',
        );
      case DioExceptionType.sendTimeout:
        return ApiExceptions(
          errorMassage: 'Send timeout with ApiServer',
        );
      case DioExceptionType.receiveTimeout:
        return ApiExceptions(
          errorMassage: 'Receive timeout with ApiServer',
        );
      case DioExceptionType.badResponse:
        return ApiExceptions(errorMassage: dioexp.toString());
      case DioExceptionType.cancel:
        return ApiExceptions(
          errorMassage: 'Request to ApiServer was canceld',
        );
      case DioExceptionType.unknown:
        if (dioexp.message!.contains('SocketException')) {
          return ApiExceptions(
            errorMassage: 'No Internet Connection',
          );
        }
        return ApiExceptions(
          errorMassage: 'Unexpected Error, Please try again!',
        );
      default:
        return ApiExceptions(
          errorMassage:
              'Opps There was an Error, Please try again',
        );
    }
  }

  factory ApiExceptions.fromResponse(
    int? statusCode,
    dynamic response,
  ) {
    if (statusCode == 400 ||
        statusCode == 401 ||
        statusCode == 403) {
      return ApiExceptions(
        errorMassage: response['error']['message'],
      );
    } else if (statusCode == 404) {
      return ApiExceptions(
        errorMassage:
            'Your request not found, Please try later!',
      );
    } else if (statusCode == 500) {
      return ApiExceptions(
        errorMassage: 'Internal Server error, Please try later',
      );
    } else {
      return ApiExceptions(
        errorMassage:
            'Opps There was an Error, Please try again',
      );
    }
  }
}
