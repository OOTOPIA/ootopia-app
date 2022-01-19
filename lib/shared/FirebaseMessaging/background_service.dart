import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ootopia_app/data/models/notifications/notification_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class BackgroundService {
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();
  SecureStoreMixin storage = SecureStoreMixin();
  SmartPageController? controller;
  User? user;

  BackgroundService(RemoteMessage message) {
    Future.delayed(Duration.zero, () async {
      bool loggedIn = await storage.getUserIsLoggedIn();
      if (loggedIn) user = await storage.getCurrentUser();
    });

    print("Message data ${message.data}");
    print("Message notification ${message.notification}");
    message.data["usersName"] = jsonDecode(message.data["usersName"]);
    final notification = NotificationModel.fromJson(message.data);
    print("Notification: ${notification.photoURL}");
    print("Notification: ${notification.type}");
    print("Notification: ${notification.usersName}");
    print("Notification: ${notification.postId}");
    print("Notification: ${notification.oozAmount}");

    Future.delayed(Duration.zero, () async {
      await getPost(notification.postId);
    });
  }

  getPost(String id) async {
    print("teste: $id");
    var post = await postsRepository.getPostById(id);
    goToTimelinePost([post].toList());
  }

  goToTimelinePost(List<TimelinePost>? post) {

   // Future.delayed(Duration(seconds: 20)).then((h){
    //  print("Deu 20 sec");
    //  print("post: ${post[0].id}");
    //   controller?.insertPage(
    //     TimelineScreenProfileScreen(
    //       {
    //         "userId": user?.id,
    //         "posts": [post].toList(),
    //         "postSelected": 0,
    //       },
    //     ),
    // );
    //});
  }
}
