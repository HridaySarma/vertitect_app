import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vertitect_app/routes_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _goToHome() {
    Navigator.pushReplacementNamed(context, Routes.homeRoute);
  }

  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goToHome);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09b387),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  'AB',
                  style: TextStyle(fontSize: 55.0, color: Colors.white),
                ),
                Image(
                  image: AssetImage('assets/images/app-icon.png'),
                  height: 80.0,
                  width: 80.0,
                ),
                Text(
                  'BABY',
                  style: TextStyle(fontSize: 55.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'ATTENDANCE REPORT',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
