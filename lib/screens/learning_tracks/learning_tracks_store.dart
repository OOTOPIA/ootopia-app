import 'dart:io';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';

part 'learning_tracks_store.g.dart';

class LearningTracksStore = LearningTracksStoreBase with _$LearningTracksStore;

abstract class LearningTracksStoreBase with Store {
  LearningTracksRepositoryImpl repository = LearningTracksRepositoryImpl();

  @observable
  List<LearningTracksModel> allLearningTracks = [];

  @observable
  bool isLoadingMore = false;

  @observable
  bool hasMoreItems = true;

  @observable
  LearningTracksModel? welcomeGuideLearningTrack;

  @observable
  TimelineViewState viewState = TimelineViewState.loading;

  @observable
  LearningTracksModel? lastLearningTracks;

  final int limit = 10;
  int offset = 0;

  @action
  Future<void> init() async {
    allLearningTracks = await getLearningTracks();
    welcomeGuideLearningTrack = await getWelcomeGuide();
    setHasMoreItem(allLearningTracks);
  }

  @action
  Future<List<LearningTracksModel>> getLearningTracks() async {
    String lang = setLocale(Platform.localeName);
    try{
      var response = await repository.listLearningTracks(
          limit: limit, offset: offset, locale: lang);
      viewState = TimelineViewState.ok;
      return response;
    }catch(error){
      viewState = TimelineViewState.error;
      return [];
    }
  }

  @action
  Future<void> getLastLearningTracks() async {
    String lang = setLocale(Platform.localeName);
    try{
      lastLearningTracks = await repository.lastLearningTracks(locale: lang);
    }catch(e){
      viewState = TimelineViewState.error;
    }
  }

  @action
  Future<LearningTracksModel> getWelcomeGuide() async {
    String lang = setLocale(Platform.localeName);
    return await repository.getWelcomeGuide(lang);
  }

  @action
  Future<void> refreshPage() async {
    offset = 0;
    allLearningTracks = await getLearningTracks();
    setHasMoreItem(allLearningTracks);
  }

  @action
  Future<void> loadMoreLearningTracks() async {
    isLoadingMore = true;
    offset++;
    List<LearningTracksModel> aux = await getLearningTracks();
    allLearningTracks.addAll(aux);
    setHasMoreItem(aux);
    isLoadingMore = false;
  }

  bool pageError(){
    return viewState == TimelineViewState.error;
  }

  bool pageLoading(){
    return viewState == TimelineViewState.loading;
  }

  String setLocale(String locale){
    if (locale.startsWith('pt')) {
      return 'pt-BR';
    }
    return "en";
  }

  void setHasMoreItem(List list){
    hasMoreItems = list.length >= limit;
  }

}
