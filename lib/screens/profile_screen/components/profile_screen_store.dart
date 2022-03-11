import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/repositories/friends_repository.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
part 'profile_screen_store.g.dart';

class ProfileScreenStore = _ProfileScreenStoreBase with _$ProfileScreenStore;

abstract class _ProfileScreenStoreBase with Store {
  UserRepositoryImpl repository = UserRepositoryImpl();
  FriendsRepositoryImpl friendsRepositoryImpl = FriendsRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();

  @observable
  bool loadingProfile = false;

  @observable
  bool loadingProfileError = false;

  @observable
  bool _loadingPosts = false;

  @observable
  bool loadingPostsError = false;

  @observable
  Profile? profile;

  @observable
  ObservableList<TimelinePost> postsList = ObservableList();

  @observable
  int _postsOffset = 0;

  @observable
  bool _hasMorePosts = false;

  @observable
  bool? isFriend;

  @computed
  int get postsOffset => _postsOffset;

  @computed
  bool get hasMorePosts => _hasMorePosts;

  @computed
  bool get loadingPosts => _loadingPosts;

  int get maxPostsPerPage => 12;

  @action
  Future<bool> addFriend() async {
    isFriend = true;
    return  await friendsRepositoryImpl.addFriend(profile!.id);
  }

  @action
  Future<bool> removeFriend() async {
    isFriend = false;
    return await friendsRepositoryImpl.removeFriends(profile!.id);
  }

  @action
  Future<bool> getIfIsFriend(String userId) async {
    isFriend =  await friendsRepositoryImpl.getIfIsFriends(userId);
    return isFriend!;
  }

  @action
  Future<Profile?> getProfileDetails(String userId) async {
    loadingProfile = true;
    loadingProfileError = false;
    profile = null;
    try {
      this.profile = await repository.getProfile(userId);
      loadingProfile = false;
      return this.profile;
    } catch (err) {
      loadingProfile = false;
      loadingProfileError = true;
    }
  }

  @action
  Future<List<TimelinePost>?> getUserPosts(String userId,
      {int? limit, int? offset}) async {
    loadingPostsError = false;
    try {
      if (postsList.length != 0) {
        _loadingPosts = true;
      }
      if ((limit == null && offset == null) && _loadingPosts == false) {
        postsList.clear();
      }

      List<TimelinePost> posts = await postsRepository.getPosts(
          (limit != null ? limit : maxPostsPerPage),
          (offset != null ? offset : _postsOffset),
          userId);

      _hasMorePosts = posts.length == maxPostsPerPage;
      _postsOffset = _postsOffset + maxPostsPerPage;

      postsList.addAll(posts);
      _loadingPosts = false;
      return this.postsList;
    } catch (err) {
      _loadingPosts = false;
      loadingPostsError = true;
    }
  }

  goToTimelinePost(
      {required ObservableList<TimelinePost> posts,
      required postSelected,
      required String userId,
      required SmartPageController controller}) {
    controller.insertPage(
      TimelineScreenProfileScreen(
        {
          "userId": userId,
          "posts": posts,
          "postSelected": postSelected,
        },
      ),
    );
  }
}
