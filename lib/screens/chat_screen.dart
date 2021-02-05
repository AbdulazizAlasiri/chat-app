import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _textEditingController = TextEditingController();
  var loggedInUser;

  String message;

  CollectionReference messagesRef;
  @override
  void initState() {
    super.initState();
    messagesRef = _firestore.collection('messages');
    getCurrentUser();
  }

  void getCurrentUser() async {
    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
      loggedInUser = _auth.currentUser;
    }
  }

  void getMessagesStream() async {
    await for (var snapshot in messagesRef.snapshots()) {
      for (var mes in snapshot.docs) {
        print(mes.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessagesStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final List<QueryDocumentSnapshot> messages = snapshot.data.docs;
                List<ChatBubble> messagesWidget = [];

                for (QueryDocumentSnapshot msg in messages) {
                  final String messageText = msg.data()['message'];
                  final String messageSender = msg.data()['email'];

                  final ChatBubble messageBubble = ChatBubble(
                    text: messageText,
                    from: messageSender,
                  );

                  messagesWidget.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    children: messagesWidget,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (message != null) {
                        _textEditingController.clear();

                        _firestore.collection('messages').add(<String, dynamic>{
                          'email': loggedInUser.email,
                          'message': message,
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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
}

enum BubbleType { sender, recever, info }

class ChatBubble extends StatelessWidget {
  ChatBubble({this.from, @required this.text, this.time});
  final String from;
  final String text;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(from),
        Material(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}
