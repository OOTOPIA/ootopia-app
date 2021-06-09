import 'package:http/http.dart' as http;

class OOzDistributionSystem {
  static OOzDistributionSystem instance;

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

  distributionWatchVideo() {}
}
