import 'screens/landing_page.dart';
import 'constants.dart';
import 'screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
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
