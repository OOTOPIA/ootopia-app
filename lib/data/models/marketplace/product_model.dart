class ProductModel {
  final String id;
  final String title, description, photoUrl;
  final double price;
  final String userName;
  final String? userEmail;
  final String? userPhotoUrl;
  final String? userPhoneNumber;
  final String? userLocation;
  const ProductModel({
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
}
