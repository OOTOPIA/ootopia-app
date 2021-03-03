import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'dart:convert';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';

abstract class CommentRepository {
  Future<List<Comment>> getComments(String postId);
  //Future<LikePostResult> likePost(String id);
  //Future<TimelinePost> getPost(int id);
  //Future<TimelinePost> updatePost(post);
  //Future<TimelinePost> deletePost(int id);
  //Future<TimelinePost> createPost(post);
}

const Map<String, String> API_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8'
};

class CommentRepositoryImpl implements CommentRepository {
  Future<List<Comment>> getComments(postId) async {
    try {
      final response = await http
          .get(DotEnv.env['API_URL'] + "posts/" + postId + "/comments");
      if (response.statusCode == 200) {
        print("RESPONSE BODY: ${response.body}");
        List l = (json.decode(response.body) as List);
        print("LIST SIZE ${l.length}");
        print("test1 " + l[0]['username']);
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
}
