import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:async';
import 'dart:math';






class BarChartExample extends StatefulWidget {
  @override
  _BarChartExampleState createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  List<double> data = [10, 20, 30, 40, 50];

  get sideTitles => null; // 막대 그래프에 표시할 데이터

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 300, // 그래프의 높이 조정
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: getData(),
          borderData: FlBorderData(
            show: true, // 바깥 그래프 테두리 제거
            border: Border(
              left: BorderSide(color: Colors.black, width: 2), // 왼쪽 테두리 스타일 지정
              bottom: BorderSide(color: Colors.black, width: 2), // 하단 테두리 스타일 지정
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
          ),
          gridData: FlGridData(
            show: false, // 점선 제거
          ),
        ),
      ),
    );
  }


  List<BarChartGroupData> getData() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < data.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              fromY: 0,
              color: Colors.blue,
              toY: data[i], // 막대 색상 지정
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Bar Chart Example'),
      ),
      body: Center(
        child: BarChartExample(),
            // Container(
            //   child: Transform.rotate(
            //       angle: 90 * 3.1415926535 / 180, // 90도를 라디안 값으로 변환
            //       child: BarChartExample(),
            //       ),
            // )
      ),
    ),
  ));
}
