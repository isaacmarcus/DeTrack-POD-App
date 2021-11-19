import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/services/photo_album.dart';
import 'package:detrack_pod_dl_app/widgets/download_card.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';

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

  String selectedDirectory = '';

  void pickFolder(date) {
    selectedDirectory = date;
  }

  // --- Function to post json to get all collection DOs based on date ---
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

  List masterDoList = [];
  List masterPODList = [];

  // --- Function to add DOs to master DO List ---
  // --- also calls getDONumbers ---
  void getData(startDate, endDate) async {
    // calculate days between start date and end date selected
    int dateRange = endDate.difference(startDate).inDays;
    // For loop to run through each day and extract the DO Numbers from that day
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
        masterDoList.add(getDONumbers(response.body));
        // print(masterDoList);
      } else {
        print(response.statusCode);
      }
    }
    //

    // for (List dailyList in masterDoList) {
    //   print(dailyList);
    // }
  }

  // --- Function to return a list of DO numbers with the date associated ---
  // --- also calls getPODData ---
  List getDONumbers(data) {
    // decode json body
    var collections = jsonDecode(data)["collections"];
    // loop through body to find all dos
    var curDoList = [];
    for (var job in collections) {
      // only take into account dos that are completed
      if (job["display_tracking_status"].toString() == "Completed") {
        // create a list containing the details for this current DO
        // TODO: make into a class object
        List curDoDeits = [
          job['date'].toString(),
          job['do'].toString(),
          job['addr_company'].toString(),
          job['job_order'].toString(),
        ];
        curDoList.add(curDoDeits); // add to the current DO List
        getPODData(curDoDeits); // call this function to dl DATA automatically
        // use vvv to see json data and headers
        // print(job.toString());
      }
    }
    return curDoList;
  }

  // --- Function to parse data and download automatically ---
  void getPODData(data) async {
    String curDate = data[0];
    String curDO = data[1];
    String curComp = data[2];
    String curTime = data[3];

    // ~http test for PDF BYTES~
    Response responsePDF = await post(
        Uri.parse('https://app.detrack.com/api/v1/collections/export.pdf'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-API-KEY': '4840603d74969363341bd6db9637d635971369c873959bd5'
        },
        body: jsonEncode(
          <String, String>{
            'date': curDate,
            'do': curDO,
          },
        ));

    // ~Create a download anchor for web to automatically download to path~
    final blob = Blob([responsePDF.bodyBytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "$curComp/_$curDate/_$curTime/_$curDO.pdf";
    document.body!.children.add(anchor);
    anchor.click();
    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(url);

    // add the PDF to the master POD List
    setState(() {
      masterPODList.add(responsePDF.bodyBytes);
    });
  }

  // *** Main build widget for the Page ***
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

  // --- Page Content builder ---
  Widget _buildContent() {
    return Padding(
      padding: MediaQuery.of(context).size.width >= 725
          ? kMasterPaddingL
          : kMasterPaddingS,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card to view PODS on screen
          Card(
            child: Container(
              height: 400,
              width: 600,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                ),
                itemCount: masterPODList.length,
                itemBuilder: (context, index) {
                  // return Image.memory(masterPODList[index]);
                  return SfPdfViewer.memory(masterPODList[index]);
                },
              ),
            ),
          ),
          SizedBox(
            width: 100,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                // CARD WIDGET FOR COLLECTIONS DOWNLOADER
                child: DownloadCard(
                  getData: getData,
                  sendFolder: pickFolder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- drawer builder ---
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
