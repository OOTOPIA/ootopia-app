part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
}

class CommentInitialState extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentStartState extends CommentState {
  @override
  List<Object> get props => null;
}

class LoadingState extends CommentState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class CommentSuccessState extends CommentState {
  List<Comment> comments;

  CommentSuccessState(this.comments);

  @override
  List<Object> get props => [comments];
}

class CommentErrorState extends CommentState {
  final String message;

  CommentErrorState(this.message);

  @override
  List<Object> get props => [message];
}
