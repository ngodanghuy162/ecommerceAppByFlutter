import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartGraph extends StatefulWidget {
  const BarChartGraph({super.key});

  final Color waiting = Colors.black;
  final Color inShipping = Colors.blue;
  final Color success = Colors.green;

  @override
  State<StatefulWidget> createState() => BarChartGraphState();
}

class BarChartGraphState extends State<BarChartGraph> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Week'; // Don vi Thu
        break;
      case 1:
        text = 'Month'; // Don vi la Ngay
        break;
      case 2:
        text = 'Year'; // Don vi la Thang
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 8,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final barsWidth = (8.0 * constraints.maxWidth) / 400;
          final barsSpace = (constraints.maxWidth - (barsWidth * 7)) / 8;

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              barTouchData: BarTouchData(
                enabled: true,
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // reservedSize: 0,
                    getTitlesWidget: bottomTitles,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // reservedSize: 20,
                    getTitlesWidget: leftTitles,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: const Color.fromARGB(137, 3, 3, 3).withOpacity(0.3),
                  strokeWidth: 0.5,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: getData(barsWidth, barsSpace),
            ),
          );
        },
      ),
    );
  }

  List<List<double>> dataOfMonth = [
    [3, 5, 7],
    [1, 4, 5],
    [5, 8, 9],
    [10, 8, 7],
    [6, 5, 7],
    [4, 3, 6],
    [3, 5, 7],
  ];

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      // --- Month

      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          for (int i = 0; i < dataOfMonth.length; i++)
            BarChartRodData(
              toY: dataOfMonth[i][0] + dataOfMonth[i][1] + dataOfMonth[i][2],
              rodStackItems: [
                BarChartRodStackItem(0, dataOfMonth[i][0], widget.waiting),
                BarChartRodStackItem(dataOfMonth[i][0],
                    dataOfMonth[i][0] + dataOfMonth[i][1], widget.inShipping),
                BarChartRodStackItem(
                    dataOfMonth[i][0] + dataOfMonth[i][1],
                    dataOfMonth[i][0] + dataOfMonth[i][1] + dataOfMonth[i][2],
                    widget.success),
              ],
              borderRadius: BorderRadius.zero,
              width: barsWidth,
            ),
        ],
      ),
    ];
  }
}
