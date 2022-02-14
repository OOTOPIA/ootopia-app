import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

class AppUsageSplashScreen with SecureStoreMixin {
  SharedPreferencesInstance? prefs;

  bool displayedToday = false;

  AppUsageSplashScreen() {
    SharedPreferencesInstance.getInstace().then((_prefs) {
      prefs = _prefs;
    });
  }

  updateLastSplashScreenOpening() async {
    if (prefs == null) prefs = await SharedPreferencesInstance.getInstace();

    String? lastDisplayedDate = prefs!.getLastSplashScreenOpening();
    DateTime date = new DateTime.now();
    String today = "${date.day}/${date.month}/${date.year}";

    if (lastDisplayedDate == null || lastDisplayedDate != today) {
      await prefs!.setLastSplashScreenOpening(today);
      displayedToday = false;
    } else
      displayedToday = true;
  }

  updateLanguageConfig(String? language) async {
    if (prefs == null) prefs = await SharedPreferencesInstance.getInstace();

    if (language != null) prefs!.setLanguageConfig(language);
  }

  checkLanguageConfig() async {
    if (prefs == null) prefs = await SharedPreferencesInstance.getInstace();

    return prefs!.getLanguageConfig();
  }
}
