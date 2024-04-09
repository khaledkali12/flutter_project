import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'package:restarent_app/model/cart_list.dart';
import 'package:restarent_app/model/meal_info.dart';
import 'package:restarent_app/pages/login.dart';

// ignore: must_be_immutable
class MealDetails extends StatefulWidget {
  MealDetails({
    super.key,
    required this.mealname,
  });

  String mealname;

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  List<MealInfo> mealinfo = [];
  List<String> mealintegrity = [];

  bool loadingState = false;

  @override
  void initState() {
    getmealinfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      height: 270,
                    ),
                    Container(
                      color: const Color.fromARGB(255, 195, 192, 192),
                      height: 250,
                      width: double.maxFinite,
                      child: Image.network(
                        mealinfo[0].strMealThumb,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(mealinfo[0].strMeal,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ReadMoreText(
                        textAlign: TextAlign.justify,
                        mealinfo[0].strInstructions,
                        trimLines: 5,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'See more',
                        trimExpandedText: 'See less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                        lessStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 84, 82, 82)),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Integrity",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  mealintegrity.length,
                                  (index) => Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 100,
                                              width: 100,

                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                // color: Color.fromARGB(255, 195, 192, 192),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://www.themealdb.com/images/ingredients/${mealintegrity[index]}-Small.png")),
                                              ),
                                              // child: Padding(
                                              //   padding: const EdgeInsets.all(8.0),
                                              //   child: Text("hello "),
                                              // ),
                                            ),
                                          ),
                                          Text(
                                            mealintegrity[index],
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(mealinfo[0].strCategory)
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Area",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(mealinfo[0].strArea)
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    MaterialButton(
                      minWidth: 260,
                      height: 30,
                      onPressed: () async {
                        if (Cart.login == true) {
                          if (Cart.strMeal.contains(mealinfo[0].strMeal)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("You Are Added")));
                          } else {
                            Cart.imageMeal.add(mealinfo[0].strMealThumb);
                            Cart.strMeal.add(mealinfo[0].strMeal);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Added Successful")));
                          }
                        } else {
                          bool categorypage = true;

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage(
                              categoryPage: categorypage,
                            ),
                          ));
                        }
                      },
                      color: Theme.of(context).primaryColor,
                      child: const Text("Add cart"),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  getmealinfo() async {
    setState(() {
      loadingState = true;
    });

    http.Response response = await http.get(Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=${widget.mealname}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String data2 = response.body.toString();

      mealinfo = MealInfo.fromJsonArray(data);
      mealintegrity = MealInfo.extractIngredients(data2);
    }
    setState(() {
      loadingState = false;
    });
  }
}
