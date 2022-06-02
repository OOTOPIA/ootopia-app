// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_posts_stores.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StoreCreatePosts on StoreCreatePostsBase, Store {
  Computed<RichTextController>? _$descriptionInputControllerComputed;

  @override
  RichTextController get descriptionInputController =>
      (_$descriptionInputControllerComputed ??= Computed<RichTextController>(
              () => super.descriptionInputController,
              name: 'StoreCreatePostsBase.descriptionInputController'))
          .value;

  final _$listTaggedUsersAtom =
      Atom(name: 'StoreCreatePostsBase.listTaggedUsers');

  @override
  List<UsersEntity>? get listTaggedUsers {
    _$listTaggedUsersAtom.reportRead();
    return super.listTaggedUsers;
  }

  @override
  set listTaggedUsers(List<UsersEntity>? value) {
    _$listTaggedUsersAtom.reportWrite(value, super.listTaggedUsers, () {
      super.listTaggedUsers = value;
    });
  }

  final _$usersAtom = Atom(name: 'StoreCreatePostsBase.users');

  @override
  List<UsersEntity> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<UsersEntity> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$fullNameAtom = Atom(name: 'StoreCreatePostsBase.fullName');

  @override
  String get fullName {
    _$fullNameAtom.reportRead();
    return super.fullName;
  }

  @override
  set fullName(String value) {
    _$fullNameAtom.reportWrite(value, super.fullName, () {
      super.fullName = value;
    });
  }

  final _$excludedIdsAtom = Atom(name: 'StoreCreatePostsBase.excludedIds');

  @override
  String? get excludedIds {
    _$excludedIdsAtom.reportRead();
    return super.excludedIds;
  }

  @override
  set excludedIds(String? value) {
    _$excludedIdsAtom.reportWrite(value, super.excludedIds, () {
      super.excludedIds = value;
    });
  }

  final _$geolocationErrorMessageAtom =
      Atom(name: 'StoreCreatePostsBase.geolocationErrorMessage');

  @override
  String get geolocationErrorMessage {
    _$geolocationErrorMessageAtom.reportRead();
    return super.geolocationErrorMessage;
  }

  @override
  set geolocationErrorMessage(String value) {
    _$geolocationErrorMessageAtom
        .reportWrite(value, super.geolocationErrorMessage, () {
      super.geolocationErrorMessage = value;
    });
  }

  final _$geolocationMessageAtom =
      Atom(name: 'StoreCreatePostsBase.geolocationMessage');

  @override
  String get geolocationMessage {
    _$geolocationMessageAtom.reportRead();
    return super.geolocationMessage;
  }

  @override
  set geolocationMessage(String value) {
    _$geolocationMessageAtom.reportWrite(value, super.geolocationMessage, () {
      super.geolocationMessage = value;
    });
  }

  final _$lastPageAtom = Atom(name: 'StoreCreatePostsBase.lastPage');

  @override
  bool get lastPage {
    _$lastPageAtom.reportRead();
    return super.lastPage;
  }

  @override
  set lastPage(bool value) {
    _$lastPageAtom.reportWrite(value, super.lastPage, () {
      super.lastPage = value;
    });
  }

  final _$openSelectedUserAtom =
      Atom(name: 'StoreCreatePostsBase.openSelectedUser');

  @override
  bool get openSelectedUser {
    _$openSelectedUserAtom.reportRead();
    return super.openSelectedUser;
  }

  @override
  set openSelectedUser(bool value) {
    _$openSelectedUserAtom.reportWrite(value, super.openSelectedUser, () {
      super.openSelectedUser = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'StoreCreatePostsBase.viewState');

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

  final _$pageAtom = Atom(name: 'StoreCreatePostsBase.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$postEntityAtom = Atom(name: 'StoreCreatePostsBase.postEntity');

  @override
  CreatePostEntity get postEntity {
    _$postEntityAtom.reportRead();
    return super.postEntity;
  }

  @override
  set postEntity(CreatePostEntity value) {
    _$postEntityAtom.reportWrite(value, super.postEntity, () {
      super.postEntity = value;
    });
  }

  final _$searchUserAsyncAction =
      AsyncAction('StoreCreatePostsBase.searchUser');

  @override
  Future<void> searchUser() {
    return _$searchUserAsyncAction.run(() => super.searchUser());
  }

  final _$getMoreAsyncAction = AsyncAction('StoreCreatePostsBase.getMore');

  @override
  Future<void> getMore() {
    return _$getMoreAsyncAction.run(() => super.getMore());
  }

  final _$StoreCreatePostsBaseActionController =
      ActionController(name: 'StoreCreatePostsBase');

  @override
  void taggedUserInText() {
    final _$actionInfo = _$StoreCreatePostsBaseActionController.startAction(
        name: 'StoreCreatePostsBase.taggedUserInText');
    try {
      return super.taggedUserInText();
    } finally {
      _$StoreCreatePostsBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listTaggedUsers: ${listTaggedUsers},
users: ${users},
fullName: ${fullName},
excludedIds: ${excludedIds},
geolocationErrorMessage: ${geolocationErrorMessage},
geolocationMessage: ${geolocationMessage},
lastPage: ${lastPage},
openSelectedUser: ${openSelectedUser},
viewState: ${viewState},
page: ${page},
postEntity: ${postEntity},
descriptionInputController: ${descriptionInputController}
    ''';
  }
}
