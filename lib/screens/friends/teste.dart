import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

class FriendsStore with ChangeNotifier {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();


  bool isLoading = false;
  int page = 0;
  final int limit = 10;
  FriendsDataModel? myFriendsDate;

  Future<void> getRandomFriends(String userId) async{
    isLoading = true;
    notifyListeners();
    List<String> listOrderBy = ['name','created'];
    List<String> listSortingType = ['asc','desc'];
    Random random = new Random();

    FriendsDataModel friendsDateAux = await friendsRepositoryImpl.
    getFriends(
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
    print('add');
    myFriendsDate?.total = (myFriendsDate?.total ?? 0) + 1;
    myFriendsDate?.friends!.add(friend);
    notifyListeners();
    return await friendsRepositoryImpl.addFriend(friend.id);
  }

  Future<bool> removeFriend(FriendModel friend, {int? index}) async {
    if(index != null){
      friendsDate!.friends![index]!.remove = true;
      friendsDate!.total = friendsDate!.total! - 1;
    }

    myFriendsDate?.total = (myFriendsDate?.total ?? 0) - 1;
    myFriendsDate?.friends!.removeWhere((element) => element!.id == friend.id);
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
  }

  Future<void> searchNewName(String name) async {
    if (name.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      isLoadingSearch = true;
      notifyListeners();
      pageSearch = 0;
      usersSearch = FriendsDataModel(total: 0, friends: []);
      lastName = name;
      usersSearch = await friendsRepositoryImpl.searchFriends(name, pageSearch, limit);
      searchIsEmpty = usersSearch.friends!.isEmpty;
      isLoadingSearch = false;
      notifyListeners();
    }
  }

  Future<void> getMoreUserBySearch() async {
    if(hasMoreUsersSearch && lastName.isNotEmpty) {
      loadingMoreUsersSearch = true;
      pageSearch++;
      FriendsDataModel auxUsers = await friendsRepositoryImpl.
      searchFriends(lastName, pageSearch, limit);
      usersSearch.friends!.addAll(auxUsers.friends!);
      loadingMoreUsersSearch = false;
      hasMoreUsersSearch = auxUsers.friends!.length == 10;
    }
  }
  //END SEARCH


  //GET IF IS FRIEND
  // bool isFriend = false;
  //
  // Future<bool> getIfIsFriend(String userId) async {
  //   isFriend =  await friendsRepositoryImpl.getIfIsFriends(userId);
  //   return isFriend;
  // }
  //END GET IF IS FRIEND


  //GET ALL FRIEND BY USER LOGGED
  String? orderBy;
  String? sortingType;
  List<String> listOrderBy = ['name','created'];
  List<String> listSortingType = ['asc','desc'];
  FriendsDataModel? friendsDate;
  bool hasMoreFriends = true;
  bool loadingMoreFriends = false;
  bool isloadingA = false;

  void init(String userId) {
    if(orderBy == null){
      orderBy = listOrderBy[0];
      sortingType = listSortingType[0];
      getFriends(userId);
    }
  }

  Future<void> getFriends(String userId) async{
    isloadingA = true;
    notifyListeners();
    friendsDate?.friends = [];
    page = 0;
    FriendsDataModel friendsDateAux = await friendsRepositoryImpl.
    getFriends(userId, page, limit, orderBy: orderBy!, sortingType:
    sortingType!);
    friendsDate = friendsDateAux;
    hasMoreFriends = friendsDateAux.friends!.length == limit;
    isloadingA = false;
    notifyListeners();
  }

  Future<void> getMoreFriends(userId) async {
    if(hasMoreFriends) {
      loadingMoreFriends = true;
      notifyListeners();
      page++;
      FriendsDataModel auxUsers = await friendsRepositoryImpl.getFriends
        (userId, page, limit, orderBy: orderBy!, sortingType: sortingType!);
      friendsDate!.friends!.addAll(auxUsers.friends!);
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