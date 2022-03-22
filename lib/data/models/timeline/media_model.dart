import 'package:json_annotation/json_annotation.dart';

part "media_model.g.dart";

@JsonSerializable()
class Media {
  String? mediaUrl;
  String? thumbnailUrl;
  String? type;

  Media({
    this.mediaUrl,
    this.thumbnailUrl,
    this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) =>
      _$MediaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
