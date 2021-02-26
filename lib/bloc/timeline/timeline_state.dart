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
  LoadedSucessState(this.posts);
  @override
  List<Object> get props => [posts];
}

class ErrorState extends TimelinePostState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}
