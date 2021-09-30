import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/geolocation.dart';

class RegisterSecondPhaseController {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

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
  List<InterestsTags> selectedTags = [];
  List<InterestsTags> allTags = [];

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
  String? birthdateValidationErrorMessage = '';

  double currentSliderValue = 10.0;

  late AuthStore authStore;

  RegisterSecondPhaseController();

  Future getLoggedUser() async {
    user = authStore.currentUser;
  }

  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }

  bool birthdateIsValid() {
    try {
      DateTime now = DateTime.now();
      int day = int.parse(dayController.text);
      int month = int.parse(monthController.text);
      int year = int.parse(yearController.text);

      return yearController.text.length == 4 &&
          day <= 31 &&
          month <= 12 &&
          year >= 1900 &&
          year < now.year;
    } catch (error) {
      return false;
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (user != null && pickedFile != null) {
      image = File(pickedFile.path);
      user!.photoFilePath = pickedFile.path;
    }
  }

  bool firstStepIsValid(BuildContext context) {
    if (birthdateIsValid()) {
      if (formKey.currentState!.validate()) {}
    } else {
      String year = yearController.text;
      if (year.length < 4) {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdateInFormat;
      } else {
        birthdateValidationErrorMessage =
            AppLocalizations.of(context)!.pleaseEnterAValidBirthdate;
      }
    }

    return birthdateIsValid() && !validCellPhone;
  }

  getLocation(BuildContext context) {
    geolocationErrorMessage = "";
    geolocationMessage = AppLocalizations.of(context)!.pleaseWait;
    Geolocation.determinePosition(context).then((Position position) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // setState(() {
      if (placemarks.length > 0) {
        var placemark = placemarks[0];
        print("Placemark: ${placemark.toJson()}");
        geolocationController.text =
            "${placemark.subAdministrativeArea}, ${placemark.administrativeArea} - ${placemark.country}";

        user!.addressCity = placemark.subAdministrativeArea;
        user!.addressState = placemark.administrativeArea;
        user!.addressCountryCode = placemark.isoCountryCode;
        user!.addressLatitude = position.latitude;
        user!.addressLongitude = position.longitude;

        this.trackingEvents.signupCompletedStepIIIOfSignupII({
          // "addressCity": widget.args['user'].addressCity,
          // "addressState": widget.args['user'].addressState,
          // "addressCountryCode": widget.args['user'].addressCountryCode,
        });
      } else {
        geolocationMessage =
            AppLocalizations.of(context)!.failedToGetCurrentLocation;
        geolocationErrorMessage =
            AppLocalizations.of(context)!.weCouldntGetYourLocation;
      }
      // });
    }).onError((error, stackTrace) {
      // setState(() {
      geolocationMessage =
          AppLocalizations.of(context)!.failedToGetCurrentLocation;
      geolocationErrorMessage = error.toString();
      // });
    });
  }

  Future<void> getTags() async {
    allTags = await this.authStore.interestsTagsrepository.getTags();
    authStore.isLoading = false;
  }

  List<InterestsTags> filterTagsByText(String text) {
    return allTags
        .where((tag) => tag.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
