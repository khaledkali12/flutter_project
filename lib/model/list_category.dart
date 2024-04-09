class MealList {
    String strMeal;
    String strMealThumb;
    String idMeal;

    MealList({
        required this.strMeal,
        required this.strMealThumb,
        required this.idMeal,
    });

    factory MealList.fromJson(Map<String, dynamic> json) => MealList(
        strMeal: json["strMeal"],
        strMealThumb: json["strMealThumb"],
        idMeal: json["idMeal"],
    );

    Map<String, dynamic> toJson() => {
        "strMeal": strMeal,
        "strMealThumb": strMealThumb,
        "idMeal": idMeal,
    };


      static List<MealList> fromJsonArray(Map<String,dynamic> jsonArray) {
    //return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
    return List<MealList>.from(jsonArray["meals"].map((e) => MealList.fromJson(e)));
  }
}