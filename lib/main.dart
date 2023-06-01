import 'package:flutter/material.dart';
import 'package:calotin/food.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
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
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '이름', //나중에 바꿀 것
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '나이: ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '키: ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '몸무게: ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '활동량: ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
              context, MaterialPageRoute(builder: (_) => foodPage())  //이거는 그냥 메인에서 음식 검색 페이지로 넘어가는 실험용
            );
          },
          child: Text('button'),
        )
      )

    );
  }
}
