import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  DioClient({required Dio dio}) : _dio = dio;

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
