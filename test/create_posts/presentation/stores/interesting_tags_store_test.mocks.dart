// Mocks generated by Mockito 5.2.0 from annotations
// in ootopia_app/test/create_posts/presentation/stores/interesting_tags_store_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:either_dart/either.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ootopia_app/clean_arch/core/exception/failure.dart' as _i5;
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart'
    as _i6;
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_tag_usecase.dart'
    as _i7;
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart'
    as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [GetInterestTagsUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetInterestTagsUsecase extends _i1.Mock
    implements _i3.GetInterestTagsUsecase {
  MockGetInterestTagsUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.InterestsTagsEntity>>> call(
          {String? tags, int? page}) =>
      (super.noSuchMethod(
          Invocation.method(#call, [], {#tags: tags, #page: page}),
          returnValue: Future<
                  _i2.Either<_i5.Failure, List<_i6.InterestsTagsEntity>>>.value(
              _FakeEither_0<_i5.Failure, List<_i6.InterestsTagsEntity>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.InterestsTagsEntity>>>);
}

/// A class which mocks [CreateTagUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreateTagUsecase extends _i1.Mock implements _i7.CreateTagUsecase {
  MockCreateTagUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.InterestsTagsEntity>> call(
          {String? name}) =>
      (super.noSuchMethod(Invocation.method(#call, [], {#name: name}),
          returnValue:
              Future<_i2.Either<_i5.Failure, _i6.InterestsTagsEntity>>.value(
                  _FakeEither_0<_i5.Failure, _i6.InterestsTagsEntity>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.InterestsTagsEntity>>);
}
