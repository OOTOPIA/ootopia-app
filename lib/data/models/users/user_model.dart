import 'package:equatable/equatable.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'badges_model.dart';
import 'dart:convert' as js;

class User extends Equatable {
  String? id;
  String? fullname;
  String? email;
  String? invitationCode;
  String? birthdate;
  String? photoUrl;
  String? photoFilePath; //Used to upload user photo
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
  String? bio;
  String? phone;
  double? addressLatitude;
  double? addressLongitude;
  int? dailyLearningGoalInMinutes;
  bool? enableSustainableAds = false;
  bool? dontAskAgainToConfirmGratitudeReward = false;
  int? registerPhase;
  String? token;
  String? createdAt;
  String? updatedAt;
  List<Badge>? badges;
  bool? personalDialogOpened = false;
  bool? cityDialogOpened = false;
  bool? globalDialogOpened = false;
  int? personalTrophyQuantity;
  int? cityTrophyQuantity;
  int? globalTrophyQuantity;
  int? totalTrophyQuantity;
  String? countryCode;
  String? dialCode;
  List<Link>? links;
  List<String>? languages;

  User({
    this.id,
    this.fullname,
    this.email,
    this.invitationCode,
    this.birthdate,
    this.photoUrl,
    this.addressCountryCode,
    this.addressState,
    this.addressCity,
    this.addressLatitude,
    this.addressLongitude,
    this.dailyLearningGoalInMinutes,
    this.enableSustainableAds,
    this.dontAskAgainToConfirmGratitudeReward,
    this.registerPhase,
    this.token,
    this.createdAt,
    this.updatedAt,
    this.badges,
    this.personalDialogOpened,
    this.cityDialogOpened,
    this.globalDialogOpened,
    this.personalTrophyQuantity,
    this.cityTrophyQuantity,
    this.globalTrophyQuantity,
    this.totalTrophyQuantity,
    this.bio,
    this.phone,
    this.countryCode,
    this.dialCode,
    this.links,
    this.languages,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      invitationCode: json['invitationCode'],
      birthdate: json['birthdate'],
      photoUrl: json['photoUrl'],
      addressCountryCode: json['addressCountryCode'],
      addressState: json['addressState'],
      addressCity: json['addressCity'],
      addressLatitude: json['addressLatitude'] == null
          ? 0.0
          : (json['addressLatitude'] is double
              ? json['addressLatitude']
              : double.parse(json['addressLatitude'])),
      addressLongitude: json['addressLongitude'] == null
          ? 0.0
          : (json['addressLongitude'] is double
              ? json['addressLongitude']
              : double.parse(json['addressLongitude'])),
      dailyLearningGoalInMinutes: (json['dailyLearningGoalInMinutes'] is int
          ? json['dailyLearningGoalInMinutes']
          : int.parse(json['dailyLearningGoalInMinutes'])),
      registerPhase: (json['registerPhase'] is int
          ? json['registerPhase']
          : int.parse(json['registerPhase'])),
      enableSustainableAds: (json['enableSustainableAds'] == null
          ? false
          : json['enableSustainableAds']),
      dontAskAgainToConfirmGratitudeReward:
          (json['dontAskAgainToConfirmGratitudeReward'] == null
              ? false
              : json['dontAskAgainToConfirmGratitudeReward']),
      token: json['token'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      badges: (json['badges'] == null
          ? []
          : (json['badges'] as List<dynamic>)
              .map((e) => Badge.fromJson(e as Map<String, dynamic>))
              .toList()),
      personalDialogOpened: json['personalDialogOpened'] == null
          ? false
          : json['personalDialogOpened'],
      cityDialogOpened:
          json['cityDialogOpened'] == null ? false : json['cityDialogOpened'],
      globalDialogOpened: json['globalDialogOpened'] == null
          ? false
          : json['globalDialogOpened'],
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
      bio: json['bio'],
      phone: json['phone'],
      dialCode: json['dialCode'],
      countryCode: json['countryCode'],
      links: (json['links'] == null || json['links'] == '[{}]'
          ? []
          : (json['links'] as List<dynamic>)
              .map((e) =>
                  Link.fromJson(e.runtimeType == String ? js.jsonDecode(e) : e))
              .toList()),
      languages: json["languages"] == null
          ? null
          : List<String>.from(json["languages"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'email': email,
        'invitationCode': invitationCode,
        'birthdate': birthdate,
        'photoUrl': photoUrl,
        'addressCountryCode': addressCountryCode,
        'addressState': addressState,
        'addressCity': addressCity,
        'addressLatitude': addressLatitude,
        'addressLongitude': addressLongitude,
        'dailyLearningGoalInMinutes': dailyLearningGoalInMinutes,
        'registerPhase': registerPhase,
        'enableSustainableAds': enableSustainableAds,
        'token': token,
        'badges': badges,
        'personalDialogOpened': personalDialogOpened,
        'cityDialogOpened': cityDialogOpened,
        'globalDialogOpened': globalDialogOpened,
        "personalTrophyQuantity": personalTrophyQuantity,
        "cityTrophyQuantity": cityTrophyQuantity,
        "globalTrophyQuantity": globalTrophyQuantity,
        "totalTrophyQuantity": totalTrophyQuantity,
        'bio': bio,
        'phone': phone,
        'countryCode': countryCode,
        'dialCode': dialCode,
        'links': links,
        'languages': languages,
      };

  @override
  List<Object?> get props => [
        id,
        fullname,
        email,
        invitationCode,
        birthdate,
        photoUrl,
        addressCountryCode,
        addressState,
        addressCity,
        addressLatitude,
        addressLongitude,
        dailyLearningGoalInMinutes,
        registerPhase,
        enableSustainableAds,
        dontAskAgainToConfirmGratitudeReward,
        token,
        createdAt,
        updatedAt,
        badges,
        personalDialogOpened,
        cityDialogOpened,
        globalDialogOpened,
        personalTrophyQuantity,
        cityTrophyQuantity,
        globalTrophyQuantity,
        totalTrophyQuantity,
        bio,
        phone,
        dialCode,
        links,
        languages,
      ];
}
