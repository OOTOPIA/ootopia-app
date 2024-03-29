// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on HomeStoreBase, Store {
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

  final _$showCreatedPostAlertAtom =
      Atom(name: 'HomeStoreBase.showCreatedPostAlert');

  @override
  bool get showCreatedPostAlert {
    _$showCreatedPostAlertAtom.reportRead();
    return super.showCreatedPostAlert;
  }

  @override
  set showCreatedPostAlert(bool value) {
    _$showCreatedPostAlertAtom.reportWrite(value, super.showCreatedPostAlert,
        () {
      super.showCreatedPostAlert = value;
    });
  }

  final _$createdPostAlertAlreadyShowedAtom =
      Atom(name: 'HomeStoreBase.createdPostAlertAlreadyShowed');

  @override
  bool get createdPostAlertAlreadyShowed {
    _$createdPostAlertAlreadyShowedAtom.reportRead();
    return super.createdPostAlertAlreadyShowed;
  }

  @override
  set createdPostAlertAlreadyShowed(bool value) {
    _$createdPostAlertAlreadyShowedAtom
        .reportWrite(value, super.createdPostAlertAlreadyShowed, () {
      super.createdPostAlertAlreadyShowed = value;
    });
  }

  final _$userLoggedAtom = Atom(name: 'HomeStoreBase.userLogged');

  @override
  bool get userLogged {
    _$userLoggedAtom.reportRead();
    return super.userLogged;
  }

  @override
  set userLogged(bool value) {
    _$userLoggedAtom.reportWrite(value, super.userLogged, () {
      super.userLogged = value;
    });
  }

  final _$iphoneHasNotchAtom = Atom(name: 'HomeStoreBase.iphoneHasNotch');

  @override
  bool get iphoneHasNotch {
    _$iphoneHasNotchAtom.reportRead();
    return super.iphoneHasNotch;
  }

  @override
  set iphoneHasNotch(bool value) {
    _$iphoneHasNotchAtom.reportWrite(value, super.iphoneHasNotch, () {
      super.iphoneHasNotch = value;
    });
  }

  final _$seeCrispAtom = Atom(name: 'HomeStoreBase.seeCrisp');

  @override
  bool get seeCrisp {
    _$seeCrispAtom.reportRead();
    return super.seeCrisp;
  }

  @override
  set seeCrisp(bool value) {
    _$seeCrispAtom.reportWrite(value, super.seeCrisp, () {
      super.seeCrisp = value;
    });
  }

  final _$resizeToAvoidBottomInsetAtom =
      Atom(name: 'HomeStoreBase.resizeToAvoidBottomInset');

  @override
  bool get resizeToAvoidBottomInset {
    _$resizeToAvoidBottomInsetAtom.reportRead();
    return super.resizeToAvoidBottomInset;
  }

  @override
  set resizeToAvoidBottomInset(bool value) {
    _$resizeToAvoidBottomInsetAtom
        .reportWrite(value, super.resizeToAvoidBottomInset, () {
      super.resizeToAvoidBottomInset = value;
    });
  }

  final _$getIphoneHasNotchAsyncAction =
      AsyncAction('HomeStoreBase.getIphoneHasNotch');

  @override
  Future getIphoneHasNotch(int iosScreenSize) {
    return _$getIphoneHasNotchAsyncAction
        .run(() => super.getIphoneHasNotch(iosScreenSize));
  }

  final _$getDailyGoalStatsAsyncAction =
      AsyncAction('HomeStoreBase.getDailyGoalStats');

  @override
  Future<DailyGoalStatsModel?> getDailyGoalStats() {
    return _$getDailyGoalStatsAsyncAction.run(() => super.getDailyGoalStats());
  }

  final _$updateDailyGoalStatsByMessageAsyncAction =
      AsyncAction('HomeStoreBase.updateDailyGoalStatsByMessage');

  @override
  Future updateDailyGoalStatsByMessage(dynamic dailyGoalStats) {
    return _$updateDailyGoalStatsByMessageAsyncAction
        .run(() => super.updateDailyGoalStatsByMessage(dailyGoalStats));
  }

  final _$getCurrentUserAsyncAction =
      AsyncAction('HomeStoreBase.getCurrentUser');

  @override
  Future<void> getCurrentUser(String id) {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser(id));
  }

  final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase');

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
  dynamic setShowCreatedPostAlert(bool value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setShowCreatedPostAlert');
    try {
      return super.setShowCreatedPostAlert(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCreatedPostAlertAlreadyShowed(bool value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setCreatedPostAlertAlreadyShowed');
    try {
      return super.setCreatedPostAlertAlreadyShowed(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeeCrip(bool setSeeCrips) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setSeeCrip');
    try {
      return super.setSeeCrip(setSeeCrips);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setResizeToAvoidBottomInset(bool resizeToAvoidBottomInset) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setResizeToAvoidBottomInset');
    try {
      return super.setResizeToAvoidBottomInset(resizeToAvoidBottomInset);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dailyGoalStats: ${dailyGoalStats},
remainingTime: ${remainingTime},
totalAppUsageTimeSoFar: ${totalAppUsageTimeSoFar},
showCreatedPostAlert: ${showCreatedPostAlert},
createdPostAlertAlreadyShowed: ${createdPostAlertAlreadyShowed},
userLogged: ${userLogged},
iphoneHasNotch: ${iphoneHasNotch},
seeCrisp: ${seeCrisp},
resizeToAvoidBottomInset: ${resizeToAvoidBottomInset}
    ''';
  }
}
