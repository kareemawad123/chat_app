import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:porject_n_01/View/ChatScreen.dart';
import 'package:porject_n_01/View/LoginScreen.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';
import 'package:porject_n_01/Model/UserModel.dart';
import 'package:provider/provider.dart';
import '../Model/Constants.dart';
import '../Controller/AuthenticationFunc.dart';
import '../Controller/ProviderController.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ProfileData {
  String? username;
  String? email;
  String? chatId;
  String? collection;

  ProfileData({this.username, this.collection, this.email, this.chatId});
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationServices _auth = AuthenticationServices();
  var fireStore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel userModelLogged = UserModel();
  TextEditingController nameController = TextEditingController();
  List allData = [];
  String collection = '';
  int _selectedIndex = 0;

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Messages');

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }

  delayFunc() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        Provider.of<ProviderController>(context, listen: false)
            .pickerChats(user!.uid);
        print('Delay Done');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    delayFunc();
    getData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected Item: $_selectedIndex');
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    Provider.of<ProviderController>(context, listen: false).image = null;
    print(
        'Image---${Provider.of<ProviderController>(context, listen: false).image}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> _pages = <Widget>[
      /// Chats Page
      Center(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff113953)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.14,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 30, top: 30),
                          width: 50,
                          height: 50,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: fireStore
                                  .collection('PersonInfo').where('uid', isEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {

                                return snapshot.hasData ? CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!.docs[0]['avatar']),
                                ) : const CircularProgressIndicator.adaptive();
                              }),
                        ),
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.only(left: 30, top: 30),
                          child: const Text(
                            'Chats',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Nisebuschgardens',
                            ),
                          ),
                        )),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, top: 30, right: 20),
                          child: IconButton(
                            onPressed: () {
                              logOutDialogueBox(context);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.rightFromBracket,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: fireStore
                            .collection('PersonInfo')
                            .orderBy('name', descending: true)
                            .snapshots(),
                        builder: (context, snapShot) {
                          return snapShot.hasData
                              ? ListView.builder(
                                  itemCount: snapShot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    //getData();
                                    if (snapShot.data?.docs[index].id !=
                                        user!.uid) {
                                      return GestureDetector(
                                        onTap: () {
                                          getData();
                                          print('DDDDD');
                                          print(allData);
                                          for (var element in allData) {
                                            print(
                                                'Elementsssss: ${element[chatId]}');
                                            if (element[chatId]
                                                    .toString()
                                                    .split('+')
                                                    .contains(user!.uid) &&
                                                element[chatId]
                                                    .toString()
                                                    .split('+')
                                                    .contains(snapShot.data
                                                        ?.docs[index]['uid'])) {
                                              collection = element[chatId];
                                              print('True');
                                              print('Collection: $collection');
                                              break;
                                            } else {
                                              collection =
                                                  '${user!.uid}+${snapShot.data?.docs[index]['uid']}';
                                              print(
                                                  'Else Collection: $collection');
                                            }
                                          }
                                          Navigator.pushNamed(
                                              context, ChatScreen.routeName,
                                              arguments: ProfileData(
                                                  username: snapShot.data
                                                      ?.docs[index][userName],
                                                  email: snapShot.data
                                                      ?.docs[index][userEmail],
                                                  chatId: snapShot.data
                                                      ?.docs[index][userId],
                                                  collection: collection));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 10,
                                              bottom: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(snapShot
                                                                .data
                                                                ?.docs[index]
                                                            ['avatar']),
                                                    maxRadius: 30,
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    color: Colors.transparent,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          snapShot.data
                                                                  ?.docs[index]
                                                              [userName],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          snapShot.data
                                                                  ?.docs[index]
                                                              [userEmail],
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.grey
                                                                  .shade600,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : snapShot.hasError
                                  ? const Text('Error')
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        CircularProgressIndicator.adaptive()
                                      ],
                                    );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      /// Profile Page
      Container(
        decoration: const BoxDecoration(
          color: Color(0xff113953),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'My Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: 'Nisebuschgardens',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.55,
              //color: Colors.black,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        bottom: 35,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: innerHeight * 0.75,
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: fireStore
                                    .collection('PersonInfo')
                                    .where(userId, isEqualTo: user?.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 100,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  const Text("Name: ",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
                                                          color: Colors.blue)),
                                                  Text(
                                                      "${snapshot.data?.docs[0][userName]}",
                                                      style: const TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 20,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  const Text("Email: ",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
                                                          color: Colors.blue)),
                                                  Text(
                                                      snapshot.data!.docs[0]
                                                          [userEmail],
                                                      style: const TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: const [
                                                  Text("Age: ",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
                                                          color: Colors.blue)),
                                                  Text("22",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: const [
                                                  Text("Gender: ",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20,
                                                          color: Colors.blue)),
                                                  Text("Male",
                                                      style: TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 20)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : snapshot.hasError
                                          ? const Text('ERROR')
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                CircularProgressIndicator(),
                                              ],
                                            );
                                }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: innerWidth * 0.3,
                        right: innerWidth * 0.3,
                        child: SizedBox(
                          width: innerWidth * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              openDialogueBox(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff113953),
                            ),
                            child: const Text('Edit',
                                style: TextStyle(fontFamily: 'Nunito')),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 130,
                            height: 130,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: fireStore
                                    .collection('PersonInfo').where('uid', isEqualTo: user!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {

                                  return snapshot.hasData ? CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!.docs[0]['avatar']),
                                  ) : const CircularProgressIndicator.adaptive();
                                }),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 80,
                          right: 90,
                          child: Consumer<ProviderController>(
                            builder: (context, provider, child) {
                              return RawMaterialButton(
                                onPressed: () {
                                  provider.uploadImage().whenComplete(() {
                                    print('Task 1');
                                    FirebaseManager()
                                        .uploadImageToFire(
                                            provider.image, user!.uid)
                                        .whenComplete(() => {
                                              provider
                                                  .downloadFromFireUrl(
                                                      user!.uid)
                                                  .whenComplete(() => {
                                                        setState(() {
                                                          FirebaseManager()
                                                              .updateAvatar(
                                                                  provider.url!,
                                                                  user!.uid);
                                                          print('Task 2');
                                                        })
                                                      })
                                            });
                                  });
                                  // provider.url =
                                  //     FirebaseManager().downloadFromFireUrl(user!.uid);
                                  //provider.downloadFromFireUrl(user!.uid);
                                },
                                fillColor: const Color(0xff113953),
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                              );
                            },
                          )),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    ];
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: const Color(0xff113953),
        items: const <Widget>[
          Icon(Icons.wechat, size: 30),
          Icon(Icons.account_circle_outlined, size: 30),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  logOutDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Log Out'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut().then((result) {
                    Navigator.popAndPushNamed(context, LoginScreen.routeName);
                    (print('-Done-'));
                  });
                  Navigator.popAndPushNamed(context, LoginScreen.routeName);
                },
                child: const Text('Ok'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit User Details'),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  submitAction(context);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    FirebaseManager().updateData(nameController.text, user!.uid);
    nameController.clear();
  }
}
