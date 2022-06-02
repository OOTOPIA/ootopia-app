import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/interest_tags/interest_tags_model.dart';

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
      description: "My first awesome post!",
    );
  });

  test("When try SEND post then return a bool", () async {
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

  test("When try send post then return a left Failure", () async {
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

  test("When try get tags then return interesting hashtags", () async {
    const String url = 'interests-tags';

    when(httpClient.get(url, queryParameters: {})).thenAnswer(
      (_) async => Response(
        statusCode: 200,
        data: postsMap,
        requestOptions: RequestOptions(path: url),
      ),
    );
    var response = await dataSource.getTags();
    expect(response, isA<List<InterestTagsModel>>());
    expect(response.length, postsMap.length);
  });
  test("When try get a interesting then return a left Failure", () async {
    const String url = 'interests-tags';

    when(httpClient.get(url, queryParameters: {}))
        .thenThrow(Exception('error'));
    expect(() async => await dataSource.getTags(), throwsA(isA<Exception>()));
  });
}
