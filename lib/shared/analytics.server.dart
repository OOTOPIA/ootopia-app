import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  trackingDataUser(Identify identify) {
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

  signupStartedSignupPartII() {
    this.trackingEvent("Signup - Started signup part II", null);
  }

  signupCompletedStepIOfSignupII(property) {
    this.trackingEvent("Signup - Completed step I of signup II", property);
  }

  signupCompletedStepIIOfSignupII(property) {
    this.trackingEvent("Signup - Completed step II of signup II", property);
  }

  signupCompletedStepIIIOfSignupII(property) {
    this.trackingEvent("Signup - Completed step III of signup II", property);
  }

  signupCompletedStepIVOfSignupII(property) {
    this.trackingEvent("Signup - Completed step IV of signup II", property);
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

  timelineCreatedAPost() {
    final Identify identify = Identify()..add('Content posted', 1);
    this.trackingDataUser(identify);
    this.trackingEvent("Timeline - Created a post", null);
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
}
