import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/theme_light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme with ChangeNotifier {
  final String _darkModeEnabledKey = "dark_mode_enabled";
  static AppTheme? _instance;
  late BuildContext _context;

  AppTheme(BuildContext context) {
    _context = context;
  }

  static AppTheme instance(BuildContext context) =>
      _instance == null ? _instance = AppTheme(context) : _instance!;

  static bool isDarkTheme = false;
  ThemeMode get currentTheme => isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  checkIsDarkMode() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_darkModeEnabledKey) != null) {
        isDarkTheme = prefs.getBool(_darkModeEnabledKey)!;
      }
      notifyListeners();
    } catch (_) {}
  }

  void toggleTheme() async {
    isDarkTheme = !isDarkTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeEnabledKey, isDarkTheme);
    notifyListeners();
  }

  //ThemeData get dark => darkTheme();
  ThemeData get light => lightTheme(_context);
}
