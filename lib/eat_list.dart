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
        backgroundColor: Color(0xff69DFCB),
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
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
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
                                                    padding: EdgeInsets.only(bottom: 2.0, right: 2.0),
                                                    child: Text("탄수화물: ${food.carbohydrate!.toString() ?? ''} g /"),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 2.0, right: 2.0),
                                                    child: Text("단백질: ${food.protein!.toString() ?? ''} g /"),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 2.0),
                                                    child: Text("지방: ${food.fat!.toString() ?? ''} g"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
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