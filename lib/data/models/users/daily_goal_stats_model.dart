import 'package:json_annotation/json_annotation.dart';

part 'daily_goal_stats_model.g.dart';

@JsonSerializable()
class DailyGoalStatsModel {
  DailyGoalStatsModel({
    required this.id,
    required this.dailyGoalInMinutes,
    required this.dailyGoalEndsAt,
    required this.dailyGoalAchieved,
    required this.totalAppUsageTimeSoFar,
    required this.totalAppUsageTimeSoFarInMs,
    required this.accumulatedOOZ,
    required this.remainingTimeUntilEndOfGame,
    required this.remainingTimeUntilEndOfGameInMs,
    required this.percentageOfDailyGoalAchieved,
  });
  String id;
  int dailyGoalInMinutes;
  String dailyGoalEndsAt;
  bool dailyGoalAchieved;
  String totalAppUsageTimeSoFar;
  int totalAppUsageTimeSoFarInMs;
  double accumulatedOOZ;
  String remainingTimeUntilEndOfGame;
  int remainingTimeUntilEndOfGameInMs;
  double percentageOfDailyGoalAchieved;
  factory DailyGoalStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DailyGoalStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DailyGoalStatsModelToJson(this);
}
