import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summary_app/screens/about.dart';
import 'package:summary_app/screens/camera_page.dart';
import 'package:summary_app/screens/crop_screen.dart';
import 'package:summary_app/screens/home_page.dart';
import 'package:summary_app/screens/info_page.dart';
import 'package:summary_app/screens/loading_page.dart';
import 'package:summary_app/screens/login_page.dart';
import 'package:summary_app/screens/sign_up.dart';
import 'package:summary_app/screens/welcome_page.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  //Initialize firebase for authentication
  await Firebase.initializeApp();

  //Define routes to navigate between screens
  runApp(
      MaterialApp(
        initialRoute: 'welcome_screen',
        routes: {
          'welcome_screen': (context) => const WelcomePage(), //welcome_page.dart
          'signup_screen': (context) => const SignUpPage(), //sign_up.dart
          'login_screen': (context) => const LoginPage(), //login_page.dart
          'list_page': (context) => const HomeScreen(),
          'about_page': (context) => const AboutPage(),
          'home_page': (context) => const InfoPage(),
          'camera_page': (context) => TakePictureScreen(camera: firstCamera), //camera_page.dart
          // 'wait_page' : (context) => LoadingPage(),
          //'crop_screen': (context) => CropScreen(item: List)
        },
      )
  );
}



