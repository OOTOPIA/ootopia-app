import 'package:json_annotation/json_annotation.dart';

part 'badges_model.g.dart';

@JsonSerializable()
class Badge {
  String name;
  String icon;

  Badge({
    required this.name,
    required this.icon
  });
  
  @override
  List<Object?> get props => [name, icon];
  
  factory Badge.fromJson(Map<String, dynamic> json) =>
      _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}