import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';

part 'learning_tracks_store.g.dart';

class LearningTracksStore = LearningTracksStoreBase with _$LearningTracksStore;

abstract class LearningTracksStoreBase with Store {
  LearningTracksRepositoryImpl learningTracksRepositoryImpl =
      LearningTracksRepositoryImpl();

  @observable
  var listOfLearningTracks = <LearningTracksModel>[];

  @observable
  var isloading = false;

  @observable
  var getLastLearningTracks = <LearningTracksModel>[];

  Future<void> listLearningTracks([int? limit, int? offset]) async {
    isloading = true;
    var response = await learningTracksRepositoryImpl.listLearningTracks(
        limit: limit, offset: offset);
    listOfLearningTracks.addAll(response);
    isloading = false;
  }

  Future<void> lastLearningTracks() async {
    getLastLearningTracks.clear();
    var response = await learningTracksRepositoryImpl.lasLearningTracks();

    getLastLearningTracks.add(response);
  }
}
