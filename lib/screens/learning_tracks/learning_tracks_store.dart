import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';

part 'learning_tracks_store.g.dart';

class LearningTracksStore = LearningTracksStoreBase with _$LearningTracksStore;

abstract class LearningTracksStoreBase with Store {
  LearningTracksRepositoryImpl _learningTracksRepositoryImpl =
      LearningTracksRepositoryImpl();

  @observable
  List<LearningTracksModel> allLearningTracks = [];

  @observable
  bool isLoading = false;

  @observable
  LearningTracksModel? getLastLearningTracks;
  @action
  Future<void> listLearningTracks({
    int? limit,
    int? offset,
    required String locale,
  }) async {
    isLoading = true;
    String lang = "en";
    if (locale.startsWith('pt')) {
      lang = 'pt-BR';
    }

    var response = await _learningTracksRepositoryImpl.listLearningTracks(
        limit: limit, offset: offset, locale: lang);
    allLearningTracks.addAll(response);
    isLoading = false;
  }

  @action
  Future<void> lastLearningTracks({required String locale}) async {
    String lang = "en";
    if (locale.startsWith('pt')) {
      lang = 'pt-BR';
    }
    var response =
        await _learningTracksRepositoryImpl.lastLearningTracks(locale: lang);
    getLastLearningTracks = response;
  }

  @action
  Future<LearningTracksModel> getWelcomeGuide() async {
    String lang = "en";
    if (Platform.localeName.startsWith('pt')) {
      lang = 'pt-BR';
    }
    return await _learningTracksRepositoryImpl.getWelcomeGuide(lang);
  }
}
