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
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:smart_page_navigation/smart_page_navigation.dart';

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  User? user;
  BuildContext? context;
  String? payload;
  String? token;

  static PushNotification getInstance() {
    if (_instance == null) {
      _instance = PushNotification();
    }
    return _instance!;
  }

  currentUserData() async {
    bool loggedIn = await storage.getUserIsLoggedIn();
    if (loggedIn) user = await storage.getCurrentUser();
  }

  PushNotification() {
    _firebaseMessaging.getNotificationSettings();
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    currentUserData();

    Future.delayed(Duration.zero, () async {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettingsIOs = IOSInitializationSettings();

      var initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);

      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();

      payload = notificationAppLaunchDetails!.payload;

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: selectNotification);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    });
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) await getPost(payload);
  }

  setContext(BuildContext context) => this.context = context;

  void listenerFirebaseCloudMessagingToken() async {
    token = await _firebaseMessaging.getToken();
    if (await storage.getCurrentUser() != null && token != null) {
      await this.userRepository.updateTokenDeviceUser(token!);
    }

    _firebaseMessaging.onTokenRefresh
        .asBroadcastStream()
        .listen((_token) async {
      token = _token;

      if (await storage.getCurrentUser() != null) {
        await this.userRepository.updateTokenDeviceUser(token!);
      }
    });
  }

  void listenerFirebaseCloudMessagingMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      event.data["usersName"] = jsonDecode(event.data["usersName"]);
      final notification = NotificationModel.fromJson(event.data);

      String title = getNotificationTitle(notification.type,
          oozReceived: notification.oozAmount);
      String body =
          getNotificationBody(notification.type, notification.usersName);

      ByteArrayAndroidBitmap? bigIcon =
          await _turnPhotoURLIntoBitmap(notification.photoURL!);



      if (event.data != null || event.data != {}) {
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
            iOS:  IOSNotificationDetails()
          ),


          payload: notification.postId,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await getPost(message.data["postId"]);
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

  String getNotificationTitle(String type, {String? oozReceived}) {
    if (type == "gratitude_reward")
      return AppLocalizations.of(context!)!
          .notificationTitleOOzReceived
          .replaceAll('%OOZ_RECEIVED%', '$oozReceived');
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
            .notificationBodyCommentedPostBySomePeople
            .replaceAll('%USER_NAME%', '${usersName.last}')
            .replaceAll(
                '%PEOPLE_AMOUNT%', '${(usersName.length - 1).toString()}');
    }
  }

  goToTimelinePost(List<TimelinePost> posts) {
    SmartPageController controller = SmartPageController.getInstance();
    controller.insertPage(
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


  // showIOSnotification() async{
  //   print("ios notificatuib");
  //   var android = new AndroidNotificationDetails(
  //       'id', 'channel ',
  //       priority: Priority.high, importance: Importance.max);
  //   var iOS = new IOSNotificationDetails();
  //   var platform = new NotificationDetails(android: android, iOS: iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
  //       payload: 'Welcome to the Local Notification demo ');
  // }
}
