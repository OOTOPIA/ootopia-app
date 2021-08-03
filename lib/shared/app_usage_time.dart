import 'dart:async';

import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTime {
  static AppUsageTime? _instance;

  Stopwatch _watch = Stopwatch();
  Timer? _timer;
  int usageTimeSoFarInMilliseconds = 0;
  String _prefsKey = "last_usage_time";
  SharedPreferences? prefs;

  AppUsageTime() {
    SharedPreferences.getInstance().then((_prefs) async {
      prefs = _prefs;
      if (prefs!.getInt(_prefsKey) != null) {
        usageTimeSoFarInMilliseconds = prefs!.getInt(_prefsKey)!;
        if (usageTimeSoFarInMilliseconds > 0) {
          if (_watch.isRunning) {
            _watch.stop();
          }
          await _sendToApi();
          if (!_watch.isRunning) {
            _watch.start();
          }
        }
      }
    });
  }

  static AppUsageTime get instance =>
      _instance == null ? _instance = AppUsageTime() : _instance!;

  _updateUsageTime(Timer timer) {
    if (_watch.isRunning) {
      usageTimeSoFarInMilliseconds++;
      if ((usageTimeSoFarInMilliseconds / 1000) % 1 == 0) {
        //A cada segundo armazenamos no storage o tempo cronometrado
        prefs!.setInt(_prefsKey, usageTimeSoFarInMilliseconds);
      }
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
    prefs!.setInt(_prefsKey, usageTimeSoFarInMilliseconds);
    await _sendToApi();
  }

  _sendToApi() async {
    if (usageTimeSoFarInMilliseconds > 0) {
      //Usamos o timer pois ele não será concluído caso o app seja fechado, evitando que a requisição seja encerrada pela metade (sem o app identificar se concluiu ou não)
      //Sendo assim o registro será enviado quando o app for aberto novamente
      Future.delayed(Duration.zero, () async {
        var _usersRepository = UserRepositoryImpl();
        await _usersRepository
            .recordTimeUserUsedApp(usageTimeSoFarInMilliseconds);
        usageTimeSoFarInMilliseconds = 0;
        prefs!.setInt(_prefsKey, 0);
      });
    }
  }
}
