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

  // Future<List<user_information>> getUserInfo() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>>? maps = await db?.query('user_info');
  //
  //   return maps!.map((map) {
  //     return user_information(
  //       year: map['year'].toString(),
  //       month: map['month'].toString(),
  //       day: map['day'].toString(),
  //       gender: map['gender'].toString(),
  //       cm: map['cm'].toString(),
  //       kg: map['kg'].toString(),
  //       activity: map['activity'].toString(),
  //       goal: map['goal'].toString(),
  //     );
  //   }).toList();
  // }

  Future<user_information?> getUserInfo() async {
    final db = await database;
    final List<Map<String, dynamic>>? maps = await db?.query(
      'user_info',
      orderBy: 'user_no DESC', // id 값 기준으로 내림차순 정렬
      limit: 1, // 결과를 1개로 제한
    );

    if (maps != null && maps.isNotEmpty) {
      return user_information.fromMap(maps.first);
    }

    return null; // 데이터가 없을 경우 null 반환
  }

}