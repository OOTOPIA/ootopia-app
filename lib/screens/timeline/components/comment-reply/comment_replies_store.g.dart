// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_replies_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CommentRepliesStore on CommentRepliesStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'CommentRepliesStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$howCommentRepliesAtom =
      Atom(name: 'CommentRepliesStoreBase.howCommentReplies');

  @override
  bool get howCommentReplies {
    _$howCommentRepliesAtom.reportRead();
    return super.howCommentReplies;
  }

  @override
  set howCommentReplies(bool value) {
    _$howCommentRepliesAtom.reportWrite(value, super.howCommentReplies, () {
      super.howCommentReplies = value;
    });
  }

  final _$hiddenAnswersAtom =
      Atom(name: 'CommentRepliesStoreBase.hiddenAnswers');

  @override
  bool get hiddenAnswers {
    _$hiddenAnswersAtom.reportRead();
    return super.hiddenAnswers;
  }

  @override
  set hiddenAnswers(bool value) {
    _$hiddenAnswersAtom.reportWrite(value, super.hiddenAnswers, () {
      super.hiddenAnswers = value;
    });
  }

  final _$showCommentRepliesAtom =
      Atom(name: 'CommentRepliesStoreBase.showCommentReplies');

  @override
  bool get showCommentReplies {
    _$showCommentRepliesAtom.reportRead();
    return super.showCommentReplies;
  }

  @override
  set showCommentReplies(bool value) {
    _$showCommentRepliesAtom.reportWrite(value, super.showCommentReplies, () {
      super.showCommentReplies = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'CommentRepliesStoreBase.viewState');

  @override
  ViewState get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(ViewState value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

  final _$listCommentsAtom = Atom(name: 'CommentRepliesStoreBase.listComments');

  @override
  List<CommentReply> get listComments {
    _$listCommentsAtom.reportRead();
    return super.listComments;
  }

  @override
  set listComments(List<CommentReply> value) {
    _$listCommentsAtom.reportWrite(value, super.listComments, () {
      super.listComments = value;
    });
  }

  final _$currentPageCommentAtom =
      Atom(name: 'CommentRepliesStoreBase.currentPageComment');

  @override
  int get currentPageComment {
    _$currentPageCommentAtom.reportRead();
    return super.currentPageComment;
  }

  @override
  set currentPageComment(int value) {
    _$currentPageCommentAtom.reportWrite(value, super.currentPageComment, () {
      super.currentPageComment = value;
    });
  }

  final _$currentPageUserAtom =
      Atom(name: 'CommentRepliesStoreBase.currentPageUser');

  @override
  int get currentPageUser {
    _$currentPageUserAtom.reportRead();
    return super.currentPageUser;
  }

  @override
  set currentPageUser(int value) {
    _$currentPageUserAtom.reportWrite(value, super.currentPageUser, () {
      super.currentPageUser = value;
    });
  }

  final _$hasMoreUsersAtom = Atom(name: 'CommentRepliesStoreBase.hasMoreUsers');

  @override
  bool get hasMoreUsers {
    _$hasMoreUsersAtom.reportRead();
    return super.hasMoreUsers;
  }

  @override
  set hasMoreUsers(bool value) {
    _$hasMoreUsersAtom.reportWrite(value, super.hasMoreUsers, () {
      super.hasMoreUsers = value;
    });
  }

  final _$getCommentRepliesAsyncAction =
      AsyncAction('CommentRepliesStoreBase.getCommentReplies');

  @override
  Future<void> getCommentReplies(String commentId, int page) {
    return _$getCommentRepliesAsyncAction
        .run(() => super.getCommentReplies(commentId, page));
  }

  final _$createCommentAsyncAction =
      AsyncAction('CommentRepliesStoreBase.createComment');

  @override
  Future<CommentReply> createComment(String commentId, String text,
      String replyToUserId, List<UserSearchModel>? listTaggedUsers) {
    return _$createCommentAsyncAction.run(() =>
        super.createComment(commentId, text, replyToUserId, listTaggedUsers));
  }

  final _$deleteCommentsAsyncAction =
      AsyncAction('CommentRepliesStoreBase.deleteComments');

  @override
  Future<bool> deleteComments(String commentId) {
    return _$deleteCommentsAsyncAction
        .run(() => super.deleteComments(commentId));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
howCommentReplies: ${howCommentReplies},
hiddenAnswers: ${hiddenAnswers},
showCommentReplies: ${showCommentReplies},
viewState: ${viewState},
listComments: ${listComments},
currentPageComment: ${currentPageComment},
currentPageUser: ${currentPageUser},
hasMoreUsers: ${hasMoreUsers}
    ''';
  }
}
