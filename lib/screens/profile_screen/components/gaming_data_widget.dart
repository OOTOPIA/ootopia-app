import 'package:flutter/material.dart';

class GamingDataWidget extends StatefulWidget {
  final String title;
  final int amount;
  final IconData icon;
  final Color colorIcon;
  GamingDataWidget({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.colorIcon,
  }) : super(key: key);

  @override
  _GamingDataWidgetState createState() => _GamingDataWidgetState();
}

class _GamingDataWidgetState extends State<GamingDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          widget.icon,
          color: widget.colorIcon,
        ),
        SizedBox(
          width: 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.amount.toString() + " ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff000000),
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: widget.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff707070),
                      fontWeight: FontWeight.w400)),
            ]))
          ],
        ),
      ],
    );
  }
}
