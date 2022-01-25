import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class PushNotification {
  static PushNotification? _instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SecureStoreMixin storage = SecureStoreMixin();
  UserRepositoryImpl userRepository = UserRepositoryImpl();
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

}
