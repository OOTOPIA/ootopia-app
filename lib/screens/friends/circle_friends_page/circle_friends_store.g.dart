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

  final _$hasMoreFriendsAtom =
      Atom(name: 'CircleFriendsStoreBase.hasMoreFriends');

  @override
  bool get hasMoreFriends {
    _$hasMoreFriendsAtom.reportRead();
    return super.hasMoreFriends;
  }

  @override
  set hasMoreFriends(bool value) {
    _$hasMoreFriendsAtom.reportWrite(value, super.hasMoreFriends, () {
      super.hasMoreFriends = value;
    });
  }

  final _$loadingMoreFriendsAtom =
      Atom(name: 'CircleFriendsStoreBase.loadingMoreFriends');

  @override
  bool get loadingMoreFriends {
    _$loadingMoreFriendsAtom.reportRead();
    return super.loadingMoreFriends;
  }

  @override
  set loadingMoreFriends(bool value) {
    _$loadingMoreFriendsAtom.reportWrite(value, super.loadingMoreFriends, () {
      super.loadingMoreFriends = value;
    });
  }

  final _$orderByAtom = Atom(name: 'CircleFriendsStoreBase.orderBy');

  @override
  String? get orderBy {
    _$orderByAtom.reportRead();
    return super.orderBy;
  }

  @override
  set orderBy(String? value) {
    _$orderByAtom.reportWrite(value, super.orderBy, () {
      super.orderBy = value;
    });
  }

  final _$sortingTypeAtom = Atom(name: 'CircleFriendsStoreBase.sortingType');

  @override
  String? get sortingType {
    _$sortingTypeAtom.reportRead();
    return super.sortingType;
  }

  @override
  set sortingType(String? value) {
    _$sortingTypeAtom.reportWrite(value, super.sortingType, () {
      super.sortingType = value;
    });
  }

  final _$getFriendsAsyncAction =
      AsyncAction('CircleFriendsStoreBase.getFriends');

  @override
  Future<void> getFriends(String userId) {
    return _$getFriendsAsyncAction.run(() => super.getFriends(userId));
  }

  final _$getMoreFriendsAsyncAction =
      AsyncAction('CircleFriendsStoreBase.getMoreFriends');

  @override
  Future<void> getMoreFriends(dynamic userId) {
    return _$getMoreFriendsAsyncAction.run(() => super.getMoreFriends(userId));
  }

  final _$CircleFriendsStoreBaseActionController =
      ActionController(name: 'CircleFriendsStoreBase');

  @override
  void init(String userId, bool userLogged) {
    final _$actionInfo = _$CircleFriendsStoreBaseActionController.startAction(
        name: 'CircleFriendsStoreBase.init');
    try {
      return super.init(userId, userLogged);
    } finally {
      _$CircleFriendsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeOrderBy(int index) {
    final _$actionInfo = _$CircleFriendsStoreBaseActionController.startAction(
        name: 'CircleFriendsStoreBase.changeOrderBy');
    try {
      return super.changeOrderBy(index);
    } finally {
      _$CircleFriendsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
friendsDate: ${friendsDate},
isLoading: ${isLoading},
hasMoreFriends: ${hasMoreFriends},
loadingMoreFriends: ${loadingMoreFriends},
orderBy: ${orderBy},
sortingType: ${sortingType}
    ''';
  }
}
