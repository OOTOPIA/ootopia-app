import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/constants/globals.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/interest_tags/interest_tags_model.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';

import '../../../../fixtures/posts/posts_fixtures.dart';
import 'post_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late HttpClient httpClient;
  late CreatePostRemoteDatasource dataSource;
  late CreatePostModel createPostModel;
  setUp(() {
    httpClient = MockHttpClient();
    dataSource = CreatePostRemoteDatasourceImpl(httpClient: httpClient);
    createPostModel = CreatePostModel(
      mediasIds: ['1', '2'],
      description: 'My first awesome post!',
    );
  });

  test('When try SEND post then return a bool', () async {
    //mocks
    const String url = 'posts/gallery';
    //Mock
    when(httpClient.post(
      url,
      data: createPostModel.toJson(),
    )).thenAnswer(
      (_) async => Response(
        statusCode: 201,
        requestOptions: RequestOptions(path: url),
      ),
    );
    //action
    final response =
        await dataSource.createPost(createPostModel: createPostModel);
    //assert
    expect(response, isA<bool>());
  });

  test('When try send post then return a left Failure', () async {
    const String url = 'posts/gallery';

    when(httpClient.post(
      url,
      data: createPostModel.toJson(),
    )).thenThrow(Exception('error'));
    expect(
        () async =>
            await dataSource.createPost(createPostModel: createPostModel),
        throwsA(isA<Exception>()));
  });

  test('When try get tags then return interesting hashtags', () async {
    const String url = 'interests-tags/search';
    const String tags = 'hello';
    const int page = 1;
    String currenLocalization = Platform.localeName.substring(0, 2);

    when(httpClient.get(url, queryParameters: {
      'page': page,
      'limit': Globals.limitList,
      'language': currenLocalization,
      'name': tags
    })).thenAnswer(
      (_) async => Response(
        data: interestingTagsMap,
        requestOptions: RequestOptions(path: url),
      ),
    );
    var response = await dataSource.getTags(
      tags: tags,
      page: page,
      language: currenLocalization,
    );
    expect(response, isA<List<InterestTagsModel>>());
    expect(response.length, interestingTagsMap.length);
  });

  test('When try get a interesting then return a left Failure', () async {
    const String url = 'interests-tags/search';
    const String tags = 'hello';
    const int page = 1;
    String currenLocalization = Platform.localeName.substring(0, 2);
    when(httpClient.get(url, queryParameters: {
      'page': page,
      'limit': Globals.limitList,
      'language': currenLocalization,
      'name': tags
    })).thenThrow(Exception('error'));
    expect(
        () async => await dataSource.getTags(
              tags: tags,
              page: page,
              language: currenLocalization,
            ),
        throwsA(isA<Exception>()));
  });

  test('When try get users then return a list of users', () async {
    const String url = 'users/search';
    String fullname = 'andy';
    int page = 1;
    String excludedIds = '';
    when(httpClient.get(url, queryParameters: {
      'page': page,
      'limit': Globals.limitList,
      'fullname': fullname,
      'excludedUsers': excludedIds
    })).thenAnswer(
      (_) async => Response(
        data: usersMap,
        requestOptions: RequestOptions(path: url),
      ),
    );
    var response = await dataSource.getUsers(
      fullname: fullname,
      page: page,
      excludedIds: excludedIds,
    );
    expect(response, isA<List<UsersEntity>>());
    expect(response.length, usersMap.length);
  });

  test('When try get a users then return a left Failure', () async {
    const String url = 'users/search';
    String fullname = 'andy';
    int page = 1;
    String excludedIds = '1234';
    when(httpClient.get(url, queryParameters: {
      'page': page,
      'limit': Globals.limitList,
      'fullname': fullname,
      'excludedUsers': excludedIds
    })).thenThrow(Exception('error'));
    expect(
        () async => await dataSource.getUsers(
              fullname: fullname,
              page: page,
              excludedIds: excludedIds,
            ),
        throwsA(isA<Exception>()));
  });
}
