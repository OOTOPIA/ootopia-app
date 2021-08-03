import 'package:flutter/cupertino.dart';

class AppConfig extends InheritedWidget {
  AppConfig({
    required this.appName,
    required this.flavorName,
    required this.apiBaseUrl,
    required Widget child,
  }) : super(child: child);

  final String appName;
  final String flavorName;
  final String apiBaseUrl;

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
