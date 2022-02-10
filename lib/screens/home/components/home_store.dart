import 'dart:async';

import "package:mobx/mobx.dart";
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/repositories/general_config_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/shared_preferences.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  String _personalCelebratePageEnabled = "show_personal_celebrate_page";
  String _personalCelebratePageAlreadyOpened =
      "personal_celebrate_page_already_opened";
  SharedPreferencesInstance? prefs;

  BuildContext? context;

  @observable
  int currentPageIndex = 0;

  bool totalIsSentToApi = false;

  @observable
  StatefulWidget? currentPageWidget;

  @observable
  bool showRemainingTime = false;

  @observable
  bool showRemainingTimeEnd = false;

  @observable
  DailyGoalStatsModel? dailyGoalStats;

  @observable
  double percentageOfDailyGoalAchieved = 0;

  Stopwatch _watch = Stopwatch();
  Timer? _dailyGoalTimer;

  int _remainingTimeInMs = 0;
  int _totalAppUsageTimeSoFarInMs = 0;
  bool _timerIsStarted = false;
  bool _getDailyGoalStats = false;

  @observable
  String remainingTime = "";

  @observable
  String totalAppUsageTimeSoFar = "";

  @observable
  bool showCreatedPostAlert = false;

  @observable
  bool createdPostAlertAlreadyShowed = false;

  @observable
  bool userLogged = false;

  @observable
  bool iphoneHasNotch = false;

  @observable
  bool seeCrisp = true;

  @observable
  bool resizeToAvoidBottomInset = false;

  @action
  startDailyGoalTimer() async {
    _timerIsStarted = false;
    _totalAppUsageTimeSoFarInMs = 0;
    if (prefs == null) {
      prefs = await SharedPreferencesInstance.getInstace();
    }
    if (!_watch.isRunning) {
      _watch.start();
    }
    if (dailyGoalStats != null) {
      percentageOfDailyGoalAchieved =
          dailyGoalStats!.percentageOfDailyGoalAchieved;
      _totalAppUsageTimeSoFarInMs = dailyGoalStats!.totalAppUsageTimeSoFarInMs;
      _getDailyGoalStats = true;
    }
    if (_dailyGoalTimer == null ||
        (_dailyGoalTimer != null && !_dailyGoalTimer!.isActive)) {
      _dailyGoalTimer =
          Timer.periodic(Duration(seconds: 1), (Timer timer) async {
        if (_watch.isRunning && dailyGoalStats != null) {
          if (!_getDailyGoalStats) {
            _totalAppUsageTimeSoFarInMs =
                dailyGoalStats!.totalAppUsageTimeSoFarInMs;
            _getDailyGoalStats = true;
          }
          if (!_timerIsStarted) {
            _remainingTimeInMs =
                dailyGoalStats!.remainingTimeUntilEndOfGameInMs;
            _totalAppUsageTimeSoFarInMs =
                dailyGoalStats!.totalAppUsageTimeSoFarInMs;
            if (AppUsageTime.instance.usageTimeSoFarInMilliseconds > 0) {
              //Dessa forma mascaramos o "bug" do tempo de utilização não ter subido ainda ao abrir o app a tempo de retornar na requisição do status da meta pessoal
              _totalAppUsageTimeSoFarInMs +=
                  AppUsageTime.instance.usageTimeSoFarInMilliseconds;
            }
            percentageOfDailyGoalAchieved =
                dailyGoalStats!.percentageOfDailyGoalAchieved;
            _timerIsStarted = true;
          } else {
            _remainingTimeInMs = _remainingTimeInMs - 1000;
            _totalAppUsageTimeSoFarInMs = _totalAppUsageTimeSoFarInMs + 1000;
            var progressPerc = (_totalAppUsageTimeSoFarInMs /
                    (dailyGoalStats!.dailyGoalInMinutes * 60000)) *
                100;
            percentageOfDailyGoalAchieved =
                (progressPerc >= 100 ? 100 : progressPerc);
          }
          if (percentageOfDailyGoalAchieved >= 100) {
            prefs?.setPersonalCelebratePageEnabled(true);
            if (prefs?.getPersonalCelebratePageAlreadyOpened() == false &&
                !totalIsSentToApi) {
              totalIsSentToApi = true;
              await AppUsageTime.instance
                  .sendToApi(_totalAppUsageTimeSoFarInMs);
              AppUsageTime.instance.resetUsageTime();
            }
          } else {
            if (prefs?.getPersonalCelebratePageAlreadyOpened() == true) {
              AppUsageTime.instance.resetUsageTime();
              percentageOfDailyGoalAchieved = 0;
              _totalAppUsageTimeSoFarInMs = 0;
            }
            prefs?.setPersonalCelebratePageEnabled(false);
            prefs?.setPersonalCelebratePageAlreadyOpened(false);
          }
          remainingTime = _msToTime(_remainingTimeInMs);
          totalAppUsageTimeSoFar =
              _msToTime(_totalAppUsageTimeSoFarInMs, showSeconds: true);
        }
      });
    }
  }

  @action
  getIphoneHasNotch(int iosScreenSize) async {
    iphoneHasNotch =
        await GeneralConfigRepositoryImpl().getIosHasNotch(iosScreenSize);
  }

  @action
  stopDailyGoalTimer() {
    _watch.stop();
    _dailyGoalTimer?.cancel();
  }

  @action
  setCurrentPageWidget(StatefulWidget pageWidget) {
    currentPageWidget = pageWidget;
  }

  @action
  setShowCreatedPostAlert(bool value) {
    showCreatedPostAlert = value;
  }

  @action
  setCreatedPostAlertAlreadyShowed(bool value) {
    createdPostAlertAlreadyShowed = value;
  }

  @action
  Future<DailyGoalStatsModel?> getDailyGoalStats() async {
    try {
      this.dailyGoalStats = await userRepository.getDailyGoalStats();
    } catch (err) {}
    return this.dailyGoalStats;
  }

  @action
  updateDailyGoalStatsByMessage(dailyGoalStats) async {
    this.dailyGoalStats = DailyGoalStatsModel(
      id: dailyGoalStats['id'],
      dailyGoalInMinutes: dailyGoalStats['dailyGoalInMinutes'],
      dailyGoalAchieved: dailyGoalStats['dailyGoalAchieved'],
      dailyGoalEndsAt: dailyGoalStats['dailyGoalEndsAt'],
      percentageOfDailyGoalAchieved:
          dailyGoalStats['percentageOfDailyGoalAchieved'],
      remainingTimeUntilEndOfGame:
          dailyGoalStats['remainingTimeUntilEndOfGame'],
      remainingTimeUntilEndOfGameInMs:
          dailyGoalStats['remainingTimeUntilEndOfGameInMs'],
      totalAppUsageTimeSoFar: dailyGoalStats['totalAppUsageTimeSoFar'],
      accumulatedOOZ: dailyGoalStats['accumulatedOOZ'],
      totalAppUsageTimeSoFarInMs: dailyGoalStats['totalAppUsageTimeSoFarInMs'],
    );
  }

  @action
  Future<bool> readyToShowCelebratePage() async {
    if (percentageOfDailyGoalAchieved >= 100 && prefs != null) {
      final result = prefs?.getPersonalCelebratePageEnabled();
      final alreadyOpened = prefs?.getPersonalCelebratePageAlreadyOpened();
      return (result != null &&
              result &&
              (alreadyOpened == null || !alreadyOpened))
          ? true
          : false;
    }
    return false;
  }

  @action
  setCelebratePageAlreadyOpened(bool show) {
    if (prefs != null) {
      prefs?.setPersonalCelebratePageAlreadyOpened(show);
    }
  }

  _msToTime(duration, {bool? showSeconds}) {
    try {
      int seconds = ((duration / 1000) % 60).floor();
      int minutes = ((duration / (1000 * 60)) % 60).floor();
      int hours = ((duration / (1000 * 60 * 60)) % 24).floor();

      String strHours = (hours < 10) ? "0$hours" : "$hours";
      String strMinutes = (minutes < 10) ? "0$minutes" : "$minutes";
      String strSeconds = (seconds < 10) ? "0$seconds" : "$seconds";

      return (strHours != "00" ? strHours + "h " : "") +
          strMinutes +
          "min " +
          (showSeconds == true && strHours == "00" ? strSeconds + "s" : "");
    } catch (err) {
      return "error";
    }
  }

  @action
  Future<void> getCurrentUser(String id) async {
    var user = await userRepository.getCurrentUser();
    if (user?.id == id) {
      userLogged = true;
    } else {
      userLogged = false;
    }
  }

  @action
  void setSeeCrip(bool setSeeCrips) {
    this.seeCrisp = setSeeCrips;
  }

  @action
  void setResizeToAvoidBottomInset(bool resizeToAvoidBottomInset) {
    this.resizeToAvoidBottomInset = resizeToAvoidBottomInset;
  }
}
