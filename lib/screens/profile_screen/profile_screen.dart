import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/data/models/users/profile_model.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/profile_screen/skeleton_profile_screen.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'components/timeline_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String id;

  ProfileScreen({this.id});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SecureStoreMixin {
  UserBloc profileBloc;
  UserRepositoryImpl profileRepositoryImpl = UserRepositoryImpl();

  bool loggedIn = false;
  User user;
  Profile userProfile;
  bool loadingPosts = true;
  bool loadPostsError = false;
  List<TimelinePost> posts = [];

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    profileBloc = BlocProvider.of<UserBloc>(context);
  }

  void _checkUserIsLoggedIn() async {
    String userId = "";
    loggedIn = await getUserIsLoggedIn();
    if (widget.id == null) {
      user = await getCurrentUser();
      userId = user.id;
    } else {
      userId = widget.id;
    }
    getUserProfile(userId);
    profileBloc.add(GetPostsProfileEvent(1, userId));
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
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
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
        actions: [
          widget.id == null
              ? IconButton(
                  icon: const Icon(Icons.menu_outlined),
                  iconSize: 36,
                  color: Colors.black,
                  tooltip: 'Show Snackbar',
                  onPressed: () => {},
                )
              : SizedBox.shrink()
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Avatar(
                    photoUrl: userProfile == null ? null : userProfile.photoUrl,
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
                        text: (userProfile != null && userProfile.bio != null
                            ? TextSpan(
                                text: ('Bio: '),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16),
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
            ],
          ),
          CaptionOfItems(
            backgroundCaption: Color(0xffE6ECDA),
            backgroundIcon: Color(0xff598006),
            colorIcon: Colors.black,
            pathIcon: 'assets/icons/add.png',
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is LoadingState) {
                loadingPosts = true;
              } else if (state is LoadedPostsProfileSucessState) {
                loadingPosts = false;
                posts = state.posts;
              } else if (state is LoadPostsProfileErrorState) {
                loadPostsError = true;
              }
            },
            child: _postsBlocBuilder(),
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }

  _postsBlocBuilder() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (loadingPosts) {
          return SkeletonProfileScreen();
        }
        if (loadPostsError) {
          return Center(
            child: Text("Error"),
          );
        }
        return GridPosts(
          context: context,
          posts: posts,
        );
      },
    );
  }
}

class CaptionOfItems extends StatelessWidget {
  final Color backgroundCaption;
  final Color backgroundIcon;
  final Color colorIcon;
  final String pathIcon;

  const CaptionOfItems({
    this.backgroundCaption,
    this.backgroundIcon,
    this.colorIcon,
    this.pathIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            height: 36,
            margin: EdgeInsets.only(bottom: 8, top: 8),
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: this.backgroundCaption,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
                topLeft: Radius.circular(150),
              ),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: this.backgroundIcon,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ImageIcon(
                      AssetImage(this.pathIcon),
                      color: this.colorIcon,
                      size: 36,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('Posts'),
                )
              ],
            )),
      ],
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
                pathIcon: 'assets/icons_profile/primary_icon.png',
                valueData: '100',
                colorIcon: Color(0xff01E8F8),
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/primary_icon.png',
                valueData: '100',
                colorIcon: Color(0xff01A9E4),
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/primary_icon.png',
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

  GridPosts({this.context, this.posts});

  _goToTimelinePost(posts, postSelected) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimelineScreenProfileScreen(
          posts: posts,
          postSelected: postSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: this.posts.length > 0
          ? GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              crossAxisCount: 4,
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
          : Center(child: Text("Esse usuário ainda não tem postagem")),
    );
  }
}
