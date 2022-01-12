import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  User? user;

  String? token;
  static PushNotification getInstace() {
    if (_instance == null) {
      _instance = PushNotification();
    }
    return _instance!;
  }

  PushNotification() {
    _firebaseMessaging.getNotificationSettings();
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

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    });
  }

  void listenerFirebaseCloudMessagingToken() async {
    token = await _firebaseMessaging.getToken();
    print("object pegou $token");
    if (await storage.getCurrentUser() != null && token != null) {
      await this.userRepository.updateTokenDeviceUser(token!);
    }

    _firebaseMessaging.onTokenRefresh
        .asBroadcastStream()
        .listen((_token) async {
      token = _token;
      print("object atualizou $token");

      if (await storage.getCurrentUser() != null) {
        await this.userRepository.updateTokenDeviceUser(token!);
      }
    });
  }

  void listenerFirebaseCloudMessagingMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("Message ${event.data}");
      final notification = NotificationModel.fromJson(event.data);
      print(notification);
      if (event.data != {} || event.data != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          getNotificationTitle(notification.type, amount: notification.amount),
          getNotificationBody(notification.type),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.white,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  String getNotificationTitle(String type, {int? amount}) {
    return "";
    // if (type == NotificationType.comments.toString().split(".").last)
      // return '${AppLocalizations.of(context)!.notificationTitleCommentedPost.replaceAll('%YOUR_NAME%', '${user?.fullname?.split(" ").first}')}';
    // else
      // return '${AppLocalizations.of(context)!.notificationTitleOOzReceived.replaceAll('%OOZ_RECEIVED%', '${amount!.toString()}')}';
  }

  String getNotificationBody(String type) {
    return "";
  }
}
