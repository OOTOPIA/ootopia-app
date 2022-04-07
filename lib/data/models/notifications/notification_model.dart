import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  NotificationModel({
    this.photoURL,
    required this.type,
    this.usersName,
    required this.postId,
    this.userCommentFullname,
    this.oozAmount,
    this.userId,
  });

  final String? photoURL;
  final String type;
  final List<String>? usersName;
  final String postId;
  final String? userCommentFullname;
  final String? oozAmount;
  final String? userId;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
