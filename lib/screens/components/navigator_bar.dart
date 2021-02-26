import 'package:flutter/material.dart';
import '../camera_screen/camera_screen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({
    Key key,
  }) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
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
          case 1:
            {
              final resultCamera = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
              print("result $resultCamera");

              if (resultCamera) {
                renderSnackBar(context);
              }
            }
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
        // BottomNavigationBarItem(
        //   icon: ImageIcon(
        //     AssetImage('assets/icons/profile.png'),
        //   ),
        //   // ignore: deprecated_member_use
        //   title: Text('Profile'),
        // ),
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
