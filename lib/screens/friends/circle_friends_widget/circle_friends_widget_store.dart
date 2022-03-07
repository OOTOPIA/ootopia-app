import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'circle_friends_widget_store.g.dart';

class CircleFriendsWidgetStore = CircleFriendsWidgetStoreBase with _$CircleFriendsWidgetStore;

abstract class CircleFriendsWidgetStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  List<FriendModel> friends = [];

  @observable
  bool isLoading = false;

  int page = 0;
  final int limit = 10;

  @action
  Future<void> getFriends(String userId) async{
    isLoading = true;
    List<FriendModel> friendsAux = await friendsRepositoryImpl.getFriends(userId, page, limit);
    friends.addAll(friendsAux);
    print('testd ${friends[0].photoUrl}');
    print('friends ${friends.length}');
    isLoading = false;
  }
}
