import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

part "timeline_store.g.dart";

class TimelineStore = TimelineStoreBase with _$TimelineStore;

abstract class TimelineStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  List<TimelinePost> allPosts = [];

  @observable
  int currentPage = 1;

  @action
  void goToTopTimeline(TimelinePostBloc timelinePostBloc) {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
    allPosts.clear();
    currentPage = 1;
    Future.delayed(Duration(milliseconds: 500)).then((value) =>
        timelinePostBloc.add(GetTimelinePostsEvent(10, 0)));
  }

  @observable
  ObservableFuture<DailyGoalStatsModel?>? dailyGoalStats;

  Stopwatch _watch = Stopwatch();
  Timer? _timelineViewTimer;
  String _prefsKey = "timeline_view_time";
  SharedPreferences? prefs;
  SmartPageController? _smartPageController;

  int _timelineViewtimeSoFarInMs = 0;

  init(SmartPageController controller) {
    _smartPageController = controller;
  }

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
        if (_watch.isRunning && _smartPageController?.currentPageIndex == 0) {
          _timelineViewtimeSoFarInMs++;
          if ((_timelineViewtimeSoFarInMs / 5000) % 1 == 0) {
            //A cada 5 segundos armazenamos no storage o tempo cronometrado
            prefs!.setInt(_prefsKey, _timelineViewtimeSoFarInMs);
          }
        }
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
