import 'package:flutter/foundation.dart';

enum Page {
  timelineScreen,
  timelineProfileScreen,
  commentScreen,
  profileScreen,
  registerScreen,
  loginScreen,
  cameraScreen,
  registerPhase2Screen,
  registerPhase2DailyLearningGoalScreen,
  registerPhase2GeolocationScreen,
  registerPhase2TopInterestsScreen,
  playerVideoFullScreen,
  menuProfile,
  postPreviewScreen
}

extension PageRoute on Page {
  String get route => describeEnum(this);
}
