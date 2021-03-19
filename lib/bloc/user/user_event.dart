part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetPostsProfileEvent extends UserEvent {
  final int page;
  final String userId;

  const GetPostsProfileEvent(this.page, this.userId);
  @override
  List<Object> get props => [this.page, this.userId];
}

class GetProfileUserEvent extends UserEvent {
  final String id;

  const GetProfileUserEvent(this.id);
  @override
  List<Object> get props => [this.id];
}

class UpdateUserEvent extends UserEvent {
  final User user;

  const UpdateUserEvent(this.user);
  @override
  List<Object> get props => [this.user];
}
