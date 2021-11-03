import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/material.dart';

/* --------------------------------------------------------------------------

Page Title: Contact Page
Page Description: to give details of contact points

-----------------------------------------------------------------------------*/

class ContactPage extends StatefulWidget {
  static const String id = "contact_page";

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Hero(
              tag: "title",
              child: Text(
                "CONTACT",
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
