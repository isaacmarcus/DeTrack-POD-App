import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../constants.dart';

class DownloadCard extends StatefulWidget {
  final Function getData;

  DownloadCard({required this.getData});

  @override
  _DownloadCardState createState() => _DownloadCardState();
}

class _DownloadCardState extends State<DownloadCard> {
  @override
  void initState() {
    super.initState();

    // Initialize today's date
    _startDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _endDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    _range = _startDate.toString() + ' - ' + _endDate.toString();
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String _startDate = '';
  String _endDate = '';

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
        _startDate = DateFormat('dd/MM/yyyy').format(args.value.startDate);
        _endDate = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.startDate);
        _range = _startDate.toString() + ' - ' + _endDate.toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width >= 725 ? 385 : double.infinity,
      child: Card(
        color: themeData.cardColor,
        elevation: 5.0,
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
                        "Collections",
                        style: themeData.textTheme.headline3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Selected range: ' + _range,
                        style: themeData.textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              // MAIN Date Picker Widget
              Container(
                margin: EdgeInsets.zero,
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.zero,
                  color: Color(0xFF340909),
                  elevation: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Container to hold Date Range Picker
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width >= 725
                            ? 300
                            : MediaQuery.of(context).size.width * 0.75,
                        child: SfDateRangePicker(
                          // Styling for the date picker
                          headerHeight: 50,
                          selectionTextStyle: themeData.textTheme.headline6,
                          rangeTextStyle: themeData.textTheme.subtitle1,
                          headerStyle: DateRangePickerHeaderStyle(
                              textStyle: themeData.textTheme.headline4),
                          monthViewSettings: DateRangePickerMonthViewSettings(
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
                ),
              ),
              SizedBox(height: 10),
              // Download Button
              ElevatedButton(
                onPressed: () {
                  widget.getData(_startDate, _endDate);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Download",
                    style: themeData.textTheme.button,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
