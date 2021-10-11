import 'package:flutter/widgets.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';

class PageViewController {
  static PageViewController? _instance;
  late PageController controller;
  List<Function> listeners = [];
  List<int> pageHistory = [0];
  List<int> pageHistoryTabSelected = [0];

  Function? onClickBack;
  Function? onAddPage;

  List<StatefulWidget> pages = [
    TimelinePage(null),
    LearningTracksScreen(),
    LearningTracksScreen(),
    WalletPage(),
    ProfileScreen(null),
  ];

  static const int TAB_INDEX_TIMELINE = 0;
  static const int TAB_INDEX_LEARNING_TRACKS = 1;
  static const int TAB_INDEX_CAMERA = 2;
  static const int TAB_INDEX_MARKETPLACE = 3;
  static const int TAB_INDEX_PROFILE = 4;

  PageViewController() {
    controller = PageController(initialPage: 0, keepPage: true);
  }

  static PageViewController get instance =>
      _instance == null ? _instance = PageViewController() : _instance!;

  PageController newController() {
    controller = PageController(initialPage: 0, keepPage: true);
    return controller;
  }

  resetPages() {
    pages.clear();

    pages = [
      TimelinePage(null),
      LearningTracksScreen(),
      LearningTracksScreen(),
      WalletPage(),
      ProfileScreen(null),
    ];

    pageHistory = [0];
    pageHistoryTabSelected = [0];
  }

  addListener(Function listener) {
    listeners.add(listener);
    listeners.forEach((l) => controller.addListener(() => l()));
  }

  goToPage(int index, [bool? dontUpdateHistoryTabSelected]) {
    if (dontUpdateHistoryTabSelected == false ||
        dontUpdateHistoryTabSelected == null) {
      pageHistoryTabSelected.add(index);
    }
    pageHistory.add(index);
    controller.jumpToPage(index);
  }

  addPage(StatefulWidget page) {
    pages.add(page);

    pageHistoryTabSelected.add(pageHistory[pageHistoryTabSelected.length - 1]);
    if (onAddPage != null) {
      this.onAddPage!();
    }

    goToPage(pages.length - 1, true);
  }

  bool back() {
    if (pages.length > 5) {
      pages.removeAt(pages.length - 1);
    }

    if (controller.page! > 0) {
      var lastPage = pageHistory[pageHistory.length - 1];
      if (pageHistory.length >= 2) {
        lastPage = pageHistory[pageHistory.length - 2];
        pageHistory.removeAt(pageHistory.length - 1);
        pageHistoryTabSelected.removeAt(pageHistoryTabSelected.length - 1);
      } else {}
      controller.jumpToPage(
        lastPage,
      );
      if (onClickBack != null) {
        onClickBack!();
      }

      return false;
    }
    return true;
  }
}
