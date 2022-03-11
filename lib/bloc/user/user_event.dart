part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetPostsProfileEvent extends UserEvent {
  final int limit;
  final int offset;
  final String userId;

  const GetPostsProfileEvent(this.limit, this.offset, this.userId);
  @override
  List<Object> get props => [this.limit, this.offset, this.userId];
}

class GetProfileUserEvent extends UserEvent {
  final String id;

  const GetProfileUserEvent(this.id);
  @override
  List<Object> get props => [this.id];
}

class UpdateUserEvent extends UserEvent {
  final User user;
  final List<String> tagsIds;

  const UpdateUserEvent(this.user, this.tagsIds);
  @override
  List<Object> get props => [this.user];
}
