// import 'package:dartz/dartz.dart';
// import 'package:flutter_consulting/domain/entities/failure/failure.dart';
// import 'package:flutter_consulting/domain/entities/post/post_entity.dart';
// import 'package:flutter_consulting/domain/repositories/post/post_repository.dart';
// import 'package:flutter_consulting/domain/use_case/post/list.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:ootopia_app/clean_arch/create_post/domain/repositories/create_post_repository.dart';

// import '../../../fixtures/posts/posts_fixtures.dart';
// import 'list_test.mocks.dart';

// @GenerateMocks([PostRepository])
// void main() {
//   late CreatePostRepository repository;
//   late ListPostUseCase useCase;

//   setUp(() {
//     repository = MockPostRepository();
//     useCase = ListPostUseCase(repository: repository);
//   });

//   test("When try get post list then return a right List<PostEntity>", () async {
//     const int _page = 0;
//     when(repository.listPosts(_page)).thenAnswer((_) async => right(postsFixture));

//     final response = await useCase(_page);
//     final result = response.fold((l) => l, (r) => r);
//     expect(result, isA<List<PostEntity>>());
//   });

//   test("When try get post list then return a left Failure", () async {
//     const int _page = 0;
//     when(repository.listPosts(_page))
//         .thenAnswer((_) async => left(ServerFailure(message: 'appMessage.failures.listPost')));

//     final response = await useCase(_page);
//     final result = response.fold((l) => l, (r) => r);
//     expect(result, isA<ServerFailure>());
//   });
// }
