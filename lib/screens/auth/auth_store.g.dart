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

  final _$isLoadingAtom = Atom(name: 'AuthStoreBase.isLoading');

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

  final _$errorOnGetTagsAtom = Atom(name: 'AuthStoreBase.errorOnGetTags');

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

  final _$emailExistAtom = Atom(name: 'AuthStoreBase.emailExist');

  @override
  bool get emailExist {
    _$emailExistAtom.reportRead();
    return super.emailExist;
  }

  @override
  set emailExist(bool value) {
    _$emailExistAtom.reportWrite(value, super.emailExist, () {
      super.emailExist = value;
    });
  }

  final _$checkEmailExistAsyncAction =
      AsyncAction('AuthStoreBase.checkEmailExist');

  @override
  Future<void> checkEmailExist(String email) {
    return _$checkEmailExistAsyncAction.run(() => super.checkEmailExist(email));
  }

  final _$checkUserIsLoggedAsyncAction =
      AsyncAction('AuthStoreBase.checkUserIsLogged');

  @override
  Future<User?> checkUserIsLogged() {
    return _$checkUserIsLoggedAsyncAction.run(() => super.checkUserIsLogged());
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

  final _$registerUserAsyncAction = AsyncAction('AuthStoreBase.registerUser');

  @override
  Future<bool> registerUser(
      {required String name,
      required String password,
      required String email,
      String? invitationCode,
      required BuildContext context}) {
    return _$registerUserAsyncAction.run(() => super.registerUser(
        name: name,
        password: password,
        email: email,
        invitationCode: invitationCode,
        context: context));
  }

  final _$AuthStoreBaseActionController =
      ActionController(name: 'AuthStoreBase');

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
isLoading: ${isLoading},
errorOnGetTags: ${errorOnGetTags},
emailExist: ${emailExist},
currentUser: ${currentUser}
    ''';
  }
}
