import 'package:flutter/foundation.dart';

class SharedExperienceService with ChangeNotifier {
  static SharedExperienceService? _instance;
  bool displayedToday = false;

  static SharedExperienceService getInstace() {
    if (_instance == null) {
      _instance = SharedExperienceService();
    }
    return _instance!;
  }

  notify() {
    notifyListeners();
  }
}
