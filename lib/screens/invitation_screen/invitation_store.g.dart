// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$InvitationStore on InvitationStoreBase, Store {
  final _$listInvitationCodeAtom =
      Atom(name: 'InvitationStoreBase.listInvitationCode');

  @override
  ObservableList<InvitationCodeModel> get listInvitationCode {
    _$listInvitationCodeAtom.reportRead();
    return super.listInvitationCode;
  }

  @override
  set listInvitationCode(ObservableList<InvitationCodeModel> value) {
    _$listInvitationCodeAtom.reportWrite(value, super.listInvitationCode, () {
      super.listInvitationCode = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'InvitationStoreBase.isLoading');

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

  final _$getCodesAsyncAction = AsyncAction('InvitationStoreBase.getCodes');

  @override
  Future<List<InvitationCodeModel>?> getCodes() {
    return _$getCodesAsyncAction.run(() => super.getCodes());
  }

  @override
  String toString() {
    return '''
listInvitationCode: ${listInvitationCode},
isLoading: ${isLoading}
    ''';
  }
}
