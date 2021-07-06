import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'ooz_distribution_controller.g.dart';

class OOZDistributionController = OOZDistributionControllerBase
    with _$OOZDistributionController;

abstract class OOZDistributionControllerBase with Store {
  @observable
  String? postId = "";

  @observable
  String? userId;

  @observable
  int? timeInMilliseconds = 0;

  @observable
  int? durationInMs = 0;

  @observable
  int? creationTimeInMs = 0;

  @observable
  bool _created = false;

  OOZDistributionControllerBase({
    this.postId,
    this.userId,
    this.timeInMilliseconds,
    this.durationInMs,
    this.creationTimeInMs,
  });

  @action
  updateVideoPosition(String postId, String userId, int timeInMilliseconds,
      int durationInMs, int creationTimeInMs) async {
    bool update = false;
    bool create = false;
    if (this.timeInMilliseconds != null &&
        timeInMilliseconds > this.timeInMilliseconds!) {
      update = true;
    } else if (this.timeInMilliseconds != null &&
        timeInMilliseconds < this.timeInMilliseconds!) {
      create = true;
      print("OLD ${this.timeInMilliseconds} AND NEW $timeInMilliseconds");
      this._created = false;
    }

    int watched = (timeInMilliseconds >= (durationInMs - 500) ||
            (this.timeInMilliseconds != null &&
                timeInMilliseconds < this.timeInMilliseconds!)
        ? 1
        : 0);

    this.postId = postId;
    this.userId = userId;
    this.timeInMilliseconds = timeInMilliseconds;
    this.durationInMs = durationInMs;
    this.creationTimeInMs = creationTimeInMs;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool uploadingWatchedPosts = false;
    if (prefs.getBool("uploading_watched_posts") == true) {
      uploadingWatchedPosts = true;
    } else {
      uploadingWatchedPosts = false;
    }

    if (uploadingWatchedPosts) {
      return;
    }

    WatchVideoProvider watchVideoProvider = WatchVideoProvider();

    WatchVideoModel? watchVideo =
        (await watchVideoProvider.getByPostId(postId));

    if (create && !_created && watchVideo == null) {
      this._created = true;
      print("HEY HEY HEY CREATE THIS NOW");
      watchVideoProvider.insert(WatchVideoModel(
        userId: userId,
        postId: postId,
        timeInMilliseconds: timeInMilliseconds,
        durationInMs: durationInMs,
        watched: 0,
        uploaded: 0,
        createdAtInMs: creationTimeInMs,
      ));
    } else if (update && watchVideo != null) {
      print("HEY I'LL UPDATE THIS");
      watchVideo.timeInMilliseconds = timeInMilliseconds;
      watchVideo.watched = watched;
      await watchVideoProvider.update(watchVideo);
    }
    print(
        "THIS IS CURRENT DATA $postId: $timeInMilliseconds; $durationInMs; $creationTimeInMs");
  }
}
