import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';

part 'learning_tracks_model.g.dart';

@JsonSerializable()
class LearningTracksModel {
  String id;
  String userPhotoUrl;
  String userName;
  String title;
  String description;
  List<ChaptersModel> chapters;
  String createdAt;
  String updatedAt;
  String time;
  String imageUrl;
  double ooz;
  String? location;
  bool completed;

  LearningTracksModel({
    required this.id,
    required this.userPhotoUrl,
    required this.userName,
    required this.title,
    required this.description,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrl,
    required this.ooz,
    required this.time,
    required this.location,
    required this.completed,
  });

  factory LearningTracksModel.fromJson(Map<String, dynamic> json) =>
      _$LearningTracksModelFromJson(json);
  Map<String, dynamic> toJson() => _$LearningTracksModelToJson(this);
}
