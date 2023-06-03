import 'package:calotin/class_user_information.dart';
import 'package:calotin/user_information.dart';
import 'package:flutter/material.dart';
import 'package:calotin/food.dart';
import 'package:calotin/db_user_information.dart';
import 'package:calotin/class_user_information.dart';
import 'package:calotin/food_db.dart';
import 'package:calotin/eat_db.dart';
import 'package:calotin/userinfo_modify.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main 화면',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
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
                    child: info?.getActivity() == 0
                      ? Text(
                        '활동량: 안함',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    : info?.getActivity() == '1'
                      ? Text(
                        '활동량: 일주일에 1~2번',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    : info?.getActivity() == '2'
                      ? Text(
                        '활동량: 일주일에 3~4번',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    : info?.getActivity() == '3'
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
      body: Center(
        child: ElevatedButton(
          onPressed: () { 
            Navigator.push(
              context, MaterialPageRoute(builder: (_) => user_info())  //이거는 그냥 메인에서 음식 검색 페이지로 넘어가는 실험용
            );
          },
          child: Text('button'),
        )
      )

    );
  }
}
