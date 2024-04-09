

class Category {
  
    String strCategory;

    Category({
        required this.strCategory,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        strCategory: json["strCategory"],
    );

    Map<String, dynamic> toJson() => {
        "strCategory": strCategory,
    };
    static List<Category> fromJsonArray(Map<String,dynamic> jsonArray) {
    //return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
    return List<Category>.from(jsonArray["meals"].map((e) => Category.fromJson(e)));
  }
}
