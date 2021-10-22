import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/data/models/users/badges_model.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class Auth {
  String? id;
  String? fullname;
  String? email;
  String? password;
  String? invitationCode;
  String? birthdate;
  String? photoUrl;
  String? photoFilePath;
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
  String? token;
  bool? personalDialogOpened = false;
  bool? cityDialogOpened = false;
  bool? globalDialogOpened = false;
  int? personalTrophyQuantity;
  int? cityTrophyQuantity;
  int? globalTrophyQuantity;
  int? totalTrophyQuantity;
  String? countryCode;
  int? registerPhase;
  String? createdAt;
  String? updatedAt;
  List<Badge>? badges;

  Auth(
      {this.id,
      this.fullname,
      this.email,
      this.password,
      this.invitationCode,
      this.birthdate,
      this.photoUrl,
      this.photoFilePath,
      this.addressCountryCode,
      this.addressState,
      this.addressCity,
      this.bio,
      this.phone,
      this.addressLatitude,
      this.addressLongitude,
      this.dailyLearningGoalInMinutes,
      this.enableSustainableAds,
      this.dontAskAgainToConfirmGratitudeReward,
      this.token,
      this.personalDialogOpened,
      this.cityDialogOpened,
      this.globalDialogOpened,
      this.personalTrophyQuantity,
      this.cityTrophyQuantity,
      this.globalTrophyQuantity,
      this.totalTrophyQuantity,
      this.countryCode,
      this.registerPhase,
      this.createdAt,
      this.updatedAt,
      List<Badge>? badges});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
