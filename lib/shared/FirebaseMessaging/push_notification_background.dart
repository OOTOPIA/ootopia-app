import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:ootopia_app/shared/app_usage_splash_screen.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:http/http.dart' as http;
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PushNotificationBackground {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();
  AppUsageSplashScreen appUsageSplashScreen = AppUsageSplashScreen();
  SmartPageController? controller;
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? payload;

  String? token;

  PushNotificationBackground() {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    Future.delayed(Duration.zero, () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();

      payload = notificationAppLaunchDetails!.payload;

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);
    });
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) await getPost(payload);
  }

  showNotificationOnBackground(RemoteMessage message) async {
    print("Message ${message.data}");
    message.data["usersName"] = jsonDecode(message.data["usersName"]);
    final notification = NotificationModel.fromJson(message.data);

    String title = await getNotificationTitle(notification.type);
    String body =
        await getNotificationBody(notification.type, notification.usersName);

    ByteArrayAndroidBitmap? bigIcon =
        await _turnPhotoURLIntoBitmap(notification.photoURL!);

    if (message.data != {} || message.data != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.white,
            channelDescription: channel.description,
            icon: '@mipmap/ic_launcher',
            largeIcon: bigIcon!,
            styleInformation: BigTextStyleInformation(body),
          ),
        ),
        payload: notification.postId,
      );
    }
  }

  _turnPhotoURLIntoBitmap(String photoURL) async {
    final ByteArrayAndroidBitmap largeIcon =
        ByteArrayAndroidBitmap(await _getByteArrayFromUrl(photoURL));
    return largeIcon;
  }

  Future<Uint8List> _getByteArrayFromUrl(String photoUrl) async {
    final http.Response response = await http.get(Uri.parse(photoUrl));
    return response.bodyBytes;
  }

  languageLocale() async {
    String language = await appUsageSplashScreen.checkLanguageConfig();
    return Locale(language);
  }

  Future<String> getNotificationTitle(String type, {int? oozReceived}) async {
    Locale locale = await languageLocale();
    User? user = await getUserData();

    String titleText = "";

    AppLocalizations.delegate.load(locale).then((value) {
      if (type == "gratitude_reward") {
        titleText = value.notificationTitleOOzReceived
            .replaceAll('%OOZ_RECEIVED%', '${oozReceived.toString()}');
      } else {
        titleText = value.notificationTitleCommentedPost
            .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
      }
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

  goToTimelinePost(List<TimelinePost> posts) async{
    User? user = await getUserData();
    controller?.insertPage(
      TimelineScreenProfileScreen(
        {
          "userId": user?.id,
          "posts": posts,
          "postSelected": 0,
        },
      ),
    );
  }

  getPost(String id) async {
    var post = await postsRepository.getPostById(id);
    await goToTimelinePost([post].toList());
  }

  getUserData() async{
    bool loggedIn = await userRepository.getUserIsLoggedIn();
    if (loggedIn) return await userRepository.getCurrentUser();
  }
}
