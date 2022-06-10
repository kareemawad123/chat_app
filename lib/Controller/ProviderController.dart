import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProviderController with ChangeNotifier{
  File? image;
  final imgPicker = ImagePicker();
  bool ActiveConnection = false;
  String imageEnc = '';
  var imageDec;

  encodeImage(File image) {
    String imageEnc;
    final bytes = File(image.path).readAsBytesSync();
    return imageEnc =   const Base64Codec().encode(bytes);
  }
  decodeImage(String? imageEnc ) {
    dynamic imageDec;
    return imageDec =  const Base64Codec().decode(imageEnc.toString());
  }
  Future uploadImage() async {
    final pickedImage =
    await imgPicker.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
    // imageEnc = encodeImage(image!);
    // print('Encode: ${imageEnc}');
    // print('Encode: ${imageEnc.runtimeType}');
    notifyListeners();
  }
  picker() {
    if (image?.path != null) {
      return FileImage(image!);
    } else {
      return const AssetImage('assets/profile.jpg');
    }
  }

  Future CheckUserConnection() async {
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