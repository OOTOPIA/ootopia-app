import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RegenerationStatusIcons extends StatefulWidget {
  Function onClick;
  RegenerationStatusIcons({required this.onClick});
  @override
  _RegenerationStatusIconsState createState() =>
      _RegenerationStatusIconsState();
}

class _RegenerationStatusIconsState extends State<RegenerationStatusIcons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ImageIcon(
            AssetImage('assets/icons/profile.png'),
            color: Colors.black,
          ),
          GestureDetector(
            onTap: () => widget.onClick,
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
            onTap: () => widget.onClick,
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
            onTap: () => widget.onClick,
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
    );
  }
}
