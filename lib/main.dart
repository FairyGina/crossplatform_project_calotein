import 'package:calotin/class_user_information.dart';
import 'package:calotin/user_information.dart';
import 'package:flutter/material.dart';
import 'package:calotin/food.dart';
import 'package:calotin/db_user_information.dart';
import 'package:calotin/class_user_information.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/eat_db.dart';
import 'package:calotin/userinfo_modify.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main 화면',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.white, // 상단바의 색상을 하얀색으로 설정
        ),
        scaffoldBackgroundColor: Color(0xff69DFCB), // 배경색을 초록색으로 설정
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'calrotain',titleColor: Color(0xff69DFCB)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.titleColor});
  final String title;
  final Color titleColor;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  db_user_information db_user_info = db_user_information();
  foodDatabase? fooddb = foodDatabase();
  eatDatabase? eatdb = eatDatabase();
  user_information? info;
  int year = 0;
  String activityDropdownValue = '0'; // 수정된 부분

  // 데이터 베이스 가져오기
  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    eatdb?.initDB();
    fooddb?.createFood();
    db_user_info.initDB().then((value) {
      db_user_info.getUserInfo().then((fetchedInfo) {
        setState(() {
          info = fetchedInfo;
          if (info != null) {
            activityDropdownValue = info!.getActivity() ?? '0';
          }
        });
      });
    });
  }


  //목표 표시
  String _getGoalText() {
    if (info != null) {
      String goal = info!.getGoal() ?? '0';
      return '   목표: $goal   ';
    } else {
      return '   목표 없음   ';
    }
  }




  //필요 영양성분 표시
  String _needKcalText() {
    if (info != null) {
      String kcal = info!.needActivityKcal() ?? '0';
      return '필요 칼로리: $kcal';
    } else {
      return '필요 칼로리: 0';
    }
  }

  String _needProteinText() {
    if (info != null) {
      String protein = info!.needActivityProtein() ?? '0';
      return '필요 단백질: $protein';
    } else {
      return '필요 단백질: 0';
    }
  }
  String _needCarbohydrateText() {
    if (info != null) {
      String carbohydrates = info!.needActivityCarbohydrates() ?? '0';
      return '필요 탄수화물: $carbohydrates';
    } else {
      return '필요 탄수화물: 0';
    }
  }
  String _needFatText() {
    if (info != null) {
      String fat = info!.needActivityFat() ?? '0';
      return '필요 지방: $fat';
    } else {
      return '필요 지방: 0';
    }
  }


  Future<double> getTotalProtein() async {
    double totalProtein = 0;
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'eat.db'),
    );
    List<Map<String, dynamic>> result = await database.rawQuery('SELECT SUM(protein) FROM eat');

    if (result.isNotEmpty && result[0]['SUM(protein)'] != null) {
      totalProtein = result[0]['SUM(protein)'] as double;
    }

    return totalProtein;
  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: TextStyle(
              color: widget.titleColor,
              fontWeight: FontWeight.bold, // 글꼴을 굵게 설정
              fontSize: 32, // 글꼴 크기를 32로 변경
            ),
          ),
          leading: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
                _scaffoldKey.currentState?.openEndDrawer();
                info = (await db_user_info.getUserInfo())!;
                if (info != null) {
                  activityDropdownValue = info!.getActivity() ?? '0';
                }
              },
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  padding: EdgeInsets.all(15.0),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xff69DFCB),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          '나이: ${info != null ? (year - int.parse(info!.getYear() ?? "") + 1) : '정보 없음'}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '키: ${info?.getCm() ?? ""} cm',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '몸무게: ${info?.getKg() ?? ""} kg',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: info?.getActivity() == '1.2'
                              ? Text(
                            '활동량: 안함',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                              : info?.getActivity() == '1.375'
                              ? Text(
                            '활동량: 일주일에 1~2번',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                              : info?.getActivity() == '1.55'
                              ? Text(
                            '활동량: 일주일에 3~4번',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                              : info?.getActivity() == '1.725'
                              ? Text(
                            '활동량: 일주일에 5~6번',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            '활동량: 매일',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                      ),
                    ],
                  )
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                child: ListTile(

                  title: Text('정보 변경'),
                  onTap: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (_) => infoModify()),  //이거는 그냥 메인에서 음식 검색 페이지로 넘어가는 실험용
                    ).then((value) {
                      setState(() {
                        db_user_info.getUserInfo().then((fetchedInfo) {
                          info = fetchedInfo;
                        });
                      });
                    });
                  },
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: ListTile(
                    title: Text('기록'),
                    onTap: () {

                    },
                  )
              ),
            ],
          ),
        ),
        //여기까지 옆에 프로필 화면
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // 흰색 테두리 색상
                    width: 4.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(8.0), // 테두리 모서리 둥글기 설정
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _getGoalText(), // 목표 텍스트 표시
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),


          Expanded(
            child: Container(), // 원래의 중앙 정렬을 유지하기 위해 추가된 빈 컨테이너
          ),


          FutureBuilder<double>(
            future: getTotalProtein(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                double _totalProtein = snapshot.data ?? 0;
                String totalProtein = _totalProtein.toStringAsFixed(0);
                return Text(
                  '섭취 단백질: ${totalProtein} g\n${_needKcalText()} kcal\n${_needProteinText()} g\n',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                );
              }
              return CircularProgressIndicator(); // 데이터베이스 연산이 완료될 때까지 로딩 표시
            },
          ),


          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // 흰색 테두리 색상
                    width: 4.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(8.0), // 테두리 모서리 둥글기 설정
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${_needKcalText()} kcal\n${_needProteinText()} g\n${_needCarbohydrateText()} g\n${_needFatText()} g', //영양성분 표시
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),



          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬을 위해 추가
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (activityDropdownValue == '0') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => user_info()),
                      );
                    } else {
                      // 다른 동작 수행
                    }
                  },
                  child: Text('첫 번째 버튼'),
                ),
                SizedBox(width: 16), // 버튼 사이에 간격을 주기 위해 추가
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => foodPage()),
                    );
                  },
                  child: Text('두 번째 버튼'),
                ),
              ],
            ),
          ),
        ],
      ),
      // body: Center(
//     child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (_) => user_info())  //이거는 그냥 메인에서 음식 검색 페이지로 넘어가는 실험용
//         );
//       },
//       child: Text('button'),
//     )
// )
    );
  }
}

