import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class CommentRepositoryImpl with SecureStoreMixin {
  Future<List<Comment>> getComments(postId, page) async {
    try {
      var response = await ApiClient.api()
          .get('posts/$postId/comments', queryParameters: {'page': page});
      if (response.statusCode == 200) {
        return (response.data as List).map((i) => Comment.fromJson(i)).toList();
      } else {
        throw Exception('Failed to load comment');
      }
    } catch (error) {
      throw Exception('Failed to load comment $error');
    }
  }

  Future<Comment> createComment(String postId, String text) async {
    try {
      var response = await ApiClient.api()
          .post('posts/$postId/comments', data: {'text': text});
      if (response.statusCode == 201) {
        return Comment.fromJson(response.data);
      } else {
        throw Exception('Failed to create comment');
      }
    } catch (error) {
      throw Exception('Failed to create comment $error');
    }
  }

  Future<bool> deleteComments(String postId, List<String> commentsIds) async {
    try {
      var response = await ApiClient.api()
          .delete('posts/$postId/comments', data: {'commentsIds': commentsIds});
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (error) {
      throw Exception('Failed to delete comment $error');
    }
  }
}
