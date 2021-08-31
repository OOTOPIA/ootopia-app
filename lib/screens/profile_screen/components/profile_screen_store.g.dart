// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileScreenStore on _ProfileScreenStoreBase, Store {
  final _$loadingProfileAtom =
      Atom(name: '_ProfileScreenStoreBase.loadingProfile');

  @override
  bool get loadingProfile {
    _$loadingProfileAtom.reportRead();
    return super.loadingProfile;
  }

  @override
  set loadingProfile(bool value) {
    _$loadingProfileAtom.reportWrite(value, super.loadingProfile, () {
      super.loadingProfile = value;
    });
  }

  final _$loadingProfileErrorAtom =
      Atom(name: '_ProfileScreenStoreBase.loadingProfileError');

  @override
  bool get loadingProfileError {
    _$loadingProfileErrorAtom.reportRead();
    return super.loadingProfileError;
  }

  @override
  set loadingProfileError(bool value) {
    _$loadingProfileErrorAtom.reportWrite(value, super.loadingProfileError, () {
      super.loadingProfileError = value;
    });
  }

  final _$loadingPostsAtom = Atom(name: '_ProfileScreenStoreBase.loadingPosts');

  @override
  bool get loadingPosts {
    _$loadingPostsAtom.reportRead();
    return super.loadingPosts;
  }

  @override
  set loadingPosts(bool value) {
    _$loadingPostsAtom.reportWrite(value, super.loadingPosts, () {
      super.loadingPosts = value;
    });
  }

  final _$loadingPostsErrorAtom =
      Atom(name: '_ProfileScreenStoreBase.loadingPostsError');

  @override
  bool get loadingPostsError {
    _$loadingPostsErrorAtom.reportRead();
    return super.loadingPostsError;
  }

  @override
  set loadingPostsError(bool value) {
    _$loadingPostsErrorAtom.reportWrite(value, super.loadingPostsError, () {
      super.loadingPostsError = value;
    });
  }

  final _$profileAtom = Atom(name: '_ProfileScreenStoreBase.profile');

  @override
  Profile? get profile {
    _$profileAtom.reportRead();
    return super.profile;
  }

  @override
  set profile(Profile? value) {
    _$profileAtom.reportWrite(value, super.profile, () {
      super.profile = value;
    });
  }

  final _$postsListAtom = Atom(name: '_ProfileScreenStoreBase.postsList');

  @override
  ObservableList<TimelinePost> get postsList {
    _$postsListAtom.reportRead();
    return super.postsList;
  }

  @override
  set postsList(ObservableList<TimelinePost> value) {
    _$postsListAtom.reportWrite(value, super.postsList, () {
      super.postsList = value;
    });
  }

  final _$getProfileDetailsAsyncAction =
      AsyncAction('_ProfileScreenStoreBase.getProfileDetails');

  @override
  Future<Profile?> getProfileDetails(String userId) {
    return _$getProfileDetailsAsyncAction
        .run(() => super.getProfileDetails(userId));
  }

  final _$getUserPostsAsyncAction =
      AsyncAction('_ProfileScreenStoreBase.getUserPosts');

  @override
  Future<List<TimelinePost>?> getUserPosts(String userId,
      {int? limit, int? offset}) {
    return _$getUserPostsAsyncAction
        .run(() => super.getUserPosts(userId, limit: limit, offset: offset));
  }

  @override
  String toString() {
    return '''
loadingProfile: ${loadingProfile},
loadingProfileError: ${loadingProfileError},
loadingPosts: ${loadingPosts},
loadingPostsError: ${loadingPostsError},
profile: ${profile},
postsList: ${postsList}
    ''';
  }
}
