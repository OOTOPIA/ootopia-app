// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CommentStore on CommentStoreBase, Store {
  final _$getCommentsAsyncAction = AsyncAction('CommentStoreBase.getComments');

  @override
  Future<List<Comment>> getComments(String postId, int page) {
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
  Future<List<Comment>> deleteComments(String postId, int page) {
    return _$deleteCommentsAsyncAction
        .run(() => super.deleteComments(postId, page));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
