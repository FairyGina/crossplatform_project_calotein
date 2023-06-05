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
      eatKcal: map['먹은 칼로리'].toString(),
      eatProtein: map['먹은 단백질'].toString(),
      eatCarbohydrate: map['먹은 탄수화물'].toString(),
      eatFat: map['먹은 지방'].toString(),
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