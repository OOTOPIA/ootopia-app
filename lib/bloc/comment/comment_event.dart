part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
}

//eventos que serão enviados para a entrada do bloc

class LoadingCommentEvent extends CommentEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingSucessCommentEvent extends CommentEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetCommentEvent extends CommentEvent {
  final int id;
  const GetCommentEvent(this.id);
  @override
  List<Object> get props => [];
}

class CreateCommentEvent extends CommentEvent {
  final String postId;
  final String text;

  const CreateCommentEvent(this.postId, this.text);

  @override
  List<Object> get props => [postId, text];
}

class UpdateCommentEvent extends CommentEvent {
  final Comment post;
  const UpdateCommentEvent(this.post);

  @override
  List<Object> get props => [post];
}

class DeleteCommentEvent extends CommentEvent {
  final Comment post;

  const DeleteCommentEvent(this.post);

  @override
  List<Object> get props => [post];
}

class NetworkErrorEvent extends Error {}
