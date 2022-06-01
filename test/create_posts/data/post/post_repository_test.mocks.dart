// Mocks generated by Mockito 5.0.15 from annotations
// in ootopia_app/test/create_posts/data/post/post_repository_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart'
    as _i2;
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart'
    as _i4;
import 'package:ootopia_app/clean_arch/create_post/data/models/interest_tags/interest_tags_model.dart'
    as _i5;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [CreatePostRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreatePostRemoteDatasource extends _i1.Mock
    implements _i2.CreatePostRemoteDatasource {
  MockCreatePostRemoteDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> createPost({_i4.CreatePostModel? createPostModel}) =>
      (super.noSuchMethod(
          Invocation.method(
              #createPost, [], {#createPostModel: createPostModel}),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<List<_i5.InterestTagsModel>> getTags({String? language}) => (super
          .noSuchMethod(Invocation.method(#getTags, [], {#language: language}),
              returnValue: Future<List<_i5.InterestTagsModel>>.value(
                  <_i5.InterestTagsModel>[]))
      as _i3.Future<List<_i5.InterestTagsModel>>);
  @override
  String toString() => super.toString();
}
