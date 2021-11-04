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
      print(page);
      isLoading = true;
      var response = await commentRepository.getComments(postId, page);
      print(response);
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
      await commentRepository.createComment(postId, text);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      return Future.error(e);
    }
  }

  @action
  Future<bool> deleteComments(String postId, String id) async {
    try {
      List<String> idComments = [id];
      return await commentRepository.deleteComments(postId, idComments);
    } catch (e) {
      return Future.error(e);
    }
  }
}
