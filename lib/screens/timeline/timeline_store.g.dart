// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TimelineStore on TimelineStoreBase, Store {
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

  final _$remainingTimeAtom = Atom(name: 'TimelineStoreBase.remainingTime');

  @override
  String get remainingTime {
    _$remainingTimeAtom.reportRead();
    return super.remainingTime;
  }

  @override
  set remainingTime(String value) {
    _$remainingTimeAtom.reportWrite(value, super.remainingTime, () {
      super.remainingTime = value;
    });
  }

  final _$TimelineStoreBaseActionController =
      ActionController(name: 'TimelineStoreBase');

  @override
  dynamic startDailyGoalTimer() {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.startDailyGoalTimer');
    try {
      return super.startDailyGoalTimer();
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<DailyGoalStatsModel?> getDailyGoalStats() {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.getDailyGoalStats');
    try {
      return super.getDailyGoalStats();
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dailyGoalStats: ${dailyGoalStats},
remainingTime: ${remainingTime}
    ''';
  }
}
