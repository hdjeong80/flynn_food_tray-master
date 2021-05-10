import 'package:flutter/material.dart';
import 'package:food_tray/Contants/colors.dart';
import 'package:food_tray/Screens/auth_screens/SignUpScreen.dart';
import 'package:food_tray/Widgets/BottomBar.dart';
import 'package:food_tray/Widgets/TextWidget.dart';

import 'LoginInScreen.dart';
import 'package:food_tray/Contants/Enums.dart';

class PlaceScreen extends StatefulWidget {
  @override
  _PlaceScreenState createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: GestureDetector(
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginInScreen(),
              ),
            );
          } ,
          child: BottomBar(

            containerHeight: height * 0.10,
            textHeight: height * 0.03,
            text: '이미 계정이 있습니다',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: '식판스토리앱 \n회원가입',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: blackColor,
              ),
              left: width * 0.08,
              top: height * 0.12,
            ),
            Center(
              child: TextWidget(
                text: '가입하실 지역을 선택하세요.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: lightBlackColor,
                ),
                top: height * 0.12,
              ),
            ),
            SizedBox(height: height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                   onTap: (){
                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => SignUpScreen(Place.one),
                       ),
                     );
                   },
                  child: TextWidget(
                    text: '흥덕/서원/세종',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(Place.two),
                      ),
                    );
                  },
                  child: TextWidget(
                    text: '상당/청원/충북',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
