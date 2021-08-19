import 'package:mobx/mobx.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
part 'timeline_profile_store.g.dart';

class TimelineProfileStore = _TimelineProfileStoreBase
    with _$TimelineProfileStore;

abstract class _TimelineProfileStoreBase with Store {
  PostRepositoryImpl repository = PostRepositoryImpl();

  @observable
  List<TimelinePost> posts = [];

  @observable
  TimelinePost? post;

  @action
  Future<TimelinePost> getPostById(String id) async {
    return post = await this.repository.getPostById(id);
  }
}
