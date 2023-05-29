import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:calotin/food_class.dart';

class eatDatabase {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return await initDB();
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), 'eat.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  Future _onCreate(Database db, int version) async {
    String sql = '''
    CREATE TABLE IF NOT EXISTS eat(
      food_no INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT DEFAULT (datetime('now', 'localtime')) NOT NULL,
      food_name TEXT NOT NULL,
      calorie DOUBLE NOT NULL,
      protein DOUBLE NOT NULL,
      fat DOUBLE NOT NULL,
      carbohydrate DOUBLE NOT NULL,
      food_size DOUBLE NOT NULL
    )  
    ''';
    db.execute(sql);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future add(Food food) async {
    final db = await database;
    await db?.insert('eat', {
      'food_name': food.food_name,
      'food_size': food.food_size,
      'calorie': food.calorie,
      'protein': food.protein,
      'fat': food.fat,
      'carbohydrate': food.carbohydrate,
    });
  }

  Future<List<Food>> getCurrentDayEat() async {
    final db = await database;
    final DateTime now = DateTime.now();
    DateTime currentDay;

    if (now.hour >= 3) {
      currentDay = DateTime(now.year, now.month, now.day);
    } else {
      currentDay = DateTime(now.year, now.month, now.day - 1);
    }

    final DateTime startTime = DateTime(currentDay.year, currentDay.month, currentDay.day, 3);
    final DateTime endTime = startTime.add(Duration(days: 1));

    final List<Map<String, dynamic>>? maps = await db?.query(
      'eat',
      where: 'date >= ? AND date < ?',
      whereArgs: [startTime.toIso8601String(), endTime.toIso8601String()],
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
  }

  Future<List<Food>> getEat() async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query('eat');

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
  }
}
