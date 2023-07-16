import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../components/reusable_widgets.dart';
import 'info_page.dart';

List <String> members = ['Pooja Gera', 'Nishtha Goyal', 'Abhigya Verma', 'Gaurisha R Srivastava', 'Mridu Pant', 'Adwita', 'Yashika', 'Akshita'];
List <String> imgPaths = ['assets/images/Pooja.jpg', 'assets/images/Nishtha.jpg', 'assets/images/Abhigya.jpg', 'assets/images/gaurisha.jpg', 'assets/images/mridu.jpeg', 'assets/images/adwita.jpg', 'assets/images/yashika.jpg', 'assets/images/akshita.jpg'];  //TODO- Get the images of all members
// List <String> desc
String cb_desc = 'Celestial Biscuit provides an environment for young women to grow as developers and leaders. We are a group of passionate developers that aim to contribute to the advancement of technology and provide real solutions to real problems.';
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  var counter = 0;

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const InfoPage()));
        return true;
      },
      child: Scaffold(
        drawer: const NavDrawer(),
        backgroundColor: Colors.black,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: const Text(
              'About',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Adam',
                fontWeight: FontWeight.bold,
                fontSize: 45,
            ),
          ),
          // actions: [
          //   IconButton(
          //       onPressed: (){
          //         Navigator.push(context, MaterialPageRoute(builder: (context)=>const InfoPage()));
          //       },
          //       icon: const Icon(
          //         Icons.home,
          //         color: Colors.white,
          //         size: 30,
          //       )
          //   )
          // ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: height!*0.5,
              child: AnimatedContainer(
              decoration: gradientBackground(getAlignments[counter % getAlignments.length]), //refer reusable_widgets.dart for code
              duration: const Duration(seconds: 4),
              curve: Curves.easeInOutSine,
            ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedWave(height: height*0.56, speed: 0.5, offset: pi/2, p:0.02) //refer reusable_widgets.dart for code
            ),
            Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/cb_logo.png', height: 150, width: 150,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(
                        cb_desc,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width*0.035,
                        ),
                      ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0,20,0,10),
                child: Center(
                  child: Text('Developers', style: TextStyle(color: Colors.white, fontFamily: 'Adam', fontWeight: FontWeight.bold, fontSize: height*0.04), ),
                ),
              ),
              Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.black,
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: 80,
                                backgroundColor: const Color(0xFF801267),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: AssetImage(imgPaths[index]),
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              members[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                ),
              )],
          ),
      ]
        ),
      ),
    );
  }
}

