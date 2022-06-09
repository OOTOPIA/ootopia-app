// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_tracks_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LearningTracksStore on LearningTracksStoreBase, Store {
  final _$allLearningTracksAtom =
      Atom(name: 'LearningTracksStoreBase.allLearningTracks');

  @override
  List<LearningTracksModel> get allLearningTracks {
    _$allLearningTracksAtom.reportRead();
    return super.allLearningTracks;
  }

  @override
  set allLearningTracks(List<LearningTracksModel> value) {
    _$allLearningTracksAtom.reportWrite(value, super.allLearningTracks, () {
      super.allLearningTracks = value;
    });
  }

  final _$isLoadingMoreAtom =
      Atom(name: 'LearningTracksStoreBase.isLoadingMore');

  @override
  bool get isLoadingMore {
    _$isLoadingMoreAtom.reportRead();
    return super.isLoadingMore;
  }

  @override
  set isLoadingMore(bool value) {
    _$isLoadingMoreAtom.reportWrite(value, super.isLoadingMore, () {
      super.isLoadingMore = value;
    });
  }

  final _$hasMoreItemsAtom = Atom(name: 'LearningTracksStoreBase.hasMoreItems');

  @override
  bool get hasMoreItems {
    _$hasMoreItemsAtom.reportRead();
    return super.hasMoreItems;
  }

  @override
  set hasMoreItems(bool value) {
    _$hasMoreItemsAtom.reportWrite(value, super.hasMoreItems, () {
      super.hasMoreItems = value;
    });
  }

  final _$welcomeGuideLearningTrackAtom =
      Atom(name: 'LearningTracksStoreBase.welcomeGuideLearningTrack');

  @override
  LearningTracksModel? get welcomeGuideLearningTrack {
    _$welcomeGuideLearningTrackAtom.reportRead();
    return super.welcomeGuideLearningTrack;
  }

  @override
  set welcomeGuideLearningTrack(LearningTracksModel? value) {
    _$welcomeGuideLearningTrackAtom
        .reportWrite(value, super.welcomeGuideLearningTrack, () {
      super.welcomeGuideLearningTrack = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'LearningTracksStoreBase.viewState');

  @override
  TimelineViewState get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(TimelineViewState value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

  final _$lastLearningTracksAtom =
      Atom(name: 'LearningTracksStoreBase.lastLearningTracks');

  @override
  LearningTracksModel? get lastLearningTracks {
    _$lastLearningTracksAtom.reportRead();
    return super.lastLearningTracks;
  }

  @override
  set lastLearningTracks(LearningTracksModel? value) {
    _$lastLearningTracksAtom.reportWrite(value, super.lastLearningTracks, () {
      super.lastLearningTracks = value;
    });
  }

  final _$deleteLearningAtom =
      Atom(name: 'LearningTracksStoreBase.deleteLearning');

  @override
  bool get deleteLearning {
    _$deleteLearningAtom.reportRead();
    return super.deleteLearning;
  }

  @override
  set deleteLearning(bool value) {
    _$deleteLearningAtom.reportWrite(value, super.deleteLearning, () {
      super.deleteLearning = value;
    });
  }

  final _$initAsyncAction = AsyncAction('LearningTracksStoreBase.init');

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  final _$getLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.getLearningTracks');

  @override
  Future<List<LearningTracksModel>> getLearningTracks() {
    return _$getLearningTracksAsyncAction.run(() => super.getLearningTracks());
  }

  final _$getLastLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.getLastLearningTracks');

  @override
  Future<void> getLastLearningTracks() {
    return _$getLastLearningTracksAsyncAction
        .run(() => super.getLastLearningTracks());
  }

  final _$getWelcomeGuideAsyncAction =
      AsyncAction('LearningTracksStoreBase.getWelcomeGuide');

  @override
  Future<LearningTracksModel> getWelcomeGuide() {
    return _$getWelcomeGuideAsyncAction.run(() => super.getWelcomeGuide());
  }

  final _$refreshPageAsyncAction =
      AsyncAction('LearningTracksStoreBase.refreshPage');

  @override
  Future<void> refreshPage() {
    return _$refreshPageAsyncAction.run(() => super.refreshPage());
  }

  final _$loadMoreLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.loadMoreLearningTracks');

  @override
  Future<void> loadMoreLearningTracks() {
    return _$loadMoreLearningTracksAsyncAction
        .run(() => super.loadMoreLearningTracks());
  }

  final _$deleteLearningTrackAsyncAction =
      AsyncAction('LearningTracksStoreBase.deleteLearningTrack');

  @override
  Future<void> deleteLearningTrack(String id) {
    return _$deleteLearningTrackAsyncAction
        .run(() => super.deleteLearningTrack(id));
  }

  @override
  String toString() {
    return '''
allLearningTracks: ${allLearningTracks},
isLoadingMore: ${isLoadingMore},
hasMoreItems: ${hasMoreItems},
welcomeGuideLearningTrack: ${welcomeGuideLearningTrack},
viewState: ${viewState},
lastLearningTracks: ${lastLearningTracks},
deleteLearning: ${deleteLearning}
    ''';
  }
}
