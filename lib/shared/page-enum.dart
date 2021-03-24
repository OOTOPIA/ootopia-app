import 'package:flutter/foundation.dart';

enum Page { timelineScreen, timelineProfileScreen, profileScreen }

extension PageRoute on Page {
  String get route => describeEnum(this);
}
