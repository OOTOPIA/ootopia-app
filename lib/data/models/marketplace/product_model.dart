import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String strapiId;
  String? userId;
  final String title;
  final String description;
  final String locale;
  final String imageUrl;
  final String? imageUpdatedAt;
  final double price;
  final String location;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String userPhotoUrl;

  ProductModel({
    required this.id,
    required this.strapiId,
    this.userId,
    required this.title,
    required this.description,
    required this.locale,
    required this.imageUrl,
    this.imageUpdatedAt,
    required this.price,
    required this.location,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.userPhotoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
