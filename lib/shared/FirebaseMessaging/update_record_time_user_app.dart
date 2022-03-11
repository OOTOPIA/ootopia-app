import 'package:flutter/foundation.dart';

class UpdateRecordTimeUsage with ChangeNotifier {
  static UpdateRecordTimeUsage? _instance;

  static UpdateRecordTimeUsage getInstace() {
    if (_instance == null) {
      _instance = UpdateRecordTimeUsage();
    }
    return _instance!;
  }

  notify() {
    notifyListeners();
  }
}
