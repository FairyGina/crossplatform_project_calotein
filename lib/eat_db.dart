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
  } //이거 로컬 시간 받아오는 거 'localtime' 써서 해결(없으면 표준 국제 시간으로 받아옴)

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
  } //리스트에서 누른 음식 추가하는 거(그날 먹은 음식)

  Future<List<Food>> getCurrentDayEat() async {
    final db = await database;
    final DateTime now = DateTime.now();  //여기서는 now만 써도 로컬 시간으로 잘 받아옴
    DateTime currentDay;

    if (now.hour >= 3) {
      currentDay = DateTime(now.year, now.month, now.day);
    } else {
      currentDay = DateTime(now.year, now.month, now.day - 1);
    } //3시를 기준으로 현재 날짜를 정함

    final DateTime startTime = DateTime(currentDay.year, currentDay.month, currentDay.day, 3);  //현재 날짜의 새벽 3시 받아오기
    final DateTime endTime = startTime.add(Duration(days: 1));  //다음날까지

    final List<Map<String, dynamic>>? maps = await db?.query(
      'eat',
      where: 'date >= ? AND date < ?',
      whereArgs: [startTime.toString(), endTime.toString()],  //날짜를 문자열로 저장하니까 쿼리에 넣을 때도 문자열로 바꿔서 넣기
    );  //하루에 해당하는 데이터만 받아오기

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
  } //현재 날짜의 데이터만 받아오는 거

  // Future<List<Food>> getEat() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>>? maps = await db?.query('eat');
  //
  //   return maps!.map((food) {
  //     return Food(
  //       food_name: food['food_name'].toString(),
  //       food_size: food['food_size'].toString(),
  //       calorie: food['calorie'].toString(),
  //       protein: food['protein'].toString(),
  //       fat: food['fat'].toString(),
  //       carbohydrate: food['carbohydrate'].toString(),
  //     );
  //   }).toList();
  // } //데이터베이스에 있는 데이터 모두 받아오기 필요없으면 지우기
}
