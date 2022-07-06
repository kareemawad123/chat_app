import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:porject_n_01/View/ChatScreen.dart';
import 'package:provider/provider.dart';
import 'View/HomeScreen.dart';
import 'View/LoginScreen.dart';
import 'View/RegisterScreen.dart';
import 'Controller/ProviderController.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animations/animations.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProviderController(),
      child: MaterialApp(
          title: 'Login',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF2661FA),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => RegisterScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ChatScreen.routeName: (context) => ChatScreen(),
          },
          home: AnimatedSplashScreen(
              duration: 1000,
              splash: const Icon(Icons.wechat, color: Colors.white,size: 100,),
              nextScreen: const LoginScreen(),
              splashTransition: SplashTransition.fadeTransition,
              //pageTransitionType: PageTransitionType.scale,
              backgroundColor: const Color(0xff113953))),
    );
  }
}

class ImageFirebase extends StatefulWidget {
  const ImageFirebase({Key? key}) : super(key: key);

  @override
  State<ImageFirebase> createState() => _ImageFirebaseState();
}

class _ImageFirebaseState extends State<ImageFirebase> {
  File? image;
  final imgPicker = ImagePicker();
  Uint8List? imageBytes;
  String? url;
  final storage = FirebaseStorage.instance;

  Future uploadImage() async {
    final pickedImage =
    await imgPicker.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
  }
  picker() {
    if (image?.path != null) {
      return FileImage(image!);
    } else if(url != null){
      return Image.network(url!).image;
    }else {
      return const AssetImage('assets/profile.jpg');
    }
  }
  Future uploadToFire () async{
    final fileName = basename(image!.path);
    print('name: ${fileName}');
    const destination = 'images/';
    try {
      final ref = FirebaseStorage.instance
          .ref(destination)
          .child(fileName);
      await ref.putFile(image!);
      print('Upload Done');
    } catch (e) {
      print('error occured');
    }
  }
   downloadFromFire() async{
     const destination = 'images/';
     final fileName = basename(image!.path);
     await storage.ref(destination).child(fileName).getData(100000000).then((value) => {imageBytes = value})
         .catchError((error) => {});
     print('ImageBytes: ${imageBytes}');
  }
  downloadFromFireUrl() async{
    const destination = 'images/';
    final fileName = basename(image!.path);
    await storage.ref(destination).child(fileName).getDownloadURL().then((value) => {url = value})
        .catchError((error) => {});
    print('ImageBytes: ${imageBytes}');
  }
  displayImage() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!).image;
    } else if(url != null){
      return Image.network(url!).image;
  } else{
      return const AssetImage('assets/profile.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 300,
              width: 300,
              child: Image(
                image: picker(),
              ),
            ),),
          ElevatedButton(
              onPressed: (){
                uploadImage().whenComplete(() => {
                  print('Image Done'),
                  setState(() {
                  })
                });
              }, child: const Text('Chose Image')),
          ElevatedButton(
              onPressed: (){
                if (image?.path != null){
                  print('11111111');
                  uploadToFire();
                }
                else{
                  print("Don't Uploaded");
                }
              }, child: const Text('Upload Image')),
          ElevatedButton(
              onPressed: (){
                downloadFromFireUrl().whenComplete(() => {
                  print('Download Done'),
                  setState(() {
                  })
                });
              }, child: const Text('Get Image')),
          Center(
            child: Container(
              height: 300,
              width: 300,
              child: Image(
                image: displayImage(),
              ),
            ),),
        ],
      ),
    );
  }
}


class ImageBase64 extends StatefulWidget {
  const ImageBase64({Key? key}) : super(key: key);

  @override
  State<ImageBase64> createState() => _ImageBase64State();
}

class _ImageBase64State extends State<ImageBase64> {
  File? image;
  var bytes;
  final imgPicker = ImagePicker();
  String? base64String;

  String _imageFile = '';
  var _decodeImage;

  Future uploadImage() async {
    final pickedImage =
    await imgPicker.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
  }
  picker() {
    if (image?.path != null) {
      return FileImage(image!);
    } else {
      return const AssetImage('assets/profile.jpg');
    }
  }
  decoded() {
    if (_decodeImage != null) {
      return Image.memory(_decodeImage).image;
    } else {
      return const AssetImage('assets/profile.jpg');
    }
  }
   encodeImage(File image) {
    String imageEnc;
       final bytes = File(image.path).readAsBytesSync();
      return imageEnc =   const Base64Codec().encode(bytes);
  }
  decodeImage(String? imageEnc ) {
    dynamic imageDec;
    return imageDec =  const Base64Codec().decode(imageEnc.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 300,
                width: 300,
                child: Image(
                    image: picker(),
              ),
            ),),
                ElevatedButton(
                    onPressed: (){
                      //print('Flie:${image!.path}');
                      uploadImage().whenComplete(() => {
                         //bytes = File(image!.path).readAsBytesSync(),
                        _imageFile = encodeImage(image!),
                        //print('Encode: ${bytes}'),
                         //_imageFile =  const Base64Codec().encode(bytes),
                        print('Encode: ${_imageFile}'),
                        print('Encode: ${_imageFile.runtimeType}'),
                        _decodeImage = decodeImage(_imageFile),
                        //_decodeImage = const Base64Codec().decode(_imageFile.toString()),
                        print('Decoder: $_decodeImage'),
                        print('Decoder: ${_decodeImage.runtimeType}'),
                      setState(() {
                      })
                      });
                    }, child: const Text('Uplod Image')),
            Center(
              child: Container(
                height: 300,
                width: 300,
                child: Image(
                  image: decoded(),
                ),
              ),),
          ],
        ),
      ),
    );
  }
}

class _TransitionsHomePage extends StatefulWidget {
  @override
  _TransitionsHomePageState createState() => _TransitionsHomePageState();
}

class _TransitionsHomePageState extends State<_TransitionsHomePage> {
  bool _slowAnimations = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Material Transitions')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                _TransitionListTile(
                  title: 'Container transform',
                  subtitle: 'OpenContainer',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Shared axis',
                  subtitle: 'SharedAxisTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Fade through',
                  subtitle: 'FadeThroughTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
                _TransitionListTile(
                  title: 'Fade',
                  subtitle: 'FadeScaleTransition',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 0.0),
          SafeArea(
            child: SwitchListTile(
              value: _slowAnimations,
              onChanged: (bool value) async {
                setState(() {
                  _slowAnimations = value;
                });
                // Wait until the Switch is done animating before actually slowing
                // down time.
                if (_slowAnimations) {
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                }
                timeDilation = _slowAnimations ? 4.0 : 1.0;
              },
              title: const Text('Slow animations'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransitionListTile extends StatelessWidget {
  const _TransitionListTile({
    this.onTap,
    required this.title,
    required this.subtitle,
  });

  final GestureTapCallback? onTap;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      leading: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black54,
          ),
        ),
        child: const Icon(
          Icons.play_arrow,
          size: 35,
        ),
      ),
      onTap: onTap,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.lightBlueAccent,
      height: MediaQuery.of(context).size.height,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topCenter,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade600, Colors.orangeAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft),
              color: Colors.orange,
              borderRadius:
                  const BorderRadius.only(bottomLeft: Radius.circular(100.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade600, Colors.orangeAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft),
                  color: Colors.orange,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'E-MAIL'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
