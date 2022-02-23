import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';

part "comment_store.g.dart";

class CommentStore = CommentStoreBase with _$CommentStore;

abstract class CommentStoreBase with Store {
  CommentRepositoryImpl commentRepository = CommentRepositoryImpl();

  @observable
  bool isLoading = false;

  @observable
  List<Comment> listComments = [];

  @observable
  List<User> listUsers = [];

  @observable
  List<User> resultList = [];

  @observable
  List<String> listUsersMarket = [];

  @observable
  int currentPage = 1;

  @observable
  int currentPageUser = 1;

  @action
  Future<void> getComments(String postId, int page) async {
    try {
      var response = await commentRepository.getComments(postId, page);
      if (response.isEmpty) {
        currentPage = currentPage;
      } else {
        listComments.addAll(response);
      }
    } catch (e) {}
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
      isLoading = true;
      List<String> idComments = [id];
      var response = await commentRepository.deleteComments(postId, idComments);
      isLoading = false;

      return response;
    } catch (e) {
      isLoading = false;

      return Future.error(e);
    }
  }

  @action
  Future<void> listAllUsers() async {
    try {
      for (var i = 0; i < 8; i++) {
        listUsers.add(User(
          fullname: 'data$i',
        ));
      }
    } catch (e) {}
  }

  @action
  void searchUser(String value) {
    List<User> showResults = [];

    for (var user in listUsers) {
      var fullaname = user.fullname?.toLowerCase();
      List<String> splitPage = value.split('@');
      if (fullaname!.contains(splitPage[1])) {
        showResults.add(user);
      }
    }
    resultList = showResults;
  }
}
