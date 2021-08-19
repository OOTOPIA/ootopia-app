import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/models/post/post_created_model.dart';
import 'package:ootopia_app/data/models/timeline/like_post_result_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'dart:convert';
import 'package:path/path.dart';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class PostRepository {
  Future<List<TimelinePost>> getPosts(
      [int? limit, int? offset, String? userId]);
  Future<LikePostResult> likePost(String id);
  Future<void> createPost(FlutterUploader uploader, PostCreate post);
  Future recordWatchedPosts(List<WatchVideoModel> watchedPosts);
  Future recordTimelineWatched(int timeInMilliseconds);
  Future<TimelinePost> getPostById(String id);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class PostRepositoryImpl with SecureStoreMixin implements PostRepository {
  Future<Map<String, String>> getHeaders([String? contentType]) async {
    bool loggedIn = await getUserIsLoggedIn();
    if (!loggedIn) {
      return API_HEADERS;
    }

    String? token = await getAuthToken();
    if (token == null) return API_HEADERS;

    Map<String, String> headers = {'Authorization': 'Bearer ' + token};

    if (contentType == null) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }

    return headers;
  }

  Future<List<TimelinePost>> getPosts(
      [int? limit, int? offset, String? userId]) async {
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
        Uri.parse(dotenv.env['API_URL']! + "posts?" + queryString),
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
      throw Exception('Failed to load posts $error');
    }
  }

  @override
  Future<LikePostResult> likePost(String id) async {
    try {
      final response = await http.post(
        Uri.parse(dotenv.env['API_URL']! + "posts/$id/like"),
        headers: await this.getHeaders(),
      );

      if (response.statusCode == 200) {
        return LikePostResult.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to like a post');
      }
    } catch (error) {
      throw Exception('Failed to like a post $error');
    }
  }

  @override
  Future<String> createPost(FlutterUploader uploader, PostCreate post) async {
    return await uploader.enqueue(
      MultipartFormDataUpload(
        url: dotenv.env['API_URL']! + "posts",
        files: [
          FileItem(
            path: post.filePath!,
            field: "file",
          )
        ],
        method: UploadMethod.POST,
        headers: await getHeaders("multipart/form-data"),
        data: {
          "metadata": jsonEncode(post),
        },
        tag: "upload 1",
      ),
    );
  }

  @override
  Future<String> deletePost(String postId) async {
    try {
      final request = http.Request(
          "DELETE", Uri.parse(dotenv.env['API_URL']! + 'posts/$postId'));
      request.headers.addAll(await this.getHeaders());

      final response = await request.send();

      if (response.statusCode == 200) {
        return "ALL_DELETED";
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (error) {
      throw Exception('Failed to delete post $error');
    }
  }

  @override
  Future recordWatchedPosts(List<WatchVideoModel> watchedPosts) async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return;
      }

      String allObjsJsonString = "";

      for (var i = 0; i < watchedPosts.length; i++) {
        WatchVideoModel watchedPost = watchedPosts[i];
        allObjsJsonString += jsonEncode(watchedPost.toMap()) +
            (i == watchedPosts.length - 1 ? "" : ",");
      }

      await ApiClient.api().post(
        "posts/watched",
        data: {
          "data": "[" + allObjsJsonString + "]",
        },
      );
    } catch (e) {
      print('Error send watched post: $e');
    }
  }

  @override
  Future recordTimelineWatched(int timeInMilliseconds) async {
    try {
      bool loggedIn = await getUserIsLoggedIn();
      if (!loggedIn) {
        return;
      }

      await ApiClient.api().post(
        "posts/timeline-watched",
        data: {
          "timeInMilliseconds": timeInMilliseconds,
        },
      );
    } catch (e) {
      print('Error send watched post: $e');
    }
  }

  @override
  Future<TimelinePost> getPostById(String id) async {
    try {
      var response = await ApiClient.api().get("posts/$id");
      return TimelinePost.fromJson(response.data);
    } catch (error) {
      throw Exception('Failed to load post by id $error');
    }
  }
}
