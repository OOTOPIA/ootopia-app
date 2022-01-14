import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  User? user;
  BuildContext? context;

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

  setContext(BuildContext context) => this.context = context;

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
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print("Message ${event.data}");
      event.data["usersName"] = jsonDecode(event.data["usersName"]);
      final notification = NotificationModel.fromJson(event.data);

      String longTextDescription =
          getNotificationBody(notification.type, notification.usersName);

      ByteArrayAndroidBitmap? bigIcon = await _turnPhotoURLIntoBitmap(notification.photoURL!);

      if (event.data != {} || event.data != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          getNotificationTitle(notification.usersName[0]),
          longTextDescription,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: Colors.white,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              largeIcon: bigIcon!,
              styleInformation: BigTextStyleInformation(longTextDescription),
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
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
    if (type == "gratitude_reward")
      return AppLocalizations.of(context!)!
          .notificationTitleOOzReceived
          .replaceAll('%OOZ_RECEIVED%', '${oozReceived.toString()}');
    else
      return AppLocalizations.of(context!)!
          .notificationTitleCommentedPost
          .replaceAll('%YOUR_NAME%', '${user!.fullname!.split(" ").first}');
  }

  String getNotificationBody(String type, List<String> usersName) {
    if (type == "gratitude_reward") {
      if (usersName.length == 1)
        return AppLocalizations.of(context!)!
            .notificationBodyOOzReceivedByOnePerson
            .replaceAll('%USER_NAME%', '${usersName.first}');
      else
        return AppLocalizations.of(context!)!
            .notificationBodyOOzReceivedBySomePeople
            .replaceAll('%USER_NAME%', '${usersName.last}')
            .replaceAll(
                '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
    } else {
      if (usersName.length == 1)
        return AppLocalizations.of(context!)!
            .notificationBodyCommentedPostByOnePerson
            .replaceAll('%USER_NAME%', '${usersName.first}');
      else
        return AppLocalizations.of(context!)!
            .notificationBodyOOzReceivedBySomePeople
            .replaceAll('%USER_NAME%', '${usersName.last}')
            .replaceAll(
                '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
    }
  }
}
