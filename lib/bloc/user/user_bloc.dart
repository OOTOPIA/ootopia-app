import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository userRepository;
  PostRepository postRepository;

  UserBloc(this.userRepository, this.postRepository) : super(InitialState());

  @override
  UserState get initialState => LoadingState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    // TODO: implement mapEventToState
    LoadingState();
    if (event is GetPostsProfileEvent) {
      yield LoadingState();
      yield* _mapGetPostsProfileToState(event);
    } else if (event is GetProfileUserEvent) {
      yield* _mapGetProfileUserToState(event.id);
    } else if (event is UpdateUserEvent) {
      yield LoadingState();
      yield* _mapUpdateUserToState(event);
    }
  }

  Stream<UserState> _mapGetPostsProfileToState(
      GetPostsProfileEvent event) async* {
    try {
      var posts =
          (await this.postRepository.getPosts(event.page, event.userId));
      yield LoadedPostsProfileSucessState(posts);
    } catch (_) {
      yield LoadPostsProfileErrorState("error loading posts");
    }
  }

  Stream<UserState> _mapGetProfileUserToState(id) async* {
    try {
      var profile = (await this.userRepository.getProfile(id));
      yield GetProfileLoadedSucessState(profile: profile);
    } catch (_) {
      yield GetProfileErrorState(message: "Erro loading profile");
    }
  }

  Stream<UserState> _mapUpdateUserToState(UpdateUserEvent event) async* {
    try {
      var resultSubscription;
      try {
        User user = await updateUser(event.user, resultSubscription);
        resultSubscription?.cancel();
        yield UpdateUserSuccessState(user);
      } catch (err) {
        print("error when upload photo: ${err.toString()}");
        yield UpdateUserErrorState(
            message: "An error occurred while saving user data.");
      }
    } catch (_) {
      yield UpdateUserErrorState(
          message: "An error occurred while saving user data.");
    }
  }

  FutureOr<dynamic> updateUser(user, subscription) async {
    FlutterUploader uploader = FlutterUploader();
    var completer = new Completer();
    await this.userRepository.updateUser(user, uploader);
    subscription = uploader.progress.listen((result) {
      print("Result ${result.toString()}");
      if (result.progress == 100) {
        completer.complete(user);
      }
    }, onDone: () {
      completer.complete(user);
    }, onError: (error) {
      completer.completeError(error);
    });
    return completer.future;
  }
}
