import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

import '../constants.dart';

enum InputTypes { password, email }

class TextInputField extends StatelessWidget {
  TextInputField({this.hintText, @required this.onChange, this.type});
  final String hintText;
  final Function onChange;
  final InputTypes type;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type == InputTypes.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      textAlign: TextAlign.center,
      obscureText: type == InputTypes.password ? true : false,
      style: TextStyle(color: Colors.black),
      onChanged: onChange,
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
      ),
    );
  }
}
