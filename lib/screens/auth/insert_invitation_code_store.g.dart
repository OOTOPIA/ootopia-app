// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insert_invitation_code_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InsertInvitationCodeStore on InsertInvitationCodeStoreBase, Store {
  final _$visibleInvalidStatusCodeAtom =
      Atom(name: 'InsertInvitationCodeStoreBase.visibleInvalidStatusCode');

  @override
  bool get visibleInvalidStatusCode {
    _$visibleInvalidStatusCodeAtom.reportRead();
    return super.visibleInvalidStatusCode;
  }

  @override
  set visibleInvalidStatusCode(bool value) {
    _$visibleInvalidStatusCodeAtom
        .reportWrite(value, super.visibleInvalidStatusCode, () {
      super.visibleInvalidStatusCode = value;
    });
  }

  final _$verifyCodesAsyncAction =
      AsyncAction('InsertInvitationCodeStoreBase.verifyCodes');

  @override
  Future<String> verifyCodes(String code) {
    return _$verifyCodesAsyncAction.run(() => super.verifyCodes(code));
  }

  @override
  String toString() {
    return '''
visibleInvalidStatusCode: ${visibleInvalidStatusCode}
    ''';
  }
}
