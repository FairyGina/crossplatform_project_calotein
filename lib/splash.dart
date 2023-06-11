import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:calotin/main.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'main 화면',
      theme: ThemeData(

      ),
      home: _SplashPage(),
    );
  }
}

class _SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
     return _Splash();
  }
}
class _Splash extends State<_SplashPage> {
  String image = 'asset/dambi_intro2.gif'; //여기에 넣을 이미지 경로 넣기(파일이 gif였음 좋겠음)
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = 10;
    double height = 10;

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(image),
              // fit: BoxFit.contain
          )
        ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}