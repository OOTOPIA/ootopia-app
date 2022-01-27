import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_experience/shared_experience_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTime with SecureStoreMixin {
  static AppUsageTime? _instance;

  Stopwatch _watch = Stopwatch();
  Timer? _timer;
  int usageTimeSoFarInMilliseconds = 0;
  String _prefsKey = "last_usage_time";
  String _prefsKeytime = "feedback_time";
  String _prefsKeyToday = "feedback_today";
  String _prefsKeydate = "feedback_last_usage_date";
  String _prefsPendingTimeKey = "last_pending_usage_time";
  String _prefsPendingDateKey = "last_pending_usage_date";
  SharedPreferences? prefs;
  SharedExperienceService sharedExperienceService =
      SharedExperienceService.getInstace();

  AppUsageTime() {
    SharedPreferences.getInstance().then((_prefs) async {
      prefs = _prefs;

      if (prefs!.getBool(_prefsKeyToday) ?? false) {
        sharedExperienceService.displayedToday = true;
      }

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
        } else {
          prefs!.setString(_prefsPendingDateKey, dateNowFormat);
        }
      } else {
        prefs!.setString(_prefsPendingDateKey, dateNowFormat);
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
      if (await getUserIsLoggedIn()) {
        prefs!.setInt(_prefsKey, usageTimeSoFarInMilliseconds);
        int lastTime = prefs!.getInt(_prefsKeytime) ?? 0;
        bool displayedToday = prefs!.getBool(_prefsKeyToday) ?? false;
        String? displayedDate = prefs!.getString(_prefsKeydate);
        String today = dateNowFormat;

        if (displayedDate == null || displayedDate != today) {
          prefs!.setString(_prefsKeydate, today);
          prefs!.setBool(_prefsKeyToday, false);
          sharedExperienceService.displayedToday = false;
          lastTime = 0;
          displayedToday = false;
        }
        if (lastTime >= 600000 && !displayedToday) {
          try {
            prefs!.setBool(_prefsKeyToday, true);
            sharedExperienceService.displayedToday = true;
            sharedExperienceService.notify();
          } catch (e) {}
        }
        prefs!.setInt(_prefsKeytime, lastTime + 1000);
        if (await FlutterBackgroundService().isServiceRunning()) {
          FlutterBackgroundService().sendData({
            "action": "ON_UPDATE_USAGE_TIME",
            "value": new DateTime.now().millisecondsSinceEpoch,
          });
        }
      }
    }
  }

  String get dateNowFormat {
    DateTime date = new DateTime.now();
    return "${date.day}/${date.month}/${date.year}";
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
        String? pendingDate = prefs!.getString(_prefsPendingDateKey);
        if (pendingDate != null && pendingDate == dateNowFormat) {
          await _usersRepository.recordTimeUserUsedApp(ms!);
        }
        this.resetUsageTime();
      });
    }
  }
}
