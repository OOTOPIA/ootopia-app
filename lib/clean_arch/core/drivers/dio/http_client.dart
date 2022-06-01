import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpClient {
  late Dio _dio;
  HttpClient({required Dio dio}) {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: 30 * 1000,
    ));
  }

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
