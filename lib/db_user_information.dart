import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:calotin/class_user_information.dart';

class db_user_information {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return await initDB();
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), 'user_info.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    await _onCreate(_database!, 1); // 테이블 생성

    return _database;
  }

  // Future initDB() async {
  //   String path = join(await getDatabasesPath(), 'user_info.db');
  //
  //   return await openDatabase(
  //       path,
  //       version: 1,
  //       onCreate: _onCreate,
  //       onUpgrade: _onUpgrade
  //   );
  // }

  Future _onCreate(Database db, int version) async {
    String sql = '''
    CREATE TABLE IF NOT EXISTS user_info(
      user_no INTEGER PRIMARY KEY AUTOINCREMENT,
      year INT NOT NULL,
      month INT NOT NULL,
      day INT NOT NULL,
      gender TEXT NOT NULL,
      cm DOUBLE NOT NULL,
      kg DOUBLE NOT NULL,
      activity TEXT NOT NULL,
      goal TEXT
    )  
    ''';
    await db.execute(sql);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future add(user_information user) async {
    final db = await database;
    await db?.insert('user_info', {
      'year': user.year,
      'month': user.month,
      'day': user.day,

      'gender': user.gender,

      'cm': user.cm,
      'kg': user.kg,
      'activity': user.activity,

      'goal': user.goal,


    });
  } //리스트에서 누른 음식 추가하는 거(그날 먹은 음식)

//
// Future<List<user_information>> getEat() async {
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