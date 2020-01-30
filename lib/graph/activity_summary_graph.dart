/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ActivitySummaryBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  ActivitySummaryBarChart(this.seriesList, {this.animate});

  factory ActivitySummaryBarChart.withSampleData() {
    return new ActivitySummaryBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [new charts.SeriesLegend()],
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<activityRecords, String>> _createSampleData() {
    final maxData = [
      new activityRecords('Heart Rate', 154),
      new activityRecords('Speed', 5),
      new activityRecords('Power', 100),
      new activityRecords('Cadence', 75),
    ];

    final avgData = [
      new activityRecords('Heart Rate', 134),
      new activityRecords('Speed', 7),
      new activityRecords('Power', 155),
      new activityRecords('Cadence', 98),
    ];

    return [
      new charts.Series<activityRecords, String>(
        id: 'Max Count',
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff4d4084)),
        domainFn: (activityRecords actData, _) => actData.title,
        measureFn: (activityRecords actData, _) => actData.value,
        data: maxData,
      ),
      new charts.Series<activityRecords, String>(
        id: 'Avg Count',
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff5ce3e)),
        domainFn: (activityRecords actData, _) => actData.title,
        measureFn: (activityRecords actData, _) => actData.value,
        data: avgData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class activityRecords {
  final String title;
  final int value;

  activityRecords(this.title, this.value);
}
