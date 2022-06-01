import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';

part 'create_post_model.g.dart';

@JsonSerializable(createFactory: false)
class CreatePostModel extends CreatePostEntity {
  CreatePostModel({
    String? description,
    List<String>? tagsIds,
    List<String>? mediasIds,
    String? addressCountryCode,
    String? addressState,
    String? addressCity,
    double? addressLatitude,
    double? addressLongitude,
    String? addressNumber,
  }) : super(
          mediaIds: mediasIds,
          description: description,
          tagsIds: tagsIds,
          addressCountryCode: addressCountryCode,
          addressState: addressState,
          addressCity: addressCity,
          addressLatitude: addressLatitude,
          addressLongitude: addressLongitude,
          addressNumber: addressNumber,
        );
  Map<String, dynamic> toJson() => _$CreatePostModelToJson(this);

  factory CreatePostModel.fromEntity(CreatePostEntity createPostEntity) {
    return CreatePostModel(
      mediasIds: createPostEntity.mediaIds,
      description: createPostEntity.description,
      tagsIds: createPostEntity.tagsIds,
      addressCountryCode: createPostEntity.addressCountryCode,
      addressState: createPostEntity.addressState,
      addressCity: createPostEntity.addressCity,
      addressLatitude: createPostEntity.addressLatitude,
      addressLongitude: createPostEntity.addressLongitude,
      addressNumber: createPostEntity.addressNumber,
    );
  }
}
