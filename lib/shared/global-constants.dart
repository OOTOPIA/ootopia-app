import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/theme/light/colors.dart';

class GlobalConstants extends InheritedWidget {
  static GlobalConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlobalConstants>()!;

  const GlobalConstants({required Widget child, Key? key})
      : super(key: key, child: child);

  final double smallIntermediateSpacing = 12;
  final double spacingSmall = 8;
  final double spacingNormal = 16;
  final double intermediateSpacing = 24;
  final double spacingMedium = 32;
  final double spacingLarge = 48;
  final double spacingXL = 64;
  final double screenHorizontalSpace = 22;
  final double spacingSemiLarge = 40;
  final double logoHeight = 82;

  InputDecoration loginInputTheme(String labelText) {
    return InputDecoration(
        counterText: "",
        labelText: labelText.isNotEmpty ? labelText : null,
        labelStyle: GoogleFonts.roboto(
            color: LightColors.lightGrey, fontWeight: FontWeight.w500),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.30),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.30),
          borderRadius: BorderRadius.circular(4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.grey, width: 0.30),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.errorRed, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: LightColors.errorRed, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        errorStyle: GoogleFonts.roboto(
            color: LightColors.errorRed,
            fontWeight: FontWeight.w400,
            fontSize: 12));
  }

  @override
  bool updateShouldNotify(GlobalConstants oldWidget) => false;
}
