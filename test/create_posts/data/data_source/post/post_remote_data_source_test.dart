import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ootopia_app/clean_arch/core/drivers/dio/http_client.dart';
import 'package:ootopia_app/clean_arch/create_post/data/datasource/create_post_remote_datasource.dart';
import 'package:ootopia_app/clean_arch/create_post/data/models/create_post/create_post_model.dart';

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
    const String url = 'https://api-ootopia.devmagic.com.br/posts';

    when(httpClient.post(
      url,
      data: createPostModel.toJson(),
    )).thenAnswer(
      (_) async => Response(
        statusCode: 201,
        requestOptions: RequestOptions(path: url),
      ),
    );

    final response =
        await dataSource.createPost(createPostModel: createPostModel);
    expect(response, isA<bool>());
  });

  test("When try send post then return a left Failure", () async {
    const String url = 'https://api-ootopia.devmagic.com.br/posts';

    when(httpClient.post(
      url,
      data: createPostModel.toJson(),
    )).thenThrow(Exception('error'));
    expect(
        () async =>
            await dataSource.createPost(createPostModel: createPostModel),
        throwsA(isA<Exception>()));
  });
}
