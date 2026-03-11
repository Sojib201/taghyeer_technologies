import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/failures.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log(
            '\n┌─────────────────────────────────────────'
                '\n│ REQUEST'
                '\n│ Method  : ${options.method}'
                '\n│ URL     : ${options.uri}'
                '\n│ Headers : ${options.headers}'
                '\n│ Body    : ${options.data}'
                '\n│ Params  : ${options.queryParameters}'
                '\n└─────────────────────────────────────────',
            name: 'DIO',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
            '\n┌─────────────────────────────────────────'
                '\n│ RESPONSE'
                '\n│ URL     : ${response.requestOptions.uri}'
                '\n│ Status  : ${response.statusCode} ${response.statusMessage}'
                '\n│ Data    : ${response.data.toString().length > 500 ? '${response.data.toString().substring(0, 500)}...[truncated]' : response.data}'
                '\n└─────────────────────────────────────────',
            name: 'DIO',
          );
          handler.next(response);
        },
        onError: (DioException e, handler) {
          developer.log(
            '\n┌─────────────────────────────────────────'
                '\n│ ERROR'
                '\n│ URL     : ${e.requestOptions.uri}'
                '\n│ Type    : ${e.type}'
                '\n│ Status  : ${e.response?.statusCode}'
                '\n│ Message : ${e.message}'
                '\n│ Data    : ${e.response?.data}'
                '\n└─────────────────────────────────────────',
            name: 'DIO',
            error: e,
          );
          handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    developer.log('Auth token set', name: 'DIO');
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    developer.log('Auth token cleared', name: 'DIO');
  }
}

Failure handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
        return const AuthFailure();
      }
      return ServerFailure('Server error: $statusCode');
    default:
      return const UnknownFailure();
  }
}