class user_information{
  String? year;
  String? month;
  String? day; //생년월일

  String? gender; //성별

  String? cm; //키
  String? kg; //몸무게

  String? activity; //활동량
  String? multiActivityProtein; //활동량에 따른 필요 단백질배수

  String? activityKcal; //활동량 + 기초칼로리
  String? activityProtein; //활동량에 따른 필요 단백질
  String? activityCarbohydrates; //활동량에 따른 필요 탄수화물
  String? activityFat; //활동량에 따른 필요 지방

  String? goal; //목표

  user_information({
    this.year,
    this.month,
    this.day,

    this.gender,

    this.cm,
    this.kg,

    this.activity,
    this.multiActivityProtein,

    this.activityKcal,
    this.activityProtein,
    this.activityCarbohydrates,
    this.activityFat,

    this.goal });

  factory user_information.fromMap(Map<String, dynamic> map) {
    return user_information(
      year: map['year'].toString(),
      month: map['month'].toString(),
      day: map['day'].toString(),

      gender: map['gender'].toString(),

      cm: map['cm'].toString(),
      kg: map['kg'].toString(),

      activity: map['activity'].toString(),
      multiActivityProtein: map['multiActivityProtein'].toString(),


      activityProtein: map['activityProtein'].toString(),
      activityKcal: map['activityKcal'].toString(),
      activityCarbohydrates: map['activityCarbohydrates'].toString(),
      activityFat: map['activityFat'].toString(),

      goal: map['goal'].toString(),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'year': year,
      'month': month,
      'day': day,

      'gender': gender,

      'cm': cm,
      'kg': kg,

      'activity': activity,
      'multiActivityProtein': multiActivityProtein,

      'activityProtein': activityProtein,
      'activityKcal': activityKcal,
      'activityCarbohydrates': activityCarbohydrates,
      'activityFat': activityFat,

    };
  }

  String? getYear() {
    return year;
  }

  String? getMonth() {
    return month;
  }

  String? getDay() {
    return day;
  }




  String? getGender() {
    return gender;
  }





  String? getCm() {
    return cm;
  }

  String? getKg() {
    return kg;
  }




  String? getActivity() {
    return activity;
  }

  String? getMultiActivityProtein(){
    return multiActivityProtein;
  }





  //하루 필요 칼로리 계산
  String? needActivityKcal() {
    //칼로리 계산 기본식
    double defaultKcal = (double.parse(kg!) * 10) + (double.parse(cm!) * 6.25) - (5 * (double.parse(year!) - (int.parse(getYear() ?? "") + 1)));

    //성별에 따른 계산
    if(gender=='1') {
      defaultKcal += 5;
    } else {
      defaultKcal -= 161;
    }

    //활동량에 따른 계산
    defaultKcal *= (double.parse(activity!));


    //소수점 버리기
    String activityKcal = defaultKcal.toStringAsFixed(0);
    return activityKcal.toString();
  }



  //하루 필요 단백질 계산
  String? needActivityProtein() {
    double _activityProtein = double.parse(kg!) * double.parse(multiActivityProtein!);

    String activityProtein = _activityProtein.toStringAsFixed(0);

    return activityProtein.toString();
  }


  //하루 필요 탄수화물 계산
  String? needActivityCarbohydrates(){
    double _activityCarbohydrates= double.parse(needActivityProtein()!) * 5/3;

    String activityCarbohydrates = _activityCarbohydrates.toStringAsFixed(0);

    return activityCarbohydrates.toString();
  }



  //하루 필요 지방 계산
  String? needActivityFat(){
    double _activityFat= double.parse(needActivityProtein()!) * 2/3;

    String activityFat = _activityFat.toStringAsFixed(0);

    return activityFat.toString();
  }




  String? getGoal() {
    return goal;
  }
}
