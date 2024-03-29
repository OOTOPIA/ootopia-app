import 'package:dio/dio.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class ILearningTracks {
  Future<List<LearningTracksModel>> listLearningTracks(
      {int? limit, int? offset, required String locale});
  Future<LearningTracksModel?> lastLearningTracks({required String locale});
  Future<LearningTracksModel> getLearningTrackById(String id);
}

class LearningTracksRepositoryImpl
    with SecureStoreMixin
    implements ILearningTracks {
  @override
  Future<LearningTracksModel?> lastLearningTracks(
      {required String locale}) async {
    try {
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
      var response =
          await ApiClient.api().get("learning-tracks", queryParameters: {
        'limit': limit,
        'offset': offset,
        'locale': locale,
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

  updateStatusVideoLearningTrack(String learningTrackId, int chapterId) async {
    try {
      await ApiClient.api()
          .post("learning-tracks/$learningTrackId/chapter/$chapterId");

      return 'sucess';
    } catch (e) {
      return throw Exception('failed to get learning track $e');
    }
  }

  Future<LearningTracksModel> getLearningTrackById(
      String learningTrackId) async {
    try {
      var response =
          await ApiClient.api().get("learning-tracks/$learningTrackId");

      if (response.statusCode == 200) {
        return LearningTracksModel.fromJson(response.data);
      }

      return throw Exception('Something went wrong');
    } catch (e) {
      return throw Exception('failed to get learning track $e');
    }
  }

  Future<LearningTracksModel> getWelcomeGuide(String locale) async {
    try {
      var response =
          await ApiClient.api().get("learning-tracks/welcome-guide/$locale");
      print(response);
      if (response.statusCode == 200) {
        return LearningTracksModel.fromJson(response.data);
      }

      return throw Exception('Something went wrong');
    } catch (e) {
      return throw Exception('failed to get welcome guide $e');
    }
  }

  Future<bool> deleteLearningTrack(String id) async {
    try {
      var response = await ApiClient.api().delete("learning-tracks/$id");
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioError) {
        print('${e.error} ${e.response} ${e.message}');
      }
      throw Exception('Failed to delete learning tracks, please try again');
    }
  }
}
