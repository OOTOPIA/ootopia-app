import 'package:flutter/material.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part "comment_store.g.dart";

class CommentStore = CommentStoreBase with _$CommentStore;

enum ViewState { loading, error, done, loadingNewData, refresh }

abstract class CommentStoreBase with Store {
  CommentRepositoryImpl commentRepository = CommentRepositoryImpl();
  UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  bool isLoading = false;

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  List<Comment> listComments = [];

  @observable
  List<UserSearchModel> listAllUsers = [];

  @observable
  List<String>? listUsersMarket = [];

  @observable
  int currentPageComment = 1;

  @observable
  int currentPageUser = 1;

  @observable
  bool hasMoreUsers = false;

  @observable
  bool hasMorePosts = true;

  @action
  Future<void> getComments(String postId, int page) async {
    try {
      var response = await commentRepository.getComments(postId, page);
      print("AHHHHHHHHHHHHHHHHHHH ${response}");
      hasMorePosts = response.length > 0;
      if (response.isEmpty) {
        currentPageComment = currentPageComment;
      } else {
        listComments.addAll(response);
      }
    } catch (e) {
      print("ERROU ? ${e.toString()}");
    }
  }

  @action
  Future<void> createComment(String postId, String text) async {
    try {
      isLoading = true;
      var oi =
          await commentRepository.createComment(postId, text, listUsersMarket);
      print("AHHHHHHHHHHHHHHH ${oi.id}");
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
  Future<void> searchUser(String fullName) async {
    if (viewState != ViewState.loadingNewData) {
      listAllUsers.clear();
    }
    try {
      viewState = ViewState.loading;
      var response =
          await userRepository.getAllUsersByName(fullName, currentPageUser, 10);
      hasMoreUsers = response.length == 10;
      listAllUsers.addAll(response);
      viewState = ViewState.done;
    } catch (e) {
      viewState = ViewState.error;
    }
  }

  void updateOnScroll(
      ScrollController scrollController, String fullname) async {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        if (hasMoreUsers) {
          currentPageUser++;
          viewState = ViewState.loadingNewData;
          await searchUser(fullname);
        }
      }
    }
  }
}
