// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_select_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LanguageSelectController on LanguageSelectControllerBase, Store {
  final _$languagesAtom = Atom(name: 'LanguageSelectControllerBase.languages');

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

  final _$LanguageSelectControllerBaseActionController =
      ActionController(name: 'LanguageSelectControllerBase');

  @override
  void addItem(dynamic item) {
    final _$actionInfo = _$LanguageSelectControllerBaseActionController
        .startAction(name: 'LanguageSelectControllerBase.addItem');
    try {
      return super.addItem(item);
    } finally {
      _$LanguageSelectControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItem(dynamic item) {
    final _$actionInfo = _$LanguageSelectControllerBaseActionController
        .startAction(name: 'LanguageSelectControllerBase.removeItem');
    try {
      return super.removeItem(item);
    } finally {
      _$LanguageSelectControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool hasLanguage(String language) {
    final _$actionInfo = _$LanguageSelectControllerBaseActionController
        .startAction(name: 'LanguageSelectControllerBase.hasLanguage');
    try {
      return super.hasLanguage(language);
    } finally {
      _$LanguageSelectControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
languages: ${languages}
    ''';
  }
}
