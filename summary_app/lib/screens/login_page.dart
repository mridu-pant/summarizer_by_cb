//This dart file contains code for login page

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summary_app/screens/sign_up.dart';
import 'package:summary_app/screens/welcome_page.dart';

import '../components/reusable_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text field controllers.
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  //final TextEditingController _usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.maybeOf(context)?.size.height;
    double? width = MediaQuery.maybeOf(context)?.size.width;
    return Scaffold(
      backgroundColor: Colors.black54,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,  //see ref https://api.flutter.dev/flutter/painting/Alignment-class.html#:~:text=Alignment(0.0%2C%20%2D0.5),coordinate%20system%20of%20the%20rectangle.
                      stops: [0.3, 1],
                      colors: [Color(0xFF190625), Color(0xFF5B0941)],
                      //Didn't use reusable widget here because there was no parameter for stops.
                    )
                ),
              )
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 0, 20),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context)=>const WelcomePage() //Back to welcome page
                    )
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: height!*0.65,speed: 0.5, offset: pi/2,p: 0.05,),
          ),
          Positioned.fill(
            top: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(width!*0.05, height*0.08, 0, height*0.05),
                  child: const Text(
                    "Welcome \nback",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 55,
                        fontFamily: 'Adam',
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, height*0.07, 0, 0),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                        fontFamily: 'Adam',
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(width*0.05, height*0.05, width*0.05, height*0.07),
                  child: Form(
                      child: Column(
                          children: [
                            reusableTextField('Email', Icons.person_outline, false, _emailTextController),
                            SizedBox(
                              height: height*0.05,
                            ),
                            reusableTextField('Password', Icons.lock_outline_rounded, true, _passwordTextController),
                          ]
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(width*0.1, 0, width*0.1, 0),
                  child: reuseButton(context, false, 'Login', (){
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text).then(
                      (value){
                        Navigator.pushNamed(context, 'home_page');
                      }).onError((error, stackTrace){
                        // print("Error${error.toString()}");
                      }
                      );
                    // Navigator.push(context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const HomeScreen()
                    //           )
                    //         );
                  }
                  )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(height*0.08, 15, height*0.08, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 15
                            )
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const SignUpPage())
                              );
                            },
                            child: const Text(
                                " Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                )
                            )
                        ),
                      ],
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

