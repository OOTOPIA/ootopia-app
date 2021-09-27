import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/interests_tags/interests_tags_model.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part "auth_store.g.dart";

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  SecureStoreMixin storage = SecureStoreMixin();

  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  final AuthRepositoryImpl authRepository = AuthRepositoryImpl();
  final InterestsTagsRepositoryImpl interestsTagsrepository =
      InterestsTagsRepositoryImpl();

  final AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  final formKey = GlobalKey<FormState>();

  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController cellPhoneController = TextEditingController();

  double currentSliderValue = 0;

  @observable
  bool validCellPhone = false;

  @observable
  String? countryCode;

  @observable
  String? birthdateValidationErrorMessage;

  @observable
  ObservableFuture<User?>? _currentUser;

  @observable
  bool isLoading = true;

  @observable
  bool errorOnGetTags = false;

  @observable
  List<InterestsTags> selectedTags = [];

  @observable
  List<InterestsTags> allTags = [];

  @action
  Future<User?> checkUserIsLogged() async =>
      this._currentUser = ObservableFuture(storage.getCurrentUser());

  @computed
  User? get currentUser => _currentUser?.value;

  @action
  setUserIsLogged() {
    this._currentUser = ObservableFuture(storage.getCurrentUser());
    AppUsageTime.instance.startTimer();
  }

  @action
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

  @action
  Future<void> searchTags(String nameTag) async {
    allTags.contains(nameTag);
  }

  @action
  void addTags(e) {
    selectedTags.add(e);
  }

  @action
  void removeTags(e) {
    selectedTags.remove(e);
  }

  @action
  Future<void> getPhoneNumber(String phoneNumber, String codeCountry) async {
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, codeCountry);
  }

  @action
  Future<void> updateUser() async {
    try {
      if (currentUser?.photoFilePath != null) {
        await _updateUserWithPhoto(currentUser!, []);
      } else if (currentUser != null) {
        await this.userRepository.updateUserProfile(currentUser!, [], null);
      }
      await this.userRepository.getMyAccountDetails();
    } catch (err) {}
  }

  Future<String> _updateUserWithPhoto(User user, List<String> tagsIds) async {
    var completer = new Completer<String>();
    var uploader = FlutterUploader();
    var taskId =
        await this.userRepository.updateUserProfile(currentUser!, [], uploader);
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
  updateUserRegenerarionGameLearningAlert(String type) async {
    try {
      await userRepository.updateUserRegenerarionGameLearningAlert(type);

      await storage.updateUserRegenerarionGameLearningAlert(type);
      this.setUserIsLogged();
    } catch (e) {}
  }

  @action
  logout() async {
    try {
      await AppUsageTime.instance.sendToApi();
    } catch (err) {}
    await Future.delayed(Duration(milliseconds: 500), () async {
      AppUsageTime.instance.stopTimer();
      await storage.cleanAuthToken();
      this._currentUser = null;
    });
  }

  @action
  Future<bool> registerUser(
      {required String name,
      required String password,
      required String email,
      String? invitationCode,
      required BuildContext context}) async {
    try {
      var result =
          await authRepository.register(name, email, password, invitationCode);
      this
          .trackingEvents
          .trackingSignupCompletedSignup(result.id!, result.fullname!);
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}
