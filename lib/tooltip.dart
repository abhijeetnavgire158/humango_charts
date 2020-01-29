import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'package:charts_flutter/src/text_style.dart' as chartsTextStyle;

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  String tooltipText;

  CustomCircleSymbolRenderer(String text) {
    print('CustomCircleSymbolRenderer');
    text = text != null ? text : '0';
    print(text);
    this.tooltipText = text;
    shouldRepaint(this);
  }

  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int> dashPattern,
      charts.Color fillColor,
      charts.Color strokeColor,
      double strokeWidthPx}) {
    print('PAINT CALL');
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: charts.Color.white,
        strokeColor: charts.Color.black,
        strokeWidthPx: 1);

    // Draw a bubble

    final num bubbleHight = 40;
    final num bubbleWidth = 120;
    final num bubbleRadius = bubbleHight / 2.0;
    final num bubbleBoundLeft = bounds.left;
    final num bubbleBoundTop = bounds.top - bubbleHight;

    canvas.drawRRect(
      Rectangle(bubbleBoundLeft, bubbleBoundTop, bubbleWidth, bubbleHight),
      fill: charts.Color.black,
      stroke: charts.Color.black,
      radius: bubbleRadius,
      roundTopLeft: true,
      roundBottomLeft: true,
      roundBottomRight: true,
      roundTopRight: true,
    );

    // Add text inside the bubble

    final textStyle = chartsTextStyle.TextStyle();
    textStyle.color = charts.Color.white;
    textStyle.fontSize = 12;

    final chartsTextElement.TextElement textElement =
        chartsTextElement.TextElement(this.tooltipText, style: textStyle);

    print("Tooltip-- " + this.tooltipText);

    final num textElementBoundsLeft = ((bounds.left +
            (bubbleWidth - textElement.measurement.horizontalSliceWidth) / 2))
        .round();
    final num textElementBoundsTop = (bounds.top - 30).round();

    canvas.drawText(textElement, textElementBoundsLeft, textElementBoundsTop);
  }
}
