import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/clean_arch/create_post/domain/entity/users_entity.dart';
part 'users_model.g.dart';

@JsonSerializable(createToJson: false)
class UsersModel extends UsersEntity {
  UsersModel({
    required String fullname,
    required String id,
    String? email,
    String? photoUrl,
  }) : super(
          fullname: fullname,
          id: id,
          email: email,
          photoUrl: photoUrl,
        );

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return _$UsersModelFromJson(json);
  }
}
