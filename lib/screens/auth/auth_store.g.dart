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

  final _$validCellPhoneAtom = Atom(name: 'AuthStoreBase.validCellPhone');

  @override
  bool get validCellPhone {
    _$validCellPhoneAtom.reportRead();
    return super.validCellPhone;
  }

  @override
  set validCellPhone(bool value) {
    _$validCellPhoneAtom.reportWrite(value, super.validCellPhone, () {
      super.validCellPhone = value;
    });
  }

  final _$countryCodeAtom = Atom(name: 'AuthStoreBase.countryCode');

  @override
  String? get countryCode {
    _$countryCodeAtom.reportRead();
    return super.countryCode;
  }

  @override
  set countryCode(String? value) {
    _$countryCodeAtom.reportWrite(value, super.countryCode, () {
      super.countryCode = value;
    });
  }

  final _$birthdateValidationErrorMessageAtom =
      Atom(name: 'AuthStoreBase.birthdateValidationErrorMessage');

  @override
  String? get birthdateValidationErrorMessage {
    _$birthdateValidationErrorMessageAtom.reportRead();
    return super.birthdateValidationErrorMessage;
  }

  @override
  set birthdateValidationErrorMessage(String? value) {
    _$birthdateValidationErrorMessageAtom
        .reportWrite(value, super.birthdateValidationErrorMessage, () {
      super.birthdateValidationErrorMessage = value;
    });
  }

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

  final _$checkUserIsLoggedAsyncAction =
      AsyncAction('AuthStoreBase.checkUserIsLogged');

  @override
  Future<User?> checkUserIsLogged() {
    return _$checkUserIsLoggedAsyncAction.run(() => super.checkUserIsLogged());
  }

  final _$getPhoneNumberAsyncAction =
      AsyncAction('AuthStoreBase.getPhoneNumber');

  @override
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) {
    return _$getPhoneNumberAsyncAction
        .run(() => super.getPhoneNumber(phoneNumber, codeCountry));
  }

  final _$updateUserAsyncAction = AsyncAction('AuthStoreBase.updateUser');

  @override
  Future<void> updateUser() {
    return _$updateUserAsyncAction.run(() => super.updateUser());
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
  bool birthdateIsValid() {
    final _$actionInfo = _$AuthStoreBaseActionController.startAction(
        name: 'AuthStoreBase.birthdateIsValid');
    try {
      return super.birthdateIsValid();
    } finally {
      _$AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
validCellPhone: ${validCellPhone},
countryCode: ${countryCode},
birthdateValidationErrorMessage: ${birthdateValidationErrorMessage},
currentUser: ${currentUser}
    ''';
  }
}
