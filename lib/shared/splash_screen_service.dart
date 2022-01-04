class SplashScreenService {
  static SplashScreenService? _instance;
  bool displayedToday = false;

  static SplashScreenService getInstace() {
    if (_instance == null) {
      _instance = SplashScreenService();
    }
    return _instance!;
  }

}
