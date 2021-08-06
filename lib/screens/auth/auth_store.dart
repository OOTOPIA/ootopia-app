import "package:mobx/mobx.dart";
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part "auth_store.g.dart";

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  SecureStoreMixin storage = SecureStoreMixin();

  final UserRepositoryImpl userRepository = UserRepositoryImpl();

  @observable
  ObservableFuture<User?>? _currentUser;

  @action
  Future<User?> checkUserIsLogged() =>
      this._currentUser = ObservableFuture(storage.getCurrentUser());

  @computed
  User? get currentUser => _currentUser?.value;

  @action
  setUserIsLogged() {
    this._currentUser = ObservableFuture(storage.getCurrentUser());
    AppUsageTime.instance.startTimer();
  }

  @action
  logout() async {
    print("LOGOUT >>>>>>>>");
    try {
      print("SEND TO API >>>>>>>>");
      await AppUsageTime.instance.sendToApi();
    } catch (err) {}
    Future.delayed(Duration(milliseconds: 100), () async {
      print("STOP???? >>>>>>>>");
      AppUsageTime.instance.stopTimer();
      await storage.cleanAuthToken();
      this._currentUser = null;
      print("WTF >>>>>>>>");
    });
  }
}
