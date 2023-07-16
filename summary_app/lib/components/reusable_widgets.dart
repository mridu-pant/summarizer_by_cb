import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:summary_app/screens/about.dart';
import 'package:summary_app/screens/home_page.dart';
import 'package:summary_app/screens/info_page.dart';

import '../screens/welcome_page.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller){
  return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(
              color: Colors.white30
          ),
          filled: true,
          fillColor: const Color(0xFF1A131E),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white54,
            )
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none)
          )
      ),
      keyboardType: isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress
  );
}

BoxDecoration gradientBackground(AlignmentGeometry alignmentGeometry){
  return BoxDecoration(
      gradient: LinearGradient(
        begin: alignmentGeometry,//getAlignments[counter % getAlignments.length],  //see ref https://api.flutter.dev/flutter/painting/Alignment-class.html#:~:text=Alignment(0.0%2C%20%2D0.5),coordinate%20system%20of%20the%20rectangle.
        stops: const [0.3, 1],
        colors: const [Color(0xFF190625), Color(0xFF5B0941)],
      )
  );
}

Container reuseButton(BuildContext context, bool backgroundGradientPresent, String text, Function onTap){
  if(backgroundGradientPresent){
    return Container(
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF190625), Color(0xFF801267)],
                ),
                borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
      ),
    );
  }
  else{
    return Container(
      child: OutlinedButton(
        onPressed: () {
          onTap();
        },
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFF801267),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: const Size(200, 50)
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}


class AnimatedWave extends StatelessWidget {
final double height;
final double speed;
final double offset;
final double p;
const AnimatedWave({super.key, required this.height, required this.speed, this.offset = 0.0, required this.p});

@override
Widget build(BuildContext context) {
  return LayoutBuilder(builder: (context, constraints) {
    return SizedBox(
      height: height,
      width: constraints.biggest.width,
      child: CustomAnimationBuilder(
          control: Control.loop,
          duration: Duration(milliseconds: (5000 / speed).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, value, child) {
            return CustomPaint(
              foregroundPainter: CurvePainter(value + offset, p),
            );
          }),
    );
  });
}
}

class CurvePainter extends CustomPainter {
  final double value;
  final double p;
  CurvePainter(this.value, this.p);

  @override
  void paint(Canvas canvas, Size size) {
    final black = Paint()..color = Colors.black;
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (p * y1);
    final controlPointY = size.height * (p * y2);
    final endPointY = size.height * (p * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, black);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        padding: const EdgeInsets.only(top: 30),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white,),
            title: const Text('Home', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: ((context) => const InfoPage())));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white,),
            title: const Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutPage()));
    },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Colors.white,),
            title: const Text('Summary List', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: ((context) => const HomeScreen())));
            },
          ),
        ],
      ),
    );
  }
}

void signOut() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //signout function
  await auth.signOut();
}


