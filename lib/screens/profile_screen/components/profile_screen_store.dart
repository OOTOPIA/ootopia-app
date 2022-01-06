import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
part 'profile_screen_store.g.dart';

class ProfileScreenStore = _ProfileScreenStoreBase with _$ProfileScreenStore;

abstract class _ProfileScreenStoreBase with Store {
  UserRepositoryImpl repository = UserRepositoryImpl();
  PostRepositoryImpl postsRepository = PostRepositoryImpl();

  @observable
  bool loadingProfile = false;

  @observable
  bool loadingProfileError = false;

  @observable
  bool loadingPosts = false;

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

  @computed
  int get postsOffset => _postsOffset;

  @computed
  bool get hasMorePosts => _hasMorePosts;

  bool _loadingMorePosts = false;

  int get maxPostsPerPage => 10;

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
    loadingPosts = true;
    loadingPostsError = false;
    try {
      if (postsList.length != 0) {
        _loadingMorePosts = true;
      }
      if ((limit == null && offset == null) && _loadingMorePosts == false) {
        postsList.clear();
      }

      List<TimelinePost> posts = await postsRepository.getPosts(
          (limit != null ? limit : maxPostsPerPage),
          (offset != null ? offset : _postsOffset),
          userId);

      _hasMorePosts = posts.length == maxPostsPerPage;
      _postsOffset = _postsOffset + maxPostsPerPage;

      postsList.addAll(posts);
      loadingPosts = false;
      return this.postsList;
    } catch (err) {
      loadingPosts = false;
      loadingPostsError = true;
      _loadingMorePosts = false;
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
