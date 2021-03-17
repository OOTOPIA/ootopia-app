import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/profile/profile_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'components/timeline_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SecureStoreMixin {
  ProfileBloc timelineBloc;
  bool loggedIn = false;
  User user;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<ProfileBloc>(context);
    timelineBloc.add(GetPostsProfileEvent());
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER ANDREW: " + user.fullname);
    }

    if (!loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: user != null ? Text(user.fullname) : Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            iconSize: 36,
            tooltip: 'Show Snackbar',
            onPressed: () => {},
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Avatar(),
              DataProfile(),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: RichText(
              text: TextSpan(
                text: ('Bio: '),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'Bio: Nature gives a person a new perspective of how he should look at life and himself as a part of the environment.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          CaptionOfItems(
            backgroundCaption: Color(0xffE6ECDA),
            backgroundIcon: Color(0xff598006),
            colorIcon: Colors.black,
            pathIcon: 'assets/icons/add.png',
          ),
          _blocBuilder()
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }

  _blocBuilder() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text("Initial"),
          );
        } else if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoadedSucessState) {
          return GridPosts(
            context: context,
            state: state,
          );
        } else if (state is ErrorState) {
          return Center(child: Text("Error"));
        }
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

  Avatar({this.photoUrl}) {
    print("My photo >>>>>>>>$photoUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * .40) - 16,
      height: (MediaQuery.of(context).size.width * .40) - 16,
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(150),
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          "${this.photoUrl}",
        ),
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
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/primary_icon.png',
                valueData: '100',
              ),
              IconDataProfile(
                pathIcon: 'assets/icons_profile/primary_icon.png',
                valueData: '100',
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

  IconDataProfile({this.pathIcon, this.valueData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageIcon(
          AssetImage(this.pathIcon),
          color: Colors.black,
        ),
        Text(' ' + this.valueData ?? '--')
      ],
    );
  }
}

class GridPosts extends StatelessWidget {
  final context;
  final state;

  GridPosts({this.context, this.state}) {
    print('---------> context <---------- ${state.posts[0].username}');
  }

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
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 4,
        children: List.generate(state.posts.length, (index) {
          return GestureDetector(
            onTap: () => _goToTimelinePost(state.posts, index),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    state.posts[index].thumbnailUrl,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
