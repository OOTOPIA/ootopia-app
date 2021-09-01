import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'insert_invitation_code_store.g.dart';

class InsertInvitationCode = InsertInvitationCodeStore
    with _$InsertInvitationCode;

abstract class InsertInvitationCodeStore with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  @action
  Future<String> getCodes(String code) async {
    return await this.userRepositoryImpl.verifyCodes(code);
  }
}
