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
  Future<void> listLearningTracks([int? limit, int? offset]) {
    return _$listLearningTracksAsyncAction
        .run(() => super.listLearningTracks(limit, offset));
  }

  final _$lastLearningTracksAsyncAction =
      AsyncAction('LearningTracksStoreBase.lastLearningTracks');

  @override
  Future<void> lastLearningTracks() {
    return _$lastLearningTracksAsyncAction
        .run(() => super.lastLearningTracks());
  }

  @override
  String toString() {
    return '''
allLearningTracks: ${allLearningTracks},
getLastLearningTracks: ${getLastLearningTracks}
    ''';
  }
}
