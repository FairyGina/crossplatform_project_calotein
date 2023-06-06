import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(BarChartExample());
}

class BarChartExample extends StatefulWidget {
  @override
  _BarChartExampleState createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(

        x: 0,
        barRods: [
          BarChartRodData(
            fromY: 0,
            color: Color(0xff69DFCB),
            toY: 50, // 막대 색상 지정
            width: 20, // 막대 선 두께
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bar Chart Example'),
        ),
        body: Center(
          child: Transform.rotate(
            angle: 90 * 3.1415926535 / 180, // 90도를 라디안 값으로 변환하여 -90도로 회전
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: 100, // 그래프의 높이 조정
                width: 30,
                padding: EdgeInsets.all(8),
                child: BarChart(
                  BarChartData(
                    maxY: 100,
                    barGroups: getData(),
                    backgroundColor: Colors.white, // 배경색 지정
                    borderData: FlBorderData(
                      show: false, // 바깥 그래프 테두리 제거
                    ),
                    titlesData: FlTitlesData(
                      show: false,
                    ),
                    gridData: FlGridData(
                      show: false, // 점선 제거
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
