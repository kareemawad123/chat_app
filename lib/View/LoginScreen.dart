import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';
import 'package:provider/provider.dart';
import '../Controller/ProviderController.dart';
import 'text_form_field.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool ActiveConnection = false;

  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: const Color(0xff113953),
    primary: Colors.white,
    minimumSize: const Size(150, 40),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(20)),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        reverse: false,
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: FractionalOffset.topCenter,
                child: Container(
                  width: size.width,
                  height: size.height * 0.30,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Color(0xff113953),],
                        end: Alignment.topCenter,
                        begin: Alignment.bottomLeft),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontFamily: 'Nisebuschgardens',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.10,
              ),
              SizedBox(
                //height: size.height * 0.5,
                // color: Colors.lightBlueAccent,
                child: Form(
                    key: loginFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFieldWidget(
                            labelText: 'Email',
                            controller: emailController,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFieldWidget(
                            labelText: 'Password',
                            controller: passwordController,
                            obscureText: true,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 20),
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                        ),
                        Consumer<ProviderController>(
                          builder: (context, provider, child) {
                            return ElevatedButton(
                              onPressed: () async {
                                provider.checkUserConnection();
                                 if (provider.activeConnection == true) {
                                  print('DDone');
                                  User? user = await FirebaseManager.signInFunc(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context);
                                  print(user);
                                  if (user != null) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()));
                                  }
                                } else {
                                  print('Not Done');
                                  Fluttertoast.showToast(msg: 'Please check your internet connection');
                                }

                              },
                              style: outlineButtonStyle,
                              child: const Text(
                                'Login',
                              ),
                            );
                          },
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(children: const <Widget>[
                              Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 30, right: 10),
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ))),
                              Text(
                                'or',
                                style: TextStyle(color: Colors.black),
                              ),
                              Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 30, left: 10),
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ))),
                            ])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()));
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
