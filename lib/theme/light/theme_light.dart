import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';

ThemeData lightTheme(BuildContext context) => ThemeData.light().copyWith(
      iconTheme: IconThemeData(color: LightColors.grey),
      backgroundColor: LightColors.white,
      scaffoldBackgroundColor: LightColors.white,
      //snackBarTheme: SnackBarThemeData(backgroundColor: LightColors.black),
      accentColor: LightColors.blue,
      primaryColor: LightColors.accentBlue,
      accentIconTheme: IconThemeData(color: LightColors.highlightText),
      accentTextTheme: TextTheme(
        bodyText2: TextStyle(
          fontSize: 14.0,
          color: LightColors.highlightText,
        ),
      ),
      primaryColorDark: LightColors.grey.withOpacity(0.20),
      primaryColorLight: LightColors.grey.withOpacity(0.05),
      appBarTheme: AppBarTheme(backgroundColor: LightColors.white),
      canvasColor: LightColors.white,
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
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        headline3: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: LightColors.blackText,
        ),
        headline4: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: LightColors.blackText,
        ),
        headline5: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: LightColors.blackText,
        ),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText1: TextStyle(
          fontSize: 12.0,
          color: LightColors.blackText,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          color: LightColors.blackText,
        ),
        subtitle1: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LightColors.blackText,
        ),
        subtitle2: TextStyle(
          fontSize: 14,
          color: LightColors.grey,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
        hintStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white12,
        contentPadding: EdgeInsets.only(
          left: GlobalConstants.of(context).spacingNormal,
          bottom: GlobalConstants.of(context).spacingSmall,
          top: GlobalConstants.of(context).spacingSmall,
          right: GlobalConstants.of(context).spacingNormal,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.5),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
