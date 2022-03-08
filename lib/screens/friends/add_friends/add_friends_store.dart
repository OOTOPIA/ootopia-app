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

  int page = 0;
  final int limit = 10;

  @action
  Future<void> searchNewName(String name) async {
    if (name.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoading = true;
      page = 0;
      users = [];
      users = await friendsRepositoryImpl.searchFriends(name, page, limit);

      print('\n\n ${users.length}');

      searchIsEmpty = users.isEmpty;
      isLoading = false;
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