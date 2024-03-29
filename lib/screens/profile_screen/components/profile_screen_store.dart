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
  bool isFriend = false;

  @observable
  bool _deletedUser = false;

  @computed
  int get postsOffset => _postsOffset;

  @computed
  bool get hasMorePosts => _hasMorePosts;

  @computed
  bool get loadingPosts => _loadingPosts;

  @computed
  bool get deletedUser => _deletedUser;

  int get maxPostsPerPage => 12;

  @action
  Future<void> addFriend() async {
    isFriend = true;
  }

  @action
  Future<void> removeFriend() async {
    isFriend = false;
  }

  @action
  Future<void> getIfIsFriend(String userId) async {
    isFriend = await friendsRepositoryImpl.getIfIsFriends(userId);
  }

  @action
  cleanPage() {
    postsList.clear();
    _postsOffset = 0;
  }

  @action
  Future<void> getProfileDetails(String userId) async {
    loadingProfile = true;
    loadingProfileError = false;
    profile = null;
    try {
      this.profile = await repository.getProfile(userId);
      loadingProfile = false;
    } catch (err) {
      loadingProfile = false;
      loadingProfileError = true;
    }
  }

  @action
  Future<void> getUserPosts(String userId, {int? limit, int? offset}) async {
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

  String getPostType(TimelinePost post) {
    if (post.type == 'gallery' && post.medias!.length == 1) {
      return post.medias!.first.type!;
    }
    return post.type;
  }
}
