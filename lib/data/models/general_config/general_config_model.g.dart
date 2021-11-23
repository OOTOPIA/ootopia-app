// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralConfigModel _$GeneralConfigModelFromJson(Map<String, dynamic> json) {
  return GeneralConfigModel(
    name: json['name'] as String,
    value: num.tryParse(json['value'])?.toDouble() as double,
  );
}

Map<String, dynamic> _$GeneralConfigModelToJson(GeneralConfigModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
