import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';

part 'invitation_store.g.dart';

class InvitationStore = InvitationStoreBase with _$InvitationStore;

abstract class InvitationStoreBase with Store {
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  @observable
  ObservableList<InvitationCodeModel> listInvitationCode = ObservableList();

  @observable
  bool isLoading = false;

  @action
  Future<List<InvitationCodeModel>?> getCodes() async {
    isLoading = true;
    listInvitationCode.clear();
    List<InvitationCodeModel>? response =
        await this.userRepositoryImpl.getCodes();
    if (response != null) {
      listInvitationCode.addAll(response);
    }
    isLoading = false;
    return listInvitationCode;
  }
}
