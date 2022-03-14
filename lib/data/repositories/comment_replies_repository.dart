import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:ootopia_app/data/repositories/api.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class CommentRepliesRepositoryImpl with SecureStoreMixin {
  Future<List<CommentReply>> getCommentsReplies(
      String commentId, int page) async {
    try {
      var response =
          await ApiClient.api().get('post-comment-replies', queryParameters: {
        'page': page,
        'limit': 2,
        'commentId': commentId,
      });

      if (response.statusCode == 200) {
        print(" testre disso aqui óóó ${response.data}");
        return (response.data as List)
            .map((i) => CommentReply.fromJson(i))
            .toList();
      } else {
        throw Exception('Failed to load comment');
      }
    } catch (error) {
      throw Exception('Failed to load comment $error');
    }
  }

  Future<CommentReply> createCommentReply(
      String commentId, String text, List<String>? usersMarket) async {
    try {
      var response = await ApiClient.api().post('post-comment-replies', data: {
        'text': text,
        'taggedUser': usersMarket,
        'commentId': commentId,
      });
      if (response.statusCode == 201) {
        return CommentReply.fromJson(response.data);
      } else {
        throw Exception('Failed to create comment ${response.data}');
      }
    } catch (error) {
      throw Exception('Failed to create comment $error');
    }
  }

  Future<bool> deleteCommentReply(String commentReplyId) async {
    try {
      var response =
          await ApiClient.api().delete('post-comment-replies/$commentReplyId');
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
