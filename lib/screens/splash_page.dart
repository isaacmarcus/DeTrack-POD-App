import 'package:detrack_pod_dl_app/constants.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatelessWidget {
  static const String id = "splash_page";
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 5,
      splash: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        width: 100,
        height: 0.5,
        child: LinearProgressIndicator(
          minHeight: 1,
          backgroundColor: themeData.scaffoldBackgroundColor,
          color: themeData.backgroundColor,
          semanticsLabel: 'Linear progress indicator',
        ),
      ),
      nextScreen: LandingPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      backgroundColor: themeData.scaffoldBackgroundColor,
    );
  }
}
