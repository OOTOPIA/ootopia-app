import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/app_usage_splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart' as model;

class NotificationMessageService {
  AppUsageSplashScreen appUsageSplashScreen = AppUsageSplashScreen();
  UserRepositoryImpl userRepository = UserRepositoryImpl();

  void createMessage(RemoteMessage message) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    message.data["usersName"] = jsonDecode(message.data["usersName"]);
    final notification = model.NotificationModel.fromJson(message.data);

    String title = await getNotificationTitle(notification.type,
        oozReceived: notification.oozAmount);
    String body =
        await getNotificationBody(notification.type, notification.usersName);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        largeIcon: notification.photoURL,
        icon: 'resource://mipmap/ic_launcher',
        payload: {"postId": notification.postId}
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: 'Accept',
        ),
      ],
    );
  }

  getUserData() async {
    bool loggedIn = await userRepository.getUserIsLoggedIn();
    if (loggedIn) return await userRepository.getCurrentUser();
  }

  languageLocale() async {
    String language = await appUsageSplashScreen.checkLanguageConfig();
    return Locale(language);
  }

  Future<String> getNotificationTitle(String type,
      {String? oozReceived}) async {
    Locale locale = await languageLocale();
    User? user = await getUserData();

    String titleText = "";

    AppLocalizations.delegate.load(locale).then((value) {
      if (type == "gratitude_reward")
        titleText = value.notificationTitleOOzReceived
            .replaceAll('%OOZ_RECEIVED%', '$oozReceived');
      else
        titleText = value.notificationTitleCommentedPost
            .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
    });

    return titleText;
  }

  Future<String> getNotificationBody(
      String type, List<String> usersName) async {
    Locale locale = await languageLocale();

    String bodyText = "";

    AppLocalizations.delegate.load(locale).then((value) {
      if (type == "gratitude_reward") {
        if (usersName.length == 1)
          bodyText = value.notificationBodyOOzReceivedByOnePerson
              .replaceAll('%USER_NAME%', '${usersName.first}');
        else
          bodyText = value.notificationBodyOOzReceivedBySomePeople
              .replaceAll('%USER_NAME%', '${usersName.last}')
              .replaceAll(
                  '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
      } else {
        if (usersName.length == 1)
          bodyText = value.notificationBodyCommentedPostByOnePerson
              .replaceAll('%USER_NAME%', '${usersName.first}');
        else
          bodyText = value.notificationBodyCommentedPostBySomePeople
              .replaceAll('%USER_NAME%', '${usersName.last}')
              .replaceAll(
                  '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
      }
    });

    return bodyText;
  }

    Future<String> getNotificationButtonText() async {
    Locale locale = await languageLocale();
    User? user = await getUserData();

    String buttonText = "";

    AppLocalizations.delegate.load(locale).then((value) {
      buttonText = value.notificationButtonText;
    });

    return buttonText;
  }
}
