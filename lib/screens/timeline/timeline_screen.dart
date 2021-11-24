import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/models/users/daily_goal_stats_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/general_config_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/last_learning_track_component.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/home/components/regeneration_game.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/shared/distribution_system.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/feed_player/multi_manager/flick_multi_manager.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

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
  late TimelinePostBloc timelineBloc;
  bool loggedIn = false;
  User? user;
  final int _itemsPerPageCount = 10;
  int _nextPageThreshold = 5;
  bool _hasMoreItems = true;
  bool showUploadedVideoMessage = false;
  GeneralConfigRepositoryImpl generalConfigRepositoryImpl =
      GeneralConfigRepositoryImpl();
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  late TimelineStore timelineStore;

  late FlickMultiManager flickMultiManager;
  late StreamSubscription _sub;
  late AuthStore authStore;
  bool showRemainingTime = false;
  bool showRemainingTimeEnd = false;
  DailyGoalStatsModel? dailyGoalStats;
  SmartPageController controller = SmartPageController.getInstance();

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
      print("getIntentDataStream error: $err");
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        onReceiveVideoFromAnotherApp(value);
      });
    });
    setTimelineVideosMuted();

    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    performAllRequests();
    flickMultiManager = FlickMultiManager();

    if (widget.args != null && widget.args!["createdPost"] == true) {
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
    //TODO firebase dynamic link
    // initDynamicLinks();
    _handleInitialUri();

    Future.delayed(Duration.zero, () {
      timelineStore.init(controller);
      timelineStore.startTimelineViewTimer();
    });
  }

  void _handleIncomingLinks() {
    _sub = getLinksStream().listen((link) {
      if (!mounted || link == null) return;
      setState(() {
        var linkSplit = link.split("resetPasswordToken=");
        var token = linkSplit[linkSplit.length - 1];
        if (token.isNotEmpty) {
          setRecoverPasswordToken(token);
          goToResetPassword();
        }
      });
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  // void initDynamicLinks() async {
  //   print("Token first");

  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //     final Uri? deepLink = dynamicLink?.link;
  //     print("Token second");

  //     // final uri = await getInitialUri();
  //     // var linkSplit = uri.toString().split("resetPasswordToken=");
  //     // var token = linkSplit[linkSplit.length - 1];

  //     // print("Token $uri");
  //     // print("Token $linkSplit");
  //     // print("Token $token");

  //     if (deepLink != null) {
  //       void _goToProfile() async {
  //         PageViewController.instance.addPage(ProfileScreen(
  //           {
  //             "id": user != null && timelineStore.allPosts[0].userId == user!.id
  //                 ? null
  //                 : timelineStore.allPosts[0].userId,
  //           },
  //         ));
  //       }
  //       // setRecoverPasswordToken(token);
  //       // goToResetPassword();
  //       // Navigator.pushNamed(context, deepLink.path);
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });

  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri? deepLink = data?.link;

  //   if (deepLink != null) {
  //     Navigator.pushNamed(context, deepLink.path);
  //   }
  // }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (!mounted || uri == null) return;
        setState(() {
          var linkSplit = uri.toString().split("resetPasswordToken=");
          var token = linkSplit[linkSplit.length - 1];
          if (token.isNotEmpty) {
            setRecoverPasswordToken(token);
            goToResetPassword();
          }
        });
      } on PlatformException {
      } on FormatException catch (err) {
        if (!mounted) return;
      }
    }
  }

  goToResetPassword() async {
    await Navigator.of(context).pushNamed(
      PageRoute.Page.resetPasswordScreen.route,
    );
  }

  performAllRequests() async {
    print("PERFORM ALL BEFORE");
    await _checkUserIsLoggedIn();
    _getTransferOozToPostLimitConfig();
    //dailyGoalStats = await store.getDailyGoalStats();
    print("PERFORM ALL AFTER");
  }

  void _getTransferOozToPostLimitConfig() async {
    try {
      GeneralConfigModel? transferOozToPostLimitConfig = await this
          .secureStoreMixin
          .getGeneralConfigByName("transfer_ooz_to_post_limit");
      setTransferOOZToPostLimit(transferOozToPostLimitConfig?.value ?? 0);
      //Recuperamos os posts apenas após a configuração inicial para evitar problema com o limite de transferência de OOZ
      timelineBloc.add(GetTimelinePostsEvent(_itemsPerPageCount,
          (timelineStore.currentPage - 1) * _itemsPerPageCount));
    } catch (e) {
      //error
      print("Erro! ${e.toString()}");
    }
  }

  void onReceiveVideoFromAnotherApp(List<SharedMediaFile> value) async {
    await _checkUserIsLoggedIn();
    if (value != null && value.length > 0) {
      _sharedFiles = value;
      var videoFile = _sharedFiles[0];

      if (videoFile.path.isNotEmpty) {
        if (user == null) {
          await Navigator.of(context).pushNamed(
            PageRoute.Page.loginScreen.route,
            arguments: {
              "returnToPageWithArgs": {
                "pageRoute": PageRoute.Page.postPreviewScreen.route,
                "arguments": {
                  "filePath": videoFile.path,
                }
              }
            },
          );
        } else {
          Navigator.of(context).pushNamed(
            PageRoute.Page.postPreviewScreen.route,
            arguments: {
              "filePath": videoFile.path,
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
        print("LOGGED USER: " + user!.fullname!);
      }
      return loggedIn;
    } catch (err) {
      print("Deu erro: $err");
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
        timelineStore.startTimelineViewTimer();
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
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool _) {
              return [];
            },
            body: Column(
              children: [
                RegenerationGame(),
                Expanded(
                  child: Center(
                    child: BlocListener<TimelinePostBloc, TimelinePostState>(
                      listener: (context, state) {
                        if (state is ErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        } else if (state is LoadedSucessState) {
                          if (!state.onlyForRefreshCurrentList) {
                            _hasMoreItems =
                                state.posts.length == _itemsPerPageCount;
                            timelineStore.allPosts.addAll(state.posts);
                          }
                        } else if (state is OnDeletedPostState) {
                          timelineStore.allPosts
                              .removeWhere((post) => post.id == state.postId);
                        } else if (state is OnUpdatePostCommentsCountState) {
                          timelineStore.allPosts
                              .firstWhere((post) => post.id == state.postId)
                              .commentsCount = state.commentsCount;
                        }
                      },
                      child: _blocBuilder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _blocBuilder() {
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text(AppLocalizations.of(context)!.initial),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
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
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          timelineStore.allPosts = [];
                          timelineStore.currentPage = 1;
                        });
                        performAllRequests();
                      },
                      child: ListView.separated(
                        controller: timelineStore.scrollController,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        shrinkWrap: true,
                        cacheExtent: 1000,
                        itemCount: timelineStore.allPosts.length +
                            (_hasMoreItems
                                ? 1
                                : 0), //Adicionei +1 manualmente devido à POC do youtube
                        itemBuilder: (context, index) {
                          if (index ==
                                  timelineStore.allPosts.length -
                                      _nextPageThreshold &&
                              _hasMoreItems) {
                            timelineStore.currentPage++;
                            _getData();
                          }
                          if (index == timelineStore.allPosts.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: _hasMoreItems
                                    ? CircularProgressIndicator()
                                    : Container(),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              if (index == 0) LastLearningTrackComponents(),
                              PhotoTimeline(
                                key: ObjectKey(timelineStore.allPosts[index]),
                                index: index,
                                post: timelineStore.allPosts[index],
                                timelineBloc: this.timelineBloc,
                                loggedIn: this.loggedIn,
                                user: user,
                                flickMultiManager: flickMultiManager,
                                isProfile: false,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ErrorState) {
          return TryAgain(
            _getData,
          );
        }
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
      },
    );
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

  Future<void> _getData() async {
    timelineBloc.add(GetTimelinePostsEvent(_itemsPerPageCount,
        (timelineStore.currentPage - 1) * _itemsPerPageCount));
  }
}
