import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:restarent_app/model/cart_list.dart';
import 'package:restarent_app/pages/select_list.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.categoryPage});

  bool categoryPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController(text: "eve.holt@reqres.in");
  var passwordController = TextEditingController(text: "cityslicka");
  bool firstSubmit = false;
  bool loadingState = false;
  bool islogin = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage("assets/pasta.jpg"),
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                      TextFormField(
                        autovalidateMode: firstSubmit
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required";
                          } else if (!value.contains("@")) {
                            return "wrong email address";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: const InputDecoration(label: Text("Email")),
                      ),
                      TextFormField(
                        autovalidateMode: firstSubmit
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(label: Text("password")),
                      ),
                      loadingState
                          ? const ElevatedButton(
                              onPressed: null,
                              child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Theme.of(context).primaryColor)),
                              onPressed: () {
                                login();
                              },
                              child: const Text("Login"))
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  if (widget.categoryPage) {
                    Navigator.pop(context, 
                    );
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const SelectCategory();
                    }));
                  }
                },
                child: const Text(
                  "Skip Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }

  void login() async {
    firstSubmit = true;

    if (!formKey.currentState!.validate()) return;

    String jsonBody = jsonEncode(
      {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );

    setState(() {
      loadingState = true;
    });

    http.Response response =
        await http.post(Uri.parse("https://reqres.in/api/login"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonBody);
    if (response.statusCode == 200) {
      Cart.login = true;
      islogin = true;
      // ignore: use_build_context_synchronously
      if (widget.categoryPage) {
        widget.categoryPage = false;

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const SelectCategory();
        }));
      }
    } else {
      String errorMsg = jsonDecode(response.body)["error"];

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMsg)));
    }

    setState(() {
      loadingState = false;
    });
  }
}
