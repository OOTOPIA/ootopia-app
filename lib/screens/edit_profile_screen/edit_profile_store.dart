import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';

part 'edit_profile_store.g.dart';

class EditProfileStore = EditProfileStoreBase with _$EditProfileStore;

abstract class EditProfileStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();

  double currentSliderValue = 0;

  String? photoUrl;

  String? photoFilePathLocal;

  @observable
  bool isloading = false;

  @observable
  bool validCellPhone = false;

  @observable
  String? countryCode;

  @observable
  User? currentUser;

  @action
  Future<void> updateUser() async {
    if (formKey.currentState!.validate()) {
      isloading = true;

      currentUser?.bio = bioController.text;
      currentUser?.fullname = fullNameController.text;
      currentUser?.phone = cellPhoneController.text;
      currentUser?.dailyLearningGoalInMinutes = currentSliderValue.toInt();
      currentUser?.countryCode = countryCode;

      if (photoFilePathLocal != null) {
        currentUser?.photoFilePath = photoFilePathLocal;
      }

      if (currentUser?.photoFilePath != null) {
        await _updateUserWithPhoto(currentUser!, []);
      } else if (currentUser != null) {
        await this.userRepositoryImpl.updateUserProfile(currentUser!, [], null);
      }
      await this.userRepositoryImpl.getMyAccountDetails();
      isloading = false;
    }
  }

  Future<String> _updateUserWithPhoto(User user, List<String> tagsIds) async {
    var completer = new Completer<String>();
    var uploader = FlutterUploader();
    var taskId = await this
        .userRepositoryImpl
        .updateUserProfile(currentUser!, [], uploader);
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
    return completer.future;
  }

  @action
  Future<void> getUser() async {
    isloading = true;
    try {
      currentUser = await userRepositoryImpl.getCurrentUser();
    } catch (err) {}
    if (currentUser != null) {
      fullNameController.text = currentUser!.fullname.toString();
      if (currentUser!.bio == null) {
        bioController.text = '';
      } else {
        bioController.text = currentUser!.bio.toString();
      }
      if (currentUser!.phone == null) {
        cellPhoneController.text = '';
      } else {
        cellPhoneController.text = currentUser!.phone.toString();
      }
      if (currentUser!.dailyLearningGoalInMinutes == 0) {
        currentSliderValue = 0;
      } else {
        currentSliderValue =
            currentUser!.dailyLearningGoalInMinutes!.toDouble();
      }
      countryCode = currentUser!.countryCode;
      photoUrl = currentUser!.photoUrl;
    }
    isloading = false;
  }

  @action
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }
}
