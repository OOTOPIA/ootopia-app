// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on HomeStoreBase, Store {
  final _$currentPageIndexAtom = Atom(name: 'HomeStoreBase.currentPageIndex');

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  final _$currentPageWidgetAtom = Atom(name: 'HomeStoreBase.currentPageWidget');

  @override
  StatefulWidget? get currentPageWidget {
    _$currentPageWidgetAtom.reportRead();
    return super.currentPageWidget;
  }

  @override
  set currentPageWidget(StatefulWidget? value) {
    _$currentPageWidgetAtom.reportWrite(value, super.currentPageWidget, () {
      super.currentPageWidget = value;
    });
  }

  final _$showRemainingTimeAtom = Atom(name: 'HomeStoreBase.showRemainingTime');

  @override
  bool get showRemainingTime {
    _$showRemainingTimeAtom.reportRead();
    return super.showRemainingTime;
  }

  @override
  set showRemainingTime(bool value) {
    _$showRemainingTimeAtom.reportWrite(value, super.showRemainingTime, () {
      super.showRemainingTime = value;
    });
  }

  final _$showRemainingTimeEndAtom =
      Atom(name: 'HomeStoreBase.showRemainingTimeEnd');

  @override
  bool get showRemainingTimeEnd {
    _$showRemainingTimeEndAtom.reportRead();
    return super.showRemainingTimeEnd;
  }

  @override
  set showRemainingTimeEnd(bool value) {
    _$showRemainingTimeEndAtom.reportWrite(value, super.showRemainingTimeEnd,
        () {
      super.showRemainingTimeEnd = value;
    });
  }

  final _$dailyGoalStatsAtom = Atom(name: 'HomeStoreBase.dailyGoalStats');

  @override
  DailyGoalStatsModel? get dailyGoalStats {
    _$dailyGoalStatsAtom.reportRead();
    return super.dailyGoalStats;
  }

  @override
  set dailyGoalStats(DailyGoalStatsModel? value) {
    _$dailyGoalStatsAtom.reportWrite(value, super.dailyGoalStats, () {
      super.dailyGoalStats = value;
    });
  }

  final _$remainingTimeAtom = Atom(name: 'HomeStoreBase.remainingTime');

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

  final _$totalAppUsageTimeSoFarAtom =
      Atom(name: 'HomeStoreBase.totalAppUsageTimeSoFar');

  @override
  String get totalAppUsageTimeSoFar {
    _$totalAppUsageTimeSoFarAtom.reportRead();
    return super.totalAppUsageTimeSoFar;
  }

  @override
  set totalAppUsageTimeSoFar(String value) {
    _$totalAppUsageTimeSoFarAtom
        .reportWrite(value, super.totalAppUsageTimeSoFar, () {
      super.totalAppUsageTimeSoFar = value;
    });
  }

  final _$getDailyGoalStatsAsyncAction =
      AsyncAction('HomeStoreBase.getDailyGoalStats');

  @override
  Future<DailyGoalStatsModel?> getDailyGoalStats() {
    return _$getDailyGoalStatsAsyncAction.run(() => super.getDailyGoalStats());
  }

  final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase');

  @override
  dynamic startDailyGoalTimer() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.startDailyGoalTimer');
    try {
      return super.startDailyGoalTimer();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic stopDailyGoalTimer() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.stopDailyGoalTimer');
    try {
      return super.stopDailyGoalTimer();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentPageWidget(StatefulWidget pageWidget) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setCurrentPageWidget');
    try {
      return super.setCurrentPageWidget(pageWidget);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCurrentPageIndex(int index) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setCurrentPageIndex');
    try {
      return super.setCurrentPageIndex(index);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic openDrawer() {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.openDrawer');
    try {
      return super.openDrawer();
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
currentPageWidget: ${currentPageWidget},
showRemainingTime: ${showRemainingTime},
showRemainingTimeEnd: ${showRemainingTimeEnd},
dailyGoalStats: ${dailyGoalStats},
remainingTime: ${remainingTime},
totalAppUsageTimeSoFar: ${totalAppUsageTimeSoFar}
    ''';
  }
}
