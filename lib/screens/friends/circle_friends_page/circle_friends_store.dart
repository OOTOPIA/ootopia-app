import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'circle_friends_store.g.dart';

class CircleFriendsStore = CircleFriendsStoreBase with _$CircleFriendsStore;

abstract class CircleFriendsStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();
  List<String> listOrderBy = ['name', 'created'];
  List<String> listSortingType = ['asc', 'desc'];
  @observable
  FriendsDataModel friendsDate = FriendsDataModel(
    total: 0,
    friends: [],
    searchFriends: [],
  );

  @observable
  bool isLoading = false;

  int page = 0;
  int limit = 10;

  @observable
  bool hasMoreFriends = true;

  @observable
  bool loadingMoreFriends = false;

  @observable
  String? orderBy;

  @observable
  String? sortingType;

  late bool userLogged;

  @action
  void init(String userId, bool userLogged) {
    if (orderBy == null) {
      this.userLogged = userLogged;
      orderBy = listOrderBy[0];
      sortingType = listSortingType[0];
      getFriends(userId);
    }
  }

  @action
  Future<void> getFriends(String userId) async {
    isLoading = true;
    friendsDate.friends = [];
    page = 0;
    late FriendsDataModel friendsDateAux;
    if (userLogged) {
      friendsDateAux = await friendsRepositoryImpl.getFriendsWhenIsLogged(
          userId, page, limit,
          orderBy: orderBy!, sortingType: sortingType!);
    } else {
      friendsDateAux = await friendsRepositoryImpl.getFriendsWhenNotIsLogged(
          userId, page, limit,
          orderBy: orderBy!, sortingType: sortingType!);
    }
    friendsDate = friendsDateAux;
    hasMoreFriends = friendsDateAux.friends!.length == limit;
    isLoading = false;
  }

  @action
  Future<void> getMoreFriends(userId) async {
    if (hasMoreFriends) {
      loadingMoreFriends = true;
      page++;
      late FriendsDataModel auxUsers;
      if (userLogged) {
        auxUsers = await friendsRepositoryImpl.getFriendsWhenIsLogged(
            userId, page, limit,
            orderBy: orderBy!, sortingType: sortingType!);
      } else {
        auxUsers = await friendsRepositoryImpl.getFriendsWhenNotIsLogged(
            userId, page, limit,
            orderBy: orderBy!, sortingType: sortingType!);
      }
      friendsDate.friends!.addAll(auxUsers.friends!);
      loadingMoreFriends = false;
      hasMoreFriends = auxUsers.friends!.length == limit;
    }
  }

  @action
  void changeOrderBy(int index) {
    if (index == 0) {
      orderBy = listOrderBy[0];
      sortingType = listSortingType[0];
    } else if (index == 1) {
      orderBy = listOrderBy[1];
      sortingType = listSortingType[1];
    } else {
      orderBy = listOrderBy[1];
      sortingType = listSortingType[0];
    }
  }
}
