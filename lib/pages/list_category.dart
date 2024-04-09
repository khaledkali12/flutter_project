import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restarent_app/model/list_category.dart';

import 'package:restarent_app/pages/category_details.dart';

// ignore: must_be_immutable
class ListWid extends StatefulWidget {
  ListWid({super.key, required this.x, required this.s});
  String x;
  int s;

  @override
  State<ListWid> createState() => _ListWidState();
}

class _ListWidState extends State<ListWid> {
  List<MealList> listcategories = [];
  bool loadingState = false;

  @override
  void initState() {
    getListcategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("${widget.x} Meals"),
        centerTitle: true,
      ),
      body: loadingState
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                itemCount: listcategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width < 480
                        ? 2
                        : MediaQuery.of(context).size.width < 680
                            ? 3
                            : MediaQuery.of(context).size.width < 800
                                ? 4
                                : MediaQuery.of(context).size.width < 1280
                                    ? 5
                                    : 6,
                    childAspectRatio: 192 / 226,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MealDetails(
                          mealname: listcategories[index].strMeal,
                        ),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    listcategories[index].strMealThumb),
                                fit: BoxFit.cover),
                            color: const Color.fromARGB(255, 195, 192, 192),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    bottomLeft: Radius.circular(16),
                                  )),
                              width: double.maxFinite,
                              height: 45,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  
                                  maxLines: 2,
                                  listcategories[index].strMeal,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(

                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  getListcategory() async {
    setState(() {
      loadingState = true;
    });

    http.Response response = await http.get(Uri.parse(widget.s == 0
        ? "https://www.themealdb.com/api/json/v1/1/filter.php?a=${widget.x}"
        : "https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.x}"));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      listcategories = MealList.fromJsonArray(data);
    }
    setState(() {
      loadingState = false;
    });
  }
}
