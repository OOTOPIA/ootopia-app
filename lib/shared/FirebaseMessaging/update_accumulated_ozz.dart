import 'package:flutter/foundation.dart';

class UpdateAccumulatedOZZ with ChangeNotifier {
  static UpdateAccumulatedOZZ? _instance;
  var dailyGoalStats;

  static UpdateAccumulatedOZZ getInstace() {
    if (_instance == null) {
      _instance = UpdateAccumulatedOZZ();
    }
    return _instance!;
  }

  notify(_dailyGoalStats) {
    dailyGoalStats = {
      'id': _dailyGoalStats['id'],
      'dailyGoalInMinutes':
          int.tryParse(_dailyGoalStats['dailyGoalInMinutes']) ?? 0,
      'dailyGoalEndsAt': _dailyGoalStats['dailyGoalEndsAt'],
      'dailyGoalAchieved':
          _dailyGoalStats['dailyGoalAchieved'] == 'true' ? true : false,
      'totalAppUsageTimeSoFar': _dailyGoalStats['totalAppUsageTimeSoFar'],
      'totalAppUsageTimeSoFarInMs':
          int.tryParse(_dailyGoalStats['totalAppUsageTimeSoFarInMs']) ?? 0,
      'accumulatedOOZ':
          double.tryParse(_dailyGoalStats['accumulatedOOZ']) ?? 0.0,
      'remainingTimeUntilEndOfGame':
          _dailyGoalStats['remainingTimeUntilEndOfGame'],
      'remainingTimeUntilEndOfGameInMs':
          int.tryParse(_dailyGoalStats['remainingTimeUntilEndOfGameInMs']) ?? 0,
      'percentageOfDailyGoalAchieved':
          double.tryParse(_dailyGoalStats['percentageOfDailyGoalAchieved']) ??
              0.0
    };
    notifyListeners();
  }
}
