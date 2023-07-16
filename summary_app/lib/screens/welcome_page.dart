//This dart file contains code for welcome page

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../components/reusable_widgets.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var counter = 0;

  //Changing direction for wave
  List<Alignment> get getAlignments => [
    Alignment.topLeft,
    Alignment.topRight,
  ];


  //Animate the gradient every 5 seconds: gradient moves left to right to left in 5 sec
  _startBgColorAnimationTimer() {
    //Animating for the first time.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      counter++;
      setState(() {});
    });

    const interval = Duration(seconds: 5);
    Timer.periodic(
      interval,
          (Timer timer) {
        counter++;
        setState(() {});
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _startBgColorAnimationTimer();
  }

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.maybeOf(context)?.size.height;
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Stack(
            children: [
              Positioned.fill(child: AnimatedContainer(
                decoration: gradientBackground(getAlignments[counter % getAlignments.length]), //refer reusable_widgets.dart for code
                duration: const Duration(seconds: 4),
                curve: Curves.easeInOutSine,
              ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedWave(height: height!*0.32, speed: 0.5, offset: pi/2, p:0.1) //refer reusable_widgets.dart for code
              ),
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top:height*0.1),
                      child: const OpeningPageText()  //refer line 101 for code
                  ),
                  SizedBox(
                    height: height*0.12,
                  ),
                  const OpeningPageButtons()
                ],
              )

            ]
        )
    );
  }
}

class OpeningPageButtons extends StatelessWidget {
  const OpeningPageButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        reuseButton(context, true, 'Login', (){ //refer reuse_widgets.dart for code
          Navigator.pushNamed(context, 'login_screen'); //navigate to login page
        }),
        const SizedBox(
          height: 30,
        ),
        reuseButton(context, false, 'Sign Up', (){ //refer reuse_widgets.dart for code
          Navigator.pushNamed(context, 'signup_screen'); //navigate to sign up page
        })
      ],
    );
  }
}


class OpeningPageText extends StatelessWidget {
  const OpeningPageText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? height = MediaQuery.maybeOf(context)?.size.height;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Text(
            "summarizer",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontFamily: 'Adam',
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(
          height: height!*0.05,
        ),
        const Text(
          "by",
          style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Adam',
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          height: height*0.05,
        ),
        Center(child: Image.asset('assets/images/cb_logo.png', height: height*0.3, width: height*0.3,),),
      ],
    );
  }
}


