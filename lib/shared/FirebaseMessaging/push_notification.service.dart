import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/FirebaseMessaging/update_record_time_user_app.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

enum TypeOfMessage {
  gratitude_reward,
  regeneration_game,
  comments,
}

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  UpdateRecordTimeUsage updateRecordTimeUsage =
      UpdateRecordTimeUsage.getInstace();
  User? user;
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

    currentUserData();
  }

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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if ((message.data['type'] as String).replaceAll('-', '_') ==
          TypeOfMessage.regeneration_game.toString().substring(14)) {
        this.updateRecordTimeUsage.notify();
        return;
      }
    });
  }
}
