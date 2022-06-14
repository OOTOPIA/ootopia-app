import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_tag_usecase.dart';

import 'create_post_usecase_test.mocks.dart';

@GenerateMocks([CreatePostRepository])
void main() {
  late CreatePostRepository repository;
  late CreateTagUsecase useCase;
  setUp(() {
    repository = MockCreatePostRepository();
    useCase = CreateTagUsecase(createPostRepository: repository);
  });

  test('When try create post then return a right bool', () async {
    String tag = 'createPostEntity';
    when(repository.createTag(name: tag))
        .thenAnswer((_) async => Right(InterestsTagsEntity(
              id: 'id',
              name: 'name',
              numberOfPosts: 10,
            )));

    final response = await useCase(name: tag);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<bool>());
  });

  test('When try create post then return a left Failure', () async {
    String tag = 'createPostEntity';
    when(repository.createTag(name: tag)).thenAnswer(
        (_) async => Left(Failure(message: 'appMessage.failures.listPost')));

    final response = await useCase(name: tag);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
