import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_tag_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart';

part 'interesting_tags_store.g.dart';

class InterestingTagsStore = InterestingTagsStoreBase
    with _$InterestingTagsStore;

abstract class InterestingTagsStoreBase with Store {
  final GetInterestTagsUsecase _getInterestTagsUsecase;
  final CreateTagUsecase _createTagUsecase;
  InterestingTagsStoreBase({
    required GetInterestTagsUsecase getTags,
    required CreateTagUsecase createTags,
  })  : _getInterestTagsUsecase = getTags,
        _createTagUsecase = createTags;

  @observable
  List<InterestsTagsEntity> tags = ObservableList.of([]);

  @observable
  AsyncStates viewState = AsyncStates.loading;

  Timer? _debounce;

  int _page = 0;

  @observable
  String tag = '';

  @observable
  String error = '';

  @observable
  bool lastPage = false;

  @observable
  bool createHasTags = false;

  void _incrementPage() => _page += 1;

  void _startLoading() => viewState = AsyncStates.loading;

  void cancelTimer() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
  }

  @action
  Future<void> getMoreTags() async {
    if (!lastPage) {
      _incrementPage();
      getTags(tag);
    }
  }

  void _setTags(List<InterestsTagsEntity> list) {
    if (list.isNotEmpty) {
      tags = ObservableList.of([...tags, ...list]);
    }
  }

  void _stopGetTags(List<InterestsTagsEntity> list) => lastPage = list.isEmpty;

  void _stopLoading({bool hasError = false}) {
    viewState = hasError ? AsyncStates.error : AsyncStates.done;
  }

  @action
  Future<void> getTags(String value) async {
    _startLoading();
    _debounce = Timer(Duration(seconds: 1, milliseconds: 700), () async {
      tag = value;
      var _response =
          await _getInterestTagsUsecase.call(tags: value, page: _page);
      _response.fold(
        (l) => _stopLoading(hasError: true),
        (result) {
          _setTags(result);
          _stopGetTags(result);
          _stopLoading();
        },
      );
    });
  }

  @action
  Future<void> createTag(String name) async {
    var response = await _createTagUsecase(name: name);
    response.fold(
      (left) => error = left.message,
      (right) => createHasTags = right,
    );
  }

  void clearVariables() {
    tags = ObservableList.of([]);
    viewState = AsyncStates.loading;
  }
}