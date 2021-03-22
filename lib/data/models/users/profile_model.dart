import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  String id;
  String fullname;
  String birthdate;
  String bio;
  String photoUrl;

  Profile({
    this.id,
    this.fullname,
    this.birthdate,
    this.bio,
    this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
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
