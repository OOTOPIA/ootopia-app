import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';

part 'circle_friends_widget_store.g.dart';

class CircleFriendsWidgetStore = CircleFriendsWidgetStoreBase with _$CircleFriendsWidgetStore;

abstract class CircleFriendsWidgetStoreBase with Store {
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();

  @observable
  List friends = [];

  @observable
  bool isLoading = false;

  @action
  Future<void> getFriends(String userId) async{
    isLoading = true;
    friends = await friendsRepositoryImpl.getFriends(userId);
    isLoading = false;
  }
}
