import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'circle_friends_store.g.dart';

class CircleFriendsStore = CircleFriendsStoreBase with _$CircleFriendsStore;

enum ViewState { loading, error, done, loadingNewData, refresh }


abstract class CircleFriendsStoreBase with Store {

  @observable
  ObservableList friends = ObservableList();

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
