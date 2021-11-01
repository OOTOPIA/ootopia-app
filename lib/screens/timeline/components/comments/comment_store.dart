import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';

part "comment_store.g.dart";

class CommentStore = CommentStoreBase with _$CommentStore;

abstract class CommentStoreBase with Store {
  CommentRepositoryImpl commentRepository = CommentRepositoryImpl();

  @observable
  bool isLoading = false;

  @observable
  List<Comment> listComments = [];

  @action
  Future<List<Comment>> getComments(String postId, int page) async {
    try {
      isLoading = true;

      var response = await commentRepository.getComments(postId, page);
      listComments.addAll(response);
      isLoading = false;

      return response;
    } catch (e) {
      isLoading = false;

      return Future.error(e);
    }
  }

  @action
  Future<void> createComment(String postId, String text) async {
    try {
      isLoading = true;
      getComments(postId, 1);
      await commentRepository.createComment(postId, text);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      return Future.error(e);
    }
  }

  @action
  Future<List<Comment>> deleteComments(String postId, int page) async {
    try {
      getComments(postId, page);
      return await commentRepository.getComments(postId, page);
    } catch (e) {
      return Future.error(e);
    }
  }
}
