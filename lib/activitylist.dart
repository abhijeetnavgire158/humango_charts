import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:humango_chart/homepage.dart';
import 'package:humango_chart/model/activitylistmodel.dart';
import 'package:humango_chart/presentation/my_flutter_app_icons.dart';
import 'package:intl/intl.dart';

class ActivityListDataSource extends DataTableSource {
  final Function() onDataLoad;
  final Function(int, String, String) onSelectClick;

//const ActivityListDataSource({Key key, @required this.onSelectClick,@required this.onCancelClick}) : super(key: key);
  List<ActivityListModel> activityListData = [];

  Future<String> _loadAActivityListAsset() async {
    return await rootBundle.loadString('jsondata/activitylist.json');
  }

  ActivityListDataSource(this.onDataLoad, this.onSelectClick) {
    print('ActivityListDataSource constructor');
    _generateData();
  }

  _generateData() async {
    String data = await _loadAActivityListAsset();
    print('Table List 4');
    // print(data);
    final List activityList = json.decode(data);
    activityListData =
        activityList.map((val) => ActivityListModel.fromJson(val)).toList();
    this.onDataLoad();
  }

  void _sort<T>(Comparable<T> getField(ActivityListModel d), bool ascending) {
    print('_sort call');
    activityListData.sort((ActivityListModel a, ActivityListModel b) {
      if (!ascending) {
        final ActivityListModel c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  selectedActivityId(activityId, activityDate, type) {
    print("selected activity id ${activityId}");
    onSelectClick(activityId, activityDate, type);
  }

  @override
  DataRow getRow(int index) {
    print('getRow');
    assert(index >= 0);
    if (index >= activityListData.length) return null;
    final ActivityListModel activity = activityListData[index];
    var date =
        new DateTime.fromMillisecondsSinceEpoch(activity.actTimestamp * 1000);
    String activityDate = DateFormat('yyyy-MM-dd').format(date);
    String distance = (activity.totalDistance * 0.001).toStringAsFixed(2);
    String sport = activity.sport.toLowerCase();
    IconData sportIcon = sport == 'cycling'
        ? MyFlutterApp.bicycle
        : sport == 'running' ? MyFlutterApp.directions_run : MyFlutterApp.alarm;

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(
            Icon(
              FontAwesomeIcons.chartLine,
              size: 12,
              color: Colors.blueAccent,
            ), onTap: () {
          selectedActivityId(activity.activityId, activityDate, 'graph');
        }),
        DataCell(
            Icon(
              FontAwesomeIcons.map,
              size: 12,
              color: Colors.blueAccent,
            ), onTap: () {
          selectedActivityId(activity.activityId, activityDate, 'map');
        }),
        DataCell(Text(activityDate)),
        DataCell(Icon(sportIcon)),
        DataCell(Center(
          child: Text(distance),
        )),
      ],
    );
  }

  @override
  int get rowCount => activityListData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

class ActivityListTable extends StatefulWidget {
  @override
  _ActivityListTableState createState() => _ActivityListTableState();
}

class _ActivityListTableState extends State<ActivityListTable> {
  int _rowsPerPage = 5;
  int _sortColumnIndex;
  bool _sortAscending = true;
  bool isload = false;
  String path = 'jsondata/activity_records/';
  ActivityListDataSource _activityListDataSource;

  void _sort<T>(Comparable<T> getField(ActivityListModel d), int columnIndex,
      bool ascending) {
    _activityListDataSource._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  onSelectClick(int value, String activityDate, String type) {
    String jsonFile = path + value.toString() + '.json';
    int tabIndex = (type == 'graph') ? 0 : 1;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                jsonFile: jsonFile,
                activityDate: activityDate,
                tabIndex: tabIndex,
              )),
    );
  }

  onDataLoad() {
    setState(() {
      isload = true;
    });
  }

  _loadData() async {
    _activityListDataSource = ActivityListDataSource(onDataLoad, onSelectClick);
  }

  @override
  void initState() {
    print('activity list ');
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HUmango: Flutter List'),
      ),
      body: Scrollbar(
        child: isload == true
            ? ListView(
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  PaginatedDataTable(
                    header: Center(child: Text('Activity List')),
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged:
                        _rowsPerPage < PaginatedDataTable.defaultRowsPerPage
                            ? null
                            : (int value) {
                                setState(() {
                                  _rowsPerPage = value;
                                });
                              },
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      DataColumn(
                        label: Text('',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      DataColumn(
                        label: Text('Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        onSort: (int columnIndex, bool ascending) =>
                            _sort<String>(
                                (ActivityListModel d) =>
                                    d.activityId.toString(),
                                columnIndex,
                                ascending),
                      ),
                      DataColumn(
                        label: Text('Sport',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        tooltip: 'Sport Type',
                        onSort: (int columnIndex, bool ascending) =>
                            _sort<String>((ActivityListModel d) => d.sport,
                                columnIndex, ascending),
                      ),
                      DataColumn(
                        label: Text('Distance(km)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        numeric: true,
                        onSort: (int columnIndex, bool ascending) => _sort<num>(
                            (ActivityListModel d) => d.totalDistance,
                            columnIndex,
                            ascending),
                      ),
                    ],
                    source: _activityListDataSource,
                    columnSpacing: 20,
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
