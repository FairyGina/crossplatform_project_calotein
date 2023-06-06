import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:calotin/class_user_nutrient.dart';
import 'main.dart';


class db_user_nutrient {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    return await initDB();
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), 'user_nutr.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    await _onCreate(_database!, 1); // 테이블 생성

    return _database;
  }


  Future _onCreate(Database db, int version) async {
    String sql = '''
    CREATE TABLE IF NOT EXISTS user_nutr(
      day_no INTEGER PRIMARY KEY AUTOINCREMENT,
      
      date TEXT DEFAULT (datetime('now', 'localtime')) NOT NULL,
      eatKcal DOUBLE NOT NULL,
      eatProtein DOUBLE NOT NULL,
      eatCarbohydrate DOUBLE NOT NULL,
      eatFat DOUBLE NOT NULL,
      
    )  
    ''';
    await db.execute(sql);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future add(user_nutrient nutr) async {
    final db = await database;

    await db?.insert('user_nutr', {
      'eatKcal': nutr.eatKcal,
      'eatProtein': nutr.eatProtein,
      'eatCarbohydrate': nutr.eatCarbohydrate,
      'eatFat': nutr.eatFat,

    });

    // 현재 날짜와 시간 가져오기
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentHour = now.hour;

    // 기준 시간인 3:00에 데이터를 추가하는 조건 확인
    if (currentHour >= 3) {
      // 현재 시간이 3 이후인 경우

      // 데이터를 추가할 날짜 계산
      DateTime nextDay = DateTime(now.year, now.month, currentDay + 1, 3, 0);

      // 다음 날짜의 3:00 이후에 데이터를 추가
      await Future.delayed(nextDay.difference(now)).then((_) async {
        await db?.insert('user_nutr', {
          'eatKcal': nutr.eatKcal,
          'eatProtein': nutr.eatProtein,
          'eatCarbohydrate': nutr.eatCarbohydrate,
          'eatFat': nutr.eatFat,
        });
      });
    }

    // 첫 번째 데이터 추가
    await db?.insert('user_nutr', {
      'eatKcal': nutr.eatKcal,
      'eatProtein': nutr.eatProtein,
      'eatCarbohydrate': nutr.eatCarbohydrate,
      'eatFat': nutr.eatFat,
    });
  }

}