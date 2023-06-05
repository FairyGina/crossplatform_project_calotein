import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

import 'package:calotin/food_class.dart';



class foodDatabase {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return await initDB();
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), 'food.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    String sql = '''
    CREATE TABLE IF NOT EXISTS food(
      food_no INTEGER PRIMARY KEY AUTOINCREMENT,
      food_name TEXT NOT NULL,
      food_size DOUBLE NOT NULL,
      calorie DOUBLE NOT NULL,
      protein DOUBLE NOT NULL,
      fat DOUBLE NOT NULL,
      carbohydrate DOUBLE NOT NULL
    )  
    ''';
    db.execute(sql);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future createFood() async {
    final jsondata = await rootBundle.loadString('asset/food_info.json');
    List<dynamic> list = json.decode(jsondata);
    for (dynamic data in list) {
      Food food = Food.fromJson(data);
      await add(food);
    } //json 파일에 있는 거 받아서 데이터베이스에 넣는 것
  }

  Future add(Food food) async {
    final db = await database;
    await db?.insert('food', {
      'food_name': food.food_name,
      'food_size': food.food_size,
      'calorie': food.calorie,
      'protein': food.protein,
      'fat': food.fat,
      'carbohydrate': food.carbohydrate,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  } //데이터베이스에 저장하는 것

  Future<List<Food>> getFood() async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query('food');
    return maps!.map((food) {
      return Food(
        food_name: food['food_name'].toString(),
        food_size: food['food_size'].toString(),
        calorie: food['calorie'].toString(),
        protein: food['protein'].toString(),
        fat: food['fat'].toString(),
        carbohydrate: food['carbohydrate'].toString(),
      );
    }).toList();
  } //데이터베이스에서 데이터 가져오는 것

  Future searchFood(String str) async {
    final db = await database;
    List<Map<String, dynamic>>? maps = await db?.query(
      'food',
      where: 'food_name LIKE ?',
      whereArgs: ['%$str%'],
    );
    return maps!.map((food) {
      return Food(
        food_name: food['food_name'].toString(),
        food_size: food['food_size'].toString(),
        calorie: food['calorie'].toString(),
        protein: food['protein'].toString(),
        fat: food['fat'].toString(),
        carbohydrate: food['carbohydrate'].toString(),
      );
    }).toList();
  } //받아온 문자열을 포함한 데이터만 가져오는 것
}

