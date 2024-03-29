import 'package:ootopia_app/data/models/users/user_search_model.dart';

class PostGalleryCreateModel {
  List<String>? mediaIds;
  String? description;
  List<String>? tagsIds;
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  String? addressNumber;
  List<UserSearchModel>? userComments;
  List<String>? taggedUsersId;

  PostGalleryCreateModel({
    this.mediaIds,
    this.description,
    this.tagsIds,
    this.addressCountryCode,
    this.addressState,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
    this.addressNumber,
    this.taggedUsersId,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "addressCountryCode": addressCountryCode,
        "addressState": addressState,
        "addressCity": addressCity,
        "addressLatitude": addressLatitude,
        "addressLongitude": addressLongitude,
        "addressNumber": addressNumber,
        "mediaIds": List<dynamic>.from(mediaIds!.map((x) => x)),
        "tagsIds": List<dynamic>.from(tagsIds!.map((x) => x)),
        "taggedUsersId": List<dynamic>.from(taggedUsersId!.map((x) => x)),
      };
}
