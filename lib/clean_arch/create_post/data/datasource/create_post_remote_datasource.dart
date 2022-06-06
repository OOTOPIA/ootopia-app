import 'package:ootopia_app/clean_arch/core/constants/endpoints.dart';
import 'package:ootopia_app/clean_arch/core/constants/globals.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/interest_tags/interest_tags_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/users/users_model.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';

abstract class CreatePostRemoteDatasource {
  Future<bool> createPost({required CreatePostModel createPostModel});
  Future<List<InterestsTagsEntity>> getTags({
    String? language,
    required String tags,
  });
  Future<List<UsersEntity>> getUsers({
    required int page,
    required String fullname,
    String? excludedIds,
  });
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
  Future<List<InterestTagsModel>> getTags({
    String? language,
    required String tags,
  }) async {
    try {
      Map<String, String> queryParams = {};
      queryParams['tags'] = tags;

      if (language != null) {
        queryParams['language'] = language.replaceFirst('_', '-');
      }
      var response = await _httpClient.get(
        Endpoints.interestingTags,
        queryParameters: queryParams,
      );
      var _list = (response.data as List)
          .map((e) => InterestTagsModel.fromJson(e))
          .toList();
      return _list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UsersModel>> getUsers({
    required int page,
    required String fullname,
    String? excludedIds,
  }) async {
    try {
      var response = await _httpClient.get(
        Endpoints.searchUsers,
        queryParameters: {
          'page': page,
          'limit': Globals.limitList,
          'fullname': fullname,
          'excludedUsers': excludedIds
        },
      );
      return (response.data as List)
          .map((e) => UsersModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
