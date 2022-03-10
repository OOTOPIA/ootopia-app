// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_screen_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileScreenStore on _ProfileScreenStoreBase, Store {
  Computed<int>? _$postsOffsetComputed;

  @override
  int get postsOffset =>
      (_$postsOffsetComputed ??= Computed<int>(() => super.postsOffset,
              name: '_ProfileScreenStoreBase.postsOffset'))
          .value;
  Computed<bool>? _$hasMorePostsComputed;

  @override
  bool get hasMorePosts =>
      (_$hasMorePostsComputed ??= Computed<bool>(() => super.hasMorePosts,
              name: '_ProfileScreenStoreBase.hasMorePosts'))
          .value;
  Computed<bool>? _$loadingPostsComputed;

  @override
  bool get loadingPosts =>
      (_$loadingPostsComputed ??= Computed<bool>(() => super.loadingPosts,
              name: '_ProfileScreenStoreBase.loadingPosts'))
          .value;

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

  final _$_loadingPostsAtom =
      Atom(name: '_ProfileScreenStoreBase._loadingPosts');

  @override
  bool get _loadingPosts {
    _$_loadingPostsAtom.reportRead();
    return super._loadingPosts;
  }

  @override
  set _loadingPosts(bool value) {
    _$_loadingPostsAtom.reportWrite(value, super._loadingPosts, () {
      super._loadingPosts = value;
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

  final _$_postsOffsetAtom = Atom(name: '_ProfileScreenStoreBase._postsOffset');

  @override
  int get _postsOffset {
    _$_postsOffsetAtom.reportRead();
    return super._postsOffset;
  }

  @override
  set _postsOffset(int value) {
    _$_postsOffsetAtom.reportWrite(value, super._postsOffset, () {
      super._postsOffset = value;
    });
  }

  final _$_hasMorePostsAtom =
      Atom(name: '_ProfileScreenStoreBase._hasMorePosts');

  @override
  bool get _hasMorePosts {
    _$_hasMorePostsAtom.reportRead();
    return super._hasMorePosts;
  }

  @override
  set _hasMorePosts(bool value) {
    _$_hasMorePostsAtom.reportWrite(value, super._hasMorePosts, () {
      super._hasMorePosts = value;
    });
  }

  final _$isFriendAtom = Atom(name: '_ProfileScreenStoreBase.isFriend');

  @override
  bool? get isFriend {
    _$isFriendAtom.reportRead();
    return super.isFriend;
  }

  @override
  set isFriend(bool? value) {
    _$isFriendAtom.reportWrite(value, super.isFriend, () {
      super.isFriend = value;
    });
  }

  final _$addFriendAsyncAction =
      AsyncAction('_ProfileScreenStoreBase.addFriend');

  @override
  Future<bool> addFriend() {
    return _$addFriendAsyncAction.run(() => super.addFriend());
  }

  final _$removeFriendAsyncAction =
      AsyncAction('_ProfileScreenStoreBase.removeFriend');

  @override
  Future<bool> removeFriend() {
    return _$removeFriendAsyncAction.run(() => super.removeFriend());
  }

  final _$getIfIsFriendAsyncAction =
      AsyncAction('_ProfileScreenStoreBase.getIfIsFriend');

  @override
  Future<bool> getIfIsFriend(String userId) {
    return _$getIfIsFriendAsyncAction.run(() => super.getIfIsFriend(userId));
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
loadingPostsError: ${loadingPostsError},
profile: ${profile},
postsList: ${postsList},
isFriend: ${isFriend},
postsOffset: ${postsOffset},
hasMorePosts: ${hasMorePosts},
loadingPosts: ${loadingPosts}
    ''';
  }
}
