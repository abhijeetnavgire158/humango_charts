import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:humango_chart/model/activitylistmodel.dart';
import 'package:intl/intl.dart';

class ActivitySummary extends StatefulWidget {
  final ActivityListModel selectedActivityData;

  ActivitySummary({Key key, @required this.selectedActivityData})
      : super(key: key);

  @override
  _ActivitySummaryState createState() => _ActivitySummaryState();
}

class _ActivitySummaryState extends State<ActivitySummary> {
  String activityDate;
  ActivityListModel selectedActivity;

  @override
  void initState() {
    print('activity summery');
    super.initState();
    this.selectedActivity = this.widget.selectedActivityData;
    print(this.selectedActivity);
    activityDate = DateFormat('yyyy-MM-dd')
        .format(new DateTime.fromMillisecondsSinceEpoch(
            this.selectedActivity.actTimestamp * 1000))
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    bool isPotrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    double rowHeight = isPotrait ? 50 : 40;
    return Scrollbar(
      child: Container(
        child: Column(
          children: <Widget>[
            Center(
                child: Text(
              'Activity Summary (${activityDate})',
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
              ),
            )),
            Container(
                color: const Color(0xFF64B5F6),
                height: 40,
                margin: EdgeInsets.all(8.0),
                child: Row(children: <Widget>[
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 40,
// margin: const EdgeInsets.all(0.0), // space between cell
                            padding: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border: Border(
                              right: BorderSide(
                                color: Colors.blue[700],
                                width: 0.5,
                              ),
                            )),
                            child: Text(
                              "  ",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
//fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                            ),
                          ))),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 40,
                          padding: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          )),
                          child: Text(
                            "Max",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ),
                        )),
                  ),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 40,
                          padding: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          )),
                          child: Text(
                            "Avg.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          ),
                        )),
                  ),
                ])),
            Container(
                height: rowHeight,
                child: _cellwithData(selectedActivity, 'Heart Rate')),
            Container(
                height: rowHeight,
                child: _cellwithData(selectedActivity, 'Power')),
            Container(
                height: rowHeight,
                child: _cellwithData(selectedActivity, 'Speed')),
            Container(
                height: rowHeight,
                child: _cellwithData(selectedActivity, 'Cadence')),
            Container(
                height: rowHeight,
                child: _cellwithData(selectedActivity, 'Temperature'))
          ],
        ),
      ),
    );
  }

  Widget _cellwithData(ActivityListModel model, String title) {
    print('_cellwithData');

    String maxValue;
    String avgValue;
    String measurement;
    switch (title) {
      case 'Heart Rate':
        maxValue = model.maxHeartRate.toString();
        avgValue = model.avgHeartRate.toString();
        measurement = '(bpm)';
        break;
      case 'Power':
        maxValue = model.maxPower.toString();
        avgValue = model.avgPower.toString();
        measurement = '(watts)';
        break;
      case 'Speed':
        maxValue =
            model.maxSpeed != null ? model.maxSpeed.toStringAsFixed(2) : 'null';
        avgValue =
            model.avgSpeed != null ? model.avgSpeed.toStringAsFixed(2) : 'null';
        measurement = '(m/s)';
        break;
      case 'Cadence':
        maxValue = model.maxCadence.toString();
        avgValue = model.avgCadence.toString();
        measurement = '(rpm)';
        break;
      case 'Temperature':
        maxValue = model.maxTemperature.toString();
        avgValue = model.avgTemperature.toString();
        measurement = '(°C)';
        break;

      default:
    }

    maxValue = maxValue != 'null' ? maxValue : '-';
    avgValue = avgValue != 'null' ? avgValue : '-';

    return Material(
//color: Colors.blue,
      child: InkWell(
          onTap: () => {print('sds')}, // handle your onTap here
          child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: new BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.yellow[700]),
                  borderRadius: new BorderRadius.only()),
              child: Row(children: <Widget>[
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(
                      color: Colors.grey[700],
                      width: 0.5,
                    ),
                  )),
                  child: Text(
                    title + ' ${measurement}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        color: Colors.black,
//fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                )),
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(
                      color: Colors.grey[700],
                      width: 0.9,
                    ),
                  )),
                  child: Text(
                    maxValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black,
//fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                )),
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    avgValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black,
//fontWeight: FontWeight.w800,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                )),
              ]))),
    );
  }
}
