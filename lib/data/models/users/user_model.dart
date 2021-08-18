import 'package:equatable/equatable.dart';
import 'badges_model.dart';

class User extends Equatable {
  String? id;
  String? fullname;
  String? email;
  String? birthdate;
  String? photoUrl;
  String? photoFilePath; //Used to upload user photo
  String? addressCountryCode;
  String? addressState;
  String? addressCity;
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

  User({
    this.id,
    this.fullname,
    this.email,
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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'email': email,
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
      };

  @override
  List<Object?> get props => [
        id,
        fullname,
        email,
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
      ];
}
