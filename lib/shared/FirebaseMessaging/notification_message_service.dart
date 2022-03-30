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
import 'package:ootopia_app/theme/light/colors.dart';

class NotificationMessageService {
  AppUsageSplashScreen appUsageSplashScreen = AppUsageSplashScreen();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  var locale;
  var language;

  void createMessage(RemoteMessage message) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

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
        icon: 'resource://mipmap/notification_icon',
        notificationLayout: NotificationLayout.BigText,
        color: LightColors.blue,
        backgroundColor: LightColors.blue,
        payload: {"postId": notification.postId, "type": notification.type},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'accept',
          label: buttonText,
          color: LightColors.blue,
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
    AppLocalizations value = await AppLocalizations.delegate.load(this.locale);
    if (type == 'user-tagged-in-comment') {
      return value.userComment;
    } else if (type == 'user-tagged-in-post') {
      return value.notificationTitleCommentedPost
          .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
    } else if (type == 'user-tagged-in-comment-reply') {
      return value.notificationTitleCommentedPost
          .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
    } else if (type == "gratitude_reward") {
      return value.notificationTitleOOzReceived
          .replaceAll('%OOZ_RECEIVED%', '$formatOOz');
    } else {
      return value.notificationTitleCommentedPost
          .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
    }
  }

  Future<String> getNotificationBody(
      String type, List<String>? usersName) async {
    AppLocalizations value = await AppLocalizations.delegate.load(this.locale);

    if (type == 'user-tagged-in-comment') {
      return value.userComment;
    } else if (type == 'user-tagged-in-post') {
      return "${usersName!.first} " + value.repliedToYourComment;
    } else if (type == 'user-tagged-in-comment-reply') {
      return "${usersName!.first} " + value.repliedToYourComment;
    } else if (type == "gratitude_reward") {
      if (usersName!.length == 1) {
        return value.notificationBodyOOzReceivedByOnePerson
            .replaceAll('%USER_NAME%', '${usersName.first}');
      } else {
        return value.notificationBodyOOzReceivedBySomePeople
            .replaceAll('%USER_NAME%', '${usersName.last}')
            .replaceAll(
                '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
      }
    } else {
      if (usersName!.length == 1) {
        return value.notificationBodyCommentedPostByOnePerson
            .replaceAll('%USER_NAME%', '${usersName.first}');
      } else {
        return value.notificationBodyCommentedPostBySomePeople
            .replaceAll('%USER_NAME%', '${usersName.last}')
            .replaceAll(
                '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
      }
    }
  }

  Future<String> getNotificationButtonText() async {
    String buttonText = "";

    AppLocalizations.delegate.load(this.locale).then((value) {
      buttonText = value.notificationButtonText;
    });

    return buttonText;
  }

  formatNumber(double number, String locale) =>
      NumberFormat("###,###,###.00", locale).format(number);
}
