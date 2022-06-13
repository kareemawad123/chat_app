import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:porject_n_01/Model/Constants.dart';
import 'package:porject_n_01/Controller/DatabaseManager.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Controller/ProviderController.dart';
import '../Model/UserModel.dart';
import 'HomeScreen.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'ChatScreen';

  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  String message = '';
  User? user = FirebaseAuth.instance.currentUser;
  var fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final args = ModalRoute.of(context)!.settings.arguments as ProfileData;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xff113953)),
        child: Column(
          children: [
            Container(
              height: height * 0.12,
              width: width,
              color: const Color(0xff113953),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30, right: 20),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 0, top: 30, right: 20),
                    width: 50,
                    height: 50,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: fireStore
                            .collection('PersonInfo')
                            .where('uid', isEqualTo: args.chatId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[0]['avatar']),
                                )
                              : const CircularProgressIndicator.adaptive();
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: Text(
                      args.username!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Nisebuschgardens',
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
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: fireStore
                      .collection(allMessages)
                      .doc(args.collection)
                      .collection(messagesDetails)
                      .orderBy(messageTime, descending: true)
                      .snapshots(),
                  builder: (context, snapShot) {
                    return snapShot.hasData
                        ? AnimationLimiter(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              reverse: true,
                              itemCount: snapShot.data?.docs.length,
                              itemBuilder: (context, index) {
                                //return Text('Length: ${snapShot.data?.docs.length}');
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: snapShot.data?.docs[index]
                                                  [currentId] ==
                                              user!.uid
                                          ?

                                          /// My Current Message
                                          Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 15,
                                                              right: 10,
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              left: 20,
                                                              right: 15,
                                                              bottom: 15),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xff113953),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  40),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  40),
                                                          topLeft:
                                                              Radius.circular(
                                                                  40),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        snapShot.data
                                                                ?.docs[index]
                                                            [messageData],
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          :

                                          /// User Message
                                          Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 15,
                                                      right: 10,
                                                      left: 10),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15,
                                                          left: 20,
                                                          right: 15,
                                                          bottom: 15),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.lightBlue,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(40),
                                                      bottomRight:
                                                          Radius.circular(40),
                                                      topLeft:
                                                          Radius.circular(40),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    snapShot.data?.docs[index]
                                                        [messageData],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : snapShot.hasError
                            ? const Text('Error')
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  CircularProgressIndicator(),
                                ],
                              );
                  },
                ),
              ),
            ),

            /// Massage Send Box
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        labelStyle: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        hintText: 'Type your message',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 0),
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onChanged: (value) => setState(() {
                        message = value;
                      }),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  GestureDetector(
                    //onTap: messageController.text.isEmpty ? null : sendMessage,
                    onTap: () {
                      messageController.text.isEmpty
                          ? null
                          : sendMessage(args.collection);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff113953),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage(String? collection) async {
    FocusScope.of(context).unfocus();
    print('Collection: $collection');
    var fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection(allMessages)
        .doc(collection)
        .set({chatId: collection});
    await fireStore
        .collection(allMessages)
        .doc(collection)
        .collection(messagesDetails)
        .add({
      messageData: message,
      currentId: user!.uid,
      messageTime: DateTime.now(),
    });
    print('Done');
    messageController.clear();
  }
}
