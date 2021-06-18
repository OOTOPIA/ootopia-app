import 'package:ootopia_app/data/BD/database.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_model.dart';
import 'package:ootopia_app/data/BD/watch_video/watch_video_provider.dart';

class OOzDistributionSystem {
  static OOzDistributionSystem instance;

  final OOTOPIADatabase dbHelper = OOTOPIADatabase();
  final WatchVideoProvider watchVideoProvider = WatchVideoProvider();

  OOzDistributionSystem();

  static getInstance() {
    if (instance == null) {
      instance = OOzDistributionSystem();
    }

    return instance;
  }

  startTimelineView() {
    print("Fui chamado start");
  }

  endTimelineView(String teste) {
    print("Fui chamado end $teste");
  }

  distributionWatchVideo(
      {String postId, int positionInMs, int durationInMs}) async {
    //print("positionInMs $positionInMs");
    //print("durationInMs $durationInMs");
    try {
      print('before');
      final test = await watchVideoProvider
          .insert(WatchVideoModel(postId, positionInMs, durationInMs));
      print("after");
      print('inserted row id: ${test.toMap()}');
    } catch (err) {
      print("Erro!!!!! " + err.toString());
    }
  }
}
