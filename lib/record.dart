import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:calotin/class_user_information.dart';
import 'package:calotin/class_user_nutrient.dart';
import 'package:calotin/eat_db.dart';
import 'package:calotin/db_user_information.dart';



void main() {
  runApp(Record());
}

class Record extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Record(),
    );

  }
}

class _Record extends StatefulWidget {
  @override
  RecordState createState() => RecordState();
}







class RecordState extends State<_Record> {

  //데이터베이스
  eatDatabase? eatdb = eatDatabase();
  db_user_information db_user_info = db_user_information();
  user_information? info;


  @override
  void initState() {
    super.initState();

    now = DateTime.now();
    db_user_info.getUserInfo().then((fetchedInfo) {
      setState(() {
        info = fetchedInfo;

        nutriList5 = eatdb?.getTotalKcal(now);
        nutriList4 = eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 1, now.hour));
        nutriList3 = eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 2, now.hour));
        nutriList2 = eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 3, now.hour));
        nutriList1 = eatdb?.getTotalKcal(DateTime(now.year, now.month, now.day - 4, now.hour));
      });
    });



  }




  //열량/영양소 합계
  double sumKcal = 0;
  double sumCarbohydrate = 0;
  double sumProtein = 0;
  double sumFat = 0;


  //열량/영양소 퍼센트 합계
  double percentKcal = 0;
  double percentCarbohydrate = 0;
  double percentProtein = 0;
  double percentFat = 0;

  late String startDate = '0';
  late String endDate = '0';




  int? day = 0;
  late DateTime now;



  Future<List<user_nutrient>>? nutriList1;
  Future<List<user_nutrient>>? nutriList2;
  Future<List<user_nutrient>>? nutriList3;
  Future<List<user_nutrient>>? nutriList4;
  Future<List<user_nutrient>>? nutriList5;










  Color getColor(int j) {
    Color barColor = Colors.black;
    if(j==0) {
      barColor = Colors.red;
    } else if(j==1) {
      barColor = Colors.grey;
    } else if(j==2) {
      barColor = Colors.blue;
    } else if(j==3) {
      barColor = Colors.yellow;
    }

    return barColor;
  }



  List<List<double>> DataList = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
  ];




  List<BarChartGroupData> getGroupedBarData() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < 5; i++) {
      List<BarChartRodData> barRods = [];
      for (int j = 0; j < 4; j++) {
        barRods.add(
          BarChartRodData(
            fromY:0,
            toY: DataList[j][i],
            color: getColor(j),
            width: 10,
          ),
        );
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: barRods,
          showingTooltipIndicators: [0],
        ),
      );
    }

    return barGroups;
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('기록'),
        backgroundColor: Color(0xff69DFCB),
      ),
      body: ListView(
        // child: Column(
        children: [
          StreamBuilder<List<user_nutrient>>(
            stream: Stream.fromFuture(nutriList1!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final List<user_nutrient> list = snapshot.data!;
                  user_nutrient nutri = list[0];

                  DateTime date = DateTime(now.year, now.month, now.day, now.hour);

                  //시작 날짜 받아오기
                  startDate = date.toString().substring(0, 10);

                  double eatKcal = double.tryParse(nutri.eatKcal ?? '0') ?? 0.0;
                  double eatProtein = double.tryParse(nutri.eatProtein ?? '0') ?? 0.0;
                  double eatCarbohydrate = double.tryParse(nutri.eatCarbohydrate ?? '0') ?? 0.0;
                  double eatFat = double.tryParse(nutri.eatFat ?? '0') ?? 0.0;

                  // 5일간 칼로리 / 영양성분 더하기 변수
                  sumKcal += eatKcal;
                  sumCarbohydrate += eatCarbohydrate;
                  sumProtein += eatProtein;
                  sumFat += eatFat;




                  // 5일간 칼로리 / 영양성분 퍼센트 계산
                  //칼로리 계산
                  double tempTotalkcal= eatKcal / double.parse(_needKcalText()) * 100;
                  if(tempTotalkcal > 100) tempTotalkcal = 100;
                  percentKcal = tempTotalkcal;

                  //탄수화물 계산
                  double carbohydrateResult = eatCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                  if (carbohydrateResult > 100) carbohydrateResult = 100;
                  percentCarbohydrate = carbohydrateResult;

                  //단백질 계산
                  double proteinResult=eatProtein/double.parse(_needProteinText())* 100;
                  if(proteinResult>100) proteinResult = 100;
                  percentProtein = proteinResult;

                  //지방 계산
                  double fatResult = eatFat / double.parse(_needFatText()) * 100;
                  if (fatResult > 100) fatResult = 100;
                  percentFat = fatResult;


                  // 그래프 변수 전달
                  DataList[0][0] = percentKcal;
                  DataList[1][0] = percentCarbohydrate;
                  DataList[2][0] = percentProtein;
                  DataList[3][0] = percentFat;


                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );

                }
              }
              return Container(
                width: 0.0,
                height: 0.0,
              );

              // return CircularProgressIndicator();
            },
          ),




          StreamBuilder<List<user_nutrient>>(
            stream: Stream.fromFuture(nutriList2!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final List<user_nutrient> list = snapshot.data!;
                  user_nutrient nutri = list[0];
                  // DateTime date = DateTime(now.year, now.month, now.day-3, now.hour);

                  double eatKcal = double.tryParse(nutri.eatKcal ?? '0') ?? 0.0;
                  double eatProtein = double.tryParse(nutri.eatProtein ?? '0') ?? 0.0;
                  double eatCarbohydrate = double.tryParse(nutri.eatCarbohydrate ?? '0') ?? 0.0;
                  double eatFat = double.tryParse(nutri.eatFat ?? '0') ?? 0.0;

                  // 5일간 칼로리 / 영양성분 더하기 변수
                  sumKcal += eatKcal;
                  sumCarbohydrate += eatCarbohydrate;
                  sumProtein += eatProtein;
                  sumFat += eatFat;


                  // 5일간 칼로리 / 영양성분 퍼센트 계산
                  //칼로리 계산
                  double tempTotalkcal= eatKcal / double.parse(_needKcalText()) * 100;
                  if(tempTotalkcal > 100) tempTotalkcal = 100;
                  percentKcal = tempTotalkcal;

                  //탄수화물 계산
                  double carbohydrateResult = eatCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                  if (carbohydrateResult > 100) carbohydrateResult = 100;
                  percentCarbohydrate = carbohydrateResult;

                  //단백질 계산
                  double proteinResult=eatProtein/double.parse(_needProteinText())* 100;
                  if(proteinResult>100) proteinResult = 100;
                  percentProtein = proteinResult;

                  //지방 계산
                  double fatResult = eatFat / double.parse(_needFatText()) * 100;
                  if (fatResult > 100) fatResult = 100;
                  percentFat = fatResult;


                  // 그래프 변수 전달
                  DataList[0][1] = percentKcal;
                  DataList[1][1] = percentCarbohydrate;
                  DataList[2][1] = percentProtein;
                  DataList[3][1] = percentFat;



                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );

                }
              }
              return Container(
                width: 0.0,
                height: 0.0,
              );
              // return CircularProgressIndicator();
            },
          ),


          StreamBuilder<List<user_nutrient>>(
            stream: Stream.fromFuture(nutriList3!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final List<user_nutrient> list = snapshot.data!;
                  user_nutrient nutri = list[0];
                  // DateTime date = DateTime(now.year, now.month, now.day-2, now.hour);

                  double eatKcal = double.tryParse(nutri.eatKcal ?? '0') ?? 0.0;
                  double eatProtein = double.tryParse(nutri.eatProtein ?? '0') ?? 0.0;
                  double eatCarbohydrate = double.tryParse(nutri.eatCarbohydrate ?? '0') ?? 0.0;
                  double eatFat = double.tryParse(nutri.eatFat ?? '0') ?? 0.0;

                  // 5일간 칼로리 / 영양성분 더하기 변수
                  sumKcal += eatKcal;
                  sumCarbohydrate += eatCarbohydrate;
                  sumProtein += eatProtein;
                  sumFat += eatFat;



                  // 5일간 칼로리 / 영양성분 퍼센트 계산
                  //칼로리 계산
                  double tempTotalkcal= eatKcal / double.parse(_needKcalText()) * 100;
                  if(tempTotalkcal > 100) tempTotalkcal = 100;
                  percentKcal = tempTotalkcal;

                  //탄수화물 계산
                  double carbohydrateResult = eatCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                  if (carbohydrateResult > 100) carbohydrateResult = 100;
                  percentCarbohydrate = carbohydrateResult;

                  //단백질 계산
                  double proteinResult=eatProtein/double.parse(_needProteinText())* 100;
                  if(proteinResult>100) proteinResult = 100;
                  percentProtein = proteinResult;

                  //지방 계산
                  double fatResult = eatFat / double.parse(_needFatText()) * 100;
                  if (fatResult > 100) fatResult = 100;
                  percentFat = fatResult;


                  // 그래프 변수 전달
                  DataList[0][2] = percentKcal;
                  DataList[1][2] = percentCarbohydrate;
                  DataList[2][2] = percentProtein;
                  DataList[3][2] = percentFat;


                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );

                }
              }
              return Container(
                width: 0.0,
                height: 0.0,
              );
              // return CircularProgressIndicator();
            },
          ),


          StreamBuilder<List<user_nutrient>>(
            stream: Stream.fromFuture(nutriList4!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final List<user_nutrient> list = snapshot.data!;
                  user_nutrient nutri = list[0];
                  // DateTime date = DateTime(now.year, now.month, now.day-1, now.hour);

                  double eatKcal = double.tryParse(nutri.eatKcal ?? '0') ?? 0.0;
                  double eatProtein = double.tryParse(nutri.eatProtein ?? '0') ?? 0.0;
                  double eatCarbohydrate = double.tryParse(nutri.eatCarbohydrate ?? '0') ?? 0.0;
                  double eatFat = double.tryParse(nutri.eatFat ?? '0') ?? 0.0;

                  // 5일간 칼로리 / 영양성분 더하기 변수
                  sumKcal += eatKcal;
                  sumCarbohydrate += eatCarbohydrate;
                  sumProtein += eatProtein;
                  sumFat += eatFat;



                  // 5일간 칼로리 / 영양성분 퍼센트 계산
                  //칼로리 계산
                  double tempTotalkcal= eatKcal / double.parse(_needKcalText()) * 100;
                  if(tempTotalkcal > 100) tempTotalkcal = 100;
                  percentKcal = tempTotalkcal;

                  //탄수화물 계산
                  double carbohydrateResult = eatCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                  if (carbohydrateResult > 100) carbohydrateResult = 100;
                  percentCarbohydrate = carbohydrateResult;

                  //단백질 계산
                  double proteinResult=eatProtein/double.parse(_needProteinText())* 100;
                  if(proteinResult>100) proteinResult = 100;
                  percentProtein = proteinResult;

                  //지방 계산
                  double fatResult = eatFat / double.parse(_needFatText()) * 100;
                  if (fatResult > 100) fatResult = 100;
                  percentFat = fatResult;


                  // 그래프 변수 전달
                  DataList[0][3] = percentKcal;
                  DataList[1][3] = percentCarbohydrate;
                  DataList[2][3] = percentProtein;
                  DataList[3][3] = percentFat;


                  return Container(
                    width: 0.0,
                    height: 0.0,
                  );

                }
              }
              return Container(
                width: 0.0,
                height: 0.0,
              );

              // return CircularProgressIndicator();
            },
          ),


          StreamBuilder<List<user_nutrient>>(
            stream: Stream.fromFuture(nutriList1!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('오류: ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final List<user_nutrient> list = snapshot.data!;
                  user_nutrient nutri = list[0];


                  double eatKcal = double.tryParse(nutri.eatKcal ?? '') ?? 0.0;
                  double eatProtein = double.tryParse(nutri.eatProtein ?? '') ?? 0.0;
                  double eatCarbohydrate = double.tryParse(nutri.eatCarbohydrate ?? '') ?? 0.0;
                  double eatFat = double.tryParse(nutri.eatFat ?? '') ?? 0.0;

                  // 5일간 칼로리 / 영양성분 더하기 변수
                  sumKcal += eatKcal;
                  sumCarbohydrate += eatCarbohydrate;
                  sumProtein += eatProtein;
                  sumFat += eatFat;


                  // 5일간 칼로리 / 영양성분 퍼센트 계산
                  //칼로리 계산
                  double temp_totalkcal= eatKcal / double.parse(_needKcalText()) * 100;
                  if(temp_totalkcal > 100) temp_totalkcal = 100;
                  percentKcal = temp_totalkcal;

                  //탄수화물 계산
                  double carbohydrateResult = eatCarbohydrate / double.parse(_needCarbohydrateText()) * 100;
                  if (carbohydrateResult > 100) carbohydrateResult = 100;
                  percentCarbohydrate = carbohydrateResult;

                  //단백질 계산
                  double proteinResult=eatProtein/double.parse(_needProteinText())* 100;
                  if(proteinResult>100) proteinResult = 100;
                  percentProtein = proteinResult;

                  //지방 계산
                  double fatResult = eatFat / double.parse(_needFatText()) * 100;
                  if (fatResult > 100) fatResult = 100;
                  percentFat = fatResult;


                  // 그래프 변수 전달
                  DataList[0][4] = percentKcal;
                  DataList[1][4] = percentCarbohydrate;
                  DataList[2][4] = percentProtein;
                  DataList[3][4] = percentFat;


                }

                return Container(
                  width: 0.0,
                  height: 0.0,
                );
              }

              return CircularProgressIndicator();
            },
          ),


          // Padding(
          //   padding: EdgeInsets.only(top: 50.0),



          // ),


          Container(
            height: 30,

          ), // 원래의 중앙 정렬을 유지하기 위해 추가된 빈 컨테이너





          // SingleChildScrollView(
          //   child: Padding(
          //     padding: EdgeInsets.all(4.0),
          //     child: ListView(
          //       shrinkWrap: true,
          //       children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              StreamBuilder<List<user_nutrient>>(
                stream: Stream.fromFuture(nutriList1!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('오류: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {

                      DateTime date = DateTime(now.year, now.month, now.day, now.hour);

                      //끝 날짜 받아오기
                      endDate = date.toString().substring(0, 10);

                      final String formattedstartDate = startDate.toString().substring(0, 10);
                      final String formattedendDate = endDate.toString().substring(0, 10);



                      double averageKcal = sumKcal / 5;
                      double averageCarbohydrate = sumCarbohydrate / 5;
                      double averageProtein = sumProtein / 5;
                      double averageFat = sumFat / 5;


                      String formattedKcal = averageKcal.toStringAsFixed(0);
                      String formattedProtein = averageCarbohydrate.toStringAsFixed(0);
                      String formattedCarbohydrate = averageProtein.toStringAsFixed(0);
                      String formattedFat = averageFat.toStringAsFixed(0);

                      return Center(
                        child: Container(
                          width: 400.0,
                          // width: 500.0,
                          margin: EdgeInsets.only(bottom: 32.0),
                          child: Column(
                            children: [
                              Container(
                                height: 300,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: BarChart(
                                    BarChartData(
                                      maxY: 100,
                                      barGroups: getGroupedBarData(), // 로드된 데이터로 그래프 그리기
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border(
                                          left: BorderSide(color: Colors.black, width: 2),
                                          bottom: BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        show: false,
                                      ),
                                      gridData: FlGridData(
                                        show: false,
                                      ),
                                      barTouchData: BarTouchData(
                                        enabled: true,
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Colors.blueGrey,
                                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                            return BarTooltipItem(
                                              rod.toY.toStringAsFixed(1) + '%',
                                              TextStyle(color: Colors.white),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '$formattedstartDate ~ $formattedendDate',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '$formattedKcal kcal\n$formattedProtein g\n$formattedCarbohydrate g\n$formattedFat g',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    }
                  }
                  return CircularProgressIndicator();
                  // return Container(
                  //   width: 0.0,
                  //   height: 0.0,
                  // );
                },
              ),
              // Expanded(







            ],



          ),







        ],

      ),
    );
  }


}