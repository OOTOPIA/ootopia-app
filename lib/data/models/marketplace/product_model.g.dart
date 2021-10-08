// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as String,
    strapiId: json['strapiId'] as String,
    userId: json['userId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    locale: json['locale'] as String,
    imageUrl: json['imageUrl'] as String,
    imageUpdatedAt: json['imageUpdatedAt'] as String,
    price: (json['price'] as num).toDouble(),
    location: json['location'] as String,
    deletedAt: json['deletedAt'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    userName: json['userName'] as String,
    userPhotoUrl: json['userPhotoUrl'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'strapiId': instance.strapiId,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'locale': instance.locale,
      'imageUrl': instance.imageUrl,
      'imageUpdatedAt': instance.imageUpdatedAt,
      'price': instance.price,
      'location': instance.location,
      'deletedAt': instance.deletedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'userName': instance.userName,
      'userPhotoUrl': instance.userPhotoUrl,
    };
