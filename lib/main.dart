import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart'
    as awesomeNotification;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ootopia_app/bloc/interests_tags/interests_tags_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/bloc/wallet/wallet_bloc.dart';
import 'package:ootopia_app/bloc/wallet_transfer/wallet_transfer_bloc.dart';
import 'package:ootopia_app/data/repositories/general_config_repository.dart';
import 'package:ootopia_app/data/repositories/interests_tags_repository.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/data/repositories/wallet_transfers_repository.dart';
import 'package:ootopia_app/screens/about_ethical_marketingplace/about_ethical_marketplace.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/auth/insert_invitation_code.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/auth/register_daily_learning_goal_screen.dart';
import 'package:ootopia_app/screens/auth/register_geolocation.dart';
import 'package:ootopia_app/screens/auth/register_phone_number.dart';
import 'package:ootopia_app/screens/auth/register_top_interests.dart';
import 'package:ootopia_app/screens/auth/register_form.dart';
import 'package:ootopia_app/screens/auth/policy_and_terms_screen.dart';
import 'package:ootopia_app/screens/camera_screen/camera_screen.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_with_users_screen.dart';
import 'package:ootopia_app/screens/create_categories/create_categories_screen.dart';
import 'package:ootopia_app/screens/edit_profile_screen/add_link/add_link_screen.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:ootopia_app/initial_screen.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_store.dart';
import 'package:ootopia_app/screens/friends/add_friends/add_friends.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_store.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/about_quiz_screen.dart';
import 'package:ootopia_app/screens/ooz_current/ooz_current_page.dart';
import 'package:ootopia_app/screens/post_preview_screen/components/post_preview_screen_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile_store.dart';
import 'package:ootopia_app/screens/regenerarion_game_learning_alert/regenerarion_game_learning_alert.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component_controller.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/home/home_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/recover_password/recover_password_screen.dart';
import 'package:ootopia_app/screens/reset_password/reset_password_screen.dart';
import 'package:ootopia_app/screens/splash/splash_screen.dart';
import 'package:ootopia_app/screens/timeline/components/celebrate_component.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_screen.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/player_video_fullscreen.dart';
import 'package:ootopia_app/screens/post_preview_screen/post_preview_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/FirebaseMessaging/notification_message_service.dart';
import 'package:ootopia_app/shared/FirebaseMessaging/push_notification.service.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/shared_experience/shared_experience_service.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ootopia_app/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'screens/timeline/timeline_screen.dart';
import './app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import './shared/analytics.server.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/l10n.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  FlutterBackgroundService.initialize(onStartService);

  var configuredApp = new AppConfig(
    appName: 'OOTOPIA',
    flavorName: 'production',
    apiBaseUrl: dotenv.env['API_URL']!,
    crispWebsiteId: dotenv.env['CRISP_WEBSITE_ID']!,
    child: new ExpensesApp(),
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN']!;
      options.debug = false;
      options.environment = "staging";
      options.attachStacktrace = true;
      options.diagnosticLevel = SentryLevel.error;
      options.enableAutoSessionTracking = true;
    },
    appRunner: () => runApp(
      GlobalConstants(
        child: configuredApp,
      ),
    ),
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  awesomeNotification.AwesomeNotifications().initialize(
    'resource://mipmap/notification_icon',
    [
      awesomeNotification.NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelShowBadge: true,
        criticalAlerts: true,
        importance: awesomeNotification.NotificationImportance.High,
        channelDescription: 'Notification channel for basic tests',
        icon: 'resource://mipmap/notification_icon',
        ledColor: LightColors.blue,
        defaultColor: LightColors.blue,
      )
    ],
    channelGroups: [
      awesomeNotification.NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
    debug: true,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  String messageType = (message.data['type'] as String).replaceAll('-', '_');
  if (messageType == TypeOfMessage.regeneration_game.name) {
    AppUsageTime.instance.resetUsageTime();
    return;
  }
  NotificationMessageService service = NotificationMessageService();

  await dotenv.load(fileName: ".env");

  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  trackingEvents
      .notificationReceived({"notificationType": message.data["type"]});
  service.createMessage(message);
}

void onStartService() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  int lastUpdateUsageTimeInMs = 0;
  const int maxAttempts = 5;
  int currentAttempt = 1;
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (event["action"] == "START_SYNC") {
      service.setNotificationInfo(
        title: "OOTOPIA",
        content: event["message"],
      );
    }

    if (event["action"] == "ON_UPDATE_USAGE_TIME") {
      lastUpdateUsageTimeInMs = event["value"];
    }
  });
  service.setForegroundMode(true);
  //Quando o aplicativo fechar, iremos verificar se a ultima atualização do
  //tempo de visualização da timeline foi há mais de 30 segundos atrás
  //Se for, enviamos o tempo de visualização para a api, pois esse tempo será convertido em OOZ
  //Se não for, isso indica que o app ainda está aberto, então ainda pode estar contando tempo
  Timer.periodic(Duration(seconds: 3), (timer) async {
    int timeInMs = new DateTime.now().millisecondsSinceEpoch;
    if (timeInMs - lastUpdateUsageTimeInMs >= 3000 &&
        lastUpdateUsageTimeInMs > 0) {
      await dotenv.load(fileName: ".env");
      AppUsageTime.instance;
      try {
        await AppUsageTime.instance.sendToApi();
        timer.cancel();
        service.stopBackgroundService();
      } catch (err) {
        currentAttempt++;
        if (currentAttempt >= maxAttempts) {
          timer.cancel();
          service.stopBackgroundService();
        }
      }
    }
  });
}

class ExpensesApp extends StatefulWidget {
  @override
  _ExpensesAppState createState() => _ExpensesAppState();
}

class _ExpensesAppState extends State<ExpensesApp> with WidgetsBindingObserver {
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  PushNotification pushNotification = PushNotification.getInstance();

  GeneralConfigRepositoryImpl generalConfigRepository =
      GeneralConfigRepositoryImpl();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pushNotification.listenerFirebaseCloudMessagingToken();
    pushNotification.listenerFirebaseCloudMessagingMessages();
    Future.delayed(Duration.zero, () async {
      await generalConfigRepository.getGlobalGoalLimitTimeInUtc();
      await generalConfigRepository.getGeneralConfig();
      SecureStoreMixin store = SecureStoreMixin();
      if (await store.getUserIsLoggedIn()) {
        AppUsageTime.instance.startTimer();
      }
    });
    trackingEvents.trackingOpenedApp();
    WidgetsBinding.instance!.addObserver(this);
    AppTheme.instance(context).addListener(() {
      setState(() {}); //To update theme if user toggle
    });
    AppTheme.instance(context).checkIsDarkMode();
    ChatDialogController.instance.init();
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
          create: (BuildContext context) =>
              UserBloc(UserRepositoryImpl(), PostRepositoryImpl()),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              InterestsTagsBloc(InterestsTagsRepositoryImpl()),
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
          ChangeNotifierProvider(create: (context) => FriendsStore()),
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
          Provider<TimelineProfileStore>(
            create: (_) => TimelineProfileStore(),
          ),
          Provider<PostPreviewScreenStore>(
            create: (_) => PostPreviewScreenStore(),
          ),
          Provider<InvitationStore>(
            create: (_) => InvitationStore(),
          ),
          Provider<ProfileScreenStore>(
            create: (_) => ProfileScreenStore(),
          ),
          Provider<EditProfileStore>(
            create: (_) => EditProfileStore(),
          ),
          Provider<PostTimelineComponentController>(
            create: (_) => PostTimelineComponentController(),
          )
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

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<MainPage> {
  final Map<PageRoute.Page, Widget Function(dynamic)> _fragments = {
    PageRoute.Page.homeScreen: (args) => HomeScreen(args: args),
    PageRoute.Page.timelineScreen: (args) => TimelinePage(args),
    PageRoute.Page.timelineProfileScreen: (args) =>
        TimelineScreenProfileScreen(args),
    PageRoute.Page.commentScreen: (args) => CommentScreen(args),
    PageRoute.Page.profileScreen: (args) => ProfileScreen(args),
    PageRoute.Page.myProfileScreen: (args) => ProfileScreen(args),
    PageRoute.Page.loginScreen: (args) => LoginPage(args),
    PageRoute.Page.cameraScreen: (args) => CameraScreen(),
    PageRoute.Page.registerFormScreen: (args) => RegisterFormScreen(args),
    PageRoute.Page.registerPhoneNumberScreen: (args) =>
        RegisterPhoneNumberScreen(args),
    // PageRoute.Page.registerDailyLearningGoalScreen: (args) =>
    //     RegisterDailyLearningGoalScreen(args),
    PageRoute.Page.registerGeolocationScreen: (args) =>
        RegisterGeolocationScreen(args),
    PageRoute.Page.registerTopInterestsScreen: (args) =>
        RegisterTopInterestsScreen(args),
    PageRoute.Page.playerVideoFullScreen: (args) =>
        PLayerVideoFullscreen(args: args),
    PageRoute.Page.postPreviewScreen: (args) => PostPreviewPage(args),
    PageRoute.Page.recoverPasswordScreen: (args) => RecoverPasswordPage(args),
    PageRoute.Page.resetPasswordScreen: (args) => ResetPasswordPage(args),
    PageRoute.Page.splashScreen: (args) => SplashScreen(args),
    PageRoute.Page.walletPage: (args) => WalletPage(),
    PageRoute.Page.celebration: (args) => Celebration(args),
    PageRoute.Page.regenerationGameLearningAlert: (args) =>
        RegenerationGameLearningAlert(args),
    PageRoute.Page.chatWithUsersScreen: (args) => ChatWithUsersScreen(),
    PageRoute.Page.invitationScreen: (args) => InvitationScreen(),
    PageRoute.Page.insertInvitationCode: (args) => InsertInvitationCode(args),
    PageRoute.Page.termsOfUseScreen: (args) => PolicyAndTermsScreen(
          filename: args['filename'],
          onAccept: args['onAccept'],
          buttonText: args['buttonText'],
          fileSuffix: args['fileSuffix'],
        ),
    PageRoute.Page.privacyPolicyScreen: (args) => PolicyAndTermsScreen(
          filename: args['filename'],
          onAccept: args['onAccept'],
          buttonText: args['buttonText'],
          fileSuffix: args['fileSuffix'],
        ),
    PageRoute.Page.editProfileScreen: (args) => EditProfileScreen(),
    PageRoute.Page.newFutureCategories: (args) => CreateCategoriesScreen(),
    PageRoute.Page.aboutQuizScreen: (args) => AboutQuizScreen(),
    PageRoute.Page.initialScreen: (args) => InitialScreen(),
    PageRoute.Page.aboutOOzCurrentScreen: (args) => AboutOOzCurrentScreen(),
    PageRoute.Page.aboutEthicalMarketPlace: (args) => AboutEthicalMarketPlace(),
    PageRoute.Page.addLink: (args) => AddLinkScreen(args),
    PageRoute.Page.addFriends: (args) => AddFriends(
          displayContacts: true,
          arguments: args,
        ),
  };

  SharedExperienceService sharedExperienceService =
      SharedExperienceService.getInstace();

  String get shareMyOpinion {
    if (MediaQuery.of(context).size.width < 416 &&
        AppLocalizations.of(context)!.localeName == 'pt') {
      return AppLocalizations.of(context)!
          .shareMyOpinion
          .replaceFirst(" ", "\n");
    }
    return AppLocalizations.of(context)!.shareMyOpinion;
  }

  showSharedExperience(context) {
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.areYouEnjoyingTheOotopiaApp,
            automaticClosing: false,
            text: AppLocalizations.of(context)!
                .weWantYourExperienceToBeTheBestItCanBe,
            buttons: [
              ButtonSnackBar(
                text: shareMyOpinion,
                onTapAbout: () async {
                  await launch(
                      "https://docs.google.com/forms/d/e/1FAIpQLScGB6JQf4-YQn7aZQ5fmJTYxhM1W3qXuW87ycYrlayiesN92A/viewform");
                },
              ),
              ButtonSnackBar(
                text: AppLocalizations.of(context)!.notNow,
                onTapAbout: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            marginBottom: true,
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    sharedExperienceService.addListener(() {
      showSharedExperience(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalObjectKey<NavigatorState>(context);
    return WillPopScope(
      onWillPop: () async => !(await navigatorKey.currentState!.maybePop()),
      child: Navigator(
        key: navigatorKey,
        initialRoute: PageRoute.Page.initialScreen.route,
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
