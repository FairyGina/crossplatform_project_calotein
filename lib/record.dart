import 'package:flutter/material.dart';
import 'eat_db.dart';
import 'class_user_nutrient.dart';

class record extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dev Test',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _record(),
    );
  }
}

class _record extends StatefulWidget {

  @override
  recordState createState() => recordState();
}

class recordState extends State<_record> {
  int? day = 0;
  late DateTime now;
  eatDatabase? eatdb=eatDatabase();

  Future<List<user_nutrient>>? nutri_list;
  Future<List<user_nutrient>>? nutri_list2;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    print(now);
    setState(() {
      nutri_list=eatdb?.getTotalKcal(now);
      nutri_list2=eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 1,now.hour));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder<List<user_nutrient>>(
              future: nutri_list,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final List<user_nutrient> list = snapshot.data!;
                    user_nutrient nutri = list[0];
                    // String totalProtein = list.toStringAsFixed(0);
                    return Text(
                      '리스트: ${nutri?.eatKcal ?? ''} kcal\n${nutri?.eatProtein ??
                          ''} g\n${nutri?.eatCarbohydrate ?? ''} g\n${nutri?.eatFat ?? ''} g',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    );
                  }
                }
                return CircularProgressIndicator(); // 데이터베이스 연산이 완료될 때까지 로딩 표시
              },
            ),

            FutureBuilder<List<user_nutrient>>(
              future: nutri_list2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    final List<user_nutrient> list = snapshot.data!;
                    user_nutrient nutri = list[0];
                    // String totalProtein = list.toStringAsFixed(0);
                    return Text(
                      '리스트: ${nutri?.eatKcal ?? ''} kcal\n${nutri?.eatProtein ??
                          ''} g\n${nutri?.eatCarbohydrate ?? ''} g\n${nutri?.eatFat ?? ''} g',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    );
                  }
                }
                return CircularProgressIndicator(); // 데이터베이스 연산이 완료될 때까지 로딩 표시
              },
            ),
          ],
        ),

      ),

    );
  }
}