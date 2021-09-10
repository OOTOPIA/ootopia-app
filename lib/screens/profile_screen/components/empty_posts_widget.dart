import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class EmptyPostsWidget extends StatefulWidget {
  EmptyPostsWidget({Key? key}) : super(key: key);

  @override
  _EmptyPostsWidgetState createState() => _EmptyPostsWidgetState();
}

class _EmptyPostsWidgetState extends State<EmptyPostsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Icon(
            FeatherIcons.image,
            color: Color(0xff707070).withOpacity(.5),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "This user has no publications yet",
            style: TextStyle(
              color: Color(0xff707070).withOpacity(.5),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
