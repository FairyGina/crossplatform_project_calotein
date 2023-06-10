import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:calotin/db_user_information.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/eat_db.dart';
import 'package:calotin/class_user_information.dart';
import 'package:calotin/food_class.dart';
import 'package:calotin/user_information.dart';
import 'package:calotin/food.dart';
import 'package:calotin/userinfo_modify.dart';
import 'package:calotin/record.dart';
import 'package:calotin/splash.dart';

int? isviewed;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = await prefs.getInt("isviewed");
  await prefs.setInt("isviewed", 1);

  runApp(SplashPage());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main 화면',
      theme: ThemeData(

      ),
      initialRoute: isviewed == 0 || isviewed == null ? "first" : "/",
      routes: {
        '/': (context) => MyHomePage(title: 'calotein',titleColor: Color(0xff69DFCB)),
        'first' : (context) => user_info(),
      },
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
  Future<List<Food>>? eatList;

  //데이터 저장 전역변수
  double totalKcalData=0;
  double totalProteinData=0;
  double totalCarbohydrateData=0;
  double totalFatData=0;

  // 데이터 베이스 가져오기
  @override
  void initState() {
    super.initState();
    year = DateTime.now().year;
    eatList = eatdb?.getCurrentDayEat();
    db_user_info.getUserInfo().then((fetchedInfo) {
      setState(() {
        info = fetchedInfo;
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
      return kcal;
    } else {
      return '0';
    }
  }

  String _needProteinText() {
    if (info != null) {
      String protein = info!.needActivityProtein() ?? '0';
      return protein;
    } else {
      return '0';
    }
  }

  String _needCarbohydrateText() {
    if (info != null) {
      String carbohydrates = info!.needActivityCarbohydrates() ?? '0';
      return carbohydrates;
    } else {
      return '0';
    }
  }

  String _needFatText() {
    if (info != null) {
      String fat = info!.needActivityFat() ?? '0';
      return fat;
    } else {
      return '0';
    }
  }

  List<BarChartGroupData> getData(double g) {
    if(g>100) g=100;
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            fromY: 0,
            color: Color(0xff69DFCB),
            toY: g, // 막대 색상 지정
            width: 8, // 막대 선 두께
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: widget.titleColor,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              color: widget.titleColor,
              fontWeight: FontWeight.bold, // 글꼴을 굵게 설정
              fontSize: 32, // 글꼴 크기를 32로 변경
            ),
          ),
          backgroundColor: Colors.white,
          leading: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              color: Colors.black54,
              onPressed: () async {
                _scaffoldKey.currentState?.openEndDrawer();
                info = (await db_user_info.getUserInfo())!;
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
                  height: 190,
                  decoration: BoxDecoration(
                    color: Color(0xff69DFCB),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 50),
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
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Record()),
                      );
                    },
                  )
              ),
            ],
          ),
        ),
        //여기까지 옆에 프로필 화면

      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32, right: 10, left: 10),
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
          Container(
              height: 60, // 원래의 중앙 정렬을 유지하기 위해 추가된 빈 컨테이너
          ),
          //원형그래프
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align( // 원형 그래프
                    alignment: Alignment.center,
                    child: Container(
                      width: 197,
                      height: 197,
                      child: StreamBuilder<double>(
                        stream: eatdb!.getTotalKcalStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          double _totalkcal = snapshot.data ?? 0;

                          double temp_totalkcal= _totalkcal / double.parse(_needKcalText()) * 100;
                          if(temp_totalkcal>100) temp_totalkcal = 100;
                          totalKcalData = temp_totalkcal;

                          return PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: totalKcalData,
                                  color: Color(0xff69DFCB),
                                  radius: 12,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.transparent,
                                  ),
                                  showTitle: true,
                                ),
                                PieChartSectionData(
                                  value: 100 - totalKcalData,
                                  color: Colors.white,
                                  radius: 8,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.transparent,
                                  ),
                                  showTitle: true,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => foodPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff69DFCB),
                          padding: EdgeInsets.all(16),
                          shape: CircleBorder(),
                          minimumSize: Size(170, 170),
                        ),
                        child: StreamBuilder<double>(
                          stream: eatdb!.getTotalKcalStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            double _totalkcal = snapshot.data ?? 0;

                            double temp_totalkcal= _totalkcal / double.parse(_needKcalText()) * 100;
                            if(temp_totalkcal > 100) temp_totalkcal = 100;
                            totalKcalData = temp_totalkcal;

                            String totalkcal = _totalkcal.toStringAsFixed(0);
                            return Text(
                              '${totalkcal} /\n${_needKcalText()} kcal',
                              style: TextStyle(fontSize: 32, color: Colors.white),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Transform.rotate(
                                          angle: 90 * 3.1415926535 / 180,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 10,
                                              padding: EdgeInsets.all(4),
                                              child: StreamBuilder<double>(
                                                stream: eatdb!.getTotalCarbohydrateStream(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  double _totalCarbohydrate = snapshot.data ?? 0;

                                                  double result = _totalCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                                                  if (result > 100) result = 100;
                                                  totalCarbohydrateData = result;

                                                  return BarChart(
                                                    BarChartData(
                                                      alignment: BarChartAlignment.center,
                                                      groupsSpace: 0,
                                                      maxY: 100,
                                                      barGroups: getData(totalCarbohydrateData),
                                                      backgroundColor: Colors.white,
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      titlesData: FlTitlesData(
                                                        show: false,
                                                      ),
                                                      gridData: FlGridData(
                                                        show: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '탄수화물',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      StreamBuilder<double>(
                                        stream: eatdb!.getTotalCarbohydrateStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }
                                          double _totalCarbohydrate = snapshot.data ?? 0;
                                          String totalCarbohydrate = _totalCarbohydrate.toStringAsFixed(0);

                                          double result = _totalCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                                          if (result > 100) result = 100;
                                          totalCarbohydrateData = result;

                                          return Text(
                                            '${totalCarbohydrate} / ${_needCarbohydrateText()} g  \n',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Transform.rotate(
                                          angle: 90 * 3.1415926535 / 180,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 10,
                                              padding: EdgeInsets.all(4),
                                              child: StreamBuilder<double>(
                                                stream: eatdb!.getTotalProteinStream(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  double _totalProtein = snapshot.data ?? 0;

                                                  double result = _totalProtein / double.parse(_needProteinText()) * 100;
                                                  if (result > 100) result = 100;
                                                  totalProteinData = result;

                                                  return BarChart(
                                                    BarChartData(
                                                      alignment: BarChartAlignment.center,
                                                      groupsSpace: 0,
                                                      maxY: 100,
                                                      barGroups: getData(totalProteinData),
                                                      backgroundColor: Colors.white,
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      titlesData: FlTitlesData(
                                                        show: false,
                                                      ),
                                                      gridData: FlGridData(
                                                        show: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '단백질',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      StreamBuilder<double>(
                                        stream: eatdb!.getTotalProteinStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }
                                          double _totalProtein = snapshot.data ?? 0;

                                          double result=_totalProtein/double.parse(_needProteinText())* 100;
                                          if(result>100) result = 100;
                                          totalProteinData = result;

                                          String totalProtein = _totalProtein.toStringAsFixed(0);

                                          return Text(
                                            '${totalProtein} / ${_needProteinText()} g\n',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 16.0, // 간격을 조정하기 위한 Container
                  ),
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Transform.rotate(
                                          angle: 90 * 3.1415926535 / 180,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            child: Container(
                                              height: 50,
                                              width: 10,
                                              padding: EdgeInsets.all(4),
                                              child: StreamBuilder<double>(
                                                stream: eatdb!.getTotalFatStream(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text('Error: ${snapshot.error}');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  double _totalFat = snapshot.data ?? 0;

                                                  double result = _totalFat / double.parse(_needFatText()) * 100;
                                                  if (result > 100) result = 100;
                                                  totalFatData = result;

                                                  return BarChart(
                                                    BarChartData(
                                                      alignment: BarChartAlignment.center,
                                                      groupsSpace: 0,
                                                      maxY: 100,
                                                      barGroups: getData(totalFatData),
                                                      backgroundColor: Colors.white,
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      titlesData: FlTitlesData(
                                                        show: false,
                                                      ),
                                                      gridData: FlGridData(
                                                        show: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '지방',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      StreamBuilder<double>(
                                        stream: eatdb!.getTotalFatStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData) {
                                            return CircularProgressIndicator();
                                          }
                                          double _totalFat = snapshot.data ?? 0;

                                          double result=_totalFat/double.parse(_needFatText())* 100;
                                          if(result>100) result = 100;
                                          totalFatData = result;

                                          String totalFat = _totalFat.toStringAsFixed(0);

                                          return Text(
                                            '${totalFat} / ${_needFatText()} g\n',
                                            style: TextStyle(fontSize: 16, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StreamBuilder<double>(
                    stream: eatdb!.getTotalKcalStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      double _totalkcal = snapshot.data ?? 0;
                      double result=double.parse(_needKcalText())-_totalkcal;
                      if(result<0) result = 0;
                      String totalkcal = result.toStringAsFixed(0);

                      return Text(
                        '칼로리: $totalkcal kcal',
                        style: TextStyle(fontSize: 16, color: Color(0xff69DFCB)),
                        textAlign: TextAlign.center, // 가운데 정렬 설정
                      );
                    },
                  ),
                    StreamBuilder<double>(
                      stream: eatdb!.getTotalCarbohydrateStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        double _totalCarbohydrate = snapshot.data ?? 0;
                        double result=_totalCarbohydrate/double.parse(_needCarbohydrateText())* 100;
                        if(result>100) result = 100;
                        String totalCarbohydrate = result.toStringAsFixed(0);

                        return Text(
                          '탄수화물: $totalCarbohydrate %',
                          style: TextStyle(fontSize: 16, color: Color(0xff69DFCB)),
                        );
                      },
                    ),
                    StreamBuilder<double>(
                      stream: eatdb!.getTotalProteinStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        double _totalProtein = snapshot.data ?? 0;
                        double result=_totalProtein/double.parse(_needProteinText())* 100;
                        if(result>100) result = 100;
                        String totalProtein = result.toStringAsFixed(0);

                        return Text(
                          '단백질: $totalProtein %',
                          style: TextStyle(fontSize: 16, color: Color(0xff69DFCB)),
                        );
                      },
                    ),
                    StreamBuilder<double>(
                      stream: eatdb!.getTotalFatStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        double _totalFat = snapshot.data ?? 0;
                        double result=_totalFat/double.parse(_needFatText())* 100;
                        if(result>100) result = 100;
                        String totalFat = result.toStringAsFixed(0);

                        return Text(
                          '지방: $totalFat %',
                          style: TextStyle(fontSize: 16, color: Color(0xff69DFCB)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

