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

  final _$getTagsAsyncAction = AsyncAction('InterestingTagsStoreBase.getTags');

  @override
  Future<void> getTags() {
    return _$getTagsAsyncAction.run(() => super.getTags());
  }

  @override
  String toString() {
    return '''
tags: ${tags},
viewState: ${viewState}
    ''';
  }
}
