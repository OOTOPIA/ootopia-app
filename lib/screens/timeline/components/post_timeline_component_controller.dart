import 'package:mobx/mobx.dart';
part 'post_timeline_component_controller.g.dart';

class PostTimelineComponentController = _PostTimelineComponentControllerBase
    with _$PostTimelineComponentController;

abstract class _PostTimelineComponentControllerBase with Store {
  @observable
  bool askToConfirmGratitude = false;

  @action
  void setAskToConfirmGratitude(bool value) {
    askToConfirmGratitude = value;
  }
}
