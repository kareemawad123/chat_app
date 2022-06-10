
class UserModel {
  String? uid;
  String? name;
  String? gender = '';
  int? age = 0;
  String? email;
  String? password;
  final List<String>? chatList ;

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
      // 'gender': gender,
      // 'age': age,
    };
  }

}
