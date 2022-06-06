import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_post_usecase.dart';

import 'create_post_usecase_test.mocks.dart';

@GenerateMocks([CreatePostRepository])
void main() {
  late CreatePostRepository repository;
  late CreatePostUsecase useCase;
  late CreatePostEntity createPostEntity;
  setUp(() {
    repository = MockCreatePostRepository();
    useCase = CreatePostUsecase(createPostRepository: repository);
    createPostEntity = CreatePostEntity();
  });

  test("When try create post then return a right bool", () async {
    when(repository.createPost(post: createPostEntity))
        .thenAnswer((_) async => Right(true));

    final response = await useCase(createPostEntity);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<bool>());
  });

  test("When try create post then return a left Failure", () async {
    when(repository.createPost(post: createPostEntity)).thenAnswer(
        (_) async => Left(Failure(message: 'appMessage.failures.listPost')));

    final response = await useCase(createPostEntity);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
