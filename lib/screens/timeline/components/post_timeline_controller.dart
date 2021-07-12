import "package:mobx/mobx.dart";
import 'package:ootopia_app/data/models/timeline/like_post_result_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
part 'post_timeline_controller.g.dart';

class PostTimelineController = PostTimelineControllerBase
    with _$PostTimelineController;

abstract class PostTimelineControllerBase with Store {
  final PostRepositoryImpl repository = PostRepositoryImpl();

  @observable
  TimelinePost post;

  PostTimelineControllerBase({required this.post});

  @action
  Future<LikePostResult> likePost() async {
    LikePostResult result = await this.repository.likePost(this.post.id);
    post.liked = result.liked;
    post.likesCount = result.count;
    return result;
  }
}
