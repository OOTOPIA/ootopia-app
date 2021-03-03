import 'dart:async';

import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';

class CommentBloc {
  CommentRepositoryImpl repository = CommentRepositoryImpl();

  final StreamController<CommentCreate> _createCommentController =
      StreamController<CommentCreate>();
  Sink<CommentCreate> get createComment => _createCommentController.sink;

  final StreamController<String> _getCommentsController =
      StreamController<String>();
  Sink<String> get getComments => _getCommentsController.sink;
  Stream<List<Comment>> get onGetComments =>
      _getCommentsController.stream.asyncMap((postId) => _getComments(postId));

  Future<List<Comment>> _getComments(String postId) async {
    try {
      print("CALL GET COMMENTS");
      List<Comment> comments = (await this.repository.getComments(postId));
      print("GET COMMENTS RESPONSE");
      print("FIRST COMMENT " +
          comments[0].username +
          "; TEXT: " +
          comments[0].text);
      return comments;
    } catch (error) {
      print("DEU ERRO ${error.toString()}");

      throw Exception('Failed to load posts' + error);
    }
  }
}
