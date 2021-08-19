// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on AuthStoreBase, Store {
  Computed<User?>? _$currentUserComputed;

  @override
  User? get currentUser =>
      (_$currentUserComputed ??= Computed<User?>(() => super.currentUser,
              name: 'AuthStoreBase.currentUser'))
          .value;

  final _$_currentUserAtom = Atom(name: 'AuthStoreBase._currentUser');

  @override
  ObservableFuture<User?>? get _currentUser {
    _$_currentUserAtom.reportRead();
    return super._currentUser;
  }

  @override
  set _currentUser(ObservableFuture<User?>? value) {
    _$_currentUserAtom.reportWrite(value, super._currentUser, () {
      super._currentUser = value;
    });
  }

  final _$updateUserRegenerarionGameLearningAlertAsyncAction =
      AsyncAction('AuthStoreBase.updateUserRegenerarionGameLearningAlert');

  @override
  Future updateUserRegenerarionGameLearningAlert(String type) {
    return _$updateUserRegenerarionGameLearningAlertAsyncAction
        .run(() => super.updateUserRegenerarionGameLearningAlert(type));
  }

  final _$logoutAsyncAction = AsyncAction('AuthStoreBase.logout');

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$AuthStoreBaseActionController =
      ActionController(name: 'AuthStoreBase');

  @override
  Future<User?> checkUserIsLogged() {
    final _$actionInfo = _$AuthStoreBaseActionController.startAction(
        name: 'AuthStoreBase.checkUserIsLogged');
    try {
      return super.checkUserIsLogged();
    } finally {
      _$AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserIsLogged() {
    final _$actionInfo = _$AuthStoreBaseActionController.startAction(
        name: 'AuthStoreBase.setUserIsLogged');
    try {
      return super.setUserIsLogged();
    } finally {
      _$AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser}
    ''';
  }
}
