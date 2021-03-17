import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  PostRepository postRepository;
  // userRepository;

  ProfileBloc(this.postRepository) : super(InitialState());

  @override
  ProfileState get initialState => LoadingState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    // TODO: implement mapEventToState
    LoadingState();
    if (event is GetPostsProfileEvent) {
      yield LoadingState();
      yield* _mapAlbumsLoadedToState();
    }
    // } else if (event is LikePostEvent) {
    //   yield* _mapPostLikedToState(event);
    // }
  }

  Stream<ProfileState> _mapAlbumsLoadedToState() async* {
    try {
      var posts = (await this.postRepository.getPosts());
      yield LoadedSucessState(posts);
    } catch (_) {
      yield ErrorState("error loading Albums");
    }
  }
}
