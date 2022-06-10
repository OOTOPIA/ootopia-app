import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/async_states.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/create_tag_usecase.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/usecases/get_interest_tags_usecase.dart';

import 'package:injectable/injectable.dart';
part 'interesting_tags_store.g.dart';

@singleton
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
  List<InterestsTagsEntity> selectedTags = ObservableList.of([]);

  TextEditingController tagTextController = TextEditingController();

  @observable
  AsyncStates viewState = AsyncStates.loading;

  Timer? _debounce;

  int _page = 1;

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

  bool get loadingMoreTags => viewState == AsyncStates.loadingNewData;

  void _startLoadingNewData() => viewState = AsyncStates.loadingNewData;

  void cancelTimer() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
  }

  @action
  Future<void> getMoreTags() async {
    if (!lastPage) {
      _startLoadingNewData();
      _incrementPage();
      getTags(tag);
    }
  }

  void _setTags(List<InterestsTagsEntity> list) {
    if (list.isNotEmpty) {
      tags = ObservableList.of([...tags, ...list]);
    }
  }

  void _resetTags() {
    tags = ObservableList.of([]);
  }

  void _stopGetTags(List<InterestsTagsEntity> list) => lastPage = list.isEmpty;

  void _stopLoading({bool hasError = false}) {
    viewState = hasError ? AsyncStates.error : AsyncStates.done;
  }

  @action
  Future<void> getTags(String value) async {
    if (viewState != AsyncStates.loadingNewData) {
      _resetTags();
      _startLoading();
    }
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(seconds: 1), () async {
      tag = value;
      var _response =
          await _getInterestTagsUsecase.call(tags: value, page: _page);
      _response.fold(
        (l) => _stopLoading(hasError: true),
        (result) {
          tags.add(InterestsTagsEntity(id: '0', name: value, numberOfPosts: 0));
          _setTags(result);
          _stopGetTags(result);
          _stopLoading();
        },
      );
    });
  }

  @action
  Future<void> createTag() async {
    var response = await _createTagUsecase(name: tag);
    response.fold(
      (left) => error = left.message,
      (right) => selectedTags.add(right),
    );
  }

  void clearVariables() {
    tags = ObservableList.of([]);
    viewState = AsyncStates.loading;
  }
}
