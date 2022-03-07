// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CircleFriendsStore on CircleFriendsStoreBase, Store {
  final _$friendsDateAtom = Atom(name: 'CircleFriendsStoreBase.friendsDate');

  @override
  FriendsDataModel get friendsDate {
    _$friendsDateAtom.reportRead();
    return super.friendsDate;
  }

  @override
  set friendsDate(FriendsDataModel value) {
    _$friendsDateAtom.reportWrite(value, super.friendsDate, () {
      super.friendsDate = value;
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

  final _$getFriendsAsyncAction =
      AsyncAction('CircleFriendsStoreBase.getFriends');

  @override
  Future<void> getFriends(String userId) {
    return _$getFriendsAsyncAction.run(() => super.getFriends(userId));
  }

  @override
  String toString() {
    return '''
friendsDate: ${friendsDate},
isLoading: ${isLoading}
    ''';
  }
}
