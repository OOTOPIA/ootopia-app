// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EditProfileStore on EditProfileStoreBase, Store {
  final _$isloadingAtom = Atom(name: 'EditProfileStoreBase.isloading');

  @override
  bool get isloading {
    _$isloadingAtom.reportRead();
    return super.isloading;
  }

  @override
  set isloading(bool value) {
    _$isloadingAtom.reportWrite(value, super.isloading, () {
      super.isloading = value;
    });
  }

  final _$validCellPhoneAtom =
      Atom(name: 'EditProfileStoreBase.validCellPhone');

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

  final _$countryCodeAtom = Atom(name: 'EditProfileStoreBase.countryCode');

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

  final _$dialCodeAtom = Atom(name: 'EditProfileStoreBase.dialCode');

  @override
  String? get dialCode {
    _$dialCodeAtom.reportRead();
    return super.dialCode;
  }

  @override
  set dialCode(String? value) {
    _$dialCodeAtom.reportWrite(value, super.dialCode, () {
      super.dialCode = value;
    });
  }

  final _$currentUserAtom = Atom(name: 'EditProfileStoreBase.currentUser');

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  final _$linksAtom = Atom(name: 'EditProfileStoreBase.links');

  @override
  List<Link> get links {
    _$linksAtom.reportRead();
    return super.links;
  }

  @override
  set links(List<Link> value) {
    _$linksAtom.reportWrite(value, super.links, () {
      super.links = value;
    });
  }

  final _$languagesAtom = Atom(name: 'EditProfileStoreBase.languages');

  @override
  List<String> get languages {
    _$languagesAtom.reportRead();
    return super.languages;
  }

  @override
  set languages(List<String> value) {
    _$languagesAtom.reportWrite(value, super.languages, () {
      super.languages = value;
    });
  }

  final _$updateUserAsyncAction =
      AsyncAction('EditProfileStoreBase.updateUser');

  @override
  Future<void> updateUser() {
    return _$updateUserAsyncAction.run(() => super.updateUser());
  }

  final _$getUserAsyncAction = AsyncAction('EditProfileStoreBase.getUser');

  @override
  Future<void> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  final _$getPhoneNumberAsyncAction =
      AsyncAction('EditProfileStoreBase.getPhoneNumber');

  @override
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) {
    return _$getPhoneNumberAsyncAction
        .run(() => super.getPhoneNumber(phoneNumber, codeCountry));
  }

  @override
  String toString() {
    return '''
isloading: ${isloading},
validCellPhone: ${validCellPhone},
countryCode: ${countryCode},
dialCode: ${dialCode},
currentUser: ${currentUser},
links: ${links},
languages: ${languages}
    ''';
  }
}
