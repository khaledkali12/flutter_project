import 'dart:convert';

class MealInfo {
  String strMeal;
  String strMealThumb;
  String strCategory;
  String strArea;
  String strInstructions;
  // List<MealInfo> strIngredient;

  MealInfo({
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    // required this.strIngredient,
  });

  factory MealInfo.fromJson(Map<String, dynamic> json) => MealInfo(
        strMeal: json["strMeal"],
        strMealThumb: json["strMealThumb"],
        strCategory: json["strCategory"],
        strArea: json["strArea"],
        strInstructions: json["strInstructions"],
        // strIngredient: 
      );

  Map<String, dynamic> toJson() => {
        "strMeal": strMeal,
        "strMealThumb": strMealThumb,
        "strCategory": strCategory,
        "strArea": strArea,
        "strInstructions": strInstructions,
      };



  static List<MealInfo> fromJsonArray(Map<String, dynamic> jsonArray) {
    //return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
    return List<MealInfo>.from(
        jsonArray["meals"].map((e) => MealInfo.fromJson(e)));
  }

  //  static List<MealInfo> fromJsonArray2(Map<String, dynamic> jsonArray) {
  //   //return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
  //   return List<MealInfo>.from(
  //       jsonArray["meals"].map((e) => MealInfo.fromJson(e)));
  // }

   static List<String> extractIngredients(String json) {
    List<String> ingredients = [];
    var data = jsonDecode(json);
    var meals = data['meals'];
    var meal = meals[0];
    
    for (int i = 1; i <= 20; i++) {
      var ingredient = meal['strIngredient$i'];
     
      if (ingredient != null && ingredient.isNotEmpty) {
        var formattedIngredient = ingredient;
        ingredients.add(formattedIngredient);
      } else {
        break;
      }
    }
    
    return ingredients;
  }
}
