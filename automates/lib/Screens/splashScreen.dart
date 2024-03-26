import 'dart:async';
import 'package:automates/Screens/home.dart';
import 'package:automates/Screens/login.dart';
import 'package:automates/Screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assuming you're using Firebase Auth for user authentication
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds
    Timer(Duration(seconds: 3), () {
      // Check user credentials
      if (FirebaseAuth.instance.currentUser == null) {
        // User is not logged in, navigate to login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // User is logged in, navigate to home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/auto.gif"),
              width: 600,
            ),
            SizedBox(height: 30),
            SpinKitSquareCircle(
              color: Colors.grey,
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
