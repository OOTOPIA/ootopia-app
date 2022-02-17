import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'add_friends_store.g.dart';

class AddFriendsStore = AddFriendsStoreBase with _$AddFriendsStore;

abstract class AddFriendsStoreBase with Store {

  @observable
  ObservableList users = ObservableList();

  @observable
  bool isLoading = false;

  @action
  Future<void> searchName(String name) async{
    if(name.isNotEmpty){
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading = true;
      print(isLoading);
      Future.delayed(Duration(milliseconds: 1000),(){
        isLoading = false;
      });
      // listInvitationCode.clear();
      // List<InvitationCodeModel>? response =
      //     await this.userRepositoryImpl.getCodes();
      // if (response != null) {
      //   listInvitationCode.addAll(response);
      // }
      //isLoading = false;
    }

  }
}
