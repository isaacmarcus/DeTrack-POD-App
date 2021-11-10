import 'dart:ui';

import 'package:detrack_pod_dl_app/constants.dart';
import 'package:detrack_pod_dl_app/widgets/menu_drawer.dart';
import 'package:detrack_pod_dl_app/widgets/master_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
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
            // *TODO* move to widgets folder
            child: Container(
              width: MediaQuery.of(context).size.width >= 725
                  ? 385
                  : double.infinity,
              child: Card(
                color: themeData.cardColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: kCardPaddingL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Collections Download",
                                style: themeData.textTheme.headline3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Selected date: ' + _selectedDate,
                                style: themeData.textTheme.subtitle1,
                              ),
                              Text(
                                'Selected date count: ' + _dateCount,
                                style: themeData.textTheme.subtitle1,
                              ),
                              Text(
                                'Selected range: ' + _range,
                                style: themeData.textTheme.subtitle1,
                              ),
                              Text(
                                'Selected ranges count: ' + _rangeCount,
                                style: themeData.textTheme.subtitle1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width >= 725
                                ? 300
                                : MediaQuery.of(context).size.width * 0.75,
                            height: 350,
                            child: SfDateRangePicker(
                              // Styling for the date picker
                              selectionTextStyle: themeData.textTheme.headline6,
                              rangeTextStyle: themeData.textTheme.subtitle1,
                              headerStyle: DateRangePickerHeaderStyle(
                                  textStyle: themeData.textTheme.headline4),
                              monthViewSettings:
                                  DateRangePickerMonthViewSettings(
                                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                    textStyle: themeData.textTheme.headline5),
                              ),
                              monthCellStyle: DateRangePickerMonthCellStyle(
                                textStyle: themeData.textTheme.subtitle1,
                                todayTextStyle: themeData.textTheme.subtitle1,
                              ),
                              yearCellStyle: DateRangePickerYearCellStyle(
                                textStyle: themeData.textTheme.subtitle1,
                                disabledDatesTextStyle:
                                    themeData.textTheme.subtitle2,
                                todayTextStyle: themeData.textTheme.subtitle1,
                                leadingDatesTextStyle:
                                    themeData.textTheme.subtitle2,
                              ),
                              viewSpacing: 5,
                              onSelectionChanged: _onSelectionChanged,
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialDisplayDate: DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
