import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterSecondPhaseController {
  User? user;
  File? image;

  final formKey = GlobalKey<FormState>();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();

  final picker = ImagePicker();

  String? countryCode;
  bool validCellPhone = false;
  String? birthdateValidationErrorMessage = '';

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
}
