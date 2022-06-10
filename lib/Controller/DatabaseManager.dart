import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import '../View/LoginScreen.dart';
import '../Model/UserModel.dart';
import 'dart:io';

class FirebaseManager{
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('PersonInfo');
  final _auth = FirebaseAuth.instance;

  static Future<User?> signInFunc(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      user = userCredential.user;
      Fluttertoast.showToast(msg: "Login Successful");
    } on FirebaseAuthException catch (e) {
      if (e.message == 'Given String is empty or null') {
        Fluttertoast.showToast(msg: "Please enter a valid email");
      } else if (e.message == "The email address is badly formatted.") {
        Fluttertoast.showToast(msg: "Please enter a valid email");
      } else {
        Fluttertoast.showToast(msg: "The email or password incorrect");
      }
    }
    return user;
  }

  void signUpFunc({
    required String email,
    required String password,
    required BuildContext context,
    required String name,
  }) async {
    await _auth
        .createUserWithEmailAndPassword(email: email.trim(), password: password)
        .then((value) => {
              postDetailsToFirestore(context,
                  name: name, password: password),
            });
  }

  postDetailsToFirestore(BuildContext context,
      {required String name,

      required String password}) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.password = password;
    userModel.name = name;

    await fireStore
        .collection('PersonInfo')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushNamed(
      context,
      LoginScreen.routeName,
    );
  }
  Future setImage (String imageEncode, String uid) async {
    print('Image: $imageEncode');
    return await profileList.doc(uid).update({
      'image': imageEncode
    });
  }
  Future updateUser(String name, String uid) async {
    return await profileList.doc(uid).set({
      'name': name
    });
  }
  updateData(String name, String userID) async {
    await FirebaseManager().updateUser(name, userID);
  }
  Future uploadImageToFire (File? image, String? userId) async{
    const destination = 'images/';
    try {
      final ref = FirebaseStorage.instance
          .ref(destination)
          .child(userId!);
      await ref.putFile(image!);
      print('Upload Done');
    } catch (e) {
      print('error occured');
    }
  }

  downloadFromFireUrl(String? userId) async{
    String? url;
    final storage = FirebaseStorage.instance;
    const destination = 'images/';
    await storage.ref(destination).child(userId!).getDownloadURL().then((value) => {url = value})
        .catchError((error) => {});
    print('Image URL: $url');
    return url;
  }

}
