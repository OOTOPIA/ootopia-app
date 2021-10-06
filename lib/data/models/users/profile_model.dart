import 'package:equatable/equatable.dart';
import 'badges_model.dart';

class Profile extends Equatable {
  String id;
  String fullname;
  String? birthdate;
  String? bio;
  String? photoUrl;
  List<Badge>? badges;
  int? personalTrophyQuantity;
  int? cityTrophyQuantity;
  int? globalTrophyQuantity;
  int? totalTrophyQuantity;

  Profile({
    required this.id,
    required this.fullname,
    required this.birthdate,
    this.bio,
    this.photoUrl,
    this.badges,
    this.personalTrophyQuantity,
    this.cityTrophyQuantity,
    this.globalTrophyQuantity,
    this.totalTrophyQuantity,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullname: json['fullname'],
      birthdate: json['birthdate'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      badges: (json['badges'] == null
          ? []
          : (json['badges'] as List<dynamic>)
              .map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList()),
      personalTrophyQuantity: json['personalTrophyQuantity'] == null
          ? 0
          : (json['personalTrophyQuantity'] is int
              ? json['personalTrophyQuantity']
              : int.parse(json['personalTrophyQuantity'])),
      cityTrophyQuantity: json['cityTrophyQuantity'] == null
          ? 0
          : (json['cityTrophyQuantity'] is int
              ? json['cityTrophyQuantity']
              : int.parse(json['cityTrophyQuantity'])),
      globalTrophyQuantity: json['globalTrophyQuantity'] == null
          ? 0
          : (json['globalTrophyQuantity'] is int
              ? json['globalTrophyQuantity']
              : int.parse(json['globalTrophyQuantity'])),
      totalTrophyQuantity: json['totalTrophyQuantity'] == null
          ? 0
          : (json['totalTrophyQuantity'] is int
              ? json['totalTrophyQuantity']
              : int.parse(json['totalTrophyQuantity'])),
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullname,
        birthdate,
        bio,
        photoUrl,
        badges,
        personalTrophyQuantity,
        cityTrophyQuantity,
        globalTrophyQuantity,
        totalTrophyQuantity,
      ];
}
