import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    this.photoURL,
    required this.type,
    required this.usersName,
    required this.postId,
    this.oozAmount,
  });

  final String? photoURL;
  final String type;
  final List<String> usersName;
  final String postId;
  final int? oozAmount;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
