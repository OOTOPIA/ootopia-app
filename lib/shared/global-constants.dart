import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class GlobalConstants extends InheritedWidget {
  static GlobalConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlobalConstants>()!;

  const GlobalConstants({required Widget child, Key? key})
      : super(key: key, child: child);

  final double spacingSmall = 8;
  final double spacingNormal = 16;
  final double spacingMedium = 32;
  final double spacingLarge = 48;
  final double spacingXL = 64;
  final double screenHorizontalSpace = 22;

  final double logoHeight = 82;

  InputDecoration loginInputTheme(String labelText) {
    return InputDecoration(
      counterText: "",
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black54, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  @override
  bool updateShouldNotify(GlobalConstants oldWidget) => false;
}
