import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/interest_tags_entity.dart';

part 'interest_tags_model.g.dart';

@JsonSerializable(createToJson: false)
class InterestTagsModel extends InterestsTagsEntity {
  InterestTagsModel({
    required String id,
    required String name,
    required int numberOfPosts,
  }) : super(
          id: id,
          name: name,
          numberOfPosts: numberOfPosts,
        );
  factory InterestTagsModel.fromJson(Map<String, dynamic> json) {
    return _$InterestTagsModelFromJson(json);
  }
}
