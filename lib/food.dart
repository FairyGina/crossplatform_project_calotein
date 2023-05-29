import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

import 'package:calotin/eat_list.dart';
import 'package:calotin/food_add.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/food_class.dart';
import 'package:calotin/eat_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // String dbpath = join(await getDatabasesPath(), 'food.db');
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
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
       useMaterial3: true,
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
  final textController = TextEditingController();
  foodDatabase? fooddb = foodDatabase();
  eatDatabase eatdb = eatDatabase();
  late Future<List<Food>> datalist = Future.value([]);

  @override
  void initState() {
    super.initState();
    fooddb?.createFood().then((value) {
      setState(() {
        datalist = fooddb!.getFood();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
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
                          color: Colors.black12,
                          onPressed: () async {
                            List<Food> searchResuts = await fooddb!.searchFood(textController.text);
                            setState(() {
                              datalist = Future.value(searchResuts);
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
                            child: Text('음식 등록'),
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
                            child: Text('먹은 음식'),
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
                      child:Column(
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
                                                        SizedBox(
                                                          width: 50,
                                                          height: 40,
                                                          child: TextButton(
                                                            // style: TextButton.styleFrom(
                                                            //   // padding: EdgeInsets.all(1.0),
                                                            //     backgroundColor: Color(0xff69DFCB),
                                                            //     side: BorderSide(
                                                            //       color: Color(0xff69DFCB),
                                                            //     ),
                                                            //     shape: RoundedRectangleBorder(
                                                            //       borderRadius: BorderRadius.circular(10),
                                                            //     )
                                                            // ),
                                                            child: Text(
                                                              "추가",
                                                              style: TextStyle(color: Color(0xff69DFCB),),
                                                            ),
                                                            onPressed: () {
                                                              eatdb.add(food);
                                                            },
                                                          ),
                                                        )
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
                              return CircularProgressIndicator();
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


