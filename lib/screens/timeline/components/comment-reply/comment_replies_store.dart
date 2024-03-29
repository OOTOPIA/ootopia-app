import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:ootopia_app/data/models/users/user_search_model.dart';
import 'package:ootopia_app/data/repositories/comment_replies_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:collection/collection.dart';

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
  bool hiddenAnswers = false;

  @observable
  bool showCommentReplies = false;

  @observable
  ViewState viewState = ViewState.loading;

  @observable
  List<CommentReply> listComments = [];

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
        response.forEach((commentReply) {
          if (listComments != null &&
              listComments.firstWhereOrNull(
                      (comment) => comment.id == commentReply.id) ==
                  null) {
            listComments.insert(0, commentReply);
          } else if (listComments == null) {
            listComments.add(commentReply);
          }
        });
      }
    } catch (e) {
      throw Future.error(e);
    }
  }

  @action
  Future<CommentReply> createComment(String commentId, String text,
      String replyToUserId, List<UserSearchModel>? listTaggedUsers) async {
    try {
      List<String> listUsersMarket = [];
      String newTextComment = text;

      if (listTaggedUsers != null) {
        int newStartIndex = 0;
        listTaggedUsers.forEach((user) {
          listUsersMarket.add(user.id);
          String newString = "@[${user.id}]";
          if (newTextComment.contains(user.fullname)) {
            newTextComment = newTextComment.replaceRange(
              user.start! + newStartIndex,
              user.end! + newStartIndex,
              newString,
            );
          }
          newStartIndex =
              newStartIndex + newString.length - (user.end! - user.start!);
          user.end = user.start! + newString.length;
        });
      }

      isLoading = true;
      CommentReply commentReply =
          await commentRepliesRepository.createCommentReply(
              commentId, newTextComment, replyToUserId, listUsersMarket);

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
}
