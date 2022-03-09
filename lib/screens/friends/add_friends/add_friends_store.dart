import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'add_friends_store.g.dart';

class AddFriendsStore = AddFriendsStoreBase with _$AddFriendsStore;

abstract class AddFriendsStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  List<FriendModel> users = [];

  @observable
  List<String> usersIdAdded = [];

  @observable
  bool isLoading = false;

  @observable
  bool searchIsEmpty = false;

  @observable
  bool hasMoreUsers = true;

  @observable
  bool loadingMoreUsers = false;

  int page = 0;
  String lastName = '';
  final int limit = 10;

  @action
  Future<void> searchNewName(String name) async {
    if (name.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading = true;
      page = 0;
      users = [];
      lastName = name;
      users = await friendsRepositoryImpl.searchFriends(name, page, limit);
      searchIsEmpty = users.isEmpty;
      isLoading = false;
    }
  }

  @action
  Future<void> getMoreUser() async {
    if(hasMoreUsers && lastName.isNotEmpty) {
      loadingMoreUsers = true;
      page++;
      List<FriendModel> auxUsers = await friendsRepositoryImpl.
      searchFriends(lastName, page, limit);
      users.addAll(auxUsers);
      loadingMoreUsers = false;
      hasMoreUsers = auxUsers.length == 10;
    }
  }

  @action
  Future<void> addFriend(String userId) async {
    usersIdAdded.add(userId);
    bool status = await friendsRepositoryImpl.addFriend(userId);
    if(!status){
      usersIdAdded.remove(userId);
    }
  }
}