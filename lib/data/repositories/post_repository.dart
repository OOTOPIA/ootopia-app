import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/models/post/post_created_model.dart';
import 'package:ootopia_app/data/models/timeline/like_post_result_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';
import 'package:path/path.dart';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class PostRepository {
  Future<List<TimelinePost>> getPosts([int limit, int offset, String userId]);
  Future<LikePostResult> likePost(String id);
  Future<void> createPost(PostCreate post, FlutterUploader uploader);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class PostRepositoryImpl with SecureStoreMixin implements PostRepository {
  Future<Map<String, String>> getHeaders() async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }
    String token = await getAuthToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    };
  }

  Future<List<TimelinePost>> getPosts(
      [int limit, int offset, String userId]) async {
    try {
      Map<String, String> queryParams = {};

      if (limit != null && offset != null) {
        queryParams['limit'] = limit.toString();
        queryParams['offset'] = offset.toString();
      }

      if (userId != null) {
        queryParams['userId'] = userId;
      }

      String queryString = Uri(queryParameters: queryParams).query;

      final response = await http.get(
        DotEnv.env['API_URL'] + "posts?" + queryString,
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("POSTS RESPONSE ${response.body}");
        return (json.decode(response.body) as List)
            .map((i) => TimelinePost.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error) {
      throw Exception('Failed to load posts' + error);
    }
  }

  @override
  Future<LikePostResult> likePost(String id) async {
    try {
      if (id != null) {
        final response = await http.post(
          DotEnv.env['API_URL'] + "posts/$id/like",
          headers: await this.getHeaders(),
        );

        if (response.statusCode == 200) {
          return LikePostResult.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to like a post');
        }
      }
    } catch (error) {
      throw Exception('Failed to like a post ' + error);
    }
    return null;
  }

  @override
  Future<PostCreate> createPost(
      PostCreate post, FlutterUploader uploader) async {
    try {
      await uploader.enqueue(
        url: DotEnv.env['API_URL'] + "posts",
        files: [
          FileItem(
            filename: basename(post.filePath),
            savedDir: dirname(post.filePath),
            fieldname: "file",
          )
        ],
        method: UploadMethod.POST,
        headers: await getHeaders(),
        data: {
          "metadata": jsonEncode(post),
        },
        showNotification: false,
        tag: "upload 1",
      );
      return post;
    } catch (e) {
      print('Error upload: $e');
    }
  }

  @override
  Future<String> deletePost(String postId) async {
    print("chamou o repository");
    try {
      print("dentro do try");
      final request = http.Request(
          "DELETE", Uri.parse(DotEnv.env['API_URL'] + 'posts/$postId'));
      request.headers.addAll(await this.getHeaders());

      final response = await request.send();

      print("depois do send");

      if (response.statusCode == 200) {
        print("deletou?");
        return "ALL_DELETED";
      } else {
        print("deu ruim");
        throw Exception('Failed to delete post');
      }
    } catch (error) {
      throw Exception('Failed to delete post ' + error);
    }
  }
}
