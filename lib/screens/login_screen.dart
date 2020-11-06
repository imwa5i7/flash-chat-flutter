import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner= false;
  SharedPreferences prefs;

  storeValueInPrefs() async{
    final loggedInUserEmail= _auth;
    var currentUser=_auth.currentUser;
    var currentEmail=currentUser.email;
    prefs= await SharedPreferences.getInstance();
    if(currentEmail != null){
      prefs.setString("UID", currentEmail);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),

              Text(kAppName, style: kAppNameStyle, textAlign: TextAlign.center,),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email= value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password=value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter your password"),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonText: "Login",
                buttonColor: Colors.lightBlueAccent,
                onPressed: ()  async{

                  setState(() {
                    showSpinner =true;
                  });
                  try{
                    final user =await _auth.signInWithEmailAndPassword(email: email, password: password);

                    if(user != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showSpinner=false;
                      });
                    }
                    storeValueInPrefs();

                  }
                  catch(err) {
                    print("Error is => $err");
                    setState(() {
                      showSpinner =false;
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
