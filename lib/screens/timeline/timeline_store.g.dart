// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TimelineStore on TimelineStoreBase, Store {
  Computed<bool>? _$hasMorePostsComputed;

  @override
  bool get hasMorePosts =>
      (_$hasMorePostsComputed ??= Computed<bool>(() => super.hasMorePosts,
              name: 'TimelineStoreBase.hasMorePosts'))
          .value;
  Computed<bool>? _$loadingMorePostsComputed;

  @override
  bool get loadingMorePosts => (_$loadingMorePostsComputed ??= Computed<bool>(
          () => super.loadingMorePosts,
          name: 'TimelineStoreBase.loadingMorePosts'))
      .value;
  Computed<int>? _$postsOffsetComputed;

  @override
  int get postsOffset =>
      (_$postsOffsetComputed ??= Computed<int>(() => super.postsOffset,
              name: 'TimelineStoreBase.postsOffset'))
          .value;

  final _$scrollControllerAtom =
      Atom(name: 'TimelineStoreBase.scrollController');

  @override
  ScrollController get scrollController {
    _$scrollControllerAtom.reportRead();
    return super.scrollController;
  }

  @override
  set scrollController(ScrollController value) {
    _$scrollControllerAtom.reportWrite(value, super.scrollController, () {
      super.scrollController = value;
    });
  }

  final _$allPostsAtom = Atom(name: 'TimelineStoreBase.allPosts');

  @override
  List<TimelinePost> get allPosts {
    _$allPostsAtom.reportRead();
    return super.allPosts;
  }

  @override
  set allPosts(List<TimelinePost> value) {
    _$allPostsAtom.reportWrite(value, super.allPosts, () {
      super.allPosts = value;
    });
  }

  final _$_hasMorePostsAtom = Atom(name: 'TimelineStoreBase._hasMorePosts');

  @override
  bool get _hasMorePosts {
    _$_hasMorePostsAtom.reportRead();
    return super._hasMorePosts;
  }

  @override
  set _hasMorePosts(bool value) {
    _$_hasMorePostsAtom.reportWrite(value, super._hasMorePosts, () {
      super._hasMorePosts = value;
    });
  }

  final _$_loadingMorePostsAtom =
      Atom(name: 'TimelineStoreBase._loadingMorePosts');

  @override
  bool get _loadingMorePosts {
    _$_loadingMorePostsAtom.reportRead();
    return super._loadingMorePosts;
  }

  @override
  set _loadingMorePosts(bool value) {
    _$_loadingMorePostsAtom.reportWrite(value, super._loadingMorePosts, () {
      super._loadingMorePosts = value;
    });
  }

  final _$_sendingToApiAtom = Atom(name: 'TimelineStoreBase._sendingToApi');

  @override
  bool get _sendingToApi {
    _$_sendingToApiAtom.reportRead();
    return super._sendingToApi;
  }

  @override
  set _sendingToApi(bool value) {
    _$_sendingToApiAtom.reportWrite(value, super._sendingToApi, () {
      super._sendingToApi = value;
    });
  }

  final _$_postsOffsetAtom = Atom(name: 'TimelineStoreBase._postsOffset');

  @override
  int get _postsOffset {
    _$_postsOffsetAtom.reportRead();
    return super._postsOffset;
  }

  @override
  set _postsOffset(int value) {
    _$_postsOffsetAtom.reportWrite(value, super._postsOffset, () {
      super._postsOffset = value;
    });
  }

  final _$viewStateAtom = Atom(name: 'TimelineStoreBase.viewState');

  @override
  TimelineViewState get viewState {
    _$viewStateAtom.reportRead();
    return super.viewState;
  }

  @override
  set viewState(TimelineViewState value) {
    _$viewStateAtom.reportWrite(value, super.viewState, () {
      super.viewState = value;
    });
  }

  final _$dailyGoalStatsAtom = Atom(name: 'TimelineStoreBase.dailyGoalStats');

  @override
  ObservableFuture<DailyGoalStatsModel?>? get dailyGoalStats {
    _$dailyGoalStatsAtom.reportRead();
    return super.dailyGoalStats;
  }

  @override
  set dailyGoalStats(ObservableFuture<DailyGoalStatsModel?>? value) {
    _$dailyGoalStatsAtom.reportWrite(value, super.dailyGoalStats, () {
      super.dailyGoalStats = value;
    });
  }

  final _$getTimelinePostsAsyncAction =
      AsyncAction('TimelineStoreBase.getTimelinePosts');

  @override
  Future<void> getTimelinePosts([int? limit, int? offset, String? userId]) {
    return _$getTimelinePostsAsyncAction
        .run(() => super.getTimelinePosts(limit, offset, userId));
  }

  final _$removePostAsyncAction = AsyncAction('TimelineStoreBase.removePost');

  @override
  Future<dynamic> removePost(TimelinePost post) {
    return _$removePostAsyncAction.run(() => super.removePost(post));
  }

  final _$reloadPostsAsyncAction = AsyncAction('TimelineStoreBase.reloadPosts');

  @override
  Future<dynamic> reloadPosts([String? userId]) {
    return _$reloadPostsAsyncAction.run(() => super.reloadPosts(userId));
  }

  final _$TimelineStoreBaseActionController =
      ActionController(name: 'TimelineStoreBase');

  @override
  void goToTopTimeline(TimelinePostBloc timelinePostBloc) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.goToTopTimeline');
    try {
      return super.goToTopTimeline(timelinePostBloc);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic stopTimelineViewTimer() {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.stopTimelineViewTimer');
    try {
      return super.stopTimelineViewTimer();
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProfilePosts(List<TimelinePost> posts) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setProfilePosts');
    try {
      return super.setProfilePosts(posts);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
scrollController: ${scrollController},
allPosts: ${allPosts},
viewState: ${viewState},
dailyGoalStats: ${dailyGoalStats},
hasMorePosts: ${hasMorePosts},
loadingMorePosts: ${loadingMorePosts},
postsOffset: ${postsOffset}
    ''';
  }
}
