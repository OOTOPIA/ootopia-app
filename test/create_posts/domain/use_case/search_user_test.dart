import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/search_user_by_name_usecase.dart';

import '../../../fixtures/posts/posts_fixtures.dart';
import 'create_post_usecase_test.mocks.dart';

@GenerateMocks([CreatePostRepository])
void main() {
  late CreatePostRepository repository;
  late SearchUserByNameUsecase useCase;
  setUp(() {
    repository = MockCreatePostRepository();
    useCase = SearchUserByNameUsecase(createPostRepository: repository);
  });

  test("When try get users then return a right List of users", () async {
    String fullname = 'andy';
    int page = 1;
    String excludedIds = '';
    when(repository.getUsers(
      fullName: fullname,
      page: page,
      excludedIds: excludedIds,
    )).thenAnswer((_) async => Right(usersFixture));

    final response = await useCase(
      fullName: fullname,
      page: page,
      excludedIds: excludedIds,
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<List<UsersEntity>>());
  });

  test("When try get users then return a left Failure", () async {
    String fullname = 'andy';
    int page = 1;
    String excludedIds = '';
    when(repository.getUsers(
      fullName: fullname,
      page: page,
      excludedIds: excludedIds,
    )).thenAnswer(
        (_) async => Left(Failure(message: 'appMessage.failures.listPost')));

    final response = await useCase(
      fullName: fullname,
      page: page,
      excludedIds: excludedIds,
    );
    final result = response.fold((l) => l, (r) => r);
    expect(result, isA<Failure>());
  });
}
