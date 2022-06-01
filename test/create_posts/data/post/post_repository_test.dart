import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

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

  test("When try send post then return a right List<PostEntity>", () async {
    when(dataSource.createPost(
            createPostModel: CreatePostModel.fromEntity(createPostEntity)))
        .thenAnswer((_) async => true);

    final response = await repository.createPost(
      post: CreatePostModel.fromEntity(createPostEntity),
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<List<CreatePostEntity>>());
  });

  test("When try send a new post then return a left Failure", () async {
    when(dataSource.createPost(
      createPostModel: CreatePostModel.fromEntity(createPostEntity),
    )).thenThrow(Exception('error'));

    final response = await repository.createPost(
      post: CreatePostModel.fromEntity(createPostEntity),
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
