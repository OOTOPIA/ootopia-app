import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friends_data_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'circle_friends_store.g.dart';

class CircleFriendsStore = CircleFriendsStoreBase with _$CircleFriendsStore;

abstract class CircleFriendsStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  late FriendsDataModel friendsDate;

  @observable
  bool isLoading = false;

  int page = 0;
  int limit = 10;

  @action
  Future<void> getFriends(String userId) async{
    isLoading = true;
    friendsDate = await friendsRepositoryImpl.getFriends(userId, page, limit);
    isLoading = false;
  }
}
