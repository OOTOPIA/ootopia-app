import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'edit_profile_store.g.dart';

class EditProfileStore = EditProfileStoreBase with _$EditProfileStore;

abstract class EditProfileStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  @action
  Future<String> updateUser(String code) async {
    var statusCode = await userRepositoryImpl.verifyCodes(code);

    return statusCode;
  }
}
