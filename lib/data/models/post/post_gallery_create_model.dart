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
      };
}
