import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'chat_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static final id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      // upperBound: 100.0,
    );

    // animation= CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();

    //in case if we want to reverse the animation
    // controller.reverse(from: 1.0);

    //to know the the status of the animation as if it is completed or not
    // animation.addStatusListener((status) {
    //   print(status);
    //   //in forward it will call complete and in reverse it will call dismissed.
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }
    //   else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {});
      // print(controller.value);
      // print(animation.value);
    });

    getSharedPrefs().then((value) {
      print("Value is=>$value");
    });
  }

  Future getSharedPrefs() async {
    var currentEmail = FirebaseAuth.instance.currentUser.email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString("UID");
    if (email == currentEmail) {
      Navigator.pushNamed(context, ChatScreen.id);
    }
    return email;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: animation.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Hero(
                      tag: "logo",
                      child: Container(
                        child: Image.asset('images/logo.png'),
                        height: 100.0,
                      ),
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ["$kAppName"],
                    textStyle: kAppNameStyle,
                  ),
                ],
              ),
              Text(
                "$kAppName let you communicate with your friends and family all over the world!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0,color: Colors.black54,fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  buttonText: "Login",
                  buttonColor: Colors.lightBlueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  }),
              RoundedButton(
                  buttonText: "Register",
                  buttonColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("Dispose Called");
    controller.dispose();
  }
}
