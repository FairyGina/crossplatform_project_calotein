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
  final formKey = GlobalKey<FormState>();
  foodDatabase? fooddb = foodDatabase();
  final foodName = TextEditingController();
  final foodSize = TextEditingController();
  final calorie = TextEditingController();
  final protein = TextEditingController();
  final fat = TextEditingController();
  final carbohydrate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음식 등록'),
      ),
      body: SingleChildScrollView(
        key: this.formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '식품명',
                  ),
                controller: foodName,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '1회제공량',
                ),
                controller: foodSize,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '에너지(㎉)',
                ),
                controller: calorie,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '단백질(g)',
                ),
                controller: protein,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '지방(g)',
                ),
                controller: fat,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '탄수화물(g)',
                ),
                controller: carbohydrate,
              ),
              TextButton(
                child: Text('저장'),
                style: ButtonStyle(

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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}