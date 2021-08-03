// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) {
  return Badge(
    name: json['name'] as String,
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'name': instance.name,
      'icon': instance.icon,
    };
