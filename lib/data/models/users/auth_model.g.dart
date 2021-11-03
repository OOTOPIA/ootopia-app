// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) {
  return Auth(
    id: json['id'] as String?,
    fullname: json['fullname'] as String?,
    email: json['email'] as String?,
    password: json['password'] as String?,
    invitationCode: json['invitationCode'] as String?,
    birthdate: json['birthdate'] as String?,
    photoUrl: json['photoUrl'] as String?,
    photoFilePath: json['photoFilePath'] as String?,
    addressCountryCode: json['addressCountryCode'] as String?,
    addressState: json['addressState'] as String?,
    addressCity: json['addressCity'] as String?,
    bio: json['bio'] as String?,
    phone: json['phone'] as String?,
    addressLatitude: (json['addressLatitude'] as num?)?.toDouble(),
    addressLongitude: (json['addressLongitude'] as num?)?.toDouble(),
    dailyLearningGoalInMinutes: json['dailyLearningGoalInMinutes'] as int?,
    enableSustainableAds: json['enableSustainableAds'] as bool?,
    dontAskAgainToConfirmGratitudeReward:
        json['dontAskAgainToConfirmGratitudeReward'] as bool?,
    token: json['token'] as String?,
    personalDialogOpened: json['personalDialogOpened'] as bool?,
    cityDialogOpened: json['cityDialogOpened'] as bool?,
    globalDialogOpened: json['globalDialogOpened'] as bool?,
    personalTrophyQuantity: json['personalTrophyQuantity'] as int?,
    cityTrophyQuantity: json['cityTrophyQuantity'] as int?,
    globalTrophyQuantity: json['globalTrophyQuantity'] as int?,
    totalTrophyQuantity: json['totalTrophyQuantity'] as int?,
    countryCode: json['countryCode'] as String?,
    dialCode: json['dialCode'] as String?,
    registerPhase: json['registerPhase'] as int?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    badges: (json['badges'] as List<dynamic>?)
        ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'password': instance.password,
      'invitationCode': instance.invitationCode,
      'birthdate': instance.birthdate,
      'photoUrl': instance.photoUrl,
      'photoFilePath': instance.photoFilePath,
      'addressCountryCode': instance.addressCountryCode,
      'addressState': instance.addressState,
      'addressCity': instance.addressCity,
      'bio': instance.bio,
      'phone': instance.phone,
      'addressLatitude': instance.addressLatitude,
      'addressLongitude': instance.addressLongitude,
      'dailyLearningGoalInMinutes': instance.dailyLearningGoalInMinutes,
      'enableSustainableAds': instance.enableSustainableAds,
      'dontAskAgainToConfirmGratitudeReward':
          instance.dontAskAgainToConfirmGratitudeReward,
      'token': instance.token,
      'personalDialogOpened': instance.personalDialogOpened,
      'cityDialogOpened': instance.cityDialogOpened,
      'globalDialogOpened': instance.globalDialogOpened,
      'personalTrophyQuantity': instance.personalTrophyQuantity,
      'cityTrophyQuantity': instance.cityTrophyQuantity,
      'globalTrophyQuantity': instance.globalTrophyQuantity,
      'totalTrophyQuantity': instance.totalTrophyQuantity,
      'countryCode': instance.countryCode,
      'dialCode': instance.dialCode,
      'registerPhase': instance.registerPhase,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'badges': instance.badges,
    };
