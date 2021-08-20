import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
part 'post_preview_screen_store.g.dart';

class PostPreviewScreenStore = _PostPreviewScreenStoreBase
    with _$PostPreviewScreenStore;

abstract class _PostPreviewScreenStoreBase with Store {
  AnalyticsTracking _trackingEvents = AnalyticsTracking.getInstance();
  PostRepositoryImpl _repository = PostRepositoryImpl();

  @observable
  bool uploadIsLoading = false;

  @observable
  bool tagsIsLoading = false;

  @observable
  bool errorOnGetTags = false;

  @observable
  bool errorOnUpload = false;

  @observable
  bool successOnUpload = false;

  @observable
  double oozToReward = 0;

  Future<dynamic> _createPost(PostCreate post) async {
    //FlutterUploader().setBackgroundHandler(_backgroundHandler);
    var completer = new Completer();
    var uploader = FlutterUploader();

    await this._repository.createPost(uploader, post);
    uploader.progress.listen((event) {
      if (event.progress != null &&
          event.progress! >= 100 &&
          !completer.isCompleted) {
        completer.complete();
      }
    });
    uploader.result.listen((result) {}, onDone: () {}, onError: (error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  @action
  Future<dynamic> createPost(PostCreate post) async {
    try {
      uploadIsLoading = true;
      var result = await this._createPost(post);
      double oozToRewardForVideo = 25;
      double oozToRewardForImage = 15;
      if (post.durationInSecs != null && post.type == "video") {
        oozToReward = oozToRewardForVideo * (post.durationInSecs! / 60);
      } else if (post.type == "image") {
        oozToReward = oozToRewardForImage;
      }
      this._trackingEvents.timelineCreatedAPost(post.type!);
      uploadIsLoading = false;
      successOnUpload = true;
      return result;
    } catch (err) {
      errorOnUpload = true;
      uploadIsLoading = false;
    }
  }

  void _backgroundHandler() {
    WidgetsFlutterBinding.ensureInitialized();
  }
}
