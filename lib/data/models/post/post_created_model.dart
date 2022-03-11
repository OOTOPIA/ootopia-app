class PostCreated {
  String? id;
  String? userId;
  String? type;
  String? description;
  List<String>? tagsIds;
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  int? addressNumber;
  String? imageUrl;
  String? videoUrl;
  String? streamMediaId;
  String? videoStatus;
  String? thumbnailUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostCreated({
    this.id,
    this.userId,
    this.type,
    this.description,
    this.tagsIds,
    this.addressCountryCode,
    this.addressState,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
    this.addressNumber,
    this.imageUrl,
    this.videoUrl,
    this.streamMediaId,
    this.videoStatus,
    this.thumbnailUrl,
    this.createdAt,
    this.updatedAt,
  });
}
