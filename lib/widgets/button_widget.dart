import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget{
  final String buttonText;
  final Color buttonColor;
  final Function onPressed;
  RoundedButton({this.buttonText,this.buttonColor,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 2.0,
        color: buttonColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18.0,color: Colors.white),
          ),
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
        ),
      ),
    );
  }
}