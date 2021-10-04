import 'package:json_annotation/json_annotation.dart';

part 'chapters_model.g.dart';

@JsonSerializable()
class ChaptersModel {
  int id;
  String title;
  String videoUrl;
  String videoThumbUrl;
  double ooz;
  String time;

  ChaptersModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.videoThumbUrl,
    required this.ooz,
    required this.time,
  });

  factory ChaptersModel.fromJson(Map<String, dynamic> json) =>
      _$ChaptersModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChaptersModelToJson(this);
}
