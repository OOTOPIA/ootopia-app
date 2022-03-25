import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

class FriendsStore with ChangeNotifier {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();
  bool isLoading = false;
  int page = 0;
  final int limit = 40;
  FriendsDataModel? myFriendsDate;

  Future<void> getRandomFriends(String userId) async{
    isLoading = true;
    notifyListeners();
    List<String> listOrderBy = ['name','created'];
    List<String> listSortingType = ['asc','desc'];
    Random random = new Random();

    FriendsDataModel friendsDateAux = await friendsRepositoryImpl.
    getFriendsWhenIsLogged(
      userId, 0, limit,
      orderBy: listOrderBy[random.nextInt(2)],
      sortingType: listSortingType[random.nextInt(2)],
    );
    friendsDateAux.friends!.sort((a, b) => a?.photoUrl == null ? 1 : 0);

    myFriendsDate = friendsDateAux;
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addFriend(FriendModel friend) async {
    if(myFriendsDate != null) {
      myFriendsDate!.total = (myFriendsDate?.total ?? 0) + 1;
      myFriendsDate!.friends!.add(friend);
    }

    if(friendsDate != null){
      friendsDate!.total = (friendsDate?.total ?? 0) + 1;
      friendsDate!.friends!.add(friend);
    }
    notifyListeners();
    return await friendsRepositoryImpl.addFriend(friend.id);
  }

  Future<bool> removeFriend(FriendModel friend, userLoggedId) async {
    if(friendsDate != null){
      int index = friendsDate!.friends!.indexWhere((element) => element?.id == friend.id);
      friendsDate!.friends![index]!.remove = true;
      friendsDate!.total = friendsDate!.total! - 1;
    }

    if(myFriendsDate != null){
      myFriendsDate!.total = (myFriendsDate?.total ?? 0) - 1;
      myFriendsDate!.friends!.removeWhere((element) => element!.id == friend.id);
    }

    if(hasMoreFriends && !loadingMoreFriends && orderBy!= null){
      getMoreFriends(userLoggedId);
    }

    notifyListeners();

    return await friendsRepositoryImpl.removeFriend(friend.id);
  }


  //SEARCH PAGE
  FriendsDataModel usersSearch = FriendsDataModel(total: 0, friends: []);
  bool isLoadingSearch = false;
  bool searchIsEmpty = false;
  bool hasMoreUsersSearch = true;
  bool loadingMoreUsersSearch = false;
  int pageSearch = 0;
  String lastName = '';

  void cleanSearchPage() {
    usersSearch = FriendsDataModel(total: 0, friends: []);
    isLoadingSearch = false;
    searchIsEmpty = false;
    hasMoreUsersSearch = true;
    loadingMoreUsersSearch = false;
    pageSearch = 0;
    lastName = '';
    notifyListeners();
  }

  Future<void> searchNewName(String name) async {
    if (name.replaceAll(' ', '').isNotEmpty ) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoadingSearch = true;
      notifyListeners();
      pageSearch = 0;
      usersSearch = FriendsDataModel(total: 0, friends: []);
      lastName = name;
      usersSearch = await friendsRepositoryImpl.searchFriends(name, pageSearch, limit);
      usersSearch.friends = [];

      if (usersSearch.alreadyFriends != null){
        usersSearch.friends!.addAll( usersSearch.alreadyFriends!);
      }
      usersSearch.friends!.addAll(usersSearch.searchFriends!);

      searchIsEmpty = usersSearch.friends!.isEmpty;
      hasMoreUsersSearch = usersSearch.friends!.length < usersSearch.total!;
      usersSearch.friends =  usersSearch.friends!.toSet().toList();
      isLoadingSearch = false;
      notifyListeners();
    }
  }

  Future<void> getMoreUserBySearch() async {
    if(hasMoreUsersSearch && lastName.isNotEmpty) {
      loadingMoreUsersSearch = true;
      notifyListeners();
      pageSearch++;
      FriendsDataModel auxUsers = await friendsRepositoryImpl.
      searchFriends(lastName, pageSearch, limit);
      usersSearch.friends!.addAll(auxUsers.searchFriends!);
      usersSearch.friends =  usersSearch.friends!.toSet().toList();
      loadingMoreUsersSearch = false;
      hasMoreUsersSearch = usersSearch.friends!.length < usersSearch.total!;
      notifyListeners();
    }
  }
  //END SEARCH

  //GET ALL FRIEND BY USER LOGGED
  String? orderBy;
  String? sortingType;
  List<String> listOrderBy = ['name','created'];
  List<String> listSortingType = ['asc','desc'];
  FriendsDataModel? friendsDate;
  bool hasMoreFriends = true;
  bool loadingMoreFriends = false;
  bool isLoadingGetAllFriends = false;

  void init(String userId) {
    orderBy = listOrderBy[0];
    sortingType = listSortingType[0];
    notifyListeners();
    getFriends(userId);
  }

  Future<void> getFriends(String userId) async{
    isLoadingGetAllFriends = true;
    notifyListeners();
    friendsDate?.friends = [];
    page = 0;
    FriendsDataModel friendsDateAux = await friendsRepositoryImpl.getFriendsWhenIsLogged(
      userId, page, limit, orderBy: orderBy!, sortingType: sortingType!,);
    friendsDate = friendsDateAux;
    hasMoreFriends = friendsDateAux.friends!.length == limit;
    isLoadingGetAllFriends = false;
    notifyListeners();
  }

  Future<void> getMoreFriends(userId) async {
    if(hasMoreFriends) {
      loadingMoreFriends = true;
      notifyListeners();
      page++;
      FriendsDataModel auxUsers = await friendsRepositoryImpl.getFriendsWhenIsLogged(
        userId, page, limit, orderBy: orderBy!, sortingType: sortingType!,);
      friendsDate!.friends!.addAll(auxUsers.friends!);
      friendsDate!.friends =  friendsDate!.friends!.toSet().toList();
      loadingMoreFriends = false;
      hasMoreFriends = auxUsers.friends!.length == limit;
      notifyListeners();
    }
  }

  void changeOrderBy(int index){
    if(index == 0){
      orderBy = listOrderBy[0];
      sortingType = listSortingType[0];
    }else if(index == 1){
      orderBy = listOrderBy[1];
      sortingType = listSortingType[1];
    }else{
      orderBy = listOrderBy[1];
      sortingType = listSortingType[0];
    }
  }

}