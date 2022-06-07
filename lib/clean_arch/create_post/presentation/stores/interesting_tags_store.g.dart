// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interesting_tags_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InterestingTagsStore on InterestingTagsStoreBase, Store {
  final _$tagsAtom = Atom(name: 'InterestingTagsStoreBase.tags');

  @override
  List<InterestsTagsEntity> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(List<InterestsTagsEntity> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  final _$selectedTagsAtom =
      Atom(name: 'InterestingTagsStoreBase.selectedTags');

  @override
  List<InterestsTagsEntity> get selectedTags {
    _$selectedTagsAtom.reportRead();
    return super.selectedTags;
  }

  @override
  set selectedTags(List<InterestsTagsEntity> value) {
    _$selectedTagsAtom.reportWrite(value, super.selectedTags, () {
      super.selectedTags = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'InterestingTagsStoreBase.viewState');

  @override
  AsyncStates get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(AsyncStates value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

  final _$tagAtom = Atom(name: 'InterestingTagsStoreBase.tag');

  @override
  String get tag {
    _$tagAtom.reportRead();
    return super.tag;
  }

  @override
  set tag(String value) {
    _$tagAtom.reportWrite(value, super.tag, () {
      super.tag = value;
    });
  }

  final _$errorAtom = Atom(name: 'InterestingTagsStoreBase.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$lastPageAtom = Atom(name: 'InterestingTagsStoreBase.lastPage');

  @override
  bool get lastPage {
    _$lastPageAtom.reportRead();
    return super.lastPage;
  }

  @override
  set lastPage(bool value) {
    _$lastPageAtom.reportWrite(value, super.lastPage, () {
      super.lastPage = value;
    });
  }

  final _$createHasTagsAtom =
      Atom(name: 'InterestingTagsStoreBase.createHasTags');

  @override
  bool get createHasTags {
    _$createHasTagsAtom.reportRead();
    return super.createHasTags;
  }

  @override
  set createHasTags(bool value) {
    _$createHasTagsAtom.reportWrite(value, super.createHasTags, () {
      super.createHasTags = value;
    });
  }

  final _$getMoreTagsAsyncAction =
      AsyncAction('InterestingTagsStoreBase.getMoreTags');

  @override
  Future<void> getMoreTags() {
    return _$getMoreTagsAsyncAction.run(() => super.getMoreTags());
  }

  final _$getTagsAsyncAction = AsyncAction('InterestingTagsStoreBase.getTags');

  @override
  Future<void> getTags(String value) {
    return _$getTagsAsyncAction.run(() => super.getTags(value));
  }

  final _$createTagAsyncAction =
      AsyncAction('InterestingTagsStoreBase.createTag');

  @override
  Future<void> createTag() {
    return _$createTagAsyncAction.run(() => super.createTag());
  }

  @override
  String toString() {
    return '''
tags: ${tags},
selectedTags: ${selectedTags},
viewState: ${viewState},
tag: ${tag},
error: ${error},
lastPage: ${lastPage},
createHasTags: ${createHasTags}
    ''';
  }
}
