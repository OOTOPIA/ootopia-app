import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/general_config_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/screens/timeline/components/regeneration_status_icons.dart';
import 'package:ootopia_app/shared/distribution_system.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'components/feed_player/multi_manager/flick_multi_manager.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

bool _initialUriIsHandled = false;

class TimelinePage extends StatefulWidget {
  Map<String, dynamic>? args;

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
  int currentPage = 1;
  final int _itemsPerPageCount = 10;
  int _nextPageThreshold = 5;
  bool _hasMoreItems = true;
  bool showUploadedVideoMessage = false;
  GeneralConfigRepositoryImpl generalConfigRepositoryImpl =
      GeneralConfigRepositoryImpl();
  UserRepositoryImpl userRepositoryImpl = UserRepositoryImpl();

  late GeneralConfig transferOozToPostLimitConfig;

  ScrollController _scrollController = new ScrollController();

  List<TimelinePost> _allPosts = [];

  late FlickMultiManager flickMultiManager;

  late StreamSubscription _sub;

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
    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['pageRoute'] ==
                PageRoute.Page.myProfileScreen.route &&
            user != null &&
            user!.registerPhase == 1) {
          Navigator.of(context).pushNamed(
            PageRoute.Page.registerPhase2Screen.route,
            arguments: {
              "returnToPageWithArgs": {
                "pageRoute": PageRoute.Page.myProfileScreen.route,
                "arguments": null
              }
            },
          );
        } else if (widget.args!['returnToPageWithArgs']['pageRoute'] != null) {
          Navigator.of(context).pushNamed(
            widget.args!['returnToPageWithArgs']['pageRoute'],
            arguments: widget.args!['returnToPageWithArgs']['arguments'],
          );
        }
      }
    });

    OOzDistributionSystem.getInstance().startTimelineView();

    _handleIncomingLinks();
    _handleInitialUri();
  }

  void goToTopTimeline() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _handleIncomingLinks() {
    _sub = getLinksStream().listen((link) {
      if (!mounted || link == null) return;
      setState(() {
        var linkSplit = link.split("resetPasswordToken=");
        var token = linkSplit[linkSplit.length - 1];
        if (token.isNotEmpty && token != null) {
          print("TEM ALGO ERRADO NAO? kkkk $token");
          setRecoverPasswordToken(token);
          goToResetPassword();
        }
      });
    }, onError: (Object err) {
      if (!mounted) return;
    });
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (!mounted || uri == null) return;
        setState(() {
          var linkSplit = uri.toString().split("resetPasswordToken=");
          var token = linkSplit[linkSplit.length - 1];
          if (token.isNotEmpty && token != null) {
            print("EITA ESSE É O TOKEN ENTAO BRABO $token");
            setRecoverPasswordToken(token);
            goToResetPassword();
          }
        });
      } on PlatformException {} on FormatException catch (err) {
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
    print("PERFORM ALL AFTER");
  }

  void _getTransferOozToPostLimitConfig() async {
    try {
      transferOozToPostLimitConfig = await this
          .generalConfigRepositoryImpl
          .getConfig(GeneralConfigName.transferOOZToPostLimit);
      setTransferOOZToPostLimit(transferOozToPostLimitConfig.value);
      //Recuperamos os posts apenas após a configuração inicial para evitar problema com o limite de transferência de OOZ
      timelineBloc.add(GetTimelinePostsEvent(
          _itemsPerPageCount, (currentPage - 1) * _itemsPerPageCount));
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
        print("LOGGED USER: " + user!.fullname!);
      }
      return loggedIn;
    } catch (err) {
      print("Deu erro: $err");
      return false;
    }
  }

  void _backButton(BuildContext context) {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.of(context).pushNamed(user!.registerPhase == 1
        ? PageRoute.Page.registerPhase2Screen.route
        : PageRoute.Page.profileScreen.route);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    OOzDistributionSystem.getInstance().endTimelineView("dispose");
    super.dispose();
  }

  @override
  void deactivate() {
    OOzDistributionSystem.getInstance().endTimelineView("deactivate");
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        OOzDistributionSystem.getInstance().endTimelineView("resumed");

        // widget is resumed
        break;
      case AppLifecycleState.inactive:
        OOzDistributionSystem.getInstance().endTimelineView("inactive");

        // widget is inactive
        break;
      case AppLifecycleState.paused:
        OOzDistributionSystem.getInstance().endTimelineView("paused");

        // widget is paused
        break;
      case AppLifecycleState.detached:
        OOzDistributionSystem.getInstance().endTimelineView("detached");

        // widget is detached
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xffC0D9E8),
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  centerTitle: true,
                  title: Padding(
                    padding: EdgeInsets.all(3),
                    child: Image.asset('assets/images/logo.png', height: 42),
                  ),
                  floating: false,
                  toolbarHeight: 90,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  // Make the initial height of the SliverAppBar larger than normal.
                  //expandedHeight: 50,
                  brightness: Brightness.light,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffC0D9E8),
                          Color(0xffffffff),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: RegenerationStatusIcons(
                      onClick: () => this._goToProfile(),
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                Visibility(
                  visible: showUploadedVideoMessage,
                  child: NewVideoUploadedMessageBox(),
                ),
                Expanded(
                  child: Center(
                    child: BlocListener<TimelinePostBloc, TimelinePostState>(
                      listener: (context, state) {
                        if (state is ErrorState) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        } else if (state is LoadedSucessState) {
                          if (!state.onlyForRefreshCurrentList) {
                            _hasMoreItems =
                                state.posts.length == _itemsPerPageCount;
                            _allPosts.addAll(state.posts);
                          }
                        } else if (state is OnDeletedPostState) {
                          _allPosts
                              .removeWhere((post) => post.id == state.postId);
                        } else if (state is OnUpdatePostCommentsCountState) {
                          _allPosts
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
        bottomNavigationBar: NavigatorBar(
          onClickButton: () => goToTopTimeline(),
          currentPage: PageRoute.Page.timelineScreen.route,
        ),
      ),
    );
  }

  _removeItem(String postId) {
    var indexPost = _allPosts.indexWhere((post) => post.id == postId);
    if (indexPost >= 0) {
      _allPosts.remove(_allPosts[indexPost]);
    }
  }

  _blocBuilder() {
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text("Initial"),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
          return Column(
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
                        _allPosts = [];
                        currentPage = 1;
                      });
                      performAllRequests();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      shrinkWrap: true,
                      cacheExtent: 1000,
                      itemCount: _allPosts.length +
                          (_hasMoreItems
                              ? 1
                              : 0), //Adicionei +1 manualmente devido à POC do youtube
                      itemBuilder: (context, index) {
                        if (index == _allPosts.length - _nextPageThreshold &&
                            _hasMoreItems) {
                          currentPage++;
                          _getData();
                        }
                        if (index == _allPosts.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _hasMoreItems
                                  ? CircularProgressIndicator()
                                  : Container(),
                            ),
                          );
                        }
                        return PhotoTimeline(
                          key: ObjectKey(_allPosts[index]),
                          index: index,
                          post: _allPosts[index],
                          timelineBloc: this.timelineBloc,
                          loggedIn: this.loggedIn,
                          user: user,
                          flickMultiManager: flickMultiManager,
                          isProfile: false,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
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
                'Não há publicações',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getData() async {
    timelineBloc.add(GetTimelinePostsEvent(
        _itemsPerPageCount, (currentPage - 1) * _itemsPerPageCount));
  }
}

class NewVideoUploadedMessageBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff73d778),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            GlobalConstants.of(context).spacingNormal,
          ),
          child: Row(
            children: [
              Icon(Icons.done, color: Colors.white),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: GlobalConstants.of(context).spacingSmall,
                  ),
                  child: Text(
                    "Your video is being processed. Wait until processing is complete.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
