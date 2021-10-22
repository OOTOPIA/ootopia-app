import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';
import 'package:ootopia_app/screens/splash/splash_screen.dart';
import 'package:ootopia_app/shared/local_storage.dart';

class InitialScreen extends StatelessWidget {
  final StorageUtil storage = StorageUtil.storageInstance;
  @override
  Widget build(BuildContext context) {
    if (storage.getIsShowSplashScreen("showSplash") ?? true) {
      storage.setIsShowSplashScreen(key: "showSplash", value: false);
      return SplashScreen(null);
    }
    return HomeScreen();
  }
}
