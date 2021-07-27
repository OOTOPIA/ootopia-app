import 'dart:async';

import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTime {
  static AppUsageTime? _instance;

  Stopwatch _watch = Stopwatch();
  Timer? _timer;
  int _usageTimeSoFarInMilliseconds = 0;
  String _prefsKey = "last_usage_time";

  AppUsageTime() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(_prefsKey) != null) {
        _usageTimeSoFarInMilliseconds = prefs.getInt(_prefsKey)!;
        if (_usageTimeSoFarInMilliseconds > 0) _sendToApi();
      }
    });
  }

  static AppUsageTime get instance =>
      _instance == null ? _instance = AppUsageTime() : _instance!;

  _updateUsageTime(Timer timer) {
    if (_watch.isRunning) {
      _usageTimeSoFarInMilliseconds++;
    }
  }

  startTimer() {
    if (!_watch.isRunning) {
      _watch.start();
    }
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 1), _updateUsageTime);
    }
  }

  stopTimer() async {
    if (_watch.isRunning) {
      _watch.stop();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_prefsKey, _usageTimeSoFarInMilliseconds);

    await _sendToApi();
  }

  _sendToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_usageTimeSoFarInMilliseconds > 0) {
      //Usamos o timer pois ele não será concluído caso o app seja fechado, evitando que a requisição seja encerrada pela metade (sem o app identificar se concluiu ou não)
      //Sendo assim o registro será enviado quando o app for aberto novamente
      Timer(Duration(seconds: 1), () async {
        var _usersRepository = UserRepositoryImpl();
        await _usersRepository
            .recordTimeUserUsedApp(_usageTimeSoFarInMilliseconds);
        _usageTimeSoFarInMilliseconds = 0;
        prefs.setInt(_prefsKey, 0);
      });
    }
  }
}
