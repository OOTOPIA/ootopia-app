import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_experience/shared_experience_service.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

class AppUsageTime with SecureStoreMixin {
  static AppUsageTime? _instance;

  Stopwatch _watch = Stopwatch();
  Timer? _timer;
  int usageTimeSoFarInMilliseconds = 0;
  SharedPreferencesInstance? prefs;
  SharedExperienceService sharedExperienceService =
      SharedExperienceService.getInstace();

  AppUsageTime() {
    SharedPreferencesInstance.getInstance().then((_prefs) async {
      prefs = _prefs;
      await dotenv.load(fileName: ".env");
      if (prefs!.getFeedbackToday() ?? false) {
        sharedExperienceService.displayedToday = true;
      }

      if (prefs!.getLastPendingUsageTime() != null) {
        usageTimeSoFarInMilliseconds = prefs!.getLastPendingUsageTime()!;
        if (usageTimeSoFarInMilliseconds > 0) {
          if (_watch.isRunning) {
            _watch.stop();
          }
          await sendToApi();
          if (!_watch.isRunning) {
            _watch.start();
          }
        } else {
          await prefs!.setLastPendingUsageDate(dateNowFormat);
        }
      } else {
        await prefs!.setLastPendingUsageDate(dateNowFormat);
      }
    });
  }

  static AppUsageTime get instance =>
      _instance == null ? _instance = AppUsageTime() : _instance!;

  _updateUsageTime(Timer timer) async {
    if (_watch.isRunning) {
      usageTimeSoFarInMilliseconds += 1000;
      if (prefs == null) {
        prefs = await SharedPreferencesInstance.getInstance();
      }
      //A cada segundo armazenamos no storage o tempo cronometrado
      if (await getUserIsLoggedIn()) {
        prefs!.setLastUsageTime(usageTimeSoFarInMilliseconds);
        int lastTime = prefs!.getFeedbackTime() ?? 0;
        bool displayedToday = prefs!.getFeedbackToday() ?? false;
        String? displayedDate = prefs!.getFeedbackLastUsageDate();
        String today = dateNowFormat;

        if (displayedDate == null || displayedDate != today) {
          prefs!.setFeedbackLastUsageDate(today);
          prefs!.setFeedbackToday(false);
          sharedExperienceService.displayedToday = false;
          lastTime = 0;
          displayedToday = false;
        }
        if (lastTime >= 600000 && !displayedToday) {
          try {
            prefs!.setFeedbackToday(true);
            sharedExperienceService.displayedToday = true;
            sharedExperienceService.notify();
          } catch (e) {}
        }
        prefs!.setFeedbackTime(lastTime + 1000);
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
    DateTime date = DateTime.now();
    List<String?> hourResetGame =
        (prefs?.getGlobalGoalLimitTimeInUtc() ?? "").split(':');
    DateTime resetGame = DateTime.utc(
        date.year,
        date.month,
        date.day,
        int.tryParse(hourResetGame.length > 0 ? hourResetGame[0]! : '0') ?? 0,
        int.tryParse(hourResetGame.length > 1 ? hourResetGame[1]! : '0') ?? 0,
        int.tryParse(hourResetGame.length > 2 ? hourResetGame[2]! : '0') ?? 0,
        0,
        0);

    if (date.isAfter(resetGame)) {
      resetGame = resetGame.add(Duration(days: 1));
      return "${resetGame.day}/${resetGame.month}/${resetGame.year}";
    } else {
      return "${date.day}/${date.month}/${date.year}";
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
    prefs!.setLastPendingUsageTime(usageTimeSoFarInMilliseconds);
  }

  resetUsageTime() {
    if (prefs != null && prefs!.getLastUsageTime() != null) {
      usageTimeSoFarInMilliseconds = 0;
      prefs!.setLastUsageTime(usageTimeSoFarInMilliseconds);
      prefs!.setLastPendingUsageTime(usageTimeSoFarInMilliseconds);
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
        String? pendingDate = prefs!.getLastPendingUsageDate();
        if (pendingDate != null && pendingDate == dateNowFormat) {
          await _usersRepository.recordTimeUserUsedApp(ms!);
        } else {
          await prefs!.setLastPendingUsageDate(dateNowFormat);
        }
        this.resetUsageTime();
      });
    }
  }
}
