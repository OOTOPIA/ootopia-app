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

  final _$listAllUsersAtom = Atom(name: 'CommentRepliesStoreBase.listAllUsers');

  @override
  List<UserSearchModel> get listAllUsers {
    _$listAllUsersAtom.reportRead();
    return super.listAllUsers;
  }

  @override
  set listAllUsers(List<UserSearchModel> value) {
    _$listAllUsersAtom.reportWrite(value, super.listAllUsers, () {
      super.listAllUsers = value;
    });
  }

  final _$listUsersMarketAtom =
      Atom(name: 'CommentRepliesStoreBase.listUsersMarket');

  @override
  List<String>? get listUsersMarket {
    _$listUsersMarketAtom.reportRead();
    return super.listUsersMarket;
  }

  @override
  set listUsersMarket(List<String>? value) {
    _$listUsersMarketAtom.reportWrite(value, super.listUsersMarket, () {
      super.listUsersMarket = value;
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
  Future<CommentReply> createComment(String commentId, String text) {
    return _$createCommentAsyncAction
        .run(() => super.createComment(commentId, text));
  }

  final _$deleteCommentsAsyncAction =
      AsyncAction('CommentRepliesStoreBase.deleteComments');

  @override
  Future<bool> deleteComments(String commentId) {
    return _$deleteCommentsAsyncAction
        .run(() => super.deleteComments(commentId));
  }

  final _$searchUserAsyncAction =
      AsyncAction('CommentRepliesStoreBase.searchUser');

  @override
  Future<void> searchUser(String fullName) {
    return _$searchUserAsyncAction.run(() => super.searchUser(fullName));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
howCommentReplies: ${howCommentReplies},
viewState: ${viewState},
listComments: ${listComments},
listAllUsers: ${listAllUsers},
listUsersMarket: ${listUsersMarket},
currentPageComment: ${currentPageComment},
currentPageUser: ${currentPageUser},
hasMoreUsers: ${hasMoreUsers}
    ''';
  }
}
