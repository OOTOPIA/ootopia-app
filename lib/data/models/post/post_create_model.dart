class PostCreate {
  String? filePath;
  String? type;
  String? description;
  List<String>? tagsIds;
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
  double? addressLatitude;
  double? addressLongitude;
  String? addressNumber;

  PostCreate({
    this.filePath,
    this.type,
    this.description,
    this.tagsIds,
    this.addressCountryCode,
    this.addressState,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
    this.addressNumber,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['description'] = this.description;
    data['tagsIds'] =
        this.tagsIds != null ? this.tagsIds!.join(",") : this.tagsIds;
    data['addressCountryCode'] = this.addressCountryCode;
    data['addressState'] = this.addressState;
    data['addressCity'] = this.addressCity;
    data['addressLatitude'] = this.addressLatitude;
    data['addressLongitude'] = this.addressLongitude;
    data['addressNumber'] = this.addressNumber;
    return data;
  }
}
