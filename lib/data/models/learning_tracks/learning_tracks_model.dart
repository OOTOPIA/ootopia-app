import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';

part 'learning_tracks_model.g.dart';

@JsonSerializable()
class LearningTracksModel {
  int id;
  String userPhotoUrl;
  String userName;
  String title;
  String description;
  List<ChaptersModel> chapters;
  String createdAt;
  String updatedAt;

  LearningTracksModel(
      {required this.id,
      required this.userPhotoUrl,
      required this.userName,
      required this.title,
      required this.description,
      required this.chapters,
      required this.createdAt,
      required this.updatedAt});

  factory LearningTracksModel.fromJson(Map<String, dynamic> json) =>
      _$LearningTracksModelFromJson(json);
  Map<String, dynamic> toJson() => _$LearningTracksModelToJson(this);
}
