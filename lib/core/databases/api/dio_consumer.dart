import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/core/databases/api/api_consumer.dart';
import 'package:complaint_app/core/databases/api/end_points.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final SecureStorageHelper secureStorageHelper;
  final String _tokenKey = 'AUTH_TOKEN';

  DioConsumer({required this.dio,required this.secureStorageHelper }) {
    dio.options.baseUrl = EndPoints.baserUrl;
  }

  Future<Map<String, dynamic>> _getAuthorizationHeader() async {
   final token = await secureStorageHelper.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    }
    return {};
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
      // 2. إنشاء خريطة ترويسات جديدة وإضافة Content-Type
    final Map<String, dynamic> headers = Map.from(authHeader);

    if (!isFormData) {
      // 🚀 التصحيح: إذا لم يكن الطلب Form Data، نعتبره JSON ونحدد Content-Type: application/json
      // هذا يحل مشكلة رسالة التحذير السابقة
      headers['Content-Type'] = 'application/json';
    }

      var res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
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

      var res = await dio.get(
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

      var res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(headers: authHeader),
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
