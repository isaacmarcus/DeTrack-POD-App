import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:archive/archive.dart';
import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/services/api_connection.dart';
import 'package:detrack_pod_dl_app/widgets/download_card.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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

  String _apiKey = "";
  List masterDoList = []; // list with sorted DO Details
  List masterPODList = []; // list to build viewer
  List masterPODBytes = []; // list to contain PODs in bytes
  String apiStatus = "Disconnected";
  String podViewerStatus = "No PODs loaded...";

  ApiConnection apiObj = ApiConnection();

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

  // --- Function to test a post to server and update apikey var ---
  // --- also updates "connected" icon accordingly ---
  void updateApiKey(keyInput) async {
    print(_apiKey);
    Response testResponse = await post(
        Uri.parse('https://app.detrack.com/api/v1/collections/view/all.json'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-API-KEY': _apiKey
        },
        body: jsonEncode(
          <String, String>{
            'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          },
        ));

    setState(() {
      if (apiObj.verifyConnection(testResponse, context)) {
        _apiKey = keyInput;
        apiStatus = "connected";
      } else {
        apiStatus = "disconnected";
      }
      print("status: $apiStatus");
    });
  }

  // --- Function to add DOs to master DO List ---
  // --- also calls getDONumbers ---
  void getData(startDate, endDate) async {
    masterPODList.clear(); // reset the POD list viewer
    String dateRangeString = DateFormat('yyyy-MM-dd').format(startDate) +
        " to " +
        DateFormat('yyyy-MM-dd').format(endDate);
    // initialize encoder and archive
    var encoder = ZipEncoder();
    var archive = Archive();
    // Start loading popup
    EasyLoading.show(status: 'downloading...');
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
            'X-API-KEY': _apiKey
          },
          body: jsonEncode(
            <String, String>{
              'date': DateFormat('yyyy-MM-dd').format(curDate),
            },
          ));

      // check response if successful, if so execute getDoNumbers
      if (apiStatus == "connected") {
        masterDoList.add(await getDONumbers(response.body, archive));

        // Create outputstream object
        var outputStream = OutputStream(
          byteOrder: LITTLE_ENDIAN,
        );
        // Create zipped bytes object
        var bytes = encoder.encode(archive,
            level: Deflate.BEST_COMPRESSION, output: outputStream);

        // generate user download for zipped file
        apiObj.generatePODZipDownload(bytes, dateRangeString);
      } else {
        setState(() {
          podViewerStatus = "Please Connect to Server with API Key";
        });
        EasyLoading.dismiss();
      }
    }
  }

  // --- Function to return a list of DO numbers with the date associated ---
  // --- also calls getPODData ---
  Future<List> getDONumbers(data, archive) async {
    // decode json body containing all DOs per date
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
        // Call getPODData to create archivefile
        ArchiveFile archiveFile = await compute(getPODData, curDoDeits);
        // add current archive file to archive
        archive.addFile(archiveFile);

        // use vvv to see json data and headers
        // print(job.toString());
      }
    }
    return curDoList;
  }

  // --- Function to parse data and download automatically ---
  Future<ArchiveFile> getPODData(data) async {
    String curDate = data[0];
    String curDO = data[1];
    String curComp = data[2];
    String curTime = data[3];

    // ~http post for PDF BYTES~
    Response responsePDF = await post(
        Uri.parse('https://app.detrack.com/api/v1/collections/export.pdf'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-API-KEY': _apiKey
        },
        body: jsonEncode(
          <String, String>{
            'date': curDate,
            'do': curDO,
          },
        ));

    // add current DO PDF to archivezip
    ArchiveFile archiveFiles = ArchiveFile(
        "$curComp\_$curDate\_$curTime\_$curDO.pdf",
        responsePDF.bodyBytes.lengthInBytes,
        responsePDF.bodyBytes);
    print(archiveFiles);

    // add the PDF to the master POD List
    setState(() {
      masterPODList.add(responsePDF.bodyBytes);
    });

    return archiveFiles;
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
          _buildContent(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- API KEY Card ---
          Container(
            width: MediaQuery.of(context).size.width >= 1025
                ? double.infinity
                : MediaQuery.of(context).size.width >= 725
                    ? kMaxCardWidth
                    : MediaQuery.of(context).size.width * 0.7,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "API Key: ",
                      style: themeData.textTheme.subtitle1,
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (inp) {
                          _apiKey = inp;
                        },
                        decoration: InputDecoration(
                            constraints: BoxConstraints(
                              minWidth: double.infinity,
                              maxWidth: double.infinity,
                              maxHeight: 43,
                            ),
                            isDense: true,
                            hintText: "Enter API Key here"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    apiStatus == "connecting"
                        ? SizedBox(
                            child: CircularProgressIndicator(),
                            width: 20,
                            height: 20,
                          )
                        : apiStatus == "connected"
                            ? Icon(
                                Icons.check_circle_outline_rounded,
                                size: 25,
                                color: themeData.errorColor,
                              )
                            : Icon(
                                Icons.remove_circle_outline_rounded,
                                size: 25,
                                color: Colors.grey[700],
                              ),
                    SizedBox(
                      width: 10,
                    ),
                    // -- Connect Button --
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          apiStatus = "connecting";
                          updateApiKey(_apiKey);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Connect",
                          style: themeData.textTheme.button,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          150,
                          40,
                        ),
                        maximumSize: Size(200, 43),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
          Container(
            constraints: BoxConstraints(
              maxHeight: 515,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Card to view PODS on screen ---
                MediaQuery.of(context).size.width >= 1025
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: masterPODList.length != 0
                                    ? GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 0.9,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 1,
                                        ),
                                        itemCount: masterPODList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              padding: EdgeInsets.all(15),
                                              child: SfPdfViewer.memory(
                                                  masterPODList[index]));
                                        },
                                      )
                                    : Center(
                                        child: Padding(
                                        padding: kMasterPaddingS,
                                        child: Text(
                                          podViewerStatus,
                                          style: themeData.textTheme.headline3,
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                // SizedBox.shrink(),
                DownloadCard(
                  getData: getData,
                  connected: apiStatus == "connected" ? true : false,
                ),
              ],
            ),
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
