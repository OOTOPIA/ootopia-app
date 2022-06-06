import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_post_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/search_user_by_name_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';

import '../../../fixtures/posts/posts_fixtures.dart';
import 'create_post_store_test.mocks.dart';

@GenerateMocks([CreatePostUsecase, SearchUserByNameUsecase])
void main() {
  late CreatePostUsecase listPostUseCase;
  late StoreCreatePosts controller;
  late SearchUserByNameUsecase searchUserByNameUsecase;
  setUp(() {
    listPostUseCase = MockCreatePostUsecase();
    searchUserByNameUsecase = MockSearchUserByNameUsecase();
    controller = StoreCreatePosts(
      createPostUsecase: listPostUseCase,
      searchUser: searchUserByNameUsecase,
    );
  });

  test(
      'when try get a list of users, then we have a success and users variable have some users',
      () async {
    controller.fullName = 'andy';
    controller.page = 1;
    controller.excludedIds = '0000';

    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();

    expect(controller.viewState, AsyncStates.done);
    expect(controller.users.length, 2);
    expect(controller.lastPage, false);
  });

  test(
      'when try get a list of users, then we have a success, but api return nothing and users variable is empty',
      () async {
    controller.fullName = 'andy';
    controller.page = 1;
    controller.excludedIds = '0000';

    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right([]));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();

    expect(controller.viewState, AsyncStates.done);
    expect(controller.users.isEmpty, true);
    expect(controller.lastPage, true);
  });

  test(
      'when try get a list of users, then we have an error and users variable is empty',
      () async {
    controller.fullName = 'andy';
    controller.page = 1;
    controller.excludedIds = '0000';

    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Left(Failure(message: '')));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();

    expect(controller.viewState, AsyncStates.error);
    expect(controller.users.isEmpty, true);
  });

  test(
      'when try get more users, then we have a success and users variable have more users',
      () async {
    controller.fullName = 'andy';
    controller.page = 1;
    controller.excludedIds = '0000';

    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));
    when(searchUserByNameUsecase(
      fullName: controller.fullName,
      page: controller.page + 1,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();
    expect(controller.users.length, 2);

    await controller.getMoreUsers();
    expect(controller.viewState, AsyncStates.done);
    expect(controller.page, 2);
    expect(controller.users.length, 4);
    expect(controller.lastPage, false);
  });

  test(
      'when try get more users, then we have an error and users variable have the same value',
      () async {
    controller.fullName = 'andy';
    controller.page = 1;
    controller.excludedIds = '0000';

    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));
    when(searchUserByNameUsecase(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Left(Failure(message: '')));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();
    expect(controller.users.length, 0);
    expect(controller.viewState, AsyncStates.done);
    controller.page += 1;
    await controller.getMoreUsers();
    expect(controller.viewState, AsyncStates.error);
    expect(controller.page, 2);
    expect(controller.users.length, 2);
    expect(controller.lastPage, false);
  });
}
