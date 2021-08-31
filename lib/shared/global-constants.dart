import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light/colors.dart';

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
  final double spacingSemiLarge = 40;
  final double logoHeight = 82;

  InputDecoration loginInputTheme(String labelText) {
    return InputDecoration(
      counterText: "",
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: LightColors.grey, width: 0.30),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: LightColors.grey, width: 0.30),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: LightColors.grey, width: 0.30),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  bool updateShouldNotify(GlobalConstants oldWidget) => false;
}
