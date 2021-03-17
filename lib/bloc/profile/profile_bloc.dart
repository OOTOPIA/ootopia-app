import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/profile/profile_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository;
  PostRepository postRepository;

  ProfileBloc(this.profileRepository, this.postRepository)
      : super(InitialState());

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
    } else if (event is GetProfileUserEvent) {
      yield* _mapGetProfileUserToState(event.id);
    }
  }

  Stream<ProfileState> _mapAlbumsLoadedToState() async* {
    try {
      var posts = (await this.postRepository.getPosts());
      yield LoadedSucessState(posts);
    } catch (_) {
      yield ErrorState("error loading Albums");
    }
  }

  Stream<ProfileState> _mapGetProfileUserToState(id) async* {
    try {
      var profile = (await this.profileRepository.getProfile(id));
      yield GetProfileLoadedSucessState(profile: profile);
    } catch (_) {
      yield GetProfileErrorState(message: "Erro loading profile");
    }
  }
}
