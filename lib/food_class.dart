class Food {
  String? food_name;
  String? food_size;
  String? calorie;
  String? protein;
  String? fat;
  String? carbohydrate;

  Food ({
    this.food_name,
    this.food_size,
    this.calorie,
    this.protein,
    this.fat,
    this.carbohydrate
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    food_name: json["식품명"].toString(),
    food_size: json["1회제공량"].toString(),
    calorie: json["에너지(㎉)"].toString(),
    protein: json["단백질(g)"].toString(),
    fat: json["지방(g)"].toString(),
    carbohydrate: json["탄수화물(g)"].toString()
  );

  Map<String, dynamic> toJson() => {
    "food_name" : food_name,
    "food_size" : food_size,
    "calorie" : calorie,
    "protein" : protein,
    "fat" : fat,
    "carbohydrate" : carbohydrate
  };
}
