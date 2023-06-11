import 'class_user_information.dart';
import 'db_user_information.dart';

import 'package:flutter/material.dart';

class infoModify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _infoModify();
  }
}

class _infoModify extends State<infoModify> {
  db_user_information? db_user_info = db_user_information();
  user_information? info;

  final year = TextEditingController();
  final month = TextEditingController();
  final day = TextEditingController();
  final gender = TextEditingController();
  final cm = TextEditingController();
  final kg = TextEditingController();
  final activity = TextEditingController();
  final goal = TextEditingController();
  //입력받은 값들을 저장하기 위한 변수

  //라디오 버튼 값
  int? _genderradioValue = 0; // 라디오 버튼 값 상태 변수

  void _radiochange(int? value) {
    setState(() {
      _genderradioValue = value ?? 0; // 선택된 라디오 버튼 값 갱신
    });
  }

  //활동량 정보
  String? _selectedActivity; // 활동량 드롭다운 값 상태 변수

  // 활동량 드롭다운 값 변경 시 호출되는 콜백 함수
  void _activityDropdownChange(String? value) {
    setState(() {
      _selectedActivity = value; // 선택된 활동량 값 갱신
    });
  }

  List<String> activityDropdownList = ['아예 없음','1~2번','3~4번','5~6번','매일'];
  String activityDropdownValue = '0';

  @override
  void initState() {
    super.initState();
    db_user_info?.getUserInfo().then((fetchedInfo) {
      setState(() {
        info = fetchedInfo;
        _genderradioValue = (info?.getGender() == '여자') ? 0 : 1;
        if (info != null) {
          switch (info!.getActivity()) {
            case '1.2':
              _selectedActivity = activityDropdownList[0];
              break;
            case '1.375':
              _selectedActivity = activityDropdownList[1];
              break;
            case '1.55':
              _selectedActivity = activityDropdownList[2];
              break;
            case '1.725':
              _selectedActivity = activityDropdownList[3];
              break;
            case '1.9':
              _selectedActivity = activityDropdownList[4];
              break;
            default:
              _selectedActivity = activityDropdownList[0];
              break;
          }
        } else {
          _selectedActivity = activityDropdownList[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    year.text = info?.getYear().toString() ?? '';
    month.text = info?.getMonth().toString() ?? '';
    day.text = info?.getDay().toString() ?? '';
    cm.text = info?.getCm().toString() ?? '';
    kg.text = info?.getKg().toString() ?? '';
    goal.text = info?.getGoal().toString() ?? '';

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('정보 변경'),
        backgroundColor: Color(0xff69DFCB),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //생년월일 입력
                    Container(
                      width: 125,
                      padding: EdgeInsets.all(3.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '년도',
                        ),
                        controller: year,
                      ),
                    ),
                    Container(
                      width: 105,
                      padding: EdgeInsets.all(3.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '월',
                        ),
                        controller: month,
                      ),
                    ),
                    Container(
                      width: 105,
                      padding: EdgeInsets.all(3.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '일',
                        ),
                        controller: day,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '성별: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _genderradioValue,
                            onChanged: _radiochange,
                          ),
                          Text(
                            '남자',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Radio(
                            value: 0,
                            groupValue: _genderradioValue,
                            onChanged: _radiochange,
                          ),
                          Text(
                            '여자',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '키',
                    ),
                    controller: cm,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '몸무게',
                    ),
                    controller: kg,
                  ),
                ),
                // 활동량 드롭다운 버튼
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: DropdownButtonFormField<String>(
                    hint: Text('일주일에 운동을 몇 번 하는지 체크하시오'), // hint 설정
                    value: _selectedActivity,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '활동량',
                    ),
                    items: activityDropdownList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _activityDropdownChange(value);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '목표',
                    ),
                    controller: goal,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  width: 70,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      // padding: EdgeInsets.all(1.0),
                        backgroundColor: Color(0xff69DFCB),
                        side: BorderSide(
                          color: Color(0xff69DFCB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                    ),
                    child: Text(
                      "저장",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      String genderValue = (_genderradioValue == 0) ? '여자' : '남자'; //여자 남자 선택

                      String selectActivityValue='1.2';
                      String selectActivityProteinValue='1.0';

                      if(_selectedActivity=='아예 없음') {
                        selectActivityValue='1.2';
                        selectActivityProteinValue='1.0';
                      } else if(_selectedActivity=='1~2번') {
                        selectActivityValue='1.375';
                        selectActivityProteinValue='1.25';
                      } else if(_selectedActivity=='3~4번') {
                        selectActivityValue='1.55';
                        selectActivityProteinValue='1.5';
                      } else if(_selectedActivity=='5~6번') {
                        selectActivityValue='1.725';
                        selectActivityProteinValue='1.75';
                      } else if(_selectedActivity=='매일') {
                        selectActivityValue='1.9';
                        selectActivityProteinValue='2.0';
                      }

                      // _genderradioValue를 '여자' 또는 '남자'로 변환하여 저장
                      user_information user_info = user_information(
                        year: year.text,
                        month: month.text,
                        day: day.text,
                        gender: genderValue,
                        cm: cm.text,
                        kg: kg.text,
                        activity: selectActivityValue, // 선택된 활동량 값 사용
                        multiActivityProtein: selectActivityProteinValue,
                        goal: goal.text,
                      );
                      await db_user_info?.add(user_info);
                      Navigator.of(context).pop();
                    },  //입력받은 값들을 데이터베이스에 넣음
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

