import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/shared/analytics.server.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepositoryImpl repository = PostRepositoryImpl();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  PostBloc(this.repository) : super(PostInitialState());

  @override
  PostState get initialState => PostInitialState();

  @override
  Stream<PostState> mapEventToState(
    PostEvent event,
  ) async* {
    if (event is CreatePostEvent) {
      yield LoadingCreatePostState();
      yield* _mapCreatePostToState(event);
    } else if (event is DeletePostEvent) {
      yield* _mapDeletePostToState(event);
    }
  }

  Stream<PostState> _mapCreatePostToState(CreatePostEvent event) async* {
    try {
      var resultSubscription;
      await this.createPost(event.post, resultSubscription);
      resultSubscription?.cancel();
      double oozToReward = 0;
      double oozToRewardForVideo = 25;
      double oozToRewardForImage = 15;
      if (event.post.durationInSecs != null && event.post.type == "video") {
        oozToReward = oozToRewardForVideo * (event.post.durationInSecs! / 60);
      } else if (event.post.type == "image") {
        oozToReward = oozToRewardForImage;
      }
      yield SuccessCreatePostState(
        oozToReward: oozToReward,
      );
      this.trackingEvents.timelineCreatedAPost(event.post.type!);
    } catch (_) {
      yield ErrorCreatePostState("Error on create a post");
    }
  }

  void backgroundHandler() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterUploader uploader = FlutterUploader();
  }

  FutureOr<dynamic> createPost(PostCreate post, subscription) async {
    FlutterUploader().setBackgroundHandler(backgroundHandler);
    var completer = new Completer();

    await this.repository.createPost(post);
    subscription = FlutterUploader().result.listen((result) {
      if (result.status == UploadTaskStatus.complete &&
          !completer.isCompleted) {
        completer.complete(result.response);
      }
    }, onDone: () {
      if (!completer.isCompleted) completer.complete(post);
    }, onError: (error) {
      completer.completeError(error);
    });
    return completer.future;
  }

  Stream<PostState> _mapDeletePostToState(DeletePostEvent event) async* {
    try {
      var result = (await this.repository.deletePost(event.postId));
      if (result == "ALL_DELETED") {
        yield SuccessDeletePostState(event.postId, event.isProfile);
      }
    } catch (_) {
      yield ErrorDeletePostState("Error on delete post $_");
    }
  }
}
