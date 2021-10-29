import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';

part "comment_store.g.dart";

class CommentStore = CommentStoreBase with _$CommentStore;

abstract class CommentStoreBase with Store {
  CommentRepositoryImpl commentRepository = CommentRepositoryImpl();

  @action
  Future<List<Comment>> getComments(String postId, int page) async {
    try {
      return await commentRepository.getComments(postId, page);
    } catch (e) {
      return Future.error(e);
    }
  }

  @action
  Future<void> createComment(String postId, String text) async {
    try {
      commentRepository.createComment(postId, text);
    } catch (e) {
      return Future.error(e);
    }
  }

  @action
  Future<List<Comment>> deleteComments(String postId, int page) async {
    try {
      return await commentRepository.getComments(postId, page);
    } catch (e) {
      return Future.error(e);
    }
  }
}
