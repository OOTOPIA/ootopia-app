import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/shared/distribution_system.dart';
import 'dart:math';

class FlickMultiManager {
  List<FlickManager> _flickManagers = [];
  FlickManager? _activeManager;
  bool _isMute = false;
  OOzDistributionSystem distributionSystem =
      OOzDistributionSystem.getInstance();

  init(FlickManager flickManager, [String? userId, String? postId]) {
    _flickManagers.add(flickManager);
    if (_isMute) {
      flickManager.flickControlManager!.mute();
    } else {
      flickManager.flickControlManager!.unmute();
    }
    if (userId != null &&
        postId != null &&
        !flickManager.flickVideoManager!.hasListeners) {
      flickManager.flickVideoManager!.addListener(() {
        var videoPlayerValue =
            flickManager.flickVideoManager!.videoPlayerValue!;
        if (videoPlayerValue.position.inMilliseconds > 0) {
          var creationTimeInMs = (new DateTime.now().millisecondsSinceEpoch);
          Timer(Duration(milliseconds: (new Random()).nextInt(1000) + 100), () {
            distributionSystem.distributionWatchVideo(
              userId: userId,
              postId: postId,
              timeInMilliseconds: videoPlayerValue.position.inMilliseconds,
              durationInMs: videoPlayerValue.duration.inMilliseconds,
              creationTimeInMs: creationTimeInMs,
            );
          });
        }
      });
      play(flickManager);
    }
  }

  remove(FlickManager flickManager) {
    if (_activeManager == flickManager) {
      _activeManager = null;
    }
    flickManager.dispose();
    _flickManagers.remove(flickManager);
  }

  togglePlay(FlickManager flickManager) {
    if (_activeManager?.flickVideoManager?.isPlaying == true &&
        flickManager == _activeManager) {
      pause();
    } else {
      play(flickManager);
    }
  }

  pause() {
    _activeManager?.flickControlManager?.pause();
  }

  play([FlickManager? flickManager]) {
    if (flickManager != null) {
      _activeManager?.flickControlManager?.pause();
      _activeManager = flickManager;
    }

    if (_isMute) {
      _activeManager?.flickControlManager?.mute();
    } else {
      _activeManager?.flickControlManager?.unmute();
    }

    _activeManager?.flickControlManager?.play();
  }

  toggleMute() {
    _activeManager?.flickControlManager?.toggleMute();
    _isMute = _activeManager?.flickControlManager?.isMute == null
        ? false
        : _activeManager!.flickControlManager!.isMute;
    if (_isMute) {
      _flickManagers.forEach((manager) => manager.flickControlManager!.mute());
    } else {
      _flickManagers
          .forEach((manager) => manager.flickControlManager!.unmute());
    }
  }
}
