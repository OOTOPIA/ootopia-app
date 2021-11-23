///
/// Created by Claudio
///

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:package_info/package_info.dart';

class ApiClient {
  static Dio? _dioInstance;
  static BaseOptions? _options;
  static InterceptorsWrapper? _dioInterceptor;

  static Dio api() {
    if (_options == null) {
      _options = BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        connectTimeout: 30 * 1000,
      );
    }

    _dioInstance = (_dioInstance == null ? Dio(_options) : _dioInstance);

    if (_dioInterceptor == null) {
      _dioInterceptor = AuthInterceptors();
      _dioInstance!.interceptors.add(_dioInterceptor!);
    }

    return _dioInstance!;
  }
}

class AuthInterceptors extends InterceptorsWrapper with SecureStoreMixin {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    var headers = await this.getHeaders();
    headers['User-Agent'] =
        "${Platform.operatingSystem}+${Platform.operatingSystemVersion}/${info.version}+${info.buildNumber}";
    if ((options.path == dotenv.env['API_URL']! + "posts") ||
        (options.path == dotenv.env['API_URL']! + "users")) {
      headers.remove('Content-Type');
    }
    options.headers = headers;
    return super.onRequest(options, handler);
  }

  final Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  Future<Map<String, String>> getHeaders([String? contentType]) async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return _headers;
    }

    String? token = await getAuthToken();
    if (token == null) return _headers;

    Map<String, String> headers = {'Authorization': 'Bearer ' + token};

    if (contentType == null) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    return headers;
  }
}
