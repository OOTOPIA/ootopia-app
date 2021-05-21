import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/bloc/wallet/wallet_bloc.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/models/wallets/transfer_model.dart';
import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
import 'package:ootopia_app/data/repositories/post_repository.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/data/repositories/wallet_repository.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/profile_screen/skeleton_profile_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'components/menu_profile.dart';
import '../../shared/analytics.server.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:package_info/package_info.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  Map<String, dynamic> args;

  ProfileScreen([this.args]);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SecureStoreMixin, TickerProviderStateMixin {
  UserBloc profileBloc;
  UserRepositoryImpl profileRepositoryImpl = UserRepositoryImpl();
  WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
  PostRepositoryImpl postRepositoryImpl = PostRepositoryImpl();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  WalletBloc walletBloc;

  bool loggedIn = false;
  User user;
  Profile userProfile;
  Wallet wallet;
  List<Transaction> transactions;
  bool loadingPosts = true;
  bool loadPostsError = false;
  bool loadingMorePosts = false;
  bool loadingWallet = true;
  bool loadingTransactions = true;
  bool loadWalletError = false;
  List<TimelinePost> posts = [];
  int _postsPerPageCount = 12;
  bool _hasMorePosts = true;
  int currentPage = 1;
  String userId = "";
  String appVersion;
  TabController _tabController;
  TabController _tabControllerTransactions;
  int _activeTabIndex = 0;
  int _activeTabIndexTransactions = 0;

  @override
  bool get wantKeepAlive => null;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    profileBloc = BlocProvider.of<UserBloc>(context);
    walletBloc = BlocProvider.of<WalletBloc>(context);
    getAppInfo();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
    _tabControllerTransactions = new TabController(length: 3, vsync: this);
    _tabControllerTransactions.addListener(_setActiveTabIndexTransactions);
    this.trackingEvents.profileViewedAProfile(
      widget.args == null || widget.args["id"] == null
          ? "Profile - Own profile"
          : "Profile - Viewed a Profile",
      {"profileId": userId},
    );
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  void _setActiveTabIndexTransactions() {
    setState(() {
      _activeTabIndexTransactions = _tabControllerTransactions.index;
    });
  }

  Future<void> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      this.appVersion = info.version;
    });
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (widget.args == null || widget.args["id"] == null) {
      user = await getCurrentUser();
      print("Meu ID ${user.id}");
      userId = user.id;
    } else {
      userId = widget.args["id"];
    }
    _performAllRequests();
  }

  void _performAllRequests() {
    this.posts = [];
    currentPage = 1;
    getUserProfile(userId);
    getUserPosts();
    getUserWallet();
    getUserTransactionHistory();
  }

  Future getUserProfile(String id) async {
    this.profileRepositoryImpl.getProfile(id).then((user) {
      if (user == null) {
        return;
      }
      setState(() {
        userProfile = user;
      });
    });
  }

  Future getUserPosts() async {
    setState(() {
      if (this.posts.length > 0) {
        loadingMorePosts = true;
      } else {
        loadingPosts = true;
      }
    });
    this
        .postRepositoryImpl
        .getPosts(
          _postsPerPageCount,
          (currentPage - 1) * _postsPerPageCount,
          userId,
        )
        .then((posts) {
      setState(() {
        loadingPosts = false;
        loadingMorePosts = false;
        _hasMorePosts = posts.length == _postsPerPageCount;
        this.posts.addAll(posts.where((post) =>
            post.userId == userId &&
            this.posts.where((p) => p.id == post.id).length == 0));
      });
    }).catchError((onError) {
      setState(() {
        loadingPosts = false;
        loadingMorePosts = false;
        loadPostsError = true;
      });
    });
  }

  Future getUserWallet() async {
    setState(() {
      loadingWallet = true;
    });
    this.walletRepositoryImpl.getWallet(userId).then((wallet) {
      this.wallet = wallet;
      setState(() {
        loadingWallet = false;
      });
    }).catchError((onError) {
      setState(() {
        loadingWallet = false;
        loadWalletError = true;
      });
    });
  }

  Future getUserTransactionHistory([String param = ""]) async {
    print("To aqui e fui chamado");

    setState(() {
      loadingTransactions = true;
    });
    this
        .walletRepositoryImpl
        .getTransactionHistory(userId)
        .then((resultTransactions) {
      print("primeirp ----> ${resultTransactions[0].createdAt}");
      // resultTransactions.forEach((obj) => obj.dateTransaction = DateFormat('dd-MM-yyyy').format(obj['createdAt']));

      var newMap = groupBy(resultTransactions,
          (obj) => DateFormat('dd-MM-yyyy').format(obj['createdAt']));

      print("Oi ----> $newMap");

      this.transactions = resultTransactions;

      setState(() {
        loadingTransactions = false;
      });
    }).catchError((onError) {
      print("error 1 --> ${onError.toString()}");
      setState(() {
        loadingTransactions = false;
        // loadWalletError = true;
      });
    });
  }

  Future<void> _loadMorePosts() async {
    getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: userProfile != null
            ? Text(
                userProfile.fullname,
                style: TextStyle(color: Colors.black),
              )
            : Text(''),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
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
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _performAllRequests();
            currentPage = 1;
            loadingMorePosts = false;
          });
        },
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              // this will set the outer container size to the height of your screen
              height: MediaQuery.of(context).size.height +
                  (30 * (posts.length > 4 ? posts.length / 4 : 1)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Avatar(
                        photoUrl:
                            userProfile == null ? null : userProfile.photoUrl,
                      ),
                      DataProfile(),
                    ],
                  ),
                  (userProfile != null && userProfile.bio != null)
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text:
                                (userProfile != null && userProfile.bio != null
                                    ? TextSpan(
                                        text: ('Bio: '),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: userProfile.bio,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )
                                        ],
                                      )
                                    : TextSpan(text: "")),
                          ),
                        )
                      : SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Container(
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.transparent,
                        tabs: [
                          TabItem(
                            backgroundColor: Color(0xff598006),
                            iconAssetPath: 'assets/icons/add.png',
                            borderBottomColor: Color(0xffbbd784),
                            text: "Posts",
                            isActiveTab: _activeTabIndex == 0,
                          ),
                          TabItem(
                            backgroundColor: Color(0xfffc0499),
                            iconAssetPath: 'assets/icons/ootopia.png',
                            borderBottomColor: Color(0xfff074be),
                            text: "OOZ Wallet",
                            isActiveTab: _activeTabIndex == 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _postsTabView(), // É aqui
                        _walletTabView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigatorBar(
          currentPage: widget.args == null || widget.args["id"] == null
              ? PageRoute.Page.myProfileScreen.route
              : PageRoute.Page.profileScreen.route),
      endDrawer: widget.args == null || widget.args["id"] == null
          ? MenuProfile(
              profileName: this.user?.fullname,
              appVersion: this.appVersion,
            )
          : null,
    );
  }

  _postsTabView() {
    if (loadingPosts) {
      return SkeletonProfileScreen();
    }
    if (loadPostsError) {
      return Center(
        child: Text("Error on get posts"),
      );
    }
    return Column(
      children: [
        GridPosts(
            context: context,
            userId: userId,
            posts: posts,
            getPostCallback: getUserPosts),
        Visibility(
          visible: posts.length >= _postsPerPageCount && _hasMorePosts,
          child: loadingMorePosts
              ? Center(child: CircularProgressIndicator())
              : ButtonTheme(
                  height: 48,
                  child: FlatButton(
                    child: Padding(
                      padding: EdgeInsets.all(
                        GlobalConstants.of(context).spacingSmall,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.expand_more_rounded,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        currentPage++;
                        loadingMorePosts = true;
                      });
                      _loadMorePosts();
                    },
                    color: Colors.white,
                    splashColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  _walletTabView() {
    if (loadingWallet) {
      return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 120,
              ),
              child: SizedBox(
                width: 46,
                height: 46,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }
    if (loadWalletError) {
      return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 300, child: TryAgain(getUserWallet)),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.all(
        GlobalConstants.of(context).spacingNormal,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleActionButton(
                iconAssetPath: 'assets/icons/plus.png',
                text: 'Add money',
                onClick: () {
                  print("add money!");
                },
              ),
              CircleActionButton(
                iconAssetPath: 'assets/icons/arrow_right.png',
                text: 'Send money',
                onClick: () {
                  print("send money!");
                },
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          "Balance in OOz",
                          textAlign: TextAlign.right,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 4,
                          right: 8,
                          bottom: 4,
                          left: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xfffc23a6),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "OOz ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: <TextSpan>[
                              TextSpan(
                                text: wallet != null
                                    ? wallet.totalBalance.toString()
                                    : "0,00",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 6),
            child: Container(
              child: TabBar(
                controller: _tabControllerTransactions,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Color(0xfffc23a6),
                indicatorWeight: 4,
                isScrollable: false,
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelColor: Colors.black.withOpacity(0.5),
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Received",
                  ),
                  Tab(
                    text: "Sent",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabControllerTransactions,
              children: [
                TransactionWidget(transactions: this.transactions),
                TransactionWidget(transactions: this.transactions),
                TransactionWidget(transactions: this.transactions),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String iconAssetPath;
  final String text;
  final Color backgroundColor;
  final Color borderBottomColor;
  final bool isActiveTab;

  TabItem({
    this.iconAssetPath,
    this.text,
    this.backgroundColor,
    this.borderBottomColor,
    this.isActiveTab,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (this.isActiveTab ? 1 : 0.5),
      child: Column(
        children: [
          SizedBox(
            width: 33,
            height: 33,
            child: Container(
              decoration: BoxDecoration(
                color: this.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(150)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: ImageIcon(
                    AssetImage(this.iconAssetPath),
                    color: Colors.black,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              this.text,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: this.borderBottomColor,
            ),
          )
        ],
      ),
    );
  }
}

class CircleActionButton extends StatelessWidget {
  final String iconAssetPath;
  final String text;
  final Function onClick;

  CircleActionButton({this.iconAssetPath, this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: GlobalConstants.of(context).spacingNormal,
      ),
      child: Column(
        children: [
          Ink(
            decoration: const ShapeDecoration(
              color: Color(0xfffd81cc),
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: ImageIcon(
                AssetImage(this.iconAssetPath),
              ),
              color: Colors.white,
              iconSize: 30,
              onPressed: this.onClick,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              this.text,
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  String photoUrl;

  Avatar({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * .40) - 16,
      height: (MediaQuery.of(context).size.width * .40) - 16,
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(150),
      ),
      child: CircleAvatar(
        backgroundImage: this.photoUrl != null
            ? NetworkImage(
                "${this.photoUrl}",
              )
            : AssetImage('assets/icons_profile/profile.png'),
        minRadius: 60,
      ),
    );
  }
}

class DataProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .15,
      width: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconDataProfile(
                pathIcon: 'assets/icons_profile/badge_hero_user.png',
                valueData: '100',
                colorIcon: Color(0xff01E8F8),
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/badge_hero_city.png',
                valueData: '100',
                colorIcon: Color(0xff01A9E4),
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/badge_hero_earth.png',
                valueData: '100',
                colorIcon: Color(0xff0073EA),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconDataProfile(
                pathIcon: 'assets/icons_profile/add.png',
                valueData: '100',
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/navegation.png',
                valueData: '100',
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/ootopia.png',
                valueData: '100',
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/double_ootopia.png',
                valueData: '100',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IconDataProfile extends StatelessWidget {
  String pathIcon;
  String valueData;
  Color colorIcon;

  IconDataProfile({this.pathIcon, this.valueData, this.colorIcon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageIcon(
          AssetImage(this.pathIcon),
          color: colorIcon,
        ),
        Text(' ' + this.valueData ?? '--')
      ],
    );
  }
}

class GridPosts extends StatelessWidget {
  final context;
  final List<TimelinePost> posts;
  final String userId;
  final Function getPostCallback;

  GridPosts({this.context, this.posts, this.userId, this.getPostCallback});

  _goToTimelinePost(posts, postSelected) async {
    await Navigator.of(context).pushNamed(
      PageRoute.Page.timelineProfileScreen.route,
      arguments: {
        "userId": userId,
        "posts": posts,
        "postSelected": postSelected,
      },
    );

    this.getPostCallback();
  }

  @override
  Widget build(BuildContext context) {
    return this.posts.length > 0
        ? GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: List.generate(posts.length, (index) {
              return GestureDetector(
                onTap: () => _goToTimelinePost(posts, index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(14),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        posts[index].thumbnailUrl,
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        : Expanded(
            child: Center(child: Text("No posts")),
          );
  }
}

class TransactionWidget extends StatelessWidget {
  List<Transaction> transactions;

  TransactionWidget({this.transactions});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "OOZ received on 28.09.2020",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        TransactionItemWidget(),
      ],
    );
  }
}

class TransactionItemWidget extends StatelessWidget {
  const TransactionItemWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.fromBorderSide(
          BorderSide(
            color: Color(0xffBDBDBD),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 39,
                width: 39,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: Color(0xffBDBDBD),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "from Pedro Rocha",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("OOZ 10,00"),
            ),
          )
        ],
      ),
    );
  }
}
