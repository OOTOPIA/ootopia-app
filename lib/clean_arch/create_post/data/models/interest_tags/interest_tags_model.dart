import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';

part 'interest_tags_model.g.dart';

@JsonSerializable(createToJson: false)
class InterestTagsModel extends InterestsTagsEntity {
  InterestTagsModel({
    required String id,
    required String name,
    required String type,
    required bool active,
    required int tagOrder,
    required String language,
    required String createdAt,
    required String updatedAt,
  }) : super(
          id: id,
          name: name,
          type: type,
          active: active,
          tagOrder: tagOrder,
          language: language,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );
  factory InterestTagsModel.fromJson(Map<String, dynamic> json) {
    return _$InterestTagsModelFromJson(json);
  }
}
