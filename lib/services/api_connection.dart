import 'dart:convert';

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';

class ApiConnection {
  // --- Function to verify api connection returning a bool ---
  bool verifyConnection(response, context) {
    bool connected = false;
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["info"]["status"] == "ok") {
        connected = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Connected to server!",
            style: themeData.textTheme.subtitle1,
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: themeData.errorColor,
            onPressed: () {
              // does nothing, just removes the snackbar
            },
          ),
          backgroundColor: Colors.grey.withOpacity(0.1),
        ));
      } else {
        print("Error Code: " +
            jsonDecode(response.body)["info"]["error"]["code"].toString());
        print(jsonDecode(response.body)["info"]["error"]["message"].toString());
        String errMsg = "Error Code: " +
            jsonDecode(response.body)["info"]["error"]["code"].toString() +
            " | " +
            jsonDecode(response.body)["info"]["error"]["message"].toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errMsg,
            style: themeData.textTheme.subtitle1,
          ),
          action: SnackBarAction(
            label: 'OK',
            textColor: themeData.errorColor,
            onPressed: () {
              // does nothing, just removes the snackbar
            },
          ),
          backgroundColor: Colors.grey.withOpacity(0.1),
        ));
      }
    } else {
      String errMsg =
          "Error connecting, response code: " + response.statusCode.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errMsg,
          style: themeData.textTheme.subtitle1,
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: themeData.errorColor,
          onPressed: () {
            // does nothing, just removes the snackbar
          },
        ),
        backgroundColor: Colors.grey.withOpacity(0.1),
      ));
    }
    return connected;
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
}
