// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddFriendsStore on AddFriendsStoreBase, Store {
  final _$usersAtom = Atom(name: 'AddFriendsStoreBase.users');

  @override
  FriendsDataModel get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(FriendsDataModel value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$usersIdAddedAtom = Atom(name: 'AddFriendsStoreBase.usersIdAdded');

  @override
  List<String> get usersIdAdded {
    _$usersIdAddedAtom.reportRead();
    return super.usersIdAdded;
  }

  @override
  set usersIdAdded(List<String> value) {
    _$usersIdAddedAtom.reportWrite(value, super.usersIdAdded, () {
      super.usersIdAdded = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'AddFriendsStoreBase.isLoading');

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

  final _$searchIsEmptyAtom = Atom(name: 'AddFriendsStoreBase.searchIsEmpty');

  @override
  bool get searchIsEmpty {
    _$searchIsEmptyAtom.reportRead();
    return super.searchIsEmpty;
  }

  @override
  set searchIsEmpty(bool value) {
    _$searchIsEmptyAtom.reportWrite(value, super.searchIsEmpty, () {
      super.searchIsEmpty = value;
    });
  }

  final _$hasMoreUsersAtom = Atom(name: 'AddFriendsStoreBase.hasMoreUsers');

  @override
  bool get hasMoreUsers {
    _$hasMoreUsersAtom.reportRead();
    return super.hasMoreUsers;
  }

  @override
  set hasMoreUsers(bool value) {
    _$hasMoreUsersAtom.reportWrite(value, super.hasMoreUsers, () {
      super.hasMoreUsers = value;
    });
  }

  final _$loadingMoreUsersAtom =
      Atom(name: 'AddFriendsStoreBase.loadingMoreUsers');

  @override
  bool get loadingMoreUsers {
    _$loadingMoreUsersAtom.reportRead();
    return super.loadingMoreUsers;
  }

  @override
  set loadingMoreUsers(bool value) {
    _$loadingMoreUsersAtom.reportWrite(value, super.loadingMoreUsers, () {
      super.loadingMoreUsers = value;
    });
  }

  final _$searchNewNameAsyncAction =
      AsyncAction('AddFriendsStoreBase.searchNewName');

  @override
  Future<void> searchNewName(String name) {
    return _$searchNewNameAsyncAction.run(() => super.searchNewName(name));
  }

  final _$getMoreUserSearchAsyncAction =
      AsyncAction('AddFriendsStoreBase.getMoreUserSearch');

  @override
  Future<void> getMoreUserSearch() {
    return _$getMoreUserSearchAsyncAction.run(() => super.getMoreUserSearch());
  }

  final _$addFriendAsyncAction = AsyncAction('AddFriendsStoreBase.addFriend');

  @override
  Future<bool> addFriend(String userId) {
    return _$addFriendAsyncAction.run(() => super.addFriend(userId));
  }

  @override
  String toString() {
    return '''
users: ${users},
usersIdAdded: ${usersIdAdded},
isLoading: ${isLoading},
searchIsEmpty: ${searchIsEmpty},
hasMoreUsers: ${hasMoreUsers},
loadingMoreUsers: ${loadingMoreUsers}
    ''';
  }
}
