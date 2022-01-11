import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
      final teste = NotificationModel.fromJson(event.data);
      print(teste);
      if (event.data != {} || event.data != null) {
          flutterLocalNotificationsPlugin.show(
            teste.hashCode,
            teste.userName,
            teste.comments,
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
}