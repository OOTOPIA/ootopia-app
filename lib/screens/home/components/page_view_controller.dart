import 'package:flutter/widgets.dart';

class PageViewController {
  static PageViewController? _instance;
  late PageController controller;

  PageViewController() {
    controller = PageController(initialPage: 0, keepPage: true);
  }

  static PageViewController get instance =>
      _instance == null ? _instance = PageViewController() : _instance!;

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
