import 'package:flutter/foundation.dart';

enum Page {
  homeScreen,
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
  resetPasswordScreen,
  splashScreen,
  celebration,
  profile,
  regenerarionGameLearningAlert,
  chatWithUsersScreen,
  invitationScreen,
  insertInvitationCode,
  termsOfUseScreen,
  privacyPolicyScreen,
  editProfileScreen,
  newFutureCategories,
  viewLearningTracksScreen,
  aboutQuizScreen,
  videoLearningTracksScreen,
  aboutOOzCurrentScreen,
}

extension PageRoute on Page {
  String get route => describeEnum(this);
}
