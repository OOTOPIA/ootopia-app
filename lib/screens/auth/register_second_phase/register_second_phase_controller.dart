import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
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

  User? user;
  File? image;

  //Step 01
  final formKey = GlobalKey<FormState>();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();

  //Step 03
  final TextEditingController geolocationController = TextEditingController();
  FocusNode inputFocusNode = new FocusNode();
  String geolocationErrorMessage = "";
  String geolocationMessage = "Please, wait...";

  //Step 04
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
  bool validBirthDate = true;
  String? birthdateValidationErrorMessage = '';

  double currentSliderValue = 10.0;

  late AuthStore authStore;

  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }

  bool validationBirthDate() {
    DateTime now = DateTime.now();

    if (dayController.text == "" ||
        monthController.text == "" ||
        yearController.text == "") {
      validBirthDate = true;
      return false;
    }

    int day = int.parse(dayController.text);
    int month = int.parse(monthController.text);
    int year = int.parse(yearController.text);

    if (yearController.text.length == 4 &&
        day <= 31 &&
        day > 0 &&
        month <= 12 &&
        month > 0 &&
        year >= 1900 &&
        year < now.year) {
      validBirthDate = true;
      return true;
    } else {
      validBirthDate = false;
      return false;
    }
  }

  void cleanTextEditingControllers() {
    dayController.clear();
    monthController.clear();
    yearController.clear();
    bioController.clear();
    cellPhoneController.clear();
    geolocationController.clear();
  }

  void birthdateIsValid(BuildContext context, VoidCallback update) {
    if (!validationBirthDate()) {
      if (yearController.text.toString().length < 4) {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdateInFormat;
      } else {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdate;
      }

      update();
    } else {
      birthdateValidationErrorMessage = '';
      update();
    }
  }

  storeDataUserFirstStep() {
    if (validationBirthDate()) {
      user!.birthdate =
          "${yearController.text}/${monthController.text}/${dayController.text}";
    }

    user!.bio = bioController.text.isNotEmpty ? bioController.text : null;
    user!.countryCode = countryCode!.isNotEmpty ? countryCode : null;
    user!.phone =
        cellPhoneController.text.isNotEmpty ? cellPhoneController.text : null;
  }

  getImage(imagePath, VoidCallback update) {
    if (user != null && imagePath != null) {
      image = File(imagePath);
      user!.photoFilePath = imagePath;
    }
    update();
  }

  bool birthDateIsValid() {
    return validBirthDate;
  }

  bool firstStepIsValid(BuildContext context) {
    return !validCellPhone;
  }

  getLocation(BuildContext context) async {
    try {
      geolocationErrorMessage = "";
      geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
      Position position = await Geolocation.determinePosition(context);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(-23.613188481052, -46.743530564060);
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

  Future<void> updateUser() async {
    var idTags = selectedTags.map((tag) => tag.id).toList();

    try {
      if (user!.photoFilePath != null) {
        await _updateUserWithPhoto(user!, idTags);
      } else if (user != null) {
        await this.userRepository.updateUserProfile(user!, [], null);
      }
      await this.userRepository.getMyAccountDetails();
    } catch (err) {
      throw (err);
    }
  }

  Future<String> _updateUserWithPhoto(User user, List<String> tagsIds) async {
    var completer = new Completer<String>();
    var uploader = FlutterUploader();

    var taskId =
        await this.userRepository.updateUserProfile(user, tagsIds, uploader);
    uploader.result.listen(
        (result) {
          if (result.statusCode == 200 && result.taskId == taskId) {
            completer.complete(user.id);
          }
        },
        onDone: () {},
        onError: (error) {
          completer.completeError(error);
        });
    user.registerPhase = 2;
    user.dailyLearningGoalInMinutes = currentSliderValue.toInt();
    await setCurrentUser(json.encode(user.toJson()));

    return completer.future;
  }
}
