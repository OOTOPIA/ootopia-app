import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'add_friends_store.g.dart';

class AddFriendsStore = AddFriendsStoreBase with _$AddFriendsStore;

abstract class AddFriendsStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  FriendsDataModel users = FriendsDataModel(total: 0, friends: []);

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
      users = FriendsDataModel(total: 0, friends: []);
      lastName = name;
      users = await friendsRepositoryImpl.searchFriends(name, page, limit);
      searchIsEmpty = users.friends!.isEmpty;
      isLoading = false;
    }
  }

  @action
  Future<void> getMoreUserSearch() async {
    if(hasMoreUsers && lastName.isNotEmpty) {
      loadingMoreUsers = true;
      page++;
      FriendsDataModel auxUsers = await friendsRepositoryImpl.
      searchFriends(lastName, page, limit);
      users..friends!.addAll(auxUsers.friends!);
      loadingMoreUsers = false;
      hasMoreUsers = auxUsers.friends!.length == 10;
    }
  }

  @action
  Future<bool> addFriend(String userId) async {
    usersIdAdded.add(userId);
    return await friendsRepositoryImpl.addFriend(userId);
  }
}