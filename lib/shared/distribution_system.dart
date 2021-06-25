import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_provider.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OOzDistributionSystem {
  static OOzDistributionSystem instance;

  final OOTOPIADatabase dbHelper = OOTOPIADatabase.init();
  final WatchVideoProvider watchVideoProvider = WatchVideoProvider();

  String prefsUploadingWatchedVideo = "uploading_watched_posts";

  OOzDistributionSystem();

  static getInstance() {
    if (instance == null) {
      instance = OOzDistributionSystem();
    }

    return instance;
  }

  startTimelineView() async {
    print(">>>>>>>>>>>> START STATE");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('uploading_watched_posts', false);
    this.sendWatchedPostsToServer();
  }

  endTimelineView(String state) async {
    print(">>>>>>>>>>>> CURRENT STATE $state");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state == "detached") {
      await prefs.setBool(prefsUploadingWatchedVideo, false);
    }
  }

  distributionWatchVideo(
      {String postId, int timeInMilliseconds, int durationInMs}) async {
    try {
      if (timeInMilliseconds < 100) {
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool uploadingWatchedPosts = false;
      if (prefs.getBool(prefsUploadingWatchedVideo) == true) {
        uploadingWatchedPosts = true;
      } else {
        uploadingWatchedPosts = false;
      }
      WatchVideoModel watchVideo = await watchVideoProvider.getByPostId(postId);

      if (uploadingWatchedPosts) {
        return;
      }

      if (watchVideo == null) {
        final newWatchVideo = await watchVideoProvider
            .insert(WatchVideoModel(postId, timeInMilliseconds, durationInMs));
      } else {
        int watched = (timeInMilliseconds >= durationInMs ? 1 : 0);
        if ((timeInMilliseconds < watchVideo.timeInMilliseconds) ||
            timeInMilliseconds >= durationInMs) {
          final newWatchVideo = await watchVideoProvider.insert(WatchVideoModel(
              postId, timeInMilliseconds, durationInMs, watched));
        } else {
          watchVideo.timeInMilliseconds = timeInMilliseconds;
          watchVideo.watched = watched;
          await watchVideoProvider.update(watchVideo);
          watchVideo = await watchVideoProvider.getByPostId(postId);
        }
      }
    } catch (err) {
      print("Erro!!!!! " + err.toString());
    }
  }

  sendWatchedPostsToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var _watchVideoProvider = WatchVideoProvider();
    var _postsRepository = PostRepositoryImpl();

    List<WatchVideoModel> watchedPosts =
        await _watchVideoProvider.getNotUploadedPosts();

    if (watchedPosts.length <= 0) {
      return;
    }

    await prefs.setBool(prefsUploadingWatchedVideo, true);

    await _postsRepository.recordWatchedPosts(watchedPosts);

    for (WatchVideoModel watchedPost in watchedPosts) {
      try {
        watchedPost.uploaded = 1;
        await _watchVideoProvider.update(watchedPost);
      } catch (err) {
        watchedPost.uploaded = 0;
        await _watchVideoProvider.update(watchedPost);
      }
    }

    await prefs.setBool('uploading_watched_posts', false);
  }
}
