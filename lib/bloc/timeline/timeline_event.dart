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

class GetTimelinePostsEvent extends TimelinePostEvent {
  final int limit;
  final int offset;
  String? userId;
  GetTimelinePostsEvent(this.limit, this.offset, [this.userId]);
  @override
  List<dynamic> get props => [this.limit, this.offset, this.userId];
}

class GetTimelinePostEvent extends TimelinePostEvent {
  final int id;
  const GetTimelinePostEvent(this.id);
  @override
  List<Object> get props => [];
}

class LikePostEvent extends TimelinePostEvent {
  final String postId;
  const LikePostEvent(this.postId);

  @override
  List<Object> get props => [postId];
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

class OnUpdatePostCommentsCountEvent extends TimelinePostEvent {
  final String postId;
  final int commentsCount;
  const OnUpdatePostCommentsCountEvent(this.postId, this.commentsCount);

  @override
  List<Object> get props => [postId, commentsCount];
}

class OnDeletePostFromTimelineEvent extends TimelinePostEvent {
  final String postId;
  final bool isProfile;

  const OnDeletePostFromTimelineEvent(this.postId, this.isProfile);

  @override
  List<Object> get props => [postId];
}

class NetworkErrorEvent extends Error {}
