import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
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

  @action
  Future<void> updateUser() async {
    isloading = true;
    if (formKey.currentState!.validate()) {
      var currentUser = await userRepositoryImpl.getCurrentUser();
      currentUser.bio = bioController.text;
      currentUser.fullname = fullNameController.text;
      currentUser.phone = cellPhoneController.text;
      currentUser.dailyLearningGoalInMinutes = currentSliderValue.toInt();
      if (photoFilePathLocal != null) {
        currentUser.photoFilePath = photoFilePathLocal;
      }
      await userRepositoryImpl.updateUser(currentUser, []);
      PageViewController.instance.back();
    }
    isloading = false;
  }

  @action
  Future<void> getUser() async {
    isloading = true;
    var user = await userRepositoryImpl.getCurrentUser();
    fullNameController.text = user.fullname.toString();
    if (user.bio == null) {
      bioController.text = '';
    } else {
      bioController.text = user.bio.toString();
    }
    if (user.phone == null) {
      bioController.text = '';
    } else {
      cellPhoneController.text = user.phone.toString();
    }
    if (user.dailyLearningGoalInMinutes == 0) {
      currentSliderValue = 0;
    } else {
      currentSliderValue = user.dailyLearningGoalInMinutes!.toDouble();
    }
    photoUrl = user.photoUrl;
    isloading = false;
  }

  @action
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }
}
