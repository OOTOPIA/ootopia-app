import 'dart:io';
import 'package:mobx/mobx.dart';

part 'language_select_controller.g.dart';

class LanguageSelectController = LanguageSelectControllerBase
    with _$LanguageSelectController;

abstract class LanguageSelectControllerBase with Store {
  LanguageSelectControllerBase() {
    final String defaultLocale = Platform.localeName;
    String lang = defaultLocale.split('_').first;
    if (lang == 'en' || lang == 'fr' || lang == 'pt') {
      addItem(lang == 'pt' ? '$lang-BR' : lang);
    }
  }

  @observable
  List<String> languages = [];

  @action
  void addItem(dynamic item) => languages.add(item);

  @action
  void removeItem(dynamic item) => languages.remove(item);

  @action
  bool hasLanguage(String language) => languages.contains(language);
}
