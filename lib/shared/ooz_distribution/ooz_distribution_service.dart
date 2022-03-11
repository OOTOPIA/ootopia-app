import 'package:ootopia_app/shared/ooz_distribution/ooz_distribution_controller.dart';

class OOZDistributionService {
  static OOZDistributionService? _instance;
  OOZDistributionController controller = OOZDistributionController();

  Map<String, OOZDistributionController> distributionData = {};

  static OOZDistributionService getInstance() {
    if (_instance == null) {
      _instance = OOZDistributionService();
    }
    return _instance!;
  }

  updateVideoPosition(String postId, String userId, int timeInMilliseconds,
      int durationInMs, int creationTimeInMs) {
    if (distributionData[postId] == null) {
      distributionData[postId] = OOZDistributionController();
    } else {
      distributionData[postId]!.updateVideoPosition(
        postId,
        userId,
        timeInMilliseconds,
        durationInMs,
        creationTimeInMs,
      );
    }
  }
}
