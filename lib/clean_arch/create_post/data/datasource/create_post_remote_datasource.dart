import 'dart:io';

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
    required String language,
    required String tags,
    required int page,
  });
  Future<List<UsersEntity>> getUsers({
    required int page,
    required String fullname,
    String? excludedIds,
  });

  Future<bool> createTag({
    required String name,
    required String language,
  });
  Future<String> sendMedia(String type, File file);
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
    required String language,
    required String tags,
    required int page,
  }) async {
    try {
      var response = await _httpClient.get(
        Endpoints.interestingTags,
        queryParameters: {
          'page': page,
          'limit': Globals.limitList,
          'language': language.replaceFirst('_', '-'),
          'name': tags
        },
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

  @override
  Future<bool> createTag({
    required String name,
    required String language,
  }) async {
    try {
      var response = await _httpClient.post(
        Endpoints.createInterestingTags,
        data: {
          'name': name,
          'language': language,
        },
      );
      return response.statusCode == 201;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendMedia(String type, File file) async {
    String fileName = file.path.split('/').last;

    try {
      final response = await _httpClient.postFile(
        Endpoints.postFile,
        file: file,
        fileName: fileName,
        queryParameters: {'type': type},
      );
      return response.data['mediaId'];
    } catch (e) {
      rethrow;
    }
  }
}
