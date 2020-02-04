import 'dart:convert';

import 'package:humango_chart/activity_summary.dart';
import 'package:humango_chart/activitydata.dart';
import 'package:humango_chart/graph/activity_summary_graph.dart';
import 'package:humango_chart/graph/chart.dart';
import 'package:humango_chart/model/activitylistmodel.dart';
import 'package:humango_chart/place_polygon.dart';
import 'package:humango_chart/tooltip.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  final String jsonFile;
  final String activityDate;
  final ActivityListModel selectedActivityData;
  final int tabIndex;

  HomePage(
      {Key key,
      this.child,
      @required this.jsonFile,
      @required this.activityDate,
      @required this.tabIndex,
      @required this.selectedActivityData})
      : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  String textSelected;
  String modelSelected;
  List<charts.Series<Activitydata, double>> _seriesLineData;
  List<Activitydata> activityListData;
  bool _isTempratureSelected = true;
  bool _isPaceSelected = false;
  String _leftYaxisText = 'Heart-Rate';
  String _rightYaxisText = 'Temperature|Speed|';
  String chartTypeDropdownValue = 'Metric Graph';

  bool isload = false;

  getPace(double speed) {
    double speedMPh = speed * 2.23694;
    return (1 / speedMPh) * 60;
  }

/**
 * remove temperature label from right y-axis
 */
  removeTemperature() {
    _seriesLineData.removeWhere((item) => item.id == 'Temperature');
    _rightYaxisText = _rightYaxisText.replaceFirst('Temperature|', '');
  }

/**
 * add temperature metric on chart
 */
  addTemperature() {
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Temperature',
        data: activityListData,
        domainFn: (Activitydata activity, _) =>
            double.parse(activity.elapsedTime),
        measureFn: (Activitydata activity, _) => activity.temperature != null
            ? double.parse(activity.temperature)
            : null,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    );
    _rightYaxisText = _rightYaxisText.replaceFirst('Temperature|', '');
    _rightYaxisText = _rightYaxisText + '' + 'Temperature|';
  }

  /**
   * Remove lable from right y-axis
   */
  removePace() {
    _seriesLineData.removeWhere((item) => item.id == 'pace(min/miles)');
    _rightYaxisText = _rightYaxisText.replaceFirst('Pace|', '');
  }

  /**
   * Add Pace metric
   */
  addPace() {
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.Color.fromHex(code: '#2F4F4F'),
        id: 'pace(min/miles)',
        data: activityListData,
        domainFn: (Activitydata activity, _) =>
            double.parse(activity.elapsedTime),
        measureFn: (Activitydata activity, _) {
          if (activity.speed != null) {
            double actSpeed = double.parse(activity.speed);
            double speedMPH = actSpeed * 2.23694;
            double pace = (1 / speedMPH) * 60;

            // return activity.speed != "0.0" ? pace : 0.0;
            return actSpeed;
          }

          return null;
        },
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    );
    _rightYaxisText = _rightYaxisText.replaceFirst('Pace|', '');
    _rightYaxisText = _rightYaxisText + ' ' + 'Pace|';
  }

  _generateData({String jsonFile = "jsondata/data2.json"}) async {
    print('generateData ss');
    String data = await DefaultAssetBundle.of(context).loadString(jsonFile);
    // final activities = jsonDecode(data);
    final List activityList = json.decode(data);
    activityListData =
        activityList.map((val) => Activitydata.fromJson(val)).toList();

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Heart Rate',
        data: activityListData,
        domainFn: (Activitydata activity, _) =>
            double.parse(activity.elapsedTime),
        measureFn: (Activitydata activity, _) =>
            activity.hearRate != null ? double.parse(activity.hearRate) : null,
      ),
    );

    //add temperature metric to line chart
    addTemperature();

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.Color.fromHex(code: '#5BD5EE'),
        id: 'Speed(mph)',
        data: activityListData,
        domainFn: (Activitydata activity, _) =>
            double.parse(activity.elapsedTime),
        measureFn: (Activitydata activity, _) => activity.speed != null
            ? double.parse(activity.speed) * 2.23694
            : null,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    );

    setState(() {
      isload = true;
    });
  }

  /**
   * Generate Tooltip card
   */
  Widget _tooltipCard(String modelSelected, String textSelected) {
    return Card(
      child: new Column(children: <Widget>[
        new ListTile(
          leading: new Icon(
            Icons.adjust,
            color: Colors.blue,
            size: 20.0,
          ),
          title: new Text(
            modelSelected != null ? "Point: " + modelSelected : "Point:",
            style: new TextStyle(fontWeight: FontWeight.w400),
          ),
          subtitle: new Text(textSelected != null ? textSelected : '',
              style: new TextStyle(fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }

  Widget _buildChartTypeDropdown(BuildContext context) {
    return DropdownButton<String>(
      value: chartTypeDropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          chartTypeDropdownValue = newValue;
        });
      },
      items: <String>['Metric Graph', 'Bar Graph', 'Line Graph']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    print('InitState 2');
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Activitydata, double>>();
    _generateData(jsonFile: this.widget.jsonFile);
    print('selected activity data');
    print(this.widget.selectedActivityData);
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD CALL 2');
    print(chartTypeDropdownValue);
    bool isPotrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    double titleFontSize = isPotrait ? 24 : 16;
    double appBarHeight = isPotrait ? 100 : 70;

    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        initialIndex: this.widget.tabIndex,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(appBarHeight),
              child: AppBar(
                backgroundColor: Color(0xff1976d2),
                bottom: TabBar(
                  indicatorColor: Color(0xff9962D0),
                  tabs: [
                    Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                    Tab(
                      icon: Icon(FontAwesomeIcons.map),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.list),
                    ),
                    Tab(
                      icon: Icon(FontAwesomeIcons.alignRight),
                    )
                  ],
                ),
                title: Text('HUmango : Flutter Charts'),
              )),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        _buildChartTypeDropdown(context),
                        Text(
                          'Athlete charts ${this.widget.activityDate}',
                          style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: (isload == true &&
                                  chartTypeDropdownValue == 'Metric Graph')
                              ? charts.LineChart(
                                  _seriesLineData,
                                  animate: true,
                                  primaryMeasureAxis:
                                      new charts.NumericAxisSpec(
                                          tickProviderSpec: new charts
                                                  .BasicNumericTickProviderSpec(
                                              desiredTickCount: 3)),
                                  secondaryMeasureAxis:
                                      new charts.NumericAxisSpec(
                                          tickProviderSpec: new charts
                                                  .BasicNumericTickProviderSpec(
                                              desiredTickCount: 3)),
                                  animationDuration: Duration(seconds: 2),
                                  behaviors: [
                                    new charts.SeriesLegend(
                                      position: charts.BehaviorPosition.top,
                                      horizontalFirst: false,
                                      desiredMaxRows: isPotrait ? 2 : 1,
                                      // This defines the padding around each legend entry.
                                      cellPadding: new EdgeInsets.only(
                                          right: 2.0, bottom: 4.0, top: 2.0),
                                      measureFormatter: (num value) {
                                        return value == null ? '-' : '${value}';
                                      },
                                    ),
                                    new charts.PanAndZoomBehavior(),
                                    // new charts.InitialSelection(
                                    //     selectedDataConfig: [
                                    //       new charts.SeriesDatumConfig<double>(
                                    //           'Temperature', 0)
                                    //     ]),
                                    new charts.LinePointHighlighter(
                                        symbolRenderer:
                                            CustomCircleSymbolRenderer(
                                                textSelected)),
                                    new charts.ChartTitle('Seconds',
                                        behaviorPosition:
                                            charts.BehaviorPosition.bottom,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea),
                                    new charts.ChartTitle(_leftYaxisText,
                                        behaviorPosition:
                                            charts.BehaviorPosition.start,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea,
                                        titleStyleSpec: charts.TextStyleSpec(
                                            fontSize: 11,
                                            color: charts
                                                .StyleFactory.style.tickColor)),
                                    new charts.ChartTitle(_rightYaxisText,
                                        behaviorPosition:
                                            charts.BehaviorPosition.end,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea,
                                        titleStyleSpec: charts.TextStyleSpec(
                                            fontSize: 11,
                                            color: charts
                                                .StyleFactory.style.tickColor))
                                  ],
                                  selectionModels: [
                                    charts.SelectionModelConfig(changedListener:
                                        (charts.SelectionModel model) {
                                      if (model.hasDatumSelection) {
                                        textSelected = model.selectedSeries[0]
                                            .measureFn(
                                                model.selectedDatum[0].index)
                                            .toString();

                                        setState(() {
                                          //Selected Point
                                          textSelected = model.selectedSeries[0]
                                              .measureFn(
                                                  model.selectedDatum[0].index)
                                              .toString();

                                          //Selected Model or series
                                          modelSelected = model
                                              .selectedSeries[0].id
                                              .toString();
                                        });
                                        print('selectionModels --------------');
                                        print(model.selectedSeries[0].id
                                            .toString());
                                      }
                                    })
                                  ],
                                )
                              : (isload == true &&
                                      chartTypeDropdownValue == 'Line Graph')
                                  ? Chart() //Line Chart
                                  : (isload == true &&
                                          chartTypeDropdownValue == 'Bar Graph')
                                      ? ActivitySummaryBarChart
                                          .withSampleData() //Bar Chart
                                      : Container(),
                        ),
                        isPotrait && chartTypeDropdownValue == 'Metric Graph'
                            ? CheckboxListTile(
                                title: Text('Temprature'),
                                value: _isTempratureSelected,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _isTempratureSelected = newValue;
                                    if (_isTempratureSelected) {
                                      addTemperature();
                                    } else {
                                      removeTemperature();
                                    }
                                  });
                                },
                              )
                            : Container(),
                        isPotrait && chartTypeDropdownValue == 'Metric Graph'
                            ? CheckboxListTile(
                                title: Text('Pace'),
                                value: _isPaceSelected,
                                onChanged: (bool newValue) {
                                  setState(() {
                                    _isPaceSelected = newValue;
                                    if (_isPaceSelected) {
                                      addPace();
                                    } else {
                                      removePace();
                                    }
                                  });
                                },
                              )
                            : Container(),
                        modelSelected != null
                            ? _tooltipCard(modelSelected, textSelected)
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: MapPage(
                          jsonFile: this.widget.jsonFile,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: ActivitySummary(
                                selectedActivityData:
                                    this.widget.selectedActivityData)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: ActivitySummaryBarChart.withSampleData()),
                      ],
                    ),
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
