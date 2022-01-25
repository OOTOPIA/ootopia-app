import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/app_usage_splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart'
    as model;

class NotificationMessageService {
  AppUsageSplashScreen appUsageSplashScreen = AppUsageSplashScreen();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  var locale;
  var language;

  void createMessage(RemoteMessage message) async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    message.data["usersName"] = jsonDecode(message.data["usersName"]);
    final notification = model.NotificationModel.fromJson(message.data);

    await setLanguage();
    setLocale();

    String title = await getNotificationTitle(notification.type,
        oozReceived: notification.oozAmount);
    String body =
        await getNotificationBody(notification.type, notification.usersName);
    String buttonText = await getNotificationButtonText();

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: message.hashCode,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          largeIcon: notification.photoURL,
          icon: 'resource://mipmap/ic_launcher',
          payload: {"postId": notification.postId}),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: buttonText,
          color: Color(0xFF003694),
        ),
      ],
    );
  }

  getUserData() async {
    bool loggedIn = await userRepository.getUserIsLoggedIn();
    if (loggedIn) return await userRepository.getCurrentUser();
  }

  setLanguage() async {
    this.language = await appUsageSplashScreen.checkLanguageConfig();
  }

  setLocale() {
    this.locale = Locale(this.language.split("_").first);
  }

  Future<String> getNotificationTitle(String type,
      {String? oozReceived}) async {
    User? user = await getUserData();

    var formatOOz;
    if (oozReceived != null)
      formatOOz = formatNumber(double.parse(oozReceived), language);

    String titleText = "";

    AppLocalizations.delegate.load(this.locale).then((value) {
      if (type == "gratitude_reward")
        titleText = value.notificationTitleOOzReceived
            .replaceAll('%OOZ_RECEIVED%', '$formatOOz');
      else
        titleText = value.notificationTitleCommentedPost
            .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
    });

    return titleText;
  }

  Future<String> getNotificationBody(
      String type, List<String> usersName) async {
    String bodyText = "";

    AppLocalizations.delegate.load(this.locale).then((value) {
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
    String buttonText = "";

    AppLocalizations.delegate.load(this.locale).then((value) {
      buttonText = value.notificationButtonText;
    });

    return buttonText;
  }

  formatNumber(double number, String locale) =>
      NumberFormat("###.00", locale).format(number);
}
