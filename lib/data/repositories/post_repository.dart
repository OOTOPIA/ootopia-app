import 'package:ootopia_app/data/models/timeline/like_post_result_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';

import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class PostRepository {
  Future<List<TimelinePost>> getPosts();
  Future<LikePostResult> likePost(String id);
  //Future<TimelinePost> getPost(int id);
  //Future<TimelinePost> updatePost(post);
  //Future<TimelinePost> deletePost(int id);
  //Future<TimelinePost> createPost(post);
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

  Future<List<TimelinePost>> getPosts() async {
    try {
      final response = await http.get(
        DotEnv.env['API_URL'] + "posts",
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
          print("RESPONSE BODY ${response.body}");
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

  // @override
  // Future<Post> getPost(int id) async {
  //   try {
  //     if (id != null) {
  //       final response = await http.get('$API_URL_BASE/posts/$id');
  //       if (response.statusCode == 200) {
  //         return Post.fromJson(json.decode(response.body));
  //       } else {
  //         throw Exception('Failed to load post');
  //       }
  //     }
  //   } catch (error) {
  //     throw Exception('Failed to load post ' + error);
  //   }
  //   return null;
  // }

  // @override
  // Future<Post> createPost(post) async {
  //   try {
  //     if (post != null) {
  //       final response = await http.post(
  //         '$API_URL_BASE/posts',
  //         headers: API_HEADERS,
  //         body: jsonEncode(<String, String>{
  //           'title': post.title,
  //         }),
  //       );

  //       if (response.statusCode == 201) {
  //         return Post.fromJson(json.decode(response.body));
  //       } else {
  //         throw Exception('Failed to create post');
  //       }
  //     }
  //   } catch (error) {
  //     throw Exception('Failed to create post ' + error);
  //   }
  //   return null;
  // }

  // @override
  // Future<Post> deletePost(int id) async {
  //   try {
  //     if (id != null) {
  //       final response = await http.delete(
  //         '$API_URL_BASE/posts/$id',
  //         headers: API_HEADERS,
  //       );
  //       if (response.statusCode == 200) {
  //         return Post.fromJson(json.decode(response.body));
  //       } else {
  //         throw Exception('Failed to load post');
  //       }
  //     }
  //   } catch (error) {
  //     throw Exception('Failed delete post ' + error);
  //   }
  //   return null;
  // }

  // @override
  // Future<Post> updatePost(post) async {
  //   try {
  //     if (post != null) {
  //       final response = await http.put(
  //         '$API_URL_BASE/posts/${post.id}',
  //         headers: API_HEADERS,
  //         body: jsonEncode(<String, String>{
  //           'title': post.title,
  //         }),
  //       );
  //       if (response.statusCode == 200) {
  //         return Post.fromJson(json.decode(response.body));
  //       } else {
  //         throw Exception('Failed to load post');
  //       }
  //     }
  //   } catch (error) {
  //     throw Exception('Failed update post ' + error);
  //   }
  //   return null;
  // }
}

/*abstract class TimelinePostRepository {
  Future<List<TimelinePost>> getPosts();
}

class TimelinePostRepositoryImpl implements TimelinePostRepository {
  TimelinePostRepositoryImpl();

  @override
  Future<List<TimelinePost>> getPosts() async {
    var response = await http.get(DotEnv.env['API_URL'] + "posts");
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((m) => new TimelinePost.fromJson(m)).toList();
    } else {
      throw Exception();
    }
  }
}*/
