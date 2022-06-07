import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/general_config_repository.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/screens/marketplace/product_detail_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
import 'package:ootopia_app/screens/timeline/components/post_widget/post_widget.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/distribution_system.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:uni_links/uni_links.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'components/feed_player/multi_manager/flick_multi_manager.dart';
import 'components/invite_your_friends.dart';

bool _initialUriIsHandled = false;

class TimelinePage extends StatefulWidget {
  final Map<String, dynamic>? args;

  TimelinePage(this.args);
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage>
    with
        SecureStoreMixin,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  late StreamSubscription _intentDataStreamSubscription;
  late List<SharedMediaFile> _sharedFiles;
  bool loggedIn = false;
  User? user;
  bool showUploadedVideoMessage = false;
  GeneralConfigRepositoryImpl generalConfigRepositoryImpl =
      GeneralConfigRepositoryImpl();
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  late TimelineStore timelineStore;

  late FlickMultiManager flickMultiManager;
  //late StreamSubscription _sub;
  late AuthStore authStore;
  //bool showRemainingTime = false;
  //bool showRemainingTimeEnd = false;
  SmartPageController controller = SmartPageController.getInstance();
  LearningTracksRepositoryImpl learningTracksStore =
      LearningTracksRepositoryImpl();
  MarketplaceRepositoryImpl marketplaceRepository = MarketplaceRepositoryImpl();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        onReceiveVideoFromAnotherApp(value);
      });
    }, onError: (err) {
      print('getIntentDataStream error: $err');
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        onReceiveVideoFromAnotherApp(value);
      });
    });

    setTimelineVideosMuted();
    performAllRequests();
    flickMultiManager = FlickMultiManager();

    if (widget.args != null && widget.args!['createdPost'] == true) {
      setState(() {
        showUploadedVideoMessage = true;
      });
      Timer(
        Duration(milliseconds: 5000),
        () {
          setState(() {
            showUploadedVideoMessage = false;
          });
        },
      );
    }

    OOzDistributionSystem.getInstance().startTimelineView();

    _handleIncomingLinks();
    _handleInitialUri();

    //Future.delayed(Duration.zero, () {
    //timelineStore.init(controller);
    //timelineStore.startTimelineViewTimer();
    //});
    if (widget.args != null &&
        widget.args?['redirectToInvitationCode'] != null) {
      Future.delayed(Duration(milliseconds: 700), () {
        controller.insertPage(InvitationScreen());
      });
    }
  }

  void _handleIncomingLinks() {
    //_sub =
    linkStream.listen((link) {
      if (link == null) return;
      if (link.contains('posts/shared')) goToPost(link);
      if (link.contains('market-place/shared')) goToMarketPlace(link);
      if (link.contains('learning-tracks/shared')) goToLearningTracks(link);
      if (link.contains('resetPasswordToken=')) redefinePassword(link);
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  void redefinePassword(String link) {
    bool isResetPassword = link.contains('resetPasswordToken=');
    if (isResetPassword) {
      var linkSplit = link.split('resetPasswordToken=');
      String token = linkSplit[linkSplit.length - 1];
      setRecoverPasswordToken(token);
      goToResetPassword();
    }
  }

  Future<void> goToPost(String link) async {
    PostRepositoryImpl postsRepository = PostRepositoryImpl();
    String postId = link.split('/').last;
    var post = await postsRepository.getPostById(postId);

    controller.insertPage(
      TimelineScreenProfileScreen(
        {
          'userId': authStore.currentUser?.id,
          'posts': [post].toList(),
          'postSelected': 0,
        },
      ),
    );
  }

  Future<void> goToMarketPlace(String link) async {
    ProductModel productModel = await marketplaceRepository
        .getProductById(link.split('market-place/shared/').last);

    controller.insertPage(ProductDetailScreen(productModel: productModel));
  }

  Future<void> goToLearningTracks(String link) async {
    LearningTracksModel learningTrack = await learningTracksStore
        .getLearningTrackById(link.split('learning-tracks/shared/').last);

    controller.insertPage(ViewLearningTracksScreen(
      {
        'list_chapters': learningTrack.chapters,
        'learning_tracks': learningTrack,
        'updateLearningTrack': () {},
      },
    ));
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (!mounted || uri == null) return;
        if (uri.toString().contains('resetPasswordToken=')) {
          redefinePassword(uri.toString());
        }
        if (uri.toString().contains('posts/shared')) {
          goToPost(uri.toString());
        }
        if (uri.toString().contains('market-place/shared')) {
          goToMarketPlace(uri.toString());
        }
        if (uri.toString().contains('learning-tracks/shared')) {
          goToLearningTracks(uri.toString());
        }
      } catch (err) {
        if (!mounted) return;
      }
    }
  }

  Future<void> goToResetPassword() async {
    await Navigator.of(context).pushNamed(
      PageRoute.Page.resetPasswordScreen.route,
    );
  }

  void performAllRequests() async {
    print('PERFORM ALL BEFORE');
    await _checkUserIsLoggedIn();
    _getTransferOozToPostLimitConfig();
    print('PERFORM ALL AFTER');
  }

  void _getTransferOozToPostLimitConfig() async {
    try {
      GeneralConfigModel? transferOozToPostLimitConfig = await this
          .secureStoreMixin
          .getGeneralConfigByName('transfer_ooz_to_post_limit');
      setTransferOOZToPostLimit(transferOozToPostLimitConfig?.value ?? 0);
      timelineStore.getTimelinePosts();
    } catch (e) {
      print('Erro!!! ${e.toString()}');
    }
  }

  void onReceiveVideoFromAnotherApp(List<SharedMediaFile> value) async {
    await _checkUserIsLoggedIn();
    if (value.length > 0) {
      _sharedFiles = value;
      var videoFile = _sharedFiles[0];

      if (videoFile.path.isNotEmpty) {
        if (user == null) {
          await Navigator.of(context).pushNamed(
            PageRoute.Page.loginScreen.route,
            arguments: {
              'returnToPageWithArgs': {
                'pageRoute': PageRoute.Page.postPreviewScreen.route,
                'arguments': {
                  'filePath': videoFile.path,
                }
              }
            },
          );
        } else {
          Navigator.of(context).pushNamed(
            PageRoute.Page.postPreviewScreen.route,
            arguments: {
              'filePath': videoFile.path,
            },
          );
        }
      }
    }
  }

  Future<bool> _checkUserIsLoggedIn() async {
    try {
      loggedIn = await getUserIsLoggedIn();
      if (loggedIn) {
        await this.userRepositoryImpl.getMyAccountDetails();
        user = await getCurrentUser();
        authStore.checkUserIsLogged();
        print('LOGGED USER: ' + user!.fullname!);
      }
      return loggedIn;
    } catch (err) {
      print('Deu erro: $err');
      return false;
    }
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    timelineStore.stopTimelineViewTimer();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        //timelineStore.startTimelineViewTimer();
        break;
      case AppLifecycleState.inactive:
        timelineStore.stopTimelineViewTimer();
        break;
      case AppLifecycleState.paused:
        timelineStore.stopTimelineViewTimer();
        break;
      case AppLifecycleState.detached:
        timelineStore.stopTimelineViewTimer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    timelineStore = Provider.of<TimelineStore>(context);
    authStore = Provider.of<AuthStore>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(positioned: -50),
            SafeArea(
              child: Column(
                children: [
                  InviteYourFriends(),
                  Expanded(
                    child: Center(
                      child: body(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  body() {
    return Observer(builder: (_) {
      if (timelineStore.viewState == TimelineViewState.loading) {
        return Center(child: CircularProgressIndicator());
      } else if (timelineStore.viewState == TimelineViewState.error) {
        return TryAgain(
          () => timelineStore.getTimelinePosts(),
        );
      } else if (timelineStore.viewState == TimelineViewState.ok &&
          timelineStore.allPosts.length == 0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.noPosts,
              ),
            ],
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).screenHorizontalSpace,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: VisibilityDetector(
                key: ObjectKey(flickMultiManager),
                onVisibilityChanged: (visibility) {
                  if (visibility.visibleFraction == 0 && this.mounted) {
                    flickMultiManager.pause();
                  }
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!timelineStore.loadingMorePosts &&
                        timelineStore.viewState != TimelineViewState.loading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        timelineStore.hasMorePosts) {
                      timelineStore.getTimelinePosts();
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      timelineStore.reloadPosts();
                    },
                    child: ListView.separated(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      itemCount: timelineStore.allPosts.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return PostWidget(
                          index: index,
                          post: timelineStore.allPosts[index],
                          action: () => setState(() {}),
                          timelineStore: timelineStore,
                          flickMultiManager: flickMultiManager,
                          user: user,
                          loggedIn: loggedIn,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

// Widget get remainingTime => Padding(
//       padding: EdgeInsets.only(
//         right: 19,
//       ),
//       child: GestureDetector(
//         onTap: () => setState(() {
//           if (dailyGoalStats != null) {
//             showRemainingTime = !showRemainingTime;
//             showRemainingTimeEnd = !showRemainingTime;
//           }
//         }),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Icon(
//               FeatherIcons.clock,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             AnimatedOpacity(
//               opacity: showRemainingTime ? 1 : 0,
//               duration: Duration(milliseconds: 500),
//               onEnd: () {},
//               child: Visibility(
//                 visible: showRemainingTime,
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 4),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         store.remainingTime,
//                         style:
//                             Theme.of(context).textTheme.bodyText2!.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xff707070),
//                                 ),
//                       ),
//                       Text(
//                         AppLocalizations.of(context)!.remaining,
//                         style:
//                             Theme.of(context).textTheme.bodyText2!.copyWith(
//                                   fontSize: 12,
//                                   color: Color(0xff707070),
//                                 ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );

}
