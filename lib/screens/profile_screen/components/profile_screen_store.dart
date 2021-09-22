import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
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
      if (limit == null && offset == null) {
        postsList.clear();
      }
      List<TimelinePost> posts =
          await postsRepository.getPosts(limit, offset, userId);
      postsList.addAll(posts);
      loadingPosts = false;
      return this.postsList;
    } catch (err) {
      loadingPosts = false;
      loadingPostsError = true;
    }
  }
}
