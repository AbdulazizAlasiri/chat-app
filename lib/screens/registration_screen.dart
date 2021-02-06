import 'package:flutter/material.dart';
import 'package:flash_chat/components/action_button.dart';
import 'package:flash_chat/components/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = '/register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  bool _showSpenner = false;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpenner,
      child: Scaffold(
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
                    height: 300.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextInputField(
                  type: InputTypes.email,
                  hintText: 'Enter your emai;',
                  onChange: (value) {
                    _email = value;
                  }),
              SizedBox(
                height: 8.0,
              ),
              TextInputField(
                hintText: 'Enter your password',
                type: InputTypes.password,
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
                    _showSpenner = true;
                  });
                  try {
                    var newUser = await _auth.createUserWithEmailAndPassword(
                        email: _email, password: _password);

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.route);
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      _showSpenner = false;
                    });
                    print(e.code);
                  }
                },
                color: Colors.blueAccent,
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
