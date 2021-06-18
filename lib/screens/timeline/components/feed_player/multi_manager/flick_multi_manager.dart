import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/shared/distribution_system.dart';

class FlickMultiManager {
  List<FlickManager> _flickManagers = [];
  FlickManager _activeManager;
  bool _isMute = false;
  OOzDistributionSystem distributionSystem =
      OOzDistributionSystem.getInstance();

  init(FlickManager flickManager) {
    _flickManagers.add(flickManager);
    if (_isMute) {
      flickManager?.flickControlManager?.mute();
    } else {
      flickManager?.flickControlManager?.unmute();
    }
    if (_flickManagers.length == 1) {
      flickManager.flickVideoManager.addListener(() {
        distributionSystem.distributionWatchVideo(
          positionInMs: flickManager
              .flickVideoManager.videoPlayerValue.position.inMilliseconds,
          durationInMs: flickManager
              .flickVideoManager.videoPlayerValue.duration.inMilliseconds,
        );
        //print("<----------------------------->");
        //print("Milisegundos ${flickManager.flickVideoManager.videoPlayerValue.position.inMilliseconds}");
        //print("Chamado position ${flickManager.flickVideoManager.videoPlayerValue.position}");
        //print("Chamado duration ${flickManager.flickVideoManager.videoPlayerValue.duration.inMilliseconds}");
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

  play([FlickManager flickManager]) {
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
    _isMute = _activeManager?.flickControlManager?.isMute;
    if (_isMute) {
      _flickManagers.forEach((manager) => manager.flickControlManager.mute());
    } else {
      _flickManagers.forEach((manager) => manager.flickControlManager.unmute());
    }
  }
}
