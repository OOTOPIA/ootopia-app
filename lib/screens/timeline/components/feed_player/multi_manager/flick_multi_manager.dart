import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
//import 'package:ootopia_app/shared/distribution_system.dart';
import 'package:ootopia_app/shared/ooz_distribution/ooz_distribution_service.dart';

class FlickMultiManager {
  List<FlickManager> _flickManagers = [];
  FlickManager? _activeManager;
  bool _isMute = false;
  //OOzDistributionSystem distributionSystem = OOzDistributionSystem.getInstance();

  void init(FlickManager flickManager, [String? userId, String? postId]) {
    _flickManagers.add(flickManager);
    if (_isMute) {
      flickManager.flickControlManager!.mute();
    } else {
      flickManager.flickControlManager!.unmute();
    }
    if (userId != null &&
        postId != null &&
        !flickManager.flickVideoManager!.videoPlayerValue!.isInitialized &&
        OOZDistributionService.getInstance().distributionData[postId] == null) {
      // flickManager.flickVideoManager!.addListener(() {
      //   // Timer.periodic(Duration(seconds: 3), (timer) async {
      //   //   print('postId $postId');
      //   // });
      //   var videoPlayerValue =
      //   flickManager.flickVideoManager!.videoPlayerValue!;
      //   if (videoPlayerValue.position.inMilliseconds > 0) {
      //     var creationTimeInMs = (new DateTime.now().millisecondsSinceEpoch);
      //     OOZDistributionService.getInstance().updateVideoPosition(
      //       postId,
      //       userId,
      //       videoPlayerValue.position.inMilliseconds,
      //       videoPlayerValue.duration.inMilliseconds,
      //       creationTimeInMs,
      //     );
      //   }
      // });
      play(flickManager);
    }
  }

  void remove(FlickManager flickManager) {
    if (_activeManager == flickManager) {
      _activeManager = null;
    }
    //flickManager.dispose();
    _flickManagers.remove(flickManager);
  }

  void togglePlay(FlickManager flickManager) {
    if (_activeManager?.flickVideoManager?.isPlaying == true &&
        flickManager == _activeManager) {
      pause();
    } else {
      play(flickManager);
    }
  }

  void pause() {
    _activeManager?.flickControlManager?.pause();
  }

  void play([FlickManager? flickManager]) {
    Future.delayed(Duration.zero, () {
      if (flickManager != null) {
        _activeManager?.flickControlManager?.pause();
        _activeManager = flickManager;
      }

      _activeManager?.flickControlManager?.play();

      _activeManager?.flickControlManager?.mute();
    });
  }

  void toggleMute() {
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
