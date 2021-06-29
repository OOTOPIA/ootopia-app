import 'package:flutter/foundation.dart';

enum Page {
  timelineScreen,
  timelineProfileScreen,
  commentScreen,
  profileScreen,
  myProfileScreen,
  registerScreen,
  loginScreen,
  cameraScreen,
  registerPhase2Screen,
  registerPhase2DailyLearningGoalScreen,
  registerPhase2GeolocationScreen,
  registerPhase2TopInterestsScreen,
  playerVideoFullScreen,
  menuProfile,
  postPreviewScreen,
  recoverPasswordScreen,
  resetPasswordScreen
}

extension PageRoute on Page {
  String get route => describeEnum(this);
}
