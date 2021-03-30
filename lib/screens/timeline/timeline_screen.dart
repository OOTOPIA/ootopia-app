import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'components/feed_player/multi_manager/flick_multi_manager.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> with SecureStoreMixin {
  TimelinePostBloc timelineBloc;
  bool loggedIn = false;
  User user;

  FlickMultiManager flickMultiManager;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    timelineBloc.add(LoadingSucessTimelinePostEvent());
    flickMultiManager = FlickMultiManager();
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user.fullname);
    }
  }

  void _backButton(BuildContext context) {
    Navigator.pop(context);
  }

  void _goToProfile() {
    Navigator.of(context).pushNamed(user.registerPhase == 1
        ? PageRoute.Page.registerPhase2Screen.route
        : PageRoute.Page.profileScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 42),
        elevation: 0,
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
        // backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageIcon(
                  AssetImage('assets/icons/profile.png'),
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () => _goToProfile(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .4,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * .15,
                      lineHeight: 16.0,
                      percent: 0.5,
                      backgroundColor: Colors.transparent,
                      progressColor: Color(0xff1BE7FA),
                    ),
                  ),
                ),
                ImageIcon(
                  AssetImage('assets/icons/location.png'),
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () => _goToProfile(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .4,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * .15,
                      lineHeight: 16.0,
                      percent: 0.5,
                      backgroundColor: Colors.transparent,
                      progressColor: Color(0xff0AA7EA),
                    ),
                  ),
                ),
                ImageIcon(
                  AssetImage('assets/icons/earth.png'),
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () => _goToProfile(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: .4,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width * .15,
                      lineHeight: 16.0,
                      percent: 0.1,
                      backgroundColor: Colors.transparent,
                      progressColor: Color(0xff026FF2),
                    ),
                  ),
                ),
              ],
            ),
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
                  }
                },
                child: _blocBuilder(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(
        currentPage: PageRoute.Page.timelineScreen.route,
      ),
    );
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
                      state.posts = [];
                      _getData();
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return PhotoTimeline(
                          post: state.posts[index],
                          timelineBloc: this.timelineBloc,
                          loggedIn: this.loggedIn,
                          user: user,
                          flickMultiManager: flickMultiManager,
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
                'nothing data :(',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getData() async {
    setState(() {
      timelineBloc.add(LoadingSucessTimelinePostEvent());
    });
  }
}
