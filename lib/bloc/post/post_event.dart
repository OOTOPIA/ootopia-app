part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostEvent extends PostEvent {
  final PostCreate post;

  CreatePostEvent({this.post});

  @override
  List<Object> get props => [this.post];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  final bool isProfile;

  DeletePostEvent(this.postId, this.isProfile);
  @override
  // TODO: implement props
  List<Object> get props => [];
}
