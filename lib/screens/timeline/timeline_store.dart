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

enum TimelineViewState { ok, loading, error, loadingMorePosts }

abstract class TimelineStoreBase with Store {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  final PostRepositoryImpl postRepository = PostRepositoryImpl();

  @observable
  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @observable
  List<TimelinePost> allPosts = [];

  @observable
  bool _hasMorePosts = false;

  @observable
  bool _loadingMorePosts = false;

  @computed
  bool get hasMorePosts => _hasMorePosts;

  @computed
  bool get loadingMorePosts => _loadingMorePosts;

  @observable
  bool _sendingToApi = false;

  @observable
  int _postsOffset = 0;

  @computed
  int get postsOffset => _postsOffset;

  @observable
  TimelineViewState viewState = TimelineViewState.loading;

  int get maxPostsPerPage => 10;

  @action
  void goToTopTimeline(TimelinePostBloc timelinePostBloc) {
    if (scrollController.hasClients)
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );

    Future.delayed(Duration(milliseconds: 500)).then((value) {
      reloadPosts();
    });
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

  @action
  void setProfilePosts(List<TimelinePost> posts) {
    allPosts = posts;
    viewState = TimelineViewState.ok;
  }

  @action
  Future<void> getTimelinePosts([
    int? limit,
    int? offset,
    String? userId,
  ]) async {
    if (allPosts.length == 0) {
      viewState = TimelineViewState.loading;
    } else {
      _loadingMorePosts = true;
    }

    try {
      if ((offset == null || offset == 0) && _loadingMorePosts == false) {
        allPosts.clear();
      }
      var response = await postRepository.getPosts(
        (limit != null ? limit : maxPostsPerPage),
        (offset != null ? offset : _postsOffset),
        userId,
      );
      _hasMorePosts = response.length == maxPostsPerPage;
      _postsOffset = _postsOffset + maxPostsPerPage;
      allPosts.addAll(response);
      viewState = TimelineViewState.ok;
      _loadingMorePosts = false;
    } catch (err) {
      viewState = TimelineViewState.error;
      _loadingMorePosts = false;
    }
  }

  @action
  Future removePost(TimelinePost post) async {
    await this.postRepository.deletePost(post.id);
    allPosts = allPosts.where((element) => element.id != post.id).toList();
  }

  @action
  Future reloadPosts([String? userId]) async {
    _postsOffset = 0;
    _hasMorePosts = true;
    allPosts.clear();
    getTimelinePosts(null, null, userId);
  }

  _sendToApi() async {
    if (_timelineViewtimeSoFarInMs > 0 && !_sendingToApi) {
      _sendingToApi = true;
      //Usamos o timer pois ele não será concluído caso o app seja fechado, evitando que a requisição seja encerrada pela metade (sem o app identificar se concluiu ou não)
      //Sendo assim o registro será enviado quando o app for aberto novamente
      Future.delayed(Duration.zero, () async {
        final repository = PostRepositoryImpl();
        await repository.recordTimelineWatched(_timelineViewtimeSoFarInMs);
        _timelineViewtimeSoFarInMs = 0;
        prefs!.setInt(_prefsKey, 0);
        _sendingToApi = false;
      });
    }
  }
}
