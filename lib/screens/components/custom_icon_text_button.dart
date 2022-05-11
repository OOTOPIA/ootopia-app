import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final String iconPath;
  final Function onTap;
  final String text;
  final Widget? textWidget;
  const CustomIconTextButton({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onTap,
    this.textWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            Image.asset(
              iconPath,
              width: 18.22,
              height: 19.05,
            ),
            SizedBox(
              width: 16,
            ),
            textWidget ?? Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
