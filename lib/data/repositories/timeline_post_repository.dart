import 'package:ootopia_app/data/models/timeline_post_model.dart';

abstract class TimelinePostRepository {
  Future<List<TimelinePost>> getPosts();
}

class TimelinePostRepositoryImpl implements TimelinePostRepository {
  @override
  Future<List<TimelinePost>> getPosts() async {
    var response = await http.get(AppStrings.cricArticleUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Articles> articles = ApiResultModel.fromJson(data).articles;
      return articles;
    } else {
      throw Exception();
    }
  }
}
