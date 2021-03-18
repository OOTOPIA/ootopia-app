part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class InitialState extends ProfileState {
  const InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedPostsProfileSucessState extends ProfileState {
  List<TimelinePost> posts;
  LoadedPostsProfileSucessState(this.posts);
  @override
  List<Object> get props => [posts];
}

class LoadPostsProfileErrorState extends ProfileState {
  final String message;
  const LoadPostsProfileErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GetProfileInitialState extends ProfileState {
  const GetProfileInitialState();
  @override
  List<Object> get props => [];
}

class GetProfileLoadedSucessState extends ProfileState {
  Profile profile;
  GetProfileLoadedSucessState({this.profile});
  @override
  List<Object> get props => [this.profile];
}

class GetProfileErrorState extends ProfileState {
  final String message;
  const GetProfileErrorState({this.message});
  @override
  List<Object> get props => [this.message];
}
