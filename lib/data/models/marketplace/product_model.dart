import 'package:ootopia_app/data/models/users/user_model.dart';

class ProductModel {
  String? id;
  User? user;
  String? photoUrl;
  String? title;
  String? price;
  //TODO: Alinhar model com API
  ProductModel({
    this.id,
    this.user,
    this.photoUrl,
    this.title,
    this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      user: User.fromJson(json['user']),
      photoUrl: json['photoUrl'],
      title: json['title'],
      price: json['price'],
    );
  }
}
