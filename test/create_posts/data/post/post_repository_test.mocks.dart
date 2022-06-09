// Mocks generated by Mockito 5.0.15 from annotations
// in ootopia_app/test/create_posts/data/post/post_repository_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:io' as _i7;

import 'package:mockito/mockito.dart' as _i1;
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart'
    as _i3;
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart'
    as _i5;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart'
    as _i2;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart'
    as _i6;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeInterestsTagsEntity_0 extends _i1.Fake
    implements _i2.InterestsTagsEntity {}

/// A class which mocks [CreatePostRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreatePostRemoteDatasource extends _i1.Mock
    implements _i3.CreatePostRemoteDatasource {
  MockCreatePostRemoteDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> createPost({_i5.CreatePostModel? createPostModel}) =>
      (super.noSuchMethod(
          Invocation.method(
              #createPost, [], {#createPostModel: createPostModel}),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<List<_i2.InterestsTagsEntity>> getTags(
          {String? language, String? tags, int? page}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getTags, [], {#language: language, #tags: tags, #page: page}),
          returnValue: Future<List<_i2.InterestsTagsEntity>>.value(
              <_i2.InterestsTagsEntity>[])) as _i4
          .Future<List<_i2.InterestsTagsEntity>>);
  @override
  _i4.Future<List<_i6.UsersEntity>> getUsers(
          {int? page, String? fullname, String? excludedIds}) =>
      (super.noSuchMethod(
              Invocation.method(#getUsers, [], {
                #page: page,
                #fullname: fullname,
                #excludedIds: excludedIds
              }),
              returnValue:
                  Future<List<_i6.UsersEntity>>.value(<_i6.UsersEntity>[]))
          as _i4.Future<List<_i6.UsersEntity>>);
  @override
  _i4.Future<_i2.InterestsTagsEntity> createTag(
          {String? name, String? language}) =>
      (super.noSuchMethod(
          Invocation.method(#createTag, [], {#name: name, #language: language}),
          returnValue: Future<_i2.InterestsTagsEntity>.value(
              _FakeInterestsTagsEntity_0())) as _i4
          .Future<_i2.InterestsTagsEntity>);
  @override
  _i4.Future<String> sendMedia(String? type, _i7.File? file) =>
      (super.noSuchMethod(Invocation.method(#sendMedia, [type, file]),
          returnValue: Future<String>.value('')) as _i4.Future<String>);
  @override
  String toString() => super.toString();
}
