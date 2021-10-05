class ProductModel {
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.price,
    required this.userName,
    this.userEmail,
    this.userPhotoUrl,
    this.userPhoneNumber,
    this.userLocation,
  });

  final int id;
  final String title;
  final String description;
  final String photoUrl;
  final double price;
  final String userName;
  final String? userEmail;
  final String? userPhotoUrl;
  final String? userPhoneNumber;
  final String? userLocation;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        price: json["price"],
        userName: json["userName"],
        userEmail: json["userEmail"],
        userPhotoUrl: json["userPhotoUrl"],
        userPhoneNumber: json["userPhoneNumber"],
        userLocation: json["userLocation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "photoUrl": photoUrl,
        "price": price,
        "userName": userName,
        "userEmail": userEmail,
        "userPhotoUrl": userPhotoUrl,
        "userPhoneNumber": userPhoneNumber,
        "userLocation": userLocation,
      };
}
