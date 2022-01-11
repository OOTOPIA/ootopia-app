import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    this.photoUrl,
    required this.comments,
    required this.typeId,
    required this.userName,
    required this.userId,
    this.amount,
  });

  final String? photoUrl;
  final String comments;
  final String typeId;
  final String userName;
  final String userId;
  final int? amount;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
