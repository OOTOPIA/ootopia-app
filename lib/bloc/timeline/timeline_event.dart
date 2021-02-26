part of 'timeline_bloc.dart';

//@immutable
abstract class TimelinePostEvent extends Equatable {
  const TimelinePostEvent();
}

//eventos que serão enviados para a entrada do bloc

class LoadingTimelinePostEvent extends TimelinePostEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingSucessTimelinePostEvent extends TimelinePostEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetTimelinePostEvent extends TimelinePostEvent {
  final int id;
  const GetTimelinePostEvent(this.id);
  @override
  List<Object> get props => [];
}

class CreateTimelinePostEvent extends TimelinePostEvent {
  final TimelinePost post;
  const CreateTimelinePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class UpdateTimelinePostEvent extends TimelinePostEvent {
  final TimelinePost post;
  const UpdateTimelinePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class DeleteTimelinePostEvent extends TimelinePostEvent {
  final TimelinePost post;

  const DeleteTimelinePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class NetworkErrorEvent extends Error {}
