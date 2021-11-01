import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/users/auth_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/geolocation.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class RegisterSecondPhaseController with SecureStoreMixin {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  final AuthRepositoryImpl authRepository = AuthRepositoryImpl();

  User? user;
  File? image;
  String? photoFilePath;
  String returnToPage = "homeScreen";

  //Step 01
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  //Step 02
  TextEditingController codeController = TextEditingController();

  //Step 03
  TextEditingController dayController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();

  //Step 04
  TextEditingController geolocationController = TextEditingController();
  FocusNode inputFocusNode = new FocusNode();
  String geolocationErrorMessage = "";
  String geolocationMessage = "Please, wait...";

  //Step 05
  List<InterestsTagsModel> selectedTags = [];
  String currentLocaleName = '';
  List<InterestsTagsModel> allTags = [];
  List<InterestsTagsModel> filterTags = [];

  static RegisterSecondPhaseController? _instance;

  static RegisterSecondPhaseController getInstance() {
    if (_instance == null) {
      _instance = new RegisterSecondPhaseController();
    }

    return _instance!;
  }

  final picker = ImagePicker();

  String? countryCode;
  bool validCellPhone = false;
  bool exibTextError = false;
  String? birthdateValidationErrorMessage = '';

  double currentSliderValue = 10.0;

  late AuthStore authStore;

  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }

  bool validationBirthDate() {
    DateTime now = DateTime.now();

    if (dayController.text.isEmpty &&
        monthController.text.isEmpty &&
        yearController.text.isEmpty) {
      return true;
    }

    var day =
        int.parse(dayController.text.isNotEmpty ? dayController.text : '0');
    var month =
        int.parse(monthController.text.isNotEmpty ? monthController.text : '0');
    var year =
        int.parse(yearController.text.isNotEmpty ? yearController.text : '0');
    if ((day > 0 && day <= 31) &&
        (month > 0 && month <= 12) &&
        (year > 1900 && year <= now.year)) {
      return true;
    } else {
      exibTextError = true;
      return false;
    }
  }

  void cleanTextEditingControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    codeController.clear();
    dayController.clear();
    monthController.clear();
    yearController.clear();
    bioController.clear();
    cellPhoneController.clear();
    geolocationController.clear();
    photoFilePath = null;
    image = null;
    user = User();
  }

  void birthdateIsValid(BuildContext context, VoidCallback update) {
    if (!validationBirthDate()) {
      if (yearController.text.toString().length < 4 &&
          monthController.text.toString().length < 2 &&
          dayController.text.toString().length < 2) {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdateInFormat;
      } else {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdate;
      }

      update();
    } else {
      exibTextError = false;

      birthdateValidationErrorMessage = '';
      update();
    }
  }

  setBirthDateAndCountryCode() {
    if (validationBirthDate()) {
      user!.birthdate =
          "${yearController.text}/${monthController.text}/${dayController.text}";
    }
    user!.countryCode = countryCode!.isNotEmpty ? countryCode : null;
  }

  getImage(imagePath, VoidCallback update) {
    if (user != null && imagePath != null) {
      image = File(imagePath);
      photoFilePath = imagePath;
    }
    update();
  }

  bool firstStepIsValid() {
    print('validate ${validationBirthDate()}');
    print('celphone $validCellPhone');
    return !validCellPhone && validationBirthDate();
  }

  getLocation(BuildContext context) async {
    try {
      geolocationErrorMessage = "";
      geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
      Position position = await Geolocation.determinePosition(context);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.length > 0) {
        var placemark = placemarks[0];
        geolocationController.text =
            "${placemark.subAdministrativeArea != '' ? placemark.subAdministrativeArea : placemark.locality}, ${placemark.administrativeArea} - ${placemark.country}";

        user!.addressCity = placemark.subAdministrativeArea != ''
            ? placemark.subAdministrativeArea
            : placemark.locality;
        user!.addressState = placemark.administrativeArea;
        user!.addressCountryCode = placemark.isoCountryCode;
        user!.addressLatitude = position.latitude;
        user!.addressLongitude = position.longitude;

        this.trackingEvents.signupCompletedStepIIIOfSignupII({
          "addressCity": user!.addressCity,
          "addressState": user!.addressState,
          "addressCountryCode": user!.addressCountryCode,
        });
        geolocationErrorMessage = "";
        geolocationMessage = "";
      } else {
        geolocationMessage =
            AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage =
            AppLocalizations.of(context)!.weCouldntGetYourLocation;
      }
    } catch (error) {
      geolocationMessage =
          AppLocalizations.of(context)!.failedToGetCurrentLocation;
      geolocationErrorMessage = error.toString();
    }
  }

  Future<void> getTags(String? language) async {
    allTags = await this.authStore.interestsTagsrepository.getTags(language);
    authStore.isLoading = false;
  }

  updateLocalName() async {
    if (currentLocaleName != Platform.localeName.substring(0, 2)) {
      currentLocaleName = Platform.localeName.substring(0, 2);
      await getTags(currentLocaleName);
      selectedTags = [];
    }
  }

  void filterTagsByText({required String text, required VoidCallback update}) {
    filterTags = allTags
        .where((tag) => tag.name.toLowerCase().contains(text.toLowerCase()))
        .toList();

    update();
  }

  Future registerUser() async {
    Auth _user = Auth(
      fullname: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      countryCode: user!.countryCode,
      bio: bioController.text,
      phone: cellPhoneController.text,
      birthdate: user!.birthdate,
      invitationCode: codeController.text,
      dailyLearningGoalInMinutes: currentSliderValue.toInt(),
      addressCountryCode: user!.addressCountryCode,
      addressState: user!.addressState,
      addressCity: user!.addressCity,
      addressLatitude: user!.addressLatitude,
      addressLongitude: user!.addressLongitude,
      photoFilePath: photoFilePath,
      registerPhase: 2,
    );

    List<String> tagsIds = selectedTags.map((e) => e.id).toList();

    try {
      if (_user.photoFilePath != null) {
        await registerUserWithPhoto(_user, tagsIds);
        await authRepository.login(_user.email!, _user.password!);
      } else {
        await this.authRepository.register(_user, tagsIds, null);
        await authRepository.login(_user.email!, _user.password!);
      }
    } catch (err) {
      throw (err);
    }
  }

  Future<String> registerUserWithPhoto(_user, tagsIds) async {
    var completer = new Completer<String>();
    var uploader = FlutterUploader();

    var taskId = await this.authRepository.register(_user, tagsIds, uploader);
    uploader.result.listen(
      (result) {
        if (result.statusCode == 201 && result.taskId == taskId) {
          completer.complete('completed');
        }
      },
      onDone: () {},
      onError: (error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }
}
