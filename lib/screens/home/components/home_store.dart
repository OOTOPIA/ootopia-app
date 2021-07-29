import 'dart:async';

import "package:mobx/mobx.dart";
import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  BuildContext? context;

  @observable
  int currentPageIndex = 0;

  @observable
  StatefulWidget? currentPageWidget;

  @observable
  bool showRemainingTime = false;

  @observable
  bool showRemainingTimeEnd = false;

  @observable
  DailyGoalStatsModel? dailyGoalStats;

  Stopwatch _watch = Stopwatch();
  Timer? _dailyGoalTimer;

  int _remainingTimeInMs = 0;
  int _totalAppUsageTimeSoFarInMs = 0;
  bool _timerIsStarted = false;

  @observable
  String remainingTime = "";

  @observable
  String totalAppUsageTimeSoFar = "";

  @action
  startDailyGoalTimer() {
    if (!_watch.isRunning) {
      _watch.start();
    }
    if (_dailyGoalTimer == null) {
      _dailyGoalTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_watch.isRunning && dailyGoalStats != null) {
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
            _timerIsStarted = true;
          } else {
            _remainingTimeInMs = _remainingTimeInMs - 1000;
            _totalAppUsageTimeSoFarInMs = _totalAppUsageTimeSoFarInMs + 1000;
          }
          remainingTime = _msToTime(_remainingTimeInMs);
          totalAppUsageTimeSoFar =
              _msToTime(_totalAppUsageTimeSoFarInMs, showSeconds: true);
        }
      });
    }
  }

  @action
  stopDailyGoalTimer() {
    if (_watch.isRunning) {
      _watch.stop();
    }
    _dailyGoalTimer = null;
  }

  @action
  setCurrentPageWidget(StatefulWidget pageWidget) {
    currentPageWidget = pageWidget;
  }

  @action
  setCurrentPageIndex(int index) {
    currentPageIndex = index;
  }

  @action
  openDrawer() {
    print("HEY OPEN DRAWER BRO!");
  }

  @action
  Future<DailyGoalStatsModel?> getDailyGoalStats() async {
    this.dailyGoalStats = await userRepository.getDailyGoalStats();
    return this.dailyGoalStats;
  }

  _msToTime(duration, {bool? showSeconds}) {
    try {
      int seconds = ((duration / 1000) % 60).floor();
      int minutes = ((duration / (1000 * 60)) % 60).floor();
      int hours = ((duration / (1000 * 60 * 60)) % 24).floor();

      String strHours = (hours < 10) ? "0$hours" : "$hours";
      String strMinutes = (minutes < 10) ? "0$minutes" : "$minutes";
      String strSeconds = (seconds < 10) ? "0$seconds" : "$seconds";

      return (strHours.isNotEmpty ? strHours + "h " : "") +
          strMinutes +
          "m " +
          (showSeconds == true ? strSeconds + "s" : "");
    } catch (err) {
      print("ERROR>>> $err");
      return "error";
    }
  }
}
