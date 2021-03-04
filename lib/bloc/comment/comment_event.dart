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
