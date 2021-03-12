part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class GetCommentEvent extends CommentEvent {
  final String postId;

  @required
  GetCommentEvent({this.postId});

  @override
  List<Object> get props => [this.postId];
}

class CreateCommentEvent extends CommentEvent {
  final CommentCreate comment;

  CreateCommentEvent({this.comment});

  @override
  List<Object> get props => [this.comment];
}

class LoadingSucessCommentsEvent extends CommentEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnToggleSelectCommentEvent extends CommentEvent {
  final Comment comment;

  OnToggleSelectCommentEvent({this.comment});

  @override
  // TODO: implement props
  List<Object> get props => [this.comment];
}

class UnselectAllCommentsEvent extends CommentEvent {
  UnselectAllCommentsEvent();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteSelectedCommentsEvent extends CommentEvent {
  final String postId;
  final List<String> commentsIds;

  DeleteSelectedCommentsEvent(this.postId, this.commentsIds);
  @override
  // TODO: implement props
  List<Object> get props => [this.commentsIds];
}
