import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class foodDatebase {
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
      date DATETIME default DATE_FORMAT(now(), '%Y-%m-%d %H),
      food_name VARCHAR(20) NOT NULL,
      calorie INTEGER NOT NULL,
      standard INTEGER NOT NULL,
      protein INTEGER NOT NULL,
      fat INTEGER NOT NULL,
      carbohydrate INTEGER NOT NULL,
      food_size INTEGER NOT NULL,
      company_name VARCHAR(10)
    )  
    ''';
    db.execute(sql);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future add(item) async {
    final db = await initDB();

  }

}

class food {
  String? date;
  String? food_name;
  String? calorie;
  String? standard;
  String? protein;
  String? fat;
  String? carbohydrate;
  String? food_size;
  String? company_name;

  food({
    this.date,
    this.food_name,
    this.calorie,
    this.standard,
    this.protein,
    this.fat,
    this.carbohydrate,
    this.food_size,
    this.company_name,
  });

  Map<String, dynamic> toMap() => {
    'date': this.date,
    'food_name': this.food_name,
    'calorie': this.calorie,
    'standard': this.standard,
    'protein': this.protein,
    'fat': this.fat,
    'carbohydrate': this.carbohydrate,
    'food_size': this.food_size,
    'company_name': this.company_name
  };
}