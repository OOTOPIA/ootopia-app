import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/dio_interceptors.dart';

class HttpClient {
  late Dio _dio;
  HttpClient({required Dio dio}) {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL']!,
      connectTimeout: 30 * 1000,
    ))
      ..interceptors.add(AuthInterceptors());
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

  Future<Response> postFile(
    String endpoint, {
    required String fileName,
    required File file,
    Map<String, dynamic>? queryParameters,
  }) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    return _dio.post(
      endpoint,
      data: formData,
      queryParameters: queryParameters,
    );
  }
}
