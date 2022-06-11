import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';

class ProviderController with ChangeNotifier {
  File? image;
  String? url;
  final imgPicker = ImagePicker();
  bool ActiveConnection = false;
  String imageEnc = '';
  var imageDec;

  // Future uploadImageToFire(String? userId) async {
  //   const destination = 'images/';
  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination).child(userId!);
  //     await ref.putFile(image!);
  //     print('Upload Done');
  //   } catch (e) {
  //     print('error upload occurred');
  //   }
  // }
  //
  downloadFromFireUrl(String? userId) async {
    final storage = FirebaseStorage.instance;
    const destination = 'images/';
    try {
      await storage
          .ref(destination)
          .child(userId!)
          .getDownloadURL()
          .then((value) => {url = value});
      //FirebaseManager().updateAvatar(url!, userId);
    } catch (e) {
      print('-----------Error in download image ---------');
    }
    print('Image URL: $url');
    notifyListeners();
  }

  Future uploadImage() async {
    final pickedImage = await imgPicker.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
    notifyListeners();
  }

  picker(String? userId) {
    downloadFromFireUrl(userId);
    print('Image URL: $url');
    if (url != null) {
      print('Case 1 Image From Firebase');
      return NetworkImage(url!);
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

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
    }
    notifyListeners();
  }
}
