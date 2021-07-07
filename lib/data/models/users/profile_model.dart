import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  String id;
  String fullname;
  String birthdate;
  String? bio;
  String? photoUrl;

  Profile({
    required this.id,
    required this.fullname,
    required this.birthdate,
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
  List<Object?> get props => [
        id,
        fullname,
        birthdate,
        bio,
        photoUrl,
      ];
}
