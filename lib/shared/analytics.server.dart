import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';

class AnalyticsTracking {
  final Amplitude analytics = Amplitude.getInstance(instanceName: "OOTOPIA");
  static AnalyticsTracking? instance;

  AnalyticsTracking() {
    analytics.init(dotenv.env["AMPLITUDE_KEY"]!);
  }

  static getInstance() {
    if (instance == null) {
      instance = AnalyticsTracking();
    }

    return instance;
  }

  trackingDataUser(Identify identify) async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    identify.set("AppVersion", "${info.version}+${info.buildNumber}");
    analytics.identify(identify);
  }

  trackingEvent(String eventName, property) {
    analytics.logEvent(eventName, eventProperties: property);
  }

  trackingOpenedApp() {
    this.trackingEvent("Open App", null);
  }

  trackingClosedApp() {
    this.trackingEvent("Close App", null);
  }

  trackingLoggedIn(String userId, String name) {
    analytics.setUserId(userId);
    final Identify identify = Identify()..set('Name', name);
    this.trackingDataUser(identify);
    this.trackingEvent("Logged in", null);
  }

  trackingLoggedOut() {
    this.trackingEvent("Logged out", null);
    analytics.setUserId(null);
    analytics.regenerateDeviceId();
  }

  trackingSignupStartedSignup() {
    this.trackingEvent("Signup - Started signup", null);
  }

  trackingSignupCompletedSignup(String userId, String name) {
    analytics.setUserId(userId);
    final Identify identify = Identify()..set('Name', name);
    this.trackingDataUser(identify);
    this.trackingEvent("Signup - Completed signup", null);
  }

  signupCompletedInvitationCode(property) {
    this.trackingEvent("Signup - Completed Invitation Code", property);
  }

  signupCompletedEmail(property) {
    this.trackingEvent("Signup - Completed Email", property);
  }

  signupCompletedPhoneNumber(property) {
    this.trackingEvent("Signup - Completed Phone Number", property);
  }

  signupCompletedDailyLearning(property) {
    this.trackingEvent("Signup - Completed Daily Learning", property);
  }

  signupCompletedGeolocation(property) {
    this.trackingEvent("Signup - Completed Geolocation", property);
  }

  signupCompletedStepIVOfSignupII(property) {
    this.trackingEvent("Signup - Completed step IV of signup II", property);
  }

  signupConcludeButton() {
    this.trackingEvent("Signup - Clicked at Conclude button", null);
  }

  signupWatchedTheTutorial(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  signupSetTheGameGoals(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  signupCompletedSignupPartII() {
    this.trackingEvent("Signup - Completed signup part II", null);
  }

  userRecoverPassword() {
    this.trackingEvent("Recover Password - Password recovery email sent", null);
  }

  userResetPassword() {
    this.trackingEvent("Reset Password - Password changed", null);
  }

  profileCreateAlbum() {
    this.trackingEvent("Profile - Create album", null);
  }

  learningTracksQuiz() {
    this.trackingEvent("Learning tracks - Quiz", null);
  }

  creteOfferMarketPlace() {
    this.trackingEvent("Create Offer - MarketingPlace", null);
  }

  timelineCreatedAPost(String type) {
    final Identify identify = Identify()..add('Content posted', 1);
    this.trackingDataUser(identify);
    this.trackingEvent("Timeline - Created a post", {
      type: type,
    });
  }

  timelineGaveALike(property) {
    final Identify identify = Identify()..add('Likes given', 1);
    this.trackingDataUser(identify);
    this.trackingEvent("Timeline - Gave a like", property);
  }

  timelineGaveADislike(property) {
    final Identify identify = Identify()..add('Likes given', -1);
    this.trackingDataUser(identify);
    this.trackingEvent("Timeline - Gave a dislike", property);
  }

  timelineViewedComments(property) {
    this.trackingEvent("Timeline - Viewed comments", property);
  }

  timelineDonatedOOZ() {
    this.trackingEvent("Timeline - Donated OOz", null);
  }

  timelineDidAComment(property, postId) {
    final Identify identify = Identify()
      ..set("PostId", postId)
      ..add('Comments made', 1);
    this.trackingDataUser(identify);
    this.trackingEvent("Timeline - Did a comment", property);
  }

  timelineDonatedOOz(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  timelineViewedAPost(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  gameCompletedPersonalGoal(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  gameCompletedCityGoal(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  gameCompletedGlobalGoal(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  profileEditedAProfile(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  profileViewedAProfile(eventName, property) {
    this.trackingEvent(eventName, property);
  }

  notificationReceived(property) {
    this.trackingEvent("Notification - Received notification", property);
  }

  notificationClicked(property) {
    this.trackingEvent("Notification - Clicked notification", property);
  }
}
