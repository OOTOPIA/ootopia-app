import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_post_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/search_user_by_name_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/send_medias_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/create_posts_stores.dart';
import 'package:fake_async/fake_async.dart';
import '../../../fixtures/posts/posts_fixtures.dart';
import 'create_post_store_test.mocks.dart';

@GenerateMocks([CreatePostUsecase, SearchUserByNameUsecase, SendMediasUsecase])
void main() {
  late CreatePostUsecase createPostUsecase;
  late StoreCreatePosts controller;
  late SearchUserByNameUsecase searchUserByNameUsecase;
  late SendMediasUsecase sendMediasUsecase;
  setUp(() {
    createPostUsecase = MockCreatePostUsecase();
    searchUserByNameUsecase = MockSearchUserByNameUsecase();
    sendMediasUsecase = MockSendMediasUsecase();
    controller = StoreCreatePosts(
      createPostUsecase: createPostUsecase,
      searchUser: searchUserByNameUsecase,
      sendMediasUsecase: sendMediasUsecase,
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
    controller.fullName = '0000';
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
    )).thenAnswer((_) async => Left(Failure(message: '')));

    expect(controller.viewState, AsyncStates.loading);
    expect(controller.users.isEmpty, true);

    await controller.searchUser();
    expect(controller.users.length, 2);
    expect(controller.viewState, AsyncStates.done);
    await controller.getMoreUsers();
    expect(controller.viewState, AsyncStates.error);
    expect(controller.page, 2);
    expect(controller.users.length, 2);
    expect(controller.lastPage, false);
  });

  test('when try create post, then return right', () async {
    controller.postEntity = CreatePostEntity();
    when(createPostUsecase.call(controller.postEntity))
        .thenAnswer((_) async => Right(true));
    expect(controller.viewState, AsyncStates.loading);

    await controller.sendPost();
    expect(controller.viewState, AsyncStates.done);
  });

  test('when try create post, then return left', () async {
    controller.postEntity = CreatePostEntity();
    when(createPostUsecase.call(controller.postEntity))
        .thenAnswer((_) async => Left(Failure(message: '')));
    expect(controller.viewState, AsyncStates.loading);

    await controller.sendPost();
    expect(controller.viewState, AsyncStates.error);
  });

  test('when try to search user by name, and return a error', () async {
    String tags = 'tags';
    controller.fullName = '0000';
    controller.page = 1;
    controller.excludedIds = '0000';
    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Left(Failure(message: '')));
    fakeAsync((async) async {
      expect(controller.viewState, AsyncStates.loading);
      expect(controller.users.isEmpty, true);

      controller.onChanged(tags);

      expect(controller.viewState, AsyncStates.error);
      expect(controller.users.isEmpty, true);
    });
  });

  test('when try to search user by name, and return a list of users', () async {
    String tags = 'tags';
    controller.fullName = '0000';
    controller.page = 1;
    controller.excludedIds = '0000';
    when(searchUserByNameUsecase.call(
      fullName: controller.fullName,
      page: controller.page,
      excludedIds: controller.excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));
    fakeAsync((async) async {
      expect(controller.viewState, AsyncStates.loading);
      expect(controller.users.isEmpty, true);

      controller.onChanged(tags);

      expect(controller.viewState, AsyncStates.done);
      expect(controller.users.isEmpty, true);
    });
  });
}
