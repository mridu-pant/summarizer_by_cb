//This dart file contains code for the sign up page

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summary_app/components/reusable_widgets.dart';
import 'package:summary_app/screens/login_page.dart';
import 'package:summary_app/screens/welcome_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //Text field controllers
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.maybeOf(context)?.size.height;
    double? width = MediaQuery.maybeOf(context)?.size.width;
    return Scaffold(
      backgroundColor: Colors.black54,
      resizeToAvoidBottomInset: false, //Can't see password. Removal removes bg effect.
      body: Stack(
        children: [
          Positioned.fill(
              child: Container(
                  decoration: gradientBackground(Alignment.topLeft) //refer reusable_widgets.dart
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
                        builder: (context)=>const WelcomePage() //Back button- goes back to welcome page
                    )
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedWave(height: height!*0.74, speed: 0.5, offset: pi/2, p:0.05), //refer reusable_widgets
          ),
          Positioned.fill(
            top: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(width!*0.05, height*0.04, 0, height*0.08),
                  child: const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontFamily: 'Adam',
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: const Text(
                    "Sign Up",
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
                  padding: EdgeInsets.fromLTRB(width*0.05, height*0.06, width*0.05, height*0.06),
                  child: Form(
                      child: Column(
                          children: [
                            reusableTextField('Username', Icons.person_outline, false, _usernameTextController),
                            SizedBox(
                              height: height*0.05,
                            ),
                            reusableTextField('Email', Icons.email_outlined, false, _emailTextController),
                            SizedBox(
                              height: height*0.05,
                            ),
                            reusableTextField('Password', Icons.lock_outline_rounded, true, _passwordTextController),
                          ]
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(width*0.06, 0, width*0.06, 0),
                  child: reuseButton(context, false, 'Sign Up', (){ //refer reusable_widgets.dart
                    FirebaseAuth.instance.createUserWithEmailAndPassword( //Firebase create user
                        email: _emailTextController.text,
                        password: _passwordTextController.text).then(
                            (value){
                              Navigator.pushNamed(context, 'home_page');
                              // Navigator.push(context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const HomeScreen() //Navigate to home screen
                              //     )
                              // );
                            }).onError((error, stackTrace){
                              //print("Error${error.toString()}");
                            }
                            );
                  }
                  )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(width*0.06, height*0.03, width*0.06, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 15
                            )
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const LoginPage())  //Navigate to login page if account exists
                              );
                            },
                            child: const Text(
                                " Login",
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
          ),
        ],
      ),
    );
  }
}

