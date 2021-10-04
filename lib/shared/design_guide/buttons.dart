import 'package:flutter/material.dart';

extension OotButton on ElevatedButton {
  ElevatedButton defaultButton(BuildContext context, {ButtonStyle? style}) {
    ButtonStyle defStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        Theme.of(context).accentColor,
      ),
      minimumSize: MaterialStateProperty.all(
        Size(60, 58),
      ),
    );
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: (this.style ?? defStyle).merge(style ?? defStyle),
    );
  }
}
