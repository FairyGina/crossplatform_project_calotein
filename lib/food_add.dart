import 'package:calotin/food_class.dart';
import 'package:calotin/food_db.dart';

import 'package:flutter/material.dart';

class foodAddPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _foodAddPage();
  }
}

class _foodAddPage extends State<foodAddPage> {
  foodDatabase? fooddb = foodDatabase();

  final foodName = TextEditingController();
  final foodSize = TextEditingController();
  final calorie = TextEditingController();
  final protein = TextEditingController();
  final fat = TextEditingController();
  final carbohydrate = TextEditingController();
  //입력받은 값들을 저장하기 위한 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음식 등록'),
        backgroundColor: Color(0xff69DFCB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '식품명',
                    ),
                    controller: foodName,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '1회제공량',
                    ),
                    controller: foodSize,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '에너지(㎉)',
                    ),
                    controller: calorie,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '단백질(g)',
                    ),
                    controller: protein,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '지방(g)',
                    ),
                    controller: fat,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '탄수화물(g)',
                    ),
                    controller: carbohydrate,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  width: 70,
                  height: 50,
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
                      "저장",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      Food food = Food(
                        food_name: foodName.text,
                        food_size: foodSize.text,
                        calorie: calorie.text,
                        protein: protein.text,
                        fat: fat.text,
                        carbohydrate: carbohydrate.text,
                      );
                      fooddb?.add(food);
                      Navigator.of(context).pop(food);
                    },  //입력받은 값들을 데이터베이스에 넣음
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}