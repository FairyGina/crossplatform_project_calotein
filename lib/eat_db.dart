import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:calotin/food_class.dart';
import 'package:calotin/class_user_nutrient.dart';

import 'main.dart';

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

  Future<List<user_nutrient>> getTotalKcal(DateTime date) async {
    final db = await database;
    DateTime currentDay;
    print("오늘날짜: ${date}");
    if (date.hour >= 3) {
      currentDay = DateTime(date.year, date.month, date.day);
    } else {
      currentDay = DateTime(date.year, date.month, date.day - 1);
    }


    final DateTime startTime = DateTime(currentDay.year, currentDay.month, currentDay.day, 3);
    final DateTime endTime = startTime.add(Duration(days: 1));


    // print("시작: ${startTime}");
    // print("끝: ${endTime}");
    List<Map<String, dynamic>> maps = await db!.rawQuery('SELECT SUM(calorie),SUM(protein),SUM(carbohydrate),SUM(fat) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);

      // if (result.isNotEmpty && result[0]['SUM(calorie),SUM(protein),SUM(carbohydrate),SUM(fat)'] != null) {
      //   totalKcal = result[0]['SUM(calorie)'] as double;
      // }
    print(maps);
    return maps.map<user_nutrient>((nutrient) {
      return user_nutrient(
        eatKcal: nutrient['SUM(calorie)'].toString(),
        eatProtein: nutrient['SUM(protein)'].toString(),
        eatCarbohydrate: nutrient['SUM(carbohydrate)'].toString(),
        eatFat: nutrient['SUM(fat)'].toString(),
      );
    }).toList();


  }












  Stream<double> getTotalKcalStream() async* {
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
    double totalProtein = 0;

    while (true) {
      List<Map<String, dynamic>> result = await db!.rawQuery('SELECT SUM(calorie) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);

      if (result.isNotEmpty && result[0]['SUM(calorie)'] != null) {
        totalProtein = result[0]['SUM(calorie)'] as double;
      }

      yield totalProtein;

      // 일정 시간(예: 1분) 대기 후에 다시 데이터를 업데이트하도록 설정할 수도 있습니다.
      await Future.delayed(Duration(seconds: 1));
    }
  }



  Stream<double> getTotalProteinStream() async* {
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
    double totalProtein = 0;

    while (true) {
      List<Map<String, dynamic>> result = await db!.rawQuery('SELECT SUM(protein) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);

      if (result.isNotEmpty && result[0]['SUM(protein)'] != null) {
        totalProtein = result[0]['SUM(protein)'] as double;
      }

      yield totalProtein;

      // 일정 시간(예: 1분) 대기 후에 다시 데이터를 업데이트하도록 설정할 수도 있습니다.
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Stream<double> getTotalCarbohydrateStream() async* {
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
    double totalProtein = 0;

    while (true) {
      List<Map<String, dynamic>> result = await db!.rawQuery('SELECT SUM(carbohydrate) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);

      if (result.isNotEmpty && result[0]['SUM(carbohydrate)'] != null) {
        totalProtein = result[0]['SUM(carbohydrate)'] as double;
      }

      yield totalProtein;

      // 일정 시간(예: 1분) 대기 후에 다시 데이터를 업데이트하도록 설정할 수도 있습니다.
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Stream<double> getTotalFatStream() async* {
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
    double totalProtein = 0;

    while (true) {
      List<Map<String, dynamic>> result = await db!.rawQuery('SELECT SUM(fat) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);

      if (result.isNotEmpty && result[0]['SUM(fat)'] != null) {
        totalProtein = result[0]['SUM(fat)'] as double;
      }

      yield totalProtein;

      // 일정 시간(예: 1분) 대기 후에 다시 데이터를 업데이트하도록 설정할 수도 있습니다.
      await Future.delayed(Duration(seconds: 1));
    }
  }

  // Future<double> getTotalProtein() async {
  //   final db = await database;
  //   final DateTime now = DateTime.now();  //여기서는 now만 써도 로컬 시간으로 잘 받아옴
  //   DateTime currentDay;
  //
  //   if (now.hour >= 3) {
  //     currentDay = DateTime(now.year, now.month, now.day);
  //   } else {
  //     currentDay = DateTime(now.year, now.month, now.day - 1);
  //   } //3시를 기준으로 현재 날짜를 정함
  //
  //   final DateTime startTime = DateTime(currentDay.year, currentDay.month, currentDay.day, 3);  //현재 날짜의 새벽 3시 받아오기
  //   final DateTime endTime = startTime.add(Duration(days: 1));  //다음날까지
  //   double totalProtein = 0;
  //
  //   List<Map<String, dynamic>> result = await db!.rawQuery('SELECT SUM(protein) FROM eat WHERE date >= ? AND date < ?', [startTime.toString(), endTime.toString()]);
  //
  //   if (result.isNotEmpty && result[0]['SUM(protein)'] != null) {
  //     totalProtein = result[0]['SUM(protein)'] as double;
  //   }
  //
  //   return totalProtein;
  // }

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