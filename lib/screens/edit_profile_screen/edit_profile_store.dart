import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'edit_profile_store.g.dart';

class EditProfileStore = EditProfileStoreBase with _$EditProfileStore;

abstract class EditProfileStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();
  double currentSliderValue = 0;

  String? photoUrl;
  @observable
  bool isloading = false;

  @action
  Future<void> updateUser() async {
    var user = await userRepositoryImpl.updateUser(User(), []);
  }

  @action
  Future<void> getUser() async {
    isloading = true;
    var user = await userRepositoryImpl.getCurrentUser();
    fullNameController.text = user.fullname.toString();
    if (user.addressCity == null) {
      bioController.text = '';
    } else {
      bioController.text = user.addressCity.toString();
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
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, codeCountry);
    print(cellPhoneController.text);
  }
}
