import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';
import 'package:ootopia_app/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InitialScreen extends StatelessWidget {
  SharedPreferences? sharedPreferences;
  HomeStore? homeStore;

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    bool isShow = homeStore?.prefs?.getBool("showSplash") ?? true;
    if (isShow) return SplashScreen(null);
    return HomeScreen();
  }
}
