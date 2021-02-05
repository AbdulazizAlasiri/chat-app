import 'package:flutter/material.dart';
import 'package:flash_chat/components/action_button.dart';
import 'package:flash_chat/components/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  bool _showSpennar = false;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpennar,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextInputField(
                type: InputTypes.email,
                hintText: 'Enter your email.',
                onChange: (value) {
                  _email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextInputField(
                type: InputTypes.password,
                hintText: 'Enter your password.',
                onChange: (value) {
                  _password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              ActionButton(
                onPressed: () async {
                  setState(() {
                    _showSpennar = true;
                  });
                  try {
                    var user = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    setState(() {
                      _showSpennar = false;
                    });
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                  } catch (e) {
                    setState(() {
                      _showSpennar = false;
                    });
                    print(e);
                  }
                },
                color: Colors.lightBlueAccent,
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
