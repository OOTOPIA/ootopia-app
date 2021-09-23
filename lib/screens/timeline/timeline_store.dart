import 'dart:async';

import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "timeline_store.g.dart";

class TimelineStore = TimelineStoreBase with _$TimelineStore;

abstract class TimelineStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  ObservableFuture<DailyGoalStatsModel?>? dailyGoalStats;

  Stopwatch _watch = Stopwatch();
  Timer? _timelineViewTimer;
  String _prefsKey = "timeline_view_time";
  SharedPreferences? prefs;

  int _timelineViewtimeSoFarInMs = 0;

  @action
  startTimelineViewTimer() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (!_watch.isRunning) {
      _watch.start();
    }

    if (prefs!.getInt(_prefsKey) != null) {
      _timelineViewtimeSoFarInMs = prefs!.getInt(_prefsKey)!;
      if (_timelineViewtimeSoFarInMs > 0) {
        if (_watch.isRunning) {
          _watch.stop();
        }
        await _sendToApi();
        if (!_watch.isRunning) {
          _watch.start();
        }
      }
    }

    if (_timelineViewTimer == null) {
      _timelineViewTimer =
          Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
        // if (_watch.isRunning &&
        //     PageViewController.instance.controller.page == 0) {
        //   _timelineViewtimeSoFarInMs++;
        //   if ((_timelineViewtimeSoFarInMs / 5000) % 1 == 0) {
        //     //A cada 5 segundos armazenamos no storage o tempo cronometrado
        //     prefs!.setInt(_prefsKey, _timelineViewtimeSoFarInMs);
        //   }
        // }
      });
    }
  }

  @action
  stopTimelineViewTimer() {
    if (_watch.isRunning) {
      _watch.stop();
    }
    _timelineViewTimer = null;
  }

  _sendToApi() async {
    if (_timelineViewtimeSoFarInMs > 0) {
      //Usamos o timer pois ele não será concluído caso o app seja fechado, evitando que a requisição seja encerrada pela metade (sem o app identificar se concluiu ou não)
      //Sendo assim o registro será enviado quando o app for aberto novamente
      Future.delayed(Duration.zero, () async {
        final repository = PostRepositoryImpl();
        await repository.recordTimelineWatched(_timelineViewtimeSoFarInMs);
        _timelineViewtimeSoFarInMs = 0;
        prefs!.setInt(_prefsKey, 0);
      });
    }
  }
}
