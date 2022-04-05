import 'package:flutter/material.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/models/users/user_search_model.dart';
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
  List<UserSearchModel>? listTaggedUsers = [];

  @observable
  String? excludedIds = '';

  @observable
  int currentPageComment = 1;

  @observable
  int currentPageUser = 1;

  @observable
  bool hasMoreUsers = false;

  @observable
  bool hasMoreComments = true;

  @observable
  String fullName = '';

  @action
  Future<void> getComments(String postId, int page) async {
    try {
      var response = await commentRepository.getComments(postId, page);
      hasMoreComments = response.length > 0;
      if (response.isEmpty) {
        currentPageComment = currentPageComment;
      } else {
        listComments.addAll(response);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @action
  Future<void> createComment(String postId, String text) async {
    try {
      isLoading = true;
      List<String> idsUsersTagged = [];
      var newTextComment = text;
      if (listTaggedUsers != null) {
        int newStartIndex = 0;
        int endNameUser = 0;
        listTaggedUsers?.forEach((user) {
          idsUsersTagged.add(user.id);
          String newString = "@[${user.id}]";
          var startname =
              newTextComment.indexOf('‌@${user.fullname}‌', endNameUser);

          // if (startname == user.start!) {
          //   newTextComment = newTextComment.replaceRange(
          //     user.start! + newStartIndex,
          //     user.end! + newStartIndex,
          //     newString,
          //   );
          //   endNameUser =
          //       startname + user.id.length - (user.end! - user.start!);
          //   newStartIndex =
          //       newStartIndex + newString.length - (user.end! - user.start!);
          //   user.end = user.start! + newString.length;
          // } else {
          newTextComment = newTextComment.replaceRange(
            startname + newStartIndex,
            user.fullname.length + startname + newStartIndex + 2,
            newString,
          );
          endNameUser = user.id.length + startname + 2;
          newStartIndex =
              newStartIndex + newString.length - (endNameUser - startname);
          // }
        });
      }
      await commentRepository.createComment(
          postId, newTextComment, idsUsersTagged);
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
  Future<void> searchUser() async {
    try {
      if (viewState != ViewState.loadingNewData) {
        listAllUsers.clear();
        viewState = ViewState.loading;
      }

      var response = await userRepository.getAllUsersByName(
        fullName,
        currentPageUser,
        10,
        excludedIds,
      );
      hasMoreUsers = response.length == 10;
      listAllUsers.addAll(response);
      viewState = ViewState.done;
    } catch (e) {
      viewState = ViewState.error;
    }
  }

  void updateOnScroll(ScrollController scrollController) async {
    if (scrollController.position.atEdge) {
      if (scrollController.position.pixels != 0) {
        if (hasMoreUsers) {
          currentPageUser++;
          viewState = ViewState.loadingNewData;
          await searchUser();
        }
      }
    }
  }
}
