// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CircleFriendsStore on CircleFriendsStoreBase, Store {
  final _$friendsAtom = Atom(name: 'CircleFriendsStoreBase.friends');

  @override
  ObservableList<dynamic> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(ObservableList<dynamic> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'CircleFriendsStoreBase.isLoading');

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

  final _$searchNameAsyncAction =
      AsyncAction('CircleFriendsStoreBase.searchName');

  @override
  Future<void> searchName(String name) {
    return _$searchNameAsyncAction.run(() => super.searchName(name));
  }

  @override
  String toString() {
    return '''
friends: ${friends},
isLoading: ${isLoading}
    ''';
  }
}
