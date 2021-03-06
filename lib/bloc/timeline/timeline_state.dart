part of 'timeline_bloc.dart';

abstract class TimelinePostState extends Equatable {
  const TimelinePostState();
}

//eventos que sairão do bloc

class EmptyState extends TimelinePostState {
  @override
  List<Object> get props => [];
}

class InitialState extends TimelinePostState {
  const InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends TimelinePostState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedSucessState extends TimelinePostState {
  List<TimelinePost> posts;
  bool
      onlyForRefreshCurrentList; //workaround for refresh list without put new posts to timeline
  LoadedSucessState(this.posts, this.onlyForRefreshCurrentList);
  @override
  List<Object> get props => [posts];
}

class OnDeletedPostState extends TimelinePostState {
  final postId;
  const OnDeletedPostState(this.postId);
  @override
  List<Object> get props => [postId];
}

class OnUpdatePostCommentsCountState extends TimelinePostState {
  final String postId;
  final int commentsCount;
  const OnUpdatePostCommentsCountState(this.postId, this.commentsCount);
  @override
  List<Object> get props => [postId, commentsCount];
}

class ErrorState extends TimelinePostState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
