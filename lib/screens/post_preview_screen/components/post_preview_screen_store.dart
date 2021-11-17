import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/hashtage_widget.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
part 'post_preview_screen_store.g.dart';

class PostPreviewScreenStore = _PostPreviewScreenStoreBase
    with _$PostPreviewScreenStore;

abstract class _PostPreviewScreenStoreBase with Store {
  AnalyticsTracking _trackingEvents = AnalyticsTracking.getInstance();
  PostRepositoryImpl _repository = PostRepositoryImpl();

  @observable
  ObservableList<InterestsTagsModel> selectedTags =
      ObservableList<InterestsTagsModel>();
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

  @observable
  String filterValue = "";

  @observable
  bool isSelected = false;

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
  void addItem(dynamic item) => selectedTags.add(item);

  @action
  void removeItem(dynamic item) => selectedTags.remove(item);

  @action
  bool hasTagInList(MultiSelectItem<InterestsTagsModel> item) {
    bool tagExists = false;

    for (InterestsTagsModel a in selectedTags) {
      if (a.name == item.label) tagExists = true;
    }
    return tagExists;
  }

  @action
  List<HashtagWidget> filterTagsPerName(List<HashtagWidget> allTags) {
    List<HashtagWidget> filteredtagsList = [];

    filteredtagsList = allTags
        .where((hashtagWidget) => hashtagWidget.item.label
            .toLowerCase()
            .contains(filterValue.toLowerCase()))
        .toList();
    filteredtagsList.map((item) => item).toList();

    return filteredtagsList;
  }

  @action
  void onFilterTagChanged(String value) {
    filterValue = value;
  }

  @action
  void clearhashtags() {
    selectedTags.clear();
    filterValue = "";
  }

  @action
  Future<dynamic> createPost(PostCreate post) async {
    try {
      uploadIsLoading = true;
      var result = await this._createPost(post);
      double oozToRewardForVideo = 10;
      double oozToRewardForImage = 5;
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
