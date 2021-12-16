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

  final _$isLoadingAtom = Atom(name: 'LearningTracksStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$getLastLearningTracksAtom =
      Atom(name: 'LearningTracksStoreBase.getLastLearningTracks');

  @override
  LearningTracksModel? get getLastLearningTracks {
    _$getLastLearningTracksAtom.reportRead();
    return super.getLastLearningTracks;
  }

  @override
  set getLastLearningTracks(LearningTracksModel? value) {
    _$getLastLearningTracksAtom.reportWrite(value, super.getLastLearningTracks,
        () {
      super.getLastLearningTracks = value;
    });
  }

  final _$listLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.listLearningTracks');

  @override
  Future<void> listLearningTracks(
      {int? limit, int? offset, bool? showAtTimeline, required String locale}) {
    return _$listLearningTracksAsyncAction.run(() => super.listLearningTracks(
        limit: limit,
        offset: offset,
        showAtTimeline: showAtTimeline,
        locale: locale));
  }

  final _$lastLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.lastLearningTracks');

  @override
  Future<void> lastLearningTracks({required String locale}) {
    return _$lastLearningTracksAsyncAction
        .run(() => super.lastLearningTracks(locale: locale));
  }

  @override
  String toString() {
    return '''
allLearningTracks: ${allLearningTracks},
isLoading: ${isLoading},
getLastLearningTracks: ${getLastLearningTracks}
    ''';
  }
}
