import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class ILearningTracks {
  Future<List<LearningTracksModel>> listLearningTracks(
      {int? limit, int? offset});
  Future<LearningTracksModel> lastLearningTracks();
}

class LearningTracksRepositoryImpl
    with SecureStoreMixin
    implements ILearningTracks {
  @override
  Future<LearningTracksModel> lastLearningTracks() async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return Future.error('user not logged');
      }
      var response = await ApiClient.api().get("learning-tracks/last");
      if (response.statusCode == 200) {
        return LearningTracksModel.fromJson(response.data);
      }
      return throw Exception('Something went wrong');
    } catch (e) {
      return throw Exception('failed to get learning track $e');
    }
  }

  @override
  Future<List<LearningTracksModel>> listLearningTracks(
      {int? limit, int? offset}) async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return Future.error('user not logged');
      }

      var response =
          await ApiClient.api().get("learning-tracks", queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((i) => LearningTracksModel.fromJson(i))
            .toList();
      }
      return throw Exception('Something went wrong');
    } catch (e) {
      return throw Exception('failed to get learning track $e');
    }
  }
}
