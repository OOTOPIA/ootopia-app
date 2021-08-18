import 'package:flutter/widgets.dart';

class PageViewController {
  static PageViewController? _instance;
  late PageController controller;
  List<Function> listeners = [];

  PageViewController() {
    controller = PageController(initialPage: 0, keepPage: true);
  }

  static PageViewController get instance =>
      _instance == null ? _instance = PageViewController() : _instance!;

  PageController newController() {
    controller = PageController(initialPage: 0, keepPage: true);
    return controller;
  }

  addListener(Function listener) {
    listeners.add(listener);
    listeners.forEach((l) => controller.addListener(() => l()));
  }

  bool back() {
    if (controller.page! > 0) {
      controller.animateToPage(
        (controller.page!.round() - 1).toInt(),
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
      return false;
    }
    return true;
  }
}
