// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_tracks_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LearningTracksStore on LearningTracksStoreBase, Store {
  final _$listOfLearningTracksAtom =
      Atom(name: 'LearningTracksStoreBase.listOfLearningTracks');

  @override
  List<dynamic> get listOfLearningTracks {
    _$listOfLearningTracksAtom.reportRead();
    return super.listOfLearningTracks;
  }

  @override
  set listOfLearningTracks(List<dynamic> value) {
    _$listOfLearningTracksAtom.reportWrite(value, super.listOfLearningTracks,
        () {
      super.listOfLearningTracks = value;
    });
  }

  final _$isloadingAtom = Atom(name: 'LearningTracksStoreBase.isloading');

  @override
  bool get isloading {
    _$isloadingAtom.reportRead();
    return super.isloading;
  }

  @override
  set isloading(bool value) {
    _$isloadingAtom.reportWrite(value, super.isloading, () {
      super.isloading = value;
    });
  }

  final _$getLastLearningTracksAtom =
      Atom(name: 'LearningTracksStoreBase.getLastLearningTracks');

  @override
  dynamic get getLastLearningTracks {
    _$getLastLearningTracksAtom.reportRead();
    return super.getLastLearningTracks;
  }

  @override
  set getLastLearningTracks(dynamic value) {
    _$getLastLearningTracksAtom.reportWrite(value, super.getLastLearningTracks,
        () {
      super.getLastLearningTracks = value;
    });
  }

  @override
  String toString() {
    return '''
listOfLearningTracks: ${listOfLearningTracks},
isloading: ${isloading},
getLastLearningTracks: ${getLastLearningTracks}
    ''';
  }
}
