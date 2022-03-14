import 'package:flutter/material.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
import 'package:ootopia_app/data/repositories/comment_replies_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part "comment_replies_store.g.dart";

class CommentRepliesStore = CommentRepliesStoreBase with _$CommentRepliesStore;

enum ViewState { loading, error, done, loadingNewData, refresh }

abstract class CommentRepliesStoreBase with Store {
  CommentRepliesRepositoryImpl commentRepliesRepository =
      CommentRepliesRepositoryImpl();
  UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  bool isLoading = false;

  @observable
  bool howCommentReplies = false;

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  List<CommentReply> listComments = [];

  @observable
  List<UserSearchModel> listAllUsers = [];

  @observable
  List<String>? listUsersMarket = [];

  @observable
  int currentPageComment = 0;

  @observable
  int currentPageUser = 1;

  @observable
  bool hasMoreUsers = false;

  @action
  Future<void> getCommentReplies(String commentId, int page) async {
    try {
      var response =
          await commentRepliesRepository.getCommentsReplies(commentId, page);
      if (response.isEmpty) {
        currentPageComment = currentPageComment;
      } else {
        listComments.addAll(response);
      }
    } catch (e) {
      print("ERROU nem ferrando ? ${e.toString()}");
    }
  }

  @action
  Future<CommentReply> createComment(String commentId, String text) async {
    try {
      isLoading = true;
      CommentReply commentReply = await commentRepliesRepository
          .createCommentReply(commentId, text, listUsersMarket);

      isLoading = false;
      return commentReply;
    } catch (e) {
      isLoading = false;
      return Future.error(e);
    }
  }

  @action
  Future<bool> deleteComments(String commentId) async {
    try {
      isLoading = true;
      var response =
          await commentRepliesRepository.deleteCommentReply(commentId);
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
