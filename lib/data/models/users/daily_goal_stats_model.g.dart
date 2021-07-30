// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyGoalStatsModel _$DailyGoalStatsModelFromJson(Map<String, dynamic> json) {
  return DailyGoalStatsModel(
    id: json['id'] as String,
    dailyGoalInMinutes: json['dailyGoalInMinutes'] as int,
    dailyGoalEndsAt: json['dailyGoalEndsAt'] as String,
    dailyGoalAchieved: json['dailyGoalAchieved'] as bool,
    totalAppUsageTimeSoFar: json['totalAppUsageTimeSoFar'] as String,
    totalAppUsageTimeSoFarInMs: json['totalAppUsageTimeSoFarInMs'] as int,
    accumulatedOOZ: (json['accumulatedOOZ'] as num).toDouble(),
    remainingTimeUntilEndOfGame: json['remainingTimeUntilEndOfGame'] as String,
    remainingTimeUntilEndOfGameInMs:
        json['remainingTimeUntilEndOfGameInMs'] as int,
    percentageOfDailyGoalAchieved:
        (json['percentageOfDailyGoalAchieved'] as num).toDouble(),
  );
}

Map<String, dynamic> _$DailyGoalStatsModelToJson(
        DailyGoalStatsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dailyGoalInMinutes': instance.dailyGoalInMinutes,
      'dailyGoalEndsAt': instance.dailyGoalEndsAt,
      'dailyGoalAchieved': instance.dailyGoalAchieved,
      'totalAppUsageTimeSoFar': instance.totalAppUsageTimeSoFar,
      'totalAppUsageTimeSoFarInMs': instance.totalAppUsageTimeSoFarInMs,
      'accumulatedOOZ': instance.accumulatedOOZ,
      'remainingTimeUntilEndOfGame': instance.remainingTimeUntilEndOfGame,
      'remainingTimeUntilEndOfGameInMs':
          instance.remainingTimeUntilEndOfGameInMs,
      'percentageOfDailyGoalAchieved': instance.percentageOfDailyGoalAchieved,
    };
