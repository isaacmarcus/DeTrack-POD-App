import 'dart:convert';
import 'dart:ui';

import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/widgets/download_card.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

/* --------------------------------------------------------------------------

Page Title: Landing Page
Widget Description: Landing Page for the app

-----------------------------------------------------------------------------*/

class LandingPage extends StatefulWidget {
  static const String id = "landing_page";

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  String _apiKey = "4840603d74969363341bd6db9637d635971369c873959bd5";

  @override
  void initState() {
    super.initState();
    // initialize animation controller for drawer slider
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

  // function to check on the menu drawer, only applies in mobile size
  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  Future<dynamic> postCollectionDate(date) async {
    Response response = await post(
        Uri.parse('https://app.detrack.com/api/v1/collections/view/all.json'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-API-KEY': '4840603d74969363341bd6db9637d635971369c873959bd5'
        },
        body: jsonEncode(
          <String, String>{
            'date': date,
          },
        ));
    if (response.statusCode == 200) {
      return response;
    } else {
      return response.statusCode;
    }
  }

  void getData(startDate, endDate) async {
    // calculate days between start date and end date selected
    int dateRange = endDate.difference(startDate).inDays;
    for (int i = 0; i <= dateRange; i++) {
      DateTime curDate = startDate.add(Duration(
          days: i)); // create new var to store new date; refer to .add docs
      // post to API to get json data on current date
      Response response = await post(
          Uri.parse('https://app.detrack.com/api/v1/collections/view/all.json'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-API-KEY': '4840603d74969363341bd6db9637d635971369c873959bd5'
          },
          body: jsonEncode(
            <String, String>{
              'date': DateFormat('yyyy-MM-dd').format(curDate),
            },
          ));
      // check response if successful, if so execute getDoNumbers
      if (response.statusCode == 200) {
        getDONumbers(response.body);
      } else {
        print(response.statusCode);
      }
    }
  }

  void getDONumbers(data) {
    var collections = jsonDecode(data)["collections"];
    for (var job in collections) {
      if (job["display_tracking_status"].toString() == "Completed") {
        print(job["do"].toString());
      }
    }
  }

  // ** Main build widget for the Page **
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: MasterAppBar(drawerSlideController: _drawerSlideController),
        preferredSize: MediaQuery.of(context).size.width >=
                725 // checks screen size and applies formatting accordingly
            ? kAppBarHeightL
            : kAppBarHeightS,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Main page body content
          Container(
            color: Colors.transparent,
            child: BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 0.6, sigmaY: 0.6),
                child: _buildContent()),
          ),
          // Stacked Menu
          _buildDrawer(),
        ],
      ),
    );
  }

  // Page Content builder
  Widget _buildContent() {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 725
          ? kMasterPaddingL
          : kMasterPaddingS,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            // CARD WIDGET FOR COLLECTIONS DOWNLOADER
            child: DownloadCard(
              getData: getData,
            ),
          ),
        ],
      ),
    );
  }

  // drawer builder
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
