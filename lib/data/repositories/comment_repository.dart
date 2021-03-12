import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'dart:convert';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  Future<Comment> createComment(CommentCreate comment);
  Future<String> deleteComments(String postId, List<String> commentsIds);
  //Future<TimelinePost> getPost(int id);
  //Future<TimelinePost> updatePost(post);
  //Future<TimelinePost> deletePost(int id);
  //Future<TimelinePost> createPost(post);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class CommentRepositoryImpl with SecureStoreMixin implements CommentRepository {
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

  Future<List<Comment>> getComments(postId) async {
    try {
      final response = await http.get(
        DotEnv.env['API_URL'] + "posts/" + postId + "/comments",
        headers: await this.getHeaders(),
      );
      if (response.statusCode == 200) {
        print("RESPONSE BODY: ${response.body}");
        List l = (json.decode(response.body) as List);
        return (json.decode(response.body) as List)
            .map((i) => Comment.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (error) {
      throw Exception('Failed to load posts' + error);
    }
  }

  @override
  Future<Comment> createComment(CommentCreate comment) async {
    try {
      final response = await http.post(
        DotEnv.env['API_URL'] + 'posts/${comment.postId}/comments',
        headers: await this.getHeaders(),
        body: jsonEncode(<String, String>{
          'text': comment.text,
        }),
      );

      if (response.statusCode == 201) {
        return Comment.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      throw Exception('Failed to create post ' + error);
    }
  }

  @override
  Future<String> deleteComments(String postId, List<String> commentsIds) async {
    try {
      final request = http.Request("DELETE",
          Uri.parse(DotEnv.env['API_URL'] + 'posts/$postId/comments'));
      request.headers.addAll(await this.getHeaders());
      request.body = jsonEncode(<String, dynamic>{
        'commentsIds': commentsIds,
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        return "ALL_DELETED";
      } else {
        throw Exception('Failed to create post');
      }
    } catch (error) {
      throw Exception('Failed to create post ' + error);
    }
  }
}
