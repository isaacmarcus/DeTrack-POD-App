import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/screens/landing_page.dart';
import 'package:detrack_pod_dl_app/widgets/full_screen_appbar_row.dart';
import 'package:detrack_pod_dl_app/widgets/title_text_button.dart';
import 'package:flutter/material.dart';

/* --------------------------------------------------------------------------

Widget Title: Master App Bar
Widget Description: Widget for app bar that is consistent throughout the different
pages of the "app"

-----------------------------------------------------------------------------*/

class MasterAppBar extends StatefulWidget {
  final AnimationController drawerSlideController;

  MasterAppBar({required this.drawerSlideController});

  @override
  _MasterAppBarState createState() => _MasterAppBarState();
}

class _MasterAppBarState extends State<MasterAppBar>
    with SingleTickerProviderStateMixin {
  bool isDrawerOpen() {
    return widget.drawerSlideController.value == 1.0;
  }

  bool isDrawerOpening() {
    return widget.drawerSlideController.status == AnimationStatus.forward;
  }

  void toggleDrawer() {
    if (isDrawerOpen() || isDrawerOpening()) {
      widget.drawerSlideController.reverse();
    } else {
      widget.drawerSlideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "appbar",
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Center(
          child: Padding(
            padding: MediaQuery.of(context).size.width >= 725
                ? kSymPadLarge
                : kSymPadSmall,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleTextButton(
                  buttonText: "Isaac Marcus",
                  pressedFunction: () {
                    Navigator.pushReplacementNamed(context, LandingPage.id);
                    if (isDrawerOpen()) {
                      toggleDrawer();
                    }
                  },
                ),
                // Check if screen size is smaller than 725 logical pixels
                MediaQuery.of(context).size.width >= 725
                    ? FullScreenABarRow()
                    // If smaller than 725 logical pixels input code here
                    : AnimatedBuilder(
                        animation: widget.drawerSlideController,
                        builder: (context, child) {
                          return IconButton(
                            onPressed: toggleDrawer,
                            icon: isDrawerOpen() || isDrawerOpening()
                                ? const Icon(
                                    Icons.clear,
                                    color: Color(0xFFeeeeee),
                                  )
                                : const Icon(
                                    Icons.menu,
                                    color: Color(0xFFeeeeee),
                                  ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
