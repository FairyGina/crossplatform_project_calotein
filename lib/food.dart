import 'dart:math';

import 'package:calotin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:calotin/eat_list.dart';
import 'package:calotin/food_add.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/food_class.dart';
import 'package:calotin/eat_db.dart';

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
  final textController = TextEditingController();
  foodDatabase? fooddb = foodDatabase();
  eatDatabase? eatdb = eatDatabase();
  late Future<List<Food>> datalist;

  @override
  void initState() {
    super.initState();
    datalist = Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        backgroundColor: Color(0xff69DFCB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MyHomePage(title: 'calotein', titleColor: Color(0xff69DFCB))),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Column(
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
                        child: Text(
                          '음식 등록',
                          style: TextStyle(
                            color: Color(0xff69DFCB),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => foodAddPage()),
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
                            context,
                            MaterialPageRoute(builder: (_) => eatPage()),
                          );
                        },
                      ),
                    ),
                  ]
              ),
              Expanded(
                child: FutureBuilder<List<Food>>(
                  future: datalist,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      final List<Food> _datalist = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _datalist.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _datalist.length) {
                            return SizedBox(
                              height: MediaQuery.of(context).padding.bottom,
                            );
                          } else {
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
                                                    "${food.calorie!.toString()} Kcal",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(bottom: 2.0, right: 2.0),
                                                child: Text(
                                                  "탄수화물: ${food.carbohydrate!.toString()} g /",
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 2.0, right: 2.0),
                                                child: Text(
                                                  "단백질: ${food.protein!.toString()} g /",
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 2.0),
                                                child: Text(
                                                  "지방: ${food.fat!.toString()} g",
                                                ),
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
                                          backgroundColor: Color(0xff69DFCB),
                                          side: BorderSide(
                                            color: Color(0xff69DFCB),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      return Text('No data');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



