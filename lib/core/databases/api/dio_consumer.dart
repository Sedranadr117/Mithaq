import 'package:complaint_app/core/databases/api/api_consumer.dart';
import 'package:complaint_app/core/databases/api/end_points.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final SecureStorageHelper secureStorageHelper;
  final String _tokenKey = 'AUTH_TOKEN';

  DioConsumer({required this.dio, required this.secureStorageHelper}) {
    dio.options.baseUrl = EndPoints.baserUrl;

    // Configure timeouts to prevent long waits
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 300);

    // Add error interceptor to handle 401 (token expired)
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired or unauthorized - clear the token and user info
            await secureStorageHelper.remove(_tokenKey);
            await secureStorageHelper.remove('USER_EMAIL');
            await secureStorageHelper.remove('USER_FIRST_NAME');
            await secureStorageHelper.remove('USER_LAST_NAME');
            await secureStorageHelper.remove('USER_IS_ACTIVE');
            debugPrint(
              '🔒 Token expired - cleared all user data from SecureStorage',
            );
          }
          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        logPrint: (obj) => print("📡 $obj"),
      ),
    );
  }

  Future<Map<String, dynamic>> _getAuthorizationHeader() async {
    try {
      final token = await secureStorageHelper.getString(_tokenKey);
      if (token != null && token.isNotEmpty) {
        debugPrint('🔑 Token found: ${token.substring(0, 20)}...');
        return {'Authorization': 'Bearer $token'};
      }
      debugPrint('⚠️ No token found in storage');
      // Return empty map if no token - but this should be handled by the calling code
      return {};
    } catch (e) {
      debugPrint('❌ Error retrieving token: $e');
      return {};
    }
  }

  //!POST
  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final authHeader = await _getAuthorizationHeader();

      // When FormData is used, let Dio automatically set multipart/form-data content type
      final formData = isFormData
          ? (data is FormData ? data : FormData.fromMap(data))
          : null;

      // For FormData, create Options without contentType to let Dio set it automatically
      // For regular JSON, set contentType to application/json
      final options = formData != null
          ? Options(headers: authHeader)
          : Options(
              headers: {...authHeader, 'Content-Type': 'application/json'},
            );

      var res = await dio.post(
        path,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: options,
      );

      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  //!GET
  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final authHeader = await _getAuthorizationHeader();

      // Ensure headers are properly set - always include Content-Type
      final headers = <String, dynamic>{
        'Content-Type': 'application/json',
        ...authHeader, // This will add Authorization if token exists
      };

      // Debug: Log if token is missing for authenticated endpoints
      if (authHeader.isEmpty &&
          !path.contains('login') &&
          !path.contains('register')) {
        debugPrint('⚠️ Warning: No auth token found for request to $path');
      }

      var res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  //!DELETE
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final authHeader = await _getAuthorizationHeader();

      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: authHeader),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final authHeader = await _getAuthorizationHeader();

      // When FormData is used, let Dio automatically set multipart/form-data content type
      final formData = isFormData
          ? (data is FormData ? data : FormData.fromMap(data))
          : null;

      // For FormData, create Options without contentType to let Dio set it automatically
      // For regular JSON, set contentType to application/json
      final options = formData != null
          ? Options(headers: authHeader)
          : Options(
              headers: {...authHeader, 'Content-Type': 'application/json'},
            );

      var res = await dio.put(
        path,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: options,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
