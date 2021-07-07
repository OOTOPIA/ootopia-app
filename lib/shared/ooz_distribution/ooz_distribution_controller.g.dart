// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ooz_distribution_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OOZDistributionController on OOZDistributionControllerBase, Store {
  final _$postIdAtom = Atom(name: 'OOZDistributionControllerBase.postId');

  @override
  String? get postId {
    _$postIdAtom.reportRead();
    return super.postId;
  }

  @override
  set postId(String? value) {
    _$postIdAtom.reportWrite(value, super.postId, () {
      super.postId = value;
    });
  }

  final _$userIdAtom = Atom(name: 'OOZDistributionControllerBase.userId');

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$timeInMillisecondsAtom =
      Atom(name: 'OOZDistributionControllerBase.timeInMilliseconds');

  @override
  int? get timeInMilliseconds {
    _$timeInMillisecondsAtom.reportRead();
    return super.timeInMilliseconds;
  }

  @override
  set timeInMilliseconds(int? value) {
    _$timeInMillisecondsAtom.reportWrite(value, super.timeInMilliseconds, () {
      super.timeInMilliseconds = value;
    });
  }

  final _$durationInMsAtom =
      Atom(name: 'OOZDistributionControllerBase.durationInMs');

  @override
  int? get durationInMs {
    _$durationInMsAtom.reportRead();
    return super.durationInMs;
  }

  @override
  set durationInMs(int? value) {
    _$durationInMsAtom.reportWrite(value, super.durationInMs, () {
      super.durationInMs = value;
    });
  }

  final _$creationTimeInMsAtom =
      Atom(name: 'OOZDistributionControllerBase.creationTimeInMs');

  @override
  int? get creationTimeInMs {
    _$creationTimeInMsAtom.reportRead();
    return super.creationTimeInMs;
  }

  @override
  set creationTimeInMs(int? value) {
    _$creationTimeInMsAtom.reportWrite(value, super.creationTimeInMs, () {
      super.creationTimeInMs = value;
    });
  }

  final _$_createdAtom = Atom(name: 'OOZDistributionControllerBase._created');

  @override
  bool get _created {
    _$_createdAtom.reportRead();
    return super._created;
  }

  @override
  set _created(bool value) {
    _$_createdAtom.reportWrite(value, super._created, () {
      super._created = value;
    });
  }

  final _$updateVideoPositionAsyncAction =
      AsyncAction('OOZDistributionControllerBase.updateVideoPosition');

  @override
  Future updateVideoPosition(String postId, String userId,
      int timeInMilliseconds, int durationInMs, int creationTimeInMs) {
    return _$updateVideoPositionAsyncAction.run(() => super.updateVideoPosition(
        postId, userId, timeInMilliseconds, durationInMs, creationTimeInMs));
  }

  @override
  String toString() {
    return '''
postId: ${postId},
userId: ${userId},
timeInMilliseconds: ${timeInMilliseconds},
durationInMs: ${durationInMs},
creationTimeInMs: ${creationTimeInMs}
    ''';
  }
}
