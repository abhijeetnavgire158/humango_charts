import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humango_chart/homepage.dart';
import 'package:humango_chart/model/activitylistmodel.dart';
import 'package:humango_chart/presentation/my_flutter_app_icons.dart';
import 'package:intl/intl.dart';

class ActivityListView extends StatefulWidget {
  @override
  _ActivityListViewState createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView> {
  int _sortColumnIndex;
  bool _sortAscending = true;
  bool isload = false;
  bool isLoading = false;
  int tableCount;
  int totalRecords = 15;

  String path = 'jsondata/activity_records/';
  List<ActivityListModel> activityListData = [];

  Future<String> _loadAActivityListAsset() async {
    return await rootBundle.loadString('jsondata/activitylist.json');
  }

  getData() async {
    String data = await _loadAActivityListAsset();
    print('Table List 4');
    // print(data);
    final List activityList = json.decode(data);
    List<ActivityListModel> listData =
        activityList.map((val) => ActivityListModel.fromJson(val)).toList();

    return listData;
  }

  _generateData() async {
    activityListData = await getData();
    this.onDataLoad();
  }

  void _sort<T>(Comparable<T> getField(ActivityListModel d), int columnIndex,
      bool ascending) {
    // _activityListDataSource._sort<T>(getField, ascending);
    tableCount = activityListData.length;
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      tableCount = activityListData.length;
    });
  }

  onDataLoad() {
    setState(() {
      tableCount = activityListData.length;
      isload = true;
    });
  }

  @override
  void initState() {
    print('activity list ');
    super.initState();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HUmango: Flutter List'),
      ),
      body: Scrollbar(
        child: isload == true
            ? Container(
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      'Activity List',
                      style: TextStyle(
                        fontSize: 24,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.23,
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
                                      "Date",
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                    "Sport",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
//fontWeight: FontWeight.bold,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                    "Distance (km)",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
//fontWeight: FontWeight.bold,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
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
                                    "Action",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
//fontWeight: FontWeight.bold,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                )),
                          ),
                        ])),
                    Container(
                        height: (MediaQuery.of(context).size.height - 200),
                        child: _buildPaginatedListView()),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  _loadMore() async {
    print('LOAD MORE');
    print(tableCount);
    print('HEIGHT');
    print(MediaQuery.of(context).size.height.toString());
    List<ActivityListModel> listData = [];
    if (tableCount <= totalRecords) {
      listData = await getData();
    }
    setState(() {
      activityListData = [...activityListData, ...listData];
      tableCount = tableCount + 10;
      isLoading = false;
    });
  }

  Widget _buildPaginatedListView() {
    return Column(
      children: <Widget>[
        Expanded(
            child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              setState(() {
                isLoading = true;
              });
              _loadMore();
            }
          },
          child: ListView.builder(
            itemCount: activityListData.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return _cellwithData(activityListData[index], index);
            },
          ),
        )),
        Container(
          height: isLoading ? 50.0 : 0,
          color: Colors.grey,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  _selectedActivityId(
      activityId, activityDate, type, ActivityListModel selectedActivity) {
    print("selected activity id ${activityId}");
    String jsonFile = path + activityId.toString() + '.json';
    int tabIndex = (type == 'graph') ? 0 : 1;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                jsonFile: jsonFile,
                activityDate: activityDate,
                tabIndex: tabIndex,
                selectedActivityData: selectedActivity,
              )),
    );
  }

  Widget _cellwithData(ActivityListModel model, int index) {
    print('_cellwithData');

    String activityDate = DateFormat('yyyy-MM-dd')
        .format(
            new DateTime.fromMillisecondsSinceEpoch(model.actTimestamp * 1000))
        .toString();
    String distance = (model.totalDistance * 0.001).toStringAsFixed(2);
    String sport = model.sport.toLowerCase();
    IconData sportIcon = sport == 'cycling'
        ? MyFlutterApp.bicycle
        : sport == 'running' ? MyFlutterApp.directions_run : MyFlutterApp.alarm;

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
                  width: MediaQuery.of(context).size.width * 0.23,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(
                      color: Colors.grey[700],
                      width: 0.5,
                    ),
                  )),
                  child: Text(
                    activityDate,
                    style: const TextStyle(
                        color: Colors.black,
//fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
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
                    child: Icon(sportIcon),
                  ),
                ),
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border(
                    right: BorderSide(
                      color: Colors.grey[700],
                      width: 0.5,
                    ),
                  )),
                  child: Text(
                    distance,
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
                  width: MediaQuery.of(context).size.width * 0.23,
                  padding: const EdgeInsets.all(15.0),
                  decoration: new BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.transparent),
                      borderRadius: new BorderRadius.only()),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () => {
                            _selectedActivityId(
                                model.activityId, activityDate, 'graph', model)
                          },
                          child: Icon(
                            FontAwesomeIcons.chartLine,
                            size: 22,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text('    '),
                        InkWell(
                          onTap: () => {
                            _selectedActivityId(
                                model.activityId, activityDate, 'map', model)
                          },
                          child: Icon(
                            FontAwesomeIcons.map,
                            size: 22,
                            color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ]))),
    );
  }
}
