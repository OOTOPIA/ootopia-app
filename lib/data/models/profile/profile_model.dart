import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  String id;
  String fullname;
  String birthdate;
  String bio;
  String photoUrl;

  ProfileModel({
    this.id,
    this.fullname,
    this.birthdate,
    this.bio,
    this.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullname: json['fullname'],
      birthdate: json['birthdate'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
    );
  }

  @override
  List<Object> get props => [
        id,
        fullname,
        birthdate,
        bio,
        photoUrl,
      ];
}
