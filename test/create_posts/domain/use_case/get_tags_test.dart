import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart';

import '../../../fixtures/posts/posts_fixtures.dart';
import 'create_post_usecase_test.mocks.dart';

@GenerateMocks([CreatePostRepository])
void main() {
  late CreatePostRepository repository;
  late GetInterestTagsUsecase useCase;
  setUp(() {
    repository = MockCreatePostRepository();
    useCase = GetInterestTagsUsecase(createPostRepository: repository);
  });

  test("When try get tags then return a right List of interestingTags",
      () async {
    String tags = 'opa';
    const int page = 1;
    when(repository.getTags(tags: tags, page: page))
        .thenAnswer((_) async => Right(interestingTagsFixture));

    final response = await useCase(tags: tags, page: page);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<List<InterestsTagsEntity>>());
  });

  test("When try get tags then return a left Failure", () async {
    String tags = 'opa';
    const int page = 1;
    when(repository.getTags(tags: tags, page: page)).thenAnswer(
        (_) async => Left(Failure(message: 'appMessage.failures.listPost')));

    final response = await useCase(tags: tags, page: page);
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
