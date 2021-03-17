part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetPostsProfileEvent extends ProfileEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetProfileUserEvent extends ProfileEvent {
  final String id;

  const GetProfileUserEvent({this.id});
  @override
  // TODO: implement props
  List<Object> get props => [this.id];
}
