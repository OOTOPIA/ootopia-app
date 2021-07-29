import 'dart:async';

import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part "timeline_store.g.dart";

class TimelineStore = TimelineStoreBase with _$TimelineStore;

abstract class TimelineStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  ObservableFuture<DailyGoalStatsModel?>? dailyGoalStats;

  Stopwatch _watch = Stopwatch();
  Timer? _dailyGoalTimer;

  int _remainingTimeInSeconds = 0;

  @observable
  String remainingTime = "";

  @action
  startDailyGoalTimer() {
    /*if (!_watch.isRunning) {
      _watch.start();
    }
    if (_dailyGoalTimer == null) {
      _dailyGoalTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_watch.isRunning) {
          _remainingTimeInSeconds--;
          remainingTime = _msToTime(_remainingTimeInSeconds / 1000);
          print("remainingTime >>>> $remainingTime");
        }
      });
    }*/
  }

  _msToTime(duration) {
    var seconds = ((duration / 1000) % 60).floor(),
        minutes = ((duration / (1000 * 60)) % 60).floor(),
        hours = ((duration / (1000 * 60 * 60)) % 24).floor();

    hours = (hours < 10) ? "0" + hours : hours;
    minutes = (minutes < 10) ? "0" + minutes : minutes;
    seconds = (seconds < 10) ? "0" + seconds : seconds;

    return (hours ? hours + "h " : "") + minutes + "m " + seconds + "s";
  }

  @action
  Future<DailyGoalStatsModel?> getDailyGoalStats() => this.dailyGoalStats =
      ObservableFuture(userRepository.getDailyGoalStats());
}
