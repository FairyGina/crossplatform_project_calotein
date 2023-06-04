class user_information{
  String? year;
  String? month;
  String? day; //생년월일

  String? gender; //성별

  String? cm; //키
  String? kg; //몸무게
  String? activity; //활동량

  String? goal; //목표

  user_information({
    this.year,
    this.month,
    this.day,
    this.gender,
    this.cm,
    this.kg,
    this.activity,
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

  String? getGoal() {
    return goal;
  }
}
