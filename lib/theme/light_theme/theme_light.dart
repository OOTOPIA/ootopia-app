import 'package:flutter/material.dart';
import 'package:ootopia_app/theme/light_theme/colors.dart';

final ThemeData _lightTheme = _buildDefaultTheme();
ThemeData _buildDefaultTheme() {
  return ThemeData.light().copyWith(
      // iconTheme: IconThemeData(color: AppColors.colors.),
      // backgroundColor: LightColors.white,
      // scaffoldBackgroundColor: LightColors.white,
      // snackBarTheme: SnackBarThemeData(backgroundColor: LightColors.black),
      // accentColor: LightColors.purple,
      // primaryColorDark: LightColors.whiteText,
      // appBarTheme: AppBarTheme(backgroundColor: LightColors.white),
      // canvasColor: LightColors.white,
      // //accen
      // tabBarTheme: TabBarTheme(
      //   labelColor: LightColors.blackText,
      //   unselectedLabelColor: LightColors.grey.withOpacity(0.50),
      // ),
      // cardTheme: CardTheme(
      //   shadowColor: LightColors.darkGrey,
      //   color: LightColors.white,
      // ),
      // dialogTheme: DialogTheme(
      //   backgroundColor: LightColors.white,
      //   titleTextStyle: TextStyle(
      //     fontSize: 16.0,
      //   ),
      // ),
      // textTheme: TextTheme(
      //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      //   headline3: TextStyle(
      //       fontSize: 20.0,
      //       fontWeight: FontWeight.w500,
      //       color: LightColors.blackText),
      //   headline4: TextStyle(
      //     fontSize: 18.0,
      //     fontWeight: FontWeight.w500,
      //     color: LightColors.blackText,
      //   ),
      //   headline5: TextStyle(
      //     fontSize: 12.0,
      //     fontWeight: FontWeight.w500,
      //     color: LightColors.blackText,
      //   ),
      //   headline6: TextStyle(fontSize: 16.0, color: LightColors.blackText),
      //   bodyText1: TextStyle(
      //     fontSize: 12.0,
      //     color: LightColors.blackText,
      //   ),
      //   bodyText2: TextStyle(
      //     fontSize: 12.0,
      //     color: LightColors.blackText,
      //   ),
      //   subtitle1: TextStyle(
      //     fontSize: 16,
      //     fontWeight: FontWeight.bold,
      //     color: LightColors.blackText,
      //   ),
      // ),
      // inputDecorationTheme: InputDecorationTheme(
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(color: Color(0xffF7F7F7), width: 1),
      //     borderRadius: BorderRadius.circular(100),
      //   ),
      //   hintStyle: TextStyle(
      //     color: Colors.black54,
      //     fontWeight: FontWeight.normal,
      //   ),
      //   filled: true,
      //   fillColor: Color(0xffF7F7F7),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: LightColors.purple, width: 1.3),
      //     borderRadius: BorderRadius.circular(100),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: BorderSide(color: Color(0xffF7F7F7), width: 1),
      //     borderRadius: BorderRadius.circular(100),
      //   ),
      // ),
      );
}

ThemeData lightTheme() => _lightTheme;
