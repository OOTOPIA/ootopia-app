import 'package:equatable/equatable.dart';
import 'badges_model.dart';

class Profile extends Equatable {
  String id;
  String fullname;
  String birthdate;
  String? bio;
  String? photoUrl;
  List<Badge>? badges;

  Profile({
    required this.id,
    required this.fullname,
    required this.birthdate,
    this.bio,
    this.photoUrl,
    this.badges
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullname: json['fullname'],
      birthdate: json['birthdate'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      badges: ( 
        json['badges'] == null ? 
          []
          : (json['badges'] as List<dynamic>)
        .map((e) => Badge.fromJson(e as Map<String, dynamic>))
        .toList()
      )
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullname,
        birthdate,
        bio,
        photoUrl,
        badges
      ];
}
