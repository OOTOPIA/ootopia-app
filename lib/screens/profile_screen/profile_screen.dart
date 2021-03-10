import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alice da Silva'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Avatar(),
              DataProfile(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        ),
        minRadius: 80,
      ),
    );
  }
}

class DataProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
            IconDataProfile(
              pathIcon: 'assets/icons_profile/primary_icon.png',
              valueData: '100',
            ),
          ],
        ),
      ],
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
