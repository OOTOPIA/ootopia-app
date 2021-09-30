import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';

part 'learning_tracks_store.g.dart';

class LearningTracksStore = LearningTracksStoreBase with _$LearningTracksStore;

abstract class LearningTracksStoreBase with Store {
  LearningTracksRepositoryImpl _learningTracksRepositoryImpl =
      LearningTracksRepositoryImpl();

  @observable
  var allLearningTracks = <LearningTracksModel>[];

  @observable
  LearningTracksModel? getLastLearningTracks;
  @action
  Future<void> listLearningTracks([int? limit, int? offset]) async {
    var response = await _learningTracksRepositoryImpl.listLearningTracks(
        limit: limit, offset: offset);
    allLearningTracks.addAll(response);
  }

  @action
  Future<void> lastLearningTracks() async {
    var response = await _learningTracksRepositoryImpl.lastLearningTracks();
    getLastLearningTracks = response;
  }
}
