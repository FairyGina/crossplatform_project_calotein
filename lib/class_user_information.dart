class user_information{
  String? year;
  String? month;
  String? day; //생년월일

  String? gender; //성별

  String? cm; //키
  String? kg; //몸무게
  String? activity; //활동량

  String? goal; //목표

  user_information({ this.year, this.month, this.day,
    this.gender,
    this.cm, this.kg, this.activity,
    this.goal });

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




}

