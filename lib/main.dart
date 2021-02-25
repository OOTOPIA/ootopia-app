import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/res/env/prod_strings.dart';
import './app/screens/timeline/timeline.dart';
import './app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Ootopia',
    flavorName: 'production',
    apiBaseUrl: AppStrings.apiUrl,
    child: new ExpensesApp(),
  );
  runApp(configuredApp);
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimelinePage(),
    );
  }
}
