import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Center(
        child: RiveAnimation.asset('assets/rocket_load_animation.riv'),
      ),
    );
  }
}
