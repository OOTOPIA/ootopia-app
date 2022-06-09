// Mocks generated by Mockito 5.0.15 from annotations
// in ootopia_app/test/create_posts/domain/use_case/create_post_usecase_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:io' as _i9;

import 'package:either_dart/either.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ootopia_app/clean_arch/core/exception/failure.dart' as _i5;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart'
    as _i6;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart'
    as _i7;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart'
    as _i8;
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [CreatePostRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreatePostRepository extends _i1.Mock
    implements _i3.CreatePostRepository {
  MockCreatePostRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> createPost(
          {_i6.CreatePostEntity? post}) =>
      (super.noSuchMethod(Invocation.method(#createPost, [], {#post: post}),
              returnValue: Future<_i2.Either<_i5.Failure, bool>>.value(
                  _FakeEither_0<_i5.Failure, bool>()))
          as _i4.Future<_i2.Either<_i5.Failure, bool>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i7.InterestsTagsEntity>>> getTags(
          {String? tags, int? page}) =>
      (super.noSuchMethod(
          Invocation.method(#getTags, [], {#tags: tags, #page: page}),
          returnValue: Future<
                  _i2.Either<_i5.Failure, List<_i7.InterestsTagsEntity>>>.value(
              _FakeEither_0<_i5.Failure, List<_i7.InterestsTagsEntity>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i7.InterestsTagsEntity>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i8.UsersEntity>>> getUsers(
          {String? fullName, int? page, String? excludedIds}) =>
      (super.noSuchMethod(
              Invocation.method(#getUsers, [], {
                #fullName: fullName,
                #page: page,
                #excludedIds: excludedIds
              }),
              returnValue:
                  Future<_i2.Either<_i5.Failure, List<_i8.UsersEntity>>>.value(
                      _FakeEither_0<_i5.Failure, List<_i8.UsersEntity>>()))
          as _i4.Future<_i2.Either<_i5.Failure, List<_i8.UsersEntity>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i7.InterestsTagsEntity>> createTag(
          {String? name}) =>
      (super.noSuchMethod(Invocation.method(#createTag, [], {#name: name}),
          returnValue:
              Future<_i2.Either<_i5.Failure, _i7.InterestsTagsEntity>>.value(
                  _FakeEither_0<_i5.Failure, _i7.InterestsTagsEntity>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i7.InterestsTagsEntity>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, String>> sendMedia(
          String? type, _i9.File? file) =>
      (super.noSuchMethod(Invocation.method(#sendMedia, [type, file]),
              returnValue: Future<_i2.Either<_i5.Failure, String>>.value(
                  _FakeEither_0<_i5.Failure, String>()))
          as _i4.Future<_i2.Either<_i5.Failure, String>>);
  @override
  String toString() => super.toString();
}
