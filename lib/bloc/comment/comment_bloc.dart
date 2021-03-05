import 'dart:async';
import 'dart:io';

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
      yield LoadingState();
      yield* _mapGetComments(event.postId);
    } else if (event is CreateCommentEvent) {
      yield* _mapCreateCommentToState(event);
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

  Stream<CommentState> _mapGetComments(postId) async* {
    try {
      var comments = (await this.repository.getComments(postId));
      yield CommentSuccessState(comments);
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
          Comment comment = result;

          List<Comment> comments = (state as CommentSuccessState).comments;
          comments.insert(0, comment);

          yield EmptyState();
          yield CommentSuccessState(comments.toList(), true);
        }
      }
    } catch (_) {
      yield ErrorCreateCommentState("Error on create a comment");
    }
  }
}
