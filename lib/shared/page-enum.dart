import 'package:flutter/foundation.dart';

enum Page {
  homeScreen,
  timelineScreen,
  timelineProfileScreen,
  commentScreen,
  profileScreen,
  myProfileScreen,
  registerFormScreen,
  loginScreen,
  cameraScreen,
  registerPhoneNumberScreen,
  registerDailyLearningGoalScreen,
  registerGeolocationScreen,
  registerTopInterestsScreen,
  playerVideoFullScreen,
  menuProfile,
  postPreviewScreen,
  recoverPasswordScreen,
  resetPasswordScreen,
  splashScreen,
  celebration,
  walletPage,
  regenerationGameLearningAlert,
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
  initialScreen,
  aboutOOzCurrentScreen,
  aboutEthicalMarketPlace,
  addLink,
  addFriends,
  viewLinksScreen,
  circleFriends
}

extension PageRoute on Page {
  String get route => describeEnum(this);
}
