

class Country {
  
    String strArea;

    Country({
        required this.strArea,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        strArea: json["strArea"],
    );

    Map<String, dynamic> toJson() => {
        "strArea": strArea,
    };
    static List<Country> fromJsonArray(Map<String,dynamic> jsonArray) {
    //return jsonArray.map((e) => CountryModel.fromJson(e)).toList();
    return List<Country>.from(jsonArray["meals"].map((e) => Country.fromJson(e)));
  }
}
