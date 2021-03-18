import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/comments/comment_create_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/data/repositories/comment_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentRepositoryImpl repository = CommentRepositoryImpl();

  CommentBloc(this.repository) : super(CommentInitialState());

  @override
  CommentState get initialState => CommentInitialState();

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    LoadingState();
    if (event is GetCommentEvent) {
      if (!event.loadingMore) {
        yield LoadingState();
      }
      yield* _mapGetComments(event.postId, event.page, event.allComments);
    } else if (event is CreateCommentEvent) {
      yield* _mapCreateCommentToState(event);
    } else if (event is OnToggleSelectCommentEvent) {
      yield* _mapOnToggleSelectCommentToState(event);
    } else if (event is UnselectAllCommentsEvent) {
      yield* _mapUnselectAllCommentsToState(event);
    } else if (event is DeleteSelectedCommentsEvent) {
      yield LoadingState();
      yield* _mapDeleteSelectedCommentsToState(event);
    }
    // else if (event is Comment) {
    //   yield* _mapUserLoginToState(event);
    // }
    // Stream<TimelinePostState> _mapAlbumsLoadedToState() async* {
    //   try {
    //     var posts = (await this.repository.getPosts());
    //     yield LoadedSucessState(posts);
    //   } catch (_) {
    //     yield ErrorState("error loading Albums");
    //   }
    // }
  }

  Stream<CommentState> _mapGetComments(
      String postId, int page, List<Comment> allComments) async* {
    try {
      var allCommentsLoaded = false;
      var comments = (await this.repository.getComments(postId, page));

      allCommentsLoaded = comments.length <= 0;

      if (allComments == null) {
        allComments = [];
      }

      allComments.addAll(comments);

      yield EmptyState();
      yield CommentSuccessState(allComments, false, allCommentsLoaded);
    } catch (_) {
      yield CommentErrorState("error loading comments");
    }
  }

  Stream<CommentState> _mapCreateCommentToState(
      CreateCommentEvent event) async* {
    try {
      if (state is CommentSuccessState) {
        var result = (await this.repository.createComment(event.comment));
        if (result != null) {
          List<Comment> comments = (state as CommentSuccessState).comments;
          comments.insert(0, result);

          yield EmptyState();
          yield CommentSuccessState(comments.toList(), true);
        }
      }
    } catch (_) {
      yield ErrorCreateCommentState("Error on create a comment");
    }
  }

  Stream<CommentState> _mapOnToggleSelectCommentToState(
      OnToggleSelectCommentEvent event) async* {
    try {
      if (state is CommentSuccessState) {
        List<Comment> comments = (state as CommentSuccessState).comments;

        comments.forEach((c) {
          if (c.id == event.comment.id) {
            c.selected = event.comment.selected;
          }
        });

        yield EmptyState();
        yield CommentSuccessState(comments.toList(), false);
      }
    } catch (_) {
      yield ErrorCreateCommentState("Error on create a comment");
    }
  }

  Stream<CommentState> _mapUnselectAllCommentsToState(
      UnselectAllCommentsEvent event) async* {
    try {
      if (state is CommentSuccessState) {
        List<Comment> comments = (state as CommentSuccessState).comments;

        comments.forEach((c) {
          c.selected = false;
        });

        yield EmptyState();
        yield CommentSuccessState(comments.toList(), false);
      }
    } catch (_) {
      yield ErrorCreateCommentState("Error on create a comment");
    }
  }

  Stream<CommentState> _mapDeleteSelectedCommentsToState(
      DeleteSelectedCommentsEvent event) async* {
    try {
      if (state is LoadingState) {
        var result = (await this
            .repository
            .deleteComments(event.postId, event.commentsIds));
        if (result == "ALL_DELETED") {
          yield* this._mapGetComments(event.postId, 1, []);
        }

        //TODO: Não recarregar a lista, apenas remover da lista atual os comentários removidos
        //fruits.where((f) => f.startsWith('a')).toList();
      }
    } catch (_) {
      yield ErrorCreateCommentState("Error on create a comment");
    }
  }
}
