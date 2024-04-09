import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restarent_app/model/cart_list.dart';

class CartWid extends StatefulWidget {
  const CartWid({super.key});

  @override
  State<CartWid> createState() => _CartWidState();
}

class _CartWidState extends State<CartWid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title:const Text("Cart"),
          centerTitle: true,
        ),
        body: Cart.strMeal.isEmpty
            ?const Center(child: Text("Cart Is Empty"))
            : ListView(
                children: List.generate(
                  Cart.strMeal.length,
                  (index) => Container(
                    height: 100,
                    margin: index == Cart.strMeal.length - 1
                        ? const EdgeInsets.all(16)
                        : const EdgeInsets.only(top: 15, left: 16, right: 16),
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
                        CircleAvatar(
                          backgroundImage: NetworkImage(Cart.imageMeal[index]),
                          radius: 40,
                          backgroundColor:const Color.fromARGB(255, 195, 192, 192),
                        ),
                        const SizedBox(width: 8,),
                        Expanded(
                            child: Text(
                          Cart.strMeal[index],
                          textAlign: TextAlign.center,
                          // style: TextStyle(fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                        IconButton(
                          icon: SvgPicture.asset(
                            "assets/rubbish-bin-svgrepo-com.svg",
                            // ignore: deprecated_member_use
                            color: Colors.red,
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () {
                            Cart.strMeal.removeAt(index);
                            Cart.imageMeal.removeAt(index);
                            setState(() {});
                          },
                        )
                      ]),
                    ),
                  ),

                  // Container(
                  //       width: 100,
                  //       height: 50,
                  //       color: Colors.orange,
                  //       child: Text(Cart.strMeal[index]),
                  //     )
                ),
              ));
  }
}
