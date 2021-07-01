part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class GetCommentEvent extends CommentEvent {
  final String postId;
  final int page;
  final List<Comment> allComments;
  final bool loadingMore;

  @required
  GetCommentEvent(
      {required this.postId,
      required this.page,
      required this.allComments,
      required this.loadingMore});

  @override
  List<Object> get props => [this.postId, this.page];
}

class CreateCommentEvent extends CommentEvent {
  final CommentCreate comment;

  CreateCommentEvent({required this.comment});

  @override
  List<Object> get props => [this.comment];
}

class LoadingSucessCommentsEvent extends CommentEvent {
  @override
  List<Object> get props => [];
}

class OnToggleSelectCommentEvent extends CommentEvent {
  final Comment comment;

  OnToggleSelectCommentEvent({required this.comment});

  @override
  List<Object> get props => [this.comment];
}

class UnselectAllCommentsEvent extends CommentEvent {
  UnselectAllCommentsEvent();
  @override
  List<Object> get props => [];
}

class DeleteSelectedCommentsEvent extends CommentEvent {
  final String postId;
  final List<String> commentsIds;

  DeleteSelectedCommentsEvent(this.postId, this.commentsIds);
  @override
  List<Object> get props => [this.commentsIds];
}
