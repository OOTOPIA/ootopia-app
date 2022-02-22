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

  final _$listUsersAtom = Atom(name: 'CommentStoreBase.listUsers');

  @override
  List<dynamic> get listUsers {
    _$listUsersAtom.reportRead();
    return super.listUsers;
  }

  @override
  set listUsers(List<dynamic> value) {
    _$listUsersAtom.reportWrite(value, super.listUsers, () {
      super.listUsers = value;
    });
  }

  final _$listUsersMarketAtom = Atom(name: 'CommentStoreBase.listUsersMarket');

  @override
  List<String> get listUsersMarket {
    _$listUsersMarketAtom.reportRead();
    return super.listUsersMarket;
  }

  @override
  set listUsersMarket(List<String> value) {
    _$listUsersMarketAtom.reportWrite(value, super.listUsersMarket, () {
      super.listUsersMarket = value;
    });
  }

  final _$currentPageAtom = Atom(name: 'CommentStoreBase.currentPage');

  @override
  int get currentPage {
    _$currentPageAtom.reportRead();
    return super.currentPage;
  }

  @override
  set currentPage(int value) {
    _$currentPageAtom.reportWrite(value, super.currentPage, () {
      super.currentPage = value;
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

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
listComments: ${listComments},
listUsers: ${listUsers},
listUsersMarket: ${listUsersMarket},
currentPage: ${currentPage}
    ''';
  }
}
