part of 'timeline_bloc.dart';

abstract class TimelinePostState extends Equatable {
  const TimelinePostState();
}

//eventos que sairão do bloc

class EmptyState extends TimelinePostState {
  @override
  // TODO: implement props
  List<Object> get props => null;
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
  final String postId;
  const OnDeletedPostState(this.postId);
  @override
  List<Object> get props => [postId];
}

class ErrorState extends TimelinePostState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
