import 'package:ootopia_app/clean_arch/core/constants/endpoints.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/interest_tags/interest_tags_model.dart';

abstract class CreatePostRemoteDatasource {
  Future<bool> createPost({required CreatePostModel createPostModel});
  Future<List<InterestTagsModel>> getTags({String? language});
}

class CreatePostRemoteDatasourceImpl extends CreatePostRemoteDatasource {
  final HttpClient _httpClient;

  CreatePostRemoteDatasourceImpl({required HttpClient httpClient})
      : _httpClient = httpClient;

  @override
  Future<bool> createPost({required CreatePostModel createPostModel}) async {
    try {
      var response = await _httpClient.post(
        Endpoints.createPost,
        data: createPostModel.toJson(),
      );
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<InterestTagsModel>> getTags({String? language}) async {
    try {
      Map<String, String> queryParams = {};

      if (language != null) {
        queryParams['language'] = language.replaceFirst('_', '-');
      }
      var response = await _httpClient.get(
        Endpoints.createPost,
        queryParameters: queryParams,
      );
      return (response as List)
          .map((e) => InterestTagsModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
