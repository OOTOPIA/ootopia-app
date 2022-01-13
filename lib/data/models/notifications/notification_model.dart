import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    this.photoUrl,
    required this.type,
    required this.usersName,
    required this.postId,
    this.oozAmount,
  });

  final String? photoUrl;
  final String type;
  final List<String> usersName;
  final String postId;
  final int? oozAmount;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
