part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class InitialState extends UserState {
  const InitialState();
  @override
  List<Object> get props => [];
}

class LoadingState extends UserState {
  const LoadingState();
  @override
  List<Object> get props => [];
}

class LoadedPostsProfileSucessState extends UserState {
  List<TimelinePost> posts;
  LoadedPostsProfileSucessState(this.posts);
  @override
  List<Object> get props => [posts];
}

class LoadPostsProfileErrorState extends UserState {
  final String message;
  const LoadPostsProfileErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class GetProfileInitialState extends UserState {
  const GetProfileInitialState();
  @override
  List<Object> get props => [];
}

class GetProfileLoadedSucessState extends UserState {
  Profile profile;
  GetProfileLoadedSucessState({required this.profile});
  @override
  List<Object> get props => [this.profile];
}

class GetProfileErrorState extends UserState {
  final String message;
  const GetProfileErrorState({required this.message});
  @override
  List<Object> get props => [this.message];
}

class UpdateUserSuccessState extends UserState {
  final User user;
  UpdateUserSuccessState(this.user);
  @override
  List<Object> get props => [];
}

class UpdateUserErrorState extends UserState {
  final String message;
  const UpdateUserErrorState({required this.message});
  @override
  List<Object> get props => [this.message];
}
