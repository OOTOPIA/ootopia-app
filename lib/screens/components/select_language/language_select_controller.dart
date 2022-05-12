import 'dart:io';
import 'package:mobx/mobx.dart';

part 'language_select_controller.g.dart';

class LanguageSelectController = LanguageSelectControllerBase
    with _$LanguageSelectController;

abstract class LanguageSelectControllerBase with Store {
  late String defaultLang;

  LanguageSelectControllerBase() {
    final String defaultLocale = Platform.localeName;
    defaultLang = defaultLocale.split('_').first;
    if (defaultLang == 'pt') {
      defaultLang = '$defaultLang-BR';
    }
    if (defaultLang == 'en' || defaultLang == 'fr' || defaultLang == 'pt-BR') {
      addItem(defaultLang);
    }
  }

  @observable
  List<String> languages = [];

  @action
  void addItem(dynamic item) => languages.add(item);

  @action
  void removeItem(dynamic item) {
    if (item != defaultLang) {
      languages.remove(item);
    }
  }

  @action
  bool hasLanguage(String language) => languages.contains(language);
}
