import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/post/post_create_model.dart';
import 'package:ootopia_app/data/models/post/post_gallery_create_model.dart';
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

  _createPost(PostCreate post) async {
    return await this._repository.createPost(post);
  }

  _sendMedia(String type, File file) async {
    return await this._repository.sendMedia(type, file);
  }

  _sendPost(PostGalleryCreateModel model) async {
    return await this._repository.sendPost(model);
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
  Future<dynamic> createPost(PostCreate post, double oozToRewardForVideo,
      double oozToRewardForImage) async {
    try {
      uploadIsLoading = true;
      var result = await this._createPost(post);
      if (post.durationInSecs != null && post.type == "video") {
        oozToReward = oozToRewardForVideo;
      } else if (post.type == "image") {
        oozToReward = oozToRewardForImage;
      }
      this._trackingEvents.timelineCreatedAPost(post.type!);
      uploadIsLoading = false;
      successOnUpload = true;
    } catch (err) {
      print("erro aqui $err");
      errorOnUpload = true;
      uploadIsLoading = false;
    }
  }

  @action
  Future<dynamic> sendMedia(
      List<Map> fileList, PostGalleryCreateModel model) async {
    List<String> mediaIds = [];
    for (var file in fileList) {
      try {
        uploadIsLoading = true;
        var result =
            await this._sendMedia(file["mediaType"], file["mediaFile"]);

        mediaIds.add(result.data["mediaId"]);
      } catch (err) {
        print("erro aqui $err");
        errorOnUpload = true;
        uploadIsLoading = false;
        return;
      }
    }
    model.mediaIds = mediaIds;
    sendPost(model);
  }

  @action
  Future<dynamic> sendPost(PostGalleryCreateModel model) async {
    try {
      uploadIsLoading = true;
      var result = await this._sendPost(model);

      print('RESPONSE:: $result');
      // print('TESTE: ${result.body["oozGenerated"]}');
      //this._trackingEvents.timelineCreatedAPost(post.type!);
      //oozToReward = result.body["oozGenerated"];
      uploadIsLoading = false;
      successOnUpload = true;
      print('AAAAAAAA $successOnUpload');
    } catch (err) {
      print("erro aqui2 $err");
      errorOnUpload = true;
      uploadIsLoading = false;
    }
  }
}
