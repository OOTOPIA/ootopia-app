import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import './screens/timeline/timeline.dart';
import './app_config.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");

  var configuredApp = new AppConfig(
    appName: 'Ootopia',
    flavorName: 'production',
    apiBaseUrl: DotEnv.env['API_URL'],
    child: new ExpensesApp(),
  );

  runApp(configuredApp);
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider(
      create: (BuildContext context) => TimelinePostBloc(PostRepositoryImpl()),
      child: TimelinePage(),
    ));
  }
}
