// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_preview_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostPreviewScreenStore on _PostPreviewScreenStoreBase, Store {
  final _$uploadIsLoadingAtom =
      Atom(name: '_PostPreviewScreenStoreBase.uploadIsLoading');

  @override
  bool get uploadIsLoading {
    _$uploadIsLoadingAtom.reportRead();
    return super.uploadIsLoading;
  }

  @override
  set uploadIsLoading(bool value) {
    _$uploadIsLoadingAtom.reportWrite(value, super.uploadIsLoading, () {
      super.uploadIsLoading = value;
    });
  }

  final _$tagsIsLoadingAtom =
      Atom(name: '_PostPreviewScreenStoreBase.tagsIsLoading');

  @override
  bool get tagsIsLoading {
    _$tagsIsLoadingAtom.reportRead();
    return super.tagsIsLoading;
  }

  @override
  set tagsIsLoading(bool value) {
    _$tagsIsLoadingAtom.reportWrite(value, super.tagsIsLoading, () {
      super.tagsIsLoading = value;
    });
  }

  final _$errorOnGetTagsAtom =
      Atom(name: '_PostPreviewScreenStoreBase.errorOnGetTags');

  @override
  bool get errorOnGetTags {
    _$errorOnGetTagsAtom.reportRead();
    return super.errorOnGetTags;
  }

  @override
  set errorOnGetTags(bool value) {
    _$errorOnGetTagsAtom.reportWrite(value, super.errorOnGetTags, () {
      super.errorOnGetTags = value;
    });
  }

  final _$errorOnUploadAtom =
      Atom(name: '_PostPreviewScreenStoreBase.errorOnUpload');

  @override
  bool get errorOnUpload {
    _$errorOnUploadAtom.reportRead();
    return super.errorOnUpload;
  }

  @override
  set errorOnUpload(bool value) {
    _$errorOnUploadAtom.reportWrite(value, super.errorOnUpload, () {
      super.errorOnUpload = value;
    });
  }

  final _$successOnUploadAtom =
      Atom(name: '_PostPreviewScreenStoreBase.successOnUpload');

  @override
  bool get successOnUpload {
    _$successOnUploadAtom.reportRead();
    return super.successOnUpload;
  }

  @override
  set successOnUpload(bool value) {
    _$successOnUploadAtom.reportWrite(value, super.successOnUpload, () {
      super.successOnUpload = value;
    });
  }

  final _$oozToRewardAtom =
      Atom(name: '_PostPreviewScreenStoreBase.oozToReward');

  @override
  double get oozToReward {
    _$oozToRewardAtom.reportRead();
    return super.oozToReward;
  }

  @override
  set oozToReward(double value) {
    _$oozToRewardAtom.reportWrite(value, super.oozToReward, () {
      super.oozToReward = value;
    });
  }

  final _$createPostAsyncAction =
      AsyncAction('_PostPreviewScreenStoreBase.createPost');

  @override
  Future<dynamic> createPost(PostCreate post) {
    return _$createPostAsyncAction.run(() => super.createPost(post));
  }

  @override
  String toString() {
    return '''
uploadIsLoading: ${uploadIsLoading},
tagsIsLoading: ${tagsIsLoading},
errorOnGetTags: ${errorOnGetTags},
errorOnUpload: ${errorOnUpload},
successOnUpload: ${successOnUpload},
oozToReward: ${oozToReward}
    ''';
  }
}
