import 'package:flutter/widgets.dart';

class GlobalConstants extends InheritedWidget {
  static GlobalConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlobalConstants>();

  const GlobalConstants({Widget child, Key key})
      : super(key: key, child: child);

  final double spacingSmall = 8;
  final double spacingNormal = 16;
  final double spacingMedium = 32;
  final double spacingLarge = 48;
  final double spacingXL = 64;

  final double logoHeight = 82;

  @override
  bool updateShouldNotify(GlobalConstants oldWidget) => false;
}
