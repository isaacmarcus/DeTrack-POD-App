import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/material.dart';

/* --------------------------------------------------------------------------

Page Title: About Page
About Description: About Page for bio and description 

-----------------------------------------------------------------------------*/

class AboutPage extends StatefulWidget {
  static const String id = "about_page";

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: MasterAppBar(drawerSlideController: _drawerSlideController),
        preferredSize: MediaQuery.of(context).size.width >= 725
            ? kAppBarHeightL
            : kAppBarHeightS,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main page body content
          _buildContent(),
          // Stacked Menu
          _buildDrawer(),
        ],
      ),
    );
  }

  // Page Content
  Widget _buildContent() {
    return Center(
      child: Padding(
        padding: MediaQuery.of(context).size.width >= 725
            ? kMasterPaddingL
            : kMasterPaddingS,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Hero(
              tag: "title",
              child: Text(
                "ABOUT ME",
                style: MediaQuery.of(context).size.width >= 725
                    ? themeData.textTheme.headline1
                    : themeData.textTheme.headline2,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed()
              ? const SizedBox()
              : Menu(
                  dsController: _drawerSlideController,
                ),
        );
      },
    );
  }
}
