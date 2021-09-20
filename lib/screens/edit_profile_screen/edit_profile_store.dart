import 'package:flutter/cupertino.dart';
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
  late User currentUser;

  @action
  Future<void> updateUser() async {
    isloading = true;
    if (formKey.currentState!.validate()) {
      currentUser.bio = bioController.text;
      currentUser.fullname = fullNameController.text;
      currentUser.phone = cellPhoneController.text;
      currentUser.dailyLearningGoalInMinutes = currentSliderValue.toInt();
      currentUser.countryCode = countryCode;

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
    currentUser = await userRepositoryImpl.getCurrentUser();
    fullNameController.text = currentUser.fullname.toString();
    if (currentUser.bio == null) {
      bioController.text = '';
    } else {
      bioController.text = currentUser.bio.toString();
    }
    if (currentUser.phone == null) {
      bioController.text = '';
    } else {
      cellPhoneController.text = currentUser.phone.toString();
    }
    if (currentUser.dailyLearningGoalInMinutes == 0) {
      currentSliderValue = 0;
    } else {
      currentSliderValue = currentUser.dailyLearningGoalInMinutes!.toDouble();
    }
    countryCode = currentUser.countryCode;
    photoUrl = currentUser.photoUrl;
    isloading = false;
  }

  @action
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }
}
