// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddFriendsStore on AddFriendsStoreBase, Store {
  final _$usersAtom = Atom(name: 'AddFriendsStoreBase.users');

  @override
  ObservableList<dynamic> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<dynamic> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
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

  final _$searchNameAsyncAction = AsyncAction('AddFriendsStoreBase.searchName');

  @override
  Future<void> searchName(String name) {
    return _$searchNameAsyncAction.run(() => super.searchName(name));
  }

  @override
  String toString() {
    return '''
users: ${users},
isLoading: ${isLoading},
searchIsEmpty: ${searchIsEmpty}
    ''';
  }
}
