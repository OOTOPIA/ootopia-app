import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/bloc/comment/comment_bloc.dart';
import 'package:ootopia_app/bloc/interests_tags/interests_tags_bloc.dart';
import 'package:ootopia_app/bloc/post/post_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/bloc/wallet/wallet_bloc.dart';
import 'package:ootopia_app/bloc/wallet_transfer/wallet_transfer_bloc.dart';
import 'package:ootopia_app/data/repositories/auth_repository.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/data/repositories/wallet_transfers_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_daily_learning_goal_screen.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_geolocation.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_screen.dart';
import 'package:ootopia_app/screens/auth/register_phase_2_top_interests.dart';
import 'package:ootopia_app/screens/auth/register_screen.dart';
import 'package:ootopia_app/screens/camera_screen/camera_screen.dart';
import 'package:ootopia_app/screens/regenerarion_game_learning_alert/regenerarion_game_learning_alert.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/recover_password/recover_password_screen.dart';
import 'package:ootopia_app/screens/reset_password/reset_password_screen.dart';
import 'package:ootopia_app/screens/splash/splash_screen.dart';
import 'package:ootopia_app/screens/timeline/components/celebrate_component.dart';
import 'package:ootopia_app/screens/timeline/components/comment_screen.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/player_video_fullscreen.dart';
import 'package:ootopia_app/screens/post_preview_screen/post_preview_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'screens/components/menu_drawer.dart';
import 'screens/timeline/timeline_screen.dart';
import './app_config.dart';
import 'data/repositories/comment_repository.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/foundation.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import './shared/analytics.server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  var configuredApp = new AppConfig(
    appName: 'OOTOPIA',
    flavorName: 'production',
    apiBaseUrl: dotenv.env['API_URL']!,
    child: new ExpensesApp(),
  );

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5a5d45bd48bd4a159f2b00f343408ab9@o566687.ingest.sentry.io/5743561';
      options.debug = false;
    },
    appRunner: () => runApp(
      GlobalConstants(
        child: configuredApp,
      ),
    ),
  );
}

class ExpensesApp extends StatefulWidget {
  @override
  _ExpensesAppState createState() => _ExpensesAppState();
}

class _ExpensesAppState extends State<ExpensesApp> with WidgetsBindingObserver {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  @override
  void initState() {
    super.initState();
    trackingEvents.trackingOpenedApp();
    WidgetsBinding.instance!.addObserver(this);
    AppUsageTime.instance.startTimer();
    AppTheme.instance(context).addListener(() {
      setState(() {}); //To update theme if user toggle
    });
    AppTheme.instance(context).checkIsDarkMode();
  }

  @override
  void dispose() {
    trackingEvents.trackingClosedApp();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppUsageTime.instance.startTimer();
        break;
      case AppLifecycleState.inactive:
        AppUsageTime.instance.stopTimer();
        break;
      case AppLifecycleState.paused:
        AppUsageTime.instance.stopTimer();
        break;
      case AppLifecycleState.detached:
        AppUsageTime.instance.stopTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => TimelinePostBloc(
            PostRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => AuthBloc(
            AuthRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => CommentBloc(
            CommentRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              UserBloc(UserRepositoryImpl(), PostRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              InterestsTagsBloc(InterestsTagsRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) => PostBloc(
            PostRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => WalletBloc(
            WalletRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => WalletTransferBloc(
            WalletTransfersRepositoryImpl(),
          ),
        ),
      ],
      child: MultiProvider(
        providers: [
          Provider<AuthStore>(
            create: (_) => AuthStore(),
          ),
          Provider<HomeStore>(
            create: (_) => HomeStore(),
          ),
          Provider<TimelineStore>(
            create: (_) => TimelineStore(),
          ),
          Provider<WalletStore>(
            create: (_) => WalletStore(),
          ),
        ],
        child: MaterialApp(
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: AppTheme.instance(context).light,
          home: MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends HookWidget {
  final Map<PageRoute.Page, Widget Function(dynamic)> _fragments = {
    PageRoute.Page.homeScreen: (args) => HomeScreen(args: args),
    PageRoute.Page.timelineScreen: (args) => TimelinePage(args),
    PageRoute.Page.timelineProfileScreen: (args) =>
        TimelineScreenProfileScreen(args),
    PageRoute.Page.commentScreen: (args) => CommentScreen(args),
    PageRoute.Page.profileScreen: (args) => ProfileScreen(args),
    PageRoute.Page.myProfileScreen: (args) => ProfileScreen(args),
    PageRoute.Page.registerScreen: (args) => RegisterPage(args),
    PageRoute.Page.loginScreen: (args) => LoginPage(args),
    PageRoute.Page.cameraScreen: (args) => CameraScreen(),
    PageRoute.Page.registerPhase2Screen: (args) => RegisterPhase2Page(args),
    PageRoute.Page.registerPhase2DailyLearningGoalScreen: (args) =>
        RegisterPhase2DailyLearningGoalPage(args),
    PageRoute.Page.registerPhase2GeolocationScreen: (args) =>
        RegisterPhase2GeolocationPage(args),
    PageRoute.Page.registerPhase2TopInterestsScreen: (args) =>
        RegisterPhase2TopInterestsPage(args),
    PageRoute.Page.playerVideoFullScreen: (args) =>
        PLayerVideoFullscreen(args: args),
    PageRoute.Page.postPreviewScreen: (args) => PostPreviewPage(args),
    PageRoute.Page.recoverPasswordScreen: (args) => RecoverPasswordPage(args),
    PageRoute.Page.resetPasswordScreen: (args) => ResetPasswordPage(args),
    PageRoute.Page.splashScreen: (args) => SplashScreen(args),
    PageRoute.Page.profile: (args) => ProfilePage(),
    PageRoute.Page.celebration: (args) => Celebration(args),
    PageRoute.Page.regenerarionGameLearningAlert: (args) =>
        RegenerarionGameLearningAlert(args),
  };

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalObjectKey<NavigatorState>(context);
    return WillPopScope(
      onWillPop: () async => !(await navigatorKey.currentState!.maybePop()),
      child: Navigator(
        key: navigatorKey,
        initialRoute: PageRoute.Page.splashScreen.route,
        onGenerateRoute: (settings) {
          final pageName = settings.name;

          final page = _fragments.keys
              .firstWhere((element) => describeEnum(element) == pageName);

          return MaterialPageRoute(
            settings: settings,
            builder: (context) => (settings.arguments == null
                ? _fragments[page]!(null)
                : _fragments[page]!(settings.arguments as Map)),
          );
        },
      ),
    );
  }
}
