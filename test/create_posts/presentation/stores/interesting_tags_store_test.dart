import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/exception/failure.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/stores/interesting_tags_store.dart';

import 'package:fake_async/fake_async.dart';
import '../../../fixtures/posts/posts_fixtures.dart';
import 'interesting_tags_store_test.mocks.dart';

@GenerateMocks([GetInterestTagsUsecase])
void main() {
  late GetInterestTagsUsecase getTagsUsecase;
  late InterestingTagsStore controller;
  setUp(() {
    getTagsUsecase = MockGetInterestTagsUsecase();
    controller = InterestingTagsStore(getTags: getTagsUsecase);
  });

  test('when try get a list of tags, then we have a success', () async {
    String tags = '';
    const int page = 1;
    when(getTagsUsecase.call(tags: tags, page: page))
        .thenAnswer((_) async => Right(interestingTagsFixture));
    fakeAsync((async) async {
      expect(controller.viewState, AsyncStates.loading);
      expect(controller.tags.isEmpty, true);

      await controller.getTags(tags);

      expect(controller.viewState, AsyncStates.done);
      expect(controller.tags.length, 2);
    });
  });
  test('when try get a list of tags, then we have a list empty', () async {
    String tags = '';
    const int page = 1;
    when(getTagsUsecase.call(tags: tags, page: page))
        .thenAnswer((_) async => Right([]));
    fakeAsync((async) async {
      expect(controller.viewState, AsyncStates.loading);
      expect(controller.tags.isEmpty, true);

      await controller.getTags(tags);

      expect(controller.viewState, AsyncStates.done);
      expect(controller.tags.isEmpty, true);
    });
  });
  test('when try get a list of tags, then we have a error', () async {
    String tags = 'tags';
    const int page = 1;
    when(getTagsUsecase.call(tags: tags, page: page))
        .thenAnswer((_) async => Left(Failure(message: '')));
    fakeAsync((async) async {
      expect(controller.viewState, AsyncStates.loading);
      expect(controller.tags.isEmpty, true);

      await controller.getTags(tags);

      expect(controller.viewState, AsyncStates.error);
      expect(controller.tags.isEmpty, true);
    });
  });
}
