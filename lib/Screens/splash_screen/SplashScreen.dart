import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_tray/Screens/auth_screens/PlaceScreen.dart';
import 'package:food_tray/Screens/modal/UserModal.dart';
import 'package:food_tray/Screens/notice/NoticeSceen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
startTime();
 }
 startTime() async {

   final SharedPreferences prefs = await _prefs;
     // SharedPreferences.setMockInitialValues({});

   String _email = prefs.getString("_foodemail");
   String _place = prefs.getString("_foodplace");
   if (_place != null) {
     var duration = new Duration(seconds: 2);
     return new Timer(duration, (){
       Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) => NoticeScreen(UserModal(mp: {"Email":_email,"place":_place})),)
       );}
       );

   }

   else {
     var duration = new Duration(seconds: 2);
     return new Timer(duration, route);
   }
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
