import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import '../camera_screen/camera_screen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({
    Key key,
  }) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> with SecureStoreMixin {
  bool loggedIn = false;
  User user;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user.fullname);
    }

    // if (!loggedIn) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //   );
    // }
  }

  renderSnackBar(BuildContext context) {
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "O vídeo esta sendo carregado",
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.black54,
      onTap: (value) async {
        switch (value) {
          case 0:
            await Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => TimelinePage()),
            );

            break;

          case 1:
            if (!loggedIn) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );

              return;
            }

            final resultCamera = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen()),
            );

            if (resultCamera != null) {
              renderSnackBar(context);
            }
            break;

          case 2:
            if (!loggedIn) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );

              return;
            }

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );

            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/home.png'),
            color: Colors.black,
          ),
          // ignore: deprecated_member_use
          title: Text('Home'),
        ),
        // BottomNavigationBarItem(
        //   icon: ImageIcon(
        //     AssetImage('assets/icons/search.png'),
        //   ),
        // ignore: deprecated_member_use
        //   title: Text('Search'),
        // ),
        // BottomNavigationBarItem(
        //   icon: ImageIcon(
        //     AssetImage('assets/icons/navegation.png'),
        //   ),
        //   // ignore: deprecated_member_use
        //   title: Text('Share'),
        // ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/add.png'),
            color: Colors.black,
          ),
          // ignore: deprecated_member_use
          title: Text('Add'),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/profile.png'),
            color: Colors.black,
          ),
          // ignore: deprecated_member_use
          title: Text('Profile'),
        ),
        // BottomNavigationBarItem(
        //   icon: ImageIcon(
        //     AssetImage('assets/icons/ootopia.png'),
        //   ),
        //   // ignore: deprecated_member_use
        //   title: Text('Home'),
        // ),
      ],
      // currentIndex: _selectedIndex,
      // selectedItemColor: Colors.amber[800],
      // onTap: _onItemTapped,
    );
  }
}
