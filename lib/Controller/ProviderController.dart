import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';

class ProviderController with ChangeNotifier {
  File? image;
  String? _url;
  final imgPicker = ImagePicker();
  bool activeConnection = false;
  bool flag = false;

  downloadFromFireUrl(String? userId) async {
    flag = false;
    final storage = FirebaseStorage.instance;
    const destination = 'images/';
    try {
      await storage
          .ref(destination)
          .child(userId!)
          .getDownloadURL()
          .then((value) => {_url = value});
      flag = true;
      print('----- Download Done -----');
      //FirebaseManager().updateAvatar(url!, userId);
    } catch (e) {
      print('Error in download image: $e');
    }
    print('Image URL: $_url');
  }

  String? get url => _url;

  picker(String? userId) {
    downloadFromFireUrl(userId);
    print('Image URL: $_url');
    if (_url != null) {
      print('Case 1 Image From Firebase');
      return NetworkImage(_url!);
    }
    // else if (image?.path != null) {
    //   print('Case 2 Image From File');
    //   return FileImage(image!);
    // }
    else {
      print('Case 3 Image From Assets');
      return const AssetImage('assets/profile.jpg');
    }
  }

  downloadFromFireUrlChats(String? userId) {
    final storage = FirebaseStorage.instance;
    const destination = 'images/';
    try {
      storage
          .ref(destination)
          .child(userId!)
          .getDownloadURL()
          .then((value) => {_url = value});
      print('----- Download Done -----');
      //FirebaseManager().updateAvatar(url!, userId);
    } catch (e) {
      print('-----------Error in download image ---------');
    }
    print('Image URL: $_url');
  }

  pickerChats(String? userId) {
    downloadFromFireUrlChats(userId);
    print('Image URL: $_url');
    if (_url != null) {
      print('Case 1 Image From Firebase');
      return NetworkImage(_url!);
    }
    // else if (image?.path != null) {
    //   print('Case 2 Image From File');
    //   return FileImage(image!);
    // }
    else {
      print('Case 3 Image From Assets');
      return const AssetImage('assets/profile.jpg');
    }
  }

  Future uploadImage() async {
    final pickedImage = await imgPicker.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
    notifyListeners();
  }

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        activeConnection = true;
      }
    } on SocketException catch (_) {
      activeConnection = false;
    }
    notifyListeners();
  }
}
