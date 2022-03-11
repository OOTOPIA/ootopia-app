import 'package:json_annotation/json_annotation.dart';

part 'interests_tags_model.g.dart';

@JsonSerializable()
class InterestsTagsModel {
  InterestsTagsModel({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.tagOrder,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    this.selectedTag,
  });

  String id;
  String name;
  String type;
  bool active;
  bool? selectedTag = false;
  int tagOrder;
  String language;
  String createdAt;
  String updatedAt;

  factory InterestsTagsModel.fromJson(Map<String, dynamic> json) =>
      _$InterestsTagsModelFromJson(json);
  Map<String, dynamic> toJson() => _$InterestsTagsModelToJson(this);
}
