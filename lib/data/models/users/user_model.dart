import 'package:equatable/equatable.dart';

class User extends Equatable {
  String id;
  String fullname;
  String email;
  String birthdate;
  String photoUrl;
  String photoFilePath; //Used to upload user photo
  String addressCountryCode;
  String addressState;
  String addressCity;
  double addressLatitude;
  double addressLongitude;
  int dailyLearningGoalInMinutes;
  bool enableSustainableAds = false;
  int registerPhase;
  String token;
  DateTime createdAt;
  DateTime updatedAt;

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
    this.registerPhase,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("LAAAT ${json['addressLatitude']}");
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
      token: json['token'],
      //createdAt: DateTime(json['createdAt']),
      //updatedAt: DateTime(json['updatedAt']),
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
      };

  @override
  List<Object> get props => [
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
        token,
        createdAt,
        updatedAt
      ];
}
