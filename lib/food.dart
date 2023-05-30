import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:calotin/eat_list.dart';
import 'package:calotin/food_add.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/food_class.dart';
import 'package:calotin/eat_db.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // String dbpath = join(await getDatabasesPath(), 'food.db');
  // if(await databaseExists(dbpath)) {
  //   await deleteDatabase(dbpath);
  // } //db 삭제(처음부터 존재하면)

  // String dbpath = join(await getDatabasesPath(), 'eat.db');
  // if(await databaseExists(dbpath)) {
  //   await deleteDatabase(dbpath);
  // } //db 삭제(처음부터 존재하면)

  runApp(foodPage());
}

class foodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: 'Flutter Demo',
     theme: ThemeData(

     ),
     home: _foodPage()
   );
  }
}

class _foodPage extends StatefulWidget {
  @override
  foodPageState createState() => foodPageState();
}

class foodPageState extends State<_foodPage> {
  final textController = TextEditingController(); //검색어 받아올 변수
  foodDatabase? fooddb = foodDatabase();
  eatDatabase? eatdb = eatDatabase();
  late Future<List<Food>> datalist = Future.value([]);

  @override
  void initState() {
    super.initState();

    eatdb?.initDB();
    fooddb?.createFood().then((value) {
      setState(() {
        datalist = fooddb!.getFood(); //화면에 리스트 띄워두는 건데 필요없으면 나중에 지울 것
      });
    }); //데이터베이스 생성하는 거 나중에 다 메인으로 옮길 것
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        backgroundColor: Color(0xff69DFCB),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              hintText: '검색어를 입력하세요',
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        IconButton(
                          icon: Icon(Icons.search),
                          color: Colors.black54,
                          onPressed: () async {
                            List<Food> searchResuts = await fooddb!.searchFood(textController.text);  //위에서 받은 문자열이 포함된 데이터를 food_db에 있는 함수로 받아옴
                            setState(() {
                              datalist = Future.value(searchResuts);  //검색어를 포함한 데이터만 화면에 띄움
                            });
                          },
                        ),
                      ]
                  ),
                  Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: TextButton(
                            child: Text(
                              '음식 등록',
                              style: TextStyle(
                                color: Color(0xff69DFCB),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => foodAddPage())
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 50, right: 50),
                          child: TextButton(
                            child: Text(
                              '먹은 음식',
                              style: TextStyle(
                                color: Color(0xff69DFCB),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => eatPage())
                              );
                            },
                          ),
                        ),
                      ]
                  ),
                  SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          FutureBuilder<List<Food>>(
                            future: datalist,
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
                                                  Container(
                                                    padding: EdgeInsets.all(4.0),
                                                    width: 50,
                                                    height: 40,
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        // padding: EdgeInsets.all(1.0),
                                                          backgroundColor: Color(0xff69DFCB),
                                                          side: BorderSide(
                                                            color: Color(0xff69DFCB),
                                                          ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5),
                                                          )
                                                      ),
                                                      child: Text(
                                                        "추가",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        eatdb?.add(food);
                                                      },
                                                    ),
                                                  )
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
                ],
              ),
            ],
          )
        ),
      ),
    );
   }

}


