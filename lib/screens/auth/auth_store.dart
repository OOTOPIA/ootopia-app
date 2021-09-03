import 'package:flutter/material.dart';
import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/repositories/auth_repository.dart';
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
  final AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  @observable
  ObservableFuture<User?>? _currentUser;

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
