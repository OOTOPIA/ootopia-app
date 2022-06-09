// Mocks generated by Mockito 5.0.15 from annotations
// in ootopia_app/test/create_posts/data/data_source/post/post_remote_data_source_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:io' as _i5;

import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeResponse_0<T> extends _i1.Fake implements _i2.Response<T> {}

/// A class which mocks [HttpClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpClient extends _i1.Mock implements _i3.HttpClient {
  MockHttpClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Response<dynamic>> get(String? endpoint,
          {Map<String, dynamic>? queryParameters}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #get, [endpoint], {#queryParameters: queryParameters}),
              returnValue: Future<_i2.Response<dynamic>>.value(
                  _FakeResponse_0<dynamic>()))
          as _i4.Future<_i2.Response<dynamic>>);
  @override
  _i4.Future<_i2.Response<dynamic>> post(String? endpoint,
          {dynamic data, Map<String, dynamic>? queryParameters}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [endpoint],
                  {#data: data, #queryParameters: queryParameters}),
              returnValue: Future<_i2.Response<dynamic>>.value(
                  _FakeResponse_0<dynamic>()))
          as _i4.Future<_i2.Response<dynamic>>);
  @override
  _i4.Future<_i2.Response<dynamic>> delete(String? endpoint,
          {dynamic data, Map<String, dynamic>? queryParameters}) =>
      (super.noSuchMethod(
              Invocation.method(#delete, [endpoint],
                  {#data: data, #queryParameters: queryParameters}),
              returnValue: Future<_i2.Response<dynamic>>.value(
                  _FakeResponse_0<dynamic>()))
          as _i4.Future<_i2.Response<dynamic>>);
  @override
  _i4.Future<_i2.Response<dynamic>> postFile(String? endpoint,
          {String? fileName,
          _i5.File? file,
          Map<String, dynamic>? queryParameters}) =>
      (super.noSuchMethod(
              Invocation.method(#postFile, [
                endpoint
              ], {
                #fileName: fileName,
                #file: file,
                #queryParameters: queryParameters
              }),
              returnValue: Future<_i2.Response<dynamic>>.value(
                  _FakeResponse_0<dynamic>()))
          as _i4.Future<_i2.Response<dynamic>>);
  @override
  String toString() => super.toString();
}
