import 'dart:async';

import 'package:flutter/material.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/users/auth_model.dart';
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

  double currentSliderValue = 0;

  @observable
  ObservableFuture<User?>? _currentUser;

  @observable
  bool isLoading = true;

  @observable
  bool errorOnGetTags = false;

  @observable
  bool emailExist = false;

  @action
  Future<void> checkEmailExist(String email) async =>
      emailExist = await authRepository.emailExist(email);

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
  updateUserRegenerarionGameLearningAlert(String type) async {
    try {
      await userRepository.updateUserRegenerarionGameLearningAlert(type);

      await storage.updateUserRegenerarionGameLearningAlert(type);
      this.setUserIsLogged();
    } catch (e) {}
  }

  @action
  Future login(String email, String password) async {
    try {
      var result = (await this.authRepository.login(email, password));
      if (result != null) {
        User user = result;
        this.trackingEvents.trackingLoggedIn(user.id!, user.fullname!);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage == "INVALID_PASSWORD") {
        throw (errorMessage);
      } else {
        throw ("Error on login");
      }
    }
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

  //TODO colocar criar controller para a register_first_phase
  @action
  Future<bool> registerUser(
      {required String name,
      required String password,
      required String email,
      String? invitationCode,
      required BuildContext context}) async {
    try {
      Auth user = Auth(
          fullname: name,
          email: email,
          password: password,
          invitationCode: invitationCode);

      var result = await authRepository.register(user, [], null);
      this
          .trackingEvents
          .trackingSignupCompletedSignup(result.id!, result.fullname!);
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  @action
  Future resetPassword(String newPassword) async {
    try {
      await this.authRepository.resetPassword(newPassword);
      this.trackingEvents.userResetPassword()();
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage == "TOKEN_EXPIRED") {
        throw ("O token expirou. Envie o e-mail para iniciar o processo de recuperação de senha novamente.");
      } else {
        throw ("Ocorreu um erro ao atualizar a senha. Tente novamente.");
      }
    }
  }

  @action
  Future recoverPassword(String email, String lang) async {
    try {
      await this.authRepository.recoverPassword(email, lang);
      this.trackingEvents.userRecoverPassword();
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage == "USER_NOT_FOUND") {
        throw (errorMessage);
      } else {
        throw ("Ocorreu um erro ao recuperar a senha. Tente novamente.");
      }
    }
  }
}
