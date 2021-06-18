import 'package:ootopia_app/data/BD/database.dart';

class OOzDistributionSystem {
  static OOzDistributionSystem instance;

  final OOTOPIADatabase dbHelper = OOTOPIADatabase();

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

  distributionWatchVideo({String postId, int position, int duration}) async {
    print("position ${position}");

    final id = await dbHelper.insertWatchVideo(
      postId: postId,
      position: position,
      duration: duration,
    );
    print('inserted row id: $id');
  }
}
