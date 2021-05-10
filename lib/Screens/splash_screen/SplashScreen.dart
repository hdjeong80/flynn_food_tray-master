import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_tray/Screens/auth_screens/PlaceScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    // TODO: implement initState
startTime();
 }
 startTime() async {
   var duration = new Duration(seconds: 2);
   return new Timer(duration, route);
 }

 route() {
   Navigator.pushReplacement(context, MaterialPageRoute(
       builder: (context) => PlaceScreen()
   )
   );
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceScreen(),
            ),
          );
        },
        child: Center(
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
