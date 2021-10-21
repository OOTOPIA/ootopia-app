// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TimelineStore on TimelineStoreBase, Store {
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

  final _$startTimelineViewTimerAsyncAction =
      AsyncAction('TimelineStoreBase.startTimelineViewTimer');

  @override
  Future startTimelineViewTimer() {
    return _$startTimelineViewTimerAsyncAction
        .run(() => super.startTimelineViewTimer());
  }

  final _$TimelineStoreBaseActionController =
      ActionController(name: 'TimelineStoreBase');

  @override
  void goToTopTimeline() {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.goToTopTimeline');
    try {
      return super.goToTopTimeline();
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
  String toString() {
    return '''
scrollController: ${scrollController},
dailyGoalStats: ${dailyGoalStats}
    ''';
  }
}
