import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'insert_invitation_code_store.g.dart';

class InsertInvitationCodeStore = InsertInvitationCodeStoreBase
    with _$InsertInvitationCodeStore;

abstract class InsertInvitationCodeStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  @action
  Future<String> verifyCodes(String code) async {
    var statusCode = await userRepositoryImpl.verifyCodes(code);

    return statusCode;
  }
}
