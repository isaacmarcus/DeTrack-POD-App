import 'package:detrack_pod_dl_app/Screens/landing_page.dart';
import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/screens/about_page.dart';
import 'package:detrack_pod_dl_app/screens/contact_page.dart';
import 'package:detrack_pod_dl_app/screens/splash_page.dart';
import 'package:detrack_pod_dl_app/screens/work_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DeTrack POD Downloader',
      theme: themeData,
      // Screen IDS initiated as static vars in respective screens
      initialRoute: SplashPage.id,
      routes: {
        SplashPage.id: (context) => SplashPage(),
        LandingPage.id: (context) => LandingPage(),
        // WorkPage.id: (context) => WorkPage(),
        // AboutPage.id: (context) => AboutPage(),
        // ContactPage.id: (context) => ContactPage(),
      },
    );
  }
}
