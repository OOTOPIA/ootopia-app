import 'dart:convert';
import 'dart:io';
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
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:smart_page_navigation/smart_page_navigation.dart';

class PushNotificationBackground {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();
  SmartPageController? controller;
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  User? user;
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
      bool loggedIn = await storage.getUserIsLoggedIn();
      if (loggedIn) user = await storage.getCurrentUser();
    });

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

      String title = getNotificationTitle(notification.type);
      String body =
          getNotificationBody(notification.type, notification.usersName);

      ByteArrayAndroidBitmap? bigIcon =
          await _turnPhotoURLIntoBitmap(notification.photoURL!);

      if (message.data != {} || message.data != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          "title",
          "body",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.white,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              largeIcon: bigIcon!,
              styleInformation: BigTextStyleInformation("body"),
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

  String getNotificationTitle(String type, {int? oozReceived}) {
     return "";
    // if (type == "gratitude_reward")
    //   return AppLocalizations.of(context!)!
    //       .notificationTitleOOzReceived
    //       .replaceAll('%OOZ_RECEIVED%', '${oozReceived.toString()}');
    // else
    //   return AppLocalizations.of(context!)!
    //       .notificationTitleCommentedPost
    //       .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
  }

  String getNotificationBody(String type, List<String> usersName) {
    return "";
    // if (type == "gratitude_reward") {
    //   if (usersName.length == 1)
    //     return AppLocalizations.of(context!)!
    //         .notificationBodyOOzReceivedByOnePerson
    //         .replaceAll('%USER_NAME%', '${usersName.first}');
    //   else
    //     return AppLocalizations.of(context!)!
    //         .notificationBodyOOzReceivedBySomePeople
    //         .replaceAll('%USER_NAME%', '${usersName.last}')
    //         .replaceAll(
    //             '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
    // } else {
    //   if (usersName.length == 1)
    //     return AppLocalizations.of(context!)!
    //         .notificationBodyCommentedPostByOnePerson
    //         .replaceAll('%USER_NAME%', '${usersName.first}');
    //   else
    //     return AppLocalizations.of(context!)!
    //         .notificationBodyCommentedPostBySomePeople
    //         .replaceAll('%USER_NAME%', '${usersName.last}')
    //         .replaceAll(
    //             '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
    // }
  }

  goToTimelinePost(List<TimelinePost> posts) {
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
    goToTimelinePost([post].toList());
  }
}
