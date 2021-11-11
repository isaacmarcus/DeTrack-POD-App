import 'package:flutter/material.dart';

import 'Screens/about_page.dart';
import 'Screens/contact_page.dart';
import 'Screens/landing_page.dart';
import 'Screens/work_page.dart';

const kScreenTitlePadding = EdgeInsets.all(15);
const kMasterPaddingL = EdgeInsets.all(60);
const kMasterPaddingS = EdgeInsets.all(28);
const kAppBarHeightDoubleL = 100.0;
const kAppBarHeightDoubleS = 60.0;
const kAppBarHeightL = Size.fromHeight(100);
const kAppBarHeightS = Size.fromHeight(60);
const kSymPadLarge = EdgeInsets.symmetric(horizontal: 60);
const kSymPadSmall = EdgeInsets.symmetric(horizontal: 28);
const kCardPaddingL = EdgeInsets.all(16.0);

const kAppName = "DeTrack POD Downloader";

// Remember to add new menu titles here when a new page is created
const kMenuTitles = [
  ['HOME', LandingPage.id],
  // ['ABOUT', AboutPage.id],
  // ['WORK', WorkPage.id],
  // ['CONTACT', ContactPage.id],
];

ThemeData themeData = ThemeData(
    fontFamily: "RobotoMono",
    canvasColor: Color(0xFF120303),
    scaffoldBackgroundColor: Color(0xFF120303),
    primaryColor: Color(0xFF120303),
    primaryColorLight: Color(0xFF460C0C),
    errorColor: Color(0xFFFF6933),
    backgroundColor: Color(0xFFeeeeee),
    cardColor: Color(0xFF230606),
    primaryTextTheme: Typography.whiteCupertino,
    textTheme: TextTheme(
      headline1: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 55,
        fontWeight: FontWeight.w500,
      ),
      headline2: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
      headline3: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 26,
        fontWeight: FontWeight.w500,
      ),
      headline4: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      headline5: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
      headline6: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      subtitle1: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 14,
        fontWeight: FontWeight.w200,
      ),
      subtitle2: TextStyle(
        color: Color(0xFF999999),
        fontSize: 14,
        fontWeight: FontWeight.w200,
      ),
      bodyText1: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      bodyText2: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 12,
        fontWeight: FontWeight.w200,
      ),
      button: TextStyle(
        color: Color(0xFFeeeeee),
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Color(0xFFFF7847),
      primary: Color(0xFFFF9670),
      brightness: Brightness.dark,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF4b1919),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFaa3d16),
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(85.0)),
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    ));
