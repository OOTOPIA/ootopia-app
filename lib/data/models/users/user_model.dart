import 'package:equatable/equatable.dart';

class User extends Equatable {
  String id;
  String fullname;
  String email;
  String birthdate;
  String photoUrl;
  int dailyLearningGoalInMinutes;
  bool enableSustainableAds = false;
  String token;
  DateTime createdAt;
  DateTime updatedAt;

  User(
      {this.id,
      this.fullname,
      this.email,
      this.birthdate,
      this.photoUrl,
      this.dailyLearningGoalInMinutes,
      this.enableSustainableAds,
      this.token,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      birthdate: json['birthdate'],
      photoUrl: json['photoUrl'],
      dailyLearningGoalInMinutes: int.parse(json['dailyLearningGoalInMinutes']),
      enableSustainableAds: (json['enableSustainableAds'] == null
          ? false
          : json['enableSustainableAds']),
      token: json['token'],
      //createdAt: DateTime(json['createdAt']),
      //updatedAt: DateTime(json['updatedAt']),
    );
  }

  @override
  List<Object> get props => [
        id,
        fullname,
        email,
        birthdate,
        photoUrl,
        dailyLearningGoalInMinutes,
        enableSustainableAds,
        token,
        createdAt,
        updatedAt
      ];
}
