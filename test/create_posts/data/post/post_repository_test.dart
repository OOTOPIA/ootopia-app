import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

import '../../../fixtures/posts/posts_fixtures.dart';
import 'post_repository_test.mocks.dart';

@GenerateMocks([CreatePostRemoteDatasource])
void main() {
  late CreatePostRepository repository;
  late CreatePostRemoteDatasource dataSource;
  late CreatePostEntity createPostEntity;
  setUp(() {
    dataSource = MockCreatePostRemoteDatasource();
    repository =
        CreatePostRepositoryImpl(createPostRemoteDatasource: dataSource);
    createPostEntity = CreatePostEntity();
  });

  test('When try send post then return a right bool', () async {
    final bool resultWhen = true;
    when(dataSource.createPost(
            createPostModel: CreatePostModel.fromEntity(createPostEntity)))
        .thenAnswer((_) async => resultWhen);

    final response = await repository.createPost(post: createPostEntity);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<bool>());
  });

  test('When try send a new post then return a left Failure', () async {
    when(dataSource.createPost(
      createPostModel: CreatePostModel.fromEntity(createPostEntity),
    )).thenThrow(Exception('error'));

    final response = await repository.createPost(post: createPostEntity);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });

  test('When try get users then return a right bool', () async {
    when(dataSource.getUsers(
      fullname: 'andy',
      page: 1,
      excludedIds: '',
    )).thenAnswer((_) async => usersFixture);

    final response = await repository.getUsers(
      fullName: 'andy',
      page: 1,
      excludedIds: '',
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<List<UsersEntity>>());
  });

  test('When try get users then return a left Failure', () async {
    when(dataSource.getUsers(
      fullname: 'andy',
      page: 1,
      excludedIds: '',
    )).thenThrow(Exception('error'));

    final response = await repository.getUsers(
      fullName: 'andy',
      page: 1,
      excludedIds: '',
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
