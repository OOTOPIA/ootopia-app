class CreatePostEntity {
  List<String>? mediaIds;
  String? description;
  List<String>? tagsIds;
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  String? addressNumber;
  List<String>? taggedUsersId;

  CreatePostEntity({
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
}
