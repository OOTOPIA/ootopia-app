import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import './screens/timeline/timeline.dart';
import './app_config.dart';

Future main() async {
  await DotEnv.load(fileName: ".env");

  var configuredApp = new AppConfig(
    appName: 'OOTOPIA',
    flavorName: 'production',
    apiBaseUrl: DotEnv.env['API_URL'],
    child: new ExpensesApp(),
  );

  runApp(
    GlobalConstants(
      child: configuredApp,
    ),
  );
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              TimelinePostBloc(PostRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) => AuthBloc(AuthRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          accentColor: Color(0xff0253e7),
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            subtitle1: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        home: TimelinePage(),
      ),
    );
  }
}
