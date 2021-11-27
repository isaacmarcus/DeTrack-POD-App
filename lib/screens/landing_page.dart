import 'dart:convert';
import 'dart:io' as io;
import 'dart:ui';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:archive/archive.dart';
import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/services/photo_album.dart';
import 'package:detrack_pod_dl_app/widgets/download_card.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';
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

  List masterDoList = []; // list with sorted DO Details
  List masterPODList = []; // list to build viewer
  List masterPODBytes = []; // list to contain PODs in bytes

  // --- Function to add DOs to master DO List ---
  // --- also calls getDONumbers ---
  void getData(startDate, endDate) async {
    String dateRangeString = DateFormat('yyyy-MM-dd').format(startDate) +
        " to " +
        DateFormat('yyyy-MM-dd').format(endDate);
    // add to archivezip
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
            'X-API-KEY': '4840603d74969363341bd6db9637d635971369c873959bd5'
          },
          body: jsonEncode(
            <String, String>{
              'date': DateFormat('yyyy-MM-dd').format(curDate),
            },
          ));
      // check response if successful, if so execute getDoNumbers
      if (response.statusCode == 200) {
        masterDoList.add(await getDONumbers(response.body, archive));
        // print(masterDoList);
      } else {
        print(response.statusCode);
      }
    }

    // Create outputstream object
    var outputStream = OutputStream(
      byteOrder: LITTLE_ENDIAN,
    );
    // Create zipped bytes object
    var bytes = encoder.encode(archive,
        level: Deflate.BEST_COMPRESSION, output: outputStream);

    // generate user download for zipped file
    generatePODZipDownload(bytes, dateRangeString);
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
          'X-API-KEY': '4840603d74969363341bd6db9637d635971369c873959bd5'
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

  void generatePODZipDownload(zipbytes, daterange) {
    // ~Create a download anchor for web to automatically download to path~
    final blob = Blob([zipbytes]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "$daterange\_PODList.zip";
    document.body!.children.add(anchor);
    anchor.click();
    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(url);
    EasyLoading.dismiss();
  }

  // Function to calculate number of DOs being called for progress indicator
  int calculateNoOfDos() {
    int numDays = 0;
    return numDays;
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
          MediaQuery.of(context).size.width >= 1025
              ? Row(
                  children: [
                    Container(
                      height: 465,
                      width: MediaQuery.of(context).size.width * 0.4,
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
                                  // return Image.memory(masterPODList[index]);
                                  return Container(
                                      padding: EdgeInsets.all(15),
                                      child: SfPdfViewer.memory(
                                          masterPODList[index]));
                                },
                              )
                            : Center(
                                child: Text(
                                "No PODs loaded...",
                                style: themeData.textTheme.headline3,
                              )),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                  ],
                )
              : SizedBox.shrink(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                // CARD WIDGET FOR COLLECTIONS DOWNLOADER
                child: Stack(
                  children: <Widget>[
                    DownloadCard(
                      getData: getData,
                      sendFolder: pickFolder,
                    ),
                  ],
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
