
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  String? uid;
  String? name;
  String? gender = '';
  int? age = 0;
  String? email;
  String? password;
  final List<String>? chatList ;
  final String _avatar = 'https://firebasestorage.googleapis.com/v0/b/projectn01.appspot.com/o/images%2Fprofile.png?alt=media&token=5db803ec-de0d-48c7-877e-a784d0011a0c';
  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.password,this.chatList,});

  //     // this.gender,
  //     // this.age
  // factory UserModel.fromJsonChatList(Map<String, dynamic> json) {
  //   return UserModel(
  //     chatList : json['uid'],
  //     // gender: json['gender'],
  //     // age: json['age'],
  //   );
  // }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      // gender: json['gender'],
      // age: json['age'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      "timestamp": DateTime.now(),
      'avatar' : _avatar
      // 'gender': gender,
      // 'age': age,
    };
  }


}
