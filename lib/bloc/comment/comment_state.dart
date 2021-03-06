part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
}

class EmptyState extends CommentState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CommentInitialState extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentStartState extends CommentState {
  @override
  List<Object> get props => [];
}

class LoadingCommentsState extends CommentState {
  const LoadingCommentsState();
  @override
  List<Object> get props => [];
}

class LoadingCreateCommentState extends CommentState {
  const LoadingCreateCommentState();
  @override
  List<Object> get props => [];
}

class SuccessCreateCommentState extends CommentState {
  final Comment comment;
  const SuccessCreateCommentState(this.comment);
  @override
  List<Object> get props => [comment];
}

class CommentSuccessState extends CommentState {
  List<Comment> comments;
  bool newCommentIsAdded;
  bool allCommentsLoaded;

  CommentSuccessState(this.comments,
      [this.newCommentIsAdded = false, this.allCommentsLoaded = false]);

  @override
  List<Object> get props => [comments, newCommentIsAdded];
}

class CommentErrorState extends CommentState {
  final String message;

  CommentErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ErrorCreateCommentState extends CommentState {
  final String message;

  ErrorCreateCommentState(this.message);

  @override
  List<Object> get props => [message];
}
