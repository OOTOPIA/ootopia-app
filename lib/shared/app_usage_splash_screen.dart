import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/splash_screen_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageSplashScreen with SecureStoreMixin {
  String _prefsKeyLastSplashScreenOpening = "last_splash_screen_opening_date";
  SharedPreferences? prefs;
  SplashScreenService sharedExperienceService =
      SplashScreenService.getInstace();
  bool teste = false;

  AppUsageSplashScreen() {
    SharedPreferences.getInstance().then((_prefs) {
      prefs = _prefs;
    });
  }

    updateLastSplashScreenOpening() async {
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }

        String? displayedDate = prefs!.getString(_prefsKeyLastSplashScreenOpening);
        DateTime date = new DateTime.now();
        String today = "${date.day}/${date.month}/${date.year}";

        if (displayedDate == null || displayedDate != today) {
          await prefs!.setString(_prefsKeyLastSplashScreenOpening, today);
          sharedExperienceService.displayedToday = false;
          teste = false;
        }
        else{
          sharedExperienceService.displayedToday = true;
          teste = true;
        }
      }

}
