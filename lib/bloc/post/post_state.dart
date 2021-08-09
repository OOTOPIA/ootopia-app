part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
}

class EmptyState extends PostState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class PostInitialState extends PostState {
  @override
  List<Object> get props => [];
}

class LoadingState extends PostState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadingCreatePostState extends PostState {
  const LoadingCreatePostState();
  @override
  List<Object> get props => [];
}

class SuccessCreatePostState extends PostState {
  double oozToReward;
  SuccessCreatePostState({required this.oozToReward});
  @override
  List<Object> get props => [];
}

class ErrorCreatePostState extends PostState {
  final String message;
  ErrorCreatePostState(this.message);
  @override
  List<Object> get props => [message];
}

class SuccessDeletePostState extends PostState {
  final String postId;
  final bool isProfile;
  const SuccessDeletePostState(this.postId, this.isProfile);
  @override
  List<Object> get props => [postId];
}

class ErrorDeletePostState extends PostState {
  final String message;
  ErrorDeletePostState(this.message);
  @override
  List<Object> get props => [message];
}
