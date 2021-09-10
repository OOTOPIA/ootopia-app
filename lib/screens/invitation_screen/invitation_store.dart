import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'invitation_store.g.dart';

class InvitationStore = InvitationStoreBase with _$InvitationStore;

abstract class InvitationStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();
  List<InvitationCodeModel> listInvitationCode = [];
  @action
  Future<List<InvitationCodeModel>?> getCodes() async {
    var response = await this.userRepositoryImpl.getCodes();
    response!.forEach((element) {
      listInvitationCode.add(element);
    });
    return response;
  }
}
