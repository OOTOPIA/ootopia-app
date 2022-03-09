import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'circle_friends_widget_store.g.dart';

class CircleFriendsWidgetStore = CircleFriendsWidgetStoreBase with _$CircleFriendsWidgetStore;

abstract class CircleFriendsWidgetStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  FriendsDataModel? friendsDate;

  @observable
  bool isLoading = false;

  int page = 0;
  final int limit = 10;

  @action
  Future<void> getFriends(String userId) async{
    List<String> listOrderBy = ['name','created'];
    List<String> listSortingType = ['asc','desc'];
    Random random = new Random();
    isLoading = true;
    FriendsDataModel friendsDateAux = await friendsRepositoryImpl.
    getFriends(
      userId, page, limit,
      orderBy: listOrderBy[random.nextInt(2)],
      sortingType: listSortingType[random.nextInt(2)],
    );
    friendsDate = friendsDateAux;
    friendsDate!.friends!.sort((a, b) => a?.photoUrl == null ? 1 : 0);
    isLoading = false;
  }
}
