import 'package:flutter/material.dart';
import 'eat_db.dart';
import 'class_user_nutrient.dart';
import 'package:fl_chart/fl_chart.dart';

class Record extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dev Test',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _Record(),
    );
  }
}

class _Record extends StatefulWidget {
  @override
  RecordState createState() => RecordState();
}

class RecordState extends State<_Record> {
  int? day = 0;
  late DateTime now;
  eatDatabase? eatdb = eatDatabase();

  Future<List<user_nutrient>>? nutriList;
  Future<List<user_nutrient>>? nutriList2;

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            fromY: 0,
            color: Color(0xff69DFCB),
            toY: 50,
            width: 20,
          ),
        ],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    print(now);
    setState(() {
      nutriList = eatdb?.getTotalKcal(now);
      nutriList2 = eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 1, now.hour));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Dev Test'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Transform.rotate(
                  angle: 90 * 3.1415926535 / 180,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      height: 100,
                      width: 30,
                      padding: EdgeInsets.all(8),
                      child: BarChart(
                        BarChartData(
                          maxY: 100,
                          barGroups: getData(),
                          backgroundColor: Colors.white,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          titlesData: FlTitlesData(
                            show: false,
                          ),
                          gridData: FlGridData(
                            show: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<user_nutrient>>(
                future: nutriList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('오류: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final List<user_nutrient> list = snapshot.data!;
                      user_nutrient nutri = list[0];
                      return Text(
                        '리스트: ${nutri?.eatKcal ?? ''} kcal\n${nutri?.eatProtein ?? ''} g\n${nutri?.eatCarbohydrate ?? ''} g\n${nutri?.eatFat ?? ''} g',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<user_nutrient>>(
                future: nutriList2,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('오류: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final List<user_nutrient> list = snapshot.data!;
                      user_nutrient nutri = list[0];
                      return Text(
                        '리스트: ${nutri?.eatKcal ?? ''} kcal\n${nutri?.eatProtein ?? ''} g\n${nutri?.eatCarbohydrate ?? ''} g\n${nutri?.eatFat ?? ''} g',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
