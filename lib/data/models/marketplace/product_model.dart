//     required this.id,
//     required this.title,
//     required this.description,
//     required this.photoUrl,
//     required this.price,
//     required this.userName,
//     this.userEmail,
//     this.userPhotoUrl,
//     this.userPhoneNumber,
//     this.userLocation,
//   final int id;
//   final String title;
//   final String description;
//   final String photoUrl;
//   final double price;
//   final String userName;
//   final String? userEmail;
//   final String? userPhotoUrl;
//   final String? userPhoneNumber;
//   final String? userLocation;

import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String strapiId;
  final String userId;
  final String title;
  final String description;
  final String locale;
  final String imageUrl;
  final String imageUpdatedAt;
  final String price;
  final String location;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String userPhotoUrl;

  ProductModel({
    required this.id,
    required this.strapiId,
    required this.userId,
    required this.title,
    required this.description,
    required this.locale,
    required this.imageUrl,
    required this.imageUpdatedAt,
    required this.price,
    required this.location,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.userPhotoUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
