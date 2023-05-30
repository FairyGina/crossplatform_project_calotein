import 'package:flutter/material.dart';

import 'package:calotin/food_class.dart';
import 'package:calotin/eat_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(eatPage());
}

class eatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _eatPage(),
    );
  }
}

class _eatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _eatState();
  }
}

class _eatState extends State<_eatPage> {
  Future<List<Food>>? eatList;
  eatDatabase? eatdb = eatDatabase();

  @override
  void initState() {
    super.initState();
    eatList = eatdb?.getCurrentDayEat();  //eat_db 파일에 있는 함수로 데이터 저장
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('먹은 음식'),
      ),
      body:SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child:Column(
            children: <Widget>[
              FutureBuilder<List<Food>>(
                future: eatList,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return CircularProgressIndicator();
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                    case ConnectionState.active:
                      return CircularProgressIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        final List<Food> _datalist = snapshot.data!;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: _datalist.length,
                            itemBuilder: (context, index) {
                              final Food food = _datalist[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                          children: <Widget>[
                                            Container(
                                              // alignment: Alignment.topRight,
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                food.food_name ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "${food.calorie!.toString() ?? ''} Kcal",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Text("탄수화물: ${food.carbohydrate!.toString() ?? ''} g /"),
                                          ),
                                          Container(
                                            child: Text("단백질: ${food.protein!.toString() ?? ''} g /"),
                                          ),
                                          Container(
                                            child: Text("지방: ${food.fat!.toString() ?? ''} g"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return Text('No data');
                      }
                  }
                }, // future: foodList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}