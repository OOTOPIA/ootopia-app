import 'package:json_annotation/json_annotation.dart';

part 'general_config_model.g.dart';

@JsonSerializable()
class GeneralConfigModel {
  final String name;
  final double value;

  GeneralConfigModel({required this.name, required this.value});

  factory GeneralConfigModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralConfigModelFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralConfigModelToJson(this);
}

class GeneralConfigName {
  static final String transferOOZToPostLimit = "transfer_ooz_to_post_limit";
}
