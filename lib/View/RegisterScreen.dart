/// block ( block - cubit )
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';
import 'package:porject_n_01/Model/UserModel.dart';
import 'text_form_field.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';

  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var fireStore = FirebaseFirestore.instance;
  final  _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  GlobalKey<FormState> RegFormKey = GlobalKey<FormState>();

  final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: Colors.lightBlue.shade400,
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

  // @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        //reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: FractionalOffset.topCenter,
              child: Container(
                width: size.width,
                height: size.height * 0.30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue],
                      end: Alignment.topCenter,
                      begin: Alignment.bottomLeft),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Register',
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
            SizedBox(height: size.height*0.07),
            Align(
              child: Container(
                height: size.height*0.63,
                //color: Colors.red,
                child: Form(
                    key: RegFormKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFieldWidget(
                            labelText: 'Name',
                            controller: nameController,
                            validator: (value) {
                              var reqExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Name';
                              }else if (!reqExp.hasMatch(value)){
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFieldWidget(
                            labelText: 'Email',
                            controller: emailController,
                            validator: (value) {
                              var reqExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Email';
                              }else if (!reqExp.hasMatch(value)){
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: TextFieldWidget(
                            labelText: 'Password',
                            controller: passwordController,
                            obscureText: true,
                            validator: (value) {
                              //var reqExp = RegExp(r'^(?=.*?[0-9]).{6,}/pre>');
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }else if(value.length < 6){
                                return 'Please enter a valid password {6. min}';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              if (RegFormKey.currentState!.validate()) {
                                print('Valid Data');
                                FirebaseManager().signUpFunc(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context,
                                  name: nameController.text,);
                                Fluttertoast.showToast(
                                    msg: "Register Successful");
                              }
                            } on FirebaseAuthException catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Please enter a valid email");
                              print("mass: ${e.message}");
                            }
                            print(RegFormKey.currentState!.validate());
                            print(
                                '${nameController.text} - ${emailController.text} - ${passwordController.text}');
                          },
                          child: const Text('Register'),
                          style: outlineButtonStyle,
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
                              "Do you have an account?",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()));
                              },
                              child: const Text('Sign in'),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // void signUpFunc({required String email, required String password, required BuildContext context})async{
  //   try{
  //     if(RegFormKey.currentState!.validate()){
  //       await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
  //         postDetailsToFirestore(context)
  //       });
  //       Fluttertoast.showToast(msg: "Register Successful");
  //     }
  //   }on FirebaseAuthException catch(e){
  //
  //     Fluttertoast.showToast(msg: "Please enter a valid email");
  //     print("mass: ${e.message}");
  //
  //   }
  // }
  //
  // postDetailsToFirestore(BuildContext context)async{
  //   FirebaseFirestore fireStore = FirebaseFirestore.instance;
  //   User? user = _auth.currentUser;
  //   UserModel userModel = UserModel();
  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.password = passwordController.text;
  //   userModel.firstName = fNameController.text;
  //   userModel.lastName = lNameController.text;
  //
  //   await fireStore.collection('PersonInfo').doc(user.uid).set(userModel.toMap());
  //   Fluttertoast.showToast(msg: "Account created successfully");
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => LoginScreen()));
  //
  // }
}
