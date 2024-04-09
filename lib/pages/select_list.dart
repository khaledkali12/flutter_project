import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'package:restarent_app/model/category_model.dart';

import 'package:restarent_app/model/country_model.dart';
import 'package:restarent_app/model/meal_info.dart';
import 'package:restarent_app/pages/cart.dart';
import 'package:restarent_app/pages/list_category.dart';

// ignore: must_be_immutable
class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  List<Category> categories = [];
  List<MealInfo> mealinfo1 = [];

  List<Country> countries = [];
  String x = "meal";
  int s = 0;

  bool loadingState = false;
  bool loadingState2 = false;

  @override
  void initState() {
    getmealinfo1();
    getCategoryList();
    getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartWid(),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: loadingState2
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 195, 192, 192),
                          image: DecorationImage(
                              image: NetworkImage(mealinfo1[0].strMealThumb),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 175),
                      width: double.maxFinite,
                      height: 25,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: s == 1
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: TextButton(
                        onPressed: () {
                          getCategoryList();
                          s = 1;
                          setState(() {});
                        },
                        child: Text(
                          "By Category",
                          style: TextStyle(
                              color: s == 1 ? Colors.white : Colors.blue),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: s == 0
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: TextButton(
                        onPressed: () {
                          getCountryList();
                          s = 0;
                          setState(() {});
                        },
                        child: Text(
                          "By Country",
                          style: TextStyle(
                              color: s == 0 ? Colors.white : Colors.blue),
                        )),
                  ),
                ],
              ),

              // SizedBox(
              //   height: 20,
              // ),
              loadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        children: List.generate(
                            s == 0 ? countries.length : categories.length,
                            (index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ListWid(
                                  x: s == 0
                                      ? countries[index].strArea
                                      : categories[index].strCategory,
                                  s: s,
                                ),
                              ));
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                  top: 15, left: 16, right: 16),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 2),
                                      blurRadius: 15,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xFFFFFFFF)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Row(children: [
                                  Expanded(
                                    child: s == 0
                                        ? Text(countries[index].strArea)
                                        : Text(categories[index].strCategory),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon:
                                          SvgPicture.asset("assets/click.svg"),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => ListWid(
                                            x: s == 0
                                                ? countries[index].strArea
                                                : categories[index].strCategory,
                                            s: s,
                                          ),
                                        ));
                                      },
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
            ]),
    );
  }

  getCountryList() async {
    setState(() {
      loadingState = true;
    });

    http.Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/list.php?a=list"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      countries = Country.fromJsonArray(data);
    }
    setState(() {
      loadingState = false;
    });
  }

  getCategoryList() async {
    setState(() {
      loadingState = true;
    });

    http.Response response2 = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/list.php?c=list"));
    if (response2.statusCode == 200) {
      Map<String, dynamic> data2 = jsonDecode(response2.body);

      categories = Category.fromJsonArray(data2);
    }
    setState(() {
      loadingState = false;
    });
  }

  getmealinfo1() async {
    setState(() {
      loadingState2 = true;
    });

    http.Response response3 = await http
        .get(Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php"));
    if (response3.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response3.body);

      mealinfo1 = MealInfo.fromJsonArray(data);
    }
    setState(() {
      loadingState2 = false;
    });
  }
}
