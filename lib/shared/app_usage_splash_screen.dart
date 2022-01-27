import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageSplashScreen with SecureStoreMixin {
  String _prefsKeyLastSplashScreenOpening = "last_splash_screen_opening_date";
  String _prefsKeyLanguageConfig = "language_config";
  SharedPreferences? prefs;
  bool displayedToday = false;

  AppUsageSplashScreen() {
    SharedPreferences.getInstance().then((_prefs) {
      prefs = _prefs;
    });
  }

  updateLastSplashScreenOpening() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    String? lastDisplayedDate =
        prefs!.getString(_prefsKeyLastSplashScreenOpening);
    DateTime date = new DateTime.now();
    String today = "${date.day}/${date.month}/${date.year}";

    if (lastDisplayedDate == null || lastDisplayedDate != today) {
      await prefs!.setString(_prefsKeyLastSplashScreenOpening, today);
      displayedToday = false;
    } else
      displayedToday = true;
  }

  updateLanguageConfig(String? language) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    if (language != null) prefs!.setString(_prefsKeyLanguageConfig, language);
  }

  checkLanguageConfig() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();

    return prefs!.getString(_prefsKeyLanguageConfig);
  }
}
