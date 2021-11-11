import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/analytics.server.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository userRepository;
  PostRepository postRepository;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  UserBloc(this.userRepository, this.postRepository) : super(InitialState());

  UserState get initialState => LoadingState();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
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
      var posts = (await this
          .postRepository
          .getPosts(event.limit, event.offset, event.userId));
      yield LoadedPostsProfileSucessState(posts);
    } catch (_) {
      yield LoadPostsProfileErrorState("error loading posts");
      // AppLocalizations.of(context)!.errorLoadinPosts
    }
  }

  Stream<UserState> _mapGetProfileUserToState(id) async* {
    try {
      var profile = (await this.userRepository.getProfile(id));
      yield GetProfileLoadedSucessState(profile: profile);
    } catch (_) {
      yield GetProfileErrorState(message: "Erro loading profile");
      // AppLocalizations.of(context)!.erroLoadingProfile
    }
  }

  Stream<UserState> _mapUpdateUserToState(UpdateUserEvent event) async* {
    try {
      var resultSubscription;
      try {
        User user =
            await updateUser(event.user, event.tagsIds, resultSubscription);
        resultSubscription?.cancel();
        yield UpdateUserSuccessState(user);
        this.trackingEvents.signupCompletedSignupPartII();
      } catch (err) {
        print("error when upload photo: ${err.toString()}");
        yield UpdateUserErrorState(
            message: "An error occurred while saving user data.");
        // AppLocalizations.of(context)!.anErrorOccurredWhileSavingUserData
      }
    } catch (_) {
      yield UpdateUserErrorState(
          message: "An error occurred while saving user data.");
      // AppLocalizations.of(context)!.anErrorOccurredWhileSavingUserData
    }
  }

  void backgroundHandler() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  FutureOr<dynamic> updateUser(User user, tagsIds, subscription) async {
    FlutterUploader().setBackgroundHandler(backgroundHandler);
    var completer = new Completer();

    if (user.photoFilePath == null ||
        (user.photoFilePath != null && user.photoFilePath!.isEmpty)) {
      return await this.userRepository.updateUser(user, tagsIds);
    } else {
      await this.userRepository.updateUser(user, tagsIds);
      subscription = FlutterUploader().result.listen(
          (result) {
            if (result.status == UploadTaskStatus.complete &&
                !completer.isCompleted) {
              user = User.fromJson(json.decode(result.response!));
              completer.complete(user);
            }
          },
          onDone: () {},
          onError: (error, s) {
            print("on completeError $s");
            completer.completeError(error);
          });
      return completer.future;
    }
  }
}
