import 'package:flutter/material.dart';
import '../timeline/timeline.dart';
import '../camera_screen/camera_screen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({
    Key key,
  }) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  // int _selectedIndex = 0;

  // _returnPageSelect() {
  //   if (this._selectedIndex == 0) {
  //     return TimelinePage();
  //   } else if (this._selectedIndex == 0) {
  //     return CameraCapturePage();
  //   }
  // }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.black54,
      onTap: (value) {
        switch (value) {
          case 1:
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            }
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/icons/home.png'),
            color: Colors.black12,
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
            color: Colors.black12,
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
