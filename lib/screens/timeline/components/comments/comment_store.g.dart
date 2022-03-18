// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CommentStore on CommentStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'CommentStoreBase.isLoading');

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

  final _$viewStateAtom = Atom(name: 'CommentStoreBase.viewState');

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

  final _$listCommentsAtom = Atom(name: 'CommentStoreBase.listComments');

  @override
  List<Comment> get listComments {
    _$listCommentsAtom.reportRead();
    return super.listComments;
  }

  @override
  set listComments(List<Comment> value) {
    _$listCommentsAtom.reportWrite(value, super.listComments, () {
      super.listComments = value;
    });
  }

  final _$listAllUsersAtom = Atom(name: 'CommentStoreBase.listAllUsers');

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

  final _$listTaggedUsersAtom = Atom(name: 'CommentStoreBase.listTaggedUsers');

  @override
  List<UserSearchModel>? get listTaggedUsers {
    _$listTaggedUsersAtom.reportRead();
    return super.listTaggedUsers;
  }

  @override
  set listTaggedUsers(List<UserSearchModel>? value) {
    _$listTaggedUsersAtom.reportWrite(value, super.listTaggedUsers, () {
      super.listTaggedUsers = value;
    });
  }

  final _$currentPageCommentAtom =
      Atom(name: 'CommentStoreBase.currentPageComment');

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

  final _$currentPageUserAtom = Atom(name: 'CommentStoreBase.currentPageUser');

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

  final _$hasMoreUsersAtom = Atom(name: 'CommentStoreBase.hasMoreUsers');

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

  final _$hasMorePostsAtom = Atom(name: 'CommentStoreBase.hasMorePosts');

  @override
  bool get hasMorePosts {
    _$hasMorePostsAtom.reportRead();
    return super.hasMorePosts;
  }

  @override
  set hasMorePosts(bool value) {
    _$hasMorePostsAtom.reportWrite(value, super.hasMorePosts, () {
      super.hasMorePosts = value;
    });
  }

  final _$getCommentsAsyncAction = AsyncAction('CommentStoreBase.getComments');

  @override
  Future<void> getComments(String postId, int page) {
    return _$getCommentsAsyncAction.run(() => super.getComments(postId, page));
  }

  final _$createCommentAsyncAction =
      AsyncAction('CommentStoreBase.createComment');

  @override
  Future<void> createComment(String postId, String text) {
    return _$createCommentAsyncAction
        .run(() => super.createComment(postId, text));
  }

  final _$deleteCommentsAsyncAction =
      AsyncAction('CommentStoreBase.deleteComments');

  @override
  Future<bool> deleteComments(String postId, String id) {
    return _$deleteCommentsAsyncAction
        .run(() => super.deleteComments(postId, id));
  }

  final _$searchUserAsyncAction = AsyncAction('CommentStoreBase.searchUser');

  @override
  Future<void> searchUser(String fullName) {
    return _$searchUserAsyncAction.run(() => super.searchUser(fullName));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
viewState: ${viewState},
listComments: ${listComments},
listAllUsers: ${listAllUsers},
listTaggedUsers: ${listTaggedUsers},
currentPageComment: ${currentPageComment},
currentPageUser: ${currentPageUser},
hasMoreUsers: ${hasMoreUsers},
hasMorePosts: ${hasMorePosts}
    ''';
  }
}
