import 'package:flutter/widgets.dart';

class PageViewController {
  static PageViewController? _instance;
  late PageController controller;
  List<Function> listeners = [];
  // List<int> pageHistory = [0];

  // static const int TAB_INDEX_TIMELINE = 0;
  // static const int TAB_INDEX_WALLET = 1;
  // static const int TAB_INDEX_PROFILE = 2;

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

  // TabsPageController() {
  //   controller = PageController(initialPage: 0, keepPage: true);
  // }

  // static TabsPageController get instance =>
  //     _instance == null ? _instance = TabsPageController() : _instance!;

  // PageController newController() {
  //   return controller = PageController(initialPage: 0, keepPage: true);
  // }

  // bool back() {
  //   if (controller.page! > 0) {
  //     controller.animateToPage(
  //       (controller.page!.round() - 1).toInt(),
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.linear,
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  // bool back() {
  //   if (controller.page! > 0) {
  //     var lastPage = pageHistory[pageHistory.length - 1];
  //     if (pageHistory.length >= 2) {
  //       lastPage = pageHistory[pageHistory.length - 2];
  //       pageHistory.removeAt(pageHistory.length - 2);
  //     } else {
  //       pageHistory.removeAt(pageHistory.length - 1);
  //     }
  //     controller.jumpToPage(
  //       lastPage,
  //       //duration: Duration(milliseconds: 300),
  //       //curve: Curves.linear,
  //     );
  //     return false;
  //   }
  //   return true;
  // }

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
