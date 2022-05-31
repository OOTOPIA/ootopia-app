import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'badges_model.dart';

class Profile extends Equatable {
  final String id;
  final String fullname;
  final String? birthdate;
  final String? bio;
  final String? photoUrl;
  final List<Badge>? badges;
  final int? personalTrophyQuantity;
  final int? cityTrophyQuantity;
  final int? globalTrophyQuantity;
  final int? totalTrophyQuantity;
  final List<Link>? links;
  final List<String>? languages;

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
    this.links,
    this.languages,
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
      links: (json['links'] == null
          ? []
          : (json['links'] as List<dynamic>)
              .map((e) => Link.fromJson(e as Map<String, dynamic>))
              .toList()),
      languages: json["languages"] == null
          ? null
          : List<String>.from(json["languages"].map((x) => x)),
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
        languages,
      ];
}
