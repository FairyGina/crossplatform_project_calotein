class user_nutrient{
  String? eatKcal;
  String? eatProtein;
  String? eatCarbohydrate;
  String? eatFat;

  user_nutrient({
    this.eatKcal,
    this.eatProtein,
    this.eatCarbohydrate,
    this.eatFat,
  });

  factory user_nutrient.fromMap(Map<String, dynamic> map){
    return user_nutrient(
      eatKcal: map['eatKcal'].toString(),
      eatProtein: map['eatProtein'].toString(),
      eatCarbohydrate: map['eatCarbohydrate'].toString(),
      eatFat: map['eatFat'].toString(),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'eatKcal' : eatKcal,
      'eatProtein' : eatProtein,
      'eatCarbohydrate' : eatCarbohydrate,
      'eatFat' : eatFat,
    };
  }
}