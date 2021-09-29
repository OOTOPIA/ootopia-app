import 'dart:async';

import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTime {
  static AppUsageTime? _instance;

  Stopwatch _watch = Stopwatch();
  Timer? _timer;
  int usageTimeSoFarInMilliseconds = 0;
  String _prefsKey = "last_usage_time";
  String _prefsPendingTimeKey = "last_pending_usage_time";
  SharedPreferences? prefs;

  AppUsageTime() {
    SharedPreferences.getInstance().then((_prefs) async {
      prefs = _prefs;
      if (prefs!.getInt(_prefsPendingTimeKey) != null) {
        usageTimeSoFarInMilliseconds = prefs!.getInt(_prefsPendingTimeKey)!;
        if (usageTimeSoFarInMilliseconds > 0) {
          if (_watch.isRunning) {
            _watch.stop();
          }
          await sendToApi();
          if (!_watch.isRunning) {
            _watch.start();
          }
        }
      }
    });
  }

  static AppUsageTime get instance =>
      _instance == null ? _instance = AppUsageTime() : _instance!;

  _updateUsageTime(Timer timer) async {
    if (_watch.isRunning) {
      usageTimeSoFarInMilliseconds += 1000;
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }
      //A cada segundo armazenamos no storage o tempo cronometrado
      prefs!.setInt(_prefsKey, usageTimeSoFarInMilliseconds);
    }
  }

  startTimer() {
    if (!_watch.isRunning) {
      _watch.start();
    }
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), _updateUsageTime);
    }
  }

  stopTimer() async {
    if (_watch.isRunning) {
      _watch.stop();
    }
    prefs!.setInt(_prefsPendingTimeKey, usageTimeSoFarInMilliseconds);
  }

  resetUsageTime() {
    if (prefs != null && prefs!.getInt(_prefsKey) != null) {
      usageTimeSoFarInMilliseconds = 0;
      prefs!.setInt(_prefsKey, usageTimeSoFarInMilliseconds);
      prefs!.setInt(_prefsPendingTimeKey, usageTimeSoFarInMilliseconds);
    }
  }

  sendToApi([int? ms]) async {
    if (ms == null) {
      ms = usageTimeSoFarInMilliseconds;
    }
    if (ms > 0) {
      //Usamos o timer pois ele não será concluído caso o app seja fechado, evitando que a requisição seja encerrada pela metade (sem o app identificar se concluiu ou não)
      //Sendo assim o registro será enviado quando o app for aberto novamente
      await Future.delayed(Duration.zero, () async {
        var _usersRepository = UserRepositoryImpl();
        await _usersRepository.recordTimeUserUsedApp(ms!);
        usageTimeSoFarInMilliseconds = 0;
        prefs?.setInt(_prefsKey, 0);
        prefs?.setInt(_prefsPendingTimeKey, 0);
      });
    }
  }
}
