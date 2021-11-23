// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_preview_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostPreviewScreenStore on _PostPreviewScreenStoreBase, Store {
  final _$selectedTagsAtom =
      Atom(name: '_PostPreviewScreenStoreBase.selectedTags');

  @override
  ObservableList<InterestsTagsModel> get selectedTags {
    _$selectedTagsAtom.reportRead();
    return super.selectedTags;
  }

  @override
  set selectedTags(ObservableList<InterestsTagsModel> value) {
    _$selectedTagsAtom.reportWrite(value, super.selectedTags, () {
      super.selectedTags = value;
    });
  }

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

  final _$filterValueAtom =
      Atom(name: '_PostPreviewScreenStoreBase.filterValue');

  @override
  String get filterValue {
    _$filterValueAtom.reportRead();
    return super.filterValue;
  }

  @override
  set filterValue(String value) {
    _$filterValueAtom.reportWrite(value, super.filterValue, () {
      super.filterValue = value;
    });
  }

  final _$isSelectedAtom = Atom(name: '_PostPreviewScreenStoreBase.isSelected');

  @override
  bool get isSelected {
    _$isSelectedAtom.reportRead();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.reportWrite(value, super.isSelected, () {
      super.isSelected = value;
    });
  }

  final _$createPostAsyncAction =
      AsyncAction('_PostPreviewScreenStoreBase.createPost');

  @override
  Future<dynamic> createPost(
      PostCreate post, double oozToRewardForVideo, double oozToRewardForImage) {
    return _$createPostAsyncAction.run(
        () => super.createPost(post, oozToRewardForVideo, oozToRewardForImage));
  }

  final _$_PostPreviewScreenStoreBaseActionController =
      ActionController(name: '_PostPreviewScreenStoreBase');

  @override
  void addItem(dynamic item) {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(dynamic item) {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.removeItem');
    try {
      return super.removeItem(item);
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool hasTagInList(MultiSelectItem<InterestsTagsModel> item) {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.hasTagInList');
    try {
      return super.hasTagInList(item);
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<HashtagWidget> filterTagsPerName(List<HashtagWidget> allTags) {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.filterTagsPerName');
    try {
      return super.filterTagsPerName(allTags);
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onFilterTagChanged(String value) {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.onFilterTagChanged');
    try {
      return super.onFilterTagChanged(value);
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearhashtags() {
    final _$actionInfo = _$_PostPreviewScreenStoreBaseActionController
        .startAction(name: '_PostPreviewScreenStoreBase.clearhashtags');
    try {
      return super.clearhashtags();
    } finally {
      _$_PostPreviewScreenStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTags: ${selectedTags},
uploadIsLoading: ${uploadIsLoading},
tagsIsLoading: ${tagsIsLoading},
errorOnGetTags: ${errorOnGetTags},
errorOnUpload: ${errorOnUpload},
successOnUpload: ${successOnUpload},
oozToReward: ${oozToReward},
filterValue: ${filterValue},
isSelected: ${isSelected}
    ''';
  }
}
