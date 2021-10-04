import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class ILearningTracks {
  Future<List<LearningTracksModel>> listLearningTracks(
      {int? limit, int? offset, required String locale});
  Future<LearningTracksModel> lastLearningTracks({required String locale});
}

class LearningTracksRepositoryImpl
    with SecureStoreMixin
    implements ILearningTracks {
  @override
  Future<LearningTracksModel> lastLearningTracks(
      {required String locale}) async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return Future.error('user not logged');
      }
      var response =
          await ApiClient.api().get("learning-tracks/last", queryParameters: {
        'locale': locale,
      });
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
      {int? limit, int? offset, required String locale}) async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return Future.error('user not logged');
      }

      var response =
          await ApiClient.api().get("learning-tracks", queryParameters: {
        'limit': limit,
        'offset': offset,
        'locale': locale,
      });
      print(response);
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
