import 'package:flutter/material.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({
    Key key,
  }) : super(key: key);

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.black54,
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
    );
  }
}
