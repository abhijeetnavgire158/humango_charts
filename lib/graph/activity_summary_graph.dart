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
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('Heart Rate', 154),
      new OrdinalSales('Speed', 5),
      new OrdinalSales('Power', 100),
      new OrdinalSales('Cadence', 75),
    ];

    final tableSalesData = [
      new OrdinalSales('Heart Rate', 134),
      new OrdinalSales('Speed', 7),
      new OrdinalSales('Power', 155),
      new OrdinalSales('Cadence', 98),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Max Count',
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff4d4084)),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Avg Count',
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xfff5ce3e)),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
